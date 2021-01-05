
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,weaver.hrm.*,weaver.security.classLoader.ReflectMethodCall,weaver.general.ThreadVarManager,weaver.filter.XssUtil" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"></jsp:useBean>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title></title>

<script type="text/javascript">
	function refresh(){
		document.getElementById("code").src="/weaver/weaver.security.access.MakeRandCode?ts="+new Date().getTime();
	}
	function check_form(){
		var validateCode = document.getElementById("validateCode").value;
		if(!validateCode){
			alert("必要信息不完整！");
			return false;
		}
		return true;
	}
</script>
</head>
<body>
<div style="margin:0 auto;width:100%;margin-top:50px;">
<div style="text-align:center;">
<%
	String src = request.getParameter("src");
	String msg = "您的请求过于频繁，请输入验证码后继续访问系统。";
	if("verify".equals(src)){
		ReflectMethodCall rmc = new ReflectMethodCall();
		boolean result = (Boolean)rmc.call("weaver.security.access.AccessFreqCheck","remove",new Class[]{HttpServletRequest.class, String.class, XssUtil.class}, request, ThreadVarManager.getIp(),xssUtil);
		if(result){
			response.sendRedirect("/main.jsp");
			return;
		}
		msg = result?"":"验证码错误！";
	}

%>
<div style="width:100%;text-align:center;color:red;margin-bottom:20px;">
	<%=msg%>
</div>
<div style="width:60%;margin:0 auto;">
<form action="validateRandCode.jsp" method="post" name="loginForm" onsubmit="return check_form();">
	<input type="hidden" value="verify" name="src" id="src"/>
	<table style="width:100%;border:1px solid #d8d8d8;border-collapse:collapse;">
		<colgroup>
			<col width="40%"/>
			<col width="60%"/>
		</colgroup>
		<tbody>
			<tr>
				<td style="border:1px solid #d8d8d8;broder-collapse:collapse;text-align:right;padding-right:10px;height:50px;">验证码：</td>
				<td style="border:1px solid #d8d8d8;broder-collapse:collapse;text-align:left;padding-left:10px;">
				<div style="float:left;margin-top:10px;">
				<input type="text" name="validateCode" id="validateCode"/>
				</div>
				<div style="float:left;">
				<img name='code' id="code" onclick="refresh();" style="cursor:pointer;" src="/weaver/weaver.security.access.MakeRandCode"/></td>
				</div>
			</tr>
			<tr>
				<td colspan="2" style="height:50px;border:1px solid #d8d8d8;broder-collapse:collapse;text-align:center">
					<input type="submit" name="loginbtn" id="loginbtn" value="确  定"/>
				</td>
			</tr>
		</tbody>
	</table>
</form>
</div>
</body>
</html>
