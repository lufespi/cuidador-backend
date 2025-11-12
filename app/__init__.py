import os
from flask import Flask
from flask_cors import CORS
from app.extensions import db, jwt, ma, migrate
from app.config import config


def create_app(config_name=None):
    """Application factory pattern"""
    if config_name is None:
        config_name = os.environ.get('FLASK_ENV', 'development')
    
    app = Flask(__name__)
    app.config.from_object(config.get(config_name, config['default']))
    
    # Initialize extensions
    db.init_app(app)
    jwt.init_app(app)
    ma.init_app(app)
    migrate.init_app(app, db)
    CORS(app, origins=app.config['CORS_ORIGINS'])
    
    # Register blueprints
    from app.routes.auth import bp as auth_bp
    from app.routes.user import bp as user_bp
    from app.routes.pain import bp as pain_bp
    
    app.register_blueprint(auth_bp, url_prefix='/api/v1/auth')
    app.register_blueprint(user_bp, url_prefix='/api/v1/user')
    app.register_blueprint(pain_bp, url_prefix='/api/v1/pain')
    
    # Health check endpoint
    @app.route('/health')
    def health():
        return {'status': 'ok', 'message': 'Cuidador API is running'}, 200
    
    # Root endpoint
    @app.route('/')
    def index():
        return {
            'name': 'Cuidador API',
            'version': '1.0.0',
            'endpoints': {
                'health': '/health',
                'auth': '/api/v1/auth',
                'user': '/api/v1/user',
                'pain': '/api/v1/pain'
            }
        }, 200
    
    return app
