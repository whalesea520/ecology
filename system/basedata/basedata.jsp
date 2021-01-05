<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
int userid=user.getUID();
if(! HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17688,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<body>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

    	<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
		<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
		<tr>
			<td ></td>
			<td valign="top">
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">

		<TABLE class=ListStyle cellspacing=1>
		<COLGROUP>
		<COL width="100%">



		<TR class=Header>
			<TH><%=SystemEnv.getHtmlLabelName(15051,user.getLanguage())%></TH>
		</TR>

		<TR class=Line>
			<TD colSpan=3></TD>
		</TR>

		<TR class=DataDark>
			<TD><a href="basedata_doc.jsp"><%=SystemEnv.getHtmlLabelName(2115,user.getLanguage())%></a></TD>
		</TR>
		<TR class=DataDark>
			<TD><a href="basedata_workflow.jsp"><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></a></TD>
		</TR>
		<TR class=DataLight>	
			<TD><a href="basedata_role.jsp"><%=SystemEnv.getHtmlLabelName(15052,user.getLanguage())%></a></TD>
		</TR>
		<TR class=DataDark>
			<TD><a href="basedata_hrmrole.jsp"><%=SystemEnv.getHtmlLabelName(15053,user.getLanguage())%></a></TD>
		</TR>

		</TABLE>
			</td>
			</tr>
			</TABLE>
			
			</td>
			<td></td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
	</table>

</body>
</HTML>
