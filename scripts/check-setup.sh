#!/bin/bash

echo "🔍 Verificando configuración de Docker para Intranet PPG"

# Cambiar al directorio raíz del proyecto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_check() {
    if [ $2 -eq 0 ]; then
        echo -e "${GREEN}✅${NC} $1"
    else
        echo -e "${RED}❌${NC} $1"
    fi
}

print_info() {
    echo -e "${YELLOW}ℹ️${NC} $1"
}

echo "📁 Directorio actual: $(pwd)"
echo ""

# Verificar archivos necesarios
print_info "Verificando archivos necesarios..."
[ -f "Dockerfile" ] && print_check "Dockerfile encontrado" 0 || print_check "Dockerfile NO encontrado" 1
[ -f "docker-compose.yml" ] && print_check "docker-compose.yml encontrado" 0 || print_check "docker-compose.yml NO encontrado" 1
[ -f "docker-compose.simple.yml" ] && print_check "docker-compose.simple.yml encontrado" 0 || print_check "docker-compose.simple.yml NO encontrado" 1
[ -d "docker" ] && print_check "Directorio docker/ encontrado" 0 || print_check "Directorio docker/ NO encontrado" 1
[ -f "docker/nginx.conf" ] && print_check "docker/nginx.conf encontrado" 0 || print_check "docker/nginx.conf NO encontrado" 1
[ -f "docker/entrypoint.sh" ] && print_check "docker/entrypoint.sh encontrado" 0 || print_check "docker/entrypoint.sh NO encontrado" 1

echo ""

# Verificar Docker
print_info "Verificando Docker..."
if command -v docker &> /dev/null; then
    print_check "Docker instalado" 0
    echo "   Versión: $(docker --version)"
else
    print_check "Docker NO instalado" 1
fi

# Verificar Docker Compose
print_info "Verificando Docker Compose..."
if command -v "docker compose" &> /dev/null; then
    print_check "docker compose disponible" 0
    echo "   Versión: $(docker compose version)"
elif command -v docker-compose &> /dev/null; then
    print_check "docker-compose disponible" 0
    echo "   Versión: $(docker-compose --version)"
else
    print_check "Docker Compose NO disponible" 1
fi

echo ""

# Verificar conectividad a servicios PPG
print_info "Verificando conectividad a servicios PPG..."
services=(
    "192.168.1.160:8000"
    "192.168.1.160:8001"
    "192.168.1.160:5000"
    "192.168.1.160:50000"
    "192.168.1.160:8070"
)

for service in "${services[@]}"; do
    if timeout 3 bash -c "</dev/tcp/${service/:/ }" 2>/dev/null; then
        print_check "$service accesible" 0
    else
        print_check "$service NO accesible" 1
    fi
done

echo ""

# Verificar NAS
print_info "Verificando acceso al NAS..."
if ping -c 1 192.168.1.178 &> /dev/null; then
    print_check "NAS (192.168.1.178) accesible" 0
else
    print_check "NAS (192.168.1.178) NO accesible" 1
fi

echo ""
echo "🚀 Para desplegar, usa uno de estos comandos:"
echo "   ./scripts/deploy-direct.sh    (recomendado)"
echo "   ./scripts/deploy-simple.sh"
echo "   docker compose -f docker-compose.simple.yml up -d --build"