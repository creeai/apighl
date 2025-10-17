# 🚀 GHL-Evolution-Integration - Setup Local

## 📋 **Instalação Rápida**

### **1. Execute o script de instalação:**
```bash
install.bat
```

### **2. Inicie o servidor:**
```bash
npm run dev
```

### **3. Teste a integração:**
```bash
test-n8n.bat
```

## 🔧 **Configuração Manual**

### **1. Instalar dependências:**
```bash
npm install
```

### **2. Criar arquivo .env:**
```bash
# Execute o script
setup-env.bat

# Ou crie manualmente com suas configurações
```

### **3. Iniciar servidor:**
```bash
npm run dev
```

## 🧪 **Testes**

### **1. Verificar saúde:**
```bash
curl http://localhost:3000/health
```

### **2. Listar instalações:**
```bash
curl "http://localhost:3000/integration/installations" \
  -H "X-GHL-Client-ID: 68e7d8954422b90cd3085a4b-mgv64d9w" \
  -H "X-GHL-Client-Secret: a7dd221f-b1de-4dd2-95f0-ea7baae24a08"
```

### **3. Configurar webhook N8N:**
```bash
curl -X POST "http://localhost:3000/integration/configure-n8n-webhook" \
  -H "Content-Type: application/json" \
  -H "X-GHL-Client-ID: 68e7d8954422b90cd3085a4b-mgv64d9w" \
  -H "X-GHL-Client-Secret: a7dd221f-b1de-4dd2-95f0-ea7baae24a08" \
  -d '{
    "resourceId": "SEU_LOCATION_ID",
    "n8n_webhook_url": "https://webhook.site/unique-id"
  }'
```

## 📊 **Endpoints Disponíveis**

- `GET /health` - Verificar saúde do servidor
- `GET /integration/installations` - Listar instalações
- `POST /integration/configure-n8n-webhook` - Configurar webhook N8N
- `POST /webhook/evolution` - Webhook Evolution (INBOUND)
- `POST /webhook/ghl` - Webhook GHL (OUTBOUND)

## 🔍 **Logs**

Monitore os logs em tempo real:
```bash
npm run dev
```

Logs importantes:
- `🔧 Configurando webhook N8N para: [resourceId]`
- `✅ Webhook N8N configurado com sucesso`
- `🔄 Enviando dados INBOUND para N8N webhook`
- `✅ Dados INBOUND enviados com sucesso para N8N`

## 🚨 **Solução de Problemas**

### **Erro: "package.json não encontrado"**
- Execute: `install.bat`

### **Erro: "Módulo não encontrado"**
- Execute: `npm install`

### **Erro: "Banco não conectado"**
- Verifique as configurações no arquivo `.env`

### **Erro: "Porta 3000 em uso"**
- Altere a porta no arquivo `.env`: `PORT=3001`

## 📞 **Suporte**

Se precisar de ajuda, verifique:
1. Logs do servidor
2. Configurações do `.env`
3. Conexão com o banco de dados
4. Credenciais do GHL

---

**Versão:** 2.4.0  
**Status:** ✅ FUNCIONANDO  
**Última atualização:** 2025-01-20
