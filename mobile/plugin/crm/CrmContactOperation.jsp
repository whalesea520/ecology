
<%@ page language="java" contentType="text/html; charset=UTF-8" %><?xml version="1.0" encoding="UTF-8"?>
<%@ page import="java.util.List" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.file.FileUpload"%>
<jsp:useBean id="hrmUserVarify" class="weaver.hrm.HrmUserVarify" scope="page"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="workPlanShare" class="weaver.WorkPlan.WorkPlanShare" scope="page"/>
<jsp:useBean id="workPlanLogMan" class="weaver.WorkPlan.WorkPlanLogMan" scope="page"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsc" class="weaver.conn.RecordSet" scope="page" />

<%
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	request.setCharacterEncoding("UTF-8");
	FileUpload fu = new FileUpload(request);
	User user = hrmUserVarify.getUser(request, response);	
	if(user == null)  return ;
	String userId = String.valueOf(user.getUID());  //当前用户Id
	String userType = user.getLogintype();

	String method = fu.getParameter("method");
	 
	String color = "";
    WorkPlan workPlan = new WorkPlan();

    workPlan.setCreaterId(Integer.parseInt(userId));
    workPlan.setCreateType(Integer.parseInt(userType));
    
    char sep = Util.getSeparator();
    
    //判断是否为系统管理员sysadmin 
    int isSysadmin=0;
    RecordSet rssysadminmenu=new RecordSet();
    rssysadminmenu.executeSql("select count(*) from hrmresourcemanager where id="+userId);	
    if(rssysadminmenu.next()){
	     isSysadmin=rssysadminmenu.getInt(1);
    }    
	if("addCalendarItem".equals(method))
	{	
		
	    String workPlanType ="0";  //日程类型p
	    recordSet.execute("SELECT workPlanTypeID FROM workPlanType where workPlanTypeName='签到签退'");
	    if(recordSet.next())
	    	workPlanType=recordSet.getString("workPlanTypeID");
	    workPlanType="3";
	    String workPlanName=Util.null2String(URLDecoder.decode(fu.getParameter("planName"),"UTF-8"));  //标题p
	    String urgentLevel=Util.null2String(fu.getParameter("urgentLevel"));//紧急程度p
	    urgentLevel="".equals(urgentLevel)?"1":urgentLevel;
	    String remindType = Util.null2String(fu.getParameter("remindType"));  //提醒类型
	    remindType="".equals(remindType)?"1":remindType;
	    String remindBeforeStart = Util.null2String(fu.getParameter("remindBeforeStart"));  //是否开始前提醒p
	    if(!"".equals(workPlanType) && null != workPlanType)
	    {
	        workPlan.setWorkPlanType(Integer.parseInt(workPlanType));  //日程类型	
	    }else{
	    	workPlanType="0";
	    	 workPlan.setWorkPlanType(0);
	    }
	    workPlan.setWorkPlanName(workPlanName);
	    workPlan.setUrgentLevel(urgentLevel);  
	    workPlan.setRemindType(remindType);
	    //workPlan.setRemindType(remindBeforeStart);
	    if(!"".equals(remindBeforeStart) && null != remindBeforeStart)
	    {
	        workPlan.setRemindBeforeStart(remindBeforeStart);  //是否开始前提醒
	    }
	    else
	    {
	        workPlan.setRemindBeforeStart("0");
	    }
	   
	    String remindBeforeEnd = Util.null2String(fu.getParameter("remindBeforeEnd"));  //是否结束前提醒p
	    if(!"".equals(remindBeforeEnd) && null != remindBeforeEnd)
	    {
	        workPlan.setRemindBeforeEnd(remindBeforeEnd);  //是否结束前提醒



	    }
	    else
	    {
	        workPlan.setRemindBeforeEnd("0");
	    }
	    
	    if(!"".equals(remindBeforeStart) && null != remindBeforeStart)
	    {
	    	workPlan.setRemindTimesBeforeStart(Util.getIntValue(fu.getParameter("remindDateBeforeStart"),0)*60+Util.getIntValue(Util.null2String(fu.getParameter("remindTimesBeforeStart")),0));  //开始前提醒时间p
	    }
	    else
	    {
	        workPlan.setRemindTimesBeforeStart(0);
	    }
	    
	     if(!"".equals(remindBeforeEnd) && null != remindBeforeEnd)
	    {
	    	workPlan.setRemindTimesBeforeEnd(Util.getIntValue(fu.getParameter("remindDateBeforeEnd"),0)*60+Util.getIntValue(Util.null2String(fu.getParameter("remindTimesBeforeEnd")),0));  //结束前提醒时间p
	    }
	    else
	    {
	        workPlan.setRemindTimesBeforeEnd(0);
	    }
	    
	    workPlan.setResourceId(Util.null2String(fu.getParameter("memberIDs")).equals("")?""+user.getUID():Util.null2String(fu.getParameter("memberIDs")));  //系统参与人p
	    
	    String beginDate = Util.null2String(fu.getParameter("beginDate"));  //开始日期p
	    workPlan.setBeginDate(beginDate);  //开始日期
	    String beginTime = fu.getParameter("beginTime");  //开始时间p
	    if("00".equals(beginTime) || "".equals(beginTime) || null == beginTime){
	    	//考虑到新建日程的起始时间和结束时间不同
		    String validedatefrom = beginDate.substring(0,4)+"-01-01";
		    String validedateto = beginDate.substring(0,4)+"-12-31";
		    String startSql="select * from HrmSchedule  where validedatefrom <= '"+validedatefrom+"' and validedateto >= '"+validedateto+"' ";
		    String startweek = getWeekByDate(beginDate)+"starttime1";
		    if(isSysadmin>0){//若为系统管理员则直接取总部时间
		    	startSql+=" and scheduletype = '3' ";
		    }else{
		    	startSql+=" and relatedid = (select m.subcompanyid1 from hrmresource m where m.id='"+userId+"')";
		    }
	    	rs.execute(startSql);
	    	if(rs.next()){
	              beginTime = rs.getString(startweek);
	              workPlan.setBeginTime(beginTime.equals("")?"00:00":beginTime);  //开始时间
	    	}else{//若无考勤时间记录取 00:00
	    		  workPlan.setBeginTime("00:00");  //开始时间
	    	}	    	
	    }else{
	    	workPlan.setBeginTime(beginTime);  //开始时间
	    }
	    
	    String endDate = Util.null2String(fu.getParameter("endDate"));  //结束日期p
	    workPlan.setEndDate(endDate);  //结束日期
	    String endTime = fu.getParameter("endTime");  //结束时间p
	    if(!"".equals(workPlan.getEndDate()) && null != workPlan.getEndDate() && ("".equals(endTime) || null == endTime || "00".equals(endTime)))
	    {	    	
		    String validedatefrom = endDate.substring(0,4)+"-01-01";
		    String validedateto = endDate.substring(0,4)+"-12-31";
		    String endSql="select * from HrmSchedule  where validedatefrom <= '"+validedatefrom+"' and validedateto >= '"+validedateto+"' ";		    
		    String endweek = getWeekByDate(endDate)+"endtime2";
		    if(isSysadmin>0){//若为系统管理员则直接取总部时间
		    	endSql+=" and scheduletype = '3' ";
		    }else{
		    	endSql+=" and relatedid = (select m.subcompanyid1 from hrmresource m where m.id='"+userId+"')";
		    }
		    rsc.execute(endSql);
	    	if(rsc.next()){		    
	                endTime = rsc.getString(endweek);
	                workPlan.setEndTime(endTime.equals("")?"00:00":endTime);  //结束时间
	    	}else{  //若无考勤时间记录取 00:00
	    		    workPlan.setEndTime("00:00");  //结束时间
	    	}
	    	
	    }
	    else
	    {
	        workPlan.setEndTime(endTime);  //结束时间
	    }
	    workPlan.setDescription(URLDecoder.decode(Util.null2String(fu.getParameter("description")),"UTF-8"));  //内容p
	    workPlan.setCustomer(Util.null2String(fu.getParameter("crmIDs")));  //相关客户p
	    workPlan.setDocument(Util.null2String(fu.getParameter("docIDs")));  //相关文档p
	    workPlan.setProject(Util.null2String(fu.getParameter("projectIDs")));  //相关项目p
	    workPlan.setTask(Util.null2String(fu.getParameter("taskIDs")));  //相关项目任务
	    workPlan.setWorkflow(Util.null2String(fu.getParameter("fuIDs")));  //相关流程p    
	    
	    if(!"".equals(workPlan.getBeginDate()) && null != workPlan.getBeginDate())
	    {	    	
	    	List beginDateTimeRemindList = Util.processTimeBySecond(workPlan.getBeginDate(), workPlan.getBeginTime(), workPlan.getRemindTimesBeforeStart() * -1 * 60);
	    	workPlan.setRemindDateBeforeStart((String)beginDateTimeRemindList.get(0));  //开始前提醒日期
	    	workPlan.setRemindTimeBeforeStart((String)beginDateTimeRemindList.get(1));  //开始前提醒时间
	    }
	    if(!"".equals(workPlan.getEndDate()) && null != workPlan.getEndDate())
	    {
	    	List endDateTimeRemindList = Util.processTimeBySecond(workPlan.getEndDate(), workPlan.getEndTime(), workPlan.getRemindTimesBeforeEnd() * -1 * 60);
	    	workPlan.setRemindDateBeforeEnd((String)endDateTimeRemindList.get(0));  //结束前提醒日期
	    	workPlan.setRemindTimeBeforeEnd((String)endDateTimeRemindList.get(1));  //结束前提醒时间
	    }

		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("SELECT * FROM WorkPlanType WHERE workPlanTypeId = ");
		stringBuffer.append(workPlanType);

	    recordSet.executeSql(stringBuffer.toString());
	    if(recordSet.next())
	    {
	        color = recordSet.getString("workPlanTypeColor");
	    }
	    
	    workPlanService.insertWorkPlan(workPlan);
	    workPlanShare.setDefaultShareDetail(user,String.valueOf(workPlan.getWorkPlanID()),workPlanType);
	    
	    //更新位置
	    String location=Util.null2String(fu.getParameter("location"));
	    String sql="update workplan set location='"+location+"' where id="+workPlan.getWorkPlanID();
	    recordSet.execute(sql);
	    
    	//插入日志
    	String logParams[] = new String[]
		{ String.valueOf(workPlan.getWorkPlanID()), workPlanLogMan.TP_CREATE, userId, fu.getRemoteAddr() };
		workPlanLogMan.writeViewLog(logParams);
    	
       	out.clearBuffer();
    	SimpleDateFormat format1=new SimpleDateFormat("MM/dd/yyyy HH:mm");
    	SimpleDateFormat format2=new SimpleDateFormat("yyyy-MM-dd HH:mm");
    	Date startDateTime=new Date();
    	Date endDateTime=new Date();
    	Map result=new HashMap();
   		List data=new ArrayList();
   		boolean isAllDay=false;
    	result.put("IsSuccess","true");
    	
    	data.add(""+workPlan.getWorkPlanID());
    	data.add(workPlan.getWorkPlanName());
    	if(!"".equals(workPlan.getBeginDate())){
    		startDateTime=format2.parse(workPlan.getBeginDate()+" "+workPlan.getBeginTime());
    		data.add(workPlan.getBeginDate()+" "+workPlan.getBeginTime());
    	}else{
    		data.add("");
    	}
    	if(!"".equals(workPlan.getEndDate())){
    		endDateTime=format2.parse(workPlan.getEndDate()+" "+workPlan.getEndTime());
    		data.add(workPlan.getEndDate()+" "+workPlan.getEndTime());
    		if(endDateTime.getDate()-startDateTime.getDate()>=1){
    			isAllDay=true;
    		}
    	}else{
    		data.add("");
    	}
    	data.add("0");
    	if(isAllDay){
    		data.add("1");//是不是全天
    	}else{
    		data.add("0");
    	}
    	data.add("0");//,0,1,0,-1,1,
    	data.add(color);//颜色
    	data.add("1");//editable
    	data.add("1");
    	data.add("1");
    	result.put("Data",data);
    	//["92","王企鹅全文","12/29/2011 01:30","12/29/2011 05:00","0","0","0","1","1","Belion",""]
    	JSONObject jsonObj=JSONObject.fromObject(result);
    	out.print(jsonObj.toString());
    	out.flush();
	}

%>

<%!
// 根据日期取星期（TD20444）
public String getWeekByDate(String date){
	String week=""; 
	DateFormat format1 = new SimpleDateFormat("yyyy-MM-dd"); 
	   Date d=null;
	  try {
	   d = format1.parse(date);
	  } catch (Exception e) {
	   e.printStackTrace();
	  }
	   Calendar   c   =   Calendar.getInstance();   
	   c.setTime(d);
	   week = c.getTime().toString().substring(0,3).toLowerCase();
	   return week;    	
}
%>