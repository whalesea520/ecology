
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<STYLE TYPE="text/css">
/*样式名未定义*/
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 
</STYLE>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="recordSet_requestbase" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet_operator" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="poppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>


<%
int isRefash = Util.getIntValue(request.getParameter("isRefash"), 0);
int isfromworkflow = Util.getIntValue(request.getParameter("isfromworkflow"), 0);
session.setAttribute("relaterequest", "new");
//权限判断，确定菜单 Start
boolean canView = false;
boolean canEdit = false;
boolean canBack = false;
boolean canCheck = false;
boolean canCancel = false;
boolean canDel = false;
boolean canApprove = false;
boolean canSubmit = false;
boolean canRemark = false;
boolean canToMould = false;

int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int operatorid = Util.getIntValue(request.getParameter("operatorid"), 0);

if(requestid == 0 && operatorid != 0){
		recordSet_operator.execute("select * from worktask_operator where id="+operatorid);
		if(recordSet_operator.next()){
			requestid = Util.getIntValue(recordSet_operator.getString("requestid"), 0);
		}
}

//直接跳转到新界面
response.sendRedirect("/worktask/pages/worktaskoperate.jsp?requestid="+requestid);
int operatorid_in = Util.getIntValue(request.getParameter("operatorid"), 0);//用于判断来源
int requestid_in = Util.getIntValue(request.getParameter("requestid"), 0);
String worktaskName = "";
String worktaskStatusName = "";
boolean shouldReturn = false;
int wtid = 0;
int request_status = 0;
int operator_optstatus = 0;
int operator_type = 0;
int operator_userid = 0;
if(requestid != 0 || operatorid != 0){
	if(operatorid != 0){
		int requestid_tmp = 0;
		recordSet_operator.execute("select * from worktask_operator where id="+operatorid);
		if(recordSet_operator.next()){
			requestid_tmp = Util.getIntValue(recordSet_operator.getString("requestid"), 0);
			operator_optstatus = Util.getIntValue(recordSet_operator.getString("optstatus"), 0);
			operator_type = Util.getIntValue(recordSet_operator.getString("type"), 0);
			operator_userid = Util.getIntValue(recordSet_operator.getString("userid"), 0);
		}else{
			shouldReturn = true;
		}
		
		if(requestid_tmp == 0){
			response.sendRedirect("/notice/noright.jsp");
			return;
		}else{
			requestid = requestid_tmp;
			recordSet_requestbase.execute("select * from worktask_requestbase where requestid="+requestid);
			if(recordSet_requestbase.next()){
				wtid = Util.getIntValue(recordSet_requestbase.getString("taskid"), 0);
				request_status = Util.getIntValue(recordSet_requestbase.getString("status"), 0);
				int deleted = Util.getIntValue(recordSet_requestbase.getString("deleted"), 0);
				if(deleted == 1){
					response.sendRedirect("/notice/noright.jsp");
					return;
				}
			}else{
				shouldReturn = true;
			}
		}
	}else if(requestid != 0){
		recordSet_requestbase.execute("select * from worktask_requestbase where requestid="+requestid);
		if(recordSet_requestbase.next()){
			wtid = Util.getIntValue(recordSet_requestbase.getString("taskid"), 0);
			request_status = Util.getIntValue(recordSet_requestbase.getString("status"), 0);
			int deleted = Util.getIntValue(recordSet_requestbase.getString("deleted"), 0);
			if(deleted == 1){
				shouldReturn = true;
			}
			int liableperson_tmp = Util.getIntValue(recordSet_requestbase.getString("liableperson"), 0);//非单责任人，则把operatorid清为0
			if(liableperson_tmp!=0 && operatorid==0 && request_status>=6){
				recordSet_operator.execute("select * from worktask_operator where type=1 and userid="+liableperson_tmp+" and requestid="+requestid);
				if(recordSet_operator.next()){
					int operatorid_tmp = Util.getIntValue(recordSet_operator.getString("id"), 0);
					operator_optstatus = Util.getIntValue(recordSet_operator.getString("optstatus"), 0);
					operator_type = Util.getIntValue(recordSet_operator.getString("type"), 0);
					operatorid = operatorid_tmp;
				}else{
					shouldReturn = true;
				}
			}
		}else{
			shouldReturn = true;
		}
	}
}else{
	shouldReturn = true;
}
if(shouldReturn == true){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

WTRequestManager wtRequestManager = new WTRequestManager(wtid);
wtRequestManager.setLanguageID(user.getLanguage());
wtRequestManager.setUserID(user.getUID());
int needcheck = Util.getIntValue(recordSet_requestbase.getString("needcheck"), 0);
int checkor = Util.getIntValue(recordSet_requestbase.getString("checkor"), 0);
if(needcheck == 0){
	checkor = 0;
}
int creater = Util.getIntValue(recordSet_requestbase.getString("creater"), 0);
int approverequest = Util.getIntValue(recordSet_requestbase.getString("approverequest"), 0);
Hashtable checkRight_hs = wtRequestManager.checkRight(requestid, request_status, operator_optstatus, creater, checkor, approverequest);
canView = (Util.null2String((String)checkRight_hs.get("canView"))).equalsIgnoreCase("true")?true:false;
canEdit = (Util.null2String((String)checkRight_hs.get("canEdit"))).equalsIgnoreCase("true")?true:false;
canBack = (Util.null2String((String)checkRight_hs.get("canBack"))).equalsIgnoreCase("true")?true:false;
canCheck = (Util.null2String((String)checkRight_hs.get("canCheck"))).equalsIgnoreCase("true")?true:false;
canCancel = (Util.null2String((String)checkRight_hs.get("canCancel"))).equalsIgnoreCase("true")?true:false;
canDel = (Util.null2String((String)checkRight_hs.get("canDel"))).equalsIgnoreCase("true")?true:false;
canApprove = (Util.null2String((String)checkRight_hs.get("canApprove"))).equalsIgnoreCase("true")?true:false;
canSubmit = (Util.null2String((String)checkRight_hs.get("canSubmit"))).equalsIgnoreCase("true")?true:false;
int nodetype = Util.getIntValue((String)checkRight_hs.get("nodetype"), -1);
//任务另存为模板
if(creater==user.getUID() || checkor==user.getUID()){
	canToMould = true;
}
if(operator_optstatus==2 && HrmUserVarify.checkUserRight("Worktask:remark", user) && resourceComInfo.getDepartmentID(""+operator_userid).equals(resourceComInfo.getDepartmentID(""+user.getUID()))){
	canRemark = true;
}
int usertype = 1;
if("1".equals(user.getLogintype())){
	usertype = 0;
}else if("2".equals(user.getLogintype())){
	usertype = 1;
}
//来自流程界面，特殊处理：具有流程查看权限，就能查看该计划任务
if(canView==false && isfromworkflow==1){
	int deswtrequestcount = Util.getIntValue(request.getParameter("deswtrequestcount"), 0);
	int wt_requestid = Util.getIntValue(request.getParameter("deswtrequestid"+deswtrequestcount), 0);
	if(wt_requestid == requestid_in){
		int sourceworkflowid = Util.getIntValue((String)session.getAttribute("sourceworkflowid"), 0);
		rs.executeSql("select requestid from workflow_currentoperator where userid="+user.getUID()+" and usertype="+usertype+" and requestid="+sourceworkflowid);
	    if(rs.next()){
        	canView = true;
	    }
	}
}
if(canView == false){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
//权限判断，确定菜单 End
//处理worktask_operator的viewtype
if(operatorid!=0 && user.getUID()==operator_userid){
	rs.execute("update worktask_operator set viewtype=0 where id="+operatorid_in);
}
if(operatorid!=0 && user.getUID()==checkor){
	rs.execute("update worktask_operator set checkorviewtype=0 where id="+operatorid_in);
}
if(operatorid!=0 && user.getUID()==creater){
	rs.execute("update worktask_operator set createrviewtype=0 where id="+operatorid_in);
}
if(approverequest != 0){
	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" + Util.add0(today.get(Calendar.MINUTE), 2) + ":" + Util.add0(today.get(Calendar.SECOND), 2);
	rs.execute("update workflow_currentoperator set viewtype=-2, operatedate='"+currentdate+"', operatetime='"+currenttime+"' where requestid = " + approverequest + "  and userid ="+user.getUID()+" and usertype = "+usertype+" and viewtype<>-2 ");
	int iscomplete = 0;
	rs.execute("select currentnodetype from workflow_requestbase where requestid="+approverequest);
	if(rs.next()){
		int currentnodetype_tmp = Util.getIntValue(rs.getString(1), 0);
		if(currentnodetype_tmp == 3){
			iscomplete = 1;
		}
	}
	//由于没有抄送的提交按钮，所以2种抄送，都只要查看就认为操作过
	rs.execute("update workflow_currentoperator set iscomplete="+iscomplete+", isremark='2', preisremark='8' where isremark in ('8','9') and requestid = " + approverequest + "  and userid ="+user.getUID()+" and usertype = "+usertype);
	poppupRemindInfoUtil.updatePoppupRemindInfo(user.getUID(), 0, user.getLogintype().equals("1")?"0":"1", approverequest);
	poppupRemindInfoUtil.updatePoppupRemindInfo(user.getUID(), 1, user.getLogintype().equals("1")?"0":"1", approverequest);
	poppupRemindInfoUtil.updatePoppupRemindInfo(user.getUID(), 10, user.getLogintype().equals("1")?"0":"1", approverequest);
}
Hashtable worktaskStatus_hs = new Hashtable();
rs.execute("select * from SysPubRef where masterCode='WorkTaskStatus' and flag=1");
while(rs.next()){
	int detailCode_tmp = Util.getIntValue(rs.getString("detailCode"), 0);
	String worktaskStatusName_tmp = SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("detailLabel")), user.getLanguage());
	worktaskStatus_hs.put("worktaskstatus_"+detailCode_tmp, worktaskStatusName_tmp);
	if(request_status == detailCode_tmp){
		worktaskStatusName = worktaskStatusName_tmp;
	}
}

