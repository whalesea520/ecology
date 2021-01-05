<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<% 
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%
	int triDiffWfDiffFieldId = Util.getIntValue(request.getParameter("triDiffWfDiffFieldId"),-1);
	
	String dialog = Util.null2String(request.getParameter("dialog"));
	
	//更新触发条件
	String triggerCondition = Util.null2String(request.getParameter("triggerCondition"));
	RecordSet.executeSql("update Workflow_TriDiffWfDiffField set triggerCondition='"+triggerCondition+"' where id=" + triDiffWfDiffFieldId);
	
	int triDiffWfSubWfIdDefault = Util.getIntValue(request.getParameter("triDiffWfSubWfIdDefault"),-1);
	int subWorkflowIdDefault = Util.getIntValue(request.getParameter("subWorkflowIdDefault"),-1);
	int isReadDefault = Util.getIntValue(request.getParameter("isReadDefault"),0);
	String isreadNodes = Util.null2String(request.getParameter("isreadNodes"));
	if(isReadDefault == 0){
		isreadNodes = "";
	}else{
		//if(isreadNodes.trim().equals("")){
		//	isreadNodes = "all";
		//}
	}
	int isreadMainwfDefault = Util.getIntValue(request.getParameter("isreadMainwf"),0);
	String isreadMainWfNodes = Util.null2String(request.getParameter("isreadMainWfNodes"));
	if(isreadMainwfDefault == 0){
		isreadMainWfNodes = "";
	}else{
		//if(isreadMainWfNodes.trim().equals("")){
		//	isreadMainWfNodes = "all";
		//}
	}
	int isreadParallelwfDefault = Util.getIntValue(request.getParameter("isreadParallelwf"),0);
	String isreadParallelwfNodes = Util.null2String(request.getParameter("isreadParallelwfNodes"));
	if(isreadParallelwfDefault == 0){
		isreadParallelwfNodes = "";
	}else{
		//if(isreadParallelwfNodes.trim().equals("")){
		//	isreadParallelwfNodes = "all";
		//}
	}
	
	//保存触发默认子流程设置
	int fieldValueDefault = -1;
    if(triDiffWfSubWfIdDefault > 0 && subWorkflowIdDefault > 0){
		//上次设置的默认子流程的编号
    	int oldSubWorkflowIdDefault = 0;
    	RecordSet.executeSql("select subWorkflowId from Workflow_TriDiffWfSubWf where id = " + triDiffWfSubWfIdDefault);
    	if(RecordSet.next()){
    		oldSubWorkflowIdDefault = Util.getIntValue(RecordSet.getString("subWorkflowId"), 0);
    	}
    	
    	RecordSet.executeSql("update Workflow_TriDiffWfSubWf set subWorkflowId="+subWorkflowIdDefault+",isRead="+isReadDefault+",isreadNodes='"+isreadNodes+"',isreadMainwf="+isreadMainwfDefault+",isreadMainWfNodes='"+isreadMainWfNodes+"',isreadParallelwf="+isreadParallelwfDefault+",isreadParallelwfNodes='"+isreadParallelwfNodes+"',fieldValue="+fieldValueDefault+" where id="+triDiffWfSubWfIdDefault);
    	//如果新默认子流程与老的默认子流程不相同，则删除字段详细设置
    	if(subWorkflowIdDefault != oldSubWorkflowIdDefault){
    		 RecordSet.executeSql("delete from Workflow_TriDiffWfSubWfField where triDiffWfSubWfId="+triDiffWfSubWfIdDefault);
    	}
	}else if(triDiffWfSubWfIdDefault <= 0 && subWorkflowIdDefault > 0){
	    RecordSet.executeSql("insert into Workflow_TriDiffWfSubWf(triDiffWfDiffFieldId,subWorkflowId,isRead,isreadMainwf,isreadParallelwf,isreadNodes,isreadMainWfNodes,isreadParallelwfNodes,fieldValue) values("+triDiffWfDiffFieldId+","+subWorkflowIdDefault+","+isReadDefault+","+isreadMainwfDefault+","+isreadParallelwfDefault+",'"+isreadNodes+"','"+isreadMainWfNodes+"','"+isreadParallelwfNodes+"',"+fieldValueDefault+")");
	}

	int rowNum = Util.getIntValue(request.getParameter("tableMax"), 0);
	/*由于前台的删除操作，并不是真正的后台的删除，所以需要在此处用排除法做删除操作*/
	String triDiffWfSubWfIds = "-9";
	for(int i = 0; i < rowNum; i++){
		int triDiffWfSubWfId = Util.getIntValue(request.getParameter("triDiffWfSubWfId_"+i),-1);
		if(triDiffWfSubWfIds.equals("")){
			triDiffWfSubWfIds = "" + triDiffWfSubWfId;
		}else{
			triDiffWfSubWfIds = triDiffWfSubWfIds + ","+triDiffWfSubWfId;
		}
	}
	
	if(rowNum > 0){
		RecordSet.executeSql("delete from Workflow_TriDiffWfSubWfField where triDiffWfSubWfId in"
		+" (select id from Workflow_TriDiffWfSubWf where id not in ("+triDiffWfSubWfIds+") and triDiffWfDiffFieldId = "+triDiffWfDiffFieldId+" and fieldValue > 0)");
		RecordSet.executeSql("delete from Workflow_TriDiffWfSubWf where fieldvalue>0 and triDiffWfDiffFieldId = "+triDiffWfDiffFieldId+" and id not in ("+triDiffWfSubWfIds+")");
	}else{
		RecordSet.executeSql("delete from Workflow_TriDiffWfSubWfField where triDiffWfSubWfId in"
		+" (select id from Workflow_TriDiffWfSubWf where triDiffWfDiffFieldId = "+triDiffWfDiffFieldId+" and fieldValue > 0)");
		RecordSet.executeSql("delete from Workflow_TriDiffWfSubWf where fieldvalue>0 and triDiffWfDiffFieldId = "+triDiffWfDiffFieldId+" and id not in ("+triDiffWfSubWfIds+")");
	}
	
	for(int i = 0; i < rowNum; i++){
		int triDiffWfSubWfId = Util.getIntValue(request.getParameter("triDiffWfSubWfId_"+i), -1);
		int subWorkflowId = Util.getIntValue(request.getParameter("subWorkflowId_"+i), -1);
		String fieldValueStr = Util.null2String(request.getParameter("fieldValue_"+i));
		String[] fieldValueArr = fieldValueStr.split(",");
		for(int j = 0; j < fieldValueArr.length; j++){
			int fieldValue = Util.getIntValue(fieldValueArr[j],-1);
			if(fieldValue <= 0) continue;
			
			//更新操作
	        if(triDiffWfSubWfId > 0 && subWorkflowId > 0){
				//上次设置的默认子流程的编号
		    	int oldSubWorkflowId = 0;
		    	RecordSet.executeSql("select subWorkflowId from Workflow_TriDiffWfSubWf where id = " + triDiffWfSubWfId);
		    	if(RecordSet.next()){
		    		oldSubWorkflowId = Util.getIntValue(RecordSet.getString("subWorkflowId"), 0);
		    	}
		    	
		    	RecordSet.executeSql("update Workflow_TriDiffWfSubWf set subWorkflowId="+subWorkflowId+",fieldValue="+fieldValue+" where id="+triDiffWfSubWfId);
		    	//如果新默认子流程与老的默认子流程不相同，则删除字段详细设置
		    	if(oldSubWorkflowId != subWorkflowId){
		    		 RecordSet.executeSql("delete from Workflow_TriDiffWfSubWfField where triDiffWfSubWfId="+triDiffWfSubWfId);
		    	}
			}
			//新增操作
			else if(triDiffWfSubWfId <= 0 && subWorkflowId > 0){
		        RecordSet.executeSql("insert into Workflow_TriDiffWfSubWf(triDiffWfDiffFieldId,subWorkflowId,fieldValue) values("+triDiffWfDiffFieldId+","+subWorkflowId+","+fieldValue+")");
			}
		}
	}
	
	if("1".equals(dialog)){
		response.sendRedirect("WorkflowTriDiffWfSubWf.jsp?dialog=1&triDiffWfDiffFieldId="+triDiffWfDiffFieldId+"&callbackvalue="+Util.null2String(request.getParameter("callbackvalue"))+"&mainWorkflowId="+Util.null2String(request.getParameter("mainWorkflowId")));
	}else{
		int mainWorkflowId = 0;
	    RecordSet.executeSql("select * from Workflow_TriDiffWfDiffField where id=" + triDiffWfDiffFieldId);
	    if(RecordSet.next()){
			mainWorkflowId = Util.getIntValue(RecordSet.getString("mainWorkflowId"), 0);
		}
    	response.sendRedirect("WorkflowSubwfSet.jsp?wfid="+mainWorkflowId);
    }
%>


