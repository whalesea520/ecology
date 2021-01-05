
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.parseBrowser.SapBrowserComInfo"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="RolesComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="WorkflowComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("SAPBrowserSetting:Manage",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(28229,user.getLanguage());
String needfav ="1";
String needhelp ="";



%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",sapbrowsersettingNew.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="SAPDataAuthSetting.jsp">
<input type="hidden" id="operation" name="operation">
<input type="hidden" id="method" name="method">
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<table class="liststyle" cellspacing=1>
				<COLGROUP> 
					<COL width="100%"> 
				</COLGROUP>
				<tbody>
					<TR class=Title>
					  <TH colSpan=4><%=titlename%></TH>
					</TR>
					<TR class=Spacing style="height:1px;">
					  <TD class=Line colSpan=4></TD>
					</TR>
					<TR class=Header>
					  <td><nobr><%=SystemEnv.getHtmlLabelName(28230,user.getLanguage())%></nobr></td>
					</TR>
					<TR class=Line><TH colspan="4"></TH></TR> 
					<%
					SapBrowserComInfo sbc = new SapBrowserComInfo();
					List allsapbrowserid = sbc.getAllBrowserId();
					
					for(int i = 0; i<allsapbrowserid.size(); i++){
						String sapbrowserid = Util.null2String((String)allsapbrowserid.get(i));
					%>
					<tr class="<%=i % 2== 0 ? "DataLight" : "DataDark" %>">
						<td><a href="sapbrowsersettingNew.jsp?sapbrowserid=<%=sapbrowserid %>"><%=sapbrowserid %></a></td>
					</tr>
					<%	
					}
					%>
				</tbody>
			</table>
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
  </FORM>
</BODY>

<script language="javascript">
function onSubmit(){

}
</script>

</HTML>
