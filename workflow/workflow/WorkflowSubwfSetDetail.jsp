<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@ page import="weaver.workflow.workflow.WorkflowSubwfSetUtil" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="WorkflowSubwfSetManager" class="weaver.workflow.workflow.WorkflowSubwfSetManager" scope="page"/>

<%
	int mainWorkflowId = Util.getIntValue(request.getParameter("mainWorkflowId"));
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(mainWorkflowId, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
		response.sendRedirect("/notice/noright.jsp");
		return;
	} 
%>

<%

	
	int subWorkflowId = Util.getIntValue(request.getParameter("subWorkflowId"), 0);
	int workflowSubwfSetId = Util.getIntValue(request.getParameter("workflowSubwfSetId"), 0);
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	//获得主流程的相关信息
	WFManager.setWfid(mainWorkflowId);
	WFManager.getWfInfo();
	
	String mainWorkflowFormId = String.valueOf(WFManager.getFormid());
	String mainWorkflowIsBill = WFManager.getIsBill();
	
	//获得子流程配置的相关信息
	String hisSubwfCreatorType="";
	String hisSubwfCreatorFieldId="";
	String triggerSourceType = "";
	String triggerSourceOrder = "";
	String triggerSource = "";
	String triggerSourceText = "";
	String isStopCreaterNode = "";
	
	String condition = "";
    String conditioncn = "";
    int detailid = 0;
	
	RecordSet.executeSql(" select condition, conditioncn, subwfCreatorType,subwfCreatorFieldId,triggerSource,triggerSourceOrder,isStopCreaterNode,triggerSourceType from Workflow_SubwfSet where id="+workflowSubwfSetId);
	if(RecordSet.next()){
		hisSubwfCreatorType = RecordSet.getString("subwfCreatorType");
		hisSubwfCreatorFieldId = RecordSet.getString("subwfCreatorFieldId");
		triggerSource = RecordSet.getString("triggerSource");
		triggerSourceType = RecordSet.getString("triggerSourceType");
		triggerSourceOrder = RecordSet.getString("triggerSourceOrder");
		if( triggerSourceType.equals("main") ){
			triggerSourceText = SystemEnv.getHtmlLabelName(21778, user.getLanguage());
		}else if( triggerSourceType.equals("detail") ){
			triggerSourceText = SystemEnv.getHtmlLabelName(19325, user.getLanguage()) + triggerSourceOrder;
			//加密
            detailid = RuleBusiness.getDetailTableId(Util.getIntValue(RecordSet.getString("triggersource"), 0), 0);
		}
		
		isStopCreaterNode =  RecordSet.getString("isStopCreaterNode").equals("1") ? "checked" : "";
		
		condition = Util.null2String(RecordSet.getString("condition"));
        //conditioncn = Util.null2String(RecordSet.getString("conditioncn"));
        conditioncn = RuleBusiness.getRuleInfoByRIds(7, workflowSubwfSetId + "").get(RuleBusiness.RULE_DESC_KEY);
	}
	//子流程创建人字段类型
	Map<String,String> creatorFieldType = WorkflowSubwfSetUtil.getFieldType(mainWorkflowIsBill, hisSubwfCreatorFieldId, triggerSourceType);
	int gloatIndex = 0;
%>

