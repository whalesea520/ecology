<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.util.NumberHelper"%>
<%
int appid = NumberHelper.string2Int(request.getParameter("appid"),0);
int appHomepageId = NumberHelper.string2Int(request.getParameter("appHomepageId"), -1);
%>

<jsp:include page="/mobilemode/appHomepageViewWrap.jsp">
	<jsp:param name="appid" value="<%=appid %>" />
	<jsp:param name="appHomepageId" value="<%=appHomepageId %>" />
</jsp:include>

<script type="text/javascript">
	$(window).on('resize', function() {
		$(document.body).hide();
		location.href = 'preview.jsp?appHomepageId=<%=appHomepageId %>';
	});
</script>