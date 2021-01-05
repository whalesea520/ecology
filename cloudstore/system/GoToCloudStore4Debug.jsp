<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="com.cloudstore.api.process.Process_Sso"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="ln.LN"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="initial-scale=1.0, maximum-scale=2.0">
<meta name="description" content="">
<meta name="author" content="">
<title>访问云商店</title>
</head>
<body>
<%
Process_Sso so = new Process_Sso();
User user = HrmUserVarify.getUser(request, response);
LN Ln = new LN();
String Licensecode = Ln.getLicensecode();
String com = Ln.getCompanyname();
int id = user.getUID();
String result = so.getToken(String.valueOf(id),Licensecode);
String ip = request.getParameter("ip");
out.println("http://"+ip+"/person?key="+result);
%>
</body>
</html>