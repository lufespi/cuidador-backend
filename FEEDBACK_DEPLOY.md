# Instruções para Deploy do Sistema de Feedback!

## 📋 Resumo das Alterações

Este documento descreve as alterações necessárias no backend para implementar o sistema de feedback.

## 🗄️ 1. Executar Migration do Banco de Dados

Execute a migration para criar a tabela de feedback:

```bash
cd /home/lufespi/cuidador-backend
mysql -u lufespi -p lufespi$cuidador_homolog_db < scripts/migrations/004_create_feedback_table.sql
```

A migration irá criar a tabela `feedback` com os seguintes campos:
- `id` - INT AUTO_INCREMENT PRIMARY KEY
- `user_id` - INT NOT NULL (FK para users)
- `feedback_type` - VARCHAR(50) NOT NULL
- `name` - VARCHAR(255) (opcional)
- `email` - VARCHAR(255) (opcional)
- `message` - TEXT NOT NULL
- `created_at` - TIMESTAMP DEFAULT CURRENT_TIMESTAMP

## 🔧 2. Registrar Blueprint de Feedback

No arquivo WSGI do PythonAnywhere (`/var/www/lufespi_pythonanywhere_com_wsgi.py`), adicione o registro do blueprint de feedback:

```python
# Importar o blueprint de feedback
from api.routes.feedback import feedback_bp

# Registrar o blueprint
app.register_blueprint(feedback_bp, url_prefix='/api/v1')
```

### Exemplo Completo do WSGI:

```python
import sys
import os

# Add your project directory to the sys.path
project_home = '/home/lufespi/cuidador-backend'
if project_home not in sys.path:
    sys.path.insert(0, project_home)

# Set environment variables
os.environ['FLASK_ENV'] = 'production'

# Import your Flask app
from api.routes.auth import auth_bp
from api.routes.pain import pain_bp
from api.routes.admin import admin_bp
from api.routes.feedback import feedback_bp  # <-- ADICIONAR ESTA LINHA

from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})

# Register blueprints
app.register_blueprint(auth_bp, url_prefix='/api/v1')
app.register_blueprint(pain_bp, url_prefix='/api/v1')
app.register_blueprint(admin_bp, url_prefix='/api/v1')
app.register_blueprint(feedback_bp, url_prefix='/api/v1')  # <-- ADICIONAR ESTA LINHA

# This is used by PythonAnywhere
application = app
```

## 🚀 3. Fazer Deploy dos Arquivos

### 3.1 Commit e Push das Alterações

No seu ambiente local:

```bash
cd cuidador-backend
git add api/routes/feedback.py scripts/migrations/004_create_feedback_table.sql
git commit -m "feat: adicionar sistema de feedback com endpoints admin"
git push origin main
```

### 3.2 Pull no PythonAnywhere

No console Bash do PythonAnywhere:

```bash
cd /home/lufespi/cuidador-backend
git pull origin main
```

### 3.3 Reiniciar a Aplicação

1. Acesse: https://www.pythonanywhere.com/user/lufespi/webapps/
2. Clique em "Reload lufespi.pythonanywhere.com"

## ✅ 4. Verificar Instalação

### 4.1 Testar Endpoints

#### Enviar Feedback (Usuário autenticado)
```bash
curl -X POST https://lufespi.pythonanywhere.com/api/v1/feedback \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN" \
  -d '{
    "feedback_type": "suggestion",
    "message": "Teste de feedback",
    "name": "Nome Teste",
    "email": "teste@example.com"
  }'
```

#### Listar Feedbacks (Admin)
```bash
curl -X GET https://lufespi.pythonanywhere.com/api/v1/admin/feedback \
  -H "Authorization: Bearer TOKEN_ADMIN"
```

#### Buscar Feedback por ID (Admin)
```bash
curl -X GET https://lufespi.pythonanywhere.com/api/v1/admin/feedback/1 \
  -H "Authorization: Bearer TOKEN_ADMIN"
```

#### Deletar Feedback (Admin)
```bash
curl -X DELETE https://lufespi.pythonanywhere.com/api/v1/admin/feedback/1 \
  -H "Authorization: Bearer TOKEN_ADMIN"
```

### 4.2 Verificar Logs

Em caso de erro, verifique os logs:

```bash
tail -f /var/log/lufespi.pythonanywhere.com.error.log
```

## 📝 5. Endpoints Criados

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| POST | `/api/v1/feedback` | Envia feedback | Token |
| GET | `/api/v1/admin/feedback` | Lista todos feedbacks | Admin |
| GET | `/api/v1/admin/feedback/:id` | Busca feedback por ID | Admin |
| DELETE | `/api/v1/admin/feedback/:id` | Deleta feedback | Admin |

## 🎯 6. Próximos Passos

Após o deploy do backend:

1. ✅ Execute a migration no banco de dados
2. ✅ Atualize o arquivo WSGI
3. ✅ Faça pull das alterações
4. ✅ Reinicie a aplicação
5. ✅ Teste os endpoints
6. ✅ O app Flutter já está configurado para usar os novos endpoints!

## 🆘 Troubleshooting

### Erro: "feedback_bp not found"
- Verifique se o import está correto no WSGI
- Certifique-se que o arquivo `api/routes/feedback.py` existe

### Erro: "Table 'feedback' doesn't exist"
- Execute a migration: `mysql -u lufespi -p lufespi$cuidador_homolog_db < scripts/migrations/004_create_feedback_table.sql`

### Erro 500 nos endpoints
- Verifique os logs: `tail -f /var/log/lufespi.pythonanywhere.com.error.log`
- Verifique se as dependências estão instaladas

---

**Criado em:** 25/11/2024  
**Última atualização:** 25/11/2024
