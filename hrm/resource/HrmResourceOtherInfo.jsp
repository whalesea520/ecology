<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OtherInfoTypeComInfo" class="weaver.hrm.tools.OtherInfoTypeComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<FORM id=weaver name=frmmain method=post >
<div>
<%
if(HrmUserVarify.checkUserRight("HrmResourceOtherInfoAdd:Add", user, departmentid)){
%>
<BUTTON class=btnNew accessKey=N onclick="location='HrmResourceOtherInfoAdd.jsp?resourceid=<%=resourceid%>'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<%}%>
</div>
<br>
<UL>
<%
	RecordSet.executeProc("HrmResourceOtherInfo_Select",resourceid);
	while(RecordSet.next()){
		String infotype =RecordSet.getString(1);
		String infocount =RecordSet.getString(2);
		%>
		<LI> <a href="HrmResourceOtherInfoView.jsp?infotype=<%=infotype%>&resourceid=<%=resourceid%>"><%=Util.toScreen(OtherInfoTypeComInfo.getTypename(infotype),user.getLanguage())%> (<%=infocount%>)</a>
		  </li>
<%
}
%>
</ul>
</form>
</body>
</html>