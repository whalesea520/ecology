
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.Util" %>

<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">	
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>

<%User user = HrmUserVarify.getUser (request , response) ;
	String imagefilename = "";
	String titlename = SystemEnv.getHtmlLabelName(16539,user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	
	String workid = "" + Util.getIntValue(request.getParameter("workid"),0);
	String add = "" + Util.getIntValue(request.getParameter("add"),0);
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	
	
%>


<FRAMESET cols="*" frameborder="NO" border="0" framespacing="0"  rows="*" id="workplan" name="workplan" scrolling="no"> 
	<FRAME name="workplanLeft" scrolling="no" noresize  src="/workplan/data/WorkPlanView.jsp?isShare=1">
</FRAMESET>

<NOFRAMES>
	<BODY>
		<%//@ include file="/systeminfo/TopTitle.jsp" %>
		<%// response.sendRedirect(srcStr); %>
	</BODY>
</NOFRAMES>

</HTML>