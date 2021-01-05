
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="java.net.URLDecoder"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.conn.RecordSet" %>
<%@page import="net.sf.json.JSONArray"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysWorkPlanflow" class="weaver.system.SysWorkPlanflow" scope="page" />
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="workPlanHandler" class="weaver.WorkPlan.WorkPlanHandler" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="sysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page"/>
<jsp:useBean id="meetingLog" class="weaver.meeting.MeetingLog" scope="page" />
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page" />
<%!
public String saveAccessory(FileUpload fu,User user,RecordSet RecordSet, String fieldname)
{
	//附件上传
	String tempAccessory = "";
		String returnarry1 =fu.getParameter(fieldname);
		String[] returnarry = returnarry1.split(",");
		if(returnarry != null){
			for(int j=0;j<returnarry.length;j++){
				if(!returnarry[j].equals("-1") && !returnarry[j].equals("")){
						//新建时赋予创建者对附件文档的权限，而不是对所有参与者赋权。
						RecordSet.executeSql("insert into shareinnerdoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource)values("+returnarry[j]+",1,"+user.getUID()+",0,1,1,"+user.getUID()+",1)");
						if(tempAccessory.equals(""))
						{
							tempAccessory = String.valueOf(returnarry[j]);
						}
						else
						{
							tempAccessory += "," + String.valueOf(returnarry[j]);
						}
				}
			}
		}
	return tempAccessory;
}
 %>
<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
char flag = 2;
String ProcPara = "";

String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();

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
String meetingid=Util.null2String(fu.getParameter("meetingid"));
String decision=Util.fromScreen(fu.getParameter("decision"),user.getLanguage());
int decisiondocid=Util.getIntValue(fu.getParameter("decisiondocid"), -1);

String decisionwfids=Util.null2String(fu.getParameter("decisionwfids"));
String decisioncrmids=Util.null2String(fu.getParameter("decisioncrmids"));
String decisionprjids=Util.null2String(fu.getParameter("decisionprjids"));
String decisiontskids=Util.null2String(fu.getParameter("decisiontskids"));
String decisionatchids=saveAccessory(fu,user,RecordSet,"decisionatchids");

String delrelatedacc =Util.fromScreen(fu.getParameter("delrelatedacc"),user.getLanguage());  //删除相关附件id
String edit_relatedacc =Util.fromScreen(fu.getParameter("edit_relatedacc"),user.getLanguage());  //删除相关附件id


boolean ismanager=false;
RecordSet.executeSql("select * from meeting where id ="+meetingid);
if(RecordSet.next()){
	String caller=RecordSet.getString("caller");
	String contacter=RecordSet.getString("contacter");
	String creater=RecordSet.getString("creater");
	String approver=RecordSet.getString("approver");
	int userPrm=1;
	if(CurrentUser.equals(caller)){
		userPrm = meetingSetInfo.getCallerPrm();
		if(userPrm != 3) userPrm = 3;
	}else{
		if(CurrentUser.equals(contacter)){
			userPrm = meetingSetInfo.getContacterPrm();
		}
		if(CurrentUser.equals(creater)&&userPrm < 3){
			if(userPrm < meetingSetInfo.getCreaterPrm()){
				userPrm = meetingSetInfo.getCreaterPrm();
			}
		}
	}
	if(userPrm == 3 || CurrentUser.equals(caller) || CurrentUser.equals(approver) ){
	    ismanager=true;
	}
}