<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(19343, user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(19344, user.getLanguage())+"）" + SystemEnv.getHtmlLabelName(19342,user.getLanguage());
    String needfav = "";
    String needhelp = "";
%>
<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
    <script type="text/javascript">
    	var parentWin = null;
		var curdialog = null;
		if("<%=dialog%>"==1){
			parentWin = parent.parent.getParentWindow(parent);
			curdialog = parent.parent.getDialog(parent);
			function btn_cancle(){
				curdialog.closeByHand();
			}
		}
		if("<%=isclose%>"==1){
			//parentWin = parent.parent.getParentWindow(parent);
			//dialog = parent.parent.getDialog(parent);
			//parentWin.location="/workflow/workflow/WorkflowSubwfSet.jsp?wfid=<%=mainWorkflowId %>";
			//parentWin._table.reLoad();
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>');
			//dialog.close();
		}
		
		var dialog = null;
        function onShowBrowser4port(id,rformid,risbill,rwfid,isreject,curtype){
	        if(id==0) {
	            //alert("请先保存新插入的节点出口");
	        } else {
	            dialog = new window.top.Dialog();
	            dialog.currentWindow = window;
	            var url = "/formmode/interfaces/showconditionContent.jsp?rulesrc=7&detailid=<%=detailid %>&formid="+rformid+"&isbill="+risbill+"&linkid="+id+"&wfid="+rwfid+"&isreject="+isreject+"&curtype="+curtype;
	            dialog.Title = "<%=SystemEnv.getHtmlLabelName(126298, user.getLanguage()) %>";
	            dialog.Width = 900;
	            dialog.Height = 500;
	            dialog.Drag = true;
	            dialog.maxiumnable = true;
	            dialog.URL = url;
	            dialog.show();
	        }
        }
    </script>
</HEAD>

<body style="overflow:hidden;">
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<%}%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveWorkflowSubwfSetDetail1(this),_self}";
    RCMenuHeight += RCMenuHeightStep ;
	 if(!"1".equals(dialog)){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancelWorkflowSubwfSetDetail(this),_self}";
	    RCMenuHeight += RCMenuHeightStep;
	 }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>ag
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSaveWorkflowSubwfSetDetail1(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id="formWorkflowSubwfSetDetail" name="formWorkflowSubwfSetDetail" method="post" action="WorkflowSubwfSetOperation.jsp">      
<input type="hidden" Name="operation" value="addSubwfSetDetail">
<input type="hidden" Name="mainWorkflowId" value="<%=mainWorkflowId%>">
<input type="hidden" Name="subWorkflowId" value="<%=subWorkflowId%>">
<input type="hidden" Name="workflowSubwfSetId" value="<%=workflowSubwfSetId%>">
<input type="hidden" name="dialog" value="<%=dialog%>">
<wea:layout type="2col" attributes="{'cw1':'35%','cw2':'65%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(31826,user.getLanguage())%>'>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(33383,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<%=triggerSourceText%>
		</wea:item>
		<%--
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(33384,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input type='hidden' id='triggerCondtion' name='triggerCondition' value='triggerCondition'/>
		</wea:item>
		--%>
		
		<wea:item>
             <%=SystemEnv.getHtmlLabelName(33384,user.getLanguage())%>
         </wea:item>
         <wea:item>
             <!-- <input type='hidden' id='triggerCondition' name='triggerCondition' value='triggerCondition'/> -->
             <button type="button" class=Browser1 onclick="onShowBrowser4port(<%=workflowSubwfSetId %>, <%=mainWorkflowFormId%>,<%=mainWorkflowIsBill %>,<%=mainWorkflowId %>)"></button>
             <input type="hidden" name="conditionss" id="conditionss" value="<%=condition %>">
             <input type="hidden" name="conditioncn" id="conditioncn" value="<%=conditioncn %>">
             <input type="hidden" name="conditionkeyid" id="conditionkeyid">
             <input type="hidden" name="rulemaplistids" id="rulemaplistids">
             <input type="hidden" name="ruleRelationship" id="ruleRelationship">
             <span id="conditions">
             <%=conditioncn %>
             </span>
         </wea:item>
		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(31827,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input type='checkbox' <%=isStopCreaterNode %> tzCheckbox='true' id='isStopCreaterNode' name='isStopCreaterNode' value='1'/>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19352,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(19353,user.getLanguage())%></wea:item>
		<wea:item>
			<input type='radio' name='subwfCreatorType' id='subwfCreatorType_1' onclick='toggleSubWfCreatorType()' value="1" <%if("1".equals(hisSubwfCreatorType)||"".equals(hisSubwfCreatorType)){%> checked <%}%> >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19354,user.getLanguage())%></wea:item>
		<wea:item>
			<input type='radio' name='subwfCreatorType' id='subwfCreatorType_2' onclick='toggleSubWfCreatorType()' value="2" <%if("2".equals(hisSubwfCreatorType)){%> checked <%}%> >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19355,user.getLanguage())%></wea:item>
		<wea:item>
			<input type='radio' name='subwfCreatorType' id='subwfCreatorType_3' onclick='toggleSubWfCreatorType()' value="3" style="float: left;" <%if("3".equals(hisSubwfCreatorType)){%> checked <%}%>>
			<select class='inputstyle'  name='subwfCreatorFieldId' onfocus="changeSubwfCreatorType('subwfCreatorType_3')" onchange='changeCreatorField()' style='width:200px;padding-left:20px;'>
			<%
				//查询主表人力资源字段
			   String sql="";
			   if(mainWorkflowIsBill.equals("0")){
				    sql = "select a.id as id,c.fieldlable as name,a.fieldhtmltype htmltype,a.type type"
				    + " from workflow_formdict a,workflow_formfield b,workflow_fieldlable c"
				    + " where  c.isdefault='1' and c.formid = b.formid  and c.fieldid = b.fieldid"
				    + " and  b.fieldid= a.id and a.fieldhtmltype='3'"
				    + " and (a.type = 1 or a.type=17 or a.type=141 or a.type=142 or a.type=166 or a.type=165  or a.type=160)"
				    + " and (b.isdetail<>'1' or b.isdetail is null) and b.formid="+mainWorkflowFormId;
				}else{
					sql = "select id as id , fieldlabel as name,fieldhtmltype htmltype,type type"
					+ " from workflow_billfield where (viewtype is null or viewtype<>1)"
					+ " and billid="+ mainWorkflowFormId+ " and fieldhtmltype = '3'"
					+ " and (type=1 or type=17 or type=141 or type=142 or type=166 or type=165 or type=160) " ;
				}
				RecordSet.executeSql(sql);
				String fieldId="";
				while(RecordSet.next()){
					fieldId = RecordSet.getString("id");
					String value = RecordSet.getString("htmltype") + "_" + RecordSet.getString("type") + "_" + RecordSet.getString("id");
					
					String selected = "";
					if(fieldId.equals(hisSubwfCreatorFieldId)){
						selected = "selected";
					}
					out.print("<option value="+value+" "+selected+">");
					if(mainWorkflowIsBill.equals("0")) {
						out.print(RecordSet.getString("name"));
					}else {
						out.print(SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage()));
					}
					out.print("</option>");
				}
				
				//当触发来源为明细表时，需要获取触发来源所选择的明细表中的人力资源字段
				if( triggerSourceType.equals("detail") ){
					if(mainWorkflowIsBill.equals("0")){
					    sql = "select a.id as id,c.fieldlable as name,a.fieldhtmltype htmltype,a.type type"
					    + " from workflow_formdictdetail a,workflow_formfield b,workflow_fieldlable c"
					    + " where  c.isdefault='1' and c.formid = b.formid  and c.fieldid = b.fieldid"
					    + " and  b.fieldid= a.id and a.fieldhtmltype='3'"
					    + " and (a.type = 1 or a.type=17 or a.type=141 or a.type=142 or a.type=166 or a.type=165  or a.type=160)"
					    + " and b.isdetail = 1 and b.groupid="+triggerSource+" and b.formid="+mainWorkflowFormId;
					}else{
						sql = "select id as id , fieldlabel as name,fieldhtmltype htmltype,type type"
						+ " from workflow_billfield where viewtype = 1"
						+ " and billid="+ mainWorkflowFormId+ " and fieldhtmltype = '3'"
						+ " and (type=1 or type=17 or type=141 or type=142 or type=166 or type=165 or type=160)"
						+ " and detailtable = (select tablename from Workflow_billdetailtable where id="+triggerSource+")";
					}
					
					out.print("<option value='__'>---"+triggerSourceText+"---</option>");
					
					RecordSet.executeSql(sql);
					while(RecordSet.next()){
						fieldId = RecordSet.getString("id");
						String value = RecordSet.getString("htmltype") + "_" + RecordSet.getString("type") + "_" + RecordSet.getString("id");
						
						String selected = "";
						if(fieldId.equals(hisSubwfCreatorFieldId)){
							selected = "selected";
						}
						out.print("<option value="+value+" "+selected+">");
						if(mainWorkflowIsBill.equals("0")) {
							out.print(RecordSet.getString("name"));
						}else {
							out.print(SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage()));
						}
						out.print("</option>");
					}
				}
				%>
			</select>			
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19356,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%>'>
					<wea:item attributes="{'isTableList':'true'}">
						<wea:layout needImportDefaultJsAndCss="false" type="table" attributes="{'cols':'4','cws':'25%,25%,20%,30%','formTableId':'oTableOfSubwfSetDetail'}">
							<wea:group context="" attributes="{'groupDisplay':'none'}">
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19357,user.getLanguage())%></wea:item>
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19358,user.getLanguage())%></wea:item>
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></wea:item>
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(31828,user.getLanguage())%></wea:item>
								<%
									String sql = "";
									List<Map<String, String>> mainFields = WorkflowSubwfSetManager.getMainWorkflowFields(mainWorkflowId, workflowSubwfSetId, user.getLanguage());
									List<Map<String, String>> details = WorkflowSubwfSetManager.getSubWfSetMainFieldDetails(mainWorkflowId, subWorkflowId, workflowSubwfSetId, user.getLanguage());
									for(int i = 0; i < details.size();i++,gloatIndex++){
										Map<String, String> detail = details.get(i);
										//获取主流程字段类型 
									  	Map<String, String> mainFieldType = WorkflowSubwfSetUtil.getFieldType(mainWorkflowIsBill, detail.get("mainWorkflowFieldId"), triggerSourceType);
								%>
										<wea:item>
											<input type='hidden' name='subwfSetDetailId' value='<%=detail.get("id")%>'>
											<input type='hidden' name='subWorkflowFieldId' value='<%=detail.get("subWorkflowFieldId")%>'>
											<%=detail.get("subWorkflowFieldName") %>
										</wea:item>
										<wea:item>
											<select name='mainWorkflowFieldId' id='mainWorkflowFieldId_<%=gloatIndex%>' onchange='mainFieldChange(this)'>
											<%
												for(int k = 0 ; k < mainFields.size(); k++){
													Map<String, String> field = mainFields.get(k);
													
													String selected = !"".equals(detail.get("mainWorkflowFieldId")) && field.get("fieldId").equals( detail.get("mainWorkflowFieldId") ) ? "selected" : "";
													String value = field.get("fieldHtmlType") + "_" + field.get("fieldType") + "_"  + field.get("fieldId");
											%>
												<option value='<%=value%>' <%=selected %>><%=field.get("fieldName") %></option>
											<%		
												}
											%>
											</select>
										</wea:item>
										<wea:item>
										<%
											/**************************************************** 
											* 当子流程创建人为：主流程人力资源相关字段，
											* 并且字段为:多人力资源、分权多人力资源、人力资源条件、收（发）文单位、角色人员
											*****************************************************/
											String isShow_ifSplitFieldDiv = "display:none;";
											if( hisSubwfCreatorType.equals("3")
												&& WorkflowSubwfSetUtil.isMultiHr(creatorFieldType.get("htmlType"), creatorFieldType.get("type"))
											  ){
											  	//当主流程字段等于子流程创建人字段时
											  	//显示“字段值拆分”设置项
											  	if( hisSubwfCreatorFieldId.equals(detail.get("mainWorkflowFieldId")) ){
											  		isShow_ifSplitFieldDiv = "display:block;";
											  	}
											}
											
											String isChecked_ifSplitField = "";
											if(detail.get("ifSplitField").equals("1")){
												isChecked_ifSplitField = "checked";
											}
											
											/*重新生成文档设置项显示控制*/
											String isShow_isCreateDocAgainDiv = "display:none;";
											if( WorkflowSubwfSetUtil.isDocument(mainFieldType.get("htmlType"), mainFieldType.get("type"))){
												isShow_isCreateDocAgainDiv = "display:block;";
											}

											String isChecked_isCreateDocAgain = "";
											if(detail.get("isCreateDocAgain").equals("1")){
												isChecked_isCreateDocAgain = "checked";
											}

											/*重新生成附件设置项显示控制*/
											String isShow_isCreateAttachmentAgainDiv = "display:none;";
											if( WorkflowSubwfSetUtil.isAttachment(mainFieldType.get("htmlType"), mainFieldType.get("type"))){
												isShow_isCreateAttachmentAgainDiv = "display:block;";
											}

											String isChecked_isCreateAttachmentAgain = "";
											if(detail.get("isCreateAttachmentAgain").equals("1")){
												isChecked_isCreateAttachmentAgain = "checked";
											}

										 %>
											<div id='ifSplitFieldDiv_<%=gloatIndex%>' style='<%=isShow_ifSplitFieldDiv %>'>
												<input type='checkbox' id='ifSplitField_<%=gloatIndex%>' name='ifSplitField_<%=gloatIndex%>' <%=isChecked_ifSplitField%> tzCheckbox='true' value='1'/>
												<%=SystemEnv.getHtmlLabelName(19359,user.getLanguage())%>
											</div>
											<div id='isCreateDocAgainDiv_<%=gloatIndex%>' style='<%=isShow_isCreateDocAgainDiv%>'>
												<input type='checkbox' id='isCreateDocAgain_<%=gloatIndex%>' name='isCreateDocAgain_<%=gloatIndex%>' <%=isChecked_isCreateDocAgain%> tzCheckbox='true' value='1'/>
												<%=SystemEnv.getHtmlLabelName(21718,user.getLanguage())%>
											</div>
											<div id='isCreateAttachmentAgainDiv_<%=gloatIndex%>' style='<%=isShow_isCreateAttachmentAgainDiv%>'>
												<input type='checkbox' id='isCreateAttachmentAgain_<%=gloatIndex%>' name='isCreateAttachmentAgain_<%=gloatIndex%>' <%=isChecked_isCreateAttachmentAgain%> tzCheckbox='true' value='1'/>
												<%=SystemEnv.getHtmlLabelName(21719,user.getLanguage())%>
											</div>
										</wea:item>
										<wea:item>
											<%
												String isShow_CreateForAnyoneDiv = "display:none;";
												/**************************************************** 
												* 当子流程创建人为单人力资源类型，具体分为以下几种情况
												* 1.子流程创建人为：主流程当前操作人
												* 2.子流程创建人为：主流程创建人
												* 3.子流程创建人：主流程人力资源相关字段，并且字段为人力资源、分权单人力资源类型
												*****************************************************/
												if( hisSubwfCreatorType.equals("1")
													|| hisSubwfCreatorType.equals("2")
													|| (
															hisSubwfCreatorType.equals("3")
															&& WorkflowSubwfSetUtil.isSingleHr(creatorFieldType.get("htmlType"), creatorFieldType.get("type"))
														)
												  ){
												  	
												  	//当主流程字段为多人力资源类型时：多人力资源、分权多人力资源、人力资源条件、收（发）文单位、角色人员
												  	//显示“每人力资源创建单独子流程”设置项
												  	if(WorkflowSubwfSetUtil.isMultiHr( mainFieldType.get("htmlType"), mainFieldType.get("type") )){
												  		isShow_CreateForAnyoneDiv = "display:block;";
												  	}
												}
												
												String isChecked_isCreateForAnyone = "";
												if( detail.get("isCreateForAnyone").equals("1") ){
													isChecked_isCreateForAnyone = "checked";
												}
											 %>
											<div id='isCreateForAnyoneDiv_<%=gloatIndex%>' style='<%=isShow_CreateForAnyoneDiv %>'>
												<input type='checkbox' id='isCreateForAnyone_<%=gloatIndex%>' name='isCreateForAnyone_<%=gloatIndex%>' onclick='createForAnyoneChange(this)' <%=isChecked_isCreateForAnyone%> tzCheckbox='true' value='1'/>
												<%=SystemEnv.getHtmlLabelName(19361,user.getLanguage())%>
											</div>
										</wea:item>
								<%	} %>
							</wea:group>
						</wea:layout>
					</wea:item>
				</wea:group>
				<%
					List<Map<String, String>> detailFields = WorkflowSubwfSetManager.getMainWorkflowDetailFields(triggerSourceType, triggerSource, mainWorkflowId, user.getLanguage());
					List<List<Map<String, String>>> groupDetails = WorkflowSubwfSetManager.getGroupedSubWfSetDetailFieldDetails(mainWorkflowId, subWorkflowId, workflowSubwfSetId, user.getLanguage());
					for(int i = 0; i < groupDetails.size(); i++){
						List<Map<String, String>> group = groupDetails.get(i);
				%>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())+(i+1)%>'>
						<wea:item attributes="{'isTableList':'true'}">
							<wea:layout needImportDefaultJsAndCss="false" type="table" attributes="{'cols':'4','cws':'25%,25%,20%,30%','formTableId':'oTableOfSubwfSetDetail'}">
							<wea:group context="" attributes="{'groupDisplay':'none'}">
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19357,user.getLanguage())%></wea:item>
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19358,user.getLanguage())%></wea:item>
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></wea:item>
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(31828,user.getLanguage())%></wea:item>
								<%
									for(int j = 0; j < group.size(); j++, gloatIndex++){
										Map<String, String> detail = group.get(j);
										//获取主流程字段类型 
					  					Map<String, String> mainFieldType = WorkflowSubwfSetUtil.getFieldType(mainWorkflowIsBill, detail.get("mainWorkflowFieldId"), true);
								%>
									<wea:item>
										<input type='hidden' name='subwfDltSetDetailId' value='<%=detail.get("id")%>'>
										<input type='hidden' name='subWorkflowDltFieldId' value='<%=detail.get("subWorkflowFieldId")%>'>
										<%=detail.get("subWorkflowFieldName") %>
									</wea:item>
									<wea:item>
										<select name='dltWorkflowFieldId' id='mainWorkflowFieldId_<%=gloatIndex%>' onchange='mainFieldChange(this)'>
										<%
											for(int k = 0,groupOrder = 0 ; k < detailFields.size(); k++){
												Map<String, String> field = detailFields.get(k);
												String selected = !"".equals(detail.get("mainWorkflowFieldId")) && field.get("fieldId").equals(detail.get("mainWorkflowFieldId")) ? "selected" : "";
												String value = field.get("fieldHtmlType") + "_" + field.get("fieldType") + "_"  + field.get("fieldId");
										%>
											<option value='<%=value%>' <%=selected %>><%=field.get("fieldName") %></option>
										<%		
											}
										%>
										</select>
									</wea:item>
									<wea:item>
									<%
										/**************************************************** 
										* 当子流程创建人为：主流程人力资源相关字段，
										* 并且字段为:多人力资源、分权多人力资源、人力资源条件、收（发）文单位、角色人员
										*****************************************************/
										String isShow_ifSplitFieldDiv = "display:none;";
										if( hisSubwfCreatorType.equals("3")
											&& WorkflowSubwfSetUtil.isMultiHr(creatorFieldType.get("htmlType"), creatorFieldType.get("type"))
										  ){
										  	//当主流程字段等于子流程创建人字段时
										  	//显示“字段值拆分”设置项
										  	if( hisSubwfCreatorFieldId.equals(detail.get("mainWorkflowFieldId")) ){
										  		isShow_ifSplitFieldDiv = "display:block;";
										  	}
										}
										
										String isChecked_ifSplitField = "";
										if(detail.get("ifSplitField").equals("1")){
											isChecked_ifSplitField = "checked";
										}
										
										/*重新生成文档设置项显示控制*/
										String isShow_isCreateDocAgainDiv = "display:none;";
										if( WorkflowSubwfSetUtil.isDocument(mainFieldType.get("htmlType"), mainFieldType.get("type"))){
											isShow_isCreateDocAgainDiv = "display:block;";
										}

										String isChecked_isCreateDocAgain = "";
										if(detail.get("isCreateDocAgain").equals("1")){
											isChecked_isCreateDocAgain = "checked";
										}

										/*重新生成附件设置项显示控制*/
										String isShow_isCreateAttachmentAgainDiv = "display:none;";
										if( WorkflowSubwfSetUtil.isAttachment(mainFieldType.get("htmlType"), mainFieldType.get("type"))){
											isShow_isCreateAttachmentAgainDiv = "display:block;";
										}

										String isChecked_isCreateAttachmentAgain = "";
										if(detail.get("isCreateAttachmentAgain").equals("1")){
											isChecked_isCreateAttachmentAgain = "checked";
										}

									 %>
										<div id='ifSplitFieldDiv_<%=gloatIndex%>' style='<%=isShow_ifSplitFieldDiv %>'>
											<input type='checkbox' id='ifSplitField_<%=gloatIndex%>' name='ifSplitField_<%=gloatIndex%>' <%=isChecked_ifSplitField%> tzCheckbox='true' value='1'/>
											<%=SystemEnv.getHtmlLabelName(19359,user.getLanguage())%>
										</div>
										<div id='isCreateDocAgainDiv_<%=gloatIndex%>' style='<%=isShow_isCreateDocAgainDiv%>'>
											<input type='checkbox' id='isCreateDocAgain_<%=gloatIndex%>' name='isCreateDocAgain_<%=gloatIndex%>' <%=isChecked_isCreateDocAgain%> tzCheckbox='true' value='1'/>
											<%=SystemEnv.getHtmlLabelName(21718,user.getLanguage())%>
										</div>
										<div id='isCreateAttachmentAgainDiv_<%=gloatIndex%>' style='<%=isShow_isCreateAttachmentAgainDiv%>'>
											<input type='checkbox' id='isCreateAttachmentAgain_<%=gloatIndex%>' name='isCreateAttachmentAgain_<%=gloatIndex%>' <%=isChecked_isCreateAttachmentAgain%> tzCheckbox='true' value='1'/>
											<%=SystemEnv.getHtmlLabelName(21719,user.getLanguage())%> 
										</div>
									</wea:item>
									<wea:item>
										<%
											String isShow_CreateForAnyoneDiv = "display:none;";
											/**************************************************** 
											* 当子流程创建人为单人力资源类型，具体分为以下几种情况
											* 1.子流程创建人为：主流程当前操作人
											* 2.子流程创建人为：主流程创建人
											* 3.子流程创建人：主流程人力资源相关字段，并且字段为人力资源、分权单人力资源类型
											*****************************************************/
											if( hisSubwfCreatorType.equals("1")
												|| hisSubwfCreatorType.equals("2")
												|| (
														hisSubwfCreatorType.equals("3")
														&& WorkflowSubwfSetUtil.isSingleHr(creatorFieldType.get("htmlType"), creatorFieldType.get("type"))
													)
											  ){
											  	//当主流程字段为多人力资源类型时：多人力资源、分权多人力资源、人力资源条件、收（发）文单位、角色人员
											  	//显示“每人力资源创建单独子流程”设置项
											  	if(WorkflowSubwfSetUtil.isMultiHr( mainFieldType.get("htmlType"), mainFieldType.get("type") )){
											  		isShow_CreateForAnyoneDiv = "display:block;";
											  	}
											}
											
											String isChecked_isCreateForAnyone = "";
											if( detail.get("isCreateForAnyone").equals("1") ){
												isChecked_isCreateForAnyone = "checked";
											}
										 %>
										<div id='isCreateForAnyoneDiv_<%=gloatIndex%>' style='<%=isShow_CreateForAnyoneDiv %>'>
											<input type='checkbox' id='isCreateForAnyone_<%=gloatIndex%>' name='isCreateForAnyone_<%=gloatIndex%>' onclick='createForAnyoneChange(this)' <%=isChecked_isCreateForAnyone%> tzCheckbox='true' value='1'/>
											<%=SystemEnv.getHtmlLabelName(19361,user.getLanguage())%>
										</div>
									</wea:item>
								<%	} %>
							</wea:group>
						</wea:layout>
						</wea:item>
					</wea:group>
				<%} %>
			</wea:layout>
		</wea:item>	
	</wea:group>
