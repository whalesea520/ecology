
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>
<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowCodeSeqReservedManager" class="weaver.workflow.workflow.WorkflowCodeSeqReservedManager" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	boolean hasWorkflowManageRight=true;
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
//		response.sendRedirect("/notice/noright.jsp");
//    		return;
        hasWorkflowManageRight=false;
	}

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){  
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("WorkflowCodeSeqReserved_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("WorkflowCodeSeqReserved_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"ReservedCode:Maintenance",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("ReservedCode:Maintenance", user))
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


  	int rowNum = Util.getIntValue(Util.null2String(request.getParameter("rowNumCodeSeqReservedSet")));

    int tempFieldId=fieldId;

    int tempWorkflowId=-1;
	int tempFormId=-1;
	String tempIsBill="0";
	if(isWorkflowSeqAlone){
		tempWorkflowId=workflowId;
	}else{
		tempFormId=formId;
		tempIsBill=isBill;
	}

	int tempRecordId=0;
	int tempYearId=-1;
	int tempMonthId=-1;
	int tempDateId=-1;
    int tempFieldValue=-1;
    int tempSupSubCompanyId=-1;
    int tempSubCompanyId=-1;
    int tempDepartmentId=-1;
    int tempSequenceId=1;
	String tempReservedIdStr=null;


	String reservedCode=null;
	String reservedDesc="";

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
        tempReservedIdStr=Util.null2String(request.getParameter("codeSeq"+i+"_reservedIdStr"));//格式为：5,6-10,23,34,37,45



		if(tempRecordId <=0){
			//tempSequenceId=1;
			if(tempSequenceId<1){
				tempSequenceId=1;
			}

			RecordSet.executeSql("insert into workflow_codeSeq(yearId,sequenceId,formId,isBill,monthId,dateId,workflowId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId) values("+tempYearId+","+tempSequenceId+","+tempFormId+",'"+tempIsBill+"',"+tempMonthId+","+tempDateId+","+tempWorkflowId+","+tempFieldId+","+tempFieldValue+","+tempSupSubCompanyId+","+tempSubCompanyId+","+tempDepartmentId+")");

	        RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

	        if(RecordSet.next()){
		        tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
		        tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
	        }
		}
//		if(tempRecordId>0){
//			RecordSet.executeSql("update workflow_codeSeq set sequenceId="+tempSequenceId+" where id="+tempRecordId);
//		}

//生成预留号开始
		int reservedId=-1;
		int reservedIdBegin=-1;
		int reservedIdEnd=-1;	
		List hisReservedIdList=new ArrayList();
		StringBuffer hisReservedIdSb=new StringBuffer();
		hisReservedIdSb.append(" select reservedId ")
		               .append("   from workflow_codeSeqReserved ")
		               .append("  where codeSeqId=").append(tempRecordId)
		               .append("    and (hasDeleted is null or hasDeleted='0') ")
		               .append("  order by reservedId asc,id asc ")		               
		               ;
		RecordSet.executeSql(hisReservedIdSb.toString());
		while(RecordSet.next()){
			reservedId=Util.getIntValue(RecordSet.getString("reservedId"),-1);
			if(reservedId>0&&hisReservedIdList.indexOf(""+reservedId)==-1){
				hisReservedIdList.add(Util.null2String(RecordSet.getString("reservedId")));
			}
		}

		RecordSet.executeSql("select distinct sequenceId from workflow_codeSeqRecord where codeSeqId="+tempRecordId);
		while(RecordSet.next()){
			reservedId=Util.getIntValue(RecordSet.getString("sequenceId"),-1);
			if(reservedId>0&&hisReservedIdList.indexOf(""+reservedId)==-1){
				hisReservedIdList.add(Util.null2String(RecordSet.getString("sequenceId")));
			}
		}
		
		List reservedIdList=Util.TokenizerString(tempReservedIdStr,",");
		String reservedIdStrPart=null;
		List reservedIdStrPartList=null;
		for(int index=0;index<reservedIdList.size();index++){
			reservedIdStrPart=Util.null2String((String)reservedIdList.get(index));
			reservedIdStrPartList=Util.TokenizerString(reservedIdStrPart,"-");
			if(reservedIdStrPartList.size()>=2){
				reservedIdBegin=reservedId=Util.getIntValue((String)reservedIdStrPartList.get(0),-1);
				reservedIdEnd=reservedId=Util.getIntValue((String)reservedIdStrPartList.get(1),-1);
				if(reservedIdBegin>0&&reservedIdBegin<=reservedIdEnd){
					for(reservedId=reservedIdBegin;reservedId<=reservedIdEnd;reservedId++){
						if(hisReservedIdList.indexOf(""+reservedId)==-1){
							hisReservedIdList.add(""+reservedId);
							reservedCode=WorkflowCodeSeqReservedManager.getReservedCode(workflowId,formId,isBill,tempRecordId,-1,reservedId);
							reservedCode=Util.toHtml100(reservedCode);
							RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+tempRecordId+","+reservedId+",'"+reservedCode+"','"+reservedDesc+"','0','0')");
						}						
					}
				}
				
				
			}else{
				reservedId=Util.getIntValue(reservedIdStrPart,-1);
				if(reservedId>0&&hisReservedIdList.indexOf(""+reservedId)==-1){
					hisReservedIdList.add(""+reservedId);
					reservedCode=WorkflowCodeSeqReservedManager.getReservedCode(workflowId,formId,isBill,tempRecordId,-1,reservedId);
					reservedCode=Util.toHtml100(reservedCode);
					RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+tempRecordId+","+reservedId+",'"+reservedCode+"','"+reservedDesc+"','0','0')");
				}
			}
		}
//生成预留号结束
        
	}
	
    response.sendRedirect("WorkflowCodeSeqReservedSet.jsp?ajax="+ajax+"&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&subCompanyId="+subCompanyId+"&isFromSubCompanyTree="+isFromSubCompanyTree+"&yearIdCodeSeqSet="+yearIdCodeSeqSet+"&yearIdBeginCodeSeqSet="+yearIdBeginCodeSeqSet+"&yearIdEndCodeSeqSet="+yearIdEndCodeSeqSet+"&monthIdCodeSeqSet="+monthIdCodeSeqSet+"&monthIdBeginCodeSeqSet="+monthIdBeginCodeSeqSet+"&monthIdEndCodeSeqSet="+monthIdEndCodeSeqSet+"&dateIdBeginCodeSeqSet="+dateIdBeginCodeSeqSet+"&dateIdEndCodeSeqSet="+dateIdEndCodeSeqSet+"&fieldValueCodeSeqSet="+fieldValueCodeSeqSet+"&departmentNameOfSearch="+departmentNameOfSearch+"&subCompanyIds="+subCompanyIds+"&subCompanyNameOfSearch="+subCompanyNameOfSearch);   

%>