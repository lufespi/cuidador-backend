"""
Rotas de Feedback
Gerencia o envio e consulta de feedbacks dos usuários
"""

from flask import Blueprint, request, jsonify
from api.db import get_db_connection
from api.middleware.auth import token_required, admin_required
from datetime import datetime

feedback_bp = Blueprint('feedback', __name__)

@feedback_bp.route('/feedback', methods=['POST'])
@token_required
def create_feedback(current_user):
    """
    Cria um novo feedback
    Requer autenticação
    """
    try:
        data = request.get_json()
        
        # Validar campos obrigatórios
        if not data.get('feedback_type'):
            return jsonify({'error': 'Tipo de feedback é obrigatório'}), 400
        
        if not data.get('message'):
            return jsonify({'error': 'Mensagem é obrigatória'}), 400
        
        if len(data.get('message', '').strip()) < 10:
            return jsonify({'error': 'Mensagem deve ter pelo menos 10 caracteres'}), 400
        
        # Validar tipo de feedback
        valid_types = ['suggestion', 'problem', 'compliment', 'other']
        if data.get('feedback_type') not in valid_types:
            return jsonify({'error': 'Tipo de feedback inválido'}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Inserir feedback
        cursor.execute('''
            INSERT INTO feedback (user_id, feedback_type, name, email, message, created_at)
            VALUES (%s, %s, %s, %s, %s, NOW())
        ''', (
            current_user['id'],
            data.get('feedback_type'),
            data.get('name'),
            data.get('email'),
            data.get('message').strip()
        ))
        
        conn.commit()
        feedback_id = cursor.lastrowid
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'message': 'Feedback enviado com sucesso',
            'feedback_id': feedback_id
        }), 201
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@feedback_bp.route('/admin/feedback', methods=['GET'])
@admin_required
def get_all_feedback(current_user):
    """
    Lista todos os feedbacks (apenas admin)
    Query params:
    - search: busca por nome, email ou mensagem
    - type: filtra por tipo de feedback
    - limit: limita quantidade de resultados
    - offset: paginação
    """
    try:
        # Parâmetros de busca
        search = request.args.get('search', '')
        feedback_type = request.args.get('type', '')
        limit = request.args.get('limit', 50, type=int)
        offset = request.args.get('offset', 0, type=int)
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Query base
        query = '''
            SELECT 
                f.id,
                f.user_id,
                f.feedback_type,
                f.name,
                f.email,
                f.message,
                f.created_at,
                u.nome as user_name,
                u.email as user_email
            FROM feedback f
            LEFT JOIN users u ON f.user_id = u.id
            WHERE 1=1
        '''
        
        params = []
        
        # Filtro de busca
        if search:
            query += ''' AND (
                f.name LIKE %s OR 
                f.email LIKE %s OR 
                f.message LIKE %s OR
                u.nome LIKE %s OR
                u.email LIKE %s
            )'''
            search_param = f'%{search}%'
            params.extend([search_param] * 5)
        
        # Filtro por tipo
        if feedback_type:
            query += ' AND f.feedback_type = %s'
            params.append(feedback_type)
        
        # Ordenação e paginação
        query += ' ORDER BY f.created_at DESC LIMIT %s OFFSET %s'
        params.extend([limit, offset])
        
        cursor.execute(query, params)
        feedbacks = cursor.fetchall()
        
        # Contar total
        count_query = '''
            SELECT COUNT(*) as total
            FROM feedback f
            LEFT JOIN users u ON f.user_id = u.id
            WHERE 1=1
        '''
        
        count_params = []
        
        if search:
            count_query += ''' AND (
                f.name LIKE %s OR 
                f.email LIKE %s OR 
                f.message LIKE %s OR
                u.nome LIKE %s OR
                u.email LIKE %s
            )'''
            count_params.extend([search_param] * 5)
        
        if feedback_type:
            count_query += ' AND f.feedback_type = %s'
            count_params.append(feedback_type)
        
        cursor.execute(count_query, count_params)
        total = cursor.fetchone()['total']
        
        # Formatar datas
        for feedback in feedbacks:
            if feedback.get('created_at'):
                if hasattr(feedback['created_at'], 'strftime'):
                    feedback['created_at'] = feedback['created_at'].strftime('%Y-%m-%d %H:%M:%S')
                else:
                    feedback['created_at'] = str(feedback['created_at'])
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'feedbacks': feedbacks,
            'total': total,
            'limit': limit,
            'offset': offset
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@feedback_bp.route('/admin/feedback/<int:feedback_id>', methods=['GET'])
@admin_required
def get_feedback_by_id(current_user, feedback_id):
    """
    Busca um feedback específico por ID (apenas admin)
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute('''
            SELECT 
                f.id,
                f.user_id,
                f.feedback_type,
                f.name,
                f.email,
                f.message,
                f.created_at,
                u.nome as user_name,
                u.email as user_email,
                u.telefone as user_phone
            FROM feedback f
            LEFT JOIN users u ON f.user_id = u.id
            WHERE f.id = %s
        ''', (feedback_id,))
        
        feedback = cursor.fetchone()
        
        if not feedback:
            cursor.close()
            conn.close()
            return jsonify({'error': 'Feedback não encontrado'}), 404
        
        # Formatar data
        if feedback.get('created_at'):
            if hasattr(feedback['created_at'], 'strftime'):
                feedback['created_at'] = feedback['created_at'].strftime('%Y-%m-%d %H:%M:%S')
            else:
                feedback['created_at'] = str(feedback['created_at'])
        
        cursor.close()
        conn.close()
        
        return jsonify(feedback), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@feedback_bp.route('/admin/feedback/<int:feedback_id>', methods=['DELETE'])
@admin_required
def delete_feedback(current_user, feedback_id):
    """
    Deleta um feedback (apenas admin)
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Verificar se existe
        cursor.execute('SELECT id FROM feedback WHERE id = %s', (feedback_id,))
        feedback = cursor.fetchone()
        
        if not feedback:
            cursor.close()
            conn.close()
            return jsonify({'error': 'Feedback não encontrado'}), 404
        
        # Deletar
        cursor.execute('DELETE FROM feedback WHERE id = %s', (feedback_id,))
        conn.commit()
        
        cursor.close()
        conn.close()
        
        return jsonify({'message': 'Feedback deletado com sucesso'}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
