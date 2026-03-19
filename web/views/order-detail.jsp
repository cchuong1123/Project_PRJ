<%-- Document : order-detail Created on : Mar 12, 2026 Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <%@ taglib prefix="mt" tagdir="/WEB-INF/tags" %>
                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Đơn #${order.orderID} - MotoFix Pro</title>

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

                            <a href="Orders" class="btn-back">
                                <i class="bi bi-arrow-left"></i> Quay lại danh sách
                            </a>

                            <div class="orders-header mb-md">
                                <h2>
                                    <i class="bi bi-receipt"></i> Phiếu #${order.orderID}
                                    <mt:statusBadge status="${order.status}" />
                                </h2>
                            </div>

                            <div class="order-detail">
                                <!-- Left Column: Info + Parts -->
                                <div>
                                    <!-- Order Info -->
                                    <div class="detail-card mb-lg">
                                        <h3><i class="bi bi-info-circle-fill"></i> Thông tin phiếu</h3>
                                        <div class="detail-info-grid">
                                            <div class="detail-info-item">
                                                <span class="detail-info-label">Ngày tạo</span>
                                                <span class="detail-info-value">
                                                    <fmt:formatDate value="${order.createdAt}"
                                                        pattern="dd/MM/yyyy HH:mm" />
                                                </span>
                                            </div>
                                            <div class="detail-info-item">
                                                <span class="detail-info-label">Người tạo</span>
                                                <span class="detail-info-value">${order.createdByName != null ? order.createdByName : 'N/A'}</span>
                                            </div>
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
                                        </div>
                                        <c:if test="${not empty order.description}">
                                            <div class="mt-md pt-md border-top">
                                                <span class="detail-info-label">Mô tả sự cố</span>
                                                <p class="mt-xs text-primary text-sm">
                                                    ${order.description}</p>
                                            </div>
                                        </c:if>

                                        <!-- Status Workflow -->
                                        <c:if test="${order.status != 'Đã giao'}">
                                            <div class="mt-md pt-md border-top">
                                                <span class="detail-info-label">Chuyển trạng thái</span>
                                                <div class="status-workflow">
                                                    <c:if test="${order.status == 'Tiếp nhận'}">
                                                        <form action="Orders" method="POST" class="inline-block">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="orderID"
                                                                value="${order.orderID}">
                                                            <input type="hidden" name="newStatus" value="Đang sửa">
                                                            <button type="submit" class="btn btn-warning btn-sm">
                                                                <i class="bi bi-wrench"></i> Bắt đầu sửa
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${order.status == 'Đang sửa'}">
                                                        <form action="Orders" method="POST" class="inline-block">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="orderID"
                                                                value="${order.orderID}">
                                                            <input type="hidden" name="newStatus" value="Chờ phụ tùng">
                                                            <button type="submit" class="btn btn-purple btn-sm">
                                                                <i class="bi bi-pause-circle"></i> Chờ phụ tùng
                                                            </button>
                                                        </form>
                                                        <c:if test="${sessionScope.user.role != 'mechanic'}">
                                                            <form action="Orders" method="POST" class="inline-block">
                                                                <input type="hidden" name="action" value="updateStatus">
                                                                <input type="hidden" name="orderID"
                                                                    value="${order.orderID}">
                                                                <input type="hidden" name="newStatus" value="Hoàn thành">
                                                                <button type="submit" class="btn btn-success btn-sm">
                                                                    <i class="bi bi-check-circle"></i> Hoàn thành
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </c:if>
                                                    <c:if test="${order.status == 'Chờ phụ tùng'}">
                                                        <form action="Orders" method="POST" class="inline-block">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="orderID"
                                                                value="${order.orderID}">
                                                            <input type="hidden" name="newStatus" value="Đang sửa">
                                                            <button type="submit" class="btn btn-warning btn-sm">
                                                                <i class="bi bi-wrench"></i> Tiếp tục sửa
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${order.status == 'Hoàn thành'}">
                                                        <form action="Orders" method="POST" class="inline-block">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="orderID"
                                                                value="${order.orderID}">
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
                                        <div class="flex flex-between items-center mb-md">
                                            <h3 class="mb-0"><i class="bi bi-box-seam"></i> Phụ tùng sử dụng
                                            </h3>
                                            <c:if test="${sessionScope.user.role != 'mechanic' && order.status != 'Hoàn thành' && order.status != 'Đã giao'}">
                                                <a href="Orders?action=addPart&orderId=${order.orderID}"
                                                    class="btn btn-primary btn-sm">
                                                    <i class="bi bi-plus-lg"></i> Thêm phụ tùng
                                                </a>
                                            </c:if>
                                        </div>
                                        <table class="table-custom">
                                            <thead>
                                                <tr>
                                                    <th>Phụ tùng</th>
                                                    <th>Mã SKU</th>
                                                    <th>SL</th>
                                                    <c:if test="${sessionScope.user.role != 'mechanic'}">
                                                        <th>Đơn giá</th>
                                                        <th>Thành tiền</th>
                                                    </c:if>
                                                    <th>BH (Tháng)</th>
                                                    <th>Bảo hành đến</th>
                                                    <c:if
                                                        test="${sessionScope.user.role != 'mechanic' && order.status != 'Hoàn thành' && order.status != 'Đã giao'}">
                                                        <th></th>
                                                    </c:if>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="op" items="${orderParts}">
                                                    <tr>
                                                        <td class="font-semibold">${op.partName}</td>
                                                        <td><span class="sku-code">${op.sku}</span></td>
                                                        <td>${op.quantity}</td>
                                                        <c:if test="${sessionScope.user.role != 'mechanic'}">
                                                            <td>
                                                                <fmt:formatNumber value="${op.unitPrice}" type="number"
                                                                    groupingUsed="true" />đ
                                                            </td>
                                                            <td class="font-bold text-heading">
                                                                <fmt:formatNumber value="${op.total}" type="number"
                                                                    groupingUsed="true" />đ
                                                            </td>
                                                        </c:if>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${op.warrantyMonths > 0}">
                                                                    ${op.warrantyMonths} tháng
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">—</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty op.warrantyEndDate}">
                                                                    <span class="text-xs">
                                                                        <fmt:parseDate value="${op.warrantyEndDate}" pattern="yyyy-MM-dd" var="parsedDate" />
                                                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted text-xs">—</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <c:if
                                                            test="${sessionScope.user.role != 'mechanic' && order.status != 'Hoàn thành' && order.status != 'Đã giao'}">
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
                                                        <td colspan="8" class="text-center p-xl text-muted italic">
                                                            Chưa có phụ tùng nào.
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                            <c:if test="${sessionScope.user.role != 'mechanic'}">
                                                <tfoot>
                                                    <tr class="font-bold border-top-2">
                                                        <td colspan="6" class="text-end">Tổng phụ tùng:</td>
                                                        <td colspan="2">
                                                            <fmt:formatNumber value="${partsTotal}" type="number"
                                                                groupingUsed="true" />đ
                                                        </td>
                                                    </tr>
                                                    <tr class="font-bold">
                                                        <td colspan="6" class="text-end">Phí Dịch Vụ:</td>
                                                        <td colspan="2">
                                                            <fmt:formatNumber value="${order.laborCost}" type="number"
                                                                groupingUsed="true" />đ
                                                        </td>
                                                    </tr>
                                                    <tr class="font-extrabold text-md text-primary">
                                                        <td colspan="6" class="text-end">TỔNG CỘNG:</td>
                                                        <td colspan="2">
                                                            <fmt:formatNumber value="${grandTotal}" type="number"
                                                                groupingUsed="true" />đ
                                                        </td>
                                                    </tr>
                                                </tfoot>
                                            </c:if>
                                        </table>
                                    </div>
                                </div>

                                <!-- Right Column: Invoice -->
                                <c:if test="${sessionScope.user.role != 'mechanic'}">
                                    <div>
                                        <c:choose>
                                            <c:when test="${not empty invoice}">
                                                <div class="detail-card invoice-card">
                                                    <h3><i class="bi bi-receipt-cutoff"></i> Hóa đơn</h3>
                                                    <div class="detail-info-item mb-sm">
                                                        <span class="detail-info-label">Mã hóa đơn</span>
                                                        <span class="detail-info-value">#${invoice.invoiceID}</span>
                                                    </div>
                                                    <div class="detail-info-item mb-sm">
                                                        <span class="detail-info-label">Phương thức</span>
                                                        <span class="detail-info-value">${invoice.paymentMethod}</span>
                                                    </div>
                                                    <div class="detail-info-item mb-sm">
                                                        <span class="detail-info-label">Ngày thanh toán</span>
                                                        <span class="detail-info-value">
                                                            <fmt:formatDate value="${invoice.paidAt}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </span>
                                                    </div>
                                                    <div class="invoice-total">
                                                        <fmt:formatNumber value="${invoice.totalAmount}" type="number"
                                                            groupingUsed="true" />đ
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="detail-card">
                                                    <h3><i class="bi bi-receipt-cutoff"></i> Hóa đơn</h3>
                                                    <c:choose>
                                                        <c:when
                                                            test="${order.status == 'Hoàn thành' || order.status == 'Đã giao'}">
                                                            <p class="text-muted text-sm mb-md">
                                                                Tạo hóa đơn thanh toán cho phiếu này.
                                                            </p>
                                                            <form action="Orders" method="POST">
                                                                <input type="hidden" name="action"
                                                                    value="createInvoice">
                                                                <input type="hidden" name="orderID"
                                                                    value="${order.orderID}">
                                                                <div class="form-group mb-md">
                                                                    <label class="form-label text-xs font-semibold">Công
                                                                        thợ (VNĐ)</label>
                                                                    <input type="number"
                                                                        class="form-input-plain text-sm p-sm"
                                                                        name="laborCost" id="laborCostInput" step="1"
                                                                        min="0"
                                                                        value="${order.laborCost > 0 ? order.laborCost : 0}"
                                                                        oninput="updateInvoiceTotal()">
                                                                </div>
                                                                <div class="form-group mb-md">
                                                                    <label
                                                                        class="form-label text-xs font-semibold">Phương
                                                                        thức thanh toán</label>
                                                                    <select class="form-input-plain"
                                                                        name="paymentMethod">
                                                                        <option value="Tiền mặt">Tiền mặt</option>
                                                                        <option value="Chuyển khoản">Chuyển khoản
                                                                        </option>
                                                                    </select>
                                                                </div>
                                                                <div class="text-sm mb-md">
                                                                    <div class="flex flex-between mb-xs">
                                                                        <span>Phụ tùng:</span>
                                                                        <span>
                                                                            <fmt:formatNumber value="${partsTotal}"
                                                                                type="number" groupingUsed="true" />đ
                                                                        </span>
                                                                    </div>
                                                                    <div class="flex flex-between mb-xs">
                                                                        <span>Phí Dịch Vụ:</span>
                                                                        <span id="laborCostDisplay">0đ</span>
                                                                    </div>
                                                                    <div
                                                                        class="flex flex-between font-extrabold text-md text-primary pt-sm border-top">
                                                                        <span>Tổng:</span>
                                                                        <span id="grandTotalDisplay">
                                                                            <fmt:formatNumber value="${partsTotal}"
                                                                                type="number" groupingUsed="true" />đ
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                                <button type="submit"
                                                                    class="btn btn-primary btn-sm w-100">
                                                                    <i class="bi bi-receipt-cutoff"></i> Tạo hóa đơn
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="text-muted text-sm italic">
                                                                Hóa đơn sẽ được tạo sau khi phiếu hoàn thành.
                                                            </p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                            </div>
                        </main>

                        <!-- Hidden input to pass partsTotal to inline JS -->
                        <input type="hidden" id="partsTotalData" value="${partsTotal != null ? partsTotal : 0}">

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Live update invoice total
                            var partsTotal = parseFloat(document.getElementById('partsTotalData').value) || 0;
                            function updateInvoiceTotal() {
                                var laborInput = document.getElementById('laborCostInput');
                                if (!laborInput)
                                    return;
                                var labor = parseFloat(laborInput.value) || 0;
                                var total = partsTotal + labor;
                                var laborDisplay = document.getElementById('laborCostDisplay');
                                var totalDisplay = document.getElementById('grandTotalDisplay');
                                if (laborDisplay)
                                    laborDisplay.textContent = labor.toLocaleString('vi-VN') + 'đ';
                                if (totalDisplay)
                                    totalDisplay.textContent = total.toLocaleString('vi-VN') + 'đ';
                            }
                            updateInvoiceTotal();
                        </script>
                    </body>

                    </html>