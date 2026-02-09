set -e

# Arxiu de la clau publica JWT
PUBLIC_KEY_FILE="/etc/odoo/keys/public.pem"

# Genera les claus JWT si no existixen
/usr/local/bin/generate-jwt-keys.sh

# Comprova que la clau no estiga buida
if [ ! -s "$PUBLIC_KEY_FILE" ]; then
    echo "Error: La clau publica esta buida. No s'exportara."
    exec "$@"
    exit 0
fi

echo "Exportant clau publica a les carpetes keys..."

# Llista de destins on copiar la clau publica
DESTINATIONS=(
    "/workspace/backend/media_server/src/keys/public.pem"
    "/workspace/backend/catalogo/src/main/resources/keys/public.pem"
    "/workspace/frontend/admin/src/keys/public.pem"
    "/workspace/frontend/blosteflix2/keys/public.pem"
)

# Copia la clau a tots els projectes
for DEST in "${DESTINATIONS[@]}"; do
    DEST_DIR=$(dirname "$DEST")
    mkdir -p "$DEST_DIR"
    # Si el fitxer existix pero esta buit, l'esborra
    if [ -f "$DEST" ] && [ ! -s "$DEST" ]; then
        rm -f "$DEST"
    fi
    cp "$PUBLIC_KEY_FILE" "$DEST"
    if [ -s "$DEST" ]; then
        echo "OK: Clau publica copiada a: $DEST"
    else
        echo "ERROR: No s'ha pogut copiar a: $DEST"
    fi
done

echo "OK: La clau en Odoo_mod/keys/public.pem ja esta disponible (volum muntat)"
echo "OK: Proces d'exportacio completat"

# Inicia Odoo amb els parametres que s'han passat al contenidor
exec "$@"


