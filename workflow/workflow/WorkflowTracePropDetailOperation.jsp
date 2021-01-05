
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
	String tracesavesecpath = Util.null2String(request.getParameter("tracesavesecpath"));
    int tracesavesecid=Util.getIntValue(request.getParameter("tracesavesecid"),-1);
	if(tracesavesecid<=0){
		ArrayList tracesavesecpathList=Util.TokenizerString(tracesavesecpath,",");
		if(tracesavesecpathList!=null&&tracesavesecpathList.size()==3){
			tracesavesecid=Util.getIntValue((String)tracesavesecpathList.get(2));
		}
	}

    int docPropId_Trace=Util.getIntValue(request.getParameter("docPropId_Trace"),-1);
	String isAjax = Util.null2String(request.getParameter("isAjax"));
    int workflowId=Util.getIntValue(request.getParameter("workflowId"),-1);
    int secCategoryId=Util.getIntValue(request.getParameter("secCategoryId"),-1);
	if(secCategoryId<=0){
		secCategoryId=tracesavesecid;
	}

    int tracefieldid=Util.getIntValue(request.getParameter("tracefieldid"),-1);

    int tracedocownertype=Util.getIntValue(request.getParameter("tracedocownertype"),-1);
    int tracedocownerfieldid=Util.getIntValue(request.getParameter("tracedocownerfieldid"),-1);
    int tracedocowner=Util.getIntValue(request.getParameter("tracedocowner"),-1);

	RecordSet.executeSql("update workflow_base set tracefieldid="+tracefieldid+",tracesavesecid="+tracesavesecid+",tracedocownertype="+tracedocownertype+",tracedocownerfieldid="+tracedocownerfieldid+",tracedocowner="+tracedocowner+"  where id="+workflowId);
    if(docPropId_Trace<=0){
		RecordSet.executeSql("select id from TraceProp where workflowId="+workflowId);
		if(RecordSet.next()){
			docPropId_Trace=Util.getIntValue(RecordSet.getString("id"),0);
		}
    }

    if(docPropId_Trace<=0){
		RecordSet.executeSql("insert into TraceProp(workflowId,secCategoryId) values("+workflowId+","+secCategoryId+")");
		RecordSet.executeSql("select max(id) as maxId from TraceProp where workflowId="+workflowId);
		if(RecordSet.next()){
			docPropId_Trace=Util.getIntValue(RecordSet.getString("maxId"),-1);
		}
	}else{
		RecordSet.executeSql("update TraceProp set workflowId="+workflowId+",secCategoryId="+secCategoryId+" where id="+docPropId_Trace);
	}

    int docPropDetailId_Trace=-1;
    int docPropFieldId_Trace=-1;
    int workflowFieldId_Trace=-1;

    int rowNum_Trace=Util.getIntValue(request.getParameter("rowNum_Trace"),-1);

	if(rowNum_Trace>=1){
		RecordSet.executeSql("delete from TracePropDetail where docPropId="+docPropId_Trace);
	}
	for(int i=0;i<rowNum_Trace;i++){
		docPropDetailId_Trace=Util.getIntValue(request.getParameter("docPropDetailId_Trace_"+i),-1);
		docPropFieldId_Trace=Util.getIntValue(request.getParameter("docPropFieldId_Trace_"+i),-1);
		workflowFieldId_Trace=Util.getIntValue(request.getParameter("workflowFieldId_Trace_"+i),-1);

		if(workflowFieldId_Trace!=-1){
			RecordSet.executeSql("insert into TracePropDetail(docPropId,docPropFieldId,workflowFieldId) values("+docPropId_Trace+","+docPropFieldId_Trace+","+workflowFieldId_Trace+")");
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
