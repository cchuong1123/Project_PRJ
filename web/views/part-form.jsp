<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${not empty part ? 'Sửa' : 'Thêm'} phụ tùng - MotoFix Pro</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
              rel="stylesheet">

        <link href="static/css/style.css" rel="stylesheet">
        <link href="static/css/dashboard.css" rel="stylesheet">
        <link href="static/css/parts.css" rel="stylesheet">
    </head>

    <body class="dashboard-body">

        <jsp:include page="includes/navbar.jsp" />

        <main class="dashboard-main">
            <a href="Parts" class="btn-back">
                <i class="bi bi-arrow-left"></i> Quay lại danh sách
            </a>

            <div class="detail-card" style="max-width:650px">
                <h3>
                    <i class="bi bi-box-seam${not empty part ? '' : '-fill'}"></i>
                    ${not empty part ? 'Sửa phụ tùng' : 'Thêm phụ tùng mới'}
                </h3>

                <form action="Parts" method="POST" style="margin-top:var(--spacing-lg)">
                    <input type="hidden" name="action" value="${not empty part ? 'editPart' : 'addPart'}">
                    <c:if test="${not empty part}">
                        <input type="hidden" name="partID" value="${part.partID}">
                    </c:if>

                    <div class="form-group" style="margin-bottom:var(--spacing-md)">
                        <label class="form-label">Tên phụ tùng *</label>
                        <input type="text" class="form-input-plain" name="partName"
                               value="${part.partName}" required>
                    </div>
                    <div class="form-row" style="display:flex; gap:var(--spacing-md); margin-bottom:var(--spacing-md)">
                        <div class="form-group" style="flex:1">
                            <label class="form-label">Mã SKU *</label>
                            <input type="text" class="form-input-plain" name="sku"
                                   value="${part.sku}" required>
                        </div>
                        <div class="form-group" style="flex:1">
                            <label class="form-label">Tồn kho *</label>
                            <input type="number" class="form-input-plain" name="stockQty"
                                   min="0" value="${part.stockQty}" required>
                        </div>
                    </div>
                    <div class="form-row" style="display:flex; gap:var(--spacing-md); margin-bottom:var(--spacing-md)">
                        <div class="form-group" style="flex:1">
                            <label class="form-label">Giá nhập (VNĐ) *</label>
                            <input type="number" class="form-input-plain" name="importPrice"
                                   step="1000" min="0" value="${part.importPrice}" required>
                        </div>
                        <div class="form-group" style="flex:1">
                            <label class="form-label">Giá bán (VNĐ) *</label>
                            <input type="number" class="form-input-plain" name="unitPrice"
                                   step="1000" min="0" value="${part.unitPrice}" required>
                        </div>
                    </div>
                    <div class="form-row" style="display:flex; gap:var(--spacing-md); margin-bottom:var(--spacing-lg)">
                        <div class="form-group" style="flex:1">
                            <label class="form-label">Ngưỡng tối thiểu</label>
                            <input type="number" class="form-input-plain" name="minStock"
                                   min="0" value="${not empty part ? part.minStock : 5}">
                        </div>
                        <div class="form-group" style="flex:1">
                            <label class="form-label">Bảo hành (tháng)</label>
                            <input type="number" class="form-input-plain" name="warrantyMonths"
                                   min="0" value="${not empty part ? part.warrantyMonths : 0}"
                                   placeholder="0 = không bảo hành">
                        </div>
                    </div>

                    <div style="display:flex; gap:var(--spacing-sm); justify-content:flex-end">
                        <a href="Parts" class="btn btn-secondary btn-sm">Hủy</a>
                        <button type="submit" class="btn btn-primary btn-sm">
                            <i class="bi bi-${not empty part ? 'check-lg' : 'plus-lg'}"></i>
                            ${not empty part ? 'Lưu' : 'Thêm'}
                        </button>
                    </div>
                </form>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>

</html>
