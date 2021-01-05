<%@page import="weaver.proj.util.SQLUtil"%>
<%@page import="weaver.proj.Maint.ProjectInfoComInfo"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.docs.docs.DocExtUtil"%>

<%@page import="weaver.conn.RecordSet"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="java.io.StringBufferInputStream"%>
<%@ page import="org.jdom.Document"%>
<%@ page import="org.jdom.Element"%>
<%@ page import="org.jdom.input.SAXBuilder"%>
<%@ page import="org.jdom.output.Format"%>
<%@ page import="org.jdom.output.XMLOutputter"%>
<%@ page import="org.jdom.xpath.XPath"%>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetDB" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs5" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsXML" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PrjViewer" class="weaver.proj.PrjViewer" scope="page"/>
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="ProjectInfo" class="weaver.proj.ProjectInfo" scope="page" />
<jsp:useBean id="ProjectAccesory" class="weaver.proj.ProjectAccesory" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="PrjImpUtil" class="weaver.proj.util.PrjImpUtil" scope="page" />
<jsp:useBean id="PrjTskFieldComInfo" class="weaver.proj.util.PrjTskFieldComInfo" scope="page"/>
<jsp:useBean id="PrjTskFieldManager" class="weaver.proj.util.PrjTskFieldManager" scope="page"/>
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page"/>
<jsp:useBean id="PrjTimeAndWorkdayUtil" class="weaver.proj.util.PrjTimeAndWorkdayUtil" scope="page" />
<%
FileUpload fu = new FileUpload(request);
int accessorynum = Util.getIntValue(fu.getParameter("accessory_num"),0);
int deleteField_idnum = Util.getIntValue(fu.getParameter("field_idnum"),0);
String accdocids=Util.null2String(fu.getParameter("accdocids"));
String isdialog=Util.null2String(fu.getParameter("isdialog"));

char flag = Util.getSeparator() ;
String ProcPara = "";
String strTemp = "";
String method = fu.getParameter("method");
String taskrecordid = fu.getParameter("taskrecordid");
String ProjID=Util.null2String(fu.getParameter("ProjID"));

if("".equals(ProjID)){
	RecordSet.executeSql("select prjid from prj_taskprocess where id="+taskrecordid);
	if(RecordSet.next()){
		ProjID=Util.null2String(RecordSet.getString("prjid"));
	}
}

String parentid=Util.null2String(fu.getParameter("parentid"));
String parentids=Util.null2String(fu.getParameter("parentids"));
String parenthrmids=Util.null2String(fu.getParameter("parenthrmids"));

//add by wangxp 20161212 如果直接在任务列表上添加任务，得不到parenthrmids
if(parenthrmids.equals("")){
   RecordSet.executeProc("Prj_TaskProcess_SelectByID",parentid);
   if(RecordSet.next()){
    parenthrmids = RecordSet.getString("parenthrmids");
   } 
}

int prjStatus= Util.getIntValue( ProjectInfoComInfo.getProjectInfostatus(ProjID),0);
//=========================================================================================================================
//TD4078
//added by hubo,2006-04-05

//=========================================================================================================================

String hrmid=Util.null2String(fu.getParameter("hrmid"));
String oldhrmid=Util.null2String(fu.getParameter("oldhrmid"));

/*modified by hubo 050830*/
String finish=Util.null2String(fu.getParameter("finish"));
if(finish.endsWith("%")){finish = finish.substring(0,finish.indexOf("%"));}
//TD4174 added by hubo,2006-04-17
if(Util.getIntValue(finish,0)>100){finish="100";}

String level=Util.null2String(fu.getParameter("level"));
String subject=Util.null2String(fu.getParameter("subject"));
String begindate=Util.null2String(fu.getParameter("begindate"));
String enddate=Util.null2String(fu.getParameter("enddate"));
String begintime = Util.null2String(fu.getParameter("begintime"));

String endtime = Util.null2String(fu.getParameter("endtime"));
//added by hubo 20050829
String actualbegindate = Util.null2String(fu.getParameter("actualBeginDate"));
String actualenddate = Util.null2String(fu.getParameter("actualEndDate"));
String actualbegintime = Util.null2String(fu.getParameter("actualBeginTime"));
String actualendtime = Util.null2String(fu.getParameter("actualEndTime"));

String workday=Util.null2String(fu.getParameter("workday"));

//String workday=""+(TimeUtil.dateInterval(begindate, enddate)+1);
if("".equals( begindate)||"".equals(enddate)){
	workday="0";
}
String fixedcost=Util.null2String(fu.getParameter("fixedcost"));
String islandmark=Util.null2String(fu.getParameter("islandmark"));
//System.out.println("islandmark===============================================:"+islandmark);
String pretask=Util.null2String(fu.getParameter("taskids02"));
String content=Util.null2String(fu.getParameter("content"));

// added by lupeng 2004-07-21
String realManDays = Util.null2String(fu.getParameter("realmandays"));

    // add by dongping for  if realManDays is null ("") under excute sql is error!
    //bengin
    if (realManDays.equals("")){
        realManDays="0";
    }
//end
String[] logParams;
WorkPlanLogMan logMan = new WorkPlanLogMan();
// end

//==========================================================
//TD4131
//modified by hubo,2006-04-13
//if(begindate.equals("")) begindate = "x" ;
//if(enddate.equals("")) enddate = "-" ;
//==========================================================
if(workday.equals("")) workday = "0" ;
if(Util.getDoubleValue(workday)<=0) workday = "0" ;
if(finish.equals("")) finish = "0" ;
if(islandmark.equals("")) islandmark="0";
if(fixedcost.equals("")) fixedcost = "0" ;
if(pretask.equals("")) pretask = "0" ;


String taskid = "0" ;
String wbscoding = "0" ;
String version = "0" ;


ArrayList arrayParentids = Util.TokenizerString(parentids,",");



String CurrentUser = ""+user.getUID();
String SubmiterType = ""+user.getLogintype();
String ClientIP = request.getRemoteAddr();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
String TaskID="";

String SWFAccepter="";
String SWFTitle="";
String SWFRemark="";
String SWFSubmiter="";
String Subject="";
String CurrentUserName = ""+user.getUsername();

boolean isInsertWorkplan=false;
String sql_Smanager="select t1.name,t1.manager,t1.status,t2.insertWorkPlan from Prj_ProjectInfo t1 left outer join Prj_ProjectType t2 on t1.prjtype=t2.id where t1.id="+ProjID;
RecordSet2.executeSql(sql_Smanager);
RecordSet2.next();
String Prj_manager=RecordSet2.getString("manager");
String Prj_name=RecordSet2.getString("name");
String prj_status = RecordSet2.getString("status");
isInsertWorkplan="1".equals( RecordSet2.getString("insertWorkPlan"))?true:false;

String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID;
RecordSet.executeSql(sql_tatus);
RecordSet.next();
String isactived=RecordSet.getString("isactived");


/*################ADD BY HUANG YU ON April 21,2004 FOR 审批任务 START*/
int[] status = {0, //正常
				1, //增加
				2, //修改
				3}; //删除
int[] log_status = {0, //未处理
					1, //批准
					2  //拒绝
					};
int[] log_operationtype = { 0, //无意义
							1, //增加
                            2, //修改
							3  //删除
							};

