<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type='text/javascript' src="../js/jquery-1.8.3.min.js"></script>
</head>
<body>
<form name="Loginform" id="form2" method="post" action='http://10.1.36.167:8080/login/VerifyLogin.jsp' >
loginid:<input type="hidden" name="loginid" value="RCPuser">
<br>
userpassword:<input type="hidden" name="userpassword" value="123456Kw">
logintype:<input type="hidden" name="logintype" value="1">
gopage:<input type="hidden" name="gopage" value="/docs/docs/DocList.jsp?hasTab=1&_fromURL=4">
<br>
</form>
<script language="javascript">	
$(document).ready(function(){
	//alert($("#form2").attr("id"));
	$("#form2").submit();
});
</script>
</body>
</html>
