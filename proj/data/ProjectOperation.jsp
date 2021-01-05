<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.Writer" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.system.code.CodeBuild" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.formmode.browser.FormModeBrowserUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.docs.docs.DocExtUtil" %>

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs5" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="PrjViewer" class="weaver.proj.PrjViewer" scope="page"/>
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ProjectAccesory" class="weaver.proj.ProjectAccesory" scope="page" />
<jsp:useBean id="ProjectInfo" class="weaver.proj.ProjectInfo" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page"/>
<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<jsp:useBean id="CodeUtil" class="weaver.proj.util.CodeUtil" scope="page"/>
<jsp:useBean id="PrjTskFieldComInfo" class="weaver.proj.util.PrjTskFieldComInfo" scope="page"/>
<jsp:useBean id="PrjImpUtil" class="weaver.proj.util.PrjImpUtil" scope="page" />
<jsp:useBean id="PrjTimeAndWorkdayUtil" class="weaver.proj.util.PrjTimeAndWorkdayUtil" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page"/>
<%
 

FileUpload fu = new FileUpload(request);
int accessorynum = Util.getIntValue(fu.getParameter("accessory_num"),0);
int deleteField_idnum = Util.getIntValue(fu.getParameter("field_idnum"),0);

String accdocids=Util.null2String(fu.getParameter("accdocids"));
String frompage=Util.null2String(fu.getParameter("frompage"));

char flag = 2;
String ProcPara = "";
String strTemp = "";
String CurrentUser = ""+user.getUID();
String SubmiterType = ""+user.getLogintype();
String ClientIP = fu.getRemoteAddr();

String[] logParams;
WorkPlanLogMan logMan = new WorkPlanLogMan();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String method = Util.null2String(fu.getParameter("method"));

String Remark=Util.fromScreen(fu.getParameter("Remark"),user.getLanguage());
String RemarkDoc=Util.fromScreen(fu.getParameter("RemarkDoc"),user.getLanguage());

String ProjID = Util.null2String(fu.getParameter("ProjID"));
String Members=Util.null2String(fu.getParameter("hrmids02"));/*项目成员*/
if("".equals(Members)){
	Members=Util.null2String(fu.getParameter("members"));
}
if(ProjID.equals("")) ProjID = "0";
boolean canRemind = false;//是否需要出发提醒工作流
rs2.executeProc("Prj_TaskInfo_SelectMaxVersion",""+ProjID);
if(rs2.next()) canRemind = true;

/*项目状态为完成和冻结的时候不能编辑*/
if(!ProjID.equals("")){
	String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID;
	RecordSet.executeSql(sql_tatus);
	RecordSet.next();
	String isactived=RecordSet.getString("isactived");
	//isactived=0,为计划
	//isactived=1,为提交计划
	//isactived=2,为批准计划

	String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
	RecordSet.executeSql(sql_prjstatus);
	RecordSet.next();
	String status_prj=RecordSet.getString("status");
	if(isactived.equals("2")&&(status_prj.equals("3")||status_prj.equals("4"))){//项目冻结或者项目完成
		response.sendRedirect("ViewProject.jsp?ProjID="+ProjID);
		return;
	}
}
if(method.equals("Jianbao"))
{
	ProcPara = ProjID;
	ProcPara += flag+"1";
	ProcPara += flag+RemarkDoc;
	ProcPara += flag+Remark;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("Prj_Jianbao_Insert",ProcPara);

	if(!RemarkDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+RemarkDoc;
		RecordSet.executeSql(tempsql);	
	}

	response.sendRedirect("/proj/data/ViewProject.jsp?log=n&ProjID="+ProjID);
	return;
}

/*2003-4-22*/
String muticontract=Util.null2String(fu.getParameter("muticontract"));



String PrjName=Util.fromScreen(fu.getParameter("name"),user.getLanguage());
String PrjCode=Util.fromScreen(fu.getParameter("procode"),user.getLanguage());
String PrjDesc=Util.fromScreen(fu.getParameter("description"),user.getLanguage());
String PrjType=Util.fromScreen(fu.getParameter("prjtype"),user.getLanguage());
String WorkType=Util.fromScreen(fu.getParameter("worktype"),user.getLanguage());
//String SecuLevel=Util.fromScreen(fu.getParameter("SecuLevel"),user.getLanguage());
String SecuLevel="0";
String PrjStatus=fu.getParameter("status");
String MemberOnly=Util.fromScreen(fu.getParameter("isblock"),user.getLanguage());
if(MemberOnly.equals("")) MemberOnly = "0";
String ManagerView=Util.fromScreen(fu.getParameter("managerview"),user.getLanguage());
if(ManagerView.equals("")) ManagerView = "0";
String passnoworktime=Util.fromScreen(fu.getParameter("passnoworktime"),user.getLanguage());
if(passnoworktime.equals("")) passnoworktime = "0";
String ParentView=Util.fromScreen(fu.getParameter("ParentView"),user.getLanguage());
if(ParentView.equals("")) ParentView = "0";
String MoneyP=Util.fromScreen(fu.getParameter("MoneyP"),user.getLanguage());
String MoneyT=Util.fromScreen(fu.getParameter("MoneyT"),user.getLanguage());
String IncomeP=Util.fromScreen(fu.getParameter("IncomeP"),user.getLanguage());
String IncomeT=Util.fromScreen(fu.getParameter("IncomeT"),user.getLanguage());
String BDateP=Util.null2String(fu.getParameter("BDateP"));
String BTimeP=Util.null2String(fu.getParameter("BTimeP"));
String EDateP=Util.null2String(fu.getParameter("EDateP"));
String ETimeP=Util.null2String(fu.getParameter("ETimeP"));
String BDateT=Util.null2String(fu.getParameter("BDateT"));
String BTimeT=Util.null2String(fu.getParameter("BTimeT"));
String EDateT=Util.null2String(fu.getParameter("EDateT"));
String ETimeT=Util.null2String(fu.getParameter("ETimeT"));
String LabourP=Util.fromScreen(fu.getParameter("LabourP"),user.getLanguage());
String LabourT=Util.fromScreen(fu.getParameter("LabourT"),user.getLanguage());
String Photo=Util.fromScreen(fu.getParameter("Photo"),user.getLanguage());
if(Photo.equals("")) Photo = "0";
String PrjInfo=Util.fromScreen(fu.getParameter("PrjInfo"),user.getLanguage());
String ParentID=Util.fromScreen(fu.getParameter("parentid"),user.getLanguage());
String EnvDoc=Util.fromScreen(fu.getParameter("envaluedoc"),user.getLanguage());
String ConDoc=Util.fromScreen(fu.getParameter("confirmdoc"),user.getLanguage());
String ProDoc=Util.fromScreen(fu.getParameter("proposedoc"),user.getLanguage());
String PrjManager=Util.fromScreen(fu.getParameter("manager"),user.getLanguage());
//根据经理选部门
String PrjDept=ResourceComInfo.getDepartmentID(PrjManager);
String Subcompanyid1=DepartmentComInfo.getSubcompanyid1(PrjDept);

String dff01=Util.null2String(fu.getParameter("dff01"));
String dff02=Util.null2String(fu.getParameter("dff02"));
String dff03=Util.null2String(fu.getParameter("dff03"));
String dff04=Util.null2String(fu.getParameter("dff04"));
String dff05=Util.null2String(fu.getParameter("dff05"));

String nff01=Util.null2String(fu.getParameter("nff01"));
if(nff01.equals("")) nff01="0.0";
String nff02=Util.null2String(fu.getParameter("nff02"));
if(nff02.equals("")) nff02="0.0";
String nff03=Util.null2String(fu.getParameter("nff03"));
if(nff03.equals("")) nff03="0.0";
String nff04=Util.null2String(fu.getParameter("nff04"));
if(nff04.equals("")) nff04="0.0";
String nff05=Util.null2String(fu.getParameter("nff05"));
if(nff05.equals("")) nff05="0.0";

String tff01=Util.fromScreen(fu.getParameter("tff01"),user.getLanguage());
String tff02=Util.fromScreen(fu.getParameter("tff02"),user.getLanguage());
String tff03=Util.fromScreen(fu.getParameter("tff03"),user.getLanguage());
String tff04=Util.fromScreen(fu.getParameter("tff04"),user.getLanguage());
String tff05=Util.fromScreen(fu.getParameter("tff05"),user.getLanguage());

String bff01=Util.null2String(fu.getParameter("bff01"));
if(bff01.equals("")) bff01="0";
String bff02=Util.null2String(fu.getParameter("bff02"));
if(bff02.equals("")) bff02="0";
String bff03=Util.null2String(fu.getParameter("bff03"));
if(bff03.equals("")) bff03="0";
String bff04=Util.null2String(fu.getParameter("bff04"));
if(bff04.equals("")) bff04="0";
String bff05=Util.null2String(fu.getParameter("bff05"));
if(bff05.equals("")) bff05="0";


String proCode = Util.null2String(fu.getParameter("procode"));    //项目编号
int proTemplateId = Util.getIntValue(fu.getParameter("protemplateid"),0);    //项目模板ID

//---------任务自定义字段

//=======================================================================
//TD5130 获取RelationXML中所有的TaskID
//added by hubo, 2006-10-13
String taskRecordIds = Util.null2String(fu.getParameter("taskRecordIds"));
if(taskRecordIds.startsWith(",")){
	taskRecordIds = taskRecordIds.substring(1,taskRecordIds.length());	
}
if(taskRecordIds.endsWith(",")){
	taskRecordIds = taskRecordIds.substring(0,taskRecordIds.length()-1);	
}
//=======================================================================


