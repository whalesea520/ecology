
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.workflow.workflow.UserWFOperateLevel"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<%
	String sql = "";
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int subCompanyID = -1;
    int operateLevel = 0;

	int workflowid = Util.getIntValue(request.getParameter("wfid"),-1);
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

	int id = Util.getIntValue(request.getParameter("id"),-1);
	int taskid = Util.getIntValue(request.getParameter("taskid"),-1);
	int nodeid = Util.getIntValue(request.getParameter("nodeid"),-1);
	String formID = request.getParameter("formid");
	String isbill = request.getParameter("isbill");
	String operationType = Util.null2String(request.getParameter("operationType"));
	int errorMessage = Util.getIntValue(request.getParameter("errorMessage"), 0);
	//System.out.println("errorMessage = " + errorMessage);
	if("save".equalsIgnoreCase(operationType)){
		int creatertype = Util.getIntValue(request.getParameter("creatertype"), 0);
		int wffield = Util.getIntValue(request.getParameter("wffield"), 0);
		if(creatertype == 0){
			wffield = 0;
		}
		sql = "update workflow_createtask set creatertype="+creatertype+", wffieldid="+wffield+" where id="+id;
		rs.execute(sql);
		String[] wtfieldids = request.getParameterValues("wtfieldid");
		String[] groupids = request.getParameterValues("groupid");
		if(wtfieldids!=null && groupids!=null){
			sql = "delete from workflow_createtaskdetail where createtaskid="+id;
			rs.execute(sql);
			sql = "delete from workflow_createtaskgroup where createtaskid="+id;
			rs.execute(sql);
			for(int i=0; i<groupids.length; i++){
				int groupid = Util.getIntValue(groupids[i], 0);
				int isused_tmp = Util.getIntValue(request.getParameter("isused_"+groupid), 0);
				sql = "insert into workflow_createtaskgroup (createtaskid, groupid, isused) values ("+id+", "+groupid+", "+isused_tmp+")";
				rs.execute(sql);
				for(int cx=0; cx<wtfieldids.length; cx++){
					String wt_id_tmp = wtfieldids[cx];
					String wffieldStr = Util.null2String(request.getParameter("wffield_"+wt_id_tmp+"_"+groupid));
					if("-1".equals(wffieldStr)){
						continue;
					}
					try{
						String[] wffieldStrs = Util.TokenizerString2(wffieldStr, "_");
						int wffieldid = Util.getIntValue(wffieldStrs[0], 0);
						int isdetail = Util.getIntValue(wffieldStrs[1], 0);
						int wffieldtype = Util.getIntValue(request.getParameter("wffieldtype_"+wt_id_tmp+"_"+groupid), 0);
						sql = "insert into workflow_createtaskdetail (createtaskid, wffieldid, isdetail, wtfieldid, groupid, wffieldtype) values ("+id+", "+wffieldid+", "+isdetail+", "+wt_id_tmp+", "+groupid+", "+wffieldtype+")";
						rs.execute(sql);
					}catch(Exception e){
						continue;
					}
				}
			}
		}
	}
    //response.sendRedirect("/workflow/workflow/CreateWorktaskByWorkflowDetail.jsp?id=id&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill+"&errorMessage="+errorMessage);
    response.sendRedirect("/workflow/workflow/CreateWorktaskByWorkflowDetail.jsp?ajax=1&id="+id+"&wfid="+workflowid);
%>