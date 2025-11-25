import bcrypt
from api.db import get_connection

class User:
    @staticmethod
    def create(email, password, nome=None, telefone=None, data_nascimento=None, sexo=None, diagnostico=None, comorbidades=None, data_share_preference='none'):
        """Cria um novo usuário no banco"""
        # Hash da senha
        password_hash = bcrypt.hashpw(
            password.encode('utf-8'),
            bcrypt.gensalt()
        ).decode('utf-8')
        
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            sql = """
                INSERT INTO users (email, password_hash, nome, telefone, data_nascimento, sexo, diagnostico, comorbidades, data_share_preference)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(sql, (email, password_hash, nome, telefone, data_nascimento, sexo, diagnostico, comorbidades, data_share_preference))
            conn.commit()
            
            return cursor.lastrowid
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def find_by_email(email):
        """Busca usuário por email"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            sql = "SELECT * FROM users WHERE email = %s"
            cursor.execute(sql, (email,))
            return cursor.fetchone()
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def find_by_id(user_id):
        """Busca usuário por ID"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            sql = "SELECT * FROM users WHERE id = %s"
            cursor.execute(sql, (user_id,))
            return cursor.fetchone()
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def check_password(password, password_hash):
        """Verifica se a senha está correta"""
        return bcrypt.checkpw(
            password.encode('utf-8'),
            password_hash.encode('utf-8')
        )
    
    @staticmethod
    def update(user_id, nome=None, telefone=None, data_nascimento=None, sexo=None, diagnostico=None, comorbidades=None, data_share_preference=None):
        """Atualiza dados do usuário"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            # Monta query dinamicamente apenas com campos fornecidos
            updates = []
            values = []
            
            if nome is not None:
                updates.append("nome = %s")
                values.append(nome)
            
            if telefone is not None:
                updates.append("telefone = %s")
                values.append(telefone)
            
            if data_nascimento is not None:
                updates.append("data_nascimento = %s")
                values.append(data_nascimento)
            
            if sexo is not None:
                updates.append("sexo = %s")
                values.append(sexo)
            
            if diagnostico is not None:
                updates.append("diagnostico = %s")
                values.append(diagnostico)
            
            if comorbidades is not None:
                updates.append("comorbidades = %s")
                values.append(comorbidades)
            
            if data_share_preference is not None:
                updates.append("data_share_preference = %s")
                values.append(data_share_preference)
            
            if not updates:
                return True  # Nada para atualizar
            
            values.append(user_id)
            sql = f"UPDATE users SET {', '.join(updates)} WHERE id = %s"
            cursor.execute(sql, tuple(values))
            conn.commit()
            
            return True
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def change_password(user_id, old_password, new_password):
        """Altera a senha do usuário"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            # Busca usuário
            sql = "SELECT password_hash FROM users WHERE id = %s"
            cursor.execute(sql, (user_id,))
            user = cursor.fetchone()
            
            if not user:
                return False, "Usuário não encontrado"
            
            # Verifica senha antiga
            if not User.check_password(old_password, user['password_hash']):
                return False, "Senha atual incorreta"
            
            # Hash da nova senha
            new_password_hash = bcrypt.hashpw(
                new_password.encode('utf-8'),
                bcrypt.gensalt()
            ).decode('utf-8')
            
            # Atualiza senha
            sql = "UPDATE users SET password_hash = %s WHERE id = %s"
            cursor.execute(sql, (new_password_hash, user_id))
            conn.commit()
            
            return True, "Senha alterada com sucesso"
            
        finally:
            cursor.close()
            conn.close()
    
    @staticmethod
    def reset_password(email, new_password):
        """Reseta a senha do usuário pelo email"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            # Verifica se usuário existe
            sql = "SELECT id FROM users WHERE email = %s"
            cursor.execute(sql, (email,))
            user = cursor.fetchone()
            
            if not user:
                return False, "Email não encontrado"
            
            # Hash da nova senha
            new_password_hash = bcrypt.hashpw(
                new_password.encode('utf-8'),
                bcrypt.gensalt()
            ).decode('utf-8')
            
            # Atualiza senha
            sql = "UPDATE users SET password_hash = %s WHERE email = %s"
            cursor.execute(sql, (new_password_hash, email))
            conn.commit()
            
            return True, "Senha redefinida com sucesso"
            
        finally:
            cursor.close()
            conn.close()

    @staticmethod
    def delete(user_id):
        """Deleta usuário e todos os seus dados relacionados do banco"""
        conn = get_connection()
        cursor = conn.cursor()
        
        try:
            # Deleta registros relacionados em cascata
            # 1. Deleta registros de dor
            cursor.execute("DELETE FROM pain_records WHERE user_id = %s", (user_id,))
            
            # 2. Deleta lembretes (tabela ainda não implementada, mas mantendo para quando for criada)
            try:
                cursor.execute("DELETE FROM reminders WHERE user_id = %s", (user_id,))
            except Exception:
                pass  # Ignora se a tabela ainda não existe
            
            # 3. Deleta feedback
            cursor.execute("DELETE FROM feedback WHERE user_id = %s", (user_id,))
            
            # 4. Por fim, deleta o usuário
            cursor.execute("DELETE FROM users WHERE id = %s", (user_id,))
            
            conn.commit()
            
            return True, "Conta excluída com sucesso"
            
        except Exception as e:
            conn.rollback()
            return False, f"Erro ao excluir conta: {str(e)}"
            
        finally:
            cursor.close()
            conn.close()
