<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">

</HEAD>
<%
	String isall = Util.null2String(request.getParameter("isall"));	
	String include_value="";
	String disinclude_value="";
	if(isall.equals("1")){
		include_value=SystemEnv.getHtmlLabelName(128512,user.getLanguage());
		disinclude_value=SystemEnv.getHtmlLabelName(128514,user.getLanguage());
	}else{
		include_value=SystemEnv.getHtmlLabelName(128515,user.getLanguage());
		disinclude_value=SystemEnv.getHtmlLabelName(128516,user.getLanguage());
	}
%>
<body >
<div style="padding-top: 31px;padding-left: 100px;font-size: 14px;">
	<div>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(128517,user.getLanguage())%></div>	
	<div style="padding-top: 5px;"><input type=radio id="isinclude"  name=sharetype checked value=1 ><%=include_value%></div>
	<div style="padding-top: 5px;"><input type=radio id="disinclude"  name=sharetype  value=2 ><%=disinclude_value%></div>
</div>

   
</body>
</html>

