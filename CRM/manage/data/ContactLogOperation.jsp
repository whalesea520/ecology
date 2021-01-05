
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page import="weaver.Constants" %>
<%@ page import="weaver.general.Util" %>

<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanHandler" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="workPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="logMan" class="weaver.WorkPlan.WorkPlanLogMan" scope="page"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>

<%
String log=Util.null2String(request.getParameter("log"));
char flag = 2;
String ProcPara = "";
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();

String ClientIP = request.getRemoteAddr();

String userId = CurrentUser;
String userType = user.getLogintype();
userType="1";  //表WorkPlanShareDetail usertype字段都是为1，所以，如果客户门户登陆的话，永远查询不到数据

String SWFTitle="";
String SWFRemark="";
String SWFSubmiter="";
String SWFAccepter="";

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
String method = Util.null2String(request.getParameter("method"));

String CLogID = Util.null2String(request.getParameter("CLogID"));
if(method.equals("process"))
{
	ProcPara = CLogID+flag+CurrentDate+flag+CurrentTime;
	RecordSet.executeProc("CRM_ContactLog_Process",ProcPara);

	response.sendRedirect("/CRM/data/ViewContactLogDetail.jsp?log="+log+"&CLogID="+CLogID);
	return;
}

String isfinished = Util.null2String(request.getParameter("isfinished"));
String ContacterID = Util.null2String(request.getParameter("ContacterID"));
String ResourceID = Util.null2String(request.getParameter("ResourceID"));
String AgentID =Util.null2String(request.getParameter("AgentID"));


String ContactWay = Util.fromScreen(request.getParameter("ContactWay"),user.getLanguage());
String isPassive = Util.fromScreen(request.getParameter("isPassive"),user.getLanguage());
//if(!isPassive.equals("")) isPassive = "1";
//else isPassive = "0";
String Subject = Util.fromScreen(request.getParameter("Subject"),user.getLanguage());
String ContactType = Util.null2String(request.getParameter("ContactType"));
String ContactDate = Util.null2String(request.getParameter("ContactDate"));
String ContactTime = Util.null2String(request.getParameter("ContactTime"));
String EndData = Util.null2String(request.getParameter("EndData"));
String EndTime = Util.null2String(request.getParameter("EndTime"));
String ContactInfo = Util.fromScreen(request.getParameter("ContactInfo"),user.getLanguage());
String DocID = Util.null2String(request.getParameter("DocID"));
String relatedprj = Util.null2String(request.getParameter("relatedprj"));
String relatedcus = Util.null2String(request.getParameter("relatedcus"));
String relatedwf = Util.null2String(request.getParameter("relatedwf"));
String relateddoc = Util.null2String(request.getParameter("relateddoc"));


if(method.equals("edit"))
{
	ProcPara = CLogID;
	ProcPara += flag+ContacterID;
	ProcPara += flag+ResourceID;
	ProcPara += flag+AgentID;
	ProcPara += flag+ContactWay;
	ProcPara += flag+isPassive;
	ProcPara += flag+Subject;
	ProcPara += flag+ContactType;
	ProcPara += flag+ContactDate;
	ProcPara += flag+ContactTime;
	ProcPara += flag+EndData;
	ProcPara += flag+EndTime;
	ProcPara += flag+ContactInfo;
	ProcPara += flag+DocID;
	ProcPara += flag+isfinished;
	RecordSet.executeProc("CRM_ContactLog_Update",ProcPara);

	response.sendRedirect("/CRM/data/ViewContactLogDetail.jsp?log="+log+"&CLogID="+CLogID);
	return;
}

String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String CustomerName = CustomerInfoComInfo.getCustomerInfoname(CustomerID);
String ParentID = ""+Util.getIntValue(request.getParameter("ParentID"),0);
String isSub = ""+Util.getIntValue(request.getParameter("isSub"),0);

