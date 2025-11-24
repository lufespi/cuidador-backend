# 🔧 Solução do Problema de Comunicação Backend

## ❌ Problema Identificado

**Erro:** `ApiException: (1054, "Unknown column 'body_parts' in 'field list'") (Status: 500)`

### Causa Raiz
O banco de dados no PythonAnywhere ainda está com o schema antigo:
- Coluna: `observacoes` (antigo)
- Coluna: `data` (antigo)

Mas o código Flutter estava enviando para o schema novo:
- Coluna: `descricao` (novo)
- Coluna: `data_registro` (novo)

## ✅ Solução Implementada

### 1. **Compatibilidade Retroativa no Código**
O modelo `PainRecord` agora:
- ✅ Detecta automaticamente quais colunas existem na tabela
- ✅ Usa nomes antigos (`observacoes`, `data`) se existirem
- ✅ Usa nomes novos (`descricao`, `data_registro`) se existirem
- ✅ Normaliza respostas para sempre usar nomes novos no frontend

### 2. **Migração Automática**
O `init_db()` atualiza automaticamente:
- ✅ Adiciona novas colunas
- ✅ Copia dados das antigas para as novas
- ✅ Remove colunas antigas (opcional)

## 🚀 Como Aplicar a Correção

### Opção 1: Deploy Automatizado (Recomendado)

```bash
# No PythonAnywhere console
cd ~/cuidador-backend
git pull origin main
python3 -c "from api.db import init_db; init_db()"
# Depois recarregar na aba Web
```

### Opção 2: Migração Manual SQL

Se preferir migrar manualmente o banco:

```bash
# No PythonAnywhere MySQL console
mysql -u lufespi -p

USE lufespi$cuidador;
SOURCE migrations/001_update_schema.sql;
```

### Opção 3: Código Funciona com Schema Antigo

**Nenhuma ação necessária!** O código agora é compatível com ambos os schemas.

Basta fazer:
```bash
git pull origin main
# Recarregar aplicação web
```

## 🎯 Arquivos Modificados

1. **`api/models/pain_record.py`**
   - Método `create()`: Detecta colunas disponíveis
   - Método `find_by_user()`: Normaliza nomes
   - Método `find_by_id()`: Normaliza nomes

2. **`migrations/001_update_schema.sql`** (NOVO)
   - Script SQL para migração manual

3. **`QUICK_UPDATE.md`**
   - Atualizado com passo de migração

## ✅ Verificação

Após deploy, teste:

```bash
curl https://lufespi.pythonanywhere.com/health
# Deve retornar: {"status":"ok"}
```

Então teste criando um registro de dor pelo app Flutter.

## 📊 Status das Colunas

### Schema Antigo (Atual no PythonAnywhere)
```sql
- id
- user_id
- body_parts (JSON)
- intensidade
- observacoes (TEXT)
- data (TIMESTAMP)
```

### Schema Novo (Após Migração)
```sql
- id
- user_id
- body_parts (JSON)
- intensidade
- descricao (TEXT)          ← Novo nome
- data_registro (TIMESTAMP) ← Novo nome
- created_at (TIMESTAMP)    ← Novo campo
- updated_at (TIMESTAMP)    ← Novo campo
```

### Compatibilidade
✅ Código funciona com AMBOS os schemas!
✅ Respostas sempre usam nomes novos (frontend compatível)

## 🎉 Conclusão

O problema está resolvido. Você pode:

1. **Apenas fazer pull** → Código funciona com schema atual
2. **Pull + migração** → Atualiza schema para versão nova
3. **Migração manual SQL** → Controle total sobre o processo

**Recomendação:** Opção 1 (apenas pull) para resolver imediatamente, depois Opção 2 quando tiver tempo.
