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
            comorbidades=data.get('comorbidades'),
            data_share_preference=data.get('data_share_preference')
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


@auth_bp.route('/reset-password', methods=['POST'])
def reset_password():
    """Reseta a senha do usuário (esqueci minha senha)"""
    data = request.get_json()
    
    email = data.get('email')
    new_password = data.get('nova_senha')
    
    # Validação
    if not email or not new_password:
        return jsonify({'error': 'Email e nova senha são obrigatórios'}), 400
    
    if len(new_password) < 6:
        return jsonify({'error': 'Nova senha deve ter pelo menos 6 caracteres'}), 400
    
    try:
        # Reseta senha
        success, message = User.reset_password(email, new_password)
        
        if not success:
            return jsonify({'error': message}), 404
        
        return jsonify({'message': message}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/delete-account', methods=['DELETE'])
def delete_account():
    """Deleta a conta do usuário e todos os seus dados"""
    from api.middleware.auth import require_auth
    from flask import g
    
    # Verifica autenticação
    auth_result = require_auth()
    if auth_result:  # Se retornou algo, é um erro
        return auth_result
    
    data = request.get_json() or {}
    
    # Solicita confirmação com senha para segurança
    senha = data.get('senha')
    
    if not senha:
        return jsonify({'error': 'Senha é obrigatória para confirmar a exclusão'}), 400
    
    try:
        # Busca usuário
        user = User.find_by_id(g.user_id)
        
        if not user:
            return jsonify({'error': 'Usuário não encontrado'}), 404
        
        # Verifica senha
        if not User.check_password(senha, user['password_hash']):
            return jsonify({'error': 'Senha incorreta'}), 401
        
        # Deleta conta e todos os dados
        success, message = User.delete(g.user_id)
        
        if not success:
            return jsonify({'error': message}), 500
        
        return jsonify({'message': message}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@auth_bp.route('/notification-preferences', methods=['GET'])
def get_notification_preferences():
    """Retorna as preferências de notificação do usuário"""
    from api.middleware.auth import require_auth
    from flask import g
    import json
    
    # Verifica autenticação
    auth_result = require_auth()
    if auth_result:
        return auth_result
    
    try:
        user = User.find_by_id(g.user_id)
        
        if not user:
            return jsonify({'error': 'Usuário não encontrado'}), 404
        
        # Retorna as preferências ou valores padrão
        preferences = user.get('notification_preferences')
        
        if preferences:
            # Se estiver armazenado como string JSON, converte
            if isinstance(preferences, str):
                preferences = json.loads(preferences)
        else:
            # Valores padrão
            preferences = {
                'enabled': True,
                'types': {
                    'exercise': {'enabled': True, 'time': '08:00'},
                    'medication': {'enabled': True, 'time': '12:00'},
                    'appointment': {'enabled': True, 'time': '14:00'},
                    'practice': {'enabled': True, 'time': '18:00'},
                    'hydration': {'enabled': True, 'time': '10:00'},
                    'diet': {'enabled': True, 'time': '12:00'}
                }
            }
        
        return jsonify(preferences), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@auth_bp.route('/notification-preferences', methods=['PUT'])
def update_notification_preferences():
    """Atualiza as preferências de notificação do usuário"""
    from api.middleware.auth import require_auth
    from flask import g
    import json
    
    # Verifica autenticação
    auth_result = require_auth()
    if auth_result:
        return auth_result
    
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'Dados de preferências são obrigatórios'}), 400
    
    try:
        # Atualiza as preferências
        success = User.update_notification_preferences(g.user_id, data)
        
        if success:
            return jsonify({
                'message': 'Preferências de notificação atualizadas',
                'preferences': data
            }), 200
        else:
            return jsonify({'error': 'Erro ao atualizar preferências'}), 500
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