String[] rowIndexs = fu.getParameterValues("txtRowIndex");   //任务名称
String[] taskNames = fu.getParameterValues("txtTaskName");   //任务名称
String[] workLongs = fu.getParameterValues("txtWorkLong");   //工期
String[] beginDates = fu.getParameterValues("txtBeginDate");  //开始日期
String[] endDates = fu.getParameterValues("txtEndDate");     //结束日期
String[] beginTimes = fu.getParameterValues("txtBeginTime");     //开始时间
String[] endTimes = fu.getParameterValues("txtEndTime");     //结束时间
String[] beforeTasks = fu.getParameterValues("seleBeforeTask"); //前置任务
String[] budgets = fu.getParameterValues("txtBudget");         //预算
String[] managers = fu.getParameterValues("txtManager");       //负责人

//4E8
String[] parentRowIndexs = fu.getParameterValues("txtParentRowIndex");//父任务索引
String[] levels = fu.getParameterValues("txtLevel");       //任务层级
String[] realids = fu.getParameterValues("realid");       //数据库真实id

String[] taskTempletIDs = fu.getParameterValues("templetTaskId");	//任务模板ID
int currentTaskID = 0;																//当前任务ID
String sqlInsTaskRelatedInfo = "";

String linkXml=Util.null2String(fu.getParameter("areaLinkXml"));  //上下级关系的字符串

//TD6879 2007-7-11
if("".equals(PrjType)){
	PrjType = ProjectInfoComInfo.getProjectInfoprjtype(ProjID);
}
//====================================
//TD6720
//2007-5-31
String insertWorkPlan = "";
RecordSet.executeSql("SELECT insertWorkPlan FROM Prj_ProjectType WHERE id="+PrjType+"");
if(RecordSet.next()){
	insertWorkPlan = RecordSet.getString("insertWorkPlan");
}
//编码方式:1,自动;2,手动;
String isuse=CodeUtil.getPrjCodeUse();
//====================================

