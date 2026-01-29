from odoo import http
from odoo.http import request

class BlosteWebsite(http.Controller):

    @http.route('/my/bloste_data', type='json', auth='user', website=True)
    def get_user_data(self):
        """Este endpoint devuelve los datos del usuario logueado para tu frontend"""
        user = request.env.user
        # Obtener la primera suscripción si existe
        subscription = user.subscription_ids[0] if user.subscription_ids else None
        return {
            'name': user.name,
            'role': user.bloste_status or 'user',
            'uuid': user.bloste_api_uuid or '',
            'subscription': {
                'plan': subscription.name if subscription else 'Ninguno',
                'end_date': str(subscription.end_date) if subscription else None,
                'is_expired': subscription.state == 'expired' if subscription else True,
            }
        }

    @http.route('/bloste/users_admins', type='http', auth='user', website=True)
    def users_admins_view(self):
        """Vista con dos pestañas: Usuarios y Administradores"""
        User = request.env['res.users']
        
        # Obtener todos los usuarios (activos)
        all_users = User.search([('active', '=', True)])
        
        # Obtener solo administradores (usuarios en el grupo admin)
        admin_group = request.env.ref('base.group_system', raise_if_not_found=False)
        admins = all_users.filtered(lambda u: admin_group in u.groups_id) if admin_group else User.search([])
        
        return request.render('bloste_core.users_admins_template', {
            'all_users': all_users,
            'admins': admins,
        })