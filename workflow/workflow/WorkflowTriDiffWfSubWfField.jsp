<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.workflow.workflow.WorkflowSubwfSetUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.workflow.UserWFOperateLevel"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowTriDiffWfManager" class="weaver.workflow.workflow.WorkflowTriDiffWfManager" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />

<%
int mainWorkflowId = Util.getIntValue(request.getParameter("mainWorkflowId"),0);
boolean haspermission = wfrm.hasPermission3(mainWorkflowId, 0, user, WfRightManager.OPERATION_CREATEDIR);
 if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>

<%

int triDiffWfDiffFieldId = Util.getIntValue(request.getParameter("triDiffWfDiffFieldId"), 0);
int triDiffWfSubWfId = Util.getIntValue(request.getParameter("triDiffWfSubWfId"),0);
int fieldValue = Util.getIntValue(request.getParameter("fieldValue"),0);
int subWorkflowId = Util.getIntValue(request.getParameter("subWorkflowId"),0);
int isRead = Util.getIntValue(request.getParameter("isRead"),0);




String mainWorkflowFormId = WorkflowComInfo.getFormId(""+mainWorkflowId);
String mainWorkflowIsBill = WorkflowComInfo.getIsBill(""+mainWorkflowId);
//add by liaodong for qc61523 in 2013-11-12 start
  if("".equals(mainWorkflowFormId)|| "".equals(mainWorkflowIsBill)){
			RecordSet.executeSql("select formid,isbill from workflow_base where id=" + mainWorkflowId);
			  if(RecordSet.next()){
				  mainWorkflowFormId = RecordSet.getString("formid");
				  mainWorkflowIsBill = RecordSet.getString("isbill");
			  }
		}
//end


//获得子流程配置的相关信息
String subwfCreatorType="";
String subwfCreatorFieldId = "0";
String isStopCreaterNode = "";
String isCreateForAnyone = "0";
RecordSet.executeSql(" select subwfCreatorType,subwfCreatorFieldId,isStopCreaterNode,ifSplitField from Workflow_TriDiffWfSubWf where id="+triDiffWfSubWfId);
if(RecordSet.next()){
	subwfCreatorType = Util.null2String(RecordSet.getString("subwfCreatorType"));
	subwfCreatorFieldId =  Util.null2String(RecordSet.getString("subwfCreatorFieldId"));
	isStopCreaterNode = RecordSet.getString("isStopCreaterNode").equals("1") ? "checked" : "";
	isCreateForAnyone = RecordSet.getString("ifSplitField");
}

String triggerSourceType = "";	//触发来源类型
String triggerSourceOrder = "";	//触发来源排序号
String triggerSource = "";	//触发来源
String triggerSourceText = "";
String diffFieldId = "";	//可区分字段编号
RecordSet.executeSql("select fieldId,triggerSource,triggerSourceType,triggerSourceOrder from Workflow_TriDiffWfDiffField where id="+triDiffWfDiffFieldId);
if(RecordSet.next()){
	triggerSource = RecordSet.getString("triggerSource");
	triggerSourceType = RecordSet.getString("triggerSourceType");
	triggerSourceOrder = RecordSet.getString("triggerSourceOrder");
	if( triggerSourceType.equals("main") ){
		triggerSourceText = SystemEnv.getHtmlLabelName(21778, user.getLanguage());
	}else if( triggerSourceType.equals("detail") ){
		triggerSourceText = SystemEnv.getHtmlLabelName(19325, user.getLanguage()) + triggerSourceOrder;
	}
	
	diffFieldId = RecordSet.getString("fieldId");
}
//子流程创建人字段类型
Map<String,String> creatorFieldType = WorkflowSubwfSetUtil.getFieldType(mainWorkflowIsBill, subwfCreatorFieldId);
int gloatIndex = 0;
%>

<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(19343, user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(19357, user.getLanguage())+"）" + SystemEnv.getHtmlLabelName(19342,user.getLanguage());
    String needfav = "";
    String needhelp = "";
    String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
%>
<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
			//parentWin = parent.parent.getParentWindow(parent);
			//dialog = parent.parent.getDialog(parent);
			//dialog.close();
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>');
		}
    </script>
