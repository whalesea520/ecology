
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

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
	String enableDeptcode=Util.null2String(request.getParameter("enableDeptcode"));


  	int rowNum = Util.getIntValue(Util.null2String(request.getParameter("rowNum")));

    int tempFieldValue=0;
	int tempRecordId=0;
    String tempAbbr=null;
    RecordSet.executeSql("delete from workflow_deptAbbr where workflowId="+workflowId+" and enableDeptcode=1");
	if(!enableDeptcode.equals("1")){
		for(int i=0;i<rowNum;i++) {
			tempFieldValue = Util.getIntValue(request.getParameter("abbr"+i+"_fieldValue"),0);
			tempRecordId = Util.getIntValue(request.getParameter("abbr"+i+"_recordId"),0);

			tempAbbr = Util.null2String(request.getParameter("abbr"+i+"_abbr"));
			tempAbbr=Util.toHtml100(tempAbbr);

			if(tempRecordId <=0&&!(tempAbbr.trim().equals(""))){
				if(isWorkflowSeqAlone){
					RecordSet.executeSql("insert into workflow_deptAbbr(workflowId,formId,isBill,fieldId,fieldValue,abbr) values("+workflowId+",-1,'0',"+fieldId+","+tempFieldValue+",'"+tempAbbr+"')");
				}else{
					RecordSet.executeSql("insert into workflow_deptAbbr(workflowId,formId,isBill,fieldId,fieldValue,abbr) values(-1,"+formId+",'"+isBill+"','"+fieldId+"',"+tempFieldValue+",'"+tempAbbr+"')");
				}
			}
			if(tempRecordId>0){
				RecordSet.executeSql("update workflow_deptAbbr set abbr='"+tempAbbr+"' where id="+tempRecordId);
			}
		}
	}else{
		RecordSet.executeSql("insert into workflow_deptAbbr(workflowId,enableDeptcode) values("+workflowId+",'1')");
	}
    response.sendRedirect("WorkflowDeptAbbr.jsp?ajax="+ajax+"&isclose=1&workflowId="+workflowId);
%>
