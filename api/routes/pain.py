from flask import Blueprint, request, jsonify
from api.models.pain_record import PainRecord
from api.middleware.auth import token_required
from datetime import datetime

pain_bp = Blueprint('pain', __name__)

def serialize_dates(record):
    """Converte todos os campos datetime para string ISO"""
    if not record:
        return record
    
    for key, value in record.items():
        if isinstance(value, datetime):
            record[key] = value.isoformat()
    
    return record

@pain_bp.route('/records', methods=['POST'])
@token_required
def create_record():
    """Cria um novo registro de dor"""
    data = request.get_json()
    
    body_parts = data.get('body_parts', [])
    intensidade = data.get('intensidade', 0)
    descricao = data.get('descricao')  # Aceita 'descricao' do frontend
    data_registro = data.get('data_registro')  # Aceita data customizada
    
    # Validação - body_parts agora é opcional
    if body_parts is not None and not isinstance(body_parts, list):
        return jsonify({'error': 'body_parts deve ser uma lista'}), 400
    
    if not isinstance(intensidade, int) or intensidade < 0 or intensidade > 10:
        return jsonify({'error': 'intensidade deve ser um número entre 0 e 10'}), 400
    
    try:
        record = PainRecord.create(
            user_id=request.user_id,
            body_parts=body_parts if body_parts else [],
            intensidade=intensidade,
            descricao=descricao,
            data_registro=data_registro
        )
        
        return jsonify(serialize_dates(record)), 201
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@pain_bp.route('/records', methods=['GET'])
@token_required
def get_records():
    """Lista registros de dor do usuário"""
    try:
        # Parâmetros de filtro
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        limit = request.args.get('limit', 50, type=int)
        
        records = PainRecord.find_by_user(
            user_id=request.user_id,
            start_date=start_date,
            end_date=end_date,
            limit=limit
        )
        
        # Converte datetime para string ISO
        serialized_records = [serialize_dates(record) for record in records]
        
        return jsonify({'records': serialized_records}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@pain_bp.route('/records/<int:record_id>', methods=['GET'])
@token_required
def get_record(record_id):
    """Busca um registro específico de dor"""
    try:
        record = PainRecord.find_by_id(record_id, request.user_id)
        
        if record:
            return jsonify(serialize_dates(record)), 200
        else:
            return jsonify({'error': 'Registro não encontrado'}), 404
            
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
