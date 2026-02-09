from odoo import http, fields
from odoo.http import request
from odoo.exceptions import AccessDenied
import logging

_logger = logging.getLogger(__name__)

# Controlador principal de les pagines web de Bloste
class BlosteWebsite(http.Controller):
    """Controlador base per a l'aplicacio web de Bloste"""

    def _render_website_page_with_plans(self, url):
        """Renderitza una pagina creada en Website Builder passant plans"""
        # Busca tots els plans de subscripcio disponibles
        subscriptions = request.env['bloste.subscription'].sudo().search([])
        # Busca la pagina web per URL
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
        """Pagina de login/registre"""
        return request.render('bloste_web.login_register_template')

    @http.route('/suscripciones', type='http', auth='public', website=True)
    def subscription_plans(self):
        """Pagina publica de plans de subscripcio"""
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
        """Pagina d'informacio de l'usuari amb pla preseleccionat"""
        # Busca la pagina a la BD
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
        """Processa l'enviament del formulari: autentica usuari i assigna subscripcio"""
        email = post.get('email')
        password = post.get('password')
        subscription_plan = post.get('subscription_plan')
        
        _logger.info(f"Intent de contractacio - Email: {email}, Pla: {subscription_plan}")
        
        # Comprova que tinga email i contrasenya
        if not email or not password:
            _logger.warning("Falta email o contrasenya")
            return request.render('bloste_web.info_usuario_page_view', {
                'error': 'Por favor, ingresa tu email y contraseña',
                'plan': subscription_plan,
            })
        
        # Busca l'usuari a la BD per email
        user = request.env['res.users'].sudo().search([('login', '=', email)], limit=1)
        
        if not user:
            _logger.warning(f"Usuari no trobat: {email}")
            return request.render('bloste_web.info_usuario_page_view', {
                'error': f'No existe ningún usuario con el email {email}. Por favor, regístrate primero.',
                'plan': subscription_plan,
            })
        
        # Comprova que la contrasenya siga correcta
        try:
            user.sudo()._check_credentials(password, request.env)
            _logger.info(f"Credencials verificades correctament per a: {email} (ID: {user.id})")
        except AccessDenied:
            _logger.warning(f"Contrasenya incorrecta per a: {email}")
            return request.render('bloste_web.info_usuario_page_view', {
                'error': 'Contraseña incorrecta. Por favor, verifica tus credenciales.',
                'plan': subscription_plan,
            })
        except Exception as e:
            _logger.error(f"Error al verificar credencials de {email}: {str(e)}")
            return request.render('bloste_web.info_usuario_page_view', {
                'error': f'Error al procesar la solicitud: {str(e)}',
                'plan': subscription_plan,
            })
        
        # Si hi ha un pla de subscripcio, l'assigna a l'usuari
        # Si hi ha un pla de subscripcio, l'assigna a l'usuari
        if subscription_plan:
            # Busca el pla de subscripcio a la BD
            subscription = request.env['bloste.subscription'].sudo().search([('name', '=', subscription_plan)], limit=1)
            if subscription:
                _logger.info(f"Subscripcio trobada: {subscription.name} (ID: {subscription.id})")
                
                # Comprova si l'usuari ja te este pla
                existing_subscription = request.env['bloste.user_subscription'].sudo().search([
                    ('user_id', '=', user.id),
                    ('subscription_id', '=', subscription.id),
                ], limit=1)
                
                if existing_subscription:
                    _logger.info(f"L'usuari {user.login} ja te la subscripcio {subscription.name}")
                else:
                    # Crea la subscripcio nova per a l'usuari
                    new_subscription = request.env['bloste.user_subscription'].sudo().create({
                        'user_id': user.id,
                        'subscription_id': subscription.id,
                        'start_date': fields.Date.today(),
                    })
                    _logger.info(f"Subscripcio creada correctament: ID {new_subscription.id} per a usuari {user.login}")
            else:
                _logger.warning(f"No s'ha trobat la subscripcio: {subscription_plan}")
        else:
            _logger.warning("No s'ha proporcionat nom de pla de subscripcio")
        
        # Redirigix a la pagina d'exit
        return request.redirect('/subscription-success')
    
