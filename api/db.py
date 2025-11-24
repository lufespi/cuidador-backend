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
                diagnostico VARCHAR(200),
                comorbidades TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                INDEX idx_email (email)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
        """)
        
        # Migração: adiciona colunas novas se não existirem
        columns_to_add = [
            ("nome", "VARCHAR(100)"),
            ("telefone", "VARCHAR(20)"),
            ("data_nascimento", "DATE"),
            ("sexo", "VARCHAR(10)"),
            ("diagnostico", "VARCHAR(200)"),
            ("comorbidades", "TEXT"),
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
        
        # Migração: copia dados das colunas antigas (inglês) para novas (português) se existirem
        old_to_new_columns = [
            ("first_name", "nome"),
            ("last_name", "nome"),  # Concatena com nome
            ("phone", "telefone"),
            ("birth_date", "data_nascimento"),
            ("gender", "sexo"),
        ]
        
        # Verifica se colunas antigas existem
        cursor.execute("SHOW COLUMNS FROM users")
        existing_columns = {col['Field'] for col in cursor.fetchall()}
        
        # Migra dados se colunas antigas existirem
        if 'first_name' in existing_columns or 'last_name' in existing_columns:
            print("🔄 Migrando dados das colunas antigas...")
            
            # Migra nome (concatena first_name + last_name)
            if 'first_name' in existing_columns:
                cursor.execute("""
                    UPDATE users 
                    SET nome = CASE 
                        WHEN first_name IS NOT NULL AND last_name IS NOT NULL 
                            THEN CONCAT(first_name, ' ', last_name)
                        WHEN first_name IS NOT NULL 
                            THEN first_name
                        WHEN last_name IS NOT NULL 
                            THEN last_name
                        ELSE nome
                    END
                    WHERE nome IS NULL OR nome = ''
                """)
                print("✅ Dados de 'first_name' e 'last_name' migrados para 'nome'")
            
            # Migra telefone
            if 'phone' in existing_columns:
                cursor.execute("UPDATE users SET telefone = phone WHERE telefone IS NULL AND phone IS NOT NULL")
                print("✅ Dados de 'phone' migrados para 'telefone'")
            
            # Migra data de nascimento
            if 'birth_date' in existing_columns:
                cursor.execute("UPDATE users SET data_nascimento = birth_date WHERE data_nascimento IS NULL AND birth_date IS NOT NULL")
                print("✅ Dados de 'birth_date' migrados para 'data_nascimento'")
            
            # Migra gênero
            if 'gender' in existing_columns:
                cursor.execute("UPDATE users SET sexo = gender WHERE sexo IS NULL AND gender IS NOT NULL")
                print("✅ Dados de 'gender' migrados para 'sexo'")
            
            conn.commit()
            
            # Remove colunas antigas
            print("🗑️  Removendo colunas antigas...")
            for old_col in ['first_name', 'last_name', 'phone', 'birth_date', 'gender', 'updated_at']:
                if old_col in existing_columns:
                    try:
                        cursor.execute(f"ALTER TABLE users DROP COLUMN {old_col}")
                        print(f"✅ Coluna antiga '{old_col}' removida")
                    except Exception as e:
                        print(f"⚠️  Aviso ao remover coluna '{old_col}': {e}")
        
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
