"""
Script de migração: Adicionar coluna notification_preferences na tabela users

Executar com: python scripts/add_notification_preferences.py
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

def add_notification_preferences_column():
    """Adiciona coluna notification_preferences na tabela users"""
    conn = get_connection()
    cursor = conn.cursor()
    
    try:
        print("🔍 Verificando se coluna 'notification_preferences' já existe...")
        
        # Verifica se a coluna já existe
        cursor.execute("""
            SELECT COUNT(*) as count 
            FROM information_schema.columns 
            WHERE table_schema = %s 
            AND table_name = 'users' 
            AND column_name = 'notification_preferences'
        """, (os.getenv('DB_NAME'),))
        
        result = cursor.fetchone()
        
        if result['count'] > 0:
            print("⚠️  Coluna 'notification_preferences' já existe!")
            print("✅ Nenhuma ação necessária.")
            return
        
        print("📝 Adicionando coluna 'notification_preferences'...")
        
        # Adiciona a coluna
        cursor.execute("""
            ALTER TABLE users 
            ADD COLUMN notification_preferences JSON DEFAULT NULL
            AFTER data_share_preference
        """)
        
        conn.commit()
        print("✅ Coluna 'notification_preferences' adicionada com sucesso!")
        
        # Mostra estrutura atualizada
        cursor.execute("DESCRIBE users")
        columns = cursor.fetchall()
        
        print("\n📋 Estrutura atualizada da tabela users:")
        print("-" * 80)
        for col in columns:
            if 'preference' in col['Field'].lower() or col['Field'] in ['id', 'email', 'nome']:
                print(f"  {col['Field']:<30} {col['Type']:<30} {col['Null']:<8}")
        print("-" * 80)
        
        # Conta usuários
        cursor.execute("SELECT COUNT(*) as count FROM users")
        user_count = cursor.fetchone()['count']
        print(f"\n👥 Total de usuários na tabela: {user_count}")
        
        print("\n💡 Estrutura JSON recomendada:")
        print('''
        {
          "enabled": true,
          "types": {
            "exercise": {"enabled": true, "time": "08:00"},
            "medication": {"enabled": true, "time": "12:00"},
            "appointment": {"enabled": true, "time": "14:00"},
            "practice": {"enabled": true, "time": "18:00"},
            "hydration": {"enabled": true, "time": "10:00"},
            "diet": {"enabled": true, "time": "12:00"}
          }
        }
        ''')
        
    except Exception as e:
        print(f"❌ Erro ao adicionar coluna: {str(e)}")
        conn.rollback()
        raise
    
    finally:
        cursor.close()
        conn.close()

if __name__ == '__main__':
    print("=" * 80)
    print("🔧 MIGRAÇÃO: Adicionar notification_preferences na tabela users")
    print("=" * 80)
    print()
    
    try:
        add_notification_preferences_column()
        print()
        print("=" * 80)
        print("✅ Migração concluída com sucesso!")
        print("=" * 80)
    
    except Exception as e:
        print()
        print("=" * 80)
        print(f"❌ Falha na migração: {str(e)}")
        print("=" * 80)
