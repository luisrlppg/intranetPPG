#!/bin/bash

echo "🚀 Desplegando Intranet PPG directamente (sin redes personalizadas)"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker no está instalado."
    exit 1
fi

# Crear directorio de logs
mkdir -p logs

# Limpiar contenedor previo si existe
if docker ps -a | grep -q "intranet-ppg"; then
    print_warning "Eliminando contenedor previo..."
    docker stop intranet-ppg 2>/dev/null || true
    docker rm intranet-ppg 2>/dev/null || true
fi

print_status "Construyendo imagen..."
docker build -t intranet-ppg .

if [ $? -ne 0 ]; then
    print_error "Error al construir la imagen"
    exit 1
fi

print_status "Iniciando contenedor..."
docker run -d \
    --name intranet-ppg \
    --privileged \
    -p 80:80 \
    -p 8080:80 \
    -v "$(pwd)/logs:/var/log/nginx" \
    -v "$(pwd)/docker/nginx.conf:/etc/nginx/nginx.conf:ro" \
    -e TZ=America/Mexico_City \
    --restart unless-stopped \
    intranet-ppg

if [ $? -eq 0 ]; then
    print_status "✅ Contenedor iniciado exitosamente!"
    
    # Esperar un momento
    sleep 5
    
    # Verificar estado
    if docker ps | grep -q "intranet-ppg"; then
        print_status "🌐 Intranet PPG desplegada exitosamente!"
        echo ""
        echo "Accesos disponibles:"
        echo "   - http://localhost"
        echo "   - http://localhost:8080"
        echo ""
        echo "Monitoreo:"
        echo "   - Estado: http://localhost/status.json"
        echo "   - Logs: docker logs -f intranet-ppg"
        echo ""
        
        # Verificar NAS
        sleep 2
        if docker exec intranet-ppg test -d /mnt/nas 2>/dev/null; then
            print_status "✅ NAS montado correctamente"
        else
            print_warning "⚠️  NAS no disponible - funcionando en modo local"
        fi
    else
        print_error "El contenedor no se inició correctamente"
        docker logs intranet-ppg
        exit 1
    fi
else
    print_error "Error al iniciar el contenedor"
    exit 1
fi