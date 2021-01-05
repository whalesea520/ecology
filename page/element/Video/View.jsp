
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
	String qualityValue = (String)valueList.get(nameList.indexOf("quality"));
	String autoPlayValue = (String)valueList.get(nameList.indexOf("autoPlay"));
	String fullScreenValue = (String)valueList.get(nameList.indexOf("fullScreen"));
	String videoSrcValue = (String)valueList.get(nameList.indexOf("videoSrc"));
%>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<div id="video_play_<%=eid%>" style="width:100%;height:<%=heightValue%>">
<% if(isie){ %>
<OBJECT id="videoPlayer_<%=eid %>" height="<%=heightValue %>" width="100%" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
<PARAM value="/page/element/Video/resource/js/player.swf" name="movie" />
<PARAM value="#FFFFFF" name="bgcolor" />
<PARAM value='<%=qualityValue %>' name="quality" />
<PARAM value='<%=fullScreenValue.equals("on") %>' name="allowfullscreen" />
<PARAM value="always" name="allowscriptaccess" />
<param name="wmode" value="transparent" />
<PARAM value='file=<%=videoSrcValue %>&autostart=<%=autoPlayValue.equals("on") %>' name="flashvars" />
<embed src="/page/element/Video/resource/js/player.swf?file=<%=videoSrcValue %>&autostart=<%=autoPlayValue.equals("on") %>" 
		mce_src="flash/top.swf"  wmode="transparent" menu="false" quality="high"  
          width="100%" height="<%=heightValue%>" allowscriptaccess="sameDomain" type="application/x-shockwave-flash"  
         pluginspage="http://www.macromedia.com/go/getflashplayer" />
</OBJECT>
<%}else{%>
	<video  src="<%=videoSrcValue %>" style="width:100%" height="<%=heightValue%>" <%=autoPlayValue.equals("on")?" autoplay ='autoplay'":""%> controls="controls"></video > 
<%} %>
</div>

