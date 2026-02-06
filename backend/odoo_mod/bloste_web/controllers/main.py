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
        """Procesar envío del formulario de información del usuario"""
        # Buscar o crear partner
        partner_vals = {
            'name': post.get('name'),
            'email': post.get('email'),
            'phone': post.get('phone'),
            'vat': post.get('vat'),
        }
        
        partner = request.env['res.partner'].sudo().search([('email', '=', post.get('email'))], limit=1)
        if partner:
            partner.write(partner_vals)
        else:
            partner = request.env['res.partner'].sudo().create(partner_vals)
        
        # Buscar suscripción por nombre
        subscription_plan = post.get('subscription_plan')
        if subscription_plan:
            subscription = request.env['bloste.subscription'].sudo().search([('name', '=', subscription_plan)], limit=1)
            if subscription:
                # Crear registro de suscripción
                request.env['bloste.user_subscription'].sudo().create({
                    'subscription_id': subscription.id,
                    'start_date': request.env['ir.fields'].Date.today(),
                })
        
        return request.redirect('/subscription-success')
    
