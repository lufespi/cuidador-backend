from app.routes.auth import bp as auth_bp
from app.routes.user import bp as user_bp
from app.routes.pain import bp as pain_bp

__all__ = ['auth_bp', 'user_bp', 'pain_bp']
