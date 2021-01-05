
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
if(!HrmUserVarify.checkUserRight("SAPDataAuthSetting:Manage",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(28215,user.getLanguage());
String needfav ="1";
String needhelp ="";



%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",SAPDataAuthSettingNew.jsp,_self} " ;
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
					<COL width="15%"> 
					<COL width="35%"> 
					<COL width="25%">
					<COL width="25%">
				</COLGROUP>
				<tbody>
					<TR class=Title>
					  <TH colSpan=4><%=titlename%></TH>
					</TR>
					<TR class=Spacing style="height:1px;">
					  <TD class=Line colSpan=4></TD>
					</TR>
					<TR class=Header>
					  <td><nobr><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></nobr></td>
					  <td><nobr><%=SystemEnv.getHtmlLabelName(28216,user.getLanguage())%></nobr></td>
					  <td><nobr><%=SystemEnv.getHtmlLabelName(28217,user.getLanguage())%></nobr></td>
					  <td><nobr><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></nobr></td>
					</TR>
					<TR class=Line><TH colspan="4"></TH></TR> 
					<%
					int index = 0;
					rs.execute("select * from SAPData_Auth_setting order by id desc");
					while(rs.next()){
						int id = rs.getInt("id");
						String name = Util.null2String(rs.getString("name"));
						String browserids = Util.null2String(rs.getString("browserids"));
						String resourcetype = Util.null2String(rs.getString("resourcetype"));
						String resourceids = Util.null2String(rs.getString("resourceids"));
						String roleids = Util.null2String(rs.getString("roleids"));
						String wfids = Util.null2String(rs.getString("wfids"));
					%>
					<tr class="<%=index % 2== 0 ? "DataLight" : "DataDark" %>">
						<td><a href="SAPDataAuthSettingNew.jsp?settingid=<%=id %>"><%=name %></a></td>
						<td><%=browserids %></td>
						<td>
						<%
						
						if(resourcetype.equals("0")){
							String[] hrmidarr = Util.TokenizerString2(resourceids,",");
							String hrmnames = "";
							for(int i = 0; i<hrmidarr.length; i++){
								hrmnames += "<a href='/hrm/resource/HrmResource.jsp?id="+hrmidarr[i]+"' target='_blank'>" + ResourceComInfo.getLastname(hrmidarr[i]) + "</a>,";
							}
							if(hrmnames.length() > 0){
								hrmnames = hrmnames.substring(0,hrmnames.length()-1);
							}
						%>
						<%=SystemEnv.getHtmlLabelName(179,user.getLanguage()) + "：" + hrmnames %>
						<%
						}else if(resourcetype.equals("1")){
							String[] rolearr = Util.TokenizerString2(roleids,",");
							String rolenames = "";
							for(int i = 0; i<rolearr.length; i++){
								rolenames += RolesComInfo.getRolesname(rolearr[i]) + ",";
							}
							if(rolenames.length() > 0){
								rolenames = rolenames.substring(0,rolenames.length()-1);
							}
						%>
						<%=SystemEnv.getHtmlLabelName(122,user.getLanguage()) + "：" + rolenames %>
						<%
						}
						%>
						</td>
						<td>
						<%
						String[] wfidarr = Util.TokenizerString2(wfids,",");
						String wfnames = "";
						for(int i = 0; i<wfidarr.length; i++){
							wfnames += WorkflowComInfo.getWorkflowname(wfidarr[i]) + ",";
						}
						if(wfnames.length() > 0){
							wfnames = wfnames.substring(0,wfnames.length()-1);
						}
						%>
						<%=wfnames %>
						</td>

					</tr>
					<%	
						index++;
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
