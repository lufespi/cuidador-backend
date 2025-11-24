#!/usr/bin/env python3
"""Script para testar geração e validação de JWT"""

from utils.jwt_handler import generate_token, decode_token
from datetime import datetime, timezone
import time

print("=== Teste de JWT ===\n")

# Testa geração
user_id = 1
print(f"1. Gerando token para user_id={user_id}")
token = generate_token(user_id)
print(f"   Token: {token[:50]}...\n")

# Testa decodificação imediata
print("2. Decodificando token (imediatamente)")
payload = decode_token(token)
if payload:
    print(f"   ✅ Token válido!")
    print(f"   user_id: {payload['user_id']}")
    
    # Calcula tempo até expiração
    exp_timestamp = payload['exp']
    now_timestamp = datetime.now(timezone.utc).timestamp()
    segundos_restantes = exp_timestamp - now_timestamp
    horas = segundos_restantes / 3600
    
    print(f"   Expira em: {horas:.2f} horas ({segundos_restantes:.0f} segundos)")
else:
    print("   ❌ Token inválido!")

print("\n3. Verificando estrutura do payload:")
print(f"   - user_id: {payload.get('user_id')}")
print(f"   - iat (issued at): {datetime.fromtimestamp(payload['iat'], tz=timezone.utc)}")
print(f"   - exp (expires at): {datetime.fromtimestamp(payload['exp'], tz=timezone.utc)}")

print("\n✅ Todos os testes passaram!")
