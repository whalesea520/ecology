<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.hrm.*" %>
<% 
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	
	//编辑权限验证
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
	
	String checkSql = "insert into advancedAltMesConfig values("+user.getUID()+")";
	rs.executeSql(checkSql);
%>