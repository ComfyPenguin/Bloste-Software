import type { Request, Response, NextFunction } from "express";
import { AppError } from "../types/errors.type";

interface ErrorResponse {
  success: false;
  error: {
    message: string;
    statusCode: number;
    stack?: string | string[];
  };
}

// Middleware para manejar errores no encontrados (404)
export function notFoundHandler(req: Request, res: Response, next: NextFunction): void {
  const error = new AppError(`Route ${req.originalUrl} not found`, 404);
  next(error);
}

// Middleware principal de manejo de errores
export function errorHandler(
  err: Error | AppError,
  req: Request,
  res: Response,
  next: NextFunction
): void {
  // Ignorar si la respuesta ya fue enviada
  if (res.headersSent) {
    return next(err);
  }

  let statusCode = 500;
  let message = "Internal server error";
  let isHandledError = false;

  // Si es un error de aplicación personalizado
  if (err instanceof AppError) {
    statusCode = err.statusCode;
    message = err.message;
    isHandledError = err.isExpectedError;
  } else if (err.name === "MulterError") {
    // Errores de Multer
    statusCode = 400;
    message = `File upload error: ${err.message}`;
    isHandledError = true;
  } else {
    // Error no esperado
    message = err.message || message;
  }

  // Log del error
  if (!isHandledError || statusCode >= 500) {
    console.error("Error:", {
      message: err.message,
      statusCode,
      stack: err.stack,
      url: req.originalUrl,
      method: req.method,
      timestamp: new Date().toISOString(),
    });
  } else {
    console.warn("Warning:", {
      message: err.message,
      statusCode,
      url: req.originalUrl,
      method: req.method,
    });
  }

  // Respuesta de error
  const errorResponse: ErrorResponse = {
    success: false,
    error: {
      message,
      statusCode,
    },
  };

  // Incluir detalles de error solo en desarrollo
  if (process.env.NODE_ENV === "development" && err.stack) {
    errorResponse.error.stack = err.stack.split("\n").map((line) => line.trim());
  }

  res.status(statusCode).json(errorResponse);
}

// Middleware para envolver funciones asíncronas y capturar errores
export function asyncHandler(
  fn: (req: Request, res: Response, next: NextFunction) => Promise<void>
) {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
}
