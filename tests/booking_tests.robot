*** Settings ***
Resource    ../resources/booking.resource
Resource    ../resources/auth.resource
Suite Setup    Initialize Test Suite

*** Variables ***
${SUITE_TOKEN}    ${EMPTY}

*** Test Cases ***
Should Return Booking Details By ID
    [Documentation]    Creates booking and retrieves details by ID
    ${booking_id}=    Create Test Booking
    ${response}=      Get Booking By ID    ${booking_id}
    Validate Booking Response    ${response}

Should Return All Booking IDs Without Filter
    [Documentation]    Retrieves all booking IDs without any filters
    ${response}=    Get All Bookings
    Validate Status Code    ${response}    ${STATUS_OK}

Should Filter Bookings By Guest Name
    [Documentation]    Filters bookings by guest name
    ${response}=    Get All Bookings    firstname=sally    lastname=brown
    Validate Status Code    ${response}    ${STATUS_OK}

Should Filter Bookings By Date Range
    [Documentation]    Filters bookings by check-in and check-out dates
    ${response}=    Get All Bookings    checkin=2025-01-01    checkout=2025-01-05
    Validate Status Code    ${response}    ${STATUS_OK}

Should Create New Booking Successfully
    [Documentation]    Creates new booking and validates response
    ${response}=    Create New Booking    Andressa    Von Ahnt    200    ${True}    2025-01-01    2025-01-10    Lunch
    Validate Booking Creation    ${response}

Should Update Booking With PUT
    [Documentation]    Updates booking using PUT method
    ${booking_id}=    Create Test Booking
    ${response}=      Update Booking    ${booking_id}    ${SUITE_TOKEN}    Julia    Brown    200    ${True}    2025-01-01    2025-01-10    Lunch
    Validate Booking Update    ${response}    firstname=Julia

Should Update Booking With PATCH
    [Documentation]    Updates booking using PATCH method
    ${booking_id}=    Create Test Booking
    ${response}=      Patch Booking Field    ${booking_id}    ${SUITE_TOKEN}    firstname=Julia
    Validate Booking Update    ${response}    firstname=Julia

Should Delete Booking Successfully
    [Documentation]    Deletes booking and validates response
    ${booking_id}=    Create Test Booking
    ${response}=      Delete Booking    ${booking_id}    ${SUITE_TOKEN}
    Validate Status Code    ${response}    ${STATUS_CREATED}

*** Keywords ***
Initialize Test Suite
    [Documentation]    Creates authentication token for test suite
    ${response}=    Create Authentication Token    admin    password123
    ${token}=       Get From Dictionary    ${response.json()}    token
    Set Suite Variable    ${SUITE_TOKEN}    ${token}

Create Test Booking
    [Documentation]    Creates a test booking and returns booking ID
    ${response}=    Create New Booking    Sally    Brown    200    ${True}    2025-01-01    2025-01-10    Lunch
    ${booking_id}=  Get From Dictionary    ${response.json()}    bookingid
    RETURN    ${booking_id}