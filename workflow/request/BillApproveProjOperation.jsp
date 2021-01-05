
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WFManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.lang.* "%>
<%@ page import="java.net.*" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="RequestTransactionManager" class="weaver.workflow.request.RequestTransactionManager" scope="page"/>
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="RequestCheckAddinRules" class="weaver.workflow.request.RequestCheckAddinRules" scope="page"/>
<jsp:useBean id="ApproveParameter" class="weaver.workflow.request.ApproveParameter" scope="session"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>

<%

FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));

String isfromproj = Util.null2String(fu.getParameter("isfromproj"));
String isfromprojplan = Util.null2String(fu.getParameter("isfromprojplan"));

if(isfromprojplan.equals("1") || isfromproj.equals("1")){
	WFManager wfManager = new WFManager();
	wfManager.setWfid(workflowid);
	wfManager.getWfInfo();
	messageType = wfManager.getSmsAlertsType();
}

String ProcPara = "";
String ProjID = "";
ProjID = Util.null2String(fu.getParameter("ProjID"));


// added by lupeng 2004-07-29
String[] logParams;
WorkPlanLogMan logMan = new WorkPlanLogMan();
// end.

//int isfromdoc = Util.getIntValue(fu.getParameter("isfromdoc"),-1);         //是否从文档显示页面提交审批过来的

char flag = 2 ;
String Procpara = "" ;
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
int userid = user.getUID();
String logintype = user.getLogintype();
	//流程有时不能触发，怀疑是SESSION的客户端问题，故在这里初始化
if(src.equals("submit")&&iscreate.equals("1")) {//新建request时
    ApproveParameter.resetParameter();
    ApproveParameter.setWorkflowid(workflowid);
    ApproveParameter.setNodetype("0");
    ApproveParameter.setApproveid(Util.getIntValue(ProjID,-1));
    ApproveParameter.setApprovetype("11");
    ApproveParameter.setRequestname(requestname);
   
	String gopage = Util.null2String(fu.getParameter("gopage"));
	ApproveParameter.setGopage(gopage);	
}



if(src.equals("submit")&&iscreate.equals("1")) {//新建request时
	workflowid=ApproveParameter.getWorkflowid();
	formid=ApproveParameter.getFormid();
	requestname=ApproveParameter.getRequestname();
	nodeid=ApproveParameter.getNodeid();
	nodetype=ApproveParameter.getNodetype();
}

isbill=1;
if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}
if(remark.equals("")){
	remark = ResourceComInfo.getResourcename(""+user.getUID())+" "+CurrentDate ;
}

RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(fu) ;
RequestManager.setUser(user) ;
RequestManager.setRequestid(requestid);
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = true ;
if(!isfromproj.equals("1"))
    savestatus = RequestManager.saveRequestInfo() ;    //不是从文档显示页面提交审批过来的才作saveRequestInfo否则会由于文档显示页面没有单据的字段信息而被清空
else    RequestManager.setBilltablename("Bill_ApproveProj");

requestid = RequestManager.getRequestid() ;

