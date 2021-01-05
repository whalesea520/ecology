
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
StaticObj staticObj=StaticObj.getInstance(); 
List signErrorInfo = (List)staticObj.getObject("signErrorInfo");
%>
<html>
<head>
</head>
<body>
<%if(signErrorInfo!=null && !signErrorInfo.isEmpty()){ 
%>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(24960, user.getLanguage())%>'>
		<%for(int i=0;i<signErrorInfo.size();i++) {%>
		<wea:item attributes="{'colspan':'full'}"><span style="color: red;"><%=signErrorInfo.get(i)%></span></wea:item>
		<%} %>
	</wea:group>
</wea:layout>
<%staticObj.removeObject("signErrorInfo");} %>
</body>
</html>
