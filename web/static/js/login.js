/* ============================================================
   LOGIN.JS - Scripts rieng cho trang Login
   ============================================================ */

// Toggle password visibility
function togglePassword() {
    const passwordInput = document.getElementById('password');
    const toggleIcon = document.getElementById('toggleIcon');

    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleIcon.classList.remove('bi-eye-fill');
        toggleIcon.classList.add('bi-eye-slash-fill');
    } else {
        passwordInput.type = 'password';
        toggleIcon.classList.remove('bi-eye-slash-fill');
        toggleIcon.classList.add('bi-eye-fill');
    }
}

// Add focus animation to input icons
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.login-card .form-input').forEach(function (input) {
        input.addEventListener('focus', function () {
            var icon = this.closest('.input-wrapper').querySelector('.input-icon');
            if (icon) icon.style.color = '#3478F6';
        });
        input.addEventListener('blur', function () {
            var icon = this.closest('.input-wrapper').querySelector('.input-icon');
            if (icon) icon.style.color = '';
        });
    });

    // Form submit animation
    var loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function () {
            var btn = this.querySelector('button[type="submit"]');
            if (btn) {
                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>';
                btn.disabled = true;
            }
            // Disable the other button too
            var btns = this.querySelectorAll('.login-actions button');
            btns.forEach(function (b) { b.disabled = true; });
        });
    }
});
