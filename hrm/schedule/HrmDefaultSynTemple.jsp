
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
</head>
<body>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361 , user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(32762 , user.getLanguage())%></wea:item>
    <wea:item>
    	<select id=copyfrom name="copyfrom">
    		<option value="1"><%=SystemEnv.getHtmlLabelName(392 , user.getLanguage())%></option>
    		<option value="2"><%=SystemEnv.getHtmlLabelName(393 , user.getLanguage())%></option>
    		<option value="3"><%=SystemEnv.getHtmlLabelName(394 , user.getLanguage())%></option>
    		<option value="4"><%=SystemEnv.getHtmlLabelName(395 , user.getLanguage())%></option>
    		<option value="5"><%=SystemEnv.getHtmlLabelName(396 , user.getLanguage())%></option>
    		<option value="6"><%=SystemEnv.getHtmlLabelName(397 , user.getLanguage())%></option>
    		<option value="7"><%=SystemEnv.getHtmlLabelName(398 , user.getLanguage())%></option>
    	</select>
    </wea:item>
	</wea:group>
</wea:layout>
</body>
</html>
