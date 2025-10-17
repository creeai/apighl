# 🔗 Exemplo de Integração com N8N

## 📋 Visão Geral

Este exemplo mostra como configurar e usar a integração com N8N para receber dados de mensagens WhatsApp (inbound e outbound) em tempo real.

## 🚀 Configuração Inicial

### 1. Configure o Webhook N8N

```bash
curl -X POST "http://localhost:3000/integration/configure-n8n-webhook" \
  -H "Content-Type: application/json" \
  -H "X-GHL-Client-ID: seu_client_id" \
  -H "X-GHL-Client-Secret: seu_client_secret" \
  -d '{
    "resourceId": "73NtQAAH2EvgoqRsx6qJ",
    "n8n_webhook_url": "https://seu-n8n.com/webhook/ghl-evolution"
  }'
```

### 2. Execute a Migração do Banco

```bash
# Execute o script de migração
psql -U $DB_USER -d $DB_NAME -f database-migration-n8n.sql
```

## 📨 Payloads Recebidos no N8N

### Mensagem Recebida (INBOUND)

```json
{
  "event": "whatsapp_message_received",
  "message_type": "inbound",
  "direction": "inbound",
  "instanceName": "cliente123",
  "resourceId": "73NtQAAH2EvgoqRsx6qJ",
  "phoneNumber": "+557388389770",
  "message": "Olá, gostaria de saber sobre os preços",
  "pushName": "João Silva",
  "timestamp": "2025-01-20T15:30:00.000Z",
  "ghl_contact_id": "contact_123",
  "ghl_conversation_id": "conv_456",
  "source": "whatsapp",
  "message_type_detected": "texto",
  "is_media_message": false
}
```

### Mensagem Enviada (OUTBOUND)

```json
{
  "event": "whatsapp_message_sent",
  "message_type": "outbound",
  "direction": "outbound",
  "instanceName": "cliente123",
  "resourceId": "73NtQAAH2EvgoqRsx6qJ",
  "phoneNumber": "+557388389770",
  "message": "Olá! Nossos preços são: Plano Básico R$ 99/mês",
  "timestamp": "2025-01-20T15:35:00.000Z",
  "ghl_contact_id": "contact_123",
  "ghl_message_id": "msg_789",
  "source": "ghl_crm",
  "status": "delivered",
  "evolution_api_response": {
    "success": true,
    "data": { "messageId": "evolution_msg_123" }
  }
}
```

## 🔧 Exemplos de Automação no N8N

### 1. Resposta Automática para Palavras-Chave

```javascript
// Node Function no N8N
const message = $input.first().json.message;
const phoneNumber = $input.first().json.phoneNumber;

if (message.toLowerCase().includes('preço')) {
  return {
    action: 'send_auto_response',
    phoneNumber: phoneNumber,
    message: 'Nossos preços são: Plano Básico R$ 99/mês, Plano Premium R$ 199/mês'
  };
}

if (message.toLowerCase().includes('contato')) {
  return {
    action: 'send_auto_response',
    phoneNumber: phoneNumber,
    message: 'Nosso telefone é (11) 99999-9999'
  };
}

return { action: 'no_auto_response' };
```

### 2. Notificação para Supervisor

```javascript
// Node Function no N8N
const message = $input.first().json.message;
const pushName = $input.first().json.pushName;

if (message.toLowerCase().includes('reclamação') || 
    message.toLowerCase().includes('problema') ||
    message.toLowerCase().includes('insatisfeito')) {
  
  return {
    action: 'notify_supervisor',
    priority: 'high',
    message: `⚠️ RECLAMAÇÃO detectada de ${pushName}: ${message}`,
    phoneNumber: $input.first().json.phoneNumber
  };
}

return { action: 'no_notification' };
```

### 3. Métricas e Analytics

```javascript
// Node Function no N8N
const event = $input.first().json.event;
const timestamp = $input.first().json.timestamp;
const resourceId = $input.first().json.resourceId;

if (event === 'whatsapp_message_sent') {
  // Registrar mensagem enviada
  return {
    action: 'log_metric',
    metric: 'messages_sent',
    resourceId: resourceId,
    timestamp: timestamp,
    data: {
      phoneNumber: $input.first().json.phoneNumber,
      messageLength: $input.first().json.message.length
    }
  };
}

if (event === 'whatsapp_message_received') {
  // Registrar mensagem recebida
  return {
    action: 'log_metric',
    metric: 'messages_received',
    resourceId: resourceId,
    timestamp: timestamp,
    data: {
      phoneNumber: $input.first().json.phoneNumber,
      messageType: $input.first().json.message_type_detected
    }
  };
}
```

