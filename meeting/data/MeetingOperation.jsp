<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.defined.MeetingFieldManager"%>
<%@page import="weaver.meeting.remind.MeetingRemindUtil"%>
<%@page import="weaver.meeting.defined.MeetingWFUtil"%>
<%@page import="weaver.meeting.MeetingShareUtil"%> 
<%@page import="weaver.meeting.defined.MeetingCreateWFUtil"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.docs.docs.DocExtUtil" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.meeting.Maint.MeetingInterval" %>
<%@ page import="java.net.*"%>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetDB" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="MeetingViewer" class="weaver.meeting.MeetingViewer" scope="page"/>
<jsp:useBean id="MeetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="meetingLog" class="weaver.meeting.MeetingLog" scope="page" />
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />
<%
FileUpload fu = new FileUpload(request);
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();
String SubmiterType = ""+user.getLogintype();
String ClientIP = fu.getRemoteAddr();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char flag = 2;
String ProcPara = "";
String Sql="";

String method = Util.null2String(fu.getParameter("method"));
String meetingtype=Util.null2String(fu.getParameter("meetingtype"));//会议类型
String meetingid=Util.null2String(fu.getParameter("meetingid"));

String approvewfid ="";
String formid="";

int days = meetingSetInfo.getDays();


if(method.equals("add") || method.equals("addSubmit"))//NewMeeting.jsp 新建页面保存和提交
{	
	//基本信息
	String name=Util.htmlFilter4UTF8(Util.spacetoHtml(Util.null2String(fu.getParameter("name"))));//会议名称
	String caller=Util.null2String(fu.getParameter("caller"));//召集人,必填
	String contacter=Util.null2String(fu.getParameter("contacter"));//联系人,空值使用当前操作人
	if("".equals(contacter)) contacter=CurrentUser;
	
	int roomType = 1;
	String address=Util.null2String(fu.getParameter("address"));//会议地点
	String customizeAddress = Util.null2String(fu.getParameter("customizeAddress"));
	if(!"".equals(address)){//优先选择会议室
		customizeAddress="";
	}else{//自定义会议室
		roomType=2;
	}
	String desc=Util.htmlFilter4UTF8(Util.spacetoHtml(Util.null2String(fu.getParameter("desc_n"))));//描述,可为空
	 
	//时间
	int repeatType = Util.getIntValue(fu.getParameter("repeatType"),0);//是否是重复会议,0 正常会议.
	String begindate=Util.null2String(fu.getParameter("begindate"));
	String enddate=Util.null2String(fu.getParameter("enddate"));
	if(repeatType>0){
		begindate=Util.null2String(fu.getParameter("repeatbegindate"));
		enddate=Util.null2String(fu.getParameter("repeatenddate"));
	}
	String begintime=Util.null2String(fu.getParameter("begintime"));
	String endtime=Util.null2String(fu.getParameter("endtime"));
	//提醒方式和时间
	String remindTypeNew=Util.null2String(fu.getParameter("remindTypeNew"));//新的提示方式
	int remindImmediately = Util.getIntValue(fu.getParameter("remindImmediately"),0);  //是否立即提醒 
	int remindBeforeStart = Util.getIntValue(fu.getParameter("remindBeforeStart"),0);  //是否开始前提醒
	int remindBeforeEnd = Util.getIntValue(fu.getParameter("remindBeforeEnd"),0);  //是否结束前提醒
	int remindHoursBeforeStart = Util.getIntValue(fu.getParameter("remindHoursBeforeStart"),0);//开始前提醒小时
	int remindTimesBeforeStart = Util.getIntValue(Util.null2String(fu.getParameter("remindTimesBeforeStart")),0);  //开始前提醒时间
    int remindHoursBeforeEnd = Util.getIntValue(fu.getParameter("remindHoursBeforeEnd"),0);//结束前提醒小时
    int remindTimesBeforeEnd = Util.getIntValue(Util.null2String(fu.getParameter("remindTimesBeforeEnd")),0);  //结束前提醒时间
	//参会人员
    String hrmmembers=Util.null2String(fu.getParameter("hrmmembers"));//参会人员
    int totalmember=Util.getIntValue(fu.getParameter("totalmember"),0);//参会人数
	String othermembers=Util.fromScreen(fu.getParameter("othermembers"),user.getLanguage());//其他参会人员
	String crmmembers=Util.null2String(fu.getParameter("crmmembers"));//参会客户
	int crmtotalmember=Util.getIntValue(fu.getParameter("crmtotalmember"),0);//参会人数
	//其他信息
	int projectid=Util.getIntValue(fu.getParameter("projectid"),0);	//加入了项目id
	String accessorys=Util.null2String(fu.getParameter("field35"));	//系统附件
	//自定义字段
	int remindType = 1;  //老的提醒方式,默认1不提醒
    
	//重复策略字段
	int repeatdays = Util.getIntValue(fu.getParameter("repeatdays"),0);
	int repeatweeks = Util.getIntValue(fu.getParameter("repeatweeks"),0);
	String rptWeekDays=Util.null2String(fu.getParameter("rptWeekDays"));
	int repeatmonths = Util.getIntValue(fu.getParameter("repeatmonths"),0);
	int repeatmonthdays = Util.getIntValue(fu.getParameter("repeatmonthdays"),0);
	int repeatStrategy = Util.getIntValue(fu.getParameter("repeatStrategy"),0);
	String description = SystemEnv.getHtmlLabelNames("84535,2103",user.getLanguage())+": "+name+SystemEnv.getHtmlLabelName(81901,user.getLanguage())+"   :"+begindate+" "+begintime+SystemEnv.getHtmlLabelName(2105,user.getLanguage())+" :"+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)+customizeAddress;
	//生成会议卡片数据
	RecordSet.executeSql("insert into meeting(creater,createdate,createtime,caller,contacter) values("+CurrentUser+",'"+CurrentDate+"','"+CurrentTime+"',"+caller+","+contacter+")");
	RecordSet.executeSql("SELECT max(id) FROM Meeting where creater = "+CurrentUser);
	RecordSet.next();
	String MaxID = RecordSet.getString(1);

	String updateSql = "update Meeting set " 
					+" meetingtype = " + meetingtype
					+" , name = '" + name  +"' "
					+" , projectid = " + projectid 
					+" , address = '" + address +"' "
					+" , begindate = '" + begindate  +"' "
					+" , begintime = '" + begintime  +"' "
					+" , enddate = '" + enddate  +"' "
					+" , endtime = '" + endtime  +"' "
					+" , desc_n = '" + desc  +"' "
					+" , totalmember = " + ""+totalmember 
					+" , othermembers = '" + othermembers  +"' "
					+" , addressdesc = '" + "" +"' "
					+" , description = '" + description  +"' "
					+" , remindType = " + remindType 
					+" , remindBeforeStart = " + remindBeforeStart 
					+" , remindBeforeEnd = " + remindBeforeEnd 
					+" , remindTimesBeforeStart = " + remindTimesBeforeStart 
					+" , remindTimesBeforeEnd = " + remindTimesBeforeEnd 
					+" , customizeAddress = '" + customizeAddress  +"' "
					+" , repeatType = " + repeatType 
					+" , repeatdays = "+ repeatdays 
					+" , repeatweeks = "+ repeatweeks 
					+" , rptWeekDays = '"+ rptWeekDays +"' "
					+" , repeatbegindate = '"+ begindate +"' "
					+" , repeatenddate = '"+ enddate +"' "
					+" , repeatmonths = "+ repeatmonths 
					+" , repeatmonthdays = "+ repeatmonthdays
					+" , repeatStrategy = "+ repeatStrategy
					+" , roomType = "+ roomType
					+" , remindTypeNew = '"+ remindTypeNew+"' "
					+" , remindImmediately = "+ remindImmediately
					+" , remindHoursBeforeStart = "+ remindHoursBeforeStart
					+" , remindHoursBeforeEnd = "+ remindHoursBeforeEnd
					+" , hrmmembers = '"+ hrmmembers+"' "
					+" , crmmembers = '"+ crmmembers+"' "
					+" , crmtotalmember = "+ crmtotalmember
					+" , accessorys = '"+ accessorys+"' "
					+" where id = " + MaxID;
	//System.out.println(updateSql);
	RecordSet.executeSql(updateSql);
	//保存自定义字段
	MeetingFieldManager mfm=new MeetingFieldManager(1);
	mfm.editCustomData(fu,Util.getIntValue(MaxID));
	
    //System.out.print(MaxID);
	ArrayList arrayhrmids02 = Util.TokenizerString(hrmmembers,",");
	for(int i=0;i<arrayhrmids02.size();i++){
		ProcPara =  MaxID;
		ProcPara += flag + "1";
		ProcPara += flag + "" + arrayhrmids02.get(i);
		ProcPara += flag + "" + arrayhrmids02.get(i);
		RecordSet.executeProc("Meeting_Member2_Insert",ProcPara);
		
		//标识会议是否查看过
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("INSERT INTO Meeting_View_Status(meetingId, userId, userType, status) VALUES(");
		stringBuffer.append(MaxID);
		stringBuffer.append(", ");
		stringBuffer.append(arrayhrmids02.get(i));
		stringBuffer.append(", '");
		stringBuffer.append("1");
		stringBuffer.append("', '");
		if(CurrentUser.equals(arrayhrmids02.get(i)))
		//当前操作用户表示已看
		{
		    stringBuffer.append("1");
		}
		else
		{
		    stringBuffer.append("0");
		}
		stringBuffer.append("')");
		RecordSet.executeSql(stringBuffer.toString());
	}

	ArrayList arraycrmids02 = Util.TokenizerString(crmmembers,",");
	for(int i=0;i<arraycrmids02.size();i++){
		String membermanager="";
		RecordSet.executeProc("CRM_CustomerInfo_SelectByID",""+arraycrmids02.get(i));
		if(RecordSet.next()) membermanager=RecordSet.getString("manager");
		ProcPara =  MaxID;
		ProcPara += flag + "2";
		ProcPara += flag + "" + arraycrmids02.get(i);
		ProcPara += flag + membermanager;
		RecordSet.executeProc("Meeting_Member2_Insert",ProcPara);
	}
	//会议议程
	int topicrows=Util.getIntValue(Util.null2String(fu.getParameter("topicrows")),0);
	if(topicrows>0){
		MeetingFieldManager mfm2=new MeetingFieldManager(2);
		for(int i=1;i<=topicrows;i++){
			mfm2.editCustomDataDetail(fu,0,i,Util.getIntValue(MaxID));
		}
	}
	//会议服务
	int servicerows=Util.getIntValue(Util.null2String(fu.getParameter("servicerows")),0);
	if(servicerows>0){
		MeetingFieldManager mfm3=new MeetingFieldManager(3);
		for(int i=1;i<=servicerows;i++){
			mfm3.editCustomDataDetail(fu,0,i,Util.getIntValue(MaxID));
		}
	}
	
	
	
	MeetingViewer.setMeetingShareById(""+MaxID);
	MeetingComInfo.removeMeetingInfoCache();
	//文档和附件的共享明细
	MeetingUtil.meetingDocShare(MaxID);
	
	if(method.equals("add")){
		meetingLog.resetParameter();
    	meetingLog.insSysLogInfo(user,Util.getIntValue(MaxID),name,"新建草稿会议"+(repeatType>0?"模板":""),"303","1",1,Util.getIpAddr(request));
	}
	//2004年4月17日，根据会议类型所对应的工作流判断是否需要触发审批工作流
    if(method.equals("addSubmit")){
    	//新建会议日志
    	
        if(!meetingtype.equals("")){
        	if(repeatType>0){//周期会议,查看周期会议审批流程
        		RecordSet.executeSql("Select approver1,formid From Meeting_Type t1 join workflow_base t2 on t1.approver1=t2.id  where t1.approver1>0 and t1.ID ="+meetingtype);
        	}else{
        		RecordSet.executeSql("Select approver,formid From Meeting_Type t1 join workflow_base t2 on t1.approver=t2.id  where t1.approver>0 and t1.ID ="+meetingtype);
        	}
            RecordSet.next();
            approvewfid = RecordSet.getString(1);
            formid=RecordSet.getString(2);
        }
        if(!approvewfid.equals("0")&&!approvewfid.equals("")){
        	approvewfid=WorkflowVersion.getActiveVersionWFID(approvewfid);
        	meetingLog.resetParameter();
        	meetingLog.insSysLogInfo(user,Util.getIntValue(MaxID),name,"新建审批会议","303","1",1,Util.getIpAddr(request));
        	if("85".equals(formid)){//原系统表单
	            response.sendRedirect("/workflow/request/BillMeetingOperation.jsp?src=submit&iscreate=1&MeetingID="+MaxID+"&approvewfid="+approvewfid+"&viewmeeting=1");
	            return;
        	}else{//新表单,通过Action统一处理
        		String errMessagecontent=MeetingCreateWFUtil.createWF(MaxID,user,approvewfid,ClientIP);
        		errMessagecontent=errMessagecontent.replaceAll("</?[^>]+>","");
        		if(!errMessagecontent.isEmpty()){
        			response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+MaxID+"&errmsg="+URLEncoder.encode(errMessagecontent,"UTF-8"));
				}else{
					response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+MaxID);
				}
        		return;
        	}
        }else{
        	
	        RecordSet.executeSql("Update Meeting Set meetingstatus = 2 WHERE id="+MaxID);//更新会议状态为正常
	        if(repeatType == 0){
	        	meetingLog.resetParameter();
	        	meetingLog.insSysLogInfo(user,Util.getIntValue(MaxID),name,"新建正常会议","303","1",1,Util.getIpAddr(request));
	        	//生成会议日程和会议提醒
	            MeetingInterval.createWPAndRemind(MaxID,null,fu.getRemoteAddr());
	            
	
	            response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+MaxID);
				/*%>
				<script type="text/javascript">
					window.parent.closeWinAFrsh();
				</script>
				<%*/
	            return;
            } else {
            	meetingLog.resetParameter();
            	meetingLog.insSysLogInfo(user,Util.getIntValue(MaxID),name,"新建会议模板","303","1",1,Util.getIpAddr(request));
				int intervaltime = 0;
				String otherinfo = "";
				if(repeatType == 1){
					intervaltime = repeatdays;
				} else if(repeatType == 2){
					intervaltime = repeatweeks;
					otherinfo = rptWeekDays;
				}else if(repeatType == 3){
					intervaltime = repeatmonths;
					otherinfo = "" + repeatmonthdays;
				}
            	MeetingInterval.updateMeetingRepeat(days,MaxID,begindate,enddate,""+repeatType,intervaltime,otherinfo,repeatStrategy);
            }
        }
    }
    response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+MaxID);
    /*%>
	<script type="text/javascript">
		window.parent.closeWinAFrsh();
	</script>
	<%*/
    return;
}else if(method.equals("submit")) {//ViewMeeting.jsp 页面直接提交
    if(!meetingid.equals("")) {
        RecordSet rs = new RecordSet();
        rs.executeSql("Update Meeting Set meetingstatus = 2 WHERE id="+meetingid);//更新会议状态为正常
        rs.executeProc("Meeting_SelectByID",meetingid);
	    rs.next();
	    String name=rs.getString("name");
	    String begindate=rs.getString("begindate");
	    String enddate=rs.getString("enddate");
	    
	    int repeatType = Util.getIntValue(rs.getString("repeatType"),0);
		int repeatdays = Util.getIntValue(rs.getString("repeatdays"),0);
		int repeatweeks = Util.getIntValue(rs.getString("repeatweeks"),0);
		int repeatmonths = Util.getIntValue(rs.getString("repeatmonths"),0);
		int repeatmonthdays = Util.getIntValue(rs.getString("repeatmonthdays"),0);
		int repeatStrategy = Util.getIntValue(rs.getString("repeatStrategy"),0);
		String rptWeekDays = rs.getString("rptWeekDays");
	
		if(repeatType == 0){
			meetingLog.resetParameter();
			meetingLog.insSysLogInfo(user,Util.getIntValue(meetingid),name,"提交会议","303","2",1,Util.getIpAddr(request));
			//生成会议日程和会议提醒
			MeetingInterval.createWPAndRemind(meetingid,null,fu.getRemoteAddr());
			
			
		 } else {
			int intervaltime = 0;
			String otherinfo = "";
			if(repeatType == 1){
				intervaltime = repeatdays;
			} else if(repeatType == 2){
				intervaltime = repeatweeks;
				otherinfo = rptWeekDays;
			}else if(repeatType == 3){
				intervaltime = repeatmonths;
				otherinfo = "" + repeatmonthdays;
			}
			meetingLog.resetParameter();
			meetingLog.insSysLogInfo(user,Util.getIntValue(meetingid),name,"提交会议模板","303","2",1,Util.getIpAddr(request));
			MeetingInterval.updateMeetingRepeat(days,meetingid,begindate,enddate,""+repeatType,intervaltime,otherinfo,repeatStrategy);
		}
        MeetingViewer.setMeetingShareById(meetingid);
		MeetingComInfo.removeMeetingInfoCache();
    }
    response.sendRedirect("/meeting/data/ViewMeeting.jsp?tab=1&meetingid="+meetingid);
    /* %>
	<script type="text/javascript">
		window.parent.closeWinAFrsh();
	</script>
	<%*/
    return;
}else if(method.equals("edit"))//修改或者编辑页面直接提交  edit页面修改和提交
{	
	String allUser=MeetingShareUtil.getAllUser(user);
	RecordSet.executeSql("select * from meeting where id = '"+meetingid+"'");
	String createrN="";
	String meetingstatus="";
	if(RecordSet.next()){
	   createrN = RecordSet.getString("creater");
	   meetingstatus=RecordSet.getString("meetingstatus");
	}
	if(!(MeetingShareUtil.containUser(allUser,createrN)&&("0".equals(meetingstatus)||"3".equals(meetingstatus)))){//不是创建人 不是草稿状态 不是审批退回状态
		out.println("<script>wfforward(\"/notice/noright.jsp\");</script>");
		   return;
	}
	
	//基本信息
	String name=Util.null2String(fu.getParameter("name"));//会议名称
	String caller=Util.null2String(fu.getParameter("caller"));//召集人,必填
	String contacter=Util.null2String(fu.getParameter("contacter"));//联系人,空值使用当前操作人
	if("".equals(contacter)) contacter=CurrentUser;
	
	int roomType = 1;
	String address=Util.null2String(fu.getParameter("address"));//会议地点
	String customizeAddress = Util.null2String(fu.getParameter("customizeAddress"));
	if(!"".equals(address)){//优先选择会议室
		customizeAddress="";
	}else{//自定义会议室
		roomType=2;
	}
	String desc=Util.htmlFilter4UTF8(Util.spacetoHtml(Util.null2String(fu.getParameter("desc_n"))));//描述,可为空
	//时间
	int repeatType = Util.getIntValue(fu.getParameter("repeatType"),0);//是否是重复会议,0 正常会议.
	String begindate=Util.null2String(fu.getParameter("begindate"));
	String enddate=Util.null2String(fu.getParameter("enddate"));
	if(repeatType>0){
		begindate=Util.null2String(fu.getParameter("repeatbegindate"));
		enddate=Util.null2String(fu.getParameter("repeatenddate"));
	}
	String begintime=Util.null2String(fu.getParameter("begintime"));
	String endtime=Util.null2String(fu.getParameter("endtime"));
	//提醒方式和时间
	String remindTypeNew=Util.null2String(fu.getParameter("remindTypeNew"));//新的提示方式
	int remindImmediately = Util.getIntValue(fu.getParameter("remindImmediately"),0);  //是否立即提醒 
	int remindBeforeStart = Util.getIntValue(fu.getParameter("remindBeforeStart"),0);  //是否开始前提醒
	int remindBeforeEnd = Util.getIntValue(fu.getParameter("remindBeforeEnd"),0);  //是否结束前提醒
	int remindHoursBeforeStart = Util.getIntValue(fu.getParameter("remindHoursBeforeStart"),0);//开始前提醒小时
	int remindTimesBeforeStart = Util.getIntValue(Util.null2String(fu.getParameter("remindTimesBeforeStart")),0);  //开始前提醒时间
    int remindHoursBeforeEnd = Util.getIntValue(fu.getParameter("remindHoursBeforeEnd"),0);//结束前提醒小时
    int remindTimesBeforeEnd = Util.getIntValue(Util.null2String(fu.getParameter("remindTimesBeforeEnd")),0);  //结束前提醒时间
	//参会人员
    String hrmmembers=Util.null2String(fu.getParameter("hrmmembers"));//参会人员
    int totalmember=Util.getIntValue(fu.getParameter("totalmember"),0);//参会人数
	String othermembers=Util.fromScreen(fu.getParameter("othermembers"),user.getLanguage());//其他参会人员
	String crmmembers=Util.null2String(fu.getParameter("crmmembers"));//参会客户
	int crmtotalmember=Util.getIntValue(fu.getParameter("crmtotalmember"),0);//参会人数
	//其他信息
	String projectid=Util.null2String(fu.getParameter("projectid"));	//加入了项目id
	String accessorys=Util.null2String(fu.getParameter("field35"));	//系统附件
	
	//自定义字段
	int remindType = 1;  //老的提醒方式,默认1不提醒
    
	//重复策略字段
	int repeatdays = Util.getIntValue(fu.getParameter("repeatdays"),0);
	int repeatweeks = Util.getIntValue(fu.getParameter("repeatweeks"),0);
	String rptWeekDays=Util.null2String(fu.getParameter("rptWeekDays"));
	int repeatmonths = Util.getIntValue(fu.getParameter("repeatmonths"),0);
	int repeatmonthdays = Util.getIntValue(fu.getParameter("repeatmonthdays"),0);
	int repeatStrategy = Util.getIntValue(fu.getParameter("repeatStrategy"),0);
	
	String description= SystemEnv.getHtmlLabelNames("84535,2103",user.getLanguage())+": "+name+SystemEnv.getHtmlLabelName(81901,user.getLanguage())+"   :"+begindate+" "+begintime+SystemEnv.getHtmlLabelName(2105,user.getLanguage())+" :"+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)+customizeAddress;

	ProcPara +=  meetingid;
	ProcPara += flag + name;
	ProcPara += flag + caller;
	ProcPara += flag + contacter;
	ProcPara += flag + projectid;	//加入修改字段
	ProcPara += flag + address;
	ProcPara += flag + begindate;
	ProcPara += flag + begintime;
	ProcPara += flag + enddate;
	ProcPara += flag + endtime;
	ProcPara += flag + desc;
    ProcPara += flag + ""+totalmember;
    ProcPara += flag + othermembers;
    ProcPara += flag + "";
    ProcPara += flag + description;
    ProcPara += flag + ""+remindType;
    ProcPara += flag + ""+remindBeforeStart;
    ProcPara += flag + ""+remindBeforeEnd;
    ProcPara += flag + ""+remindTimesBeforeStart;
    ProcPara += flag + ""+remindTimesBeforeEnd;
    ProcPara += flag + customizeAddress;
    
	RecordSet.executeProc("Meeting_Update",ProcPara);
	
	String updateSql = "update Meeting set meetingtype='"+meetingtype+"',repeatType = " + repeatType 
					+" , repeatdays = "+ repeatdays 
					+" , repeatweeks = "+ repeatweeks 
					+" , rptWeekDays = '"+ rptWeekDays +"' "
					+" , repeatbegindate = '"+ begindate +"' "
					+" , repeatenddate = '"+ enddate +"' "
					+" , repeatmonths = "+ repeatmonths 
					+" , repeatmonthdays = "+ repeatmonthdays
					+" , repeatStrategy = "+ repeatStrategy
					+" , roomType = "+ roomType
					+" , remindTypeNew = '"+ remindTypeNew+"' "
					+" , remindImmediately = "+ remindImmediately
					+" , remindHoursBeforeStart = "+ remindHoursBeforeStart
					+" , remindHoursBeforeEnd = "+ remindHoursBeforeEnd
					+" , hrmmembers = '"+ hrmmembers+"' "
					+" , crmmembers = '"+ crmmembers+"' "
					+" , crmtotalmember = "+ crmtotalmember
					+" , accessorys = '"+ accessorys+"' "
					+" where id = " + meetingid;
	RecordSet.executeSql(updateSql);
	//保存自定义字段
	MeetingFieldManager mfm=new MeetingFieldManager(1);
	mfm.editCustomData(fu,Util.getIntValue(meetingid));
	
	//删除会议人员
	RecordSet.executeProc("Meeting_Member2_Delete",meetingid);
		
	//删除会议中相关的标识是否查看的信息
	StringBuffer stringBuffer = new StringBuffer();
	stringBuffer.append("DELETE FROM Meeting_View_Status WHERE meetingId = ");
	stringBuffer.append(meetingid);
	RecordSet.executeSql(stringBuffer.toString());
	

	ArrayList arrayhrmids02 = Util.TokenizerString(hrmmembers,",");
	for(int i=0;i<arrayhrmids02.size();i++){
		ProcPara =  meetingid;
		ProcPara += flag + "1";
		ProcPara += flag + "" + arrayhrmids02.get(i);
		ProcPara += flag + "" + arrayhrmids02.get(i);
		RecordSet.executeProc("Meeting_Member2_Insert",ProcPara);
		
		//标识会议是否查看过
		stringBuffer = new StringBuffer();
		stringBuffer.append("INSERT INTO Meeting_View_Status(meetingId, userId, userType, status) VALUES(");
		stringBuffer.append(meetingid);
		stringBuffer.append(", ");
		stringBuffer.append(arrayhrmids02.get(i));
		stringBuffer.append(", '");
		stringBuffer.append("1");
		stringBuffer.append("', '");
		if(CurrentUser.equals(arrayhrmids02.get(i)))
		//当前操作用户表示已看
		{
		    stringBuffer.append("1");
		}
		else
		{
		    stringBuffer.append("0");
		}
		stringBuffer.append("')");
		RecordSet.executeSql(stringBuffer.toString());
	}

	ArrayList arraycrmids02 = Util.TokenizerString(crmmembers,",");
	for(int i=0;i<arraycrmids02.size();i++){
		String membermanager="";
		RecordSet.executeProc("CRM_CustomerInfo_SelectByID",""+arraycrmids02.get(i));
		if(RecordSet.next()) membermanager=RecordSet.getString("manager");
		ProcPara =  meetingid;
		ProcPara += flag + "2";
		ProcPara += flag + "" + arraycrmids02.get(i);
		ProcPara += flag + membermanager;
		RecordSet.executeProc("Meeting_Member2_Insert",ProcPara);
	}
	//会议议程
	int topicrows=Util.getIntValue(Util.null2String(fu.getParameter("topicrows")),0);
	if(topicrows>0){
		String recordsetids="";
		for(int i=1;i<=topicrows;i++){
			String recordsetid=Util.null2String(fu.getParameter("topic_data_"+i));
			if(!recordsetid.equals("")) recordsetids+=","+recordsetid;
		}
		if(!recordsetids.equals("")){
			recordsetids=recordsetids.substring(1);
			Sql = "delete from Meeting_Topic WHERE ( meetingid = "+meetingid+" and id not in ("+recordsetids+"))";
			RecordSet.executeSql(Sql);
		}else{
			Sql = "delete from Meeting_Topic WHERE ( meetingid = "+meetingid+")";
			RecordSet.executeSql(Sql);
		}
		MeetingFieldManager mfm2=new MeetingFieldManager(2);
		for(int i=1;i<=topicrows;i++){
			String recordsetid=Util.null2String(fu.getParameter("topic_data_"+i));
			mfm2.editCustomDataDetail(fu,Util.getIntValue(recordsetid),i,Util.getIntValue(meetingid));
		}
		
	}
	//会议服务
	int servicerows=Util.getIntValue(Util.null2String(fu.getParameter("servicerows")),0);
	if(servicerows>0){
		String recordsetids="";
		for(int i=1;i<=servicerows;i++){
			String recordsetid=Util.null2String(fu.getParameter("serivce_data_"+i));
			if(!recordsetid.equals("")) recordsetids+=","+recordsetid;
		}
		if(!recordsetids.equals("")){
			recordsetids=recordsetids.substring(1);
			Sql = "delete from Meeting_Service_New WHERE ( meetingid = "+meetingid+" and id not in ("+recordsetids+"))";
			RecordSet.executeSql(Sql);
		}else{
			Sql = "delete from Meeting_Service_New WHERE ( meetingid = "+meetingid+")";
			RecordSet.executeSql(Sql);
		}
		MeetingFieldManager mfm3=new MeetingFieldManager(3);
		for(int i=1;i<=servicerows;i++){
			String recordsetid=Util.null2String(fu.getParameter("serivce_data_"+i));
			mfm3.editCustomDataDetail(fu,Util.getIntValue(recordsetid),i,Util.getIntValue(meetingid));
		}
	}
    MeetingViewer.setMeetingShareById(meetingid);
	MeetingComInfo.removeMeetingInfoCache();
	//文档和附件的共享明细
	MeetingUtil.meetingDocShare(meetingid);
	
	meetingLog.resetParameter();
	meetingLog.insSysLogInfo(user,Util.getIntValue(meetingid),name,"修改会议"+(repeatType>0?"模板":""),"303","2",1,Util.getIpAddr(request));

	response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+meetingid);
	/*%>
	<script type="text/javascript">
		window.parent.toView();
	</script>
	<%*/
	return;
}

