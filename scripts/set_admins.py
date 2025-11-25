#!/usr/bin/env python3
"""
Script para vincular administradores específicos do CuidaDor
Define os 3 administradores principais do sistema
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

# E-mails dos administradores
ADMIN_EMAILS = [
    'lufespi1221@gmail.com',
    'kauemuller@gmail.com',
    'carinasuzanacorrea@gmail.com'
]

def get_connection():
    """Cria conexão com o banco de dados"""
    return pymysql.connect(**DB_CONFIG)

def check_users_exist(conn):
    """Verifica quais usuários existem no banco"""
    with conn.cursor() as cursor:
        placeholders = ','.join(['%s'] * len(ADMIN_EMAILS))
        query = f"""
            SELECT id, nome, email, is_admin
            FROM users 
            WHERE email IN ({placeholders})
            ORDER BY email
        """
        cursor.execute(query, ADMIN_EMAILS)
        return cursor.fetchall()

def set_admins(conn, emails):
    """Define usuários como administradores"""
    with conn.cursor() as cursor:
        placeholders = ','.join(['%s'] * len(emails))
        query = f"UPDATE users SET is_admin = TRUE WHERE email IN ({placeholders})"
        cursor.execute(query, emails)
        conn.commit()
        return cursor.rowcount

def get_all_admins(conn):
    """Lista todos os administradores"""
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT id, nome, email, created_at 
            FROM users 
            WHERE is_admin = TRUE 
            ORDER BY email
        """)
        return cursor.fetchall()

def main():
    """Função principal"""
    print("=" * 70)
    print("🔐 CONFIGURAÇÃO DE ADMINISTRADORES - CuidaDor")
    print("=" * 70)
    
    try:
        # Conectar ao banco
        conn = get_connection()
        print("\n✅ Conectado ao banco de dados\n")
        
        # Verificar usuários existentes
        print("📋 Verificando usuários cadastrados...\n")
        existing_users = check_users_exist(conn)
        
        if not existing_users:
            print("❌ ERRO: Nenhum dos e-mails especificados foi encontrado no banco!")
            print("\nE-mails procurados:")
            for email in ADMIN_EMAILS:
                print(f"   - {email}")
            print("\n⚠️  Os usuários precisam estar cadastrados primeiro.")
            print("   Use o app Flutter para criar as contas.\n")
            return 1
        
        # Mostrar usuários encontrados
        print(f"✅ {len(existing_users)} usuário(s) encontrado(s):\n")
        print(f"{'ID':<5} {'Nome':<30} {'E-mail':<35} {'Admin'}")
        print("-" * 75)
        
        emails_to_promote = []
        for user in existing_users:
            admin_status = "✓ SIM" if user['is_admin'] else "✗ NÃO"
            print(f"{user['id']:<5} {user['nome']:<30} {user['email']:<35} {admin_status}")
            
            if not user['is_admin']:
                emails_to_promote.append(user['email'])
        
        # Verificar se há usuários não encontrados
        found_emails = {user['email'] for user in existing_users}
        missing_emails = set(ADMIN_EMAILS) - found_emails
        
        if missing_emails:
            print("\n⚠️  Usuários NÃO encontrados (precisam criar conta):")
            for email in missing_emails:
                print(f"   - {email}")
        
        # Promover usuários
        if emails_to_promote:
            print("\n" + "=" * 70)
            print(f"🔄 {len(emails_to_promote)} usuário(s) será(ão) promovido(s) a ADMINISTRADOR")
            print("=" * 70)
            
            confirm = input("\nDeseja continuar? (s/N): ")
            
            if confirm.lower() != 's':
                print("\n❌ Operação cancelada pelo usuário\n")
                return 0
            
            # Executar atualização
            count = set_admins(conn, emails_to_promote)
            print(f"\n✅ {count} usuário(s) promovido(s) com sucesso!")
        else:
            print("\n✨ Todos os usuários encontrados já são administradores!")
        
        # Mostrar resultado final
        print("\n" + "=" * 70)
        print("📊 ADMINISTRADORES ATUAIS DO SISTEMA")
        print("=" * 70 + "\n")
        
        all_admins = get_all_admins(conn)
        
        if all_admins:
            print(f"Total: {len(all_admins)} administrador(es)\n")
            print(f"{'ID':<5} {'Nome':<30} {'E-mail':<35} {'Cadastro'}")
            print("-" * 78)
            for admin in all_admins:
                created_at = admin['created_at']
                if hasattr(created_at, 'strftime'):
                    created = created_at.strftime('%d/%m/%Y')
                elif created_at:
                    created = str(created_at)[:10]
                else:
                    created = 'N/A'
                print(f"{admin['id']:<5} {admin['nome']:<30} {admin['email']:<35} {created}")
        else:
            print("⚠️  Nenhum administrador configurado no sistema")
        
        print("\n" + "=" * 70)
        print("✅ Processo concluído com sucesso!")
        print("=" * 70 + "\n")
    
    except pymysql.Error as e:
        print(f"\n❌ Erro de banco de dados: {e}\n")
        return 1
    except Exception as e:
        print(f"\n❌ Erro: {e}\n")
        return 1
    finally:
        if 'conn' in locals():
            conn.close()
    
    return 0

if __name__ == '__main__':
    sys.exit(main())