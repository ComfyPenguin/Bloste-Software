from odoo import http

from ..services.auth_service import AuthService
from ..utils.http import json_response, get_json_body

from ..constants import Endpoints

# Controlador para manejar las rutas de autenticación JWT
class AuthController(http.Controller):

    # Ruta para autenticar usuarios y obtener tokens JWT /auth/token (login)
    @http.route(Endpoints.AUTH_TOKEN, type='http', auth='none', csrf=False, cors='*', methods=['POST'])
    def authenticate(self, **kw):
        """Autentica un usuario y devuelve tokens JWT de acceso y login."""

        data = get_json_body()
        if not data:
            return json_response(
                {"error": "Invalid JSON"},
                status=400)
        
        login = data.get("login")
        password = data.get("password")

        if not login or not password:
            return json_response(
                {"error": "Missing credentials"},
                status=400)
        
        token_data = AuthService.authenticate(login, password)

        if not token_data:
            return json_response(
                {"error": "Invalid credentials"},
                status=401)

        return json_response(token_data, status=200)
    
    # Ruta para refrescar el access token utilizando un refresh token válido /auth/refresh
    @http.route(Endpoints.AUTH_REFRESH, type='http', auth='none', csrf=False, cors='*', methods=['POST'])
    def refresh_token(self, **kw):
        """Refresca un access token utilizando un refresh token válido."""
        data = get_json_body()
        if not data:
            return json_response(
                {"error": "Invalid JSON"},
                status=400)
        
        refresh_token = data.get("refresh_token")

        if not refresh_token:
            return json_response(
                {"error": "Missing refresh_token"},
                status=400)
        
        token_data = AuthService.refresh_token_flow(refresh_token)

        if not token_data:
            return json_response(
                {"error": "Invalid or expired refresh token"},
                status=401)

        return json_response(token_data, status=200)

    # Ruta para registrar un nuevo usuario /auth/register
    @http.route(Endpoints.AUTH_REGISTER, type='http', auth='none', csrf=False, cors='*', methods=['POST'])
    def register(self, **kw):
        """Crear una nueva cuenta de usuario"""
        
        data = get_json_body()
        if not data:
            return json_response({
                "error": "Invalid JSON or empty body"
            }, status=400)

        login = data.get('login')
        password = data.get('password')
        name = data.get('name')

        if not login or not password or not name:
            return json_response(
                {
                    "error": "Faltan campos requeridos (name, login, password)"
                }, status=400)
        
        result = AuthService.register_user(name, login, password)

        if not result["ok"]:
            return json_response({
                "error": result["error"]
            }, status=400)

        return json_response(result["data"], status=201)