-- Migration 004: Criar tabela de feedback
-- Data: 2024-11-25
-- Descrição: Cria tabela para armazenar feedback dos usuários

-- Verificar se a tabela já existe usando INFORMATION_SCHEMA
SET @table_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'feedback'
);

-- Criar tabela apenas se não existir
SET @create_table_sql = IF(
    @table_exists = 0,
    'CREATE TABLE feedback (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        feedback_type VARCHAR(50) NOT NULL,
        name VARCHAR(255),
        email VARCHAR(255),
        message TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        INDEX idx_feedback_user_id (user_id),
        INDEX idx_feedback_created_at (created_at),
        INDEX idx_feedback_type (feedback_type)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci',
    'SELECT "Tabela feedback já existe" AS message'
);

PREPARE stmt FROM @create_table_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Mensagem de sucesso
SELECT 'Migration 004 executada com sucesso' AS status;
