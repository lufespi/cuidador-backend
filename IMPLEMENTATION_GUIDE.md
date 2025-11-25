# 🚀 Guia de Implementação e Atualização - CuidaDor Backend

> **Versão:** 2.0.0  
> **Data:** 25/11/2025  
> **Ambiente:** PythonAnywhere (lufespi.pythonanywhere.com)

---

## 📋 Índice

1. [Estrutura do Projeto](#estrutura-do-projeto)
2. [Primeira Instalação](#primeira-instalação)
3. [Atualizar Código Existente](#atualizar-código-existente)
4. [Executar Migrações](#executar-migrações)
5. [Gerenciar Administradores](#gerenciar-administradores)
6. [Reset do Banco (Homologação)](#reset-do-banco-homologação)
7. [Troubleshooting](#troubleshooting)

---

## 📁 Estrutura do Projeto

```
cuidador-backend/
├── api/                          # Código da aplicação
│   ├── middleware/               # Autenticação e middlewares
│   │   └── auth.py              # Decorators: @token_required, @admin_required
│   ├── models/                   # Modelos de dados
│   │   ├── user.py              # Modelo de usuário
│   │   └── pain_record.py       # Modelo de registro de dor
│   ├── routes/                   # Endpoints da API
│   │   ├── auth.py              # POST /register, /login, GET /me
│   │   ├── pain.py              # CRUD de registros de dor
│   │   └── admin.py             # Endpoints administrativos
│   ├── app.py                    # Factory da aplicação Flask
│   └── db.py                     # Conexão com banco de dados
│
├── config/                       # Configurações
│   └── settings.py              # Variáveis de ambiente e config
│
├── scripts/                      # Scripts utilitários
│   ├── migrations/              # Migrações SQL organizadas
│   │   ├── 001_initial_schema.sql
│   │   ├── 002_add_admin_field.sql
│   │   └── 003_add_body_parts.sql
│   ├── run_migrations.py        # Executor de migrações
│   ├── setup_admin_users.py     # Gerenciador de admins
│   └── reset_database.sql       # Reset completo (CUIDADO!)
│
├── utils/                        # Utilitários
│   └── jwt_handler.py           # Encode/decode JWT tokens
│
├── tests/                        # Testes automatizados
│   ├── test_auth.py
│   └── test_pain.py
│
├── .env.example                  # Exemplo de variáveis de ambiente
├── requirements.txt              # Dependências Python
└── README.md                     # Documentação principal
```

---

## 🆕 Primeira Instalação

### 1. Clonar Repositório

```bash
cd ~
git clone https://github.com/lufespi/cuidador-backend.git
cd cuidador-backend
```

### 2. Criar Ambiente Virtual (se não existir)

```bash
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# ou
venv\Scripts\activate     # Windows
```

### 3. Instalar Dependências

```bash
pip install -r requirements.txt
```

**Dependências principais:**
- Flask 3.0.0 - Framework web
- Flask-CORS 4.0.0 - Suporte a CORS
- PyMySQL 1.1.0 - Driver MySQL
- PyJWT 2.8.0 - Autenticação JWT
- bcrypt 4.1.2 - Hash de senhas
- reportlab 4.0.7 - Geração de PDFs
- python-dotenv 1.0.0 - Variáveis de ambiente

### 4. Configurar Variáveis de Ambiente

Crie arquivo `.env` baseado em `.env.example`:

```bash
cp .env.example .env
nano .env
```

Configurar:
```env
DB_HOST=lufespi.mysql.pythonanywhere-services.com
DB_USER=lufespi
DB_PASSWORD=sua_senha_aqui
DB_NAME=lufespi$cuidador_homolog_db

JWT_SECRET_KEY=sua_chave_secreta_aqui
FLASK_ENV=production
```

### 5. Executar Migrações Iniciais

```bash
cd scripts
python3 run_migrations.py
```

Confirme quando solicitado. O script executará todas as migrações pendentes.

### 6. Configurar WSGI (PythonAnywhere)

No arquivo `/var/www/lufespi_pythonanywhere_com_wsgi.py`:

```python
import sys
import os
from dotenv import load_dotenv

# Configurar path
path = '/home/lufespi/cuidador-backend'
if path not in sys.path:
    sys.path.insert(0, path)

# Carregar variáveis de ambiente
load_dotenv(os.path.join(path, '.env'))

# Importar aplicação
from api.app import create_app
application = create_app()
```

### 7. Reload da Aplicação

Na aba **Web** do PythonAnywhere, clique em:
**"Reload lufespi.pythonanywhere.com"**

Aguarde 15 segundos e teste:
```
https://lufespi.pythonanywhere.com/health
```

Resposta esperada: `{"status": "ok"}`

---

## 🔄 Atualizar Código Existente

### Método Rápido (Recomendado)

```bash
cd ~/cuidador-backend
git pull origin main
```

### Verificar Mudanças

```bash
git log -5 --oneline
git diff HEAD~1..HEAD
```

### Atualizar Dependências (se houver)

```bash
pip install -r requirements.txt --upgrade
```

### Reload Obrigatório

⚠️ **IMPORTANTE:** Após qualquer atualização de código, você DEVE recarregar a aplicação:

1. Vá para aba **Web** no PythonAnywhere
2. Clique em **"Reload lufespi.pythonanywhere.com"**
3. Aguarde 15 segundos

### Verificar Logs de Erro

Se algo der errado:

```bash
tail -n 50 /var/www/lufespi_pythonanywhere_com_error.log
```

Ou na aba **Web** → **Error log**

---

## 🗄️ Executar Migrações

### Verificar Status das Migrações

```bash
cd ~/cuidador-backend/scripts
python3 run_migrations.py
```

O script mostra:
- ✓ Migrações já executadas
- → Migrações pendentes
- Solicita confirmação antes de executar

### Criar Nova Migração

1. Crie arquivo em `scripts/migrations/` seguindo padrão:
   ```
   004_nome_descritivo.sql
   ```

2. Formato do arquivo:
   ```sql
   -- ============================================================================
   -- MIGRAÇÃO 004: Título Descritivo
   -- Data: YYYY-MM-DD
   -- Descrição: O que esta migração faz
   -- ============================================================================

   -- Seus comandos SQL aqui
   ALTER TABLE tabela ADD COLUMN nova_coluna VARCHAR(255);

   -- Registrar migração
   INSERT INTO migration_history (migration_name, description) 
   VALUES ('004_nome_descritivo', 'Descrição da migração')
   ON DUPLICATE KEY UPDATE executed_at = CURRENT_TIMESTAMP;
   ```

3. Execute:
   ```bash
   python3 run_migrations.py
   ```

### Histórico de Migrações

Para ver migrações executadas:

```sql
SELECT * FROM migration_history ORDER BY executed_at DESC;
```

---

## 👥 Gerenciar Administradores

### Configurar Administradores Padrão do Sistema

Para vincular os 3 administradores principais (lufespi, kaue, carina):

```bash
cd ~/cuidador-backend/scripts
python3 set_admins.py
```

O script irá:
- ✅ Verificar se os usuários existem (precisam ter conta criada)
- ✅ Promover automaticamente para administrador
- ✅ Mostrar lista final de todos os admins

**Ou via SQL direto:**
```bash
mysql -h lufespi.mysql.pythonanywhere-services.com \
      -u lufespi \
      -p \
      lufespi$cuidador_homolog_db < scripts/set_admins.sql
```

### Gerenciar Outros Administradores (Menu Interativo)

Para adicionar/remover outros usuários como admin:

```bash
cd ~/cuidador-backend/scripts
python3 setup_admin_users.py
```

O script oferece menu interativo:

```
📋 Total de usuários: 5

ID    Nome                          Email                         Admin    Status
--------------------------------------------------------------------------------
1     João Silva                    joao@email.com                ✗ NÃO    ativo
2     Maria Santos                  maria@email.com               ✓ SIM    ativo
3     Pedro Costa                   pedro@email.com               ✗ NÃO    ativo

OPÇÕES:
1. Adicionar administradores
2. Remover administradores
3. Sair
```

### Promover Usuários a Admin

Escolha opção **1** e digite IDs separados por vírgula:
```
IDs: 1,3
✅ 2 usuário(s) promovido(s) a administrador!
```

### Remover Privilégios de Admin

Escolha opção **2** e digite IDs:
```
IDs: 3
✅ 1 usuário(s) removido(s) da administração!
```

### Via SQL Direto

```sql
-- Promover usuário
UPDATE users SET is_admin = TRUE WHERE email = 'admin@email.com';

-- Listar admins
SELECT id, nome, email FROM users WHERE is_admin = TRUE;

-- Remover privilégios
UPDATE users SET is_admin = FALSE WHERE id = 5;
```

---

## 🔥 Reset do Banco (Homologação)

⚠️ **ATENÇÃO:** Este procedimento APAGA TODOS OS DADOS!  
✅ Use apenas em ambiente de **homologação/desenvolvimento**

### Via MySQL Console

1. Acesse MySQL:
   ```bash
   mysql -h lufespi.mysql.pythonanywhere-services.com \
         -u lufespi \
         -p \
         lufespi$cuidador_homolog_db
   ```

2. Execute o script de reset:
   ```sql
   source ~/cuidador-backend/scripts/reset_database.sql
   ```

3. Verifique:
   ```sql
   SHOW TABLES;
   SELECT COUNT(*) FROM users;
   SELECT COUNT(*) FROM pain_records;
   ```

### Ou Copie e Cole o SQL

Abra o arquivo `scripts/reset_database.sql` e execute todo o conteúdo no console MySQL.

### Após o Reset

1. **Execute as migrações:**
   ```bash
   cd ~/cuidador-backend/scripts
   python3 run_migrations.py
   ```

2. **Configure administradores:**
   ```bash
   python3 setup_admin_users.py
   ```

3. **Reload da aplicação** (sempre!)

---

## 🔧 Troubleshooting

### Erro: ImportError - Cannot import name 'get_db_connection'

**Causa:** Código do servidor está desatualizado

**Solução:**
```bash
cd ~/cuidador-backend
git pull origin main
# Clique em Reload na aba Web
```

---

### Erro: ModuleNotFoundError: No module named 'X'

**Causa:** Dependências não instaladas ou ambiente virtual errado

**Solução:**
```bash
cd ~/cuidador-backend
source venv/bin/activate  # Ativar ambiente virtual
pip install -r requirements.txt --upgrade
# Clique em Reload na aba Web
```

---

### Erro: Access denied for user

**Causa:** Credenciais incorretas no `.env`

**Solução:**
```bash
nano ~/cuidador-backend/.env
# Verificar DB_USER, DB_PASSWORD, DB_HOST, DB_NAME
# Clique em Reload na aba Web
```

---

### Erro 500 - Something went wrong

**Causa:** Erro no código Python

**Verificar logs:**
```bash
tail -n 100 /var/www/lufespi_pythonanywhere_com_error.log
```

**Ou na interface:** Aba Web → Error log (último link)

---

### Backend não responde após git pull

**Causa:** Esqueceu de fazer Reload

**Solução:**
1. Aba **Web** no PythonAnywhere
2. Clique em **"Reload lufespi.pythonanywhere.com"**
3. Aguarde 15-20 segundos
4. Teste: `https://lufespi.pythonanywhere.com/health`

---

### Migração falhou no meio

**Causa:** Erro de sintaxe SQL ou constraint violation

**Solução:**
```bash
# Ver histórico de migrações
mysql -h ... -u ... -p -e "SELECT * FROM migration_history"

# Se necessário, reverter manualmente:
mysql -h ... -u ... -p lufespi$cuidador_homolog_db
# Executar comandos inversos (DROP COLUMN, etc)

# Corrigir arquivo de migração e executar novamente
python3 run_migrations.py
```

---

### Permissões de Admin não funcionam

**Verificar:**
```sql
-- Campo is_admin existe?
SHOW COLUMNS FROM users LIKE 'is_admin';

-- Usuário tem privilégio?
SELECT id, email, is_admin FROM users WHERE email = 'seu@email.com';

-- Corrigir se necessário:
UPDATE users SET is_admin = TRUE WHERE email = 'seu@email.com';
```

---

## 📞 Suporte

### Verificar Saúde da API

```bash
curl https://lufespi.pythonanywhere.com/health
# Deve retornar: {"status":"ok"}
```

### Testar Autenticação

```bash
curl -X POST https://lufespi.pythonanywhere.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"seu@email.com","senha":"sua_senha"}'
```

### Logs em Tempo Real

```bash
tail -f /var/www/lufespi_pythonanywhere_com_error.log
```

---

## 📝 Checklist de Deploy

Antes de fazer deploy de uma nova feature:

- [ ] Código testado localmente
- [ ] Arquivo de migração criado (se necessário)
- [ ] `requirements.txt` atualizado (se houver novas dependências)
- [ ] Commit e push para GitHub
- [ ] `git pull` no PythonAnywhere
- [ ] Executar migrações pendentes
- [ ] **Reload da aplicação**
- [ ] Testar endpoint `/health`
- [ ] Testar funcionalidade nova
- [ ] Verificar error logs

---

## 🎯 Workflows Comuns

### Adicionar Novo Endpoint

1. Criar rota em `api/routes/nome.py`
2. Registrar blueprint em `api/app.py`
3. Testar localmente
4. Commit + Push
5. Pull no servidor + Reload

### Adicionar Campo na Tabela

1. Criar migração em `scripts/migrations/00X_nome.sql`
2. Atualizar model em `api/models/`
3. Commit + Push
4. Pull no servidor
5. Executar `python3 run_migrations.py`
6. Reload

### Corrigir Bug Urgente

1. Fix local e teste
2. Commit + Push
3. SSH no PythonAnywhere:
   ```bash
   cd ~/cuidador-backend && git pull origin main
   ```
4. **Reload** (crucial!)
5. Verificar logs

---

## 🚀 Comandos Rápidos

```bash
# Atualizar tudo
cd ~/cuidador-backend && git pull && python3 scripts/run_migrations.py

# Ver últimos erros
tail -n 50 /var/www/lufespi_pythonanywhere_com_error.log

# Listar admins
mysql -h ... -u ... -p -e "SELECT id, nome, email FROM lufespi\$cuidador_homolog_db.users WHERE is_admin = TRUE"

# Testar API
curl https://lufespi.pythonanywhere.com/health && echo "✅ API OK"
```

---

**Última atualização:** 25/11/2025  
**Mantido por:** Equipe CuidaDor  
**Repositório:** https://github.com/lufespi/cuidador-backend
