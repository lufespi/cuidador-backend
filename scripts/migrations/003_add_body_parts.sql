-- ============================================================================
-- MIGRAÇÃO 003: Campo de Partes do Corpo
-- Data: 2025-11-25
-- Descrição: Adiciona campo body_parts JSON para registrar múltiplas partes do corpo
-- ============================================================================

-- Adicionar coluna body_parts se não existir
ALTER TABLE pain_records 
ADD COLUMN IF NOT EXISTS body_parts JSON NOT NULL DEFAULT ('[]');

-- Inicializar registros existentes com array vazio
UPDATE pain_records 
SET body_parts = '[]' 
WHERE body_parts IS NULL OR body_parts = '';

-- Registrar migração
INSERT INTO migration_history (migration_name, description) 
VALUES ('003_add_body_parts', 'Adição do campo body_parts JSON na tabela pain_records')
ON DUPLICATE KEY UPDATE executed_at = CURRENT_TIMESTAMP;
