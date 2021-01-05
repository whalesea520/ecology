
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY>

<%
boolean canmaint = HrmUserVarify.checkUserRight("Voting:Maint",user);
boolean canParticular = HrmUserVarify.checkUserRight("Voting:particular",user);
if(!canmaint && !canParticular) {//如果有网上调查维护和查看详细结果的权限就可以看此报表
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String userid = ""+user.getUID();
int perpage = Util.getIntValue(request.getParameter("perpage"),10);

String votingname = "";
String votingid = Util.null2String(request.getParameter("votingid"));
String subjettype = Util.null2String(request.getParameter("subjettype"));
String SqlWhere = "";
String backFields = "";
String sqlFrom = "";
String orderby = " a.resourceid,a.questionid,a.operatedate,a.operatetime ";
String columnstr = "";
String columnname = "";
String isanony="0";
String sql = " select distinct v.subject,v.isanony from Voting v where v.id="+votingid;
rs.executeSql(sql);
while(rs.next()){
		isanony = rs.getString("isanony");
}

	backFields = "votingid,operatedate,operatetime,(select subject from voting where id = a.votingid) as votingname,"+
	" (select subject from votingquestion where id = a.questionid) as questionname,"+
	" resourceid,questionid,"+
	" (select workcode from hrmresource where id = a.resourceid) as workcode,"+
	" (select subcompanyid1 from hrmresource where id = a.resourceid) as subcompanyid,"+
	" (select departmentid from hrmresource where id = a.resourceid) as departmentid,"+
	" (select description from votingoption where id = a.optionid  and votingid = a.votingid ) as optionname,"+
	" (select otherinput from votingresourceremark where votingid = a.votingid and questionid = a.questionid and resourceid = a.resourceid) as otherinput";
	sqlFrom  = " votingresource a ";
	//orderby = " b.id,f.id ";
	if("".equals(votingid)){
		SqlWhere = " 1 = 2 ";
	} else {
		SqlWhere = " votingid= "+votingid;
		rs.executeSql("select subject from Voting where id="+votingid);
		if(rs.next()) votingname = "<a href='/voting/VotingView.jsp?votingid="+votingid+"' target='_blank'>"+rs.getString(1)+"</a>";
	}
	
	String tableString = "";
	if ("1".equals(isanony)){
		 tableString="<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
    "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"a.votingid\" sqlorderby=\""+orderby+"\" sqlsortway=\"desc\"  sqlisdistinct=\"false\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
    "<head>"+
	"<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(24118,user.getLanguage())+"\" column=\"votingid\" orderkey=\"votingid\"/>"+
	"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(24096,user.getLanguage())+"\" column=\"votingname\" orderkey=\"votingname\"  href=\"/voting/VotingView.jsp\" linkvaluecolumn=\"votingid\" linkkey=\"votingid\" target=\"blank\"/>"+
	"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(24119,user.getLanguage())+"\" column=\"questionname\" orderkey=\"questionname\" />"+
	"<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" href=\"/hrm/company/HrmDepartment.jsp\" linkkey=\"subcompanyid\" target=\"blank\"/>"+
	"<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\"  column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" href=\"/hrm/company/HrmDepartmentDsp.jsp\" linkkey=\"departmentid\" target=\"blank\"/>"+
	"<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(24120,user.getLanguage())+"\"  column=\"optionname\" orderkey=\"optionname\"/>"+
	"<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(24122,user.getLanguage())+"\"  column=\"otherinput\" orderkey=\"otherinput\"/>"+"</head>"+"</table>";

	} else {	
    tableString="<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
    "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"a.votingid\" sqlorderby=\""+orderby+"\" sqlsortway=\"desc\"  sqlisdistinct=\"false\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
    "<head>"+
	"<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(24118,user.getLanguage())+"\" column=\"votingid\" orderkey=\"votingid\"/>"+
	"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(24096,user.getLanguage())+"\" column=\"votingname\" orderkey=\"votingname\"  href=\"/voting/VotingView.jsp\" linkvaluecolumn=\"votingid\" linkkey=\"votingid\" target=\"blank\"/>"+
	"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(24119,user.getLanguage())+"\" column=\"questionname\" orderkey=\"questionname\" />"+
	"<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" href=\"/hrm/company/HrmDepartment.jsp\" linkkey=\"subcompanyid\" target=\"blank\"/>"+
	"<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\"  column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" href=\"/hrm/company/HrmDepartmentDsp.jsp\" linkkey=\"departmentid\" target=\"blank\"/>"+
	"<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(19401,user.getLanguage())+"\"  column=\"workcode\" orderkey=\"workcode\"/>"+
	"<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\"  column=\"resourceid\" orderkey=\"resourceid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" href=\"/hrm/resource/HrmResource.jsp\" linkkey=\"resourceid\" target=\"blank\"/>"+
	"<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(24120,user.getLanguage())+"\"  column=\"optionname\" orderkey=\"optionname\"/>"+
	"<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(24122,user.getLanguage())+"\"  column=\"otherinput\" orderkey=\"otherinput\"/>"+"</head>"+"</table>";
	}
%>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(24121,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+"Excel,javascript:_xtable_getAllExcel(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<FORM id=report name=report action=VotingResultRp.jsp method=post>
			<TABLE class=ViewForm border=0>
				<COLGROUP> <COL width="10%"> <COL width="40%"> <COL width="10%"> <COL width="40%">
				<TBODY>
				<TR class=Spacing>
					<TD class=Line1 colSpan=4></TD>
				</TR>
				<TR>
					<TD><%=SystemEnv.getHtmlLabelName(24096,user.getLanguage())%></TD>
					<TD class=Field>
						<INPUT class=wuiBrowser id=votingid type=hidden name=votingid value="<%=votingid%>"
						_url="/systeminfo/BrowserMain.jsp?url=/voting/VotingInfoBrowser.jsp?status=1,2" _required="yes"
						_displayTemplate="<a href='/voting/VotingView.jsp?votingid=#b{id}' target='_blank'>#b{name}</a>"
						_displayText="<%=votingname%>"
						>
					</TD>
				</TR>
				<TR style="height:2px" ><TD class=Line colSpan=4></TD></TR>				
			</TBODY>
			</TABLE>
			</FORM>
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
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
<script language=vbs>
sub onShowVoting()
	idstr = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/voting/VotingInfoBrowser.jsp?status=1,2")
	if NOT isempty(idstr) then
		if idstr(0)<> 0 then
			votingnamedesc.innerHtml="<a href='/voting/VotingView.jsp?votingid="+idstr(0)+"' target='_blank'>"&idstr(1)&"</a>"
			report.votingid.value=idstr(0)
		else
			votingnamedesc.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			report.votingid.value=""
		end if
	end if
end sub
</script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function onSubmit(){
    if(check_form(document.report,"votingid")){
		document.report.submit();
	}
}
</script>
</HTML>
