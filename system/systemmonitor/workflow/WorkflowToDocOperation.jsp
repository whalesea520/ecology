
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>

<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String requestids = Util.null2String(request.getParameter("multiSubIds"));

if(operation.equals("wftodoc")){
	if(!HrmUserVarify.checkUserRight("workflowtodocument:all",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
    if(!requestids.equals("")){
    	String requestid[] = Util.TokenizerString2(requestids,",");  	
    	for(int i=0;i<requestid.length;i++){
			String reqid = Util.null2String(requestid[i]);
    		if(reqid.equals("")) continue;
    		String sql = "select * from workflow_requestbase where requestid = " + reqid ;
    		rs.executeSql(sql);
    		if(rs.next()){
    			String workflowid = rs.getString("workflowid");
    			String requestname = rs.getString("requestname");
    			String creater =     rs.getString("creater");
    			new weaver.interfaces.workflow.action.WorkflowToDoc().Start(reqid,creater,requestname,workflowid);
    		}	    			
    	}    	
    }     	
 	//response.sendRedirect("/system/systemmonitor/workflow/WorkflowToDocTab.jsp?"+request.getQueryString());
}

%>