Hashtable canCreateTasks_hs = wtRequestManager.getCanCreateTasks(false);

worktaskName = (String)canCreateTasks_hs.get("tasks_"+wtid);
String tasksSelectStr = (String)canCreateTasks_hs.get("tasksSelectStr");

Hashtable ret_hs_1 = wtRequestManager.getViewFieldInfo();
ArrayList textheightList = (ArrayList)ret_hs_1.get("textheightList");
ArrayList idList = (ArrayList)ret_hs_1.get("idList");
ArrayList fieldnameList = (ArrayList)ret_hs_1.get("fieldnameList");
ArrayList crmnameList = (ArrayList)ret_hs_1.get("crmnameList");
ArrayList ismandList = (ArrayList)ret_hs_1.get("ismandList");
ArrayList fieldhtmltypeList = (ArrayList)ret_hs_1.get("fieldhtmltypeList");
ArrayList typeList = (ArrayList)ret_hs_1.get("typeList");
ArrayList wttypeList = (ArrayList)ret_hs_1.get("wttypeList");
ArrayList iseditList = (ArrayList)ret_hs_1.get("iseditList");
ArrayList defaultvalueList = (ArrayList)ret_hs_1.get("defaultvalueList");
ArrayList defaultvaluecnList = (ArrayList)ret_hs_1.get("defaultvaluecnList");
ArrayList fieldlenList = (ArrayList)ret_hs_1.get("fieldlenList");

