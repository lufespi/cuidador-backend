from flask import Blueprint, request, jsonify
from api.models.reminder import Reminder
from api.middleware.auth import token_required

reminders_bp = Blueprint('reminders', __name__)

@reminders_bp.route('', methods=['GET'])
@token_required
def get_reminders(current_user):
    """Lista todos os lembretes do usuário"""
    try:
        reminders = Reminder.find_by_user(current_user['id'])
        
        # Converte datetime para string ISO
        for reminder in reminders:
            if reminder.get('created_at'):
                reminder['created_at'] = reminder['created_at'].isoformat()
            if reminder.get('updated_at'):
                reminder['updated_at'] = reminder['updated_at'].isoformat()
        
        return jsonify(reminders), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@reminders_bp.route('', methods=['POST'])
@token_required
def create_reminder(current_user):
    """Cria um novo lembrete"""
    data = request.get_json()
    
    # Validações
    required_fields = ['type', 'title', 'time']
    for field in required_fields:
        if not data.get(field):
            return jsonify({'error': f'Campo obrigatório: {field}'}), 400
    
    # Valida tipo de lembrete
    valid_types = ['exercise', 'medication', 'appointment', 'practice', 'hydration', 'diet']
    if data.get('type') not in valid_types:
        return jsonify({'error': 'Tipo de lembrete inválido'}), 400
    
    try:
        reminder_id = Reminder.create(
            user_id=current_user['id'],
            type=data.get('type'),
            title=data.get('title'),
            description=data.get('description', ''),
            frequency=data.get('frequency', 'Diário'),
            time=data.get('time'),
            is_active=data.get('is_active', True),
            selected_days=data.get('selected_days')
        )
        
        # Busca o lembrete criado
        reminder = Reminder.find_by_id(reminder_id)
        
        # Converte datetime para string ISO
        if reminder.get('created_at'):
            reminder['created_at'] = reminder['created_at'].isoformat()
        if reminder.get('updated_at'):
            reminder['updated_at'] = reminder['updated_at'].isoformat()
        
        return jsonify(reminder), 201
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@reminders_bp.route('/<int:reminder_id>', methods=['GET'])
@token_required
def get_reminder(current_user, reminder_id):
    """Busca um lembrete específico"""
    try:
        # Verifica se o lembrete pertence ao usuário
        if not Reminder.verify_ownership(reminder_id, current_user['id']):
            return jsonify({'error': 'Lembrete não encontrado ou sem permissão'}), 404
        
        reminder = Reminder.find_by_id(reminder_id)
        
        # Converte datetime para string ISO
        if reminder.get('created_at'):
            reminder['created_at'] = reminder['created_at'].isoformat()
        if reminder.get('updated_at'):
            reminder['updated_at'] = reminder['updated_at'].isoformat()
        
        return jsonify(reminder), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@reminders_bp.route('/<int:reminder_id>', methods=['PUT'])
@token_required
def update_reminder(current_user, reminder_id):
    """Atualiza um lembrete existente"""
    try:
        # Verifica se o lembrete pertence ao usuário
        if not Reminder.verify_ownership(reminder_id, current_user['id']):
            return jsonify({'error': 'Lembrete não encontrado ou sem permissão'}), 404
        
        data = request.get_json()
        
        # Valida tipo de lembrete se fornecido
        if data.get('type'):
            valid_types = ['exercise', 'medication', 'appointment', 'practice', 'hydration', 'diet']
            if data.get('type') not in valid_types:
                return jsonify({'error': 'Tipo de lembrete inválido'}), 400
        
        success = Reminder.update(
            reminder_id=reminder_id,
            type=data.get('type'),
            title=data.get('title'),
            description=data.get('description'),
            frequency=data.get('frequency'),
            time=data.get('time'),
            is_active=data.get('is_active'),
            selected_days=data.get('selected_days')
        )
        
        if success:
            # Busca o lembrete atualizado
            reminder = Reminder.find_by_id(reminder_id)
            
            # Converte datetime para string ISO
            if reminder.get('created_at'):
                reminder['created_at'] = reminder['created_at'].isoformat()
            if reminder.get('updated_at'):
                reminder['updated_at'] = reminder['updated_at'].isoformat()
            
            return jsonify(reminder), 200
        else:
            return jsonify({'error': 'Erro ao atualizar lembrete'}), 500
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@reminders_bp.route('/<int:reminder_id>', methods=['DELETE'])
@token_required
def delete_reminder(current_user, reminder_id):
    """Deleta um lembrete"""
    try:
        # Verifica se o lembrete pertence ao usuário
        if not Reminder.verify_ownership(reminder_id, current_user['id']):
            return jsonify({'error': 'Lembrete não encontrado ou sem permissão'}), 404
        
        success = Reminder.delete(reminder_id)
        
        if success:
            return jsonify({'message': 'Lembrete deletado com sucesso'}), 200
        else:
            return jsonify({'error': 'Erro ao deletar lembrete'}), 500
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
