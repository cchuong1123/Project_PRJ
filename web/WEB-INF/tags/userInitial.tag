<%@ tag description="Display first character of user name" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="name" required="true" type="java.lang.String" %>
<c:choose>
    <c:when test="${fn:length(name) > 0}">${fn:toUpperCase(fn:substring(name, 0, 1))}</c:when>
    <c:otherwise>U</c:otherwise>
</c:choose>
