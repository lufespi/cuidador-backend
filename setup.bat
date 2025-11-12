@echo off
echo ========================================
echo   Cuidador Backend - Setup Rapido
echo ========================================
echo.

REM Verificar se Python esta instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Python nao encontrado!
    echo Por favor, instale Python 3.10+ de https://python.org
    pause
    exit /b 1
)

echo [1/7] Criando virtual environment...
python -m venv venv
if errorlevel 1 (
    echo [ERRO] Falha ao criar virtualenv
    pause
    exit /b 1
)

echo [2/7] Ativando virtual environment...
call venv\Scripts\activate.bat

echo [3/7] Instalando dependencias...
pip install -r requirements.txt
if errorlevel 1 (
    echo [ERRO] Falha ao instalar dependencias
    pause
    exit /b 1
)

echo [4/7] Configurando variaveis de ambiente...
if not exist .env (
    copy .env.example .env
    echo.
    echo [ATENCAO] Arquivo .env criado!
    echo Por favor, edite o arquivo .env com suas configuracoes antes de continuar.
    echo.
    echo Pressione qualquer tecla para abrir o .env no Notepad...
    pause >nul
    notepad .env
)

echo [5/7] Verificando banco de dados...
echo.
echo [IMPORTANTE] Certifique-se de que:
echo 1. MySQL esta rodando
echo 2. Database foi criado: CREATE DATABASE cuidador_db;
echo 3. Credenciais no .env estao corretas
echo.
echo Pressione qualquer tecla para continuar com as migrations...
pause >nul

echo [6/7] Executando migrations...
flask db init
flask db migrate -m "Initial migration"
flask db upgrade
if errorlevel 1 (
    echo [ERRO] Falha nas migrations
    echo Verifique se o MySQL esta rodando e as credenciais estao corretas
    pause
    exit /b 1
)

echo [7/7] Verificando instalacao...
echo.

echo ========================================
echo   Setup Concluido com Sucesso!
echo ========================================
echo.
echo Para iniciar o servidor, execute:
echo   venv\Scripts\activate
echo   flask run
echo.
echo A API estara disponivel em: http://localhost:5000
echo.
echo Consulte QUICK_START.md para proximos passos.
echo.
pause
