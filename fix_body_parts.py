#!/usr/bin/env python3
"""
Script de emergência para adicionar coluna body_parts
Execute no console do PythonAnywhere se o erro persistir
"""

import pymysql
from config.settings import Config

def fix_body_parts_column():
    """Adiciona coluna body_parts se não existir"""
    print("🔧 Verificando estrutura da tabela pain_records...")
    
    try:
        conn = pymysql.connect(
            host=Config.DB_HOST,
            user=Config.DB_USER,
            password=Config.DB_PASSWORD,
            database=Config.DB_NAME,
            charset="utf8mb4",
            cursorclass=pymysql.cursors.DictCursor
        )
        cursor = conn.cursor()
        
        # Verifica colunas existentes
        cursor.execute("SHOW COLUMNS FROM pain_records")
        columns = {col['Field'] for col in cursor.fetchall()}
        
        print(f"📋 Colunas encontradas: {columns}")
        
        # Adiciona body_parts se não existir
        if 'body_parts' not in columns:
            print("⚠️  Coluna 'body_parts' não encontrada! Adicionando...")
            cursor.execute("ALTER TABLE pain_records ADD COLUMN body_parts JSON")
            
            # Inicializa com array vazio para registros existentes
            cursor.execute("UPDATE pain_records SET body_parts = '[]' WHERE body_parts IS NULL")
            
            conn.commit()
            print("✅ Coluna 'body_parts' adicionada com sucesso!")
        else:
            print("✅ Coluna 'body_parts' já existe!")
        
        # Verifica novamente
        cursor.execute("SHOW COLUMNS FROM pain_records")
        columns_after = {col['Field'] for col in cursor.fetchall()}
        print(f"📋 Colunas após correção: {columns_after}")
        
        cursor.close()
        conn.close()
        
        print("\n🎉 Correção aplicada com sucesso!")
        return True
        
    except Exception as e:
        print(f"❌ Erro: {e}")
        return False

if __name__ == '__main__':
    fix_body_parts_column()
