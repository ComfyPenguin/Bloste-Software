from odoo import models, fields, api
from datetime import timedelta

class UserSubscription(models.Model):
    _name = 'bloste.user_subscription'
    _description = 'Suscripción de Usuario'
    _rec_name = 'subscription_id'

    user_id = fields.Many2one('res.users', string='Usuario', required=True, ondelete='cascade')
    subscription_id = fields.Many2one('bloste.subscription', string='Plan de Suscripción', required=True, ondelete='cascade')
    start_date = fields.Date(string='Fecha de Inicio', default=fields.Date.today, readonly=True)
    end_date = fields.Date(string='Fecha de Caducidad', compute='_compute_end_date', readonly=True, store=True)
    
    @api.depends('start_date', 'subscription_id.duration')
    def _compute_end_date(self):
        """Calcula la fecha de caducidad como start_date + duration de la suscripción"""
        for record in self:
            if record.start_date and record.subscription_id:
                record.end_date = record.start_date + timedelta(days=record.subscription_id.duration)
            else:
                record.end_date = None
