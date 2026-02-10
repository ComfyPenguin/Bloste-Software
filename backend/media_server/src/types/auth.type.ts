export interface JwtPayload {
  sub?: string;
  login?: string;
  role?: string;
  iat?: number;
  exp?: number;
  type?: string;
}

// Extender el tipo Request para incluir user
declare global {
  namespace Express {
    interface Request {
      user?: JwtPayload;
    }
  }
}