if(method.equals("delete"))
{
    RecordSet.executeSql("select requestid,name,meetingtype,repeattype,caller,creater,contacter From meeting where (meetingstatus=0 or meetingstatus=3) and id="+meetingid);
    int requestid=0;
    int meetingtype1=0;
    if(RecordSet.next()){
       requestid=Integer.valueOf(Util.null2String(RecordSet.getString("requestid"))).intValue();
       meetingtype1=RecordSet.getInt("meetingtype");
       String caller=Util.null2String(RecordSet.getString("caller"));
       String creater=Util.null2String(RecordSet.getString("creater"));
       String contacter=Util.null2String(RecordSet.getString("contacter"));
       String allUser=MeetingShareUtil.getAllUser(user);
       //有编辑权限的人员才可删除会议
       if((MeetingShareUtil.containUser(allUser,caller)|| MeetingShareUtil.containUser(allUser,contacter)||MeetingShareUtil.containUser(allUser,creater))){
    	   meetingLog.resetParameter();
       	   meetingLog.insSysLogInfo(user,Util.getIntValue(meetingid),RecordSet.getString("name"),"删除会议","303","3",1,Util.getIpAddr(request));
       		if(RecordSet.getInt("repeattype")>0){//周期会议,查看周期会议审批流程
        		RecordSet.executeSql("Select formid From Meeting_Type t1 join workflow_base t2 on t1.approver1=t2.id  where t1.approver1>0 and t1.ID ="+meetingtype1);
        	}else{
        		RecordSet.executeSql("Select formid From Meeting_Type t1 join workflow_base t2 on t1.approver=t2.id  where t1.approver>0 and t1.ID ="+meetingtype1);
        	}
       		if(RecordSet.next()){
       			int fromid=RecordSet.getInt("formid");
       		    if(requestid>0){
    	   			MeetingWFUtil.deleteWF(requestid,meetingid,fromid);
       		        RecordSet.executeSql("delete From workflow_currentoperator where requestid="+requestid);
       		    }
       		}
       		MeetingWFUtil.deleteMeeting(meetingid);
       	    
       	    MeetingComInfo.removeMeetingInfoCache();
       }
    }
    
	//response.sendRedirect("/meeting/data/AddMeeting.jsp");
	%>
	<script type="text/javascript">
		window.parent.closeWinAFrsh();
	</script>
	<%
	return;
}

