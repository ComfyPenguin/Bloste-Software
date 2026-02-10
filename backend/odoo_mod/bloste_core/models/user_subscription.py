from odoo import models, fields, api
from datetime import timedelta

# Model que relaciona usuaris amb les seues subscripcions
class UserSubscription(models.Model):
    _name = 'bloste.user_subscription'
    _description = 'Subscripcio d\'Usuari'
    _rec_name = 'subscription_id'

    # Camps de la relacio usuari-subscripcio
    user_id = fields.Many2one('res.users', string='Usuari', required=True, ondelete='cascade')
    subscription_id = fields.Many2one('bloste.subscription', string='Pla de Subscripcio', required=True, ondelete='cascade')
    start_date = fields.Date(string='Data d\'Inici', default=fields.Date.today, readonly=True)
    end_date = fields.Date(string='Data de Caducitat', compute='_compute_end_date', readonly=True, store=True)
    
    @api.depends('start_date', 'subscription_id.duration')
    def _compute_end_date(self):
        """Calcula la data de caducitat com start_date + duracio de la subscripcio"""
        for record in self:
            if record.start_date and record.subscription_id:
                # Suma els dies de duracio del pla a la data d'inici
                record.end_date = record.start_date + timedelta(days=record.subscription_id.duration)
            else:
                record.end_date = None