if(method.equals("edit"))
{
	if(!ismanager){
		out.println("<script>wfforward(\"/notice/noright.jsp\");</script>");
		return;
	}
	//删除相关附件
   	if(!"".equals(delrelatedacc)) 
    	RecordSet.executeSql("delete DocDetail where id in ("+delrelatedacc.substring(0,delrelatedacc.length()-1)+")" );
 	if(!"".equals(decisionatchids)){
    	decisionatchids += "," + edit_relatedacc;
	} else {
    	decisionatchids =  edit_relatedacc;
	}
	String sql = " Update Meeting set" 
	+" isdecision=1"
	+" , decision='"+decision+"'"
	+" , decisiondocid="+decisiondocid
	+" , decisiondate='"+CurrentDate+"'"
	+" , decisiontime='"+CurrentTime+"'"
	+" , decisionhrmid="+CurrentUser 
	+" , decisionwfids='"+decisionwfids+"'"
	+" , decisioncrmids='"+decisioncrmids+"'"
	+" , decisionprjids='"+decisionprjids+"'"
	+" , decisiontskids='"+decisiontskids+"'"
	+" , decisionatchids='"+decisionatchids+"'"
	+" where id = "+meetingid;

	RecordSet.executeSql(sql);
	MeetingUtil.meetingDecisionDocShare(meetingid);
	meetingLog.resetParameter();
	meetingLog.insSysLogInfo(user,Util.getIntValue(meetingid),"保存会议决议","修改会议决议","303","2",1,Util.getIpAddr(request));

	RecordSet.executeProc("Meeting_Decision_Delete",meetingid);

	int decisionrows=Util.getIntValue(Util.null2String(fu.getParameter("decisionrows")),0);
	for(int i=0;i<decisionrows;i++){
		String coding=Util.null2String(fu.getParameter("coding_"+i));
		String subject=Util.null2String(fu.getParameter("subject_"+i));
		String hrmid01=Util.null2String(fu.getParameter("hrmid01_"+i));
		String hrmid02=Util.null2String(fu.getParameter("hrmid02_"+i));
		String begindate=Util.null2String(fu.getParameter("begindate_"+i));
		String begintime=Util.null2String(fu.getParameter("begintime_"+i));
		String enddate=Util.null2String(fu.getParameter("enddate_"+i));
		String endtime=Util.null2String(fu.getParameter("endtime_"+i));

		if(!subject.equals("")){
			ProcPara =  meetingid;
			ProcPara += flag + "0";
			ProcPara += flag + coding;
			ProcPara += flag + subject;
			//更改把执行人变为多人
			ProcPara += flag + hrmid01;
			ProcPara += flag + hrmid02;
			ProcPara += flag + begindate;
			ProcPara += flag + begintime;
			ProcPara += flag + enddate;
			ProcPara += flag + endtime;
			RecordSet.executeProc("Meeting_Decision_Insert",ProcPara);	
		}
	}

}

