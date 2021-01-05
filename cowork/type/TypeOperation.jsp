
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page"/>
<%

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
int id = Util.getIntValue(request.getParameter("id"));
String ids = Util.null2String(request.getParameter("ids"));
String typename = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String isAnonymous = Util.fromScreen(request.getParameter("isAnonymous"),user.getLanguage());
String isApproval = Util.fromScreen(request.getParameter("isApproval"),user.getLanguage());
isAnonymous=isAnonymous.equals("1")?"1":"0";
isApproval=isApproval.equals("1")?"1":"0";

String managerid = "";
String members = "";

char flag = 2;
String Proc="";
boolean isoracle = (RecordSet.getDBType()).equals("oracle");

if(operation.equals("add")){
		String sql = "insert into cowork_types(typename,departmentid,managerid,members,isAnonymous,isApproval) values('"+typename+"',"+departmentid+",'"+managerid+"','"+members+"',"+isAnonymous+","+isApproval+")";
		RecordSet.execute(sql);
}else if(operation.equals("edit")){
		String sql = "update cowork_types set typename='"+typename+"',departmentid="+departmentid+",isAnonymous="+isAnonymous+",isApproval="+isApproval+" where id="+id;
		RecordSet.execute(sql);
}
else if(operation.equals("delete")){
	RecordSet.execute("delete from cowork_types where id in("+ids+")");
	RecordSet.execute("delete from cotype_sharemanager where cotypeid in("+ids+")");
	RecordSet.execute("delete from cotype_sharemembers where cotypeid in("+ids+")");
} 
CoTypeComInfo.removeCoTypeCache();

response.sendRedirect("/cowork/type/CoworkType.jsp");
%>