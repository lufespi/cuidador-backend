#!/usr/bin/env python3
"""
Script para executar migração 002_add_admin_field no PythonAnywhere
Adiciona campo is_admin na tabela users

Como usar:
1. Abra o console Bash no PythonAnywhere
2. Navegue até o diretório do projeto: cd ~/cuidador-backend
3. Execute: python3 run_migration_002_admin.py
"""

import mysql.connector
from mysql.connector import Error

# Configurações do banco de dados
DB_CONFIG = {
    'host': 'KaueMuller.mysql.pythonanywhere-services.com',
    'user': 'KaueMuller',
    'password': 'ESquiva09',
    'database': 'KaueMuller$default',
    'charset': 'utf8mb4',
    'collation': 'utf8mb4_unicode_ci'
}

# E-mails dos administradores (atualize com os e-mails reais)
ADMIN_EMAILS = [
    'admin@cuidador.com',
    'admin2@cuidador.com', 
    'admin3@cuidador.com'
]

def execute_sql(cursor, sql, description):
    """Executa um comando SQL e trata erros"""
    try:
        cursor.execute(sql)
        affected_rows = cursor.rowcount
        print(f"✓ {description} (linhas afetadas: {affected_rows})")
        return True
    except Error as e:
        error_msg = str(e)
        if "Duplicate column name" in error_msg:
            print(f"⊙ {description} (coluna já existe)")
            return True
        elif "Duplicate key name" in error_msg:
            print(f"⊙ {description} (índice já existe)")
            return True
        else:
            print(f"✗ Erro em {description}: {e}")
            return False

def main():
    """Função principal para executar a migração"""
    connection = None
    try:
        print("=" * 60)
        print("MIGRAÇÃO 002: ADICIONAR CAMPO is_admin")
        print("=" * 60)
        print()
        
        # Conecta ao banco de dados
        print("Conectando ao banco de dados...")
        connection = mysql.connector.connect(**DB_CONFIG)
        cursor = connection.cursor()
        print("✓ Conectado com sucesso!\n")
        
        # Verifica se a tabela users existe
        print("Verificando tabela 'users'...")
        cursor.execute("SHOW TABLES LIKE 'users'")
        if not cursor.fetchone():
            print("✗ ERRO: Tabela 'users' não encontrada!")
            print("Execute primeiro o script create_tables_pythonanywhere.py")
            return 1
        print("✓ Tabela 'users' encontrada\n")
        
        # 1. Adicionar coluna is_admin
        print("1. Adicionando coluna 'is_admin'...")
        sql_add_column = """
        ALTER TABLE users 
        ADD COLUMN is_admin BOOLEAN DEFAULT FALSE
        """
        execute_sql(cursor, sql_add_column, "Coluna is_admin adicionada")
        connection.commit()
        print()
        
        # 2. Criar índice
        print("2. Criando índice para otimizar consultas...")
        sql_create_index = "CREATE INDEX idx_users_is_admin ON users(is_admin)"
        execute_sql(cursor, sql_create_index, "Índice idx_users_is_admin criado")
        connection.commit()
        print()
        
        # 3. Atualizar administradores
        print("3. Configurando administradores...")
        print(f"E-mails configurados como admin: {', '.join(ADMIN_EMAILS)}")
        
        placeholders = ', '.join(['%s'] * len(ADMIN_EMAILS))
        sql_update_admins = f"""
        UPDATE users 
        SET is_admin = TRUE 
        WHERE email IN ({placeholders})
        """
        
        try:
            cursor.execute(sql_update_admins, ADMIN_EMAILS)
            affected = cursor.rowcount
            connection.commit()
            
            if affected > 0:
                print(f"✓ {affected} usuário(s) configurado(s) como administrador")
            else:
                print("⚠ Nenhum usuário encontrado com os e-mails fornecidos")
                print("  Os usuários precisam estar cadastrados primeiro")
        except Error as e:
            print(f"✗ Erro ao atualizar administradores: {e}")
        
        print()
        
        # 4. Verificar estrutura da tabela
        print("4. Verificando estrutura da tabela 'users'...")
        cursor.execute("SHOW COLUMNS FROM users")
        columns = cursor.fetchall()
        print("\nColunas da tabela users:")
        for col in columns:
            marker = "→" if col[0] == 'is_admin' else " "
            print(f"  {marker} {col[0]} ({col[1]}) - Default: {col[4]}")
        print()
        
        # 5. Mostrar usuários admin
        print("5. Listando usuários administradores...")
        cursor.execute("""
            SELECT id, nome, email, is_admin 
            FROM users 
            WHERE is_admin = TRUE
        """)
        admins = cursor.fetchall()
        
        if admins:
            print(f"\nTotal de administradores: {len(admins)}")
            for admin in admins:
                print(f"  • ID: {admin[0]} | Nome: {admin[1]} | Email: {admin[2]}")
        else:
            print("  Nenhum administrador configurado ainda")
        
        print()
        print("=" * 60)
        print("✓ MIGRAÇÃO 002 CONCLUÍDA COM SUCESSO!")
        print("=" * 60)
        print()
        print("PRÓXIMOS PASSOS:")
        print("1. Atualize os e-mails dos administradores no script se necessário")
        print("2. Execute novamente para configurar os admins corretos")
        print("3. Ou use o endpoint da API para promover usuários a admin")
        
    except Error as e:
        print(f"\n✗ ERRO: {e}")
        print("\nVerifique:")
        print("  1. As credenciais do banco de dados estão corretas")
        print("  2. A tabela 'users' existe")
        print("  3. Você tem permissões adequadas")
        return 1
        
    finally:
        if connection and connection.is_connected():
            cursor.close()
            connection.close()
            print("\nConexão encerrada.")
    
    return 0

if __name__ == "__main__":
    exit(main())
