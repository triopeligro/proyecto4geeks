
#!/usr/bin/env bash

set -euo pipefail

echo "=================================="
echo " Actualizando dependencias Python"
echo "=================================="

# Comprobar entorno virtual
if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    echo "ERROR: Activa primero el entorno virtual."
    exit 1
fi

# Comprobar pip-tools
if ! command -v pip-compile >/dev/null 2>&1; then
    echo "ERROR: pip-tools no está instalado."
    exit 1
fi

# Crear copias de seguridad
timestamp=$(date +%Y%m%d_%H%M%S)

if [[ -f requirements.txt ]]; then
    cp requirements.txt "requirements.txt.backup_$timestamp"
fi

# Actualizar requirements.txt desde pyproject.toml
echo "Resolviendo dependencias..."

pip-compile \
    --upgrade \
    pyproject.toml \
    --output-file requirements.txt

echo "Instalando dependencias..."

python -m pip install -r requirements.txt

echo "=================================="
echo " Actualización completada"
echo "=================================="
