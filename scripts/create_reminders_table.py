"""
Script de migração: Criar tabela de lembretes (reminders)

Executar com: python scripts/create_reminders_table.py
"""
import pymysql
import os
from dotenv import load_dotenv

# Carrega variáveis de ambiente
load_dotenv()

def get_connection():
    """Cria conexão com o banco de dados"""
    return pymysql.connect(
        host=os.getenv('DB_HOST'),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD'),
        database=os.getenv('DB_NAME'),
        cursorclass=pymysql.cursors.DictCursor
    )

def create_reminders_table():
    """Cria a tabela de lembretes"""
    conn = get_connection()
    cursor = conn.cursor()
    
    try:
        print("🔍 Verificando se tabela 'reminders' já existe...")
        
        # Verifica se a tabela já existe
        cursor.execute("""
            SELECT COUNT(*) as count 
            FROM information_schema.tables 
            WHERE table_schema = %s 
            AND table_name = 'reminders'
        """, (os.getenv('DB_NAME'),))
        
        result = cursor.fetchone()
        
        if result['count'] > 0:
            print("⚠️  Tabela 'reminders' já existe!")
            print("✅ Nenhuma ação necessária.")
            return
        
        print("📝 Criando tabela 'reminders'...")
        
        # Cria a tabela
        cursor.execute("""
            CREATE TABLE reminders (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                type VARCHAR(50) NOT NULL,
                title VARCHAR(255) NOT NULL,
                description TEXT,
                frequency VARCHAR(50) NOT NULL DEFAULT 'Diário',
                time VARCHAR(5) NOT NULL,
                is_active BOOLEAN DEFAULT TRUE,
                selected_days JSON,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                INDEX idx_user_id (user_id),
                INDEX idx_type (type),
                INDEX idx_is_active (is_active)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        """)
        
        conn.commit()
        print("✅ Tabela 'reminders' criada com sucesso!")
        
        # Mostra estrutura da tabela
        cursor.execute("DESCRIBE reminders")
        columns = cursor.fetchall()
        
        print("\n📋 Estrutura da tabela:")
        print("-" * 80)
        for col in columns:
            print(f"  {col['Field']:<20} {col['Type']:<30} {col['Null']:<8} {col['Key']:<5}")
        print("-" * 80)
        
    except Exception as e:
        print(f"❌ Erro ao criar tabela: {str(e)}")
        conn.rollback()
        raise
    
    finally:
        cursor.close()
        conn.close()

if __name__ == '__main__':
    print("=" * 80)
    print("🔧 MIGRAÇÃO: Criar tabela de lembretes (reminders)")
    print("=" * 80)
    print()
    
    try:
        create_reminders_table()
        print()
        print("=" * 80)
        print("✅ Migração concluída com sucesso!")
        print("=" * 80)
    
    except Exception as e:
        print()
        print("=" * 80)
        print(f"❌ Falha na migração: {str(e)}")
        print("=" * 80)
