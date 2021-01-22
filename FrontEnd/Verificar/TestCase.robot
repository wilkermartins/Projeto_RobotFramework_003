*** Settings ***
Resource      Resource.robot
Suite Teardown  Fechar Navegador

*** Test Cases ***

Validar acesso ao site
    Validar que a página home foi exibida

Validar acesso a categoria
    Validar que ao passar o mouse por cima da categoria Dresses, as sub categorias foram exibidas

Validar acesso a subcategoria
    Validar que ao clicar na sub categoria Summer Dresses os produtos são exibidos
