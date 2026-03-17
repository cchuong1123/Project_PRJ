<%-- Document : orders Created on : Mar 12, 2026 Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <%@ taglib prefix="mt" tagdir="/WEB-INF/tags" %>
                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Đơn hàng - MotoFix Pro</title>

                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
                            rel="stylesheet">
                        <link
                            href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                            rel="stylesheet">

                        <link href="static/css/style.css" rel="stylesheet">
                        <link href="static/css/dashboard.css" rel="stylesheet">
                        <link href="static/css/orders.css" rel="stylesheet">
                    </head>

                    <body class="dashboard-body">

                        <jsp:include page="includes/navbar.jsp" />

                        <!-- Main Content -->
                        <main class="dashboard-main">

                            <!-- Status Summary -->
                            <div class="orders-summary">
                                <div class="summary-mini">
                                    <div class="summary-mini-value">${totalOrders}</div>
                                    <div class="summary-mini-label">Tất cả</div>
                                </div>
                                <c:set var="cTiepNhan" value="0" />
                                <c:set var="cDangSua" value="0" />
                                <c:set var="cChoPhutung" value="0" />
                                <c:set var="cHoanThanh" value="0" />
                                <c:set var="cDaGiao" value="0" />
                                <c:forEach var="o" items="${orders}">
                                    <c:if test="${o.status == 'Tiếp nhận'}">
                                        <c:set var="cTiepNhan" value="${cTiepNhan + 1}" />
                                    </c:if>
                                    <c:if test="${o.status == 'Đang sửa'}">
                                        <c:set var="cDangSua" value="${cDangSua + 1}" />
                                    </c:if>
                                    <c:if test="${o.status == 'Chờ phụ tùng'}">
                                        <c:set var="cChoPhutung" value="${cChoPhutung + 1}" />
                                    </c:if>
                                    <c:if test="${o.status == 'Hoàn thành'}">
                                        <c:set var="cHoanThanh" value="${cHoanThanh + 1}" />
                                    </c:if>
                                    <c:if test="${o.status == 'Đã giao'}">
                                        <c:set var="cDaGiao" value="${cDaGiao + 1}" />
                                    </c:if>
                                </c:forEach>
                                <div class="summary-mini">
                                    <div class="summary-mini-value" style="color:var(--info)">${cTiepNhan}</div>
                                    <div class="summary-mini-label">Tiếp nhận</div>
                                </div>
                                <div class="summary-mini">
                                    <div class="summary-mini-value" style="color:var(--warning)">${cDangSua}</div>
                                    <div class="summary-mini-label">Đang sửa</div>
                                </div>
                                <div class="summary-mini">
                                    <div class="summary-mini-value" style="color:var(--success)">${cHoanThanh}</div>
                                    <div class="summary-mini-label">Hoàn thành</div>
                                </div>
                                <div class="summary-mini">
                                    <div class="summary-mini-value" style="color:var(--text-muted)">${cDaGiao}</div>
                                    <div class="summary-mini-label">Đã giao</div>
                                </div>
                            </div>

                            <!-- Status Filter Tabs -->
                            <div class="status-tabs">
                                <a href="Orders"
                                    class="status-tab ${empty filterStatus && empty keyword ? 'active' : ''}">Tất cả</a>
                                <a href="Orders?status=Tiếp nhận"
                                    class="status-tab ${filterStatus == 'Tiếp nhận' ? 'active' : ''}">Tiếp nhận</a>
                                <a href="Orders?status=Đang sửa"
                                    class="status-tab ${filterStatus == 'Đang sửa' ? 'active' : ''}">Đang sửa</a>
                                <a href="Orders?status=Chờ phụ tùng"
                                    class="status-tab ${filterStatus == 'Chờ phụ tùng' ? 'active' : ''}">Chờ phụ
                                    tùng</a>
                                <a href="Orders?status=Hoàn thành"
                                    class="status-tab ${filterStatus == 'Hoàn thành' ? 'active' : ''}">Hoàn thành</a>
                                <a href="Orders?status=Đã giao"
                                    class="status-tab ${filterStatus == 'Đã giao' ? 'active' : ''}">Đã giao</a>
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
                                    <a href="Orders?action=createOrder" class="btn btn-primary btn-sm">
                                        <i class="bi bi-plus-lg"></i> Tạo đơn mới
                                    </a>
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
                                            <th>Tiền phụ tùng</th>
                                            <th>Phí Dịch Vụ</th>
                                            <th>Ngày tạo</th>
                                            <th>Khách phải trả</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="o" items="${orders}">
                                            <tr>
                                                <td><span
                                                        style="font-weight:700; color:var(--primary)">#${o.orderID}</span>
                                                </td>
                                                <td>
                                                    <div style="font-weight:600; color:var(--text-heading)">
                                                        ${o.customerName}</div>
                                                    <div style="font-size:var(--font-size-xs); color:var(--text-muted)">
                                                        ${o.customerPhone}</div>
                                                </td>
                                                <td>
                                                    <span class="sku-code">${o.vehiclePlate}</span>
                                                    <div
                                                        style="font-size:var(--font-size-xs); color:var(--text-muted); margin-top:2px">
                                                        ${o.vehicleInfo}</div>
                                                </td>
                                                <td>${o.mechanicName}</td>
                                                <td>
                                                    <mt:statusBadge status="${o.status}" />
                                                </td>
                                                <td style="font-weight:600">
                                                    <fmt:formatNumber value="${o.partsTotal}" type="number"
                                                        groupingUsed="true" />đ
                                                </td>
                                                <td style="font-weight:600">
                                                    <fmt:formatNumber value="${o.laborCost}" type="number"
                                                        groupingUsed="true" />đ
                                                </td>
                                                <td style="font-size:var(--font-size-xs); color:var(--text-muted)">
                                                    <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </td>
                                                <td style="font-weight:700; color:var(--primary)">
                                                    <fmt:formatNumber value="${o.partsTotal + o.laborCost}"
                                                        type="number" groupingUsed="true" />đ
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
                                                <td colspan="10" class="text-center" style="padding:40px">
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

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <div
                                    style="display:flex; justify-content:center; align-items:center; gap:8px; margin-top:var(--spacing-lg); padding:var(--spacing-md) 0">
                                    <c:set var="pageParams" value="" />
                                    <c:if test="${not empty filterStatus}">
                                        <c:set var="pageParams" value="&status=${filterStatus}" />
                                    </c:if>
                                    <c:if test="${not empty keyword}">
                                        <c:set var="pageParams" value="&keyword=${keyword}" />
                                    </c:if>

                                    <c:if test="${currentPage > 1}">
                                        <a href="Orders?page=${currentPage - 1}${pageParams}"
                                            class="btn btn-outline btn-sm">
                                            <i class="bi bi-chevron-left"></i> Trước
                                        </a>
                                    </c:if>

                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <a href="Orders?page=${i}${pageParams}"
                                            class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline'}"
                                            style="min-width:36px; text-align:center">${i}</a>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="Orders?page=${currentPage + 1}${pageParams}"
                                            class="btn btn-outline btn-sm">
                                            Sau <i class="bi bi-chevron-right"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </c:if>
                        </main>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                    </body>

                    </html>