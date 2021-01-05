
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@page import="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager"%>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page"/>
<jsp:useBean id="HrmAnnualManagement" class="weaver.hrm.schedule.HrmAnnualManagement" scope="page"/>
<jsp:useBean id="HrmPaidSickManagement" class="weaver.hrm.schedule.HrmPaidSickManagement" scope="page"/>
<jsp:useBean id="HrmPaidLeaveManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveManager" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
FileUpload fu = new FileUpload(request);
//add by lvyi 2015-04-22
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
String requestname = Util.fromScreen3(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));
String method = Util.fromScreen(fu.getParameter("method"),user.getLanguage()); // 作为新建文档时候的参数传递
String topage=URLDecoder.decode(Util.null2String(fu.getParameter("topage")));  //返回的页面
String sql = "";
int urger=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"urger"),0);

HrmScheduleDiffUtil.setUser(user);
HrmScheduleDiffUtil.setForSchedule(true);

if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
    return ;
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
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;
//System.out.println("messageType===="+messageType);
RequestManager.setUser(user) ;
//add by chengfeng.han 2011-7-28 td20647 
int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
RequestManager.setIsagentCreater(isagentCreater);
RequestManager.setBeAgenter(beagenter);
//end

boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;

if( !savestatus ) {
    if( requestid != 0 ) {

        String message=RequestManager.getMessage();
        if(!"".equals(message)){
			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }

        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&message=1');</script>");
        return ;
    }
}
	int newLeaveType = Util.getIntValue(fu.getParameter("newLeaveType"), 0);
	if(newLeaveType != 0) RecordSet.executeSql("update Bill_BoHaiLeave set newLeaveType = "+newLeaveType+", vacationInfo='"+Util.null2String(fu.getParameter("vacationInfo"))+"' where requestid = "+requestid);

    sql = "select * from Bill_BoHaiLeave where requestid = " + requestid;
    RecordSet.executeSql(sql);
    RecordSet.next();
    String workflowcreater = RecordSet.getString("resourceid");
    if("submit".equalsIgnoreCase(src) && RequestManager.getIsremark()==0){
		//TD15253 控制结束日期（时间）不能在开始日期（时间之前） Start
	    String fromDateAll = Util.null2String(RecordSet.getString("fromDate")).trim();
	    String fromTimeAll = Util.null2String(RecordSet.getString("fromTime")).trim();
	    String toDateAll = Util.null2String(RecordSet.getString("toDate")).trim();
	    String toTimeAll = Util.null2String(RecordSet.getString("toTime")).trim();
	    if(!"".equals(fromDateAll) && !"".equals(toDateAll)){//开始、结束日期都不能为空，否则不判断
	    	if("".equals(fromTimeAll)){
	    		fromTimeAll = "00:00:00";
	    	}else if(fromTimeAll.length() == 5){
	    		fromTimeAll = fromTimeAll + ":00";
	    	}
	    	if("".equals(toTimeAll)){
	    		toTimeAll = "23:59:59";
	    	}else if(toTimeAll.length() == 5){
	    		toTimeAll = toTimeAll + ":00";
	    	}
	    	long leaveTimesAll = TimeUtil.timeInterval(fromDateAll+" "+fromTimeAll, toDateAll+" "+toTimeAll);
	    	if(leaveTimesAll <= 0){//结束日期（时间）在开始之前
	    		out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=24569');</script>");
	    		return;
	    	}
	    }
    }
	//TD15253 控制结束日期（时间）不能在开始日期（时间之前） End

    String leaveType = RecordSet.getString("newLeaveType");
    //获取所有带薪假类型
	String strleaveTypes = new HrmLeaveTypeColorManager().getPaidleaveStr();
    
	HrmLeaveTypeColorManager leaveTypeColorManager = new HrmLeaveTypeColorManager();  
	HrmLeaveTypeColor leaveTypeColor = (HrmLeaveTypeColor)leaveTypeColorManager.get(leaveTypeColorManager.getMapParam("field004:"+leaveType));
	leaveTypeColor = leaveTypeColor == null? new HrmLeaveTypeColor():leaveTypeColor;  
	int isCalWorkDay = leaveTypeColor.getIsCalWorkDay();
	int relateweekday = leaveTypeColor.getRelateweekday();
	
    String otherLeaveType = RecordSet.getString("otherLeaveType");
    ArrayList annualsql = new ArrayList();//存放销假的sql语句
    float leavedaysAll = 0;//存放本次请假天数，用于更新Bill_BoHaiLeave
