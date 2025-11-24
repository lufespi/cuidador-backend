import jwt
from datetime import datetime, timedelta, timezone
from config.settings import Config

def generate_token(user_id):
    """Gera um token JWT para o usuário"""
    now = datetime.now(timezone.utc)
    payload = {
        'user_id': user_id,
        'exp': now + timedelta(seconds=Config.JWT_EXPIRATION),
        'iat': now
    }
    return jwt.encode(payload, Config.JWT_SECRET, algorithm='HS256')

def decode_token(token):
    """Decodifica e valida um token JWT"""
    try:
        payload = jwt.decode(token, Config.JWT_SECRET, algorithms=['HS256'])
        return payload
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None