//提交会议，此部分对于现在通过流程来审批会议已经无用处！ by charoes Huang ,July 23,2004
if(method.equals("submitapprove111"))
{
	String approver="";
	RecordSet.executeProc("Meeting_Type_SelectByID",meetingtype);
	if(RecordSet.next()){
		approver=RecordSet.getString("approver");
	}

	if(!approver.equals("0") && !approver.equals("") && !approver.equals(CurrentUser)){
		RecordSet.executeProc("Meeting_Submit",meetingid);

		RecordSet.executeProc("Meeting_SelectByID",meetingid);
		RecordSet.next();
		String contacter=RecordSet.getString("contacter");
		
		String SWFTitle=SystemEnv.getHtmlLabelNames("2103,129",user.getLanguage())+":"; //文字
		SWFTitle += RecordSet.getString("name");
		SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
		SWFTitle += "-"+CurrentDate;
		String SWFRemark="";
		SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(CurrentUser),approver,SWFRemark);
	}else{
	    RecordSet.executeProc("Meeting_Submit",meetingid);
        ProcPara =  meetingid;
		ProcPara += flag + CurrentUser;
		ProcPara += flag + CurrentDate;
		ProcPara += flag + CurrentTime;
		RecordSet.executeProc("Meeting_Approve",ProcPara);

		RecordSet.executeProc("Meeting_SelectByID",meetingid);
		RecordSet.next();
		String name=RecordSet.getString("name");
		String caller=RecordSet.getString("caller");
		String contacter=RecordSet.getString("contacter");
		approver=RecordSet.getString("approver");
		String address=RecordSet.getString("address");
		String begindate=RecordSet.getString("begindate");
		String begintime=RecordSet.getString("begintime");
		String enddate=RecordSet.getString("enddate");
		String endtime=RecordSet.getString("endtime");
		String desc=RecordSet.getString("desc_n");
		String customizeAddress = Util.null2String(RecordSet.getString("customizeAddress"));

		String SWFTitle="";
		String SWFRemark="";
		String SWFSubmiter="";
		String SWFAccepter="";

		
	    int repeatType = Util.getIntValue(RecordSet.getString("repeatType"),0);
		int repeatdays = Util.getIntValue(RecordSet.getString("repeatdays"),0);
		int repeatweeks = Util.getIntValue(RecordSet.getString("repeatweeks"),0);
		int repeatmonths = Util.getIntValue(RecordSet.getString("repeatmonths"),0);
		int repeatmonthdays = Util.getIntValue(RecordSet.getString("repeatmonthdays"),0);
		int repeatStrategy = Util.getIntValue(RecordSet.getString("repeatStrategy"),0);
		String rptWeekDays = RecordSet.getString("rptWeekDays");
	
		if(repeatType == 0){
			/*查询会议室管理员,并发出通知*/
			String roommanager="" ;
			RecordSet.executeSql("select resourceid from hrmrolemembers where roleid=11") ;
			while(RecordSet.next()){
			    roommanager+=","+ RecordSet.getString(1);
			}
			if(!roommanager.equals(""))
	        {
	            roommanager=roommanager.substring(1);
	            SWFTitle=Util.toScreen("会议室调配:",user.getLanguage(),"0");
	            SWFTitle += name;
	            SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
	            SWFTitle += "-"+CurrentDate;
	            SWFRemark="";
	            SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(CurrentUser),roommanager,SWFRemark);
	        }
		    /* end */
	
			//会议通知
			SWFAccepter="";
			SWFSubmiter="";
			RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
			//Sql="select distinct membermanager from Meeting_Member2 where meetingid="+meetingid;
			//RecordSet.executeSql(Sql);
			while(RecordSet.next()){
				if(!RecordSet.getString("memberid").equals(caller) && !RecordSet.getString("memberid").equals(contacter) && !RecordSet.getString("memberid").equals(approver) ){
				SWFAccepter+=","+RecordSet.getString("memberid");
				}
			}
			RecordSet.executeProc("Meeting_Member2_SelectByType", meetingid+flag+"2");
    		while(RecordSet.next()){
    			SWFAccepter += "," + RecordSet.getString("membermanager");
    		}
			
    		//SWFAccepter += ","+caller + ","+ contacter;
			//会议通知
			if(!SWFAccepter.equals("")){
				SWFAccepter=SWFAccepter.substring(1);
				SWFTitle=SystemEnv.getHtmlLabelName(24215,user.getLanguage()); //文字
				SWFTitle += name;
				SWFTitle += SystemEnv.getHtmlLabelName(81901,user.getLanguage()); 
				SWFTitle += begindate+" "+begintime;
				SWFTitle +=SystemEnv.getHtmlLabelName(2105,user.getLanguage())+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)+customizeAddress;
				SWFRemark="";
				SWFSubmiter=CurrentUser;
				SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			}
	
			SWFAccepter="";
			Sql="select distinct hrmid from Meeting_Service2 where meetingid="+meetingid;
			RecordSet.executeSql(Sql);
			while(RecordSet.next()){
				SWFAccepter+=","+RecordSet.getString(1);
			}
			if(!SWFAccepter.equals("")){
				SWFAccepter=SWFAccepter.substring(1);
				SWFTitle=SystemEnv.getHtmlLabelName(2107,user.getLanguage()); //文字
				SWFTitle += name;
				SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
				SWFTitle += "-"+CurrentDate;
				SWFRemark="";
				SWFSubmiter=CurrentUser;
				SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			}
	 	} else {
	            
			int intervaltime = 0;
			String otherinfo = "";
			if(repeatType == 1){
				intervaltime = repeatdays;
			} else if(repeatType == 2){
				intervaltime = repeatweeks;
				otherinfo = rptWeekDays;
			}else if(repeatType == 3){
				intervaltime = repeatmonths;
				otherinfo = "" + repeatmonthdays;
			}
	        MeetingInterval.updateMeetingRepeat(days,meetingid,begindate,enddate,""+repeatType,intervaltime,otherinfo,repeatStrategy);
	    }
	}
	response.sendRedirect("/meeting/data/ProcessMeeting.jsp?tab=1&meetingid="+meetingid);
	return;
}

