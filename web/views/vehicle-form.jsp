<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty vehicle ? 'Sửa' : 'Thêm'} xe - MotoFix Pro</title>

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
        <a href="Customers?expandId=${customerID}" class="btn-back">
            <i class="bi bi-arrow-left"></i> Quay lại danh sách
        </a>

        <div class="detail-card" style="max-width:600px">
            <h3>
                <i class="bi bi-bicycle"></i>
                ${not empty vehicle ? 'Sửa xe' : 'Thêm xe mới'}
            </h3>

            <form action="Customers" method="POST" style="margin-top:var(--spacing-lg)">
                <input type="hidden" name="action" value="${not empty vehicle ? 'editVehicle' : 'addVehicle'}">
                <input type="hidden" name="customerID" value="${customerID}">
                <c:if test="${not empty vehicle}">
                    <input type="hidden" name="vehicleID" value="${vehicle.vehicleID}">
                </c:if>

                <div class="form-group" style="margin-bottom:var(--spacing-md)">
                    <label class="form-label">Biển số *</label>
                    <input type="text" class="form-input-plain" name="licensePlate"
                        value="${vehicle.licensePlate}" required>
                </div>
                <div class="form-row" style="display:flex; gap:var(--spacing-md); margin-bottom:var(--spacing-md)">
                    <div class="form-group" style="flex:1">
                        <label class="form-label">Hãng xe</label>
                        <input type="text" class="form-input-plain" name="brand"
                            value="${vehicle.brand}">
                    </div>
                    <div class="form-group" style="flex:1">
                        <label class="form-label">Mẫu xe</label>
                        <input type="text" class="form-input-plain" name="model"
                            value="${vehicle.model}">
                    </div>
                </div>
                <div class="form-group" style="margin-bottom:var(--spacing-lg)">
                    <label class="form-label">Năm sản xuất</label>
                    <input type="number" class="form-input-plain" name="manufactureYear"
                        min="1990" max="2030" value="${not empty vehicle ? vehicle.manufactureYear : 2024}">
                </div>

                <div style="display:flex; gap:var(--spacing-sm); justify-content:flex-end">
                    <a href="Customers?expandId=${customerID}" class="btn btn-secondary btn-sm">Hủy</a>
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="bi bi-${not empty vehicle ? 'check-lg' : 'plus-lg'}"></i>
                        ${not empty vehicle ? 'Lưu' : 'Thêm'}
                    </button>
                </div>
            </form>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
