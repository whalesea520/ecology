<%
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
String ChinaExcel_Version = "";
if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1)
{
	 ChinaExcel_Version = "CODEBASE='/weaverplugin/chinaexcelweb_tw.cab#version=3,8,7,9'";
}
else
{
	 ChinaExcel_Version = "CODEBASE='/weaverplugin/chinaexcelweb.cab#version=4,2,0,0'";	
}
String ChinaMenu_Version = "CODEBASE='/weaverplugin/chinamenu.cab#version=1.0.0.2'";
%>
