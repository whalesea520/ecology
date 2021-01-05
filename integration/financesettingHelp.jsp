<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<head>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:financesetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
请咨询NC供应商获取：信息交换平台的手动加载页面的目标URL地址。
%>
<body>
</body>
</HTML>