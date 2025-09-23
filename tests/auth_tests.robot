*** Settings ***
Resource    ../resources/auth.resource

*** Test Cases ***
Should Create Valid Authentication Token
    [Documentation]    Validates successful token creation with valid credentials
    ${response}=    Create Authentication Token    admin    password123
    Validate Token Response    ${response}

Should Reject Invalid Credentials
    [Documentation]    Validates that API rejects invalid credentials
    ${response}=    Create Authentication Token    invalid    wrong
    Validate Status Code    ${response}    ${STATUS_OK}
    Dictionary Should Contain Key    ${response.json()}    reason