### 4. Integração com CRM Externo

```javascript
// Node Function no N8N
const event = $input.first().json.event;
const phoneNumber = $input.first().json.phoneNumber;
const message = $input.first().json.message;

if (event === 'whatsapp_message_received') {
  return {
    action: 'update_crm',
    crm_action: 'add_interaction',
    contact: {
      phone: phoneNumber,
      name: $input.first().json.pushName
    },
    interaction: {
      type: 'whatsapp_message',
      content: message,
      direction: 'inbound',
      timestamp: $input.first().json.timestamp
    }
  };
}
```

## 🔄 Fluxo Completo de Exemplo

### Cenário: Cliente pergunta sobre preços

```
1. Cliente envia: "Qual o preço do produto X?" (WhatsApp)
2. Evolution API → Seu Sistema → GHL
3. Seu Sistema → N8N (INBOUND)
4. N8N detecta palavra "preço" → Envia resposta automática
5. Agente vê no GHL e responde: "O preço é R$ 100" (GHL)
6. GHL → Seu Sistema → Evolution API → WhatsApp
7. Seu Sistema → N8N (OUTBOUND)
8. N8N registra métricas: tempo de resposta, agente, etc.
```

## 🛠️ Configuração do Webhook no N8N

### 1. Crie um Webhook Node

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

### 2. Configure o Processamento

```json
{
  "name": "Process Message",
  "type": "n8n-nodes-base.function",
  "parameters": {
    "functionCode": "// Processar mensagem baseada no tipo\nconst event = $input.first().json.event;\nconst direction = $input.first().json.direction;\n\nif (event === 'whatsapp_message_received') {\n  // Processar mensagem recebida\n  return {\n    action: 'process_inbound',\n    data: $input.first().json\n  };\n} else if (event === 'whatsapp_message_sent') {\n  // Processar mensagem enviada\n  return {\n    action: 'process_outbound',\n    data: $input.first().json\n  };\n}\n\nreturn { action: 'unknown', data: $input.first().json };"
  }
}
```

## 📊 Monitoramento

### Logs Importantes

```bash
# Verificar se webhook N8N está configurado
curl "http://localhost:3000/integration/installations"

# Verificar logs do sistema
npm run dev

# Logs que você verá:
# 🔄 Enviando dados INBOUND para N8N webhook: https://seu-n8n.com/webhook/ghl-evolution
# ✅ Dados INBOUND enviados com sucesso para N8N
# 🔄 Enviando dados OUTBOUND para N8N webhook: https://seu-n8n.com/webhook/ghl-evolution
# ✅ Dados OUTBOUND enviados com sucesso para N8N
```

## 🚨 Tratamento de Erros

### Se N8N estiver offline

```bash
# Logs que você verá:
# ❌ Erro ao enviar INBOUND para N8N: connect ECONNREFUSED
# ❌ Erro ao enviar OUTBOUND para N8N: timeout of 5000ms exceeded

# O fluxo principal continua funcionando normalmente!
# Apenas o N8N não recebe os dados
```

### Se URL do webhook for inválida

```bash
# Logs que você verá:
# ❌ Erro ao enviar INBOUND para N8N: Invalid URL
# ❌ Erro ao enviar OUTBOUND para N8N: Invalid URL

# O fluxo principal continua funcionando normalmente!
```

## 🎯 Casos de Uso Avançados

### 1. Chatbot Inteligente
- Detectar intenção da mensagem
- Responder automaticamente
- Escalar para humano quando necessário

### 2. Análise de Sentimento
- Analisar tom das mensagens
- Alertar para mensagens negativas
- Priorizar atendimento

### 3. Integração com IA
- Usar GPT/Claude para respostas
- Tradução automática
- Resumo de conversas

### 4. Métricas Avançadas
- Tempo de resposta
- Volume de mensagens
- Satisfação do cliente
- Performance por agente

## 🔧 Troubleshooting

### Webhook não recebe dados
1. Verifique se a URL está correta
2. Teste a URL manualmente
3. Verifique logs do N8N
4. Verifique logs do sistema

### Dados incompletos
1. Verifique se a instalação está ativa
2. Verifique se o webhook está configurado
3. Verifique logs para erros

### Performance
1. N8N tem timeout de 5 segundos
2. Falha no N8N não afeta o fluxo principal
3. Use processamento assíncrono no N8N
