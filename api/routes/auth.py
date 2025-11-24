from flask import Blueprint, request, jsonify
from api.models.user import User
from utils.jwt_handler import generate_token

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    """Registra um novo usuário"""
    data = request.get_json()
    
    email = data.get('email')
    senha = data.get('senha')
    
    # Validação
    if not email or not senha:
        return jsonify({'error': 'Email e senha são obrigatórios'}), 400
    
    # Verifica se email já existe
    existing_user = User.find_by_email(email)
    if existing_user:
        return jsonify({'error': 'Email já cadastrado'}), 409
    
    try:
        # Cria usuário
        user_id = User.create(
            email=email,
            password=senha,
            nome=data.get('nome'),
            telefone=data.get('telefone'),
            data_nascimento=data.get('data_nascimento'),
            sexo=data.get('sexo'),
            diagnostico=data.get('diagnostico'),
            comorbidades=data.get('comorbidades')
        )
        
        # Gera token
        token = generate_token(user_id)
        
        # Busca usuário criado
        user = User.find_by_id(user_id)
        
        # Remove password_hash da resposta
        if user and 'password_hash' in user:
            del user['password_hash']
        
        # Converte datas para formato ISO
        if user:
            from datetime import date, datetime
            for key, value in user.items():
                if isinstance(value, (date, datetime)):
                    if value.year > 1900:
                        user[key] = value.isoformat()
                    else:
                        user[key] = None
        
        return jsonify({
            'message': 'Usuário cadastrado com sucesso',
            'token': token,
            'user': user
        }), 201
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@auth_bp.route('/login', methods=['POST'])
def login():
    """Faz login de um usuário"""
    data = request.get_json()
    
    email = data.get('email')
    senha = data.get('senha')
    
    # Validação
    if not email or not senha:
        return jsonify({'error': 'Email e senha são obrigatórios'}), 400
    
    try:
        # Busca usuário
        user = User.find_by_email(email)
        
        if not user:
            return jsonify({'error': 'Credenciais inválidas'}), 401
        
        # Verifica senha
        if not User.check_password(senha, user['password_hash']):
            return jsonify({'error': 'Credenciais inválidas'}), 401
        
        # Gera token
        token = generate_token(user['id'])
        
        # Remove password_hash da resposta
        if 'password_hash' in user:
            del user['password_hash']
        
        # Converte datas para formato ISO
        from datetime import date, datetime
        for key, value in user.items():
            if isinstance(value, (date, datetime)):
                if value.year > 1900:
                    user[key] = value.isoformat()
                else:
                    user[key] = None
        
        return jsonify({
            'message': 'Login realizado com sucesso',
            'token': token,
            'user': user
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@auth_bp.route('/profile', methods=['GET'])
def get_profile():
    """Retorna o perfil do usuário autenticado"""
    from api.middleware.auth import require_auth
    from flask import g
    from datetime import date, datetime
    
    # Verifica autenticação
    auth_result = require_auth()
    if auth_result:  # Se retornou algo, é um erro
        return auth_result
    
    try:
        # Busca usuário pelo ID do token
        user = User.find_by_id(g.user_id)
        
        if not user:
            return jsonify({'error': 'Usuário não encontrado'}), 404
        
        # Remove password_hash da resposta
        if 'password_hash' in user:
            del user['password_hash']
        
        # Converte datas para formato ISO string
        for key, value in user.items():
            if isinstance(value, (date, datetime)):
                # Ignora datas inválidas (0000-00-00)
                if value.year > 1900:
                    user[key] = value.isoformat()
                else:
                    user[key] = None
        
        return jsonify({'user': user}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@auth_bp.route('/profile', methods=['PUT'])
def update_profile():
    """Atualiza o perfil do usuário autenticado"""
    from api.middleware.auth import require_auth
    from flask import g
    from datetime import date, datetime
    
    # Verifica autenticação
    auth_result = require_auth()
    if auth_result:
        return auth_result
    
    data = request.get_json()
    
    try:
        # Atualiza dados do usuário
        User.update(
            user_id=g.user_id,
            nome=data.get('nome'),
            telefone=data.get('telefone'),
            data_nascimento=data.get('data_nascimento'),
            sexo=data.get('sexo'),
            diagnostico=data.get('diagnostico'),
            comorbidades=data.get('comorbidades')
        )
        
        # Busca usuário atualizado
        user = User.find_by_id(g.user_id)
        
        if not user:
            return jsonify({'error': 'Usuário não encontrado'}), 404
        
        # Remove password_hash da resposta
        if 'password_hash' in user:
            del user['password_hash']
        
        # Converte datas para formato ISO
        for key, value in user.items():
            if isinstance(value, (date, datetime)):
                if value.year > 1900:
                    user[key] = value.isoformat()
                else:
                    user[key] = None
        
        return jsonify({
            'message': 'Perfil atualizado com sucesso',
            'user': user
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@auth_bp.route('/password', methods=['PUT'])
def change_password():
    """Altera a senha do usuário autenticado"""
    from api.middleware.auth import require_auth
    from flask import g
    
    # Verifica autenticação
    auth_result = require_auth()
    if auth_result:
        return auth_result
    
    data = request.get_json()
    
    current_password = data.get('senha_atual')
    new_password = data.get('nova_senha')
    
    # Validação
    if not current_password or not new_password:
        return jsonify({'error': 'Senha atual e nova senha são obrigatórias'}), 400
    
    if len(new_password) < 6:
        return jsonify({'error': 'Nova senha deve ter pelo menos 6 caracteres'}), 400
    
    try:
        # Altera senha
        success, message = User.change_password(g.user_id, current_password, new_password)
        
        if not success:
            return jsonify({'error': message}), 401
        
        return jsonify({'message': message}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
