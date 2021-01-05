<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.meeting.MeetingServiceUtil"%>
<%@page import="weaver.interfaces.workflow.action.Action"%>
<%@page import="org.apache.hivemind.Registry"%>
<%@page import="weaver.meeting.action.WFMeetingAction"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@page import="weaver.workflow.action.WorkflowActionManager"%>
<jsp:useBean id="ActionXML" class="weaver.servicefiles.ActionXML" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("Meeting:WFSetting", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}
	
String id = Util.null2String(request.getParameter("id"));
String method=Util.null2String(request.getParameter("method"));
if("".equals(id)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
ActionXML.initAction();
Map<String,String> actionMap=new HashMap<String,String>();
ArrayList pointArrayList = ActionXML.getPointArrayList();
Hashtable dataHST = ActionXML.getDataHST();
for(int i=0;i<pointArrayList.size();i++){
    String pointid = (String)pointArrayList.get(i);
    String classname = (String)dataHST.get(pointid);
    if("weaver.meeting.action.WFMeetingAction".equals(classname)){
	    String actionshowname = ActionXML.getActionName(pointid);
	    actionMap.put(pointid,actionshowname);
    }
}

Iterator<String> it=actionMap.keySet().iterator();
String op="";
if("setAction".equals(method)){//批量设置动作
	String interfaceid= Util.null2String(request.getParameter("interfaceid"));
	if(!"".equals(interfaceid)){
		RecordSet.execute("select nodeid,nodetype from workflow_flownode where workflowid="+id+" ORDER BY nodetype");
		WorkflowActionManager workflowActionManager = new WorkflowActionManager();
		workflowActionManager.setActionorder(0);
		workflowActionManager.setNodelinkid(0);
		workflowActionManager.setIspreoperator(1);
		workflowActionManager.setIsused(1);
		workflowActionManager.setInterfacetype(3);
		while(RecordSet.next()){
			int nodeid=RecordSet.getInt("nodeid");
			int nodetype=RecordSet.getInt("nodetype");
			int actionid=0;
			if(nodetype==0){//创建节点
				RecordSet.executeSql("update workflow_flownode set drawbackflag=1 where workflowid="+id+" and nodeid="+nodeid);
			}
			RecordSet1.execute("SELECT id FROM workflowactionset where workflowid="+id+" and nodeid="+nodeid+" and ispreoperator=1 and interfaceid='"+interfaceid+"' and interfacetype=3");
			if(RecordSet1.next()){
				actionid=RecordSet1.getInt("id");
			}
			//设置action
			workflowActionManager.setActionid(actionid);
			workflowActionManager.setWorkflowid(Util.getIntValue(id));
			workflowActionManager.setNodeid(nodeid);
			workflowActionManager.setActionname("Meeting接口动作");
			workflowActionManager.setInterfaceid(interfaceid);
			workflowActionManager.doSaveWsAction();
			RecordSet1.execute("update workflow_base set custompage='/meeting/template/MeetingSubmitRequestJs.jsp',custompage4Emoble='/meeting/template/MeetingSubmitRequestJs4Mobile.jsp' where id="+id);
		}
		op="true";
	}else{
		op="false";
	}
	//QC378535 设置自定义表单html模式情况下,校验页面更新
	//一次性更新所有的流程,不止更新当前的workflowid
	RecordSet.execute("update workflow_base set custompage='/meeting/template/MeetingSubmitRequestJs.jsp',custompage4Emoble='/meeting/template/MeetingSubmitRequestJs4Mobile.jsp' where id in(select id from workflow_base wb join meeting_bill mb on mb.billid=wb.formid where mb.billid<>85 and mb.defined=1)");
	
}

 
	 
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<LINK href="/js/ecology8/meeting/meetingbase_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css"
			type="text/css" />
		<link rel="stylesheet"
			href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"
			type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(780, user
				.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY style="overflow: hidden;">
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())+ ",javascript:save(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="meeting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33085,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan"
					style="text-align: right; width: 300px !important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>" class="e8_btn_top middle" onclick="save()" />	
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"  class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv">
			<span style="width:10px"></span>
			<span id="hoverBtnSpan" class="hoverBtnSpan">  
			</span>
		</div>
		<div class="zDialog_div_content" id="editDiv" name="editDiv">
			<FORM id=weaverA name=weaverA action="/meeting/defined/wfAction.jsp" method=post>
				<input type="hidden" value="<%=id%>" name="id">
				<input type="hidden" value="setAction" name="method">
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
						<!-- 服务项目名称 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(20978, user.getLanguage())%></wea:item>
						<wea:item>
							<select name="interfaceid">
								<%while(it.hasNext()){
									String key=it.next();
								%>
									<option value="<%=key %>"><%=actionMap.get(key) %></option>
								<%} %>
							</select>
						</wea:item>
					</wea:group>
				</wea:layout>
			</FORM>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
							id="zd_btn_cancle" class="zd_btn_cancle" onclick="closeDialog()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
	</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">
var parentWin;
try{
parentWin = parent.getParentWindow(window);
}catch(e){}

function preDo(){
	$("#topTitle").topMenuTitle({});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();
};

function save(){
	$('#weaverA').submit();	
}

function closeDialog(){
	parentWin.closeDialog();
}

//关闭页面并刷新列表
function closeDlgARfsh(){
	parentWin.closeDlgARfsh();
}
 
jQuery(document).ready(function(){
	resizeDialog();
	if("true"=="<%=op%>"){
	 	Dialog.alert('<%=SystemEnv.getHtmlLabelNames("33085,25008", user.getLanguage())%>');
	}else if("false"=="<%=op%>"){
		Dialog.alert('<%=SystemEnv.getHtmlLabelNames("33085,25009", user.getLanguage())%>');
	}
});

</script>
