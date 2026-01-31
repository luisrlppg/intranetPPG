#!/bin/bash

echo "🚀 Desplegando Intranet PPG con Docker"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para imprimir mensajes coloreados
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    print_error "Docker no está instalado. Por favor instala Docker primero."
    exit 1
fi

# Verificar si Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose no está instalado. Por favor instala Docker Compose primero."
    exit 1
fi

# Crear directorio de logs si no existe
mkdir -p logs

print_status "Construyendo imagen Docker..."
docker-compose build

if [ $? -eq 0 ]; then
    print_status "Imagen construida exitosamente"
else
    print_error "Error al construir la imagen"
    exit 1
fi

print_status "Iniciando contenedor..."
docker-compose up -d

if [ $? -eq 0 ]; then
    print_status "Contenedor iniciado exitosamente"
    
    # Esperar un momento para que el contenedor se inicie
    sleep 5
    
    # Verificar estado del contenedor
    if docker-compose ps | grep -q "Up"; then
        print_status "✅ Intranet PPG desplegada exitosamente!"
        echo ""
        echo "🌐 Accesos disponibles:"
        echo "   - http://localhost"
        echo "   - http://localhost:8080"
        echo "   - http://$(hostname -I | awk '{print $1}')"
        echo ""
        echo "📊 Monitoreo:"
        echo "   - Estado: http://localhost/status.json"
        echo "   - Logs: docker-compose logs -f"
        echo ""
        echo "📁 Archivos NAS (si está disponible):"
        echo "   - http://localhost/nas/"
        
        # Verificar si el NAS está montado
        sleep 2
        if docker-compose exec intranet-ppg test -d /mnt/nas 2>/dev/null; then
            print_status "✅ NAS montado correctamente"
        else
            print_warning "⚠️  NAS no disponible - funcionando en modo local"
        fi
        
    else
        print_error "El contenedor no se inició correctamente"
        docker-compose logs
        exit 1
    fi
else
    print_error "Error al iniciar el contenedor"
    exit 1
fi