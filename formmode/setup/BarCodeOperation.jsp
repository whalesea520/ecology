<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int modeId=  Util.getIntValue(request.getParameter("modeId"));
    int isused = Util.getIntValue(request.getParameter("isused"));
    String resolution = Util.null2String(request.getParameter("resolution"));
    String size = Util.null2String(request.getParameter("size"));
    String codenum = Util.null2String(request.getParameter("codenum"));
	String info=  Util.null2String(request.getParameter("info"));
	
	String levelspacing = Util.null2String(request.getParameter("levelspacing"));
	String verticalspacing = Util.null2String(request.getParameter("verticalspacing"));
	String numberrows = Util.null2String(request.getParameter("numberrows"));
	String numbercols = Util.null2String(request.getParameter("numbercols"));
	
	if("".equals(levelspacing)) levelspacing = null;
	if("".equals(verticalspacing)) verticalspacing = null;
	if("".equals(numberrows)) numberrows = null;
	if("".equals(numbercols)) numbercols = null;
	
	rs.executeSql("select 1 from mode_barcode where modeid="+modeId); 
	if (rs.next()) { //如果已经有数据了，就更新
		String updateSql = "update mode_barcode set ";
		updateSql += "isused="+isused+",resolution='"+resolution+"',codesize='"+size+"',codenum='"+codenum+"',info='"+info+"'";
		updateSql += ",levelspacing="+levelspacing+",verticalspacing="+verticalspacing+",numberrows="+numberrows+",numbercols="+numbercols;
		updateSql += " where modeid="+modeId;
		rs.executeSql(updateSql);
	} else {
		String insertSql = "insert into mode_barcode";
		insertSql += "(modeid,isused,resolution,codesize,codenum,info,levelspacing,verticalspacing,numberrows,numbercols)";
		insertSql += " values ";
		insertSql += "("+modeId+","+isused+",'"+resolution+"','"+size+"','"+codenum+"','"+info+"',"+levelspacing+","+verticalspacing+","+numberrows+","+numbercols+")";
		rs.executeSql(insertSql);
	}
	response.sendRedirect("BarCode.jsp?modeId="+modeId);
%>
