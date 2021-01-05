
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.workflow.WorkflowSubwfSetUtil" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowSubwfSetUtil" class="weaver.workflow.workflow.WorkflowSubwfSetUtil" scope="page"/>
<%
String mainWorkflowId = Util.null2String(request.getParameter("mainWorkflowId"));
String operation = Util.null2String(request.getParameter("operation"));

String subWorkflowId = Util.null2String(request.getParameter("subWorkflowId"));
String workflowSubwfSetId = Util.null2String(request.getParameter("workflowSubwfSetId"));

String triggerCondition = Util.null2String(request.getParameter("triggerCondition"));
String subwfCreatorType = Util.null2String(request.getParameter("subwfCreatorType"));
String subwfCreatorFieldId = Util.null2String(request.getParameter("subwfCreatorFieldId"));
subwfCreatorFieldId = subwfCreatorFieldId.substring(subwfCreatorFieldId.lastIndexOf("_")+1);

if(!subwfCreatorType.equals("3")){
	subwfCreatorFieldId="0";
}

if(operation.equals("addSubwfSetDetail")){  
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(Util.getIntValue(mainWorkflowId, 0), 0, user, WfRightManager.OPERATION_CREATEDIR);
 	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
   		response.sendRedirect("/notice/noright.jsp");
   		return;
	}
	String isStopCreaterNode = Util.null2String(request.getParameter("isStopCreaterNode"));
	if(!isStopCreaterNode.equals("1")){
		isStopCreaterNode = "0";
	}
	//更新触发条件
    String conditionss = Util.null2String(request.getParameter("conditionss"));
    String conditionsscn = Util.null2String(request.getParameter("conditioncn"));
    
    //更新子流程配置表信息
