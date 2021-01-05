

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.conn.RecordSet" %>


<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) return;
String userid = request.getParameter("userid");
String sql =" select count(*) as num from mailresource where resourceid ='"+userid+"' and   folderid = '0' and status ='0'  and canview=1 ";
RecordSet rs  = new RecordSet();

rs.execute(sql);
rs.next();
out.clearBuffer();
out.print(rs.getInt("num"));

%>

