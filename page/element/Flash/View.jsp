
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>
<%
	String widthValue = (String)valueList.get(nameList.indexOf("width"));
	String heightValue = (String)valueList.get(nameList.indexOf("height"));
	String flashSrc = (String)valueList.get(nameList.indexOf("flashSrc"));
%>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<div id="flash_play_<%=eid%>" style="width:100%;height:<%=heightValue%>px;overflow-y:hidden">
<!-- 
<object id ="flashPlayer_<%=eid %>"     
        type="application/x-shockwave-flash" width="100%" height="<%=heightValue%>">
        <param name="movie" value="<%=flashSrc%>" />
         <param name="wmode" value="transparent" />

</object>
 -->
<embed width="100%" height="<%=heightValue%>px;" wmode="opaque" name="plugin" src="<%=flashSrc%>" type="application/x-shockwave-flash">
</div>
