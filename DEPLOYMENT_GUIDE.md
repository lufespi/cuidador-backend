# Guia de Deploy - Backend Cuidador App

## Estrutura do Banco de Dados (PythonAnywhere)

### Tabela: pain_records

**Colunas Existentes:**
- `id` (INT, PRIMARY KEY)
- `user_id` (INT, FOREIGN KEY)
- `body_parts` (JSON) - **Adicionada via fix_body_parts.py**
- `intensity` (INT) - Escala 0-10
- `description` (TEXT) - Descrição da dor
- `timestamp` (TIMESTAMP) - Data/hora do registro
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

**Colunas Legacy (não utilizadas):**
- `body_part` (VARCHAR) - Coluna antiga, mantida por compatibilidade
- `symptoms` (TEXT) - Coluna antiga, mantida por compatibilidade
- `descricao` (TEXT) - Coluna antiga, mantida por compatibilidade

## Mapeamento Frontend ↔ Backend ↔ Database

### Frontend (Flutter) envia:
```json
{
  "body_parts": ["torax_frente_direita", "ombro_direito_frente"],
  "intensidade": 7,
  "descricao": "Dor persistente após exercício",
  "data_registro": "2024-11-24T10:30:00"
}
```

### Backend (routes) recebe e passa para model:
```python
PainRecord.create(
    user_id=request.user_id,
    body_parts=body_parts,      # Lista de strings
    intensidade=intensidade,    # Int 0-10
    descricao=descricao,        # String
    data_registro=data_registro # String ISO ou None
)
```

### Model mapeia para Database:
```python
INSERT INTO pain_records 
(user_id, body_parts, intensity, description, timestamp)
VALUES (user_id, JSON, intensidade, descricao, data_registro)
```

### Model normaliza resposta para Frontend:
```python
{
    'id': str(record['id']),
    'user_id': str(record['user_id']),
    'body_parts': json.loads(record['body_parts']),
    'intensidade': record['intensity'],          # DB: intensity → Frontend: intensidade
    'descricao': record['description'],          # DB: description → Frontend: descricao
    'data_registro': record['timestamp'],        # DB: timestamp → Frontend: data_registro
    'created_at': record['created_at'],
    'updated_at': record['updated_at']
}
```

## Instruções de Deploy

### 1. Verificar o banco de dados
```bash
# No console Python do PythonAnywhere
import pymysql
conn = pymysql.connect(host='...', user='...', password='...', database='...')
cursor = conn.cursor()
cursor.execute("SHOW COLUMNS FROM pain_records")
for col in cursor.fetchall():
    print(col)
```

### 2. Executar script de migração (se body_parts não existir)
```bash
cd ~/cuidador-backend
python3 fix_body_parts.py
```

**Saída esperada:**
```
✅ Coluna 'body_parts' adicionada com sucesso!
```

### 3. Atualizar código do backend
```bash
cd ~/cuidador-backend
git pull origin main
```

### 4. Recarregar aplicação
No painel PythonAnywhere:
- Web → Reload cuidador.pythonanywhere.com

### 5. Testar endpoints

**POST /api/v1/pain/records**
```bash
curl -X POST https://cuidador.pythonanywhere.com/api/v1/pain/records \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "body_parts": ["torax_frente_direita"],
    "intensidade": 7,
    "descricao": "Teste"
  }'
```

**GET /api/v1/pain/records**
```bash
curl https://cuidador.pythonanywhere.com/api/v1/pain/records \
  -H "Authorization: Bearer <TOKEN>"
```

## Arquivos Modificados

### api/models/pain_record.py
- ✅ `create()`: Usa colunas reais do DB (intensity, description, timestamp)
- ✅ `find_by_user()`: Normaliza resposta para frontend (intensidade, descricao, data_registro)
- ✅ `find_by_id()`: Normaliza resposta para frontend

### api/routes/pain.py
- ✅ Aceita parâmetros do Flutter: body_parts, intensidade, descricao, data_registro
- ✅ Passa corretamente para model
- ✅ Retorna resposta normalizada

### api/db.py
- ✅ `init_db()`: Simplificada - apenas verifica existência das tabelas
- ✅ Remove toda lógica de migração automática
- ⚠️ **Importante**: Não tenta mais modificar schema existente

### fix_body_parts.py
- ✅ Script one-time para adicionar coluna body_parts
- ✅ Já executado com sucesso no servidor

## Troubleshooting

### Erro: "Unknown column 'intensidade'"
**Causa**: Backend tentando usar nome de coluna que não existe
**Solução**: Código já corrigido - usa `intensity` no SQL

### Erro: "Unknown column 'body_parts'"
**Causa**: Coluna não existe na tabela
**Solução**: Executar `python3 fix_body_parts.py`

### Erro: "Data type mismatch"
**Causa**: body_parts não é JSON válido
**Solução**: Código já corrigido - converte lista para JSON string

### Erro: "500 Internal Server Error"
**Causa**: Vários possíveis
**Solução**: Verificar logs em PythonAnywhere → Web → Error log

## Checklist de Deploy

- [x] Coluna body_parts existe no banco
- [x] Código usa colunas corretas (intensity, description, timestamp)
- [x] Normalização frontend ↔ backend implementada
- [x] db.py não tenta mais alterar schema
- [ ] Código commitado e pushed para GitHub
- [ ] Pull executado no PythonAnywhere
- [ ] Aplicação recarregada
- [ ] Testes manuais realizados
- [ ] Flutter app testado end-to-end

## Observações Importantes

1. **Não deletar colunas antigas**: body_part, symptoms, descricao antigas devem ser mantidas por compatibilidade
2. **JSON válido**: body_parts sempre deve ser JSON string válido
3. **Timestamps**: Usar formato ISO 8601 nas comunicações
4. **Normalização**: Model faz toda conversão entre nomes de campos
5. **init_db()**: Agora apenas verifica, não modifica tabelas
