#!/bin/bash

echo "🚀 Iniciando Intranet PPG..."

# Función para montar el NAS
mount_nas() {
    echo "📁 Intentando montar NAS en 192.168.1.178..."
    
    # Crear directorio de montaje
    mkdir -p /mnt/nas
    
    # Verificar conectividad primero
    if ! ping -c 1 -W 3 192.168.1.178 >/dev/null 2>&1; then
        echo "⚠️  No hay conectividad con 192.168.1.178"
        return 1
    fi
    
    # Intentar montaje SMB/CIFS versión 2.0 sin credenciales
    echo "🔄 Intentando montaje SMB/CIFS v2.0 sin credenciales..."
    if timeout 15 mount -t cifs //192.168.1.178/share/Intranet /mnt/nas \
        -o vers=2.0,sec=none,uid=101,gid=101,iocharset=utf8,file_mode=0644,dir_mode=0755,nounix,noserverino,cache=loose 2>/dev/null; then
        echo "✅ NAS montado exitosamente via SMB/CIFS v2.0"
        return 0
    fi
    
    # Fallback: intentar con guest si sec=none falla
    echo "🔄 Fallback: Intentando con guest..."
    if timeout 15 mount -t cifs //192.168.1.178/share/Intranet /mnt/nas \
        -o vers=2.0,guest,uid=101,gid=101,iocharset=utf8,file_mode=0644,dir_mode=0755,nounix,noserverino 2>/dev/null; then
        echo "✅ NAS montado exitosamente via SMB/CIFS v2.0 (guest)"
        return 0
    fi
    
    # Si falla SMB, intentar NFS con opciones más compatibles
    echo "🔄 Intentando montaje NFS..."
    if timeout 10 mount -t nfs 192.168.1.178:/share/Intranet /mnt/nas \
        -o soft,intr,nolock,rsize=8192,wsize=8192,timeo=14,retrans=2 2>/dev/null; then
        echo "✅ NAS montado exitosamente via NFS"
        return 0
    fi
    
    echo "⚠️  No se pudo montar el NAS. Continuando sin acceso a archivos externos."
    echo "   La intranet funcionará normalmente, pero sin acceso a recursos del NAS."
    return 1
}

# Función para verificar conectividad
check_connectivity() {
    echo "🔍 Verificando conectividad con servicios PPG..."
    
    services=(
        "192.168.1.160:8000"
        "192.168.1.160:8001" 
        "192.168.1.160:5000"
        "192.168.1.160:50000"
        "192.168.1.160:8070"
    )
    
    for service in "${services[@]}"; do
        if curl -s --connect-timeout 3 "http://$service" > /dev/null 2>&1; then
            echo "✅ $service - Online"
        else
            echo "⚠️  $service - Offline"
        fi
    done
}

# Crear directorio de logs si no existe
mkdir -p /var/log/nginx

# Verificar conectividad
check_connectivity

# Intentar montar NAS
mount_nas

# Crear archivo de estado
nas_status="false"
if mountpoint -q /mnt/nas 2>/dev/null || [ "$(ls -A /mnt/nas 2>/dev/null)" ]; then
    nas_status="true"
fi

cat > /usr/share/nginx/html/status.json << EOF
{
    "status": "running",
    "timestamp": "$(date -Iseconds)",
    "nas_mounted": $nas_status,
    "version": "2.1.0"
}
EOF

echo "🌐 Intranet PPG lista en puerto 80"
echo "📊 Estado disponible en /status.json"
echo "📁 Archivos NAS disponibles en /nas/ (si está montado)"

# Ejecutar comando pasado como parámetro
exec "$@"