from flask import Flask, jsonify
from flask_cors import CORS
from config.settings import Config
from api.db import init_db
from api.routes.auth import auth_bp
from api.routes.pain import pain_bp
from api.routes.admin import admin_bp

def create_app():
    """Factory para criar a aplicação Flask"""
    app = Flask(__name__)
    app.config.from_object(Config)
    
    # CORS para permitir requisições do Flutter
    CORS(app, resources={
        r"/api/*": {
            "origins": "*",
            "methods": ["GET", "POST", "PUT", "DELETE", "PATCH"],
            "allow_headers": ["Content-Type", "Authorization"]
        }
    })
    
    # Inicializa banco de dados
    with app.app_context():
        init_db()
    
    # Registra blueprints (rotas)
    app.register_blueprint(auth_bp, url_prefix='/api/v1/auth')
    app.register_blueprint(pain_bp, url_prefix='/api/v1/pain')
    app.register_blueprint(admin_bp, url_prefix='/api/v1')
    
    # Rota de health check
    @app.route('/')
    def home():
        return jsonify({
            'message': 'API CuidaDor rodando',
            'version': '1.0.0',
            'status': 'online'
        }), 200
    
    @app.route('/health')
    def health():
        return jsonify({'status': 'ok'}), 200
    
    # Error handlers
    @app.errorhandler(404)
    def not_found(error):
        return jsonify({'error': 'Endpoint não encontrado'}), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({'error': 'Erro interno do servidor'}), 500
    
    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True, host='0.0.0.0', port=5000)
