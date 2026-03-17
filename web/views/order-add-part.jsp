<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm phụ tùng - Đơn #${orderID} - MotoFix Pro</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
        rel="stylesheet">

    <link href="static/css/style.css" rel="stylesheet">
    <link href="static/css/dashboard.css" rel="stylesheet">
    <link href="static/css/orders.css" rel="stylesheet">
</head>

<body class="dashboard-body">

    <jsp:include page="includes/navbar.jsp" />

    <main class="dashboard-main">
        <a href="Orders?action=detail&id=${orderID}" class="btn-back">
            <i class="bi bi-arrow-left"></i> Quay lại đơn #${orderID}
        </a>

        <div class="detail-card" style="max-width:600px">
            <h3>
                <i class="bi bi-box-seam"></i> Thêm phụ tùng vào đơn #${orderID}
            </h3>

            <form action="Orders" method="POST" id="addPartForm" style="margin-top:var(--spacing-lg)">
                <input type="hidden" name="action" value="addPart">
                <input type="hidden" name="orderID" value="${orderID}">

                <div class="form-group" style="margin-bottom:var(--spacing-md)">
                    <label class="form-label">Chọn phụ tùng *</label>
                    <select class="form-input-plain" name="partID" id="partSelect" required
                        onchange="onPartChange()">
                        <option value="" data-stock="0">-- Chọn phụ tùng --</option>
                        <c:forEach var="p" items="${allParts}">
                            <c:if test="${p.stockQty > 0}">
                                <option value="${p.partID}" data-stock="${p.stockQty}">
                                    ${p.partName} (${p.sku}) — Tồn: ${p.stockQty} —
                                    <fmt:formatNumber value="${p.unitPrice}" type="number"
                                        groupingUsed="true" />đ
                                </option>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group" style="margin-bottom:var(--spacing-lg)">
                    <label class="form-label">Số lượng *</label>
                    <input type="number" class="form-input-plain" name="quantity" id="qtyInput"
                        min="1" value="1" required>
                    <small id="stockHint"
                        style="color:var(--text-muted); font-size:var(--font-size-xs)"></small>
                </div>

                <div style="display:flex; gap:var(--spacing-sm); justify-content:flex-end">
                    <a href="Orders?action=detail&id=${orderID}" class="btn btn-secondary btn-sm">Hủy</a>
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="bi bi-plus-lg"></i> Thêm
                    </button>
                </div>
            </form>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function onPartChange() {
            var sel = document.getElementById('partSelect');
            var opt = sel.options[sel.selectedIndex];
            var stock = parseInt(opt.getAttribute('data-stock')) || 0;
            var qtyInput = document.getElementById('qtyInput');
            var hint = document.getElementById('stockHint');
            if (sel.value) {
                qtyInput.max = stock;
                qtyInput.value = 1;
                hint.textContent = 'Tồn kho: ' + stock;
            } else {
                qtyInput.removeAttribute('max');
                hint.textContent = '';
            }
        }

        document.getElementById('addPartForm').addEventListener('submit', function (e) {
            var sel = document.getElementById('partSelect');
            var opt = sel.options[sel.selectedIndex];
            var stock = parseInt(opt.getAttribute('data-stock')) || 0;
            var qty = parseInt(document.getElementById('qtyInput').value) || 0;
            if (qty > stock) {
                e.preventDefault();
                alert('Số lượng (' + qty + ') vượt quá tồn kho (' + stock + ')!');
            }
        });
    </script>
</body>

</html>
