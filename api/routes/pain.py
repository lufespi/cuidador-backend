from flask import Blueprint, request, jsonify
from api.models.pain_record import PainRecord
from api.middleware.auth import token_required

pain_bp = Blueprint('pain', __name__)

@pain_bp.route('/records', methods=['POST'])
@token_required
def create_record():
    """Cria um novo registro de dor"""
    data = request.get_json()
    
    body_parts = data.get('body_parts', [])
    intensidade = data.get('intensidade', 0)
    observacoes = data.get('observacoes')
    
    # Validação
    if not body_parts or not isinstance(body_parts, list):
        return jsonify({'error': 'body_parts é obrigatório e deve ser uma lista'}), 400
    
    if not isinstance(intensidade, int) or intensidade < 0 or intensidade > 10:
        return jsonify({'error': 'intensidade deve ser um número entre 0 e 10'}), 400
    
    try:
        record_id = PainRecord.create(
            user_id=request.user_id,
            body_parts=body_parts,
            intensidade=intensidade,
            observacoes=observacoes
        )
        
        return jsonify({
            'message': 'Registro criado com sucesso',
            'id': record_id
        }), 201
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@pain_bp.route('/records', methods=['GET'])
@token_required
def get_records():
    """Lista registros de dor do usuário"""
    try:
        records = PainRecord.find_by_user(request.user_id)
        
        # Converte datetime para string
        for record in records:
            if 'data' in record:
                record['data'] = record['data'].isoformat()
        
        return jsonify(records), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@pain_bp.route('/records/<int:record_id>', methods=['DELETE'])
@token_required
def delete_record(record_id):
    """Deleta um registro de dor"""
    try:
        success = PainRecord.delete(record_id, request.user_id)
        
        if success:
            return jsonify({'message': 'Registro deletado com sucesso'}), 200
        else:
            return jsonify({'error': 'Registro não encontrado'}), 404
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500
