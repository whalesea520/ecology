<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
String applyid = Util.null2String(request.getParameter("applyid"));
String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());

char separator = Util.getSeparator() ;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


if(operation.equals("addremark")){
	String para = "";
	para  = applyid;
	para += separator+remark;
	para += separator+""+user.getUID();
	para += separator+CurrentDate;
	para += separator+CurrentTime;
	
	out.print(para);
	
	RecordSet.executeProc("HrmApplyRemark_Insert",para);

	response.sendRedirect("HrmCareerApplyEdit.jsp?applyid="+applyid);
} //end 
%>