//点批准后的操作，是做什么用的？
if(method.equals("approve111"))
{
		ProcPara =  meetingid;
		ProcPara += flag + CurrentUser;
		ProcPara += flag + CurrentDate;
		ProcPara += flag + CurrentTime;
		RecordSet.executeProc("Meeting_Approve",ProcPara);

		RecordSet.executeProc("Meeting_SelectByID",meetingid);
		RecordSet.next();
		String name=RecordSet.getString("name");
		String caller=RecordSet.getString("caller");
		String contacter=RecordSet.getString("contacter");
		String approver=RecordSet.getString("approver");
		String address=RecordSet.getString("address");
		String begindate=RecordSet.getString("begindate");
		String begintime=RecordSet.getString("begintime");
		String enddate=RecordSet.getString("enddate");
		String endtime=RecordSet.getString("endtime");
		String desc=RecordSet.getString("desc_n");
		String customizeAddress = Util.null2String(RecordSet.getString("customizeAddress"));

		String SWFTitle="";
		String SWFRemark="";
		String SWFSubmiter="";
		String SWFAccepter="";

	    int repeatType = Util.getIntValue(RecordSet.getString("repeatType"),0);
		int repeatdays = Util.getIntValue(RecordSet.getString("repeatdays"),0);
		int repeatweeks = Util.getIntValue(RecordSet.getString("repeatweeks"),0);
		int repeatmonths = Util.getIntValue(RecordSet.getString("repeatmonths"),0);
		int repeatmonthdays = Util.getIntValue(RecordSet.getString("repeatmonthdays"),0);
		int repeatStrategy = Util.getIntValue(RecordSet.getString("repeatStrategy"),0);
		String rptWeekDays = RecordSet.getString("rptWeekDays");
	
		if(repeatType == 0){
			if(!approver.equals(caller) && !approver.equals(contacter)){
	    		SWFTitle=SystemEnv.getHtmlLabelNames("2103,129",user.getLanguage());  //文字
	    		SWFTitle += name;
	    		SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
	    		SWFTitle += "-"+CurrentDate;
	    		SWFRemark="";
	    		SWFSubmiter=approver;
	    		SWFAccepter=caller+","+contacter;
	    		SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			}
	
			/*查询会议室管理员,并发出通知*/
			String roommanager="" ;
			RecordSet.executeSql("select resourceid from hrmrolemembers where roleid=11") ;
			while(RecordSet.next()){
			    roommanager+=","+ RecordSet.getString(1);
			}
			if(!roommanager.equals(""))
	        {
	            roommanager=roommanager.substring(1);
	            RecordSet.executeProc("Meeting_SelectByID",meetingid);
	            RecordSet.next();
	            SWFTitle=Util.toScreen("会议室调配:",user.getLanguage(),"0"); //文字
	            SWFTitle += RecordSet.getString("name");
	            SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
	            SWFTitle += "-"+CurrentDate;
	            SWFRemark="";
	            SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(CurrentUser),roommanager,SWFRemark);
	        }
		    /* end */
	
			//会议通知
			SWFAccepter="";
			//Sql="select distinct membermanager from Meeting_Member2 where meetingid="+meetingid;
			//RecordSet.executeSql(Sql);
			RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
			while(RecordSet.next()){
				if(!RecordSet.getString("memberid").equals(caller) && !RecordSet.getString("memberid").equals(contacter) && !RecordSet.getString("memberid").equals(approver) ){
				SWFAccepter+=","+RecordSet.getString("memberid");
				}
			}
			RecordSet.executeProc("Meeting_Member2_SelectByType", meetingid+flag+"2");
    		while(RecordSet.next()){
    			SWFAccepter += "," + RecordSet.getString("membermanager");
    		}
			
    		//SWFAccepter += ","+caller + ","+ contacter;
			//会议通知
			if(!SWFAccepter.equals("")){
				SWFAccepter=SWFAccepter.substring(1);
				SWFTitle=SystemEnv.getHtmlLabelName(24215,user.getLanguage()); //文字
				SWFTitle += name;
				SWFTitle += SystemEnv.getHtmlLabelName(81901,user.getLanguage()); 
				SWFTitle += begindate+" "+begintime;
				SWFTitle +=SystemEnv.getHtmlLabelName(2105,user.getLanguage())+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)+customizeAddress;
				SWFRemark="";
				SWFSubmiter=CurrentUser;
				SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			}
	
			SWFAccepter="";
			Sql="select distinct hrmid from Meeting_Service2 where meetingid="+meetingid;
			RecordSet.executeSql(Sql);
			while(RecordSet.next()){
				SWFAccepter+=","+RecordSet.getString(1);
			}
			if(!SWFAccepter.equals("")){
				SWFAccepter=SWFAccepter.substring(1);
				SWFTitle=SystemEnv.getHtmlLabelName(2107,user.getLanguage()); //文字
				SWFTitle += name;
				SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
				SWFTitle += "-"+CurrentDate;
				SWFRemark="";
				SWFSubmiter=CurrentUser;
				SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			}
	
			//会议查看权限？
	        MeetingViewer.setMeetingShareById(meetingid);
			MeetingComInfo.removeMeetingInfoCache();
        } else {
	            
			int intervaltime = 0;
			String otherinfo = "";
			if(repeatType == 1){
				intervaltime = repeatdays;
			} else if(repeatType == 2){
				intervaltime = repeatweeks;
				otherinfo = rptWeekDays;
			}else if(repeatType == 3){
				intervaltime = repeatmonths;
				otherinfo = "" + repeatmonthdays;
			}
	        MeetingInterval.updateMeetingRepeat(days,meetingid,begindate,enddate,""+repeatType,intervaltime,otherinfo,repeatStrategy);
			MeetingViewer.setMeetingShareById(meetingid);
			MeetingComInfo.removeMeetingInfoCache();
		}

	response.sendRedirect("/meeting/data/ProcessMeeting.jsp?tab=1&meetingid="+meetingid);
	return;
}

