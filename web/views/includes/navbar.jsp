<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mt" tagdir="/WEB-INF/tags" %>

<!-- Top Navbar -->
<nav class="top-navbar">
    <a href="Dashboard" class="top-navbar-brand">
        <div class="top-navbar-brand-icon">
            <i class="bi bi-droplet-fill leaf-blue"></i>
            <i class="bi bi-droplet-fill leaf-green"></i>
        </div>
        <span class="top-navbar-brand-text">
            <span class="blue">Moto</span><span class="green">Fix</span> Pro
        </span>
    </a>
    <div class="top-navbar-right">
        <div class="top-navbar-user">
            <div class="top-navbar-avatar"><mt:userInitial name="${sessionScope.user.fullName}" /></div>
            <div class="top-navbar-user-info">
                <span class="top-navbar-user-name">${sessionScope.user.fullName}</span>
                <span class="top-navbar-user-role"><mt:roleDisplay role="${sessionScope.user.role}" /></span>
            </div>
        </div>
        <a href="Logout" class="btn-logout">
            <i class="bi bi-box-arrow-right"></i> Đăng xuất
        </a>
    </div>
</nav>

<!-- Secondary Navbar -->
<nav class="secondary-navbar">
    <div class="secondary-navbar-links">
        <a href="Dashboard" class="secondary-navbar-link ${activePage == 'dashboard' ? 'active' : ''}">
            <i class="bi bi-grid-1x2-fill"></i> Tổng quan
        </a>
        <a href="Parts" class="secondary-navbar-link ${activePage == 'parts' ? 'active' : ''}">
            <i class="bi bi-box-seam-fill"></i> Hàng hóa
        </a>
        <a href="Orders" class="secondary-navbar-link ${activePage == 'orders' ? 'active' : ''}">
            <i class="bi bi-receipt"></i> Đơn hàng
        </a>
        <a href="Customers" class="secondary-navbar-link ${activePage == 'customers' ? 'active' : ''}">
            <i class="bi bi-people-fill"></i> Khách hàng
        </a>
    </div>
    <c:choose>
        <c:when test="${activePage == 'order-detail'}">
            <a href="Orders" class="btn-create-order">
                <i class="bi bi-arrow-left"></i> Danh sách
            </a>
        </c:when>
        <c:otherwise>
            <a href="Orders?action=createForm" class="btn-create-order">
                <i class="bi bi-plus-lg"></i> Tạo đơn
            </a>
        </c:otherwise>
    </c:choose>
</nav>
