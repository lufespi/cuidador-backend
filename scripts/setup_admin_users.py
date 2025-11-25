#!/usr/bin/env python3
"""
Script para configurar usuários administradores
Permite definir quais usuários terão privilégios de admin
"""
import pymysql
import os

# Configurações do banco de dados
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'KaueMuller.mysql.pythonanywhere-services.com'),
    'user': os.getenv('DB_USER', 'KaueMuller'),
    'password': os.getenv('DB_PASSWORD', ''),
    'database': os.getenv('DB_NAME', 'KaueMuller$cuidador'),
    'charset': 'utf8mb4',
    'cursorclass': pymysql.cursors.DictCursor
}

def get_connection():
    """Cria conexão com o banco de dados"""
    return pymysql.connect(**DB_CONFIG)

def list_users(conn):
    """Lista todos os usuários cadastrados"""
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT id, nome, email, is_admin, status, created_at 
            FROM users 
            ORDER BY created_at DESC
        """)
        return cursor.fetchall()

def set_admin_status(conn, user_ids, is_admin):
    """Define status de admin para usuários especificados"""
    if not user_ids:
        return 0
    
    placeholders = ','.join(['%s'] * len(user_ids))
    query = f"UPDATE users SET is_admin = %s WHERE id IN ({placeholders})"
    
    with conn.cursor() as cursor:
        cursor.execute(query, [is_admin] + user_ids)
        conn.commit()
        return cursor.rowcount

def main():
    """Função principal"""
    print("=" * 60)
    print("👥 GERENCIAMENTO DE ADMINISTRADORES - CuidaDor")
    print("=" * 60)
    
    try:
        conn = get_connection()
        print("\n✅ Conectado ao banco de dados\n")
        
        # Listar usuários
        users = list_users(conn)
        
        if not users:
            print("⚠️  Nenhum usuário cadastrado no sistema")
            return
        
        print(f"📋 Total de usuários: {len(users)}\n")
        print(f"{'ID':<5} {'Nome':<30} {'Email':<30} {'Admin':<8} {'Status'}")
        print("-" * 80)
        
        for user in users:
            admin_status = "✓ SIM" if user['is_admin'] else "✗ NÃO"
            print(f"{user['id']:<5} {user['nome']:<30} {user['email']:<30} {admin_status:<8} {user['status']}")
        
        print("\n" + "=" * 60)
        print("OPÇÕES:")
        print("1. Adicionar administradores")
        print("2. Remover administradores")
        print("3. Sair")
        print("=" * 60)
        
        option = input("\nEscolha uma opção (1-3): ").strip()
        
        if option == '1':
            print("\n📝 Digite os IDs dos usuários para PROMOVER a admin (separados por vírgula):")
            ids_input = input("IDs: ").strip()
            ids = [int(i.strip()) for i in ids_input.split(',') if i.strip().isdigit()]
            
            if ids:
                count = set_admin_status(conn, ids, True)
                print(f"\n✅ {count} usuário(s) promovido(s) a administrador!")
            else:
                print("\n⚠️  Nenhum ID válido fornecido")
        
        elif option == '2':
            print("\n📝 Digite os IDs dos usuários para REMOVER privilégios de admin (separados por vírgula):")
            ids_input = input("IDs: ").strip()
            ids = [int(i.strip()) for i in ids_input.split(',') if i.strip().isdigit()]
            
            if ids:
                count = set_admin_status(conn, ids, False)
                print(f"\n✅ {count} usuário(s) removido(s) da administração!")
            else:
                print("\n⚠️  Nenhum ID válido fornecido")
        
        else:
            print("\n👋 Saindo...")
    
    except Exception as e:
        print(f"\n❌ Erro: {e}")
        return 1
    finally:
        if 'conn' in locals():
            conn.close()
    
    return 0

if __name__ == '__main__':
    exit(main())