if(method.equals("add")){
	ProjectInfo.setBff01(bff01);
	ProjectInfo.setBff02(bff02);
	ProjectInfo.setBff03(bff03);
	ProjectInfo.setBff04(bff04);
	ProjectInfo.setBff05(bff05);
	ProjectInfo.setTff01(tff01);
	ProjectInfo.setTff02(tff02);
	ProjectInfo.setTff03(tff03);
	ProjectInfo.setTff04(tff04);
	ProjectInfo.setTff05(tff05);
	ProjectInfo.setNff01(nff01);
	ProjectInfo.setNff02(nff02);
	ProjectInfo.setNff03(nff03);
	ProjectInfo.setNff04(nff04);
	ProjectInfo.setNff05(nff05);
	ProjectInfo.setDff01(dff01);
	ProjectInfo.setDff02(dff02);
	ProjectInfo.setDff03(dff03);
	ProjectInfo.setDff04(dff04);
	ProjectInfo.setDff05(dff05);
	ProjectInfo.setLinkXml(linkXml);
	ProjectInfo.setProTemplateId(proTemplateId);
	ProjectInfo.setProCode(proCode);
	ProjectInfo.setPrjName(PrjName);
	ProjectInfo.setPrjDesc(PrjDesc);
	ProjectInfo.setPrjType(PrjType);
	ProjectInfo.setWorkType(WorkType);
	ProjectInfo.setSecuLevel(SecuLevel);
	ProjectInfo.setMemberOnly(MemberOnly);
	ProjectInfo.setManagerView(ManagerView);
	ProjectInfo.setParentView(ParentView);
	/*ProjectInfo.setMoneyP(MoneyP);
	ProjectInfo.setMoneyT(MoneyT);
	ProjectInfo.setIncomeP(IncomeP);
	ProjectInfo.setIncomeT(IncomeT);
	*/
	/*TD46699 由于以上四列数据库类型为money型，在插入时需要转化数据类型。不然SQL 2000 数据库会报错，改用存储过程更新*/
	
	ProjectInfo.setBDateP(BDateP);
	ProjectInfo.setBTimeP(BTimeP);
	ProjectInfo.setEDateP(EDateP);
	ProjectInfo.setETimeP(ETimeP);
	ProjectInfo.setBDateT(BDateT);
	ProjectInfo.setBTimeT(BTimeT);
	ProjectInfo.setEDateT(EDateT);
	ProjectInfo.setETimeT(ETimeT);
	ProjectInfo.setLabourP(LabourP);
	ProjectInfo.setLabourT(LabourT);
	ProjectInfo.setPhoto(Photo);
	ProjectInfo.setPrjInfo(PrjInfo);
	ProjectInfo.setParentID(ParentID);
	ProjectInfo.setEnvDoc(EnvDoc);
	ProjectInfo.setConDoc(ConDoc);
	ProjectInfo.setProDoc(ProDoc);
	ProjectInfo.setPrjManager(PrjManager);
	ProjectInfo.setPrjDept(PrjDept);
	ProjectInfo.setSubcompanyid1(Subcompanyid1);
	ProjectInfo.setCurrentUser(CurrentUser);
	ProjectInfo.setCurrentDate(CurrentDate);
	ProjectInfo.setCurrentTime(CurrentTime);
	ProjectInfo.addPrjInfo();

	RecordSet.executeProc("Prj_ProjectInfo_InsertID","");
	RecordSet.first();
	ProjID = RecordSet.getString(1);
	
	RecordSet.executeSql("update Prj_ProjectInfo set passnoworktime = "+passnoworktime+" where id = "+ProjID);
	
	CptFieldManager.updateCusfieldValue(ProjID, fu, user);
	/*TD46699 在插入结束后，用存储过程更新 Money类型字段值*/
	ProcPara = ProjID;
	ProcPara += flag+MoneyP;
	ProcPara += flag+MoneyT;
	ProcPara += flag+IncomeP;
	ProcPara += flag+IncomeT;
	RecordSet.executeProc("Prj_ProjectInfo_UpdateForMoney",ProcPara);
	/*TD46699  End*/
	
//修改项目编码 开始
String projectCode ="";
if("1".equals(isuse)){
  CodeBuild cbuild = new CodeBuild(1);
  projectCode=cbuild.getProjCodeStr(ProjID,PrjDesc,PrjType,WorkType);
	
}else if("2".equals(isuse)){
	projectCode=PrjCode;
}

RecordSet.execute("update Prj_ProjectInfo set procode='"+projectCode+"' where id="+ProjID);  
//修改项目编码 结束

  RecordSet.executeProc("Prj_ProjectInfo_UConids",ProjID+flag+muticontract);

//检测项目成员，当任务负责人不在项目成员中时，更新项目成员
  String hrmId111=Members+",";
  if(managers!=null&&managers.length>0){
	   for (int i=0 ;i<managers.length;i++){
		   hrmId111 += managers[i]+",";
	   }
  }
  String[] managers111=hrmId111.split(",");
  List<String> list = new ArrayList<String>();
  for (int i = 0; i < managers111.length; i++) {
	   if(!"".equals(managers111[i])&&!list.contains(managers111[i])){
		   list.add(managers111[i]); 
	   }
  }
  String hrmId112="";
  if(list.size()>0){
	   for(int m=0;m<list.size();m++){
		   hrmId112+=list.get(m)+",";
	   }
	  hrmId112 = hrmId112.substring(0,hrmId112.length()-1);
   }

	ProcPara = ProjID;
	ProcPara += flag+"n";
	ProcPara += flag+RemarkDoc;
	ProcPara += flag+Remark;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("Prj_Log_Insert",ProcPara);
	
    ProcPara = ProjID;
    ProcPara += flag+hrmId112;
	RecordSet.executeProc("Proj_Members_update",ProcPara);

	ProjectInfoComInfo.removeProjectInfoCache();
    
    RecordSet.executeProc("Prj_ShareInfo_Update",PrjType+flag+ProjID);
    //权限添加
	
    PrjViewer.setPrjShareByPrj(""+ProjID);

	if(!EnvDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+EnvDoc;
		RecordSet.executeSql(tempsql);	
	}
	if(!ConDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+ConDoc;
		RecordSet.executeSql(tempsql);	
	}
	if(!ProDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+ProDoc;
		RecordSet.executeSql(tempsql);	
	}
	if(!RemarkDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+RemarkDoc;
		RecordSet.executeSql(tempsql);	
	}



   
    //========项目类型自定义字段开始=====    
    ProjTempletUtil.addProjTypeCDataReal(fu,ProjID);
    //========项目类型自定义字段结束=====
String alltskaccids="";
    String maxEndDate="";//存任务中最大结束日期
	String minBeginDate="";//存任务中最小的开始日期
     //------任务的内容的插入
     HashMap<String,String> taskIndexMap=new HashMap<String,String>();//4E8 存前置任务索引
    if (rowIndexs!=null){
        for (int i=0 ;i<rowIndexs.length;i++){
            int rowIndex = Util.getIntValue(rowIndexs[i],0);
            //String taskName =  new String(Util.null2String(taskNames[i]).getBytes("ISO8859_1") , "UTF-8");
          	String taskName =  Util.null2String(taskNames[i]);
            double workLong = Util.getDoubleValue(workLongs[i],0);
            String beginDate =  Util.null2String(beginDates[i]);
            String endDate =  Util.null2String(endDates[i]);
            String begintime =  Util.null2String(beginTimes[i]);
			if("".equals(minBeginDate)){
            	minBeginDate = beginDate;
            }
			if(beginDate.compareTo(minBeginDate)<0){
            	minBeginDate=beginDate;
            }
            String endtime=  Util.null2String(endTimes[i]);
            if(endDate.compareTo(maxEndDate)>0){
            	maxEndDate=endDate;
            }
            
            int beforeTask = Util.getIntValue(beforeTasks[i],0);
            //float budget = Util.getFloatValue(budgets[i],0);
            String budget =  Util.null2String(budgets[i]);
            String manager =managers[i];
    
    		  int taskTempletID = Util.getIntValue(taskTempletIDs[i],0);
    
    
            //String parentid  = ProjTempletUtil.getParentTaskId(linkXml,rowIndex);
            //int level = ProjTempletUtil.getLevel(linkXml,rowIndex); 
            
    		//4E8
            //System.out.println("rowindex:"+rowIndex+"\tbfindex:"+beforeTask);
            if(beforeTask>0){
              	taskIndexMap.put(""+rowIndex, ""+beforeTask);
            }
            
            String parentid=""+Util.getIntValue(parentRowIndexs[i],0);
            int level=Util.getIntValue(levels[i],1);
           
            //System.out.println("parentindex:"+parentid+"\tlevel:"+level);
            
            String taskid = "0" ;
            String wbscoding = "0" ;
            String version = "0" ;
    
            //以下这段东西需要修改 dongpign 现在只为测试用      

				//====================================================================================================================
				//TD3853,modified by hubo,2006-03-13
				String tempParentIds = "";
				String tempParentHrmIds = "";
				rs2.executeSql("SELECT parentids,parenthrmids FROM Prj_TaskProcess WHERE prjid="+ProjID+" AND taskIndex="+parentid+"");
				if (rs2.next()){
					tempParentIds = rs2.getString(1);
					tempParentHrmIds = rs2.getString(2);
				}
            String parentids = tempParentIds;
            String parenthrmids = tempParentHrmIds;
            //====================================================================================================================
            String taskContent="";
            String taskaccids="";
            RecordSet.executeSql("select taskDesc,accessory from Prj_TemplateTask where id="+taskTempletID);
            if(RecordSet.next()){
            	taskContent=RecordSet.getString("taskDesc");
                taskaccids=Util.null2String( RecordSet.getString("accessory"));
                if(taskaccids.startsWith(",")){
                    taskaccids=taskaccids.substring(1);
                }
            }
            if(!"".equals(taskaccids)){
                alltskaccids+=taskaccids+",";
            }
            if ("".equals(taskName))  taskName=" ";
            if ("".equals(beginDate))  beginDate=" ";
            if ("".equals(endDate))  endDate=" ";
            if ("".equals(budget))  budget="0";
            ProcPara = "";
            ProcPara = ProjID ;
            ProcPara += flag + "" + taskid ;
            ProcPara += flag + "" + wbscoding ;
            ProcPara += flag + "" + taskName ;
            ProcPara += flag + "" + version ;
            ProcPara += flag + "" + beginDate ;
            ProcPara += flag + "" + endDate ;
            ProcPara += flag + "" + workLong ;
            ProcPara += flag + "" + taskContent ; //模板任务内容
            ProcPara += flag + "" + budget ;
            ProcPara += flag + "" + parentid ;
            ProcPara += flag + "" + parentids ;
            ProcPara += flag + "" + parenthrmids ;
            ProcPara += flag + "" + level ;
            ProcPara += flag + "" + manager ;
            ProcPara += flag + "" + beforeTask ;
            ProcPara += flag + "" + "0" ; // real work days
            ProcPara += flag + "" + rowIndex ;  //记录真正的行号
    
            RecordSet.executeProc("Prj_TaskProcess_Insert",ProcPara);  
            
            RecordSet.executeProc("Prj_TaskProcess_SMAXID",""); 
            String TaskIDinsert="";
            while(RecordSet.next()){
            	TaskIDinsert = RecordSet.getString("maxid_1");
            }
          //将存储过程中的parentids和parenthrmids两个字段的值重新赋值  因为hrmid改为多人力资源  Start
            
          	String parentidsinsert= parentids+TaskIDinsert+",";
          	String parenthrmidsinsert= parenthrmids;
          	if(!"".equals(manager)){
          		String[] managerinsert = manager.split(",");
          		for(int l=0;l<managerinsert.length;l++){
          			parenthrmidsinsert+="|"+TaskIDinsert+","+managerinsert[l]+"|";
          		}
          	}
          	RecordSet.executeSql("update Prj_TaskProcess set accessory='"+taskaccids+"',parentids='"+parentidsinsert+"', parenthrmids='"+parenthrmidsinsert+"' where id="+TaskIDinsert);
            //System.out.println(ProcPara);   
    		  currentTaskID = RecordSet.getFlag();
    
    		  //保存模板任务的所需文档
    		  sqlInsTaskRelatedInfo = "INSERT INTO Prj_task_needdoc (taskId,templetTaskId,docMainCategory,docSubCategory,docSecCategory,isNecessary,isTempletTask) SELECT "+TaskIDinsert+","+taskTempletID+",docMainCategory,docSubCategory,docSecCategory,isNecessary,1 FROM Prj_TempletTask_needdoc WHERE templetTaskId='"+taskTempletID+"'";
    		  RecordSet.executeSql(sqlInsTaskRelatedInfo);
    
    		  ////保存模板任务的参考文档
    		  sqlInsTaskRelatedInfo = "INSERT INTO Prj_task_referdoc (taskId,templetTaskId,docid,isTempletTask) SELECT "+TaskIDinsert+","+taskTempletID+",docid,1 FROM Prj_TempletTask_referdoc WHERE templetTaskId='"+taskTempletID+"'";
    		  RecordSet.executeSql(sqlInsTaskRelatedInfo);
    
    		  ////保存模板任务的所需工作流
    		  sqlInsTaskRelatedInfo = "INSERT INTO Prj_task_needwf (taskId,templetTaskId,workflowId,isNecessary,isTempletTask) SELECT "+TaskIDinsert+","+taskTempletID+",workflowId,isNecessary,1 FROM Prj_TempletTask_needwf WHERE templetTaskId='"+taskTempletID+"'";
    		  RecordSet.executeSql(sqlInsTaskRelatedInfo);
            
            RecordSet.executeSql("update Prj_TaskProcess set dsporder ="+i+" where prjid="+ProjID+" and taskIndex="+rowIndex);
            RecordSet.executeSql("update Prj_TaskProcess set workday="+workLong+", begintime='"+begintime+"',endtime='"+endtime+"' where prjid="+ProjID+" and taskIndex="+rowIndex);
            //父任务更新时间和工期
        	PrjTimeAndWorkdayUtil.updateTimeAndWorkday(TaskIDinsert);
        	
        	
        	//任务模板自定义字段Save
			TreeMap<String,JSONObject> openfieldMap= PrjTskFieldComInfo.getOpenFieldMap();
			if(!openfieldMap.isEmpty()){
				Iterator it=openfieldMap.entrySet().iterator();
				String tempsql1 = "select * from Prj_TemplateTask where id="+taskTempletID;
				RecordSet.executeSql(tempsql1);
				RecordSet.next();
				
				//长字段值不能直接拼接sql，包括html文本、多选
			    List<Object> clobValueList = new ArrayList<Object>();
				String sb1 = "update Prj_TaskProcess set ";
				while(it.hasNext()){
					Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
					String k= entry.getKey();
					JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
					String fieldname=v.getString("fieldname");
					int fieldtype=v.getInt("type");
			        String fielddbtype=v.getString("fielddbtype");
			        String fieldhtmltype = v.getString("fieldhtmltype");
			        String val = Util.null2String(RecordSet.getString(fieldname));
			        if (fielddbtype.startsWith("char") ||
							fielddbtype.startsWith("varchar")||fieldtype==256||fieldtype==161) {
						sb1 += fieldname + " = '" + val + "',";
		            } else if(fielddbtype.startsWith("text")||fielddbtype.startsWith("clob")|| FormModeBrowserUtil.isMultiBrowser(fieldhtmltype, ""+fieldtype)){
		           		sb1 += fieldname + " = ?,";
        				clobValueList.add(val);
		            } else {
		                if (Util.null2String(val).equals("")) {
		                	sb1 += fieldname + " = null,";
		                } else {
		                	sb1 += fieldname + " = "+val+",";
		                }
		            }
				}
				
				if (!sb1.equals("")) {
        			sb1 = sb1.substring(0, sb1.length() - 1);
        			sb1 += " where id = " + TaskIDinsert;
        			
        			
        			Object[] clobObjects = new Object[clobValueList.size()];
        			for (int k=0;k<clobValueList.size();k++) {
        				clobObjects[k] = clobValueList.get(k);
        			}
        			RecordSet.executeSql(sb1,false,clobObjects);
        		}
			 }
        }
   
    }
     
     
    if(insertWorkPlan.equals("1")){
    	//添加工作计划
    	WorkPlan workPlan = new WorkPlan();
    	
    	workPlan.setCreaterId(Integer.parseInt(CurrentUser));
        workPlan.setCreateType(Integer.parseInt(SubmiterType));
        workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_ProjectCalendar));        
        workPlan.setWorkPlanName(PrjName);    
        workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
        workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
        workPlan.setResourceId(PrjManager);
		if("".equals( minBeginDate)){
        	minBeginDate=CurrentDate;
        }
	
		workPlan.setBeginDate(minBeginDate);
        workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间    
       
        if("".equals( maxEndDate)){
        	maxEndDate="2099-12-31";
        }
        workPlan.setEndDate(maxEndDate);
        workPlan.setEndTime(Constants.WorkPlan_EndTime);
        
        workPlan.setDescription(Util.convertInput2DB(Util.null2String(fu.getParameter("PrjInfo"))));
        workPlan.setProject(ProjID);
		workPlan.setTask("-1");
        workPlanService.insertWorkPlan(workPlan);  //插入日程
    	

        //插入日程日志
        logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, CurrentUser, fu.getRemoteAddr()};
        logMan.writeViewLog(logParams);
    }
     
    //修改父结点的值
    RecordSet.executeSql("select id,parentid from Prj_TaskProcess where prjid="+ProjID);
    while(RecordSet.next()){
        String id = RecordSet.getString("id");
        String parentid =  RecordSet.getString("parentid");
        
        rs.executeSql("select id from Prj_TaskProcess where prjid="+ProjID+" and taskIndex ="+parentid);
        if (rs.next()){
            String newId = rs.getString(1);
            rs1.executeSql("update Prj_TaskProcess set parentid ="+newId+" where id="+id );
        }
    }
    
    //附件上传开始
    String tempAccessory = "";
    if(!"".equals(accdocids)) {
		rs.executeSql("update Prj_ProjectInfo set accessory='"+accdocids+"' where id ="+ProjID);
	}
    //附件上传结束
    
    //给项目里面的相关附件赋查看权限开始
	/**
    String memberstmp = "";
    RecordSet.executeSql("select userid from PrjShareDetail where prjid="+ProjID);
	while(RecordSet.next()) {
        memberstmp += RecordSet.getString("userid")+",";
	}**/
