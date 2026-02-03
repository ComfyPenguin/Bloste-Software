from odoo import http

from ..services.auth_service import AuthService
from ..utils.http import json_response

from ..constants import Endpoints

class UserController(http.Controller):
    
    @http.route(Endpoints.USER_ME, type='http', auth='none', csrf=False, cors='*', methods=['GET'])
    def get_user_data(self, **kw):
        """Devuelve los datos del usuario autenticado mediante JWT."""
        user = AuthService.get_user_from_request()

        if not user:
            return json_response(
                {
                    "error": "Unauthorized",
                    "details": "Token inválido o expirado"
                },
                status=401
            )

        return json_response(
            {
                "id": user.id,
                "name": user.name,
                "email": user.login,
                "partner_id": user.partner_id.id,
            },
            status=200
        )
