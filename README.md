# 🏥 CuidaDor Backend

> Backend da aplicação CuidaDor - Sistema de gerenciamento de cuidados e acompanhamento de saúde.

[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/)
[![Flask](https://img.shields.io/badge/Flask-3.0.0-green.svg)](https://flask.palletsprojects.com/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange.svg)](https://www.mysql.com/)

**Versão:** 2.0.0  
**Stack:** Flask + MySQL + JWT  
**Deploy:** PythonAnywhere (lufespi.pythonanywhere.com)  
**Repositório:** https://github.com/lufespi/cuidador-backend

---

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Instalação](#instalação)
- [API Endpoints](#api-endpoints)
- [Migrações](#migrações)
- [Deploy](#deploy)
- [Documentação Completa](#documentação-completa)

---

## 🎯 Visão Geral

O CuidaDor Backend é uma API RESTful construída com Flask que gerencia:

- ✅ Autenticação de usuários (JWT)
- ✅ Registro de dor e sintomas
- ✅ Painel administrativo
- ✅ Geração de relatórios em PDF
- ✅ Gestão de múltiplos pacientes

### Features Principais

- 🔐 **Autenticação JWT** - Sistema seguro de tokens
- 👥 **Multi-tenant** - Suporte para múltiplos usuários/pacientes
- 📊 **Relatórios PDF** - Exportação de dados históricos
- 🏥 **Registro Detalhado** - Intensidade, partes do corpo, descrições
- 🔧 **Admin Panel** - Gestão de usuários e sistema
- 🗄️ **Migrações Automáticas** - Sistema organizado de versionamento do banco

---

## 📁 Estrutura do Projeto

```
cuidador-backend/
├── api/                          # Código da aplicação
│   ├── middleware/               # Autenticação e middlewares
│   ├── models/                   # Modelos de dados (User, PainRecord)
│   ├── routes/                   # Endpoints da API
│   ├── app.py                    # Factory da aplicação Flask
│   └── db.py                     # Conexão com banco de dados
│
├── config/                       # Configurações e variáveis de ambiente
├── scripts/                      # Scripts utilitários
│   ├── migrations/              # Migrações SQL organizadas
│   ├── run_migrations.py        # Executor de migrações
│   ├── setup_admin_users.py     # Gerenciador de admins
│   └── reset_database.sql       # Reset completo (homologação)
│
├── utils/                        # JWT handler e utilitários
├── tests/                        # Testes automatizados
└── IMPLEMENTATION_GUIDE.md       # 📘 Guia completo de implementação
```

---

## 🚀 Instalação

### 1. Clone o Repositório

```bash
git clone https://github.com/lufespi/cuidador-backend.git
cd cuidador-backend
```

### 2. Crie Ambiente Virtual

```bash
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# ou
venv\Scripts\activate     # Windows
```

### 3. Instale Dependências

```bash
pip install -r requirements.txt
```

### 4. Configure Ambiente

```bash
cp .env.example .env
# Edite o .env com suas configurações
```

### 5. Execute Migrações

```bash
cd scripts
python3 run_migrations.py
```

### 6. Inicie o Servidor

```bash
python api/app.py
```

---

## 🌐 API Endpoints

### Autenticação

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| POST | `/api/v1/auth/register` | Registrar novo usuário | ❌ |
| POST | `/api/v1/auth/login` | Login e obter token JWT | ❌ |
| GET | `/api/v1/auth/me` | Obter dados do usuário logado | ✅ |
| PATCH | `/api/v1/auth/me` | Atualizar perfil do usuário | ✅ |

### Registros de Dor

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| POST | `/api/v1/pain` | Criar novo registro de dor | ✅ |
| GET | `/api/v1/pain` | Listar registros do usuário | ✅ |
| GET | `/api/v1/pain/:id` | Obter registro específico | ✅ |
| PUT | `/api/v1/pain/:id` | Atualizar registro | ✅ |
| DELETE | `/api/v1/pain/:id` | Deletar registro | ✅ |

### Admin (requer `is_admin = true`)

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| GET | `/api/v1/admin/users` | Listar todos os usuários | 🔑 Admin |
| GET | `/api/v1/admin/users/:id` | Detalhes de um usuário | 🔑 Admin |
| POST | `/api/v1/admin/users/:id/reset-password` | Resetar senha | 🔑 Admin |
| GET | `/api/v1/admin/users/:id/export` | Exportar PDF do usuário | 🔑 Admin |

### Health Check

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| GET | `/health` | Status da API | ❌ |
| GET | `/` | Info da API | ❌ |

---

## 🗄️ Migrações

### Executar Migrações Pendentes

```bash
cd scripts
python3 run_migrations.py
```

O script:
- ✅ Verifica migrações já executadas
- ✅ Lista migrações pendentes
- ✅ Solicita confirmação
- ✅ Executa em ordem sequencial
- ✅ Registra histórico

### Criar Nova Migração

1. Crie arquivo em `scripts/migrations/`:
   ```
   004_nome_descritivo.sql
   ```

2. Siga o formato padrão (veja exemplos existentes)

3. Execute `python3 run_migrations.py`

---

## 🚀 Deploy (PythonAnywhere)

### Quick Deploy

```bash
cd ~/cuidador-backend
git pull origin main
# Clique em "Reload" na aba Web do PythonAnywhere
```

### Troubleshooting

```bash
# Ver logs de erro
tail -n 50 /var/www/lufespi_pythonanywhere_com_error.log

# Testar API
curl https://lufespi.pythonanywhere.com/health
```

---

## 📘 Documentação Completa

Para guia detalhado de implementação, atualização, troubleshooting e workflows:

👉 **[IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)**

Inclui:
- ✅ Primeira instalação passo a passo
- ✅ Como atualizar código existente
- ✅ Executar e criar migrações
- ✅ Gerenciar administradores
- ✅ Reset do banco de dados
- ✅ Troubleshooting completo
- ✅ Workflows comuns
- ✅ Checklist de deploy

---

## 🔒 Segurança

- 🔐 Senhas criptografadas com bcrypt
- 🎫 Autenticação JWT com expiração
- 🛡️ Validação de dados em todos os endpoints
- 🚫 CORS configurado corretamente
- 🔑 Separação de privilégios (user/admin)

---

## 📞 Suporte

**API URL:** https://lufespi.pythonanywhere.com  
**Health Check:** https://lufespi.pythonanywhere.com/health  
**Repositório:** https://github.com/lufespi/cuidador-backend

Para questões técnicas, consulte [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)

---

**Última atualização:** 25/11/2025  
**Versão:** 2.0.0
