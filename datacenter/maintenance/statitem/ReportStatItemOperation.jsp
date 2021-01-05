<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="StatitemComInfo" class="weaver.datacenter.StatitemComInfo" scope="page" />


<%
String operation = Util.null2String(request.getParameter("operation"));
String statitemid = Util.null2String(request.getParameter("statitemid"));
String statitemname = Util.fromScreen(request.getParameter("statitemname"),user.getLanguage());
String statitemenname = Util.fromScreen(request.getParameter("statitemenname"),user.getLanguage());
String statitemdesc = Util.fromScreen(request.getParameter("statitemdesc"),user.getLanguage());
String statitemexpress = Util.null2String(request.getParameter("statitemexpress"));

char separator = Util.getSeparator() ;


if(operation.equals("add")){
	String para = statitemname + separator + statitemexpress + separator + statitemdesc + separator + statitemenname ;
	RecordSet.executeProc("T_Statitem_Insert",para);
}
 
else if(operation.equals("edit")){
    String para = statitemid + separator + statitemname
		          + separator + statitemexpress + separator + statitemdesc + separator + statitemenname;
	RecordSet.executeProc("T_Statitem_Update",para);
 }
 else if(operation.equals("delete")){
	String para = ""+statitemid;
	RecordSet.executeProc("T_Statitem_Delete",para);
 }

StatitemComInfo.removeStatitemCache() ;
response.sendRedirect("ReportStatItem.jsp");

%>
