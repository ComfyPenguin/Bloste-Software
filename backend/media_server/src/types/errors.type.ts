// Tipos de error personalizados
export class AppError extends Error {
  public readonly statusCode: number;
  public readonly isExpectedError: boolean;

  constructor(message: string, statusCode: number, isHandledError = true) {
    super(message);
    this.statusCode = statusCode;
    this.isExpectedError = isHandledError;

    Error.captureStackTrace(this, this.constructor);
  }
}

export class ValidationError extends AppError {
  constructor(message: string) {
    super(message, 400);
  }
}

export class NotFoundError extends AppError {
  constructor(message: string) {
    super(message, 404);
  }
}

export class UnauthorizedError extends AppError {
  constructor(message: string) {
    super(message, 401);
  }
}

export class ForbiddenError extends AppError {
  constructor(message: string) {
    super(message, 403);
  }
}

export class ConflictError extends AppError {
  constructor(message: string) {
    super(message, 409);
  }
}

export class InternalServerError extends AppError {
  constructor(message: string) {
    super(message, 500);
  }
}
