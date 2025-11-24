# 🚀 Guia Rápido de Atualização

## Para Atualizar o Backend no PythonAnywhere

### 1️⃣ **Acesse o Console do PythonAnywhere**
```bash
cd ~/cuidador-backend
```

### 2️⃣ **Atualize o Código**
```bash
git pull origin main
```

### 3️⃣ **Execute as Migrações do Banco**
```bash
python3 -c "from api.db import init_db; init_db()"
```

### 4️⃣ **Recarregue a Aplicação**
- Vá para a aba **"Web"**
- Clique no botão verde **"Reload lufespi.pythonanywhere.com"**

### ✅ **Pronto!**

---

## 🔍 Verificação

Teste a API:
```bash
curl https://lufespi.pythonanywhere.com/health
```

Deve retornar: `{"status": "ok"}`

---

## 📝 O que foi Alterado (Compatibilidade Frontend)

### Campos Renomeados
- `observacoes` → `descricao`
- `data` → `data_registro`

### Novos Recursos
- ✅ Filtros por data: `?start_date=2024-01-01&end_date=2024-12-31`
- ✅ Limite de registros: `?limit=50`
- ✅ Busca por ID: `GET /api/v1/pain/records/<id>`
- ✅ Data customizada no registro
- ✅ Timestamps automáticos (created_at, updated_at)

### Estrutura de Resposta

**POST `/api/v1/pain/records`** - Retorna objeto completo:
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

**GET `/api/v1/pain/records`** - Retorna array:
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

---

## 🔧 Troubleshooting

### Se houver erro após pull:
```bash
# Reinstale dependências
pip install -r requirements.txt

# Teste manualmente
python3 -c "from api.app import create_app; app = create_app(); print('OK')"
```

### Ver logs de erro:
- Aba "Web" → "Log files" → "Error log"

---

## 📊 Migrações Automáticas

O sistema aplica automaticamente:
- ✅ Cria novas colunas se não existirem
- ✅ Renomeia colunas antigas
- ✅ Adiciona índices para performance
- ✅ Migra dados existentes

**Nenhuma ação manual necessária!** 🎉
