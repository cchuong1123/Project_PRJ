<%-- Document : parts  Created on : Mar 12, 2026  Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Hàng hóa - MotoFix Pro</title>

            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
                rel="stylesheet">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet">

            <link href="static/css/style.css" rel="stylesheet">
            <link href="static/css/dashboard.css" rel="stylesheet">
            <link href="static/css/parts.css" rel="stylesheet">
        </head>

        <body class="dashboard-body">

            <% models.User user=(models.User) session.getAttribute("user");
                String fullName=user != null ? user.getFullName() : "Người dùng";
                String role=user != null ? user.getRole() : "staff";
                String initial=fullName.length() > 0 ? fullName.substring(0, 1).toUpperCase() : "U";
                String roleDisplay = "Nhân viên";
                if ("admin".equals(role)) roleDisplay = "Quản trị viên";
                else if ("mechanic".equals(role)) roleDisplay = "Thợ sửa chữa";
            %>

            <!-- Top Navbar -->
            <nav class="top-navbar">
                <a href="Dashboard" class="top-navbar-brand">
                    <div class="top-navbar-brand-icon">
                        <i class="bi bi-droplet-fill leaf-blue"></i>
                        <i class="bi bi-droplet-fill leaf-green"></i>
                    </div>
                    <span class="top-navbar-brand-text">
                        <span class="blue">Moto</span><span class="green">Fix</span> Pro
                    </span>
                </a>
                <div class="top-navbar-right">
                    <div class="top-navbar-user">
                        <div class="top-navbar-avatar"><%= initial %></div>
                        <div class="top-navbar-user-info">
                            <span class="top-navbar-user-name"><%= fullName %></span>
                            <span class="top-navbar-user-role"><%= roleDisplay %></span>
                        </div>
                    </div>
                    <a href="Logout" class="btn-logout">
                        <i class="bi bi-box-arrow-right"></i> Đăng xuất
                    </a>
                </div>
            </nav>

            <!-- Secondary Navbar -->
            <nav class="secondary-navbar">
                <div class="secondary-navbar-links">
                    <a href="Dashboard" class="secondary-navbar-link">
                        <i class="bi bi-grid-1x2-fill"></i> Tổng quan
                    </a>
                    <a href="Parts" class="secondary-navbar-link active">
                        <i class="bi bi-box-seam-fill"></i> Hàng hóa
                    </a>
                    <a href="Orders" class="secondary-navbar-link">
                        <i class="bi bi-receipt"></i> Đơn hàng
                    </a>
                    <a href="Customers" class="secondary-navbar-link">
                        <i class="bi bi-people-fill"></i> Khách hàng
                    </a>
                </div>
                <a href="Orders" class="btn-create-order">
                    <i class="bi bi-plus-lg"></i> Tạo đơn
                </a>
            </nav>

            <!-- Main Content -->
            <main class="dashboard-main">

                <!-- Summary Cards -->
                <div class="parts-summary">
                    <div class="summary-card">
                        <div class="summary-card-icon blue">
                            <i class="bi bi-box-seam-fill"></i>
                        </div>
                        <div>
                            <div class="summary-card-value">${parts.size()}</div>
                            <div class="summary-card-label">Tổng phụ tùng</div>
                        </div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-card-icon green">
                            <i class="bi bi-check-circle-fill"></i>
                        </div>
                        <div>
                            <c:set var="inStockCount" value="0"/>
                            <c:forEach var="p" items="${parts}">
                                <c:if test="${p.stockQty >= p.minStock}">
                                    <c:set var="inStockCount" value="${inStockCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            <div class="summary-card-value">${inStockCount}</div>
                            <div class="summary-card-label">Còn hàng</div>
                        </div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-card-icon red">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                        </div>
                        <div>
                            <c:set var="lowStockCount" value="0"/>
                            <c:forEach var="p" items="${parts}">
                                <c:if test="${p.stockQty < p.minStock}">
                                    <c:set var="lowStockCount" value="${lowStockCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            <div class="summary-card-value">${lowStockCount}</div>
                            <div class="summary-card-label">Sắp hết hàng</div>
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
                        <button class="btn btn-primary btn-sm" onclick="openAddModal()">
                            <i class="bi bi-plus-lg"></i> Thêm phụ tùng
                        </button>
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
                                        <td style="font-weight:600; color:var(--text-heading)">${p.partName}</td>
                                        <td><span class="sku-code">${p.sku}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.stockQty < p.minStock}">
                                                    <span class="low-stock">${p.stockQty}</span>
                                                    <span class="low-stock-badge">
                                                        <i class="bi bi-exclamation-triangle-fill"></i> Thấp
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    ${p.stockQty}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="price">
                                            <fmt:formatNumber value="${p.importPrice}" type="number"
                                                groupingUsed="true"/>đ
                                        </td>
                                        <td class="price">
                                            <fmt:formatNumber value="${p.unitPrice}" type="number"
                                                groupingUsed="true"/>đ
                                        </td>
                                        <td>${p.minStock}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.warrantyMonths > 0}">
                                                    ${p.warrantyMonths} tháng
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color:var(--text-muted)">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="table-actions">
                                                <button class="btn btn-outline btn-icon-sm"
                                                    title="Sửa"
                                                    onclick="openEditModal(${p.partID}, '${p.partName}', '${p.sku}', ${p.stockQty}, ${p.importPrice}, ${p.unitPrice}, ${p.minStock}, ${p.warrantyMonths})">
                                                    <i class="bi bi-pencil-square"></i>
                                                </button>
                                                <a href="Parts?action=delete&id=${p.partID}"
                                                    class="btn btn-danger btn-icon-sm"
                                                    title="Xóa"
                                                    onclick="return confirm('Bạn có chắc muốn xóa phụ tùng này?')">
                                                    <i class="bi bi-trash3"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty parts}">
                                    <tr>
                                        <td colspan="8" class="text-center" style="padding:40px;">
                                            <div class="empty-state">
                                                <i class="bi bi-inbox" style="display:block"></i>
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

            </main>

            <!-- Add/Edit Modal -->
            <div class="modal-overlay" id="partModal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 id="modalTitle">Thêm phụ tùng</h3>
                        <button class="modal-close" onclick="closeModal()">
                            <i class="bi bi-x-lg"></i>
                        </button>
                    </div>
                    <form action="Parts" method="POST" class="modal-form">
                        <input type="hidden" name="action" id="formAction" value="addPart">
                        <input type="hidden" name="partID" id="formPartID">

                        <div class="form-group">
                            <label class="form-label">Tên phụ tùng *</label>
                            <input type="text" class="form-input-plain" name="partName" id="formPartName" required>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Mã SKU *</label>
                                <input type="text" class="form-input-plain" name="sku" id="formSku" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Tồn kho *</label>
                                <input type="number" class="form-input-plain" name="stockQty" id="formStockQty"
                                    min="0" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Giá nhập (VNĐ) *</label>
                                <input type="number" class="form-input-plain" name="importPrice" id="formImportPrice"
                                    step="1000" min="0" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Giá bán (VNĐ) *</label>
                                <input type="number" class="form-input-plain" name="unitPrice" id="formUnitPrice"
                                    step="1000" min="0" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Ngưỡng tối thiểu</label>
                                <input type="number" class="form-input-plain" name="minStock" id="formMinStock"
                                    min="0" value="5">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Bảo hành (tháng)</label>
                                <input type="number" class="form-input-plain" name="warrantyMonths" id="formWarrantyMonths"
                                    min="0" value="0" placeholder="0 = không bảo hành">
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary btn-sm" onclick="closeModal()">Hủy</button>
                            <button type="submit" class="btn btn-primary btn-sm" id="modalSubmitBtn">
                                <i class="bi bi-plus-lg"></i> Thêm
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                function openAddModal() {
                    document.getElementById('modalTitle').textContent = 'Thêm phụ tùng';
                    document.getElementById('formAction').value = 'addPart';
                    document.getElementById('formPartID').value = '';
                    document.getElementById('formPartName').value = '';
                    document.getElementById('formSku').value = '';
                    document.getElementById('formStockQty').value = '';
                    document.getElementById('formImportPrice').value = '';
                    document.getElementById('formUnitPrice').value = '';
                    document.getElementById('formMinStock').value = '5';
                    document.getElementById('formWarrantyMonths').value = '0';
                    document.getElementById('modalSubmitBtn').innerHTML = '<i class="bi bi-plus-lg"></i> Thêm';
                    document.getElementById('partModal').classList.add('active');
                }

                function openEditModal(id, name, sku, qty, importPrice, price, min, warranty) {
                    document.getElementById('modalTitle').textContent = 'Sửa phụ tùng';
                    document.getElementById('formAction').value = 'editPart';
                    document.getElementById('formPartID').value = id;
                    document.getElementById('formPartName').value = name;
                    document.getElementById('formSku').value = sku;
                    document.getElementById('formStockQty').value = qty;
                    document.getElementById('formImportPrice').value = importPrice;
                    document.getElementById('formUnitPrice').value = price;
                    document.getElementById('formMinStock').value = min;
                    document.getElementById('formWarrantyMonths').value = warranty;
                    document.getElementById('modalSubmitBtn').innerHTML = '<i class="bi bi-check-lg"></i> Lưu';
                    document.getElementById('partModal').classList.add('active');
                }

                function closeModal() {
                    document.getElementById('partModal').classList.remove('active');
                }

                // Close modal on overlay click
                document.getElementById('partModal').addEventListener('click', function(e) {
                    if (e.target === this) closeModal();
                });
            </script>
        </body>
        </html>
