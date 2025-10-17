@echo off
echo ========================================
echo    TESTANDO INTEGRAÇÃO N8N
echo ========================================
echo.

set CLIENT_ID=68e7d8954422b90cd3085a4b-mgv64d9w
set CLIENT_SECRET=a7dd221f-b1de-4dd2-95f0-ea7baae24a08
set BASE_URL=http://localhost:3000
set RESOURCE_ID=SEU_LOCATION_ID_AQUI
set WEBHOOK_URL=https://webhook.site/unique-id-aqui

echo 1. Verificando saúde do servidor...
curl -s %BASE_URL%/health

echo.
echo 2. Listando instalações...
curl -s "%BASE_URL%/integration/installations" -H "X-GHL-Client-ID: %CLIENT_ID%" -H "X-GHL-Client-Secret: %CLIENT_SECRET%"

echo.
echo 3. Configurando webhook N8N...
curl -X POST "%BASE_URL%/integration/configure-n8n-webhook" -H "Content-Type: application/json" -H "X-GHL-Client-ID: %CLIENT_ID%" -H "X-GHL-Client-Secret: %CLIENT_SECRET%" -d "{\"resourceId\": \"%RESOURCE_ID%\", \"n8n_webhook_url\": \"%WEBHOOK_URL%\"}"

echo.
echo 4. Testando webhook Evolution (INBOUND)...
curl -X POST "%BASE_URL%/webhook/evolution" -H "Content-Type: application/json" -d "{\"event\": \"messages.upsert\", \"instance\": \"cliente123\", \"data\": {\"key\": {\"remoteJid\": \"557388389770@s.whatsapp.net\", \"fromMe\": false}, \"pushName\": \"João Silva\", \"message\": {\"conversation\": \"Olá, gostaria de saber sobre os preços\"}}}"

echo.
echo 5. Testando webhook GHL (OUTBOUND)...
curl -X POST "%BASE_URL%/webhook/ghl" -H "Content-Type: application/json" -d "{\"type\": \"OutboundMessage\", \"locationId\": \"%RESOURCE_ID%\", \"contactId\": \"contact_123\", \"messageId\": \"msg_789\", \"body\": \"Olá! Nossos preços são: Plano Básico R$ 99/mês\", \"direction\": \"outbound\", \"source\": \"ghl_crm\"}"

echo.
echo ========================================
echo    TESTES CONCLUÍDOS!
echo ========================================
echo.
echo Verifique o webhook.site para ver os payloads recebidos.
echo.
pause
