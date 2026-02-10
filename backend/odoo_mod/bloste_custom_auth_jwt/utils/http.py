import json

from odoo.http import Response, request

from ..constants import Configuration

def json_response(data, status=200, headers=None):
    """Devuelve una respuesta HTTP JSON estándar."""
    return Response(
        json.dumps(data),
        status=status,
        headers=headers or [],
        mimetype="application/json"
    )

def get_json_body():
    """Parsea el body JSON de la request HTTP.Devuelve dict o None si es inválido."""
    try:
        return json.loads(request.httprequest.data.decode(Configuration.DECODE))
    except Exception:
        return None