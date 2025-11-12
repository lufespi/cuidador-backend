# 🧪 Exemplos de Requisições - Cuidador API

## 📋 Coleção Postman / Thunder Client

Exemplos práticos de todas as requisições da API.

---

## 🔧 Configuração

### Variáveis de Ambiente

```
BASE_URL = http://localhost:5000/api/v1
# ou
BASE_URL = https://seuusuario.pythonanywhere.com/api/v1

TOKEN = (será preenchido após login)
```

---

## 1️⃣ Autenticação

### 1.1. Registrar Novo Usuário

**Request:**
```http
POST {{BASE_URL}}/auth/register
Content-Type: application/json

{
  "email": "joao.silva@exemplo.com",
  "password": "senha123",
  "first_name": "João",
  "last_name": "Silva",
  "birth_date": "1980-05-15",
  "phone": "+5511999999999",
  "gender": "male"
}
```

**Response (201 Created):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcwMDAwMDAwMCwianRpIjoiMTIzNDU2NzgiLCJ0eXBlIjoiYWNjZXNzIiwic3ViIjoxLCJuYmYiOjE3MDAwMDAwMDAsImV4cCI6MTcwMjU5MjAwMH0.abc123",
  "user": {
    "id": 1,
    "email": "joao.silva@exemplo.com",
    "first_name": "João",
    "last_name": "Silva",
    "birth_date": "1980-05-15",
    "phone": "+5511999999999",
    "gender": "male",
    "created_at": "2025-11-12T10:30:00.000000",
    "updated_at": "2025-11-12T10:30:00.000000"
  }
}
```

**Salvar TOKEN da resposta!**

---

### 1.2. Login

**Request:**
```http
POST {{BASE_URL}}/auth/login
Content-Type: application/json

{
  "email": "joao.silva@exemplo.com",
  "password": "senha123"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "joao.silva@exemplo.com",
    "first_name": "João",
    "last_name": "Silva",
    "birth_date": "1980-05-15",
    "phone": "+5511999999999",
    "gender": "male",
    "created_at": "2025-11-12T10:30:00.000000",
    "updated_at": "2025-11-12T10:30:00.000000"
  }
}
```

---

### 1.3. Obter Usuário Atual

**Request:**
```http
GET {{BASE_URL}}/auth/me
Authorization: Bearer {{TOKEN}}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "email": "joao.silva@exemplo.com",
  "first_name": "João",
  "last_name": "Silva",
  "birth_date": "1980-05-15",
  "phone": "+5511999999999",
  "gender": "male",
  "created_at": "2025-11-12T10:30:00.000000",
  "updated_at": "2025-11-12T10:30:00.000000"
}
```

---

## 2️⃣ Perfil do Usuário

### 2.1. Obter Perfil

**Request:**
```http
GET {{BASE_URL}}/user/profile
Authorization: Bearer {{TOKEN}}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "email": "joao.silva@exemplo.com",
  "first_name": "João",
  "last_name": "Silva",
  "birth_date": "1980-05-15",
  "phone": "+5511999999999",
  "gender": "male",
  "created_at": "2025-11-12T10:30:00.000000",
  "updated_at": "2025-11-12T10:30:00.000000"
}
```

---

### 2.2. Atualizar Perfil

**Request:**
```http
PUT {{BASE_URL}}/user/profile
Authorization: Bearer {{TOKEN}}
Content-Type: application/json

{
  "first_name": "João Pedro",
  "last_name": "Silva Santos",
  "phone": "+5511988888888"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "email": "joao.silva@exemplo.com",
  "first_name": "João Pedro",
  "last_name": "Silva Santos",
  "birth_date": "1980-05-15",
  "phone": "+5511988888888",
  "gender": "male",
  "created_at": "2025-11-12T10:30:00.000000",
  "updated_at": "2025-11-12T15:45:00.000000"
}
```

---

## 3️⃣ Preferências do Usuário

### 3.1. Obter Preferências

**Request:**
```http
GET {{BASE_URL}}/user/preferences
Authorization: Bearer {{TOKEN}}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "user_id": 1,
  "language": "pt",
  "theme": "light",
  "notifications_enabled": true,
  "notification_time": "09:00:00",
  "created_at": "2025-11-12T10:30:00.000000",
  "updated_at": "2025-11-12T10:30:00.000000"
}
```

---

### 3.2. Atualizar Preferências

**Request:**
```http
PUT {{BASE_URL}}/user/preferences
Authorization: Bearer {{TOKEN}}
Content-Type: application/json

