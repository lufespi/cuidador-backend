-- ============================================================================
-- MIGRAÇÃO 003: Campo de Partes do Corpo
-- Data: 2025-11-25
-- Descrição: Adiciona campo body_parts JSON para registrar múltiplas partes do corpo
-- ============================================================================

-- Adicionar coluna body_parts (ignora erro se já existir)
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'pain_records' 
    AND COLUMN_NAME = 'body_parts'
);

SET @sql = IF(@column_exists = 0,
    'ALTER TABLE pain_records ADD COLUMN body_parts JSON NOT NULL',
    'SELECT "Coluna body_parts já existe" AS msg'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Inicializar registros existentes com array vazio (se a coluna acabou de ser criada)
UPDATE pain_records 
SET body_parts = JSON_ARRAY()
WHERE body_parts IS NULL OR body_parts = '' OR body_parts = 'null';

-- Registrar migração
INSERT INTO migration_history (migration_name, description) 
VALUES ('003_add_body_parts', 'Adição do campo body_parts JSON na tabela pain_records')
ON DUPLICATE KEY UPDATE executed_at = CURRENT_TIMESTAMP;
