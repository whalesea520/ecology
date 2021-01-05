
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%

//子目录id
String secCategoryId=  Util.null2String(request.getParameter("id"));
String operation=  Util.null2String(request.getParameter("operation"));


if("editApproveWf".equals(operation)) {

	String isOpenApproveWf = Util.null2String(request.getParameter("isOpenApproveWf"));
	String hisValidityWfId = Util.null2String(request.getParameter("hisValidityWfId"));
	String hisInvalidityWfId = Util.null2String(request.getParameter("hisInvalidityWfId"));
	String validityWfId = Util.null2String(request.getParameter("validityWfId"));
	String invalidityWfId = Util.null2String(request.getParameter("invalidityWfId"));

	String approveWorkflowId = Util.null2String(request.getParameter("approveWorkflowId"));

    //isOpenApproveWf为1表示启用文档生效审批和文档失效审批
    if(isOpenApproveWf.equals("1")){


        if(hisValidityWfId.equals("")){
			hisValidityWfId="0";
		}
        if(hisInvalidityWfId.equals("")){
			hisInvalidityWfId="0";
		}

        if(!validityWfId.equals(hisValidityWfId)){
            RecordSet.executeSql("delete from DocSecCategoryApproveWfDetail where secCategoryId="+secCategoryId+" and approveType='1' and workflowId="+hisValidityWfId);
		}

		if(!invalidityWfId.equals(hisInvalidityWfId)){
            RecordSet.executeSql("delete from DocSecCategoryApproveWfDetail where secCategoryId="+secCategoryId+" and approveType='2' and workflowId="+hisInvalidityWfId);
		}

        if(validityWfId.equals("")){
			validityWfId="0";
		}
        if(invalidityWfId.equals("")){
			invalidityWfId="0";
		}

//update by fanggsh 2006-09-22 for  TD5029 begin
//        RecordSet.executeSql("update DocSecCategory set isOpenApproveWf='1',validityApproveWf="+validityWfId+",invalidityApproveWf="+invalidityWfId+" from DocSecCategory where id="+secCategoryId);
        RecordSet.executeSql("update DocSecCategory set isOpenApproveWf='1',validityApproveWf="+validityWfId+",invalidityApproveWf="+invalidityWfId+"  where id="+secCategoryId);

//update by fanggsh 2006-09-22 for  TD5029 end

	}else if(isOpenApproveWf.equals("2")){//isOpenApproveWf为2表示启用批准工作流，即文档需求变更前使用的批准工作流。
	
        if(approveWorkflowId.equals("")){
			approveWorkflowId="0";
		}

        RecordSet.executeSql("update DocSecCategory set isOpenApproveWf='2',approveWorkflowId="+approveWorkflowId+"  where id="+secCategoryId);

	}else{
        RecordSet.executeSql("update DocSecCategory set isOpenApproveWf='0' where id="+secCategoryId);
	}



    response.sendRedirect("DocSecCategoryApproveWfEdit.jsp?id="+secCategoryId);
	return ;
}

if("editApproveWfDetail".equals(operation)){

	String approveType = Util.null2String(request.getParameter("approveType"));
	String approveWfId = Util.null2String(request.getParameter("approveWfId"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
    //更新子目录表的数据
	String updateSql="";
	if(approveType.equals("1")){
		updateSql="update  DocSecCategory set isOpenApproveWf='1',validityApproveWf="+approveWfId+" where id="+secCategoryId;
	}else if(approveType.equals("2")){
		updateSql="update  DocSecCategory set isOpenApproveWf='1',invalidityApproveWf="+approveWfId+" where id="+secCategoryId;
	}

	if(!updateSql.equals("")){
		RecordSet.executeSql(updateSql);
	}

    String[] approveWfDetailIds = request.getParameterValues("approveWfDetailId"); 
    String[] approveWfFieldIds = request.getParameterValues("approveWfFieldId"); 
    String[] docPropertyFieldIds = request.getParameterValues("docPropertyFieldId"); 

    String approveWfDetailId="";
    String approveWfFieldId="";
	String docPropertyFieldId="";

    RecordSet.executeSql("delete from DocSecCategoryApproveWfDetail where seccategoryId="+secCategoryId+" and approveType='"+approveType+"'");

    if(approveWfFieldId!=null){
		for(int i=0;i<approveWfFieldIds.length;i++){
            approveWfDetailId=approveWfDetailIds[i];
			approveWfFieldId=approveWfFieldIds[i];
			docPropertyFieldId=docPropertyFieldIds[i];

			if(docPropertyFieldId.equals("")||docPropertyFieldId.equals("0")){//如果文档属性页字段未选

			}else{//否则，已选
			    RecordSet.executeSql("insert into DocSecCategoryApproveWfDetail(secCategoryId,approveType,workflowId,workflowFieldId,docPropertyFieldId) values("+secCategoryId+","+approveType+","+approveWfId+","+approveWfFieldId+","+docPropertyFieldId+")");
			}

		}
	}
	if(isDialog.equals("1")){
		response.sendRedirect("DocSecCategoryApproveWfDetailEdit.jsp?isdialog="+isDialog+"&id="+secCategoryId+"&approveWfId="+approveWfId+"&approveType="+approveType);
		return ;
	}
    response.sendRedirect("DocSecCategoryApproveWfEdit.jsp?id="+secCategoryId);
	return ;
}
%>