{
  "language": "en",
  "theme": "dark",
  "notifications_enabled": true,
  "notification_time": "08:30:00"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "user_id": 1,
  "language": "en",
  "theme": "dark",
  "notifications_enabled": true,
  "notification_time": "08:30:00",
  "created_at": "2025-11-12T10:30:00.000000",
  "updated_at": "2025-11-12T16:00:00.000000"
}
```

---

## 4️⃣ Registros de Dor

### 4.1. Criar Registro de Dor

**Request:**
```http
POST {{BASE_URL}}/pain
Authorization: Bearer {{TOKEN}}
Content-Type: application/json

{
  "body_part": "left_knee",
  "intensity": 7,
  "description": "Dor ao subir escadas, piora pela manhã",
  "symptoms": ["stiffness", "swelling"],
  "timestamp": "2025-11-12T14:30:00Z"
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "user_id": 1,
  "body_part": "left_knee",
  "intensity": 7,
  "description": "Dor ao subir escadas, piora pela manhã",
  "symptoms": ["stiffness", "swelling"],
  "timestamp": "2025-11-12T14:30:00",
  "created_at": "2025-11-12T14:30:00.000000",
  "updated_at": "2025-11-12T14:30:00.000000"
}
```

---

### 4.2. Listar Registros (Paginado)

**Request:**
```http
GET {{BASE_URL}}/pain?page=1&per_page=20
Authorization: Bearer {{TOKEN}}
```

**Response (200 OK):**
```json
{
  "items": [
    {
      "id": 3,
      "user_id": 1,
      "body_part": "right_knee",
      "intensity": 6,
      "description": "Dor leve ao caminhar",
      "symptoms": ["stiffness"],
      "timestamp": "2025-11-12T16:00:00",
      "created_at": "2025-11-12T16:00:00.000000",
      "updated_at": "2025-11-12T16:00:00.000000"
    },
    {
      "id": 2,
      "user_id": 1,
      "body_part": "torso",
      "intensity": 4,
      "description": "Desconforto na região lombar",
      "symptoms": ["stiffness", "limited_movement"],
      "timestamp": "2025-11-12T15:00:00",
      "created_at": "2025-11-12T15:00:00.000000",
      "updated_at": "2025-11-12T15:00:00.000000"
    },
    {
      "id": 1,
      "user_id": 1,
      "body_part": "left_knee",
      "intensity": 7,
      "description": "Dor ao subir escadas",
      "symptoms": ["stiffness", "swelling"],
      "timestamp": "2025-11-12T14:30:00",
      "created_at": "2025-11-12T14:30:00.000000",
      "updated_at": "2025-11-12T14:30:00.000000"
    }
  ],
  "total": 3,
  "page": 1,
  "per_page": 20,
  "pages": 1
}
```

---

### 4.3. Listar com Filtros

**Request:**
```http
GET {{BASE_URL}}/pain?start_date=2025-11-01&end_date=2025-11-30&min_intensity=5&body_part=left_knee
Authorization: Bearer {{TOKEN}}
```

---

### 4.4. Obter Registro Específico

**Request:**
```http
GET {{BASE_URL}}/pain/1
Authorization: Bearer {{TOKEN}}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "user_id": 1,
  "body_part": "left_knee",
  "intensity": 7,
  "description": "Dor ao subir escadas",
  "symptoms": ["stiffness", "swelling"],
  "timestamp": "2025-11-12T14:30:00",
  "created_at": "2025-11-12T14:30:00.000000",
  "updated_at": "2025-11-12T14:30:00.000000"
}
```

---

### 4.5. Atualizar Registro

**Request:**
```http
PUT {{BASE_URL}}/pain/1
Authorization: Bearer {{TOKEN}}
Content-Type: application/json

