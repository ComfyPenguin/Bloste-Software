import jwt
import logging
import datetime
import odoo

from odoo.tools import config
from odoo.http import request
import hashlib

from ..constants import Configuration, ACCESS_TOKEN_EXPIRES_IN, LOGIN_TOKEN_EXPIRES_IN, TOKEN_TYPE_ACCESS, TOKEN_TYPE_LOGIN, REFRESH_TOKEN_EXPIRES_IN, TOKEN_TYPE_REFRESH

logger = logging.getLogger(__name__)

class JWTService:
    
    @staticmethod
    def get_private_key():
        """Lee la clave privada desde el archivo especificado en odoo.conf"""
        path = config.get("private")
        if not path:
            logger.warning("Clave privada JWT no configurada")

        try:
            with open(path, 'r') as f:
                return f.read()
        except FileNotFoundError:
            logger.error(f"Archivo de clave privada no encontrada: {path}")
        except Exception as e:
            logger.error(f"Error al leer la clave privada: {e}")

    @staticmethod
    def get_public_key():
        """Lee la clave pública desde el archivo especificado en odoo.conf"""
        path = config.get("public")
        if not path:
            logger.warning("Clave pública JWT no configurada")
        
        try:
            with open(path, 'r') as f:
                return f.read()
        except FileNotFoundError:
            logger.error(f"Archivo de clave pública no encontrada: {path}")
        except Exception as e:
            logger.error(f"Error al leer la clave pública: {e}")
    
    @staticmethod
    def _generate_token_hash(token):
        """Genera un hash SHA256 del token."""
        return hashlib.sha256(token.encode('utf-8')).hexdigest()

    @staticmethod
    def create_token(payload, token_type=TOKEN_TYPE_ACCESS, expires_in=None):
        """Crear un JWT firmado con expiración y tipo de token."""
        now = datetime.datetime.now(datetime.timezone.utc)

        if expires_in is None:
            if token_type == TOKEN_TYPE_LOGIN:
                expires_in_seconds = LOGIN_TOKEN_EXPIRES_IN
            elif token_type == TOKEN_TYPE_REFRESH:
                expires_in_seconds = REFRESH_TOKEN_EXPIRES_IN
            else:
                expires_in_seconds = ACCESS_TOKEN_EXPIRES_IN
        else:
            expires_in_seconds = expires_in

        data = payload.copy()
        data.update({
            "iat": int(now.timestamp()),
            "exp": int((now + datetime.timedelta(seconds=expires_in_seconds)).timestamp()),
            "type": token_type
        })

        private_key = JWTService.get_private_key()
        if not private_key:
            raise ValueError("No se pudo obtener la clave privada JWT")

        return jwt.encode(
            data,
            JWTService.get_private_key(),
            algorithm=Configuration.ALGORITHM_RS
        )
    
    @staticmethod
    def create_refresh_token(user_id, login, role):
        """
        Genera un refresh token JWT, lo guarda en la BD y lo devuelve.
        El payload del refresh token debe ser minimalista y contener solo lo necesario para identificar al usuario.
        """
        refresh_token = JWTService.create_token(
            payload={
                "sub": str(user_id),
                "login": login,
                "role": role,
            },
            token_type=TOKEN_TYPE_REFRESH,
            expires_in=REFRESH_TOKEN_EXPIRES_IN
        )

        token_hash = JWTService._generate_token_hash(refresh_token)

        now_utc = datetime.datetime.utcnow()
        expires_at_dt = now_utc + datetime.timedelta(seconds=REFRESH_TOKEN_EXPIRES_IN)
        issued_at_dt = now_utc

        try:
            env_as_superuser = request.env(user=odoo.SUPERUSER_ID, su=True)
            env_as_superuser['auth.refresh.token'].create({
                'user_id': user_id,
                'token_hash': token_hash,
                'expiration_date': expires_at_dt,
                'issued_at': issued_at_dt,
                'is_revoked': False,
            })
            return refresh_token
        except Exception as e:
            logger.error(f"Error al guardar el refresh token en la BD: {e}")
            raise


    @staticmethod
    def revoke_refresh_token(token):
        """Marca un refresh token como revocado en la base de datos."""
        token_hash = JWTService._generate_token_hash(token)
        try:
            env_as_superuser = request.env(user=odoo.SUPERUSER_ID, su=True)
            refresh_token_record = env_as_superuser['auth.refresh.token'].search([('token_hash', '=', token_hash)], limit=1)
            if refresh_token_record:
                refresh_token_record.write({'is_revoked': True})
                return True
            return False
        except Exception as e:
            logger.error(f"Error al revocar el refresh token: {e}")
            return False

    @staticmethod
    def validate_refresh_token(token):
        """Decodifica, valida y verifica el estado de un refresh token en la BD."""
        try:
            payload = JWTService.decode_token(token)
            if payload.get('type') != TOKEN_TYPE_REFRESH:
                logger.warning("Tipo de token inválido para refresh token.")
                return None

            user_id = int(payload.get('sub'))
            token_hash = JWTService._generate_token_hash(token)

            env_as_superuser = request.env(user=odoo.SUPERUSER_ID, su=True)
            refresh_token_record = env_as_superuser['auth.refresh.token'].search([
                ('token_hash', '=', token_hash),
                ('user_id', '=', user_id),
                ('is_revoked', '=', False),
                ('expiration_date', '>', datetime.datetime.now(datetime.timezone.utc))
            ], limit=1)

            if not refresh_token_record:
                logger.warning("Refresh token no encontrado, revocado o expirado en la BD.")
                return None
            
            return user_id
            
        except jwt.ExpiredSignatureError:
            logger.warning("Refresh token expirado.")
            return None
        except jwt.InvalidTokenError:
            logger.warning("Refresh token inválido.")
            return None
        except Exception as e:
            logger.error(f"Error al validar refresh token: {e}")
            return None

    @staticmethod
    def decode_token(token):
        """Decodificar y valida un JWT. Lanza excepción si es inválido."""
        public_key = JWTService.get_public_key()
        if not public_key:
            raise ValueError("No se pudo obtener la clave pública JWT")
        
        return jwt.decode(
            token,
            JWTService.get_public_key(),
            algorithms=[Configuration.ALGORITHM_RS]
        )
    
    @staticmethod
    def get_uid_from_token(token):
        """Extrae el UID del JWT (claim sub)."""
        payload = JWTService.decode_token(token)
        uid = payload.get("sub")

        try:
            return int(uid)
        except (TypeError, ValueError):
            return None