-- Migration: Adicionar campo is_admin na tabela users
-- Data: 2025-11-25
-- Descrição: Adiciona campo booleano para identificar administradores do sistema

-- Adicionar coluna is_admin
ALTER TABLE users 
ADD COLUMN is_admin BOOLEAN DEFAULT FALSE AFTER status;

-- Criar índice para otimizar consultas de admin
CREATE INDEX idx_users_is_admin ON users(is_admin);

-- Atualizar administradores específicos (manter e-mails seguros)
-- NOTA: Atualizar com os e-mails reais dos 3 administradores
UPDATE users SET is_admin = TRUE WHERE email IN (
    'admin@cuidador.com',
    'admin2@cuidador.com',
    'admin3@cuidador.com'
);