int annexmaincategory = 0;
int annexsubcategory = 0;
int annexseccategory = 0;
rs.execute("select * from worktask_base where id="+wtid);
if(rs.next()){
	annexmaincategory = Util.getIntValue(rs.getString("annexmaincategory"), 0);
	annexsubcategory = Util.getIntValue(rs.getString("annexsubcategory"), 0);
	annexseccategory = Util.getIntValue(rs.getString("annexseccategory"), 0);
}
int maxUploadImageSize = 5;
maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexseccategory), 5);
if(maxUploadImageSize<=0){
	maxUploadImageSize = 5;
}
%>
<HTML><HEAD>
<title><%=Util.toScreen(worktaskName, user.getLanguage())%></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/xmlextras_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
</HEAD>
<%
String needfav ="1";
String needhelp ="";
String titlename = SystemEnv.getHtmlLabelName(82, user.getLanguage())+": "+worktaskName;
String imagefilename = "/images/hdMaintenance_wev8.gif";
%>
<BODY id="taskbody">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %> 
<%
if(canSubmit == true){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15143, user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(canEdit==true && operatorid_in==0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93, user.getLanguage())+",javaScript:doEdit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(canApprove==true && nodetype==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(142, user.getLanguage())+",javaScript:OnApprove(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(236, user.getLanguage())+",javaScript:OnReject(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}else if(canApprove==true && nodetype==2){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(615, user.getLanguage())+",javaScript:OnApprove(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(canBack==true && operatorid!=0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(21950, user.getLanguage())+",javaScript:OnExecute(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(canCheck==true && operatorid!=0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15357, user.getLanguage())+",javaScript:OnCheck(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(canRemark==true && operatorid!=0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(454, user.getLanguage())+",javaScript:OnRemark(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(canToMould==true){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(19468, user.getLanguage())+",javaScript:OnToMould(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(creater==user.getUID() && operatorid_in==0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(119, user.getLanguage())+",javaScript:OnShare(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(canCancel == true){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javaScript:OnCancel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(canDel == true){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javaScript:OnDel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(isfromworkflow == 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83, user.getLanguage())+",javaScript:viewLog(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="worktask"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelName(33564,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16539,user.getLanguage()) %>'/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
		   <% if(canSubmit == true){ %>
			<span title="<%=SystemEnv.getHtmlLabelName(15143,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="OnSubmit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(15143,user.getLanguage()) %>"/>
			</span>
		   <%}%>
		   <% if(canEdit==true && operatorid_in==0){ %>
			<span title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doEdit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>"/>
			</span>
		    <%}%>
			<% if(canApprove==true && nodetype==1){ %>
			<span title="<%=SystemEnv.getHtmlLabelName(142,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="OnApprove()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(142,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="OnReject()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage()) %>"/>
			</span>
		    <%}%>
			<% if(canBack==true && operatorid!=0){ %>
			<span title="<%=SystemEnv.getHtmlLabelName(21950,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="OnExecute()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(21950,user.getLanguage()) %>"/>
			</span>
		    <%}%>
			<% if(canCheck==true && operatorid!=0){ %>
			<span title="<%=SystemEnv.getHtmlLabelName(15357,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="OnCheck()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(15357,user.getLanguage()) %>"/>
			</span>
		    <%}%>
			<% if(canRemark==true && operatorid!=0){ %>
			<span title="<%=SystemEnv.getHtmlLabelName(454,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="OnRemark()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(454,user.getLanguage()) %>"/>
			</span>
		    <%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form name="taskform" method="post" action="ViewWorktask.jsp" enctype="multipart/form-data">
<input type="hidden" name="wtid" id="wtid" value="<%=wtid%>">
<input type="hidden" name="taskid_<%=requestid%>" id="taskid_<%=requestid%>" value="<%=wtid%>">
<input type="hidden" name="requestid" id="requestid" value="<%=requestid%>">
<input type="hidden" name="operatorid" id="operatorid" value="<%=operatorid%>">
<input type="hidden" name="operatorid_add" id="operatorid_add" value="<%=operatorid%>">
<input type="hidden" name="operationType">
<input type="hidden" id="isCreate" name="isCreate" value="0">
<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
<input type="hidden" id="functionPage" name="functionPage" value="ViewWorktask.jsp" >
<input type="hidden" id="approverequest" name="approverequest" value="<%=approverequest%>" >
<input type="hidden" id="isRefash" name="isRefash" value="<%=isRefash%>" >
<table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
	<tr>
		<td height="10" colspan="3">
			<br>
			<div align="center">
				<font style="font-size:14pt;FONT-WEIGHT: bold"><%=worktaskName%></font>
			</div>
			<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%;text-align: center;' valign='top'>
			</div>
			</td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">
		<TABLE class="Shadow">
		<tr>
			<td valign="top">
			<!--table class="ViewForm" style="border:1px solid #FF0000"-->
			<table class="ViewForm">
			<colgroup>
			<col width="20%">
			<col width="80%">
			<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>
			<tr>
				<td class="fieldName"><%=SystemEnv.getHtmlLabelName(18177, user.getLanguage())%></td>
				<td  class="field"><%=worktaskName%></td>
			</tr>
			<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>
			<%
				int sourceworktaskid = Util.getIntValue(recordSet_requestbase.getString("sourceworktaskid"), 0);
				int sourceworkflowid = Util.getIntValue(recordSet_requestbase.getString("sourceworkflowid"), 0);
				if(sourceworktaskid!=0 || sourceworkflowid!=0){
					String linkStr = "";
					if(sourceworktaskid != 0){
						linkStr = "<a href=\"/worktask/request/ViewWorktaskTemplate.jsp?requestid="+sourceworktaskid+"\">"+SystemEnv.getHtmlLabelName(16539, user.getLanguage())+SystemEnv.getHtmlLabelName(64, user.getLanguage())+"</a>";
					}else if(sourceworkflowid != 0){
						String requestname = "";
						rs.execute("select requestname from workflow_requestbase where requestid="+sourceworkflowid);
						if(rs.next()){
							requestname = Util.null2String(rs.getString("requestname"));
						}
						if("".equals(requestname)){
							requestname = SystemEnv.getHtmlLabelName(793, user.getLanguage());
						}
						linkStr = "<a href=\"/workflow/request/ViewRequest.jsp?requestid="+sourceworkflowid+"\">"+requestname+"</a>";
					}
			%>
			<tr>
				<td class="fieldName"><%=SystemEnv.getHtmlLabelName(22139, user.getLanguage())%></td>
				<td  class="field"><%=linkStr%></td>
			</tr>
			<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>
			<%}%>
			<tr>
				<td class="fieldName"><%=SystemEnv.getHtmlLabelName(21947, user.getLanguage())%></td>
				<td  class="field"><a href="/worktask/request/ViewWorktask.jsp?requestid=<%=requestid%>"><%=worktaskStatusName%></a></td>
			</tr>
			<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>
			<%
				String checkStr = "";
				String realStartDate = "";
				String realEndDate = "";
				String realDays = "";
				if(needcheck==1 && checkor!=0){
					needcheck = 1;
				}
				for(int i=0; i<idList.size(); i++){
					int textheight_tmp = Util.getIntValue((String)textheightList.get(i), 0);
					int fieldid_tmp = Util.getIntValue((String)idList.get(i), 0);
					String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
					String crmname_tmp = Util.null2String((String)crmnameList.get(i));
					String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
					String type_tmp = Util.null2String((String)typeList.get(i));
					int isedit_tmp = Util.getIntValue((String)iseditList.get(i), 0);
					int ismand_tmp = Util.getIntValue((String)ismandList.get(i), 0);
					String value_tmp = Util.null2String(recordSet_requestbase.getString(fieldname_tmp));//recordSet获取
					String fieldlen_tmp = Util.null2String((String)fieldlenList.get(i));
					int wttype = Util.getIntValue((String)wttypeList.get(i), 1);
					if(wttype != 1){
						continue;
					}
					if("16".equals(type_tmp) || "152".equals(type_tmp) || "171".equals(type_tmp)){
						if(!"".equals(value_tmp)){
							String[] tlinkwts = Util.TokenizerString2(value_tmp, ",");
							for(int dx=0; dx<tlinkwts.length; dx++){
								String tlinkwt = Util.null2o(tlinkwts[dx]);
								int tempnum = Util.getIntValue((String)(session.getAttribute("tlinkwtnum")), 0);
								tempnum++;
								session.setAttribute("retrequestid"+tempnum, tlinkwt);
								session.setAttribute("tlinkwfnum", ""+tempnum);
								session.setAttribute("haslinkworktask", "1");
								session.setAttribute("deswtrequestid"+tempnum, ""+requestid);
							}
						}
					}
					String sHtml = "";

					sHtml = wtRequestManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, requestid);
					
		     %>
		         <tr><td class="fieldName"><%=crmname_tmp %></td><td class="field"><%=sHtml%></td></tr>
				 <tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>
		     
		     <%} %>    
		     
			 <%
				
				//提醒设置
				int remindtype = 0;
				int beforestart = 0;
				int beforestarttime = 0;
				int beforestarttype = 0;
				int beforestartper = 0;
				int beforeend = 0;
				int beforeendtime = 0;
				int beforeendtype = 0;
				int beforeendper = 0;
				remindtype = Util.getIntValue(recordSet_requestbase.getString("remindtype"), 0);
				beforestart = Util.getIntValue(recordSet_requestbase.getString("beforestart"), 0);
				beforestarttime = Util.getIntValue(recordSet_requestbase.getString("beforestarttime"), 0);
				beforestarttype = Util.getIntValue(recordSet_requestbase.getString("beforestarttype"), 0);
				beforestartper = Util.getIntValue(recordSet_requestbase.getString("beforestartper"), 0);
				beforeend = Util.getIntValue(recordSet_requestbase.getString("beforeend"), 0);
				beforeendtime = Util.getIntValue(recordSet_requestbase.getString("beforeendtime"), 0);
				beforeendtype = Util.getIntValue(recordSet_requestbase.getString("beforeendtype"), 0);
				beforeendper = Util.getIntValue(recordSet_requestbase.getString("beforeendper"), 0);
				String startTimeType = "";
				String endTimeType = "";
				if(beforestarttype == 0){
					startTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
				}else if(beforestarttype == 1){
					startTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
				}else{
					startTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
				}
				if(beforeendtype == 0){
					endTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
				}else if(beforeendtype == 1){
					endTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
				}else{
					endTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
				}
			%>
			<TR>
				<TD  class="fieldName"><%=SystemEnv.getHtmlLabelName(18713, user.getLanguage())%></TD>
				<TD class="field">
					<INPUT type="radio" value="0" name="remindtype" id="remindtype" <%if (remindtype == 0) {%>checked<%}%> disabled><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
					<INPUT type="radio" value="1" name="remindtype" id="remindtype" <%if (remindtype == 1) {%>checked<%}%> disabled><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
					<INPUT type="radio" value="2" name="remindtype" id="remindtype" <%if (remindtype == 2) {%>checked<%}%> disabled><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
				</TD>
			</TR>
			<TR style='height: 1px;'>
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<!--开始前提醒-->
			<TR id="startTime" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD  class="fieldName"><%=SystemEnv.getHtmlLabelName(785, user.getLanguage())%></TD>
				<TD class="field">
					<INPUT type="checkbox" name="beforestart" value="1" <% if(beforestart == 1) { %>checked<% } %> disabled>
						<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" name="beforestarttime" size=5 value="<%= beforestarttime%>" disabled>
						<select name="beforestarttype" id="beforestarttype" style="display:'<%if(remindtype == 0) {%>none<%}%>'" disabled>
							<option value="0" <%if(beforestarttype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
							<option value="1" <%if(beforestarttype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
							<option value="2" <%if(beforestarttype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
						</select>
				</TD>
			</TR>
			<TR id="startTimeLine" style="height: 1px;display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<TR id="startTime2" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD  class="fieldName"><%=SystemEnv.getHtmlLabelName(18080, user.getLanguage())%></TD>
				<TD class="field">
					<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="beforestartper"  size=5 value="<%=beforestartper%>" disabled>
					<span id="beforestarttypespan" name="beforestarttypespan"><%=startTimeType%></span>
				</TD>
			</TR>
			<TR id="startTimeLine2" style="height: 1px;display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<!--结束前提醒-->
			<TR id="endTime" style="display:<%if(remindtype == 0) {%>none<%}%>">
				<TD  class="fieldName"><%=SystemEnv.getHtmlLabelName(785, user.getLanguage())%></TD>
				<TD class="field">
					<INPUT type="checkbox" name="beforeend" value="1" <% if(beforeend == 1) { %>checked<% } %> disabled>
						<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" name="beforeendtime" size=5 value="<%= beforeendtime%>" disabled>
						<select name="beforeendtype" id="beforeendtype" style="display:'<%if(remindtype == 0) {%>none<%}%>'" disabled>
							<option value="0" <%if(beforeendtype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
							<option value="1" <%if(beforeendtype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
							<option value="2" <%if(beforeendtype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
						</select>
				</TD>
			</TR>
			<TR id="endTimeLine" style="height: 1px;display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<TR id="endTime2" style="display:<%if(remindtype == 0) {%>none<%}%>">
				<TD  class="fieldName"><%=SystemEnv.getHtmlLabelName(18080, user.getLanguage())%></TD>
				<TD class="field">
					<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="beforeendper"  size=5 value="<%=beforeendper%>" disabled>
					<span id="beforeendtypespan" name="beforeendtypespan"><%=endTimeType%></span>
				</TD>
			</TR>
			<TR id="endTimeLine2" style="height: 1px;display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<%
				//System.out.println("request_status = " + request_status);
				//System.out.println("operatorid = " + operatorid);
				//完成情况 Start
				if(request_status >= 6 && operatorid != 0){//只有 未开始、进行中、已超期、待验证、已完成 任务才显示完成情况
					//out.println("<TR><TD colspan=\"2\"><table ><tr class=\"header\"><td nowrap align=\"center\">"+SystemEnv.getHtmlLabelName(22069, user.getLanguage())+"</td></tr></table></TD></TR>");
					out.println("<TR><TD colspan=\"2\"><table class=\"ListStyle\"><tr class=\"header\"><td nowrap align=\"center\" style='font-weight: bold;'>"+SystemEnv.getHtmlLabelName(22069, user.getLanguage())+"</td></tr></table></TD></TR>");
					out.println("<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>");
					for(int i=0; i<idList.size(); i++){
						int textheight_tmp = Util.getIntValue((String)textheightList.get(i), 0);
						int fieldid_tmp = Util.getIntValue((String)idList.get(i), 0);
						String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
						String crmname_tmp = Util.null2String((String)crmnameList.get(i));
						String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
						String type_tmp = Util.null2String((String)typeList.get(i));
						int isedit_tmp = Util.getIntValue((String)iseditList.get(i), 0);
						int ismand_tmp = Util.getIntValue((String)ismandList.get(i), 0);
						String value_tmp = recordSet_operator.getString(fieldname_tmp);
						String fieldlen_tmp = Util.null2String((String)fieldlenList.get(i));
						int wttype = Util.getIntValue((String)wttypeList.get(i), 1);
						if(wttype != 2){
							continue;
						}
						if("16".equals(type_tmp) || "152".equals(type_tmp) || "171".equals(type_tmp)){
							if("!".equals(value_tmp)){
								String[] tlinkwts = Util.TokenizerString2(value_tmp, ",");
								for(int dx=0; dx<tlinkwts.length; dx++){
									String tlinkwt = Util.null2o(tlinkwts[dx]);
									int tempnum = Util.getIntValue((String)(session.getAttribute("tlinkwtnum")), 0);
									tempnum++;
									session.setAttribute("retrequestid"+tempnum, tlinkwt);
									session.setAttribute("tlinkwfnum", ""+tempnum);
									session.setAttribute("haslinkworktask", "1");
									session.setAttribute("deswtrequestid"+tempnum, ""+requestid);
								}
							}
						}
						String sHtml = "";

						sHtml = wtRequestManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, operatorid);
						out.println("<tr><td  class=\"fieldName\">"+crmname_tmp+"</td><td class=\"field\">"+sHtml+"</td></tr>");
						out.println("<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>");
					}
					//完成情况 End
					//验证情况 Start
					if(needcheck == 1){
						out.println("<TR><TD colspan=\"2\"><table class=\"ListStyle\"><tr class=\"header\"><td nowrap align=\"center\" style='font-weight: bold;'>"+SystemEnv.getHtmlLabelName(22070, user.getLanguage())+"</td></tr></table></TD></TR>");
						out.println("<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>");
						for(int i=0; i<idList.size(); i++){
							int textheight_tmp = Util.getIntValue((String)textheightList.get(i), 0);
							int fieldid_tmp = Util.getIntValue((String)idList.get(i), 0);
							String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
							String crmname_tmp = Util.null2String((String)crmnameList.get(i));
							String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
							String type_tmp = Util.null2String((String)typeList.get(i));
							int isedit_tmp = Util.getIntValue((String)iseditList.get(i), 0);
							int ismand_tmp = Util.getIntValue((String)ismandList.get(i), 0);
							String value_tmp = recordSet_operator.getString(fieldname_tmp);
							String fieldlen_tmp = Util.null2String((String)fieldlenList.get(i));
							int wttype = Util.getIntValue((String)wttypeList.get(i), 1);
							if(wttype != 3){
								continue;
							}
							if("16".equals(type_tmp) || "152".equals(type_tmp) || "171".equals(type_tmp)){
								if("!".equals(value_tmp)){
									String[] tlinkwts = Util.TokenizerString2(value_tmp, ",");
									for(int dx=0; dx<tlinkwts.length; dx++){
										String tlinkwt = Util.null2o(tlinkwts[dx]);
										int tempnum = Util.getIntValue((String)(session.getAttribute("tlinkwtnum")), 0);
										tempnum++;
										session.setAttribute("retrequestid"+tempnum, tlinkwt);
										session.setAttribute("tlinkwfnum", ""+tempnum);
										session.setAttribute("haslinkworktask", "1");
										session.setAttribute("deswtrequestid"+tempnum, ""+requestid);
									}
								}
							}
							String sHtml = "";

							sHtml = wtRequestManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, operatorid);
							out.println("<tr><td class=\"fieldName\">"+crmname_tmp+"</td><td class=\"field\">"+sHtml+"</td></tr>");
							out.println("<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>");
						}
					}
					//验证情况 End
				}
				if(request_status >= 6){
					//其他责任人情况 Start
					String tableStr = "";
					rs.execute("select * from worktask_operator where type=1 and requestid="+requestid+" and id<>"+operatorid);
					if(rs.next()){
						if(operatorid != 0){
							out.println("<TR><TD colspan=\"2\">");
							out.println("<table class=\"ListStyle\">");
							out.println("<colgroup>");
							out.println("<col width=\"20%\">");
							out.println("<col width=\"60%\">");
							out.println("<col width=\"20%\">");
							out.println("<tr class=\"header\"><td colspan=\"3\" nowrap align=\"center\">"+SystemEnv.getHtmlLabelName(22071, user.getLanguage())+"</td></tr>");
						}else{
							out.println("<TR><TD colspan=\"2\">");
							out.println("<table class=\"ListStyle\">");
							out.println("<colgroup>");
							out.println("<col width=\"20%\">");
							out.println("<col width=\"60%\">");
							out.println("<col width=\"20%\">");
							out.println("<tr class=\"header\"><td colspan=\"3\" nowrap align=\"center\">"+SystemEnv.getHtmlLabelName(22072, user.getLanguage())+"</td></tr>");
						}
						out.println("<tr style='height: 1px;'><td class=Line2 colSpan=3></td></tr>");
						tableStr = "</table></TD></TR>";
						out.println("<tr class=\"header\">");
						out.println("<td align=\"center\">"+SystemEnv.getHtmlLabelName(2172, user.getLanguage())+"</td>");
						out.println("<td align=\"center\">"+SystemEnv.getHtmlLabelName(22073, user.getLanguage())+"</td>");
						out.println("<td align=\"center\">"+SystemEnv.getHtmlLabelName(22074, user.getLanguage())+"</td>");
						out.println("</tr>");
						out.println("<tr style='height: 1px;'><td class=\"Line2\" colSpan=3></td></tr>");
					}
					rs.beforFirst();
					while(rs.next()){
						int operatorid_tmp = Util.getIntValue(rs.getString("id"), 0);
						int userid_tmp = Util.getIntValue(rs.getString("userid"), 0);
						String name_tmp = resourceComInfo.getLastname(""+userid_tmp);
						name_tmp = "<a href=\"javaScript:openFullWindowHaveBar('/hrm/resource/HrmResource.jsp?id="+userid_tmp+"')\">"+name_tmp+"</a>";
						int optstatus_tmp = Util.getIntValue(rs.getString("optstatus"), 0);
						String backremark = Util.null2String(rs.getString("backremark"));
						if("".equals(backremark.trim())){
							backremark = "<a href=\"javaScript:openFullWindowHaveBar('/worktask/request/ViewWorktask.jsp?operatorid="+operatorid_tmp+"')\">"+SystemEnv.getHtmlLabelName(22075, user.getLanguage())+"</a>";
						}else{
							backremark = "<a href=\"javaScript:openFullWindowHaveBar('/worktask/request/ViewWorktask.jsp?operatorid="+operatorid_tmp+"')\">"+backremark+"</a>";
						}
						int status_tmp = 0;
						if(optstatus_tmp == 0){
							status_tmp = 6;
						}else if(optstatus_tmp == -1 || optstatus_tmp == 7){
							status_tmp = 7;
						}else if(optstatus_tmp == 8){
							status_tmp = 8;
						}else if(optstatus_tmp == 1){
							status_tmp = 9;
						}else if(optstatus_tmp == 2){
							status_tmp = 10;
						}
						String statusName_tmp = Util.null2String((String)worktaskStatus_hs.get("worktaskstatus_"+status_tmp));
						out.println("<tr class=\"datalight\"><td align=\"center\" class=\"field\">"+name_tmp+"</td><td align=\"left\" class=\"field\">"+backremark+"</td><td align=\"center\" class=\"field\">"+statusName_tmp+"</td>");
						out.println("<tr style='height: 1px;'><td class=\"Line2\" colSpan=3></td></tr>");
					}
					out.println(tableStr);
					//其他责任人情况 End
					//任务执行过程记录 Start
					if(operatorid != 0){
						rs.execute("select * from worktask_backlog where operatorid="+operatorid+" order by id desc");
						if(rs.next()){
							if(operatorid != 0){
								out.println("<TR><TD colspan=\"2\">");
								out.println("<table class=\"ListStyle\">");
								out.println("<colgroup>");
								out.println("<col width=\"8%\">");
								out.println("<col width=\"10%\">");
								out.println("<col width=\"20%\">");
								out.println("<col width=\"25%\">");
								out.println("<col width=\"10%\">");
								out.println("<col width=\"27%\">");
								out.println("<tr class=\"header\"><td colspan=\"5\" nowrap align=\"center\">"+SystemEnv.getHtmlLabelName(22076, user.getLanguage())+"</td><td><span id=\"worktaskbacklogspan\" name=\"worktaskbacklogspan\"><span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' >"+SystemEnv.getHtmlLabelName(332,user.getLanguage())+"</span></span></td></tr>");
							}
							out.println("<tr style='height: 1px;'><td class=Line2 colSpan=6></td></tr>");
							tableStr = "</table></TD></TR>";
							out.println("<tr class=\"header\">");
							out.println("<td align=\"center\">"+SystemEnv.getHtmlLabelName(2172, user.getLanguage())+"</td>");
							out.println("<td align=\"center\">"+SystemEnv.getHtmlLabelName(15503, user.getLanguage())+"</td>");
							out.println("<td align=\"center\">"+SystemEnv.getHtmlLabelName(15502, user.getLanguage())+"</td>");
							out.println("<td align=\"center\">"+SystemEnv.getHtmlLabelName(21950, user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(22077, user.getLanguage())+"</td>");
							out.println("<td align=\"center\">"+SystemEnv.getHtmlLabelName(22074, user.getLanguage())+"</td>");
							out.println("<td align=\"center\">"+SystemEnv.getHtmlLabelName(22078, user.getLanguage())+"</td>");
							out.println("</tr>");
							out.println("<tr style='height: 1px;'><td class=\"Line2\" colSpan=6></td></tr>");
						}
						rs.beforFirst();
						int count = 0;
						while(rs.next()){
							count++;
							int logtype_tmp = Util.getIntValue(rs.getString("type"), 0);//0：反馈；1：验证
							int userid_tmp = Util.getIntValue(rs.getString("optuserid"), 0);
							String name_tmp = resourceComInfo.getLastname(""+userid_tmp);
							name_tmp = "<a href=\"javaScript:openFullWindowHaveBar('/hrm/resource/HrmResource.jsp?id="+userid_tmp+"')\">"+name_tmp+"</a>";
							String remark_tmp = "";
							int opttype_tmp = Util.getIntValue(rs.getString("opttype"), 0);
							String opttypeName_tmp = "";
							if(logtype_tmp == 0){
								remark_tmp = Util.null2String(rs.getString("backremark"));
								if(opttype_tmp == 0){
									opttypeName_tmp = SystemEnv.getHtmlLabelName(22079, user.getLanguage());
								}else if(opttype_tmp == 1){
									opttypeName_tmp = SystemEnv.getHtmlLabelName(22080, user.getLanguage());
								}else if(opttype_tmp == 2){
									opttypeName_tmp = SystemEnv.getHtmlLabelName(22081, user.getLanguage());
								}
							}else if(logtype_tmp == 1){
								remark_tmp = Util.null2String(rs.getString("checkremark"));
								if(opttype_tmp == 1){
									opttypeName_tmp = SystemEnv.getHtmlLabelName(22082, user.getLanguage());
								}else if(opttype_tmp == 2){
									opttypeName_tmp = SystemEnv.getHtmlLabelName(22083, user.getLanguage());
								}
							}
							String optdate_tmp = Util.null2String(rs.getString("optdate"));
							String opttime_tmp = Util.null2String(rs.getString("opttime"));
							String date_time_tmp = optdate_tmp + " " + opttime_tmp;
							int optstatus_tmp = Util.getIntValue(rs.getString("optstatus"), 0);
							int status_tmp = 0;
							if(optstatus_tmp == 0){
								status_tmp = 6;
							}else if(optstatus_tmp == -1 || optstatus_tmp == 7){
								status_tmp = 7;
							}else if(optstatus_tmp == 8){
								status_tmp = 8;
							}else if(optstatus_tmp == 1){
								status_tmp = 9;
							}else if(optstatus_tmp == 2){
								status_tmp = 10;
							}
							String optstatusName_tmp = Util.null2String((String)worktaskStatus_hs.get("worktaskstatus_"+status_tmp));
							if(count==4){
								out.println("<tr class=\"datalight\"><td colspan=\"6\">");
								out.println("<div id=\"worktasklogDiv\" name=\"worktasklogDiv\" style=\"display:none\" >");
								out.println("<table class=\"ListStyle\">");
								out.println("<colgroup>");
								out.println("<col width=\"8%\">");
								out.println("<col width=\"10%\">");
								out.println("<col width=\"20%\">");
								out.println("<col width=\"25%\">");
								out.println("<col width=\"10%\">");
								out.println("<col width=\"27%\">");
							}
							out.println("<tr class=\"datalight\">");
							out.println("<td align=\"center\" class=\"field\">"+name_tmp+"</td>");
							out.println("<td align=\"center\" class=\"field\">"+opttypeName_tmp+"</td>");
							out.println("<td align=\"center\" class=\"field\">"+date_time_tmp+"</td>");
							out.println("<td align=\"left\" class=\"field\">"+remark_tmp+"</td>");
							out.println("<td align=\"center\" class=\"field\">"+optstatusName_tmp+"</td>");
							out.println("<td align=\"center\">");
							out.println("<table class=\"ListStyle\">");
							out.println("<colgroup>");
							out.println("<col width=\"25%\">");
							out.println("<col width=\"75%\">");
							for(int i=0; i<idList.size(); i++){
								int fieldid_tmp = Util.getIntValue((String)idList.get(i), 0);
								String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
								String crmname_tmp = Util.null2String((String)crmnameList.get(i));
								String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
								String type_tmp = Util.null2String((String)typeList.get(i));
								String value_tmp = rs.getString(fieldname_tmp);
								int wttype = Util.getIntValue((String)wttypeList.get(i), 1);
								if(wttype == 1){
									continue;
								}
								if(wttype==3 && logtype_tmp==0){
									continue;
								}
								if("".equals(value_tmp)){
									continue;
								}
								if("backremark".equalsIgnoreCase(fieldname_tmp) || "checkremark".equalsIgnoreCase(fieldname_tmp)){
									continue;
								}
								if("16".equals(type_tmp) || "152".equals(type_tmp) || "171".equals(type_tmp)){
									if("!".equals(value_tmp)){
										String[] tlinkwts = Util.TokenizerString2(value_tmp, ",");
										for(int dx=0; dx<tlinkwts.length; dx++){
											String tlinkwt = Util.null2o(tlinkwts[dx]);
											int tempnum = Util.getIntValue((String)(session.getAttribute("tlinkwtnum")), 0);
											tempnum++;
											session.setAttribute("retrequestid"+tempnum, tlinkwt);
											session.setAttribute("tlinkwfnum", ""+tempnum);
											session.setAttribute("haslinkworktask", "1");
											session.setAttribute("deswtrequestid"+tempnum, ""+requestid);
										}
									}
								}
								String sHtml = "";

								sHtml = wtRequestManager.getFieldValue(fieldhtmltype_tmp, type_tmp, value_tmp, ""+fieldid_tmp);
								out.println("<tr><td>"+crmname_tmp+"</td><td class=\"field\">"+sHtml+"</td></tr>");
								out.println("<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>");
							}
							out.println("</table>");
							out.println("</td>");
							out.println("<tr style='height: 1px;'><td class=\"Line2\" colSpan=6></td></tr>");
						}
						if(count >= 4){
							out.println("</table>");
							out.println("</div>");
							out.println("</td>");
							out.println("</tr>");
						}
						out.println(tableStr);
					}
					//任务执行过程记录 End
					//备注 Start
					if(canRemark==true && operatorid!=0){
						int count = 0;
						rs.execute("select * from worktask_remarklog where operatorid="+operatorid+" order by id desc");
						while(rs.next()){
							count++;
							if(count == 1){
								out.println("<TR><TD colspan=\"2\">");
								out.println("<table class=\"ListStyle\">");
								out.println("<colgroup>");
								out.println("<col width=\"20%\">");
								out.println("<col width=\"20%\">");
								out.println("<col width=\"60%\">");
								out.println("<tr class=\"header\"><td colspan=\"3\" nowrap align=\"center\">"+SystemEnv.getHtmlLabelName(22265, user.getLanguage())+"</td></tr>");
								out.println("<tr style='height: 1px;'><td class=Line2 colSpan=3></td></tr>");
								out.println("<tr class=\"header\">");
								out.println("<td align=\"center\">"+SystemEnv.getHtmlLabelName(17482, user.getLanguage())+"</td>");
								out.println("<td align=\"center\">"+SystemEnv.getHtmlLabelName(15502, user.getLanguage())+"</td>");
								out.println("<td align=\"center\">"+SystemEnv.getHtmlLabelName(454, user.getLanguage())+SystemEnv.getHtmlLabelName(345, user.getLanguage())+"</td>");
								out.println("</tr>");
								out.println("<tr style='height: 1px;'><td class=\"Line2\" colSpan=3></td></tr>");
							}
							int remarkuserid_tmp = Util.getIntValue(rs.getString("remarkuserid"), 0);
							String name_tmp = resourceComInfo.getLastname(""+remarkuserid_tmp);
							name_tmp = "<a href=\"javaScript:openFullWindowHaveBar('/hrm/resource/HrmResource.jsp?id="+remarkuserid_tmp+"')\">"+name_tmp+"</a>";
							String remarkdate_tmp = Util.null2String(rs.getString("remarkdate"));
							String remarktime_tmp = Util.null2String(rs.getString("remarktime"));
							String remarkcontent_tmp = Util.null2String(rs.getString("remarkcontent"));
							out.print("<tr class=\"datalight\"><td align=\"center\" class=\"field\">"+name_tmp+"</td><td align=\"center\" class=\"field\">"+remarkdate_tmp+" "+remarktime_tmp+"</td><td align=\"left\" class=\"field\">"+remarkcontent_tmp+"</td></tr>");
							out.println("<tr style='height: 1px;'><td class=\"Line2\" colSpan=3></td></tr>");
						}
						if(count > 0){
							out.println("</table><br></TD></TR>");
						}
					}
					//备注 End
				}
			%>
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
</form>
<script language="javascript">
function doChangeWorktask(obj){
	var selectedIndex = 0;
	var i = 0;
	var length = document.all("selectWorktask").options.length;
	for(i=0; i<length; i++){
		if("<%=wtid%>" == document.all("selectWorktask").options[i].value){
			selectedIndex = i;
		}
	}
	if(confirm("<%=SystemEnv.getHtmlLabelName(18691, user.getLanguage())%>")){
		var wtid = obj.value;
		location.href="/worktask/request/Addworktask.jsp?wtid="+wtid;
	}else{
		for(i=0; i<length; i++){
			document.all("selectWorktask").options[i].selected = false;
		}
		document.all("selectWorktask").options[selectedIndex].selected = true;
	}
}

function OnSave(){
	//alert(document.all("needcheck").value);
	//if(check_form(document.taskform, document.all("needcheck").value)){
		//document.taskform.action = "RequestOperation.jsp";
		//document.taskform.operationType.value="multisave";
		//showPrompt("<%=SystemEnv.getHtmlLabelName(22060, user.getLanguage())%>");
		//document.taskform.submit();
		//enableAllmenu();
	//}
}

function OnSubmit(){
	document.taskform.action = "RequestOperation.jsp";
	document.taskform.operationType.value="Submit";
	showPrompt("<%=SystemEnv.getHtmlLabelName(22061, user.getLanguage())%>");
	document.taskform.submit();
	enableAllmenu();
}


function showPrompt(content){
     var showTableDiv  = document.getElementById('_xTable');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = document.getElementById("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     //message_table_Div.style.posTop=pTop;
     //message_table_Div.style.posLeft=pLeft;
     message_table_Div.style.top = pTop;
     message_table_Div.style.left = pLeft;
     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
}
</script>
<script language="vbs">
sub onShowBrowser3(id,url,linkurl,type1,ismand)

	if type1= 2 or type1 = 19 then
	    spanname = "field"+id+"span"
	    inputname = "field"+id
		if type1 = 2 then
		  onFlownoShowDate spanname,inputname,ismand
        else
	      onWorkFlowShowTime spanname,inputname,ismand
		end if
	else
		if  type1 <> 152 and type1 <> 142 and type1 <> 135 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>165 and type1<>166 and type1<>167 and type1<>168 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		else
            if type1=135 then
			tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
			elseif type1=37 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
            elseif type1=142 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?receiveUnitIds="&tmpids)
            elseif type1=165 or type1=166 or type1=167 or type1=168 then
            index=InStr(id,"_")
            if index>0 then
            tmpids=uescape("?isdetail=1&fieldid="& Mid(id,1,index-1)&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            else
            tmpids=uescape("?fieldid="&id&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            end if
            else
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
            end if
		end if
		if NOT isempty(id1) then
			if  type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 then
				if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceidss = Mid(resourceids,2,len(resourceids))
					resourceids = Mid(resourceids,2,len(resourceids))

					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					document.all("field"+id).value= resourceidss
				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if

			else
			   if  id1(0)<>""  and id1(0)<> "0"  then
                   if type1=162 then
				     ids = id1(0)
					names = id1(1)
					descs = id1(2)
					sHtml = ""
					ids = Mid(ids,2,len(ids))
					document.all("field"+id).value= ids
					names = Mid(names,2,len(names))
					descs = Mid(descs,2,len(descs))
					while InStr(ids,",") <> 0
						curid = Mid(ids,1,InStr(ids,","))
						curname = Mid(names,1,InStr(names,",")-1)
						curdesc = Mid(descs,1,InStr(descs,",")-1)
						ids = Mid(ids,InStr(ids,",")+1,Len(ids))
						names = Mid(names,InStr(names,",")+1,Len(names))
						descs = Mid(descs,InStr(descs,",")+1,Len(descs))
						sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
				   if type1=161 then
				     name = id1(1)
					desc = id1(2)
				    document.all("field"+id).value=id1(0)
					sHtml = "<a title='"&desc&"'>"&name&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
			        if linkurl = "" then
						document.all("field"+id+"span").innerHtml = id1(1)
					else
						document.all("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&" target='_new'>"&id1(1)&"</a>"
					end if
					document.all("field"+id).value=id1(0)

				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if
			end if
		end if
	end if
end sub
</script>
<script language="javascript">

function ItemCount_KeyPress_self(){
	if(!((window.event.keyCode>=48) && (window.event.keyCode<=57))){
		window.event.keyCode=0;
	}
}
function displaydiv_1(){
	try{
		if(worktasklogDiv.style.display == ""){
			worktasklogDiv.style.display = "none";
			worktaskbacklogspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
		}else{
			worktasklogDiv.style.display = "";
			worktaskbacklogspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";
		}
	}catch(e){}
}

function doEdit(){
	location.href="/worktask/request/EditWorktask.jsp?isRefash=<%=isRefash%>&requestid=<%=requestid%>";
}

function OnDel(){

	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("28296,91",user.getLanguage()) %>?',function(){	    
		document.taskform.action = "RequestOperation.jsp";
		document.taskform.operationType.value="delete";
		document.taskform.submit();
		enableAllmenu();
	});

}

function OnCancel(){
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("28296,201",user.getLanguage()) %>?',function(){
	    document.taskform.action = "RequestOperation.jsp";
		document.taskform.operationType.value="cancel";
		document.taskform.submit();
		enableAllmenu();	
	});

}

function OnApprove(){
	document.taskform.action = "RequestOperation.jsp";
	document.taskform.operationType.value="Approve";
	document.taskform.submit();
	enableAllmenu();
}

function OnReject(){
	document.taskform.action = "RequestOperation.jsp";
	document.taskform.operationType.value="Back";
	document.taskform.submit();
	enableAllmenu();
}

function OnExecute(){
	location.href="/worktask/request/ExecuteWorktask.jsp?operatorid=<%=operatorid%>";
}

function OnCheck(){
	location.href="/worktask/request/CheckWorktask.jsp?operatorid=<%=operatorid%>";
}
function OnRemark(){
	location.href="/worktask/request/RemarkWorktask.jsp?operatorid=<%=operatorid%>";
}
function OnToMould(){
	location.href="/worktask/request/EditWorktaskTemplate.jsp?isCreate=1&requestid=<%=requestid%>&wtid=<%=wtid%>";
}
var dlg;
function OnShare(){
	//location.href="/worktask/request/RequestShareSet.jsp?requestid=<%=requestid%>&wtid=<%=wtid%>";
	dlg=new window.top.Dialog();//定义Dialog对象
	// dialog.currentWindow = window;
　　dlg.Model=false;
　　dlg.Width=1000;//定义长度
　　dlg.Height=550;
　　dlg.URL="/worktask/request/RequestShareList.jsp?requestid=<%=requestid%>&wtid=<%=wtid%>";
　　dlg.Title='<%=SystemEnv.getHtmlLabelName(119, user.getLanguage())%>';
	dlg.maxiumnable=false;
　　dlg.show();
}
function iscancel(){
	if(!confirm("<%=SystemEnv.getHtmlLabelName(22059, user.getLanguage())%>")){
		return false;
	}
	return true;
}
function viewLog(){
	    
		//jQuery(document.getElementById("rightMenuIframe")).hide();
        var dlg=new window.top.Dialog();//定义Dialog对象
		// dialog.currentWindow = window;
	　　dlg.Model=false;
	　　dlg.Width=1000;//定义长度
	　　dlg.Height=550;
	　　dlg.URL="/worktask/request/RequestLog.jsp?requestid=<%=requestid%>&wtid=<%=wtid%>&isRefash=<%=isRefash%>";
	　　dlg.Title='<%=SystemEnv.getHtmlLabelName(83, user.getLanguage())%>';
		dlg.maxiumnable=false;
	　　dlg.show();
}
//附件相关JS Start
function openDocExt(showid,versionid,docImagefileid,isedit){
	taskbody.onbeforeunload=null;
    
	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&operatorid=<%=operatorid%>&fromworktask=1");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&operatorid=<%=operatorid%>&fromworktask=1");
	}
}

function openAccessory(fileId){ 
	taskbody.onbeforeunload=null;
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>&operatorid=<%=operatorid%>&fromworktask=1");
}
function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;
        fileLenth= File.getFileSize();
    } catch (e){
        //alert('<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>');
		if(e.message=="Type mismatch"||e.message=="类型不匹配"){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
		}else{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if (fileLenthByM><%=maxUploadImageSize%>) {
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}
  function addannexRow(accname,maxsize)
  {
    document.all(accname+'_num').value=parseInt(document.all(accname+'_num').value)+1;
    ncol = document.all(accname+'_tab').cols;
    oRow = document.all(accname+'_tab').insertRow();
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell();
      oCell.style.height=24;
      switch(j) {
        case 1:
          var oDiv = document.createElement("div");
          var sHtml = "";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
        case 0:
          var oDiv = document.createElement("div");
          <%----- Modified by xwj for td3323 20051209  ------%>
          var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+document.all(accname+'_num').value+"' onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
}
function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=60 >";  
    document.getElementById(objName).outerHTML=outerHTML;       
    document.getElementById(objName).onchange=tempObjonchange;
}
function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}
function openDocExt(showid,versionid,docImagefileid,isedit){
	taskbody.onbeforeunload=null;

	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&operatorid=<%=operatorid%>&fromworktask=1");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&operatorid=<%=operatorid%>&fromworktask=1");
	}
}

function openAccessory(fileId){
	taskbody.onbeforeunload=null;
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>&operatorid=<%=operatorid%>&fromworktask=1");
}
function returnTrue(o){
	return;
}
function downloads(files){
	taskbody.onbeforeunload=null;
	document.location.href="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1";
}
 function onChangeSharetype(delspan,delid,ismand,maxUploadImageSize){
	fieldid=delid.substr(0,delid.indexOf("_"));
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
	fieldidspans=fieldid+"spans";
	fieldid=fieldid+"_1";
	 var sHtml = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange='accesoryChanage(this,"+maxUploadImageSize+")'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
	 var sHtml1 = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange=\"accesoryChanage(this,"+maxUploadImageSize+");checkinput(\'"+fieldid+"\',\'"+fieldidspan+"\')\"> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";

    if(document.all(delspan).style.visibility=='visible'){
      document.all(delspan).style.visibility='hidden';
      document.all(delid).value='0';
	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)+1;
    }else{
      document.all(delspan).style.visibility='visible';
      document.all(delid).value='1';
	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)-1;
    }
	//alert(document.all(fieldidnum).value);
	if (ismand=="1")
	  {
	if (document.all(fieldidnum).value=="0")
	  {
	    document.all("needcheck").value=document.all("needcheck").value+","+fieldid;
		document.all(fieldidspan).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";

		document.all(fieldidspans).innerHTML=sHtml1;
	  }
	  else
	  {   if (document.all("needcheck").value.indexOf(","+fieldid)>0)
		  {
	     document.all("needcheck").value=document.all("needcheck").value.substr(0,document.all("needcheck").value.indexOf(","+fieldid));
		 document.all(fieldidspan).innerHTML="";
		 document.all(fieldidspans).innerHTML=sHtml;
		  }
	  }
	  }
  }
  //附件相关JS End
</script>

</BODY>
</HTML>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
