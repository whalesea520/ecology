
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.workflow.UserWFOperateLevel"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<%
    int workflowid = Util.getIntValue(request.getParameter("wfid"), -1);
	boolean haspermission = wfrm.hasPermission3(workflowid, 0, user, WfRightManager.OPERATION_CREATEDIR);
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int subCompanyID= Util.getIntValue(Util.null2String(session.getAttribute(workflowid+"subcompanyid")),-1);
    int operateLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyID,user,haspermission,"WorkflowManage:All");
	int id = Util.getIntValue(request.getParameter("id"),-1);
	if(operateLevel<1 || workflowid==-1){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String formID = request.getParameter("formid");
	String isbill = request.getParameter("isbill");
	String operationType = Util.null2String(request.getParameter("operationType"));
	int errorMessage = 0;
	String sql = "";
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isEntryDetail = Util.null2String(request.getParameter("isEntryDetail"));
	//System.out.println("operationType = " + operationType);
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
		int plantypeid = Util.getIntValue(request.getParameter("plantypeid"), -1);
		//System.out.println("nodeid = " + nodeid);
		//System.out.println("changetime = " + changetime);
		//System.out.println("taskid = " + taskid);
		if(nodeid==0 || changetime==0 || plantypeid==-1){
			if(dialog.equals("1")){
				response.sendRedirect("/workflow/workflow/WorkplanAdd.jsp?dialog=1&ajax=1&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill+"&errorMessage=0");
			}else{
				response.sendRedirect("/workflow/workflow/CreateWorkplanByWorkflow.jsp?ajax=1&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill+"&errorMessage=0");
			}
			return;
		}
		rs.execute("select * from workflow_createplan where wfid="+workflowid+" and nodeid="+nodeid+" and changetime="+changetime+" and plantypeid="+plantypeid);
		if(rs.next()){
			errorMessage = 1;
		}else{
			sql = "insert into workflow_createplan (wfid, nodeid, changetime, plantypeid, changemode) values ("+workflowid+", "+nodeid+", "+changetime+", "+plantypeid+", "+changemode+")";
			//System.out.println(sql);
			boolean s = rs.execute(sql);
			if(s){
				sql = "select max(id) from workflow_createplan where wfid="+workflowid+" and nodeid="+nodeid+" and changetime="+changetime+" and plantypeid="+plantypeid;
				rs.execute(sql);
				if(rs.next()){
					id = Util.getIntValue(rs.getString(1),-1);
				}
			}
		}
	}else if("del".equalsIgnoreCase(operationType)){
		String createwpids = Util.null2String(request.getParameter("id"));
		if(!createwpids.equalsIgnoreCase("")){
			sql = "delete from workflow_createplan where id in (" + createwpids + ")";
			rs.execute(sql);
			sql = "delete from workflow_createplandetail where createplanid in (" + createwpids + ")";
			rs.execute(sql);
		}
		out.println("1");
		return;
	}
	if(dialog.equals("1")){
		response.sendRedirect("/workflow/workflow/WorkplanAdd.jsp?isclose=1&id="+id+"&isEntryDetail="+isEntryDetail+"&dialog=1&ajax=1&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill+"&errorMessage="+errorMessage);
	}else{
		response.sendRedirect("/workflow/workflow/CreateWorkplanByWorkflow.jsp?ajax=1&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill+"&errorMessage="+errorMessage);
	}
    
%>