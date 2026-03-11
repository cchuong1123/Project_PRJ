<%-- Document : login Created on : Mar 11, 2026, 12:20:24 AM Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đăng nhập - Quản lý Cửa hàng Sửa chữa Xe máy</title>

            <!-- Bootstrap 5 CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Bootstrap Icons -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
                rel="stylesheet">
            <!-- Google Fonts -->
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet">

            <!-- Global CSS + Login CSS -->
            <link href="static/css/style.css" rel="stylesheet">
            <link href="static/css/login.css" rel="stylesheet">
        </head>

        <body class="login-body">
            <!-- Background image with overlay -->
            <div class="login-bg"></div>

            <!-- Login Content -->
            <div class="login-wrapper">

                <!-- Login Card (white) -->
                <div class="login-card">
                    <!-- Brand logo -->
                    <div class="login-brand">
                        <div class="login-brand-logo">
                            <div class="login-brand-icon">
                                <i class="bi bi-droplet-fill leaf-blue"></i>
                                <i class="bi bi-droplet-fill leaf-green"></i>
                            </div>
                            <span class="login-brand-text">
                                <span class="blue">Moto</span><span class="green">Fix</span>
                            </span>
                        </div>
                    </div>

                    <!-- Error message -->
                    <% String error=(String) request.getAttribute("error"); %>
                        <% if (error !=null) { %>
                            <div class="alert alert-error anim-shake">
                                <i class="bi bi-exclamation-triangle-fill"></i>
                                <span>
                                    <%= error %>
                                </span>
                            </div>
                            <% } %>

                                <form action="Login" method="POST" id="loginForm">
                                    <!-- Username -->
                                    <div class="form-group input-group-top">
                                        <div class="input-wrapper">
                                            <i class="bi bi-person-fill input-icon"></i>
                                            <input type="text" class="form-input" id="username" name="username"
                                                placeholder="Tên đăng nhập" required autocomplete="username">
                                        </div>
                                    </div>

                                    <!-- Password -->
                                    <div class="form-group input-group-bottom">
                                        <div class="input-wrapper">
                                            <i class="bi bi-lock-fill input-icon"></i>
                                            <input type="password" class="form-input form-input-password" id="password"
                                                name="password" placeholder="Mật khẩu" required
                                                autocomplete="current-password">
                                            <button type="button" class="password-toggle" onclick="togglePassword()"
                                                id="toggleBtn">
                                                <i class="bi bi-eye-fill" id="toggleIcon"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Options -->
                                    <div class="form-options">
                                        <label class="form-check">
                                            <input type="checkbox" name="remember" value="true">
                                            <span class="checkmark"></span>
                                            <span>Duy trì đăng nhập</span>
                                        </label>
                                        <a href="#" class="forgot-link">Quên mật khẩu?</a>
                                    </div>

                                    <!-- Submit -->
                                    <button type="submit" class="btn btn-primary btn-lg btn-block">
                                        Đăng nhập
                                        <i class="bi bi-arrow-right"></i>
                                    </button>
                                </form>
                </div>

            </div>

            <!-- Footer bar -->
            <div class="login-footer">
                <span><i class="bi bi-telephone-fill"></i> Hỗ trợ 1900 0000</span>
                <span>&copy; 2026 MotoFix Pro</span>
            </div>

            <!-- Bootstrap JS + Login JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="static/js/login.js"></script>
        </body>

        </html>