if(method.equals("add"))
{
	ProcPara = CustomerID;
	ProcPara += flag+ContacterID;
	ProcPara += flag+ResourceID;
	ProcPara += flag+AgentID;
	ProcPara += flag+ContactWay;
	ProcPara += flag+isPassive;
	ProcPara += flag+Subject;
	ProcPara += flag+ContactType;
	ProcPara += flag+ContactDate;
	ProcPara += flag+ContactTime;
	ProcPara += flag+EndData;
	ProcPara += flag+EndTime;
	ProcPara += flag+ContactInfo;
	ProcPara += flag+DocID;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+isSub;
	ProcPara += flag+ParentID;
	ProcPara += flag+isfinished;

	RecordSet.executeProc("CRM_ContactLog_Insert",ProcPara);

	
	RecordSet.executeProc("CRM_ContactLog_InsertID","");

	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/CRM/data/ViewContactLog.jsp?log="+log+"&CustomerID="+CustomerID);
		return;
	}
	else
		RecordSet.first();
		CLogID = RecordSet.getString("id");
		String operators = ResourceComInfo.getManagerID(ResourceID);

		SWFAccepter=operators;
		SWFTitle=SystemEnv.getHtmlLabelName(1221,user.getLanguage());
		SWFTitle += ":"+CustomerName;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark="<a href=/CRM/data/ViewContactLogDetail.jsp?CLogID="+CLogID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
		SWFSubmiter=CurrentUser;

		//SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	
		
		//out.println(remark);
		response.sendRedirect("/CRM/data/ViewContactLogDetail.jsp?log="+log+"&CLogID="+CLogID);
		return;
}

if(method.equals("addquick"))
{	
    Calendar cal = Calendar.getInstance();
    String currDate = Util.add0(cal.get(Calendar.YEAR), 4) +"-"+
                         Util.add0(cal.get(Calendar.MONTH) + 1, 2) +"-"+
                         Util.add0(cal.get(Calendar.DAY_OF_MONTH), 2) ;
    String currTime = Util.add0(cal.getTime().getHours(), 2) +":"+
                         Util.add0(cal.getTime().getMinutes(), 2) +":"+
                         Util.add0(cal.getTime().getSeconds(), 2) ;

	if((","+relatedcus+",").indexOf(","+CustomerID+",")==-1)
	{
	    relatedcus=CustomerID+","+relatedcus;
	}
	
	WorkPlan workPlan = new WorkPlan();

    workPlan.setCreaterId(user.getUID());
    workPlan.setCreateType(Integer.parseInt(user.getLogintype()));

    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_CustomerContact));        
    workPlan.setWorkPlanName(CustomerInfoComInfo.getCustomerInfoname(CustomerID) + "-" + SystemEnv.getHtmlLabelName(6082, user.getLanguage()));    
    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
    workPlan.setResourceId(String.valueOf(user.getUID()));
    workPlan.setBeginDate(currDate);  //开始日期
    workPlan.setBeginTime(currTime.substring(0, 5));  //开始时间  
    //workPlan.setDescription(Util.convertInput2DB(Util.null2String(request.getParameter("ContactInfo"))));
    workPlan.setDescription(Util.convertInput2DB(Util.null2String(URLDecoder.decode(request.getParameter("ContactInfo"),"utf-8"))));
    
    workPlan.setStatus(Constants.WorkPlan_Status_Archived);  //直接归档
    
    workPlan.setCustomer(relatedcus);
    workPlan.setDocument(relateddoc);
    workPlan.setWorkflow(relatedwf);
    workPlan.setTask(relatedprj);

    workPlanService.insertWorkPlan(workPlan);  //插入日程
	
	
	//插入日志
	String[] logParams = new String[]{String.valueOf(workPlan.getWorkPlanID()),
								WorkPlanLogMan.TP_CREATE,
								userId,
								request.getRemoteAddr()};
	logMan.writeViewLog(logParams);
	//end	
	
	
	String operators = ResourceComInfo.getManagerID(ResourceID);

	SWFAccepter=operators;
	SWFTitle=Util.toScreen("客户联系情况",user.getLanguage(),"0");
	SWFTitle += ":"+CustomerName;
	SWFTitle += "-"+CurrentUserName;
	SWFTitle += "-"+CurrentDate;
	SWFRemark="<a href=/workplan/data/WorkPlan.jsp?workid="+workPlan.getWorkPlanID()+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
	SWFSubmiter=CurrentUser;

	//SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);

    //客户联系共享给能够查看到该客户的所有人
    CrmShareBase.setCRM_WPShare_newContact(CustomerID,""+workPlan.getWorkPlanID());

	response.sendRedirect("/CRM/data/ViewCustomer.jsp?log="+log+"&CustomerID="+CustomerID);
	
	return;
}

%>
<p><%=CLogID%><%=SystemEnv.getHtmlLabelName(15127,user.getLanguage())%>！</p>