import json
from datetime import datetime
from api.db import get_connection

class PainRecord:
    @staticmethod
    def create(user_id, body_parts, intensidade, descricao=None, data_registro=None):
        """Cria um novo registro de dor - compatível com schema existente"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            # Converte data se necessário
            if data_registro and isinstance(data_registro, str):
                data_registro = datetime.fromisoformat(data_registro.replace('Z', '+00:00'))
            
            # Converte lista de body_parts para JSON string
            body_parts_json = json.dumps(body_parts)
            
            # Usa as colunas que existem na tabela atual
            sql = """
                INSERT INTO pain_records 
                (user_id, body_parts, intensity, description, timestamp)
                VALUES (%s, %s, %s, %s, %s)
            """
            
            cursor.execute(sql, (
                user_id,
                body_parts_json,
                intensidade,
                descricao or '',
                data_registro or datetime.now()
            ))
            conn.commit()
            
            record_id = cursor.lastrowid
            
            # Busca o registro criado
            cursor.execute("SELECT * FROM pain_records WHERE id = %s", (record_id,))
            record = cursor.fetchone()
            
            # Normaliza resposta para formato esperado pelo frontend
            if record:
                normalized = {
                    'id': str(record.get('id')),
                    'user_id': str(record.get('user_id')),
                    'body_parts': json.loads(record.get('body_parts', '[]')) if isinstance(record.get('body_parts'), str) else (record.get('body_parts') or []),
                    'intensidade': record.get('intensity', 0),
                    'descricao': record.get('description') or record.get('descricao'),
                    'data_registro': record.get('timestamp') or record.get('created_at'),
                    'created_at': record.get('created_at'),
                    'updated_at': record.get('updated_at')
                }
                return normalized
            
            return None
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def find_by_user(user_id, start_date=None, end_date=None, limit=50):
        """Busca registros de dor de um usuário"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            # Monta query usando as colunas existentes
            sql = "SELECT * FROM pain_records WHERE user_id = %s"
            params = [user_id]
            
            if start_date:
                sql += " AND timestamp >= %s"
                params.append(start_date)
            
            if end_date:
                sql += " AND timestamp <= %s"
                params.append(end_date)
            
            sql += " ORDER BY timestamp DESC LIMIT %s"
            params.append(limit)
            
            cursor.execute(sql, tuple(params))
            records = cursor.fetchall()
            
            # Normaliza todos os registros para formato do frontend
            normalized_records = []
            for record in records:
                normalized = {
                    'id': str(record.get('id')),
                    'user_id': str(record.get('user_id')),
                    'body_parts': json.loads(record.get('body_parts', '[]')) if isinstance(record.get('body_parts'), str) else (record.get('body_parts') or []),
                    'intensidade': record.get('intensity', 0),
                    'descricao': record.get('description') or record.get('descricao') or 'Sem descrição',
                    'data_registro': record.get('timestamp') or record.get('created_at'),
                    'created_at': record.get('created_at'),
                    'updated_at': record.get('updated_at')
                }
                normalized_records.append(normalized)
            
            return normalized_records
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def find_by_id(record_id, user_id):
        """Busca um registro específico por ID"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            sql = "SELECT * FROM pain_records WHERE id = %s AND user_id = %s"
            cursor.execute(sql, (record_id, user_id))
            record = cursor.fetchone()
            
            if record:
                # Normaliza para formato do frontend
                normalized = {
                    'id': str(record.get('id')),
                    'user_id': str(record.get('user_id')),
                    'body_parts': json.loads(record.get('body_parts', '[]')) if isinstance(record.get('body_parts'), str) else (record.get('body_parts') or []),
                    'intensidade': record.get('intensity', 0),
                    'descricao': record.get('description') or record.get('descricao') or 'Sem descrição',
                    'data_registro': record.get('timestamp') or record.get('created_at'),
                    'created_at': record.get('created_at'),
                    'updated_at': record.get('updated_at')
                }
                return normalized
            
            return None
            
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
    
    @staticmethod
    def update(record_id, user_id, intensidade=None, descricao=None, data_registro=None):
        """Atualiza um registro de dor existente"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            # Busca o registro atual para verificar se existe e pertence ao usuário
            cursor.execute("SELECT * FROM pain_records WHERE id = %s AND user_id = %s", (record_id, user_id))
            existing = cursor.fetchone()
            
            if not existing:
                return None
            
            # Monta query de update dinâmica baseada nos campos fornecidos
            updates = []
            params = []
            
            if intensidade is not None:
                updates.append("intensity = %s")
                params.append(intensidade)
            
            if descricao is not None:
                updates.append("description = %s")
                params.append(descricao)
            
            if data_registro is not None:
                # Converte data se necessário
                if isinstance(data_registro, str):
                    data_registro = datetime.fromisoformat(data_registro.replace('Z', '+00:00'))
                updates.append("timestamp = %s")
                params.append(data_registro)
            
            # Se não há nada para atualizar, retorna o registro atual
            if not updates:
                normalized = {
                    'id': str(existing.get('id')),
                    'user_id': str(existing.get('user_id')),
                    'body_parts': json.loads(existing.get('body_parts', '[]')) if isinstance(existing.get('body_parts'), str) else (existing.get('body_parts') or []),
                    'intensidade': existing.get('intensity', 0),
                    'descricao': existing.get('description') or existing.get('descricao'),
                    'data_registro': existing.get('timestamp') or existing.get('created_at'),
                    'created_at': existing.get('created_at'),
                    'updated_at': existing.get('updated_at')
                }
                return normalized
            
            # Adiciona updated_at
            updates.append("updated_at = NOW()")
            
            # Adiciona condições WHERE
            params.extend([record_id, user_id])
            
            sql = f"UPDATE pain_records SET {', '.join(updates)} WHERE id = %s AND user_id = %s"
            cursor.execute(sql, tuple(params))
            conn.commit()
            
            # Busca o registro atualizado
            cursor.execute("SELECT * FROM pain_records WHERE id = %s", (record_id,))
            record = cursor.fetchone()
            
            if record:
                normalized = {
                    'id': str(record.get('id')),
                    'user_id': str(record.get('user_id')),
                    'body_parts': json.loads(record.get('body_parts', '[]')) if isinstance(record.get('body_parts'), str) else (record.get('body_parts') or []),
                    'intensidade': record.get('intensity', 0),
                    'descricao': record.get('description') or record.get('descricao'),
                    'data_registro': record.get('timestamp') or record.get('created_at'),
                    'created_at': record.get('created_at'),
                    'updated_at': record.get('updated_at')
                }
                return normalized
            
            return None
            
        finally:
            cursor.close()
            conn.close()
