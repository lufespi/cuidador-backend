import pytest
import json
from api.app import create_app

@pytest.fixture
def client():
    app = create_app()
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_register_success(client):
    """Teste de registro bem-sucedido"""
    response = client.post('/api/v1/auth/register',
                          data=json.dumps({
                              'email': 'test@example.com',
                              'senha': 'senha123',
                              'nome': 'Teste Usuario'
                          }),
                          content_type='application/json')
    
    assert response.status_code == 201
    data = json.loads(response.data)
    assert 'token' in data
    assert 'user' in data

def test_register_missing_fields(client):
    """Teste de registro com campos faltando"""
    response = client.post('/api/v1/auth/register',
                          data=json.dumps({
                              'email': 'test@example.com'
                          }),
                          content_type='application/json')
    
    assert response.status_code == 400

def test_login_success(client):
    """Teste de login bem-sucedido"""
    # Primeiro registra um usuário
    client.post('/api/v1/auth/register',
               data=json.dumps({
                   'email': 'login@example.com',
                   'senha': 'senha123'
               }),
               content_type='application/json')
    
    # Depois faz login
    response = client.post('/api/v1/auth/login',
                          data=json.dumps({
                              'email': 'login@example.com',
                              'senha': 'senha123'
                          }),
                          content_type='application/json')
    
    assert response.status_code == 200
    data = json.loads(response.data)
    assert 'token' in data

def test_login_invalid_credentials(client):
    """Teste de login com credenciais inválidas"""
    response = client.post('/api/v1/auth/login',
                          data=json.dumps({
                              'email': 'naoexiste@example.com',
                              'senha': 'senhaerrada'
                          }),
                          content_type='application/json')
    
    assert response.status_code == 401
