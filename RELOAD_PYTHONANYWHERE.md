# RECARREGAR APLICAÇÃO NO PYTHONANYWHERE

## Problema
Após fazer git pull com novas alterações (como as rotas admin), o PythonAnywhere está retornando erro 500 porque o código antigo ainda está em cache.

## Solução Rápida

### 1. Acesse o PythonAnywhere
- Vá para: https://www.pythonanywhere.com
- Faça login

### 2. Vá para a Aba "Web"
- Clique em "Web" no menu superior
- Você verá sua aplicação listada

### 3. Recarregue a Aplicação
- Procure o botão verde **"Reload lufespi.pythonanywhere.com"**
- Clique nele
- Aguarde alguns segundos

### 4. Teste a API
- Abra: https://lufespi.pythonanywhere.com/health
- Deve retornar: `{"status": "ok"}`

## Se Ainda Não Funcionar

### Verifique os Logs de Erro
1. Na aba "Web", role até "Log files"
2. Clique em **"Error log"**
3. Veja os erros mais recentes (últimas linhas)
4. Procure por:
   - Erros de importação (ModuleNotFoundError)
   - Erros de sintaxe
   - Erros de banco de dados

### Problemas Comuns

#### Erro: ModuleNotFoundError: No module named 'reportlab'
**Solução:**
```bash
# No console Bash do PythonAnywhere
cd ~/cuidador-backend
pip3.10 install reportlab==4.0.7
```

Depois clique em **Reload** novamente.

#### Erro: No module named 'api.routes.admin'
**Solução:**
```bash
# Verifique se o arquivo existe
cd ~/cuidador-backend
ls -la api/routes/admin.py

# Se não existir, faça git pull
git pull origin main
```

Depois clique em **Reload** novamente.

#### Erro: Connection to database failed
**Solução:** Verifique se o arquivo `.env` existe e tem as credenciais corretas:
```bash
cd ~/cuidador-backend
cat .env
```

Deve conter:
```
DB_HOST=KaueMuller.mysql.pythonanywhere-services.com
DB_USER=KaueMuller
DB_PASSWORD=ESquiva09
DB_NAME=KaueMuller$default
JWT_SECRET_KEY=sua-chave-secreta-super-segura-aqui-2024
```

## Verificação Final

Após recarregar, teste os endpoints:

1. **Health Check:**
   ```
   GET https://lufespi.pythonanywhere.com/health
   ```

2. **Login (teste):**
   ```
   POST https://lufespi.pythonanywhere.com/api/v1/auth/login
   Body: {"email": "teste@email.com", "password": "senha123"}
   ```

3. **Perfil de usuário:**
   ```
   GET https://lufespi.pythonanywhere.com/api/v1/auth/me
   Headers: Authorization: Bearer seu-token
   ```

## Comandos Úteis no Console Bash

```bash
# Ver status do git
cd ~/cuidador-backend
git status

# Ver últimas alterações
git log --oneline -5

# Ver arquivos no diretório de rotas
ls -la api/routes/

# Ver se admin.py existe
cat api/routes/admin.py | head -20

# Instalar dependências faltantes
pip3.10 install -r requirements.txt

# Ver processos rodando
ps aux | grep python
```

## Nota Importante
Toda vez que você fizer:
- `git pull` com novas alterações
- Instalar novos pacotes
- Modificar código Python

Você **DEVE** clicar em **Reload** na aba Web do PythonAnywhere!
