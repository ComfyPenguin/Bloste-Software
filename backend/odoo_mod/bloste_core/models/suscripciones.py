from odoo import models, fields, api
from datetime import timedelta

# Model de subscripcions de BlosteFlix
class BlosteSubscription(models.Model):
    _name = 'bloste.subscription'
    _description = 'Subscripcio de BlosteFlix'

    # Camps basics del pla de subscripcio
    name = fields.Char(string='Nom del Pla', required=True)
    price = fields.Float(string='Preu')
    duration = fields.Integer(string='Duracio (Dies)', default=30, required=True)
    
    # Relacio amb els usuaris que tenen este pla
    user_subscription_ids = fields.One2many('bloste.user_subscription', 'subscription_id', string='Usuaris')
    
    # Relacio amb productes i comandes de venda
    product_id = fields.Many2one('product.product', string='Producte de Venda', help='Producte vinculat a esta subscripcio')
    sale_order_id = fields.Many2one('sale.order', string='Orde de Venda')
    partner_id = fields.Many2one('res.partner', string='Client', related='sale_order_id.partner_id', readonly=True)