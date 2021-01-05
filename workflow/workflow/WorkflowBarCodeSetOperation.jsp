<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%

	int workflowId=Util.getIntValue(request.getParameter("workflowId"),0);
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(workflowId, 0, user, WfRightManager.OPERATION_CREATEDIR);
	int formId=Util.getIntValue(request.getParameter("formId"));
    String isBill = Util.null2String(request.getParameter("isBill"));

//权限判断
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int subCompanyID = -1;
    int operateLevel = 0;

    if(1 == detachable)
    {  
        if(null == request.getParameter("subCompanyID"))
        {
            subCompanyID=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")), -1);
        }
        else
        {
            subCompanyID=Util.getIntValue(request.getParameter("subCompanyID"),-1);
        }
        if(-1 == subCompanyID)
        {
            subCompanyID = user.getUserSubCompany1();
        }
        
        session.setAttribute("managefield_subCompanyId", String.valueOf(subCompanyID));
        
        operateLevel= checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowManage:All", subCompanyID);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
            operateLevel=2;
        }
    }

    if(operateLevel<=0 && haspermission){
    	operateLevel = 2;
    }    

	if(operateLevel<=0){
		return ;
	}



	int id=Util.getIntValue(request.getParameter("id"),0);
    String isUse = Util.null2String(request.getParameter("isUseBarCodeSet"));
    String measureUnit = Util.null2String(request.getParameter("measureUnit"));
	int printRatio=Util.getIntValue(request.getParameter("printRatioBarCodeSet"),0);
	int minWidth=Util.getIntValue(request.getParameter("minWidthBarCodeSet"),0);
	int maxWidth=Util.getIntValue(request.getParameter("maxWidthBarCodeSet"),0);
	int bestWidth=Util.getIntValue(request.getParameter("bestWidthBarCodeSet"),0);
	int minHeight=Util.getIntValue(request.getParameter("minHeightBarCodeSet"),0);
	int maxHeight=Util.getIntValue(request.getParameter("maxHeightBarCodeSet"),0);
	int bestHeight=Util.getIntValue(request.getParameter("bestHeightBarCodeSet"),0);

	if(isBill.trim().equals("")){
		isBill="0";
	}   
	if(isUse.trim().equals("")){
		isUse="0";
	}
    
	//更改主表数据
    if(id<=0){
		RecordSet.executeSql("insert into  Workflow_BarCodeSet(workflowId,isUse,measureUnit,printRatio,minWidth,maxWidth,minHeight,maxHeight,bestWidth,bestHeight) values("+workflowId+",'"+isUse+"','"+measureUnit+"',"+printRatio+","+minWidth+","+maxWidth+","+minHeight+","+maxHeight+","+bestWidth+","+bestHeight+")");
		RecordSet.executeSql("select max(id) from Workflow_BarCodeSet");
		if(RecordSet.next()){
			id=Util.getIntValue(RecordSet.getString(1),0);
		}
	}else{
		RecordSet.executeSql("update Workflow_BarCodeSet set workflowId="+workflowId+",isUse='"+isUse+"',measureUnit='"+measureUnit+"',printRatio="+printRatio+",minWidth="+minWidth+",maxWidth="+maxWidth+",minHeight="+minHeight+",maxHeight="+maxHeight+",bestWidth="+bestWidth+",bestHeight="+bestHeight+" where id="+id);
	}

	//更改明细表数据
	int dataElementNum=Util.getIntValue(request.getParameter("dataElementNum"),0);
	int tempDataElementId=-1;
	int tempFieldId=-1;
    for(int i=1;i<=dataElementNum;i++){
		tempDataElementId=i;
		tempFieldId=Util.getIntValue(request.getParameter("fieldId"+i),-1);

		RecordSet.executeSql("select 1 from Workflow_BarCodeSetDetail where barCodeSetId="+id+" and dataElementId="+tempDataElementId);
		if(RecordSet.next()){
			RecordSet.executeSql("update Workflow_BarCodeSetDetail set fieldId="+tempFieldId+" where barCodeSetId="+id+" and dataElementId="+tempDataElementId);
		}else{
			RecordSet.executeSql("insert into Workflow_BarCodeSetDetail(barCodeSetId,dataElementId,fieldId) values("+id+","+tempDataElementId+","+tempFieldId+")");
		}
	}

	RecordSet.executeSql("UPDATE Workflow_BarCodeSet SET isUse = '1' WHERE workflowId ="+workflowId);

    response.sendRedirect("WFSetqrCode.jsp?ajax=1&workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill);
%>
