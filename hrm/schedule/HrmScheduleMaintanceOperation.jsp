<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.tools.Time" %>
<%@ page import="weaver.conn.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
Time time = new Time() ; 
int userid = user.getUID() ; 
Calendar todaycal = Calendar.getInstance () ; 
String today =  Util.add0(todaycal.get(Calendar.YEAR) , 4) + "-" + 
                Util.add0(todaycal.get(Calendar.MONTH) + 1 , 2) + "-" + 
                Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ; 

String opera = Util.null2String(request.getParameter("operation")) ; 
char separator = Util.getSeparator() ; 
String procedurepara = "" ; 

int id = Util.getIntValue(request.getParameter("id") , 0) ; 
String resourceids = Util.fromScreen(request.getParameter("resourceid") , user.getLanguage()) ; 

String diffid = Util.fromScreen(request.getParameter("diffid") , user.getLanguage()) ; 
String startdate = Util.fromScreen(request.getParameter("startdate") , user.getLanguage()) ; 
String starttime = Util.fromScreen(request.getParameter("starttime") , user.getLanguage()) ; 
String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage()) ; 

String endtime = Util.fromScreen(request.getParameter("endtime") , user.getLanguage()) ; 
String totaltime = Util.fromScreen(request.getParameter("totaltime") , user.getLanguage()) ; 
String memo = Util.fromScreen(request.getParameter("memo") , user.getLanguage()) ; 
String createtype = Util.fromScreen(request.getParameter("createtype") , user.getLanguage()) ;

String counttime       = Util.null2String(request.getParameter("counttime")) ; 
String fromdate       = Util.null2String(request.getParameter("fromdate")) ; 
String theenddate       = Util.null2String(request.getParameter("theenddate")) ; 
String worktimeid       = Util.null2String(request.getParameter("worktimeid")) ; 

// 从考勤偏差来的信息
String departmentid  = Util.null2String(request.getParameter("departmentid")) ; 
String resourceidpar  = Util.null2String(request.getParameter("resourceidpar")) ; 
String isself  = Util.null2String(request.getParameter("isself")) ;

String difftype = "" ;
String realdifftime = "0" ;

RecordSet.executeSql( " select difftype from HrmScheduleDiff where id = " + diffid ) ;
if( RecordSet.next() ) difftype = Util.null2String(RecordSet.getString("difftype")) ;

if(!totaltime.equals("")  )  {
    int hoursepindex = totaltime.indexOf(":") ;
    if(hoursepindex != -1) {
        int totalhour = Util.getIntValue(totaltime.substring(0,hoursepindex),0) ;
        int totalminitus = Util.getIntValue(totaltime.substring(hoursepindex+1),0) ;
        int totalrealtime = totalhour*60 + totalminitus ;
        realdifftime = "" + totalrealtime ;
    }
    else realdifftime = "" + Util.getIntValue(totaltime,0) ;
}

if(opera.equals("insert")) { 
    if(!HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add" , user)) { 
        response.sendRedirect("/notice/noright.jsp") ; 
        return ; 
    } 

    ArrayList al = new ArrayList() ; 
    al = Util.TokenizerString(resourceids , ",") ; 
    for(int i = 0 ; i < al.size() ; i++) { 
        String resourceid = (String)al.get(i) ; 
        procedurepara = diffid + separator + resourceid + separator + startdate + separator + starttime +  separator + enddate + separator + endtime + separator + memo  + separator + createtype + separator + userid + separator + today + separator + realdifftime + separator + difftype; 

        RecordSet.executeProc("HrmScheduleMain_Insert" , procedurepara) ; 
        RecordSet.next() ; 
        id = RecordSet.getInt(1) ; 

        RecordSet.executeSql("update HrmScheduleMaintance set realcarddifftime = " + Util.getIntValue(counttime,0) + " where id = " + id ) ; 
		if(!worktimeid.equals("")){
        RecordSet.executeSql("update HrmWorkTimeWarp set diffid = " + id + " , diffcounttime= " + Util.getIntValue(realdifftime,0) + " where id = " + worktimeid ) ; 
}
	    log.resetParameter() ; 
	    log.setRelatedId(id) ; 
        log.setRelatedName(ResourceComInfo.getResourcename(resourceid)) ; 
      	log.setOperateType("1") ; 
        log.setOperateDesc("HrmScheduleMain_Insert") ; 
      	log.setOperateItem("79") ; 
      	log.setOperateUserid(user.getUID()) ; 
      	log.setClientAddress(request.getRemoteAddr()) ; 
      	log.setSysLogInfo() ; 
    } 
    
    if( isself.equals("1") ) {
        response.sendRedirect("HrmWorkTimeWarpList.jsp?fromdate="+fromdate+"&enddate="+theenddate+"&departmentid="+departmentid+"&isself="+isself+"&resourceid="+resourceidpar) ; 
    }
    else {
        response.sendRedirect("HrmScheduleMaintance.jsp") ; 
    }
} 

