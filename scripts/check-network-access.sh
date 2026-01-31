#!/bin/bash

echo "🌐 Verificando acceso de red para Intranet PPG"

# Cambiar al directorio raíz del proyecto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

# Obtener IP local
LOCAL_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || ip route get 1 | awk '{print $7}' 2>/dev/null || echo "IP-NO-DETECTADA")

print_info "Información de red:"
echo "   IP Local detectada: $LOCAL_IP"
echo "   Hostname: $(hostname)"
echo ""

# Verificar si el contenedor está corriendo
print_info "Verificando contenedor Docker..."
if docker ps | grep -q "intranet-ppg"; then
    print_success "Contenedor intranet-ppg está corriendo"
    
    # Mostrar puertos
    echo "   Puertos expuestos:"
    docker port intranet-ppg 2>/dev/null | while read line; do
        echo "     $line"
    done
else
    print_error "Contenedor intranet-ppg NO está corriendo"
    echo "   Ejecuta: ./scripts/deploy-direct.sh"
    exit 1
fi

echo ""

# Verificar puertos locales
print_info "Verificando puertos locales..."
if netstat -tuln 2>/dev/null | grep -q ":80 " || ss -tuln 2>/dev/null | grep -q ":80 "; then
    print_success "Puerto 80 está escuchando"
else
    print_warning "Puerto 80 podría no estar escuchando correctamente"
fi

if netstat -tuln 2>/dev/null | grep -q ":8080 " || ss -tuln 2>/dev/null | grep -q ":8080 "; then
    print_success "Puerto 8080 está escuchando"
else
    print_warning "Puerto 8080 podría no estar escuchando correctamente"
fi

echo ""

# Verificar acceso local
print_info "Verificando acceso local..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost 2>/dev/null | grep -q "200"; then
    print_success "Acceso local funciona: http://localhost"
else
    print_warning "Acceso local podría tener problemas"
fi

if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 2>/dev/null | grep -q "200"; then
    print_success "Acceso local funciona: http://localhost:8080"
else
    print_warning "Acceso local en puerto 8080 podría tener problemas"
fi

echo ""

# Mostrar URLs de acceso
print_info "URLs de acceso desde otras PCs:"
echo "   http://$LOCAL_IP"
echo "   http://$LOCAL_IP:8080"
echo ""

# Verificar firewall (Windows)
print_info "Verificando configuración de firewall..."
if command -v netsh &> /dev/null; then
    echo "   Sistema Windows detectado"
    echo "   Si no puedes acceder desde otras PCs, ejecuta como administrador:"
    echo "   netsh advfirewall firewall add rule name=\"Intranet PPG\" dir=in action=allow protocol=TCP localport=80"
    echo "   netsh advfirewall firewall add rule name=\"Intranet PPG Alt\" dir=in action=allow protocol=TCP localport=8080"
elif command -v ufw &> /dev/null; then
    echo "   Sistema Linux con UFW detectado"
    echo "   Si no puedes acceder desde otras PCs, ejecuta:"
    echo "   sudo ufw allow 80"
    echo "   sudo ufw allow 8080"
elif command -v firewall-cmd &> /dev/null; then
    echo "   Sistema Linux con firewalld detectado"
    echo "   Si no puedes acceder desde otras PCs, ejecuta:"
    echo "   sudo firewall-cmd --permanent --add-port=80/tcp"
    echo "   sudo firewall-cmd --permanent --add-port=8080/tcp"
    echo "   sudo firewall-cmd --reload"
else
    print_warning "No se pudo detectar el tipo de firewall"
fi

echo ""

# Comandos de diagnóstico adicionales
print_info "Comandos de diagnóstico adicionales:"
echo "   Ver logs del contenedor: docker logs intranet-ppg"
echo "   Ver procesos de red: netstat -tuln | grep -E ':(80|8080) '"
echo "   Probar desde otra PC: curl -I http://$LOCAL_IP"
echo ""

print_info "Si aún no puedes acceder desde otras PCs:"
echo "   1. Verifica que el firewall permita los puertos 80 y 8080"
echo "   2. Asegúrate de que otras PCs estén en la misma red"
echo "   3. Prueba con la IP específica: http://$LOCAL_IP"
echo "   4. Verifica que no haya otro servicio usando el puerto 80"