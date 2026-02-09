from odoo import http, fields
from odoo.http import request
from odoo.exceptions import AccessDenied
import logging

_logger = logging.getLogger(__name__)

class BlosteWebsite(http.Controller):
    """Controller base para la aplicación web de Bloste"""

    def _render_website_page_with_plans(self, url):
        """Renderiza una página creada en Website Builder pasando planes"""
        subscriptions = request.env['bloste.subscription'].sudo().search([])
        page = request.env['website.page'].sudo().search([('url', '=', url)], limit=1)

        if page and page.view_id:
            return request.render(page.view_id.id, {
                'subscriptions': subscriptions,
            })

        return request.render('bloste_web.subscriptions_template', {
            'subscriptions': subscriptions,
        })

    @http.route('/in', type='http', auth='public', website=True)
    def login_register(self):
        """Página de login/registro"""
        return request.render('bloste_web.login_register_template')

    @http.route('/suscripciones', type='http', auth='public', website=True)
    def subscription_plans(self):
        """Página pública de planes de suscripción"""
        return self._render_website_page_with_plans('/suscripciones')

    @http.route('/planes', type='http', auth='public', website=True)
    def subscription_plans_alias(self):
        """Alias: planes = suscripciones"""
        return request.redirect('/suscripciones')
    
    @http.route('/productos', type='http', auth='public', website=True)
    def products(self):
        """Alias: productos = planes"""
        return request.redirect('/suscripciones')
    
    @http.route('/info-usuario', type='http', auth='public', website=True)
    def info_usuario(self, plan=None, **kwargs):
        """Página de información del usuario con plan preseleccionado"""
        page = request.env['website.page'].sudo().search([('url', '=', '/info-usuario')], limit=1)
        
        if page and page.view_id:
            return request.render(page.view_id.id, {
                'plan': plan,
            })
        
        return request.render('bloste_web.info_usuario_page_view', {
            'plan': plan,
        })
    
    @http.route('/info-usuario/submit', type='http', auth='public', website=True, methods=['POST'], csrf=True)
    def info_usuario_submit(self, **post):
        """Procesar envío del formulario: autenticar usuario y asignar suscripción"""
        email = post.get('email')
        password = post.get('password')
        subscription_plan = post.get('subscription_plan')
        
        _logger.info(f"Intento de contratación - Email: {email}, Plan: {subscription_plan}")
        
        if not email or not password:
            _logger.warning("Faltan email o contraseña")
            return request.render('bloste_web.info_usuario_page_view', {
                'error': 'Por favor, ingresa tu email y contraseña',
                'plan': subscription_plan,
            })
        
        # Buscar el usuario por email
        user = request.env['res.users'].sudo().search([('login', '=', email)], limit=1)
        
        if not user:
            _logger.warning(f"Usuario no encontrado: {email}")
            return request.render('bloste_web.info_usuario_page_view', {
                'error': f'No existe ningún usuario con el email {email}. Por favor, regístrate primero.',
                'plan': subscription_plan,
            })
        
        # Verificar la contraseña SIN cambiar la sesión actual
        try:
            # Verificar credenciales sin autenticar (no cambia la sesión)
            user.sudo()._check_credentials(password, request.env)
            _logger.info(f"Credenciales verificadas correctamente para: {email} (ID: {user.id})")
        except AccessDenied:
            _logger.warning(f"Contraseña incorrecta para: {email}")
            return request.render('bloste_web.info_usuario_page_view', {
                'error': 'Contraseña incorrecta. Por favor, verifica tus credenciales.',
                'plan': subscription_plan,
            })
        except Exception as e:
            _logger.error(f"Error al verificar credenciales de {email}: {str(e)}")
            return request.render('bloste_web.info_usuario_page_view', {
                'error': f'Error al procesar la solicitud: {str(e)}',
                'plan': subscription_plan,
            })
        
        # Buscar y asignar suscripción
        if subscription_plan:
            subscription = request.env['bloste.subscription'].sudo().search([('name', '=', subscription_plan)], limit=1)
            if subscription:
                _logger.info(f"Suscripción encontrada: {subscription.name} (ID: {subscription.id})")
                
                # Verificar si el usuario ya tiene esta suscripción activa
                existing_subscription = request.env['bloste.user_subscription'].sudo().search([
                    ('user_id', '=', user.id),
                    ('subscription_id', '=', subscription.id),
                ], limit=1)
                
                if existing_subscription:
                    _logger.info(f"Usuario {user.login} ya tiene la suscripción {subscription.name}")
                else:
                    # Crear registro de suscripción
                    new_subscription = request.env['bloste.user_subscription'].sudo().create({
                        'user_id': user.id,
                        'subscription_id': subscription.id,
                        'start_date': fields.Date.today(),
                    })
                    _logger.info(f"Suscripción creada exitosamente: ID {new_subscription.id} para usuario {user.login}")
            else:
                _logger.warning(f"No se encontró la suscripción: {subscription_plan}")
        else:
            _logger.warning("No se proporcionó nombre de plan de suscripción")
        
        return request.redirect('/subscription-success')
    
