
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
    int docPropId=Util.getIntValue(request.getParameter("docPropId"),-1);
	String isAjax = Util.null2String(request.getParameter("isAjax"));
    int workflowId=Util.getIntValue(request.getParameter("workflowId"),-1);
    int selectItemId=Util.getIntValue(request.getParameter("selectItemId"),-1);
    int secCategoryId=Util.getIntValue(request.getParameter("secCategoryId"),-1);
    String isuser = Util.null2String(request.getParameter("isuser"));
    String number = Util.null2String(request.getParameter("number"));
    
    RecordSet.executeSql("update DocSecCategory set isuser='"+isuser+"',e8number='"+number+"' where id="+secCategoryId);

    int objId=Util.getIntValue(request.getParameter("objId"),-1);
    String objType=Util.null2String(request.getParameter("objType"));
	if(objType.equals("")){
		objType="0";
	}

        if(docPropId<=0){
		    RecordSet.executeSql("select id from  Workflow_DocProp where workflowId="+workflowId+" and selectItemId="+selectItemId+" and secCategoryid="+secCategoryId+" and objId="+objId+" and objType="+objType);
		    if(RecordSet.next()){
			    docPropId=Util.getIntValue(RecordSet.getString("id"),0);
		    }
		}

    if(docPropId<=0){
		RecordSet.executeSql("insert into Workflow_DocProp(workflowId,selectItemId,secCategoryId,objId,objType) values("+workflowId+","+selectItemId+","+secCategoryId+","+objId+",'"+objType+"')");
		RecordSet.executeSql("select max(id) as maxId from Workflow_DocProp");
		if(RecordSet.next()){
			docPropId=Util.getIntValue(RecordSet.getString("maxId"),-1);
		}
	}else{
		RecordSet.executeSql("update Workflow_DocProp set workflowId="+workflowId+",selectItemId="+selectItemId+",secCategoryId="+secCategoryId+",objId="+objId+",objType='"+objType+"'  where id="+docPropId);
	}

    int docPropDetailId=-1;
    int docPropFieldId=-1;
    int workflowFieldId=-1;

    int rowNum=Util.getIntValue(request.getParameter("rowNum"),-1);

	if(rowNum>=1){
		RecordSet.executeSql("delete from Workflow_DocPropDetail where docPropId="+docPropId);
	}
	for(int i=0;i<rowNum;i++){
		docPropDetailId=Util.getIntValue(request.getParameter("docPropDetailId_"+i),-1);
		docPropFieldId=Util.getIntValue(request.getParameter("docPropFieldId_"+i),-1);
		workflowFieldId=Util.getIntValue(request.getParameter("workflowFieldId_"+i),-1);

		if(workflowFieldId!=-1){
			RecordSet.executeSql("insert into Workflow_DocPropDetail(docPropId,docPropFieldId,workflowFieldId) values("+docPropId+","+docPropFieldId+","+workflowFieldId+")");
		}


	}
	
	if(isAjax.equals("1")){
		out.println("1");
		return;
	}

    //if(objId<=-1){
		response.sendRedirect("/workflow/workflow/WorkflowDocPropDetail.jsp?isclose=1&wfid=" + workflowId );
	//}else{
	//	out.println("<script>window.close();</script>");
	//}
%>