if(method.equals("submit"))
{
	if(!ismanager){
		out.println("<script>wfforward(\"/notice/noright.jsp\");</script>");
		return;
	}
	//删除相关附件
   	if(!"".equals(delrelatedacc)) 
    	RecordSet.executeSql("delete DocDetail where id in ("+delrelatedacc.substring(0,delrelatedacc.length()-1)+")" );
 	if(!"".equals(decisionatchids)){
    	decisionatchids += "," + edit_relatedacc;
	} else {
    	decisionatchids =  edit_relatedacc;
	}
	String sql = " Update Meeting set" 
	+" isdecision=2"
	+" , decision='"+decision+"'"
	+" , decisiondocid="+decisiondocid
	+" , decisiondate='"+CurrentDate+"'"
	+" , decisiontime='"+CurrentTime+"'"
	+" , decisionhrmid="+CurrentUser 
	+" , decisionwfids='"+decisionwfids+"'"
	+" , decisioncrmids='"+decisioncrmids+"'"
	+" , decisionprjids='"+decisionprjids+"'"
	+" , decisiontskids='"+decisiontskids+"'"
	+" , decisionatchids='"+decisionatchids+"'"
	+" where id = "+meetingid;

	RecordSet.executeSql(sql);
	MeetingUtil.meetingDecisionDocShare(meetingid);
	RecordSet.executeProc("Meeting_Decision_Delete",meetingid);
	
	RecordSet.executeSql("select * from meeting where id ="+meetingid);
	RecordSet.next();
	String caller=RecordSet.getString("caller");
	String name=RecordSet.getString("name")+SystemEnv.getHtmlLabelName(2194,user.getLanguage());
	
	int decisionrows=Util.getIntValue(Util.null2String(fu.getParameter("decisionrows")),0);
	for(int i=0;i<decisionrows;i++){
		String coding=Util.fromScreen(Util.null2String(fu.getParameter("coding_"+i)),user.getLanguage());
		String subject=Util.fromScreen(Util.null2String(fu.getParameter("subject_"+i)),user.getLanguage());
		String hrmid01=Util.fromScreen(Util.null2String(fu.getParameter("hrmid01_"+i)),user.getLanguage());
		String hrmid02=Util.fromScreen(Util.null2String(fu.getParameter("hrmid02_"+i)),user.getLanguage());
		String begindate=Util.fromScreen(Util.null2String(fu.getParameter("begindate_"+i)),user.getLanguage());
		String begintime=Util.fromScreen(Util.null2String(fu.getParameter("begintime_"+i)),user.getLanguage());
		String enddate=Util.fromScreen(Util.null2String(fu.getParameter("enddate_"+i)),user.getLanguage());
		String endtime=Util.fromScreen(Util.null2String(fu.getParameter("endtime_"+i)),user.getLanguage());
		
	/*
	这里需要发工作流到个人计划，条件：if(!subject.equals(""))
	hrm01为决议执行人，hrm02为检查人，“决议执行：”＋subject为工作流名称，还有时间
	需要返回工作流ID，并赋值给下面的"0"
	
	*/
	if(!subject.equals("")){ 
		String resourceid1 = hrmid01;
		String resourceid2 = hrmid02;
		int userid = user.getUID();
		int requestid = 0;
	//改动	
		if(resourceid1.equals("")) 	resourceid1 = "" + userid;
		if(resourceid2.equals(""))	resourceid2 = "" + userid;

		//添加工作计划
		WorkPlan workPlan = new WorkPlan();
		
		workPlan.setCreaterId(Util.getIntValue(resourceid2,user.getUID()));
	    workPlan.setCreateType(Integer.parseInt(user.getLogintype()));

	    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_Plan));        
	    workPlan.setWorkPlanName(subject);    
	    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
	    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
	    workPlan.setResourceId(resourceid1);
	    workPlan.setBeginDate(begindate);
	    if(null != begintime && !"".equals(begintime.trim()))
	    {
	        workPlan.setBeginTime(begintime);  //开始时间
	    }
	    else
	    {
	        workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间
	    }	    
	    workPlan.setEndDate(enddate);
	    if(null != enddate && !"".equals(enddate.trim()) && (null == endtime || "".equals(endtime.trim())))
	    {
	        workPlan.setEndTime(Constants.WorkPlan_EndTime);  //结束时间
	    }
	    else
	    {
	        workPlan.setEndTime(endtime);  //结束时间
	    }
	    workPlan.setDescription(Util.convertInput2DB(Util.null2String(fu.getParameter("decision"))));
	    workPlan.setMeeting(meetingid);
	    
	    workPlanService.insertWorkPlan(workPlan);  //插入日程

		//添加日志
		logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, resourceid2, fu.getRemoteAddr()};
		logMan.writeViewLog(logParams);
		
		//会议决议通知
		try {
			requestid=sysRemindWorkflow.make(name+subject,0,0,0,Util.getIntValue(meetingid),Util.getIntValue(resourceid2),resourceid1,subject);
		} catch (Exception e) {
			RecordSet.writeLog("会议决议通知提醒流程生成失败：["+name+"]");
			RecordSet.writeLog(e);
			
		} 
		
			//添加会议决议
			ProcPara =  meetingid;
			ProcPara += flag + "" + requestid;
			ProcPara += flag + coding;
			ProcPara += flag + subject;
			ProcPara += flag + resourceid1;
			ProcPara += flag + hrmid02;
			ProcPara += flag + begindate;
			ProcPara += flag + begintime;
			ProcPara += flag + enddate;
			ProcPara += flag + endtime;

			RecordSet.executeProc("Meeting_Decision_Insert",ProcPara);	
			
			meetingLog.resetParameter();
			meetingLog.insSysLogInfo(user,Util.getIntValue(meetingid),subject,"会议决议内容:Meeting_Decision_Insert "+ProcPara,"303","1",1,Util.getIpAddr(request));
		}
		
    }

}

