
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<!-- modified by wcd 2014-07-04 [E7 to E8] -->
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	int applyid = Util.getIntValue(request.getParameter("applyid"),0);
	String firstname=Util.null2String(request.getParameter("firstname"));
	String lastname=Util.null2String(request.getParameter("lastname"));
	String resourceid=Util.null2String(request.getParameter("resourceid"));
	String method=Util.null2String(request.getParameter("method"));
	char flag=Util.getSeparator();

	if(method.equals("delete")){
		RecordSet.executeProc("HrmShare_Delete",""+resourceid+flag+applyid);
		response.sendRedirect("HrmShare.jsp?showpage=2&applyid="+applyid+"&firstname="+firstname+"&lastname="+lastname);
		return;
	}else if(method.equals("add")){
		RecordSet.executeProc("HrmShare_Insert",""+resourceid+flag+applyid);
		out.println("<script>");
		out.println("parent.window.location = '/hrm/HrmDialogTab.jsp?_fromURL=applyInfo&showpage=2&method=share&id="+applyid+"';");
		out.println("</script>");
		return;
	}
%>