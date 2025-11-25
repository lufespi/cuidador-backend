-- ============================================================================
-- MIGRAÇÃO 002: Campo de Administrador
-- Data: 2025-11-25
-- Descrição: Adiciona campo is_admin para identificar administradores
-- ============================================================================

-- Adicionar coluna is_admin (ignora erro se já existir)
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'users' 
    AND COLUMN_NAME = 'is_admin'
);

SET @sql = IF(@column_exists = 0,
    'ALTER TABLE users ADD COLUMN is_admin BOOLEAN DEFAULT FALSE AFTER status',
    'SELECT "Coluna is_admin já existe" AS msg'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Criar índice (ignora erro se já existir)
SET @index_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'users' 
    AND INDEX_NAME = 'idx_users_is_admin'
);

SET @sql = IF(@index_exists = 0,
    'CREATE INDEX idx_users_is_admin ON users(is_admin)',
    'SELECT "Índice idx_users_is_admin já existe" AS msg'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Registrar migração
INSERT INTO migration_history (migration_name, description) 
VALUES ('002_add_admin_field', 'Adição do campo is_admin na tabela users')
ON DUPLICATE KEY UPDATE executed_at = CURRENT_TIMESTAMP;
