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
            
            sql = """
                INSERT INTO pain_records (user_id, body_parts, intensidade, descricao, data_registro)
                VALUES (%s, %s, %s, %s, %s)
            """
            # Converte lista para JSON string
            body_parts_json = json.dumps(body_parts)
            cursor.execute(sql, (
                user_id, 
                body_parts_json, 
                intensidade, 
                descricao,
                data_registro or datetime.now()
            ))
            conn.commit()
            
            record_id = cursor.lastrowid
            
            # Busca e retorna o registro completo criado
            cursor.execute("SELECT * FROM pain_records WHERE id = %s", (record_id,))
            record = cursor.fetchone()
            
            if record and 'body_parts' in record:
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
            # Monta query com filtros dinâmicos
            sql = "SELECT * FROM pain_records WHERE user_id = %s"
            params = [user_id]
            
            if start_date:
                sql += " AND data_registro >= %s"
                params.append(start_date)
            
            if end_date:
                sql += " AND data_registro <= %s"
                params.append(end_date)
            
            sql += " ORDER BY data_registro DESC LIMIT %s"
            params.append(limit)
            
            cursor.execute(sql, tuple(params))
            records = cursor.fetchall()
            
            # Converte JSON string de volta para lista
            for record in records:
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
            
            if record and 'body_parts' in record and isinstance(record['body_parts'], str):
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
