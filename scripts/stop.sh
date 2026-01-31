#!/bin/bash

echo "🛑 Deteniendo Intranet PPG"

# Detener contenedor
docker compose down

echo "✅ Contenedor detenido"

# Opcional: limpiar volúmenes (descomenta si quieres limpiar datos)
# docker-compose down -v
# echo "🧹 Volúmenes limpiados"