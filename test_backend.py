#!/usr/bin/env python3
"""
Script de teste para validar alterações do backend
Execute antes de fazer deploy no PythonAnywhere
"""

import sys
import json
from datetime import datetime

def test_imports():
    """Testa se todos os módulos podem ser importados"""
    print("🔍 Testando imports...")
    try:
        from api.app import create_app
        from api.models.pain_record import PainRecord
        from api.routes.pain import pain_bp
        print("✅ Imports OK")
        return True
    except Exception as e:
        print(f"❌ Erro nos imports: {e}")
        return False

def test_database_schema():
    """Testa criação das tabelas"""
    print("\n🔍 Testando schema do banco...")
    try:
        from api.app import create_app
        app = create_app()
        print("✅ Banco de dados inicializado com sucesso")
        return True
    except Exception as e:
        print(f"❌ Erro no banco: {e}")
        return False

def test_pain_record_model():
    """Testa métodos do modelo PainRecord"""
    print("\n🔍 Testando modelo PainRecord...")
    try:
        from api.models.pain_record import PainRecord
        
        # Verifica se os métodos existem
        assert hasattr(PainRecord, 'create'), "Método 'create' não encontrado"
        assert hasattr(PainRecord, 'find_by_user'), "Método 'find_by_user' não encontrado"
        assert hasattr(PainRecord, 'find_by_id'), "Método 'find_by_id' não encontrado"
        assert hasattr(PainRecord, 'delete'), "Método 'delete' não encontrado"
        
        print("✅ Modelo PainRecord OK")
        return True
    except Exception as e:
        print(f"❌ Erro no modelo: {e}")
        return False

def test_routes():
    """Testa se as rotas estão registradas"""
    print("\n🔍 Testando rotas...")
    try:
        from api.app import create_app
        app = create_app()
        
        with app.test_client() as client:
            # Testa health check
            response = client.get('/health')
            assert response.status_code == 200, "Health check falhou"
            
            # Testa rota home
            response = client.get('/')
            assert response.status_code == 200, "Rota home falhou"
            data = json.loads(response.data)
            assert 'status' in data, "Resposta home inválida"
            
        print("✅ Rotas OK")
        return True
    except Exception as e:
        print(f"❌ Erro nas rotas: {e}")
        return False

def test_pain_endpoints_structure():
    """Testa estrutura dos endpoints de dor (sem autenticação)"""
    print("\n🔍 Testando estrutura dos endpoints...")
    try:
        from api.app import create_app
        app = create_app()
        
        with app.test_client() as client:
            # POST sem autenticação deve retornar 401
            response = client.post('/api/v1/pain/records', 
                                  json={
                                      'body_parts': ['cabeca:topo'],
                                      'intensidade': 5,
                                      'descricao': 'Teste'
                                  })
            assert response.status_code in [401, 403], f"POST retornou {response.status_code}"
            
            # GET sem autenticação deve retornar 401
            response = client.get('/api/v1/pain/records')
            assert response.status_code in [401, 403], f"GET retornou {response.status_code}"
            
        print("✅ Estrutura dos endpoints OK")
        return True
    except Exception as e:
        print(f"❌ Erro nos endpoints: {e}")
        return False

def test_json_serialization():
    """Testa serialização de dados"""
    print("\n🔍 Testando serialização JSON...")
    try:
        test_data = {
            'body_parts': ['cabeca:topo', 'torso:pescoco'],
            'intensidade': 7,
            'descricao': 'Teste de dor',
            'data_registro': datetime.now().isoformat()
        }
        
        # Testa serialização
        json_str = json.dumps(test_data)
        parsed = json.loads(json_str)
        
        assert parsed['body_parts'] == test_data['body_parts']
        assert parsed['intensidade'] == test_data['intensidade']
        
        print("✅ Serialização JSON OK")
        return True
    except Exception as e:
        print(f"❌ Erro na serialização: {e}")
        return False

def main():
    """Executa todos os testes"""
    print("="*50)
    print("🧪 TESTES DE VALIDAÇÃO DO BACKEND")
    print("="*50)
    
    tests = [
        test_imports,
        test_database_schema,
        test_pain_record_model,
        test_routes,
        test_pain_endpoints_structure,
        test_json_serialization
    ]
    
    results = []
    for test in tests:
        results.append(test())
    
    print("\n" + "="*50)
    print("📊 RESULTADO DOS TESTES")
    print("="*50)
    
    passed = sum(results)
    total = len(results)
    
    print(f"✅ Passou: {passed}/{total}")
    print(f"❌ Falhou: {total - passed}/{total}")
    
    if all(results):
        print("\n🎉 TODOS OS TESTES PASSARAM!")
        print("✅ Backend pronto para deploy no PythonAnywhere")
        return 0
    else:
        print("\n⚠️  ALGUNS TESTES FALHARAM")
        print("❌ Corrija os erros antes de fazer deploy")
        return 1

if __name__ == '__main__':
    sys.exit(main())
