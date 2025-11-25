#!/usr/bin/env python3
"""
Script para executar migrações do banco de dados
Executa todas as migrações pendentes na ordem correta
"""
import pymysql
import os
from pathlib import Path

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
                    cursor.execute(statement)
            conn.commit()
        
        print(f"✅ Migração {migration_name} executada com sucesso!")
        return True
    except Exception as e:
        conn.rollback()
        print(f"❌ Erro ao executar migração {migration_name}: {e}")
        return False

def main():
    """Função principal"""
    print("=" * 60)
    print("🔧 SISTEMA DE MIGRAÇÕES - CuidaDor Backend")
    print("=" * 60)
    
    try:
        # Conectar ao banco
        conn = get_connection()
        print("\n✅ Conectado ao banco de dados")
        
        # Obter migrações executadas
        executed = get_executed_migrations(conn)
        print(f"\n📋 Migrações já executadas: {len(executed)}")
        for m in sorted(executed):
            print(f"   ✓ {m}")
        
        # Obter arquivos de migração
        migration_files = get_migration_files()
        print(f"\n📁 Arquivos de migração encontrados: {len(migration_files)}")
        
        # Executar migrações pendentes
        pending = [(name, path) for name, path in migration_files if name not in executed]
        
        if not pending:
            print("\n✨ Todas as migrações já foram executadas!")
            return
        
        print(f"\n🔄 Migrações pendentes: {len(pending)}")
        for name, _ in pending:
            print(f"   → {name}")
        
        print("\n" + "=" * 60)
        confirm = input("Deseja executar as migrações pendentes? (s/N): ")
        
        if confirm.lower() != 's':
            print("\n❌ Operação cancelada pelo usuário")
            return
        
        # Executar cada migração pendente
        success_count = 0
        for name, path in pending:
            if execute_migration(conn, name, path):
                success_count += 1
        
        print("\n" + "=" * 60)
        print(f"✅ Processo concluído: {success_count}/{len(pending)} migrações executadas")
        print("=" * 60)
        
    except Exception as e:
        print(f"\n❌ Erro: {e}")
        return 1
    finally:
        if 'conn' in locals():
            conn.close()
    
    return 0

if __name__ == '__main__':
    exit(main())
