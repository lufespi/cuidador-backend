-- ============================================================================
-- SCRIPT: Vincular Administradores Específicos
-- Data: 2025-11-25
-- Descrição: Define os 3 administradores principais do sistema
-- ============================================================================

-- Verificar se os usuários existem
SELECT 
    id, 
    nome, 
    email,
    is_admin
FROM users 
WHERE email IN (
    'lufespi1221@gmail.com',
    'kauemuller@gmail.com',
    'carinasuzanacorrea@gmail.com'
);

-- Atualizar para administradores
UPDATE users 
SET is_admin = TRUE 
WHERE email IN (
    'lufespi1221@gmail.com',
    'kauemuller@gmail.com',
    'carinasuzanacorrea@gmail.com'
);

-- Verificar resultado
SELECT 
    id, 
    nome, 
    email,
    is_admin,
    status
FROM users 
WHERE is_admin = TRUE
ORDER BY email;

-- Mostrar total de administradores
SELECT 
    COUNT(*) as total_admins 
FROM users 
WHERE is_admin = TRUE;
