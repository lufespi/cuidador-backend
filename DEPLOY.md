# 🚀 Guia de Deploy - PythonAnywhere!

Este guia detalha como fazer deploy do backend CuidaDor no PythonAnywhere.

## 📋 Pré-requisitos

1. Conta no PythonAnywhere (gratuita ou paga)
2. Código do backend no GitHub
3. Banco MySQL configurado no PythonAnywhere

## 🔧 Passo 1: Preparar o Código

### 1.1 Criar Repositório no GitHub

```bash
cd backend
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/seu-usuario/cuidador-backend.git
git push -u origin main
```

## 🌐 Passo 2: Configurar PythonAnywhere

### 2.1 Fazer Login no PythonAnywhere

1. Acesse: https://www.pythonanywhere.com
2. Faça login na sua conta
3. Vá para o Dashboard

### 2.2 Clonar o Repositório

No console Bash do PythonAnywhere:

```bash
cd ~
git clone https://github.com/seu-usuario/cuidador-backend.git
cd cuidador-backend
```

### 2.3 Criar Ambiente Virtual

```bash
# Criar virtualenv
mkvirtualenv --python=/usr/bin/python3.10 cuidador-env

# Ativar virtualenv
workon cuidador-env

# Instalar dependências
pip install -r requirements.txt
```

## 🗄️ Passo 3: Configurar Banco de Dados

### 3.1 Criar Banco MySQL

1. No Dashboard, vá em **Databases**
2. Configure seu banco MySQL:
   - Host: `seu_usuario.mysql.pythonanywhere-services.com`
   - Database: `seu_usuario$cuidador`
   - Username: `seu_usuario`
   - Password: (senha que você definir)

### 3.2 Configurar Variáveis de Ambiente

Crie o arquivo `.env`:

```bash
cd ~/cuidador-backend
nano .env
```

Adicione:

```env
DB_HOST=seu_usuario.mysql.pythonanywhere-services.com
DB_USER=seu_usuario
DB_PASSWORD=sua_senha_mysql
DB_NAME=seu_usuario$cuidador

JWT_SECRET=cole-uma-chave-aleatoria-super-segura-aqui
JWT_EXPIRATION=86400

FLASK_ENV=production
SECRET_KEY=outra-chave-aleatoria-segura
```

Salve com `Ctrl+O`, Enter, `Ctrl+X`

### 3.3 Inicializar Tabelas

```bash
workon cuidador-env
python -c "from api.db import init_db; init_db()"
```

## 🌍 Passo 4: Configurar Web App

### 4.1 Criar Web App

1. No Dashboard, vá em **Web**
2. Clique em **Add a new web app**
3. Escolha **Manual configuration**
4. Selecione **Python 3.10**

### 4.2 Configurar Virtualenv

Na página de configuração do Web App:

1. Encontre a seção **Virtualenv**
2. Digite: `/home/seu_usuario/.virtualenvs/cuidador-env`
3. Clique em ✓

### 4.3 Configurar Source Code

1. Na seção **Code**, em **Source code**:
   - `/home/seu_usuario/cuidador-backend`

### 4.4 Configurar WSGI File

1. Clique no link do arquivo WSGI (algo como `/var/www/seu_usuario_pythonanywhere_com_wsgi.py`)
2. Substitua TODO o conteúdo por:

```python
import sys
import os

# Adicionar diretório do projeto ao path
project_home = '/home/seu_usuario/cuidador-backend'
if project_home not in sys.path:
    sys.path.insert(0, project_home)

# Carregar variáveis de ambiente
from dotenv import load_dotenv
project_folder = os.path.expanduser(project_home)
load_dotenv(os.path.join(project_folder, '.env'))

# Importar aplicação
from api.app import create_app
application = create_app()
```

3. **IMPORTANTE**: Substitua `seu_usuario` pelo seu username do PythonAnywhere
4. Salve o arquivo

### 4.5 Configurar Static Files (Opcional)

Se você tiver arquivos estáticos:

- URL: `/static/`
- Directory: `/home/seu_usuario/cuidador-backend/static`

## 🔄 Passo 5: Reload e Testar

### 5.1 Reload da Aplicação

1. No topo da página Web, clique no botão verde **Reload**
2. Aguarde alguns segundos

### 5.2 Verificar Logs

Se houver erro:

1. Clique em **Log files**
2. Abra o **Error log**
3. Corrija os erros encontrados
4. Reload novamente

### 5.3 Testar Endpoints

```bash
# Health check
curl https://seu_usuario.pythonanywhere.com/health

# Deve retornar:
# {"status": "ok"}

# Testar registro
curl -X POST https://seu_usuario.pythonanywhere.com/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"teste@email.com","senha":"123456"}'
```

## 📱 Passo 6: Atualizar App Flutter

No arquivo `lib/core/config/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'https://seu_usuario.pythonanywhere.com';
  // ...
}
```

## 🔧 Manutenção

### Atualizar Código

```bash
cd ~/cuidador-backend
git pull origin main
# Reload no Dashboard Web
```

### Ver Logs

```bash
# Error log
tail -f /var/log/seu_usuario.pythonanywhere.com.error.log

# Server log
tail -f /var/log/seu_usuario.pythonanywhere.com.server.log
```

### Executar Migrations

```bash
workon cuidador-env
cd ~/cuidador-backend
python scripts/migrate.py
```

## 🐛 Troubleshooting

### Erro: "No module named 'api'"

Verifique o WSGI file:
- Path correto em `project_home`
- `sys.path.insert(0, project_home)` está presente

### Erro: "Could not import 'api.app'"

```bash
workon cuidador-env
cd ~/cuidador-backend
python -c "from api.app import create_app; print('OK')"
```

### Erro de Conexão com Banco

Verifique:
1. Credenciais no `.env`
2. Banco existe no Dashboard > Databases
3. Permissões do usuário

### Erro 502 Bad Gateway

1. Verifique Error log
2. Confirme virtualenv path correto
3. Reinstale dependências:

```bash
workon cuidador-env
pip install --upgrade -r requirements.txt
```

## 🔐 Segurança

### Gerar Chaves Secretas

```python
import secrets
print(secrets.token_urlsafe(32))
```

Use a saída para `JWT_SECRET` e `SECRET_KEY`

### Proteger .env

```bash
chmod 600 .env
```

### HTTPS

PythonAnywhere fornece HTTPS automático! ✅

## 📊 Monitoramento

### CPU Usage

Dashboard > Account > CPU usage

### Requests

Dashboard > Web > Access log

### Database

Dashboard > Databases > Manage database

## 🎉 Conclusão

Seu backend está no ar! 🚀

URL da API: `https://seu_usuario.pythonanywhere.com`

Documentação: `https://seu_usuario.pythonanywhere.com/` (retorna JSON com info da API)

## 📞 Suporte

- Documentação PythonAnywhere: https://help.pythonanywhere.com/
- Fórum: https://www.pythonanywhere.com/forums/
