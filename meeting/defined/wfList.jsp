<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.defined.MeetingWFUtil"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.*" %>

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
//流程设置权限
boolean wfPermission=true;
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user))
{
	wfPermission=false;
}


String formids="85";
RecordSet.execute("select DISTINCT billid from meeting_bill where billid<>85");
while(RecordSet.next()){
	String billid=RecordSet.getString("billid");
	if(!"".equals(billid)){
		formids+=","+billid;
	}
}

String perpage="20";
String sqlwhere=" where formid in("+formids+") and (istemplate is null or istemplate<>'1') ";

String workflowname=Util.null2String(request.getParameter("workflowname"));
String formname=Util.null2String(request.getParameter("formname"));
if(!"".equals(workflowname)){
	sqlwhere+=" and workflowname like'%"+workflowname+"%'";
}
if(!"".equals(formname)){
	sqlwhere+=" and formid = '"+formname+"'";
}

String backFields = " id,workflowname,workflowdesc,istemplate,workflowtype,dsporder,subcompanyid,isbill,formid,officalType ";
String sqlFrom = "  workflow_base   ";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"meetingRemindTable\" tabletype=\"none\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+  
			  "			  <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(81651,user.getLanguage())+"\" column=\"id\" otherpara=\""+String.valueOf(wfPermission)+"\" orderkey=\"workflowname\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getWfNameForWfDoc\"/>"+
              "			  <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15600,user.getLanguage())+"\" column=\"isbill\" orderkey=\"formid\" otherpara=\"column:formid+"+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.WFMainManager.getFormName\"/>"+
              "</head>";
tableString +=  "<operates>"+
				"		<popedom column=\"id\" otherpara=\""+String.valueOf(wfPermission)+"+column:formid\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingWFOpt\"></popedom> "+
				"		<operate href=\"javascript:viewDetail();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:setAction();\" text=\""+SystemEnv.getHtmlLabelName(33085,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		<operate href=\"javascript:testBillid();\" text=\""+SystemEnv.getHtmlLabelNames("22011,83023,33277",user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
				"</operates>";
tableString += "</table>";
        

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(81896,user.getLanguage());
String needfav ="1";
String needhelp ="";

RecordSet.execute("select id,namelabel from workflow_bill where id in("+formids+")");
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(wfPermission){
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addwf(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<%if(wfPermission){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName( 611 ,user.getLanguage())%>" class="e8_btn_top" onclick="addwf()"/>
			<%} %>
			<input type="text" class="searchInput" id="t_name" name="t_name" /> 
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv">
<form name="weaver" id="weaver" method="post" action="wfList.jsp">
	<input id="method" type="hidden" name="method">
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
			<!-- 流程名称 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(81651,user.getLanguage())%></wea:item>
			<wea:item>
            	<input class=inputstyle type="text" id="workflowname" name="workflowname"  style="width:60%" value="<%=workflowname %>">
			
            </wea:item>
			<!-- 会议表单 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></wea:item>
            <wea:item>
            	<select name="formname">
            		<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
            		<%
            		while(RecordSet.next()){
            		%>	
            		<option value="<%=RecordSet.getString("id") %>" <%=formname.equals(RecordSet.getString("id"))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage())%></option>
            		<%
            		}
            		%>
            	</select>
            </wea:item>
		</wea:group>
		<wea:group context="">
	    	<wea:item type="toolbar">
				<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>

				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>

				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</form>

</div>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
	var w= document.body.offsetWidth-50;
	var h= document.body.offsetHeight-50
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = w;
	diag_vote.Height = h;
	diag_vote.Modal = true;
	diag_vote.closeHandle=refreshListData;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(81896,user.getLanguage())%>";
	diag_vote.URL = "/workflow/workflow/addwf.jsp?src=editwf&wfid="+id+"&isTemplate=0&&isdialog=1";
	diag_vote.show();
}       

function addwf(){
	var w= document.body.offsetWidth-50;
	var h= document.body.offsetHeight-50
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = w;
	diag_vote.Height = h;
	diag_vote.Modal = true;
	diag_vote.closeHandle=refreshListData;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(81896,user.getLanguage())%>";
	diag_vote.URL = "/workflow/workflow/addwf.jsp?isTemplate=0&iscreat=1&&isdialog=1";
	diag_vote.show();
}

function refreshListData(){
	_table.reLoad();
}
function setAction(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 300;
	diag_vote.Height = 120;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(33085,user.getLanguage())%>";
	diag_vote.URL = "/meeting/defined/wfAction.jsp?id="+id;
	diag_vote.show();
}

function testBillid(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 400;
	diag_vote.Height = 240;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(22011, user.getLanguage())%>";
	diag_vote.URL = "/meeting/defined/wfTestBillid.jsp?method=testBillid&id="+id;
	diag_vote.show();
}

function preDo(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("input[name='workflowname']").val(name);
	doSearchsubmit();
}  

function doSearchsubmit(){
	$('#weaver').submit();
}    
</script>

</html>
