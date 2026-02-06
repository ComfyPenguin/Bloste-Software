# Imagen base de Odoo 16
FROM odoo:16

USER root

# Instalar dependencias Python
RUN pip install --no-cache-dir \
    PyJWT==2.10.1 \
    authlib>=1.2.0

# Crear directorio para las claves
RUN mkdir -p /etc/odoo/keys && \
    chown odoo:odoo /etc/odoo/keys

# Copiar scripts de generación de claves y entrypoint
COPY generate-jwt-keys.sh /usr/local/bin/generate-jwt-keys.sh
COPY docker-entrypoint-custom.sh /docker-entrypoint-custom.sh

# Dar permisos de ejecución a los scripts
RUN chmod +x /usr/local/bin/generate-jwt-keys.sh && \
    chmod +x /docker-entrypoint-custom.sh

USER odoo

# Usar el entrypoint personalizado
ENTRYPOINT ["/docker-entrypoint-custom.sh"]
CMD ["odoo"]