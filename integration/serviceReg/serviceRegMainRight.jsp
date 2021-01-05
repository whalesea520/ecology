
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<script language=javascript src="/js/weaver_wev8.js"></script>
<html>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int language=user.getLanguage();
 //1数据源管理，2注册服务管理
 String showtype=Util.null2String(request.getParameter("showtype"));
%>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<br>
<%if(language!=8){%>
<p><strong>操作说明</strong></p>
<ul>
 
  	<%
  		if("1".equals(showtype)){
  	 %>
		  <li><%=SystemEnv.getHtmlLabelName(84443,user.getLanguage()) %></li>
		  <li><%=SystemEnv.getHtmlLabelName(84444,user.getLanguage()) %></li>
  <%}else{ %>
  	 	 <li><%=SystemEnv.getHtmlLabelName(84445,user.getLanguage()) %></li>
 		 <li><%=SystemEnv.getHtmlLabelName(84446,user.getLanguage()) %></li>
  	<%} %>
</ul>
<%}else{ %>
<p><strong>Operation Instruction</strong></p>
<ul>

	<%
  		if("1".equals(showtype)){
  	 %>
	  <li>Click on the left tree products, this page will display all of the products under the data source</li>
	  <li>The system administrator can service each data source maintenance</li>
  <%}else{ %>
	 	<li>Click on the left tree products, this page will display all of the products under the registered service</li>
	 	 <li>The system administrator can service each product maintenance</li>
  <%} %>
</ul>
<%}%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
</html>