
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.page.menu.*" %>
<%@ page import="weaver.general.*" %>
<%@ include file="/page/maint/common/initLoginNoCache.jsp"%>  
<jsp:useBean id="mu" class="weaver.page.maint.MenuUtil" scope="page" />
<%
	String menuid=Util.null2String(request.getParameter("menuid"));
	String menutype=Util.null2String(request.getParameter("menutype"));
	if(menutype.equals("menuh")){
		%>
		<span id="menuh" class="menuh">
		<%
		MenuH menuh=MenuHFactory.creatorMenuH(menuid);
		out.println(menuh.getMenuStr(menuid,null));
		 %>
		 <div style="clear: left" />
		</span>
		 <%
	}else{
		String returnStr= mu.getMenuTableStr_V(menuid,2);
		if(!"".equals(returnStr)){
			%>
		<div id="menuv" class="sdmenu">	  
		 <%
			
		    out.println(returnStr);
		%>
		</div>	
		<%} 
	}
%>