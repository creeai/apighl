const express = require('express');
const app = express();
const port = 3001;

app.get('/health', (req, res) => {
  res.json({
    success: true,
    message: "Servidor funcionando",
    timestamp: new Date().toISOString(),
    version: "2.4.0"
  });
});

app.listen(port, () => {
  console.log(`🚀 Servidor rodando na porta ${port}`);
  console.log(`🔗 URL: http://localhost:${port}`);
  console.log(`📋 Health Check: http://localhost:${port}/health`);
});
