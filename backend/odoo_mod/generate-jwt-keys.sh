set -e

TEMP_KEYS_DIR="/tmp/odoo-keys"
KEYS_DIR="/etc/odoo/keys"
PRIVATE_KEY="$KEYS_DIR/private.pem"
PUBLIC_KEY="$KEYS_DIR/public.pem"

if [ -f "$PRIVATE_KEY" ] && [ -s "$PRIVATE_KEY" ] && [ -f "$PUBLIC_KEY" ] && [ -s "$PUBLIC_KEY" ]; then
    echo "Las claves JWT ya existen, saltando generaciÃ³n..."
else
    echo "Generando claves JWT RSA 4096..."
    
    mkdir -p "$TEMP_KEYS_DIR"
    
    openssl genrsa -out "$TEMP_KEYS_DIR/private.pem" 4096
    echo "âœ“ Clave privada generada en directorio temporal"

    openssl rsa -in "$TEMP_KEYS_DIR/private.pem" -pubout -out "$TEMP_KEYS_DIR/public.pem"
    echo "âœ“ Clave pÃºblica generada en directorio temporal"
    
    cp "$TEMP_KEYS_DIR/private.pem" "$PRIVATE_KEY"
    cp "$TEMP_KEYS_DIR/public.pem" "$PUBLIC_KEY"
    echo "âœ“ Claves copiadas a $KEYS_DIR"
    
    chmod 600 "$PRIVATE_KEY"
    chmod 644 "$PUBLIC_KEY"
    
    rm -rf "$TEMP_KEYS_DIR"
    
    echo "âœ“ Claves JWT generadas exitosamente"
fi
