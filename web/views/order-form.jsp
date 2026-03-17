<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo phiếu sửa chữa - MotoFix Pro</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
        rel="stylesheet">
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet">

    <link href="static/css/style.css" rel="stylesheet">
    <link href="static/css/dashboard.css" rel="stylesheet">
    <link href="static/css/orders.css" rel="stylesheet">
</head>

<body class="dashboard-body">

    <jsp:include page="includes/navbar.jsp" />

    <main class="dashboard-main">
        <a href="Orders" class="btn-back">
            <i class="bi bi-arrow-left"></i> Quay lại danh sách
        </a>

        <div class="detail-card" style="max-width:650px">
            <h3>
                <i class="bi bi-plus-circle"></i> Tạo phiếu sửa chữa
            </h3>

            <form action="Orders" method="POST" style="margin-top:var(--spacing-lg)">
                <input type="hidden" name="action" value="create">

                <div class="form-group" style="margin-bottom:var(--spacing-md)">
                    <label class="form-label">Chọn xe (Biển số — Khách hàng) *</label>
                    <select class="form-input-plain" name="vehicleID" id="vehicleSelect" required>
                        <option value="">-- Chọn xe --</option>
                        <c:forEach var="v" items="${allVehicles}">
                            <option value="${v.vehicleID}">
                                ${v.licensePlate} — ${v.customerName}
                                <c:if test="${not empty v.brand}"> (${v.brand} ${v.model})</c:if>
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group" style="margin-bottom:var(--spacing-md)">
                    <label class="form-label">Thợ phụ trách *</label>
                    <select class="form-input-plain" name="mechanicID" required>
                        <option value="">-- Chọn thợ --</option>
                        <c:forEach var="m" items="${mechanics}">
                            <option value="${m.userID}">${m.fullName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group" style="margin-bottom:var(--spacing-lg)">
                    <label class="form-label">Mô tả sự cố</label>
                    <textarea class="form-input-plain" name="description" rows="3"
                        placeholder="Mô tả tình trạng xe, yêu cầu sửa chữa..."></textarea>
                </div>

                <div style="display:flex; gap:var(--spacing-sm); justify-content:flex-end">
                    <a href="Orders" class="btn btn-secondary btn-sm">Hủy</a>
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="bi bi-plus-lg"></i> Tạo phiếu
                    </button>
                </div>
            </form>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery + Select2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#vehicleSelect').select2({
                placeholder: '-- Tìm và chọn xe --',
                allowClear: true,
                width: '100%',
                language: {
                    noResults: function() { return 'Không tìm thấy xe phù hợp'; },
                    searching: function() { return 'Đang tìm...'; }
                }
            });
        });
    </script>
</body>

</html>
