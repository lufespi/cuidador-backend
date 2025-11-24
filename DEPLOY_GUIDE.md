# 🚀 Guia Completo de Deploy - Backend CuidaDor

## 📋 Checklist Pré-Deploy

Antes de fazer o deploy, execute localmente:

```bash
# 1. Teste o backend
python test_backend.py

# 2. Verifique se não há erros
python -c "from api.app import create_app; app = create_app(); print('OK')"

# 3. Commit suas alterações
git add .
git commit -m "feat: atualização compatibilidade frontend"
git push origin main
```

---

## 🎯 Deploy no PythonAnywhere

### Passo 1: Acessar Console
1. Acesse [https://www.pythonanywhere.com](https://www.pythonanywhere.com)
2. Faça login na conta **lufespi**
3. Vá para aba **"Consoles"**
4. Abra um **Bash console**

### Passo 2: Navegar para o Diretório
```bash
cd ~/cuidador-backend
```

### Passo 3: Atualizar o Código
```bash
git pull origin main
```

**Saída esperada:**
```
remote: Enumerating objects: ...
Updating abc123..def456
Fast-forward
 api/routes/pain.py       | 30 ++++++++++++++++++++++++------
 api/models/pain_record.py| 25 +++++++++++++++++++------
 api/db.py                | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 12 deletions(-)
```

### Passo 4: Verificar Dependências (Opcional)
```bash
pip install --upgrade -r requirements.txt
```

### Passo 5: Testar Localmente (Opcional)
```bash
python3 -c "from api.app import create_app; app = create_app(); print('✅ Backend OK')"
```

### Passo 6: Recarregar Aplicação Web
1. Volte para o dashboard do PythonAnywhere
2. Vá para aba **"Web"**
3. Encontre **"lufespi.pythonanywhere.com"**
4. Clique no botão verde **"Reload lufespi.pythonanywhere.com"**

### Passo 7: Verificar Deploy
```bash
# No console do PythonAnywhere ou localmente:
curl https://lufespi.pythonanywhere.com/health
```

**Resposta esperada:**
```json
{"status":"ok"}
```

---

## 🔍 Testando os Novos Endpoints

### 1. Health Check
```bash
curl https://lufespi.pythonanywhere.com/health
```

### 2. Info da API
```bash
curl https://lufespi.pythonanywhere.com/
```

### 3. Criar Registro de Dor (requer autenticação)
```bash
curl -X POST https://lufespi.pythonanywhere.com/api/v1/pain/records \
  -H "Authorization: Bearer SEU_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "body_parts": ["cabeca:topo", "torso:pescoco"],
    "intensidade": 7,
    "descricao": "Dor após exercício",
    "data_registro": "2024-11-24T10:30:00"
  }'
```

**Resposta esperada:**
```json
{
  "id": "123",
  "user_id": "456",
  "body_parts": ["cabeca:topo", "torso:pescoco"],
  "intensidade": 7,
  "descricao": "Dor após exercício",
  "data_registro": "2024-11-24T10:30:00",
  "created_at": "2024-11-24T10:30:00",
  "updated_at": "2024-11-24T10:30:00"
}
```

### 4. Listar Registros (com filtros)
```bash
curl "https://lufespi.pythonanywhere.com/api/v1/pain/records?start_date=2024-11-01&limit=10" \
  -H "Authorization: Bearer SEU_TOKEN"
```

**Resposta esperada:**
```json
{
  "records": [
    {
      "id": "123",
      "user_id": "456",
      "body_parts": ["cabeca:topo"],
      "intensidade": 5,
      "descricao": "Dor leve",
      "data_registro": "2024-11-24T10:30:00"
    }
  ]
}
```

### 5. Buscar Registro Específico
```bash
curl https://lufespi.pythonanywhere.com/api/v1/pain/records/123 \
  -H "Authorization: Bearer SEU_TOKEN"
```

---

## 📊 Alterações Aplicadas

### ✅ Backend Atualizado

1. **Campos Renomeados:**
   - `observacoes` → `descricao`
   - `data` → `data_registro`

2. **Novos Campos:**
   - `created_at`: Timestamp de criação
   - `updated_at`: Timestamp de atualização
   - `data_registro`: Suporta data customizada

3. **Novos Endpoints:**
   - `GET /api/v1/pain/records/<id>` - Buscar registro específico

4. **Filtros Adicionados:**
   - `?start_date=2024-01-01` - Data inicial
   - `?end_date=2024-12-31` - Data final
   - `?limit=50` - Limite de resultados

5. **Migrações Automáticas:**
   - ✅ Renomeia colunas antigas automaticamente
   - ✅ Adiciona novas colunas
   - ✅ Migra dados existentes
   - ✅ Mantém compatibilidade

### 🔄 Compatibilidade com Frontend

O Flutter já está configurado para usar:
- ✅ Campo `descricao` (não `observacoes`)
- ✅ Campo `data_registro` (não `data`)
- ✅ Filtros por data
- ✅ Estrutura de resposta atualizada

**Nenhuma alteração necessária no app Flutter!** 🎉

---

## 🔧 Troubleshooting

### Erro: "No module named 'api'"
```bash
# Verifique se está no diretório correto
pwd
# Deve retornar: /home/lufespi/cuidador-backend

# Verifique estrutura
ls -la
```

### Erro: Conexão com Banco
```bash
# Verifique variáveis de ambiente
cat .env

# Teste conexão manualmente
python3 << EOF
from api.db import get_connection
conn = get_connection()
print("✅ Conexão OK")
conn.close()
EOF
```

### Erro: Migrações não Aplicadas
```bash
# Execute migrações manualmente
python3 << EOF
from api.app import create_app
app = create_app()
print("✅ Migrações aplicadas")
EOF
```

### Ver Logs de Erro
1. Aba "Web" no PythonAnywhere
2. Seção "Log files"
3. Clique em "Error log"

---

## 📝 Próximos Passos

Após deploy bem-sucedido:

1. ✅ Teste a API com Postman ou curl
2. ✅ Teste o app Flutter
3. ✅ Verifique se registros são salvos corretamente
4. ✅ Verifique se histórico carrega com filtros
5. ✅ Verifique se detalhes do registro funcionam

---

## 🎉 Pronto!

Seu backend está atualizado e compatível com o frontend Flutter!

**URL Base:** `https://lufespi.pythonanywhere.com`

**Versão API:** `v1`

**Status:** ✅ Online
