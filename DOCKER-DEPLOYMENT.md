# Despliegue Docker - Intranet PPG

Esta guía explica cómo desplegar la Intranet PPG usando Docker con acceso al servidor NAS.

## 🚀 Despliegue Rápido

### Prerrequisitos
- Docker instalado
- Docker Compose instalado
- Acceso de red a 192.168.1.178 (servidor NAS)

### Pasos de Instalación

1. **Clonar/Descargar el proyecto**
   ```bash
   # Si tienes git
   git clone <tu-repositorio>
   cd intranet-ppg
   ```

2. **Configurar variables de entorno (opcional)**
   ```bash
   cp .env.example .env
   # Editar .env si necesitas cambiar configuraciones
   ```

3. **Verificar configuración (opcional)**
   ```bash
   ./scripts/check-setup.sh
   ```

4. **Desplegar con script automático**
   ```bash
   # Opción 1: Despliegue directo (más simple, recomendado)
   ./scripts/deploy-direct.sh
   
   # Opción 2: Con docker compose (versión simple)
   ./scripts/deploy-simple.sh
   
   # Opción 3: Con docker compose (versión completa)
   ./scripts/deploy.sh
   
   # En Windows (PowerShell) - usar docker compose con espacio
   docker compose -f docker-compose.simple.yml up -d --build
   ```

   **Importante**: Los scripts se ejecutan automáticamente desde el directorio correcto.

4. **Verificar despliegue**
   - Abrir http://localhost en el navegador
   - Verificar estado: http://localhost/status.json

## 🔧 Configuración Manual

### Construir imagen
```bash
docker build -t intranet-ppg .
```

### Ejecutar contenedor
```bash
docker run -d \
  --name intranet-ppg \
  --privileged \
  -p 80:80 \
  -v $(pwd)/logs:/var/log/nginx \
  intranet-ppg
```

### Con Docker Compose
```bash
docker-compose up -d
```

## 📁 Acceso al NAS

El contenedor intentará montar automáticamente el NAS en:
- **Ruta interna**: `/mnt/nas`
- **URL web**: `http://localhost/nas/`

### Tipos de montaje soportados:
1. **SMB/CIFS** (predeterminado)
2. **NFS** (fallback)

### Verificar montaje del NAS:
```bash
docker-compose exec intranet-ppg ls -la /mnt/nas
```

## 🖥️ Puertos y Accesos

| Puerto | Descripción |
|--------|-------------|
| 80     | Puerto principal |
| 8080   | Puerto alternativo |

### URLs disponibles:
- **Intranet**: http://localhost
- **Estado**: http://localhost/status.json
- **Archivos NAS**: http://localhost/nas/
- **API NAS**: http://localhost/api/nas/list

## 📊 Monitoreo

### Ver logs en tiempo real:
```bash
docker-compose logs -f
```

### Verificar estado del contenedor:
```bash
docker-compose ps
```

### Verificar salud del servicio:
```bash
curl http://localhost/status.json
```

### Estadísticas de recursos:
```bash
docker stats intranet-ppg
```

## 🛠️ Comandos Útiles

### Reiniciar servicio:
```bash
docker-compose restart
```

### Detener servicio:
```bash
docker-compose down
# o usar el script
./scripts/stop.sh
```

### Actualizar imagen:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Acceder al contenedor:
```bash
docker-compose exec intranet-ppg bash
```

### Ver archivos del NAS desde el contenedor:
```bash
docker-compose exec intranet-ppg find /mnt/nas -type f | head -10
```

## 🔒 Seguridad

### Consideraciones:
- El contenedor requiere privilegios para montar sistemas de archivos
- Solo exponer puertos necesarios
- Configurar firewall apropiadamente
- Considerar usar HTTPS en producción

### Para HTTPS (opcional):
1. Obtener certificados SSL
2. Modificar nginx.conf para incluir configuración SSL
3. Exponer puerto 443

## 🐛 Solución de Problemas

### Error de red Docker superpuesta:
```
Error: Pool overlaps with other one on this address space
```

**Soluciones:**

1. **Usar versión simple (recomendado):**
   ```bash
   ./scripts/deploy-simple.sh
   # o
   docker-compose -f docker-compose.simple.yml up -d --build
   ```

2. **Limpiar redes existentes:**
   ```bash
   docker network prune
   docker-compose down
   docker-compose up -d --build
   ```

3. **Cambiar subnet manualmente:**
   Editar `docker-compose.yml` y cambiar `172.25.0.0/16` por otra subnet disponible.

### Contenedor no accesible desde otras PCs:

**Diagnóstico:**
```bash
./scripts/check-network-access.sh
```

**Soluciones:**

1. **Configurar firewall automáticamente:**
   ```bash
   # Windows (ejecutar como Administrador)
   ./scripts/setup-firewall.sh
   
   # Linux
   sudo ./scripts/setup-firewall.sh
   ```

2. **Configurar firewall manualmente:**
   ```bash
   # Windows (como Administrador)
   netsh advfirewall firewall add rule name="Intranet PPG" dir=in action=allow protocol=TCP localport=80
   netsh advfirewall firewall add rule name="Intranet PPG Alt" dir=in action=allow protocol=TCP localport=8080
   
   # Linux (Ubuntu/Debian)
   sudo ufw allow 80
   sudo ufw allow 8080
   
   # Linux (CentOS/RHEL)
   sudo firewall-cmd --permanent --add-port=80/tcp
   sudo firewall-cmd --permanent --add-port=8080/tcp
   sudo firewall-cmd --reload
   ```

3. **Verificar que el contenedor escuche en todas las interfaces:**
   ```bash
   docker port intranet-ppg
   # Debe mostrar: 0.0.0.0:80->80/tcp y 0.0.0.0:8080->80/tcp
   ```

4. **Reiniciar contenedor con configuración correcta:**
   ```bash
   docker stop intranet-ppg
   docker rm intranet-ppg
   ./scripts/deploy-direct.sh
   ```

### NAS no se monta:
```bash
# Verificar conectividad
ping 192.168.1.178

# Verificar desde el contenedor
docker-compose exec intranet-ppg ping 192.168.1.178
```

### Servicios PPG no disponibles:
```bash
# Verificar conectividad a servicios
curl -I http://192.168.1.160:8000
curl -I http://192.168.1.160:8001
# etc.
```

### Contenedor no inicia:
```bash
# Ver logs detallados
docker-compose logs intranet-ppg

# Verificar configuración
docker-compose config
```

### Problemas de permisos:
```bash
# Verificar permisos de archivos
ls -la logs/
# Cambiar propietario si es necesario
sudo chown -R $USER:$USER logs/
```

## 📈 Optimizaciones de Producción

### Para mejor rendimiento:
1. Usar volúmenes nombrados para datos persistentes
2. Configurar límites de recursos
3. Implementar balanceador de carga si es necesario
4. Configurar backup automático

### Ejemplo de configuración con límites:
```yaml
services:
  intranet-ppg:
    # ... otras configuraciones
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
```

## 🔄 Actualizaciones

Para actualizar la intranet:
1. Hacer cambios en el código
2. Reconstruir imagen: `docker-compose build`
3. Reiniciar servicio: `docker-compose up -d`

## 📞 Soporte

Para problemas o dudas:
- Revisar logs: `docker-compose logs`
- Verificar estado: `http://localhost/status.json`
- Contactar soporte técnico: Ext. 718