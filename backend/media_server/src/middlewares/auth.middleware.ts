import type { Request, Response, NextFunction } from "express";
import { importSPKI, jwtVerify, errors } from "jose";
import fs from "fs";
import path from "path";
import type { JwtPayload } from "../types/auth.type";

const publicKeyPath = path.join(__dirname, "../keys/public.pem");
const publicKeyPem = fs.readFileSync(publicKeyPath, "utf8");
let publicKeyCache: CryptoKey | null = null;

// Función base reutilizable
const verifyToken = async (
  req: Request,
  res: Response,
  roleCheck?: (role: string) => boolean
): Promise<JwtPayload | null> => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader?.startsWith("Bearer ")) {
      res.status(401).json({ error: "Token no proporcionado o formato inválido" });
      return null;
    }

    const token = authHeader.substring(7);

    if (!publicKeyCache) {
      publicKeyCache = await importSPKI(publicKeyPem.trim(), "RS256");
    }

    const { payload } = await jwtVerify(token, publicKeyCache, {
      algorithms: ["RS256"],
    });

    const decoded = payload as JwtPayload;

    // Verificar role si se proporciona una función de validación
    if (roleCheck && !roleCheck(decoded.role || "")) {
      res.status(403).json({ error: "Acceso denegado: role no válido" });
      return null;
    }

    return decoded;
  } catch (error) {
    if (error instanceof errors.JWTExpired) {
      res.status(401).json({ error: "Token expirado" });
      return null;
    }

    if (
      error instanceof errors.JWSSignatureVerificationFailed ||
      error instanceof errors.JWTInvalid
    ) {
      res.status(401).json({ error: "Token inválido" });
      return null;
    }

    console.error("Error al verificar token:", error);
    res.status(500).json({ error: "Error al verificar el token" });
    return null;
  }
};

// Middleware para admin
export const adminAuthentication = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const decoded = await verifyToken(req, res, (role) => role === "admin");
  if (decoded) {
    req.user = decoded;
    next();
  }
};

// Middleware para user o admin
export const registeredAuthentication = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const decoded = await verifyToken(req, res, (role) => ["user", "admin"].includes(role));
  if (decoded) {
    req.user = decoded;
    next();
  }
};
