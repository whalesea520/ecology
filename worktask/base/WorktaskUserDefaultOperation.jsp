
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.worktask.worktask.WTSerachManager" %>
<%
String src = Util.null2String(request.getParameter("src"));
if(src.equalsIgnoreCase("userdefault")){
	int perpage = Util.getIntValue(request.getParameter("perpage"), 0);
	WTSerachManager wTSerachManager = new WTSerachManager();
	wTSerachManager.setUserID(user.getUID());
	int retInt = wTSerachManager.setUserDefaultPerpage(perpage);
	response.sendRedirect("WorktaskUserDefault.jsp?retInt="+retInt);
	return;
}


%>

