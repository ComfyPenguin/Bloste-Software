from odoo import models, fields, api
from datetime import timedelta

class BlosteSubscription(models.Model):
    _name = 'bloste.subscription'
    _description = 'Suscripción de BlosteFlix'

    name = fields.Char(string='Nombre del Plan', required=True)
    price = fields.Float(string='Precio')
    duration = fields.Integer(string='Duración (Días)', default=30, required=True)
    user_subscription_ids = fields.One2many('bloste.user_subscription', 'subscription_id', string='Usuarios')
    
    product_id = fields.Many2one('product.product', string='Producto de Venta', help='Producto vinculado a esta suscripción')
    sale_order_id = fields.Many2one('sale.order', string='Orden de Venta')
    partner_id = fields.Many2one('res.partner', string='Cliente', related='sale_order_id.partner_id', readonly=True)