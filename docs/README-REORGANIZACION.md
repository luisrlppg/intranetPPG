# Propuesta de Reorganización de la Intranet PPG

## Estructura Actual vs Propuesta

### Estructura Actual
```
├── areas/                    # Departamentos
├── assets/                   # Recursos estáticos
├── events/                   # Eventos
├── templates/                # Plantillas
├── tools/                    # Herramientas
├── ext-tel.html             # Teléfonos (raíz)
├── suggest.html             # Sugerencias (raíz)
├── organigrama.html         # Organigrama (raíz)
└── otros archivos HTML...
```

### Estructura Propuesta
```
├── areas/                    # Departamentos (sin cambios)
├── assets/                   # Recursos estáticos (sin cambios)
├── docs/                     # Documentación y páginas informativas
│   ├── company/             # Información de la empresa
│   │   ├── organigrama.html
│   │   └── about.html
│   ├── contact/             # Información de contacto
│   │   └── ext-tel.html
│   └── help/                # Ayuda y soporte
│       └── suggest.html
├── events/                   # Eventos (sin cambios)
├── services/                 # Servicios y accesos
│   ├── localaccess.html
│   └── localsrc.html
├── templates/                # Plantillas (sin cambios)
└── tools/                    # Herramientas (sin cambios)
```

## Beneficios de la Reorganización

1. **Mejor organización**: Archivos relacionados agrupados lógicamente
2. **Escalabilidad**: Fácil agregar nuevos documentos o servicios
3. **Mantenimiento**: Más fácil encontrar y actualizar archivos
4. **Navegación**: Estructura más intuitiva para desarrolladores

## Archivos a Mover

- `ext-tel.html` → `docs/contact/ext-tel.html`
- `suggest.html` → `docs/help/suggest.html`
- `organigrama.html` → `docs/company/organigrama.html`
- `localaccess.html` → `services/localaccess.html`
- `localsrc.html` → `services/localsrc.html`

## Actualizaciones Necesarias

Después de mover los archivos, será necesario actualizar:
1. Enlaces en `index.html`
2. Enlaces en archivos que referencien a los movidos
3. Rutas relativas en CSS/JS si las hay