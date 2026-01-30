# Changelog - Intranet PPG

Registro de cambios y mejoras realizadas en la intranet de Central de Plásticos Plasa.

## [2.1.0] - 2026-01-30

### Agregado
- Nueva página dedicada para Áreas (`/areas/index.html`) con diseño en grid
- Página de Herramientas con categorización y diseño mejorado
- Página de Servicios con indicadores de estado en tiempo real
- Navegación ultra-simplificada con dropdown único "PPG"
- Estadísticas y métricas visuales en la página de áreas
- Mapa de procesos interactivo
- Indicadores de estado para servicios internos

### Cambiado
- Navegación principal reducida a 4 elementos: Inicio, PPG (dropdown), Documentación, Acerca de
- Dropdown "PPG" incluye: Áreas, Servicios, Herramientas
- Reorganización de accesos rápidos en página principal
- Mejora en la experiencia de usuario con navegación más intuitiva

### Mejorado
- Diseño más limpio y menos saturado en la barra de navegación
- Mejor organización visual de contenido
- Accesibilidad mejorada con navegación simplificada
- Consistencia visual entre todas las páginas principales

## [2.0.0] - 2026-01-30

### Agregado
- README.md completo con documentación detallada del proyecto
- Nueva estructura de carpetas más organizada
- Carpeta `docs/` para documentación y páginas informativas
- Carpeta `services/` para servicios y accesos externos
- Documentación de reorganización del proyecto

### Cambiado
- Reorganización de archivos HTML en carpetas lógicas:
  - `ext-tel.html` → `docs/contact/ext-tel.html`
  - `suggest.html` → `docs/help/suggest.html`
  - `organigrama.html` → `docs/company/organigrama.html`
  - `localaccess.html` → `services/localaccess.html`
  - `localsrc.html` → `services/localsrc.html`
- Actualización de enlaces en `index.html` para reflejar nueva estructura

### Mejorado
- Estructura del proyecto más escalable y mantenible
- Mejor organización de archivos por categorías
- Documentación más completa para desarrolladores

## [1.0.0] - Versión Inicial

### Agregado
- Estructura inicial de la intranet
- Departamentos: Almacén, Producción, Taller, Ventas
- Integración con servicios locales (etiquetas, reportes)
- Sistema de navegación con Bootstrap
- Tema oscuro por defecto
- Páginas de contacto, sugerencias y organigrama