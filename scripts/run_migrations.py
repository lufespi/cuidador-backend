#!/usr/bin/env python3
"""
Script para executar migrações do banco de dados
Executa todas as migrações pendentes na ordem correta
"""
import pymysql
import os
import sys
from pathlib import Path
from dotenv import load_dotenv

# Carregar variáveis de ambiente
BASE_DIR = Path(__file__).resolve().parent.parent
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

def get_connection():
    """Cria conexão com o banco de dados"""
    return pymysql.connect(**DB_CONFIG)

def get_executed_migrations(conn):
    """Retorna lista de migrações já executadas"""
    with conn.cursor() as cursor:
        # Criar tabela de histórico se não existir
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS migration_history (
                id INT AUTO_INCREMENT PRIMARY KEY,
                migration_name VARCHAR(255) NOT NULL UNIQUE,
                executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                description TEXT
            )
        """)
        conn.commit()
        
        cursor.execute("SELECT migration_name FROM migration_history")
        return {row['migration_name'] for row in cursor.fetchall()}

def get_migration_files():
    """Retorna lista ordenada de arquivos de migração"""
    migrations_dir = Path(__file__).parent / 'migrations'
    if not migrations_dir.exists():
        return []
    
    files = sorted(migrations_dir.glob('*.sql'))
    return [(f.stem, f) for f in files]

def execute_migration(conn, migration_name, migration_file):
    """Executa uma migração específica"""
    print(f"\n🔄 Executando migração: {migration_name}")
    
    with open(migration_file, 'r', encoding='utf-8') as f:
        sql_content = f.read()
    
    # Dividir em statements individuais
    statements = [s.strip() for s in sql_content.split(';') if s.strip() and not s.strip().startswith('--')]
    
    try:
        with conn.cursor() as cursor:
            for statement in statements:
                if statement:
                    try:
                        cursor.execute(statement)
                    except Exception as e:
                        # Ignorar erros de "já existe"
                        if 'already exists' in str(e).lower() or 'duplicate' in str(e).lower():
                            print(f"   ⚠️  Aviso (ignorado): {str(e)[:80]}")
                        else:
                            raise
            conn.commit()
        
        # Marcar como executada
        with conn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO migration_history (migration_name) VALUES (%s) ON DUPLICATE KEY UPDATE executed_at=NOW()",
                (migration_name,)
            )
            conn.commit()
        
        print(f"✅ Migração {migration_name} executada com sucesso!")
        return True
    except Exception as e:
        conn.rollback()
        print(f"❌ Erro ao executar migração {migration_name}: {e}")
        return False

def main():
    """Função principal"""
    print("=" * 70)
    print("🔧 SISTEMA DE MIGRAÇÕES - CuidaDor Backend")
    print("=" * 70)
    
    # Verificar se é listagem
    if len(sys.argv) > 1 and sys.argv[1] == '--list':
        list_migrations()
        return
    
    try:
        # Conectar ao banco
        print(f"\n🔌 Conectando ao banco: {DB_CONFIG['database']}@{DB_CONFIG['host']}")
        conn = get_connection()
        print("✅ Conectado ao banco de dados")
        
        # Obter migrações executadas
        executed = get_executed_migrations(conn)
        print(f"\n📊 Migrações já executadas: {len(executed)}")
        if executed:
            for m in sorted(executed):
                print(f"   ✓ {m}")
        
        # Obter arquivos de migração
        migration_files = get_migration_files()
        print(f"\n📁 Arquivos de migração encontrados: {len(migration_files)}")
        
        # Executar migrações pendentes
        pending = [(name, path) for name, path in migration_files if name not in executed]
        
        if not pending:
            print("\n✨ Todas as migrações já foram executadas!")
            conn.close()
            return
        
        print(f"\n🔄 Migrações pendentes: {len(pending)}")
        for name, _ in pending:
            print(f"   → {name}")
        
        print("\n" + "=" * 70)
        confirm = input("Deseja executar as migrações pendentes? (s/N): ")
        
        if confirm.lower() != 's':
            print("\n❌ Operação cancelada pelo usuário")
            conn.close()
            return
        
        # Executar cada migração pendente
        print("\n" + "=" * 70)
        success_count = 0
        fail_count = 0
        
        for name, path in pending:
            if execute_migration(conn, name, path):
                success_count += 1
            else:
                fail_count += 1
                print("\n⚠️  Continuando com próxima migração...\n")
        
        print("\n" + "=" * 70)
        print("📊 RESUMO DA EXECUÇÃO")
        print("=" * 70)
        print(f"✅ Sucesso: {success_count}")
        print(f"❌ Falhas: {fail_count}")
        print(f"📝 Total processado: {success_count + fail_count}")
        
        if fail_count == 0:
            print("\n🎉 Todas as migrações foram executadas com sucesso!")
        else:
            print("\n⚠️  Algumas migrações falharam. Verifique os erros acima.")
        
    except pymysql.Error as e:
        print(f"\n❌ Erro de conexão com o banco de dados:")
        print(f"   {str(e)}")
        print(f"\n💡 Dica: Verifique as configurações no arquivo .env:")
        print(f"   DB_HOST={DB_CONFIG['host']}")
        print(f"   DB_USER={DB_CONFIG['user']}")
        print(f"   DB_NAME={DB_CONFIG['database']}")
        return 1
    except Exception as e:
        print(f"\n❌ Erro inesperado: {e}")
        return 1
    finally:
        if 'conn' in locals():
            conn.close()


def list_migrations():
    """Lista todas as migrações e seu status"""
    print("=" * 70)
    print("📋 LISTAGEM DE MIGRAÇÕES")
    print("=" * 70)
    
    try:
        conn = get_connection()
        executed = get_executed_migrations(conn)
        migration_files = get_migration_files()
        
        print(f"\n📊 Total de migrações: {len(migration_files)}")
        print(f"   Executadas: {len(executed)}")
        print(f"   Pendentes: {len(migration_files) - len(executed)}\n")
        
        for name, path in migration_files:
            status = "✅ EXECUTADA" if name in executed else "⏳ PENDENTE"
            print(f" {status:15} | {name}.sql")
        
        conn.close()
        
    except Exception as e:
        print(f"❌ Erro: {str(e)}")
        return 1
    
    return 0

if __name__ == '__main__':
    exit(main())
