/**
 * Utilidades JavaScript para la Intranet PPG
 * Central de Plásticos Plasa
 */

// Configuración global
const PPG_CONFIG = {
    company: 'Central de Plásticos Plasa',
    version: '2.0.0',
    theme: 'dark',
    services: {
        labels: 'http://192.168.1.160:8000/',
        reports: 'http://192.168.1.160:8001/'
    }
};

/**
 * Utilidades generales
 */
const PPGUtils = {
    
    /**
     * Muestra un mensaje de notificación
     * @param {string} message - Mensaje a mostrar
     * @param {string} type - Tipo de mensaje (success, error, warning, info)
     */
    showNotification: function(message, type = 'info') {
        // Crear elemento de notificación
        const notification = document.createElement('div');
        notification.className = `alert alert-${type === 'error' ? 'danger' : type} alert-dismissible fade show position-fixed`;
        notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        
        notification.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        document.body.appendChild(notification);
        
        // Auto-remover después de 5 segundos
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 5000);
    },
    
    /**
     * Valida si un servicio local está disponible
     * @param {string} url - URL del servicio
     * @returns {Promise<boolean>}
     */
    checkServiceAvailability: async function(url) {
        try {
            const response = await fetch(url, { 
                method: 'HEAD', 
                mode: 'no-cors',
                timeout: 3000 
            });
            return true;
        } catch (error) {
            return false;
        }
    },
    
    /**
     * Formatea una fecha en español
     * @param {Date} date - Fecha a formatear
     * @returns {string}
     */
    formatDate: function(date) {
        return new Intl.DateTimeFormat('es-MX', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        }).format(date);
    },
    
    /**
     * Obtiene información del departamento actual basado en la URL
     * @returns {string|null}
     */
    getCurrentDepartment: function() {
        const path = window.location.pathname;
        const departments = ['almacen', 'produccion', 'taller', 'ventas'];
        
        for (const dept of departments) {
            if (path.includes(dept)) {
                return dept;
            }
        }
        return null;
    },
    
    /**
     * Carga dinámicamente el breadcrumb basado en la ubicación
     */
    loadBreadcrumb: function() {
        const breadcrumbContainer = document.getElementById('breadcrumb');
        if (!breadcrumbContainer) return;
        
        const path = window.location.pathname;
        const segments = path.split('/').filter(segment => segment && segment !== 'index.html');
        
        let breadcrumbHTML = '<nav aria-label="breadcrumb"><ol class="breadcrumb">';
        breadcrumbHTML += '<li class="breadcrumb-item"><a href="/index.html">Inicio</a></li>';
        
        let currentPath = '';
        segments.forEach((segment, index) => {
            currentPath += '/' + segment;
            const isLast = index === segments.length - 1;
            const displayName = segment.charAt(0).toUpperCase() + segment.slice(1);
            
            if (isLast) {
                breadcrumbHTML += `<li class="breadcrumb-item active" aria-current="page">${displayName}</li>`;
            } else {
                breadcrumbHTML += `<li class="breadcrumb-item"><a href="${currentPath}/index.html">${displayName}</a></li>`;
            }
        });
        
        breadcrumbHTML += '</ol></nav>';
        breadcrumbContainer.innerHTML = breadcrumbHTML;
    }
};

/**
 * Funciones específicas para formularios
 */
const PPGForms = {
    
    /**
     * Valida un formulario de sugerencias
     * @param {HTMLFormElement} form - Formulario a validar
     * @returns {boolean}
     */
    validateSuggestionForm: function(form) {
        const nombre = form.querySelector('#nombre')?.value.trim();
        const tema = form.querySelector('#tema')?.value;
        const sugerencia = form.querySelector('#sugerencia')?.value.trim();
        
        if (!nombre || !tema || !sugerencia) {
            PPGUtils.showNotification('Por favor, completa todos los campos.', 'error');
            return false;
        }
        
        if (sugerencia.length < 10) {
            PPGUtils.showNotification('La sugerencia debe tener al menos 10 caracteres.', 'warning');
            return false;
        }
        
        return true;
    },
    
    /**
     * Envía una sugerencia (simulado)
     * @param {Object} data - Datos de la sugerencia
     */
    submitSuggestion: function(data) {
        // Simular envío (en producción se conectaría a un backend)
        console.log('Sugerencia enviada:', data);
        
        PPGUtils.showNotification('¡Gracias por tu sugerencia! Ha sido enviada correctamente.', 'success');
        
        // Limpiar formulario
        const form = document.getElementById('buzonForm');
        if (form) {
            form.reset();
        }
    }
};

/**
 * Inicialización cuando el DOM está listo
 */
document.addEventListener('DOMContentLoaded', function() {
    
    // Cargar breadcrumb si existe el contenedor
    PPGUtils.loadBreadcrumb();
    
    // Verificar disponibilidad de servicios
    const serviceLinks = document.querySelectorAll('a[href*="192.168.1.160"]');
    serviceLinks.forEach(async (link) => {
        const isAvailable = await PPGUtils.checkServiceAvailability(link.href);
        if (!isAvailable) {
            link.classList.add('text-muted');
            link.title = 'Servicio no disponible';
        }
    });
    
    // Mejorar formulario de sugerencias si existe
    const suggestionForm = document.getElementById('buzonForm');
    if (suggestionForm) {
        const submitButton = suggestionForm.querySelector('button[onclick="enviarSugerencia()"]');
        if (submitButton) {
            submitButton.onclick = function(e) {
                e.preventDefault();
                
                if (PPGForms.validateSuggestionForm(suggestionForm)) {
                    const formData = {
                        nombre: document.getElementById('nombre').value,
                        tema: document.getElementById('tema').value,
                        sugerencia: document.getElementById('sugerencia').value,
                        fecha: new Date().toISOString()
                    };
                    
                    PPGForms.submitSuggestion(formData);
                }
            };
        }
    }
    
    // Agregar información de versión al footer si existe
    const footer = document.querySelector('footer');
    if (footer && !footer.querySelector('.version-info')) {
        const versionInfo = document.createElement('small');
        versionInfo.className = 'version-info text-muted d-block mt-2';
        versionInfo.textContent = `Intranet PPG v${PPG_CONFIG.version}`;
        footer.appendChild(versionInfo);
    }
});

// Exportar para uso global
window.PPGUtils = PPGUtils;
window.PPGForms = PPGForms;
window.PPG_CONFIG = PPG_CONFIG;