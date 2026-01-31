# Intranet PPG - Central de Plásticos Plasa

Una aplicación web interna que sirve como punto de entrada único para todos los servicios, procedimientos y herramientas de la empresa Central de Plásticos Plasa.

## 📋 Descripción

Esta intranet proporciona acceso centralizado a:
- Procedimientos y estándares por departamento
- Herramientas internas (Odoo, reportes, etiquetas)
- Información organizacional
- Recursos de capacitación y desarrollo

## 🏗️ Estructura del Proyecto

```
├── areas/                    # Departamentos de la empresa
│   ├── almacen/             # Área de almacén
│   │   ├── embalaje/        # Procesos de embalaje
│   │   └── pesar/           # Procesos de pesado
│   ├── produccion/          # Área de producción
│   │   ├── cepillo/         # Línea de cepillos
│   │   ├── ensamble/        # Procesos de ensamble
│   │   ├── ensartado/       # Procesos de ensartado
│   │   ├── inyeccion/       # Procesos de inyección
│   │   ├── molido/          # Procesos de molido
│   │   ├── soplado/         # Procesos de soplado
│   │   └── triturado/       # Procesos de triturado
│   ├── taller/              # Área de taller/mantenimiento
│   └── ventas/              # Área de ventas
├── assets/                  # Recursos estáticos
│   ├── css/                 # Estilos personalizados
│   ├── img/                 # Imágenes y logos
│   └── js/                  # JavaScript utilities
├── config/                  # Archivos de configuración
├── docs/                    # Documentación y páginas informativas
│   ├── company/             # Información de la empresa
│   ├── contact/             # Información de contacto
│   └── help/                # Ayuda y soporte
├── events/                  # Eventos especiales y simulacros
├── services/                # Servicios y accesos externos
├── templates/               # Plantillas reutilizables
└── tools/                   # Herramientas integradas
    └── odoo/                # Tutoriales y guías de Odoo
```

## 🚀 Características

- **Interfaz responsive** con Bootstrap 5
- **Tema oscuro** por defecto
- **Navegación simplificada** con dropdown único "PPG"
- **Páginas dedicadas** para Áreas, Servicios y Herramientas
- **Acceso a servicios locales** (etiquetas, reportes)
- **Documentación integrada** de herramientas como Odoo
- **Sistema de sugerencias** para mejora continua
- **Indicadores de estado** para servicios en tiempo real

## 🛠️ Tecnologías Utilizadas

- HTML5
- CSS3 (con variables CSS personalizadas)
- Bootstrap 5.3.3
- JavaScript (ES6+)
- Archivos de configuración JSON

## 📁 Archivos Principales

- `index.html` - Página principal de la intranet
- `assets/css/ppg-styles.css` - Estilos personalizados de PPG
- `assets/js/utils.js` - Utilidades JavaScript
- `config/settings.json` - Configuración del proyecto
- `docs/` - Centro de documentación completo

## 📱 Servicios Integrados

- **Etiquetas**: `http://192.168.1.160:8000/`
- **Reportes**: `http://192.168.1.160:8001/`
- **Odoo**: Tutoriales y guías de uso
- **Acceso Público**: Enlaces a recursos externos
- **Red Local**: Recursos internos de la empresa

## 🏢 Departamentos

### Almacén
- Procesos de embalaje (stack, strap, test)
- Sistemas de pesado y medición
- Gestión de inventarios

### Producción
- **Cepillo**: Fabricación de cepillos y bala prosa
- **Ensamble**: Procesos de ensamblaje
- **Ensartado**: Procesos de ensartado
- **Inyección**: Moldeo por inyección (incluye procedimientos de apagado)
- **Molido**: Procesos de molido
- **Soplado**: Moldeo por soplado
- **Triturado**: Procesos de triturado

### Taller
- Mantenimiento de equipos
- Reparaciones

### Ventas
- Procesos comerciales
- Atención al cliente

## 📚 Documentación

Cada área incluye:
- Procedimientos paso a paso
- Mejores prácticas
- Estándares de calidad
- Archivos de prueba para validación

## 🔧 Instalación y Uso

### Desarrollo Local
1. Clona el repositorio
2. Abre `index.html` en un navegador web
3. Navega por los diferentes departamentos y servicios

Para desarrollo, se recomienda usar un servidor local:

```bash
# Con Python
python -m http.server 8000

# Con Node.js (http-server)
npx http-server

# Con PHP
php -S localhost:8000
```

### Despliegue con Docker 🐳

Para despliegue en producción con acceso al servidor NAS:

```bash
# Despliegue rápido
./scripts/deploy.sh

# O manualmente
docker-compose up -d --build
```

**Características del despliegue Docker:**
- ✅ Servidor web nginx optimizado
- ✅ Acceso automático al NAS (192.168.1.178/share/Intranet)
- ✅ Monitoreo de salud integrado
- ✅ Logs centralizados
- ✅ Reinicio automático

**Accesos disponibles:**
- Intranet: `http://localhost`
- Estado: `http://localhost/status.json`
- Archivos NAS: `http://localhost/nas/`

Ver [DOCKER-DEPLOYMENT.md](DOCKER-DEPLOYMENT.md) para documentación completa.

## 📚 Documentación Adicional

- **Centro de Documentación**: Accede a `/docs/index.html`
- **Guía de Contribución**: Ver `/docs/CONTRIBUTING.md`
- **Registro de Cambios**: Ver `/docs/CHANGELOG.md`
- **Configuración**: Ver `/config/settings.json`

## 🤝 Contribuciones

Para sugerir mejoras o reportar problemas, utiliza la sección de "Sugerencias" en la aplicación o contacta al equipo de desarrollo.

## 📞 Contacto

- **Empresa**: Central de Plásticos Plasa
- **Tipo**: Intranet corporativa
- **Acceso**: Red local de la empresa

## 📄 Licencia

Uso interno de Central de Plásticos Plasa. Todos los derechos reservados.
