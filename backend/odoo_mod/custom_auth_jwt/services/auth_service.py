import logging
import odoo

from odoo.http import request
from odoo.tools import config
from odoo.exceptions import AccessDenied, UserError

from ..services.jwt_service import JWTService
from ..constants import ACCESS_TOKEN_EXPIRES_IN, LOGIN_TOKEN_EXPIRES_IN, TOKEN_TYPE_ACCESS, TOKEN_TYPE_LOGIN, REFRESH_TOKEN_EXPIRES_IN, TOKEN_TYPE_REFRESH

logger = logging.getLogger(__name__)

class AuthService:

    @staticmethod
    def authenticate(login, password):
        """Autentica usuario en Odoo y devuelve JWTs de acceso y refresh."""
        db = request.session.db

        try:
            uid = request.session.authenticate(db, login, password)
        except AccessDenied:
            logger.info("Invalid credentials")
            return None
        
        if not uid:
            logger.info("Authentication failed")
            return None
        
        user =  request.env["res.users"].sudo().browse(uid)
        role = "admin" if user.has_group("base.group_system") else "user"
        
        # Create refresh token (and persist it in DB)
        refresh_token = JWTService.create_refresh_token(
            user_id=uid,
            login=login,
            role=role
        )

        # Create access token
        access_token = JWTService.create_token(
            payload={
                "sub": str(uid),
                "login": login,
                "role": role,
            },
            token_type=TOKEN_TYPE_ACCESS,
            expires_in=ACCESS_TOKEN_EXPIRES_IN
        )

        return {
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "Bearer",
            "expires_in": ACCESS_TOKEN_EXPIRES_IN # Primary expiration for the access token
        }
    
    @staticmethod
    def refresh_token_flow(refresh_token):
        """
        Maneja el flujo de refresh token: valida el token existente y emite uno nuevo de acceso.
        """
        user_id = JWTService.validate_refresh_token(refresh_token)

        if not user_id:
            return None
        
        user = request.env["res.users"].sudo().browse(user_id)
        if not user.exists():
            logger.warning(f"Usuario {user_id} no encontrado para refresh token válido.")
            return None
        
        role = "admin" if user.has_group("base.group_system") else "user"

        # Issue a new access token
        new_access_token = JWTService.create_token(
            payload={
                "sub": str(user_id),
                "login": user.login,
                "role": role,
            },
            token_type=TOKEN_TYPE_ACCESS,
            expires_in=ACCESS_TOKEN_EXPIRES_IN
        )

        return {
            "access_token": new_access_token,
            "refresh_token": refresh_token, # Return the same refresh token, no rotation for now
            "token_type": "Bearer",
            "expires_in": ACCESS_TOKEN_EXPIRES_IN
        }

    @staticmethod
    def get_user_from_request():
        """Devuelve el usuario autenticado a partir del JWT del header."""
        auth_header = request.httprequest.headers.get("Authorization")

        if not auth_header or not auth_header.startswith("Bearer "):
            return None
        
        token = auth_header.split(" ", 1)[1]

        try:
            payload = JWTService.decode_token(token)
            
            # Asegurar que el token es de tipo 'access'
            if payload.get("type") != TOKEN_TYPE_ACCESS:
                logger.warning("Invalid token type for access: %s", payload.get("type"))
                return None

            uid = payload.get("sub")
            if not uid:
                return None
        
            user = request.env["res.users"].sudo().browse(int(uid))
            if not user.exists():
                return None
            return user
        
        except Exception as e:
            logger.warning("JWT inválido; %s", e)
            return None
        
    @staticmethod
    def register_user(name, login, password):
        """Crear un usuario en Odoo y devuelve un JWT"""

        existing_user = request.env['res.users'].sudo().search([('login', '=', login)], limit=1)
        company = request.env['res.company'].sudo().search([], limit=1)
        
        if existing_user:
            return {"ok": False, "error": "Usuario existe actualmente"}
        
        try:
            # Para la creación de usuarios bajo 'auth=none', el usuario del entorno está vacío.
            # Esto causa un error en 'mail_thread.message_post' al crear un usuario del portal.
            # Debemos ejecutar la creación en un entorno con un usuario válido, como el superusuario.
            env_as_superuser = request.env(user=odoo.SUPERUSER_ID, su=True)

            portal_group_id = env_as_superuser.ref('base.group_portal').id

            new_user = env_as_superuser['res.users'].create({
                'login': login,
                'name': name,
                'password': password,
                'company_id': company.id,
                'company_ids': [(6, 0, [company.id])],
                'groups_id': [(6, 0, [portal_group_id])]
            })
            
        except UserError as e:
            logger.error("Error al crar el usuario: %s", e)
            return {"ok": False, "error": str(e)}
        
        exp_seconds = int(config.get('jwt_expiration', 3000))
        token = JWTService.create_token(
            payload={
                "sub": str(new_user.id),
                "login": new_user.login,
                "role": "user",
            },
            expires_in=exp_seconds
        )

        token_data = {
            "token": token,
            "token_type": "Bearer",
            "expires_in": exp_seconds
        }

        return {"ok": True, "data": token_data}