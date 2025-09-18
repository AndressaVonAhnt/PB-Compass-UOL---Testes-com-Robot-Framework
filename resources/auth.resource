*** Settings ***
Library    Collections
Resource  ../resources/common.robot

*** Keywords ***
Criar Sessao e Pegar Token
    [Documentation]    Cria uma sessao com a API e pega o token de autenticacao.
    [Arguments]      ${username}    ${password}

    Criar Sessão na Restful Booker 

    ${body}  Create Dictionary  username=${username}   password=${password}
    ${headers}  Create Dictionary  Content-Type=application/json
    
    ${response}  POST On Session  
    ...          alias=RestfulBooker
    ...          url=/auth
    ...          headers=${headers}
    ...          json=${body}

    RETURN     ${response}

Verificar se o token é válido
    [Documentation]   Verifica se o token retornado é valido
    [Arguments]      ${response}

    Should Be Equal As Strings       ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    token

