*** Settings ***
Resource  ../resources/auth.resource

*** Test Cases ***
Cenário 01: Criar token para autenticação
    ${response}=  Criar Sessao e Pegar Token    admin    password123
    Verificar se o token é válido   ${response}
