# 🚀 Setup e Manutenção - CuidaDor Backend

> Guia rápido de setup inicial, atualizações e manutenção do backend.

## 📋 Índice

1. [Primeira Instalação](#primeira-instalação)
2. [Atualizar Código](#atualizar-código)
3. [Executar Migrações](#executar-migrações)
4. [Configurar Administradores](#configurar-administradores)
5. [Reset do Banco](#reset-do-banco)

---

## 1️⃣ Primeira Instalação

### No Console do PythonAnywhere:

```bash
# 1. Clonar repositório
cd ~
git clone https://github.com/lufespi/cuidador-backend.git
cd cuidador-backend

# 2. Criar ambiente virtual
mkvirtualenv --python=/usr/bin/python3.10 cuidador-env
workon cuidador-env

# 3. Instalar dependências
pip install -r requirements.txt

# 4. Configurar variáveis de ambiente
cp .env.example .env
nano .env  # Editar com credenciais reais

# 5. Executar migrações
cd scripts
python3 run_migrations.py

# 6. Configurar administradores (após usuários criarem contas)
python3 set_admins.py
```

### Na aba Web do PythonAnywhere:

1. **Add a new web app** → Manual configuration → Python 3.10
2. **Source code:** `/home/lufespi/cuidador-backend`
3. **Virtualenv:** `/home/lufespi/.virtualenvs/cuidador-env`
4. **WSGI configuration file:** Editar para apontar para `api/app.py`
5. **Reload** a aplicação

---

## 2️⃣ Atualizar Código

Quando houver novos commits no GitHub:

```bash
cd ~/cuidador-backend
git pull origin main
```

**Na aba Web:** Click em **"Reload lufespi.pythonanywhere.com"**

---

## 3️⃣ Executar Migrações

Sempre que houver novas migrações:

```bash
cd ~/cuidador-backend/scripts
python3 run_migrations.py
```

O script:
- ✅ Detecta migrações pendentes automaticamente
- ✅ Mostra preview antes de executar
- ✅ Pede confirmação (s/N)
- ✅ Registra histórico no banco

**Após migrações:** Reload na aba Web.

---

## 4️⃣ Configurar Administradores

### Administradores Padrão

Script automático para vincular 3 administradores:
- lufespi1221@gmail.com
- kauemuller@gmail.com
- carinasuzanacorrea@gmail.com

```bash
cd ~/cuidador-backend/scripts
python3 set_admins.py
```

**⚠️ Importante:** Usuários precisam criar conta no app primeiro!

### Adicionar Outros Administradores

Menu interativo para gerenciar qualquer usuário:

```bash
cd ~/cuidador-backend/scripts
python3 setup_admin_users.py
```

Opções:
1. Listar todos os usuários
2. Promover usuário a admin (por ID)
3. Remover privilégios de admin

---

## 5️⃣ Reset do Banco

⚠️ **CUIDADO:** Apaga TODOS os dados! Apenas para homologação!

```bash
cd ~/cuidador-backend/scripts

# Método 1: Executar SQL diretamente
mysql -h lufespi.mysql.pythonanywhere-services.com \
      -u lufespi \
      -p \
      lufespi$cuidador_homolog_db < reset_database.sql

# Método 2: Console MySQL interativo
mysql -h lufespi.mysql.pythonanywhere-services.com \
      -u lufespi \
      -p \
      lufespi$cuidador_homolog_db

# Depois copiar e colar o conteúdo de reset_database.sql
```

**Após reset:**
1. Executar migrações: `python3 run_migrations.py`
2. Reload na aba Web

---

## 🔍 Verificações Úteis

### Verificar Status dos Administradores

```sql
SELECT id, nome, email, is_admin, status 
FROM users 
WHERE is_admin = TRUE;
```

### Verificar Migrações Executadas

```sql
SELECT * FROM migrations ORDER BY executed_at DESC;
```

### Testar API

```bash
curl https://lufespi.pythonanywhere.com/health
```

Resposta esperada: `{"status": "healthy", "timestamp": "..."}`

---

## 📚 Documentação Adicional

- **[DEPLOY.md](DEPLOY.md)** - Guia completo de deploy no PythonAnywhere
- **[README.md](README.md)** - Documentação geral do projeto
- **[scripts/](scripts/)** - Scripts SQL e Python disponíveis

---

## 🆘 Troubleshooting

### Erro "Unknown column 'is_admin'"

Migração 002 não foi executada corretamente.

**Solução:**
```bash
cd ~/cuidador-backend/scripts
python3 run_migrations.py  # Re-executar migrações
```

### Erro "Access denied for user"

Credenciais incorretas no `.env`

**Solução:**
```bash
cd ~/cuidador-backend
nano .env  # Verificar DB_HOST, DB_USER, DB_PASSWORD, DB_NAME
```

### Aplicação não carrega após Reload

**Checklist:**
1. ✅ Virtualenv ativado? `workon cuidador-env`
2. ✅ Dependências instaladas? `pip list`
3. ✅ WSGI configurado corretamente?
4. ✅ Error log na aba Web do PythonAnywhere

---

**Versão:** 2.0.0  
**Última Atualização:** 25/11/2025