boolean isPM = false;
  if(CurrentUser.equals(Prj_manager)) isPM = true; /*是否是 ProjectManager*/

/*################ADD BY HUANG YU ON April 21,2004 FOR 审批任务 END*/

//检测项目成员，当任务负责人不在项目成员中时，更新项目成员
	String sql111 = "select members from Prj_ProjectInfo where id="+ProjID;
	RecordSet.executeSql(sql111);
	RecordSet.next();
	  String hrmId111=RecordSet.getString("members")+","+hrmid;
	  String[] managers111=hrmId111.split(",");
	  List<String> list1 = new ArrayList<String>();
	  for (int i = 0; i < managers111.length; i++) {
		   if(!"".equals(managers111[i])&&!list1.contains(managers111[i])){
			   list1.add(managers111[i]); 
		   }
	  }
	  String hrmId112="";
	  if(list1.size()>0){
		   for(int m=0;m<list1.size();m++){
			   hrmId112+=list1.get(m)+",";
		   }
		  hrmId112 = hrmId112.substring(0,hrmId112.length()-1);
	   }
	  ProcPara = ProjID;
	    ProcPara += flag+hrmId112;
		RecordSet.executeProc("Proj_Members_update",ProcPara);
if (method.equals("add"))
{

	int taskIndex = 1;
	String sqlTaskIndex = "SELECT MAX(taskindex) AS maxTaskIndex FROM Prj_TaskProcess WHERE prjid="+Util.getIntValue(ProjID)+"";
	RecordSet.executeSql(sqlTaskIndex);
	if(RecordSet.next()){
		taskIndex =Util.getIntValue( RecordSet.getString("maxTaskIndex"),0) + 1;
	}
	
	ProcPara = ProjID ;
	ProcPara += flag + "" + taskid ;
	ProcPara += flag + "" + wbscoding ;
	ProcPara += flag + "" + subject ;
	ProcPara += flag + "" + version ;
	ProcPara += flag + "" + begindate ;
	ProcPara += flag + "" + enddate ;
	ProcPara += flag + "" + workday ;
	ProcPara += flag + "" + content ;
	ProcPara += flag + "" + fixedcost ;//项目预算
	ProcPara += flag + "" + Util.getIntValue(parentid,0) ;
	ProcPara += flag + "" + parentids ;
	ProcPara += flag + "" + parenthrmids ;
	ProcPara += flag + "" + level ;
	ProcPara += flag + "" + hrmid ;
    ProcPara += flag + "" + pretask ;
    ProcPara += flag + "" + realManDays ;
	//================================================
	//TD4078	添加任务的时候应该保存这个任务的taskindex
	//added by hubo,2006-04-05
	ProcPara += flag + "" + taskIndex;
	
	
	
	//================================================
	RecordSet.executeProc("Prj_TaskProcess_Insert",ProcPara);
	
	
	RecordSet.executeProc("Prj_TaskProcess_SMAXID","");
    while(RecordSet.next()){
    TaskID = RecordSet.getString("maxid_1");
    }
  //将存储过程中的parentids和parenthrmids两个字段的值重新赋值  因为hrmid改为多人力资源  Start
  
  	String parentidsinsert= parentids+TaskID+",";
  	String parenthrmidsinsert= parenthrmids;
  	if(!"".equals(hrmid)){
  		String[] hrmidsinsert = hrmid.split(",");
  		for(int l=0;l<hrmidsinsert.length;l++){
  			parenthrmidsinsert+="|"+TaskID+","+hrmidsinsert[l]+"|";
  		}
  	}
  	RecordSet.executeSql("update Prj_TaskProcess set parentids='"+parentidsinsert+"', parenthrmids='"+parenthrmidsinsert+"' where id="+TaskID);
  	//将存储过程中的parentids和parenthrmids两个字段的值重新赋值  因为hrmid改为多人力资源  End
    if(Util.getIntValue(parentid,0)>0){
		parentids=PrjImpUtil.getTaskParentids(Util.getIntValue(TaskID,0) ,new StringBuffer() ).toString();
		level=""+PrjImpUtil.occurTimes(parentids, ",");
	}
    RecordSet.executeSql("update Prj_TaskProcess set islandmark='"+islandmark+"',parentids='"+parentids+"',level_n='"+level+"' where id="+TaskID);
    RecordSet.executeSql("update Prj_TaskProcess set realmandays="+realManDays+",begintime='"+begintime+"',endtime='"+endtime+"',actualbegintime='"+actualbegintime+"',actualendtime='"+actualendtime+"' where id="+TaskID+" and prjid="+ProjID+"  ");
    PrjTskFieldManager.updateCusfieldValue(TaskID, fu, user,"prj_taskprocess");
	/*更新任务状态为 1：增加待审批，并且同时插入一条到任务历史记录表中*/
	/*############Added By Huang Yu START##################*/

	/*insert to the log table*/

	ProcPara = ProjID ;
	ProcPara += flag + "" + TaskID ;
	ProcPara += flag + "" + subject ;
	ProcPara += flag + "" + hrmid ;
	//ProcPara += flag + "" + begindate ;
	//ProcPara += flag + "" + enddate ;
	ProcPara += flag + "" + begindate ;
	ProcPara += flag + "" + enddate ;
	ProcPara += flag + "" + workday ;
	ProcPara += flag + "" + fixedcost ;
	ProcPara += flag + "" + finish /**/;
	ProcPara += flag + "" + Util.getIntValue(parentid,0) ;
	ProcPara += flag + "" + pretask ;  /**/
	ProcPara += flag + "" + islandmark ;
	ProcPara += flag + "" + CurrentDate ;
	ProcPara += flag + "" + CurrentTime ;
	ProcPara += flag + "" + CurrentUser ;
	ProcPara += flag + "" + ((!ProjectTransUtil.needApproveTask(Util.getIntValue(parentid,0)+"", Prj_manager, user))?log_status[1]:log_status[0]) ; /*Status: 是否是项目经理？如果是，直接更新为接受 1*/
	ProcPara += flag + "" + log_operationtype[1] ; /*Operation Type*/
	ProcPara += flag + "" + ClientIP ;
    ProcPara += flag + "" + realManDays ;

	RecordSet.executeProc("Prj_TaskModifyLog_Insert",ProcPara);
    ProcPara = ProjID ;
    ProcPara += flag + "" + TaskID ;
    ProcPara += flag + "n"  ;
    ProcPara += flag + "" + CurrentDate ;
    ProcPara += flag + "" + CurrentTime ;
    ProcPara += flag + "" + CurrentUser ;
    ProcPara += flag + "" + ClientIP ;
    ProcPara += flag + "" + SubmiterType ;
    RecordSet.executeProc("Prj_TaskLog_Insert",ProcPara);

	ArrayList arrayParentidss = Util.TokenizerString(parentids,",");
	for(int i=arrayParentidss.size()-1;i>=0;i--){
		String tmpparentid = ""+arrayParentidss.get(i);
		//父任务更新进度
		RecordSet.executeProc("Prj_Task_UpdateParent",tmpparentid);
		//out.print("::::"+tmpparentid+"::::");
   	}
	//父任务更新时间和工期
	PrjTimeAndWorkdayUtil.updateTimeAndWorkday(TaskID);


	String tmpsql="";

	tmpsql="update Prj_taskprocess set childnum=childnum+1 where id="+Util.getIntValue(parentid,0);
	RecordSet.executeSql(tmpsql);



	tmpsql="select * from prj_taskinfo where prjid="+ProjID;
	RecordSet.executeSql(tmpsql);
	if(RecordSet.next()){
		tmpsql="update prj_taskprocess set isactived=2 where prjid="+ProjID;
		RecordSet.executeSql(tmpsql);
	}

	//更新工作计划中该项目的经理的时间Begin
    String begindate01 = "";
    String enddate01 = "";

	RecordSet.executeSql("select max(enddate) as enddate from prj_taskprocess where prjid = "+ProjID);
	if(RecordSet.next()){
		enddate01 = RecordSet.getString("enddate");
	}
	RecordSet.executeSql("select min(begindate) as begindate from prj_taskprocess where prjid = "+ProjID);
	if(RecordSet.next()){
		begindate01 = RecordSet.getString("begindate");
	}
	if("".equals(enddate01)){
		enddate01 = "2099-12-31";
	}
    if (!begindate01.equals("")){
        RecordSet.executeSql("update workplan set begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + ProjID + "' and taskid = '-1'");
    }
    //更新工作计划中该项目的经理的时间End


/*如果为项目经理所作的修改，无需审批，不更新项目任务状态*/
    //新增状态

    if( prjStatus!=0&&prjStatus!=6&&prjStatus!=7 &&(ProjectTransUtil.needApproveTask(parentid, Prj_manager, user))){ /*不是项目经理，更新状态为：1，*/
		RecordSet.executeSql("Update Prj_TaskProcess Set Status = "+status[1]+" WHERE ID ="+TaskID);
    }
	else{  /*是项目经理的话，直接触发工作流，并加入任务负责人的计划*/
         /*触发工作流通知任务负责人或经理*/
         boolean isall=true;
         if(CurrentUser.equals(Prj_manager) && CurrentUser.equals(hrmid)) isall=false;
         if (isall){//任务负责人是自己，也是经理就不触发
            if( CurrentUser.equals(Prj_manager) && ( !CurrentUser.equals(hrmid)) ){//经理自己,负责人不是自己
                SWFAccepter=hrmid;
            }
            if( (!CurrentUser.equals(Prj_manager) ) && ( !CurrentUser.equals(hrmid)) ){//不是经理，负责人也不是自己
                SWFAccepter=hrmid+","+Prj_manager;
            }
            if ( (!CurrentUser.equals(Prj_manager) ) && ( CurrentUser.equals(hrmid)) ){//不是经理，负责人是自己
                SWFAccepter= Prj_manager;
            }
            //SWFAccepter=hrmid+","+Prj_manager;
            //SWFTitle=Util.toScreen("项目",user.getLanguage(),"0");
            //SWFTitle += ":"+Prj_name;
            SWFTitle +=SystemEnv.getHtmlLabelName(15283,user.getLanguage());
            SWFTitle += ":"+subject;
            SWFTitle += "-"+CurrentUserName;
            SWFTitle += "-"+CurrentDate;
            SWFRemark="";
            SWFSubmiter=CurrentUser;

            SysRemindWorkflow.setPrjSysRemind(SWFTitle,Util.getIntValue(ProjID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
        }

        	//添加工作计划Begin
       	boolean isactived_flag = false;
       	if(isactived.equals("2")||(!"0".equals(prj_status)&&!"7".equals(prj_status))){
       		isactived_flag = true;
       	}
        if (isInsertWorkplan && isactived_flag) 
        {
			//添加工作计划
       		WorkPlan workPlan = new WorkPlan();
       		
       		workPlan.setCreaterId(Integer.parseInt(CurrentUser));

       	    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_ProjectCalendar));        
       	    workPlan.setWorkPlanName(subject);    
       	    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
       	    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
       	    workPlan.setResourceId(hrmid);           	    
       	    workPlan.setBeginDate(begindate);           	    
       	    workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间	    
       	    workPlan.setEndDate(enddate);
       	    workPlan.setEndTime(Constants.WorkPlan_EndTime);  //结束时间
       	    workPlan.setDescription(Util.convertInput2DB(Util.null2String(fu.getParameter("content"))));
       	    workPlan.setProject(ProjID);
       	    workPlan.setTask(TaskID);

       	    workPlanService.insertWorkPlan(workPlan);  //插入日程

			//插入日志
            logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, CurrentUser, request.getRemoteAddr()};
            logMan.writeViewLog(logParams);

        }

        //添加工作计划End

    }

	/*############Added By Huang Yu END##################*/


	//============================================================================
	//在老的任务列表页面添加子任务后，需要更新项目的XML字段
	//added by hubo,2006-04-05
	int parentTaskIndex = 0;
	//============================================================================
	//tagtag附件 start
    String tempAccessory = "";
    if(!"".equals(accdocids)) {
		rs.executeSql("update Prj_TaskProcess set accessory='"+accdocids+"' where id ="+TaskID);
	}
	rs.executeSql("update Prj_TaskProcess set finish=0 where finish is null or finish = '' " );
	String memberstmp = "";
    /**
    RecordSet.executeSql("select userid from PrjShareDetail where prjid="+ProjID);
	while(RecordSet.next()) {
        memberstmp += RecordSet.getString("userid")+",";
	}
	**/
	HashSet<String> set= CommonShareManager.getPrjCanviewUsers(ProjID);
	for (Iterator iterator = set.iterator(); iterator.hasNext();) {
		String string = (String) iterator.next();
		memberstmp += string +",";
	}
	if(!"".equals(accdocids)) {
	   ProjectAccesory.addAccesoryShare(accdocids,memberstmp);
	}
	//tagtag附件 end
			
			
	//response.sendRedirect("/proj/process/ViewProcess.jsp?ProjID="+ProjID);
	response.sendRedirect("/proj/process/AddTask.jsp?isclose=1");
}

