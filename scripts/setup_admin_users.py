#!/usr/bin/env python3
"""
Script interativo para gerenciar administradores no CuidaDor
Permite listar, adicionar e remover permissões de administrador
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
    'cursorclass': pymysql.cursors.DictCursor
}

def get_connection():
    """Cria conexão com o banco de dados"""
    return pymysql.connect(**DB_CONFIG)

def list_all_users(conn):
    """Lista todos os usuários"""
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT id, nome, email, is_admin, created_at 
            FROM users 
            ORDER BY is_admin DESC, email
        """)
        return cursor.fetchall()

def list_admins(conn):
    """Lista apenas administradores"""
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT id, nome, email, created_at 
            FROM users 
            WHERE is_admin = TRUE 
            ORDER BY email
        """)
        return cursor.fetchall()

def set_admin(conn, user_id, is_admin=True):
    """Define ou remove permissão de administrador"""
    with conn.cursor() as cursor:
        cursor.execute(
            "UPDATE users SET is_admin = %s WHERE id = %s",
            (is_admin, user_id)
        )
        conn.commit()
        return cursor.rowcount

def show_users_table(users):
    """Exibe tabela de usuários"""
    if not users:
        print("\n⚠️  Nenhum usuário encontrado\n")
        return
    
    print(f"\n{'ID':<5} {'Nome':<30} {'E-mail':<35} {'Admin':<8} {'Cadastro'}")
    print("-" * 85)
    
    for user in users:
        admin_status = "✓ SIM" if user['is_admin'] else "✗ NÃO"
        created_at = user['created_at']
        if hasattr(created_at, 'strftime'):
            created = created_at.strftime('%d/%m/%Y')
        elif created_at:
            created = str(created_at)[:10]
        else:
            created = 'N/A'
        print(f"{user['id']:<5} {user['nome']:<30} {user['email']:<35} {admin_status:<8} {created}")
    
    print()

def menu_principal():
    """Exibe menu principal"""
    print("\n" + "=" * 60)
    print("MENU PRINCIPAL")
    print("=" * 60)
    print("1. Listar todos os usuários")
    print("2. Listar apenas administradores")
    print("3. Adicionar administrador")
    print("4. Remover administrador")
    print("0. Sair")
    print("=" * 60)
    return input("\nEscolha uma opção: ")

def main():
    """Função principal"""
    print("=" * 60)
    print("👥 GERENCIAMENTO DE ADMINISTRADORES - CuidaDor")
    print("=" * 60)
    
    try:
        conn = get_connection()
        print("\n✅ Conectado ao banco de dados")
        
        while True:
            opcao = menu_principal()
            
            if opcao == '0':
                print("\n👋 Saindo...\n")
                break
            
            elif opcao == '1':
                print("\n📋 TODOS OS USUÁRIOS")
                print("=" * 85)
                users = list_all_users(conn)
                show_users_table(users)
            
            elif opcao == '2':
                print("\n🔐 ADMINISTRADORES")
                print("=" * 85)
                admins = list_admins(conn)
                show_users_table(admins)
            
            elif opcao == '3':
                print("\n➕ ADICIONAR ADMINISTRADOR")
                print("=" * 60)
                users = list_all_users(conn)
                show_users_table(users)
                
                user_id = input("Digite o ID do usuário (0 para cancelar): ")
                
                if user_id == '0':
                    continue
                
                try:
                    user_id = int(user_id)
                    confirm = input(f"\nConfirma tornar o usuário ID {user_id} ADMINISTRADOR? (s/N): ")
                    
                    if confirm.lower() == 's':
                        count = set_admin(conn, user_id, True)
                        if count > 0:
                            print(f"\n✅ Usuário ID {user_id} promovido a administrador!")
                        else:
                            print(f"\n❌ Usuário ID {user_id} não encontrado")
                except ValueError:
                    print("\n❌ ID inválido")
            
            elif opcao == '4':
                print("\n➖ REMOVER ADMINISTRADOR")
                print("=" * 60)
                admins = list_admins(conn)
                show_users_table(admins)
                
                user_id = input("Digite o ID do usuário (0 para cancelar): ")
                
                if user_id == '0':
                    continue
                
                try:
                    user_id = int(user_id)
                    confirm = input(f"\n⚠️  Confirma REMOVER privilégios de administrador do usuário ID {user_id}? (s/N): ")
                    
                    if confirm.lower() == 's':
                        count = set_admin(conn, user_id, False)
                        if count > 0:
                            print(f"\n✅ Privilégios removidos do usuário ID {user_id}")
                        else:
                            print(f"\n❌ Usuário ID {user_id} não encontrado")
                except ValueError:
                    print("\n❌ ID inválido")
            
            else:
                print("\n❌ Opção inválida")
        
        conn.close()
    
    except Exception as e:
        print(f"\n❌ Erro: {e}\n")
        return 1
    
    return 0

if __name__ == '__main__':
    sys.exit(main())