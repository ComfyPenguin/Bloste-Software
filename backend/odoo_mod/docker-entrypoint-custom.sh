set -e

PUBLIC_KEY_FILE="/etc/odoo/keys/public.pem"

/usr/local/bin/generate-jwt-keys.sh

if [ ! -s "$PUBLIC_KEY_FILE" ]; then
    echo "âš  Error: La clave pÃºblica estÃ¡ vacÃ­a. No se exportarÃ¡."
    exec "$@"
    exit 0
fi

echo "Exportando clave pÃºblica a las carpetas keys..."

DESTINATIONS=(
    "/workspace/backend/media_server/src/keys/public.pem"
    "/workspace/backend/catalogo/src/main/resources/keys/public.pem"
    "/workspace/frontend/admin/src/keys/public.pem"
    "/workspace/frontend/blosteflix2/keys/public.pem"
)

for DEST in "${DESTINATIONS[@]}"; do
    DEST_DIR=$(dirname "$DEST")
    mkdir -p "$DEST_DIR"
    if [ -f "$DEST" ] && [ ! -s "$DEST" ]; then
        rm -f "$DEST"
    fi
    cp "$PUBLIC_KEY_FILE" "$DEST"
    if [ -s "$DEST" ]; then
        echo "âœ“ Clave pÃºblica copiada a: $DEST"
    else
        echo "âœ— Error al copiar a: $DEST"
    fi
done

echo "âœ“ La clave en Odoo_mod/keys/public.pem ya estÃ¡ disponible (volumen montado)"
echo "âœ“ Proceso de exportaciÃ³n completado"

exec "$@"


