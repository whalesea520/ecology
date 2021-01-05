<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
//校验名称是否存在
String name=request.getParameter("nameStr");
String method=request.getParameter("method");
String matrixid=request.getParameter("matrixid");
out.clearBuffer();
String sqlWhere = "";
if("edit".equals(method)){
	sqlWhere = " and id != "+matrixid;
}
	RecordSet.executeSql("select id from MatrixInfo where name='"+name+"'"+sqlWhere);
	if(RecordSet.next()){
		out.println("{\"success\":\"1\"}");
	}else{
		out.println("{\"success\":\"0\"}");
	}
%>