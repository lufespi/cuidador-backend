import json
from datetime import datetime
from api.db import get_connection

class PainRecord:
    @staticmethod
    def create(user_id, body_parts, intensidade, descricao=None, data_registro=None):
        """Cria um novo registro de dor"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            # Se data_registro foi fornecida, converte string ISO para datetime
            if data_registro and isinstance(data_registro, str):
                data_registro = datetime.fromisoformat(data_registro.replace('Z', '+00:00'))
            
            # Verifica quais colunas existem na tabela
            cursor.execute("SHOW COLUMNS FROM pain_records")
            columns = {col['Field'] for col in cursor.fetchall()}
            
            # Converte lista para JSON string
            body_parts_json = json.dumps(body_parts)
            data_value = data_registro or datetime.now()
            
            # Monta SQL baseado nas colunas disponíveis
            if 'descricao' in columns and 'data_registro' in columns:
                # Schema novo
                sql = """
                    INSERT INTO pain_records (user_id, body_parts, intensidade, descricao, data_registro)
                    VALUES (%s, %s, %s, %s, %s)
                """
                cursor.execute(sql, (user_id, body_parts_json, intensidade, descricao, data_value))
            else:
                # Schema antigo (compatibilidade)
                sql = """
                    INSERT INTO pain_records (user_id, body_parts, intensidade, observacoes, data)
                    VALUES (%s, %s, %s, %s, %s)
                """
                cursor.execute(sql, (user_id, body_parts_json, intensidade, descricao, data_value))
            
            conn.commit()
            
            record_id = cursor.lastrowid
            
            # Busca e retorna o registro completo criado
            cursor.execute("SELECT * FROM pain_records WHERE id = %s", (record_id,))
            record = cursor.fetchone()
            
            if record:
                # Normaliza nomes das colunas para o padrão novo
                if 'observacoes' in record and 'descricao' not in record:
                    record['descricao'] = record.pop('observacoes')
                if 'data' in record and 'data_registro' not in record:
                    record['data_registro'] = record.pop('data')
                
                if 'body_parts' in record and isinstance(record['body_parts'], str):
                    record['body_parts'] = json.loads(record['body_parts'])
            
            return record
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def find_by_user(user_id, start_date=None, end_date=None, limit=50):
        """Busca registros de dor de um usuário com filtros opcionais"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            # Verifica quais colunas existem
            cursor.execute("SHOW COLUMNS FROM pain_records")
            columns = {col['Field'] for col in cursor.fetchall()}
            
            # Usa nome correto da coluna de data
            date_column = 'data_registro' if 'data_registro' in columns else 'data'
            
            # Monta query com filtros dinâmicos
            sql = f"SELECT * FROM pain_records WHERE user_id = %s"
            params = [user_id]
            
            if start_date:
                sql += f" AND {date_column} >= %s"
                params.append(start_date)
            
            if end_date:
                sql += f" AND {date_column} <= %s"
                params.append(end_date)
            
            sql += f" ORDER BY {date_column} DESC LIMIT %s"
            params.append(limit)
            
            cursor.execute(sql, tuple(params))
            records = cursor.fetchall()
            
            # Normaliza nomes das colunas e converte JSON
            for record in records:
                # Normaliza nomes
                if 'observacoes' in record and 'descricao' not in record:
                    record['descricao'] = record.pop('observacoes')
                if 'data' in record and 'data_registro' not in record:
                    record['data_registro'] = record.pop('data')
                
                # Converte JSON
                if 'body_parts' in record and isinstance(record['body_parts'], str):
                    record['body_parts'] = json.loads(record['body_parts'])
            
            return records
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def find_by_id(record_id, user_id):
        """Busca um registro específico por ID (validando que pertence ao usuário)"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            sql = "SELECT * FROM pain_records WHERE id = %s AND user_id = %s"
            cursor.execute(sql, (record_id, user_id))
            record = cursor.fetchone()
            
            if record:
                # Normaliza nomes das colunas
                if 'observacoes' in record and 'descricao' not in record:
                    record['descricao'] = record.pop('observacoes')
                if 'data' in record and 'data_registro' not in record:
                    record['data_registro'] = record.pop('data')
                
                # Converte JSON
                if 'body_parts' in record and isinstance(record['body_parts'], str):
                    record['body_parts'] = json.loads(record['body_parts'])
            
            return record
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def delete(record_id, user_id):
        """Deleta um registro de dor"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            sql = "DELETE FROM pain_records WHERE id = %s AND user_id = %s"
            cursor.execute(sql, (record_id, user_id))
            conn.commit()
            
            return cursor.rowcount > 0
            
        finally:
            cursor.close()
            conn.close()
