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
    """Verifica se as tabelas necessárias existem (não faz migrações)"""
    conn = get_connection()
    cursor = conn.cursor()
    
    try:
        # Apenas verifica se as tabelas existem
        cursor.execute("SHOW TABLES LIKE 'users'")
        if not cursor.fetchone():
            print("⚠️  Tabela 'users' não encontrada")
        
        cursor.execute("SHOW TABLES LIKE 'pain_records'")
        if not cursor.fetchone():
            print("⚠️  Tabela 'pain_records' não encontrada")
        else:
            print("✅ Tabelas verificadas com sucesso!")
        
        conn.commit()
        
    except Exception as e:
        print(f"❌ Erro ao verificar tabelas: {e}")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()
