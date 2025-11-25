-- ============================================================================
-- MIGRAÇÃO 002: Campo de Administrador
-- Data: 2025-11-25
-- Descrição: Adiciona campo is_admin para identificar administradores
-- ============================================================================

-- Adicionar coluna is_admin se não existir
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS is_admin BOOLEAN DEFAULT FALSE AFTER status;

-- Criar índice para otimizar consultas de admin
CREATE INDEX IF NOT EXISTS idx_users_is_admin ON users(is_admin);

-- Registrar migração
INSERT INTO migration_history (migration_name, description) 
VALUES ('002_add_admin_field', 'Adição do campo is_admin na tabela users')
ON DUPLICATE KEY UPDATE executed_at = CURRENT_TIMESTAMP;

-- NOTA: Para definir administradores, use o script scripts/setup_admin_users.py
