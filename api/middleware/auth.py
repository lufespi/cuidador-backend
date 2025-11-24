from functools import wraps
from flask import request, jsonify, g
from utils.jwt_handler import decode_token

def token_required(f):
    """Decorator para proteger rotas que precisam de autenticação"""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')
        
        if not token:
            return jsonify({'error': 'Token ausente'}), 401
        
        # Remove "Bearer " se presente
        if token.startswith('Bearer '):
            token = token[7:]
        
        payload = decode_token(token)
        if not payload:
            return jsonify({'error': 'Token inválido ou expirado'}), 401
        
        # Adiciona user_id ao request
        request.user_id = payload['user_id']
        return f(*args, **kwargs)
    
    return decorated


def require_auth():
    """Valida autenticação e retorna erro se inválido, ou None se válido"""
    token = request.headers.get('Authorization')
    
    if not token:
        return jsonify({'error': 'Token ausente'}), 401
    
    # Remove "Bearer " se presente
    if token.startswith('Bearer '):
        token = token[7:]
    
    payload = decode_token(token)
    if not payload:
        return jsonify({'error': 'Token inválido ou expirado'}), 401
    
    # Salva user_id no contexto global do Flask
    g.user_id = payload['user_id']
    return None  # Sem erro
