*** Settings ***
Resource    ../resources/ping.resource

*** Test Cases ***
Should Return API Health Status
    [Documentation]    Validates that API health endpoint returns expected status
    ${response}=    Get API Health Status
    Validate Health Response    ${response}