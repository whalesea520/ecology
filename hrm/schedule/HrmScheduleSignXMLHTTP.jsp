<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.schedule.manager.HrmScheduleManager"%>
<%
	User user = HrmUserVarify.getUser (request, response) ;
	//签到（签退）只接受POST方法，不接受GET方法。
	if(user == null || request == null || !"POST".equalsIgnoreCase(request.getMethod())) return;
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	</head>
	<BODY>
		<table   border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top"><%=new HrmScheduleManager(request, response, user).showSignInfo()%>&nbsp;&nbsp;&nbsp;&nbsp;<BUTTON class=AddDoc  onclick="onCloseDivShowSignInfo()"><%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%></BUTTON></td>
			</tr>
		</TABLE>
	</BODY>
</HTML>