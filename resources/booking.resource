*** Settings ***
Resource  ../resources/common.robot
Library    Collections
Library    String

*** Keywords ***
Buscar por um ID de uma reserva
    [Documentation]    Cria uma sessão e verifica se encontrou o ID da reserva
    [Arguments]        ${id}
    Criar Sessão na Restful Booker 

    ${response}  GET On Session    RestfulBooker    /booking/${id} 
    RETURN     ${response}

Verificar se o retorno está correto
    [Documentation]    Verifica se o retorno é valido
    [Arguments]        ${response}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    firstname
    Dictionary Should Contain Key    ${response.json()}    lastname
    Dictionary Should Contain Key    ${response.json()}    totalprice
    Dictionary Should Contain Key    ${response.json()}    depositpaid
    Dictionary Should Contain Key    ${response.json()}    bookingdates
    Dictionary Should Contain Key    ${response.json()}[bookingdates]    checkin
    Dictionary Should Contain Key    ${response.json()}[bookingdates]    checkout

Buscar por IDs 
    [Documentation]    Verifica se o retorno é valido
    [Arguments]        ${firstname}    ${lastname}    ${checkin}    ${checkout}
    
    Criar Sessão na Restful Booker 
    
    &{params}=    Create Dictionary
    Run Keyword If    '${firstname}' != '${EMPTY}'    Set To Dictionary    ${params}    firstname=${firstname}
    Run Keyword If    '${lastname}' != '${EMPTY}'    Set To Dictionary    ${params}    lastname=${lastname}
    Run Keyword If    '${checkin}' != '${EMPTY}'    Set To Dictionary    ${params}    checkin=${checkin}
    Run Keyword If    '${checkout}' != '${EMPTY}'    Set To Dictionary    ${params}    checkout=${checkout}

    ${response}=    GET On Session    alias=RestfulBooker    url=/booking    params=${params}
    
    RETURN          ${response}

Criar reserva
    [Documentation]    Cria uma nova reserva na API.
    [Arguments]      ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}

    Criar Sessão na Restful Booker 

    ${bookingdates}=    Create Dictionary     
    ...                checkin=${checkin}    
    ...                checkout=${checkout}
    
    ${body}=  Create Dictionary  
    ...      firstname=${firstname}   
    ...      lastname=${lastname}    
    ...      totalprice=${totalprice}    
    ...      depositpaid=${depositpaid}    
    ...      bookingdates=${bookingdates}
    ...      additionalneeds=${additionalneeds}
    
    ${headers}=  Create Dictionary  
    ...         Content-Type=application/json
    ...         Accept=application/json
    
    ${response}  POST On Session  
    ...          alias=RestfulBooker
    ...          url=/booking
    ...          headers=${headers}
    ...          json=${body}

    RETURN     ${response}

Verificar se a reserva foi criada com sucesso
    [Documentation]    Verifica se a reserva foi criada com sucesso.
    [Arguments]        ${response}
    
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    bookingid
    Dictionary Should Contain Key    ${response.json()}    booking

    ${booking_details}=    Get From Dictionary    ${response.json()}    booking
    
    Dictionary Should Contain Key    ${booking_details}    firstname
    Dictionary Should Contain Key    ${booking_details}    lastname
    Dictionary Should Contain Key    ${booking_details}    totalprice
    Dictionary Should Contain Key    ${booking_details}    depositpaid
    Dictionary Should Contain Key    ${booking_details}    bookingdates
    Dictionary Should Contain Key    ${booking_details}    additionalneeds


Atualizar nome 
    [Documentation]    Atualiza uma reserva existente.
    [Arguments]    ${booking_id}    ${token}    ${new_name}    ${booking_details}

    &{headers}=    Create Dictionary
    ...            Content-Type=application/json
    ...            Accept=application/json
    ...            Cookie=token=${token}

    &{body}=    Create Dictionary   
    ...         firstname=${new_name}
    ...         lastname=${booking_details}[lastname]
    ...         totalprice=${booking_details}[totalprice]
    ...         depositpaid=${booking_details}[depositpaid]
    ...         bookingdates=${booking_details}[bookingdates]
    ...         additionalneeds=${booking_details}[additionalneeds]

    ${response}=    PUT On Session
    ...             alias=RestfulBooker
    ...             url=/booking/${booking_id}
    ...             headers=${headers}
    ...             json=${body}
    
    RETURN     ${response}

Validar resposta ATUALIZACAO
    [Documentation]    Verifica se o retorno da atualização de uma reserva está válido.
    [Arguments]    ${response_put} 
    Should Be Equal As Strings    ${response_put.status_code}    200
    Dictionary Should Contain Key    ${response_put.json()}    firstname
    Should Be Equal As Strings    ${response_put.json()}[firstname]    Julia

Atualizar Nome com PATCH
    [Documentation]    Atualiza o nome de uma reserva usando PATCH.
    [Arguments]      ${booking_id}    ${token}    ${new_name}

    &{headers}=    Create Dictionary
    ...            Content-Type=application/json
    ...            Accept=application/json
    ...            Cookie=token=${token}

    &{body}=       Create Dictionary
    ...            firstname=${new_name}

    ${response}=   PATCH On Session
    ...            alias=RestfulBooker
    ...            url=/booking/${booking_id}
    ...            headers=${headers}
    ...            json=${body}

    RETURN         ${response}

Deletar Reserva
    [Documentation]    Deleta uma reserva existente.
    [Arguments]      ${booking_id}    ${token}

    &{headers}=    Create Dictionary
    ...            Content-Type=application/json
    ...            Cookie=token=${token}
    
    ${response}=   DELETE On Session
    ...            alias=RestfulBooker
    ...            url=/booking/${booking_id}
    ...            headers=${headers}

    RETURN         ${response}
