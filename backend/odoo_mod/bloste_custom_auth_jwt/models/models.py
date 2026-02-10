from odoo import models, fields, api

# Este modelo representa los tokens de refresco para la autenticación JWT
class RefreshToken(models.Model):
    _name = 'auth.refresh.token'
    _description = 'Refresh Token'

    user_id = fields.Many2one('res.users', string='User', required=True, ondelete='cascade')
    token_hash = fields.Char(string='Token Hash', required=True, copy=False, index=True, readonly=True)
    expiration_date = fields.Datetime(string='Expiration Date', required=True)
    is_revoked = fields.Boolean(string='Is Revoked', default=False)
    issued_at = fields.Datetime(string='Issued At', required=True, default=fields.Datetime.now)

    _sql_constraints = [
        ('token_hash_unique', 'unique(token_hash)', 'The token hash must be unique!'),
    ]

    def name_get(self):
        result = []
        for token in self:
            name = f"Refresh Token for {token.user_id.login} (Issued: {token.issued_at.strftime('%Y-%m-%d %H:%M')})"
            result.append((token.id, name))
        return result
