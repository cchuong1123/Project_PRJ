<%-- Document : reports Created on : Mar 18, 2026 Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <%@ taglib prefix="mt" tagdir="/WEB-INF/tags" %>
                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Báo cáo doanh thu - MotoFix Pro</title>

                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
                            rel="stylesheet">
                        <link
                            href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                            rel="stylesheet">

                        <link href="static/css/style.css" rel="stylesheet">
                        <link href="static/css/dashboard.css" rel="stylesheet">
                        <link href="static/css/reports.css" rel="stylesheet">
                    </head>

                    <body class="dashboard-body">

                        <jsp:include page="includes/navbar.jsp" />

                            <!-- Main Content -->
                            <main class="dashboard-main">

                                <!-- Page Header -->
                                <div class="report-header anim-slide-up">
                                    <div class="report-header-text">
                                        <h1><i class="bi bi-bar-chart-line-fill"></i> Báo cáo doanh thu</h1>
                                        <p class="report-subtitle">${filterLabel}</p>
                                    </div>
                                </div>

                                <!-- Filter Section -->
                                <div class="report-filters anim-slide-up">
                                    <div class="filter-quick-btns">
                                        <a href="Reports?filterType=today"
                                           class="filter-btn ${filterType == 'today' ? 'active' : ''}">
                                            <i class="bi bi-calendar-day"></i> Hôm nay
                                        </a>
                                        <a href="Reports?filterType=week"
                                           class="filter-btn ${filterType == 'week' ? 'active' : ''}">
                                            <i class="bi bi-calendar-week"></i> Tuần này
                                        </a>
                                        <a href="Reports?filterType=month"
                                           class="filter-btn ${filterType == 'month' ? 'active' : ''}">
                                            <i class="bi bi-calendar-month"></i> Tháng này
                                        </a>
                                    </div>
                                    <div class="filter-custom">
                                        <form action="Reports" method="GET" class="filter-form">
                                            <input type="hidden" name="filterType" value="custom">
                                            <div class="filter-input-group">
                                                <label>Từ ngày</label>
                                                <input type="date" name="fromDate" value="${fromDate}"
                                                       class="form-input-plain filter-date-input">
                                            </div>
                                            <div class="filter-input-group">
                                                <label>Đến ngày</label>
                                                <input type="date" name="toDate" value="${toDate}"
                                                       class="form-input-plain filter-date-input">
                                            </div>
                                            <button type="submit" class="btn btn-primary btn-sm filter-submit-btn">
                                                <i class="bi bi-funnel-fill"></i> Lọc
                                            </button>
                                        </form>
                                    </div>
                                </div>

                                <!-- Revenue Summary Cards -->
                                <div class="report-summary anim-slide-up">
                                    <div class="report-card revenue-card">
                                        <div class="report-card-icon blue">
                                            <i class="bi bi-cash-stack"></i>
                                        </div>
                                        <div class="report-card-info">
                                            <span class="report-card-value">
                                                <fmt:formatNumber value="${revenue}" type="number" groupingUsed="true" />đ
                                            </span>
                                            <span class="report-card-label">Tổng doanh thu</span>
                                        </div>
                                    </div>

                                    <div class="report-card">
                                        <div class="report-card-icon green">
                                            <i class="bi bi-receipt-cutoff"></i>
                                        </div>
                                        <div class="report-card-info">
                                            <span class="report-card-value">${totalInvoices}</span>
                                            <span class="report-card-label">Số hóa đơn</span>
                                        </div>
                                    </div>

                                    <div class="report-card">
                                        <div class="report-card-icon orange">
                                            <i class="bi bi-graph-up-arrow"></i>
                                        </div>
                                        <div class="report-card-info">
                                            <span class="report-card-value">
                                                <fmt:formatNumber value="${avgRevenue}" type="number" groupingUsed="true" maxFractionDigits="0" />đ
                                            </span>
                                            <span class="report-card-label">Trung bình / hóa đơn</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Invoice Detail Table -->
                                <div class="report-table-section anim-slide-up">
                                    <div class="report-table-header">
                                        <h2><i class="bi bi-table"></i> Chi tiết hóa đơn</h2>
                                        <span class="report-table-count">${totalInvoices} hóa đơn</span>
                                    </div>
                                    <div class="table-wrapper">
                                        <table class="table-custom">
                                            <thead>
                                                <tr>
                                                    <th>Mã HĐ</th>
                                                    <th>Mã đơn</th>
                                                    <th>Khách hàng</th>
                                                    <th>Biển số</th>
                                                    <th>Tổng tiền</th>
                                                    <th>Thanh toán</th>
                                                    <th>Ngày thanh toán</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="inv" items="${invoices}">
                                                    <tr>
                                                        <td><span class="invoice-id">#${inv.invoiceID}</span></td>
                                                        <td>
                                                            <a href="Orders?action=detail&id=${inv.orderID}"
                                                               class="order-link">#${inv.orderID}</a>
                                                        </td>
                                                        <td style="font-weight:600">${inv.customerName}</td>
                                                        <td><span class="sku-code">${inv.licensePlate}</span></td>
                                                        <td style="font-weight:700; color:var(--primary)">
                                                            <fmt:formatNumber value="${inv.totalAmount}" type="number"
                                                                groupingUsed="true" />đ
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${inv.paymentMethod == 'Tiền mặt'}">
                                                                    <span class="payment-badge cash">
                                                                        <i class="bi bi-cash-coin"></i> Tiền mặt
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${inv.paymentMethod == 'Chuyển khoản'}">
                                                                    <span class="payment-badge transfer">
                                                                        <i class="bi bi-bank"></i> Chuyển khoản
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="payment-badge other">
                                                                        <i class="bi bi-credit-card"></i> ${inv.paymentMethod}
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td style="font-size:var(--font-size-xs); color:var(--text-muted)">
                                                            <fmt:formatDate value="${inv.paidAt}" pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty invoices}">
                                                    <tr>
                                                        <td colspan="7" class="text-center" style="padding:40px">
                                                            <div class="empty-state">
                                                                <i class="bi bi-clipboard-x" style="display:block"></i>
                                                                <h3>Không có hóa đơn nào</h3>
                                                                <p>Không tìm thấy hóa đơn trong khoảng thời gian đã chọn.</p>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                            </main>

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                    </body>

                    </html>
