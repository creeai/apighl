import { Request, Response, NextFunction } from 'express';

// RATE LIMITING COMPLETAMENTE REMOVIDO - CAUSA CONFLITOS

// Configuração CORS restritiva
export const corsOptions = {
  origin: function (origin: string | undefined, callback: Function) {
    // Permite webhooks sem origin (Evolution API)
    if (!origin) {
      return callback(null, true);
    }
    
    // Lista de origens permitidas
    const allowedOrigins = process.env.ALLOWED_ORIGINS?.split(',') || [
      'https://app.gohighlevel.com',
      'https://marketplace.leadconnectorhq.com'
    ];
    
    // Verifica se a origem está na lista permitida
    if (allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      console.warn(`🚨 Tentativa de acesso CORS de origem não permitida: ${origin}`);
      callback(new Error('Origem não permitida pelo CORS'));
    }
  },
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-API-Key', 'X-GHL-Client-ID', 'X-GHL-Client-Secret'],
  credentials: true,
  maxAge: 86400 // 24 horas
};

// Middleware de sanitização de dados
export const sanitizeInput = (req: Request, res: Response, next: NextFunction) => {
  // Remove caracteres perigosos de todos os campos
  const sanitize = (obj: any): any => {
    if (typeof obj === 'string') {
      return obj.replace(/[<>"'&]/g, '');
    }
    if (typeof obj === 'object' && obj !== null) {
      const sanitized: any = Array.isArray(obj) ? [] : {};
      for (const key in obj) {
        sanitized[key] = sanitize(obj[key]);
      }
      return sanitized;
    }
    return obj;
  };
  
  req.body = sanitize(req.body);
  req.query = sanitize(req.query);
  req.params = sanitize(req.params);
  
  next();
};

// Middleware de logging seguro (sem dados sensíveis)
export const secureLogging = (req: Request, res: Response, next: NextFunction) => {
  const start = Date.now();
  
  // Log da requisição (sem dados sensíveis)
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path} - IP: ${req.ip}`);
  
  // Intercepta a resposta para logging
  const originalSend = res.send;
  res.send = function(data: any) {
    const duration = Date.now() - start;
    
    // Log da resposta (sem dados sensíveis)
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.path} - Status: ${res.statusCode} - Duração: ${duration}ms`);
    
    return originalSend.call(this, data);
  };
  
  next();
};

// Middleware de proteção contra ataques comuns
export const securityHeaders = (req: Request, res: Response, next: NextFunction) => {
  // Headers de segurança
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  res.setHeader('Permissions-Policy', 'geolocation=(), microphone=(), camera=()');
  
  next();
};

// Middleware de validação de tamanho de payload
export const validatePayloadSize = (req: Request, res: Response, next: NextFunction) => {
  const contentLength = parseInt(req.headers['content-length'] || '0');
  const maxSize = 10 * 1024 * 1024; // 10MB
  
  if (contentLength > maxSize) {
    return res.status(413).json({
      success: false,
      message: 'Payload muito grande'
    });
  }
  
  next();
};

// Middleware de proteção contra ataques de timing
export const timingAttackProtection = (req: Request, res: Response, next: NextFunction) => {
  // Adiciona delay aleatório para evitar ataques de timing
  const randomDelay = Math.random() * 100; // 0-100ms
  setTimeout(next, randomDelay);
};