# Backend API - Cuidador App (Flask)

## 📋 Visão Geral

Backend em Flask para aplicativo de monitoramento de dor para pacientes com osteoartrite.
Deploy: PythonAnywhere.com

---

## 🗄️ Modelagem de Dados

### 1. **User (Usuário)**

```python
{
    "id": Integer (PK, Auto),
    "email": String(120, unique, not null),
    "password_hash": String(255, not null),
    "first_name": String(100, not null),
    "last_name": String(100, not null),
    "birth_date": Date (nullable),
    "phone": String(20, nullable),
    "gender": String(20, nullable),  # 'male', 'female', 'other'
    "created_at": DateTime (default=now),
    "updated_at": DateTime (onupdate=now)
}
```

**Relacionamentos:**
- `pain_records`: One-to-Many com PainRecord
- `preferences`: One-to-One com UserPreferences

---

### 2. **PainRecord (Registro de Dor)**

```python
{
    "id": Integer (PK, Auto),
    "user_id": Integer (FK -> User.id, not null),
    "body_part": String(50, not null),  # 'head', 'torso', 'left_arm', etc.
    "intensity": Integer (not null),  # 1-10
    "description": Text (nullable),
    "symptoms": JSON (nullable),  # Lista de sintomas
    "timestamp": DateTime (default=now),
    "created_at": DateTime (default=now),
    "updated_at": DateTime (onupdate=now)
}
```

**Índices:**
- `idx_user_timestamp`: (user_id, timestamp) para consultas rápidas

**Validações:**
- intensity: 1-10
- body_part: deve ser uma região válida

---

### 3. **UserPreferences (Preferências do Usuário)**

```python
{
    "id": Integer (PK, Auto),
    "user_id": Integer (FK -> User.id, unique, not null),
    "language": String(10, default='pt'),  # 'pt', 'en', 'es'
    "theme": String(10, default='light'),  # 'light', 'dark', 'system'
    "notifications_enabled": Boolean (default=True),
    "notification_time": Time (nullable),  # Horário de lembrete diário
    "created_at": DateTime (default=now),
    "updated_at": DateTime (onupdate=now)
}
```

---

## 🏗️ Estrutura do Backend (Flask)

```
cuidador-backend/
│
├── app/
│   ├── __init__.py              # Inicialização do Flask
│   ├── config.py                # Configurações (dev, prod)
│   ├── extensions.py            # SQLAlchemy, JWT, CORS, etc.
│   │
│   ├── models/
│   │   ├── __init__.py
│   │   ├── user.py              # Modelo User
│   │   ├── pain_record.py       # Modelo PainRecord
│   │   └── user_preferences.py  # Modelo UserPreferences
│   │
│   ├── routes/
│   │   ├── __init__.py
│   │   ├── auth.py              # POST /auth/register, /auth/login
│   │   ├── user.py              # GET/PUT /user/profile
│   │   └── pain.py              # CRUD de registros de dor
│   │
│   ├── schemas/
│   │   ├── __init__.py
│   │   ├── user_schema.py       # Validação com Marshmallow
│   │   ├── pain_schema.py
│   │   └── auth_schema.py
│   │
│   └── utils/
│       ├── __init__.py
│       ├── decorators.py        # @jwt_required, @validate_json
│       └── helpers.py           # Funções auxiliares
│
├── migrations/                  # Alembic migrations
├── tests/                       # Testes unitários
├── .env.example                 # Variáveis de ambiente
├── requirements.txt             # Dependências
├── wsgi.py                      # Entry point para PythonAnywhere
└── README.md
```

---

## 🔌 Endpoints da API

### **Base URL:** `https://seuusuario.pythonanywhere.com/api/v1`

### 🔐 Autenticação

#### 1. Registrar Usuário
```http
POST /auth/register
Content-Type: application/json

{
  "email": "usuario@exemplo.com",
  "password": "senha123",
  "first_name": "João",
  "last_name": "Silva",
  "birth_date": "1980-05-15",
  "phone": "+5511999999999",
  "gender": "male"
}
```

**Resposta (201):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "usuario@exemplo.com",
    "first_name": "João",
    "last_name": "Silva",
    "birth_date": "1980-05-15",
    "phone": "+5511999999999",
    "gender": "male",
    "created_at": "2025-11-12T10:30:00Z",
    "updated_at": "2025-11-12T10:30:00Z"
  }
}
```

---

#### 2. Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "usuario@exemplo.com",
  "password": "senha123"
}
```

