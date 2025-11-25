# 🔧 Sistema de Migrações - CuidaDor Backend

Este diretório contém o sistema de migrações do banco de dados.

## 📋 Estrutura

```
scripts/
├── migrations/           # Arquivos SQL de migração
│   ├── 002_add_admin_field.sql
│   ├── 003_add_body_parts.sql
│   └── 004_create_feedback_table.sql
└── run_migrations.py     # Script executor de migrações
```

## 🚀 Como Usar

### 1. Listar Migrações

Ver status de todas as migrações (executadas e pendentes):

```bash
python scripts/run_migrations.py --list
```

**Saída exemplo:**
```
====================================================================
📋 LISTAGEM DE MIGRAÇÕES
====================================================================

📊 Total de migrações: 3
   Executadas: 2
   Pendentes: 1

 ✅ EXECUTADA    | 002_add_admin_field.sql
 ✅ EXECUTADA    | 003_add_body_parts.sql
 ⏳ PENDENTE     | 004_create_feedback_table.sql
```

### 2. Executar Migrações Pendentes

Executar todas as migrações que ainda não foram aplicadas:

```bash
python scripts/run_migrations.py
```

**Fluxo de execução:**
1. Script se conecta ao banco de dados
2. Verifica quais migrações já foram executadas
3. Lista migrações pendentes
4. Solicita confirmação do usuário
5. Executa cada migração em ordem
6. Exibe resumo final

**Saída exemplo:**
```
====================================================================
🔧 SISTEMA DE MIGRAÇÕES - CuidaDor Backend
====================================================================

🔌 Conectando ao banco: lufespi$cuidador_homolog_db@lufespi.mysql...
✅ Conectado ao banco de dados

📊 Migrações já executadas: 2
   ✓ 002_add_admin_field
   ✓ 003_add_body_parts

📁 Arquivos de migração encontrados: 3

🔄 Migrações pendentes: 1
   → 004_create_feedback_table

====================================================================
Deseja executar as migrações pendentes? (s/N): s

====================================================================

🔄 Executando migração: 004_create_feedback_table
✅ Migração 004_create_feedback_table executada com sucesso!

====================================================================
📊 RESUMO DA EXECUÇÃO
====================================================================
✅ Sucesso: 1
❌ Falhas: 0
📝 Total processado: 1

🎉 Todas as migrações foram executadas com sucesso!
```

## 📝 Criando Nova Migração

### Convenção de Nomenclatura

Arquivos de migração devem seguir o padrão:

```
NNN_descricao_da_migracao.sql
```

Onde:
- `NNN` = número sequencial (ex: 005, 006, 007)
- `descricao` = descrição curta e clara

**Exemplos:**
- `005_add_user_preferences.sql`
- `006_create_notifications_table.sql`
- `007_update_user_schema.sql`

### Template de Migração

```sql
-- ============================================================================
-- MIGRAÇÃO NNN: Título Descritivo
-- Data: YYYY-MM-DD
-- Descrição: Descrição detalhada do que a migração faz
-- ============================================================================

-- Seu código SQL aqui
-- Use prepared statements para evitar erros de "já existe"

-- Exemplo: Adicionar coluna
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'nome_tabela' 
    AND COLUMN_NAME = 'nome_coluna'
);

SET @sql = IF(@column_exists = 0,
    'ALTER TABLE nome_tabela ADD COLUMN nome_coluna VARCHAR(255)',
    'SELECT "Coluna já existe" AS msg'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Mensagem de sucesso
SELECT 'Migração NNN executada com sucesso' AS status;
```

## 🗄️ Tabela de Controle

O sistema usa a tabela `migration_history` para rastrear migrações executadas:

```sql
CREATE TABLE migration_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    migration_name VARCHAR(255) NOT NULL UNIQUE,
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT
)
```

Esta tabela é criada automaticamente na primeira execução.

## ⚙️ Configuração

O script usa variáveis de ambiente do arquivo `.env`:

```env
DB_HOST=lufespi.mysql.pythonanywhere-services.com
DB_USER=lufespi
DB_PASSWORD=sua_senha
DB_NAME=lufespi$cuidador_homolog_db
```

## 🐍 Dependências

```bash
pip install pymysql python-dotenv
```

## 🆘 Troubleshooting

### Erro: "Can't connect to MySQL server"

**Problema:** Script não consegue conectar ao banco.

**Solução:**
1. Verifique credenciais no arquivo `.env`
2. Confirme que o servidor MySQL está acessível
3. Verifique firewall/permissões de rede

### Erro: "Table already exists"

**Problema:** Migração tenta criar tabela que já existe.

**Solução:**
- Isso é normal! O script ignora automaticamente erros de "já existe"
- Use prepared statements com `INFORMATION_SCHEMA` para verificações

### Migração Não Aparece como Pendente

**Problema:** Nova migração não é listada.

**Solução:**
1. Verifique se o arquivo está em `scripts/migrations/`
2. Confirme que a extensão é `.sql`
3. Verifique a numeração sequencial

### Como Reverter uma Migração?

**Problema:** Preciso desfazer uma migração.

**Solução:**
1. Crie uma nova migração com o código reverso
2. Exemplo: se `005_add_column.sql` adiciona coluna, crie `006_remove_column.sql`
3. **Nunca** delete registros da tabela `migration_history` manualmente

## 📚 Exemplos de Uso

### Desenvolvimento Local

```bash
# 1. Listar status
python scripts/run_migrations.py --list

# 2. Executar pendentes
python scripts/run_migrations.py
```

### Produção (PythonAnywhere)

```bash
# 1. Conectar via SSH/Console
ssh lufespi@ssh.pythonanywhere.com

# 2. Navegar para o projeto
cd ~/cuidador-backend

# 3. Ativar virtualenv
workon cuidador-env

# 4. Executar migrações
python scripts/run_migrations.py
```

## ✅ Boas Práticas

1. **Sempre teste localmente** antes de executar em produção
2. **Use transações** quando possível
3. **Documente** cada migração com comentários claros
4. **Não altere** migrações já executadas
5. **Faça backup** do banco antes de migrações grandes
6. **Numere sequencialmente** para manter ordem
7. **Use prepared statements** para evitar erros de duplicação

## 🔐 Segurança

- ⚠️ **Nunca** commite o arquivo `.env` com senhas reais
- ✅ Use `.env.example` como template
- ✅ Configure permissões adequadas nos arquivos
- ✅ Limite acesso ao banco de produção

---

**Última atualização:** 25/11/2024  
**Versão:** 1.0.0
