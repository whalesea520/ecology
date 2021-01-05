<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    if(!HrmUserVarify.checkUserRight("workflowtodocument:all", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

    int docPropId=Util.getIntValue(request.getParameter("docPropId"),-1);
    int workflowId=Util.getIntValue(request.getParameter("workflowId"),-1);
    int secCategoryId=Util.getIntValue(request.getParameter("secCategoryId"),-1);
    String wfdocpath = Util.null2String(request.getParameter("wfdocpath"));
	String wfdocowner = Util.null2String(request.getParameter("wfdocowner"));
    String wfdocownertype = ""+Util.getIntValue(request.getParameter("wfdocownertype"), 0);
	String wfdocownerfieldid = ""+Util.getIntValue(request.getParameter("wfdocownerfieldid"), 0);
    int keepsign = Util.getIntValue(request.getParameter("keepsign"),0);
	rs.executeSql("update workflow_base set wfdocpath='"+wfdocpath+"',wfdocowner='"+wfdocowner+"',wfdocownertype='"+wfdocownertype+"',wfdocownerfieldid='"+wfdocownerfieldid+"',keepsign='"+keepsign+"',secCategoryId='"+secCategoryId+"' where id = " + workflowId);

    if(docPropId<=0){
	    RecordSet.executeSql("select id from  WorkflowToDocProp where workflowId="+workflowId+" and secCategoryid="+secCategoryId);
	    if(RecordSet.next()){
		    docPropId=Util.getIntValue(RecordSet.getString("id"),0);
	    }
	}

    if(docPropId<=0){
		RecordSet.executeSql("insert into WorkflowToDocProp(workflowId,secCategoryId) values("+workflowId+","+secCategoryId+")");
		RecordSet.executeSql("select max(id) as maxId from WorkflowToDocProp");
		if(RecordSet.next()){
			docPropId=Util.getIntValue(RecordSet.getString("maxId"),-1);
		}
	}else{
		RecordSet.executeSql("update WorkflowToDocProp set workflowId="+workflowId+",secCategoryId="+secCategoryId+" where id="+docPropId);
	}

    int docPropDetailId=-1;
    int docPropFieldId=-1;
    int workflowFieldId=-1;
    int rowNum=Util.getIntValue(request.getParameter("rowNum"),-1);
	if(rowNum>=1){
		RecordSet.executeSql("delete from WorkflowToDocPropDetail where docPropId="+docPropId);
	}

	for(int i=0;i<rowNum;i++){
		docPropDetailId=Util.getIntValue(request.getParameter("docPropDetailId_"+i),-1);
		docPropFieldId=Util.getIntValue(request.getParameter("docPropFieldId_"+i),-1);
		workflowFieldId=Util.getIntValue(request.getParameter("workflowFieldId_"+i),-1);

		if(workflowFieldId!=-1){
			RecordSet.executeSql("insert into WorkflowToDocPropDetail(docPropId,docPropFieldId,workflowFieldId) values("+docPropId+","+docPropFieldId+","+workflowFieldId+")");
		}
	}

	response.sendRedirect("/workflow/workflow/CreateDocumentByAction.jsp?ajax=1&wfid=" + workflowId );

%>