{
  "intensity": 5,
  "description": "Dor melhorou após medicação"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "user_id": 1,
  "body_part": "left_knee",
  "intensity": 5,
  "description": "Dor melhorou após medicação",
  "symptoms": ["stiffness", "swelling"],
  "timestamp": "2025-11-12T14:30:00",
  "created_at": "2025-11-12T14:30:00.000000",
  "updated_at": "2025-11-12T18:00:00.000000"
}
```

---

### 4.6. Deletar Registro

**Request:**
```http
DELETE {{BASE_URL}}/pain/1
Authorization: Bearer {{TOKEN}}
```

**Response (204 No Content):**
```
(sem corpo na resposta)
```

---

## 5️⃣ Estatísticas

### 5.1. Obter Estatísticas (Últimos 30 dias)

**Request:**
```http
GET {{BASE_URL}}/pain/statistics
Authorization: Bearer {{TOKEN}}
```

**Response (200 OK):**
```json
{
  "period": {
    "start_date": "2025-10-13",
    "end_date": "2025-11-12"
  },
  "total_records": 45,
  "average_intensity": 6.2,
  "most_affected_parts": [
    {
      "body_part": "left_knee",
      "count": 15
    },
    {
      "body_part": "right_knee",
      "count": 12
    },
    {
      "body_part": "torso",
      "count": 8
    },
    {
      "body_part": "left_hand",
      "count": 5
    },
    {
      "body_part": "right_hand",
      "count": 5
    }
  ],
  "intensity_distribution": {
    "1-3": 5,
    "4-6": 20,
    "7-10": 20
  },
  "common_symptoms": [
    {
      "symptom": "stiffness",
      "count": 30
    },
    {
      "symptom": "swelling",
      "count": 25
    },
    {
      "symptom": "limited_movement",
      "count": 15
    },
    {
      "symptom": "redness",
      "count": 8
    },
    {
      "symptom": "warmth",
      "count": 5
    }
  ]
}
```

---

### 5.2. Estatísticas com Período Customizado

**Request:**
```http
GET {{BASE_URL}}/pain/statistics?start_date=2025-11-01&end_date=2025-11-15
Authorization: Bearer {{TOKEN}}
```

---

## ⚠️ Exemplos de Erros

### Erro 400 - Bad Request (Validação)

**Request:**
```http
POST {{BASE_URL}}/auth/register
Content-Type: application/json

{
  "email": "email-invalido",
  "password": "123",
  "first_name": "J"
}
```

**Response (400 Bad Request):**
```json
{
  "error": "Validation error",
  "messages": {
    "email": ["Not a valid email address."],
    "password": ["Shorter than minimum length 6."],
    "first_name": ["Shorter than minimum length 2."],
    "last_name": ["Missing data for required field."]
  }
}
```

---

### Erro 401 - Unauthorized (Token inválido)

**Request:**
```http
GET {{BASE_URL}}/auth/me
Authorization: Bearer token-invalido
```

**Response (401 Unauthorized):**
```json
{
  "error": "Invalid or expired token",
  "message": "Signature verification failed"
}
```

---

### Erro 404 - Not Found

**Request:**
```http
GET {{BASE_URL}}/pain/9999
Authorization: Bearer {{TOKEN}}
```

**Response (404 Not Found):**
```json
{
  "error": "Pain record not found"
}
```

---

### Erro 409 - Conflict (Email já existe)

**Request:**
```http
POST {{BASE_URL}}/auth/register
Content-Type: application/json

{
  "email": "joao.silva@exemplo.com",
  "password": "senha123",
  "first_name": "João",
  "last_name": "Silva"
}
```

**Response (409 Conflict):**
```json
{
  "error": "Email already registered"
}
```

---

## 🧪 Scripts de Teste (cURL)

### Teste Completo (Linux/Mac)

```bash
#!/bin/bash

