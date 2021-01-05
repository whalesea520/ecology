<!DOCTYPE html>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowSubwfSetManager" class="weaver.workflow.workflow.WorkflowSubwfSetManager" scope="page"/>

<%
	String mainWorkflowId = Util.null2String(request.getParameter("wfid"));
	String triggerType = Util.null2String(request.getParameter("triggerType"));
	String triggerNode = Util.null2String(request.getParameter("triggerNode"));
	String selectedids = Util.null2String(request.getParameter("selectedids"));
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(Util.getIntValue(mainWorkflowId), 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	//int mainWorkflowFormId = 0;
	//String mainWorkflowIsBill = "";
	String isTriDiffWorkflow = "0";
	RecordSet.executeSql("select formId,isBill,isTriDiffWorkflow from workflow_base where id="+mainWorkflowId);
	if(RecordSet.next()){
		//mainWorkflowFormId = Util.getIntValue(RecordSet.getString("formId"),0);
		//mainWorkflowIsBill = Util.null2String(RecordSet.getString("isBill"));
		isTriDiffWorkflow = Util.null2String(RecordSet.getString("isTriDiffWorkflow"));
	}

	String allIds = "";
%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSure(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onclear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
    <script type='text/javascript' src='/dwr/interface/WorkflowSubwfSetUtil.js'></script>
	<script type='text/javascript' src='/dwr/engine.js'></script>
	<script type='text/javascript' src='/dwr/util.js'></script>	
	<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
	</script>
</HEAD>

<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32803, user.getLanguage())%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align: right;">
			<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>" onClick="submitData();" />
			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())%>" onclick="selectAll();" title="<%=SystemEnv.getHtmlLabelName(129517, user.getLanguage())%>" />
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name="formWorkflowSubwfSet" method="post" action="/workflow/workflow/WorkflowSubwfSetBrowser.jsp">     
	<input type="hidden" Name="wfid" value="<%=mainWorkflowId%>">
	<input type="hidden" Name="selectedids" value="<%=selectedids%>">
<%
	String attributes1 = "{'groupOperDisplay':'none','samePair':'subwfSetContentDivSame','groupDisplay':'','itemAreaDisplay':''}"; 
	String attributes2 = "{'groupOperDisplay':'none','samePair':'subwfSetContentDivDiff','groupDisplay':'none','itemAreaDisplay':'none'}"; 
	if("1".equals(isTriDiffWorkflow)){
		attributes1 = "{'groupOperDisplay':'none','samePair':'subwfSetContentDivSame','groupDisplay':'none','itemAreaDisplay':'none'}"; 
		attributes2 = "{'groupOperDisplay':'none','samePair':'subwfSetContentDivDiff','groupDisplay':'','itemAreaDisplay':''}";
	}
 %>
