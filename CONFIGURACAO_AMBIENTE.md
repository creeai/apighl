# 🔧 Configuração do Ambiente - GHL Evolution API + N8N

## 📋 Pré-requisitos

### 1. **Node.js e NPM**
```bash
node --version  # v18+ recomendado
npm --version
```

### 2. **PostgreSQL**
```bash
# Instalar PostgreSQL
# Ubuntu/Debian:
sudo apt-get install postgresql postgresql-contrib

# macOS:
brew install postgresql

# Windows:
# Baixar do site oficial: https://www.postgresql.org/download/
```

### 3. **Evolution API**
```bash
# Instalar Evolution API
# Seguir documentação oficial: https://doc.evolution-api.com/
```

## 🚀 Configuração Passo a Passo

### 1. **Clonar e Instalar Dependências**
```bash
git clone <seu-repositorio>
cd ghl-app
npm install
```

### 2. **Configurar Banco de Dados**

#### Criar Banco PostgreSQL
```sql
-- Conectar ao PostgreSQL
psql -U postgres

-- Criar banco de dados
CREATE DATABASE ghl_integration;

-- Criar usuário (opcional)
CREATE USER ghl_user WITH PASSWORD 'sua_senha_forte';
GRANT ALL PRIVILEGES ON DATABASE ghl_integration TO ghl_user;
```

#### Executar Migration
```sql
-- Executar o script de migration
\i database_migration.sql

-- Ou executar manualmente:
ALTER TABLE installations ADD COLUMN IF NOT EXISTS n8n_webhook_url TEXT;
```

### 3. **Configurar Variáveis de Ambiente**

#### Copiar arquivo de exemplo
```bash
cp env.example .env
```

#### Editar arquivo .env
```bash
nano .env
# ou
code .env
```

#### Configuração Mínima Necessária
```env
# ========================================
# CONFIGURAÇÕES OBRIGATÓRIAS
# ========================================
NODE_ENV=development
PORT=3000

# Banco de Dados
DB_HOST=localhost
DB_PORT=5432
DB_NAME=ghl_integration
DB_USER=postgres
DB_PASSWORD=sua_senha_db

# GoHighLevel
GHL_API_DOMAIN=https://services.leadconnectorhq.com
GHL_APP_CLIENT_ID=seu_client_id_do_ghl
GHL_APP_CLIENT_SECRET=seu_client_secret_do_ghl
GHL_APP_REDIRECT_URI=http://localhost:3000/authorize-handler

# Evolution API
EVOLUTION_API_URL=http://localhost:8080
EVOLUTION_API_KEY=sua_evolution_api_key

# ========================================
# CONFIGURAÇÕES OPCIONAIS
# ========================================
# Rate Limiting (requisições por minuto)
RATE_LIMIT_GLOBAL=100
RATE_LIMIT_WEBHOOK=50
RATE_LIMIT_AUTH=5

# Tamanho máximo de payload (em bytes)
PAYLOAD_MAX_SIZE=10485760

# Timeout para chamadas HTTP (em ms)
HTTP_TIMEOUT=30000

# Log level (debug, info, warn, error)
LOG_LEVEL=info

# Chave SSO para descriptografia (opcional)
GHL_APP_SSO_KEY=sua_chave_sso_aqui
```

