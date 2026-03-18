<%-- Document : customers Created on : Mar 12, 2026 Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Khách hàng - MotoFix Pro</title>

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
                    rel="stylesheet">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">

                <link href="static/css/style.css" rel="stylesheet">
                <link href="static/css/dashboard.css" rel="stylesheet">
                <link href="static/css/customers.css" rel="stylesheet">
            </head>

            <body class="dashboard-body">

                <jsp:include page="includes/navbar.jsp" />

                <!-- Main Content -->
                <main class="dashboard-main">

                    <!-- Error Alert -->
                    <c:if test="${param.error == 'phone_exists'}">
                        <div class="alert alert-danger d-flex align-items-center mb-3 text-sm py-2 px-3">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                            <span>Số điện thoại này đã tồn tại trong hệ thống. Vui lòng nhập số khác.</span>
                        </div>
                    </c:if>
                    <c:if test="${param.error == 'plate_exists'}">
                        <div class="alert alert-danger d-flex align-items-center mb-3 text-sm py-2 px-3">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                            <span>Biển số xe này đã tồn tại trong hệ thống. Vui lòng nhập biển số khác.</span>
                        </div>
                    </c:if>

                    <!-- Summary Cards -->
                    <div class="customers-summary d-inline-flex min-w-250">
                        <div class="summary-card w-100">
                            <div class="summary-card-icon blue">
                                <i class="bi bi-people-fill"></i>
                            </div>
                            <div>
                                <div class="summary-card-value">${totalCustomers}</div>
                                <div class="summary-card-label">Tổng khách hàng</div>
                            </div>
                        </div>
                    </div>

                    <!-- Header + Toolbar -->
                    <div class="customers-header">
                        <h2><i class="bi bi-people-fill"></i> Quản lý khách hàng</h2>
                        <div class="customers-toolbar">
                            <form action="Customers" method="GET" class="customers-search">
                                <i class="bi bi-search input-icon"></i>
                                <input type="text" name="keyword" placeholder="Tìm theo tên, SĐT..." value="${keyword}">
                            </form>
                            <a href="Customers?action=addCustomer" class="btn btn-primary btn-sm">
                                <i class="bi bi-plus-lg"></i> Thêm khách hàng
                            </a>
                        </div>
                    </div>

                    <!-- Customers Table -->
                    <div class="table-wrapper">
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th class="w-40px"></th>
                                    <th>#</th>
                                    <th>Họ tên</th>
                                    <th>Số điện thoại</th>
                                    <th>Địa chỉ</th>
                                    <th>Email</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${customers}" varStatus="loop">
                                    <!-- Customer Row -->
                                    <tr class="customer-row">
                                        <td>
                                            <a href="Customers?expandId=${c.customerID}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                                                class="customer-expand-btn ${expandId == c.customerID ? 'expanded' : ''}">
                                                <i
                                                    class="bi bi-chevron-${expandId == c.customerID ? 'down' : 'right'}"></i>
                                            </a>
                                        </td>
                                        <td>${loop.index + 1}</td>
                                        <td class="font-semibold text-heading">${c.fullName}</td>
                                        <td>
                                            <div class="contact-phone">
                                                <i class="bi bi-telephone-fill"></i> ${c.phone}
                                            </div>
                                        </td>
                                        <td>${c.address}</td>
                                        <td>
                                            <c:if test="${not empty c.email}">
                                                <div class="contact-email">
                                                    <i class="bi bi-envelope-fill"></i> ${c.email}
                                                </div>
                                            </c:if>
                                        </td>
                                        <td>
                                            <div class="table-actions">
                                                <a href="Customers?action=editCustomer&id=${c.customerID}"
                                                    class="btn btn-outline btn-icon-sm" title="Sửa">
                                                    <i class="bi bi-pencil-square"></i>
                                                </a>
                                                <a href="Customers?action=delete&id=${c.customerID}"
                                                    class="btn btn-danger btn-icon-sm" title="Xóa"
                                                    onclick="return confirm('Bạn có chắc muốn xóa khách hàng này? Tất cả xe liên quan cũng sẽ bị ảnh hưởng.')">
                                                    <i class="bi bi-trash3"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>

                                    <!-- Expanded Vehicle Sub-rows -->
                                    <c:if test="${expandId == c.customerID}">
                                        <tr class="vehicle-row">
                                            <td colspan="7">
                                                <div class="vehicle-sub-header">
                                                    <span><i class="bi bi-bicycle"></i> Xe của ${c.fullName}</span>
                                                    <a href="Customers?action=addVehicle&cid=${c.customerID}"
                                                        class="btn btn-primary btn-sm">
                                                        <i class="bi bi-plus-lg"></i> Thêm xe
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                        <c:choose>
                                            <c:when test="${not empty vehicles}">
                                                <c:forEach var="v" items="${vehicles}">
                                                    <tr class="vehicle-row">
                                                        <td></td>
                                                        <td></td>
                                                        <td>
                                                            <span class="vehicle-plate">${v.licensePlate}</span>
                                                        </td>
                                                        <td>${v.brand}</td>
                                                        <td>${v.model}</td>
                                                        <td>${v.manufactureYear}</td>
                                                        <td>
                                                            <div class="table-actions">
                                                                <a href="Customers?action=editVehicle&vid=${v.vehicleID}&cid=${c.customerID}"
                                                                    class="btn btn-outline btn-icon-sm" title="Sửa xe">
                                                                    <i class="bi bi-pencil-square"></i>
                                                                </a>
                                                                <a href="Customers?action=deleteVehicle&vid=${v.vehicleID}&cid=${c.customerID}"
                                                                    class="btn btn-danger btn-icon-sm" title="Xóa xe"
                                                                    onclick="return confirm('Xóa xe này?')">
                                                                    <i class="bi bi-trash3"></i>
                                                                </a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr class="vehicle-row">
                                                    <td colspan="7" class="ps-48 text-muted italic">
                                                        Chưa có xe nào được đăng ký.
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${empty customers}">
                                    <tr>
                                        <td colspan="7" class="text-center p-xl">
                                            <div class="empty-state">
                                                <i class="bi bi-person-x d-block"></i>
                                                <h3>Không tìm thấy khách hàng</h3>
                                                <p>Thử tìm kiếm với từ khóa khác hoặc thêm khách hàng mới.</p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="flex flex-center items-center gap-sm mt-lg py-md">
                            <c:set var="pageParams" value="" />
                            <c:if test="${not empty keyword}">
                                <c:set var="pageParams" value="&keyword=${keyword}" />
                            </c:if>

                            <c:if test="${currentPage > 1}">
                                <a href="Customers?page=${currentPage - 1}${pageParams}" class="btn btn-outline btn-sm">
                                    <i class="bi bi-chevron-left"></i> Trước
                                </a>
                            </c:if>

                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <a href="Customers?page=${i}${pageParams}"
                                    class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline'} min-w-36 text-center">${i}</a>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="Customers?page=${currentPage + 1}${pageParams}" class="btn btn-outline btn-sm">
                                    Sau <i class="bi bi-chevron-right"></i>
                                </a>
                            </c:if>
                        </div>
                    </c:if>

                </main>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>