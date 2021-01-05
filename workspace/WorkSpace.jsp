
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.workspace.WorkSpaceStyle"%>

<%
    WorkSpaceStyle workSpaceStyle = new WorkSpaceStyle();
    String userId = String.valueOf(user.getUID());
    String userType = user.getLogintype();
	int styleType = 0;	
	styleType = workSpaceStyle.getStyleType(userId, userType);

    String srcStr = "";
    if (styleType == WorkSpaceStyle.WS_WORKPLAN)
        srcStr = "WorkPlanView.jsp";
    else
        srcStr = "WorkSpaceNews.jsp";
%>

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
</HEAD>
<frameset cols="*,6,200" frameborder="NO" border="0" framespacing="0" rows="*" id="workspace" name="workspace">
  <frameset rows="*,6,250" id="workspacemain" name="workspacemain">
    <frame name="workSpaceLeft" scrolling="YES" noresize src="<%=srcStr%>">
	<frame name="workSpaceControlViewInfo" scrolling="no" src="WorkSpaceControlViewInfo.jsp">
    <frame name="workSpaceInfo" src="WorkSpaceInfo.jsp" scrolling="no">
  </frameset>
  <frame name="workSpaceControlViewCalender" scrolling="no" src="WorkSpaceControlViewCalender.jsp">
  <frame name="workSpaceRight" scrolling="no" src="WorkSpaceRight.jsp">
</frameset>
<noframes>
<BODY>
</BODY>
</noframes>
</HTML>