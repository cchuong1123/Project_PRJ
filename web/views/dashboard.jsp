<%-- Document : dashboard Created on : Mar 11, 2026 Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard - MotoFix Pro</title>

                <!-- Bootstrap 5 CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Bootstrap Icons -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
                    rel="stylesheet">
                <!-- Google Fonts -->
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">

                <!-- Global CSS + Dashboard CSS -->
                <link href="static/css/style.css" rel="stylesheet">
                <link href="static/css/dashboard.css" rel="stylesheet">
            </head>

            <body class="dashboard-body">

                    <jsp:include page="includes/navbar.jsp" />

                    <!-- Main Content -->
                    <main class="dashboard-main">

                        <!-- Welcome Banner -->
                        <div class="welcome-banner anim-slide-up">
                            <h1><i class="bi bi-hand-thumbs-up-fill"></i> Xin chào, ${sessionScope.user.fullName}!</h1>
                            <p>Chào mừng bạn đến với hệ thống quản lý cửa hàng sửa chữa xe máy MotoFix Pro.</p>
                        </div>

                        <!-- Stats Cards -->
                        <div class="stats-grid">
                            <div class="stat-card anim-slide-up">
                                <div class="stat-card-icon blue">
                                    <i class="bi bi-people-fill"></i>
                                </div>
                                <div class="stat-card-info">
                                    <span class="stat-card-value">128</span>
                                    <span class="stat-card-label">Khách hàng</span>
                                </div>
                            </div>

                            <div class="stat-card anim-slide-up">
                                <div class="stat-card-icon green">
                                    <i class="bi bi-tools"></i>
                                </div>
                                <div class="stat-card-info">
                                    <span class="stat-card-value">42</span>
                                    <span class="stat-card-label">Đơn sửa chữa</span>
                                </div>
                            </div>

                            <div class="stat-card anim-slide-up">
                                <div class="stat-card-icon orange">
                                    <i class="bi bi-currency-dollar"></i>
                                </div>
                                <div class="stat-card-info">
                                    <span class="stat-card-value">15.6M</span>
                                    <span class="stat-card-label">Doanh thu tháng</span>
                                </div>
                            </div>

                            <div class="stat-card anim-slide-up">
                                <div class="stat-card-icon info">
                                    <i class="bi bi-person-badge-fill"></i>
                                </div>
                                <div class="stat-card-info">
                                    <span class="stat-card-value">8</span>
                                    <span class="stat-card-label">Nhân viên</span>
                                </div>
                            </div>
                        </div>



                        <!-- Recent Repairs Table -->
                        <div class="section-header">
                            <h2>Đơn sửa chữa gần đây</h2>
                            <a href="#" class="btn btn-secondary btn-sm">Xem tất cả <i
                                    class="bi bi-arrow-right"></i></a>
                        </div>

                        <div class="table-wrapper">
                            <table class="table-custom">
                                <thead>
                                    <tr>
                                        <th>Mã đơn</th>
                                        <th>Khách hàng</th>
                                        <th>Xe</th>
                                        <th>Dịch vụ</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>#SC001</strong></td>
                                        <td>Nguyễn Văn A</td>
                                        <td>Honda Wave 110i</td>
                                        <td>Thay nhớt, kiểm tra phanh</td>
                                        <td><span class="badge badge-warning">Đang xử lý</span></td>
                                        <td>11/03/2026</td>
                                    </tr>
                                    <tr>
                                        <td><strong>#SC002</strong></td>
                                        <td>Trần Thị B</td>
                                        <td>Yamaha Exciter 155</td>
                                        <td>Sửa động cơ</td>
                                        <td><span class="badge badge-primary">Chờ phụ tùng</span></td>
                                        <td>10/03/2026</td>
                                    </tr>
                                    <tr>
                                        <td><strong>#SC003</strong></td>
                                        <td>Lê Văn C</td>
                                        <td>Honda SH 150i</td>
                                        <td>Bảo dưỡng định kỳ</td>
                                        <td><span class="badge badge-success">Hoàn thành</span></td>
                                        <td>09/03/2026</td>
                                    </tr>
                                    <tr>
                                        <td><strong>#SC004</strong></td>
                                        <td>Phạm Thị D</td>
                                        <td>Honda Vision</td>
                                        <td>Thay lốp, căn chỉnh</td>
                                        <td><span class="badge badge-success">Hoàn thành</span></td>
                                        <td>08/03/2026</td>
                                    </tr>
                                    <tr>
                                        <td><strong>#SC005</strong></td>
                                        <td>Hoàng Văn E</td>
                                        <td>Suzuki Raider 150</td>
                                        <td>Sơn lại xe</td>
                                        <td><span class="badge badge-danger">Đã huỷ</span></td>
                                        <td>07/03/2026</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                    </main>

                    <!-- Bootstrap JS -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>