//如果用户请假类型为年假，则检查，年假时间是否大于可请年假时间，如果大于则不允许提交
if(src.equals("submit")&&!nodetype.equals("3")&&leaveType.equals(String.valueOf(HrmAttVacation.L6))) {
    
    String fromDate = RecordSet.getString("fromDate");
    String fromTime = RecordSet.getString("fromTime");
    String toDate = RecordSet.getString("toDate");
    String toTime = RecordSet.getString("toTime"); 
    
    String creater = RecordSet.getString("resourceid");
    
	int subcompanyid1=user.getUserSubCompany1();
	int locationid = 0;
    RecordSet.executeSql("select b.subcompanyid1,a.locationid from hrmresource a,hrmdepartment b where a.departmentid=b.id and a.id="+creater);
    if(RecordSet.next()){
		subcompanyid1=Util.getIntValue(RecordSet.getString("subcompanyid1"),-1);
	   	locationid=Util.getIntValue(RecordSet.getString("locationid"),0);
		if(subcompanyid1<=0){
			subcompanyid1=user.getUserSubCompany1();
		}
	}

	String sqlHrmLocations = "select countryid from HrmLocations where id="+locationid;
	RecordSet.executeSql(sqlHrmLocations);
	String countryId = "";
	if (RecordSet.next()){
	   countryId =  RecordSet.getString("countryid");
	}
	User tmpUser = User.getUser(Util.getIntValue(creater),0);


	HrmScheduleDiffUtil.setUser(tmpUser);
	HrmScheduleDiffUtil.setForSchedule(true);
    //本次请假时间
    String leavetime = HrmScheduleDiffUtil.getTotalWorkingDays(fromDate,fromTime,toDate,toTime,subcompanyid1,isCalWorkDay,relateweekday);
    
    Calendar today = Calendar.getInstance() ; 
    String currentdate = Util.add0(today.get(Calendar.YEAR),4) + "-" + Util.add0(today.get(Calendar.MONTH)+1,2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH),2);
    String thisyear = Util.add0(today.get(Calendar.YEAR),4);
    String lastyear = Util.add0(today.get(Calendar.YEAR)-1,4);
    //可请年假总时间
    String allannualtime = "";
    //上一年剩余年假天数
    String lastyearannualtime = "";
    //今天剩余年假天数
    String thisyearannualtime = "";
    
    try{
        String tempvalue = HrmAnnualManagement.getUserAannualInfo(workflowcreater,currentdate);
        thisyearannualtime = Util.TokenizerString2(tempvalue,"#")[0];
        lastyearannualtime = Util.TokenizerString2(tempvalue,"#")[1];
        allannualtime = Util.TokenizerString2(tempvalue,"#")[2];    
    }catch(Exception e){
        
    }
    
    float leavedays = Util.getFloatValue(leavetime,0);//本次请假时间
    leavedaysAll = leavedays;
    float allannualdays = Util.getFloatValue(allannualtime,0);//用户剩余年假时间
    float lastyearannualdays = Util.getFloatValue(lastyearannualtime,0);
    float thisyearannualdays = Util.getFloatValue(thisyearannualtime,0);
    DecimalFormat   df   =   new   DecimalFormat("0.##");
       
    if(allannualdays<leavedays){
       //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message=182");
       out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=182');</script>");
       return ;
    }else{
       //销假sql，先请上一年年假，再请当前年年假
       if(leavedays<lastyearannualdays){
         sql = "update hrmannualmanagement set annualdays = (annualdays - " + leavedays + ") where annualyear = " + lastyear + " and resourceid = " + creater;     
         annualsql.add(sql);
       }else{
         sql = "update hrmannualmanagement set annualdays = 0 where annualyear = " + lastyear + " and resourceid = " + creater;
         annualsql.add(sql);
         sql = "update hrmannualmanagement set annualdays = (annualdays - " + Util.getFloatValue(df.format(leavedays - lastyearannualdays),0) + ") where annualyear = " + thisyear + " and resourceid = " + creater;
         annualsql.add(sql);
       }                   
    }
}else if(src.equals("submit")&&!nodetype.equals("3")&& !"".equals(leaveType) && strleaveTypes.indexOf(","+leaveType+",") > -1 ) {//带薪病假
    
    String fromDate = RecordSet.getString("fromDate");
    String fromTime = RecordSet.getString("fromTime");
    String toDate = RecordSet.getString("toDate");
    String toTime = RecordSet.getString("toTime"); 
    
    String creater = RecordSet.getString("resourceid");

	int subcompanyid1=user.getUserSubCompany1();
	int locationid = 0;
    RecordSet.executeSql("select b.subcompanyid1,a.locationid from hrmresource a,hrmdepartment b where a.departmentid=b.id and a.id="+creater);
    if(RecordSet.next()){
		subcompanyid1=Util.getIntValue(RecordSet.getString("subcompanyid1"),-1);
	   	locationid=Util.getIntValue(RecordSet.getString("locationid"),0);
		if(subcompanyid1<=0){
			subcompanyid1=user.getUserSubCompany1();
		}
	}
	String sqlHrmLocations = "select countryid from HrmLocations where id="+locationid;
	RecordSet.executeSql(sqlHrmLocations);
	String countryId = "";
	if (RecordSet.next()){
	   countryId =  RecordSet.getString("countryid");
	}
	User tmpUser = User.getUser(Util.getIntValue(creater),0);
	HrmScheduleDiffUtil.setUser(tmpUser);
	HrmScheduleDiffUtil.setForSchedule(true);
    //本次请假时间
    String leavetime = HrmScheduleDiffUtil.getTotalWorkingDays(fromDate,fromTime,toDate,toTime,subcompanyid1,isCalWorkDay,relateweekday);
    
    Calendar today = Calendar.getInstance() ; 
    String currentdate = Util.add0(today.get(Calendar.YEAR),4) + "-" + Util.add0(today.get(Calendar.MONTH)+1,2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH),2);
    String thisyear = Util.add0(today.get(Calendar.YEAR),4);
    String lastyear = Util.add0(today.get(Calendar.YEAR)-1,4);
  //可请带薪病假总时间
    String allpsltime = "";
    //上一年剩余带薪病假天数
    String lastyearpsltime = "";
    //今年剩余带薪病假天数
    String thisyearpsltime = "";
    
    try{
        String tempvalue = HrmPaidSickManagement.getUserPaidSickInfo(workflowcreater,currentdate,leaveType);
        thisyearpsltime = Util.TokenizerString2(tempvalue,"#")[0];
        lastyearpsltime = Util.TokenizerString2(tempvalue,"#")[1];
        allpsltime = Util.TokenizerString2(tempvalue,"#")[2];    
    }catch(Exception e){
        
    }
    
    float leavedays = Util.getFloatValue(leavetime,0);//本次请假时间
    leavedaysAll = leavedays;
    float allpsldays = Util.getFloatValue(allpsltime,0);//用户剩余带薪病假时间
    float lastyearpsldays = Util.getFloatValue(lastyearpsltime,0);
    float thisyearpsldays = Util.getFloatValue(thisyearpsltime,0);
    DecimalFormat   df   =   new   DecimalFormat("0.##");
       
    if(allpsldays<leavedays){
       //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message=182");
       out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=183');</script>");
       return ;
    }else{
        //销假sql，先请上一年带薪病假，再请当前年带薪病假
        if(leavedays<lastyearpsldays){
		  sql = "update HrmPSLManagement set psldays = (psldays - " + leavedays + ") where pslyear = " + lastyear + " and resourceid = " + creater+" and leavetype="+leaveType;
          annualsql.add(sql);
        }else{
		  sql = "update HrmPSLManagement set psldays = 0 where pslyear = " + lastyear + " and resourceid = " + creater+" and leavetype="+leaveType;
          annualsql.add(sql);
          sql = "update HrmPSLManagement set psldays = (psldays - " + Util.getFloatValue(df.format(leavedays - lastyearpsldays),0) + ") where pslyear = " + thisyear + " and resourceid = " + creater+" and leavetype="+leaveType;
          annualsql.add(sql);
        }                   
    }
}else{//计算请假天数
	String fromDate = RecordSet.getString("fromDate");
	String fromTime = RecordSet.getString("fromTime");
	String toDate = RecordSet.getString("toDate");
	String toTime = RecordSet.getString("toTime");
    
	String resourceId = RecordSet.getString("resourceid");

	int subcompanyid1=user.getUserSubCompany1();
	int locationid = 0;
    RecordSet.executeSql("select b.subcompanyid1,a.locationid from hrmresource a,hrmdepartment b where a.departmentid=b.id and a.id="+resourceId);
    if(RecordSet.next()){
		subcompanyid1=Util.getIntValue(RecordSet.getString("subcompanyid1"),-1);
	   	locationid=Util.getIntValue(RecordSet.getString("locationid"),0);
		if(subcompanyid1<=0){
			subcompanyid1=user.getUserSubCompany1();
		}
	}
	
	String sqlHrmLocations = "select countryid from HrmLocations where id="+locationid;
	RecordSet.executeSql(sqlHrmLocations);
	String countryId = "";
	if (RecordSet.next()){
	   countryId =  RecordSet.getString("countryid");
	}
	User tmpUser = User.getUser(Util.getIntValue(resourceId),0);
	HrmScheduleDiffUtil.setUser(tmpUser);
	HrmScheduleDiffUtil.setForSchedule(true);
	//本次请假时间
	String leavetime = HrmScheduleDiffUtil.getTotalWorkingDays(fromDate,fromTime,toDate,toTime,subcompanyid1,isCalWorkDay,relateweekday);
	float leavedays = Util.getFloatValue(leavetime,0);//本次请假时间
    leavedaysAll = leavedays;
}
if(("submit".equalsIgnoreCase(src)||"save".equalsIgnoreCase(src)) && RequestManager.getIsremark()==0){
	sql = "update Bill_BoHaiLeave set leaveDays="+leavedaysAll+" where requestid="+requestid;
	RecordSet.executeSql(sql);
}
boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
    //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
    out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=2');</script>");
    return ;
}