//    RecordSet.executeSql("update Workflow_SubwfSet set subwfCreatorType='"+subwfCreatorType+"',subwfCreatorFieldId="+subwfCreatorFieldId+",isStopCreaterNode='"+isStopCreaterNode+"',triggerCondition='"+triggerCondition+"' where id="+workflowSubwfSetId);
    RecordSet.executeUpdate("update Workflow_SubwfSet set condition=?, conditioncn=?, subwfCreatorType='"+subwfCreatorType+"',subwfCreatorFieldId="+subwfCreatorFieldId+",isStopCreaterNode='"+isStopCreaterNode+"',triggerCondition='"+triggerCondition+"' where id="+workflowSubwfSetId, conditionss, conditionsscn);
	String existsSubwfSetDetailIds="";
	String noDeleteSubwfSetDetailIds="";
    RecordSet.executeSql("select id from Workflow_SubwfSetDetail where subwfSetId="+workflowSubwfSetId);
	while(RecordSet.next()){
		existsSubwfSetDetailIds+=","+Util.getIntValue(RecordSet.getString("id"),0);
	}
	
	int globalI = 0;

    //更新子流程配置明细表信息
    String[] subwfSetDetailIds = request.getParameterValues("subwfSetDetailId"); 
    String[] subWorkflowFieldIds = request.getParameterValues("subWorkflowFieldId"); 
    String[] mainWorkflowFieldIds = request.getParameterValues("mainWorkflowFieldId");

	if(subWorkflowFieldIds != null){
		for(int i = 0; i < subWorkflowFieldIds.length; i++,globalI++){
            String subwfSetDetailId = subwfSetDetailIds[i];
			String subWorkflowFieldId = subWorkflowFieldIds[i];
			String mainWorkflowFieldId = mainWorkflowFieldIds[i];
            mainWorkflowFieldId = mainWorkflowFieldId.substring(mainWorkflowFieldId.lastIndexOf("_")+1);

			String ifSplitField = Util.null2String(request.getParameter("ifSplitField_"+globalI));
			if(ifSplitField.equals("")){
				ifSplitField = "0";
			}

			String isCreateForAnyone = Util.null2String(request.getParameter("isCreateForAnyone_"+globalI));
			if(isCreateForAnyone.equals("")){
				isCreateForAnyone = "0";
			}

			String isCreateDocAgain = Util.null2String(request.getParameter("isCreateDocAgain_"+globalI));
			if(isCreateDocAgain.equals("")){
				isCreateDocAgain = "0";
			}

			String isCreateAttachmentAgain = Util.null2String(request.getParameter("isCreateAttachmentAgain_"+globalI));
			if(isCreateAttachmentAgain.equals("")){
				isCreateAttachmentAgain = "0";
			}

			if(mainWorkflowFieldId.equals("")){//如果主流程字段未选

			    if(!subwfSetDetailId.equals("")){//子流程设置明细id不为空，则需要删除已有记录

                    RecordSet.executeSql("delete from Workflow_SubwfSetDetail where id="+subwfSetDetailId);
				}
			}else{//否则，主流程字段已选

			    if(!subwfSetDetailId.equals("")){//子流程设置明细id不为空，则需要修改已有记录

                    RecordSet.executeSql("update Workflow_SubwfSetDetail set mainWorkflowFieldId="+mainWorkflowFieldId+",ifSplitField='"+ifSplitField+"',isCreateForAnyone='"+isCreateForAnyone+"',isCreateDocAgain='"+isCreateDocAgain+"', isCreateAttachmentAgain='"+isCreateAttachmentAgain+"',isdetail=0  where id="+subwfSetDetailId);
					noDeleteSubwfSetDetailIds+=","+subwfSetDetailId;
				}else{//不然得新增记录

                    RecordSet.executeSql("insert into Workflow_SubwfSetDetail(subwfSetId,subWorkflowFieldId,mainWorkflowFieldId,ifSplitField,isCreateForAnyone,isCreateDocAgain,isCreateAttachmentAgain,isdetail)  values("+workflowSubwfSetId+","+subWorkflowFieldId+","+mainWorkflowFieldId+",'"+ifSplitField+"','"+isCreateForAnyone+"','"+isCreateDocAgain+"','"+isCreateAttachmentAgain+"',0)");
				}
			}
		}
	}

	String[] subwfDltSetDetailIds = request.getParameterValues("subwfDltSetDetailId");
    String[] subWorkflowDltFieldIds = request.getParameterValues("subWorkflowDltFieldId");
    String[] dltWorkflowFieldIds = request.getParameterValues("dltWorkflowFieldId");
    if( subWorkflowDltFieldIds != null ){
		for(int i = 0; i < subWorkflowDltFieldIds.length; i++, globalI++){
            String subwfDltSetDetailId = subwfDltSetDetailIds[i];
			String subWorkflowDltFieldId = subWorkflowDltFieldIds[i];
			String dltWorkflowFieldId = dltWorkflowFieldIds[i];
            dltWorkflowFieldId = dltWorkflowFieldId.substring(dltWorkflowFieldId.lastIndexOf("_")+1);
            
            String ifSplitField = Util.null2String(request.getParameter("ifSplitField_"+globalI));
			if(ifSplitField.equals("")){
				ifSplitField = "0";
			}

			String isCreateForAnyone = Util.null2String(request.getParameter("isCreateForAnyone_"+globalI));
			if(isCreateForAnyone.equals("")){
				isCreateForAnyone = "0";
			}

			String isCreateDocAgain = Util.null2String(request.getParameter("isCreateDocAgain_"+globalI));
			if(isCreateDocAgain.equals("")){
				isCreateDocAgain = "0";
			}

			String isCreateAttachmentAgain = Util.null2String(request.getParameter("isCreateAttachmentAgain_"+globalI));
			if(isCreateAttachmentAgain.equals("")){
				isCreateAttachmentAgain = "0";
			}

			if(dltWorkflowFieldId.equals("")){//如果主流程字段未选

			    if(!subwfDltSetDetailId.equals("")){//子流程设置明细id不为空，则需要删除已有记录

                    RecordSet.executeSql("delete from Workflow_SubwfSetDetail where id="+subwfDltSetDetailId);
				}
			}else{//否则，主流程字段已选

			    if(!subwfDltSetDetailId.equals("")){//子流程设置明细id不为空，则需要修改已有记录

                    RecordSet.executeSql("update Workflow_SubwfSetDetail set mainWorkflowFieldId="+dltWorkflowFieldId+",ifSplitField='"+ifSplitField+"',isCreateForAnyone='"+isCreateForAnyone+"',isCreateDocAgain='"+isCreateDocAgain+"', isCreateAttachmentAgain='"+isCreateAttachmentAgain+"',isdetail=1  where id="+subwfDltSetDetailId);
					noDeleteSubwfSetDetailIds+=","+subwfDltSetDetailId;
				}else{//不然得新增记录

                    RecordSet.executeSql("insert into Workflow_SubwfSetDetail(subwfSetId,subWorkflowFieldId,mainWorkflowFieldId,ifSplitField,isCreateForAnyone,isCreateDocAgain,isCreateAttachmentAgain,isdetail)  values("+workflowSubwfSetId+","+subWorkflowDltFieldId+","+dltWorkflowFieldId+",'"+ifSplitField+"','"+isCreateForAnyone+"','"+isCreateDocAgain+"','"+isCreateAttachmentAgain+"',1)");
				}
			}
		}
	}
    
	//删除垃圾数据
	if(!existsSubwfSetDetailIds.equals("")){
		existsSubwfSetDetailIds=existsSubwfSetDetailIds.substring(1);
	}

	if(!noDeleteSubwfSetDetailIds.equals("")){
		noDeleteSubwfSetDetailIds=noDeleteSubwfSetDetailIds.substring(1);
	}

	if((!existsSubwfSetDetailIds.equals(""))&&(!noDeleteSubwfSetDetailIds.equals(""))){
		RecordSet.executeSql("delete from Workflow_SubwfSetDetail where subwfSetId="+workflowSubwfSetId+" and id in("+existsSubwfSetDetailIds+") and id not in("+noDeleteSubwfSetDetailIds+")");
	}
	String dialog = Util.null2String(request.getParameter("dialog"));
	if("1".equals(dialog)){
		response.sendRedirect("WorkflowSubwfSetDetail.jsp?isclose=1&dialog=1&ajax=1&mainWorkflowId="+mainWorkflowId+"&subWorkflowId="+subWorkflowId+"&workflowSubwfSetId="+workflowSubwfSetId);
	}else{
    	response.sendRedirect("WorkflowSubwfSet.jsp?ajax=1&wfid="+mainWorkflowId);
    } 
	return;
}else if(operation.equals("subwfSetAdd")){
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(Util.getIntValue(mainWorkflowId, 0), 0, user, WfRightManager.OPERATION_CREATEDIR);
 	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
   		response.sendRedirect("/notice/noright.jsp");
   		return;
	}
	String isTriDiff = Util.null2String(request.getParameter("isTriDiff"));
	String dialog = Util.null2String(request.getParameter("dialog"));
	if(!"1".equals(isTriDiff)){
		String triggerType = Util.null2String(request.getParameter("triggerType"));
		String triggerNodeId = Util.null2String(request.getParameter("triggerNodeId"));
		String triggerTime = Util.null2String(request.getParameter("triggerTime"));
		String triggerOperation = Util.null2String(request.getParameter("triggerOperationHidden"));
		String type_id_order = Util.null2String(request.getParameter("triggerSource"));
		String[] typeAndIdAndOrder = type_id_order.split("_");
		String triggerSourceType = typeAndIdAndOrder[0];
		String triggerSource = typeAndIdAndOrder[1];
		String triggerSourceOrder = typeAndIdAndOrder[2];
		String isread = Util.null2String(request.getParameter("isread"));
		if(!isread.equals("1")){
			isread = "0";
		}
		String isreadNodes = Util.null2String(request.getParameter("isreadNodes"));
		if(isread.equals("0")){
			isreadNodes = "";
		}else{
			if(isreadNodes.trim().equals("")){
				isreadNodes = "all";
			}
		}
		
		String isreadMainwf = Util.null2String(request.getParameter("isreadMainwf"));
		if(!isreadMainwf.equals("1")){
			isreadMainwf = "0";
		}
		String isreadMainWfNodes = Util.null2String(request.getParameter("isreadMainWfNodes"));
		if(isreadMainwf.equals("0")){
			isreadMainWfNodes = "";
		}else{
			if(isreadMainWfNodes.trim().equals("")){
				isreadMainWfNodes = "all";
			}
		}
		
		String isreadParallelwf = Util.null2String(request.getParameter("isreadParallelwf"));
		if(!isreadParallelwf.equals("1")){
			isreadParallelwf = "0";
		}
		String isreadParallelwfNodes = Util.null2String(request.getParameter("isreadParallelwfNodes"));
		if(isreadParallelwf.equals("0")){
			isreadParallelwfNodes = "";
		}else{
			if(isreadParallelwfNodes.trim().equals("")){
				isreadParallelwfNodes = "all";
			}
		}
		
		triggerNodeId = triggerNodeId.substring(triggerNodeId.lastIndexOf("_")+1);
		WorkflowSubwfSetUtil.addWorkflowSubwfSet(
			Util.getIntValue(mainWorkflowId, 0), 
			Util.getIntValue(subWorkflowId, 0), 
			Util.getIntValue(triggerNodeId, 0), 
			triggerType, 
			triggerTime, 
			triggerOperation,
			isread,
			isreadMainwf,
			isreadParallelwf,
			isreadNodes,
			isreadMainWfNodes,
			isreadParallelwfNodes,
			triggerSourceType,
			triggerSource,
			triggerSourceOrder);
	}else{
		String triggerTypeDiff = Util.null2String(request.getParameter("triggerTypeDiff"));
		String triggerNodeIdDiff = Util.null2String(request.getParameter("triggerNodeIdDiff"));
		String triggerTimeDiff = Util.null2String(request.getParameter("triggerTimeDiff"));
		String triggerOperationHidden = Util.null2String(request.getParameter("triggerOperationHidden"));
		String type_id_order = Util.null2String(request.getParameter("triggerSource"));
		String fieldIdDiff = Util.null2String(request.getParameter("fieldIdDiff_" + type_id_order));
		
		//System.out.println("****fieldIdDiff:" + fieldIdDiff);
		
		String[] typeAndIdAndOrder = type_id_order.split("_");
		String triggerSourceType = typeAndIdAndOrder[0];
		String triggerSource = typeAndIdAndOrder[1];
		String triggerSourceOrder = typeAndIdAndOrder[2];
		
		triggerNodeIdDiff = triggerNodeIdDiff.substring(triggerNodeIdDiff.lastIndexOf("_")+1);
		WorkflowSubwfSetUtil.addWorkflowSubwfSetDiff(
			Util.getIntValue(mainWorkflowId, 0), 
			Util.getIntValue(triggerNodeIdDiff, 0), 
			triggerTypeDiff, 
			triggerTimeDiff, 
			triggerOperationHidden, 
			Util.getIntValue(fieldIdDiff, 0),
			triggerSourceType,
			triggerSource,
			triggerSourceOrder);
	}
	if("1".equals(dialog)){
			response.sendRedirect("WorkflowSubwfSetAdd.jsp?isclose=1&wfid="+mainWorkflowId);
	}else{
		response.sendRedirect("WorkflowSubwfSet.jsp?wfid="+mainWorkflowId);
	}	
}else if(operation.equals("enableSetting")){//启用子流程设置 触发相同子流程

	String settingId =  Util.null2String(request.getParameter("settingId"));
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(WorkflowSubwfSetUtil.getMainWorkflowIdBySettingId(settingId), 0, user, WfRightManager.OPERATION_CREATEDIR);
 	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
   		response.sendRedirect("/notice/noright.jsp");
   		return;
	}
	WorkflowSubwfSetUtil.enableDisableSetting(settingId, "1");
}else if(operation.equals("disableSetting")){//停用子流程设置 触发相同子流程

	String settingId =  Util.null2String(request.getParameter("settingId"));
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(WorkflowSubwfSetUtil.getMainWorkflowIdBySettingId(settingId), 0, user, WfRightManager.OPERATION_CREATEDIR);
 	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
   		response.sendRedirect("/notice/noright.jsp");
   		return;
	}
	WorkflowSubwfSetUtil.enableDisableSetting(settingId, "0");
}else if(operation.equals("enableSettingDiff")){//启用子流程设置 触发不同子流程

	String settingId =  Util.null2String(request.getParameter("settingId"));
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(WorkflowSubwfSetUtil.getMainWorkflowIdByDiffSettingId(settingId), 0, user, WfRightManager.OPERATION_CREATEDIR);
 	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
   		response.sendRedirect("/notice/noright.jsp");
   		return;
	}
	WorkflowSubwfSetUtil.enableDisableSettingDiff(settingId, "1");
}else if(operation.equals("disableSettingDiff")){//停用子流程设置 触发不同子流程

	String settingId =  Util.null2String(request.getParameter("settingId"));
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(WorkflowSubwfSetUtil.getMainWorkflowIdByDiffSettingId(settingId), 0, user, WfRightManager.OPERATION_CREATEDIR);
 	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
   		response.sendRedirect("/notice/noright.jsp");
   		return;
	}
	WorkflowSubwfSetUtil.enableDisableSettingDiff(settingId, "0");
}
%>