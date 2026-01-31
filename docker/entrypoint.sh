#!/bin/bash

echo "🚀 Iniciando Intranet PPG..."

# Función para montar el NAS
mount_nas() {
    echo "📁 Intentando montar NAS en 192.168.1.178..."
    
    # Intentar montaje SMB/CIFS primero
    if mount -t cifs //192.168.1.178/share/Intranet /mnt/nas -o guest,uid=nginx,gid=nginx,iocharset=utf8,file_mode=0644,dir_mode=0755; then
        echo "✅ NAS montado exitosamente via SMB/CIFS"
        return 0
    fi
    
    # Si falla SMB, intentar NFS
    if mount -t nfs 192.168.1.178:/share/Intranet /mnt/nas -o soft,intr,rsize=8192,wsize=8192; then
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
cat > /usr/share/nginx/html/status.json << EOF
{
    "status": "running",
    "timestamp": "$(date -Iseconds)",
    "nas_mounted": $([ -d "/mnt/nas" ] && echo "true" || echo "false"),
    "version": "2.1.0"
}
EOF

echo "🌐 Intranet PPG lista en puerto 80"
echo "📊 Estado disponible en /status.json"
echo "📁 Archivos NAS disponibles en /nas/ (si está montado)"

# Ejecutar comando pasado como parámetro
exec "$@"