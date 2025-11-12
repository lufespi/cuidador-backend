#!/bin/bash

echo "========================================"
echo "  Cuidador Backend - Setup Rápido"
echo "========================================"
echo ""

# Verificar se Python está instalado
if ! command -v python3 &> /dev/null; then
    echo "[ERRO] Python não encontrado!"
    echo "Por favor, instale Python 3.10+ de https://python.org"
    exit 1
fi

echo "[1/7] Criando virtual environment..."
python3 -m venv venv
if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao criar virtualenv"
    exit 1
fi

echo "[2/7] Ativando virtual environment..."
source venv/bin/activate

echo "[3/7] Instalando dependências..."
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao instalar dependências"
    exit 1
fi

echo "[4/7] Configurando variáveis de ambiente..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo ""
    echo "[ATENÇÃO] Arquivo .env criado!"
    echo "Por favor, edite o arquivo .env com suas configurações."
    echo ""
    read -p "Pressione ENTER para continuar após editar o .env..."
fi

echo "[5/7] Verificando banco de dados..."
echo ""
echo "[IMPORTANTE] Certifique-se de que:"
echo "1. MySQL está rodando"
echo "2. Database foi criado: CREATE DATABASE cuidador_db;"
echo "3. Credenciais no .env estão corretas"
echo ""
read -p "Pressione ENTER para continuar com as migrations..."

echo "[6/7] Executando migrations..."
flask db init
flask db migrate -m "Initial migration"
flask db upgrade
if [ $? -ne 0 ]; then
    echo "[ERRO] Falha nas migrations"
    echo "Verifique se o MySQL está rodando e as credenciais estão corretas"
    exit 1
fi

echo "[7/7] Verificando instalação..."
echo ""

echo "========================================"
echo "  Setup Concluído com Sucesso!"
echo "========================================"
echo ""
echo "Para iniciar o servidor, execute:"
echo "  source venv/bin/activate"
echo "  flask run"
echo ""
echo "A API estará disponível em: http://localhost:5000"
echo ""
echo "Consulte QUICK_START.md para próximos passos."
echo ""
