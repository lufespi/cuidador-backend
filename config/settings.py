import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    # Database
    DB_HOST = os.getenv('DB_HOST', 'KaueMuller.mysql.pythonanywhere-services.com')
    DB_USER = os.getenv('DB_USER', 'KaueMuller')
    DB_PASSWORD = os.getenv('DB_PASSWORD', 'ESquiva09')
    DB_NAME = os.getenv('DB_NAME', 'KaueMuller$default')
    
    # JWT
    JWT_SECRET = os.getenv('JWT_SECRET', 'dev-jwt-secret')
    JWT_EXPIRATION = int(os.getenv('JWT_EXPIRATION', 86400))
    
    # Flask
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key')
    FLASK_ENV = os.getenv('FLASK_ENV', 'development')
