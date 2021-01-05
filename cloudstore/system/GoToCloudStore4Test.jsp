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

int id = user.getUID();
String loginid =  user.getLoginid();
String lastnamess = user.getLastname();
String ip = request.getParameter("ip");
String path = request.getParameter("path");
String isMobile= request.getParameter("isMobile");
String result = so.goToCloudStore(String.valueOf(id),loginid,lastnamess,path,isMobile);
String aas = "0";
if("false".equals(result)){
aas = "1";
}
String url = "http://"+ip;

//response.sendRedirect("http://"+ip+"/person?key="+result+"&?");
%>
<form id = "aaa" method ="GET" action="<%=url %>">
<input type="hidden" name="key" value="<%=result %>" />
</form>
<script type="text/javascript">
function validate(){
  document.getElementById('aaa').submit();
}
if(1==<%=aas %>){
alert("没有绑定token");
}else{
window.load=validate();
}

</script>
</body>
</html>