**Resposta (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": { ... }
}
```

---

#### 3. Obter Usuário Atual
```http
GET /auth/me
Authorization: Bearer {token}
```

**Resposta (200):**
```json
{
  "id": 1,
  "email": "usuario@exemplo.com",
  "first_name": "João",
  "last_name": "Silva",
  ...
}
```

---

### 👤 Usuário

#### 4. Atualizar Perfil
```http
PUT /user/profile
Authorization: Bearer {token}
Content-Type: application/json

{
  "first_name": "João",
  "last_name": "Silva Santos",
  "birth_date": "1980-05-15",
  "phone": "+5511988888888",
  "gender": "male"
}
```

**Resposta (200):**
```json
{
  "id": 1,
  "email": "usuario@exemplo.com",
  "first_name": "João",
  "last_name": "Silva Santos",
  ...
}
```

---

#### 5. Obter/Atualizar Preferências
```http
GET /user/preferences
Authorization: Bearer {token}
```

```http
PUT /user/preferences
Authorization: Bearer {token}
Content-Type: application/json

{
  "language": "pt",
  "theme": "dark",
  "notifications_enabled": true,
  "notification_time": "09:00:00"
}
```

---

### 🩺 Registros de Dor

#### 6. Criar Registro de Dor
```http
POST /pain
Authorization: Bearer {token}
Content-Type: application/json

{
  "body_part": "left_knee",
  "intensity": 7,
  "description": "Dor ao subir escadas",
  "symptoms": ["swelling", "stiffness"],
  "timestamp": "2025-11-12T14:30:00Z"
}
```

**Resposta (201):**
```json
{
  "id": 1,
  "user_id": 1,
  "body_part": "left_knee",
  "intensity": 7,
  "description": "Dor ao subir escadas",
  "symptoms": ["swelling", "stiffness"],
  "timestamp": "2025-11-12T14:30:00Z",
  "created_at": "2025-11-12T14:30:00Z",
  "updated_at": "2025-11-12T14:30:00Z"
}
```

---

#### 7. Listar Registros de Dor
```http
GET /pain?page=1&per_page=20&start_date=2025-11-01&end_date=2025-11-30
Authorization: Bearer {token}
```

**Resposta (200):**
```json
{
  "items": [
    {
      "id": 1,
      "body_part": "left_knee",
      "intensity": 7,
      ...
    },
    ...
  ],
  "total": 45,
  "page": 1,
  "per_page": 20,
  "pages": 3
}
```

---

#### 8. Obter Registro Específico
```http
GET /pain/{id}
Authorization: Bearer {token}
```

---

#### 9. Atualizar Registro
```http
PUT /pain/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "intensity": 5,
  "description": "Melhorou após medicação"
}
```

---

#### 10. Deletar Registro
```http
DELETE /pain/{id}
Authorization: Bearer {token}
```

**Resposta (204):** No Content

---

#### 11. Estatísticas de Dor
```http
GET /pain/statistics?start_date=2025-11-01&end_date=2025-11-30
Authorization: Bearer {token}
```

**Resposta (200):**
```json
{
  "period": {
    "start_date": "2025-11-01",
    "end_date": "2025-11-30"
  },
  "total_records": 45,
  "average_intensity": 6.2,
  "most_affected_parts": [
    {"body_part": "left_knee", "count": 15},
    {"body_part": "right_knee", "count": 12},
    {"body_part": "torso", "count": 8}
  ],
  "intensity_distribution": {
    "1-3": 5,
    "4-6": 20,
    "7-10": 20
  },
  "common_symptoms": [
    {"symptom": "stiffness", "count": 30},
    {"symptom": "swelling", "count": 25}
  ]
}
```

---

## 🔧 Tecnologias e Dependências

### Requirements.txt
```txt
Flask==3.0.0
Flask-SQLAlchemy==3.1.1
Flask-Migrate==4.0.5
Flask-JWT-Extended==4.5.3
Flask-CORS==4.0.0
Flask-Marshmallow==0.15.0
marshmallow-sqlalchemy==0.29.0
python-dotenv==1.0.0
bcrypt==4.1.1
PyMySQL==1.1.0
```

---

## ⚙️ Configuração (.env)

```env
# Flask
FLASK_APP=wsgi.py
FLASK_ENV=production
SECRET_KEY=sua-chave-secreta-super-segura

# Database (MySQL no PythonAnywhere)
DATABASE_URL=mysql+pymysql://usuario:senha@usuario.mysql.pythonanywhere-services.com/usuario$cuidador

# JWT
JWT_SECRET_KEY=sua-jwt-secret-key
JWT_ACCESS_TOKEN_EXPIRES=2592000  # 30 dias em segundos

