
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser(request, response) ;
if(user==null){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
int orgtype  = Util.getIntValue(request.getParameter("orgtype"),1);          //人员0/部门1/分部2
int orgid    = Util.getIntValue(request.getParameter("orgid"),0);            //组织id
String returnStr = "";
String sql = "";
if(orgtype==0){
	sql = "select lastname as name from hrmresource where id="+orgid;
}else if(orgtype==1){
	sql = "select departmentname as name from hrmdepartment where id="+orgid;
}else if(orgtype==2){
	sql = "select subcompanyname as name from hrmsubcompany where id="+orgid;
}else if(orgtype==3){
	sql = "select name as name from FnaCostCenter where id="+orgid;
}
rs.executeSql(sql);
if(rs.next()){
	returnStr = rs.getString("name");
}
%>   
<%=returnStr%>