//	if(!"".equals(accdocids)) {
//	   ProjectAccesory.setAccesoryShareByProj(ProjID) ;
//	}
    if(alltskaccids.endsWith(",")){
        alltskaccids=alltskaccids.substring(0,alltskaccids.length()-1);
    }
    String totalaccdocids=accdocids;
    if(!"".equals(alltskaccids)){
        totalaccdocids+=","+alltskaccids;
    }
    String memberstmp = "";
    HashSet<String> set= CommonShareManager.getPrjCanviewUsers(ProjID);
    for (Iterator iterator = set.iterator(); iterator.hasNext();) {
        String string = (String) iterator.next();
        memberstmp += string +",";
    }
    if(!"".equals(totalaccdocids)) {
        ProjectAccesory.addAccesoryShare(totalaccdocids,memberstmp);
    }
	//给项目里面的相关附件赋查看权限结束
	
	//4E8 前置任务处理
    for(Entry<String,String> entry:taskIndexMap.entrySet()){
	   	 String key= entry.getKey();
	   	 String val= entry.getValue();
	   	 rs.executeSql("update  Prj_taskprocess set  prefinish='"+val+"'  where taskindex='"+key+"' and  prjid="+ProjID);
    }
	
if("viewprojectsub".equalsIgnoreCase(frompage)){//来自子项目创建tab页面
%>	
<script type="text/javascript">
parent.window.location.href="/proj/data/ProjectBlankTab.jsp?isclose=1";
try{
	var parentWin = parent.parent.getParentWindow(parent);
	var dialog = parent.parent.getDialog(parent);
	parentWin._table.reLoad();
}catch (e) {
	
}
</script>
<%
return;		
}else{
		
%>
<script type="text/javascript">
parent.window.location.href="/proj/data/ViewProject.jsp?log=n&ProjID=<%=ProjID %>";
</script>
<%
return;
}
	


}
	
	
	
	




String projStatus ="";
RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if (RecordSet.next()){
   projStatus = RecordSet.getString("status");
}