if(method.equals("schedule111"))
{
		String address1=Util.fromScreen(fu.getParameter("address"),user.getLanguage()) ;
		String begindate1=Util.fromScreen(fu.getParameter("begindate"),user.getLanguage()) ;
		String begintime1=Util.fromScreen(fu.getParameter("begintime"),user.getLanguage()) ;
		String enddate1=Util.fromScreen(fu.getParameter("enddate"),user.getLanguage()) ;
		String endtime1=Util.fromScreen(fu.getParameter("endtime"),user.getLanguage()) ;
		enddate1=begindate1 ;
		String updatesql="update meeting set address="+address1+",begindate='"+begindate1+"',begintime='"+begintime1+
		                "',enddate='"+enddate1+"',endtime='"+endtime1+"' where id="+meetingid ;
		RecordSet.executeSql(updatesql) ;

		RecordSet.executeProc("Meeting_Schedule",meetingid);

		RecordSet.executeProc("Meeting_SelectByID",meetingid);
		RecordSet.next();
		String name=RecordSet.getString("name");
		String caller=RecordSet.getString("caller");
		String contacter=RecordSet.getString("contacter");
		String approver=RecordSet.getString("approver");
		String address=RecordSet.getString("address");
		String begindate=RecordSet.getString("begindate");
		String begintime=RecordSet.getString("begintime");
		String enddate=RecordSet.getString("enddate");
		String endtime=RecordSet.getString("endtime");
		String desc=RecordSet.getString("desc_n");
		String customizeAddress = RecordSet.getString("customizeAddress");

		String SWFTitle="";
		String SWFRemark="";
		String SWFSubmiter="";
		String SWFAccepter="";

		SWFAccepter="";
		 int repeatType = Util.getIntValue(RecordSet.getString("repeatType"),0);
		int repeatdays = Util.getIntValue(RecordSet.getString("repeatdays"),0);
		int repeatweeks = Util.getIntValue(RecordSet.getString("repeatweeks"),0);
		int repeatmonths = Util.getIntValue(RecordSet.getString("repeatmonths"),0);
		int repeatmonthdays = Util.getIntValue(RecordSet.getString("repeatmonthdays"),0);
		int repeatStrategy = Util.getIntValue(RecordSet.getString("repeatStrategy"),0);
		String rptWeekDays = RecordSet.getString("rptWeekDays");
	
		if(repeatType == 0){
			//Sql="select distinct membermanager from Meeting_Member2 where meetingid="+meetingid;
			//RecordSet.executeSql(Sql);
			RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
			while(RecordSet.next()){
				if(!RecordSet.getString("memberid").equals(caller) && !RecordSet.getString("memberid").equals(contacter) && !RecordSet.getString("memberid").equals(approver) ){
				SWFAccepter+=","+RecordSet.getString("memberid");
				}
			}
			RecordSet.executeProc("Meeting_Member2_SelectByType", meetingid+flag+"2");
    		while(RecordSet.next()){
    			SWFAccepter += "," + RecordSet.getString("membermanager");
    		}
			
    		//SWFAccepter += ","+caller + ","+ contacter;
			//会议通知
			if(!SWFAccepter.equals("")){
				
				
				SWFAccepter=SWFAccepter.substring(1);
				SWFTitle=SystemEnv.getHtmlLabelName(24215,user.getLanguage()); //文字
				SWFTitle += name;
				SWFTitle += SystemEnv.getHtmlLabelName(81901,user.getLanguage()); 
				SWFTitle += begindate+" "+begintime;
				SWFTitle +=" "+SystemEnv.getHtmlLabelName(2105,user.getLanguage())+":"+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)+customizeAddress;
				SWFRemark="";
				SWFSubmiter=CurrentUser;
				SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			}
	
			SWFAccepter="";
			Sql="select distinct hrmid from Meeting_Service2 where meetingid="+meetingid;
			RecordSet.executeSql(Sql);
			while(RecordSet.next()){
				SWFAccepter+=","+RecordSet.getString(1);
			}
			if(!SWFAccepter.equals("")){
				SWFAccepter=SWFAccepter.substring(1);
				SWFTitle=SystemEnv.getHtmlLabelName(2107,user.getLanguage()); //文字
				SWFTitle += name;
				SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
				SWFTitle += "-"+CurrentDate;
				SWFRemark="";
				SWFSubmiter=contacter;
				SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			}
		 } else {
			int intervaltime = 0;
			String otherinfo = "";
			if(repeatType == 1){
				intervaltime = repeatdays;
			} else if(repeatType == 2){
				intervaltime = repeatweeks;
				otherinfo = rptWeekDays;
			}else if(repeatType == 3){
				intervaltime = repeatmonths;
				otherinfo = "" + repeatmonthdays;
			}
	         MeetingInterval.updateMeetingRepeat(days,meetingid,begindate,enddate,""+repeatType,intervaltime,otherinfo,repeatStrategy);
	    }

	response.sendRedirect("/meeting/report/MeetingRoomPlan.jsp");
	return;
}