<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(22050,user.getLanguage())%></wea:item>
			<wea:item>
				<select style="width:80%;" class="InputStyle" name="triggerType">
					<option value=""></option>
					<option value="1" <%="1".equals(triggerType) ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(22051,user.getLanguage())%></option>
					<option value="2" <%="2".equals(triggerType) ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(22052,user.getLanguage())%></option>
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(19346,user.getLanguage())%></wea:item>
			<wea:item>
				<select style="width:80%;" class="InputStyle" name="triggerNode">
					<option value=""></option>
					<%
						RecordSet.executeSql("SELECT b.id AS triggerNodeId,a.nodeType AS triggerNodeType,b.nodeName AS triggerNodeName FROM workflow_flownode a,workflow_nodebase b WHERE (b.IsFreeNode IS NULL OR b.IsFreeNode!='1') AND a.nodeId=b.id AND a.workFlowId='"+mainWorkflowId+"' ORDER BY a.nodeType,a.nodeId");
						while (RecordSet.next()) {
							String triggerNodeId = Util.null2String(RecordSet.getString("triggerNodeId"));
					%>
					<option value="<%=triggerNodeId%>" <%=triggerNodeId.equals(triggerNode) ? "selected" : ""%>><%=Util.null2String(RecordSet.getString("triggerNodeName"))%></option>
					<%}%>					
				</select>
			</wea:item>
		</wea:group>
    <%if(isTriDiffWorkflow.equals("0")){ %>
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(31769,user.getLanguage())%>' attributes="<%=attributes1 %>">
			<wea:item attributes="{'isTableList':'true'}">
				<wea:layout needImportDefaultJsAndCss="false" attributes="{'formTableId':'oTable'}">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item  attributes="{'isTableList':'true'}">
							<!-- 分页列表 -->
							<% 
								List<Map<String,String>> allDatas = WorkflowSubwfSetManager.getSubwfSetTRString(mainWorkflowId, user.getLanguage(), true);
								if (allDatas != null) {
									for (Map<String, String> data : allDatas) {
										allIds += "," + data.get("id");
									}
								}
								String  operateString = "";
								String tabletype = "checkbox";
								String tableString = ""+
								   "<table  datasource=\"weaver.workflow.workflow.WorkflowSubwfSetManager.getSubwfSetList\" sourceparams=\"mainWorkflowId:"+mainWorkflowId+"+triggerType:"+triggerType+"+triggerNodeId:"+triggerNode+"\" needPage=\"false\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_WORKFLOWSUBWFSET,user.getUID())+"\" tabletype=\""+tabletype+"\">"+
								    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getMailCheckbox\" />"+
								   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
								   operateString+
								   "<head>"+							 
										 "<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"__ranking\"/>"+
										 "<col width=\"22%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(22050,user.getLanguage())+"\" column=\"triggerTypeText\"/>"+
										 "<col width=\"22%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" column=\"triggerNodeNameText\" text=\""+SystemEnv.getHtmlLabelName(19346,user.getLanguage())+"\"/>"+
										 "<col width=\"22%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(19347,user.getLanguage())+"\" column=\"triggerTimeText\"/>"+
										 "<col width=\"22%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(19351,user.getLanguage())+"\" column=\"subWorkflowNameText\"/>"+
								   "</head>"+
								   "</table>";
							%>
							<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false" selectedstrs="<%=selectedids%>" mode="run"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</wea:item>    
	    </wea:group>
	<%}else{ %>
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(31769,user.getLanguage())%>' attributes="<%=attributes2 %>">
			<wea:item attributes="{'isTableList':'true'}">
				<wea:layout needImportDefaultJsAndCss="false" attributes="{'formTableId':'oTableDiff'}">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item  attributes="{'isTableList':'true'}">
							<!-- 分页列表 -->
							<% 
								List<Map<String,String>> allDatas = WorkflowSubwfSetManager.getSubwfSetDiffTRString(mainWorkflowId, user.getLanguage(), true);
								if (allDatas != null) {
									for (Map<String, String> data : allDatas) {
										allIds += "," + data.get("id");
									}
								}
								String  operateString = "";
								String tabletype = "checkbox";
								String tableString = ""+
								   "<table  datasource=\"weaver.workflow.workflow.WorkflowSubwfSetManager.getSubwfSetDiffList\" sourceparams=\"mainWorkflowId:"+mainWorkflowId+"+triggerType:"+triggerType+"+triggerNodeId:"+triggerNode+"\" needPage=\"false\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_WORKFLOWSUBWFSET,user.getUID())+"\" tabletype=\""+tabletype+"\">"+
								    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getMailCheckbox\" />"+
								   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
								   operateString+
								   "<head>"+
								   		 "<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"__ranking\"/>"+
										 "<col width=\"22%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(22050,user.getLanguage())+"\" column=\"triggerTypeText\"/>"+
										 "<col width=\"22%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" column=\"triggerNodeNameText\" text=\""+SystemEnv.getHtmlLabelName(19346,user.getLanguage())+"\"/>"+
										 "<col width=\"22%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(19347,user.getLanguage())+"\" column=\"triggerTimeText\"/>"+
										 "<col width=\"22%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(21582,user.getLanguage())+"\" column=\"fieldNameText\"/>"+
								   "</head>"+
								   "</table>";
							%>
							<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false" selectedstrs="<%=selectedids%>" mode="run"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</wea:item>   
	    </wea:group>
	<%} %>
</wea:layout>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=O  id=btnok  value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSure();">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onclear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
	jQuery("#oTable").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
	jQuery("#oTableDiff").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
});

function submitData() {
	formWorkflowSubwfSet.submit();	
}

function selectAll() {
	var returnjson  = {id:'<%=allIds%>',name:'<%=allIds%>'} ;
	if (dialog) {
	    dialog.callback(returnjson);
	} else {  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}  
}

function onSure(){
    var printNodes = "";
    var printNodesName = "";

	var checkboxes = jQuery('div.table').find('tbody').find('[type=checkbox]');
	for(var i = 0; i < checkboxes.length; i++){
		var ckbx = checkboxes[i];
		
		if( jQuery(ckbx).attr('checked') ){
			var currentTr = jQuery(ckbx).parent().parent().parent();
			var nameTd = jQuery(currentTr).find('td:last-child');
			
			printNodes += (',' + jQuery(ckbx).attr('checkboxid') );
			printNodesName += (',' + jQuery(nameTd).text() );
		}
	}
    if( printNodes ){
		printNodes = printNodes.substr(1);
		printNodesName = printNodesName.substr(1);
	}
	
  	var returnjson  = {id:printNodes,name:printNodesName} ;
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}     
}

function js_btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}     
}

function checkAll(){
	var rowNum=document.getElementById("rowNum").value;
	for(i=0;i<rowNum;i++){
		document.getElementById("checkbox_"+i).status = true;
	}
	onSure();
}

function onclear(){
    js_btnclear_onclick();
}

function onClose()
{
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}
</script>
</html>
