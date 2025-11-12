# 🚀 Guia Rápido de Início - Cuidador App

## ⚡ Início Rápido em 5 Minutos

### Backend (Flask)

```bash
# 1. Clone e entre na pasta
git clone https://github.com/seu-usuario/cuidador-backend.git
cd cuidador-backend

# 2. Crie virtualenv (Windows)
python -m venv venv
venv\Scripts\activate

# 3. Instale dependências
pip install -r requirements.txt

# 4. Configure variáveis
copy .env.example .env
# Edite .env com suas configurações

# 5. Crie banco de dados
# No MySQL: CREATE DATABASE cuidador_db;

# 6. Execute migrations
flask db init
flask db migrate -m "Initial"
flask db upgrade

# 7. Rode o servidor
flask run

# ✅ API rodando em http://localhost:5000
```

### Frontend (Flutter)

```bash
# 1. Clone e entre na pasta
git clone https://github.com/seu-usuario/cuidador-app.git
cd cuidador-app

# 2. Instale dependências
flutter pub get

# 3. Atualize API URL
# Edite: lib/core/constants/api_constants.dart
# baseUrl = 'http://SEU_IP:5000/api/v1'

# 4. Rode o app
flutter run

# ✅ App rodando no emulador/device
```

---

## 🎯 Teste Rápido

### 1. Registre um usuário

```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
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

**Copie o TOKEN retornado!**

### 2. Crie um registro de dor

```bash
curl -X POST http://localhost:5000/api/v1/pain \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN" \
  -d '{
    "body_part": "left_knee",
    "intensity": 7,
    "description": "Dor ao subir escadas",
    "symptoms": ["stiffness", "swelling"]
  }'
```

### 3. Liste os registros

```bash
curl -X GET http://localhost:5000/api/v1/pain \
  -H "Authorization: Bearer SEU_TOKEN"
```

---

## 📁 Estrutura do Projeto

```
cuidador-backend/               # Backend API (Flask)
├── app/
│   ├── models/                 # Modelos de dados
│   ├── routes/                 # Endpoints
│   ├── schemas/                # Validações
│   └── utils/                  # Utilitários
├── requirements.txt
├── wsgi.py
└── *.md                        # Documentação

cuidador-app/                   # Mobile App (Flutter)
├── lib/
│   ├── core/
│   │   ├── models/
│   │   ├── services/
│   │   └── constants/
│   └── screens/
└── pubspec.yaml
```

---

## 🔑 Endpoints Principais

### Autenticação
- `POST /auth/register` - Registrar
- `POST /auth/login` - Login
- `GET /auth/me` - Usuário atual

### Dor
- `POST /pain` - Criar registro
- `GET /pain` - Listar (paginado)
- `GET /pain/statistics` - Estatísticas

### Usuário
- `GET /user/profile` - Perfil
- `PUT /user/profile` - Atualizar perfil
- `GET /user/preferences` - Preferências

---

## 📚 Documentação Completa

- **API Completa:** `BACKEND_SPECIFICATION.md`
- **Deploy:** `DEPLOY_GUIDE.md`
- **Integração Flutter:** `FLUTTER_INTEGRATION.md`
- **Exemplos:** `API_EXAMPLES.md`
- **Checklist:** `CHECKLIST.md`

---

## 🆘 Problemas Comuns

### Backend não inicia
```bash
# Verifique se o MySQL está rodando
# Verifique as credenciais no .env
# Reinstale as dependências: pip install -r requirements.txt
```

### Erro de CORS no Flutter
```dart
// No api_constants.dart, use o IP correto:
// Android Emulator: http://10.0.2.2:5000/api/v1
// iOS Simulator: http://localhost:5000/api/v1
// Device Real: http://SEU_IP_LOCAL:5000/api/v1
```

### Erro 401 (Unauthorized)
```bash
# Verifique se o token está correto
# Verifique se o token não expirou
# Faça login novamente para obter novo token
```

---

## 🚀 Deploy Rápido (PythonAnywhere)

```bash
# 1. Acesse PythonAnywhere
# 2. Abra console Bash
cd ~
git clone https://github.com/seu-usuario/cuidador-backend.git
cd cuidador-backend

# 3. Crie virtualenv
mkvirtualenv --python=/usr/bin/python3.10 cuidador-env
pip install -r requirements.txt

# 4. Configure .env
nano .env
# Adicione as variáveis

# 5. Configure Web App no dashboard
# 6. Configure WSGI file
# 7. Reload

# ✅ API online em https://seuusuario.pythonanywhere.com
```

---

## 🎯 Próximos Passos

1. ✅ **Backend está pronto!** Faça o deploy
2. ⚠️ **Flutter precisa de ajustes:** Veja `FLUTTER_INTEGRATION.md`
3. 🧪 **Teste a integração completa**
4. 🚀 **Publique o app**

---

## 💡 Dicas

- Use Postman para testar a API
- Salve o TOKEN após login
- Consulte `API_EXAMPLES.md` para exemplos
- Leia `DEPLOY_GUIDE.md` antes de fazer deploy
- Mantenha o `.env` seguro (nunca commite!)

---

## 📞 Ajuda

- 📖 Leia a documentação completa
- 🐛 Abra uma issue no GitHub
- 💬 Contate o time de desenvolvimento

---

**Boa sorte! 🎉**

Desenvolvido com ❤️ para ajudar pacientes com osteoartrite.
