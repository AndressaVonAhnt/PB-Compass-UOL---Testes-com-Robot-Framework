*** Settings ***
Resource  ../resources/booking.resource
Resource  ../resources/auth.resource


*** Test Cases ***
Cenário 01: Retornar detalhes de uma reserva com base no ID
    ${response_post}=    Criar reserva    John    Doe    150    ${True}    2026-01-01    2026-01-05    Brunch
    ${booking_id}=       Get From Dictionary    ${response_post.json()}    bookingid
    
    ${response_get}=    Buscar por um ID de uma reserva    id=${booking_id}
    
    Verificar se o retorno está correto    ${response_get}

Cenário 02: Retornar todos os IDs da API sem filtro
    ${response}=    Buscar por IDs    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    Should Be Equal As Strings    ${response.status_code}    200

Cenário 03: Retornar IDs por nome de usuário
    ${response}=    Buscar por IDs    sally    brown    ${EMPTY}    ${EMPTY}
    Should Be Equal As Strings    ${response.status_code}    200

Cenário 04: Retornar IDs por datas de check-in e check-out
    ${response}=    Buscar por IDs    ${EMPTY}    ${EMPTY}    2025-01-01    2025-01-05
    Should Be Equal As Strings    ${response.status_code}    200

Cenário 05: Criando reserva
    ${response}=  Criar reserva    Andressa    Von Ahnt    200    ${True}    2025-01-01    2025-01-10    Lunch
    Verificar se a reserva foi criada com sucesso   ${response}

Cenário 06: Atualizar o nome de uma reserva
    ${response_token}=    Criar Sessao e Pegar Token    admin    password123
    ${token}=             Get From Dictionary    ${response_token.json()}    token
    
    ${response_post}=    Criar reserva    Sally    Brown    200    ${True}    2025-01-01    2025-01-10    Lunch
    ${booking_id}=       Get From Dictionary    ${response_post.json()}    bookingid
    
    ${response_get}=    Buscar por um ID de uma reserva    id=${booking_id}
    ${booking_details}=    Set Variable    ${response_get.json()}
    
    ${response_put}=    Atualizar nome    ${booking_id}    ${token}    Julia    ${booking_details}
    
    Validar resposta ATUALIZACAO    ${response_put}

Cenário 07: Atualizar o nome de uma reserva com PATCH
    ${response_token}=    Criar Sessao e Pegar Token    admin    password123
    ${token}=             Get From Dictionary    ${response_token.json()}    token
    
    ${response_post}=    Criar reserva    Sally    Brown    200    ${True}    2025-01-01    2025-01-10    Lunch
    ${booking_id}=       Get From Dictionary    ${response_post.json()}    bookingid

    ${response_patch}=   Atualizar Nome com PATCH    ${booking_id}    ${token}    Julia
    
    Validar resposta ATUALIZACAO    ${response_patch}

Cenário 08: Deletar uma reserva
    ${response_token}=    Criar Sessao e Pegar Token    admin    password123
    ${token}=             Get From Dictionary    ${response_token.json()}    token

    ${response_post}=    Criar reserva    Sally    Brown    200    ${True}    2025-01-01    2025-01-10    Lunch
    ${booking_id}=       Get From Dictionary    ${response_post.json()}    bookingid

    ${response}=     Deletar Reserva    ${booking_id}    ${token}
    
    Should Be Equal As Strings    ${response.status_code}    201