</HEAD>

<body style="overflow-y:hidden;">
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<%}%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveWorkflowTriDiffWfSubWfField(this),_self}";
    RCMenuHeight += RCMenuHeightStep ;
 	if(!"1".equals(dialog)){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancelWorkflowTriDiffWfSubWfField(this,"+triDiffWfDiffFieldId+"),_self}";
	    RCMenuHeight += RCMenuHeightStep;
    }
%>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSaveWorkflowTriDiffWfSubWfField(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id="formWorkflowTriDiffWfSubWfField" name="formWorkflowTriDiffWfSubWfField" method="post" action="WorkflowTriDiffWfSubWfFieldOperation.jsp">
	<input type="hidden" Name="mainWorkflowId" value="<%=mainWorkflowId%>">
	<input type="hidden" Name="triDiffWfDiffFieldId" value="<%=triDiffWfDiffFieldId%>">
	<input type="hidden" Name="triDiffWfSubWfId" value="<%=triDiffWfSubWfId%>">
	<input type="hidden" Name="fieldValue" value="<%=fieldValue%>">
	<input type="hidden" Name="subWorkflowId" value="<%=subWorkflowId%>">
	<input type="hidden" Name="isRead" value="<%=isRead%>">
	<input type="hidden" Name="operation" value="addTriDiffWfSubWfField">
	<input type="hidden" name="dialog" value="<%=dialog%>">
<wea:layout type="2col" attributes="{'cw1':'35%','cw2':'65%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(31826,user.getLanguage())%>'>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(33383,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<%=triggerSourceText %>
		</wea:item>
		<%--
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(33384,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input type='hidden' id='triggerCondition' name='triggerCondition' value='triggerCondition'/>
		</wea:item>
		--%>
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
			<input type=radio name=subwfCreatorType id=subwfCreatorType_1 onclick="toggleCreateForAnyoneDiv()" value="1" <%if("1".equals(subwfCreatorType)||"".equals(subwfCreatorType)){%>checked<%}%> >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19354,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=radio name=subwfCreatorType id=subwfCreatorType_2 onclick="toggleCreateForAnyoneDiv()" value="2" <% if("2".equals(subwfCreatorType)){%> checked <%}%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19355,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=radio name=subwfCreatorType id=subwfCreatorType_3 onclick="toggleCreateForAnyoneDiv()" value="3" <% if("3".equals(subwfCreatorType)){ %> checked <%}%> >
			&nbsp;&nbsp;&nbsp;&nbsp;
			<select class="inputstyle" id="subwfCreatorFieldId" name="subwfCreatorFieldId" onchange="changeSubwfCreatorField()" onfocus="changeSubwfCreatorType('subwfCreatorType_3')">
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
				String fieldId = "";
				while(RecordSet.next()){
					fieldId = RecordSet.getString("id");
					String value = RecordSet.getString("htmltype") + "_" + RecordSet.getString("type") + "_" + RecordSet.getString("id");
					
					String selected = "";
					if(fieldId.equals(subwfCreatorFieldId)){
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
						if(fieldId.equals(subwfCreatorFieldId)){
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
			<%
				String isShow_CreateForAnyoneDiv = "display:none;";
				String isChecked_isCreateForAnyone = "";
				/**************************************************** 
				* 当子流程创建人为：主流程人力资源相关字段，
				* 并且字段为:多人力资源、分权多人力资源、人力资源条件、收（发）文单位、角色人员
				*****************************************************/
				if( subwfCreatorType.equals("3")
					&& WorkflowSubwfSetUtil.isMultiHr(creatorFieldType.get("htmlType"), creatorFieldType.get("type"))
					&& !subwfCreatorFieldId.equals(diffFieldId)
				  ){
			  		isShow_CreateForAnyoneDiv = "display:inline;";
			  		if( isCreateForAnyone.equals("1") ){
						isChecked_isCreateForAnyone = "checked";
					}
				}
			%>
			<div id='isCreateForAnyoneDiv' style='<%=isShow_CreateForAnyoneDiv %>;padding-left:5px;'>
				<input type='checkbox' id='isCreateForAnyone' name='isCreateForAnyone' <%=isChecked_isCreateForAnyone%> tzCheckbox='true' value='1'/>
				<%=SystemEnv.getHtmlLabelName(19361,user.getLanguage())%>
			</div>			
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19356,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%>'>
					<wea:item attributes="{'isTableList':'true'}">
						<wea:layout needImportDefaultJsAndCss="false" type="table" attributes="{'cols':'3','cws':'33%%,33%,34%','formTableId':'oTableOfTriDiffWfSubWfField'}">
							<wea:group context="" attributes="{'groupDisplay':'none'}">
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19357,user.getLanguage())%></wea:item>
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19358,user.getLanguage())%></wea:item>
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></wea:item>
								<%
									//List maindetail = WorkflowTriDiffWfManager.getTriDiffWfFieldTRString(mainWorkflowId,subWorkflowId,triDiffWfSubWfId,user.getLanguage(),true);
									List<Map<String, String>> mainFields = WorkflowTriDiffWfManager.getMainWorkflowFields(mainWorkflowId, triDiffWfDiffFieldId, user.getLanguage());
									List<Map<String, String>> details = WorkflowTriDiffWfManager.getSubWfSetMainFieldDetails(mainWorkflowId,subWorkflowId,triDiffWfSubWfId,user.getLanguage());
									for(int i = 0; i < details.size();i++,gloatIndex++){
										Map<String, String> detail = details.get(i);
										//获取主流程字段类型 
									  	Map<String, String> mainFieldType = WorkflowSubwfSetUtil.getFieldType(mainWorkflowIsBill, detail.get("mainWorkflowFieldId"));
								%>
										<wea:item>
											<input type='hidden' name='triDiffWfSubWfFieldId' value='<%=detail.get("id")%>'>
											<input type='hidden' name='subWorkflowFieldId' value='<%=detail.get("subWorkflowFieldId")%>'>
											<%=detail.get("subWorkflowFieldName") %>
										</wea:item>
										<wea:item>
											<select name='mainWorkflowFieldId' id='mainWorkflowFieldId_<%=gloatIndex%>' onchange='mainFieldChange(this)'>
											<%
												for(int k = 0 ; k < mainFields.size(); k++){
													Map<String, String> field = mainFields.get(k);
													
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

											*****************************************************/
											String isShow_ifSplitFieldDiv = "display:none;";
										  	//当主流程字段等于可区分字段时
										  	//显示“字段值拆分”设置项
										  	if( diffFieldId.equals(detail.get("mainWorkflowFieldId")) ){
										  		isShow_ifSplitFieldDiv = "display:block;";
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
								<%	} %>
							</wea:group>
						</wea:layout>
					</wea:item>
				</wea:group>
				<%
					List<Map<String, String>> detailFields = WorkflowTriDiffWfManager.getMainWorkflowDetailFields(triggerSourceType, triggerSource, mainWorkflowId, user.getLanguage());
					List<List<Map<String, String>>> groupDetails = WorkflowTriDiffWfManager.getGroupedSubWfSetDetailFieldDetails(mainWorkflowId,subWorkflowId,triDiffWfSubWfId, user.getLanguage());
					for(int i = 0; i < groupDetails.size(); i++){
						List<Map<String, String>> group = groupDetails.get(i);
				%>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())+(i+1)%>'>
						<wea:item attributes="{'isTableList':'true'}">
							<wea:layout needImportDefaultJsAndCss="false" type="table" attributes="{'cols':'3','cws':'33%,33%,34%','formTableId':'oTableOfSubwfSetDetail'}">
							<wea:group context="" attributes="{'groupDisplay':'none'}">
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19357,user.getLanguage())%></wea:item>
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19358,user.getLanguage())%></wea:item>
								<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></wea:item>
								<%
									for(int j = 0; j < group.size(); j++, gloatIndex++){
										Map<String, String> detail = group.get(j);
										//获取主流程字段类型 
					  					Map<String, String> mainFieldType = WorkflowSubwfSetUtil.getFieldType(mainWorkflowIsBill, detail.get("mainWorkflowFieldId"), true);
								%>
									<wea:item>
										<input type='hidden' name='triDiffWfDltSubWfFieldId' value='<%=detail.get("id")%>'>
										<input type='hidden' name='subWorkflowDltFieldId' value='<%=detail.get("subWorkflowFieldId")%>'>
										<%=detail.get("subWorkflowFieldName") %>
									</wea:item>
									<wea:item>
										<select name='mainWorkflowDltFieldId' id='mainWorkflowFieldId_<%=gloatIndex%>' onchange='mainFieldChange(this)'>
										<%
											for(int k = 0; k < detailFields.size(); k++){
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
										*****************************************************/
										String isShow_ifSplitFieldDiv = "display:none;";
										//当主流程字段等于可区分字段时
									  	//显示“字段值拆分”设置项
									  	if( diffFieldId.equals(detail.get("mainWorkflowFieldId")) ){
									  		isShow_ifSplitFieldDiv = "display:block;";
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
</html>
<script type="text/javascript">
function onCancelWorkflowTriDiffWfSubWfField(obj,triDiffWfDiffFieldId){
	window.location="/workflow/workflow/WorkflowTriDiffWfSubWf.jsp?ajax=1&triDiffWfDiffFieldId="+triDiffWfDiffFieldId;
}
function onSaveWorkflowTriDiffWfSubWfField(obj){
	obj.disabled=true;
	formWorkflowTriDiffWfSubWfField.submit();
}
function changeSubwfCreatorType(subwfCreatorType){
	$GetEle(subwfCreatorType).checked = true;
}

function changeIsCreateDocAgain(obj,divNamePart,fieldIdSplited){

    var objId=$(obj).attr("id");
    var objValue=$(obj).val();

    var divName=divNamePart+objId.substr(objId.lastIndexOf("_")+1)
    var spanName="span"+divNamePart+objId.substr(objId.lastIndexOf("_")+1);

    var objHtmlType=objValue.substring(0,objValue.indexOf("_"));
    var objType=objValue.substring(objValue.indexOf("_")+1,objValue.lastIndexOf("_"));
    var objFieldId=objValue.substring(objValue.lastIndexOf("_")+1);

    var objChkIsCreateDocAgain=$(obj).parent().next().find("input")[0];
    
    if((objHtmlType=='3'&&(objType=='9'||objType=='37'))||objHtmlType=='6'){

		if(objHtmlType=='6'){
			$G(spanName).innerHTML="<%=SystemEnv.getHtmlLabelName(21719, user.getLanguage())%>";
		}else{
			$G(spanName).innerHTML="<%=SystemEnv.getHtmlLabelName(21718, user.getLanguage())%>";
		}
		$("#"+divName).show();
        objChkIsCreateDocAgain.value='1'
        objChkIsCreateDocAgain.checked=false        
    }else{
        $("#"+divName).hide();
        objChkIsCreateDocAgain.value='1'
        objChkIsCreateDocAgain.checked=false    
    }

	if(fieldIdSplited>0){
		var divIfSplitFieldName="divIfSplitField_"+objId.substr(objId.lastIndexOf("_")+1);
        var objChkIfSplitField=obj.parentNode.nextSibling.nextSibling.children(0).children(0);

		if(fieldIdSplited==objFieldId){
            $GetEle(divIfSplitFieldName).style.display=""
            objChkIfSplitField.value='1'
            objChkIfSplitField.checked=false
		}else{
            $GetEle(divIfSplitFieldName).style.display="none"
            objChkIfSplitField.value='1'
            objChkIfSplitField.checked=false 
		}
	}
}

function changeSubwfCreatorField(){
	jQuery('#subwfCreatorType_3').attr('checked', 'checked');
	var radios = jQuery('#subwfCreatorType_3').parent()
		.parent().parent().parent().find('.jNiceRadio');

	jQuery(radios).each(function(i, v){
		jQuery(v).attr('class', 'jNiceRadio');
	});
	
	jQuery('#subwfCreatorType_3').parent()
		.find('.jNiceRadio').attr('class', 'jNiceRadio jNiceChecked');
		
	toggleCreateForAnyoneDiv();
}

function toggleCreateForAnyoneDiv(){
	var diffFieldId = '<%=diffFieldId%>';	//可区分字段编号

	var tr = jQuery('#subwfCreatorFieldId').parent().parent();
	var value = jQuery('#subwfCreatorFieldId').val();
	var array = value.split('_');
	
	var type = '';
	for(var i = 1; i < 4; i++){
		var checkbox = jQuery('#subwfCreatorType_' + i);
		if( jQuery(checkbox).attr('checked') ){
			type = jQuery(checkbox).val();
		}
	}

	if(type == 3
		&& array.length == 3 //人力资源大类
		&& (array[0] == 3
			&& (
				array[1]== "17" //多人力资源
				|| array[1] =="166"  //分权多人力资源
				|| array[1] =="141"  //人力资源条件
				|| array[1] == "142"	//收发文单位
				|| array[1] =="160"	//角色人员 
			)	
		)
		&& array[2] != diffFieldId	//当主流程字段不等于可区分字段
	){
		jQuery(tr).find('div[id=isCreateForAnyoneDiv]').attr('style', 'display:inline;padding-left:5px;');
		jQuery(tr).find('div[id=isCreateForAnyoneDiv]').find('input[type=checkbox]').removeAttr('checked');
		jQuery(tr).find('div[id^=isCreateForAnyoneDiv]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}else{
		jQuery(tr).find('div[id=isCreateForAnyoneDiv]').attr('style', 'display:none;padding-left:5px;');
		jQuery(tr).find('div[id=isCreateForAnyoneDiv]').find('input[type=checkbox]').removeAttr('checked');
		jQuery(tr).find('div[id=isCreateForAnyoneDiv]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}
}

function mainFieldChange(me){
	var diffFieldId = '<%=diffFieldId%>';	//可区分字段编号

	var tr = jQuery(me).parent().parent();
	var value = jQuery(me).val();
	
	//当选中‘---明细表n---’时，自动切换到不选中任何选项的状态
	if(value == '__'){
		$(me).find("option[text='']").attr("selected",true);
		$(me).next().find('.sbSelector').attr('title','');
		$(me).next().find('.sbSelector').text('');
		
		return;
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
		&& array[2] == diffFieldId	//当主流程字段等于可区分字段
	){
		jQuery(tr).find('div[id^=ifSplitFieldDiv_]').fadeIn();
		jQuery(tr).find('div[id^=ifSplitFieldDiv_]').find('input[type=checkbox]').removeAttr('checked');
		jQuery(tr).find('div[id^=ifSplitFieldDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}else{

		jQuery(tr).find('div[id^=ifSplitFieldDiv_]').fadeOut();
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
		jQuery(tr).find('div[id^=isCreateDocAgainDiv_]').fadeIn();
		jQuery(tr).find('div[id^=isCreateDocAgainDiv_]').find('input[type=checkbox]').removeAttr('checked');
		jQuery(tr).find('div[id^=isCreateDocAgainDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}else{
		jQuery(tr).find('div[id^=isCreateDocAgainDiv_]').fadeOut();
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
		jQuery(tr).find('div[id^=isCreateAttachmentAgainDiv_]').fadeIn();
		jQuery(tr).find('div[id^=isCreateAttachmentAgainDiv_]').find('input[type=checkbox]').removeAttr('checked');
		jQuery(tr).find('div[id^=isCreateAttachmentAgainDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}else{
		jQuery(tr).find('div[id^=isCreateAttachmentAgainDiv_]').fadeOut();
		jQuery(tr).find('div[id^=isCreateAttachmentAgainDiv_]').find('input[type=checkbox]').removeAttr('checked');
		jQuery(tr).find('div[id^=isCreateAttachmentAgainDiv_]').find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}
}

</script>

