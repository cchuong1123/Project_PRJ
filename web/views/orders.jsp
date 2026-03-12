<%-- Document : orders  Created on : Mar 12, 2026  Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đơn hàng - MotoFix Pro</title>

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
                <button class="btn-create-order" onclick="openCreateModal()">
                    <i class="bi bi-plus-lg"></i> Tạo đơn
                </button>
            </nav>

            <!-- Main Content -->
            <main class="dashboard-main">

                <!-- Status Summary -->
                <div class="orders-summary">
                    <div class="summary-mini">
                        <div class="summary-mini-value">${orders.size()}</div>
                        <div class="summary-mini-label">Tất cả</div>
                    </div>
                    <c:set var="cTiepNhan" value="0"/>
                    <c:set var="cDangSua" value="0"/>
                    <c:set var="cChoPhutung" value="0"/>
                    <c:set var="cHoanThanh" value="0"/>
                    <c:set var="cDaGiao" value="0"/>
                    <c:forEach var="o" items="${orders}">
                        <c:if test="${o.status == 'Tiếp nhận'}"><c:set var="cTiepNhan" value="${cTiepNhan + 1}"/></c:if>
                        <c:if test="${o.status == 'Đang sửa'}"><c:set var="cDangSua" value="${cDangSua + 1}"/></c:if>
                        <c:if test="${o.status == 'Chờ phụ tùng'}"><c:set var="cChoPhutung" value="${cChoPhutung + 1}"/></c:if>
                        <c:if test="${o.status == 'Hoàn thành'}"><c:set var="cHoanThanh" value="${cHoanThanh + 1}"/></c:if>
                        <c:if test="${o.status == 'Đã giao'}"><c:set var="cDaGiao" value="${cDaGiao + 1}"/></c:if>
                    </c:forEach>
                    <div class="summary-mini"><div class="summary-mini-value" style="color:var(--info)">${cTiepNhan}</div><div class="summary-mini-label">Tiếp nhận</div></div>
                    <div class="summary-mini"><div class="summary-mini-value" style="color:var(--warning)">${cDangSua}</div><div class="summary-mini-label">Đang sửa</div></div>
                    <div class="summary-mini"><div class="summary-mini-value" style="color:var(--success)">${cHoanThanh}</div><div class="summary-mini-label">Hoàn thành</div></div>
                    <div class="summary-mini"><div class="summary-mini-value" style="color:var(--text-muted)">${cDaGiao}</div><div class="summary-mini-label">Đã giao</div></div>
                </div>

                <!-- Status Filter Tabs -->
                <div class="status-tabs">
                    <a href="Orders" class="status-tab ${empty filterStatus && empty keyword ? 'active' : ''}">Tất cả</a>
                    <a href="Orders?status=Tiếp nhận" class="status-tab ${filterStatus == 'Tiếp nhận' ? 'active' : ''}">Tiếp nhận</a>
                    <a href="Orders?status=Đang sửa" class="status-tab ${filterStatus == 'Đang sửa' ? 'active' : ''}">Đang sửa</a>
                    <a href="Orders?status=Chờ phụ tùng" class="status-tab ${filterStatus == 'Chờ phụ tùng' ? 'active' : ''}">Chờ phụ tùng</a>
                    <a href="Orders?status=Hoàn thành" class="status-tab ${filterStatus == 'Hoàn thành' ? 'active' : ''}">Hoàn thành</a>
                    <a href="Orders?status=Đã giao" class="status-tab ${filterStatus == 'Đã giao' ? 'active' : ''}">Đã giao</a>
                </div>

                <!-- Header + Toolbar -->
                <div class="orders-header">
                    <h2><i class="bi bi-receipt"></i> Phiếu sửa chữa</h2>
                    <div class="orders-toolbar">
                        <form action="Orders" method="GET" class="orders-search">
                            <i class="bi bi-search input-icon"></i>
                            <input type="text" name="keyword" placeholder="Tìm theo KH, biển số, SĐT..."
                                value="${keyword}">
                        </form>
                        <button class="btn btn-primary btn-sm" onclick="openCreateModal()">
                            <i class="bi bi-plus-lg"></i> Tạo đơn mới
                        </button>
                    </div>
                </div>

                <!-- Orders Table -->
                <div class="table-wrapper">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Khách hàng</th>
                                <th>Xe</th>
                                <th>Thợ phụ trách</th>
                                <th>Trạng thái</th>
                                <th>Công thợ</th>
                                <th>Ngày tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td><span style="font-weight:700; color:var(--primary)">#${o.orderID}</span></td>
                                    <td>
                                        <div style="font-weight:600; color:var(--text-heading)">${o.customerName}</div>
                                        <div style="font-size:var(--font-size-xs); color:var(--text-muted)">${o.customerPhone}</div>
                                    </td>
                                    <td>
                                        <span class="sku-code">${o.vehiclePlate}</span>
                                        <div style="font-size:var(--font-size-xs); color:var(--text-muted); margin-top:2px">${o.vehicleInfo}</div>
                                    </td>
                                    <td>${o.mechanicName}</td>
                                    <td>
                                        <c:set var="statusClass" value=""/>
                                        <c:if test="${o.status == 'Tiếp nhận'}"><c:set var="statusClass" value="status-tiepnhan"/></c:if>
                                        <c:if test="${o.status == 'Đang sửa'}"><c:set var="statusClass" value="status-dangsua"/></c:if>
                                        <c:if test="${o.status == 'Chờ phụ tùng'}"><c:set var="statusClass" value="status-chophutung"/></c:if>
                                        <c:if test="${o.status == 'Hoàn thành'}"><c:set var="statusClass" value="status-hoanthanh"/></c:if>
                                        <c:if test="${o.status == 'Đã giao'}"><c:set var="statusClass" value="status-dagiao"/></c:if>
                                        <span class="status-badge ${statusClass}">${o.status}</span>
                                    </td>
                                    <td style="font-weight:600">
                                        <fmt:formatNumber value="${o.laborCost}" type="number" groupingUsed="true"/>đ
                                    </td>
                                    <td style="font-size:var(--font-size-xs); color:var(--text-muted)">
                                        <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td>
                                        <div class="table-actions">
                                            <a href="Orders?action=detail&id=${o.orderID}"
                                                class="btn btn-primary btn-icon-sm" title="Chi tiết">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <a href="Orders?action=delete&id=${o.orderID}"
                                                class="btn btn-danger btn-icon-sm" title="Xóa"
                                                onclick="return confirm('Xóa phiếu sửa chữa #${o.orderID}? Tất cả phụ tùng và hóa đơn liên quan sẽ bị xóa.')">
                                                <i class="bi bi-trash3"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="8" class="text-center" style="padding:40px">
                                        <div class="empty-state">
                                            <i class="bi bi-clipboard-x" style="display:block"></i>
                                            <h3>Chưa có phiếu sửa chữa nào</h3>
                                            <p>Nhấn "Tạo đơn" để bắt đầu.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>

            <!-- Create Order Modal -->
            <div class="modal-overlay" id="createOrderModal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3><i class="bi bi-plus-circle"></i> Tạo phiếu sửa chữa</h3>
                        <button class="modal-close" onclick="closeCreateModal()">
                            <i class="bi bi-x-lg"></i>
                        </button>
                    </div>
                    <form action="Orders" method="POST" class="modal-form">
                        <input type="hidden" name="action" value="create">

                        <div class="form-group">
                            <label class="form-label">Chọn xe (Biển số — Khách hàng) *</label>
                            <select class="form-input-plain" name="vehicleID" required>
                                <option value="">-- Chọn xe --</option>
                                <c:forEach var="v" items="${allVehicles}">
                                    <option value="${v.vehicleID}">
                                        ${v.licensePlate} — ${v.customerName}
                                        <c:if test="${not empty v.brand}"> (${v.brand} ${v.model})</c:if>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Thợ phụ trách *</label>
                            <select class="form-input-plain" name="mechanicID" required>
                                <option value="">-- Chọn thợ --</option>
                                <c:forEach var="m" items="${mechanics}">
                                    <option value="${m.userID}">${m.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Mô tả sự cố</label>
                            <textarea class="form-input-plain" name="description" rows="3"
                                placeholder="Mô tả tình trạng xe, yêu cầu sửa chữa..."></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Công thợ (VNĐ)</label>
                            <input type="number" class="form-input-plain" name="laborCost"
                                step="1000" min="0" value="0">
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary btn-sm" onclick="closeCreateModal()">Hủy</button>
                            <button type="submit" class="btn btn-primary btn-sm">
                                <i class="bi bi-plus-lg"></i> Tạo phiếu
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                function openCreateModal() {
                    document.getElementById('createOrderModal').classList.add('active');
                }
                function closeCreateModal() {
                    document.getElementById('createOrderModal').classList.remove('active');
                }
                document.getElementById('createOrderModal').addEventListener('click', function(e) {
                    if (e.target === this) closeCreateModal();
                });
            </script>
        </body>
        </html>
