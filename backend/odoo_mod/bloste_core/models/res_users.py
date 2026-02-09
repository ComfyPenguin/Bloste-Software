from odoo import models, fields, api

class ResUsers(models.Model):
    _inherit = 'res.users'
    
    user_subscription_ids = fields.One2many('bloste.user_subscription', 'user_id', string='Suscripciones')
    bloste_api_uuid = fields.Char(string='UUID de API', readonly=True)
    bloste_status = fields.Selection([
        ('user', 'Usuario Normal'),
        ('admin', 'Administrador')
    ], string='Estado en BlosteFlix', default='user')
    is_admin_bloste = fields.Boolean(string='¿Es Admin en BlosteFlix?', default=False)
    
    active_subscription_id = fields.Many2one('bloste.subscription', string='Suscripción Activa', compute='_compute_active_subscription', store=True)
    subscription_expiry_date = fields.Date(string='Caducidad de Suscripción', compute='_compute_subscription_expiry', store=True, readonly=True)
    
    new_subscription_id = fields.Many2one('bloste.subscription', string='Asignar Suscripción')
    password_display = fields.Char(string='Contraseña', compute='_compute_password_display', readonly=True)

    @api.depends('login')
    def _compute_password_display(self):
        """Muestra un indicador de que el usuario tiene contraseña configurada"""
        for record in self:
            # Si el usuario tiene login configurado, asumimos que tiene contraseña
            if record.login:
                record.password_display = '••••••••'
            else:
                record.password_display = 'No configurada'

    @api.depends('user_subscription_ids.end_date')
    def _compute_subscription_expiry(self):
        """Obtiene la fecha de caducidad de la suscripción activa"""
        today = fields.Date.today()
        for record in self:
            expiry_date = None
            valid_subs = record.user_subscription_ids.filtered(lambda s: s.end_date and s.end_date >= today)
            if valid_subs:
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
                active_sub = sorted(valid_subs, key=lambda s: s.end_date)[0].subscription_id
            record.active_subscription_id = active_sub

    @api.model
    def create(self, vals):
        """Al crear un usuario, si no se proporciona login, usar el email."""
        if 'email' in vals and 'login' not in vals:
            vals['login'] = vals['email']
        return super(ResUsers, self).create(vals)

    def write(self, vals):
        """Si se cambia `new_subscription_id` creamos una nueva entrada en bloste.user_subscription
        con fecha de inicio hoy. Mantener historial de suscripciones.
        Si se cambia a admin de Bloste, asignar grupos de administrador de Odoo."""
        
        # Verificar si se está cambiando el estado a admin
        if 'bloste_status' in vals and vals['bloste_status'] == 'admin':
            vals['is_admin_bloste'] = True
        elif 'is_admin_bloste' in vals and vals['is_admin_bloste']:
            vals['bloste_status'] = 'admin'
        
        res = super(ResUsers, self).write(vals)
        
        # Si se convirtió en admin de Bloste, convertir en admin de Odoo
        if vals.get('bloste_status') == 'admin' or vals.get('is_admin_bloste'):
            for user in self:
                self._make_odoo_admin(user)
        
        # Si se quitó el admin de Bloste, quitar admin de Odoo
        if vals.get('bloste_status') == 'user' or vals.get('is_admin_bloste') == False:
            for user in self:
                self._remove_odoo_admin(user)
        
        if 'new_subscription_id' in vals:
            sub_id = vals.get('new_subscription_id')
            if sub_id:
                today = fields.Date.today()
                for user in self:
                    self.env['bloste.user_subscription'].create({
                        'user_id': user.id,
                        'subscription_id': int(sub_id),
                        'start_date': today,
                    })
                    user.new_subscription_id = False
        return res
    
    def _make_odoo_admin(self, user):
        """Convierte un usuario en administrador de Odoo"""
        # Cambiar de usuario Portal a usuario Interno
        internal_user_group = self.env.ref('base.group_user')
        portal_group = self.env.ref('base.group_portal')
        system_group = self.env.ref('base.group_system')
        
        # Remover grupo portal y agregar grupos necesarios
        user.write({
            'groups_id': [
                (3, portal_group.id),  # Remover portal
                (4, internal_user_group.id),  # Agregar usuario interno
                (4, system_group.id),  # Agregar administrador
            ]
        })
    
    def _remove_odoo_admin(self, user):
        """Quita permisos de administrador y convierte en usuario Portal"""
        internal_user_group = self.env.ref('base.group_user')
        portal_group = self.env.ref('base.group_portal')
        system_group = self.env.ref('base.group_system')
        
        user.write({
            'groups_id': [
                (3, system_group.id),  # Remover administrador
                (3, internal_user_group.id),  # Remover usuario interno
                (4, portal_group.id),  # Agregar portal
            ]
        })

