from odoo import http

from ..services.auth_service import AuthService
from ..utils.http import json_response

from ..constants import Endpoints

class UserController(http.Controller):
    
    @http.route(Endpoints.USER_ME, type='http', auth='none', csrf=False, cors='*', methods=['GET'])
    def get_user_data(self, **kw):
        """Devuelve los datos del usuario autenticado mediante JWT con rol actualizado."""
        user_data = AuthService.get_user_data_with_role()

        if not user_data:
            return json_response(
                {
                    "error": "Unauthorized",
                    "details": "Token inválido o expirado"
                },
                status=401
            )

        return json_response(user_data, status=200)
    
    @http.route('/api/users/check-groups', type='http', auth='none', csrf=False, cors='*', methods=['GET'])
    def check_user_groups(self, **kw):
        """Endpoint temporal para verificar los grupos del usuario autenticado."""
        user = AuthService.get_user_from_request()

        if not user:
            return json_response(
                {"error": "Unauthorized"},
                status=401
            )

        return json_response(
            {
                "id": user.id,
                "login": user.login,
                "name": user.name,
                "groups": [g.full_name for g in user.groups_id],
                "has_system_group": user.has_group("base.group_system"),
                "has_admin_group": user.has_group("base.group_erp_manager"),
                "computed_role": "admin" if user.has_group("base.group_system") else "user"
            },
            status=200
        )