if(opera.equals("save")) { 
	if(!HrmUserVarify.checkUserRight("HrmScheduleMaintanceEdit:Edit" , user)) { 
    		response.sendRedirect("/notice/noright.jsp") ; 
    		return ; 
	} 

	procedurepara = id + "" + separator + diffid + separator + resourceids + separator + startdate   + separator  + starttime + separator + enddate + separator + endtime + separator + memo + separator + realdifftime + separator + difftype ; 
    
    RecordSet.executeProc("HrmScheduleMain_Update" , procedurepara) ; 

    

    RecordSet.executeSql("update HrmWorkTimeWarp set diffcounttime= " + Util.getIntValue(realdifftime,0) + " where diffid = " + id ) ; 
	
	log.resetParameter() ; 
	log.setRelatedId(id) ; 
    log.setRelatedName(ResourceComInfo.getResourcename(resourceids)) ; 
    log.setOperateType("2") ; 
    log.setOperateDesc("HrmScheduleMain_Update") ; 
    log.setOperateItem("79") ; 
    log.setOperateUserid(user.getUID()) ; 
    log.setClientAddress(request.getRemoteAddr()) ; 
    log.setSysLogInfo() ; 

    response.sendRedirect("HrmScheduleMaintanceView.jsp?id=" + id +"&fromdate="+fromdate+"&enddate="+theenddate) ; 
} 
if(opera.equals("submit")) { 
	totaltime = time.getTotalTimeOnce(resourceids , diffid , startdate , starttime , enddate , endtime) ; 
	
    response.sendRedirect("HrmScheduleMaintanceEdit.jsp?id=" + id + "&resourceid=" + resourceids + "&diffid=" + diffid + "&startdate=" + startdate + "&starttime=" + starttime + "&enddate=" + enddate + "&endtime=" + endtime + "&totaltime=" + totaltime + "&memo=" + memo) ; 
} 

if(opera.equals("new")) { 
	totaltime = time.getTotalTimeOnce(resourceids , diffid , startdate , starttime , enddate , endtime) ; 

    response.sendRedirect("HrmScheduleMaintanceAdd.jsp?resourceid=" + resourceids + "&diffid=" + diffid + "&startdate=" + startdate + "&starttime=" + starttime + "&enddate=" + enddate + "&endtime=" + endtime + "&totaltime=" + totaltime + "&worktimeid=" + worktimeid + "&counttime="+counttime+"&fromdate="+fromdate+"&theenddate="+theenddate+"&memo=" + memo+"&departmentid="+departmentid+"&isself="+isself+"&resourceidpar="+resourceidpar) ; 
} 

if(opera.equals("delete")) { 
	if(!HrmUserVarify.checkUserRight("HrmScheduleMaintanceDelete:Delete" , user)) { 
    		response.sendRedirect("/notice/noright.jsp") ; 
    		return ; 
	} 

	RecordSet.executeProc("HrmScheduleMain_Delete" , id + "") ; 
    RecordSet.executeSql("update HrmWorkTimeWarp set diffid = 0 , diffcounttime=0 where diffid = " + id ) ; 

	log.resetParameter() ; 
	log.setRelatedId(id) ; 
    log.setRelatedName(ResourceComInfo.getResourcename(resourceids)) ; 
    log.setOperateType("3") ; 
    log.setOperateDesc("HrmScheduleMain_Delete") ; 
    log.setOperateItem("79") ; 
    log.setOperateUserid(user.getUID()) ; 
    log.setClientAddress(request.getRemoteAddr()) ; 
    log.setSysLogInfo() ; 

    if( !fromdate.equals("") ) {
        response.sendRedirect("HrmWorkTimeWarpList.jsp?fromdate="+fromdate+"&enddate="+theenddate) ; 
    }
    else {
        response.sendRedirect("HrmScheduleMaintance.jsp") ;  
    }    
} 
%>