//如果流程归档了，则使年假生效，在用户可请年假减去当前本次请的年假
sql = "select currentnodetype from workflow_requestbase where requestid = " + requestid;
RecordSet.executeSql(sql);
RecordSet.next();
String currentnodetype = RecordSet.getString("currentnodetype");

if(src.equals("submit")&&!nodetype.equals("3")&&currentnodetype.equals("3")) {
    
    sql = "select * from Bill_BoHaiLeave where requestid = " + requestid;
    RecordSet.executeSql(sql);
    RecordSet.next();
    String fromDate = RecordSet.getString("fromDate");
    String fromTime = RecordSet.getString("fromTime");
    String toDate = RecordSet.getString("toDate");
    String toTime = RecordSet.getString("toTime"); 
    String creater = RecordSet.getString("resourceid");

	int subcompanyid1=user.getUserSubCompany1();
	int locationid = 0;
    RecordSet.executeSql("select b.subcompanyid1,a.locationid from hrmresource a,hrmdepartment b where a.departmentid=b.id and a.id="+creater);
    if(RecordSet.next()){
		subcompanyid1=Util.getIntValue(RecordSet.getString("subcompanyid1"),-1);
	   	locationid=Util.getIntValue(RecordSet.getString("locationid"),0);
		if(subcompanyid1<=0){
			subcompanyid1=user.getUserSubCompany1();
		}
	}
	String sqlHrmLocations = "select countryid from HrmLocations where id="+locationid;
	RecordSet.executeSql(sqlHrmLocations);
	String countryId = "";
	if (RecordSet.next()){
	   countryId =  RecordSet.getString("countryid");
	}
		
	User tmpUser = User.getUser(Util.getIntValue(creater),0);
	HrmScheduleDiffUtil.setUser(tmpUser);
	HrmScheduleDiffUtil.setForSchedule(true);
    //本次请假时间
    String leavetime = HrmScheduleDiffUtil.getTotalWorkingDays(fromDate,fromTime,toDate,toTime,subcompanyid1,isCalWorkDay,relateweekday);
    
    Calendar today = Calendar.getInstance() ; 
    String currentdate = Util.add0(today.get(Calendar.YEAR),4) + "-" + Util.add0(today.get(Calendar.MONTH)+1,2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH),2);
    String thisyear = Util.add0(today.get(Calendar.YEAR),4);
    String lastyear = Util.add0(today.get(Calendar.YEAR)-1,4);
    
    float leavedays = Util.getFloatValue(leavetime,0);//本次请假时间
    DecimalFormat   df   =   new   DecimalFormat("0.##");
    
    //通过HrmAnnualLeaveInfo的status进行年假的记录1代表未进入年假 2代表准备扣减年假 3代表销上一年年假 4代表先销上一年年假，再销当前年年假
    sql = "delete from HrmAnnualLeaveInfo where requestid = " + requestid;
    RecordSet.executeSql(sql);
    sql = "insert into HrmAnnualLeaveInfo (requestid,resourceid,startdate,starttime,enddate,endtime,leavetime,occurdate,leavetype,otherleavetype,status) values ("+requestid+","+creater+",'"+fromDate+"','"+fromTime+"','"+toDate+"','"+toTime+"','"+leavedays+"','"+currentdate+"','"+leaveType+"','"+otherLeaveType+"',1)";
    RecordSet.executeSql(sql);
    
    RecordSet.executeSql("select * from Bill_BoHaiLeave where requestid = "+requestid);
    RecordSet.next();
    String confirmNewLeavetype = RecordSet.getString("newLeaveType");
    if(!leaveType.equals(confirmNewLeavetype)) leaveType = confirmNewLeavetype;
	
    if(leaveType.equals(String.valueOf(HrmAttVacation.L6))){
        //可请年假总时间
        String allannualtime = "";
        //上一年剩余年假天数
        String lastyearannualtime = "";
        //今天剩余年假天数
        String thisyearannualtime = "";
        
        try{
            String tempvalue = HrmAnnualManagement.getUserAannualInfo(workflowcreater,currentdate);
            thisyearannualtime = Util.TokenizerString2(tempvalue,"#")[0];
            lastyearannualtime = Util.TokenizerString2(tempvalue,"#")[1];
            allannualtime = Util.TokenizerString2(tempvalue,"#")[2];    
        }catch(Exception e){
            
        }
        RecordSet.executeSql("update HrmAnnualLeaveInfo set status=2 where requestid = " + requestid);
        float allannualdays = Util.getFloatValue(allannualtime,0);//用户剩余年假时间
        float lastyearannualdays = Util.getFloatValue(lastyearannualtime,0);
        float thisyearannualdays = Util.getFloatValue(thisyearannualtime,0);
      //销假sql，先销上一年年假，再销当前年年假
      if(leavedays<lastyearannualdays){
		RecordSet.executeSql("update HrmAnnualLeaveInfo set status=3 where requestid = " + requestid);
         sql = "update hrmannualmanagement set annualdays = (annualdays - " + leavedays + ") where annualyear = " + lastyear + " and resourceid = " + creater;     
         RecordSet.executeSql(sql);
      }else{
       	RecordSet.executeSql("update HrmAnnualLeaveInfo set status=4 where requestid = " + requestid);
         sql = "update hrmannualmanagement set annualdays = 0 where annualyear = " + lastyear + " and resourceid = " + creater;
         RecordSet.executeSql(sql);
         sql = "update hrmannualmanagement set annualdays = (annualdays - " + Util.getFloatValue(df.format(leavedays - lastyearannualdays),0) + ") where annualyear = " + thisyear + " and resourceid = " + creater;
         RecordSet.executeSql(sql);
      }
    }else if(!"".equals(leaveType) && strleaveTypes.indexOf(","+leaveType+",") > -1 ){//带薪病假
        //可请带薪病假总时间
        String allannualtime = "";
        //上一年剩余带薪病假天数
        String lastyearannualtime = "";
        //今年剩余带薪病假天数
        String thisyearannualtime = "";
        
        try{
            String tempvalue = HrmPaidSickManagement.getUserPaidSickInfo(workflowcreater,currentdate,leaveType);
            thisyearannualtime = Util.TokenizerString2(tempvalue,"#")[0];
            lastyearannualtime = Util.TokenizerString2(tempvalue,"#")[1];
            allannualtime = Util.TokenizerString2(tempvalue,"#")[2];    
        }catch(Exception e){
            
        }
        float allannualdays = Util.getFloatValue(allannualtime,0);//用户剩余带薪病假时间
        float lastyearannualdays = Util.getFloatValue(lastyearannualtime,0);
        float thisyearannualdays = Util.getFloatValue(thisyearannualtime,0);
        //销假sql，先销上一年年假，再销当前年年假，如果年假小于0，则年假在本年上增加年假
        if(leavedays<0){
     	     sql = "update HrmPSLManagement set psldays = (psldays - " + leavedays + ") where pslyear = " + thisyear + " and resourceid = " + creater+" and leavetype="+leaveType;      
              RecordSet.executeSql(sql);  
     	  }else if(leavedays<lastyearannualdays){
              sql = "update HrmPSLManagement set psldays = (psldays - " + leavedays + ") where pslyear = " + lastyear + " and resourceid = " + creater+" and leavetype="+leaveType;     
              RecordSet.executeSql(sql);
           }else{
              sql = "update HrmPSLManagement set psldays = 0 where pslyear = " + lastyear + " and resourceid = " + creater+" and leavetype="+leaveType;
              RecordSet.executeSql(sql);
              sql = "update HrmPSLManagement set psldays = (psldays - " + Util.getFloatValue(df.format(leavedays - lastyearannualdays),0) + ") where pslyear = " + thisyear + " and resourceid = " + creater+" and leavetype="+leaveType;
              RecordSet.executeSql(sql);
        }
	
	} else if(leaveType.equals(String.valueOf(HrmAttVacation.L13))){//调休
		HrmPaidLeaveManager.paidLeaveDeduction(creater, fromDate, fromTime, toDate, toTime);
    }
}