BASE_URL="http://localhost:5000/api/v1"

# 1. Registrar
echo "1. Registrando usuário..."
REGISTER_RESPONSE=$(curl -s -X POST $BASE_URL/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@exemplo.com",
    "password": "senha123",
    "first_name": "Teste",
    "last_name": "Usuario",
    "birth_date": "1990-01-01",
    "gender": "male"
  }')

TOKEN=$(echo $REGISTER_RESPONSE | jq -r '.token')
echo "Token: $TOKEN"

# 2. Login
echo -e "\n2. Fazendo login..."
LOGIN_RESPONSE=$(curl -s -X POST $BASE_URL/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@exemplo.com",
    "password": "senha123"
  }')

TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.token')
echo "Login OK"

# 3. Criar registro de dor
echo -e "\n3. Criando registro de dor..."
curl -s -X POST $BASE_URL/pain \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "body_part": "left_knee",
    "intensity": 7,
    "description": "Dor ao subir escadas",
    "symptoms": ["stiffness", "swelling"]
  }' | jq

# 4. Listar registros
echo -e "\n4. Listando registros..."
curl -s -X GET "$BASE_URL/pain?page=1&per_page=10" \
  -H "Authorization: Bearer $TOKEN" | jq

# 5. Obter estatísticas
echo -e "\n5. Obtendo estatísticas..."
curl -s -X GET $BASE_URL/pain/statistics \
  -H "Authorization: Bearer $TOKEN" | jq

echo -e "\n✅ Testes concluídos!"
```

### Teste Completo (PowerShell - Windows)

```powershell
$BASE_URL = "http://localhost:5000/api/v1"

# 1. Registrar
Write-Host "1. Registrando usuário..." -ForegroundColor Cyan
$registerBody = @{
    email = "teste@exemplo.com"
    password = "senha123"
    first_name = "Teste"
    last_name = "Usuario"
    birth_date = "1990-01-01"
    gender = "male"
} | ConvertTo-Json

$registerResponse = Invoke-RestMethod -Uri "$BASE_URL/auth/register" `
    -Method Post `
    -ContentType "application/json" `
    -Body $registerBody

$TOKEN = $registerResponse.token
Write-Host "Token obtido!" -ForegroundColor Green

# 2. Criar registro de dor
Write-Host "`n2. Criando registro de dor..." -ForegroundColor Cyan
$painBody = @{
    body_part = "left_knee"
    intensity = 7
    description = "Dor ao subir escadas"
    symptoms = @("stiffness", "swelling")
} | ConvertTo-Json

$headers = @{
    "Authorization" = "Bearer $TOKEN"
    "Content-Type" = "application/json"
}

$painResponse = Invoke-RestMethod -Uri "$BASE_URL/pain" `
    -Method Post `
    -Headers $headers `
    -Body $painBody

Write-Host "Registro criado: ID $($painResponse.id)" -ForegroundColor Green

# 3. Listar registros
Write-Host "`n3. Listando registros..." -ForegroundColor Cyan
$listResponse = Invoke-RestMethod -Uri "$BASE_URL/pain?page=1&per_page=10" `
    -Method Get `
    -Headers $headers

Write-Host "Total de registros: $($listResponse.total)" -ForegroundColor Green

Write-Host "`n✅ Testes concluídos!" -ForegroundColor Green
```

---

## 📦 Importar para Postman

1. Crie um arquivo `cuidador-api.postman_collection.json`
2. Copie a estrutura acima
3. Importe no Postman
4. Configure as variáveis de ambiente

---

## 🔗 Links Úteis

- **Postman:** https://www.postman.com/
- **Thunder Client (VS Code):** https://www.thunderclient.com/
- **HTTPie:** https://httpie.io/
- **Insomnia:** https://insomnia.rest/

---

**Dica:** Salve o TOKEN após login/registro para usar em todas as requisições autenticadas!