if(method.equals("edit")){
	boolean bNeedUpdate = false;
	boolean bShareUpdate = false;    
    //String Members_d = RecordSet.getString("members");
	String Members_d=Util.null2String(fu.getParameter("members"));
    ArrayList Members01 = Util.TokenizerString(Members_d,",");
    int Member_length_01 = Members01.size();
    
  //检测项目成员，当任务负责人不在项目成员中时，更新项目成员
    String hrmId111=Members+",";
    String sqlM = "select * from Prj_TaskProcess where prjid="+ProjID;
    RecordSetM.executeSql(sqlM);
   	while(RecordSetM.next()){
   		hrmId111+=RecordSetM.getString("hrmid")+",";
   	}
    String[] managers111=hrmId111.split(",");
    List<String> list = new ArrayList<String>();
    for (int i = 0; i < managers111.length; i++) {
  	   if(!"".equals(managers111[i])&&!list.contains(managers111[i])){
  		   list.add(managers111[i]); 
  	   }
    }
    String hrmId112="";
    if(list.size()>0){
  	   for(int m=0;m<list.size();m++){
  		   hrmId112+=list.get(m)+",";
  	   }
  	  hrmId112 = hrmId112.substring(0,hrmId112.length()-1);
     }

    ArrayList Members02 = Util.TokenizerString(hrmId112,",");
    int Member_length_02 = Members02.size();
    out.print(Member_length_01);
    boolean membercheck=false;
    
      if(Member_length_01<Member_length_02){
        for(int i=0;i<Member_length_02;i++){
            if(Members01.indexOf(Members02.get(i)) == -1){
                 membercheck=true;
        }
        }
      }
      if(Member_length_01>Member_length_02){
        for(int i=0;i<Member_length_01;i++){
            if(Members02.indexOf(Members01.get(i)) == -1){
                 membercheck=true;
        }
        }
      }
        if(membercheck){
                ProcPara = ProjID+flag+"m";
                ProcPara += flag+"members"+flag+CurrentDate+flag+CurrentTime+flag+Members_d+flag+Members;
                ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
                RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);   

                ProcPara =ProjID;
                ProcPara += flag +hrmId112;
                RecordSetM.executeProc("Proj_Members_update",ProcPara);

        		bShareUpdate = true;
        }


    String contractids_d = RecordSet.getString("contractids");
    ArrayList contractids01 = Util.TokenizerString(contractids_d,",");
    int Con_length_01 = contractids01.size();
    ArrayList contractids02 = Util.TokenizerString(muticontract,",");
    int Con_length_02 = contractids02.size();
    
    boolean concheck=false;
    
      if(Con_length_01<Con_length_02){
        for(int i=0;i<Con_length_02;i++){
            if(contractids01.indexOf(contractids02.get(i)) == -1){
                 concheck=true;
        }
        }
      }
      if(Con_length_01>Con_length_02){
        for(int i=0;i<Con_length_01;i++){
            if(contractids02.indexOf(contractids01.get(i)) == -1){
                 concheck=true;
        }
        }
      }

    if(concheck){
            ProcPara = ProjID+flag+"m";
            ProcPara += flag+"contract"+flag+CurrentDate+flag+CurrentTime+flag+contractids_d+flag+muticontract;
            ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
            RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);   

            RecordSet.executeProc("Prj_ProjectInfo_UConids",ProjID+flag+muticontract);

    
    }


	strTemp = RecordSet.getString("name");
	if(!PrjName.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"name"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjName;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("description");
	if(!PrjDesc.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"description"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjDesc;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
		bShareUpdate = true;
	}

	strTemp = RecordSet.getString("prjtype");
	if(!PrjType.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"prjtype"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjType;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

    strTemp = RecordSet.getString("proCode");
    if("2".equals(isuse)){//手动编码
    	if(!proCode.equals(strTemp))
    	{
    		ProcPara = ProjID+flag+"m";
    		ProcPara += flag+"proCode"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+proCode;
    		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
    		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
    		bNeedUpdate = true;
    	}
    }else if("1".equals(isuse)){//自动编码
    	proCode=strTemp;
    }else{//不编码
    	proCode="";
    }
	

    strTemp = RecordSet.getString("protemplateid");
	if(!strTemp.equals(""+proTemplateId))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"proTemplateId"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+""+proTemplateId;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("worktype");
	if(!WorkType.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"worktype"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+WorkType;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("securelevel");
	if(!SecuLevel.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"securelevel"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+SecuLevel;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("status");
	if(!PrjStatus.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"status"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjStatus;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("isblock");
	if(!MemberOnly.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"isblock"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+MemberOnly;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
		bShareUpdate = true;
	}


	strTemp = RecordSet.getString("managerview");
	if(!ManagerView.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"managerview"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+ManagerView;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
        bShareUpdate = true;
	}


	strTemp = RecordSet.getString("picid");
	if(!Photo.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"picid"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Photo;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("intro");
	if(!PrjInfo.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"intro"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjInfo;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("parentid");
	if(!ParentID.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"parentid"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+ParentID;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("envaluedoc");
	if(!EnvDoc.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"envaluedoc"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+EnvDoc;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("confirmdoc");
	if(!ConDoc.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"confirmdoc"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+ConDoc;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("proposedoc");
	if(!ProDoc.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"proposedoc"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+ProDoc;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("manager");
	if(!PrjManager.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"manager"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjManager;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
		bShareUpdate = true;
		
	}

	strTemp = RecordSet.getString("department");
	if(!PrjDept.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"department"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjDept;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
		bShareUpdate = true;
	}

	strTemp = RecordSet.getString("datefield1");
	if(!dff01.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"datefield1"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield2");
	if(!dff02.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"datefield2"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield3");
	if(!dff03.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"datefield3"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield4");
	if(!dff04.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"datefield4"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield5");
	if(!dff05.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"datefield5"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield1");
	if(!nff01.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"numberfield1"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield2");
	if(!nff02.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"numberfield2"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield3");
	if(!nff03.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"numberfield3"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield4");
	if(!nff04.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"numberfield4"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield5");
	if(!nff05.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"numberfield5"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield1");
	if(!tff01.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"textfield1"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield2");
	if(!tff02.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"textfield2"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield3");
	if(!tff03.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"textfield3"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield4");
	if(!tff04.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"textfield4"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield5");
	if(!tff05.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"textfield5"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield1");
	if(!bff01.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"tinyintfield1"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield2");
	if(!bff02.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"tinyintfield2"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield3");
	if(!bff03.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"tinyintfield3"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield4");
	if(!bff04.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"tinyintfield4"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield5");
	if(!bff05.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"tinyintfield5"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
    bNeedUpdate = true ;
	if(bNeedUpdate)
	{
		ProjectInfo.setId(ProjID);
	ProjectInfo.setBff01(bff01);
	ProjectInfo.setBff02(bff02);
	ProjectInfo.setBff03(bff03);
	ProjectInfo.setBff04(bff04);
	ProjectInfo.setBff05(bff05);
	ProjectInfo.setTff01(tff01);
	ProjectInfo.setTff02(tff02);
	ProjectInfo.setTff03(tff03);
	ProjectInfo.setTff04(tff04);
	ProjectInfo.setTff05(tff05);
	ProjectInfo.setNff01(nff01);
	ProjectInfo.setNff02(nff02);
	ProjectInfo.setNff03(nff03);
	ProjectInfo.setNff04(nff04);
	ProjectInfo.setNff05(nff05);
	ProjectInfo.setDff01(dff01);
	ProjectInfo.setDff02(dff02);
	ProjectInfo.setDff03(dff03);
	ProjectInfo.setDff04(dff04);
	ProjectInfo.setDff05(dff05);
	ProjectInfo.setLinkXml(linkXml);
	ProjectInfo.setProTemplateId(proTemplateId);
	ProjectInfo.setProCode(proCode);
	ProjectInfo.setPrjName(PrjName);
	ProjectInfo.setPrjDesc(PrjDesc);
	ProjectInfo.setPrjType(Util.getIntValue(PrjType,-1)+"");
	ProjectInfo.setWorkType(Util.getIntValue(WorkType,-1)+"");
	ProjectInfo.setSecuLevel(Util.getIntValue(SecuLevel,-1)+"");
	ProjectInfo.setMemberOnly(Util.getIntValue(MemberOnly,-1)+"");
	ProjectInfo.setManagerView(Util.getIntValue(ManagerView,-1)+"");
	ProjectInfo.setParentView(Util.getIntValue(ParentView,-1)+"");
	/*ProjectInfo.setMoneyP(MoneyP);
	ProjectInfo.setMoneyT(MoneyT);
	ProjectInfo.setIncomeP(IncomeP);
	ProjectInfo.setIncomeT(IncomeT);*/
	/*TD46699 由于以上四列数据库类型为money型，需要转化数据类型。不然SQL 2000 数据库会报错，改用存储过程更新*/
	ProjectInfo.setBDateP(BDateP);
	ProjectInfo.setBTimeP(BTimeP);
	ProjectInfo.setEDateP(EDateP);
	ProjectInfo.setETimeP(ETimeP);
	ProjectInfo.setBDateT(BDateT);
	ProjectInfo.setBTimeT(BTimeT);
	ProjectInfo.setEDateT(EDateT);
	ProjectInfo.setETimeT(ETimeT);
	ProjectInfo.setLabourP(LabourP);
	ProjectInfo.setLabourT(LabourT);
	ProjectInfo.setPhoto(Util.getIntValue(Photo,-1)+"");
	ProjectInfo.setPrjInfo(PrjInfo);
	ProjectInfo.setParentID(Util.getIntValue(ParentID,-1)+"");
	ProjectInfo.setEnvDoc(Util.getIntValue(EnvDoc,-1)+"");
	ProjectInfo.setConDoc(Util.getIntValue(ConDoc,-1)+"");
	ProjectInfo.setProDoc(Util.getIntValue(ProDoc,-1)+"");
	ProjectInfo.setPrjManager(Util.getIntValue(PrjManager,-1)+"");
	ProjectInfo.setPrjDept(Util.getIntValue(PrjDept,-1)+"");
	ProjectInfo.setSubcompanyid1(Util.getIntValue(Subcompanyid1,-1)+"");
	ProjectInfo.setCurrentUser(CurrentUser);
	ProjectInfo.setCurrentDate(CurrentDate);
	ProjectInfo.setCurrentTime(CurrentTime);
	ProjectInfo.setPrjStatus(Util.getIntValue(PrjStatus,-1)+"");
	//System.out.println("ProjID:"+ProjID);
	ProjectInfo.editPrjInfo();
	
	CptFieldManager.updateCusfieldValue(ProjID, fu, user);
	/************TD46699 在结束后，用存储过程更新 Money类型字段值****************/
	ProcPara = ProjID;
	ProcPara += flag+MoneyP;
	ProcPara += flag+MoneyT;
	ProcPara += flag+IncomeP;
	ProcPara += flag+IncomeT;
	RecordSet.executeProc("Prj_ProjectInfo_UpdateForMoney",ProcPara);
	/*****************TD46699  End****************/
		ProjectInfoComInfo.removeProjectInfoCache();

		

 
        ProcPara = ProjID;
        ProcPara += flag+"m";
        ProcPara += flag+RemarkDoc;
        ProcPara += flag+Remark;
        ProcPara += flag+CurrentDate;
        ProcPara += flag+CurrentTime;
        ProcPara += flag+CurrentUser;
        ProcPara += flag+SubmiterType;
        ProcPara += flag+ClientIP;
        RecordSet.executeProc("Prj_Log_Insert",ProcPara);

        //========编辑项目类型自定义字段开始=====    
        ProjTempletUtil.editProjTypeCDataReal(fu,ProjID);
        //========编辑项目类型自定义字段结束=====   
	}

	if(bShareUpdate)
	{
		PrjViewer.setPrjShareByPrj(""+ProjID);
	}

	if(!EnvDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+EnvDoc;
		RecordSet.executeSql(tempsql);	
	}
	if(!ConDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+ConDoc;
		RecordSet.executeSql(tempsql);	
	}
	if(!ProDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+ProDoc;
		RecordSet.executeSql(tempsql);	
	}
	if(!RemarkDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+RemarkDoc;
		RecordSet.executeSql(tempsql);	
	}        
    
	RecordSet.executeSql("update Prj_ProjectInfo set passnoworktime = "+passnoworktime+" where id = "+ProjID);
	
	//相关附件操作开始
    String newAccessory = "";
	RecordSet.executeSql("SELECT accessory FROM Prj_ProjectInfo WHERE id = " + ProjID);
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
    
    if(!"".equals(accdocids)){
	    RecordSet.executeSql("update Prj_ProjectInfo set accessory ='"+newAccessory+accdocids+"' where id = "+ProjID);    
	    
		//给项目里面的相关附件赋查看权限开始
		/**
		String memberstmp = "";
		RecordSet.executeSql("select userid from PrjShareDetail where prjid="+ProjID);
		while(RecordSet.next()) {
			memberstmp += RecordSet.getString("userid")+",";
		}
		**/
		ProjectAccesory.setAccesoryShareByProj(ProjID);
		//给项目里面的相关附件赋查看权限结束
		
	}
    //相关附件操作结束
    
	response.sendRedirect("/proj/data/ViewProject.jsp?isfromProjTab=1&log=n&ProjID="+ProjID);
	return;
  
} 





if(method.equals("editTask")){
	//检测项目成员，当任务负责人不在项目成员中时，更新项目成员
	  String hrmId111=Members+",";
	  if(managers!=null&&managers.length>0){
		   for (int i=0 ;i<managers.length;i++){
			   hrmId111 += managers[i]+",";
		   }
	  }
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
	double ptype=Util.getDoubleValue( CommonShareManager.getPrjPermissionType(""+ProjID, user),0 );
    RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
    if(RecordSet.next()){
        PrjManager = RecordSet.getString("manager");
    }

    boolean needAprove = false  ;
	boolean bNeedUpdate=false;
        //if (!"0".equals(projStatus)&&!"7".equals(projStatus)) needAprove = true ;
        int status = 0;
        
        HashMap<String,String> taskIndexMap=new HashMap<String,String>();//4E8 存前置任务索引
		HashMap<String,String> taskOrderMap=new HashMap<String,String>();//4E8 存任务显示顺序与任务索引号对应关系
		taskOrderMap.put("0","0");
		String maxEndDate="";
        //1:表示项目审批过后正常状态   2:表项目为延期状态   5:表项目为立项批准状态
        if (rowIndexs!=null)
                                for (int i=0 ;i<rowIndexs.length;i++){
                                    int rowIndex = Util.getIntValue(rowIndexs[i],0);
                                    //String taskName =  new String(Util.null2String(taskNames[i]).getBytes("ISO8859_1") , "UTF-8");
                                   	String taskName =  Util.null2String(taskNames[i]);
                                    float workLong = Util.getFloatValue(workLongs[i],0);
                                    String beginDate =  Util.null2String(beginDates[i]);
                                    String endDate =  Util.null2String(endDates[i]);
                                    String begintime =  Util.null2String(beginTimes[i]);
                                    String endtime=  Util.null2String(endTimes[i]);
                                    
                                    if(endDate.compareTo(maxEndDate)>0){
                                    	maxEndDate=endDate;
                                    }
                                    int beforeTask = Util.getIntValue(beforeTasks[i],0);
                                    //float budget = Util.getFloatValue(budgets[i],0);
                                    String budget =  Util.null2String(budgets[i]);
                                    String hrmid =  Util.null2String(managers[i]);
                                    if(budget.equals("")) budget = "0";
                                    String manager = "";
									try{
										manager =managers[i];
									}catch(Exception e){
									
									}
                                   
                                    //String parentid  = ProjTempletUtil.getParentTaskId(linkXml,rowIndex);
                                    //int level = ProjTempletUtil.getLevel(linkXml,rowIndex); 
                                    
                                    //4E8
                                    int taskrecordid = Util.getIntValue(realids[i],0);
                                    
                                    String parentid=""+Util.getIntValue(parentRowIndexs[i],0);
                                    
                                    if (!"0".equals(projStatus)&&!"7".equals(projStatus)&& (ProjectTransUtil.needApproveTask(parentid, PrjManager, user))) needAprove = true ;
                                    
                                    int level=Util.getIntValue(levels[i],1);
                                    //System.out.println("parentindex:"+parentid+"\tlevel:"+level);
                                   
                                    taskOrderMap.put(""+rowIndex,""+(i+1));
                    	            if(beforeTask>0){
                    	              	taskIndexMap.put(""+rowIndex, ""+beforeTask);
                    	            }
                    	            
                    	            //System.out.println("rowIndex:"+rowIndex+" parentTaskId: "+parentid+" beforetaskindex: "+beforeTask+" taskrealid:"+taskrecordid+"taskName:"+taskName);
                                    
                        
                                    String taskid = "0" ;
                                    String wbscoding = "0" ;
                                    String version = "0" ;
                            
												//====================================================================================================================
                                    //TD3853,modified by hubo,2006-03-13
												String tempParentIds = "";
												String tempParentHrmIds = "";
												rs2.executeSql("select id,parentids,parenthrmids from Prj_TaskProcess where prjid="+ProjID+" and taskIndex ="+parentid);
												if (rs2.next()){
													parentid=rs2.getString(1);
													tempParentIds = rs2.getString(2);
													tempParentHrmIds = rs2.getString(3);
												}
												String parentids = tempParentIds;
												String parenthrmids = tempParentHrmIds;   
												//====================================================================================================================

                        
                                    if ("".equals(taskName))  taskName=" ";
                                    if ("".equals(beginDate))  beginDate=" ";
                                    /** nouse@20140729
									//if (ProjTempletUtil.isProjTaskExist(ProjID,""+rowIndex))
                                    //     bNeedUpdate = false ;
                                    //int taskrecordid = 0 ;
                                    //rs.executeSql("select id from Prj_TaskProcess where prjid="+ProjID+" and taskIndex="+rowIndex);
                                   // if (rs.next()) taskrecordid = Util.getIntValue(rs.getString(1),0);
                                    **/
                                    
                                    if(taskrecordid>0){
                                    	bNeedUpdate = false ;
                                        strTemp="";
                                        int oldStatus=0;
                                        RecordSetM.executeProc("Prj_TaskProcess_SelectByID",""+taskrecordid);
                                        if( RecordSetM.next())  {
                                        	oldStatus=Util.getIntValue(RecordSetM.getString("status"),0);
                                            /*修改主题*/
                                            strTemp = RecordSetM.getString("subject");
                                            if(!taskName.equals(strTemp)){
                                                ProcPara =ProjID+flag + taskrecordid +flag + "1352" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ taskName+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType + flag +"0";
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                            }
                                            /*修改负责人*/
                                            strTemp = RecordSetM.getString("hrmid");
                                            if(!manager.equals(strTemp)){
                                                ProcPara =ProjID+flag + taskrecordid +flag + "2097" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ manager+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                                
                                                //触发工作流通知原任务负责人和现任务负责人，若其中有一个是现登陆者，那么就不用再通知本人。
                                                if(canRemind&&CurrentUser.equals(PrjManager)){//修改者是经理
                                                    String SWFAccepter="";
                                                    String Subject="";
                                                    String SWFTitle="";
                                                    String SWFRemark="";
                                                    String SWFSubmiter="";
                                                    String CurrentUserName = ""+user.getUsername();
                                                
                                                    if(!"".equals(strTemp)){//原来有设置负责人
                                                		String warnpeople1 = "";
                                                		if(!"".equals(manager)){
                                                			strTemp+=","+manager;
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
                                              			 if(!"".equals(warnpeople1)){
                                              				warnpeople1 = warnpeople1.substring(0,warnpeople1.length()-1);
                                              			 }
                                              		   }
                                             		  SWFAccepter=warnpeople1;
                                                	}else{//原来没有设置负责人
                                                		String warnpeople = "";
                                                		String[] hrmids = manager.split(",");
                                                		for(int l=0;l<hrmids.length;l++){
                                                			if(!CurrentUser.equals(hrmids[l])){
                                                				warnpeople+=hrmids[l]+",";
                                                			}
                                                		}
                                                		SWFAccepter=warnpeople;
                                                	}
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
                                                     Subject+=":"+taskName+"-";
                                                     Subject+=SystemEnv.getHtmlLabelName(15285,user.getLanguage());
                                                     Subject+=":"+name;
                                                     
                                                     SWFTitle=SystemEnv.getHtmlLabelName(15284,user.getLanguage());
                                                     SWFTitle += ":"+taskName;
                                                     SWFTitle += "-"+CurrentUserName;
                                                     SWFTitle += "-"+CurrentDate;
                                                     SWFRemark="<a href=/proj/process/ViewProcess.jsp?ProjID="+ProjID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
                                                     SWFSubmiter=CurrentUser;

                                                     SysRemindWorkflow.setPrjSysRemind(SWFTitle,Util.getIntValue(ProjID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
                                                }
                                                
                                            }
															
														//================================================
														//TD3900
														//modified by hubo,2006-04-05
                                            strTemp = RecordSetM.getString("begindate").trim();
                                            if(!(beginDate.trim()).equals(strTemp)){
														//================================================
                                                ProcPara =ProjID+flag + taskrecordid +flag + "1322" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ beginDate+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                            }
                                            strTemp = RecordSetM.getString("enddate");
                                            if(!endDate.equals(strTemp)){
                                                ProcPara =ProjID+flag + taskrecordid +flag + "741" + flag + CurrentDate +  flag + CurrentTime + flag+ strTemp+flag+ endDate+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                            }
                        
                        
                                            strTemp = RecordSetM.getString("workday");
                                            if(workLong!=Util.getFloatValue(strTemp)){
                                                ProcPara =ProjID+flag + taskrecordid +flag + "1298" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ workLong+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                            }
                        
                                            strTemp = Util.null2String(RecordSetM.getString("fixedcost"));
                                            if(strTemp.equals("")) strTemp = "0";
                                            //if(budget!=Util.getFloatValue(strTemp)){
                                            if((new BigDecimal(strTemp)).compareTo(new BigDecimal(budget))!=0){
                                                ProcPara =ProjID+flag + taskrecordid +flag + "15274" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ budget+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                            }
                                            strTemp = Util.null2String(RecordSetM.getString("prefinish"));                    if(!(beforeTask==Util.getIntValue(strTemp))){                   
                                                ProcPara =ProjID+flag + taskrecordid +flag + "2233" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ beforeTask+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+flag+"0" ;
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                            }

                                            if(bNeedUpdate){
                                                ProcPara = ProjID ;
                                                ProcPara += flag + "" + taskrecordid ;
                                                ProcPara += flag + "" + RecordSetM.getString("subject") ;
                                                ProcPara += flag + "" + RecordSetM.getString("hrmid") ;
                                                ProcPara += flag + "" + RecordSetM.getString("begindate") ;
                                                ProcPara += flag + "" + RecordSetM.getString("enddate") ;
                                                ProcPara += flag + "" + RecordSetM.getString("workday") ;
                                                ProcPara += flag + "" + RecordSetM.getString("fixedcost") ;
                                                ProcPara += flag + "" + RecordSetM.getString("finish") ;
                                                ProcPara += flag + "" + RecordSetM.getString("parentid") ;
                                                ProcPara += flag + "" + RecordSetM.getString("prefinish") ;
                                                ProcPara += flag + "" + RecordSetM.getString("islandmark") ;
                                                ProcPara += flag + "" + CurrentDate ;
                                                ProcPara += flag + "" + CurrentTime ;
                                                ProcPara += flag + "" + CurrentUser ;
                                                ProcPara += flag + "" + "0"; /*Status*/
                                                ProcPara += flag + "" + "2" ;
                                                ProcPara += flag + "" + ClientIP ;
                                                ProcPara += flag + "" + RecordSetM.getString("realmandays") ;

                                                RecordSet.executeProc("Prj_TaskModifyLog_Insert",ProcPara);
                                            }
                                        }
                                            
                                        if(oldStatus!=0){
                                        	status=oldStatus;
                                        }else if (ptype==2.5||!needAprove){
											status = 0;
                                        }else if(!bNeedUpdate){
                                        	//如果没有什么改动的话，还是原来的状态 
											status = RecordSetM.getInt("status");
                                        }else{
											status = 2;
                                        }
										//System.out.println("ptype:"+ptype+",needapprove:"+needAprove+",taskname:"+taskName+",needupdate:"+bNeedUpdate+", status:"+status);
										//String strsqlForTask="update Prj_TaskProcess set subject='"+taskName+"',hrmid="+manager+",begindate='"+beginDate+"',enddate='"+endDate+"',workday="+workLong+",fixedcost="+budget+",prefinish="+beforeTask+",parentid="+parentid+",level_n="+level+",dsporder="+i+",status="+status+" where prjid="+ProjID+" and taskIndex="+rowIndex;
										parentids+=""+taskrecordid+",";
										if(!"".equals(manager)){
						      	      		String[] hrmidupdate = manager.split(",");
						      	      		for(int m=0;m<hrmidupdate.length;m++){
						      	      		parenthrmids+="|"+taskrecordid+","+hrmidupdate[m]+"|";
						      	      		}
						      	      	}
										String strsqlForTask="update Prj_TaskProcess set subject='"+taskName+"',hrmid='"+manager+"',begintime='"+begintime+"',endtime='"+endtime+"',begindate='"+beginDate+"',enddate='"+endDate+"',workday="+workLong+",fixedcost="+budget+",prefinish="+beforeTask+",parentid="+parentid+",level_n="+level+",dsporder="+i+",status="+status+",parentids='"+parentids+"',parenthrmids='"+parenthrmids+"' where prjid="+ProjID+" and taskIndex="+rowIndex;
										rs.executeSql(strsqlForTask);
										//====================================================================
										//TD3853,added by hubo,2006-03-13
										String oldhrmid = RecordSetM.getString("hrmid");
										//ProcPara = ""+manager + flag + ""+oldhrmid + flag + ""+taskrecordid;
										//rs.executeProc("Prj_TaskProcess_UParentHrmIds",ProcPara);
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
								      			rs5.next();
								      			String pphrmid = Util.null2String(rs5.getString("hrmid"));
								      			if(!"".equals(pphrmid)){
								      				String[] hrmidupdate = pphrmid.split(",");
								      	      		for(int m=0;m<hrmidupdate.length;m++){
								      	      			parenthrmidsupdate+="|"+parentidseach+","+hrmidupdate[m]+"|";
								      	      		}
								      	      	}
								      		}
						      	      		RecordSet.executeSql("update Prj_TaskProcess set parenthrmids='"+parenthrmidsupdate+"' where id="+taskrecordid);
								      	}
								      	//将存储过程中的parenthrmids两个字段的值重新赋值  因为hrmid改为多人力资源  End
										//====================================================================
								      //父任务更新时间和工期
                                    	PrjTimeAndWorkdayUtil.updateTimeAndWorkday(taskrecordid+"");


                                    } else {
                        
                                        ProcPara = "";
                                        ProcPara = ProjID ;
                                        ProcPara += flag + "" + taskid ;
                                        ProcPara += flag + "" + wbscoding ;
                                        ProcPara += flag + "" + taskName ;
                                        ProcPara += flag + "" + version ;
                                        ProcPara += flag + "" + beginDate ;
                                        ProcPara += flag + "" + endDate ;
                                        ProcPara += flag + "" + workLong ;
                                        ProcPara += flag + "" + " " ;
                                        ProcPara += flag + "" + budget ;
                                        ProcPara += flag + "" + parentid ;
                                        ProcPara += flag + "" + parentids ;
                                        ProcPara += flag + "" + parenthrmids ;
                                        ProcPara += flag + "" + level ;
                                        ProcPara += flag + "" + manager ;
                                        ProcPara += flag + "" + beforeTask ;
                                        ProcPara += flag + "" + "0" ; // real work days
                                        ProcPara += flag + "" + rowIndex ;  //记录真正的行号
                        
                                        RecordSet.executeProc("Prj_TaskProcess_Insert",ProcPara);  
                                        
                                        String TaskID="0";
                                        RecordSet.executeProc("Prj_TaskProcess_SMAXID","");
                                        if (RecordSet.next())   TaskID = RecordSet.getString("maxid_1");
                                      //将存储过程中的parentids和parenthrmids两个字段的值重新赋值  因为hrmid改为多人力资源  Start
                                        
                                      	String parentidsinsert= parentids+TaskID+",";
                                      	String parenthrmidsinsert= parenthrmids;
                                      	if(!"".equals(manager)){
                                      		String[] hrmidsinsert = manager.split(",");
                                      		for(int l=0;l<hrmidsinsert.length;l++){
                                      			parenthrmidsinsert+="|"+TaskID+","+hrmidsinsert[l]+"|";
                                      		}
                                      	}
                                      	RecordSet.executeSql("update Prj_TaskProcess set parentids='"+parentidsinsert+"', parenthrmids='"+parenthrmidsinsert+"' where id="+TaskID);
                                      	//将存储过程中的parentids和parenthrmids两个字段的值重新赋值  因为hrmid改为多人力资源  End
                                        ProcPara = ProjID ;
                                        ProcPara += flag + "" + TaskID ;
                                        ProcPara += flag + "np"  ;
                                        ProcPara += flag + "" + CurrentDate ;
                                        ProcPara += flag + "" + CurrentTime ;
                                        ProcPara += flag + "" + CurrentUser ;
                                        ProcPara += flag + "" + ClientIP ;
                                        ProcPara += flag + "" + SubmiterType ;
                                        RecordSet.executeProc("Prj_TaskLog_Insert",ProcPara);
                                        
                                        if (ptype==2.5||!needAprove)   status = 0;
                                        else  status = 1;
                                        rs.executeSql("update Prj_TaskProcess set dsporder ="+i+" ,status="+status+" where prjid="+ProjID+" and taskIndex="+rowIndex);
                                        //strsqlForTask = "insert into Prj_TaskProcess (prjid,taskIndex,subject,hrmid,begindate,enddate,workday,fixedcost,prefinish) values("+ProjID+","+rowIndex+",'"+taskName+"',"+manager+",'"+beginDate+"','"+endDate+"',"+workLong+","+budget+","+beforeTask+")"; 
                                        
                                         rs.executeSql("update Prj_TaskProcess set begintime='"+begintime+"',endtime='"+endtime+"' where prjid="+ProjID+" and taskIndex="+rowIndex);
                                        
                                        //添加工作计划Begin
								        if ("1".equals( insertWorkPlan) &&(!"0".equals(projStatus) && !"6".equals(projStatus) && !"7".equals(projStatus) && !"".equals(projStatus)) ) 
								        {
											//添加工作计划
								       		WorkPlan workPlan = new WorkPlan();
								       		workPlan.setCreaterId(Integer.parseInt(CurrentUser));
								
								       	    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_ProjectCalendar));        
								       	    workPlan.setWorkPlanName(taskName);    
								       	    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
								       	    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
								       	    workPlan.setResourceId(""+manager);           	    
								       	    workPlan.setBeginDate(beginDate);           	    
								       	    workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间	    
								       	    workPlan.setEndDate(endDate);
								       	    workPlan.setEndTime(Constants.WorkPlan_EndTime);  //结束时间
								       	    workPlan.setDescription(Util.convertInput2DB(Util.null2String("")));
								       	    workPlan.setProject(ProjID);
								       	    workPlan.setTask(TaskID);
								
								       	    workPlanService.insertWorkPlan(workPlan);  //插入日程
								
											//插入日志
								            logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, CurrentUser, Util.getIpAddr(request)};
								            logMan.writeViewLog(logParams);
								
								        }
								        //添加工作计划End
                                        
                                        
                                        
                                        //触发工作流通知原任务负责人和现任务负责人，若其中有一个是现登陆者，那么就不用再通知本人。
                                        if(canRemind&&CurrentUser.equals(PrjManager)&&!(""+manager).equals("")){//修改者是经理,并且任务负责人不为空
                                            String SWFAccepter="";
                                            String Subject="";
                                            String SWFTitle="";
                                            String SWFRemark="";
                                            String SWFSubmiter="";
                                            String CurrentUserName = ""+user.getUsername();
                                                
                                            if(!CurrentUser.equals(""+manager)){//任务负责人不是当前操作者
                                                SWFAccepter = ""+manager;
                                            }

                                            String name=ResourceComInfo.getResourcename(""+manager);
                                            Subject=SystemEnv.getHtmlLabelName(15284,user.getLanguage());
                                            Subject+=":"+taskName+"-";
                                            Subject+=SystemEnv.getHtmlLabelName(15285,user.getLanguage());
                                            Subject+=":"+name;
                                                     
                                            SWFTitle=SystemEnv.getHtmlLabelName(15284,user.getLanguage());
                                            SWFTitle += ":"+taskName;
                                            SWFTitle += "-"+CurrentUserName;
                                            SWFTitle += "-"+CurrentDate;
                                            SWFRemark="<a href=/proj/process/ViewProcess.jsp?ProjID="+ProjID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
                                            SWFSubmiter=CurrentUser;

                                            SysRemindWorkflow.setPrjSysRemind(SWFTitle,Util.getIntValue(ProjID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
                                        }
                                      //父任务更新时间和工期
                                    	PrjTimeAndWorkdayUtil.updateTimeAndWorkday(TaskID);
                                    }


                                  
                                    //System.out.println(strsqlForTask);
        }
                                    
                                    
       //System.out.println("=======================split line2====================");                        
                                    
        ArrayList rowIndexList = Util.arrayToArrayList(rowIndexs);
        rs.executeSql("select id,taskIndex from Prj_TaskProcess where prjid="+ProjID);
        while (rs.next()){
            String taskId = Util.null2String(rs.getString("id"));
            String taskIndexId = Util.null2String(rs.getString("taskIndex"));           

            //如果从客户端传过来的数据中不存在此任务的ID则需删掉此任务
            if (rowIndexList.indexOf(taskIndexId)==-1){                             
                ProcPara = ProjID ;
                ProcPara += flag + "" + taskId ;
                ProcPara += flag + "dp"  ;
                ProcPara += flag + "" + CurrentDate ;
                ProcPara += flag + "" + CurrentTime ;
                ProcPara += flag + "" + CurrentUser ;
                ProcPara += flag + "" + ClientIP ;
                ProcPara += flag + "" + SubmiterType ;
                RecordSet.executeProc("Prj_TaskLog_Insert",ProcPara);
                
                if (ptype==2.5||!needAprove) {
                   
                 String parentidss =PrjImpUtil.getTaskParentids(Util.getIntValue(taskId,0) ,new StringBuffer() ).toString();
                 
                  //真正的删除操作
                  rs1.executeSql("delete Prj_TaskProcess where id = "+taskId+" and status=0");
                 //删除前更新父任务进度
              
		           ArrayList arrayParentidss = Util.TokenizerString(parentidss,",");
                   for( int i=arrayParentidss.size()-2;i>=0;i--){
   					String tmpparentid = ""+arrayParentidss.get(i);
   					try{
   						rs1.executeProc("Prj_Task_UpdateParent",tmpparentid);
   					}catch(Exception e){}
   				}
                   
                   rs1.executeSql( "DELETE FROM workplan WHERE projectid='"+Util.getIntValue(ProjID)+"' AND taskid = '"+taskId+"'");
                } else {
                    rs1.executeSql("update Prj_TaskProcess set status=3 where id = "+taskId);
                }
                //System.out.println("delete Prj_TaskProcess where id = "+taskId);
            }
        }


      //编辑任务的时候更新日程
        if(rowIndexs!=null && insertWorkPlan.equals("1") &&(!"0".equals(projStatus) && !"6".equals(projStatus) && !"7".equals(projStatus) && !"".equals(projStatus)) ){
              	  
              	 // System.out.println("=========/更新日程start============");
              		//更新日程
              	       	String para = "";
              	        String workid = "";
              	        String task_id = "";
              	        String taskName1="";
              	        String beginDate1="";
              	        String endDate1 ="";
              	        String hrmid1 = "";
              	      int rowIndex = 0;
              	       // String taskTempletID="";
              	        int j=0 ;
              	      //  System.out.println("========taskrecordid======"+taskrecordid);
              	        //rs3.executeSql("select id,taskid from workplan where projectid = '" + ProjID +"' and taskid is not null and taskid !='' ");
              	        rs3.executeSql("select id,taskid from workplan where projectid = '" + ProjID +"' and taskid is not null and taskid !='' and taskid!=-1");
              	        while (rs3.next()) {
              	        
              	        	 for (  ;j<rowIndexs.length;){
              	        		    //taskName1 =  new String(Util.null2String(taskNames[j]).getBytes("ISO8859_1") , "UTF-8");
              	        		     taskName1 =  Util.null2String(taskNames[j]);
              	        		    rowIndex = Util.getIntValue(rowIndexs[j],0);
                                     beginDate1 =  Util.null2String(beginDates[j]);
                                     endDate1 =  Util.null2String(endDates[j]);
                                     hrmid1 =  Util.null2String(managers[j]);
                                   //  taskTempletID =  Util.null2String(taskTempletIDs[j]);
                                     rs4.executeSql("select id from Prj_TaskProcess where prjid="+ProjID+" and taskIndex="+rowIndex);
                                     if (rs4.next()){
                                     	task_id = rs4.getString("id");
                                     }
                                     j++;
                                     break;
              	        	 }
              	        
                      	   workid = rs3.getString("id");
              	           //task_id = rs3.getString("taskid");
              	          
              	            para = workid;
              	            para +=flag+"2"; //type_n
              	            para +=flag+taskName1;
              	            para +=flag+hrmid1;
              	            para +=flag+beginDate1;
              	            para +=flag+Constants.WorkPlan_StartTime; //BeginTime
              	            para +=flag+endDate1;
              	            para +=flag+Constants.WorkPlan_EndTime; //EndTime
              	            //para +=flag+"008DC8";
              	            para +=flag+"";
              	            para +=flag+"0";//requestid
              	            para +=flag+ProjID;//projectid
              	            para +=flag+"0";//crmid
              	            para +=flag+"0";//docid
              	            para +=flag+"0";//meetingid
              	            para +=flag+"1";//isremind;
              	            para +=flag+"0";//waketime;
              	            
              	            para +=flag+task_id;//taskid
              	            para +=flag+"";//urgentlevel
              	            
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

              	            rs3.executeProc("WorkPlan_Update",para);
              	            WorkPlanViewer.setWorkPlanShareById(workid);
              	           // System.out.println("=========/更新日程end============");
              	          
                }
                                                  
           }    

      //4E8 重建rowindex
        RecordSetTrans rst=new RecordSetTrans();
        rst.setAutoCommit(false);
        try{
       	 rs.executeSql("select id,taskIndex,parentid,prefinish from prj_taskprocess where prjid="+ProjID+" order by id");
       	 
       	 while(rs.next()){
       		 String id=Util.null2String(rs.getString("id"));
       		 String taskindex=Util.null2String(rs.getString("taskIndex"));
       		 String befTaskId=Util.null2String(rs.getString("prefinish"));
       		 String newprefinish = taskOrderMap.get(befTaskId);
       		 if(newprefinish==null){
       		 	newprefinish = "0";
       		 }
       		 String sql="update prj_taskprocess set taskIndex='"+taskOrderMap.get(taskindex)+"',prefinish='"+newprefinish+"' where id='"+id+"' and prjid='"+ProjID+"' ";
       		 //System.out.println("sql:"+sql);
       		 rst.executeSql(sql);
       	 }
       	 rst.commit();
       	 
        }catch(Exception e){
       	 rst.rollback();
        }
        
    	RecordSet.executeSql("select 1 from prj_taskinfo where prjid="+ProjID);
    	if(RecordSet.next()){
    		RecordSet.executeSql("update prj_taskprocess set isactived=2 where prjid="+ProjID);
    	}

if(insertWorkPlan.equals("1")){
	//编辑工作计划Begin
	RecordSet.executeSql("select * from workplan where type_n = '2' and projectid = '" + ProjID + "' and ( taskid = -1 or taskid='' ) ");
	String para = "";
	String workid = "";
	if (RecordSet.next()) {
		String endDate= Util.null2String(RecordSet.getString("enddate"));
		if(!"".equals( maxEndDate)){
			endDate=maxEndDate;
		}
		
		workid = RecordSet.getString("id");
		para = workid;
		para +=flag+"2";//type_n
		para +=flag+ProjectInfoComInfo.getProjectInfoname(ProjID);
		para +=flag+ProjectInfoComInfo.getProjectInfomanager(ProjID);;
		para +=flag+Util.null2String(RecordSet.getString("begindate"));//BeginDate;
		para +=flag+Util.null2String(RecordSet.getString("begintime"));//BeginTime;
		para +=flag+endDate;//EndDate;
		para +=flag+Util.null2String(RecordSet.getString("endtime"));//EndTime;
		para +=flag+PrjInfo;//description
		para +=flag+Util.null2String(RecordSet.getString("requestid"));//requestid ;
		para +=flag+ProjID;
		para +=flag+Util.null2String(RecordSet.getString("crmid"));//crmid;
		para +=flag+Util.null2String(RecordSet.getString("docid"));//docid;
		para +=flag+Util.null2String(RecordSet.getString("meetingid"));//meetingid;
		para +=flag+Util.null2String(RecordSet.getString("isremind"));//isremind;
		para +=flag+Util.null2String(RecordSet.getString("waketime"));//waketime;
		para +=flag+Util.null2String(RecordSet.getString("taskid"));//taskid;
		para +=flag+Util.null2String(RecordSet.getString("urgentlevel"));//urgentlevel;
		//=======================================================================================================
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
		//out.print(para);
		WorkPlanViewer.setWorkPlanShareById(workid);
		
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
        RecordSet.executeSql("update workplan set begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + ProjID + "' and taskid = -1");
    }
    //更新工作计划中该项目的经理的时间End
	//编辑工作计划End
}

    //重新计算父任务的进度 add by wangxp
	RecordSet.executeSql("select id from prj_taskprocess where parentid <> 0 and prjid = "+ProjID);
	while(RecordSet.next()){
		String taskidtemp = RecordSet.getString(1);
		String parentidss =PrjImpUtil.getTaskParentids(Util.getIntValue(taskidtemp,0) ,new StringBuffer() ).toString();
		
		ArrayList arrayParentidss = Util.TokenizerString(parentidss,",");
		for(int i=arrayParentidss.size()-1;i>=0;i--){
				String tmpparentid = ""+arrayParentidss.get(i);
				 if(tmpparentid.equals(taskidtemp)||tmpparentid.equals("")) continue;
				 
				RecordSet.executeProc("Prj_Task_UpdateParent",tmpparentid);
					
		}
	}

    	//response.sendRedirect("/proj/data/ViewProject.jsp?log=n&ProjID="+ProjID);
    	response.sendRedirect("/proj/data/EditProjectTask.jsp?isclose=1&ProjID="+ProjID);
	return;
  
}

%>
<p><%=SystemEnv.getHtmlLabelName(15127,user.getLanguage())%>！</p>