</wea:layout>
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
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
<%} %>
</body>
<script type="text/javascript">
// function changeSubwfCreatorType(subwfCreatorType){
// 	$GetEle(subwfCreatorType).checked = true;
// }

function changeIfSplitField(obj){

    var objId=$(obj).attr("id");
    var objValue=$(obj).val();

    var divName="divIfSplitField_"+objId.substr(objId.lastIndexOf("_")+1)

    var objHtmlType=objValue.substring(0,objValue.indexOf("_"));
    var objType=objValue.substring(objValue.indexOf("_")+1,objValue.lastIndexOf("_"));

    var objChkIfSplitField=$($(obj).parent().next().children()[0]).children()[0];
    
    if(objHtmlType=='3'&&(objType=='17'||objType=='141'||objType=='142'||objType=='166')){
        $("#"+divName).show();
        objChkIfSplitField.value='1'
        objChkIfSplitField.checked=false        
    }else{
    	$("#"+divName).hide();
        objChkIfSplitField.value='1'
        objChkIfSplitField.checked=false    
    }

}

function onCancelWorkflowSubwfSetDetail(obj)
{
	window.location = "/workflow/workflow/WorkflowSubwfSet.jsp?ajax=1&wfid=<%=mainWorkflowId%>";
}

function onSaveWorkflowSubwfSetDetail1(obj)
{
	obj.disabled=true;
    formWorkflowSubwfSetDetail.submit();	
}


