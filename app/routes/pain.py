from flask import Blueprint, request, jsonify
from flask_jwt_extended import get_jwt_identity
from sqlalchemy import func, and_
from datetime import datetime, timedelta
from app.extensions import db
from app.models import PainRecord
from app.schemas import (
    PainRecordSchema,
    PainRecordUpdateSchema,
    PainRecordQuerySchema,
    StatisticsQuerySchema
)
from app.utils import (
    validate_json,
    validate_query,
    jwt_required_custom,
    error_response,
    paginate_query
)

bp = Blueprint('pain', __name__)


@bp.route('', methods=['POST'])
@jwt_required_custom
@validate_json(PainRecordSchema)
def create_pain_record():
    """Create a new pain record"""
    try:
        user_id = get_jwt_identity()
        data = request.validated_data
        
        # Create pain record
        pain_record = PainRecord(
            user_id=user_id,
            body_part=data['body_part'],
            intensity=data['intensity'],
            description=data.get('description'),
            symptoms=data.get('symptoms'),
            timestamp=data.get('timestamp', datetime.utcnow())
        )
        
        db.session.add(pain_record)
        db.session.commit()
        
        return jsonify(pain_record.to_dict()), 201
        
    except Exception as e:
        db.session.rollback()
        return error_response('Failed to create pain record', str(e), 500)


@bp.route('', methods=['GET'])
@jwt_required_custom
@validate_query(PainRecordQuerySchema)
def get_pain_records():
    """Get paginated list of pain records with filters"""
    try:
        user_id = get_jwt_identity()
        query_params = request.validated_query
        
        # Build query
        query = PainRecord.query.filter_by(user_id=user_id)
        
        # Apply filters
        if query_params.get('start_date'):
            query = query.filter(PainRecord.timestamp >= query_params['start_date'])
        
        if query_params.get('end_date'):
            # Add 1 day to include the end date
            end_date = datetime.combine(
                query_params['end_date'],
                datetime.max.time()
            )
            query = query.filter(PainRecord.timestamp <= end_date)
        
        if query_params.get('body_part'):
            query = query.filter_by(body_part=query_params['body_part'])
        
        if query_params.get('min_intensity'):
            query = query.filter(PainRecord.intensity >= query_params['min_intensity'])
        
        if query_params.get('max_intensity'):
            query = query.filter(PainRecord.intensity <= query_params['max_intensity'])
        
        # Order by timestamp descending
        query = query.order_by(PainRecord.timestamp.desc())
        
        # Paginate
        result = paginate_query(
            query,
            page=query_params['page'],
            per_page=query_params['per_page']
        )
        
        return jsonify(result), 200
        
    except Exception as e:
        return error_response('Failed to get pain records', str(e), 500)


@bp.route('/<int:pain_id>', methods=['GET'])
@jwt_required_custom
def get_pain_record(pain_id):
    """Get a specific pain record"""
    try:
        user_id = get_jwt_identity()
        pain_record = PainRecord.query.filter_by(id=pain_id, user_id=user_id).first()
        
        if not pain_record:
            return error_response('Pain record not found', status_code=404)
        
        return jsonify(pain_record.to_dict()), 200
        
    except Exception as e:
        return error_response('Failed to get pain record', str(e), 500)


@bp.route('/<int:pain_id>', methods=['PUT'])
@jwt_required_custom
@validate_json(PainRecordUpdateSchema)
def update_pain_record(pain_id):
    """Update a pain record"""
    try:
        user_id = get_jwt_identity()
        pain_record = PainRecord.query.filter_by(id=pain_id, user_id=user_id).first()
        
        if not pain_record:
            return error_response('Pain record not found', status_code=404)
        
        data = request.validated_data
        
        # Update fields
        for key, value in data.items():
            if hasattr(pain_record, key):
                setattr(pain_record, key, value)
        
        db.session.commit()
        
        return jsonify(pain_record.to_dict()), 200
        
    except Exception as e:
        db.session.rollback()
        return error_response('Failed to update pain record', str(e), 500)