if( !savestatus ) {
    if( requestid != 0 ) {

        String message=RequestManager.getMessage();
        if(!"".equals(message)){
			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}
if(ProjID.equals("")){
	billid = RequestManager.getBillid() ;
			RecordSet.executeSql("Select approveid from Bill_ApproveProj WHERE id="+billid);

			if(RecordSet.next())
				ProjID = RecordSet.getString("approveid");
}else{//在requestManager中用事务来操作，所以查询表Bill_ApproveProj时，审批项目未实际赋值，共享是找不到审批项目
	
    RecordSet.executeSql("update Bill_ApproveProj set ApproveID="+ProjID+" WHERE requestid="+requestid);
}

//td72276 项目经理字段更新
if(src.equals("submit")&&iscreate.equals("1")) {
	String approveid=ProjID;
	String manager="";
	if(!approveid.equals("")){
	       RecordSet.executeSql("Select manager From Prj_ProjectInfo Where id = "+approveid) ;
	        if (RecordSet.next())
	                 manager = RecordSet.getString("manager") ;
	        else manager = ""+user.getUID();
	    }

		String updateclause="set ";
	    updateclause+= "manager="+manager;
		updateclause="update Bill_ApproveProj "+updateclause+" where id = "+RequestManager.getBillid() ;;
		RecordSet.executeSql(updateclause);
}


RequestManager.setPrjids(ProjID);

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	ProjectInfoComInfo.removeProjectInfoCache();
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;
//Save data to Bill_ApproveProj 创建时
if(src.equals("submit")&&iscreate.equals("1")) {
	 
	billid = RequestManager.getBillid() ;
	String approveid=ApproveParameter.getApproveid()+"";
    if(Util.getIntValue(approveid)<=0){
        approveid=ProjID;
    }
	String gopage=ApproveParameter.getGopage();
    String manager = "";
    if(!approveid.equals("")){
       RecordSet.executeSql("Select manager From Prj_ProjectInfo Where id = "+approveid) ;
        if (RecordSet.next())
                 manager = RecordSet.getString("manager") ;
        else manager = ""+user.getUID();
    }

	String updateclause="set ";
    updateclause+= "approveid="+approveid+",manager="+manager;
	updateclause="update Bill_ApproveProj "+updateclause+" where id = "+billid;
	
	//System.out.println("billid = "+billid);
	//System.out.println("updateclause = "+updateclause);

	RecordSet.executeSql(updateclause);
	//更新项目的状态为立项审批
	RecordSet.executeSql("update Prj_ProjectInfo set status=6 ,requestid = "+RequestManager.getRequestid()+"where id = "+approveid);


	//Added by dongping for TD1278 start
	//desc 项目一旦被立项批准以后，存在着就不能再添加一级任务的问题
	if ("".equals(ProcPara)) {
		ProcPara=approveid;
	}
	//end

	
	/*Added By Charoes Huang For Bug 621,直接归档的项目也应该更新状态为立项批准*/		
	if(RequestManager.getNextNodetype().equals("3")){ 
		
		 /*审批通过到归档节点时，表示项目已经审批通过，可以更新项目状态以及插入任务计划到任务执行*/
		//System.out.println("Request agree:"+RequestManager.getNextNodetype());
		
	ProcPara=ProcPara+flag+""+RequestManager.getCreater()+flag+CurrentDate+flag+CurrentTime;
	RecordSet.executeProc("Prj_Plan_Approve",ProcPara);
	
	String tmpsql="update prj_taskprocess set isactived=2 where prjid="+ProjID ;
	RecordSet.executeSql(tmpsql);
	tmpsql = "update Prj_ProjectInfo set status = 5 where id = "+ ProjID;
	RecordSet.executeSql(tmpsql);
    
	//更新工作计划中该项目的经理的时间Begin
	String begindate01 = "";
	String enddate01 = "";

	RecordSet.executeProc("Prj_TaskProcess_Sum",""+ProjID);
	if(RecordSet.next() && !RecordSet.getString("workday").equals("")){

		if(!RecordSet.getString("begindate").equals("x")) begindate01 = RecordSet.getString("begindate");
		if(!RecordSet.getString("enddate").equals("-")) enddate01 = RecordSet.getString("enddate");
	
	}
	if (!begindate01.equals("")){
		RecordSet.executeSql("update workplan set status = '0',begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + ProjID + "' and taskid = -1");
	}
	//更新工作计划中该项目的经理的时间End

	//添加工作计划Begin
	String para = "";
	String workid = "";
	manager="";
	String TaskID="";
	RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
	if (RecordSet.next()){
		manager=RecordSet.getString("manager");
	}

	tmpsql = "SELECT * FROM Prj_TaskProcess WHERE prjid = " + ProjID + " and isdelete<>'1' order by id";
	RecordSet.executeSql(tmpsql);

	while (RecordSet.next()) 
	{	    	    	    
		TaskID = RecordSet.getString("id");
		
		//添加工作计划
   		WorkPlan workPlan = new WorkPlan();
   		
   		workPlan.setCreaterId(Integer.parseInt(manager));

   	    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_ProjectCalendar));        
   	    workPlan.setWorkPlanName(RecordSet.getString("subject"));    
   	    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
   	    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
   	    workPlan.setResourceId(RecordSet.getString("hrmid"));
   	    String beginDate = RecordSet.getString("begindate");
   	    if(null != beginDate && !"".equals(beginDate))
   	    {
			workPlan.setBeginDate(beginDate);
   	    }
   	    else
   	    {
   	    	workPlan.setBeginDate(CurrentDate);
   	    }
   	    workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间	    
   	    workPlan.setEndDate(RecordSet.getString("enddate"));
   	    workPlan.setEndTime(Constants.WorkPlan_EndTime);  //结束时间
   	    
   	 	String workPlanDescription = Util.null2String(RecordSet.getString("content"));
	    workPlanDescription = Util.replace(workPlanDescription, "\n", "", 0);
	    workPlanDescription = Util.replace(workPlanDescription, "\r", "", 0);
	    workPlan.setDescription(workPlanDescription);
   	    
   	    workPlan.setProject(ProjID);
   	    workPlan.setTask(TaskID);

   	    workPlanService.insertWorkPlan(workPlan);  //插入日程
		
   	    //插入日志
		logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, String.valueOf(userid), fu.getRemoteAddr()};	
		logMan.writeViewLog(logParams);
	}
	//添加工作计划End
	 }

	if(!gopage.equals(""))
	if(isfromprojplan.equals("1")){
		response.sendRedirect(gopage);
		ProjectInfoComInfo.removeProjectInfoCache();
		return;
	}else{
		out.print("<script>wfforward('"+gopage+"');</script>");
	}
}
/*审批通过时*/
//System.out.println("src = "+src);
//System.out.println("iscreate = "+iscreate);
if(src.equals("submit")&&iscreate.equals("0")){
	 billid = RequestManager.getBillid() ;
		RecordSet.executeSql("Select approveid from Bill_ApproveProj WHERE id="+billid);

		if(RecordSet.next())
			ProjID = RecordSet.getString("approveid");

		ProcPara = ProjID ;
		
	/*更新项目状态为待审批*/
		RecordSet.executeSql("update Prj_ProjectInfo set status = 6 where id = "+ ProjID);
		
	if(RequestManager.getNextNodetype().equals("3")){ 
		
		 /*审批通过到归档节点时，表示项目已经审批通过，可以更新项目状态以及插入任务计划到任务执行*/
		//System.out.println("Request agree:"+RequestManager.getNextNodetype());
		
	ProcPara=ProcPara+flag+""+RequestManager.getCreater()+flag+CurrentDate+flag+CurrentTime;
	RecordSet.executeProc("Prj_Plan_Approve",ProcPara);
	
	String tmpsql="update prj_taskprocess set isactived=2 where prjid="+ProjID ;
	RecordSet.executeSql(tmpsql);
	tmpsql = "update Prj_ProjectInfo set status = 5 where id = "+ ProjID;
	RecordSet.executeSql(tmpsql);
    
	//更新工作计划中该项目的经理的时间Begin
	String begindate01 = "";
	String enddate01 = "";

	RecordSet.executeProc("Prj_TaskProcess_Sum",""+ProjID);
	if(RecordSet.next() && !RecordSet.getString("workday").equals("")){

		if(!RecordSet.getString("begindate").equals("x")) begindate01 = RecordSet.getString("begindate");
		if(!RecordSet.getString("enddate").equals("-")) enddate01 = RecordSet.getString("enddate");
	
	}
	if (!begindate01.equals("")){
		RecordSet.executeSql("update workplan set status = '0',begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + ProjID + "' and taskid = -1");
	}
	//更新工作计划中该项目的经理的时间End

//====================================
//TD6720
//2007-5-31
String insertWorkPlan = "";
RecordSet.executeSql("SELECT b.insertWorkPlan FROM Prj_ProjectInfo a,Prj_ProjectType b WHERE a.prjtype=b.id AND a.id="+ProjID+"");
if(RecordSet.next()){
	insertWorkPlan = Util.null2String(RecordSet.getString("insertWorkPlan"));
}
//====================================
if(insertWorkPlan.equals("1")){

	//添加工作计划Begin
	String para = "";
	String workid = "";
	String manager="";
	String TaskID="";
	RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
	if (RecordSet.next()){
		manager=RecordSet.getString("manager");
	}

	tmpsql = "SELECT * FROM Prj_TaskProcess WHERE prjid = " + ProjID + " and isdelete<>'1' order by id";
	RecordSet.executeSql(tmpsql);

	while (RecordSet.next()) 
	{
		TaskID = Util.null2String(RecordSet.getString("id"));        
        //add by dongping for TD157
        //项目审批时，流程报错。
        if ("".equals(TaskID))
        {
            TaskID = "0" ;
        }
        
		//添加工作计划
   		WorkPlan workPlan = new WorkPlan();
   		
   		workPlan.setCreaterId(Integer.parseInt(manager));

   	    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_ProjectCalendar));        
   	    workPlan.setWorkPlanName(RecordSet.getString("subject"));    
   	    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
   	    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
   	    workPlan.setResourceId(RecordSet.getString("hrmid"));           	    
	   	 String beginDate = RecordSet.getString("begindate");
	   	 if(null != beginDate && !"".equals(beginDate))
	   	 {
	   	 	workPlan.setBeginDate(beginDate);
	   	 }
	   	 else
	   	 {
	   	 	workPlan.setBeginDate(CurrentDate);
	   	 }         	    
   	    workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间	    
   	    workPlan.setEndDate(RecordSet.getString("enddate"));
   	    workPlan.setEndTime(Constants.WorkPlan_EndTime);  //结束时间
   	    
   	 	String workPlanDescription = Util.null2String(RecordSet.getString("content"));
	    workPlanDescription = Util.replace(workPlanDescription, "\n", "", 0);
	    workPlanDescription = Util.replace(workPlanDescription, "\r", "", 0);
	    workPlan.setDescription(workPlanDescription);
   	    
   	    workPlan.setProject(ProjID);
   	    workPlan.setTask(TaskID);

   	    workPlanService.insertWorkPlan(workPlan);  //插入日程
		
   	    //插入日志
		logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, String.valueOf(userid), fu.getRemoteAddr()};	
		logMan.writeViewLog(logParams);
	}
	 
}

	}
	 
	 if(isfromproj.equals("1")){
		response.sendRedirect("/proj/data/ViewProject.jsp?ProjID="+ProjID);
		//out.print("<script>wfforward('/proj/data/ViewProject.jsp?ProjID="+ProjID+"');</script>");
	 }
}
/*审批拒绝时*/
if(src.equals("reject")&&iscreate.equals("0")){
	if(RequestManager.getNextNodetype().equals("0")){
		//System.out.println("Request reject:"+RequestManager.getNextNodetype());
		billid = RequestManager.getBillid() ;
		RecordSet.executeSql("Select approveid from Bill_ApproveProj WHERE id="+billid);

		if(RecordSet.next())
			ProjID = RecordSet.getString("approveid");
		
		//System.out.println("update Prj_ProjectInfo set status=7 where id ="+ProjID);
		RecordSet.executeSql("update Prj_ProjectInfo set status=7 where id ="+ProjID);
	}

	if(isfromproj.equals("1")){
		response.sendRedirect("/proj/data/ViewProject.jsp?ProjID="+ProjID);
		ProjectInfoComInfo.removeProjectInfoCache();
		//out.print("<script>wfforward('/proj/data/ViewProject.jsp?ProjID="+ProjID+"');</script>");
		return;
	}
}

if(src.equals("delete")&&iscreate.equals("0")){
	billid = RequestManager.getBillid() ;
		RecordSet.executeSql("Select approveid from Bill_ApproveProj WHERE id="+billid);

		if(RecordSet.next())
			ProjID = RecordSet.getString("approveid");

		RecordSet.executeSql("update Prj_ProjectInfo set status=7,requestid=0 where id ="+ProjID);
}

ProjectInfoComInfo.removeProjectInfoCache();
//response.sendRedirect("/workflow/request/RequestView.jsp");
 
//out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");



%><%@ include file="/workflow/request/RedirectPage.jsp" %> 