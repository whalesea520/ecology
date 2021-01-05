
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head></head>
<frameset name="pdocMain"  cols="175,6,*"  rows="*" frameborder="no" border="0" framespacing="5" > 
    <frame name="pdocLeft"  scrolling="auto"  src="PersonalDocLeft.jsp"   NORESIZE="true" > 
    <frame name="pdocCenter"  scrolling="no" src="PersonalDocCenter.jsp" NORESIZE="true" > 
    <frame name="pdocRight"  scrolling="auto" src="PersonalDocRight.jsp"  NORESIZE="true" > 
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    <%=SystemEnv.getHtmlLabelName(83630,user.getLanguage())%>
</body>
</noframes>
</html>
