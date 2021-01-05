
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page buffer="16kb" autoFlush="true" errorPage="/notice/error.jsp" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<%
	
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}


    String ajax=Util.null2String(request.getParameter("ajax"));
	int workflowId=Util.getIntValue(Util.null2String(request.getParameter("workflowId")),0);
	int formId=Util.getIntValue(Util.null2String(request.getParameter("formId")),0);
	String isBill=Util.null2String(request.getParameter("isBill"));
	String fieldId=Util.null2String(request.getParameter("fieldId"));

    CodeBuild codeBuild = new CodeBuild(formId,isBill,workflowId);
	boolean isWorkflowSeqAlone=codeBuild.isWorkflowSeqAlone(RecordSet,workflowId);


  	int rowNum = Util.getIntValue(Util.null2String(request.getParameter("rowNumShortNameSetting")));

    int tempFieldValue=0;
	int tempRecordId=0;
    String tempShortNameSetting=null;

	for(int i=0;i<rowNum;i++) {
		tempFieldValue = Util.getIntValue(request.getParameter("shortNameSetting"+i+"_fieldValue"),0);
		tempRecordId = Util.getIntValue(request.getParameter("shortNameSetting"+i+"_recordId"),0);

		tempShortNameSetting = Util.null2String(request.getParameter("shortNameSetting"+i+"_shortNameSetting"));
		tempShortNameSetting=Util.toHtml100(tempShortNameSetting);

		if(tempRecordId <=0&&!(tempShortNameSetting.trim().equals(""))){
			if(isWorkflowSeqAlone){
				RecordSet.executeSql("insert into workflow_shortNameSetting(workflowId,formId,isBill,fieldId,fieldValue,shortNameSetting) values("+workflowId+",-1,'0',"+fieldId+","+tempFieldValue+",'"+tempShortNameSetting+"')");
			}else{
				RecordSet.executeSql("insert into workflow_shortNameSetting(workflowId,formId,isBill,fieldId,fieldValue,shortNameSetting) values(-1,"+formId+",'"+isBill+"','"+fieldId+"',"+tempFieldValue+",'"+tempShortNameSetting+"')");
			}
		}
		if(tempRecordId>0){
			RecordSet.executeSql("update workflow_shortNameSetting set shortNameSetting='"+tempShortNameSetting+"' where id="+tempRecordId);
		}
	}
	   
    response.sendRedirect("WorkflowShortNameSetting.jsp?ajax="+ajax+"&isclose=1&workflowId="+workflowId);
%>
