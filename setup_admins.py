#!/usr/bin/env python3
"""
Script para listar usuários cadastrados e configurar administradores
Execute este script para ver os emails cadastrados e definir os admins

Como usar:
1. Execute no PythonAnywhere: python3 setup_admins.py
2. Digite os emails dos administradores quando solicitado
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

def list_users():
    """Lista todos os usuários cadastrados"""
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        cursor = connection.cursor(dictionary=True)
        
        print("=" * 70)
        print("USUÁRIOS CADASTRADOS NO BANCO DE DADOS")
        print("=" * 70)
        print()
        
        # Buscar todos os usuários
        cursor.execute("""
            SELECT id, email, nome, is_admin, created_at 
            FROM users 
            ORDER BY created_at DESC
        """)
        users = cursor.fetchall()
        
        if not users:
            print("⚠ Nenhum usuário encontrado no banco de dados")
            print("  Cadastre usuários primeiro usando o aplicativo")
            return []
        
        print(f"Total de usuários: {len(users)}\n")
        print(f"{'ID':<5} {'EMAIL':<35} {'NOME':<20} {'ADMIN':<8}")
        print("-" * 70)
        
        for user in users:
            admin_status = "✓ SIM" if user['is_admin'] else "  NÃO"
            nome = user['nome'] or "N/A"
            print(f"{user['id']:<5} {user['email']:<35} {nome:<20} {admin_status}")
        
        cursor.close()
        connection.close()
        
        return [user['email'] for user in users]
        
    except Error as e:
        print(f"✗ Erro ao conectar ao banco de dados: {e}")
        return []

def set_admins(admin_emails):
    """Define quais emails serão administradores"""
    if not admin_emails:
        print("\n⚠ Nenhum email fornecido. Operação cancelada.")
        return False
    
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        cursor = connection.cursor()
        
        print("\n" + "=" * 70)
        print("CONFIGURANDO ADMINISTRADORES")
        print("=" * 70)
        print()
        
        # Primeiro, remover admin de todos
        print("1. Removendo permissões de admin de todos os usuários...")
        cursor.execute("UPDATE users SET is_admin = FALSE")
        print(f"   ✓ {cursor.rowcount} usuários atualizados\n")
        
        # Depois, adicionar admin aos emails especificados
        print("2. Adicionando permissões de admin aos emails selecionados...")
        placeholders = ', '.join(['%s'] * len(admin_emails))
        sql = f"UPDATE users SET is_admin = TRUE WHERE email IN ({placeholders})"
        cursor.execute(sql, admin_emails)
        updated = cursor.rowcount
        
        connection.commit()
        
        if updated > 0:
            print(f"   ✓ {updated} administrador(es) configurado(s) com sucesso!\n")
            print("Administradores configurados:")
            for email in admin_emails:
                print(f"   • {email}")
            return True
        else:
            print(f"   ⚠ Nenhum usuário encontrado com os emails fornecidos")
            print("   Verifique se os emails estão corretos e se os usuários existem")
            return False
            
    except Error as e:
        print(f"✗ Erro ao configurar administradores: {e}")
        return False
    finally:
        if connection and connection.is_connected():
            cursor.close()
            connection.close()

def main():
    """Função principal"""
    print("\n")
    
    # Listar usuários existentes
    available_emails = list_users()
    
    if not available_emails:
        print("\n⚠ Cadastre usuários primeiro antes de configurar administradores")
        return 1
    
    print("\n" + "=" * 70)
    print("CONFIGURAÇÃO DE ADMINISTRADORES")
    print("=" * 70)
    print()
    print("Opções:")
    print("  1. Digite os emails dos administradores (separados por vírgula)")
    print("  2. Pressione ENTER para usar os emails padrão do script anterior")
    print("  3. Digite 'cancelar' para sair")
    print()
    
    user_input = input("Sua escolha: ").strip()
    
    if user_input.lower() == 'cancelar':
        print("Operação cancelada.")
        return 0
    
    if user_input == '':
        # Usar emails padrão
        admin_emails = [
            'admin@cuidador.com',
            'admin2@cuidador.com',
            'admin3@cuidador.com'
        ]
        print(f"\nUsando emails padrão: {', '.join(admin_emails)}")
    else:
        # Processar emails fornecidos
        admin_emails = [email.strip() for email in user_input.split(',')]
        print(f"\nEmails selecionados: {', '.join(admin_emails)}")
    
    # Confirmar
    confirm = input("\nConfirmar configuração? (s/n): ").strip().lower()
    if confirm != 's':
        print("Operação cancelada.")
        return 0
    
    # Configurar administradores
    success = set_admins(admin_emails)
    
    if success:
        print("\n✓ SUCESSO! Administradores configurados.")
        print("\nAgora você pode:")
        print("  • Fazer login no aplicativo com um dos emails admin")
        print("  • Acessar Ajustes > Administrador")
        print("  • Gerenciar usuários e exportar relatórios")
        return 0
    else:
        print("\n✗ Falha ao configurar administradores")
        return 1

if __name__ == "__main__":
    exit(main())
