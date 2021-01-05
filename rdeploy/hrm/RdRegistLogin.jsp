<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<style>
	.e8_os{
	  height:35px; 
	}
	.e8_innerShowContent{
	  height: 30px;
	  padding: 7px 0 0 7px;
	}
	
	.e8_spanFloat{
	  padding: 5px 0 0 0;
	}
	.e8_browflow{
		
	}
	.back:hover{
	  background-color: #325fd4;
	}
</style>
</head>

<%
String loginid= Util.null2String(request.getParameter("loginid"));
String language= Util.null2String(request.getParameter("language"));
String userpassword= Util.null2String(request.getParameter("userpassword"));



String gopage = "/rdeploy/hrm/RdRegistResourceFinish.jsp";
%>
<BODY onload="go()">
<form name="formMain" action="RdVerifyLogin.jsp" method="post">
 <input name="loginid" type="hidden" value="<%=loginid %>">
 <input name="userpassword" type="hidden" value="<%=userpassword %>">
 <INPUT type=hidden name="logintype" value="1">
 <input type=hidden name="gopage1" value="<%=gopage%>">
 <input type=hidden name="islanguid" value="<%=language%>">

</form>
<script language=javascript>

function go(){
 formMain.submit();
}

</script>




</BODY>
</HTML>

