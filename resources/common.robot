*** Settings ***
Library         RequestsLibrary

*** Variables ***
${API_BASE_URL}     https://restful-booker.herokuapp.com

*** Keywords ***
Criar Sessão na Restful Booker
    [Documentation]    Cria uma sessão no Restful Booker e inicializa a URL base.
    Create Session    alias=RestfulBooker    url=${API_BASE_URL}