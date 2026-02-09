/** @odoo-module **/

document.addEventListener('DOMContentLoaded', function() {
    'use strict';
    
    // Auto-rellenar el campo "Plan a contratar" con el parámetro de la URL
    var urlParams = new URLSearchParams(window.location.search);
    var plan = urlParams.get('plan');
    
    if (plan) {
        // Buscar inputs con name="plan" o id que contenga "plan"
        var planInputs = document.querySelectorAll('input[name="plan"], input[id*="plan"], input[name*="Plan"]');
        planInputs.forEach(function(input) {
            if (!input.value || input.value === '') {
                input.value = decodeURIComponent(plan);
            }
        });
    }
    
    // Función para manejar clics en botones de suscripción
    function handleSubscriptionClick(e) {
        var button = e.target.closest('a, button');
        if (!button) return;
        
        // IMPORTANTE: No interceptar clics dentro del formulario de pago
        if (button.closest('#payment-form')) {
            console.log('[Bloste] Clic en formulario de pago - NO interceptar');
            return; // Dejar que el formulario se envíe normalmente
        }
        
        console.log('[Bloste] Evaluando clic en botón:', button.textContent.trim());
        
        // Verificar si es un botón de suscripción
        var buttonText = button.textContent.trim().toLowerCase();
        if (buttonText.includes('suscrib') || buttonText.includes('contratar') || buttonText.includes('elegir')) {
            // Buscar el nombre del plan
            var card = button.closest('.card, .col-md-4, .col-lg-4, .col, .s_text_block, [data-snippet]');
            var planName = '';
            
            if (card) {
                // Buscar el título del plan (h1-h6 o elementos con clase title/heading)
                var titleSelectors = 'h1, h2, h3, h4, h5, h6, .card-title, .title, .heading, [class*="title"]';
                var title = card.querySelector(titleSelectors);
                
                if (title) {
                    planName = title.textContent.trim();
                }
            }
            
            // Si encontramos un nombre de plan, redirigir
            if (planName) {
                e.preventDefault();
                e.stopPropagation();
                window.location.href = '/info-usuario?plan=' + encodeURIComponent(planName);
            }
        }
    }
    
    // Agregar listener a todo el documento para capturar clics en botones
    document.body.addEventListener('click', handleSubscriptionClick);
});
