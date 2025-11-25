import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    # Database
    DB_HOST = os.getenv('DB_HOST', 'lufespi.mysql.pythonanywhere-services.com')
    DB_USER = os.getenv('DB_USER', 'lufespi')
    DB_PASSWORD = os.getenv('DB_PASSWORD', 'mZHr$hSi3ebB{3Px')
    DB_NAME = os.getenv('DB_NAME', 'lufespi$cuidador_homolog_db')
    
    # JWT
    JWT_SECRET = os.getenv('JWT_SECRET', 'dev-jwt-secret')
    JWT_EXPIRATION = int(os.getenv('JWT_EXPIRATION', 86400))
    
    # Flask
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key')
    FLASK_ENV = os.getenv('FLASK_ENV', 'development')
