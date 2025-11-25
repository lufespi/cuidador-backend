-- ============================================================
-- Script: Adicionar campo data_share_preference à tabela users
-- Data: 2025-11-25
-- Descrição: Adiciona suporte para preferências de compartilhamento de dados
-- ============================================================

-- Verifica se a coluna já existe antes de adicionar
SET @column_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'users'
    AND COLUMN_NAME = 'data_share_preference'
);

-- Adiciona a coluna se não existir
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE users ADD COLUMN data_share_preference VARCHAR(20) DEFAULT ''none'' AFTER comorbidades',
    'SELECT ''Coluna data_share_preference já existe'' as message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Exibe informações sobre a alteração
SELECT 
    'Coluna adicionada com sucesso!' as status,
    'data_share_preference' as coluna,
    'VARCHAR(20)' as tipo,
    'none' as valor_padrao,
    'none, full, diagnostic' as valores_aceitos;

-- Exibe contagem de usuários atualizados
SELECT 
    COUNT(*) as total_usuarios,
    'Todos configurados com valor padrão ''none''' as observacao
FROM users;

-- ============================================================
-- Valores aceitos:
-- - 'none': Não compartilha dados (padrão)
-- - 'full': Compartilha todas as estatísticas
-- - 'diagnostic': Compartilha apenas dados de diagnóstico
-- ============================================================
