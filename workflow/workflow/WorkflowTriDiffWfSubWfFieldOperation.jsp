
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
 <%@page import="weaver.workflow.workflow.WfRightManager"%>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<%
int mainWorkflowId = Util.getIntValue(request.getParameter("mainWorkflowId"),0);
boolean haspermission = wfrm.hasPermission3(mainWorkflowId, 0, user, WfRightManager.OPERATION_CREATEDIR);
 if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 

int triDiffWfDiffFieldId = Util.getIntValue(request.getParameter("triDiffWfDiffFieldId"),0);
int triDiffWfSubWfId = Util.getIntValue(request.getParameter("triDiffWfSubWfId"),0);
int fieldValue = Util.getIntValue(request.getParameter("fieldValue"),-1);
int subWorkflowId = Util.getIntValue(request.getParameter("subWorkflowId"),0);
int isRead = Util.getIntValue(request.getParameter("isRead"),0);
String subwfCreatorType = Util.null2String(request.getParameter("subwfCreatorType"));
String subwfCreatorFieldId = Util.null2String(request.getParameter("subwfCreatorFieldId"));
subwfCreatorFieldId = subwfCreatorFieldId.substring(subwfCreatorFieldId.lastIndexOf("_")+1);

/*当子流程创建人类型不为多人力资源字段时，置空人力资源字段*/
if( !subwfCreatorType.equals("3") ){
	subwfCreatorFieldId = "";
}

String operation = Util.null2String(request.getParameter("operation"));
String dialog = Util.null2String(request.getParameter("dialog"));

