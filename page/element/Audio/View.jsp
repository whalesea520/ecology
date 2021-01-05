
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>

<%
	String agent = request.getHeader("User-Agent").toLowerCase(); 
	boolean isie = false;
	//识别IE浏览器  
	if (agent != null && (agent.indexOf("msie") != -1 ||   
	        (agent.indexOf("rv") != -1 && agent.indexOf("firefox") == -1))) {  
		isie = true;
	}
	String heightValue = (String)valueList.get(nameList.indexOf("height"));
	String widthValue = (String)valueList.get(nameList.indexOf("width"));
	String autoPlayValue = (String)valueList.get(nameList.indexOf("autoPlay"));
	String audioSrcValue = (String)valueList.get(nameList.indexOf("audioSrc"));
%>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>


<div id="audio_play_<%=eid%>" style="width:<%="100%"%>;height:<%=heightValue%>">
<% if(isie){ %>
<object id="audioplayer_<%=eid%>" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" align="middle" height="<%=heightValue%>" width="<%="100%"%>">
    <param name="quality" value="best">
	<param name="SAlign" value="LT">
    <param name="allowScriptAccess" value="never">
    <param name="wmode" value="transparent">
    <param name="movie" value="<%=ePath%>resource/js/audio-player.swf?audioUrl=<%=audioSrcValue%>&<%=autoPlayValue.equals("on")?"autoPlay=true":""%>">
    <embed src="<%=ePath%>resource/js/audio-player.swf?audioUrl=<%=audioSrcValue%>&<%=autoPlayValue.equals("on")?"autoPlay=true":""%>" mce_src="flash/top.swf"  wmode="transparent" menu="false" quality="high"  
          width="100%" height="<%=heightValue%>" allowscriptaccess="sameDomain" type="application/x-shockwave-flash"  
         pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object>
<%}else{%>
	<audio  src="<%=audioSrcValue %>" style="width:100%" height="<%=heightValue%>" <%=autoPlayValue.equals("on")?"autoplay ='autoplay'":""%> controls="controls"></audio > 
<%} %>
</div>