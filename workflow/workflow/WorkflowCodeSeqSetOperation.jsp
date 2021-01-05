
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>
<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	boolean hasWorkflowManageRight=true;
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
//		response.sendRedirect("/notice/noright.jsp");
//    		return;
        hasWorkflowManageRight=false;
	}

	String isfrom = Util.null2String(request.getParameter("isfrom"));
	String actionKey = Util.null2String(request.getParameter("actionKey"));
	if(!actionKey.equals("")){
		int workflowId=Util.getIntValue(Util.null2String(request.getParameter("workflowId")),0);
		int formId=Util.getIntValue(Util.null2String(request.getParameter("formId")),0);
		String isBill=Util.null2String(request.getParameter("isBill"));
		if(actionKey.equals("del")){
			String id = Util.null2String(request.getParameter("id"));
			RecordSet.executeSql("delete from workflow_codeSeqReserved where id = "+id);
			response.sendRedirect("WFCodeReservedForDigit.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill);
		    return;
		}else if(actionKey.equals("deleteAll")){
			String ids = Util.null2String(request.getParameter("ids"));
			String idss[]=Util.TokenizerString2(ids,",");
			for(int i=0;i<idss.length;i++){
				RecordSet.executeSql("delete from workflow_codeSeqReserved where id = "+idss[i]);
			}
		    response.sendRedirect("WFCodeReservedForDigit.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill);
		    return;
		}
	}else{
	
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){  
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("WorkflowCodeSeq_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("WorkflowCodeSeq_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"StartCode:Maintenance",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("StartCode:Maintenance", user))
            operatelevel=2;
    }

	if(operatelevel<=0&&!hasWorkflowManageRight){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

    String isFromSubCompanyTree = Util.null2String(request.getParameter("isFromSubCompanyTree")); 

    int yearIdCodeSeqSet = Util.getIntValue(request.getParameter("yearIdCodeSeqSet"),-1); 
    int yearIdBeginCodeSeqSet = Util.getIntValue(request.getParameter("yearIdBeginCodeSeqSet"),-1); 
    int yearIdEndCodeSeqSet = Util.getIntValue(request.getParameter("yearIdEndCodeSeqSet"),-1); 
    int monthIdCodeSeqSet = Util.getIntValue(request.getParameter("monthIdCodeSeqSet"),-1); 
    int monthIdBeginCodeSeqSet = Util.getIntValue(request.getParameter("monthIdBeginCodeSeqSet"),-1); 
    int monthIdEndCodeSeqSet = Util.getIntValue(request.getParameter("monthIdEndCodeSeqSet"),-1); 
    int dateIdBeginCodeSeqSet = Util.getIntValue(request.getParameter("dateIdBeginCodeSeqSet"),-1); 
    int dateIdEndCodeSeqSet = Util.getIntValue(request.getParameter("dateIdEndCodeSeqSet"),-1); 

    String departmentNameOfSearch = Util.null2String(request.getParameter("departmentNameOfSearch")); 
    String subCompanyIds = Util.null2String(request.getParameter("subCompanyIds")); 
    String subCompanyNameOfSearch = Util.null2String(request.getParameter("subCompanyNameOfSearch")); 
    departmentNameOfSearch=URLEncoder.encode(departmentNameOfSearch);
    subCompanyNameOfSearch=URLEncoder.encode(subCompanyNameOfSearch);

    int fieldId = Util.getIntValue(request.getParameter("fieldId"),-1); 
    int fieldValueCodeSeqSet = Util.getIntValue(request.getParameter("fieldValueCodeSeqSet"),-1); 

    String ajax=Util.null2String(request.getParameter("ajax"));
	int workflowId=Util.getIntValue(Util.null2String(request.getParameter("workflowId")),0);
	int formId=Util.getIntValue(Util.null2String(request.getParameter("formId")),0);
	String isBill=Util.null2String(request.getParameter("isBill"));

    CodeBuild codeBuild = new CodeBuild(formId,isBill,workflowId);
	boolean isWorkflowSeqAlone=codeBuild.isWorkflowSeqAlone(RecordSet,workflowId);


  	int rowNum = Util.getIntValue(Util.null2String(request.getParameter("rowNumCodeSeqSet")));

	int tempRecordId=0;
	int tempYearId=-1;
	int tempMonthId=-1;
	int tempDateId=-1;
    int tempFieldValue=-1;
    int tempSupSubCompanyId=-1;
    int tempSubCompanyId=-1;
    int tempDepartmentId=-1;
    int tempSequenceId=1;

	int tempWorkflowId=-1;
	int tempFormId=-1;
	String tempIsBill="0";

	for(int i=0;i<rowNum;i++) {
		tempRecordId = Util.getIntValue(request.getParameter("codeSeq"+i+"_recordId"),0);
		tempYearId = Util.getIntValue(request.getParameter("codeSeq"+i+"_yearId"),-1);
		tempMonthId = Util.getIntValue(request.getParameter("codeSeq"+i+"_monthId"),-1);
		tempDateId = Util.getIntValue(request.getParameter("codeSeq"+i+"_dateId"),-1);
		tempFieldValue = Util.getIntValue(request.getParameter("codeSeq"+i+"_fieldValue"),-1);
		tempSupSubCompanyId = Util.getIntValue(request.getParameter("codeSeq"+i+"_supSubCompanyId"),-1);
		tempSubCompanyId = Util.getIntValue(request.getParameter("codeSeq"+i+"_subCompanyId"),-1);
		tempDepartmentId = Util.getIntValue(request.getParameter("codeSeq"+i+"_departmentId"),-1);
		tempSequenceId = Util.getIntValue(request.getParameter("codeSeq"+i+"_sequenceId"),1);

		if(isWorkflowSeqAlone){
			tempWorkflowId=workflowId;
		}else{
			tempFormId=formId;
			tempIsBill=isBill;
		}

		if(tempRecordId <=0){
			//tempSequenceId=1;
			if(tempSequenceId<1){
				tempSequenceId=1;
			}
			RecordSet.executeSql("insert into workflow_codeSeq(yearId,sequenceId,formId,isBill,monthId,dateId,workflowId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId) values("+tempYearId+","+tempSequenceId+","+tempFormId+",'"+tempIsBill+"',"+tempMonthId+","+tempDateId+","+tempWorkflowId+","+fieldId+","+tempFieldValue+","+tempSupSubCompanyId+","+tempSubCompanyId+","+tempDepartmentId+")");

		}
		if(tempRecordId>0){
			RecordSet.executeSql("update workflow_codeSeq set sequenceId="+tempSequenceId+" where id="+tempRecordId);
		}
	}
	
	if(isfrom.equals("new")){
    	response.sendRedirect("WorkflowCodeSeqSetList.jsp?ajax="+ajax+"&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&subCompanyId="+subCompanyId+"&isFromSubCompanyTree="+isFromSubCompanyTree+"&yearIdCodeSeqSet="+yearIdCodeSeqSet+"&yearIdBeginCodeSeqSet="+yearIdBeginCodeSeqSet+"&yearIdEndCodeSeqSet="+yearIdEndCodeSeqSet+"&monthIdCodeSeqSet="+monthIdCodeSeqSet+"&monthIdBeginCodeSeqSet="+monthIdBeginCodeSeqSet+"&monthIdEndCodeSeqSet="+monthIdEndCodeSeqSet+"&dateIdBeginCodeSeqSet="+dateIdBeginCodeSeqSet+"&dateIdEndCodeSeqSet="+dateIdEndCodeSeqSet+"&fieldValueCodeSeqSet="+fieldValueCodeSeqSet+"&departmentNameOfSearch="+departmentNameOfSearch+"&subCompanyIds="+subCompanyIds+"&subCompanyNameOfSearch="+subCompanyNameOfSearch);   
	}else{
    	response.sendRedirect("WorkflowCodeSeqSet.jsp?ajax="+ajax+"&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&subCompanyId="+subCompanyId+"&isFromSubCompanyTree="+isFromSubCompanyTree+"&yearIdCodeSeqSet="+yearIdCodeSeqSet+"&yearIdBeginCodeSeqSet="+yearIdBeginCodeSeqSet+"&yearIdEndCodeSeqSet="+yearIdEndCodeSeqSet+"&monthIdCodeSeqSet="+monthIdCodeSeqSet+"&monthIdBeginCodeSeqSet="+monthIdBeginCodeSeqSet+"&monthIdEndCodeSeqSet="+monthIdEndCodeSeqSet+"&dateIdBeginCodeSeqSet="+dateIdBeginCodeSeqSet+"&dateIdEndCodeSeqSet="+dateIdEndCodeSeqSet+"&fieldValueCodeSeqSet="+fieldValueCodeSeqSet+"&departmentNameOfSearch="+departmentNameOfSearch+"&subCompanyIds="+subCompanyIds+"&subCompanyNameOfSearch="+subCompanyNameOfSearch);   
	}
	}
%>