if("overCalendarItem".equals(method))
{
	String did = Util.null2String(fu.getParameter("id"));
	String userId = String.valueOf(user.getUID());  //当前用户Id
	String sql = "select w.id,d.subject from Meeting_Decision d, WorkPlan w, Meeting m WHERE d.meetingid = m.id AND w.meetingid = m.id AND d.subject = w.name AND d.hrmid01 = w.resourceid and d.id ="+did;
	String planID = "";
	RecordSet.executeSql(sql);
	String jueyiName="";
	if(RecordSet.next()){
		planID = RecordSet.getString("id");
		jueyiName=RecordSet.getString("subject");
	}
	boolean isPass=false;
    String[] creater = workPlanHandler.getCreater(planID);
    String createrID = "";
    if (creater != null) createrID = creater[0];
    
    if(createrID.equals(userId)){ //提交人完成
	    String planStatus =workPlanHandler.getWorkPlanStatus(planID);
	
	    if (planStatus.equals("0"))
	    {
	    	isPass=workPlanHandler.finishWorkPlan(planID);
	    }
	
	    if (planStatus.equals("1"))
	    {
	    	isPass=workPlanHandler.closeWorkPlan(planID);
	    }
	    meetingLog.resetParameter();
		meetingLog.insSysLogInfo(user,Util.getIntValue(did),"会议任务完成","会议决议ID:"+did+",完成.","303","2",1,Util.getIpAddr(request));
		
    }else{ //非提交人完成
    	String planName = workPlanHandler.getWorkPlanName(planID);
    	List<User> userList=new ArrayList<User>();
		userList.add(user);
		List tempUserList=User.getBelongtoUsersByUserId(user.getUID());//获取主次帐号
		if(tempUserList!=null) userList.addAll(tempUserList);
		boolean canfinish=false;
		for(int i=0;i<userList.size();i++){
			int tempuid=userList.get(i).getUID();
			RecordSet.executeSql("SELECT * FROM workplan WHERE id = " + planID+" and (resourceid='"+tempuid+"' or resourceid like '"+tempuid+",%' or resourceid like '%,"+tempuid+"' or resourceid like '%,"+tempuid+",%')");
		    if(RecordSet.next()){
		    	canfinish=true;
		    	break;
		    }
		}
		if(canfinish){
	    String accepter = createrID;
	    String wfTitle = "";
	    String wfRemark = "";
	    Calendar current = Calendar.getInstance();
	    String currentDate = Util.add0(current.get(Calendar.YEAR), 4) + "-" + Util.add0(current.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(current.get(Calendar.DAY_OF_MONTH), 2);
	
	    wfTitle = SystemEnv.getHtmlLabelName(16653,user.getLanguage());
	    wfTitle += planName;
	    wfTitle += "-" + resourceComInfo.getResourcename(userId);
	    wfTitle += "-" + currentDate;
	    wfRemark = SystemEnv.getHtmlLabelName(83995,user.getLanguage()) + "<A href=/workplan/data/WorkPlan.jsp?workid=" + planID + ">" + Util.fromScreen2(planName, user.getLanguage()) + "</A>";
	    sysRemindWorkflow.setCRMSysRemind(wfTitle, 0, Util.getIntValue(userId), accepter, wfRemark);
	
	    isPass=workPlanHandler.memberFinishWorkPlan(planID);
		}
    }
	
	Map result=new HashMap();
	result.put("IsSuccess",""+isPass);
	out.clearBuffer();
	out.print(JSONObject.fromObject(result).toString());
	return;
}

%>

<script>
     var parentWin = parent.parent.getParentWindow(window.parent);
     try{
	     parentWin.parent.dataRfsh();
     }catch(e){
     	console.log("refresh error");
     }
     parentWin.location="ProcessMeeting.jsp?tab=1&meetingid=<%=meetingid%>&showdiv=dicisionDiv";
     parentWin.diag_vote.close();
</script>

