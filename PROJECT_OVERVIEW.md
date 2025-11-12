# 🏥 Cuidador App - Sistema Completo

## 📋 Visão Geral do Projeto

Sistema completo para monitoramento de dor em pacientes com osteoartrite, composto por:

1. **Backend API (Flask)** - `cuidador-backend` (este repositório)
2. **Mobile App (Flutter)** - `cuidador-app` (repositório separado)

---

## 🗂️ Estrutura dos Repositórios

### 📦 cuidador-backend (Backend Flask)

```
cuidador-backend/
├── app/
│   ├── __init__.py              # Factory do Flask
│   ├── config.py                # Configurações
│   ├── extensions.py            # SQLAlchemy, JWT, etc.
│   │
│   ├── models/                  # Modelos de dados
│   │   ├── user.py              # Usuário
│   │   ├── pain_record.py       # Registro de dor
│   │   └── user_preferences.py  # Preferências
│   │
│   ├── routes/                  # Endpoints da API
│   │   ├── auth.py              # Autenticação
│   │   ├── user.py              # Usuário e preferências
│   │   └── pain.py              # Registros de dor
│   │
│   ├── schemas/                 # Validação (Marshmallow)
│   │   ├── auth_schema.py
│   │   ├── pain_schema.py
│   │   └── user_schema.py
│   │
│   └── utils/                   # Utilitários
│       ├── decorators.py        # @jwt_required, @validate_json
│       └── helpers.py           # Helpers
│
├── migrations/                  # Migrações do banco
├── wsgi.py                      # Entry point
├── requirements.txt             # Dependências Python
├── .env.example                 # Exemplo de variáveis
├── README.md
├── BACKEND_SPECIFICATION.md     # Documentação completa da API
├── DEPLOY_GUIDE.md              # Guia de deploy PythonAnywhere
└── FLUTTER_INTEGRATION.md       # Integração com Flutter
```

### 📱 cuidador-app (App Flutter)

```
cuidador-app/lib/
├── main.dart
├── core/
│   ├── constants/
│   │   └── api_constants.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── pain_record_model.dart
│   │   ├── auth_response_model.dart
│   │   ├── user_preferences_model.dart      # ⚠️ Criar
│   │   └── pain_statistics_model.dart       # ⚠️ Criar
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   ├── pain_service.dart
│   │   └── preferences_service.dart         # ⚠️ Criar
│   ├── providers/
│   │   └── register_provider.dart
│   ├── theme/
│   └── widgets/
└── screens/
    ├── auth/                    # Login e Registro
    ├── home/                    # Home
    ├── dor/                     # Registro de dor
    ├── statistics/              # ⚠️ Criar - Estatísticas
    └── settings/                # Configurações
```

---

## 🗄️ Banco de Dados (MySQL)

### Tabelas:

#### 1. **users**
- `id` (PK)
- `email` (unique)
- `password_hash`
- `first_name`, `last_name`
- `birth_date`, `phone`, `gender`
- `created_at`, `updated_at`

#### 2. **pain_records**
- `id` (PK)
- `user_id` (FK → users)
- `body_part` (head, torso, left_arm, etc.)
- `intensity` (1-10)
- `description`, `symptoms` (JSON)
- `timestamp`, `created_at`, `updated_at`

#### 3. **user_preferences**
- `id` (PK)
- `user_id` (FK → users, unique)
- `language` (pt, en, es)
- `theme` (light, dark, system)
- `notifications_enabled`
- `notification_time`
- `created_at`, `updated_at`

---

## 🔌 API Endpoints

### Base URL
- **Dev:** `http://localhost:5000/api/v1`
- **Prod:** `https://seuusuario.pythonanywhere.com/api/v1`

### Autenticação
```
POST   /auth/register       # Registrar usuário
POST   /auth/login          # Login
GET    /auth/me             # Usuário atual (JWT)
```

### Usuário
```
GET    /user/profile        # Obter perfil (JWT)
PUT    /user/profile        # Atualizar perfil (JWT)
GET    /user/preferences    # Obter preferências (JWT)
PUT    /user/preferences    # Atualizar preferências (JWT)
```

### Registros de Dor
```
POST   /pain                # Criar registro (JWT)
GET    /pain                # Listar registros (JWT, paginado)
GET    /pain/{id}           # Obter registro específico (JWT)
PUT    /pain/{id}           # Atualizar registro (JWT)
DELETE /pain/{id}           # Deletar registro (JWT)
GET    /pain/statistics     # Estatísticas (JWT)
```

---

## 🚀 Guia de Início Rápido

### 1️⃣ Configurar Backend

```bash
# Clonar repositório
git clone https://github.com/seu-usuario/cuidador-backend.git
cd cuidador-backend

# Criar virtualenv
python -m venv venv
venv\Scripts\activate  # Windows
# source venv/bin/activate  # Linux/Mac

# Instalar dependências
pip install -r requirements.txt

# Configurar .env
copy .env.example .env
# Editar .env com suas configurações

# Criar banco de dados MySQL
# CREATE DATABASE cuidador_db;

# Executar migrations
flask db init
flask db migrate -m "Initial migration"
flask db upgrade

# Rodar servidor
flask run
```

### 2️⃣ Configurar App Flutter

