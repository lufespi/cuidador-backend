-- Script de Migração Manual para PythonAnywhere
-- Execute este script se as migrações automáticas não funcionarem

-- 0. IMPORTANTE: Adiciona coluna 'body_parts' se não existir
ALTER TABLE pain_records 
ADD COLUMN IF NOT EXISTS body_parts JSON NOT NULL;

-- Se a coluna body_parts foi criada vazia, inicializa com array vazio
UPDATE pain_records 
SET body_parts = '[]' 
WHERE body_parts IS NULL OR body_parts = '';

-- 1. Verifica e adiciona coluna 'descricao' se não existir
ALTER TABLE pain_records 
ADD COLUMN IF NOT EXISTS descricao TEXT;

-- 2. Se 'observacoes' existir, copia dados para 'descricao'
UPDATE pain_records 
SET descricao = observacoes 
WHERE descricao IS NULL AND observacoes IS NOT NULL;

-- 3. Remove coluna antiga 'observacoes' (opcional - pode causar erro se não existir)
-- ALTER TABLE pain_records DROP COLUMN IF EXISTS observacoes;

-- 4. Verifica e adiciona coluna 'data_registro' se não existir
ALTER TABLE pain_records 
ADD COLUMN IF NOT EXISTS data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- 5. Se 'data' existir, copia dados para 'data_registro'
UPDATE pain_records 
SET data_registro = data 
WHERE data_registro IS NULL AND data IS NOT NULL;

-- 6. Remove coluna antiga 'data' (opcional - pode causar erro se não existir)
-- ALTER TABLE pain_records DROP COLUMN IF EXISTS data;

-- 7. Adiciona timestamps se não existirem
ALTER TABLE pain_records 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE pain_records 
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- 8. Verifica estrutura final
SHOW COLUMNS FROM pain_records;
