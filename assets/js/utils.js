/**
 * Utilidades JavaScript para la Intranet PPG
 * Central de Plásticos Plasa
 */

// Configuración global
const PPG_CONFIG = {
    company: 'Central de Plásticos Plasa',
    version: '2.1.0',
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
 * Funciones específicas para el dashboard
 */
const PPGDashboard = {
    
    /**
     * Verifica el estado de los servicios y actualiza indicadores
     */
    checkServicesStatus: async function() {
        const services = [
            { 
                url: 'http://192.168.1.160:8000/', 
                elementId: 'status-labels',
                name: 'Sistema de Etiquetas'
            },
            { 
                url: 'http://192.168.1.160:8001/', 
                elementId: 'status-reports',
                name: 'Sistema de Reportes'
            },
            { 
                url: 'http://192.168.1.160:5000/', 
                elementId: 'status-inventory',
                name: 'Inventario PPG'
            },
            { 
                url: 'http://192.168.1.160:50000/', 
                elementId: 'status-pc-control',
                name: 'Control de PCs'
            },
            { 
                url: 'http://192.168.1.160:8070/', 
                elementId: 'status-odoo',
                name: 'Odoo ERP'
            }
        ];
        
        for (const service of services) {
            const element = document.getElementById(service.elementId);
            if (!element) continue;
            
            try {
                const isAvailable = await PPGUtils.checkServiceAvailability(service.url);
                
                if (isAvailable) {
                    element.className = 'badge bg-success rounded-pill';
                    element.textContent = '🟢 Online';
                } else {
                    element.className = 'badge bg-danger rounded-pill';
                    element.textContent = '🔴 Offline';
                }
            } catch (error) {
                element.className = 'badge bg-warning rounded-pill';
                element.textContent = '🟡 Desconocido';
            }
        }
    },
    
    
    /**
     * Actualiza el contador de sugerencias pendientes en el dashboard
     */
    updatePendingSuggestionsCount: function() {
        try {
            const pendingSuggestions = JSON.parse(localStorage.getItem('ppg_suggestions_pending') || '[]');
            const countElement = document.getElementById('pending-suggestions');
            
            if (countElement) {
                const count = pendingSuggestions.length;
                countElement.textContent = count;
                
                if (count > 0) {
                    countElement.className = 'badge bg-warning text-dark rounded-pill';
                    countElement.title = `${count} sugerencia(s) pendiente(s) de envío`;
                } else {
                    countElement.className = 'badge bg-secondary rounded-pill';
                    countElement.title = 'No hay sugerencias pendientes';
                }
            }
        } catch (error) {
            console.error('Error al actualizar contador de sugerencias:', error);
        }
    },
    /**
     * Inicializa el dashboard
     */
    init: function() {
        // Verificar estado de servicios
        this.checkServicesStatus();
        
        // Actualizar contador de sugerencias pendientes
        this.updatePendingSuggestionsCount();
        
        // Verificar servicios cada 2 minutos
        setInterval(() => {
            this.checkServicesStatus();
        }, 120000);
        
        // Actualizar contador de sugerencias cada minuto
        setInterval(() => {
            this.updatePendingSuggestionsCount();
        }, 60000);
        
        // Mostrar notificación de bienvenida
        setTimeout(() => {
            PPGUtils.showNotification('¡Bienvenido a la Intranet PPG! 🎉', 'success');
        }, 1000);
    }
};
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
     * Envía una sugerencia al servicio de reportes
     * @param {Object} data - Datos de la sugerencia
     */
    submitSuggestion: async function(data) {
        const submitButton = document.querySelector('button[type="button"]');
        const originalText = submitButton?.textContent;
        
        try {
            // Mostrar estado de carga
            if (submitButton) {
                submitButton.disabled = true;
                submitButton.textContent = 'Enviando...';
            }
            
            // Preparar datos para envío
            const suggestionData = {
                timestamp: new Date().toISOString(),
                nombre: data.nombre,
                tema: data.tema,
                sugerencia: data.sugerencia,
                tipo: 'sugerencia_intranet',
                origen: 'Intranet PPG',
                estado: 'nueva'
            };
            
            // Intentar enviar al servicio de reportes
            const response = await fetch('http://192.168.1.160:8001/api/sugerencias', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(suggestionData)
            });
            
            if (response.ok) {
                const result = await response.json();
                PPGUtils.showNotification('¡Sugerencia enviada exitosamente! Gracias por tu aporte.', 'success');
                
                // Limpiar formulario
                const form = document.getElementById('buzonForm');
                if (form) {
                    form.reset();
                }
                
                console.log('Sugerencia enviada:', result);
            } else {
                throw new Error(`Error del servidor: ${response.status}`);
            }
            
        } catch (error) {
            console.error('Error al enviar sugerencia:', error);
            
            // Fallback: guardar localmente si el servicio no está disponible
            this.saveSuggestionLocally(data);
            
            PPGUtils.showNotification(
                'Sugerencia guardada localmente. Se enviará cuando el servicio esté disponible.', 
                'warning'
            );
        } finally {
            // Restaurar botón
            if (submitButton) {
                submitButton.disabled = false;
                submitButton.textContent = originalText || 'Enviar Sugerencia';
            }
        }
    },
    
    /**
     * Guarda la sugerencia localmente como fallback
     * @param {Object} data - Datos de la sugerencia
     */
    saveSuggestionLocally: function(data) {
        try {
            const suggestions = JSON.parse(localStorage.getItem('ppg_suggestions_pending') || '[]');
            suggestions.push({
                ...data,
                timestamp: new Date().toISOString(),
                status: 'pending'
            });
            localStorage.setItem('ppg_suggestions_pending', JSON.stringify(suggestions));
        } catch (error) {
            console.error('Error al guardar sugerencia localmente:', error);
        }
    },
    
    /**
     * Intenta enviar sugerencias pendientes
     */
    retryPendingSuggestions: async function() {
        try {
            const pendingSuggestions = JSON.parse(localStorage.getItem('ppg_suggestions_pending') || '[]');
            
            if (pendingSuggestions.length === 0) return;
            
            const successfulSends = [];
            
            for (let i = 0; i < pendingSuggestions.length; i++) {
                const suggestion = pendingSuggestions[i];
                
                try {
                    const response = await fetch('http://192.168.1.160:8001/api/sugerencias', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'Accept': 'application/json'
                        },
                        body: JSON.stringify({
                            timestamp: suggestion.timestamp,
                            nombre: suggestion.nombre,
                            tema: suggestion.tema,
                            sugerencia: suggestion.sugerencia,
                            tipo: 'sugerencia_intranet_retry',
                            origen: 'Intranet PPG',
                            estado: 'nueva'
                        })
                    });
                    
                    if (response.ok) {
                        successfulSends.push(i);
                    }
                } catch (error) {
                    // Si falla, mantener en pendientes
                    console.log('Sugerencia aún pendiente:', suggestion.nombre);
                }
            }
            
            // Remover sugerencias enviadas exitosamente
            if (successfulSends.length > 0) {
                const remainingSuggestions = pendingSuggestions.filter((_, index) => 
                    !successfulSends.includes(index)
                );
                localStorage.setItem('ppg_suggestions_pending', JSON.stringify(remainingSuggestions));
                
                if (remainingSuggestions.length === 0) {
                    PPGUtils.showNotification(
                        `${successfulSends.length} sugerencia(s) pendiente(s) enviada(s) exitosamente.`, 
                        'success'
                    );
                }
            }
            
        } catch (error) {
            console.error('Error al procesar sugerencias pendientes:', error);
        }
    }
};

/**
 * Inicialización cuando el DOM está listo
 */
document.addEventListener('DOMContentLoaded', function() {
    
    // Cargar breadcrumb si existe el contenedor
    PPGUtils.loadBreadcrumb();
    
    // Inicializar dashboard si estamos en la página principal
    if (window.location.pathname.endsWith('index.html') || window.location.pathname === '/') {
        PPGDashboard.init();
        
        // Intentar enviar sugerencias pendientes
        setTimeout(() => {
            PPGForms.retryPendingSuggestions();
        }, 3000);
    }
    
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
window.PPGDashboard = PPGDashboard;
window.PPG_CONFIG = PPG_CONFIG;