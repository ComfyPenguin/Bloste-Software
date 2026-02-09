FROM odoo:16

USER root

RUN pip install --no-cache-dir \
    PyJWT==2.10.1 \
    authlib>=1.2.0

RUN mkdir -p /etc/odoo/keys && \
    chown odoo:odoo /etc/odoo/keys

COPY generate-jwt-keys.sh /usr/local/bin/generate-jwt-keys.sh
COPY docker-entrypoint-custom.sh /docker-entrypoint-custom.sh

RUN chmod +x /usr/local/bin/generate-jwt-keys.sh && \
    chmod +x /docker-entrypoint-custom.sh

USER odoo

ENTRYPOINT ["/docker-entrypoint-custom.sh"]
CMD ["odoo"]