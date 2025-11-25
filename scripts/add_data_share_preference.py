#!/usr/bin/env python3
"""
Script para adicionar a coluna data_share_preference na tabela users
"""

import sys
import os

# Adiciona o diretório pai ao path para importar o módulo de conexão
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from api.db import get_connection

def add_data_share_preference_column():
    """Adiciona a coluna data_share_preference à tabela users"""
    
    conn = get_connection()
    cursor = conn.cursor()
    
    try:
        print("Verificando se a coluna data_share_preference já existe...")
        
        # Verifica se a coluna já existe
        cursor.execute("""
            SELECT COUNT(*) as count
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = 'users'
            AND COLUMN_NAME = 'data_share_preference'
        """)
        
        result = cursor.fetchone()
        
        if result['count'] > 0:
            print("✓ A coluna data_share_preference já existe na tabela users.")
            return True
        
        print("Adicionando coluna data_share_preference à tabela users...")
        
        # Adiciona a coluna
        cursor.execute("""
            ALTER TABLE users 
            ADD COLUMN data_share_preference VARCHAR(20) DEFAULT 'none' 
            AFTER comorbidades
        """)
        
        conn.commit()
        
        print("✓ Coluna data_share_preference adicionada com sucesso!")
        print("  - Tipo: VARCHAR(20)")
        print("  - Valor padrão: 'none'")
        print("  - Valores aceitos: 'none', 'full', 'diagnostic'")
        
        # Verifica quantos usuários existem
        cursor.execute("SELECT COUNT(*) as count FROM users")
        user_count = cursor.fetchone()['count']
        
        if user_count > 0:
            print(f"\n✓ {user_count} usuário(s) existente(s) foram configurados com o valor padrão 'none'")
        
        return True
        
    except Exception as e:
        conn.rollback()
        print(f"✗ Erro ao adicionar coluna: {str(e)}")
        return False
        
    finally:
        cursor.close()
        conn.close()

def main():
    """Função principal"""
    print("=" * 60)
    print("Script: Adicionar campo data_share_preference")
    print("=" * 60)
    print()
    
    success = add_data_share_preference_column()
    
    print()
    print("=" * 60)
    
    if success:
        print("✓ Script executado com sucesso!")
        print()
        print("Próximos passos:")
        print("1. Recarregue o backend no PythonAnywhere")
        print("2. Teste a funcionalidade em Configurações > Privacidade e Segurança")
        sys.exit(0)
    else:
        print("✗ Script falhou. Verifique os erros acima.")
        sys.exit(1)

if __name__ == "__main__":
    main()
