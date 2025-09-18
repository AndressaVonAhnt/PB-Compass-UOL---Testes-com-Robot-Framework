# Testes de API com Robot Framework

Este repositório contém uma suíte de testes de API automatizados, desenvolvida com **Robot Framework**, para validar as funcionalidades da API de gerenciamento de reservas [**Restful Booker**](https://restful-booker.herokuapp.com/apidoc/index.html).

A atividade foi focada em praticar todos os principais verbos HTTP (**GET**, **POST**, **PUT**, **DELETE**) e entender o fluxo de autenticação via token.


## Como Executar os Testes

### Pré-requisitos

Certifique-se de que você tem o Python instalado. Depois, instale as bibliotecas necessárias via `pip` (geralmente em um ambiente virtual).

```bash
pip install robotframework
pip install robotframework-requests
pip install robotframework-collections
```

### Execução

Para rodar todos os testes, navegue até a pasta raiz do projeto no terminal e execute o seguinte comando:

```bash
robot tests/
```

Para executar um arquivo de teste específico, como o de autenticação:

```bash
robot tests/auth_tests.robot
```

Após a execução, o Robot Framework irá gerar arquivos de log e relatórios detalhados na sua pasta, como `log.html` e `report.html`.

-----

## Funcionalidades Testadas

Os testes cobrem os seguintes cenários da API, exercitando todos os verbos HTTP e fluxos de autenticação:

### Autenticação

  * **`POST /auth`**: Criação de um token de autenticação com credenciais válidas e teste de falha com credenciais inválidas.

### Gerenciamento de Reservas

  * **`GET /booking`**: Obtenção de todos os IDs de reservas. Testes com e sem parâmetros de busca (nome, datas).
  * **`POST /booking`**: Criação de uma nova reserva com dados válidos, validando a estrutura de retorno da API.
  * **`GET /booking/{id}`**: Busca por uma reserva específica. O teste garante que o ID buscado existe, validando a estrutura e os dados da resposta.
  * **`PUT /booking/{id}`**: Atualização de uma reserva existente, exigindo o uso do token de autenticação.
  * **`DELETE /booking/{id}`**: Exclusão de uma reserva, também exigindo o token de autorização.
