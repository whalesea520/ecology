<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.file.Prop,weaver.general.GCONST"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML>
<HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>

<%
	String imagefilename = "/images/hdNoAccess_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(2011, user.getLanguage()) + "...";
	String needfav = "";
	String needhelp = "";
	int wfid = Util.getIntValue(Util.null2String(request.getParameter("wfid")), 0);
	String editor = Util.null2String(request.getParameter("editor"));
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">

		<TABLE class="Shadow">
			<tr>
				<td valign="top">

				<TABLE class=ViewForm>
					<COLGROUP>
						<COL width="30%">
						<COL width="70%">
					<TBODY>

						<TR class=Title>
							<TD colSpan=2 style="color:red"><%=SystemEnv.getHtmlLabelName(22257, user.getLanguage())%></TD>
						</TR>
						<TR class=Spacing>
							<TD class=Line1 colSpan=2></TD>
						</TR>

						<TR>
							<TD><%=SystemEnv.getHtmlLabelName(19690, user.getLanguage())%></TD>
							<TD class=Field><!--a href='javaScript:openhrm(<%=editor%>);' onclick='pointerXY(event);'--><%=ResourceComInfo.getResourcename(editor)%><!--/a--></TD>
						</TR>
						<TR>
							<TD><%=SystemEnv.getHtmlLabelName(19691, user.getLanguage())%></TD>
							<TD class=Field>
							<%if(WFManager.getEditor()!=-1){ %>
							<%=Util.null2String(WFManager.getEditdate())%><%
							if(!Util.null2String(WFManager.getEdittime()).equals("")){%> <%=WFManager.getEdittime()%><%}}%></TD>
						</TR>
						<TR>
							<TD class=Line colspan=2></TD>
						</TR>

					</TBODY>
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


</BODY>
</HTML>