#### Configuração Completa para Produção
```env
# ========================================
# CONFIGURAÇÕES DO SERVIDOR
# ========================================
NODE_ENV=production
PORT=3000

# ========================================
# BANCO DE DADOS POSTGRESQL
# ========================================
DB_HOST=seu_host_producao
DB_PORT=5432
DB_NAME=ghl_integration
DB_USER=seu_usuario_producao
DB_PASSWORD=senha_forte_producao

# ========================================
# GOHIGHLEVEL API
# ========================================
GHL_API_DOMAIN=https://services.leadconnectorhq.com
GHL_APP_CLIENT_ID=seu_client_id_producao
GHL_APP_CLIENT_SECRET=seu_client_secret_producao
GHL_APP_REDIRECT_URI=https://seu-dominio.com/authorize-handler
GHL_APP_SSO_KEY=sua_chave_sso_producao

# ========================================
# EVOLUTION API
# ========================================
EVOLUTION_API_URL=https://sua-evolution-api.com
EVOLUTION_API_KEY=sua_evolution_api_key_producao

# ========================================
# CONFIGURAÇÕES DE SEGURANÇA
# ========================================
RATE_LIMIT_GLOBAL=100
RATE_LIMIT_WEBHOOK=50
RATE_LIMIT_AUTH=5
PAYLOAD_MAX_SIZE=10485760
HTTP_TIMEOUT=30000
LOG_LEVEL=info

# ========================================
# WEBHOOK N8N (NOVO)
# ========================================
# Esta funcionalidade é configurada por instalação via API
# Não é necessário configurar aqui - use os endpoints:
# POST /integration/setup-n8n-webhook
# DELETE /integration/remove-n8n-webhook
```

### 4. **Configurar GoHighLevel App**

#### No Dashboard do GHL:
1. Acesse **Marketplace** → **Apps**
2. Crie um novo app ou edite existente
3. Configure as URLs:
   - **Redirect URI**: `http://localhost:3000/authorize-handler`
   - **Webhook URL**: `http://localhost:3000/webhook/ghl`
4. Anote o **Client ID** e **Client Secret**

#### Permissões necessárias:
- ✅ `conversations.write`
- ✅ `conversations.readonly`
- ✅ `conversations/message.readonly`
- ✅ `conversations/message.write`
- ✅ `contacts.readonly`
- ✅ `contacts.write`
- ✅ `locations.readonly`

### 5. **Configurar Evolution API**

#### Instalar Evolution API
```bash
# Seguir documentação oficial
# https://doc.evolution-api.com/
```

#### Configurar Webhook
```bash
# No Evolution API, configurar webhook para:
POST http://localhost:3000/webhook/evolution
```

### 6. **Iniciar Aplicação**

#### Desenvolvimento
```bash
npm run dev
# ou
npm start
```

#### Produção
```bash
npm run build
npm run start:prod
```

## 🔗 Configuração do Webhook N8N (NOVO)

### 📋 Variáveis de Ambiente para N8N
```env
# ========================================
# WEBHOOK N8N (NOVO)
# ========================================
# Esta funcionalidade é configurada por instalação via API
# Não é necessário configurar variáveis de ambiente específicas
# Use os endpoints abaixo para configurar:

# Configurar webhook N8N por instalação
POST /integration/setup-n8n-webhook

# Remover webhook N8N por instalação  
DELETE /integration/remove-n8n-webhook
```

### 1. **Configurar Webhook N8N**
```bash
# Após a aplicação estar rodando
curl -X POST http://localhost:3000/integration/setup-n8n-webhook \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <GHL_TOKEN>" \
  -d '{
    "resourceId": "location123",
    "n8nWebhookUrl": "https://seu-n8n.com/webhook/ghl-evolution"
  }'
```

### 2. **Remover Webhook N8N**
```bash
curl -X DELETE http://localhost:3000/integration/remove-n8n-webhook \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <GHL_TOKEN>" \
  -d '{
    "resourceId": "location123"
  }'
```

### 3. **Verificar Configuração N8N**
```bash
# Listar todas as instalações com webhook N8N configurado
curl -X GET http://localhost:3000/integration/installations \
  -H "Authorization: Bearer <GHL_TOKEN>"
```

## 🧪 Testar Configuração

### 1. **Health Check**
```bash
curl http://localhost:3000/health
```

### 2. **Configurações**
```bash
curl http://localhost:3000/config
```

### 3. **Status da Integração**
```bash
curl http://localhost:3000/integration/status
```

### 4. **Teste Evolution API**
```bash
curl http://localhost:3000/test-evolution
```

## 🐛 Troubleshooting