@bp.route('/<int:pain_id>', methods=['DELETE'])
@jwt_required_custom
def delete_pain_record(pain_id):
    """Delete a pain record"""
    try:
        user_id = get_jwt_identity()
        pain_record = PainRecord.query.filter_by(id=pain_id, user_id=user_id).first()
        
        if not pain_record:
            return error_response('Pain record not found', status_code=404)
        
        db.session.delete(pain_record)
        db.session.commit()
        
        return '', 204
        
    except Exception as e:
        db.session.rollback()
        return error_response('Failed to delete pain record', str(e), 500)


@bp.route('/statistics', methods=['GET'])
@jwt_required_custom
@validate_query(StatisticsQuerySchema)
def get_statistics():
    """Get pain statistics for the user"""
    try:
        user_id = get_jwt_identity()
        query_params = request.validated_query
        
        # Default to last 30 days if not specified
        end_date = query_params.get('end_date') or datetime.utcnow().date()
        start_date = query_params.get('start_date') or (
            datetime.utcnow() - timedelta(days=30)
        ).date()
        
        # Build base query
        query = PainRecord.query.filter(
            and_(
                PainRecord.user_id == user_id,
                PainRecord.timestamp >= start_date,
                PainRecord.timestamp <= datetime.combine(end_date, datetime.max.time())
            )
        )
        
        # Total records
        total_records = query.count()
        
        if total_records == 0:
            return jsonify({
                'period': {
                    'start_date': start_date.isoformat(),
                    'end_date': end_date.isoformat()
                },
                'total_records': 0,
                'average_intensity': 0,
                'most_affected_parts': [],
                'intensity_distribution': {'1-3': 0, '4-6': 0, '7-10': 0},
                'common_symptoms': []
            }), 200
        
        # Average intensity
        avg_intensity = db.session.query(
            func.avg(PainRecord.intensity)
        ).filter(
            and_(
                PainRecord.user_id == user_id,
                PainRecord.timestamp >= start_date,
                PainRecord.timestamp <= datetime.combine(end_date, datetime.max.time())
            )
        ).scalar()
        
        # Most affected body parts
        most_affected = db.session.query(
            PainRecord.body_part,
            func.count(PainRecord.id).label('count')
        ).filter(
            and_(
                PainRecord.user_id == user_id,
                PainRecord.timestamp >= start_date,
                PainRecord.timestamp <= datetime.combine(end_date, datetime.max.time())
            )
        ).group_by(PainRecord.body_part).order_by(func.count(PainRecord.id).desc()).limit(5).all()
        
        # Intensity distribution
        intensity_dist = {
            '1-3': query.filter(PainRecord.intensity.between(1, 3)).count(),
            '4-6': query.filter(PainRecord.intensity.between(4, 6)).count(),
            '7-10': query.filter(PainRecord.intensity.between(7, 10)).count()
        }
        
        # Common symptoms
        all_symptoms = []
        for record in query.all():
            if record.symptoms:
                all_symptoms.extend(record.symptoms)
        
        from collections import Counter
        symptom_counts = Counter(all_symptoms)
        common_symptoms = [
            {'symptom': symptom, 'count': count}
            for symptom, count in symptom_counts.most_common(5)
        ]
        
        return jsonify({
            'period': {
                'start_date': start_date.isoformat(),
                'end_date': end_date.isoformat()
            },
            'total_records': total_records,
            'average_intensity': round(float(avg_intensity), 2) if avg_intensity else 0,
            'most_affected_parts': [
                {'body_part': part, 'count': count}
                for part, count in most_affected
            ],
            'intensity_distribution': intensity_dist,
            'common_symptoms': common_symptoms
        }), 200
        
    except Exception as e:
        return error_response('Failed to get statistics', str(e), 500)
