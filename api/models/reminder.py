import json
from api.db import get_connection
from datetime import datetime

class Reminder:
    @staticmethod
    def create(user_id, type, title, description, frequency, time, is_active=True, selected_days=None):
        """Cria um novo lembrete no banco"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            # Converte selected_days para JSON se fornecido
            days_json = json.dumps(selected_days) if selected_days else None
            
            sql = """
                INSERT INTO reminders 
                (user_id, type, title, description, frequency, time, is_active, selected_days, created_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(sql, (
                user_id, type, title, description, frequency, time, 
                is_active, days_json, datetime.now()
            ))
            conn.commit()
            
            return cursor.lastrowid
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def find_by_user(user_id):
        """Busca todos os lembretes de um usuário"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            sql = """
                SELECT id, user_id, type, title, description, frequency, 
                       time, is_active, selected_days, created_at, updated_at
                FROM reminders 
                WHERE user_id = %s
                ORDER BY created_at DESC
            """
            cursor.execute(sql, (user_id,))
            reminders = cursor.fetchall()
            
            # Converte selected_days de JSON para dict
            for reminder in reminders:
                if reminder.get('selected_days'):
                    try:
                        reminder['selected_days'] = json.loads(reminder['selected_days'])
                    except:
                        reminder['selected_days'] = None
            
            return reminders
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def find_by_id(reminder_id):
        """Busca um lembrete específico por ID"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            sql = """
                SELECT id, user_id, type, title, description, frequency, 
                       time, is_active, selected_days, created_at, updated_at
                FROM reminders 
                WHERE id = %s
            """
            cursor.execute(sql, (reminder_id,))
            reminder = cursor.fetchone()
            
            # Converte selected_days de JSON para dict
            if reminder and reminder.get('selected_days'):
                try:
                    reminder['selected_days'] = json.loads(reminder['selected_days'])
                except:
                    reminder['selected_days'] = None
            
            return reminder
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def update(reminder_id, type=None, title=None, description=None, 
               frequency=None, time=None, is_active=None, selected_days=None):
        """Atualiza um lembrete existente"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            # Monta query dinâmica apenas com campos fornecidos
            updates = []
            values = []
            
            if type is not None:
                updates.append("type = %s")
                values.append(type)
            
            if title is not None:
                updates.append("title = %s")
                values.append(title)
            
            if description is not None:
                updates.append("description = %s")
                values.append(description)
            
            if frequency is not None:
                updates.append("frequency = %s")
                values.append(frequency)
            
            if time is not None:
                updates.append("time = %s")
                values.append(time)
            
            if is_active is not None:
                updates.append("is_active = %s")
                values.append(is_active)
            
            if selected_days is not None:
                updates.append("selected_days = %s")
                values.append(json.dumps(selected_days))
            
            if not updates:
                return True  # Nada para atualizar
            
            # Adiciona updated_at
            updates.append("updated_at = %s")
            values.append(datetime.now())
            
            # Adiciona reminder_id ao final
            values.append(reminder_id)
            
            sql = f"UPDATE reminders SET {', '.join(updates)} WHERE id = %s"
            cursor.execute(sql, values)
            conn.commit()
            
            return cursor.rowcount > 0
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def delete(reminder_id):
        """Deleta um lembrete"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            sql = "DELETE FROM reminders WHERE id = %s"
            cursor.execute(sql, (reminder_id,))
            conn.commit()
            
            return cursor.rowcount > 0
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def verify_ownership(reminder_id, user_id):
        """Verifica se o lembrete pertence ao usuário"""
        reminder = Reminder.find_by_id(reminder_id)
        return reminder and reminder.get('user_id') == user_id