//取消会议
if(method.equals("cancelMeeting"))
{
	String meetingId = fu.getParameter("meetingId");
	String userId = "" + user.getUID();
	int meetingStatus = -1;
	String allUser=MeetingShareUtil.getAllUser(user);
	String forwardFlag = Util.null2String(fu.getParameter("forward"));
	//会议详细中右键的取消会议后跳转界面
	String forward = "/meeting/data/NewMeetings.jsp";
	//会议室报表中的会议取消，跳转界面
	if(!"".equals(forwardFlag) && !"null".equals(forwardFlag)){
	     forward = "/meeting/report/MeetingRoomPlan.jsp";
	}
	
	//会议取消，触发系统提醒工作流
	String MeetingName="";
	String MeetingDate="";
	String MeetingContacter="";
	String callerN = "";
	String createrN = "";
	String remindTypeNew="";
	RecordSet.executeSql("select * from meeting where id = '"+meetingId+"'");
	while(RecordSet.next()){
	   MeetingName=RecordSet.getString("name");
	   MeetingDate=RecordSet.getString("begindate");
	   MeetingContacter=RecordSet.getString("contacter");
	   meetingStatus = RecordSet.getInt("meetingStatus");
	   callerN = RecordSet.getString("caller");
	   createrN = RecordSet.getString("creater");
	   remindTypeNew=RecordSet.getString("remindTypeNew");
	}
	meetingLog.resetParameter();
	meetingLog.insSysLogInfo(user,Util.getIntValue(meetingId),MeetingName,"取消会议","303","2",1,Util.getIpAddr(request));

	String wfname="";
	String wfaccepter="";
	String wfremark="";
	
	wfname=Util.toMultiLangScreen("23269")+":"+MeetingName+"-"+ResourceComInfo.getLastname(user.getUID()+"")+"-"+CurrentDate;
	
	RecordSet.executeProc("Meeting_Member2_SelectByType",meetingId+flag+"1");
	//RecordSet.executeSql("select membermanager from Meeting_Member2 where meetingid = '"+meetingId+"'");
	while(RecordSet.next()){
	   wfaccepter+=","+RecordSet.getString("memberid");
	}
	if(!"".equals(wfaccepter)){
		wfaccepter+=",";
	}

	RecordSet.execute("select hrmids from meeting_service_new where meetingid="+meetingId);
	while(RecordSet.next()){
		String hrmids=RecordSet.getString("hrmids");
		String[] hrmidarrs=hrmids.split(",");
		for(int i=0;i<hrmidarrs.length;i++){
			if(!hrmidarrs[i].equals("")&&wfaccepter.indexOf(","+hrmidarrs[i]+",")==-1){
				wfaccepter+=hrmidarrs[i]+",";
			}
		}
	}
	if(!"".equals(wfaccepter)){
		wfaccepter=wfaccepter.substring(1,wfaccepter.length()-1);
	}
	
	int userPrm=1;

	if(MeetingShareUtil.containUser(allUser,callerN)){//是召集人 赋权限为3
		userPrm = meetingSetInfo.getCallerPrm();
		if(userPrm != 3) userPrm = 3;
	}
	if(MeetingShareUtil.containUser(allUser,MeetingContacter)&&userPrm<3){//是联系人 且权限小于3
		if(userPrm < meetingSetInfo.getContacterPrm()){ //当前权限小于联系人权限
			userPrm = meetingSetInfo.getContacterPrm(); //赋联系人权限
		}
	}
	if(MeetingShareUtil.containUser(allUser,createrN)&&userPrm<3){//是创建人 且权限小于3
	   if(userPrm < meetingSetInfo.getCreaterPrm()){//当前权限小于创建人权限
			userPrm = meetingSetInfo.getCreaterPrm();//赋创建人权限
		}
	} 
	
	//更新状态
	RecordSet.executeSql("SELECT * FROM Meeting WHERE id = " + meetingId + " AND (meetingStatus = 1 OR meetingStatus = 2)");	
	boolean cancelRight = HrmUserVarify.checkUserRight("Canceledpermissions:Edit",user);
	if(RecordSet.next()  && ( userPrm == 3 || cancelRight))
	{	
		if(1!=meetingStatus&&meetingSetInfo.getCancelMeetingRemindChk()==1){
		    SysRemindWorkflow.setMeetingSysRemind(wfname,Util.getIntValue(meetingId),Util.getIntValue(MeetingContacter),wfaccepter,wfremark);
		}
		
		meetingStatus = RecordSet.getInt("meetingStatus");
		//RecordSetDB.executeSql("UPDATE Meeting SET meetingStatus = 4 WHERE id = " + meetingId);
		Calendar today = Calendar.getInstance();
		String nowdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
        String nowtime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                Util.add0(today.get(Calendar.SECOND), 2); 
        RecordSetDB.executeSql("update meeting set cancel='1',meetingStatus=4,canceldate='"+nowdate+"',canceltime='"+nowtime+"' where id="+meetingId);
		//标识会议已经被取消
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("UPDATE Meeting_View_Status SET status = '2'");		
		stringBuffer.append(" WHERE meetingId = ");
		stringBuffer.append(meetingId);
		stringBuffer.append(" AND userId <> ");
		stringBuffer.append(CurrentUser);
		
		RecordSetDB.executeSql(stringBuffer.toString());
		
		/** Add By Hqf for TD9970 Start**/
		//表示当日计划已经被删除
		//stringBuffer.setLength(0);	
		//stringBuffer.append("DELETE FROM  WorkPlan ");
		//stringBuffer.append(" WHERE meetingId = ");
		//stringBuffer.append("'");
		//stringBuffer.append(meetingId);
		//stringBuffer.append("'");
		//RecordSetDB.executeSql(stringBuffer.toString());
		/** Add By Hqf for TD9970 End**/
		RecordSet.execute("select id from workplan where meetingId='"+meetingId+"'");
		weaver.WorkPlan.WorkPlanHandler wph = new weaver.WorkPlan.WorkPlanHandler();
		while(RecordSet.next()){
			wph.delete(RecordSet.getString("id"));
		}
	

		//待审批则删除相关流程
		if(1 == meetingStatus)
		{	
			
	   	    
			int requestId = 0;	
	 		RecordSet.executeSql("SELECT  requestid,name,meetingtype,repeattype FROM Meeting WHERE id = " + meetingId);
	    	if(RecordSet.next())
	    	{
	       		requestId = Integer.valueOf(Util.null2String(RecordSet.getString("requestid"))).intValue();
	       		RecordSet.executeSql("Select formid From workflow_requestbase t1 join workflow_base t2 on t1.workflowid=t2.id  where t1.requestid ="+requestId);
		   		if(RecordSet.next()){
		   			int fromid=RecordSet.getInt("formid");
		   		    if(requestId>0){
			   			MeetingWFUtil.deleteWF(requestId,meetingId,fromid);
		   		        RecordSet.executeSql("delete From workflow_currentoperator where requestid="+requestId);
		   		    }
		   		}
	       	}
		}
		
	    MeetingInterval.deleteMeetingRepeat(meetingId);
	    //之前是正常会议,被取消后进行取消会议提醒
	    if(meetingStatus==2&&!"".equals(remindTypeNew)){
		    MeetingRemindUtil.cancelMeeting(meetingId);
	    }
	}
	///response.sendRedirect(forward);
	%>
	<script type="text/javascript">
		window.parent.closeWinAFrsh();
	</script>
	<%
	return;
}

if(method.equals("overMeeting")){
	String meetingId = fu.getParameter("meetingId");
	String userId = "" + user.getUID();
	int meetingStatus = -1;
	String allUser=MeetingShareUtil.getAllUser(user);
	String forwardFlag = Util.null2String(fu.getParameter("forward"));
	//会议详细中右键的取消会议后跳转界面
	String forward = "/meeting/data/NewMeetings.jsp";
	//会议室报表中的会议取消，跳转界面
	if(!"".equals(forwardFlag) && !"null".equals(forwardFlag)){
	     forward = "/meeting/report/MeetingRoomPlan.jsp";
	}
	String MeetingName="";
	String MeetingContacter="";
	String callerN = "";
	String createrN = "";
	RecordSet.executeSql("select * from meeting where id = '"+meetingId+"'");
	while(RecordSet.next()){
	   MeetingName=RecordSet.getString("name");
	   MeetingContacter=RecordSet.getString("contacter");
	   meetingStatus = RecordSet.getInt("meetingStatus");
	   callerN = RecordSet.getString("caller");
	   createrN = RecordSet.getString("creater");
	}
	meetingLog.resetParameter();
	meetingLog.insSysLogInfo(user,Util.getIntValue(meetingId),MeetingName,"提前结束会议","303","2",1,Util.getIpAddr(request));
	
	int userPrm=1;
	if(MeetingShareUtil.containUser(allUser,callerN)){//是召集人 赋权限为3
		userPrm = meetingSetInfo.getCallerPrm();
		if(userPrm != 3) userPrm = 3;
	}else{
		if(MeetingShareUtil.containUser(allUser,MeetingContacter)){//是联系人
			userPrm = meetingSetInfo.getContacterPrm(); //赋联系人权限
		}
		if(MeetingShareUtil.containUser(allUser,createrN)&&userPrm<3){//是创建人 且权限小于3
			if(userPrm < meetingSetInfo.getCreaterPrm()){//当前权限小于创建人权限
				userPrm = meetingSetInfo.getCreaterPrm();//赋创建人权限
			}
		} 
	}
	
	boolean canover=false;
	//更新状态
	RecordSet.executeSql("SELECT * FROM Meeting WHERE id = " + meetingId + " AND meetingStatus = 2");	
	boolean cancelRight = HrmUserVarify.checkUserRight("Canceledpermissions:Edit",user);
	if(RecordSet.next()){//存在会议
		if( userPrm == 3 || cancelRight){//有完全控制权限或取消会议权限
			canover=true;
		}else{//是会议室负责人
			String address=RecordSet.getString("address");
			String [] adds = address.split(",");
			for(int i=0;i<adds.length;i++){
				String roomManager=MeetingRoomComInfo.getMeetingRoomInfohrmids(adds[i]);
				if((","+roomManager+",").indexOf(","+user.getUID()+",")>-1){
					canover=true;
					break;
				}
			}

		}
		
	}
	if(canover)
	{
		Calendar today = Calendar.getInstance();
		String nowdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
        String nowtime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                Util.add0(today.get(Calendar.MINUTE), 2); 
        RecordSetDB.executeSql("update meeting set enddate='"+nowdate+"',endtime='"+nowtime+"' where id="+meetingId);

	}
	%>
	<script type="text/javascript">
		window.parent.closeWinAFrsh();
	</script>
	<%
	return;
}

