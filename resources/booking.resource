*** Settings ***
Resource    common.robot

*** Variables ***
${BOOKING_ENDPOINT}    /booking

*** Keywords ***
Get Booking By ID
    [Documentation]    Retrieves booking details by ID
    [Arguments]    ${booking_id}
    
    Create API Session
    ${response}=    GET On Session    ${SESSION_ALIAS}    ${BOOKING_ENDPOINT}/${booking_id}
    RETURN    ${response}

Get All Bookings
    [Documentation]    Retrieves all booking IDs with optional filters
    [Arguments]    ${firstname}=${EMPTY}    ${lastname}=${EMPTY}    ${checkin}=${EMPTY}    ${checkout}=${EMPTY}
    
    Create API Session
    ${params}=    Build Filter Parameters    ${firstname}    ${lastname}    ${checkin}    ${checkout}
    ${response}=  GET On Session    ${SESSION_ALIAS}    ${BOOKING_ENDPOINT}    params=${params}
    RETURN    ${response}

Create New Booking
    [Documentation]    Creates a new booking
    [Arguments]    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
    
    Create API Session
    ${headers}=    Create Standard Headers
    ${body}=       Build Booking Body    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
    ${response}=   POST On Session    ${SESSION_ALIAS}    ${BOOKING_ENDPOINT}    headers=${headers}    json=${body}
    RETURN    ${response}

Update Booking
    [Documentation]    Updates existing booking
    [Arguments]    ${booking_id}    ${token}    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
    
    Create API Session
    ${headers}=    Create Auth Headers    ${token}
    ${body}=       Build Booking Body    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
    ${response}=   PUT On Session    ${SESSION_ALIAS}    ${BOOKING_ENDPOINT}/${booking_id}    headers=${headers}    json=${body}
    RETURN    ${response}

Patch Booking Field
    [Documentation]    Updates specific booking fields using PATCH
    [Arguments]    ${booking_id}    ${token}    &{field_updates}
    
    Create API Session
    ${headers}=    Create Auth Headers    ${token}
    ${response}=   PATCH On Session    ${SESSION_ALIAS}    ${BOOKING_ENDPOINT}/${booking_id}    headers=${headers}    json=${field_updates}
    RETURN    ${response}

Delete Booking
    [Documentation]    Deletes booking by ID
    [Arguments]    ${booking_id}    ${token}
    
    Create API Session
    ${headers}=    Create Auth Headers    ${token}
    ${response}=   DELETE On Session    ${SESSION_ALIAS}    ${BOOKING_ENDPOINT}/${booking_id}    headers=${headers}
    RETURN    ${response}

Build Booking Body
    [Documentation]    Builds booking request body
    [Arguments]    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
    
    ${booking_dates}=    Create Dictionary    checkin=${checkin}    checkout=${checkout}
    ${body}=    Create Dictionary
    ...         firstname=${firstname}
    ...         lastname=${lastname}
    ...         totalprice=${totalprice}
    ...         depositpaid=${depositpaid}
    ...         bookingdates=${booking_dates}
    ...         additionalneeds=${additionalneeds}
    RETURN    ${body}

Build Filter Parameters
    [Documentation]    Builds filter parameters removing empty values
    [Arguments]    ${firstname}    ${lastname}    ${checkin}    ${checkout}
    
    ${params}=    Create Dictionary
    Run Keyword If    '${firstname}' != '${EMPTY}'    Set To Dictionary    ${params}    firstname=${firstname}
    Run Keyword If    '${lastname}' != '${EMPTY}'     Set To Dictionary    ${params}    lastname=${lastname}
    Run Keyword If    '${checkin}' != '${EMPTY}'      Set To Dictionary    ${params}    checkin=${checkin}
    Run Keyword If    '${checkout}' != '${EMPTY}'     Set To Dictionary    ${params}    checkout=${checkout}
    RETURN    ${params}

Validate Booking Response
    [Documentation]    Validates booking response structure
    [Arguments]    ${response}
    
    Validate Status Code    ${response}    ${STATUS_OK}
    ${required_fields}=    Create List    firstname    lastname    totalprice    depositpaid    bookingdates
    Validate Required Fields    ${response.json()}    @{required_fields}
    ${date_fields}=    Create List    checkin    checkout
    Validate Required Fields    ${response.json()}[bookingdates]    @{date_fields}

Validate Booking Creation
    [Documentation]    Validates successful booking creation
    [Arguments]    ${response}
    
    Validate Status Code    ${response}    ${STATUS_OK}
    ${creation_fields}=    Create List    bookingid    booking
    Validate Required Fields    ${response.json()}    @{creation_fields}
    
    ${booking_details}=    Get From Dictionary    ${response.json()}    booking
    ${booking_fields}=     Create List    firstname    lastname    totalprice    depositpaid    bookingdates    additionalneeds
    Validate Required Fields    ${booking_details}    @{booking_fields}

Validate Booking Update
    [Documentation]    Validates booking update response
    [Arguments]    ${response}    &{expected_values}
    
    Validate Status Code    ${response}    ${STATUS_OK}
    FOR    ${field}    ${expected_value}    IN    &{expected_values}
        Dictionary Should Contain Key    ${response.json()}    ${field}
        Should Be Equal As Strings    ${response.json()}[${field}]    ${expected_value}
    END