<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty customer ? 'Sửa' : 'Thêm'} khách hàng - MotoFix Pro</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
        rel="stylesheet">

    <link href="static/css/style.css" rel="stylesheet">
    <link href="static/css/dashboard.css" rel="stylesheet">
    <link href="static/css/customers.css" rel="stylesheet">
</head>

<body class="dashboard-body">

    <jsp:include page="includes/navbar.jsp" />

    <main class="dashboard-main">
        <a href="Customers" class="btn-back">
            <i class="bi bi-arrow-left"></i> Quay lại danh sách
        </a>

        <div class="detail-card" style="max-width:600px">
            <h3>
                <i class="bi bi-person-${not empty customer ? 'gear' : 'plus-fill'}"></i>
                ${not empty customer ? 'Sửa khách hàng' : 'Thêm khách hàng mới'}
            </h3>

            <form action="Customers" method="POST" style="margin-top:var(--spacing-lg)">
                <input type="hidden" name="action" value="${not empty customer ? 'editCustomer' : 'addCustomer'}">
                <c:if test="${not empty customer}">
                    <input type="hidden" name="customerID" value="${customer.customerID}">
                </c:if>

                <div class="form-group" style="margin-bottom:var(--spacing-md)">
                    <label class="form-label">Họ tên *</label>
                    <input type="text" class="form-input-plain" name="fullName"
                        value="${customer.fullName}" required>
                </div>
                <div class="form-row" style="display:flex; gap:var(--spacing-md); margin-bottom:var(--spacing-md)">
                    <div class="form-group" style="flex:1">
                        <label class="form-label">Số điện thoại *</label>
                        <input type="text" class="form-input-plain" name="phone"
                            value="${customer.phone}" required>
                    </div>
                    <div class="form-group" style="flex:1">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-input-plain" name="email"
                            value="${customer.email}">
                    </div>
                </div>
                <div class="form-group" style="margin-bottom:var(--spacing-lg)">
                    <label class="form-label">Địa chỉ</label>
                    <input type="text" class="form-input-plain" name="address"
                        value="${customer.address}">
                </div>

                <div style="display:flex; gap:var(--spacing-sm); justify-content:flex-end">
                    <a href="Customers" class="btn btn-secondary btn-sm">Hủy</a>
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="bi bi-${not empty customer ? 'check-lg' : 'plus-lg'}"></i>
                        ${not empty customer ? 'Lưu' : 'Thêm'}
                    </button>
                </div>
            </form>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
