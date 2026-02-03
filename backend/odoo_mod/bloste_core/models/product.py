from odoo import models, fields

class ProductTemplate(models.Model):
    _inherit = 'product.template'
    
    is_subscription_product = fields.Boolean(
        string='Es un Plan de Suscripción',
        help='Marcar si este producto es un plan de suscripción'
    )
