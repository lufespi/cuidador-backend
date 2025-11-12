# Deploy no PythonAnywhere - Guia Passo a Passo

## 📋 Pré-requisitos

1. Conta no PythonAnywhere (https://www.pythonanywhere.com)
2. Repositório GitHub criado com o código
3. MySQL database criado no PythonAnywhere

---

## 🚀 Passo 1: Preparar o Repositório

### 1.1. Criar repositório no GitHub

```bash
cd cuidador-backend
git init
git add .
git commit -m "Initial commit: Flask backend"
git branch -M main
git remote add origin https://github.com/seu-usuario/cuidador-backend.git
git push -u origin main
```

---

## 🖥️ Passo 2: Configurar PythonAnywhere

### 2.1. Abrir Console Bash

No dashboard do PythonAnywhere:
- Clique em "Consoles" → "Bash"

### 2.2. Clonar Repositório

```bash
cd ~
git clone https://github.com/seu-usuario/cuidador-backend.git
cd cuidador-backend
```

### 2.3. Criar Virtual Environment

```bash
mkvirtualenv --python=/usr/bin/python3.10 cuidador-env
workon cuidador-env
```

### 2.4. Instalar Dependências

```bash
pip install -r requirements.txt
```

---

## 🗄️ Passo 3: Configurar Banco de Dados MySQL

### 3.1. Criar Database

No dashboard do PythonAnywhere:
- Vá em "Databases"
- Crie um novo database MySQL (ex: `seuusuario$cuidador`)
- Anote a senha do MySQL

### 3.2. Configurar Variáveis de Ambiente

```bash
cd ~/cuidador-backend
nano .env
```

Adicione:

```env
FLASK_APP=wsgi.py
FLASK_ENV=production
SECRET_KEY=gere-uma-chave-secreta-aqui-use-uuid

# Database MySQL
DATABASE_URL=mysql+pymysql://seuusuario:senha@seuusuario.mysql.pythonanywhere-services.com/seuusuario$cuidador

# JWT
JWT_SECRET_KEY=gere-outra-chave-secreta-aqui
JWT_ACCESS_TOKEN_EXPIRES=2592000

# CORS (adicione o domínio do seu app Flutter depois)
CORS_ORIGINS=*
```

**Dica para gerar chaves secretas:**

```bash
python -c "import uuid; print(uuid.uuid4().hex)"
```

### 3.3. Inicializar Database

```bash
workon cuidador-env
cd ~/cuidador-backend

# Inicializar migrations
flask db init
flask db migrate -m "Initial migration"
flask db upgrade
```

---

## 🌐 Passo 4: Configurar Web App

### 4.1. Criar Web App

No dashboard do PythonAnywhere:
- Vá em "Web"
- Clique em "Add a new web app"
- Escolha "Manual configuration"
- Selecione Python 3.10

### 4.2. Configurar Source Code

Na seção **Code**:
- **Source code:** `/home/seuusuario/cuidador-backend`
- **Working directory:** `/home/seuusuario/cuidador-backend`

### 4.3. Configurar Virtualenv

Na seção **Virtualenv**:
- Insira o path: `/home/seuusuario/.virtualenvs/cuidador-env`

### 4.4. Configurar WSGI File

Clique no link do WSGI file e substitua TODO o conteúdo por:

```python
import sys
import os
from dotenv import load_dotenv

# Add project directory to the sys.path
project_home = '/home/seuusuario/cuidador-backend'
if project_home not in sys.path:
    sys.path.insert(0, project_home)

# Load environment variables
load_dotenv(os.path.join(project_home, '.env'))

# Import Flask app
from app import create_app

application = create_app()
```

**Importante:** Substitua `seuusuario` pelo seu username do PythonAnywhere.

### 4.5. Configurar HTTPS

Na seção **Security**:
- Marque "Force HTTPS"

### 4.6. Recarregar Web App

- Clique no botão verde "Reload" no topo da página

---

## ✅ Passo 5: Testar API

### 5.1. Health Check

Abra no navegador:
```
https://seuusuario.pythonanywhere.com/health
```

Deve retornar:
```json
{
  "status": "ok",
  "message": "Cuidador API is running"
}
```

### 5.2. Testar Registro

Use Postman ou cURL:

```bash
curl -X POST https://seuusuario.pythonanywhere.com/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@exemplo.com",
    "password": "senha123",
    "first_name": "Teste",
    "last_name": "Usuario",
    "birth_date": "1990-01-01",
    "gender": "male"
  }'
```

### 5.3. Testar Login

```bash
curl -X POST https://seuusuario.pythonanywhere.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@exemplo.com",
    "password": "senha123"
  }'
```

---

## 🔧 Manutenção e Atualizações

### Atualizar Código

```bash
# Conectar no console bash do PythonAnywhere
cd ~/cuidador-backend
git pull origin main

# Ativar virtualenv
workon cuidador-env

# Instalar novas dependências (se houver)
pip install -r requirements.txt

# Executar migrations (se houver)
flask db migrate -m "Nova migração"
flask db upgrade
```

Depois, vá em "Web" e clique em "Reload".

### Ver Logs de Erro

No dashboard "Web", veja:
- **Error log:** para erros do servidor
- **Server log:** para requisições

### Backup do Banco de Dados

```bash
# No console bash
mysqldump -u seuusuario -h seuusuario.mysql.pythonanywhere-services.com \
  -p seuusuario\$cuidador > backup_$(date +%Y%m%d).sql
```

---

## 🔒 Segurança em Produção

### 1. Atualizar CORS

Após publicar o app Flutter, atualize o `.env`:

```env
CORS_ORIGINS=https://seuapp.com,https://app.seudominio.com
```

### 2. Configurar Rate Limiting

Adicione ao `requirements.txt`:
```
Flask-Limiter==3.5.0
```

No `app/__init__.py`:
```python
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(
    app=app,
    key_func=get_remote_address,
    default_limits=["200 per day", "50 per hour"]
)
```

### 3. Monitorar Uso

- Verifique o uso de CPU/memória no dashboard
- Configure alertas de quota
- Monitore logs regularmente

---

## 📊 Limites do PythonAnywhere (Plano Gratuito)

- **CPU:** 100 segundos/dia
- **Storage:** 512 MB
- **MySQL:** 1 database
- **Web app:** 1 app por conta
- **Requests:** Sem limite oficial, mas rate limitado

### Upgrade para Plano Pago

Se necessário:
- **Hacker ($5/mês):** 2 web apps, mais CPU
- **Web Dev ($12/mês):** 5 web apps, mais recursos

---

## 🆘 Troubleshooting

### Erro 500

1. Verifique error log
2. Teste localmente
3. Verifique `.env` está correto
4. Confirme que migrations rodaram

### Import Error

1. Verifique virtualenv está configurado
2. Reinstale dependências: `pip install -r requirements.txt`

### Database Connection Error

1. Verifique credenciais MySQL no `.env`
2. Confirme que database foi criado
3. Teste conexão no console

### CORS Error (no app Flutter)

1. Atualize `CORS_ORIGINS` no `.env`
2. Reload web app
3. Verifique headers nas requisições

---

## 📝 Checklist Final

- [ ] Repositório GitHub criado e atualizado
- [ ] PythonAnywhere configurado
- [ ] Virtual environment criado
- [ ] Dependências instaladas
- [ ] MySQL database criado
- [ ] `.env` configurado com chaves secretas
- [ ] Migrations executadas
- [ ] WSGI file configurado
- [ ] Web app recarregado
- [ ] Health check funcionando
- [ ] Endpoint de registro testado
- [ ] Endpoint de login testado
- [ ] HTTPS habilitado
- [ ] Logs verificados

---

## 🔗 Links Úteis

- **PythonAnywhere Help:** https://help.pythonanywhere.com/
- **Flask Documentation:** https://flask.palletsprojects.com/
- **SQLAlchemy Docs:** https://docs.sqlalchemy.org/

---

## 🎉 Próximos Passos

1. Documentar API com Swagger
2. Configurar CI/CD (GitHub Actions)
3. Adicionar testes automatizados
4. Implementar logging estruturado
5. Configurar monitoring (Sentry, etc.)
