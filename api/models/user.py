import bcrypt
from api.db import get_connection

class User:
    @staticmethod
    def create(email, password, nome=None, telefone=None, data_nascimento=None, sexo=None):
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
                INSERT INTO users (email, password_hash, nome, telefone, data_nascimento, sexo)
                VALUES (%s, %s, %s, %s, %s, %s)
            """
            cursor.execute(sql, (email, password_hash, nome, telefone, data_nascimento, sexo))
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
    def update(user_id, nome=None, telefone=None, data_nascimento=None, sexo=None):
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
