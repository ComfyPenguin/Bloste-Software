# Imagen base de Odoo 16
FROM odoo:16

USER root

# Solo instalar/actualizar lo que necesitas añadir
RUN pip install --no-cache-dir \
    PyJWT==2.10.1 \
    authlib>=1.2.0

USER odoo