<%@page import="weaver.general.TimeUtil"%><%@page import="java.io.PrintWriter"%><%@page import="weaver.hrm.User"%><%@page import="weaver.hrm.HrmUserVarify"%><%@ page import="weaver.general.Util" %><%@ page language="java" contentType="text/html; charset=UTF-8" %><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" /><%
User user = HrmUserVarify.getUser (request , response) ;
if(true || user==null) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String guid1 = Util.null2String(request.getParameter("guid1"));
int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"));
String fnaXmlStr = "";

String filename = "expXml_"+TimeUtil.getCurrentTimeString().replaceAll("-", "").replaceAll(" ", "").replaceAll(":", "")+".xml";

String xmlVersion = "";
String xmlEncoding = "";
if(fnaVoucherXmlId > 0){
	fnaXmlStr = Util.null2String((String)request.getSession().getAttribute(guid1+"_ReportResultData.jsp_"+user.getUID()));
	
	rs.executeSql("select a.xmlVersion, a.xmlEncoding "+
		" from fnaVoucherXml a "+
		" where a.id = "+fnaVoucherXmlId);
	if(rs.next()){
		xmlVersion = Util.null2String(rs.getString("xmlVersion")).trim();
		xmlEncoding = Util.null2String(rs.getString("xmlEncoding")).trim();
	}
}else{
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

response.setContentType("application/octet-stream");
response.setHeader("Content-disposition", "attachment;filename=\""+filename+"\"");
PrintWriter writer = response.getWriter();
writer.write(fnaXmlStr);
response.flushBuffer();
%>