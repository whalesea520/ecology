<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
String saveType = Util.null2String(request.getParameter("saveType")).trim();
String name = Util.null2String(request.getParameter("name"));
String sql = "select count(*) from HrmEducationLevel where name='"+name+"'";
if("edit".equals(saveType)){
	String id = Util.null2String(request.getParameter("id")).trim();
	sql += " and id<>"+id;
}
int counts = 0;
RecordSet.executeSql(sql);
if(RecordSet.next()){
    counts = Util.getIntValue(RecordSet.getString(1),0);
}
if(counts>0){
    out.println("0");
}else{
    out.println("1");
}
%>