*** Settings ***
Library    Collections
Resource  ../resources/common.robot

*** Keywords ***
Verificar o funcionamento da API
    [Documentation]    Verifica se a API está funcionando corretamente
    Criar Sessão na Restful Booker 

    ${response}  GET On Session    RestfulBooker    /ping    
    Should Be Equal As Strings    ${response.status_code}    201