<%-- Document : order-detail  Created on : Mar 12, 2026  Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đơn #${order.orderID} - MotoFix Pro</title>

            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
                rel="stylesheet">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet">

            <link href="static/css/style.css" rel="stylesheet">
            <link href="static/css/dashboard.css" rel="stylesheet">
            <link href="static/css/orders.css" rel="stylesheet">
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
                    <a href="Parts" class="secondary-navbar-link">
                        <i class="bi bi-box-seam-fill"></i> Hàng hóa
                    </a>
                    <a href="Orders" class="secondary-navbar-link active">
                        <i class="bi bi-receipt"></i> Đơn hàng
                    </a>
                    <a href="Customers" class="secondary-navbar-link">
                        <i class="bi bi-people-fill"></i> Khách hàng
                    </a>
                </div>
                <a href="Orders" class="btn-create-order">
                    <i class="bi bi-arrow-left"></i> Danh sách
                </a>
            </nav>

            <!-- Main Content -->
            <main class="dashboard-main">

                <a href="Orders" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                </a>

                <div class="orders-header" style="margin-bottom: var(--spacing-md)">
                    <h2>
                        <i class="bi bi-receipt"></i> Phiếu #${order.orderID}
                        <c:set var="statusClass" value=""/>
                        <c:if test="${order.status == 'Tiếp nhận'}"><c:set var="statusClass" value="status-tiepnhan"/></c:if>
                        <c:if test="${order.status == 'Đang sửa'}"><c:set var="statusClass" value="status-dangsua"/></c:if>
                        <c:if test="${order.status == 'Chờ phụ tùng'}"><c:set var="statusClass" value="status-chophutung"/></c:if>
                        <c:if test="${order.status == 'Hoàn thành'}"><c:set var="statusClass" value="status-hoanthanh"/></c:if>
                        <c:if test="${order.status == 'Đã giao'}"><c:set var="statusClass" value="status-dagiao"/></c:if>
                        <span class="status-badge ${statusClass}">${order.status}</span>
                    </h2>
                </div>

                <div class="order-detail">
                    <!-- Left Column: Info + Parts -->
                    <div>
                        <!-- Order Info -->
                        <div class="detail-card" style="margin-bottom: var(--spacing-lg)">
                            <h3><i class="bi bi-info-circle-fill"></i> Thông tin phiếu</h3>
                            <div class="detail-info-grid">
                                <div class="detail-info-item">
                                    <span class="detail-info-label">Khách hàng</span>
                                    <span class="detail-info-value">${order.customerName}</span>
                                </div>
                                <div class="detail-info-item">
                                    <span class="detail-info-label">SĐT</span>
                                    <span class="detail-info-value">${order.customerPhone}</span>
                                </div>
                                <div class="detail-info-item">
                                    <span class="detail-info-label">Biển số</span>
                                    <span class="detail-info-value">${order.vehiclePlate}</span>
                                </div>
                                <div class="detail-info-item">
                                    <span class="detail-info-label">Xe</span>
                                    <span class="detail-info-value">${order.vehicleInfo}</span>
                                </div>
                                <div class="detail-info-item">
                                    <span class="detail-info-label">Thợ phụ trách</span>
                                    <span class="detail-info-value">${order.mechanicName}</span>
                                </div>
                                <div class="detail-info-item">
                                    <span class="detail-info-label">Ngày tạo</span>
                                    <span class="detail-info-value">
                                        <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>
                            </div>
                            <c:if test="${not empty order.description}">
                                <div style="margin-top: var(--spacing-md); padding-top: var(--spacing-md); border-top: 1px solid var(--card-border)">
                                    <span class="detail-info-label">Mô tả sự cố</span>
                                    <p style="margin-top:4px; color:var(--text-primary); font-size:var(--font-size-sm)">${order.description}</p>
                                </div>
                            </c:if>

                            <!-- Status Workflow -->
                            <c:if test="${order.status != 'Đã giao'}">
                                <div style="margin-top: var(--spacing-md); padding-top: var(--spacing-md); border-top: 1px solid var(--card-border)">
                                    <span class="detail-info-label">Chuyển trạng thái</span>
                                    <div class="status-workflow">
                                        <c:if test="${order.status == 'Tiếp nhận'}">
                                            <form action="Orders" method="POST" style="display:inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="orderID" value="${order.orderID}">
                                                <input type="hidden" name="newStatus" value="Đang sửa">
                                                <button type="submit" class="btn btn-warning btn-sm">
                                                    <i class="bi bi-wrench"></i> Bắt đầu sửa
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${order.status == 'Đang sửa'}">
                                            <form action="Orders" method="POST" style="display:inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="orderID" value="${order.orderID}">
                                                <input type="hidden" name="newStatus" value="Chờ phụ tùng">
                                                <button type="submit" class="btn btn-outline btn-sm" style="color:#9c27b0; border-color:#9c27b0">
                                                    <i class="bi bi-pause-circle"></i> Chờ phụ tùng
                                                </button>
                                            </form>
                                            <form action="Orders" method="POST" style="display:inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="orderID" value="${order.orderID}">
                                                <input type="hidden" name="newStatus" value="Hoàn thành">
                                                <button type="submit" class="btn btn-success btn-sm">
                                                    <i class="bi bi-check-circle"></i> Hoàn thành
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${order.status == 'Chờ phụ tùng'}">
                                            <form action="Orders" method="POST" style="display:inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="orderID" value="${order.orderID}">
                                                <input type="hidden" name="newStatus" value="Đang sửa">
                                                <button type="submit" class="btn btn-warning btn-sm">
                                                    <i class="bi bi-wrench"></i> Tiếp tục sửa
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${order.status == 'Hoàn thành'}">
                                            <form action="Orders" method="POST" style="display:inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="orderID" value="${order.orderID}">
                                                <input type="hidden" name="newStatus" value="Đã giao">
                                                <button type="submit" class="btn btn-primary btn-sm">
                                                    <i class="bi bi-box-arrow-right"></i> Giao xe
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <!-- Parts Used -->
                        <div class="detail-card order-parts-table">
                            <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom: var(--spacing-md)">
                                <h3 style="margin-bottom:0"><i class="bi bi-box-seam"></i> Phụ tùng sử dụng</h3>
                                <c:if test="${order.status != 'Hoàn thành' && order.status != 'Đã giao'}">
                                    <button class="btn btn-primary btn-sm" onclick="openAddPartModal()">
                                        <i class="bi bi-plus-lg"></i> Thêm phụ tùng
                                    </button>
                                </c:if>
                            </div>
                            <table class="table-custom">
                                <thead>
                                    <tr>
                                        <th>Phụ tùng</th>
                                        <th>Mã SKU</th>
                                        <th>SL</th>
                                        <th>Đơn giá</th>
                                        <th>Thành tiền</th>
                                        <c:if test="${order.status != 'Hoàn thành' && order.status != 'Đã giao'}">
                                            <th></th>
                                        </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="op" items="${orderParts}">
                                        <tr>
                                            <td style="font-weight:600">${op.partName}</td>
                                            <td><span class="sku-code">${op.sku}</span></td>
                                            <td>${op.quantity}</td>
                                            <td><fmt:formatNumber value="${op.unitPrice}" type="number" groupingUsed="true"/>đ</td>
                                            <td style="font-weight:700; color:var(--text-heading)">
                                                <fmt:formatNumber value="${op.total}" type="number" groupingUsed="true"/>đ
                                            </td>
                                            <c:if test="${order.status != 'Hoàn thành' && order.status != 'Đã giao'}">
                                                <td>
                                                    <a href="Orders?action=removePart&orderId=${order.orderID}&partId=${op.partID}"
                                                        class="btn btn-danger btn-icon-sm"
                                                        onclick="return confirm('Xóa phụ tùng này khỏi đơn?')">
                                                        <i class="bi bi-trash3"></i>
                                                    </a>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty orderParts}">
                                        <tr>
                                            <td colspan="6" class="text-center" style="padding:20px; color:var(--text-muted); font-style:italic">
                                                Chưa có phụ tùng nào.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                                <tfoot>
                                    <tr style="font-weight:700; border-top: 2px solid var(--card-border)">
                                        <td colspan="4" style="text-align:right">Tổng phụ tùng:</td>
                                        <td colspan="2">
                                            <fmt:formatNumber value="${partsTotal}" type="number" groupingUsed="true"/>đ
                                        </td>
                                    </tr>
                                    <tr style="font-weight:700">
                                        <td colspan="4" style="text-align:right">Công thợ:</td>
                                        <td colspan="2">
                                            <fmt:formatNumber value="${order.laborCost}" type="number" groupingUsed="true"/>đ
                                        </td>
                                    </tr>
                                    <tr style="font-weight:800; font-size: var(--font-size-md); color:var(--primary)">
                                        <td colspan="4" style="text-align:right">TỔNG CỘNG:</td>
                                        <td colspan="2">
                                            <fmt:formatNumber value="${grandTotal}" type="number" groupingUsed="true"/>đ
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>

                    <!-- Right Column: Invoice -->
                    <div>
                        <c:choose>
                            <c:when test="${not empty invoice}">
                                <div class="detail-card invoice-card">
                                    <h3><i class="bi bi-receipt-cutoff"></i> Hóa đơn</h3>
                                    <div class="detail-info-item" style="margin-bottom:var(--spacing-sm)">
                                        <span class="detail-info-label">Mã hóa đơn</span>
                                        <span class="detail-info-value">#${invoice.invoiceID}</span>
                                    </div>
                                    <div class="detail-info-item" style="margin-bottom:var(--spacing-sm)">
                                        <span class="detail-info-label">Phương thức</span>
                                        <span class="detail-info-value">${invoice.paymentMethod}</span>
                                    </div>
                                    <div class="detail-info-item" style="margin-bottom:var(--spacing-sm)">
                                        <span class="detail-info-label">Ngày thanh toán</span>
                                        <span class="detail-info-value">
                                            <fmt:formatDate value="${invoice.paidAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </span>
                                    </div>
                                    <div class="invoice-total">
                                        <fmt:formatNumber value="${invoice.totalAmount}" type="number" groupingUsed="true"/>đ
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="detail-card">
                                    <h3><i class="bi bi-receipt-cutoff"></i> Hóa đơn</h3>
                                    <c:choose>
                                        <c:when test="${order.status == 'Hoàn thành' || order.status == 'Đã giao'}">
                                            <p style="color:var(--text-muted); font-size:var(--font-size-sm); margin-bottom:var(--spacing-md)">
                                                Tạo hóa đơn thanh toán cho phiếu này.
                                            </p>
                                            <form action="Orders" method="POST">
                                                <input type="hidden" name="action" value="createInvoice">
                                                <input type="hidden" name="orderID" value="${order.orderID}">
                                                <div class="form-group" style="margin-bottom:var(--spacing-md)">
                                                    <label class="form-label" style="font-size:var(--font-size-xs); font-weight:600">Phương thức thanh toán</label>
                                                    <select class="form-input-plain" name="paymentMethod">
                                                        <option value="Tiền mặt">Tiền mặt</option>
                                                        <option value="Chuyển khoản">Chuyển khoản</option>
                                                    </select>
                                                </div>
                                                <div style="font-size:var(--font-size-sm); margin-bottom:var(--spacing-md)">
                                                    <div style="display:flex; justify-content:space-between; margin-bottom:4px">
                                                        <span>Phụ tùng:</span>
                                                        <span><fmt:formatNumber value="${partsTotal}" type="number" groupingUsed="true"/>đ</span>
                                                    </div>
                                                    <div style="display:flex; justify-content:space-between; margin-bottom:4px">
                                                        <span>Công thợ:</span>
                                                        <span><fmt:formatNumber value="${order.laborCost}" type="number" groupingUsed="true"/>đ</span>
                                                    </div>
                                                    <div style="display:flex; justify-content:space-between; font-weight:800; font-size:var(--font-size-md); color:var(--primary); padding-top:8px; border-top:1px solid var(--card-border)">
                                                        <span>Tổng:</span>
                                                        <span><fmt:formatNumber value="${grandTotal}" type="number" groupingUsed="true"/>đ</span>
                                                    </div>
                                                </div>
                                                <button type="submit" class="btn btn-primary btn-sm" style="width:100%">
                                                    <i class="bi bi-receipt-cutoff"></i> Tạo hóa đơn
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <p style="color:var(--text-muted); font-size:var(--font-size-sm); font-style:italic">
                                                Hóa đơn sẽ được tạo sau khi phiếu hoàn thành.
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>

            <!-- Add Part Modal -->
            <div class="modal-overlay" id="addPartModal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3><i class="bi bi-box-seam"></i> Thêm phụ tùng</h3>
                        <button class="modal-close" onclick="closePartModal()">
                            <i class="bi bi-x-lg"></i>
                        </button>
                    </div>
                    <form action="Orders" method="POST" class="modal-form">
                        <input type="hidden" name="action" value="addPart">
                        <input type="hidden" name="orderID" value="${order.orderID}">

                        <div class="form-group">
                            <label class="form-label">Chọn phụ tùng *</label>
                            <select class="form-input-plain" name="partID" required>
                                <option value="">-- Chọn phụ tùng --</option>
                                <c:forEach var="p" items="${allParts}">
                                    <c:if test="${p.stockQty > 0}">
                                        <option value="${p.partID}">
                                            ${p.partName} (${p.sku}) — Tồn: ${p.stockQty} —
                                            <fmt:formatNumber value="${p.unitPrice}" type="number" groupingUsed="true"/>đ
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số lượng *</label>
                            <input type="number" class="form-input-plain" name="quantity" min="1" value="1" required>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary btn-sm" onclick="closePartModal()">Hủy</button>
                            <button type="submit" class="btn btn-primary btn-sm">
                                <i class="bi bi-plus-lg"></i> Thêm
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                function openAddPartModal() {
                    document.getElementById('addPartModal').classList.add('active');
                }
                function closePartModal() {
                    document.getElementById('addPartModal').classList.remove('active');
                }
                document.getElementById('addPartModal').addEventListener('click', function(e) {
                    if (e.target === this) closePartModal();
                });
            </script>
        </body>
        </html>
