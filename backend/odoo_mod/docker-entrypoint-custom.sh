#!/bin/bash
set -e

PUBLIC_KEY_FILE="/etc/odoo/keys/public.pem"

# Generar claves si no existen
/usr/local/bin/generate-jwt-keys.sh

# Verificar que la clave pública tenga contenido
if [ ! -s "$PUBLIC_KEY_FILE" ]; then
    echo "⚠ Error: La clave pública está vacía. No se exportará."
    exec "$@"
    exit 0
fi

# Exportar clave pública a múltiples carpetas del proyecto
echo "Exportando clave pública a las carpetas keys..."

# Lista de destinos (excluye Odoo_mod/keys porque el volumen ya mapea /etc/odoo/keys)
DESTINATIONS=(
    "/workspace/backend/media_server/src/keys/public.pem"
    "/workspace/backend/catalogo/src/main/resources/keys/public.pem"
    "/workspace/frontend/admin/src/keys/public.pem"
    "/workspace/frontend/blosteflix2/keys/public.pem"
)

# Crear directorios si no existen y copiar la clave pública
for DEST in "${DESTINATIONS[@]}"; do
    DEST_DIR=$(dirname "$DEST")
    mkdir -p "$DEST_DIR"
    # Eliminar el archivo destino si existe y está vacío
    if [ -f "$DEST" ] && [ ! -s "$DEST" ]; then
        rm -f "$DEST"
    fi
    # Copiar la clave
    cp "$PUBLIC_KEY_FILE" "$DEST"
    # Verificar que se copió correctamente
    if [ -s "$DEST" ]; then
        echo "✓ Clave pública copiada a: $DEST"
    else
        echo "✗ Error al copiar a: $DEST"
    fi
done

echo "✓ La clave en Odoo_mod/keys/public.pem ya está disponible (volumen montado)"
echo "✓ Proceso de exportación completado"

# Ejecutar el comando original de Odoo
exec "$@"


