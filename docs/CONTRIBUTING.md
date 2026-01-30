# Guía de Contribución - Intranet PPG

Esta guía describe cómo contribuir al desarrollo y mantenimiento de la intranet de Central de Plásticos Plasa.

## 🚀 Cómo Contribuir

### 1. Reportar Problemas
- Utiliza la sección de "Sugerencias" en la aplicación
- Describe claramente el problema encontrado
- Incluye pasos para reproducir el error si es posible

### 2. Sugerir Mejoras
- Usa el formulario de sugerencias integrado
- Especifica el área o departamento afectado
- Proporciona detalles sobre la mejora propuesta

### 3. Agregar Contenido

#### Nuevos Procedimientos
1. Identifica el departamento correspondiente
2. Crea el archivo HTML en la carpeta apropiada
3. Sigue la estructura de archivos existentes
4. Incluye un archivo `test.html` para validación

#### Nuevas Herramientas
1. Agrega la herramienta en la carpeta `tools/`
2. Crea documentación o tutoriales
3. Actualiza el menú principal si es necesario

## 📁 Estructura de Archivos

### Convenciones de Nomenclatura
- Archivos HTML: `nombre-descriptivo.html`
- Carpetas: nombres en minúsculas, sin espacios
- Imágenes: formato descriptivo, optimizadas para web

### Estructura de Departamentos
```
areas/[departamento]/
├── index.html          # Página principal del departamento
├── [proceso]/          # Subcarpetas por proceso
│   ├── index.html      # Página principal del proceso
│   ├── [archivo].html  # Procedimientos específicos
│   └── test.html       # Archivo de prueba/validación
└── test.html           # Pruebas generales del departamento
```

## 🎨 Estándares de Diseño

### CSS y Estilos
- Usar Bootstrap 5.3.3 como framework principal
- Mantener tema oscuro consistente
- Colores corporativos de PPG
- Responsive design obligatorio

### HTML
- HTML5 semántico
- Accesibilidad (alt tags, labels, etc.)
- Validación W3C
- Comentarios descriptivos

### JavaScript
- Vanilla JS preferido
- Bootstrap JS para componentes
- Funciones documentadas
- Compatibilidad con navegadores modernos

## 📋 Checklist de Contribución

Antes de enviar cambios, verifica:

- [ ] El código sigue las convenciones establecidas
- [ ] Los enlaces funcionan correctamente
- [ ] El diseño es responsive
- [ ] Se mantiene el tema oscuro
- [ ] Los archivos están en las carpetas correctas
- [ ] Se actualizó la documentación si es necesario
- [ ] Se probó en diferentes navegadores

## 🔧 Herramientas Recomendadas

### Editores
- Visual Studio Code
- Sublime Text
- Atom

### Extensiones Útiles
- Live Server (para desarrollo local)
- HTML CSS Support
- Bootstrap 5 Quick Snippets

### Validadores
- W3C HTML Validator
- W3C CSS Validator
- WAVE Web Accessibility Evaluator

## 📞 Contacto

Para dudas sobre contribuciones:
- **Soporte Técnico**: Ext. 718
- **Email**: soporte@plasticosplasa.com
- **Formulario**: Usar sección de sugerencias en la app

## 📚 Recursos Adicionales

- [Bootstrap 5 Documentation](https://getbootstrap.com/docs/5.3/)
- [HTML5 Semantic Elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Element)
- [Web Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

---

¡Gracias por contribuir al mejoramiento de nuestra intranet! 🎉