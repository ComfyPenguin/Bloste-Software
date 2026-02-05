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

    @http.route('/suscripciones', type='http', auth='public', website=True)
    def subscription_plans(self):
        """Página pública de planes de suscripción"""
        subscriptions = request.env['bloste.subscription'].sudo().search([])
        page = request.env['website.page'].sudo().search([('url', '=', '/suscripciones')], limit=1)
        
        if page and page.view_id:
            return request.render(page.view_id.id, {
                'subscriptions': subscriptions,
            })
        
        # Fallback al template si la página no existe
        return request.render('bloste_web.suscripciones_page_view', {
            'subscriptions': subscriptions,
        })

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
        """Página de información de usuario con plan seleccionado"""
        page = request.env['website.page'].sudo().search([('url', '=', '/info-usuario')], limit=1)
        
        values = {
            'plan': plan or '',
        }
        
        if page and page.view_id:
            return request.render(page.view_id.id, values)
        
        return request.render('bloste_web.info_usuario_page_view', values)
    
    @http.route('/info-usuario/submit', type='http', auth='public', website=True, methods=['POST'], csrf=False)
    def info_usuario_submit(self, plan=None, name=None, email=None, phone=None, address=None, **kwargs):
        """Procesar el formulario de información de usuario y crear suscripción"""
        
        # Buscar o crear el socio (partner)
        Partner = request.env['res.partner'].sudo()
        partner = Partner.search([('email', '=', email)], limit=1)
        
        if not partner:
            partner = Partner.create({
                'name': name,
                'email': email,
                'phone': phone,
                'street': address,
            })
        else:
            # Actualizar información si ya existe
            partner.write({
                'name': name,
                'phone': phone,
                'street': address,
            })
        
        # Buscar el plan de suscripción por nombre
        Subscription = request.env['bloste.subscription'].sudo()
        subscription_plan = Subscription.search([('name', '=', plan)], limit=1)
        
        if subscription_plan:
            # Crear la suscripción de usuario
            UserSubscription = request.env['bloste.user_subscription'].sudo()
            
            # Verificar si ya existe una suscripción activa para este usuario y plan
            existing = UserSubscription.search([
                ('user_id', '=', partner.id),
                ('subscription_id', '=', subscription_plan.id),
                ('state', 'in', ['active', 'pending'])
            ], limit=1)
            
            if not existing:
                user_subscription = UserSubscription.create({
                    'user_id': partner.id,
                    'subscription_id': subscription_plan.id,
                    'state': 'pending',  # Estado pendiente hasta que se confirme el pago
                })
                
                # Redirigir a página de agradecimiento
                return request.redirect('/subscription-success')
            else:
                # Ya tiene una suscripción activa
                return request.render('bloste_web.subscription_exists', {
                    'partner': partner,
                    'subscription': subscription_plan,
                })
        
        # Si no se encuentra el plan, redirigir a suscripciones
        return request.redirect('/suscripciones')
    
