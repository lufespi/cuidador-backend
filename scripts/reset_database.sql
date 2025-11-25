-- ============================================================================
-- SCRIPT DE RESET COMPLETO DO BANCO - AMBIENTE DE HOMOLOGAÇÃO
-- ============================================================================
-- ATENÇÃO: Este script APAGA TODOS OS DADOS e recria as tabelas do zero
-- Use apenas em ambiente de homologação/desenvolvimento
-- ============================================================================

-- Desabilita verificações de foreign key temporariamente
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- PASSO 1: REMOVER TABELAS EXISTENTES
-- ============================================================================

DROP TABLE IF EXISTS pain_records;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS migration_history;

-- ============================================================================
-- PASSO 2: CRIAR TABELA DE USUÁRIOS
-- ============================================================================

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    telefone VARCHAR(20),
    data_nascimento DATE,
    status VARCHAR(20) DEFAULT 'ativo',
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_users_email (email),
    INDEX idx_users_cpf (cpf),
    INDEX idx_users_is_admin (is_admin),
    INDEX idx_users_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- PASSO 3: CRIAR TABELA DE REGISTROS DE DOR
-- ============================================================================

CREATE TABLE pain_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    intensidade INT NOT NULL CHECK (intensidade BETWEEN 0 AND 10),
    body_parts JSON NOT NULL,
    descricao TEXT,
    data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_pain_user_id (user_id),
    INDEX idx_pain_data_registro (data_registro),
    INDEX idx_pain_intensidade (intensidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- PASSO 4: CRIAR TABELA DE HISTÓRICO DE MIGRAÇÕES
-- ============================================================================

CREATE TABLE migration_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    migration_name VARCHAR(255) NOT NULL UNIQUE,
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    INDEX idx_migration_name (migration_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- PASSO 5: REGISTRAR MIGRAÇÕES APLICADAS
-- ============================================================================

INSERT INTO migration_history (migration_name, description) VALUES
('001_initial_schema', 'Criação inicial das tabelas users e pain_records'),
('002_add_admin_field', 'Adição do campo is_admin na tabela users'),
('003_add_body_parts', 'Adição do campo body_parts JSON na tabela pain_records');

-- ============================================================================
-- PASSO 6: INSERIR USUÁRIOS DE TESTE (OPCIONAL)
-- ============================================================================

-- Senha: "teste123" (hash bcrypt)
-- Descomente as linhas abaixo se quiser usuários de teste

/*
INSERT INTO users (nome, email, senha, cpf, telefone, data_nascimento, is_admin) VALUES
('Administrador Sistema', 'admin@cuidador.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIvApBG.yG', '111.111.111-11', '(11) 91111-1111', '1980-01-01', TRUE),
('Usuário Teste 1', 'usuario1@teste.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIvApBG.yG', '222.222.222-22', '(11) 92222-2222', '1990-01-01', FALSE),
('Usuário Teste 2', 'usuario2@teste.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIvApBG.yG', '333.333.333-33', '(11) 93333-3333', '1995-01-01', FALSE);
*/

-- ============================================================================
-- PASSO 7: REABILITAR VERIFICAÇÕES DE FOREIGN KEY
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- VERIFICAÇÃO FINAL
-- ============================================================================

SELECT 'RESET CONCLUÍDO COM SUCESSO!' as status;
SELECT COUNT(*) as total_users FROM users;
SELECT COUNT(*) as total_pain_records FROM pain_records;
SELECT COUNT(*) as total_migrations FROM migration_history;

-- Para verificar a estrutura das tabelas:
-- SHOW CREATE TABLE users;
-- SHOW CREATE TABLE pain_records;
-- SHOW CREATE TABLE migration_history;
