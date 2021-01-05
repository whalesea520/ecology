<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//特殊处理，直接跳转到计划任务界面，进行审批操作
int approverequest = Util.getIntValue(request.getParameter("requestid"), 0);
boolean hasSuchWT = true;
rs.execute("select * from worktask_requestbase where approverequest="+approverequest);
if(rs.next()){
	int requestid = Util.getIntValue(rs.getString("approverequest"), 0);
	response.sendRedirect("/worktask/request/ViewWorktask.jsp?requestid="+requestid);
	return;
}else{
	hasSuchWT = false;
}
if(hasSuchWT == false){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>