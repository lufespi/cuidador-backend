#!/usr/bin/env python3
"""
Script para verificar se o setup de admin está correto
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

def main():
    print("=" * 80)
    print("🔍 VERIFICAÇÃO DO SETUP DE ADMINISTRADORES")
    print("=" * 80)
    
    try:
        conn = pymysql.connect(**DB_CONFIG)
        print("\n✅ Conectado ao banco de dados\n")
        
        with conn.cursor() as cursor:
            # 1. Verificar se campo is_admin existe
            print("📋 1. Verificando campo is_admin na tabela users...")
            cursor.execute("""
                SELECT COUNT(*) as count
                FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_SCHEMA = %s
                AND TABLE_NAME = 'users' 
                AND COLUMN_NAME = 'is_admin'
            """, (DB_CONFIG['database'],))
            
            result = cursor.fetchone()
            has_is_admin = result[0] > 0
            
            if has_is_admin:
                print("   ✅ Campo is_admin existe")
            else:
                print("   ❌ Campo is_admin NÃO existe")
                print("\n   Execute primeiro:")
                print("   cd ~/cuidador-backend/scripts")
                print("   python3 add_missing_fields.py")
                return 1
            
            # 2. Verificar usuários admin
            print("\n📋 2. Verificando usuários administradores...")
            cursor.execute("""
                SELECT id, nome, email, is_admin 
                FROM users 
                WHERE is_admin = TRUE
            """)
            
            admins = cursor.fetchall()
            
            if admins:
                print(f"   ✅ {len(admins)} administrador(es) encontrado(s):\n")
                for admin in admins:
                    print(f"      ID: {admin[0]} | Nome: {admin[1]} | Email: {admin[2]}")
            else:
                print("   ⚠️  Nenhum administrador configurado")
                print("\n   Execute:")
                print("   cd ~/cuidador-backend/scripts")
                print("   python3 set_admins.py")
            
            # 3. Verificar todos os usuários
            print("\n📋 3. Lista de todos os usuários:")
            cursor.execute("""
                SELECT id, nome, email, is_admin, created_at 
                FROM users 
                ORDER BY created_at DESC
                LIMIT 10
            """)
            
            users = cursor.fetchall()
            
            if users:
                print(f"\n   {'ID':<5} {'Nome':<30} {'Email':<35} {'Admin':<8} {'Cadastro'}")
                print("   " + "-" * 85)
                for user in users:
                    admin_status = "✓ SIM" if user[3] else "✗ NÃO"
                    created_at = user[4]
                    if hasattr(created_at, 'strftime'):
                        created = created_at.strftime('%d/%m/%Y')
                    elif created_at:
                        created = str(created_at)[:10]
                    else:
                        created = 'N/A'
                    print(f"   {user[0]:<5} {user[1]:<30} {user[2]:<35} {admin_status:<8} {created}")
            else:
                print("   ⚠️  Nenhum usuário cadastrado")
            
            # 4. Verificar estrutura da tabela
            print("\n📋 4. Estrutura da tabela users:")
            cursor.execute("DESCRIBE users")
            columns = cursor.fetchall()
            
            print(f"\n   {'Campo':<25} {'Tipo':<30} {'Null':<8} {'Key':<8}")
            print("   " + "-" * 80)
            for col in columns:
                print(f"   {col[0]:<25} {col[1]:<30} {col[2]:<8} {col[3]:<8}")
        
        conn.close()
        
        print("\n" + "=" * 80)
        print("✅ Verificação concluída!")
        print("=" * 80 + "\n")
        
    except Exception as e:
        print(f"\n❌ Erro: {e}\n")
        return 1
    
    return 0

if __name__ == '__main__':
    sys.exit(main())
