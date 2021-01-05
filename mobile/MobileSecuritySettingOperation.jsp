
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.zip.*"%>
<%@ page import="java.io.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
if (!HrmUserVarify.checkUserRight("MobileSecurity:Setting", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String[] userids = request.getParameterValues("userid");
String[] udids = request.getParameterValues("udid");
String[] isuseds = request.getParameterValues("used");

rs.execute("TRUNCATE TABLE MobileUserUDID");

if (userids != null && userids.length > 0) {
	for (int i=0; i<userids.length; i++) {
		rs.execute("insert into MobileUserUDID(userid, udid, isused) values(" + userids[i] + ", '" + udids[i] + "'," + isuseds[i] + ")");	
	}
}
response.sendRedirect("/mobile/MobileSecuritySetting.jsp");

%>
