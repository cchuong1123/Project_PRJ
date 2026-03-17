<%@ tag description="Display status badge with appropriate CSS class" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="status" required="true" type="java.lang.String" %>
<c:set var="statusClass" value="" />
<c:if test="${status == 'Tiếp nhận'}"><c:set var="statusClass" value="status-tiepnhan" /></c:if>
<c:if test="${status == 'Đang sửa'}"><c:set var="statusClass" value="status-dangsua" /></c:if>
<c:if test="${status == 'Chờ phụ tùng'}"><c:set var="statusClass" value="status-chophutung" /></c:if>
<c:if test="${status == 'Hoàn thành'}"><c:set var="statusClass" value="status-hoanthanh" /></c:if>
<c:if test="${status == 'Đã giao'}"><c:set var="statusClass" value="status-dagiao" /></c:if>
<span class="status-badge ${statusClass}">${status}</span>
