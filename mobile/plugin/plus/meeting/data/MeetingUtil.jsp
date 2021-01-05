<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.remind.MeetingRemindUtil"%>
<%@page import="weaver.meeting.defined.MeetingWFUtil"%>
<%@page import="weaver.meeting.MeetingShareUtil"%> 

<%@ include file="/page/maint/common/initNoCache.jsp"%>

<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.meeting.Maint.MeetingInterval" %>
<%@page import="weaver.wxinterface.InterfaceUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetDB" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="meetingLog" class="weaver.meeting.MeetingLog" scope="page" />
<%
FileUpload fu = new FileUpload(request);
String userid = ""+user.getUID();
String allUser=MeetingShareUtil.getAllUser(user);
String CurrentUser = ""+user.getUID();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
char flag = 2;

String method = Util.null2String(fu.getParameter("method"));
String meetingId = fu.getParameter("meetingId");
//获得取消权限
if(method.equals("getMeetingList"))
{
    Map retResult = new HashMap();
	String address = Util.null2String(fu.getParameter("address"));
	if("".equals(address)){
		retResult.put("status","1");
        retResult.put("msg","没有获取到会议室ID");
	}else{
		RecordSet.executeSql("select count(1) count from meetingroom where id = "+address);
		RecordSet.next();
		if(RecordSet.getInt("count") > 0){
			String beginDate = Util.null2String(fu.getParameter("beginDate"));
		    String endDate = Util.null2String(fu.getParameter("endDate"));
		    StringBuffer sqlStringBuffer = new StringBuffer("select distinct t1.id,t1.name,t1.address,t1.customizeAddress,t1.caller,t1.contacter,t1.creater,t1.begindate,t1.begintime,t1.enddate,t1.endtime,t1.meetingstatus,t1.isdecision, t.id as tid, t.name as typename ");
		    sqlStringBuffer.append(" from   Meeting t1 , Meeting_Type  t ");
		    sqlStringBuffer.append(" where 1=1 ");
		    sqlStringBuffer.append(" and t1.meetingtype = t.id  and t1.repeatType = 0 ");
		    //取消的会议不在日历中显示
		    sqlStringBuffer.append(" and (t1.cancel <> 1 or t1.cancel is null) ");
		    sqlStringBuffer.append(" AND ( (t1.beginDate >= '");
		    sqlStringBuffer.append(beginDate);
		    sqlStringBuffer.append("' AND t1.beginDate <= '");
		    sqlStringBuffer.append(endDate);
		    sqlStringBuffer.append("') OR ");
		    sqlStringBuffer.append(" (t1.endDate >= '");
		    sqlStringBuffer.append(beginDate);
		    sqlStringBuffer.append("' AND t1.endDate <= '");
		    sqlStringBuffer.append(endDate);
		    sqlStringBuffer.append("') OR ");
		    sqlStringBuffer.append(" (t1.endDate >= '");
		    sqlStringBuffer.append(endDate);
		    sqlStringBuffer.append("' AND t1.beginDate <= '");
		    sqlStringBuffer.append(beginDate);
		    sqlStringBuffer.append("') OR ");
		    sqlStringBuffer
		            .append(" ((t1.endDate IS null OR t1.endDate = '') AND t1.beginDate <= '");
		    sqlStringBuffer.append(beginDate);
		    sqlStringBuffer.append("') )");
		    
		    if(!address.equals("")){
		        String getAddress = " and a.id = " + address +" ";
		        if("oracle".equals(RecordSet.getDBType())){
		            sqlStringBuffer.append( " and exists (select 1 from MeetingRoom a  where ','||to_char(t1.address)||',' like '%,'||to_char(a.id)||',%' " + getAddress+MeetingShareUtil.getRoomShareSql(user)+" ) ");
		        }else{
		            sqlStringBuffer.append( " and exists (select 1 from MeetingRoom a  where ','+convert(varchar,t1.address)+',' like '%,'+convert(varchar,a.id)+',%' " + getAddress+MeetingShareUtil.getRoomShareSql(user)+") ");
		        }
		    }
		    sqlStringBuffer.append(" order by t1.beginDate,t1.begintime");
		    Map result = null;
		    List eventslist = new ArrayList();
		    RecordSet.executeSql(sqlStringBuffer.toString());
		    while (RecordSet.next()) {
		        result = new HashMap();
		        result.put("name",RecordSet.getString("name"));
		        result.put("address",RecordSet.getString("address"));
		        result.put("beginDate",RecordSet.getString("beginDate"));
                result.put("beginTime",RecordSet.getString("beginTime"));
                result.put("endDate",RecordSet.getString("endDate"));
                result.put("endTime",RecordSet.getString("endTime"));
                result.put("caller", ResourceComInfo.getLastname(RecordSet.getString("caller")));
                result.put("contacter",ResourceComInfo.getLastname(RecordSet.getString("contacter")));
                String creater = RecordSet.getString("creater");
                String deptId = ResourceComInfo.getDepartmentID(creater);
                result.put("creater",ResourceComInfo.getLastname(creater));
                result.put("deptName",DepartmentComInfo.getDepartmentname(deptId));
                eventslist.add(result);
		        
		    }
		    if(eventslist.size()>0){
		        retResult.put("status","0");
		        retResult.put("msg",eventslist);
		    }else{
                retResult.put("status","3");
                retResult.put("msg","该时间内当前会议室没有使用记录");
            }
		}else{
			retResult.put("status","2");
            retResult.put("msg","会议室不存在");
		}
	}
    JSONObject obj = JSONObject.fromObject(retResult);
    out.clearBuffer();
    out.print(obj.toString());
	
}
//获得取消权限
if(method.equals("getCancelRight"))
{
	Map retMap = new HashMap(); 
	
	RecordSet.executeProc("Meeting_SelectByID",meetingId);
	RecordSet.next();
	String caller=Util.null2String(RecordSet.getString("caller"));
	//System.out.println("caller===="+caller);
	String contacter=Util.null2String(RecordSet.getString("contacter"));
	String creater=Util.null2String(RecordSet.getString("creater"));
	String begindate=Util.null2String(RecordSet.getString("begindate"));
	String begintime=Util.null2String(RecordSet.getString("begintime"));
	String enddate=Util.null2String(RecordSet.getString("enddate"));
	String endtime=Util.null2String(RecordSet.getString("endtime"));
	String meetingstatus=Util.null2String(RecordSet.getString("meetingstatus"));
	String isdecision=Util.null2String(RecordSet.getString("isdecision"));
	int repeatType = Util.getIntValue(RecordSet.getString("repeatType"),0);
	
	boolean isover = false;//会议是否结束
	//该会议的meetingstatus=2,并且结束时间不在当前时间之后或者该会议已产生会议决议，该会议即为结束
	if((enddate+":"+endtime).compareTo(CurrentDate+":"+CurrentTime)<=0 || isdecision.equals("2")) isover=true;
	int userPrm=1;
	if(MeetingShareUtil.containUser(allUser,caller)){
	    userPrm = meetingSetInfo.getCallerPrm();
	    if(userPrm != 3) userPrm = 3;
	}else{
	    if( MeetingShareUtil.containUser(allUser,contacter)){
	        userPrm = meetingSetInfo.getContacterPrm();
	    }
	    
	    if( MeetingShareUtil.containUser(allUser,creater)&&userPrm<3){
	        if(userPrm < meetingSetInfo.getCreaterPrm()){
	            userPrm = meetingSetInfo.getCreaterPrm();
	        }
	    }
	}
	
	//当状态为待审批、正常，召集人可取消会议
	if("4".equals(meetingstatus)){
		retMap.put("status","1");
        retMap.put("msg","该会议已经取消");
	}
	if(userPrm == 3 ||MeetingShareUtil.containUser(allUser,caller)){
        retMap.put("status","2");
        retMap.put("msg","没有取消会议权限");
    }
	if("2".equals(meetingstatus) && isover){
        retMap.put("status","3");
        retMap.put("msg","会议已结束");
    }
	if(("1".equals(meetingstatus) || ("2".equals(meetingstatus) && !isover)) && (userPrm == 3 ||MeetingShareUtil.containUser(allUser,caller)) && repeatType == 0)
	{
		retMap.put("status","0");
		retMap.put("msg","");
	}
	JSONObject obj = JSONObject.fromObject(retMap);
    out.clearBuffer();
    out.print(obj.toString());
	
}
//取消会议
if(method.equals("cancelMeeting"))
{
	Map retMap = new HashMap();
	int meetingStatus = -1;
	
	//会议取消，触发系统提醒工作流
	String MeetingName="";
	String MeetingDate="";
	String MeetingTime="";
	String MeetingContacter="";
	String callerN = "";
	String createrN = "";
	String remindTypeNew="";
	RecordSet.executeSql("select * from meeting where id = '"+meetingId+"'");
	while(RecordSet.next()){
	   MeetingName=RecordSet.getString("name");
	   MeetingDate=RecordSet.getString("begindate");
	   MeetingTime = RecordSet.getString("begintime");
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
	List<String> userList = new ArrayList<String>();
	String[]  wfaccepterArr = wfaccepter.split(",");
	for(int i =0;i<wfaccepterArr.length;i++){
		if(!wfaccepterArr[i].equals("")){
			userList.add(wfaccepterArr[i]);
		}
	}
	String tpids = RecordSet.getPropValue("QC303688_meeting","tpids");
	String content = MeetingDate + " " + MeetingTime +" 会议:"+MeetingName+"已取消，请知晓。" ;
	String dataid = meetingId;
	int type=6;
	Map<String,Object> map = new HashMap<String,Object>();
	//更新状态
	RecordSet.executeSql("SELECT * FROM Meeting WHERE id = " + meetingId + " AND (meetingStatus = 1 OR meetingStatus = 2)");	
	boolean cancelRight = HrmUserVarify.checkUserRight("Canceledpermissions:Edit",user);
	if(userPrm != 3 && !cancelRight){
		retMap.put("status","1");
	    retMap.put("msg","没有权限取消会议");
	}
	if(RecordSet.next()  && ( userPrm == 3 || cancelRight))
	{	
		if(1!=meetingStatus&&meetingSetInfo.getCancelMeetingRemindChk()==1){
		    SysRemindWorkflow.setMeetingSysRemind(wfname,Util.getIntValue(meetingId),Util.getIntValue(MeetingContacter),wfaccepter,wfremark);
		}
		InterfaceUtil.sendMsg(userList,tpids,dataid,content,type,map);
		meetingStatus = RecordSet.getInt("meetingStatus");
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
	    retMap.put("status","0");
	    retMap.put("msg","");
	}else{
		retMap.put("status","2");
        retMap.put("msg","没有对应的会议");
	}
	JSONObject obj = JSONObject.fromObject(retMap);
    out.clearBuffer();
    out.print(obj.toString());
}
%>