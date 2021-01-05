
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="PrjViewer" class="weaver.proj.PrjViewer" scope="page"/>


<%
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();
String SubmiterType = ""+user.getLogintype();
String ClientIP = request.getRemoteAddr();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char flag = 2 ;
String ProcPara = "";
String method = request.getParameter("method");
String ProjID=Util.null2String(request.getParameter("ProjID"));
int version=Util.getIntValue(request.getParameter("version"),0);
String isactived = request.getParameter("isactived");

String SWFAccepter="";
String SWFTitle="";
String SWFRemark="";
String SWFSubmiter="";

if (method.equals("delplan"))
{
	ProcPara = ProjID ;
	ProcPara += flag + "" + version ;
	RecordSet.executeProc("Prj_TaskInfo_DeleteByVesion",ProcPara);

	//PrjViewer.setPrjShareByPrj(""+ProjID);

	response.sendRedirect("/proj/plan/ViewPlan.jsp?ProjID="+ProjID);
}

if (method.equals("approveplan"))
{
	ProcPara = ProjID ;
	ProcPara += flag + "" + version ;
	ProcPara += flag + "" + isactived ;
	RecordSet.executeProc("Prj_TaskInfo_Approve",ProcPara);

	if(isactived.equals("1")){
		RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
		String manager="";
		String managers="";
		String name=""
		if (RecordSet.next()){
			manager=RecordSet.getString("manager");
			name=RecordSet.getString("name");
		}
		managers=ResourceComInfo.getManagerID(manager);
		if(!managers.equals("")){
		
		SWFAccepter=managers;
		SWFTitle=SystemEnv.getHtmlLabelName(841,user.getLanguage());
		SWFTitle += ":"+name;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark="";
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setPrjSysRemind(SWFTitle,Util.getIntValue(ProjID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	

		}
	}

	response.sendRedirect("/proj/plan/ViewPlan.jsp?ProjID="+ProjID);
}

if (method.equals("newplan"))
{
	ProcPara = ProjID ;
	ProcPara += flag + "|" + version + "|" ;
	ProcPara += flag + "|" + (version + 1) + "|" ;
	RecordSet.executeProc("Prj_TaskInfo_NewPlan",ProcPara);
	//out.print(ProcPara);

	response.sendRedirect("/proj/plan/ViewPlan.jsp?ProjID="+ProjID);
}

if (method.equals("tellplanmember"))
{
	ProcPara = ProjID + flag + version ;
	RecordSet.executeProc("Prj_Member_SumPlan",ProcPara);
	String members="";
	while(RecordSet.next()){
	members += ","+RecordSet.getString("relateid");
	}
	RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
	String manager="";
	String name="";
	if (RecordSet.next()){
		manager=RecordSet.getString("manager");
		name=RecordSet.getString("name");
	}
	if(!members.equals("")){

		members = members.substring(1);
	
		SWFAccepter=members;
		SWFTitle=SystemEnv.getHtmlLabelName(1337,user.getLanguage());
		SWFTitle += ":"+name;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark="";
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setPrjSysRemind(SWFTitle,Util.getIntValue(ProjID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	

	}
	
	response.sendRedirect("/proj/plan/ViewPlan.jsp?ProjID="+ProjID);
}

%>