if(method.equals("changeMeeting")){
	if("".equals(meetingid)){
		return ;
	}
	RecordSet.executeProc("Meeting_SelectByID",meetingid);
	RecordSet.next();
	String meetingname=RecordSet.getString("name");
	String address=RecordSet.getString("address");
	String begindate=RecordSet.getString("begindate");
	String begintime=RecordSet.getString("begintime");

	String caller=RecordSet.getString("caller");
	String contacter=RecordSet.getString("contacter");
	String creater=RecordSet.getString("creater");
	String isdecision=RecordSet.getString("isdecision");
	String meetingstatus=RecordSet.getString("meetingstatus");

	int repeatType = Util.getIntValue(RecordSet.getString("repeatType"),0);

	String allUser=MeetingShareUtil.getAllUser(user);
	int userPrm=1;

	if(MeetingShareUtil.containUser(allUser,caller)){//是召集人 赋权限为3
		userPrm = meetingSetInfo.getCallerPrm();
		if(userPrm != 3) userPrm = 3;
	}
	if(MeetingShareUtil.containUser(allUser,contacter)&&userPrm<3){//是联系人 且权限小于3
		if(userPrm < meetingSetInfo.getContacterPrm()){ //当前权限小于联系人权限
			userPrm = meetingSetInfo.getContacterPrm(); //赋联系人权限
		}
	}
	if(MeetingShareUtil.containUser(allUser,creater)&&userPrm<3){//是创建人 且权限小于3
	   if(userPrm < meetingSetInfo.getCreaterPrm()){//当前权限小于创建人权限
			userPrm = meetingSetInfo.getCreaterPrm();//赋创建人权限
		}
	} 

	boolean isnotstart=false;//会议未开始
	//当前时间小于会议开始时间 即会议未开始
	if((begindate+":"+begintime).compareTo(CurrentDate+":"+CurrentTime)>0&&!isdecision.equals("2") ) isnotstart=true;
	boolean canedit=false;
	if(("2".equals(meetingstatus) && isnotstart) && userPrm==3 && repeatType == 0)
	{
		canedit=true;
	}
	
	if(!canedit){
		response.sendRedirect("/notice/noright.jsp") ;
		return;
	}
	
	
	
	String userId = "" + user.getUID();
	int roomType = 1;
	String address1=Util.null2String(fu.getParameter("address"));//会议地点
	String customizeAddress = Util.null2String(fu.getParameter("customizeAddress"));
	if(!"".equals(address1)){//优先选择会议室
		customizeAddress="";
	}else{//自定义会议室
		roomType=2;
	}
	 
	//时间
	String begindate1=Util.null2String(fu.getParameter("begindate"));
	String enddate1=Util.null2String(fu.getParameter("enddate"));
	String begintime1=Util.null2String(fu.getParameter("begintime"));
	String endtime1=Util.null2String(fu.getParameter("endtime"));
	//提醒方式和时间
	String remindTypeNew=Util.null2String(fu.getParameter("remindTypeNew"));//新的提示方式
	int remindImmediately = Util.getIntValue(fu.getParameter("remindImmediately"),0);  //是否立即提醒 
	int remindBeforeStart = Util.getIntValue(fu.getParameter("remindBeforeStart"),0);  //是否开始前提醒
	int remindBeforeEnd = Util.getIntValue(fu.getParameter("remindBeforeEnd"),0);  //是否结束前提醒
	int remindHoursBeforeStart = Util.getIntValue(fu.getParameter("remindHoursBeforeStart"),0);//开始前提醒小时
	int remindTimesBeforeStart = Util.getIntValue(Util.null2String(fu.getParameter("remindTimesBeforeStart")),0);  //开始前提醒时间
    int remindHoursBeforeEnd = Util.getIntValue(fu.getParameter("remindHoursBeforeEnd"),0);//结束前提醒小时
    int remindTimesBeforeEnd = Util.getIntValue(Util.null2String(fu.getParameter("remindTimesBeforeEnd")),0);  //结束前提醒时间
	//参会人员
    String hrmmembers=Util.null2String(fu.getParameter("hrmmembers"));//参会人员
    int totalmember=Util.getIntValue(fu.getParameter("totalmember"),0);//参会人数
	String othermembers=Util.fromScreen(fu.getParameter("othermembers"),user.getLanguage());//其他参会人员
	String crmmembers=Util.null2String(fu.getParameter("crmmembers"));//参会客户
	int crmtotalmember=Util.getIntValue(fu.getParameter("crmtotalmember"),0);//参会人数
	
	RecordSet.executeProc("Meeting_SelectByID",meetingid);
	RecordSet.next();
	String oldbegindate=RecordSet.getString("begindate");
	String oldbegintime=RecordSet.getString("begintime");
	String oldenddate=RecordSet.getString("enddate");
	String oldendtime=RecordSet.getString("endtime");
	String oldaddress=RecordSet.getString("address");
	String oldcustomizeAddress=RecordSet.getString("customizeAddress");
	String oldmembers=RecordSet.getString("hrmmembers");//原参会人员
	String oldcrmmembers=RecordSet.getString("crmmembers");//原参会客户
	String meetingName=RecordSet.getString("name");
	String MeetingContacter=RecordSet.getString("contacter");
	
	
	String updateSql = "update Meeting set "
	+"   begindate = '"+ begindate1+"' "
	+" , enddate = '"+ enddate1+"' "
	+" , begintime = '"+ begintime1+"' "
	+" , endtime = '"+ endtime1+"' "
	+" , roomType = "+ roomType
	+" , address = '"+ address1+"' "
	+" , customizeAddress = '"+ customizeAddress+"' "
	+" , remindTypeNew = '"+ remindTypeNew+"' "
	+" , remindImmediately = "+ remindImmediately
	+" , remindBeforeStart = "+ remindBeforeStart
	+" , remindBeforeEnd = "+ remindBeforeEnd
	+" , remindHoursBeforeStart = "+ remindHoursBeforeStart
	+" , remindTimesBeforeStart = "+ remindTimesBeforeStart
	+" , remindHoursBeforeEnd = "+ remindHoursBeforeEnd
	+" , remindTimesBeforeEnd = "+ remindTimesBeforeEnd
	+" , hrmmembers = '"+ hrmmembers+"' "
	+" , crmmembers = '"+ crmmembers+"' "
	+" , othermembers = '"+ othermembers+"' "
	+" , totalmember = "+ totalmember
	+" , crmtotalmember = "+ crmtotalmember
	+" where id = " + meetingid;
	//变更会议基本信息
	RecordSet.executeSql(updateSql);
	//变更参会人员
	
	//删除会议人员
	RecordSet.executeProc("Meeting_Member2_Delete",meetingid);
		
	//删除会议中相关的标识是否查看的信息
	StringBuffer stringBuffer = new StringBuffer();
	stringBuffer.append("DELETE FROM Meeting_View_Status WHERE meetingId = ");
	stringBuffer.append(meetingid);
	RecordSet.executeSql(stringBuffer.toString());
	

	ArrayList arrayhrmids02 = Util.TokenizerString(hrmmembers,",");
	for(int i=0;i<arrayhrmids02.size();i++){
		ProcPara =  meetingid;
		ProcPara += flag + "1";
		ProcPara += flag + "" + arrayhrmids02.get(i);
		ProcPara += flag + "" + arrayhrmids02.get(i);
		RecordSet.executeProc("Meeting_Member2_Insert",ProcPara);
		
		//标识会议是否查看过
		stringBuffer = new StringBuffer();
		stringBuffer.append("INSERT INTO Meeting_View_Status(meetingId, userId, userType, status) VALUES(");
		stringBuffer.append(meetingid);
		stringBuffer.append(", ");
		stringBuffer.append(arrayhrmids02.get(i));
		stringBuffer.append(", '");
		stringBuffer.append("1");
		stringBuffer.append("', '");
		if(CurrentUser.equals(arrayhrmids02.get(i)))
		//当前操作用户表示已看
		{
		    stringBuffer.append("1");
		}
		else
		{
		    stringBuffer.append("0");
		}
		stringBuffer.append("')");
		RecordSet.executeSql(stringBuffer.toString());
	}

	ArrayList arraycrmids02 = Util.TokenizerString(crmmembers,",");
	for(int i=0;i<arraycrmids02.size();i++){
		String membermanager="";
		RecordSet.executeProc("CRM_CustomerInfo_SelectByID",""+arraycrmids02.get(i));
		if(RecordSet.next()) membermanager=RecordSet.getString("manager");
		ProcPara =  meetingid;
		ProcPara += flag + "2";
		ProcPara += flag + "" + arraycrmids02.get(i);
		ProcPara += flag + membermanager;
		RecordSet.executeProc("Meeting_Member2_Insert",ProcPara);
	}
	boolean meetingInfoChanged=false;//会议主要信息发生变更
	if(!((begindate1+begintime1+enddate1+endtime1).equals(oldbegindate+oldbegintime+oldenddate+oldendtime) && address1.equals(oldaddress) && oldcustomizeAddress.equals(customizeAddress))){
		meetingInfoChanged=true;
	}
	//会议变更提醒处理
	if(!oldmembers.equals(hrmmembers)||!oldcrmmembers.equals(crmmembers)||meetingInfoChanged){//前后人员不相同或客户不相同或主要信息发生变更
		
		//获取参会客户的客户经理
		ArrayList tmpcrmids = Util.TokenizerString(crmmembers,",");
		crmmembers="";
		for(int i=0;i<tmpcrmids.size();i++){
			String membermanager="";
			RecordSet.executeProc("CRM_CustomerInfo_SelectByID",""+tmpcrmids.get(i));
			if(RecordSet.next()){
				membermanager=RecordSet.getString("manager");
				if(!membermanager.isEmpty()){
					if(!crmmembers.isEmpty()){
						crmmembers+=",";
					}
					crmmembers+=membermanager;
				}
			}
		}
		//获取原参会客户的客户经理
		tmpcrmids = Util.TokenizerString(oldcrmmembers,",");
		oldcrmmembers="";
		for(int i=0;i<tmpcrmids.size();i++){
			String membermanager="";
			RecordSet.executeProc("CRM_CustomerInfo_SelectByID",""+tmpcrmids.get(i));
			if(RecordSet.next()){
				membermanager=RecordSet.getString("manager");
				if(!membermanager.isEmpty()){
					if(!oldcrmmembers.isEmpty()){
						oldcrmmembers+=",";
					}
					oldcrmmembers+=membermanager;
				}
			}
		}
		
		
		String[] arrmbr=hrmmembers.split(",");
		String[] arroldmbr=oldmembers.split(",");
		ArrayList newHrm=new ArrayList();
		ArrayList delHrm=new ArrayList();
		for(int i=0;i<arrmbr.length;i++){
			//当前参会人不在原参会人中且不为原参会客户的客户经理,也不为召集人、联系人、创建人 为新加人员
			if(!arrmbr[i].equals(creater)&&!arrmbr[i].equals(caller)&&!arrmbr[i].equals(contacter)&&(","+oldmembers+",").indexOf(","+arrmbr[i]+",")<0&&(","+oldcrmmembers+",").indexOf(","+arrmbr[i]+",")<0){
				newHrm.add(arrmbr[i]);
				RecordSet.execute("insert into  meeting_sign (meetingid,userid,attendType,flag) values ("+meetingid+","+arrmbr[i]+",1,1)");
			}
		}
		for(int i=0;i<arroldmbr.length;i++){
			//原参会人不在当前参会人中且不为当前参会客户的客户经理,也不为召集人、联系人、创建人 为删除人员
			if(!arroldmbr[i].equals(creater)&&!arroldmbr[i].equals(caller)&&!arroldmbr[i].equals(contacter)&&(","+hrmmembers+",").indexOf(","+arroldmbr[i]+",")<0&&(","+crmmembers+",").indexOf(","+arroldmbr[i]+",")<0){
				delHrm.add(arroldmbr[i]);
				//删除签到信息
				RecordSet.execute("delete from meeting_sign where meetingid="+meetingid+" and userid="+arroldmbr[i]);
			}
		}
		
		String[] arrcrm=crmmembers.split(",");
		String[] arroldcrm=oldcrmmembers.split(",");
		for(int i=0;i<arrcrm.length;i++){
			//当前参会客户经理不在原参会客户经理中且不为原参会人员,也不为召集人、联系人、创建人 为新加客户
			if(!arrcrm[i].equals(creater)&&!arrcrm[i].equals(caller)&&!arrcrm[i].equals(contacter)&&(","+oldcrmmembers+",").indexOf(","+arrcrm[i]+",")<0&&(","+oldmembers+",").indexOf(","+arrcrm[i]+",")<0){
				newHrm.add(arrcrm[i]);
			}
		}
		for(int i=0;i<arroldcrm.length;i++){
			//原参会客户经理不在当前参会客户经理中且不为当前参会人员,也不为召集人、联系人、创建人 为删除客户
			if(!arroldcrm[i].equals(creater)&&!arroldcrm[i].equals(caller)&&!arroldcrm[i].equals(contacter)&&(","+crmmembers+",").indexOf(","+arroldcrm[i]+",")<0&&(","+hrmmembers+",").indexOf(","+arroldcrm[i]+",")<0){				delHrm.add(arroldcrm[i]);
			}
		}
		//删除人员 发送会议取消提醒
		String wfname="";
		String wfaccepter="";
		String wfremark="";
		
		wfaccepter=delHrm.toString().substring(1,delHrm.toString().length()-1).replaceAll("\\s*", "");
		wfname=Util.toMultiLangScreen("23269")+":"+meetingName+"-"+ResourceComInfo.getLastname(user.getUID()+"")+"-"+CurrentDate;
		
		if(meetingSetInfo.getCancelMeetingRemindChk()==1&&!wfaccepter.isEmpty()){
		   SysRemindWorkflow.setMeetingSysRemind(wfname,Util.getIntValue(meetingid),Util.getIntValue(MeetingContacter),wfaccepter,wfremark);
		}
		
		//新加参会人发送新建会议提醒
		wfaccepter=newHrm.toString().substring(1,newHrm.toString().length()-1).replaceAll("\\s*", "");
		wfname = Util.toMultiLangScreen("24215")+":";
		wfname += meetingName;
		wfname += " "+SystemEnv.getHtmlLabelName(81901,user.getLanguage())+":"; 
		wfname += begindate1+" "+begintime1;
		wfname += " "+SystemEnv.getHtmlLabelName(2105,user.getLanguage())+":";
		wfname += MeetingRoomComInfo.getMeetingRoomInfoname(""+address1)+customizeAddress;
		//wfname=Util.toMultiLangScreen("24215")+":"+meetingName+"-"+ResourceComInfo.getLastname(user.getUID()+"")+"-"+CurrentDate;
		if(meetingSetInfo.getCreateMeetingRemindChk()==1&&!wfaccepter.isEmpty()){
			   SysRemindWorkflow.setMeetingSysRemind(wfname,Util.getIntValue(meetingid),Util.getIntValue(MeetingContacter),wfaccepter,wfremark);
		}
		//会议主要元素发生变更时 并且开启新建会议提醒时 给未发生变化的人员发送变更提醒
		if(meetingSetInfo.getCreateMeetingRemindChk()==1&&meetingInfoChanged){
			wfaccepter="";
			for(int i=0;i<arrmbr.length;i++){
				if(!arrmbr[i].equals(CurrentUser)&&(newHrm.indexOf(arrmbr[i])<0||newHrm.size()==0)){//不是新加人员 也不是当前操作用户
					wfaccepter+=wfaccepter.equals("")?arrmbr[i]:","+arrmbr[i];
				}
			}
			for(int i=0;i<arrcrm.length;i++){
				if(!arrcrm[i].equals(CurrentUser)&&(newHrm.indexOf(arrcrm[i])<0||newHrm.size()==0)){//不是新加客户经理 也不是当前操作用户
					wfaccepter+=wfaccepter.equals("")?arrcrm[i]:","+arrcrm[i];
				}
			}
			wfname = Util.toMultiLangScreen("24574")+":";
			wfname += meetingName;
			wfname += " "+SystemEnv.getHtmlLabelName(81901,user.getLanguage())+":"; 
			wfname += begindate1+" "+begintime1;
			wfname += " "+SystemEnv.getHtmlLabelName(2105,user.getLanguage())+":";
			wfname += MeetingRoomComInfo.getMeetingRoomInfoname(""+address1)+customizeAddress;
			//wfname=Util.toMultiLangScreen("24574")+":"+meetingName+"-"+ResourceComInfo.getLastname(user.getUID()+"")+"-"+CurrentDate;
				   SysRemindWorkflow.setMeetingSysRemind(wfname,Util.getIntValue(meetingid),Util.getIntValue(MeetingContacter),wfaccepter,wfremark);
		}
	}
	 
    MeetingViewer.setMeetingShareById(meetingid);
	MeetingComInfo.removeMeetingInfoCache();
	 
	meetingLog.resetParameter();
	meetingLog.insSysLogInfo(user,Util.getIntValue(meetingid),meetingname,"变更会议","303","2",1,Util.getIpAddr(request));
	
	//删除未触发的提醒
	RecordSet.execute("delete FROM meeting_remind where meeting='"+meetingid+"'");
	//删除日程
	RecordSet.execute("select id from workplan where meetingid = '"+meetingid+"'");
	while(RecordSet.next()){
		RecordSetDB.execute("DELETE FROM WorkPlanShareDetail where workid="+RecordSet.getString(1));
	}
	RecordSet.executeSql("DELETE FROM WorkPlan WHERE meetingid = '"+meetingid+"'");
	//重新生成新的提醒和日程
	MeetingInterval.createWPAndRemind(meetingid,null,Util.getIpAddr(request),false,true);
	%>
	<script type="text/javascript">
		window.parent.closeWinAFrsh();
	</script>
	<%
	return;
}
%>