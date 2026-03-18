<%-- Document : dashboard Created on : Mar 11, 2026 Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

                        <!-- Stats Cards -->
                        <div class="stats-grid">
                            <!-- Doanh thu hôm nay -->
                            <div class="stat-card">
                                <div class="stat-card-icon blue">
                                    <i class="bi bi-cash-stack"></i>
                                </div>
                                <div class="stat-card-info">
                                    <span class="stat-card-value"><fmt:formatNumber value="${todayRevenue}" type="number" groupingUsed="true"/>đ</span>
                                    <span class="stat-card-label">Doanh thu hôm nay</span>
                                </div>
                            </div>

                            <!-- Hóa đơn hôm nay -->
                            <div class="stat-card">
                                <div class="stat-card-icon green">
                                    <i class="bi bi-receipt"></i>
                                </div>
                                <div class="stat-card-info">
                                    <span class="stat-card-value">${todayInvoices}</span>
                                    <span class="stat-card-label">Hóa đơn hôm nay</span>
                                </div>
                            </div>

                            <!-- Xe đang sửa -->
                            <div class="stat-card">
                                <div class="stat-card-icon orange">
                                    <i class="bi bi-tools"></i>
                                </div>
                                <div class="stat-card-info">
                                    <span class="stat-card-value">${repairingCount}</span>
                                    <span class="stat-card-label">Xe đang sửa</span>
                                </div>
                            </div>
                        </div>

                        <!-- Cảnh báo tồn kho -->
                        <div class="section-header">
                            <h2><i class="bi bi-exclamation-triangle alert-icon"></i> Cảnh báo tồn kho</h2>
                        </div>

                        <div class="row g-4">
                            <!-- Phụ tùng sắp hết -->
                            <div class="col-md-6">
                                <div class="alert-card">
                                    <div class="alert-card-header warning">
                                        <strong class="text-alert-warning"><i class="bi bi-exclamation-triangle-fill"></i> Phụ tùng sắp hết (${lowStockParts.size()})</strong>
                                    </div>
                                    <table class="table table-hover mb-0 alert-table">
                                        <thead>
                                            <tr>
                                                <th>Tên phụ tùng</th>
                                                <th>Mã SKU</th>
                                                <th class="text-end">Tồn kho</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="p" items="${lowStockParts}">
                                                <tr>
                                                    <td class="part-name">${p.partName}</td>
                                                    <td><span class="sku-code">${p.sku}</span></td>
                                                    <td class="text-end">
                                                        <span class="badge-alert-warning">${p.stockQty}</span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty lowStockParts}">
                                                <tr><td colspan="3" class="text-center text-muted empty-state">Không có phụ tùng sắp hết</td></tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Phụ tùng đã hết -->
                            <div class="col-md-6">
                                <div class="alert-card">
                                    <div class="alert-card-header danger">
                                        <strong class="text-alert-danger"><i class="bi bi-x-circle-fill"></i> Phụ tùng đã hết (${outOfStockParts.size()})</strong>
                                    </div>
                                    <table class="table table-hover mb-0 alert-table">
                                        <thead>
                                            <tr>
                                                <th>Tên phụ tùng</th>
                                                <th>Mã SKU</th>
                                                <th class="text-end">Tồn kho</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="p" items="${outOfStockParts}">
                                                <tr>
                                                    <td class="part-name">${p.partName}</td>
                                                    <td><span class="sku-code">${p.sku}</span></td>
                                                    <td class="text-end">
                                                        <span class="badge-alert-danger">0</span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty outOfStockParts}">
                                                <tr><td colspan="3" class="text-center text-muted empty-state">Không có phụ tùng đã hết</td></tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </main>

                    <!-- Bootstrap JS -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>