if(operation.equals("addTriDiffWfSubWfField")){
	String isStopCreaterNode = Util.null2String(request.getParameter("isStopCreaterNode"));
	if(!isStopCreaterNode.equals("1")){
		isStopCreaterNode = "0";
	}
	
	String isCreateForAnyone = Util.null2String(request.getParameter("isCreateForAnyone"));
	if(!isCreateForAnyone.equals("1")){
		isCreateForAnyone = "0";
	}
	//更新触发不同流程子流程设置表信息
	if(triDiffWfSubWfId>0){
		RecordSet.executeSql("update Workflow_TriDiffWfSubWf set triDiffWfDiffFieldId="+triDiffWfDiffFieldId+",subworkflowId="+subWorkflowId+",subWfCreatorType='"+subwfCreatorType+"',subWfCreatorFieldId='"+subwfCreatorFieldId+"',isRead="+isRead+",fieldValue="+fieldValue+",isStopCreaterNode='"+isStopCreaterNode+"',ifSplitField='"+isCreateForAnyone+"'  where id="+triDiffWfSubWfId);
	}else{
		RecordSet.executeSql("insert into  Workflow_TriDiffWfSubWf(triDiffWfDiffFieldId,subworkflowId,subWfCreatorType,subWfCreatorFieldId,isRead,fieldValue,isStopCreaterNode,ifSplitField) values("+triDiffWfDiffFieldId+","+subWorkflowId+","+subwfCreatorType+","+subwfCreatorFieldId+","+isRead+","+fieldValue+",'"+isStopCreaterNode+"','"+isCreateForAnyone+"')");
		RecordSet.executeSql("select max(id)  from Workflow_TriDiffWfSubWf");
		if(RecordSet.next()){
			triDiffWfSubWfId = Util.getIntValue(RecordSet.getString(1),0);
		}
	}

	/*主表和明细表共用一个循环变量，因为request中相关变量的key的索引并没有区分主表和明细表*/
	int globalIndex = 0;
	/*主表字段设置*/
    String[] triDiffWfSubWfFieldIds = request.getParameterValues("triDiffWfSubWfFieldId"); 
    String[] subWorkflowFieldIds = request.getParameterValues("subWorkflowFieldId"); 
    String[] mainWorkflowFieldIds = request.getParameterValues("mainWorkflowFieldId");
	if(subWorkflowFieldIds != null){
		for(int i=0;i<subWorkflowFieldIds.length;i++,globalIndex++){

            int triDiffWfSubWfFieldId = Util.getIntValue(triDiffWfSubWfFieldIds[i],0);
			int subWorkflowFieldId = Util.getIntValue(subWorkflowFieldIds[i],0);
			String mainWorkflowFieldId = mainWorkflowFieldIds[i];
            mainWorkflowFieldId = mainWorkflowFieldId.substring(mainWorkflowFieldId.lastIndexOf("_")+1);

			String isCreateDocAgain = Util.null2String(request.getParameter("isCreateDocAgain_"+globalIndex));
			if(isCreateDocAgain.equals("")){
				isCreateDocAgain = "0";
			}
			
			String isCreateAttachmentAgain = Util.null2String(request.getParameter("isCreateAttachmentAgain_"+globalIndex));
			if(isCreateAttachmentAgain.equals("")){
				isCreateAttachmentAgain = "0";
			}

			String ifSplitField=Util.null2String(request.getParameter("ifSplitField_"+globalIndex));
			if(ifSplitField.equals("")){
				ifSplitField = "0";
			}

			if(mainWorkflowFieldId.equals("")){//如果主流程字段未选
			    if(triDiffWfSubWfFieldId > 0){//子流程设置明细id不为空，则需要删除已有记录
                    RecordSet.executeSql("delete from Workflow_TriDiffWfSubWfField where id="+triDiffWfSubWfFieldId);
				}
			}else{//否则，主流程字段已选
			    if(triDiffWfSubWfFieldId > 0){//子流程设置明细id不为空，则需要修改已有记录
                    RecordSet.executeSql("update Workflow_TriDiffWfSubWfField set mainWorkflowFieldId="+mainWorkflowFieldId+",isCreateDocAgain='"+isCreateDocAgain+"',isCreateAttachmentAgain='"+isCreateAttachmentAgain+"',ifSplitField='"+ifSplitField+"',isdetail=0  where id="+triDiffWfSubWfFieldId);
				}else{//不然得新增记录
                    RecordSet.executeSql("insert into Workflow_TriDiffWfSubWfField(triDiffWfSubWfId,subWorkflowFieldId,mainWorkflowFieldId,isCreateDocAgain,isCreateAttachmentAgain,ifSplitField,isdetail)  values("+triDiffWfSubWfId+","+subWorkflowFieldId+","+mainWorkflowFieldId+",'"+isCreateDocAgain+"','"+isCreateAttachmentAgain+"','"+ifSplitField+"',0)");
				}
			}
		}
	}
	
	/*明细表字段设置*/
    String[] triDiffWfDltSubWfFieldIds = request.getParameterValues("triDiffWfDltSubWfFieldId");
    String[] subWorkflowDltFieldIds = request.getParameterValues("subWorkflowDltFieldId");
    String[] mainWorkflowDltFieldIds = request.getParameterValues("mainWorkflowDltFieldId");
    if(subWorkflowDltFieldIds != null){
		for(int i = 0;i < subWorkflowDltFieldIds.length; i++,globalIndex++){
            int triDiffWfDltSubWfFieldId = Util.getIntValue(triDiffWfDltSubWfFieldIds[i],0);
			int subWorkflowDltFieldId = Util.getIntValue(subWorkflowDltFieldIds[i],0);
			String mainWorkflowDltFieldId = mainWorkflowDltFieldIds[i];
            mainWorkflowDltFieldId = mainWorkflowDltFieldId.substring(mainWorkflowDltFieldId.lastIndexOf("_") + 1);

			String dltIsCreateDocAgain=Util.null2String(request.getParameter("isCreateDocAgain_"+globalIndex));
			if(dltIsCreateDocAgain.equals("")){
				dltIsCreateDocAgain = "0";
			}
			
			String isCreateAttachmentAgain = Util.null2String(request.getParameter("isCreateAttachmentAgain_"+globalIndex));
			if(isCreateAttachmentAgain.equals("")){
				isCreateAttachmentAgain = "0";
			}
			
			String ifSplitField = Util.null2String(request.getParameter("ifSplitField_"+globalIndex));
			if(ifSplitField.equals("")){
				ifSplitField = "0";
			}

			if(mainWorkflowDltFieldId.equals("")){//如果主流程字段未选
			    if(triDiffWfDltSubWfFieldId > 0){//子流程设置明细id不为空，则需要删除已有记录
                    RecordSet.executeSql("delete from Workflow_TriDiffWfSubWfField where id="+triDiffWfDltSubWfFieldId);
				}
			}else{//否则，主流程字段已选
			    if(triDiffWfDltSubWfFieldId > 0){//子流程设置明细id不为空，则需要修改已有记录
                    RecordSet.executeSql("update Workflow_TriDiffWfSubWfField set mainWorkflowFieldId="+mainWorkflowDltFieldId+",isCreateDocAgain='"+dltIsCreateDocAgain+"',isCreateAttachmentAgain='"+isCreateAttachmentAgain+"',ifSplitField='"+ifSplitField+"', isdetail=1  where id="+triDiffWfDltSubWfFieldId);
				}else{//不然得新增记录
                    RecordSet.executeSql("insert into Workflow_TriDiffWfSubWfField(triDiffWfSubWfId,subWorkflowFieldId,mainWorkflowFieldId,isCreateDocAgain,isCreateAttachmentAgain,ifSplitField,isdetail)  values("+triDiffWfSubWfId+","+subWorkflowDltFieldId+","+mainWorkflowDltFieldId+",'"+dltIsCreateDocAgain+"','"+isCreateAttachmentAgain+"',"+ifSplitField+",1)");
				}
			}
		}
	}

	if(dialog.equals("1")){
		response.sendRedirect("/workflow/workflow/WorkflowTriDiffWfSubWfField.jsp?isclose=1&dialog=1&ajax=1&triDiffWfDiffFieldId="+triDiffWfDiffFieldId+"&triDiffWfSubWfId="+triDiffWfSubWfId+"&fieldValue="+fieldValue+"&subWorkflowId="+subWorkflowId+"&isRead="+isRead+"&mainWorkflowId="+Util.null2String(request.getParameter("mainWorkflowId")));
	}else{
    	response.sendRedirect("WorkflowTriDiffWfSubWf.jsp?triDiffWfDiffFieldId="+triDiffWfDiffFieldId+"&triDiffWfSubWfId="+triDiffWfSubWfId+"&fieldValue="+fieldValue+"&subWorkflowId="+subWorkflowId+"&isRead="+isRead+"&mainWorkflowId="+Util.null2String(request.getParameter("mainWorkflowId")));
    } 
	return;
}


%>
