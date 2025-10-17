-- Migração para adicionar suporte ao webhook N8N
-- Execute este script no seu banco PostgreSQL

-- Adicionar coluna n8n_webhook_url na tabela installations
ALTER TABLE installations 
ADD COLUMN IF NOT EXISTS n8n_webhook_url VARCHAR(500) NULL;

-- Comentário para documentar a nova coluna
COMMENT ON COLUMN installations.n8n_webhook_url IS 'URL do webhook N8N para receber dados de mensagens (inbound e outbound)';

-- Verificar se a coluna foi adicionada corretamente
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'installations' 
AND column_name = 'n8n_webhook_url';

-- Exemplo de como a tabela deve ficar após a migração:
-- SELECT * FROM installations LIMIT 1;
