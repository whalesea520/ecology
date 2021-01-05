<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.defined.MeetingWFUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CommunicateLog" class="weaver.sms.CommunicateLog" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">

</head>
<%
//会议流程设置
if(!HrmUserVarify.checkUserRight("Meeting:WFSetting", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}
String method=request.getParameter("method");
if("create".equals(method)){
	MeetingWFUtil.createTable();
}
boolean custom=true;
RecordSet.execute("SELECT count(1) as c FROM meeting_bill a right join workflow_bill b on a.tablename=b.tablename where  billid<>85");
RecordSet.next();
int c1 = RecordSet.getInt("c");
RecordSet.execute("SELECT count(1) as c FROM meeting_bill where  billid<>85");
RecordSet.next();
int c2 = RecordSet.getInt("c");
if(c1==0 && c2>0){
	RecordSet.execute("delete meeting_bill where billid<>85");
}else if(c1>0 && c2>0){
	custom=false;
}

String perpage="20";
String sqlwhere=" where defined=1 and isoldornew=1 ";
String backFields = " t1.* ";
String para2 = "column:id+column:isoldornew+-1";
String para3 = "column:isoldornew+"+user.getLanguage();
String sqlFrom = " view_workflowForm_selectAll t1 join meeting_bill t2 on t1.id=t2.billid ";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"meetingRemindTable\" tabletype=\"none\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"t1.id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
			  "			  <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15451,user.getLanguage())+"\" column=\"formname\" otherpara=\""+para2+"\" orderkey=\"formname\" />"+
              "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(18411,user.getLanguage())+"\" column=\"id\" otherpara=\""+para3+"\" transmethod=\"weaver.workflow.form.FormMainManager.getFormType\"/>"+
              "</head>";
tableString +=  "<operates>"+
				"		<operate href=\"javascript:viewDetail();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"</operates>";
tableString += "</table>";
        

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82377,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(custom){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82450,user.getLanguage())+",javascript:createForm(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<%if(custom){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82450,user.getLanguage()) %>" class="e8_btn_top" onclick="createForm()"/>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<form name="weaver" id="weaver" method="post" action="wfFormList.jsp">
	<input id="method" type="hidden" name="method">
</form>
<table width=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top">
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
	</td>
</tr>
</table>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript">


var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function doSubmit()
{
	_table.reLoad();
}

function closeDlgARfsh(){
	diag_vote.close();
	_table.reLoad();
}

function createForm(){
	$('#method').val("create");
	$('#weaver').submit();
}

function viewDetail(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(24087,user.getLanguage())%>";
	diag_vote.URL = "/meeting/defined/commonTab.jsp?_fromURL=MeetingWfForm&id="+id;
	diag_vote.show();
}       
       
</script>

</html>
