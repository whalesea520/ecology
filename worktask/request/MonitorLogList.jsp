
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
String sqlWhere = "";
boolean hasRight = false;
if(HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
	hasRight = true;
}
int isfromself = Util.getIntValue(request.getParameter("isfromself"), 0);
int opter = Util.getIntValue(request.getParameter("opter"), -1);
String beginDate = Util.null2String(request.getParameter("beginDate"));
String endDate = Util.null2String(request.getParameter("endDate"));
int opttype = 1;
if(isfromself==0 && opter<=0){
	opter = user.getUID();
}
sqlWhere = " where opttype="+opttype+" ";
if(hasRight == true){
	if(opter <= 0){
		sqlWhere += " and 1=1 ";
	}else{
		sqlWhere += " and opter="+opter+" ";
	}
}else{
	opter = user.getUID();
	sqlWhere += " and opter="+opter+" ";
}


if(!"".equals(beginDate)){
	sqlWhere += " and optdate >= '"+beginDate+"' ";
}
if(!"".equals(endDate)){
	sqlWhere += " and optdate <= '"+endDate+"' ";
}

String sqlFrom = " worktask_monitorlog ";

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16539,user.getLanguage()) + "&nbsp;-&nbsp;" + SystemEnv.getHtmlLabelName(24622,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onReSearch(),_self}";
RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="searchform" name="searchform" method="post" action="MonitorLogList.jsp">
<input type="hidden" id="isfromself" name="isfromself" value="1">
<TABLE width="100%" height="95%" border="0" cellspacing="0" cellpadding="0">


	<TR>

		<TD valign="top">
			<TABLE class="Shadow">
				<TR>
					<TD valign="top">
					<table class="viewform" style='width: 100%;'>
					<COLGROUP>
						<COL width="15%">
						<COL width="30%">
						<COL width="15%">
						<COL width="40%">
					</COLGROUP>
						<TBODY>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></td>
							<td class="field">
							<input type="hidden" id="opter" name="opter" value="<%=opter%>">
							<%if(hasRight == true){%>
							<button type='button' class="browser" onClick="onShowResource('opter', 'opterspan')"></button>
							<%}%>
							<span id="opterspan"><%=resourceComInfo.getResourcename(""+opter)%></span>
							</td>
							<td><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%></td>
							<td class="field">
								<button type='button' class="calendar" id="SelectBeginDate" onclick="getDate(beginDatespan,beginDate)"></BUTTON>
								<SPAN id="beginDatespan"><%=beginDate%></SPAN>
								&nbsp;&nbsp;-&nbsp;&nbsp;
								<button type='button' class="calendar" id="SelectEndDate" onclick="getDate(endDatespan,endDate)"></BUTTON>
								<SPAN id="endDatespan"><%=endDate%></SPAN>
								<input type="hidden" id="beginDate" name="beginDate" value="<%=beginDate%>">
								<input type="hidden" id="endDate" name="endDate" value="<%=endDate%>">
							</td>
						</tr>
						<TR style="height: 1px;"><TD class="Line" colSpan="4"></TD></TR>
						</TBODY>
					</table>
				</br>
				<table  class="viewform">
				<TR>
					<TD valign="top">					
					<%
						String tableString=""+
					    "<table pagesize=\"20\" tabletype=\"none\">"+
					    "<sql backfields=\"id,requestid, taskcontent, requeststatus, opter, optdate, opttime, opttype\" sqlisdistinct=\"true\" sqlform=\"" + sqlFrom + "\" sqlprimarykey=\"id\" sqlorderby=\"id\" sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					    "<head>"+
					    "<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(22134,user.getLanguage())+"\" column=\"taskcontent\" orderkey=\"requestid\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getTaskContentWithId\" otherpara=\"column:requestid\" />"+
					    "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(17524,user.getLanguage())+"\" column=\"requeststatus\" orderkey=\"requeststatus\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getRequestStatusName\" otherpara=\""+user.getLanguage()+"\"/>"+
					    "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"\" column=\"opter\" orderkey=\"opter\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getUserLink\" />"+						    
					    "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(15502,user.getLanguage())+"\" column=\"optdate\" orderkey=\"optdate\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getOptTime\" otherpara=\"column:opttime\" />"+			    
					    "</head>"+
					    "</table>";
					%>
					<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
					</TD>
				</TR>
				</table>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD></TD>
	</TR>
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
</TABLE>
</form>
</BODY>
</HTML>

<SCRIPT language=javascript>  
function onReSearch(){
	document.searchform.submit();
	enableAllmenu();
}
</SCRIPT>
<script language=vbs>
sub onShowResource(inputname, spanname)
	tmpval = document.getElementById(inputname).value
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
			document.all(spanname).innerHtml = id(1)
			document.getElementById(inputname).value = id(0)
		else
			document.all(spanname).innerHtml = ""
			document.getElementById(inputname).value = ""
		end if
	end if
end sub
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
