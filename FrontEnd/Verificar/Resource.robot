*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${BROWSER}                Chrome
${URL}                    http://automationpractice.com/index.php
${CATEGORIA}              //*[@id="block_top_menu"]/ul/li[2]/a
${SUBCATEGORIA}           //*[@id="categories_block_left"]/div/ul/li[3]/a
${VALIDACAOSITE}          //*[@id="header_logo"]/a/img
${VALIDACAOCATEGORIA}     //*[@id="categories_block_left"]/div/ul/li[1]/a
${VALIDACAOCATEGORIA}     //*[@id="categories_block_left"]/div/ul/li[2]/a
${VALIDACAOCATEGORIA}     //*[@id="categories_block_left"]/div/ul/li[3]/a
${VALIDACAOSUBCATEGORIA}  //*[@id="center_column"]/ul/li[1]/div/div[1]/div/a[1]/img

*** Keywords ***

Validar que a página home foi exibida
    Open Browser    ${URL}  ${BROWSER}
    Wait Until Element Is Visible   ${VALIDACAOSITE}
Validar que ao passar o mouse por cima da categoria Dresses, as sub categorias foram exibidas
    Click Element  ${CATEGORIA}
    Wait Until Element Is Visible  ${VALIDACAOCATEGORIA}
Validar que ao clicar na sub categoria Summer Dresses os produtos são exibidos
    Click Element  ${SUBCATEGORIA}
    Wait Until Element Is Visible  ${VALIDACAOSUBCATEGORIA}
Fechar Navegador
    Close Browser
