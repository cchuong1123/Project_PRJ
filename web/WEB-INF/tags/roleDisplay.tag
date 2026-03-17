<%@ tag description="Display Vietnamese role name" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="role" required="true" type="java.lang.String" %>
<c:choose>
    <c:when test="${role == 'admin'}">Quản trị viên</c:when>
    <c:when test="${role == 'mechanic'}">Thợ sửa chữa</c:when>
    <c:otherwise>Nhân viên</c:otherwise>
</c:choose>
