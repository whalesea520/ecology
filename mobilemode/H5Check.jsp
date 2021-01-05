<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String url = request.getParameter("url");
%>
<script type="text/javascript">
var pass = true;
if(navigator.userAgent.indexOf("MSIE")!=-1){	//IE
	
	var strVer = window.navigator.appVersion;
	var iev = 0;
	if(strVer.substr(17,4)=="MSIE"){
		iev = strVer.substr(22,(strVer.indexOf(";", 22) - 22));
	}
	iev = parseInt(iev);
	
	if(iev < 10){
		pass = false;
	}
}
if(pass){
	window.location.href = "<%=url%>";
}else{
	window.location.href = "/mobilemode/unsupporthtml5_wev8.jsp";
}
</script>
