*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${API_BASE_URL}       https://restful-booker.herokuapp.com
${SESSION_ALIAS}      RestfulBooker
${STATUS_OK}          200
${STATUS_CREATED}     201

*** Keywords ***
Create API Session
    [Documentation]    Creates session with Restful Booker API
    Create Session    alias=${SESSION_ALIAS}    url=${API_BASE_URL}

Create Standard Headers
    [Documentation]    Creates standard JSON headers
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    RETURN    ${headers}

Create Auth Headers
    [Documentation]    Creates headers with authentication token
    [Arguments]    ${token}
    ${headers}=    Create Standard Headers
    Set To Dictionary    ${headers}    Cookie=token=${token}
    RETURN    ${headers}

Validate Status Code
    [Documentation]    Validates HTTP response status code
    [Arguments]    ${response}    ${expected_code}
    Should Be Equal As Strings    ${response.status_code}    ${expected_code}

Validate Required Fields
    [Documentation]    Validates that dictionary contains required fields
    [Arguments]    ${data}    @{required_fields}
    FOR    ${field}    IN    @{required_fields}
        Dictionary Should Contain Key    ${data}    ${field}
    END