# CORS
CORS_ORIGINS=*  # Em produção, especifique o domínio do app
```

---

## 📦 Estrutura Mínima dos Arquivos

### `app/__init__.py`
```python
from flask import Flask
from flask_cors import CORS
from app.extensions import db, jwt, ma, migrate
from app.config import Config

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)
    
    # Initialize extensions
    db.init_app(app)
    jwt.init_app(app)
    ma.init_app(app)
    migrate.init_app(app, db)
    CORS(app)
    
    # Register blueprints
    from app.routes import auth, user, pain
    app.register_blueprint(auth.bp, url_prefix='/api/v1/auth')
    app.register_blueprint(user.bp, url_prefix='/api/v1/user')
    app.register_blueprint(pain.bp, url_prefix='/api/v1/pain')
    
    return app
```

### `app/extensions.py`
```python
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_marshmallow import Marshmallow
from flask_migrate import Migrate

db = SQLAlchemy()
jwt = JWTManager()
ma = Marshmallow()
migrate = Migrate()
```

### `app/config.py`
```python
import os
from datetime import timedelta

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key'
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY') or 'jwt-secret-key'
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(days=30)
    
    JSON_SORT_KEYS = False
```

### `wsgi.py` (Entry Point para PythonAnywhere)
```python
import os
from dotenv import load_dotenv

# Load environment variables
dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)

from app import create_app

application = create_app()

if __name__ == '__main__':
    application.run()
```

---

## 🚀 Deploy no PythonAnywhere

### Passos:

1. **Criar conta no PythonAnywhere**
2. **Clonar repositório:**
   ```bash
   git clone https://github.com/seu-usuario/cuidador-backend.git
   ```

3. **Criar virtual environment:**
   ```bash
   mkvirtualenv --python=/usr/bin/python3.10 cuidador-env
   pip install -r requirements.txt
   ```

4. **Configurar banco MySQL:**
   - Criar database no PythonAnywhere
   - Atualizar `.env` com credenciais

5. **Configurar Web App:**
   - Source code: `/home/seuusuario/cuidador-backend`
   - Working directory: `/home/seuusuario/cuidador-backend`
   - WSGI file: apontar para `wsgi.py`
   - Virtualenv: `/home/seuusuario/.virtualenvs/cuidador-env`

6. **Executar migrations:**
   ```bash
   flask db init
   flask db migrate -m "Initial migration"
   flask db upgrade
   ```

7. **Recarregar aplicação**

---

## 🧪 Validações e Regras de Negócio

### User:
- Email único e válido
- Senha: mínimo 6 caracteres
- birth_date: formato YYYY-MM-DD
- gender: 'male', 'female', 'other'

### PainRecord:
- intensity: 1-10
- body_part: deve estar na lista de regiões válidas
  - `head`, `torso`, `left_arm`, `right_arm`, `left_hand`, `right_hand`, 
  - `left_leg`, `right_leg`, `left_foot`, `right_foot`
- timestamp: não pode ser futuro

### UserPreferences:
- language: 'pt', 'en', 'es'
- theme: 'light', 'dark', 'system'
- notification_time: formato HH:MM:SS

---

## 🔒 Segurança

1. **Autenticação JWT**: Token Bearer em todos endpoints protegidos
2. **Hash de Senha**: bcrypt com salt
3. **CORS**: Configurado para domínio específico em produção
4. **SQL Injection**: Protegido pelo SQLAlchemy ORM
5. **Rate Limiting**: Implementar em produção (Flask-Limiter)
6. **HTTPS**: Obrigatório em produção (PythonAnywhere fornece)

---

## 📝 Códigos de Status HTTP

- `200`: OK
- `201`: Created
- `204`: No Content
- `400`: Bad Request (validação)
- `401`: Unauthorized (não autenticado)
- `403`: Forbidden (sem permissão)
- `404`: Not Found
- `409`: Conflict (email já existe)
- `422`: Unprocessable Entity
- `500`: Internal Server Error

---

## 📚 Documentação Adicional

- Swagger/OpenAPI: Implementar com `flask-swagger-ui`
- Postman Collection: Exportar para facilitar testes

---

## 🔄 Próximos Passos

1. Implementar refresh tokens
2. Adicionar suporte a foto de perfil
3. Notificações push
4. Relatórios em PDF
5. Integração com wearables
6. Modo offline no app Flutter

---

## 📞 Suporte

Para dúvidas sobre a API, consulte a documentação Swagger em:
`https://seuusuario.pythonanywhere.com/api/docs`
