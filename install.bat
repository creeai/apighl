@echo off
echo ========================================
echo    INSTALANDO GHL-EVOLUTION-INTEGRATION
echo ========================================
echo.

echo 1. Criando arquivo .env...
call setup-env.bat

echo.
echo 2. Instalando dependências...
npm install

echo.
echo 3. Verificando instalação...
npm list --depth=0

echo.
echo ========================================
echo    INSTALAÇÃO CONCLUÍDA!
echo ========================================
echo.
echo Para iniciar o servidor, execute:
echo npm run dev
echo.
echo Para testar, acesse:
echo http://localhost:3000/health
echo.
pause