```bash
# Clonar repositório do app
git clone https://github.com/seu-usuario/cuidador-app.git
cd cuidador-app

# Instalar dependências
flutter pub get

# Atualizar API URL em lib/core/constants/api_constants.dart
# baseUrl = 'http://SEU_IP_LOCAL:5000/api/v1'  # Para testar em device

# Rodar app
flutter run
```

### 3️⃣ Testar Integração

1. No app, registre um novo usuário
2. Faça login
3. Registre uma dor
4. Visualize estatísticas

---

## 📊 Modelagem de Dados (Resumo)

### Relacionamentos:

```
User (1) ──────< (N) PainRecord
  │
  └──── (1:1) ─────> UserPreferences
```

### Validações:

**User:**
- Email único e válido
- Senha mínimo 6 caracteres
- Gender: male/female/other

**PainRecord:**
- Intensity: 1-10
- BodyPart: lista de regiões válidas
- Timestamp não pode ser futuro

**UserPreferences:**
- Language: pt/en/es
- Theme: light/dark/system

---

## 🔒 Segurança

- ✅ JWT Bearer Token
- ✅ Bcrypt password hashing
- ✅ CORS configurável
- ✅ SQL Injection protection (SQLAlchemy)
- ✅ Input validation (Marshmallow)
- ✅ HTTPS obrigatório em produção

---

## 📦 Deploy

### Backend (PythonAnywhere)

Consulte: **`DEPLOY_GUIDE.md`**

Resumo:
1. Criar conta PythonAnywhere
2. Clonar repositório
3. Criar virtualenv e instalar dependências
4. Criar banco MySQL
5. Configurar `.env`
6. Executar migrations
7. Configurar WSGI
8. Reload web app

### App Flutter

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

Deploy em:
- Google Play Store
- Apple App Store
- Firebase App Distribution (testes)

---

## 🧪 Testes

### Backend

```bash
# Instalar dependências de teste
pip install pytest pytest-flask

# Criar testes em tests/
# Rodar testes
pytest
```

### Flutter

```dart
// Criar testes em test/
flutter test
```

---

## 📝 Tarefas Pendentes

### Backend ✅ COMPLETO
- [x] Modelos de dados
- [x] Endpoints de autenticação
- [x] Endpoints de usuário
- [x] Endpoints de dor
- [x] Estatísticas
- [x] Validações
- [x] Deploy guide

### Flutter ⚠️ AJUSTES NECESSÁRIOS
- [x] Modelos básicos (User, PainRecord)
- [x] Services básicos (Auth, Pain)
- [ ] Criar `UserPreferencesModel`
- [ ] Criar `PainStatisticsModel`
- [ ] Criar `PreferencesService`
- [ ] Adicionar `getStatistics()` no PainService
- [ ] Criar página de estatísticas
- [ ] Integrar preferências nas configurações
- [ ] Melhorar tratamento de erros
- [ ] Adicionar loading states
- [ ] Implementar refresh
- [ ] Adicionar cache local

---

## 📚 Documentação

- **`README.md`** - Introdução e setup rápido
- **`BACKEND_SPECIFICATION.md`** - Documentação completa da API
- **`DEPLOY_GUIDE.md`** - Guia de deploy no PythonAnywhere
- **`FLUTTER_INTEGRATION.md`** - Integração Flutter com API

---

## 🛠️ Tecnologias

### Backend
- Python 3.10+
- Flask 3.0
- SQLAlchemy (ORM)
- Flask-JWT-Extended
- Marshmallow (validação)
- MySQL
- PythonAnywhere (hosting)

### Frontend
- Flutter 3.x
- Dart
- Provider (state management)
- HTTP package
- SharedPreferences

---

## 🤝 Contribuindo

1. Fork o repositório
2. Crie uma branch (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

---

## 📞 Suporte

Para dúvidas:
- Consulte a documentação em cada arquivo `.md`
- Abra uma issue no GitHub
- Entre em contato com o time de desenvolvimento

---

## 📄 Licença

MIT License - Veja LICENSE para detalhes

---

## 🎉 Status do Projeto

### Backend: ✅ PRONTO PARA DEPLOY
- Todos os endpoints implementados
- Validações completas
- Pronto para PythonAnywhere

### Frontend: ⚠️ REQUER AJUSTES
- Estrutura base pronta
- Necessita implementar:
  - Modelos de preferências e estatísticas
  - Services adicionais
  - Página de estatísticas
  - Melhorias de UX

---

## 🔄 Próximos Passos

1. **Implementar ajustes no Flutter** (conforme `FLUTTER_INTEGRATION.md`)
2. **Deploy do backend** no PythonAnywhere
3. **Testar integração completa**
4. **Adicionar testes automatizados**
5. **Implementar notificações push**
6. **Adicionar modo offline**
7. **Criar documentação Swagger**
8. **Configurar CI/CD**
9. **Publicar na App Store / Play Store**

---

## ⭐ Features Futuras

- [ ] Refresh tokens
- [ ] Upload de fotos
- [ ] Relatórios em PDF
- [ ] Integração com wearables
- [ ] Modo offline com sincronização
- [ ] Notificações push
- [ ] Multi-idioma completo
- [ ] Gráficos avançados
- [ ] Export de dados
- [ ] Compartilhamento com médicos

---

**Desenvolvido com ❤️ para ajudar pacientes com osteoartrite**
