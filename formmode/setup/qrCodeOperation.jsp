<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
	String modeId=  Util.null2String(request.getParameter("modeId"));
	int txtUserUse=  Util.getIntValue(request.getParameter("txtUserUse"),0);
	String targetType=  Util.null2String(request.getParameter("targetType"));
	String targetUrl=  Util.null2String(request.getParameter("targetUrl"));
	String w=  Util.null2String(request.getParameter("w"));
	String h=  Util.null2String(request.getParameter("h"));
	String baseinfo=  Util.null2String(request.getParameter("baseinfo"));
	String levelspacing = Util.null2String(request.getParameter("levelspacing"));
	String verticalspacing = Util.null2String(request.getParameter("verticalspacing"));
	String numberrows = Util.null2String(request.getParameter("numberrows"));
	String numbercols = Util.null2String(request.getParameter("numbercols"));
	
	if("".equals(levelspacing)) levelspacing = null;
	if("".equals(verticalspacing)) verticalspacing = null;
	if("".equals(numberrows)) numberrows = null;
	if("".equals(numbercols)) numbercols = null;
	
	rs.executeSql("select 1 from ModeQRCode where modeid="+modeId);
	if (rs.next()) {
		String updateSql = "update ModeQRCode set ";
		updateSql += "isuse='"+txtUserUse+"',targetType='"+targetType+"',targetUrl='"+targetUrl+"',width="+w+",height="+h+",qrCodeDesc='"+baseinfo+"'";
		updateSql += ",levelspacing="+levelspacing+",verticalspacing="+verticalspacing+",numberrows="+numberrows+",numbercols="+numbercols;
		updateSql += " where modeid="+modeId;
		rs.executeSql(updateSql);
	} else {
		String insertSql = "insert into ModeQRCode";
		insertSql += "(modeid,isuse,targetType,targetUrl,width,height,qrCodeDesc,levelspacing,verticalspacing,numberrows,numbercols)";
		insertSql += " values ";
		insertSql += "("+modeId+",'"+txtUserUse+"','"+targetType+"','"+targetUrl+"',"+w+","+h+",'"+baseinfo+"',"+levelspacing+","+verticalspacing+","+numberrows+","+numbercols+")";
		rs.executeSql(insertSql);
	}
	response.sendRedirect("QRCode.jsp?modeId="+modeId);
%>