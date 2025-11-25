#!/usr/bin/env python3
"""
Script para adicionar campos faltantes na tabela users
Adiciona is_admin e body_parts se não existirem
"""
import pymysql
import os
import sys

# Configurações do banco de dados
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'lufespi.mysql.pythonanywhere-services.com'),
    'user': os.getenv('DB_USER', 'lufespi'),
    'password': os.getenv('DB_PASSWORD', 'mZHr$hSi3ebB{3Px'),
    'database': os.getenv('DB_NAME', 'lufespi$cuidador_homolog_db'),
    'charset': 'utf8mb4',
}

def get_connection():
    """Cria conexão com o banco de dados"""
    return pymysql.connect(**DB_CONFIG)

def column_exists(cursor, column_name):
    """Verifica se uma coluna existe na tabela users"""
    cursor.execute("""
        SELECT COUNT(*) as count
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = %s
        AND TABLE_NAME = 'users' 
        AND COLUMN_NAME = %s
    """, (DB_CONFIG['database'], column_name))
    
    result = cursor.fetchone()
    return result[0] > 0

def show_table_structure(cursor):
    """Mostra a estrutura atual da tabela users"""
    cursor.execute("DESCRIBE users")
    columns = cursor.fetchall()
    
    print(f"\n{'Campo':<20} {'Tipo':<25} {'Null':<8} {'Key':<8} {'Default':<15}")
    print("-" * 80)
    
    for col in columns:
        null_val = col[2] if col[2] else ''
        key_val = col[3] if col[3] else ''
        default_val = str(col[4]) if col[4] is not None else 'NULL'
        print(f"{col[0]:<20} {col[1]:<25} {null_val:<8} {key_val:<8} {default_val:<15}")

def main():
    """Função principal"""
    print("=" * 80)
    print("🔧 ADICIONAR CAMPOS FALTANTES - Tabela users")
    print("=" * 80)
    
    try:
        # Conectar ao banco
        conn = get_connection()
        print("\n✅ Conectado ao banco de dados")
        
        with conn.cursor() as cursor:
            # Verificar estrutura atual
            print("\n📋 Estrutura atual da tabela users:")
            show_table_structure(cursor)
            
            # Verificar campos
            print("\n" + "=" * 80)
            print("🔍 VERIFICANDO CAMPOS...")
            print("=" * 80)
            
            has_is_admin = column_exists(cursor, 'is_admin')
            has_body_parts = column_exists(cursor, 'body_parts')
            
            print(f"\nis_admin:    {'✅ EXISTE' if has_is_admin else '❌ NÃO EXISTE'}")
            print(f"body_parts:  {'✅ EXISTE' if has_body_parts else '❌ NÃO EXISTE'}")
            
            # Preparar alterações
            changes_needed = []
            
            if not has_is_admin:
                changes_needed.append("is_admin")
            
            if not has_body_parts:
                changes_needed.append("body_parts")
            
            if not changes_needed:
                print("\n✨ Todos os campos já existem! Nada a fazer.")
                return 0
            
            # Confirmar alterações
            print("\n" + "=" * 80)
            print(f"🔄 Será(ão) adicionado(s) {len(changes_needed)} campo(s):")
            print("=" * 80)
            
            for field in changes_needed:
                print(f"   → {field}")
            
            print("\nOperações que serão executadas:")
            if not has_is_admin:
                print("   • ALTER TABLE users ADD COLUMN is_admin BOOLEAN DEFAULT FALSE")
                print("   • CREATE INDEX idx_users_is_admin ON users(is_admin)")
            if not has_body_parts:
                print("   • ALTER TABLE users ADD COLUMN body_parts TEXT")
            
            confirm = input("\nDeseja continuar? (s/N): ")
            
            if confirm.lower() != 's':
                print("\n❌ Operação cancelada pelo usuário\n")
                return 0
            
            # Executar alterações
            print("\n" + "=" * 80)
            print("⚙️  EXECUTANDO ALTERAÇÕES...")
            print("=" * 80 + "\n")
            
            if not has_is_admin:
                print("🔄 Adicionando campo is_admin...")
                cursor.execute("ALTER TABLE users ADD COLUMN is_admin BOOLEAN DEFAULT FALSE")
                print("✅ Campo is_admin adicionado")
                
                print("🔄 Criando índice idx_users_is_admin...")
                cursor.execute("CREATE INDEX idx_users_is_admin ON users(is_admin)")
                print("✅ Índice criado")
            
            if not has_body_parts:
                print("🔄 Adicionando campo body_parts...")
                cursor.execute("ALTER TABLE users ADD COLUMN body_parts TEXT")
                print("✅ Campo body_parts adicionado")
            
            # Commit
            conn.commit()
            
            # Mostrar estrutura final
            print("\n" + "=" * 80)
            print("📋 ESTRUTURA FINAL DA TABELA:")
            print("=" * 80)
            show_table_structure(cursor)
            
            print("\n" + "=" * 80)
            print("✅ Processo concluído com sucesso!")
            print("=" * 80 + "\n")
        
        conn.close()
    
    except pymysql.Error as e:
        print(f"\n❌ Erro de banco de dados: {e}")
        print(f"   Código: {e.args[0] if e.args else 'N/A'}")
        print(f"   Mensagem: {e.args[1] if len(e.args) > 1 else 'N/A'}\n")
        return 1
    except Exception as e:
        print(f"\n❌ Erro: {e}\n")
        return 1
    
    return 0

if __name__ == '__main__':
    sys.exit(main())