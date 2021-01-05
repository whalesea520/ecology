<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.WorkflowSubwfSetUtil" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<% 
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
%>
<HTML>
	<HEAD>
		<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="../../js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = null;
			var dialog = null;
			if("<%=dialog%>"==1){
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
				function btn_cancle(){
					dialog.closeByHand();
				}
			}
			if("<%=isclose%>"==1){
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
				parentWin._table.reLoad();
				dialog.close();
			}
		</script>
	</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16579,user.getLanguage());
String needfav ="1";
String needhelp ="";
String isTriDiff = Util.null2String(request.getParameter("isTriDiff")); //是否为触发不同子流程 0、相同  1、不同

String mainWorkflowId = Util.null2String(request.getParameter("wfid"));
String subWorkflowId = "0";
String sql="";
String id=Util.null2String(request.getParameter("id"));
String isread = "0";
String isreadNodes = "";
String isreadMainwf = "0";
String isreadMainWfNodes = "";
String isreadParallelwf = "0";
String isreadParallelwfNodes = "";
if(!id.equals("")){
	if(isTriDiff.equals("1")){
		RecordSet.executeSql("select subWorkflowId,isread,isreadMainwf,isreadParallelwf,isreadNodes,isreadMainWfNodes,isreadParallelwfNodes from Workflow_TriDiffWfSubWf where id = "+id);
	}else{
		RecordSet.executeSql("select subWorkflowId,isread,isreadMainwf,isreadParallelwf,isreadNodes,isreadMainWfNodes,isreadParallelwfNodes from Workflow_SubwfSet where id = "+id);
	}
	if(RecordSet.next()){
		subWorkflowId = RecordSet.getString("subWorkflowId");
		isread = RecordSet.getString("isread");
		isreadNodes = RecordSet.getString("isreadNodes");
		isreadMainwf = RecordSet.getString("isreadMainwf");
		isreadMainWfNodes = RecordSet.getString("isreadMainWfNodes");
		isreadParallelwf = RecordSet.getString("isreadParallelwf");
		isreadParallelwfNodes = RecordSet.getString("isreadParallelwfNodes");
	}
}
int mainWorkflowFormId=0;
String mainWorkflowIsBill="";
String isTriDiffWorkflow="0";
RecordSet.executeSql("select formId,isBill,isTriDiffWorkflow from workflow_base where id='"+mainWorkflowId+"'");
if(RecordSet.next()){
	mainWorkflowFormId=Util.getIntValue(RecordSet.getString("formId"),0);
	mainWorkflowIsBill=Util.null2String(RecordSet.getString("isBill"));
	isTriDiffWorkflow=Util.null2String(RecordSet.getString("isTriDiffWorkflow"),"0");
}
if(isTriDiffWorkflow.equals("")){
	isTriDiffWorkflow="0";
}
%>
<body style="overflow-y:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if("".equals(id)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}else{
	if(isTriDiff.equals("1")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:updateDiffViewOpinion(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:updateViewOpinion(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
}
if(!"1".equals(dialog)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if("".equals(id)){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<%}else if(isTriDiff.equals("1")){%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="updateDiffViewOpinion();">
			<%}else{ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="updateViewOpinion();">
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id=weaver action="WorkflowSubwfSetOperation.jsp" method=post style="width:100%;">
<input type="hidden" name="mainWorkflowId" value="<%=mainWorkflowId %>">
<input type="hidden" name="operation" value="subwfSetAdd">
<input type="hidden" name="isTriDiff" value="<%=isTriDiff %>">
<input type="hidden" name="dialog" value="<%=dialog%>">
<wea:layout type="twoCol" attributes="{'cw1':'30%','cw2':'70%'}">
	<%if("".equals(id)){ %>
	<% if(!"1".equals(isTriDiff)){ %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(22050,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=InputStyle  name=triggerType  onChange="changeTriggerTypeAndOperation()">   
			    <option value="1" ><%=SystemEnv.getHtmlLabelName(22051,user.getLanguage())%></option> 
				<option value="2" ><%=SystemEnv.getHtmlLabelName(22052,user.getLanguage())%></option>
			</select>     				
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19346,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=InputStyle  name=triggerNodeId  onChange="changeTriggerTypeAndOperation()">    
			<%
			RecordSet.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and  a.workFlowId= '"+mainWorkflowId+"'  order by a.nodeType,a.nodeId  ");
			while(RecordSet.next()) {
			%>
			<option value="<%=Util.null2String(RecordSet.getString("triggerNodeType"))%>_<%=Util.null2String(RecordSet.getString("triggerNodeId"))%>"><%=Util.null2String(RecordSet.getString("triggerNodeName"))%></option>
			<%}%>						
			</select>
		</wea:item>
		<wea:item attributes="{'samePair':'trTriggerTimeShow','display':''}"><%=SystemEnv.getHtmlLabelName(19347,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'trTriggerTimeShow','display':''}">
			<select class=InputStyle  name=triggerTime  onChange="changeTriggerTypeAndOperation()">   
			    <option value="1" ><%=SystemEnv.getHtmlLabelName(19348,user.getLanguage())%></option> 
				<option value="2" selected><%=SystemEnv.getHtmlLabelName(19349,user.getLanguage())%></option>
			</select> 						
		</wea:item>     				
		<wea:item attributes="{'samePair':'trTriggerOperation','display':'none'}"><%=SystemEnv.getHtmlLabelName(22053,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'trTriggerOperation','display':'none'}">
			<select class=InputStyle  name=triggerOperation  onChange="triggerOperationSelected()">
			    <option value="" ></option>									
			    <option value="1" ><%=SystemEnv.getHtmlLabelName(25361,user.getLanguage())%></option> 
				<option value="2" ><%=SystemEnv.getHtmlLabelName(25362,user.getLanguage())%></option>
			</select> 
			<input type="hidden" name="triggerOperationHidden" id="triggerOperationHidden" value=""/>    				
		</wea:item>
		<wea:item attributes="{'samePair':'trTriggerOperationNew','display':'none'}"><%=SystemEnv.getHtmlLabelName(22053,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'trTriggerOperationNew','display':'none'}">
			<select class=InputStyle  name=triggerOperationNew  onChange="triggerOperationSelected()">
				<option value="" ></option>									
				<option value="3" ><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option> 
				<option value="4" ><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
			</select>     				
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(27156,user.getLanguage())%>
		</wea:item>
		<wea:item>
			
           <select class=InputStyle  name="triggerSource">
           <%
           		List<Map<String,String>> tables = WorkflowSubwfSetUtil.getTablesByWorkflow(mainWorkflowId);
           		for(int i = 0; i < tables.size(); i++){
           			Map<String, String> table = tables.get(i);
           			out.print("<option value="+table.get("tableId")+">"+table.get("tableName")+"</option>");
           		}
           %>
           </select> 
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19344,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser name="subWorkflowId" viewType="0" hasBrowser="true" hasAdd="false" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1" isMustInput="2" isSingle="true" hasInput="true"
						completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0"  width="200px" browserValue="" browserSpanValue=""/>    				
		</wea:item>
	</wea:group>	
	<%}else{ %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(22050,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=InputStyle  name=triggerTypeDiff id="triggerTypeDiff"  onChange="changeTriggerTypeAndOperationDiff()">   
				<option value="1" ><%=SystemEnv.getHtmlLabelName(22051,user.getLanguage())%></option> 
				<option value="2" ><%=SystemEnv.getHtmlLabelName(22052,user.getLanguage())%></option>
			</select>  
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19346,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=InputStyle  name=triggerNodeIdDiff id="triggerNodeIdDiff"  onChange="changeTriggerTypeAndOperationDiff()">    
			<%
			RecordSet.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and  a.workFlowId= '"+mainWorkflowId+"'  order by a.nodeType,a.nodeId  ");
			while(RecordSet.next()) {
			%>
			<option value="<%=Util.null2String(RecordSet.getString("triggerNodeType"))%>_<%=Util.null2String(RecordSet.getString("triggerNodeId"))%>"><%=Util.null2String(RecordSet.getString("triggerNodeName"))%></option>
			<%}%>
			</select>     				
		</wea:item>
		<wea:item attributes="{'samePair':'trTriggerTime','display':''}"><%=SystemEnv.getHtmlLabelName(19347,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'trTriggerTime','display':''}">
			<select class=InputStyle  name=triggerTimeDiff  id="triggerTimeDiff" onChange="changeTriggerTypeAndOperationDiff()">   
				<option value="1" ><%=SystemEnv.getHtmlLabelName(19348,user.getLanguage())%></option> 
				<option value="2" selected><%=SystemEnv.getHtmlLabelName(19349,user.getLanguage())%></option>
			</select>    				
		</wea:item>
		<wea:item attributes="{'samePair':'trTriggerOperationDiff','display':'none'}"><%=SystemEnv.getHtmlLabelName(22053,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'trTriggerOperationDiff','display':'none'}">
			<select class=InputStyle  name=triggerOperationDiff id="triggerOperationDiff" onChange="triggerOperationDiffSelected()">
				<option value="" ></option>									
				<option value="1" ><%=SystemEnv.getHtmlLabelName(25361,user.getLanguage())%></option> 
				<option value="2" ><%=SystemEnv.getHtmlLabelName(25362,user.getLanguage())%></option>
			</select>  
			<input type="hidden" name="triggerOperationHidden" id="triggerOperationHidden" value=""/>   				
		</wea:item>
		<wea:item attributes="{'samePair':'trTriggerOperationDiffNew','display':'none'}"><%=SystemEnv.getHtmlLabelName(22053,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'trTriggerOperationDiffNew','display':'none'}">
			<select class=InputStyle  name=triggerOperationDiffNew id="triggerOperationDiffNew"  onChange="triggerOperationDiffSelected()">
				<option value="" ></option>									
				<option value="3" ><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option> 
				<option value="4" ><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
			</select>     				
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(27156,user.getLanguage())%>
		</wea:item>
		<wea:item>
           <select class=InputStyle  name="triggerSource" onchange="toggleTriggeSource()">
           <%
           		List<Map<String,String>> tables = WorkflowSubwfSetUtil.getTablesByWorkflow(mainWorkflowId);
           		for(int i = 0; i < tables.size(); i++){
           			Map<String, String> table = tables.get(i);
           			out.print("<option value="+table.get("tableId")+">"+table.get("tableName")+"</option>");	
           		}
           %>
           </select> 
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21582,user.getLanguage())%></wea:item>
		<wea:item>
			<%
				List<Map<String,String>> tables = WorkflowSubwfSetUtil.getTablesByWorkflow(mainWorkflowId);
				for(int i = 0; i < tables.size(); i++){
					Map<String, String> table = tables.get(i);
					String[] tableInfo = table.get("tableId").split("_");
					
					String selectName = "fieldIdDiff_" + table.get("tableId");
					if( i == 0 ){
						out.println("<input type='hidden' id='fieldDiffSelectName' value='"+selectName+"'/>");
					}
					
					//查询主表多人力资源字段

					if( tableInfo[0].equals("main") ){
						out.println("<select class='inputstyle'  name='"+selectName+"' style='width:200px;'>");
						
						if(mainWorkflowIsBill.equals("0")){
						   	sql = "select a.id as id,c.fieldlable as name"
						   	+ " from workflow_formdict a,workflow_formfield b,workflow_fieldlable c"
						   	+ " where  c.isdefault='1' and c.formid = b.formid  and c.fieldid = b.fieldid"
						   	+ " and  b.fieldid= a.id and a.fieldhtmltype='3'"
						   	+ " and (a.type=17 or a.type=141 or a.type=142 or a.type=166 or a.type=160)"
						   	+ " and (b.isdetail<>'1' or b.isdetail is null) and b.formid="+mainWorkflowFormId
						   	+ " order by a.id asc";
						}else{
							sql = "select id as id , fieldlabel as name"
							+ " from workflow_billfield where (viewtype is null or viewtype<>1)"
							+ " and billid="+ mainWorkflowFormId+ " and fieldhtmltype = '3'"
							+ " and (type=17 or type=141 or type=142 or type=166 or type=160)"
							+ " order by id asc" ;
						}
					}else{//查询明细表多人力资源字段
						out.println("<select class='inputstyle'  name='"+selectName+"' style='display:none;width:200px;'>");
						if(mainWorkflowIsBill.equals("0")){
						   	sql = "select a.id as id,c.fieldlable as name"
						   	+ " from workflow_formdictdetail a,workflow_formfield b,workflow_fieldlable c"
						   	+ " where  c.isdefault='1' and c.formid = b.formid  and c.fieldid = b.fieldid"
						   	+ " and  b.fieldid= a.id and a.fieldhtmltype='3'"
						   	+ " and (a.type=17 or a.type=141 or a.type=142 or a.type=166 or a.type=160)"
						   	+ " and b.isdetail=1 and b.groupid="+tableInfo[1]+" and b.formid="+mainWorkflowFormId
						   	+ " order by a.id asc";
						}else{
							sql = "select id as id , fieldlabel as name"
							+ " from workflow_billfield where viewtype=1"
							+ " and billid="+ mainWorkflowFormId+ " and fieldhtmltype = '3'"
							+ " and (type=17 or type=141 or type=142 or type=166 or type=160)"
							+ " and detailtable = (select tablename from Workflow_billdetailtable where id="+tableInfo[1]+")"
							+ " order by id asc" ;
						}
					}
					
					RecordSet.executeSql(sql);
					while( RecordSet.next() ){
						String optionText = "";
						if(mainWorkflowIsBill.equals("0")) {
							optionText = RecordSet.getString("name");
						}else{
							optionText = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage());
						}
						out.print("<option value="+RecordSet.getString("id")+">"+optionText+"</option>");
					}
					out.println("</select>");
				}
			 %>
    	<span name="diffFieldSpanimg" id="diffFieldSpanimg">
			<img align="absmiddle" src="/images/BacoError_wev8.gif">
		</span>			
		</wea:item>
	</wea:group>	
	<%} %>
	<%} %>
	<%if(!"1".equals(isTriDiff) || !id.equals("")){ %>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33503,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(31770,user.getLanguage())%></wea:item>
			<wea:item>
				<%
					String completeUrl1 = "/data.jsp?type=workflowNodeBrowser&wfid="+subWorkflowId;
					String nodeNames = "";
					
					String display = "display:none;";
					String checked = "";
					if("1".equals(isread)){
						display = "display:inline-block;";
						checked = "checked";
						//读取节点名称
						String sqlGetNodeName = "select id,nodename from workflow_nodebase wn where wn.id=";
						String[] nodeIds = isreadNodes.split(",");
						for(int i = 0 ; i < nodeIds.length; i++){
							if(nodeIds[i].equals("all")){
								nodeNames += SystemEnv.getHtmlLabelName(332, user.getLanguage());
								break;
							}
							
							String sqlTemp = sqlGetNodeName + nodeIds[i];
							RecordSet.executeSql(sqlTemp);
							if( RecordSet.next() ){
								nodeNames += RecordSet.getString("nodename");
								if( i != nodeIds.length - 1){
									nodeNames += ",";
								}
							}
						}
					} 
				%>
				<input type="checkbox" <%=checked%> tzCheckbox="true" id="isread" name="isread" onclick='isreadChange(this)' value="1"></input>
				<span id="isreadspan" style="<%=display%>vertical-align:middle;padding-left:5px;">
					<div style='float:left;padding:3px 5px 0px 10px;'>
						<%=SystemEnv.getHtmlLabelName(31773,user.getLanguage())%>
					</div>
					<brow:browser name="isreadNodes" viewType="0" hasBrowser="true" hasAdd="false" 
						getBrowserUrlFn="getIsReadNodesUrl" isMustInput="1" isSingle="false" hasInput="true"
						completeUrl='<%=completeUrl1 %>'  width="250px" browserValue='<%=isreadNodes %>' browserSpanValue='<%=nodeNames %>' />
				</span>
			</wea:item>
			<wea:item>
				 <%=SystemEnv.getHtmlLabelName(31771,user.getLanguage())%>
			 </wea:item>
			<wea:item>
				<%
					String browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MainSubWorkFlowNodesBrowser.jsp?wfid="+mainWorkflowId+"_0_0";
					String completeUrl1 = "/data.jsp?type=workflowNodeBrowser&wfid="+mainWorkflowId;
					String nodeNames = "";
					String display = "display:none;";
					String checked = "";
					if("1".equals(isreadMainwf)){
						display = "display:inline-block;";
						checked = "checked";
						//读取节点名称
						String sqlGetNodeName = "select id,nodename from workflow_nodebase wn where wn.id=";
						String[] nodeIds = isreadMainWfNodes.split(",");
						for(int i = 0 ; i < nodeIds.length; i++){
							if(nodeIds[i].equals("all")){
								nodeNames += SystemEnv.getHtmlLabelName(332, user.getLanguage());
								break;
							}
							
							String sqlTemp = sqlGetNodeName + nodeIds[i];
							RecordSet.executeSql(sqlTemp);
							if( RecordSet.next() ){
								nodeNames += RecordSet.getString("nodename");
								if( i != nodeIds.length - 1){
									nodeNames += ",";
								}
							}
						}
					} 
				%>
				<input type="checkbox" <%=checked %> tzCheckbox="true" id="isreadMainwf" name="isreadMainwf" value="1" onclick="isreadMainwfChange(this)"></input>
				<span id="isreadMainwfspan" style="<%=display %>vertical-align:middle;padding-left:5px;">
					<div style='float:left;padding:3px 5px 0px 10px;'>
						<%=SystemEnv.getHtmlLabelName(31773,user.getLanguage())%>
					</div>
					<brow:browser name="isreadMainWfNodes" viewType="0" hasBrowser="true" hasAdd="false" 
						getBrowserUrlFn="getIsReadMainNodesUrl" isMustInput="1" isSingle="false" hasInput="true"
						completeUrl='<%=completeUrl1 %>'  width="250px" browserValue='<%=isreadMainWfNodes %>' browserSpanValue='<%=nodeNames %>' />
				</span>
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(31772,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<%
					String browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MainSubWorkFlowNodesBrowser.jsp?wfid="+subWorkflowId+"_0_0";
					String completeUrl1 = "/data.jsp?type=workflowNodeBrowser&wfid="+subWorkflowId;
					String nodeNames = "";
					String display = "display:none;";
					String checked = "";
					if("1".equals(isreadParallelwf)){
						display = "display:inline-block;";
						checked = "checked";
						//读取节点名称
						String sqlGetNodeName = "select id,nodename from workflow_nodebase wn where wn.id=";
						String[] nodeIds = isreadParallelwfNodes.split(",");
						for(int i = 0 ; i < nodeIds.length; i++){
							if(nodeIds[i].equals("all")){
								nodeNames += SystemEnv.getHtmlLabelName(332, user.getLanguage());
								break;
							}
							
							String sqlTemp = sqlGetNodeName + nodeIds[i];
							RecordSet.executeSql(sqlTemp);
							if( RecordSet.next() ){
								nodeNames += RecordSet.getString("nodename");
								if( i != nodeIds.length - 1){
									nodeNames += ",";
								}
							}
						}
					} 
				%>
			   <input type="checkbox" <%=checked %> tzCheckbox="true" id="isreadParallelwf" name="isreadParallelwf" value="1" onclick="isreadParallelwfChange(this)"></input>
				<span id="isreadParallelwfspan" style="<%=display %>vertical-align:middle;padding-left:5px;">
					<div style='float:left;padding:3px 5px 0px 10px;'>
						<%=SystemEnv.getHtmlLabelName(31773,user.getLanguage())%>
					</div>
					<brow:browser name="isreadParallelwfNodes" viewType="0" hasBrowser="true" hasAdd="false" 
						getBrowserUrlFn="getIsReadParaNodesUrl" isMustInput="1" isSingle="false" hasInput="true"
						completeUrl='<%=completeUrl1 %>'  width="250px" browserValue='<%=isreadParallelwfNodes %>' browserSpanValue='<%=nodeNames %>' />
				</span>
			</wea:item>
		</wea:group>
	<%} %>
</wea:layout>		
</form>
<%if("1".equals(dialog)){ %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('1');checkSubmit();">
		    	<span class="e8_sep_line">|</span>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('<%= isEntryDetail%>');checkSubmit();">
		    	<span class="e8_sep_line">|</span> --%>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
		validateDiffField();
	});
</script>
<%} %>
<script language="javascript">
function getIsReadNodesUrl(){
	var url = '/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MainSubWorkFlowNodesBrowser.jsp';
	var subWorkflowId = '<%=subWorkflowId%>';
	if ( !subWorkflowId ) return;
	url += ( '?wfid=' + subWorkflowId );
	
	var isReadNodes = jQuery('#isreadNodes').val();
	if ( isReadNodes == '<%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>' || isReadNodes == '') {
		url +=  '_0_0';
	}
	else {
		url +=  ( '_0_' + isReadNodes );
	}
	return url;
}

function getIsReadMainNodesUrl(){
	var url = '/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MainSubWorkFlowNodesBrowser.jsp';
	var mainWorkflowId = '<%=mainWorkflowId%>';
	if ( !mainWorkflowId ) return;
	url += ( '?wfid=' + mainWorkflowId );
	
	var isreadMainWfNodes = jQuery('#isreadMainWfNodes').val();
	if ( isreadMainWfNodes == '<%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>' || isreadMainWfNodes == '') {
		url +=  '_0_0';
	}
	else {
		url +=  ( '_0_' + isreadMainWfNodes );
	}
	return url;
}

function getIsReadParaNodesUrl(){
	var url = '/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MainSubWorkFlowNodesBrowser.jsp';
	var subWorkflowId = '<%=subWorkflowId%>';
	if ( !subWorkflowId ) return;
	url += ( '?wfid=' + subWorkflowId );
	
	var isreadParallelwfNodes = jQuery('#isreadParallelwfNodes').val();
	if ( isreadParallelwfNodes == '<%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>' || isreadParallelwfNodes == '') {
		url +=  '_0_0';
	}
	else {
		url +=  ( '_0_' + isreadParallelwfNodes );
	}
	return url;
}

function submitData(){
	enableAllmenu();
	var fieldDiffSelectName = jQuery('#fieldDiffSelectName').val();

	var isTriDiff_T = "<%=isTriDiff %>";
	if(isTriDiff_T!="1"){	
		if(check_form(weaver,"subWorkflowId")){
			weaver.submit();
		}else{
			displayAllmenu();
		}
	}else{
		validateDiffField();
		
		if(!jQuery('[name='+fieldDiffSelectName+']').val()){
			displayAllmenu();
			return alert('<%=SystemEnv.getHtmlLabelName(129515, user.getLanguage())%>');
		}
		
		if(check_form(weaver,fieldDiffSelectName)){
			weaver.submit();
		}else{
			displayAllmenu();
		}
	}
}

function updateViewOpinion(operation){
	if(!operation) operation = "updateIsRead";
	jQuery.ajax({
		url:"officalwf_operation.jsp",
		type:"post",
		dataType:"json",
		data:{
			workflowSubwfSetId : "<%=id%>",
			isread : jQuery("#isread").attr("checked")?"1":"0",
			isreadNodes : jQuery('#isreadNodes').val(),
			isreadMainwf : jQuery("#isreadMainwf").attr("checked")?"1":"0",
			isreadMainWfNodes : jQuery('#isreadMainWfNodes').val(),
			isreadParallelwf : jQuery("#isreadParallelwf").attr("checked")?"1":"0",
			isreadParallelwfNodes : jQuery("#isreadParallelwfNodes").val(),
			operation : operation,
			wfid : "<%=mainWorkflowId%>"
		},
		beforeSend:function(xhr){
			try{
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(129516, user.getLanguage())%>",true);
			}catch(e){}
		},
		complete:function(xhr){
			e8showAjaxTips("",false);
		},
		success:function(data){
			dialog.close();
		}
	});
}

function updateDiffViewOpinion(){
	updateViewOpinion("updateDiffIsRead");
}

function onReturn(){
	location="/workflow/workflow/WorkflowSubwfSet.jsp";
}
//提交表单
function submitForm(){
    weaver.submit();
}

function changeTriggerTypeAndOperation(){
	hideEle("trTriggerOperation");
	hideEle("trTriggerOperationNew");

    var triggerNodeId = $GetEle("triggerNodeId").value;
    var triggerNodeType = triggerNodeId.substring(0,triggerNodeId.indexOf("_"));
    triggerNodeId = triggerNodeId.substr(triggerNodeId.lastIndexOf("_")+1);

    var triggerType = $GetEle("triggerType").value;
    var triggerTime = $GetEle("triggerTime").value;
	var finalOperationValue = "";

	if(triggerType == 1){
		showEle("trTriggerTimeShow");
	    hideEle("trTriggerOperation");
		if(triggerNodeType == 1 || triggerTime == 1){
	        if(triggerTime == 1){			       
	        	finalOperationValue = $GetEle("triggerOperation").value;
	    		showEle("trTriggerOperation");
	    		hideEle("trTriggerOperationNew");
	    	}
	    	if(triggerTime == 2){
	    		finalOperationValue = $GetEle("triggerOperationNew").value;
	    		hideEle("trTriggerOperation");
	    		showEle("trTriggerOperationNew");
	    	}
		}
	}else{
		hideEle("trTriggerTimeShow");
	}
	$GetEle("triggerOperationHidden").value = finalOperationValue;
}

function triggerOperationSelected(){
	var triggerNodeId=$G("triggerNodeId").value;
    var triggerNodeType=triggerNodeId.substring(0,triggerNodeId.indexOf("_"));
    triggerNodeId=triggerNodeId.substr(triggerNodeId.lastIndexOf("_")+1)
    var triggerType=$G("triggerType").value;
    var triggerTime=$G("triggerTime").value;
	var finalOperationValue="";
	if(triggerType==1){
		if(triggerNodeType==1||triggerTime==1){
	    	if(triggerTime==1){ //到达节点
	    		finalOperationValue = $G("triggerOperation").value;
	    	}
	    	if(triggerTime==2){ //离开节点
	    		finalOperationValue = $G("triggerOperationNew").value;
	    	}
		}
	}
	$G("triggerOperationHidden").value = finalOperationValue;
}

function changeTriggerTypeAndOperationDiff(){
	hideEle("trTriggerOperationDiff");
	hideEle("trTriggerOperationDiffNew");

    var triggerNodeIdDiff=$GetEle("triggerNodeIdDiff").value;
    var triggerNodeTypeDiff=triggerNodeIdDiff.substring(0,triggerNodeIdDiff.indexOf("_"));
    triggerNodeIdDiff=triggerNodeIdDiff.substr(triggerNodeIdDiff.lastIndexOf("_")+1)

    var triggerTypeDiff=$GetEle("triggerTypeDiff").value;

    var triggerTimeDiff=$GetEle("triggerTimeDiff").value;
	var finalOperationDiffValue="";

	if(triggerTypeDiff==1){
		showEle("trTriggerTime");
	    hideEle("trTriggerOperationDiffNew");
		if(triggerNodeTypeDiff==1||triggerTimeDiff==1){
	        if(triggerTimeDiff==1){			       
	        	finalOperationDiffValue = $GetEle("triggerOperationDiff").value;
	    		showEle("trTriggerOperationDiff");
	    		hideEle("trTriggerOperationDiffNew");
	    	}
	    	if(triggerTimeDiff==2){
	    		finalOperationDiffValue = $GetEle("triggerOperationDiffNew").value;
	    		hideEle("trTriggerOperationDiff");
	    		showEle("trTriggerOperationDiffNew");
	    	}
		}
	}else{
		hideEle("trTriggerTime");
	}
	$GetEle("triggerOperationHidden").value = finalOperationDiffValue;
}

function triggerOperationDiffSelected(){
	var triggerNodeIdDiff=document.getElementById("triggerNodeIdDiff").value;
    var triggerNodeTypeDiff=triggerNodeIdDiff.substring(0,triggerNodeIdDiff.indexOf("_"));
    triggerNodeIdDiff=triggerNodeIdDiff.substr(triggerNodeIdDiff.lastIndexOf("_")+1)
    
    var triggerTypeDiff=document.getElementById("triggerTypeDiff").value;
    var triggerTimeDiff=document.getElementById("triggerTimeDiff").value;
    
	var finalOperationDiffValue="";
	if(triggerTypeDiff==1){
		if(triggerNodeTypeDiff==1||triggerTimeDiff==1){
	    	if(triggerTimeDiff==1){ //到达节点
	    		finalOperationDiffValue = document.getElementById("triggerOperationDiff").value;
	    	}
	    	if(triggerTimeDiff==2){ //离开节点
	    		finalOperationDiffValue = document.getElementById("triggerOperationDiffNew").value;
	    	}
		}
	}
	document.getElementById("triggerOperationHidden").value = finalOperationDiffValue;
}

var all = '<span class="e8_showNameClass">'
			+ '<a onclick="return false;" href="#all"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></a>'
			+ '<span id="all" class="e8_delClass" onclick="del(event,this,1,true,{});" style="opacity: 0; visibility: hidden;">&nbsp;x&nbsp;</span>'
		 + '</span>';
function isreadChange(me){
	if(jQuery(me).attr('checked')){
		jQuery('#isreadspan').css('display','inline-block');
		jQuery('#isreadNodes').val('all');
		jQuery('#isreadNodes').next().html(all);
		
		jQuery('#isreadspan').find('.e8_showNameClass').hover(
			function(){
				jQuery(this).find('.e8_delClass').attr('style','opacity: 1; visibility: visible;');
			},
			function(){
				jQuery(this).find('.e8_delClass').attr('style','opacity: 0; visibility: hidden;');
			}
		);
	}else{
		jQuery('#isreadspan').fadeOut();
		jQuery('#isreadNodes').val('');
		jQuery('#isreadNodes').next().html('');
	}
}

function isreadMainwfChange(me){
	if(jQuery(me).attr('checked')){
		jQuery('#isreadMainwfspan').css('display','inline-block');
		jQuery('#isreadMainWfNodes').val('all');
		jQuery('#isreadMainWfNodes').next().html(all);
		jQuery('#isreadMainwfspan').find('.e8_showNameClass').hover(
			function(){
				jQuery(this).find('.e8_delClass').attr('style','opacity: 1; visibility: visible;');
			},
			function(){
				jQuery(this).find('.e8_delClass').attr('style','opacity: 0; visibility: hidden;');
			}
		);
	}else{
		jQuery('#isreadMainwfspan').fadeOut();
		jQuery('#isreadMainWfNodes').val('');
		jQuery('#isreadMainWfNodes').next().html('');
	}
}

function isreadParallelwfChange(me){
	if(jQuery(me).attr('checked')){
		jQuery('#isreadParallelwfspan').css('display','inline-block');
		jQuery('#isreadParallelwfNodes').val('all');
		jQuery('#isreadParallelwfNodes').next().html(all);
		jQuery('#isreadParallelwfspan').find('.e8_showNameClass').hover(
			function(){
				jQuery(this).find('.e8_delClass').attr('style','opacity: 1; visibility: visible;');
			},
			function(){
				jQuery(this).find('.e8_delClass').attr('style','opacity: 0; visibility: hidden;');
			}
		);
	}else{
		jQuery('#isreadParallelwfspan').fadeOut();
		jQuery('#isreadParallelwfNodes').val('');
		jQuery('#isreadParallelwfNodes').next().html('');
	}
}

function toggleTriggeSource(){
	var triggerSource = jQuery('[name=triggerSource]').val();
	jQuery('[name^=fieldIdDiff_]').each(function(i, v){
		if( jQuery(v).attr('name') != 'fieldIdDiff_' + triggerSource){
			jQuery('.weatable_' + jQuery(v).attr('name')).hide();
			jQuery('.weatable_' + jQuery(v).attr('name')).parent().hide();
		}else{
			jQuery('#fieldDiffSelectName').val(jQuery(v).attr('name'));
			
			jQuery('.weatable_' + jQuery(v).attr('name')).width(230);
			jQuery('.weatable_' + jQuery(v).attr('name')).parent().width(230);
			
			jQuery('.weatable_' + jQuery(v).attr('name')).show();
			jQuery('.weatable_' + jQuery(v).attr('name')).parent().show();
		}
	});
	
	validateDiffField();
}

function validateDiffField(){
	var triggerSource = jQuery('[name=triggerSource]').val();
	var val = jQuery('[name=fieldIdDiff_' + triggerSource+']').val();
	if(val){
		jQuery('#diffFieldSpanimg').hide();
	}else{
		jQuery('#diffFieldSpanimg').show();
	}
}
</script>
</BODY>
</HTML>
