    <%@ page language="java" contentType="text/html; charset=GBK" %>
    <%@ page import="java.security.*,weaver.general.Util,weaver.general.TimeUtil" %>
    <%@ page import="java.util.*" %>
    <%@ page import="java.io.*" %>
    <%@ page import="java.sql.*" %>
   <%@ page import="java.math.BigDecimal" %>
    <%@ page import="weaver.general.SessionOper" %>
    <%@ include file="/systeminfo/init.jsp" %>
    <jsp:useBean id="workPlanShare" class="weaver.WorkPlan.WorkPlanShare" scope="page" />
    <jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rsf" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rsk" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rse" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="createWF" class="weaver.system.SysCreateWF" scope="page" />
    <jsp:useBean id="plan" class="weaver.hrm.performance.targetplan.PlanInfo" scope="page" />
    <jsp:useBean id="delalert" class="weaver.hrm.performance.DelAlertInfo" scope="page" />
    <jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
    <jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
    <jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
    <%
//================================================================================================
//TD
//added by hubo, 2006-10-16
String clientIP = request.getRemoteAddr();
String currentTime = TimeUtil.getCurrentTimeString();
boolean isApproved = false;
String _planDate = Util.null2String(request.getParameter("planDate"));
String _type = Util.null2String(request.getParameter("type"));
String _objId = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String _type_d = Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d"));
String _groupStatus = "";
rs.execute("select * from workPlanGroup where planDate='"+_planDate+"' and type_d='"+_type_d+"' and cycle='"+_type+"' and objId="+_objId);
if(rs.next()){
	if(rs.getString("status").equals("6")){isApproved = true;}
}
//================================================================================================
				
    String operationType=Util.null2String(request.getParameter("operationType"));
    String deptId="";
    String subCompany="";
    deptId=""+user.getUserDepartment();
    subCompany=""+user.getUserSubCompany1();
    String createtype=user.getLogintype();
    //计划的insert
    if (operationType.equals("planAdd")){


    //String id=plan.getMaxID("targetplanid");
    String mid=plan.getMaxID("plangroupid");
    String name=Util.fromScreen(request.getParameter("name"),user.getLanguage());
    String planDate=Util.null2String(request.getParameter("planDate"));
    String type=Util.null2String(request.getParameter("type"));
    String objId=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
	String type_d=Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
	String objName=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objName"));
    int nodesumd=Util.getIntValue(request.getParameter("nodesumd"),0);
    String nodesumu=Util.null2String(request.getParameter("nodesumu"));
    String createrid=""+user.getUID();
   
    String type_n=Util.null2String(request.getParameter("type_n"));
    String oppositeGoal=Util.null2o(request.getParameter("oppositeGoal"));
    String planProperty=Util.null2o(request.getParameter("planProperty"));
    String isremind=Util.null2String(request.getParameter("isremind"));
    String waketime=Util.null2o(request.getParameter("waketime"));
    String principal=Util.null2String(request.getParameter("principal"));
    String cowork=Util.null2String(request.getParameter("cowork"));
    String upPrincipals=Util.null2String(request.getParameter("upPrincipals"));
    String downPrincipals=Util.null2String(request.getParameter("downPrincipals"));
    String rbegindate=Util.null2String(request.getParameter("rbegindate"));
    String rbegintime=Util.null2String(request.getParameter("rbegintime"));
    String renddate=Util.null2String(request.getParameter("renddate"));
    String rendtime=Util.null2String(request.getParameter("rendtime"));
    String begindate=Util.null2String(request.getParameter("begindate"));
    String begintime=Util.null2String(request.getParameter("begintime"));
    String enddate=Util.null2String(request.getParameter("enddate"));
    String endtime=Util.null2String(request.getParameter("endtime"));
    String crmid=Util.null2String(request.getParameter("crmid"));
    String docid=Util.null2String(request.getParameter("docid"));
    String projectid=Util.null2String(request.getParameter("projectid"));
    String requestid=Util.null2String(request.getParameter("requestid"));
    String description=Util.null2String(request.getParameter("description"));
    String teamRequest=Util.null2String(request.getParameter("teamRequest"));
    String percent_n=Util.null2o(request.getParameter("percent_n"));
    String pName=Util.null2String(request.getParameter("pName"));
    String unitType = Util.null2String(request.getParameter("unittype"));
    if (isremind.equals("")) isremind="1";
    
   
    	if (isremind.equals("2")) {
		if (!waketime.equals("")) {
			BigDecimal b1 = new BigDecimal(waketime);
			float a1 = b1.setScale(1, BigDecimal.ROUND_HALF_UP).floatValue();
			int a2 = 1;
			if (unitType.equals("1"))
				a2 = 60;
			else
				a2 = 1440;

			waketime = String.valueOf(a1 * a2);
			if (waketime.indexOf(".") != -1)
				waketime = waketime.substring(0, waketime.indexOf("."));

		} else
			waketime = "0";

	} 
    rse.execute("select * from workPlanGroup where planDate='"+planDate+"' and type_d='"+type_d+"' and cycle='"+type+"' and objId="+objId );
    if (rse.next())
    {
    mid=rse.getString("id");
    }
    else
    {
    rs.execute("insert into workPlanGroup (id,planName,cycle,planDate,objId,status,type_d) values("+mid+",'"+pName+"','"+type+"','"+planDate+"',"+objId+",'3','"+type_d+"')");
    //删除提醒信息
    if (type_d.equals("3"))
    delalert.delAlert(Util.getIntValue(objId),type,planDate,1,"3");
    }
    
    rs.execute("insert into workPlan(groupId,type_n,name,cycle,planDate,planType,objId,createrid,resourceid,status,oppositeGoal,planProperty,isremind,waketime,principal,cowork,upPrincipal,downPrincipal,rbeginDate,rbeginTime,rendDate,rendTime,begindate,begintime,enddate,endtime,crmid,docid,projectid,requestid,description,percent_n,teamRequest,allShare,deptId,subcompanyId,createrType) values("+mid+",'6','"+name+"','"+type+"','"+planDate+"','"+type_d+"',"+objId+","+createrid+","+createrid+",'3',"+oppositeGoal+","+planProperty+","+isremind+","+waketime+",'"+principal+"','"+cowork+"','"+upPrincipals+"','"+downPrincipals+"','"+rbegindate+"','"+rbegintime+"','"+renddate+"','"+rendtime+"','"+begindate+"','"+begintime+"','"+enddate+"','"+endtime+"','"+crmid+"','"+docid+"','"+projectid+"','"+requestid+"','"+description+"','"+percent_n+"','"+teamRequest+"','1',"+deptId+","+subCompany+",'"+createtype+"') ");
    //out.print("insert into workPlan(groupId,type_n,name,cycle,planDate,planType,objId,createrid,resourceid,status,oppositeGoal,planProperty,isremind,waketime,principal,cowork,upPrincipal,downPrincipal,rbeginDate,rbeginTime,rendDate,rendTime,begindate,begintime,enddate,endtime,crmid,docid,projectid,requestid,description,percent_n,teamRequest,allShare,deptId,subcompanyId,createrType) values("+mid+",'6','"+name+"','"+type+"','"+planDate+"','"+type_d+"',"+objId+","+createrid+","+createrid+",'3',"+oppositeGoal+","+planProperty+","+isremind+","+waketime+",'"+principal+"','"+cowork+"','"+upPrincipals+"','"+downPrincipals+"','"+rbegindate+"','"+rbegintime+"','"+renddate+"','"+rendtime+"','"+begindate+"','"+begintime+"','"+enddate+"','"+endtime+"','"+crmid+"','"+docid+"','"+projectid+"','"+requestid+"','"+description+"',"+percent_n+",'"+teamRequest+"','1',"+deptId+","+subCompany+",'"+createtype+"') ");
    rs.execute("select max(id) from workPlan");
    rs.next();
    String id=rs.getString(1);
    
	//TD
	//added by hubo, 2006-10-16
	if(isApproved){
		rs.executeSql("UPDATE workPlan SET modifyStatus='1',modifyUser="+user.getUID()+" WHERE id="+Util.getIntValue(id)+"");
		rs.executeSql("INSERT INTO WorkplanRevision (planId,operator,operateTime,operateType,clientIP) VALUES ("+Util.getIntValue("id")+","+user.getUID()+",'"+currentTime+"','1','"+clientIP+"')");
	}

    //下游部门数据插入
    //out.print(nodesumd);
    for (int i=0;i<nodesumd;i++)
    {
    String objIds=Util.null2String(request.getParameter("downPrincipalhrm_"+i));
    rs.execute("insert into HrmPerformancePlanDown (planId,objId,status) values("+id+","+objIds+",'0')");
    }
    
    
    
    //共享
    workPlanShare.setShareDetail(id);
    //out.print("insert into workPlan(id,type_n,name,objId,status,oppositeGoal,planProperty,isremind,waketime,principal,cowork,upPrincipal,downPrincipal,rBeginDate,rBeginTime,rEndDate,rEndTime,begindate,begintime,enddate,endtime,crmid,docid,projectid,requestid,description) values("+id+",'6','"+name+"',"+objId+",'3',"+oppositeGoal+",'"+planProperty+"',"+isremind+","+waketime+",'"+principal+"','"+cowork+"','"+upPrincipals+"','"+downPrincipals+"','"+rbegindate+"','"+rbegintime+"','"+renddate+"','"+rendtime+"','"+begindate+"','"+begintime+"','"+enddate+"','"+endtime+"','"+crmid+"','"+docid+"','"+projectid+"','"+requestid+"','"+description+"') ");
    //response.sendRedirect("PlanEdit.jsp?id="+id+"&type="+type+"&planDate="+planDate);
    out.print("<script>history.go(-2);</script>");
    }
    //计划的update
    if (operationType.equals("planEdit")){
    String from=request.getParameter("from");
    String id=request.getParameter("id");
    String name=Util.fromScreen(request.getParameter("name"),user.getLanguage());
    String planDate=Util.null2String(request.getParameter("planDate"));
    String type=Util.null2String(request.getParameter("type"));
    //String objId=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
	//String type_d=Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
	//String objName=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objName"));
    int nodesumd=Util.getIntValue(request.getParameter("nodesumd"),0);
    String nodesumu=Util.null2String(request.getParameter("nodesumu"));
    //String createrid=""+user.getUID();
    String type_n=Util.null2String(request.getParameter("type_n"));
    String oppositeGoal=Util.null2o(request.getParameter("oppositeGoal"));
    String planProperty=Util.null2o(request.getParameter("planProperty"));
    String isremind=Util.null2String(request.getParameter("isremind"));
    String waketime=Util.null2o(request.getParameter("waketime"));
    String principal=Util.null2String(request.getParameter("principal"));
    String cowork=Util.null2String(request.getParameter("cowork"));
    String upPrincipals=Util.null2String(request.getParameter("upPrincipals"));
    String downPrincipals=Util.null2String(request.getParameter("downPrincipals"));
    String rbegindate=Util.null2String(request.getParameter("rbegindate"));
    String rbegintime=Util.null2String(request.getParameter("rbegintime"));
    String renddate=Util.null2String(request.getParameter("renddate"));
    String rendtime=Util.null2String(request.getParameter("rendtime"));
    String begindate=Util.null2String(request.getParameter("begindate"));
    String begintime=Util.null2String(request.getParameter("begintime"));
    String enddate=Util.null2String(request.getParameter("enddate"));
    String endtime=Util.null2String(request.getParameter("endtime"));
    String crmid=Util.null2String(request.getParameter("crmid"));
    String docid=Util.null2String(request.getParameter("docid"));
    String unitType=Util.null2String(request.getParameter("unittype"));
    String projectid=Util.null2String(request.getParameter("projectid"));
    String requestid=Util.null2String(request.getParameter("requestid"));
    String description=Util.null2String(request.getParameter("description"));
    String percent_n=Util.null2o(request.getParameter("percent_n"));
    String teamRequest=Util.null2String(request.getParameter("teamRequest"));
   // out.print(teamRequest);
     if (isremind.equals("")) isremind="1";
    
    	if (isremind.equals("2")) {
		if (!waketime.equals("")) {
			BigDecimal b1 = new BigDecimal(waketime);
			float a1 = b1.setScale(1, BigDecimal.ROUND_HALF_UP).floatValue();
			int a2 = 1;
			if (unitType.equals("1"))
				a2 = 60;
			else
				a2 = 1440;

			waketime = String.valueOf(a1 * a2);
			if (waketime.indexOf(".") != -1)
				waketime = waketime.substring(0, waketime.indexOf("."));

		} else
			waketime = "0";

	} 

	//TD
	//added by hubo, 2006-10-16
	if(isApproved){
		rs.executeSql("UPDATE workPlan SET modifyStatus='2',modifyUser="+user.getUID()+" WHERE id="+id+"");
		rs.executeSql("INSERT INTO WorkplanRevision (planId,operator,operateTime,operateType,clientIP) VALUES ("+Util.getIntValue(id)+","+user.getUID()+",'"+currentTime+"','2','"+clientIP+"')");
		rs.executeSql("INSERT INTO WorkplanRevisionLog SELECT * FROM workplan WHERE id="+id+"");
	}

    rs.execute("update workPlan set name='"+name+"',oppositeGoal="+oppositeGoal+",planProperty="+planProperty+",isremind="+isremind+",waketime="+waketime+",principal='"+principal+"',cowork='"+cowork+"',upPrincipal='"+upPrincipals+"',downPrincipal='"+downPrincipals+"',rbeginDate='"+rbegindate+"',rbeginTime='"+rbegintime+"',rendDate='"+renddate+"',rendTime='"+rendtime+"',begindate='"+begindate+"',begintime='"+begintime+"',enddate='"+enddate+"',endtime='"+endtime+"',crmid='"+crmid+"',docid='"+docid+"',projectid='"+projectid+"',requestid='"+requestid+"',description='"+description+"',teamRequest='"+teamRequest+"',percent_n='"+percent_n+"' where id="+id);	

    String objIdss="";
    workPlanShare.setShareDetail(id);
    //下游部门数据插入(删除)
    rse.execute("delete from HrmPerformancePlanDown where planId="+id);
    for (int i=0;i<nodesumd;i++)
    {
    String objIds=Util.null2String(request.getParameter("downPrincipalhrm_"+i));
   // objIdss=objIdss+objId+",";
    if (from.equals("list"))
    {
    rs.execute("insert into HrmPerformancePlanDown(planId,objId,status) values("+id+","+objIds+",'1')");
    }
    else
    {
    rs.execute("insert into HrmPerformancePlanDown(planId,objId,status) values("+id+","+objIds+",'0')");
    }
    }
    
     //关键插入
    int rownum = Util.getIntValue(request.getParameter("rownum"));
	String keyName = "";
	int viewSort = 0;
	String sql="";
	String sql1="";
	//out.println(rownum);
	sql1="delete from HrmPerformancePlanKey where planId="+id;
	rs.executeSql(sql1);
	for(int i=0;i<rownum;i++){
		keyName = Util.null2String(request.getParameter("keyName_"+i));
		viewSort = Util.getIntValue(request.getParameter("viewSort_"+i),0);
		
		sql = "INSERT INTO HrmPerformancePlanKey  VALUES ("+id+",'"+keyName+"',"+viewSort+")";
		//out.println(sql);
		
		rs.executeSql(sql);
	}
    //成果插入
    int rownum1 = Util.getIntValue(request.getParameter("rownum1"));
	String effortName = "";
	int viewSort1 = 0;
	 sql="";
	 sql1="";
	//out.println(rownum);
	sql1="delete from HrmPerformancePlanEffort where planId="+id;
	rs.executeSql(sql1);
	for(int i=0;i<rownum1;i++){
		effortName = Util.null2String(request.getParameter("effortName_"+i));
		viewSort1 = Util.getIntValue(request.getParameter("viewSort1_"+i),0);
		
		sql = "INSERT INTO HrmPerformancePlanEffort  VALUES ("+id+",'"+effortName+"',"+viewSort1+")";
		//out.println(sql);
		
		rs.executeSql(sql);
	}
	//out.print(sql);
    if (from.equals("list"))
    {
    String gid=request.getParameter("groupId");
    response.sendRedirect("PlanList.jsp?id="+gid);
    }
    else
    {
    String urls="MyPlan.jsp?type="+type;
    if (type.equals("0"))
	{
	String years=planDate.substring(0,4);
	urls=urls+"&years="+years;
	}
	else if (type.equals("2"))
	{
	String years=planDate.substring(0,4);
	String months=planDate.substring(4,planDate.length());
	urls=urls+"&years="+years+"&months="+months;
	}
	else if (type.equals("1"))
	{
	String years=planDate.substring(0,4);
	String quarters=planDate.substring(4,planDate.length());
	urls=urls+"&years="+years+"&quarters="+quarters;
	
	}
	else if (type.equals("3"))
	{
	String years=planDate.substring(0,4);
	String weeks=planDate.substring(4,planDate.length());
	urls=urls+"&years="+years+"&weeks="+weeks;
	
	}
    response.sendRedirect(urls);
    }
    }
    //工作关键点的insert
    if (operationType.equals("KeyAdd")){
    String from=Util.null2String(request.getParameter("from"));
    String viewSort=Util.null2String(request.getParameter("viewSort"));
    String keyName=Util.fromScreen(request.getParameter("keyName"),user.getLanguage());
    String id=Util.null2String(request.getParameter("id"));
    String planDate=Util.null2String(request.getParameter("planDate"));
    String type=Util.null2String(request.getParameter("type"));
    rs.execute("insert into  HrmPerformancePlanKey  values("+id+",'"+keyName+"',"+viewSort+") ");
    
    response.sendRedirect("PlanEdit.jsp?id="+id+"&type="+type+"&planDate="+planDate+"&from="+from);
    }
     //工作关键点的update
    if (operationType.equals("KeyEdit")){
    String from=Util.null2String(request.getParameter("from"));
    String viewSort=Util.null2String(request.getParameter("viewSort"));
    String keyName=Util.fromScreen(request.getParameter("keyName"),user.getLanguage());
    String id=Util.null2String(request.getParameter("id"));
    String did=Util.null2String(request.getParameter("did"));
    String planDate=Util.null2String(request.getParameter("planDate"));
    String type=Util.null2String(request.getParameter("type"));
    rs.execute("update  HrmPerformancePlanKey  set keyName='"+keyName+"',viewSort="+viewSort+" where id="+did);
    response.sendRedirect("PlanEdit.jsp?id="+id+"&type="+type+"&planDate="+planDate+"&from="+from);
    }
    
    //工作成果的insert
    if (operationType.equals("EffortAdd")){
    String from=Util.null2String(request.getParameter("from"));
    String viewSort=Util.null2String(request.getParameter("viewSort"));
    String effortName=Util.fromScreen(request.getParameter("effortName"),user.getLanguage());
    String id=Util.null2String(request.getParameter("id"));
    String planDate=Util.null2String(request.getParameter("planDate"));
    String type=Util.null2String(request.getParameter("type"));
    rs.execute("insert into  HrmPerformancePlanEffort  values("+id+",'"+effortName+"',"+viewSort+") ");
    response.sendRedirect("PlanEdit.jsp?id="+id+"&type="+type+"&planDate="+planDate+"&from="+from);
    }
     //工作成果的update
    if (operationType.equals("EffortEdit")){
   String from=Util.null2String(request.getParameter("from"));
    String viewSort=Util.null2String(request.getParameter("viewSort"));
    String effortName=Util.fromScreen(request.getParameter("effortName"),user.getLanguage());
    String id=Util.null2String(request.getParameter("id"));
    String did=Util.null2String(request.getParameter("did"));
    String planDate=Util.null2String(request.getParameter("planDate"));
    String type=Util.null2String(request.getParameter("type"));
    rs.execute("update  HrmPerformancePlanEffort set effortName='"+effortName+"',viewSort="+viewSort+" where id="+did);
    response.sendRedirect("PlanEdit.jsp?id="+id+"&type="+type+"&planDate="+planDate+"&from="+from);
    }
    //递交审批
    if (operationType.equals("check")){
    int createrid=0;
    String planDate=Util.null2String(request.getParameter("planDate"));
    String type=Util.null2String(request.getParameter("type"));
    String objId=""+SessionOper.getAttribute(session,"hrm.objId");
    String type_d=Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
    int flowId=0;
    //新的方法得到审批流程
    String objIds=objId;
    if (type_d.equals("3")) objIds=""+resourceComInfo.getDepartmentID(objId);
    String sql = "SELECT planFlowId FROM HrmPerformanceCheckFlow WHERE objId="+objIds+" AND objType='"+type_d+"'";
    //rs.execute("select relatingFlow from HrmPerformanceFlow where type_1='1'");
    rs.execute(sql);
    if (rs.next())
    {
    flowId=rs.getInt(1);
    }
    else
    {
    out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18268,user.getLanguage())+"');history.back(-1);</script>");
    return;
    }
    if(flowId==-1) 
    {
    out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18268,user.getLanguage())+"');history.back(-1);</script>");
    return;
    }
   //先确认计划权重和是100
    if (rse.getDBType().equals("oracle"))
     rse.execute("select sum(percent_n) from WorkPlan where planDate='"+planDate+"' and planType='"+type_d+"' and cycle='"+type+"' and objId="+objId);
    else if (rse.getDBType().equals("db2"))
     rse.execute("select sum(double(float)) from WorkPlan where planDate='"+planDate+"' and planType='"+type_d+"' and cycle='"+type+"' and objId="+objId);
    else
     rse.execute("select sum(convert(float,percent_n)) from WorkPlan where planDate='"+planDate+"' and planType='"+type_d+"' and cycle='"+type+"' and objId="+objId);
     if (rse.next())
     {
        if (rse.getFloat(1)!=100)
        {
         out.print("<script> alert('"+SystemEnv.getHtmlLabelName(18212,user.getLanguage())+"');</script>");
         out.print("<script>history.back(-1);</script>");
         return;
        }
     }
     rse.execute("select * from HrmPerformancePlanDown a left join WorkPlan b ON a.planId = b.id where b.planDate='"+planDate+"' and b.planType='"+type_d+"' and b.cycle='"+type+"' and b.objId="+objId);
     //有下游,等下游确认后直接进入审批
    if (rse.next())
    {
    rs.execute("update workPlanGroup set status='4' where planDate='"+planDate+"' and cycle='"+type+"' and type_d='"+type_d+"' and objId="+objId);
    rs.execute("update workPlan set status='4' where planDate='"+planDate+"' and cycle='"+type+"' and planType='"+type_d+"' and objId="+objId);
    }
    else //无下游，生成审批流程
    {
    
    //生成审批流程
    //如果是退回计划重新递交不需要重新生成
    
    String requestName="";
    int requestId=0;
    ArrayList planGroupId=new ArrayList();
    rse.execute("select * from workPlanGroup where planDate='"+planDate+"' and cycle='"+type+"' and type_d='"+type_d+"' and objId="+objId);
    if (rse.next())
    {
    requestName=rse.getString("planName");
    planGroupId.add(rse.getString("id"));
    requestId=Util.getIntValue(rse.getString("requestId"),0);
    }
    
    requestName=requestName+"审批";
    
    if (requestId==0)//新建流程
    {
     try{
     	 createWF.setUser(user);
         requestId=createWF.setWorkflowInfo(flowId,requestName,user.getUID(),planGroupId);
		}catch(Exception e){
			out.println("<div style='color:red;font-size:12px'>"+SystemEnv.getHtmlLabelName(16333,user.getLanguage())+"!</div>");
			return;
		}
    if (requestId!=0)
    {
    rs.execute("update workPlanGroup set requestId="+requestId+" , status='5' where planDate='"+planDate+"' and cycle='"+type+"' and type_d='"+type_d+"' and objId="+objId);
    rs.execute("update workPlan set status='5' where planDate='"+planDate+"' and cycle='"+type+"' and planType='"+type_d+"' and objId="+objId);
    }
    else
    { 
    out.print("<script>alert('"+SystemEnv.getHtmlLabelName(15413,user.getLanguage())+SystemEnv.getHtmlLabelName(15058,user.getLanguage())+SystemEnv.getHtmlLabelName(498,user.getLanguage())+"');</script>");
    }
    }
    else  //流程流向下一节点
    {
    //准备流程参数
    String src = "submit";
	String iscreate = "0";
	int requestid = requestId;
	int workflowid = flowId;
	String workflowtype = "";
	int isremark = 0;
	int formid = 0;
	int isbill = 1;
	int billid = -1;
	int nodeid =-1;
	String nodetype = "";
	String requestname =Util.toScreenToEdit(requestName,user.getLanguage());
	String requestlevel = "";
	String messageType = "0";
	String remark = "";
	 rsf.execute("select messageType,workflowtype,formid from workflow_base where id="+workflowid);
	 if (rsf.next())
	 {
	
	 workflowtype=rsf.getString("workflowtype");
	 billid=rsf.getInt("formid");
	 }
	 rsf.execute("select messageType,currentnodeid,currentnodetype,requestlevel,creater from workflow_requestbase where requestid="+requestid);
	 if (rsf.next())
	 {
	 createrid=rsf.getInt("creater");
	 messageType=rsf.getString("messageType");
	 requestlevel=rsf.getString("requestlevel");
	 nodetype=rsf.getString("currentnodetype");
	 nodeid=rsf.getInt("currentnodeid");
	 }
	 formid=billid;
	 rs.execute("update workPlanGroup set  status='5' where planDate='"+planDate+"' and cycle='"+type+"' and type_d='"+type_d+"' and objId="+objId);
     rs.execute("update workPlan set status='5' where planDate='"+planDate+"' and cycle='"+type+"' and planType='"+type_d+"' and objId="+objId);
	   //准备流程参数结束
	 String url="/workflow/request/BillBPMApprovePlanOperation.jsp?"+
	 "planDate="+planDate+"&type="+type+"&src="+src+"&iscreate="+iscreate+"&requestid="+requestid+"&"+
	 "workflowid="+workflowid+"&workflowtype="+workflowtype+""+
	 "&isremark="+isremark+"&formid="+formid+"&isbill="+isbill+"&billid="+billid+"&"+
	 "nodeid="+nodeid+"&users="+createrid+"&"+
	 "nodetype="+nodetype+"&requestlevel="+requestlevel+"&messageType="+messageType+"&remark="+remark+"&from=1";
     //out.print(url);
	 response.sendRedirect(url);
	  return;
	
    }
    }
    
    out.print("<script>history.back(-1);</script>");
    }
    //下游确认
    if (operationType.equals("confirm")){
    String type_d=Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
    String planDate=Util.null2String(request.getParameter("planDate"));
    String type=Util.null2String(request.getParameter("type"));
    String objId=""+SessionOper.getAttribute(session,"hrm.objId");
    String id=Util.null2String(request.getParameter("id"));
    String did=Util.null2String(request.getParameter("did"));
    String sta="";
    if (rs.execute("update HrmPerformancePlanDown set status='1' where id="+did))
    {//判断是否所有下游都已确认
          rse.execute("select status from HrmPerformancePlanDown where planId="+id);
          
          while (rse.next())
          {
          sta=rse.getString(1);
          if (sta.equals("0"))
          {break;}
          }
         
          if (sta.equals("1"))
          {
          rs.execute("update workPlan set status='5' where id="+id); 
          }
     //判断是否该周期所有计划的所有下游都已确认
           sta="";
           String groupId="";
           int createrid=0;
           rse.execute("select groupId,status,createrid from workPlan where planDate='"+planDate+"' and cycle='"+type+"' and planType=(select planType from workPlan where id="+id+") and objId=(select objId from workPlan where id="+id+") and id in (select planId from HrmPerformancePlanDown)");
          
           while (rse.next())
           {groupId=rse.getString(1);
            sta=rse.getString(2);
            createrid=rse.getInt(3);
           if (!sta.equals("5"))
           {break;}
           }
          
          if (sta.equals("5"))
          {
              
		    //生成审批流程
		    //如果是退回计划重新递交不需要重新生成
		    int flowId=0;
		    String requestName="";
		    int requestId=0;
		    ArrayList planGroupId=new ArrayList();
		    rse.execute("select * from workPlanGroup where id="+groupId);
		    if (rse.next())
		    {
		    requestName=rse.getString("planName");
		    planGroupId.add(rse.getString("id"));
		    requestId=Util.getIntValue(rse.getString("requestId"),0);
		    }
		    requestName=requestName+"审批";
		    //新的方法得到审批流程
		    String objIds=objId;
            String planType="";
            rs.execute("select objId,createrid,planType from workPlan where id="+id);
            rs.next();
            objIds=rs.getString(1);
            planType=rs.getString(3);
            if (planType.equals("3")) objIds=""+resourceComInfo.getDepartmentID(objIds);
            String sql = "SELECT planFlowId FROM HrmPerformanceCheckFlow WHERE objId="+objIds+" AND objType='"+planType+"'";
		    //rs.execute("select relatingFlow from HrmPerformanceFlow where type_1='1'");
		    rs.execute(sql);
		    if (rs.next())
		    {
		    flowId=rs.getInt(1);
		    }
		    else
		    {
		    out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18268,user.getLanguage())+"');history.back(-1);</script>");
		    return;
		    }
		     if(flowId==-1) 
		    {
		    out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18268,user.getLanguage())+"');history.back(-1);</script>");
		    return;
		    }
		    if (requestId==0)
		    {
		    try
		    {
		    	createWF.setUser(user);
		    requestId=createWF.setWorkflowInfo(flowId,requestName,createrid,planGroupId);
		    }catch(Exception e1){
		     rs.execute("update workPlan set status='4' where id="+id); 
		     rs.execute("update HrmPerformancePlanDown set status='0' where id="+did);
			out.println("<div style='color:red;font-size:12px'>"+SystemEnv.getHtmlLabelName(16333,user.getLanguage())+"!</div>");
			return;
		    }
		    if (requestId!=0)
		    {
		    rs.execute("update workPlanGroup set requestId="+requestId+" , status='5' where id="+groupId );
		   
		    }
		    else
		    { 
		    out.print("<script>alert('"+SystemEnv.getHtmlLabelName(15413,user.getLanguage())+SystemEnv.getHtmlLabelName(15058,user.getLanguage())+SystemEnv.getHtmlLabelName(498,user.getLanguage())+"');</script>");
		    }
		    }
		     else  //流程流向下一节点  
		    {
		    //准备流程参数
		    String src = "submit";
			String iscreate = "0";
			int requestid = requestId;
			int workflowid = flowId;
			String workflowtype = "";
			int isremark = 0;
			int formid = 0;
			int isbill = 1;
			int billid = -1;
			int nodeid =-1;
			String nodetype = "";
			String requestname = requestName;
			String requestlevel = "";
			String messageType = "0";
			String remark = "";
			 rsf.execute("select messageType,workflowtype,formid from workflow_base where id="+workflowid);
			 if (rsf.next())
			 {
			
			 workflowtype=rsf.getString("workflowtype");
			 billid=rsf.getInt("formid");
			 }
			 rsf.execute("select messageType,currentnodeid,currentnodetype,requestlevel,creater from workflow_requestbase where requestid="+requestid);
			 if (rsf.next())
			 {
			 messageType=rsf.getString("messageType");
			 requestlevel=rsf.getString("requestlevel");
			 nodetype=rsf.getString("currentnodetype");
			 nodeid=rsf.getInt("currentnodeid");
			 createrid=rsf.getInt("creater");
			 }
			 formid=billid;

			   //准备流程参数结束
			 rs.execute("update workPlanGroup set  status='5' where id="+groupId );
			 String url="/workflow/request/BillBPMApprovePlanOperation.jsp?"+
			 "type="+type+"&planDate="+planDate+"&users="+createrid+"&src="+src+"&iscreate="+iscreate+"&requestid="+requestid+"&"+
			 "workflowid="+workflowid+"&workflowtype="+workflowtype+""+
			 "&isremark="+isremark+"&formid="+formid+"&isbill="+isbill+"&billid="+billid+"&"+
			 "nodeid="+nodeid+"&"+
			 "nodetype="+nodetype+"&requestlevel="+requestlevel+"&messageType="+messageType+"&remark="+remark+"&from=1";
			  response.sendRedirect(url);
			  //out.print(url);
			  return;
			
		    }
		    
          }
           
     }
     out.print("<script>history.back(-1);</script>");
    }
    
     if (operationType.equals("choosePlan")) //选择计划
     {
     String planDate=Util.null2String(request.getParameter("planDate"));
     String type=Util.null2String(request.getParameter("type"));
     String type_d=Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
     String objId=""+SessionOper.getAttribute(session,"hrm.objId");
     String str="";
     String id="";
     String cols="";
     String para="";
     String planId="";
     String objName="";
     String depId=Util.null2String(request.getParameter("depId"));
     String braId=Util.null2String(request.getParameter("braId"));
     String importType=Util.null2String(request.getParameter("importType"));
     String mid=plan.getMaxID("plangroupid");
     String pName=Util.null2String(request.getParameter("pName"));
     String pName1=Util.null2String(request.getParameter("pName1"));
     //从计划中直接倒入上级计划 
     if (importType.equals("1"))
     {
     if (type_d.equals("3"))
     {
     objId=depId;
     type_d="2";
     objName=DepartmentComInfo.getDepartmentname(objId);
     pName=objName+pName1;
     }
     else if (type_d.equals("2"))
     {
     objId=braId;
     type_d="1";
     objName=SubCompanyComInfo.getSubCompanyname(objId);
     pName=objName+pName1;
     }
     SessionOper.setAttribute(session,"hrm.type_d",type_d);
     SessionOper.setAttribute(session,"hrm.objId",objId);
     SessionOper.setAttribute(session,"hrm.objName",objName);
     }
      //从计划中直接倒入上级计划 结束
    
     rse.execute("select * from workPlanGroup where planDate='"+planDate+"' and type_d='"+type_d+"' and cycle='"+type+"' and objId="+objId );
     if (rse.next())
     {
     mid=rse.getString("id");
     }
     else
     {
     rs.execute("insert into workPlanGroup (id,planName,cycle,planDate,objId,status,type_d) values("+mid+",'"+pName+"','"+type+"','"+planDate+"',"+objId+",'3','"+type_d+"')");
     }
     String checkplan[] = request.getParameterValues("checkplan");
     for(int a = 0;a<checkplan.length;a++){
		if(a == checkplan.length-1)
			str = str+"'"+checkplan[a]+"'";
		else
		   str = str+"'"+checkplan[a]+"'"+",";
		}
    
     rse.execute("select * from workPlan where id in ("+str+") " );
     while (rse.next())
     { cols="";
      para="";
      planId="";
     //id=plan.getMaxID("targetplanid");

     for (int i=1;i<=rse.getColCounts();i++)
      {
      if (!rse.getColumnName(i).equalsIgnoreCase("id"))
      {
      if (cols.equals("")) cols=rse.getColumnName(i);
      else  cols=cols+","+rse.getColumnName(i);
      }
      if (rse.getColumnName(i).equalsIgnoreCase("id"))
      {
     // if (para.equals("")) para=para+""+id;
     // else para=para+","+id;
      para=para;
      }
      else if (rse.getColumnName(i).equalsIgnoreCase("objId"))
      {
      if (para.equals("")) para=para+""+objId;
      else para=para+","+objId;
      }
      else if (rse.getColumnName(i).equalsIgnoreCase("planType"))
      {
      if (para.equals("")) para=para+""+type_d;
      else para=para+","+type_d;
      }
      else if (rse.getColumnName(i).equalsIgnoreCase("status"))
      {
      String st="3";
      if (para.equals("")) para=para+"'"+st+"'";
      else para=para+",'"+st+"'";
      }
      else if (rse.getColumnName(i).equalsIgnoreCase("groupId"))
      {
      if (para.equals("")) para=para+""+mid;
      else para=para+","+mid;
      }
      else
      {
      if (rse.getColumnType()[i-1]==Types.INTEGER)
      {
      if (para.equals("")) para=""+rse.getInt(rse.getColumnName(i));
      else para=para+","+rse.getInt(rse.getColumnName(i));
      }
      else
      {
      if (para.equals("")) para=" '"+rse.getString(rse.getColumnName(i))+"' ";
      else para=para+", '"+rse.getString(rse.getColumnName(i))+"' ";
      }
      }
    
     }
     planId=rse.getString("id");
    
     if (rs.execute("insert into workPlan ("+ cols +" ) values ("+para+") "))
     {
     rsk.execute("select max(id) from workPlan");
     rsk.next();
     id=rsk.getString(1);
     rsd.execute("select * from HrmPerformancePlanKey where planId="+planId);

     while (rsd.next())
     {
     rs.execute("insert into HrmPerformancePlanKey (planId,keyName,viewSort) values("+id+","+rsd.getString("keyName")+",'"+rsd.getString("viewSort")+"')");
     }
   
     rsd.execute("select * from HrmPerformancePlanEffort where planId="+planId);
     while (rsd.next())
     {
     rs.execute("insert into HrmPerformancePlanEffort (planId,effortName,viewSort) values("+id+","+rsd.getString("effortName")+",'"+rsd.getString("viewSort")+"')");
     }
     
     rsd.execute("select * from HrmPerformancePlanDown where planId="+planId); 
     while (rsd.next())
     {
     rs.execute("insert into HrmPerformancePlanDown (planId,objId,status) values("+id+","+rsd.getString("objId")+",'0')");
     }
     
     }
    // out.print("insert into workPlan ("+ cols +" ) values ("+para+") ");
     }
      if (importType.equals("1"))
     {
     out.print("<script>history.go(-1);</script>");
     }
     else
     {
     out.print("<script>history.go(-2);</script>");
     }
     }
     
      if (operationType.equals("unite")) //合并计划
      {
        String checkplan[] = request.getParameterValues("checkplan");
        String cowork="";
        String principal="";
        String teamRequest="";
        String upPrincipal="";
        String begindate="";
        String begintime="";
        String rbeginDate="";
        String rendDate="";
        String enddate="";
        String endtime="";
        String rendTime="";
        String rbeginTime="";
        String description="";
        String docids="";
        String crmids="";
        String projectids="";
        String requestids="";
        String planName="";
        String mid="";
        String isremind="";
        String waketime="";
        String planDate=Util.null2String(request.getParameter("planDate"));
        String type=Util.null2String(request.getParameter("type"));
        String objId=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
	    String type_d=Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
	    String objName=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objName"));
        String id="";
        //=plan.getMaxID("targetplanid");
        String createrid=""+user.getUID();
        String planProperty="";
        String oppositeGoal="";
        String resourceid="";
        String str="";
        String coworka="";
        String principala="";
        for(int a = 0;a<checkplan.length;a++){
		if(a == checkplan.length-1)
			str = str+"'"+checkplan[a]+"'";
		else
		   str = str+"'"+checkplan[a]+"'"+",";
		}
		rse.execute("select * from workPlan where id in ("+str+")");
		while (rse.next())
		{ 
		 coworka=Util.null2String(rse.getString("cowork"));
		 if (!coworka.equals(""))
		 {
		 ArrayList coworks = Util.TokenizerString(coworka, ",");
		 for (int j=0;j<coworks.size();j++)
		 {
		 if (cowork.indexOf(""+coworks.get(j))<0)
		 {
         if (cowork.equals("")) cowork=""+coworks.get(j);
         else cowork=cowork+","+coworks.get(j);
         }
         }
		 }
		
		 principala=Util.null2String(rse.getString("principal"));
		 if (!principala.equals(""))
		 {
		 ArrayList principals = Util.TokenizerString(principala, ",");
		 for (int k=0;k<principals.size();k++)
		 {
		 if (principal.indexOf(""+principals.get(k))<0)
		 {
         if (principal.equals("")) principal=""+principals.get(k);
         else principal=principal+","+principals.get(k);
         }
         }
         }
         if (!Util.null2String(rse.getString("teamRequest")).equals("")) teamRequest=teamRequest+Util.null2String(rse.getString("teamRequest"))+",";
         upPrincipal="";
        
         begindate=Util.null2String(rse.getString("begindate"));
         begintime=Util.null2String(rse.getString("begintime"));
         rbeginDate=Util.null2String(rse.getString("rbeginDate"));
         rendDate=Util.null2String(rse.getString("rendDate"));
         enddate=Util.null2String(rse.getString("enddate"));
         endtime=Util.null2String(rse.getString("endtime"));
         rendTime=Util.null2String(rse.getString("rendTime"));
         rbeginTime=Util.null2String(rse.getString("rbeginTime"));
         if (!Util.null2String(rse.getString("description")).equals("")) description=description+Util.null2String(rse.getString("description"))+",";
         //principala=Util.null2String(rse.getString("principal"));
		 if (!Util.null2String(rse.getString("docid")).equals(""))
		 {
		 ArrayList docidss = Util.TokenizerString(Util.null2String(rse.getString("docid")), ",");
		 for (int k=0;k<docidss.size();k++)
		 {
		 if (docids.indexOf(""+docidss.get(k))<0)
		 {
         if (docids.equals("")) docids=""+docidss.get(k);
         else docids=docids+","+docidss.get(k);
         }
         }
         }
        
         if (!Util.null2String(rse.getString("crmid")).equals(""))
		 {
		 ArrayList crmidss = Util.TokenizerString(Util.null2String(rse.getString("crmid")), ",");
		 for (int k=0;k<crmidss.size();k++)
		 {
		 if (crmids.indexOf(""+crmidss.get(k))<0)
		 {
         if (crmids.equals("")) crmids=""+crmidss.get(k);
         else crmids=crmids+","+crmidss.get(k);
         }
         }
         }
         if (!Util.null2String(rse.getString("projectid")).equals(""))
		 {
		 ArrayList projectidss = Util.TokenizerString(Util.null2String(rse.getString("projectid")), ",");
		 for (int k=0;k<projectidss.size();k++)
		 {
		 if (projectids.indexOf(""+projectidss.get(k))<0)
		 {
         if (projectids.equals("")) projectids=""+projectidss.get(k);
         else projectids=projectids+","+projectidss.get(k);
         }
         }
         }
        if (!Util.null2String(rse.getString("requestid")).equals(""))
		 {
		 ArrayList requestidss = Util.TokenizerString(Util.null2String(rse.getString("requestid")), ",");
		 for (int k=0;k<requestidss.size();k++)
		 {
		 if (requestids.indexOf(""+requestidss.get(k))<0)
		 {
         if (requestids.equals("")) requestids=""+requestidss.get(k);
         else requestids=requestids+","+requestidss.get(k);
         }
         }
         }
        
         
         oppositeGoal=Util.null2o(rse.getString("oppositeGoal"));
         planProperty=Util.null2o(rse.getString("planProperty"));
		 mid=rse.getString("groupId");
		 isremind=Util.null2o(rse.getString("isremind"));
         waketime=Util.null2o(rse.getString("waketime"));;
		 planName=planName+rse.getString("name");
		 //principalb=Util.null2String(rse.getString("principal"));
		}
		if (planName.length()>=50)
		{
		planName=planName.substring(1,50);
		}
        if (rs.execute("insert into workPlan(groupId,type_n,name,cycle,planDate,planType,objId,createrid,resourceid,status,oppositeGoal,planProperty,isremind,waketime,principal,cowork,upPrincipal,downPrincipal,rbeginDate,rbeginTime,rendDate,rendTime,begindate,begintime,enddate,endtime,crmid,docid,projectid,requestid,description,percent_n,teamRequest,allShare) values("+mid+",'6','"+planName+"','"+type+"','"+planDate+"','"+type_d+"',"+objId+","+createrid+","+createrid+",'3',"+oppositeGoal+","+planProperty+","+isremind+","+waketime+",'"+principal+"','"+cowork+"','','','"+rbeginDate+"','"+rbeginTime+"','"+rendDate+"','"+rendTime+"','"+begindate+"','"+begintime+"','"+enddate+"','"+endtime+"','"+crmids+"','"+docids+"','"+projectids+"','"+requestids+"','"+description+"','0','"+teamRequest+"','1') "))
        {
        rsk.execute("select max(id) from workPlan");
     	rsk.next();
        id=rsk.getString(1);
        rs.execute("delete  from workPlan where id in ("+str+")");
        rs.execute("delete  from HrmPerformancePlanDown where planId in ("+str+")");
        rs.execute("update HrmPerformancePlanEffort set planId="+id+" where planId in ("+str+")");
        rs.execute("update HrmPerformancePlanKey set planId="+id+" where planId in ("+str+")");
        }
       response.sendRedirect("PlanEdit.jsp?planName="+planName+"&id="+id+"&type="+type+"&planDate="+planDate);
      }
      
      if (operationType.equals("checkpercent")){
      String[] ids=request.getParameterValues("pId");
      String[] percent_ns=request.getParameterValues("percent_n");
      for (int i=0;i<ids.length;i++)
      {
      rs.execute("update workPlan set percent_n='"+percent_ns[i]+"' where id="+ids[i]);
      }
       out.print("<script>history.back(-1);</script>");
      }
    //审批人修改后直接递交
    if (operationType.equals("process"))
    {
      //准备流程参数
		    String src = request.getParameter("src");
		    String remark = request.getParameter("remark");
			String iscreate = "0";
			int requestid = Util.getIntValue(request.getParameter("requestId"),0);
			int workflowid = 0;
			String workflowtype = "";
			int isremark = 0;
			int formid = 0;
			int isbill = 1;
			int billid = -1;
			int nodeid =-1;
			String nodetype = "";
			String requestlevel = "";
			String messageType = "0";
			
			int flowId=0;
			int createrid=0;
			
			 rsf.execute("select workflowid,messageType,currentnodeid,currentnodetype,requestlevel,creater from workflow_requestbase where requestid="+requestid);
			 if (rsf.next())
			 {
			 flowId=rsf.getInt(1);
			 messageType=rsf.getString("messageType");
			 requestlevel=rsf.getString("requestlevel");
			 nodetype=rsf.getString("currentnodetype");
			 nodeid=rsf.getInt("currentnodeid");
			 createrid=rsf.getInt("creater");
			 }
			  workflowid=flowId;
			 rsf.execute("select messageType,workflowtype,formid from workflow_base where id="+workflowid);
			 if (rsf.next())
			 {
			
			 workflowtype=rsf.getString("workflowtype");
			 billid=rsf.getInt("formid");
			 }
			 formid=billid;

			   //准备流程参数结束
			
			 String url="/workflow/request/BillBPMApprovePlanOperation.jsp?"+
			 "users="+createrid+"&src="+src+"&iscreate="+iscreate+"&requestid="+requestid+"&"+
			 "workflowid="+workflowid+"&workflowtype="+workflowtype+""+
			 "&isremark="+isremark+"&formid="+formid+"&isbill="+isbill+"&billid="+billid+"&"+
			 "nodeid="+nodeid+"&"+
			 "nodetype="+nodetype+"&requestlevel="+requestlevel+"&messageType="+messageType+"&remark="+remark+"&from=2";
			  response.sendRedirect(url);
			  //out.print(url);
			  return;
    }
       //删除
       
    if (operationType.equals("del"))
    {
		String checkplan[] = request.getParameterValues("checkplan");
		String str="";
		for(int a = 0;a<checkplan.length;a++){
			if(a == checkplan.length-1)
				str = str+"'"+checkplan[a]+"'";
			else
				str = str+"'"+checkplan[a]+"'"+",";
			if(isApproved)
				rs.executeSql("INSERT INTO WorkplanRevision (planId,operator,operateTime,operateType,clientIP) VALUES ("+Util.getIntValue(checkplan[a])+","+user.getUID()+",'"+currentTime+"','3','"+clientIP+"')");
		}

		if(isApproved){
			rse.execute("update workPlan set modifyStatus='3',modifyUser="+user.getUID()+" where id in ("+str+")");
		}else{
			rse.execute("delete  from HrmPerformancePlanDown where planId in ("+str+")");	
			rse.execute("delete from workPlan where id in ("+str+")");
		}
		out.print("<script>history.back(-1);</script>");
    }
    
    if (operationType.equals("detaildel"))
    {
   
    String id = request.getParameter("id");
    String type=request.getParameter("ctype");;
    if (type.equals("key"))
    {
    rse.execute("delete from HrmPerformancePlanKey where id="+id);
    
    }
    else
    {rse.execute("delete from HrmPerformancePlanEffort where id="+id);
    }
    
    out.print("<script>history.back(-1);</script>");
    }
    %>
 