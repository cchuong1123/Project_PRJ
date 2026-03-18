<%-- Document : staff Created on : Mar 18, 2026 Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <%@ taglib prefix="mt" tagdir="/WEB-INF/tags" %>
                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Nhân sự - MotoFix Pro</title>

                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
                            rel="stylesheet">
                        <link
                            href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                            rel="stylesheet">

                        <link href="static/css/style.css" rel="stylesheet">
                        <link href="static/css/dashboard.css" rel="stylesheet">
                        <link href="static/css/staff.css" rel="stylesheet">
                    </head>

                    <body class="dashboard-body">

                        <jsp:include page="includes/navbar.jsp" />

                        <!-- Main Content -->
                        <main class="dashboard-main">

                            <!-- Error Alert -->
                            <c:if test="${param.error == 'username_exists'}">
                                <div class="alert alert-danger d-flex align-items-center mb-3 text-sm py-2 px-3">
                                    <i class="bi bi-exclamation-triangle-fill"></i>
                                    <span>Username đã tồn tại. Vui lòng chọn username khác.</span>
                                </div>
                            </c:if>

                            <!-- Header + Toolbar -->
                            <div class="staff-header">
                                <h2><i class="bi bi-person-badge-fill"></i> Quản lý nhân sự</h2>
                                <a href="Staff?action=add" class="btn btn-primary btn-sm">
                                    <i class="bi bi-plus-lg"></i> Thêm nhân sự
                                </a>
                            </div>

                            <!-- Staff Table -->
                            <div class="table-wrapper">
                                <table class="table-custom">
                                    <thead>
                                        <tr>
                                            <th>Họ tên</th>
                                            <th>Username</th>
                                            <th>Vai trò</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày vào làm</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="u" items="${users}" varStatus="loop">
                                            <tr>
                                                <td class="font-semibold text-heading">${u.fullName}</td>
                                                <td><span class="sku-code">${u.username}</span></td>
                                                <td>
                                                    <mt:roleDisplay role="${u.role}" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${u.isActive}">
                                                            <span class="status-badge status-active">
                                                                <i class="bi bi-check-circle-fill"></i> Hoạt động
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-locked">
                                                                <i class="bi bi-lock-fill"></i> Đã khóa
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-xs text-muted">
                                                    <fmt:formatDate value="${u.hireDate}" pattern="dd/MM/yyyy" />
                                                </td>
                                                <td>
                                                    <div class="table-actions">
                                                        <a href="Staff?action=edit&id=${u.userID}"
                                                            class="btn btn-outline btn-icon-sm" title="Sửa thông tin">
                                                            <i class="bi bi-pencil-square"></i>
                                                        </a>
                                                        <c:if test="${sessionScope.user.userID != u.userID}">
                                                            <form action="Staff" method="POST" class="inline-block">
                                                                <input type="hidden" name="action" value="toggleActive">
                                                                <input type="hidden" name="id" value="${u.userID}">
                                                                <input type="hidden" name="currentActive"
                                                                    value="${u.isActive}">
                                                                <c:choose>
                                                                    <c:when test="${u.isActive}">
                                                                        <button type="submit"
                                                                            class="btn btn-danger btn-icon-sm"
                                                                            title="Khóa tài khoản"
                                                                            onclick="return confirm('Khóa tài khoản ${u.fullName}?')">
                                                                            <i class="bi bi-lock-fill"></i>
                                                                        </button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button type="submit"
                                                                            class="btn btn-success btn-icon-sm"
                                                                            title="Mở khóa tài khoản"
                                                                            onclick="return confirm('Mở khóa tài khoản ${u.fullName}?')">
                                                                            <i class="bi bi-unlock-fill"></i>
                                                                        </button>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty users}">
                                            <tr>
                                                <td colspan="6" class="text-center p-xl">
                                                    <div class="empty-state">
                                                        <i class="bi bi-person-x d-block"></i>
                                                        <h3>Chưa có nhân sự nào</h3>
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
                                    <c:if test="${currentPage > 1}">
                                        <a href="Staff?page=${currentPage - 1}" class="btn btn-outline btn-sm">
                                            <i class="bi bi-chevron-left"></i> Trước
                                        </a>
                                    </c:if>

                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <a href="Staff?page=${i}"
                                            class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline'} min-w-36 text-center">${i}</a>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="Staff?page=${currentPage + 1}" class="btn btn-outline btn-sm">
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
