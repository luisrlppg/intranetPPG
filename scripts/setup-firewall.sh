#!/bin/bash

echo "🔥 Configurando firewall para Intranet PPG"

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() {
    echo -e "${YELLOW}ℹ️${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

# Detectar sistema operativo
if command -v netsh &> /dev/null; then
    print_info "Sistema Windows detectado"
    echo "Configurando Windows Firewall..."
    
    # Verificar si se ejecuta como administrador
    net session >nul 2>&1
    if [ $? -eq 0 ]; then
        print_info "Agregando reglas de firewall..."
        netsh advfirewall firewall add rule name="Intranet PPG HTTP" dir=in action=allow protocol=TCP localport=80
        netsh advfirewall firewall add rule name="Intranet PPG HTTP Alt" dir=in action=allow protocol=TCP localport=8080
        print_success "Reglas de firewall agregadas exitosamente"
    else
        print_error "Este script debe ejecutarse como Administrador en Windows"
        echo ""
        echo "Ejecuta manualmente como Administrador:"
        echo "netsh advfirewall firewall add rule name=\"Intranet PPG HTTP\" dir=in action=allow protocol=TCP localport=80"
        echo "netsh advfirewall firewall add rule name=\"Intranet PPG HTTP Alt\" dir=in action=allow protocol=TCP localport=8080"
        exit 1
    fi

elif command -v ufw &> /dev/null; then
    print_info "Sistema Linux con UFW detectado"
    echo "Configurando UFW..."
    
    sudo ufw allow 80/tcp comment "Intranet PPG HTTP"
    sudo ufw allow 8080/tcp comment "Intranet PPG HTTP Alt"
    print_success "Reglas UFW agregadas exitosamente"

elif command -v firewall-cmd &> /dev/null; then
    print_info "Sistema Linux con firewalld detectado"
    echo "Configurando firewalld..."
    
    sudo firewall-cmd --permanent --add-port=80/tcp
    sudo firewall-cmd --permanent --add-port=8080/tcp
    sudo firewall-cmd --reload
    print_success "Reglas firewalld agregadas exitosamente"

else
    print_error "No se pudo detectar el sistema de firewall"
    echo ""
    echo "Configura manualmente el firewall para permitir:"
    echo "- Puerto 80/TCP (HTTP)"
    echo "- Puerto 8080/TCP (HTTP alternativo)"
fi

echo ""
print_info "Verificando configuración..."
./scripts/check-network-access.sh