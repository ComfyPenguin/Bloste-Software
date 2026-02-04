from odoo import http
from odoo.http import request

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
    