else if (method.equals("del"))
{
	
	//System.out.println("deltask");
	/**#################Add by Huang Yu On April 21,2004 START任务审批**/
	if(!taskrecordid.equals("")){
		String parentidss =PrjImpUtil.getTaskParentids(Util.getIntValue(taskrecordid,0) ,new StringBuffer() ).toString();

        ProjID=Util.null2String(fu.getParameter("ProjID"));

        ProcPara = taskrecordid ;
		RecordSet.executeProc("Prj_TaskProcess_SelectByID",ProcPara);

		TaskID = taskrecordid;
		if(RecordSet.next()){
			subject = Util.null2String(RecordSet.getString("subject"));
			hrmid = Util.null2String(RecordSet.getString("hrmid"));
			begindate = Util.null2String(RecordSet.getString("begindate"));
			enddate = Util.null2String(RecordSet.getString("enddate"));
			workday = Util.null2String(RecordSet.getString("workday"));
			fixedcost = Util.null2String(RecordSet.getString("fixedcost"));
			finish = Util.null2String(RecordSet.getString("finish"));
			pretask = Util.null2String(RecordSet.getString("prefinish"));
			islandmark = Util.null2String(RecordSet.getString("islandmark"));
			parentid = Util.null2String(RecordSet.getString("parentid"));
		}


		//if(begindate.equals("")) begindate = "x" ;
		//if(enddate.equals("")) enddate = "-" ;
		if(workday.equals("")) workday = "0" ;
		if(Util.getDoubleValue(workday)<=0) workday = "0" ;
		if(finish.equals("")) finish = "0" ;
		if(islandmark.equals("")) islandmark="0";
		if(fixedcost.equals("")) fixedcost = "0" ;
		if(pretask.equals("")) pretask = "0" ;
		if(parentid.equals("")) parentid = "0";


		/*insert to the log table*/
		ProcPara = ProjID ;
		ProcPara += flag + "" + TaskID ;
		ProcPara += flag + "" + subject ;
		ProcPara += flag + "" + hrmid ;
		ProcPara += flag + "" + begindate ;
		ProcPara += flag + "" + enddate ;
		ProcPara += flag + "" + workday ;
		ProcPara += flag + "" + fixedcost ;
		ProcPara += flag + "" + finish /**/;
		ProcPara += flag + "" + parentid /**/;
		ProcPara += flag + "" + pretask ;  /**/
		ProcPara += flag + "" + islandmark ;
		ProcPara += flag + "" + CurrentDate ;
		ProcPara += flag + "" + CurrentTime ;
		ProcPara += flag + "" + CurrentUser ;
		ProcPara += flag + "" + ((!ProjectTransUtil.needApproveTask(parentid, Prj_manager, user))?log_status[1]:log_status[0]) ; /*Status*/
		ProcPara += flag + "" + log_operationtype[3] ; /*Operation Type*/
		ProcPara += flag + "" + ClientIP ;
        ProcPara += flag + "" + realManDays ;



		RecordSet.executeProc("Prj_TaskModifyLog_Insert",ProcPara);

        /*insert into the task log */
        ProcPara = ProjID ;
        ProcPara += flag + "" + taskrecordid ;
        ProcPara += flag + "d"  ;
        ProcPara += flag + "" + CurrentDate ;
        ProcPara += flag + "" + CurrentTime ;
        ProcPara += flag + "" + CurrentUser ;
        ProcPara += flag + "" + ClientIP ;
        ProcPara += flag + "" + SubmiterType ;
        RecordSet.executeProc("Prj_TaskLog_Insert",ProcPara);

		if( prjStatus!=0&&prjStatus!=6&&prjStatus!=7 && (ProjectTransUtil.needApproveTask(parentid, Prj_manager, user))){ /*是否是Project Manager*/
			String sqlstr = "Update Prj_TaskProcess SET status ="+status[3]+" WHERE ID ="+taskrecordid;
			RecordSet.executeSql(sqlstr);

		}else{//如果是项目经理，直接删除
			//ProcPara = taskrecordid ; 
			//RecordSet.executeProc("Prj_TaskProcess_DeleteByID",ProcPara);
			RecordSet.executeSql("DELETE FROM Prj_TaskProcess WHERE id="+taskrecordid);
			//更新工作计划中该项目的经理的时间Begin
			String begindate01 = "";
			String enddate01 = "";

			RecordSet.executeSql("select max(enddate) as enddate from prj_taskprocess where prjid = "+ProjID);
			if(RecordSet.next()){
				enddate01 = RecordSet.getString("enddate");
			}
			RecordSet.executeSql("select min(begindate) as begindate from prj_taskprocess where prjid = "+ProjID);
			if(RecordSet.next()){
				begindate01 = RecordSet.getString("begindate");
			}
			if("".equals(enddate01)){
				enddate01 = "2099-12-31";
			}
			if (!begindate01.equals("")){
				RecordSet.executeSql("update workplan set begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + ProjID + "' and taskid = '-1'");
			}
			//更新工作计划中该项目的经理的时间End

			//删除工作计划Begin
			if (isactived.equals("2")) {
				RecordSet.executeSql("delete from workplan where taskid = '" + taskrecordid +"'");
			}
			//删除工作计划End

			arrayParentids = Util.TokenizerString(parentidss,",");
			int i=arrayParentids.size()-2;
			for( i=arrayParentids.size()-2;i>=0;i--){
				String tmpparentid = ""+arrayParentids.get(i);
				try{
					//父任务更新进度
					RecordSet.executeProc("Prj_Task_UpdateParent",tmpparentid);
				}catch(Exception e){
				}
			}
			//父任务更新时间和工期
			//PrjTimeAndWorkdayUtil.updateTimeAndWorkday(TaskID);

			String tmpsql="";
			if(i>=0){
			tmpsql="update Prj_taskprocess set childnum=childnum-1 where id="+arrayParentids.get(arrayParentids.size()-2);
			RecordSet.executeSql(tmpsql);
			}

			//PrjViewer.setPrjShareByPrj(""+ProjID);

			tmpsql="select * from prj_taskinfo where prjid="+ProjID;
			RecordSet.executeSql(tmpsql);
			if(RecordSet.next()){
				tmpsql="update prj_taskprocess set isactived=2 where prjid="+ProjID;
				RecordSet.executeSql(tmpsql);
			}
		}
		
		//tagtag级联删除任务的子任务
		RecordSet.executeSql(SQLUtil.filteSql(RecordSet.getDBType(),  "select * from prj_taskprocess where prjid="+ProjID+" and ','+parentids+',' like '%,"+TaskID+",%' "));
		while(RecordSet.next()){
			
			String subTaskID=Util.null2String(RecordSet.getString("id"));
			subject = Util.null2String(RecordSet.getString("subject"));
			hrmid = Util.null2String(RecordSet.getString("hrmid"));
			begindate = Util.null2String(RecordSet.getString("begindate"));
			enddate = Util.null2String(RecordSet.getString("enddate"));
			workday = Util.null2String(RecordSet.getString("workday"));
			fixedcost = Util.null2String(RecordSet.getString("fixedcost"));
			finish = Util.null2String(RecordSet.getString("finish"));
			pretask = Util.null2String(RecordSet.getString("prefinish"));
			islandmark = Util.null2String(RecordSet.getString("islandmark"));
			parentid = Util.null2String(RecordSet.getString("parentid"));
			parentids=Util.null2String(RecordSet.getString("parentids"));
			
			if(workday.equals("")) workday = "0" ;
			if(Util.getDoubleValue(workday)<=0) workday = "0" ;
			if(finish.equals("")) finish = "0" ;
			if(islandmark.equals("")) islandmark="0";
			if(fixedcost.equals("")) fixedcost = "0" ;
			if(pretask.equals("")) pretask = "0" ;
			if(parentid.equals("")) parentid = "0";


			/*insert to the log table*/
			ProcPara = ProjID ;
			ProcPara += flag + "" + subTaskID ;
			ProcPara += flag + "" + subject ;
			ProcPara += flag + "" + hrmid ;
			ProcPara += flag + "" + begindate ;
			ProcPara += flag + "" + enddate ;
			ProcPara += flag + "" + workday ;
			ProcPara += flag + "" + fixedcost ;
			ProcPara += flag + "" + finish /**/;
			ProcPara += flag + "" + parentid /**/;
			ProcPara += flag + "" + pretask ;  /**/
			ProcPara += flag + "" + islandmark ;
			ProcPara += flag + "" + CurrentDate ;
			ProcPara += flag + "" + CurrentTime ;
			ProcPara += flag + "" + CurrentUser ;
			ProcPara += flag + "" + ((!ProjectTransUtil.needApproveTask(parentid, Prj_manager, user))?log_status[1]:log_status[0]) ; /*Status*/
			ProcPara += flag + "" + log_operationtype[3] ; /*Operation Type*/
			ProcPara += flag + "" + ClientIP ;
	        ProcPara += flag + "" + realManDays ;



			RecordSet2.executeProc("Prj_TaskModifyLog_Insert",ProcPara);

	        /*insert into the task log */
	        ProcPara = ProjID ;
	        ProcPara += flag + "" + subTaskID ;
	        ProcPara += flag + "d"  ;
	        ProcPara += flag + "" + CurrentDate ;
	        ProcPara += flag + "" + CurrentTime ;
	        ProcPara += flag + "" + CurrentUser ;
	        ProcPara += flag + "" + ClientIP ;
	        ProcPara += flag + "" + SubmiterType ;
	        RecordSet2.executeProc("Prj_TaskLog_Insert",ProcPara);

			if( prjStatus!=0&&prjStatus!=6&&prjStatus!=7 && (ProjectTransUtil.needApproveTask(parentid, Prj_manager, user))){ /*是否是Project Manager*/
				String sqlstr = "Update Prj_TaskProcess SET status ="+status[3]+" WHERE ID ="+subTaskID;
				RecordSet2.executeSql(sqlstr);

			}else{//如果是项目经理，直接删除
				//ProcPara = taskrecordid ; 
				//RecordSet.executeProc("Prj_TaskProcess_DeleteByID",ProcPara);
				RecordSet2.executeSql("DELETE FROM Prj_TaskProcess WHERE id="+subTaskID);
				//更新工作计划中该项目的经理的时间Begin
				String begindate01 = "";
				String enddate01 = "";

				RecordSet2.executeSql("select max(enddate) as enddate from prj_taskprocess where prjid = "+ProjID);
				if(RecordSet2.next()){
					enddate01 = RecordSet2.getString("enddate");
				}
				RecordSet2.executeSql("select min(begindate) as begindate from prj_taskprocess where prjid = "+ProjID);
				if(RecordSet2.next()){
					begindate01 = RecordSet2.getString("begindate");
				}
				if("".equals(enddate01)){
					enddate01 = "2099-12-31";
				}
				if (!begindate01.equals("")){
					RecordSet2.executeSql("update workplan set begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + ProjID + "' and taskid = '-1'");
				}
				//更新工作计划中该项目的经理的时间End

				//删除工作计划Begin
				if (isactived.equals("2")) {
					RecordSet2.executeSql("delete from workplan where taskid = '" + subTaskID+"'");
				}
				//删除工作计划End

				arrayParentids = Util.TokenizerString(parentidss,",");
				int i=arrayParentids.size()-2;
				for( i=arrayParentids.size()-2;i>=0;i--){
					String tmpparentid = ""+arrayParentids.get(i);
					try{
						//父任务更新进度
						RecordSet2.executeProc("Prj_Task_UpdateParent",tmpparentid);
					}catch(Exception e){
					}
				}
				//父任务更新时间和工期
				//PrjTimeAndWorkdayUtil.updateTimeAndWorkday(TaskID);
				String tmpsql="";
				if(i>=0){
				tmpsql="update Prj_taskprocess set childnum=childnum-1 where id="+arrayParentids.get(arrayParentids.size()-2);
				RecordSet2.executeSql(tmpsql);
				}
				/**
				tmpsql="select * from prj_taskinfo where prjid="+ProjID;
				RecordSet2.executeSql(tmpsql);
				if(RecordSet2.next()){
					tmpsql="update prj_taskprocess set isactived=2 where prjid="+ProjID;
					RecordSet2.executeSql(tmpsql);
				}**/
			}
			
		}


	}
	/**#################Add by Huang Yu On April 21,2004 END**/

	%>
	<script type="text/javascript">
	<!--
	try{
		parent.window.close();
		parent.refreshOpener();
	}catch(e){}
	//-->
	</script>
	
	<%
	//response.sendRedirect("/proj/process/ViewProcess.jsp?ProjID="+ProjID);
}

else if (method.equals("edit"))
{

	//modify dongping for TD735
    //1.找出其子任务中最大的结束时间
    String maxSubTaskEndDate = "" ;
    String strSql= "select max(enddate) as maxEndDate from Prj_TaskProcess where isdelete= 0 and   parentid="+taskrecordid ;
	RecordSet rs1=new RecordSet();
    rs1.executeSql(strSql);
    if (rs1.next()) {
        maxSubTaskEndDate = Util.null2String(rs1.getString("maxEndDate")) ;
    }
    int tempCompare = enddate.compareTo(maxSubTaskEndDate) ;
     //2.其本身任务修改后的结束时间和子任务的最大结束时间做比较
    if (tempCompare<0&&!maxSubTaskEndDate.equals("")) {%>
        <SCRIPT LANGUAGE="JavaScript">
        <!--
            alert("<%=SystemEnv.getHtmlLabelNames("83887",user.getLanguage())%>");
            window.location='EditTask.jsp?taskrecordid=<%=taskrecordid%>&ProjID=<%=ProjID %>';
        //-->
        </SCRIPT>
    <%    return ;
    } 
	
    String submittype = fu.getParameter("submittype");
    boolean bNeedUpdate = false;


    ProcPara = taskrecordid ;
    RecordSetM.executeProc("Prj_TaskProcess_SelectByID",ProcPara);
    RecordSetM.next();


    /*修改主题*/
    strTemp = RecordSetM.getString("subject");
    if(!subject.equals(strTemp)){
        ProcPara =ProjID+flag + taskrecordid +flag + "1352" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ subject+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType +flag+"1" ;
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }

	strTemp = RecordSetM.getString("realManDays");
    if(Util.getDoubleValue( realManDays,0.0)!= Util.getDoubleValue(strTemp,0.0)){
        ProcPara =ProjID+flag + taskrecordid +flag + "17501" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ realManDays+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType +flag+"1" ;
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }


    /*修改负责人*/
    strTemp = RecordSetM.getString("hrmid");//原负责人
    if(!hrmid.equals(strTemp)){
        ProcPara =ProjID+flag + taskrecordid +flag + "2097" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ hrmid+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+flag+"1" ;
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;

        //触发工作流通知原任务负责人和现任务负责人，若其中有一个是现登陆者，那么就不用再通知本人。
        if(isPM){
            if(CurrentUser.equals(Prj_manager)){//修改者是经理
            	if(!"".equals(strTemp)){//原来有设置负责人
            		String warnpeople1 = "";
            		if(!"".equals(hrmid)){
            			strTemp+=","+hrmid;
            		}
            		String[] strTemps = strTemp.split(",");
            		List<String> list = new ArrayList<String>();
                    for (int n = 0; n < strTemps.length; n++) {
                 	   if(!"".equals(strTemps[n])&&!list.contains(strTemps[n])){
                 		   list.add(strTemps[n]); 
                 	   }
                    }
         		   if(list.size()>0){
          			   for(int m=0;m<list.size();m++){
          				   if(!CurrentUser.equals(list.get(m))){
          					 warnpeople1+=list.get(m)+",";
          				   }
          			   }
          			 warnpeople1 = warnpeople1.substring(0,warnpeople1.length()-1);
          		   }
         		  SWFAccepter=warnpeople1;
            	}else{//原来没有设置负责人
            		String warnpeople = "";
            		String[] hrmids = hrmid.split(",");
            		for(int l=0;l<hrmids.length;l++){
            			if(!CurrentUser.equals(hrmids[l])){
            				warnpeople+=hrmids[l]+",";
            			}
            		}
            		SWFAccepter=warnpeople;
            	}
            }
            else{
            	if(!"".equals(strTemp)){//原来有设置负责人
            		String warnpeople1 = "";
            		if(!"".equals(hrmid)){
            			strTemp+=","+hrmid;
            		}
            		String[] strTemps = strTemp.split(",");
            		List<String> list = new ArrayList<String>();
                    for (int n = 0; n < strTemps.length; n++) {
                 	   if(!"".equals(strTemps[n])&&!list.contains(strTemps[n])){
                 		   list.add(strTemps[n]); 
                 	   }
                    }
         		   if(list.size()>0){
          			   for(int m=0;m<list.size();m++){
          				   if(!CurrentUser.equals(list.get(m))){
          					 warnpeople1+=list.get(m)+",";
          				   }
          			   }
          			 warnpeople1 = warnpeople1.substring(0,warnpeople1.length()-1);
          		   }
         		  SWFAccepter=warnpeople1+","+Prj_manager;
            	}else{//原来没有设置负责人
            		String warnpeople = "";
            		String[] hrmids = hrmid.split(",");
            		for(int l=0;l<hrmids.length;l++){
            			if(!CurrentUser.equals(hrmids[l])){
            				warnpeople+=hrmids[l]+",";
            			}
            		}
            		SWFAccepter=warnpeople+","+Prj_manager;
            	}
            }

            //out.print(SWFAccepter);
            String name="";
            if(!"".equals(hrmid)){
            	String[] subjectname = hrmid.split(",");
            	for(int t=0;t<subjectname.length;t++){
            		if(!"".equals(subjectname[t])){
            			name+=ResourceComInfo.getResourcename(subjectname[t])+",";
            		}
            	}
            	name.substring(0,name.length()-1);
            }
            Subject=SystemEnv.getHtmlLabelName(15284,user.getLanguage());
            Subject+=":"+subject+"-";
            Subject+=SystemEnv.getHtmlLabelName(15285,user.getLanguage());
            Subject+=":"+name;

            //SWFTitle=SystemEnv.getHtmlLabelName(101,user.getLanguage());
            //SWFTitle += ":"+Prj_name;
            SWFTitle=SystemEnv.getHtmlLabelName(15284,user.getLanguage());
            SWFTitle += ":"+subject;
            SWFTitle += "-"+CurrentUserName;
            SWFTitle += "-"+CurrentDate;
            SWFRemark="<a href=/proj/process/ViewProcess.jsp?ProjID="+ProjID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
            SWFSubmiter=CurrentUser;

            SysRemindWorkflow.setPrjSysRemind(SWFTitle,Util.getIntValue(ProjID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
        }
    }

    strTemp = RecordSetM.getString("begindate");
    if(!begindate.equals(strTemp)){
        ProcPara =ProjID+flag + taskrecordid +flag + "1322" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ begindate+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType +flag+"1";
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }

    strTemp = RecordSetM.getString("enddate");
    if(!enddate.equals(strTemp)){
        ProcPara =ProjID+flag + taskrecordid +flag + "741" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ enddate+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType +flag+"1";
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }


    strTemp = RecordSetM.getString("workday");
    if(Util.getDoubleValue( workday,0.0)!= Util.getDoubleValue(strTemp,0.0)){
        ProcPara =ProjID+flag + taskrecordid +flag + "1298" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ workday+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+flag+"1" ;
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }


    strTemp = RecordSetM.getString("finish");
    if(Util.getDoubleValue( finish,0.0)!= Util.getDoubleValue (strTemp,0.0)){
        ProcPara =ProjID+flag + taskrecordid +flag + "555" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ finish+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType +flag+"1";
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }

    strTemp = RecordSetM.getString("fixedcost");
    if(Util.getDoubleValue( fixedcost,0.0)!= Util.getDoubleValue(strTemp,0.0)){
        ProcPara =ProjID+flag + taskrecordid +flag + "15274" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ fixedcost+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType +flag+"1";
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }

    strTemp = Util.null2String(RecordSetM.getString("islandmark"));


    if((!islandmark.equals("")) || (!strTemp.equals(""))){
        if(!islandmark.equals(strTemp)){
            ProcPara =ProjID+flag + taskrecordid +flag + "2232" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ islandmark+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+flag+"1" ;
            RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
            bNeedUpdate = true;
    }
    }

    strTemp = Util.null2String(RecordSetM.getString("content"));


    if((!content.equals("")) || (!strTemp.equals(""))){
        if(!content.equals(strTemp)){
            ProcPara =ProjID+flag + taskrecordid +flag + "2240" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ content+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+flag+"1" ;
            RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
            bNeedUpdate = true; /*不记录Content字段的更改*/
    }
    }


    strTemp = Util.null2String(RecordSetM.getString("prefinish"));


    if((!pretask.equals("")) || (!strTemp.equals(""))){
        if(!pretask.equals(strTemp)){
            ProcPara =ProjID+flag + taskrecordid +flag + "2233" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ pretask+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+flag+"1" ;
            RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
            bNeedUpdate = true;
		}
    }

	if(!hrmid.equals(oldhrmid)){
		//PrjViewer.setPrjShareByPrj(""+ProjID);
	}


	String tmpsql="select * from prj_taskinfo where prjid="+ProjID;
	RecordSet.executeSql(tmpsql);
	if(RecordSet.next()){
		tmpsql="update prj_taskprocess set isactived=2 where prjid="+ProjID;
		RecordSet.executeSql(tmpsql);
	}

	//tagtag
	strTemp = Util.null2String(RecordSetM.getString("actualbegindate"));
    if((!actualbegindate.equals("")) || (!strTemp.equals(""))){
        if(!actualbegindate.equals(strTemp)){
            ProcPara =ProjID+flag + taskrecordid +flag + "33351" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ actualbegindate+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+flag+"1" ;
            RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
            bNeedUpdate = true;
    	}
    }
	strTemp = Util.null2String(RecordSetM.getString("actualenddate"));
    if((!actualenddate.equals("")) || (!strTemp.equals(""))){
        if(!actualenddate.equals(strTemp)){
            ProcPara =ProjID+flag + taskrecordid +flag + "24697" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ actualenddate+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+flag+"1" ;
            RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
            bNeedUpdate = true;
    	}
    }
	
    if(bNeedUpdate){
        if(submittype.equals("0")){
			ProcPara = taskrecordid ;
			ProcPara += flag + "" + wbscoding ;
			ProcPara += flag + "" + subject ;
			ProcPara += flag + "" + begindate ;
			ProcPara += flag + "" + enddate ;
			ProcPara += flag + "" + actualbegindate ;
			ProcPara += flag + "" + actualenddate ;
			ProcPara += flag + "" + workday ;
			ProcPara += flag + "" + content ;
			ProcPara += flag + "" + fixedcost ;
			ProcPara += flag + "" + hrmid ;
			ProcPara += flag + "" + oldhrmid ;
			ProcPara += flag + "" + finish ;
			ProcPara += flag + "" + '0' ;
			ProcPara += flag + "" + islandmark ;
			ProcPara += flag + "" + pretask ;
            ProcPara += flag + "" + realManDays ;
        }
        else{
			ProcPara = taskrecordid ;
			ProcPara += flag + "" + wbscoding ;
			ProcPara += flag + "" + subject ;
			ProcPara += flag + "" + begindate ;
			ProcPara += flag + "" + enddate ;
			ProcPara += flag + "" + actualbegindate ;
			ProcPara += flag + "" + actualenddate ;
			ProcPara += flag + "" + workday ;
			ProcPara += flag + "" + content ;
			ProcPara += flag + "" + fixedcost ;
			ProcPara += flag + "" + hrmid ;
			ProcPara += flag + "" + oldhrmid ;
			ProcPara += flag + "" + finish ;
			ProcPara += flag + "" + '1' ;
			ProcPara += flag + "" + islandmark ;
			ProcPara += flag + "" + pretask ;
            ProcPara += flag + "" + realManDays ;
        }
        RecordSet.executeProc("Prj_TaskProcess_Update",ProcPara);
        //db2 trigger->procedure
        /*
        CREATE PROCEDURE Trigger_Proc_02 
        (
        in begindate char(10),
        in enddate char(10),
        in isdelete smallint ,
        in hrmid integer
        ) 
        */
        //将存储过程中的parenthrmids两个字段的值重新赋值  因为hrmid改为多人力资源  Start
        RecordSet.executeSql("select parentids from Prj_TaskProcess where id="+taskrecordid);
        RecordSet.next();
      	String parentidsupdate= RecordSet.getString("parentids");
      	if(!"".equals(parentidsupdate)){
      		String[] parentidsupdates = parentidsupdate.split(",");
      		String parenthrmidsupdate="";
      		for(int l=0;l<parentidsupdates.length;l++){
      			String parentidseach = parentidsupdates[l];
      			rs5.executeSql("select hrmid from Prj_TaskProcess where id="+parentidseach);
                if(rs5.next()){
                    String pphrmid = Util.null2String(rs5.getString("hrmid"));
                    if(!"".equals(pphrmid)){
                        String[] hrmidupdate = pphrmid.split(",");
                        for(int m=0;m<hrmidupdate.length;m++){
                            parenthrmidsupdate+="|"+parentidseach+","+hrmidupdate[m]+"|";
                        }
                    }
                }

      		}
    	    RecordSet.executeSql("update Prj_TaskProcess set parenthrmids='"+parenthrmidsupdate+"' where id="+taskrecordid);
      	}
      	//将存储过程中的parenthrmids两个字段的值重新赋值  因为hrmid改为多人力资源  End

        if (RecordSetDB.getDBType().equals("db2")){
            ProcPara = begindate ;
            ProcPara += flag + "" + enddate ;
            ProcPara += flag + "" + '0' ;
            ProcPara += flag + "" + hrmid ;
       //   RecordSet.executeProc("Trigger_Proc_02",ProcPara);
        }

    }
    
    PrjTskFieldManager.updateCusfieldValue(taskrecordid, fu, user,"prj_taskprocess");
    
    ProcPara = ProjID ;
    ProcPara += flag + "" + taskrecordid ;
    ProcPara += flag + "m"  ;
    ProcPara += flag + "" + CurrentDate ;
    ProcPara += flag + "" + CurrentTime ;
    ProcPara += flag + "" + CurrentUser ;
    ProcPara += flag + "" + ClientIP ;
    ProcPara += flag + "" + SubmiterType ;
    RecordSet.executeProc("Prj_TaskLog_Insert",ProcPara);

    //更新工作计划中该项目的经理的时间Begin
    String begindate01 = "";
    String enddate01 = "";

	RecordSet.executeSql("select max(enddate) as enddate from prj_taskprocess where prjid = "+ProjID);
	if(RecordSet.next()){
		enddate01 = RecordSet.getString("enddate");
	}
	RecordSet.executeSql("select min(begindate) as begindate from prj_taskprocess where prjid = "+ProjID);
	if(RecordSet.next()){
		begindate01 = RecordSet.getString("begindate");
	}
	if("".equals(enddate01)){
		enddate01 = "2099-12-31";
	}
    if (!begindate01.equals("")){
        RecordSet.executeSql("update workplan set begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + ProjID + "' and taskid = '-1'");
    }
    //更新工作计划中该项目的经理的时间End

    //编辑工作计划Begin
    if (isactived.equals("2")) {
        String para = "";
        String workid = "";
        RecordSet.executeSql("select id from workplan where taskid = '" + taskrecordid+"'");
        if (RecordSet.next()) {
            workid = RecordSet.getString("id");

            para = workid;
            para +=flag+"2"; //type_n
            para +=flag+subject;
            para +=flag+hrmid;
            para +=flag+begindate;
            para +=flag+Constants.WorkPlan_StartTime; //BeginTime
            para +=flag+enddate;
            para +=flag+Constants.WorkPlan_EndTime; //EndTime
            //para +=flag+"008DC8";
            para +=flag+content;
            para +=flag+"0";//requestid
            para +=flag+ProjID;//projectid
            para +=flag+"0";//crmid
            para +=flag+"0";//docid
            para +=flag+"0";//meetingid
            para +=flag+"1";//isremind;
            para +=flag+"0";//waketime;
            
            para +=flag+taskrecordid;//taskid
            para +=flag+level;//urgentlevel
            
			//TD.6769
			para += flag + "1";  //remindType
			para += flag + "";  //remindBeforeStart
			para += flag + "";  //remindBeforeEnd
			para += flag + "0";  //remindTimesBeforeStart
			para += flag + "0";  //remindTimesBeforeEnd
			para += flag + "";  //remindDateBeforeStart
			para += flag + "";  //remindTimeBeforeStart
			para += flag + "";  //remindDateBeforeEnd
			para += flag + "";  //remindTimeBeforeEnd
			para += flag + "-1";  //hrmPerformanceCheckDetailID

            RecordSet.executeProc("WorkPlan_Update",para);
            WorkPlanViewer.setWorkPlanShareById(workid);
        }
    }
    //编辑工作计划End

	//TD5181
	//modified by hubo, 2006-10-19
    for(int i=arrayParentids.size()-1; i>=0; i--){
        String tmpparentid = ""+arrayParentids.get(i);
        tmpparentid =Util.StringReplace(tmpparentid,"\'", "");
		  if(tmpparentid.equals(taskrecordid)||tmpparentid.equals("")) continue;
		  //父任务更新进度
        RecordSet.executeProc("Prj_Task_UpdateParent",tmpparentid);
        // out.print(RecordSet.executeProc("Prj_TaskProcess_UpdateParent",tmpparentid));
    }
  	//父任务更新时间和工期
	PrjTimeAndWorkdayUtil.updateTimeAndWorkday(taskrecordid);
    if(bNeedUpdate){
        /**ADD BY HUANG YU ON April 22,2004###########START##############**/
        TaskID = taskrecordid;
        subject = Util.null2String(RecordSetM.getString("subject"));
        hrmid = Util.null2String(RecordSetM.getString("hrmid"));
        begindate = Util.null2String(RecordSetM.getString("begindate"));
        enddate = Util.null2String(RecordSetM.getString("enddate"));
        workday = Util.null2String(RecordSetM.getString("workday"));
        fixedcost = Util.null2String(RecordSetM.getString("fixedcost"));
        finish = Util.null2String(RecordSetM.getString("finish"));
        pretask = Util.null2String(RecordSetM.getString("prefinish"));
        islandmark = Util.null2String(RecordSetM.getString("islandmark"));
        parentid = Util.null2String(RecordSetM.getString("parentid"));

        if(workday.equals("")) workday = "0" ;
        if(Util.getDoubleValue(workday)<=0) workday = "0" ;
        if(finish.equals("")) finish = "0" ;
        if(islandmark.equals("")) islandmark="0";
        if(fixedcost.equals("")) fixedcost = "0" ;
        if(pretask.equals("")) pretask = "0" ;
        if(parentid.equals("")) parentid = "0";

        if( prjStatus!=0 && prjStatus!=6 && prjStatus!=7 && (ProjectTransUtil.needApproveTask(parentid, Prj_manager, user))){
            String sqlstr = "Update Prj_TaskProcess SET status ="+status[2]+" WHERE ID ="+taskrecordid;
            RecordSet.executeSql(sqlstr);
        }else{
            String sqlStr = "Update Prj_TaskModifyLog Set status = 2 WHERE status="+log_status[0]+" and OperationType="+log_operationtype[2]+" and  taskID ="+taskrecordid ;
            RecordSet.executeSql(sqlStr);

            String sqlstr = "Update Prj_TaskProcess SET status ="+status[0]+" WHERE ID ="+taskrecordid;
            RecordSet.executeSql(sqlstr);
        }

        /*insert to the log table*/
        ProcPara = ProjID ;
        ProcPara += flag + "" + TaskID ;
        ProcPara += flag + "" + subject ;
        ProcPara += flag + "" + hrmid ;
        ProcPara += flag + "" + begindate ;
        ProcPara += flag + "" + enddate ;
        ProcPara += flag + "" + workday ;
        ProcPara += flag + "" + fixedcost ;
        ProcPara += flag + "" + finish /**/;
        ProcPara += flag + "" + parentid /**/;
        ProcPara += flag + "" + pretask ;  /**/
        ProcPara += flag + "" + islandmark ;
        ProcPara += flag + "" + CurrentDate ;
        ProcPara += flag + "" + CurrentTime ;
        ProcPara += flag + "" + CurrentUser ;
        ProcPara += flag + "" + ((!ProjectTransUtil.needApproveTask(parentid, Prj_manager, user))?log_status[1]:log_status[0]) ; /*Status*/
        ProcPara += flag + "" + log_operationtype[2] ; /*Operation Type*/
        ProcPara += flag + "" + ClientIP ;
        ProcPara += flag + "" + realManDays ;


        RecordSet.executeProc("Prj_TaskModifyLog_Insert",ProcPara);

        
        
        /**ADD BY HUANG YU ON April 22,2004###########END#############**/

    }
    
    RecordSet.executeSql("update Prj_TaskProcess set realmandays="+realManDays+",begintime='"+begintime+"',endtime='"+endtime+"',actualbegintime='"+actualbegintime+"',actualendtime='"+actualendtime+"' where id="+taskrecordid+" and prjid="+ProjID+"  ");
    
    
  //tagtag附件 start
    String newAccessory = "";
	RecordSet.executeSql("SELECT accessory FROM Prj_TaskProcess WHERE id = " + taskrecordid);
    if(RecordSet.next()){
		String oldAccessory = Util.null2String(RecordSet.getString(1));
	    newAccessory = oldAccessory;
		//删除附件
		if(deleteField_idnum>0){
			for(int i=0;i<deleteField_idnum;i++){
				String field_del_flag = Util.null2String(fu.getParameter("field_del_"+i));				
				if(field_del_flag.equals("1")){
					String field_del_value = Util.null2String(fu.getParameter("field_id_"+i));
					RecordSet.executeSql("delete DocDetail where id = " + field_del_value);
					if(newAccessory.indexOf(field_del_value)==0){
						newAccessory = Util.StringReplace(newAccessory,field_del_value+",","");
					}else{
						newAccessory = Util.StringReplace(newAccessory,","+field_del_value,"");
					}
				}
			}
		}
		//附件上传
		if(accessorynum > 0){
			String[] uploadField=new String[accessorynum];
			for(int i=0; i<accessorynum; i++){
				uploadField[i]="accessory"+(i+1);
			}
			DocExtUtil mDocExtUtil=new DocExtUtil();
			int[] returnarry = mDocExtUtil.uploadDocsToImgs(fu,user,uploadField);
			if(returnarry != null){
				for(int j=0;j<returnarry.length;j++){
					if(returnarry[j] != -1){
						if(newAccessory.equals("")){
							newAccessory = String.valueOf(returnarry[j])+",";
						}else{
							newAccessory += String.valueOf(returnarry[j])+",";
						}
					}
				}
			}
		}
	}
	
    String tempAccessory = "";
    if(!"".equals(accdocids)) {
		rs.executeSql("update Prj_TaskProcess set accessory='"+newAccessory+accdocids+"' where id ="+taskrecordid);
	}
    rs.executeSql("update Prj_TaskProcess set finish=0 where finish is null or finish = '' " );
	String memberstmp = "";
	HashSet<String> set= CommonShareManager.getPrjCanviewUsers(ProjID);
	for (Iterator iterator = set.iterator(); iterator.hasNext();) {
		String string = (String) iterator.next();
		memberstmp += string +",";
	}
	if(!"".equals(accdocids)) {
	   ProjectAccesory.addAccesoryShare(accdocids,memberstmp);
	}
	//tagtag附件 end
	if( true){//刷新父页面
		
	%>
		<script type="text/javascript">
		<!--
		try{
			if("<%=isdialog %>"=="1"){
				window.location="/proj/process/EditTask.jsp?isclose=1&isdialog=1";
			}else{
				window.location="/proj/process/ViewTask.jsp?isfromProjTab=1&taskrecordid=<%=taskrecordid %>";
			}
			parent.refreshOpener();
		}catch(e){}
		//-->
		</script>
	<%
	}
	
    /**if("1".equals(isdialog)){
    	response.sendRedirect("/proj/process/EditTask.jsp?isclose=1&isdialog="+isdialog);
    }else{
	    response.sendRedirect("/proj/process/ViewTask.jsp?isfromProjTab=1&taskrecordid="+taskrecordid);
    }**/
	
	//return;
}

else if (method.equals("uporder")) {
    String para = taskrecordid + flag+ "1";
    RecordSet.executeProc("PrjTaskProcess_UOrder",para);
    response.sendRedirect("ViewProcess.jsp?ProjID="+ProjID);
}

else if (method.equals("downorder")) {
    String para = taskrecordid + flag+ "2";
    RecordSet.executeProc("PrjTaskProcess_UOrder",para);
    response.sendRedirect("ViewProcess.jsp?ProjID="+ProjID);
}

%>