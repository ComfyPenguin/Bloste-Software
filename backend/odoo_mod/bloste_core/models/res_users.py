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
    plain_password = fields.Char(string='Contraseña', help='Contraseña en texto plano')
    
    # Campos para mostrar la suscripción activa actual
    active_subscription_id = fields.Many2one('bloste.subscription', string='Suscripción Activa', compute='_compute_active_subscription', store=True, readonly=True)
    subscription_expiry_date = fields.Date(string='Caducidad de Suscripción', compute='_compute_subscription_expiry', store=True, readonly=True)
    
    # Campo auxiliar para asignar nueva suscripción desde formulario
    new_subscription_id = fields.Many2one('bloste.subscription', string='Asignar Suscripción')
    active_subscription_id = fields.Many2one('bloste.subscription', string='Suscripción Activa', compute='_compute_active_subscription', store=True)
    subscription_expiry_date = fields.Date(string='Caducidad de Suscripción', compute='_compute_subscription_expiry', store=True, readonly=True)
    
    # Campo auxiliar para asignar nueva suscripción desde formulario
    new_subscription_id = fields.Many2one('bloste.subscription', string='Asignar Suscripción')

    @api.depends('user_subscription_ids.end_date')
    def _compute_subscription_expiry(self):
        """Obtiene la fecha de caducidad de la suscripción activa"""
        today = fields.Date.today()
        for record in self:
            expiry_date = None
            # Buscar la suscripción que aún no ha caducado y devolver la más próxima
            valid_subs = record.user_subscription_ids.filtered(lambda s: s.end_date and s.end_date >= today)
            if valid_subs:
                # ordenar por end_date ascendente y tomar la primera
                expiry_date = sorted(valid_subs, key=lambda s: s.end_date)[0].end_date
            record.subscription_expiry_date = expiry_date

    @api.depends('user_subscription_ids.end_date')
    def _compute_active_subscription(self):
        """Establece `active_subscription_id` como la suscripción con fecha de caducidad más próxima (no caducada)."""
        today = fields.Date.today()
        for record in self:
            active_sub = None
            valid_subs = record.user_subscription_ids.filtered(lambda s: s.end_date and s.end_date >= today)
            if valid_subs:
                # escoger la suscripción con la fecha de caducidad más cercana
                active_sub = sorted(valid_subs, key=lambda s: s.end_date)[0].subscription_id
            record.active_subscription_id = active_sub

    def write(self, vals):
        """Si se cambia `new_subscription_id` creamos una nueva entrada en bloste.user_subscription
        con fecha de inicio hoy. Mantener historial de suscripciones.
        Si se cambia `password`, guardamos también en plain_password."""
        # Sincronizar password con plain_password
        if 'password' in vals:
            vals['plain_password'] = vals['password']
        
        res = super(ResUsers, self).write(vals)
        
        if 'new_subscription_id' in vals:
            sub_id = vals.get('new_subscription_id')
            if sub_id:
                today = fields.Date.today()
                for user in self:
                    # crear nueva suscripción de usuario
                    self.env['bloste.user_subscription'].create({
                        'user_id': user.id,
                        'subscription_id': int(sub_id),
                        'start_date': today,
                    })
                    # Limpiar el campo auxiliar
                    user.new_subscription_id = False
        return res

