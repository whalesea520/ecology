<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%
	User __checkright4setting_user = HrmUserVarify.getUser(request, response);
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", __checkright4setting_user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
 %>
