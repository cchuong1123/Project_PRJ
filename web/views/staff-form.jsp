<%-- Document : staff-form Created on : Mar 18, 2026 Author : Admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${not empty editUser ? 'Sửa' : 'Thêm'} nhân sự - MotoFix Pro</title>

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
                    rel="stylesheet">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">

                <link href="static/css/style.css" rel="stylesheet">
                <link href="static/css/dashboard.css" rel="stylesheet">
                <link href="static/css/staff.css" rel="stylesheet">
            </head>

            <body class="dashboard-body">

                <jsp:include page="includes/navbar.jsp" />

                <main class="dashboard-main">
                    <a href="Staff" class="btn btn-outline btn-sm mb-md">
                        <i class="bi bi-arrow-left"></i> Quay lại danh sách
                    </a>

                    <div class="detail-card max-w-600">
                        <h3>
                            <c:choose>
                                <c:when test="${not empty editUser}">
                                    <i class="bi bi-pencil-square"></i> Sửa thông tin nhân sự
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-person-plus-fill"></i> Thêm nhân sự mới
                                </c:otherwise>
                            </c:choose>
                        </h3>

                        <form action="Staff" method="POST" class="mt-lg">
                            <input type="hidden" name="action" value="${not empty editUser ? 'edit' : 'add'}">
                            <c:if test="${not empty editUser}">
                                <input type="hidden" name="userID" value="${editUser.userID}">
                            </c:if>

                            <div class="form-group mb-md">
                                <label class="form-label">Họ tên *</label>
                                <input type="text" class="form-input-plain" name="fullName"
                                    value="${editUser.fullName}" required>
                            </div>

                            <div class="form-group mb-md">
                                <label class="form-label">Username *</label>
                                <c:choose>
                                    <c:when test="${not empty editUser}">
                                        <input type="text" class="form-input-plain" value="${editUser.username}"
                                            disabled>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="text" class="form-input-plain" name="username" required>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <c:if test="${empty editUser}">
                                <div class="form-group mb-md">
                                    <label class="form-label">Password *</label>
                                    <input type="password" class="form-input-plain" name="password" required>
                                </div>
                            </c:if>

                            <div class="flex gap-md mb-md">
                                <div class="flex-1">
                                    <div class="form-group">
                                        <label class="form-label">Vai trò *</label>
                                        <select class="form-input-plain" name="role" required>
                                            <option value="admin"
                                                ${editUser.role=='admin' ? 'selected' : '' }>Quản trị viên</option>
                                            <option value="mechanic"
                                                ${editUser.role=='mechanic' ? 'selected' : '' }>Thợ sửa chữa</option>
                                            <option value="staff"
                                                ${editUser.role=='staff' ? 'selected' : '' }>Thu ngân</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="flex-1">
                                    <div class="form-group">
                                        <label class="form-label">Ngày vào làm</label>
                                        <input type="date" class="form-input-plain" name="hireDate"
                                            value="${editUser.hireDate}">
                                    </div>
                                </div>
                            </div>

                            <div class="flex gap-sm justify-end">
                                <a href="Staff" class="btn btn-secondary btn-sm">Hủy</a>
                                <button type="submit" class="btn btn-primary btn-sm">
                                    <c:choose>
                                        <c:when test="${not empty editUser}">
                                            <i class="bi bi-check-lg"></i> Lưu thay đổi
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-plus-lg"></i> Thêm nhân sự
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                            </div>
                        </form>
                    </div>
                </main>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>