
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<%
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int subCompanyID = -1;
    int operateLevel = 0;
    int workflowid = Util.getIntValue(request.getParameter("wfid"), -1);
    
    if(detachable==1){  
        //如果开启分权，管理员
        subCompanyID = Util.getIntValue(request.getParameter("subCompanyID"),0);
    }
    boolean haspermission = wfrm.hasPermission3(workflowid, 0, user, WfRightManager.OPERATION_CREATEDIR);
    operateLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyID,user,haspermission,"WorkflowManage:All");
     
    if(operateLevel < 1){
		response.sendRedirect("/notice/noright.jsp");
		return;
    }
	String formID = request.getParameter("formid");
	String isbill = request.getParameter("isbill");
	int id = Util.getIntValue(request.getParameter("id"),-1);
	String operationType = Util.null2String(request.getParameter("operationType"));
	int errorMessage = 0;
	String sql = "";
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isEntryDetail = Util.null2String(request.getParameter("isEntryDetail"));
	if("add".equalsIgnoreCase(operationType)){
		int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
		int changetime = Util.getIntValue(request.getParameter("changetime"), 0);
		if(changetime == 0){
			changetime = Util.getIntValue(request.getParameter("changetimeinput"), 0);
		}
		int changemode = Util.getIntValue(request.getParameter("changemode"), 0);
		int changemode0 = Util.getIntValue(request.getParameter("changemode0"), 0);
		if(changetime == 2){
			changemode = changemode0;
		}
		int taskid = Util.getIntValue(request.getParameter("taskid"), 0);
		if(nodeid==0 || changetime==0 || taskid==0){
			if(dialog.equals("1")){
				response.sendRedirect("/workflow/workflow/WorktaskAdd.jsp?dialog=1&ajax=1&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill+"&errorMessage=0");
			}else{
				response.sendRedirect("/workflow/workflow/CreateWorktaskByWorkflow.jsp?ajax=1&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill+"&errorMessage=0");
			}
			return;
		}
		rs.execute("select id from workflow_createtask where wfid="+workflowid+" and nodeid="+nodeid+" and changetime="+changetime+" and taskid="+taskid);
		if(rs.next()){
			errorMessage = 1;
		}else{
			sql = "insert into workflow_createtask (wfid, nodeid, changetime, taskid, changemode) values ("+workflowid+", "+nodeid+", "+changetime+", "+taskid+", "+changemode+")";
			rs.execute(sql);
			//System.out.println("sql:"+sql);
		}
	}else if("del".equalsIgnoreCase(operationType)){
		String[] checkbox1s = request.getParameterValues("checkbox1");
		String createwtids = "0";
		if(checkbox1s != null){
			for(int i=0; i<checkbox1s.length; i++){
				createwtids += ("," + checkbox1s[i]);
			}
			sql = "delete from workflow_createtask where id in (" + createwtids + ")";
			rs.execute(sql);
			sql = "delete from workflow_createtaskgroup where createtaskid in (" + createwtids + ")";
			rs.execute(sql);
			sql = "delete from workflow_createtaskdetail where createtaskid in (" + createwtids + ")";
			rs.execute(sql);
			response.sendRedirect("/workflow/workflow/CreateWorktaskByWorkflow.jsp?ajax=1&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill+"&errorMessage="+errorMessage);
		}
	}
	if(dialog.equals("1")){
		response.sendRedirect("/workflow/workflow/WorktaskAdd.jsp?isclose=1&id="+id+"&isEntryDetail="+isEntryDetail+"&dialog=1&ajax=1&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill+"&errorMessage=0");
	}else{
		response.sendRedirect("/workflow/workflow/CreateWorktaskByWorkflow.jsp?ajax=1&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill+"&errorMessage="+errorMessage);
	}
%>