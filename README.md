## Automação de testes - API/WEB

Neste repositório encontra-se a automação utilizando o framework Robot.

Para executar o teste é necessário ter um ambiente em Python configurado.

Utilizei o editor PyCharm pois tem uma interface amigavél e de fácil usabilidade.
Os testes foram executados utilizando o driver do Chrome.

### 01 — Instalando o Python e pip [Pré-Requisitos]
- Baixe o Python 2.7.x [https://www.python.org/downloads/] 
- OBS.: Podem ocorrer problemas de compatibilidade com o Python 3.0, então recomendam o 2.7 por enquanto.
- Instale via executável o Python 2.7. 
- OBS.: Defina a variável de ambiente durante a instalação (recomendado).
- Se mesmo após a instalação não configurou as variáveis de ambiente, manualmente edite as variáveis e adicione “C:\Python27\;C:\Python27\Scripts”.
- Para conferir se deu certo, no prompt de comando (cmd) execute:
python --version
pip -- version
### 02 — Instalando o Robot Framework
- No prompt de comando (cmd) execute e aguarde a instalação:
- pip install robotframework
- Para saber se deu tudo certo no prompt de comando (cmd) execute:
robot --version

#### Versões utilizadas:

- Gherkin 4.1.3
- pip (atualizado)
- robotframework-seleninumlibrary 4.1.0rc1
- selenium 3.141.0
- ChromeDriver 88.0.4324.96
- robotframework==3.2.2
- robotframework-faker==5.0.0
- robotframework-requests==0.8.0
