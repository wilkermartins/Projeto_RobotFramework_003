*** Settings ***

Library         RequestsLibrary
Library         Collections
Library         FakerLibrary   locale=pt_br
Resource        Credenciais.robot


*** Variable ***

${HOST}                 http://serverest.dev
${ALIAS}                API_ServerRest

*** Test Cases ***

Acessar API - Usuários e produtos
  Abrir sessão na API
  Cadastrar usuário
  Editar usuário
  Listar todos usuários
  Excluir um usuário por ID
  Gerar Token para autenticar
  Cadastrar produto
  Listar o produto cadastrado por ID

*** Keywords ***

Criar dados aleatórios para cadastro de usuários
    ${NOME}         FakerLibrary.Name
    ${EMAIL}        FakerLibrary.Email
    ${PASSWORD}     FakerLibrary.Password
    ${USUARIO}      Create Dictionary    nome=${NOME}  email=${EMAIL}  senha=${PASSWORD}
    Set Suite Variable    ${USUARIO}

Abrir sessão na API
    ${HEADERS}   Create Dictionary  Content-Type=application/json
    Create Session    alias=${ALIAS}    url=${HOST}     headers=${HEADERS}   disable_warnings=1

Cadastrar usuário
    Criar dados aleatórios para cadastro de usuários
    ${BODY}      Create Dictionary   nome=${USUARIO.nome}   email=${USUARIO.email}   password=${USUARIO.senha}   administrador=true
    ${HEADERS}   Create Dictionary  Content-Type=application/json
    ${RESPOSTA}     POST On Session     alias=${ALIAS}    url=usuarios    json=${BODY}      headers=${HEADERS}
    Log   Resposta: ${\n}${RESPOSTA.text}
    Dictionary Should Contain Item    ${RESPOSTA.json()}      message      Cadastro realizado com sucesso
    ${ID_USUARIO_CADASTRADO}  Get From Dictionary    ${RESPOSTA.json()}    _id
    Set Suite Variable   ${ID_USUARIO_CADASTRADO}
    ${PARAMS}    Create Dictionary  _id=${ID_USUARIO_CADASTRADO}
    ${RESPOSTA}  GET On Session     alias=${ALIAS}    url=usuarios   params=${PARAMS}  headers=${HEADERS}
    Dictionary Should Contain Item    ${RESPOSTA.json()["usuarios"][0]}    nome        ${USUARIO.nome}
    Dictionary Should Contain Item    ${RESPOSTA.json()["usuarios"][0]}    email       ${USUARIO.email}
    Dictionary Should Contain Item    ${RESPOSTA.json()["usuarios"][0]}    password     ${USUARIO.senha}

Editar usuário
    Criar dados aleatórios para cadastro de usuários
    ${ALTERAR_USUARIO}      Create Dictionary   nome=João de Souza   email=${USUARIO.email}   password=${USUARIO.senha}   administrador=true
    ${HEADERS}   Create Dictionary  Content-Type=application/json
    ${PARAMS}    Create Dictionary  _id=${ID_USUARIO_CADASTRADO}
    ${RESPOSTA}  GET On Session     alias=${ALIAS}    url=usuarios   params=${PARAMS}  headers=${HEADERS}
    Log   Resposta: ${\n}${RESPOSTA.text}
    Create Session   EditarUsuario       ${HOST}     ${HEADERS}
    ${RESPOSTA}     PUT On Session    EditarUsuario    url=usuarios/${ID_USUARIO_CADASTRADO}       json=${ALTERAR_USUARIO}
    Log      ${RESPOSTA.text}
    Set Test Variable     ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA.json()}      message      Registro alterado com sucesso

Listar todos usuários
    ${HEADERS}   Create Dictionary  Content-Type=application/json
    Create Session   LerTodosUsuarios       ${HOST}     ${HEADERS}
    ${RESPOSTA}     GET On Session      LerTodosUsuarios     usuarios        headers=${HEADERS}
    Log      ${RESPOSTA.text}
    Set Test Variable     ${RESPOSTA}

Excluir um usuário por ID
    ${HEADERS}   Create Dictionary  Content-Type=application/json
    ${PARAMS}    Create Dictionary  _id=${ID_USUARIO_CADASTRADO}
    ${RESPOSTA}  GET On Session     alias=${ALIAS}    url=usuarios   params=${PARAMS}  headers=${HEADERS}
    Log   Resposta: ${\n}${RESPOSTA.text}
    Create Session   DeleteUsuario       ${HOST}     ${HEADERS}
    ${RESPOSTA}     DELETE On Session    DeleteUsuario    usuarios/${ID_USUARIO_CADASTRADO}      headers=${HEADERS}
    Log      ${RESPOSTA.text}
    Set Test Variable     ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA.json()}      message        Registro excluído com sucesso

Gerar Token para autenticar
    Cadastrar usuário
    ${BODY}      Create Dictionary   email=${USUARIO.email}   password=${USUARIO.senha}
    ${RESPOSTA}     POST On Session     alias=${ALIAS}    url=login    json=${BODY}
    Log   Resposta: ${\n}${RESPOSTA.text}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    message    Login realizado com sucesso
    ${TOKEN}     Get From Dictionary    ${RESPOSTA.json()}    authorization
    Set Suite Variable    ${TOKEN}

Cadastrar produto
    ${PRODUTO}      FakerLibrary.Word
    ${PRECO}        FakerLibrary.Random Int
    ${DESCRICAO}    FakerLibrary.Word
    ${QUANTIDADE}   FakerLibrary.Random Int
    Set Suite Variable    ${PRODUTO}
    Set Suite Variable    ${PRECO}
    Set Suite Variable    ${DESCRICAO}
    Set Suite Variable    ${QUANTIDADE}
    ${BODY}      Create Dictionary   nome=${PRODUTO}      preco=${PRECO}     descricao=${DESCRICAO}    quantidade=${QUANTIDADE}
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}
    ${RESPOSTA}     POST On Session    alias=${ALIAS}    url=produtos    json=${BODY}  headers=${HEADERS}
    Log   Resposta: ${\n}${RESPOSTA.text}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    message    Cadastro realizado com sucesso
    ${ID_PRODUTO_CADASTRADO}  Get From Dictionary    ${RESPOSTA.json()}    _id
    Set Suite Variable   ${ID_PRODUTO_CADASTRADO}

Listar o produto cadastrado por ID
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}
    ${PARAMS}    Create Dictionary  _id=${ID_PRODUTO_CADASTRADO}
    ${RESPOSTA}  GET On Session     alias=${ALIAS}    url=produtos   params=${PARAMS}  headers=${HEADERS}
    Log   Resposta: ${\n}${RESPOSTA.text}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    quantidade   1
    Dictionary Should Contain Item    ${RESPOSTA.json()["produtos"][0]}      nome         ${PRODUTO}
    Dictionary Should Contain Item    ${RESPOSTA.json()["produtos"][0]}      preco        ${PRECO}
    Dictionary Should Contain Item    ${RESPOSTA.json()["produtos"][0]}      descricao    ${DESCRICAO}
    Dictionary Should Contain Item    ${RESPOSTA.json()["produtos"][0]}      quantidade   ${QUANTIDADE}
    Dictionary Should Contain Key     ${RESPOSTA.json()["produtos"][0]}      _id
