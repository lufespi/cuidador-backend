import pytest
import json
from api.app import create_app

@pytest.fixture
def client():
    app = create_app()
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

@pytest.fixture
def auth_token(client):
    """Cria um usuário e retorna o token"""
    response = client.post('/api/v1/auth/register',
                          data=json.dumps({
                              'email': 'paintest@example.com',
                              'senha': 'senha123'
                          }),
                          content_type='application/json')
    data = json.loads(response.data)
    return data['token']

def test_create_pain_record_success(client, auth_token):
    """Teste de criação de registro de dor"""
    response = client.post('/api/v1/pain/records',
                          headers={'Authorization': f'Bearer {auth_token}'},
                          data=json.dumps({
                              'body_parts': ['head', 'neck'],
                              'intensidade': 7,
                              'observacoes': 'Dor de cabeça forte'
                          }),
                          content_type='application/json')
    
    assert response.status_code == 201
    data = json.loads(response.data)
    assert 'id' in data

def test_create_pain_record_no_auth(client):
    """Teste de criação sem autenticação"""
    response = client.post('/api/v1/pain/records',
                          data=json.dumps({
                              'body_parts': ['head'],
                              'intensidade': 5
                          }),
                          content_type='application/json')
    
    assert response.status_code == 401

def test_get_pain_records(client, auth_token):
    """Teste de listagem de registros"""
    # Cria um registro
    client.post('/api/v1/pain/records',
               headers={'Authorization': f'Bearer {auth_token}'},
               data=json.dumps({
                   'body_parts': ['head'],
                   'intensidade': 5
               }),
               content_type='application/json')
    
    # Lista registros
    response = client.get('/api/v1/pain/records',
                         headers={'Authorization': f'Bearer {auth_token}'})
    
    assert response.status_code == 200
    data = json.loads(response.data)
    assert isinstance(data, list)
    assert len(data) > 0

def test_delete_pain_record(client, auth_token):
    """Teste de deleção de registro"""
    # Cria um registro
    create_response = client.post('/api/v1/pain/records',
                                 headers={'Authorization': f'Bearer {auth_token}'},
                                 data=json.dumps({
                                     'body_parts': ['head'],
                                     'intensidade': 5
                                 }),
                                 content_type='application/json')
    record_id = json.loads(create_response.data)['id']
    
    # Deleta o registro
    response = client.delete(f'/api/v1/pain/records/{record_id}',
                           headers={'Authorization': f'Bearer {auth_token}'})
    
    assert response.status_code == 200
