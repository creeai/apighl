# 🔗 Integração Webhook N8N - GHL Evolution API

## 📋 Visão Geral

Esta implementação permite que o sistema de integração GHL + Evolution API envie dados de mensagens (INBOUND e OUTBOUND) para webhooks N8N configurados por instalação.

## 🏗️ Arquitetura

```
WhatsApp → Evolution API → Sistema GHL → GHL CRM
    ↓                           ↓
    └── Webhook N8N ←──────────┘
```

## 🚀 Configuração

### 1. Executar Migration do Banco
```sql
-- Execute o arquivo database_migration.sql
ALTER TABLE installations ADD COLUMN IF NOT EXISTS n8n_webhook_url TEXT;
```

### 2. Configurar Webhook N8N
```bash
POST /integration/setup-n8n-webhook
Content-Type: application/json
Authorization: Bearer <GHL_TOKEN>

{
  "resourceId": "location123",
  "n8nWebhookUrl": "https://seu-n8n.com/webhook/ghl-evolution"
}
```

### 3. Remover Webhook N8N
```bash
DELETE /integration/remove-n8n-webhook
Content-Type: application/json
Authorization: Bearer <GHL_TOKEN>

{
  "resourceId": "location123"
}
```

## 📊 Payloads Enviados para N8N

### 🔽 INBOUND (WhatsApp → GHL)
```json
{
  "type": "inbound",
  "direction": "whatsapp_to_ghl",
  "instanceName": "cliente1",
  "resourceId": "location123",
  "phoneNumber": "+5511999999999",
  "message": "Olá, preciso de ajuda",
  "messageType": "texto",
  "isMediaMessage": false,
  "pushName": "João Silva",
  "timestamp": "2024-01-15T10:30:00Z",
  "ghlMessageId": "msg_123456",
  "conversationProviderId": "conv_789",
  "evolutionInstanceName": "cliente1"
}
```

### 🔼 OUTBOUND (GHL → WhatsApp)
```json
{
  "type": "outbound",
  "direction": "ghl_to_whatsapp",
  "locationId": "location123",
  "contactId": "contact456",
  "phoneNumber": "+5511999999999",
  "message": "Olá! Como posso ajudar?",
  "messageId": "msg_789012",
  "instanceName": "cliente1",
  "timestamp": "2024-01-15T10:35:00Z",
  "status": "delivered",
  "conversationProviderId": "conv_789",
  "companyId": "company123"
}
```

## 🎯 Casos de Uso no N8N

### 1. **Automação de Respostas**
- Detectar palavras-chave nas mensagens
- Enviar respostas automáticas
- Roteamento inteligente de conversas

### 2. **Métricas e Analytics**
- Contar mensagens por período
- Tempo de resposta
- Volume de conversas

### 3. **Integração com Outros Sistemas**
- CRM externo
- Sistema de tickets
- Notificações Slack/Teams

### 4. **IA e Processamento**
- Análise de sentimento
- Classificação de intenções
- Sugestões de respostas

## 🔧 Configuração no N8N

### 1. **Webhook Node**
```json
{
  "name": "GHL Evolution Webhook",
  "type": "n8n-nodes-base.webhook",
  "parameters": {
    "path": "ghl-evolution",
    "httpMethod": "POST",
    "responseMode": "responseNode"
  }
}
```

### 2. **Processamento de Dados**
```javascript
// Node Code - Processar dados recebidos
const data = $input.all()[0].json;

if (data.type === 'inbound') {
  // Processar mensagem recebida
  console.log(`Mensagem recebida de ${data.phoneNumber}: ${data.message}`);
  
  // Lógica de automação aqui
  if (data.message.toLowerCase().includes('preço')) {
    // Enviar resposta automática sobre preços
    return {
      action: 'send_auto_response',
      message: 'Aqui estão nossos preços...',
      contactId: data.phoneNumber
    };
  }
} else if (data.type === 'outbound') {
  // Processar mensagem enviada
  console.log(`Mensagem enviada para ${data.phoneNumber}: ${data.message}`);
  
  // Registrar métricas
  return {
    action: 'log_metrics',
    type: 'outbound_message',
    timestamp: data.timestamp
  };
}
```

## 🛡️ Segurança

### Headers Enviados
```
Content-Type: application/json
User-Agent: GHL-Evolution-Integration/2.0.0
```

### Timeout
- **5 segundos** para chamadas N8N
- **Não bloqueia** o fluxo principal
- **Logs detalhados** para debugging

### Validações
- ✅ URL válida obrigatória
- ✅ Instalação deve existir
- ✅ Credenciais GHL válidas
- ✅ Rate limiting aplicado

## 📈 Monitoramento

### Logs Gerados
```
✅ Dados enviados para N8N (INBOUND) com sucesso: cliente1
✅ Dados enviados para N8N (OUTBOUND) com sucesso: location123
❌ Erro ao enviar dados para N8N (INBOUND): Connection timeout
ℹ️ Webhook N8N não configurado para instância: cliente1
```

### Endpoints de Status
```bash
# Verificar instalações
GET /integration/installations

# Status da integração
GET /integration/status

# Configurações do servidor
GET /config
```

## 🔄 Fluxo Completo

### **Cenário: Cliente pergunta sobre preços**

1. **Cliente envia mensagem no WhatsApp**
   ```
   "Qual o preço do produto X?"
   ```

2. **Evolution API recebe e envia webhook**
   ```json
   {
     "event": "messages.upsert",
     "data": { "message": "Qual o preço do produto X?" }
   }
   ```

3. **Sistema processa e envia para GHL**
   - Cria/atualiza contato
   - Envia mensagem para GHL
   - Retorna sucesso

4. **Sistema envia dados para N8N (INBOUND)**
   ```json
   {
     "type": "inbound",
     "message": "Qual o preço do produto X?",
     "phoneNumber": "+5511999999999"
   }
   ```

5. **N8N processa e pode:**
   - Detectar palavra "preço"
   - Enviar resposta automática
   - Registrar métrica
   - Notificar equipe

6. **Agente responde pelo GHL**
   ```
   "O produto X custa R$ 100,00"
   ```

7. **Sistema envia dados para N8N (OUTBOUND)**
   ```json
   {
     "type": "outbound",
     "message": "O produto X custa R$ 100,00",
     "phoneNumber": "+5511999999999"
   }
   ```

## 🎉 Benefícios

### ✅ **Visibilidade Completa**
- Todo o fluxo de conversas
- Dados estruturados
- Timestamps precisos

### ✅ **Automação Avançada**
- Respostas automáticas
- Roteamento inteligente
- Classificação de mensagens

### ✅ **Integração Flexível**
- Qualquer sistema via N8N
- APIs externas
- Bancos de dados

### ✅ **Não Quebra Nada**
- Fluxo atual mantido
- Chamadas assíncronas
- Backward compatible

## 🚨 Troubleshooting

### Webhook não recebe dados
1. Verificar se URL está configurada
2. Testar conectividade N8N
3. Verificar logs do sistema

### Dados duplicados
1. Sistema tem deduplicação
2. Verificar configuração N8N
3. Checar timeouts

### Performance
1. N8N tem timeout de 5s
2. Não bloqueia fluxo principal
3. Logs para monitoramento

## 📞 Suporte

Para dúvidas ou problemas:
- Verificar logs do sistema
- Testar endpoints de status
- Validar configuração N8N
- Checar conectividade

---

**🎯 Implementação 100% funcional e pronta para produção!**
