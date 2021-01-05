<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.workflow.workflow.beans.OfficialDocConditions" %>

<jsp:useBean id="WFDocumentManager" class="weaver.workflow.workflow.WFDocumentManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%
    String workFlowID = request.getParameter("workFlowID");

	// 默认打开正文的节点
	String openTextDefaultNode = Util.null2String(request.getParameter("openTextDefaultNode"));

    String show = request.getParameter("show");  //是否通过流程创建文档    0:启用
    String workFlowCoding = request.getParameter("workFlowCoding");  //流程编码字段
	String setwfstatusfrom = Util.null2String(request.getParameter("setwfstatusfrom"));  //来自公文流程设置界面而不是路径设置那里
    String createDocument = request.getParameter("createDocument");  //创建文档字段
    String documentTitleField = request.getParameter("documentTitleField");  //文档标题字段
    String documentLocation = request.getParameter("documentLocation"); //文件存放目录
    String isDialog = Util.null2String(request.getParameter("isdialog")); //0表示从流程过来的，其他值表示从公文过来的
    int tabIndex = Util.getIntValue(request.getParameter("tabIndex"),1); //tab序号
    

    String mainCategoryDocument = request.getParameter("mainCategoryDocument");  //一级子目录
    String subCategoryDocument = request.getParameter("subCategoryDocument");  //二级子目录
    String secCategoryDocument = request.getParameter("secCategoryDocument");  //三级子目录

    String useTempletNode = Util.null2String(request.getParameter("useTempletNode"));  //套红节点
    String[] printNodesArr = request.getParameterValues("printNodes");  //打印节点
    String[] signatureNodesArr = request.getParameterValues("signatureNodes");//签章节点
    String printNodes = "";
    String signatureNodes = "";
    for(int i=0;printNodesArr!=null && i<printNodesArr.length;i++){
    	if(printNodes.equals("")){
    		printNodes = printNodesArr[i];
    	}else{
    		printNodes = printNodes+","+printNodesArr[i];
    	}
    }
    for(int i=0;signatureNodesArr!=null && i<signatureNodesArr.length;i++){
    	if(signatureNodes.equals("")){
    		signatureNodes =signatureNodesArr[i];
    	}else{
    		signatureNodes = signatureNodes+","+signatureNodesArr[i];
    	}
    }
	String newTextNodes = Util.null2String(request.getParameter("newTextNodes"));//是否只能新建正文
    String onlyCanAddWord = Util.null2String(request.getParameter("onlyCanAddWord"));//是否只能只能选择WORD文档
	String isCompellentMark = Util.null2String(request.getParameter("isCompellentMark"));//是否必须保留痕迹
	String isCancelCheck = Util.null2String(request.getParameter("isCancelCheckInput"));//是否取消审阅
	String isWorkflowDraft = Util.null2String(request.getParameter("isWorkflowDraft"));//是否存为流程草稿

	String ifVersion = Util.null2String(request.getParameter("ifVersion"));//是否保留正文版本
    int titleFieldId = Util.getIntValue(request.getParameter("titleFieldId"),0);
    int keywordFieldId = Util.getIntValue(request.getParameter("keywordFieldId"),0);
	int extfile2doc = Util.getIntValue(request.getParameter("extfile2doc"),0);//流程附件是否存为正文附件
	String defaultDocType = Util.null2String(request.getParameter("defaultDocType"));//默认文档类型，1：Office Word   2：WPS文字
	String isHideTheTraces = Util.null2String(request.getParameter("isHideTheTraces"));//编辑正文时默认隐藏痕迹
	String cleanCopyNodes = Util.null2String(request.getParameter("cleanCopyNodes"));//清稿节点	
	String isTextInForm = Util.null2String(request.getParameter("isTextInForm"));
	if("".equals(useTempletNode.trim())){
		useTempletNode = "-1";
	}

	if("".equals(isCompellentMark)){
		isCompellentMark = "0";
	}
	if("".equals(isCancelCheck)){
		isCancelCheck = "0";
	}
	String logsql = "";
	String sql = "";
	OfficialDocConditions officialDocConditions = null;
	String status = ("0".equals(show) || "1".equals(setwfstatusfrom)) ? "1" : "0";
    //if((!"".equals(show) && null != show))
    //{
		if(setwfstatusfrom.equals("1")){
		    WFDocumentManager.setWfstatusfrom("1");
		}
		officialDocConditions = new OfficialDocConditions(workFlowID, status, workFlowCoding, createDocument, documentLocation, mainCategoryDocument, subCategoryDocument, secCategoryDocument, useTempletNode, documentTitleField,printNodes,  newTextNodes, isCompellentMark, isCancelCheck,signatureNodes,isWorkflowDraft,defaultDocType,extfile2doc,isHideTheTraces,cleanCopyNodes);
		officialDocConditions.setOpenTextDefaultNode(openTextDefaultNode);
        officialDocConditions.setOnlyCanAddWord(onlyCanAddWord);
		WFDocumentManager.saveCreateDocByWorkFlowObject(officialDocConditions);
		logsql = WFDocumentManager.getLogsql();
		boolean succ = true;
		sql = "update workflow_process_relative set nodeids='"+useTempletNode+"' where officaltype=1 and workflowid="+workFlowID+" and pdid in ( select id from workflow_processdefine where sysid=5)";
		succ = RecordSet.executeSql(sql);
		logsql = logsql + ";" + sql;
		//System.out.println(succ);
		sql = "update workflow_process_relative set nodeids='"+signatureNodes+"' where officaltype=1 and workflowid="+workFlowID+" and pdid in ( select id from workflow_processdefine where sysid=6)";
		succ = RecordSet.executeSql(sql);
		logsql = logsql + ";" + sql;
		//System.out.println(succ);
		sql = "update workflow_process_relative set nodeids='"+printNodes+"' where officaltype=1 and workflowid="+workFlowID+" and pdid in ( select id from workflow_processdefine where sysid=7)";
		RecordSet.executeSql(sql);
		logsql = logsql + ";" + sql;
		//System.out.println(succ);
		//RecordSet.executeSql("update workflow_base set ifVersion='"+ifVersion+"' where id=" +workFlowID);
		sql = "update workflow_base set ifVersion='"+ifVersion+"',titleFieldId="+titleFieldId+",keywordFieldId="+keywordFieldId+" where id=" +workFlowID;
		logsql = logsql + ";" + sql;
		RecordSet.executeSql(sql);
    //}
    //else
    //{   
	//	if(setwfstatusfrom.equals("1")){
	//		officialDocConditions = new OfficialDocConditions(workFlowID, "1",  workFlowCoding, createDocument, documentLocation, mainCategoryDocument, subCategoryDocument, secCategoryDocument, useTempletNode, documentTitleField,printNodes,  newTextNodes, isCompellentMark, isCancelCheck,signatureNodes,isWorkflowDraft,defaultDocType,extfile2doc,isHideTheTraces);
	//		officialDocConditions.setOpenTextDefaultNode(openTextDefaultNode);
	//  }else{
	//		officialDocConditions = new OfficialDocConditions(workFlowID, "0", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "","", "0", "0","","","",0,"0");
	//		officialDocConditions.setOpenTextDefaultNode("");
	//	}
	//	WFDocumentManager.saveCreateDocByWorkFlowObject(officialDocConditions);
	//	logsql = WFDocumentManager.getLogsql();
		//RecordSet.executeSql("update workflow_base set ifVersion='0' where id=" +workFlowID);
	//	sql = "update workflow_base set ifVersion='0',titleFieldId="+titleFieldId+",keywordFieldId="+keywordFieldId+" where id=" +workFlowID;
	//	RecordSet.executeSql(sql);
	//	logsql = logsql + ";" + sql;

    //}
    sql = "update workflow_createdoc set isTextInForm='"+isTextInForm+"' where workflowId="+workFlowID;
	logsql = logsql + ";" + sql;
	RecordSet.executeSql(sql);
    //保存过程设置
    String saveThNode = Util.null2String(request.getParameter("saveThNode"));//如果该值为1，则保存过程设置中设置的套红节点
    int processRows = Util.getIntValue(request.getParameter("processRows"),-1);//过程定义的行数
    int sysid = 0;
    int pdid = 0;
    String nodeids = "";
    int officalType = Util.getIntValue(request.getParameter("officalType"),-1);//公文种类
    if(officalType>-2){
		if(setwfstatusfrom.equals("1")){
			sql = "update workflow_base set officalType="+officalType +" where id="+workFlowID;
    		RecordSet.executeSql(sql);
    		logsql = logsql + ";" + sql;
		}
    	WorkflowComInfo.reloadWorkflowInfos();
	    try{
	    	rst.setAutoCommit(false);
	    	sql = "delete from workflow_process_relative where workflowid="+workFlowID+" and officaltype="+officalType;
	    	rst.executeSql(sql);
	    	logsql = logsql + ";" + sql;
		    for(int i=0;i<processRows;i++){
		    	sysid = Util.getIntValue(request.getParameter("sysid_"+i));
		    	pdid = Util.getIntValue(request.getParameter("pdid_"+i));
		    	nodeids = Util.null2String(request.getParameter("nodeids_"+i));
		    	sql = "insert into workflow_process_relative(workflowid,officaltype,pdid,nodeids) values("+workFlowID+","+officalType+","+pdid+",'"+nodeids+"')";
		    	rst.executeSql(sql);
		    	logsql = logsql + ";" + sql;
		    	//System.out.println("saveThNode::"+saveThNode);
		    	if(saveThNode.equals("1")){
			    	if(sysid==5){//套红
			    		sql = "update workflow_createdoc set useTempletNode="+nodeids+" where workflowId="+workFlowID;
			    		logsql = logsql + ";" + sql;
			    		rst.executeSql(sql);
			    	}else if(sysid==6){//签章
			    		sql = "update workflow_createdoc set signatureNodes='"+nodeids+"' where workflowId="+workFlowID;
			    		logsql = logsql + ";" + sql;
			    		rst.executeSql(sql);
			    	}
			    	else if(sysid==7){//打印
			    		sql = "update workflow_createdoc set printNodes='"+nodeids+"' where workflowId="+workFlowID;
			    		logsql = logsql + ";" + sql;
			    		rst.executeSql(sql);
			    	}
			    }else{
			    	if(sysid==5){//套红
			    		sql = "update workflow_process_relative set nodeids='"+useTempletNode+"' where pdid="+pdid;
			    		logsql = logsql + ";" + sql;
			    		rst.executeSql(sql);
			    	}else if(sysid==6){//签章
			    		sql = "update workflow_process_relative set nodeids='"+signatureNodes+"' where pdid="+pdid;
			    		logsql = logsql + ";" + sql;
			    		rst.executeSql(sql);
			    	}
			    	else if(sysid==7){//打印
			    		sql = "update workflow_process_relative set nodeids='"+printNodes+"' where pdid="+pdid;
			    		logsql = logsql + ";" + sql;
			    		rst.executeSql(sql);
			    	}
			    }
		    }
		    log.insSysLogInfo(user, Util.getIntValue(workFlowID), WorkflowComInfo.getWorkflowname(workFlowID), sql, "220", "2", 0, request.getRemoteAddr());
		    rst.commit();
		}catch(Exception e){
			e.printStackTrace();
			rst.rollback();
		}
	}
    if(isDialog.equals("0")){
    	response.sendRedirect("/workflow/workflow/CreateDocumentByWorkFlowForWf.jsp?isdialog=0&tabIndex="+tabIndex+"&ajax=1&wfid=" + request.getParameter("workFlowID") + "&formid=" + request.getParameter("formID") + "&isbill=" + request.getParameter("isbill"));
    }else{
    	response.sendRedirect("/workflow/workflow/CreateDocumentByWorkFlow.jsp?ajax=1&wfid=" + request.getParameter("workFlowID") + "&formid=" + request.getParameter("formID") + "&isbill=" + request.getParameter("isbill"));
    }
%>



