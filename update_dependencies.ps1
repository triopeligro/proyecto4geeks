
$ErrorActionPreference = "Stop"

Write-Host "==================================" -ForegroundColor Cyan
Write-Host " Actualizando dependencias Python" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Comprobar entorno virtual
if (-not $env:VIRTUAL_ENV) {
    Write-Host "ERROR: Activa primero el entorno virtual." -ForegroundColor Red
    exit 1
}

# Comprobar pyproject.toml
if (-not (Test-Path "pyproject.toml")) {
    Write-Host "ERROR: No se encuentra pyproject.toml." -ForegroundColor Red
    exit 1
}

# Comprobar pip-tools
python -m pip show pip-tools *> $null

if ($LASTEXITCODE -ne 0) {
    Write-Host "Instalando pip-tools..." -ForegroundColor Yellow
    python -m pip install pip-tools
}

# Crear copia de seguridad
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

if (Test-Path "requirements.txt") {
    Copy-Item "requirements.txt" "requirements.txt.backup_$timestamp"
    Write-Host "Copia de seguridad creada." -ForegroundColor Green
}

# Actualizar requirements.txt
Write-Host "Resolviendo dependencias..." -ForegroundColor Yellow

python -m piptools compile --upgrade pyproject.toml -o requirements.txt

if ($LASTEXITCODE -ne 0) {
    throw "Error actualizando requirements.txt"
}

# Instalar dependencias
Write-Host "Instalando dependencias..." -ForegroundColor Yellow

python -m pip install -r requirements.txt

if ($LASTEXITCODE -ne 0) {
    throw "Error instalando dependencias"
}

# Comprobar dependencias
Write-Host "Comprobando dependencias..." -ForegroundColor Yellow

python -m pip check

if ($LASTEXITCODE -ne 0) {
    throw "Se han detectado conflictos entre dependencias"
}

Write-Host "==================================" -ForegroundColor Green
Write-Host " Actualización completada" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green
