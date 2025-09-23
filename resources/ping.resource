*** Settings ***
Resource    common.robot

*** Variables ***
${PING_ENDPOINT}    /ping

*** Keywords ***
Get API Health Status
    [Documentation]    Checks API health status
    
    Create API Session
    ${response}=    GET On Session    ${SESSION_ALIAS}    ${PING_ENDPOINT}
    RETURN    ${response}

Validate Health Response
    [Documentation]    Validates API health response
    [Arguments]    ${response}
    
    Validate Status Code    ${response}    ${STATUS_CREATED}