-- Migration para adicionar campo n8n_webhook_url na tabela installations
-- Execute este script no seu banco de dados PostgreSQL

ALTER TABLE installations ADD COLUMN IF NOT EXISTS n8n_webhook_url TEXT;

-- Comentário para documentar o campo
COMMENT ON COLUMN installations.n8n_webhook_url IS 'URL do webhook N8N para receber dados de mensagens (INBOUND e OUTBOUND)';

-- Verificar se a coluna foi adicionada
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'installations' 
AND column_name = 'n8n_webhook_url';
