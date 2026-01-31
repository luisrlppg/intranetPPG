#!/bin/bash

echo "🔄 Reiniciando contenedor Intranet PPG"

# Cambiar al directorio raíz del proyecto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Detener y eliminar contenedor actual
if docker ps -a | grep -q "intranet-ppg"; then
    print_warning "Deteniendo contenedor actual..."
    docker stop intranet-ppg 2>/dev/null || true
    docker rm intranet-ppg 2>/dev/null || true
fi

# Limpiar logs anteriores
print_status "Limpiando logs..."
rm -rf logs/*

# Reiniciar con configuración corregida
print_status "Iniciando contenedor con configuración corregida..."
docker run -d \
    --name intranet-ppg \
    --privileged \
    -p 0.0.0.0:80:80 \
    -p 0.0.0.0:8080:80 \
    -v "$(pwd)/logs:/var/log/nginx" \
    -v "$(pwd)/docker/nginx.conf:/etc/nginx/nginx.conf:ro" \
    -e TZ=America/Mexico_City \
    --restart unless-stopped \
    intranet-ppg

if [ $? -eq 0 ]; then
    print_status "✅ Contenedor reiniciado exitosamente"
    
    # Esperar un momento
    sleep 5
    
    # Verificar estado
    if docker ps | grep -q "intranet-ppg"; then
        print_status "🌐 Verificando acceso..."
        
        # Obtener IP local
        LOCAL_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "192.168.1.160")
        
        echo ""
        echo "URLs de acceso:"
        echo "   - http://localhost"
        echo "   - http://localhost:8080"
        echo "   - http://$LOCAL_IP"
        echo "   - http://$LOCAL_IP:8080"
        echo ""
        
        # Probar acceso local
        sleep 3
        if curl -s -o /dev/null -w "%{http_code}" http://localhost 2>/dev/null | grep -q "200"; then
            print_status "✅ Acceso local funcionando"
        else
            print_warning "⚠️  Verificando logs..."
            echo "Últimas líneas del log:"
            docker logs --tail 10 intranet-ppg
        fi
    fi
else
    echo "❌ Error al reiniciar el contenedor"
    exit 1
fi