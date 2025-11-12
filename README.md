# Cuidador Backend - API Flask

Backend em Flask para aplicativo de monitoramento de dor para pacientes com osteoartrite.

## 🚀 Tecnologias

- Python 3.10+
- Flask 3.0
- SQLAlchemy (ORM)
- Flask-JWT-Extended (Autenticação)
- MySQL (PythonAnywhere)
- Flask-Migrate (Migrations)

## 📦 Instalação

```bash
# Criar virtual environment
python -m venv venv

# Ativar (Windows)
venv\Scripts\activate

# Ativar (Linux/Mac)
source venv/bin/activate

# Instalar dependências
pip install -r requirements.txt
```

## ⚙️ Configuração

1. Copiar `.env.example` para `.env`
2. Configurar variáveis de ambiente
3. Criar banco de dados MySQL

```bash
# Inicializar migrations
flask db init
flask db migrate -m "Initial migration"
flask db upgrade
```

## 🏃 Executar

```bash
# Desenvolvimento
flask run

# Produção (PythonAnywhere)
# O arquivo wsgi.py é usado automaticamente
```

## 📚 Documentação

Consulte `BACKEND_SPECIFICATION.md` para documentação completa da API.

## 🔗 Endpoints

- `POST /api/v1/auth/register` - Registrar usuário
- `POST /api/v1/auth/login` - Login
- `GET /api/v1/auth/me` - Usuário atual
- `GET/PUT /api/v1/user/profile` - Perfil do usuário
- `GET/PUT /api/v1/user/preferences` - Preferências
- `GET/POST /api/v1/pain` - Registros de dor
- `GET /api/v1/pain/statistics` - Estatísticas

## 📄 Licença

MIT
