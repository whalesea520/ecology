
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" /><%
	
String coworkname = Util.null2String(java.net.URLDecoder.decode(request.getParameter("coworkname"),"UTF-8"));  //获得操作页面传过来的参数 coworkname
String departmentid = Util.null2String(request.getParameter("departmentid"));
String id = Util.null2String(request.getParameter("id"));
if (id != null && !"".equals(id))
		RecordSet.executeSql("select * from cowork_types where typename='"+coworkname+"' and departmentid="+departmentid+" and id != " + id); //修改状态时有id传入进行过滤
else
	  RecordSet.executeSql("select * from cowork_types where typename='"+coworkname+"' and departmentid="+departmentid);
	  	  
if (RecordSet.next()){
		out.print("exist--");
} else {
    out.print("unfind--");
}

%>