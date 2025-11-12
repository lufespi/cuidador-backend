from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, get_jwt_identity
from app.extensions import db
from app.models import User, UserPreferences
from app.schemas import RegisterSchema, LoginSchema
from app.utils import validate_json, jwt_required_custom, error_response

bp = Blueprint('auth', __name__)


@bp.route('/register', methods=['POST'])
@validate_json(RegisterSchema)
def register():
    """Register a new user"""
    try:
        data = request.validated_data
        
        # Check if email already exists
        if User.query.filter_by(email=data['email']).first():
            return error_response('Email already registered', status_code=409)
        
        # Create user
        user = User(
            email=data['email'],
            first_name=data['first_name'],
            last_name=data['last_name'],
            birth_date=data.get('birth_date'),
            phone=data.get('phone'),
            gender=data.get('gender')
        )
        user.set_password(data['password'])
        
        db.session.add(user)
        db.session.flush()  # Get user.id before committing
        
        # Create default preferences
        preferences = UserPreferences(user_id=user.id)
        db.session.add(preferences)
        
        db.session.commit()
        
        # Generate JWT token
        token = create_access_token(identity=user.id)
        
        return jsonify({
            'token': token,
            'user': user.to_dict()
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return error_response('Registration failed', str(e), 500)


@bp.route('/login', methods=['POST'])
@validate_json(LoginSchema)
def login():
    """Login user"""
    try:
        data = request.validated_data
        
        # Find user by email
        user = User.query.filter_by(email=data['email']).first()
        
        if not user or not user.check_password(data['password']):
            return error_response('Invalid email or password', status_code=401)
        
        # Generate JWT token
        token = create_access_token(identity=user.id)
        
        return jsonify({
            'token': token,
            'user': user.to_dict()
        }), 200
        
    except Exception as e:
        return error_response('Login failed', str(e), 500)


@bp.route('/me', methods=['GET'])
@jwt_required_custom
def get_current_user():
    """Get current authenticated user"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return error_response('User not found', status_code=404)
        
        return jsonify(user.to_dict()), 200
        
    except Exception as e:
        return error_response('Failed to get user', str(e), 500)