function changeCreatorField(){
	jQuery('#subwfCreatorType_3').attr('checked', 'checked');
	var radios = jQuery('#subwfCreatorType_3').parent()
		.parent().parent().parent().find('.jNiceRadio');

	jQuery(radios).each(function(i, v){
		jQuery(v).attr('class', 'jNiceRadio');
	});
	
	jQuery('#subwfCreatorType_3').parent()
		.find('.jNiceRadio').attr('class', 'jNiceRadio jNiceChecked');

	toggleSubWfCreatorType();
}

function toggleSubWfCreatorType(){
	var subwfCreatorFieldIdVal = jQuery('[name=subwfCreatorFieldId]').val();
	var subWfCreatorFieldId = "";
	var subWfCreatorFieldType = "";
	
	if(subwfCreatorFieldIdVal != null){
		subWfCreatorFieldId = jQuery('[name=subwfCreatorFieldId]').val().split('_')[2];
		subWfCreatorFieldType = jQuery('[name=subwfCreatorFieldId]').val().split('_')[1];
	}

	var type = '';
	for(var i = 1; i < 4; i++){
		var checkbox = jQuery('#subwfCreatorType_' + i);
		if( jQuery(checkbox).attr('checked') ){
			type = jQuery(checkbox).val();
		}
	}

	if(type == '1' || type == '2'
		|| (
			type == '3'
			&& (
				subWfCreatorFieldType == '1'
				|| subWfCreatorFieldType == '165'
			)
		)
	){
		jQuery('div[id^=ifSplitFieldDiv_]').each(function(i ,v){
			jQuery(v).hide();
			jQuery(v).find('input[type=checkbox]').removeAttr('checked');
			jQuery(v).find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
		});

		jQuery('div[id^=isCreateForAnyoneDiv_]').each(function(i ,v){
			var value = jQuery('#mainWorkflowFieldId_' + i).val();
			var array = value.split('_');
			if(array.length == 3 
				&& (array[0] == 3 
					&& (
						array[1]== "17" //多人力资源
						|| array[1] =="166"  //分权多人力资源
						|| array[1] =="141"  //人力资源条件
						|| array[1] == "142"	//收发文单位
						|| array[1] =="160"	//角色人员 
					)
				)
			){
				jQuery(v).show();
			}
		});
	}else{
		jQuery('div[id^=ifSplitFieldDiv_]').each(function(i ,v){
			var value = jQuery('#mainWorkflowFieldId_' + i).val();
			var array = value.split('_');
			if(array.length == 3 
				&& (array[0] == 3 
					&& (
						array[1]== "17" //多人力资源
						|| array[1] =="166"  //分权多人力资源
						|| array[1] =="141"  //人力资源条件
						|| array[1] == "142"	//收发文单位
						|| array[1] =="160"	//角色人员 
					)
				)
			){
				if( array[2] == subWfCreatorFieldId){
					jQuery(v).show();
					jQuery(v).find('input[type=checkbox]').removeAttr('checked');
					jQuery(v).find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
				}else{
					jQuery(v).hide();
					jQuery(v).find('input[type=checkbox]').removeAttr('checked');
					jQuery(v).find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
				}
			}
		});
		
		jQuery('div[id^=isCreateForAnyoneDiv_]').each(function(i ,v){
			jQuery(v).hide();
			jQuery(v).find('input[type=checkbox]').removeAttr('checked');
			jQuery(v).find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
		});
	}
}

