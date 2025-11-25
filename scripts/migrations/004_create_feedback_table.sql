-- Migration 004: Criar tabela de feedback
-- Data: 2024-11-25
-- Descrição: Cria tabela para armazenar feedback dos usuários

CREATE TABLE IF NOT EXISTS feedback (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