boolean logstatus = RequestManager.saveRequestLog() ;



if( method.equals("") ) 
	if(!topage.equals("")){
        	if(topage.indexOf("?")!=-1)
        	{
        		//response.sendRedirect(topage+"&requestid="+requestid);
        		out.print("<script>wfforward('"+topage+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"');</script>");
        		return;
        	}
        	else
        	{
				//response.sendRedirect(topage+"?requestid="+requestid);
				out.print("<script>wfforward('"+topage+"?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"');</script>");
        		return;
        	}
		}
    else {
        if(iscreate.equals("1")||src.equals("save")){
            //response.sendRedirect("/workflow/request/RequestView.jsp");
        	
        	%>
        	<%@ include file="/workflow/request/RedirectPage.jsp" %> 
        	<%
        	
        }
        else{
        	//System.out.println("delete".equals(src) && savestatus && flowstatus);
            if("delete".equals(src) && savestatus && flowstatus){%>
                <SCRIPT LANGUAGE="JavaScript">
	                alert("<%=SystemEnv.getHtmlLabelName(20461,user.getLanguage())%>");
	                //window.close();
			    	try{
			    	    window.close();
			    	    window.opener._table.reLoad();
			    	}catch(e){}
			    	try{
			    	    parent.window.close();
			    	    parent.window.opener._table.reLoad();
			    	}catch(e){}
			        window.history.go(-2);
			   		try{	
			   			parent.window.opener.btnWfCenterReload.onclick();
			   		}catch(e){}
			   		try{
			   			parent.window.opener.reLoad();
			   		}catch(e){}
       			</SCRIPT>
                <%
                	return;
            }
            else{
	            //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1"+"&urger="+urger);//td3450 xwj 20060207
	            //out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1"+"&urger="+urger+"');</script>"); 	
	            
            	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1"+"&urger="+urger+"');</script>"); 	
	            return;
            }
        }
    }

else {
    String adddocfieldid = method.substring(7) ;
    topage = URLEncoder.encode("/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&docfileid="+adddocfieldid+"&topage="+topage);
    //response.sendRedirect("/docs/docs/DocList.jsp?topage="+topage);
    out.print("<script>wfforward('/docs/docs/DocList.jsp?topage="+topage+"');</script>");
//  showsubmit 为0的时候新建文档将不显示提交按钮  response.sendRedirect("/docs/docs/DocList.jsp?topage="+topage+"&showsubmit=0");
}

%>
