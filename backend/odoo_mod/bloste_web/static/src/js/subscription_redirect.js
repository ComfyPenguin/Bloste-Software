document.addEventListener('DOMContentLoaded', function() {
    'use strict';
    
    var urlParams = new URLSearchParams(window.location.search);
    var plan = urlParams.get('plan');
    
    if (plan) {
        var planInputs = document.querySelectorAll('input[name="plan"], input[id*="plan"], input[name*="Plan"]');
        planInputs.forEach(function(input) {
            if (!input.value || input.value === '') {
                input.value = decodeURIComponent(plan);
            }
        });
    }
    
    function handleSubscriptionClick(e) {
        var button = e.target.closest('a, button');
        if (!button) return;
        
        if (button.closest('#payment-form')) {
            console.log('[Bloste] Clic en formulario de pago - NO interceptar');
            return;
        }
        
        console.log('[Bloste] Evaluando clic en botón:', button.textContent.trim());
        
        var buttonText = button.textContent.trim().toLowerCase();
        if (buttonText.includes('suscrib') || buttonText.includes('contratar') || buttonText.includes('elegir')) {
            var card = button.closest('.card, .col-md-4, .col-lg-4, .col, .s_text_block, [data-snippet]');
            var planName = '';
            
            if (card) {
                var titleSelectors = 'h1, h2, h3, h4, h5, h6, .card-title, .title, .heading, [class*="title"]';
                var title = card.querySelector(titleSelectors);
                
                if (title) {
                    planName = title.textContent.trim();
                }
            }
            
            if (planName) {
                e.preventDefault();
                e.stopPropagation();
                window.location.href = '/info-usuario?plan=' + encodeURIComponent(planName);
            }
        }
    }
    
    document.body.addEventListener('click', handleSubscriptionClick);
});
