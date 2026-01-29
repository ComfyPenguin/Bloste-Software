from odoo import models, fields, api

class ResUsers(models.Model):
    _inherit = 'res.users'
    
    # Campos para integración con BlosteFlix
    user_subscription_ids = fields.One2many('bloste.user_subscription', 'user_id', string='Suscripciones')
    bloste_api_uuid = fields.Char(string='UUID de API', readonly=True)
    bloste_status = fields.Selection([
        ('user', 'Usuario Normal'),
        ('admin', 'Administrador')
    ], string='Estado en BlosteFlix', default='user')
    is_admin_bloste = fields.Boolean(string='¿Es Admin en BlosteFlix?', default=False)
    
    # Campos para mostrar la suscripción activa actual
    active_subscription_id = fields.Many2one('bloste.subscription', string='Suscripción Activa', compute='_compute_active_subscription', readonly=True)
    subscription_expiry_date = fields.Date(string='Caducidad de Suscripción', compute='_compute_subscription_expiry', readonly=True)
    
    @api.depends('user_subscription_ids', 'user_subscription_ids.end_date')
    def _compute_active_subscription(self):
        """Obtiene la suscripción activa actual (la que no ha caducado)"""
        today = fields.Date.today()
        for record in self:
            active_sub = None
            for user_sub in record.user_subscription_ids:
                # Buscar la suscripción que aún no ha caducado
                if user_sub.end_date and user_sub.end_date >= today:
                    active_sub = user_sub.subscription_id
                    break
            record.active_subscription_id = active_sub
    
    @api.depends('user_subscription_ids', 'user_subscription_ids.end_date')
    def _compute_subscription_expiry(self):
        """Obtiene la fecha de caducidad de la suscripción activa"""
        today = fields.Date.today()
        for record in self:
            expiry_date = None
            for user_sub in record.user_subscription_ids:
                # Buscar la suscripción que aún no ha caducado
                if user_sub.end_date and user_sub.end_date >= today:
                    expiry_date = user_sub.end_date
                    break
            record.subscription_expiry_date = expiry_date

