# CuidaDor Backend API

Backend em Flask para o aplicativo CuidaDor.

## 📋 Pré-requisitos

- Python 3.8+
- MySQL (PythonAnywhere)

## 🚀 Instalação Local

```bash
# Criar ambiente virtual
python -m venv venv

# Ativar ambiente virtual
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# Instalar dependências
pip install -r requirements.txt

# Configurar variáveis de ambiente
cp .env.example .env
# Edite o .env com suas configurações

# Rodar aplicação
python api/app.py
```

## 🌐 Deploy no PythonAnywhere

### 1. Upload do Código
```bash
# Via Git
git clone https://github.com/seu-usuario/cuidador-backend.git
cd cuidador-backend
```

### 2. Criar Virtualenv
No console do PythonAnywhere:
```bash
mkvirtualenv --python=/usr/bin/python3.10 cuidador-env
pip install -r requirements.txt
```

### 3. Configurar WSGI File
Arquivo: `/var/www/kaueMuller_pythonanywhere_com_wsgi.py`
```python
import sys
import os

# Adicionar diretório do projeto ao path
project_home = '/home/KaueMuller/cuidador-backend'
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

### 4. Configurar Web App
- Virtualenv path: `/home/KaueMuller/.virtualenvs/cuidador-env`
- Source code: `/home/KaueMuller/cuidador-backend`
- WSGI file: configurado acima

### 5. Reload
Clique em "Reload" no dashboard do PythonAnywhere

## 📡 Endpoints da API

### Autenticação

#### Registrar Usuário
```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "email": "usuario@email.com",
  "senha": "senha123",
  "nome": "Nome do Usuário",
  "telefone": "(11) 99999-9999",
  "data_nascimento": "1990-01-01",
  "sexo": "M"
}
```

**Resposta (201):**
```json
{
  "message": "Usuário cadastrado com sucesso",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "usuario@email.com",
    "nome": "Nome do Usuário",
    "telefone": "(11) 99999-9999",
    "data_nascimento": "1990-01-01",
    "sexo": "M",
    "created_at": "2025-11-23T10:30:00"
  }
}
```

#### Login
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "usuario@email.com",
  "senha": "senha123"
}
```

**Resposta (200):**
```json
{
  "message": "Login realizado com sucesso",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "usuario@email.com",
    "nome": "Nome do Usuário"
  }
}
```

### Registros de Dor (Requer Autenticação)

#### Criar Registro
```http
POST /api/v1/pain/records
Authorization: Bearer <token>
Content-Type: application/json

{
  "body_parts": ["head", "neck", "left_shoulder"],
  "intensidade": 7,
  "observacoes": "Dor persistente após atividade física"
}
```

**Resposta (201):**
```json
{
  "message": "Registro criado com sucesso",
  "id": 1
}
```

#### Listar Registros
```http
GET /api/v1/pain/records
Authorization: Bearer <token>
```

**Resposta (200):**
```json
[
  {
    "id": 1,
    "user_id": 1,
    "body_parts": ["head", "neck", "left_shoulder"],
    "intensidade": 7,
    "data": "2025-11-23T10:30:00",
    "observacoes": "Dor persistente após atividade física"
  }
]
```

#### Deletar Registro
```http
DELETE /api/v1/pain/records/1
Authorization: Bearer <token>
```

**Resposta (200):**
```json
{
  "message": "Registro deletado com sucesso"
}
```

### Health Check
```http
GET /health
```

**Resposta (200):**
```json
{
  "status": "ok"
}
```

## 🗄️ Estrutura do Banco de Dados

### Tabela: users
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(120) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nome VARCHAR(100),
    telefone VARCHAR(20),
    data_nascimento DATE,
    sexo VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
);
```

### Tabela: pain_records
```sql
CREATE TABLE pain_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    body_parts JSON NOT NULL,
    intensidade INT NOT NULL,
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observacoes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_data (data)
);
```

## 🔒 Segurança

- ✅ Senhas armazenadas com hash bcrypt
- ✅ Autenticação JWT com expiração
- ✅ CORS configurado para Flutter
- ✅ Validação de entrada em todos os endpoints
- ✅ SQL preparado (prevenção de SQL injection)
- ✅ Tokens com tempo de expiração

## 🛠️ Tecnologias

- **Flask** - Framework web
- **PyMySQL** - Driver MySQL
- **bcrypt** - Hash de senhas
- **PyJWT** - JSON Web Tokens
- **python-dotenv** - Variáveis de ambiente
- **Flask-CORS** - Cross-Origin Resource Sharing

## 📝 Variáveis de Ambiente

Crie um arquivo `.env` baseado no `.env.example`:

```env
DB_HOST=seu-host-mysql
DB_USER=seu-usuario
DB_PASSWORD=sua-senha
DB_NAME=seu-banco
JWT_SECRET=chave-secreta-jwt
JWT_EXPIRATION=86400
FLASK_ENV=production
SECRET_KEY=chave-secreta-flask
```

## 🧪 Testes

```bash
# Instalar dependências de teste
pip install pytest pytest-cov

# Rodar testes
pytest

# Com cobertura
pytest --cov=api tests/
```

## 📞 Suporte

Para problemas ou dúvidas, abra uma issue no repositório.

## 📄 Licença

MIT License