function mainFieldChange(me){
	
	var subwfCreatorFieldIdVal = jQuery('[name=subwfCreatorFieldId]').val();
	var subWfCreatorFieldId = "";
	var subWfCreatorFieldType = "";
	if(subwfCreatorFieldIdVal != null){
		subWfCreatorFieldId = jQuery('[name=subwfCreatorFieldId]').val().split('_')[2];
		subWfCreatorFieldType = jQuery('[name=subwfCreatorFieldId]').val().split('_')[1];
	}

	var type = '';
	for(var i = 1; i < 4; i++){
		var checkbox = jQuery('#subwfCreatorType_' + i);
		if( jQuery(checkbox).attr('checked') ){
			type = jQuery(checkbox).val();
		}
	}

	var tr = jQuery(me).parent().parent();
	var value = jQuery(me).val();
	//当选中‘---明细表n---’时，自动切换到不选中任何选项的状态
	if(value == '__'){
		$(me).find("option[text='']").attr("selected",true);
		$(me).next().find('.sbSelector').attr('title','');
		$(me).next().find('.sbSelector').text('');
		
		//return;
	}
	
	var array = value.split('_');

	if(array.length == 3 //人力资源大类
		&& (array[0] == 3
			&& (
				array[1]== "17" //多人力资源
				|| array[1] =="166"  //分权多人力资源
				|| array[1] =="141"  //人力资源条件
				|| array[1] == "142"	//收发文单位
				|| array[1] =="160"	//角色人员 
			)	
		)
	){
		if(type == '1' || type == '2'
			|| (
				type == '3'
				&& (
					subWfCreatorFieldType == '1'
					|| subWfCreatorFieldType == '165'
				)
			)
		){
			jQuery(tr).find('div[id^=isCreateForAnyoneDiv_]').show();
			jQuery(tr).find('div[id^=isCreateForAnyoneDiv_]').find('input[type=checkbox]').removeAttr('checked');
			jQuery(tr).find('div[id^=isCreateForAnyoneDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
		}else{
			if( array[2] == subWfCreatorFieldId ){
				jQuery(tr).find('div[id^=ifSplitFieldDiv_]').show();
				jQuery(tr).find('div[id^=ifSplitFieldDiv_]').find('input[type=checkbox]').removeAttr('checked');
				jQuery(tr).find('div[id^=ifSplitFieldDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
			}else{
				jQuery(tr).find('div[id^=ifSplitFieldDiv_]').hide();
				jQuery(tr).find('div[id^=ifSplitFieldDiv_]').find('input[type=checkbox]').removeAttr('checked');
				jQuery(tr).find('div[id^=ifSplitFieldDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
			}
		}
	}else{
		jQuery(tr).find('div[id^=isCreateForAnyoneDiv_]').hide();
		jQuery(tr).find('div[id^=isCreateForAnyoneDiv_]').find('input[type=checkbox]').removeAttr('checked');
		jQuery(tr).find('div[id^=isCreateForAnyoneDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');

		jQuery(tr).find('div[id^=ifSplitFieldDiv_]').hide();
		jQuery(tr).find('div[id^=ifSplitFieldDiv_]').find('input[type=checkbox]').removeAttr('checked');
		jQuery(tr).find('div[id^=ifSplitFieldDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}

	//控制重新生成文档选项是否显示
	if(array.length == 3 
		&& (
			array[0] == 3
			&& (array[1]== "9" //文档
				|| array[1] =="37"  //多文档
			)
		)	
	){
		jQuery(tr).find('div[id^=isCreateDocAgainDiv_]').show();
		jQuery(tr).find('div[id^=isCreateDocAgainDiv_]').find('input[type=checkbox]').removeAttr('checked');
		jQuery(tr).find('div[id^=isCreateDocAgainDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}else{
		jQuery(tr).find('div[id^=isCreateDocAgainDiv_]').hide();
		jQuery(tr).find('div[id^=isCreateDocAgainDiv_]').find('input[type=checkbox]').removeAttr('checked');
		jQuery(tr).find('div[id^=isCreateDocAgainDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}

	//控制重新生成附件选项是否显示
	if(array.length == 3 
		&& (
			array[0]== "6" //文档
			&& (
				array[1] == "1"
				|| array[1] == '2'
			)
		)
	){
		jQuery(tr).find('div[id^=isCreateAttachmentAgainDiv_]').show();
		jQuery(tr).find('div[id^=isCreateAttachmentAgainDiv_]').find('input[type=checkbox]').removeAttr('checked');
		jQuery(tr).find('div[id^=isCreateAttachmentAgainDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}else{
		jQuery(tr).find('div[id^=isCreateAttachmentAgainDiv_]').hide();
		jQuery(tr).find('div[id^=isCreateAttachmentAgainDiv_]').find('input[type=checkbox]').removeAttr('checked');
		jQuery(tr).find('div[id^=isCreateAttachmentAgainDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}
}


function createForAnyoneChange(me){
	if( jQuery(me).attr('checked') ){
		jQuery('input[type=checkbox][name^=isCreateForAnyone_]').each( function(i, v){

			if( jQuery(v).attr('id') != jQuery(me).attr('id') ){
				jQuery(v).removeAttr('checked');
				jQuery(v).parent().find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
			}
		});
	}
}
</script>
</html>


