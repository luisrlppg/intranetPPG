# Usar nginx como servidor web base
FROM nginx:alpine

# Instalar herramientas necesarias para montar NFS/SMB
RUN apk add --no-cache \
    nfs-utils \
    cifs-utils \
    curl \
    bash

# Crear directorio para el punto de montaje del NAS
RUN mkdir -p /mnt/nas

# Copiar archivos de la intranet al directorio web de nginx
COPY . /usr/share/nginx/html/

# Copiar configuración personalizada de nginx
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Copiar script de inicio
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Crear directorio para logs
RUN mkdir -p /var/log/nginx

# Exponer puerto 80
EXPOSE 80

# Usar script de inicio personalizado
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]