from functools import wraps
from flask import request, jsonify
from flask_jwt_extended import verify_jwt_in_request, get_jwt_identity
from marshmallow import ValidationError


def jwt_required_custom(fn):
    """Custom JWT required decorator with better error handling"""
    @wraps(fn)
    def wrapper(*args, **kwargs):
        try:
            verify_jwt_in_request()
            return fn(*args, **kwargs)
        except Exception as e:
            return jsonify({'error': 'Invalid or expired token', 'message': str(e)}), 401
    return wrapper


def validate_json(schema_class):
    """Decorator to validate JSON request body with Marshmallow schema"""
    def decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            try:
                if not request.is_json:
                    return jsonify({'error': 'Content-Type must be application/json'}), 400
                
                schema = schema_class()
                data = schema.load(request.get_json())
                request.validated_data = data
                return fn(*args, **kwargs)
            except ValidationError as e:
                return jsonify({'error': 'Validation error', 'messages': e.messages}), 400
            except Exception as e:
                return jsonify({'error': 'Invalid JSON', 'message': str(e)}), 400
        return wrapper
    return decorator


def validate_query(schema_class):
    """Decorator to validate query parameters with Marshmallow schema"""
    def decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            try:
                schema = schema_class()
                data = schema.load(request.args)
                request.validated_query = data
                return fn(*args, **kwargs)
            except ValidationError as e:
                return jsonify({'error': 'Validation error', 'messages': e.messages}), 400
        return wrapper
    return decorator
