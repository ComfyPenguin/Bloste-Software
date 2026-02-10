from odoo import models, fields

class BlosteWeb(models.Model):
    _name = 'bloste.web'
    _description = 'Modelo de Bloste Web'

    name = fields.Char(string='Nombre', required=True)
    description = fields.Text(string='Descripción')