### Problemas Comuns

#### 1. **Erro de Conexão com Banco**
```bash
# Verificar se PostgreSQL está rodando
sudo systemctl status postgresql

# Verificar configurações no .env
echo $DB_HOST $DB_PORT $DB_NAME
```

#### 2. **Erro de Autenticação GHL**
```bash
# Verificar credenciais
echo $GHL_APP_CLIENT_ID
echo $GHL_APP_CLIENT_SECRET

# Verificar URL de redirecionamento
echo $GHL_APP_REDIRECT_URI
```

#### 3. **Erro de Conexão Evolution API**
```bash
# Verificar se Evolution API está rodando
curl http://localhost:8080/instance/connectionState/default

# Verificar configurações
echo $EVOLUTION_API_URL
echo $EVOLUTION_API_KEY
```

#### 4. **Webhook N8N não recebe dados**
```bash
# Verificar se webhook está configurado
curl http://localhost:3000/integration/installations

# Verificar logs da aplicação
tail -f logs/app.log

# Testar webhook N8N manualmente
curl -X POST https://seu-n8n.com/webhook/ghl-evolution \
  -H "Content-Type: application/json" \
  -d '{"test": "webhook funcionando"}'
```

#### 5. **Erro de Timeout N8N**
```bash
# Verificar se N8N está acessível
curl -I https://seu-n8n.com/webhook/ghl-evolution

# Verificar logs de timeout (5 segundos)
grep "timeout" logs/app.log
```

## 📊 Monitoramento

### Logs Importantes
```bash
# Logs de inicialização
✅ Servidor iniciando...
✅ Evolution API: CONFIGURADA
✅ GoHighLevel: CONFIGURADO
✅ Banco de Dados: CONFIGURADO

# Logs de webhook N8N (NOVO)
📤 Enviando dados para N8N (INBOUND): https://seu-n8n.com/webhook
✅ Dados enviados para N8N (INBOUND) com sucesso: cliente1
📤 Enviando dados para N8N (OUTBOUND): https://seu-n8n.com/webhook
✅ Dados enviados para N8N (OUTBOUND) com sucesso: location123
❌ Erro ao enviar dados para N8N (INBOUND): Connection timeout
ℹ️ Webhook N8N não configurado para instância: cliente1
✅ Webhook N8N configurado para location123: https://seu-n8n.com/webhook
✅ Webhook N8N removido para location123
```

### Endpoints de Status
- `GET /health` - Status do servidor
- `GET /config` - Configurações carregadas
- `GET /integration/status` - Status das integrações
- `GET /integration/installations` - Lista instalações
- `GET /test-evolution` - Teste Evolution API

### Endpoints Webhook N8N (NOVO)
- `POST /integration/setup-n8n-webhook` - Configurar webhook N8N
- `DELETE /integration/remove-n8n-webhook` - Remover webhook N8N
- `GET /integration/installations` - Verificar webhooks configurados

## 🚀 Deploy em Produção

### 1. **Configurações de Produção**
```env
NODE_ENV=production
PORT=3000
DB_HOST=seu_host_producao
DB_PASSWORD=senha_forte_producao
GHL_APP_REDIRECT_URI=https://seu-dominio.com/authorize-handler
EVOLUTION_API_URL=https://sua-evolution-api.com
```

### 2. **SSL/HTTPS**
```bash
# Configurar certificado SSL
# Usar proxy reverso (Nginx/Apache)
# Configurar firewall
```

### 3. **Backup do Banco**
```bash
# Backup automático
pg_dump ghl_integration > backup_$(date +%Y%m%d).sql
```

## 🎯 Próximos Passos

1. ✅ Configurar ambiente
2. ✅ Testar integração GHL
3. ✅ Testar integração Evolution API
4. ✅ Configurar webhook N8N
5. ✅ Testar fluxo completo
6. ✅ Deploy em produção

---

**🎉 Sistema 100% funcional com webhook N8N integrado!**
