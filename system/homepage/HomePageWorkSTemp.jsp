<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String whereclause="";
String orderclause="";
String orderclause2="";
String userid = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;

String logintype = ""+user.getLogintype();
int usertype = 0;

if(userid.equals("")) {
	userid = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}
SearchClause.resetClause();
String method=Util.null2String(request.getParameter("method"));
if(method.equals("reqeustbywfid")){
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid = "+workflowid+" ";
	}
	else {
		whereclause +=" and t1.workflowid = "+workflowid+" ";
	}
	
	if(complete.equals("0")){
		whereclause +=" and t2.isremark in( '0','1','5','7','8','9') ";
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> 3 ";
	}
	else if(complete.equals("1")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = 3 ";
	}
	SearchClause.setWhereClause(whereclause);
	response.sendRedirect("HomePageWorkResult.jsp?start=1&perpage=10");
	return;
}

%>