from odoo import http
from odoo.http import request


class BlosteWebsite(http.Controller):
    """Controller base para la aplicación web de Bloste"""

    @http.route('/in', type='http', auth='public', website=True)
    def login_register(self):
        """Página de login/registro"""
        return request.render('bloste_web.login_register_template')

    @http.route('/s', type='http', auth='public', website=True)
    def subscriptions(self):
        records = request.env['bloste.web'].search([])
    
        return request.render('bloste_web.subscriptions_template', {
        'subscriptions': records,
    })
