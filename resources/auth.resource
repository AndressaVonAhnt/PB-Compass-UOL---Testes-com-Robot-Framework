*** Settings ***
Resource    common.robot

*** Variables ***
${AUTH_ENDPOINT}    /auth

*** Keywords ***
Create Authentication Token
    [Documentation]    Creates authentication token for given credentials
    [Arguments]    ${username}    ${password}
    
    Create API Session
    ${headers}=    Create Standard Headers
    ${body}=       Create Dictionary    username=${username}    password=${password}
    ${response}=   POST On Session    ${SESSION_ALIAS}    ${AUTH_ENDPOINT}    headers=${headers}    json=${body}
    RETURN    ${response}

Validate Token Response
    [Documentation]    Validates successful token creation response
    [Arguments]    ${response}
    
    Validate Status Code    ${response}    ${STATUS_OK}
    Dictionary Should Contain Key    ${response.json()}    token
    ${token}=    Get From Dictionary    ${response.json()}    token
    Should Not Be Empty    ${token}