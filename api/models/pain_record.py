import json
from api.db import get_connection

class PainRecord:
    @staticmethod
    def create(user_id, body_parts, intensidade, observacoes=None):
        """Cria um novo registro de dor"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            sql = """
                INSERT INTO pain_records (user_id, body_parts, intensidade, observacoes)
                VALUES (%s, %s, %s, %s)
            """
            # Converte lista para JSON string
            body_parts_json = json.dumps(body_parts)
            cursor.execute(sql, (user_id, body_parts_json, intensidade, observacoes))
            conn.commit()
            
            return cursor.lastrowid
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def find_by_user(user_id, limit=50):
        """Busca registros de dor de um usuário"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            sql = """
                SELECT * FROM pain_records 
                WHERE user_id = %s 
                ORDER BY data DESC 
                LIMIT %s
            """
            cursor.execute(sql, (user_id, limit))
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
