#!/usr/bin/env python3
"""
Script para executar a migration de feedback
Cria a tabela feedback no banco de dados
"""

import os
import sys
import pymysql
from pathlib import Path
from dotenv import load_dotenv

# Adicionar o diretório raiz ao path
BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(BASE_DIR))

# Carregar variáveis de ambiente
load_dotenv(BASE_DIR / '.env')

# Configurações do banco de dados
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'lufespi.mysql.pythonanywhere-services.com'),
    'user': os.getenv('DB_USER', 'lufespi'),
    'password': os.getenv('DB_PASSWORD', 'mZHr$hSi3ebB{3Px'),
    'database': os.getenv('DB_NAME', 'lufespi$cuidador_homolog_db'),
    'charset': 'utf8mb4',
    'cursorclass': pymysql.cursors.DictCursor
}


def create_feedback_table():
    """Cria a tabela de feedback"""
    print("=" * 70)
    print("🔧 CRIANDO TABELA DE FEEDBACK")
    print("=" * 70)
    
    try:
        # Conectar ao banco
        print(f"\n🔌 Conectando ao banco: {DB_CONFIG['database']}@{DB_CONFIG['host']}")
        conn = pymysql.connect(**DB_CONFIG)
        print("✅ Conectado ao banco de dados")
        
        cursor = conn.cursor()
        
        # Verificar se tabela já existe
        print("\n📋 Verificando se tabela feedback existe...")
        cursor.execute("""
            SELECT COUNT(*) as count
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = 'feedback'
        """)
        
        table_exists = cursor.fetchone()['count'] > 0
        
        if table_exists:
            print("⚠️  Tabela feedback já existe")
            
            response = input("\nDeseja recriar a tabela? (ATENÇÃO: Todos os dados serão perdidos!) (s/N): ").strip().lower()
            if response == 's':
                print("\n🗑️  Removendo tabela antiga...")
                cursor.execute("DROP TABLE feedback")
                conn.commit()
                print("✅ Tabela removida")
            else:
                print("❌ Operação cancelada")
                cursor.close()
                conn.close()
                return
        
        # Criar tabela
        print("\n📝 Criando tabela feedback...")
        cursor.execute("""
            CREATE TABLE feedback (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                feedback_type VARCHAR(50) NOT NULL,
                name VARCHAR(255),
                email VARCHAR(255),
                message TEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                INDEX idx_feedback_user_id (user_id),
                INDEX idx_feedback_created_at (created_at),
                INDEX idx_feedback_type (feedback_type)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        """)
        conn.commit()
        print("✅ Tabela feedback criada com sucesso!")
        
        # Criar tabela de controle de migrations
        print("\n📝 Verificando tabela migration_history...")
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS migration_history (
                id INT AUTO_INCREMENT PRIMARY KEY,
                migration_name VARCHAR(255) NOT NULL UNIQUE,
                executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                description TEXT
            )
        """)
        conn.commit()
        
        # Registrar migration
        cursor.execute("""
            INSERT INTO migration_history (migration_name, description)
            VALUES (%s, %s)
            ON DUPLICATE KEY UPDATE executed_at = NOW()
        """, ('004_create_feedback_table', 'Cria tabela de feedback dos usuários'))
        conn.commit()
        print("✅ Migration registrada no histórico")
        
        # Mostrar estrutura da tabela
        print("\n📊 Estrutura da tabela feedback:")
        cursor.execute("DESCRIBE feedback")
        columns = cursor.fetchall()
        
        print("\n┌─────────────────┬──────────────┬──────┬─────┬─────────┬──────────────────┐")
        print("│ Field           │ Type         │ Null │ Key │ Default │ Extra            │")
        print("├─────────────────┼──────────────┼──────┼─────┼─────────┼──────────────────┤")
        for col in columns:
            field = col['Field'].ljust(15)
            type_ = col['Type'].ljust(12)
            null = col['Null'].ljust(4)
            key = col['Key'].ljust(3)
            default = str(col['Default'] or '').ljust(7)
            extra = col['Extra'].ljust(16)
            print(f"│ {field} │ {type_} │ {null} │ {key} │ {default} │ {extra} │")
        print("└─────────────────┴──────────────┴──────┴─────┴─────────┴──────────────────┘")
        
        cursor.close()
        conn.close()
        
        print("\n" + "=" * 70)
        print("🎉 TABELA DE FEEDBACK CRIADA COM SUCESSO!")
        print("=" * 70)
        print("\n✅ Próximos passos:")
        print("   1. Reinicie a aplicação no PythonAnywhere")
        print("   2. Teste o endpoint: POST /api/v1/feedback")
        print("   3. Acesse Administrador > Feedback no app\n")
        
    except pymysql.Error as e:
        print(f"\n❌ Erro de banco de dados:")
        print(f"   {str(e)}")
        print(f"\n💡 Dica: Verifique as credenciais no arquivo .env")
        sys.exit(1)
    
    except Exception as e:
        print(f"\n❌ Erro inesperado: {str(e)}")
        sys.exit(1)


if __name__ == '__main__':
    create_feedback_table()
