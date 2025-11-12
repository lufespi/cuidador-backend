import os
from dotenv import load_dotenv

# Load environment variables
dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)

from app import create_app

application = create_app()

if __name__ == '__main__':
    application.run(debug=os.environ.get('FLASK_ENV') == 'development')
