import pymysql
from config.settings import Config

def get_connection():
    """Retorna uma conexão com o banco de dados MySQL"""
    return pymysql.connect(
        host=Config.DB_HOST,
        user=Config.DB_USER,
        password=Config.DB_PASSWORD,
        database=Config.DB_NAME,
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor
    )

def init_db():
    """Cria as tabelas necessárias se não existirem e faz migrações"""
    conn = get_connection()
    cursor = conn.cursor()
    
    try:
        # Tabela de usuários
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                email VARCHAR(120) UNIQUE NOT NULL,
                password_hash VARCHAR(255) NOT NULL,
                nome VARCHAR(100),
                telefone VARCHAR(20),
                data_nascimento DATE,
                sexo VARCHAR(10),
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                INDEX idx_email (email)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
        """)
        
        # Migração: adiciona colunas que podem estar faltando em tabelas antigas
        columns_to_add = [
            ("nome", "VARCHAR(100)"),
            ("telefone", "VARCHAR(20)"),
            ("data_nascimento", "DATE"),
            ("sexo", "VARCHAR(10)"),
            ("created_at", "TIMESTAMP DEFAULT CURRENT_TIMESTAMP"),
        ]
        
        for column_name, column_type in columns_to_add:
            try:
                cursor.execute(f"ALTER TABLE users ADD COLUMN {column_name} {column_type}")
                print(f"✅ Coluna '{column_name}' adicionada à tabela users")
            except Exception as e:
                if "Duplicate column name" in str(e):
                    pass  # Coluna já existe, tudo bem
                else:
                    print(f"⚠️  Aviso ao adicionar coluna '{column_name}': {e}")
        
        # Adiciona índice no email se não existir
        try:
            cursor.execute("ALTER TABLE users ADD INDEX idx_email (email)")
        except Exception:
            pass  # Índice já existe
        
        # Tabela de registros de dor
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS pain_records (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                body_parts JSON NOT NULL,
                intensidade INT NOT NULL,
                data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                observacoes TEXT,
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                INDEX idx_user_id (user_id),
                INDEX idx_data (data)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
        """)
        
        conn.commit()
        print("✅ Tabelas criadas/verificadas com sucesso!")
        
    except Exception as e:
        print(f"❌ Erro ao criar tabelas: {e}")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()
