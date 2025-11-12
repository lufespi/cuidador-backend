from flask import Blueprint, request, jsonify
from flask_jwt_extended import get_jwt_identity
from app.extensions import db
from app.models import User, UserPreferences
from app.schemas import UserUpdateSchema, UserPreferencesSchema
from app.utils import validate_json, jwt_required_custom, error_response

bp = Blueprint('user', __name__)


@bp.route('/profile', methods=['GET'])
@jwt_required_custom
def get_profile():
    """Get user profile"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return error_response('User not found', status_code=404)
        
        return jsonify(user.to_dict()), 200
        
    except Exception as e:
        return error_response('Failed to get profile', str(e), 500)


@bp.route('/profile', methods=['PUT'])
@jwt_required_custom
@validate_json(UserUpdateSchema)
def update_profile():
    """Update user profile"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return error_response('User not found', status_code=404)
        
        data = request.validated_data
        
        # Update user fields
        for key, value in data.items():
            if hasattr(user, key):
                setattr(user, key, value)
        
        db.session.commit()
        
        return jsonify(user.to_dict()), 200
        
    except Exception as e:
        db.session.rollback()
        return error_response('Failed to update profile', str(e), 500)


@bp.route('/preferences', methods=['GET'])
@jwt_required_custom
def get_preferences():
    """Get user preferences"""
    try:
        user_id = get_jwt_identity()
        preferences = UserPreferences.query.filter_by(user_id=user_id).first()
        
        if not preferences:
            # Create default preferences if not exists
            preferences = UserPreferences(user_id=user_id)
            db.session.add(preferences)
            db.session.commit()
        
        return jsonify(preferences.to_dict()), 200
        
    except Exception as e:
        return error_response('Failed to get preferences', str(e), 500)


@bp.route('/preferences', methods=['PUT'])
@jwt_required_custom
@validate_json(UserPreferencesSchema)
def update_preferences():
    """Update user preferences"""
    try:
        user_id = get_jwt_identity()
        preferences = UserPreferences.query.filter_by(user_id=user_id).first()
        
        if not preferences:
            preferences = UserPreferences(user_id=user_id)
            db.session.add(preferences)
        
        data = request.validated_data
        
        # Update preferences fields
        for key, value in data.items():
            if hasattr(preferences, key):
                setattr(preferences, key, value)
        
        db.session.commit()
        
        return jsonify(preferences.to_dict()), 200
        
    except Exception as e:
        db.session.rollback()
        return error_response('Failed to update preferences', str(e), 500)
