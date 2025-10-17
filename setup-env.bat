@echo off
echo Criando arquivo .env...

echo # Configurações GoHighLevel > .env
echo GHL_APP_CLIENT_ID=68e7d8954422b90cd3085a4b-mgv64d9w >> .env
echo GHL_APP_CLIENT_SECRET=a7dd221f-b1de-4dd2-95f0-ea7baae24a08 >> .env
echo GHL_APP_SSO_KEY=^<SSO_KEY^> >> .env
echo GHL_API_DOMAIN=https://services.leadconnectorhq.com >> .env
echo GHL_APP_SCOPE=conversations.write+conversations.readonly+conversations%%2Fmessage.readonly+conversations%%2Fmessage.write+contacts.readonly+contacts.write+locations.readonly >> .env
echo GHL_MARKETPLACE_URL=https://marketplace.leadconnectorhq.com >> .env
echo GHL_CONVERSATION_PROVIDER_ID=68f1976ca4ccf33378b9c59d >> .env
echo GHL_APP_REDIRECT_URI=https://editor.posicionamentodigital.com/rest/oauth2-credential/callback >> .env
echo. >> .env
echo # Configurações do Servidor >> .env
echo PORT=3000 >> .env
echo NODE_ENV=development >> .env
echo. >> .env
echo # Configurações do Banco de Dados >> .env
echo DB_HOST=aws-0-sa-east-1.pooler.supabase.com >> .env
echo DB_PORT=6543 >> .env
echo DB_USER=postgres.zyvahurvhgdordmybaey >> .env
echo DB_PASSWORD=WZWLvWDoiloIVGxP >> .env
echo DB_NAME=postgres >> .env
echo. >> .env
echo # Configurações Evolution API >> .env
echo EVOLUTION_API_URL=https://evo.posicionamentodigital.com >> .env
echo EVOLUTION_API_KEY=54ed96fa-da27-4c30-9812-483e88c5b366 >> .env
echo. >> .env
echo # CORS - Domínios permitidos >> .env
echo ALLOWED_ORIGINS=https://app.gohighlevel.com,https://marketplace.leadconnectorhq.com >> .env

echo Arquivo .env criado com sucesso!
pause
