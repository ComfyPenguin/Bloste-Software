#!/bin/bash



# Arxiu de la clau publica JWT
PUBLIC_KEY_FILE="/etc/odoo/keys/public.pem"

# Genera les claus JWT si no existixen
/usr/local/bin/generate-jwt-keys.sh

# Verificar que la clave publica tenga contenido
if [ ! -s "$PUBLIC_KEY_FILE" ]; then
    echo "Error: La clave publica esta vacia. No se exportara."
    exec "$@"
    exit 0
fi

# Exportar clave publica a multiples carpetas del proyecto
echo "Exportando clave publica a las carpetas keys..."

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
    mkdir -p "$DEST_DIR" 2>/dev/null || true
    # Eliminar el archivo destino si existe y esta vacio
    if [ -f "$DEST" ] && [ ! -s "$DEST" ]; then
        rm -f "$DEST" 2>/dev/null || true
    fi
    # Copiar la clave (ignorar errores de permiso)
    cp "$PUBLIC_KEY_FILE" "$DEST" 2>/dev/null || true
    # Verificar que se copio correctamente
    if [ -s "$DEST" ]; then
        echo "Clave publica copiada a: $DEST"
    else
        echo "Advertencia: No se pudo copiar a $DEST (puede existir ya desde el host)"
    fi
done

echo "La clave en Odoo_mod/keys/public.pem ya esta disponible (volumen montado)"
echo "Proceso de exportacion completado"

# Inicia Odoo amb els parametres que s'han passat al contenidor
exec "$@"


