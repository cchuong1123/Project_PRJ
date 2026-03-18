<%-- Document : parts Created on : Mar 12, 2026 Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Hàng hóa - MotoFix Pro</title>

                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
                        rel="stylesheet">
                    <link
                        href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                        rel="stylesheet">

                    <link href="static/css/style.css" rel="stylesheet">
                    <link href="static/css/dashboard.css" rel="stylesheet">
                    <link href="static/css/parts.css" rel="stylesheet">
                </head>

                <body class="dashboard-body">

                    <jsp:include page="includes/navbar.jsp" />

                    <!-- Main Content -->
                    <main class="dashboard-main">

                        <!-- Summary Cards -->
                        <div class="parts-summary">
                            <div class="summary-card">
                                <div class="summary-card-icon blue">
                                    <i class="bi bi-box-seam-fill"></i>
                                </div>
                                <div>
                                    <div class="summary-card-value">${totalParts}</div>
                                    <div class="summary-card-label">Tổng phụ tùng</div>
                                </div>
                            </div>
                            <div class="summary-card">
                                <div class="summary-card-icon green">
                                    <i class="bi bi-check-circle-fill"></i>
                                </div>
                                <div>
                                    <div class="summary-card-value">${inStockCount}</div>
                                    <div class="summary-card-label">Còn hàng</div>
                                </div>
                            </div>
                            <div class="summary-card">
                                <div class="summary-card-icon orange">
                                    <i class="bi bi-exclamation-triangle-fill"></i>
                                </div>
                                <div>
                                    <div class="summary-card-value">${lowStockCount}</div>
                                    <div class="summary-card-label">Sắp hết hàng</div>
                                </div>
                            </div>
                            <div class="summary-card">
                                <div class="summary-card-icon red">
                                    <i class="bi bi-x-circle-fill"></i>
                                </div>
                                <div>
                                    <div class="summary-card-value">${outOfStockCount}</div>
                                    <div class="summary-card-label">Hết hàng</div>
                                </div>
                            </div>
                        </div>

                        <!-- Header + Toolbar -->
                        <div class="parts-header">
                            <h2><i class="bi bi-box-seam-fill"></i> Quản lý phụ tùng</h2>
                            <div class="parts-toolbar">
                                <form action="Parts" method="GET" class="parts-search">
                                    <i class="bi bi-search input-icon"></i>
                                    <input type="text" name="keyword" placeholder="Tìm theo tên, mã SKU..."
                                        value="${keyword}">
                                </form>
                                <a href="Parts?action=addPart" class="btn btn-primary btn-sm">
                                    <i class="bi bi-plus-lg"></i> Thêm phụ tùng
                                </a>
                            </div>
                        </div>

                        <!-- Parts Table -->
                        <div class="parts-table">
                            <div class="table-wrapper">
                                <table class="table-custom">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Tên phụ tùng</th>
                                            <th>Mã SKU</th>
                                            <th>Tồn kho</th>
                                            <th>Giá nhập</th>
                                            <th>Giá bán</th>
                                            <th>Ngưỡng tối thiểu</th>
                                            <th>BH (tháng)</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${parts}" varStatus="loop">
                                            <tr>
                                                <td>${loop.index + 1}</td>
                                                <td class="font-semibold text-heading">${p.partName}
                                                </td>
                                                <td><span class="sku-code">${p.sku}</span></td>
                                                <td>
                                                    ${p.stockQty}
                                                </td>
                                                <td class="price">
                                                    <fmt:formatNumber value="${p.importPrice}" type="number"
                                                        groupingUsed="true" />đ
                                                </td>
                                                <td class="price">
                                                    <fmt:formatNumber value="${p.unitPrice}" type="number"
                                                        groupingUsed="true" />đ
                                                </td>
                                                <td>${p.minStock}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.warrantyMonths > 0}">
                                                            ${p.warrantyMonths} tháng
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">—</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="table-actions">
                                                        <a href="Parts?action=editPart&id=${p.partID}"
                                                            class="btn btn-outline btn-icon-sm" title="Sửa">
                                                            <i class="bi bi-pencil-square"></i>
                                                        </a>
                                                        <a href="Parts?action=delete&id=${p.partID}"
                                                            class="btn btn-danger btn-icon-sm" title="Xóa"
                                                            onclick="return confirm('Bạn có chắc muốn xóa phụ tùng này?')">
                                                            <i class="bi bi-trash3"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty parts}">
                                            <tr>
                                                <td colspan="8" class="text-center p-xl">
                                                    <div class="empty-state">
                                                        <i class="bi bi-inbox d-block"></i>
                                                        <h3>Không tìm thấy phụ tùng</h3>
                                                        <p>Thử tìm kiếm với từ khóa khác hoặc thêm phụ tùng mới.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="flex flex-center items-center gap-sm mt-lg py-md">
                                <c:set var="pageParams" value="" />
                                <c:if test="${not empty keyword}">
                                    <c:set var="pageParams" value="&keyword=${keyword}" />
                                </c:if>

                                <c:if test="${currentPage > 1}">
                                    <a href="Parts?page=${currentPage - 1}${pageParams}" class="btn btn-outline btn-sm">
                                        <i class="bi bi-chevron-left"></i> Trước
                                    </a>
                                </c:if>

                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <a href="Parts?page=${i}${pageParams}"
                                        class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline'} min-w-36 text-center">${i}</a>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <a href="Parts?page=${currentPage + 1}${pageParams}" class="btn btn-outline btn-sm">
                                        Sau <i class="bi bi-chevron-right"></i>
                                    </a>
                                </c:if>
                            </div>
                        </c:if>

                    </main>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>