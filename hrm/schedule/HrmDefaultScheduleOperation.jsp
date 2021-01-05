<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "log" class = "weaver.systeminfo.SysMaintenanceLog" scope = "page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>

<%
/*
if(!HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit", user)){
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
}  */

String operation = Util.fromScreen(request.getParameter("operation") , user.getLanguage()) ; 


int id = Util.getIntValue(request.getParameter("id") , 0) ; // 编辑或者删除的时候获得id

String monstarttime1 = Util.fromScreen(request.getParameter("monstarttime1") , user.getLanguage()) ; 
String monendtime1 = Util.fromScreen(request.getParameter("monendtime1") , user.getLanguage()) ; 
String monstarttime2 = Util.fromScreen(request.getParameter("monstarttime2") , user.getLanguage()) ; 
String monendtime2 = Util.fromScreen(request.getParameter("monendtime2") , user.getLanguage()) ; 

String tuestarttime1 = Util.fromScreen(request.getParameter("tuestarttime1") , user.getLanguage()) ; 
String tueendtime1 = Util.fromScreen(request.getParameter("tueendtime1") , user.getLanguage()) ; 
String tuestarttime2 = Util.fromScreen(request.getParameter("tuestarttime2") , user.getLanguage()) ; 
String tueendtime2 = Util.fromScreen(request.getParameter("tueendtime2") , user.getLanguage()) ; 

String wedstarttime1 = Util.fromScreen(request.getParameter("wedstarttime1") , user.getLanguage()) ; 
String wedendtime1 = Util.fromScreen(request.getParameter("wedendtime1") , user.getLanguage()) ; 
String wedstarttime2 = Util.fromScreen(request.getParameter("wedstarttime2") , user.getLanguage()) ; 
String wedendtime2 = Util.fromScreen(request.getParameter("wedendtime2") , user.getLanguage()) ; 

String thustarttime1 = Util.fromScreen(request.getParameter("thustarttime1") , user.getLanguage()) ; 
String thuendtime1 = Util.fromScreen(request.getParameter("thuendtime1") , user.getLanguage()) ; 
String thustarttime2 = Util.fromScreen(request.getParameter("thustarttime2") , user.getLanguage()) ; 
String thuendtime2 = Util.fromScreen(request.getParameter("thuendtime2") , user.getLanguage()) ; 

String fristarttime1 = Util.fromScreen(request.getParameter("fristarttime1") , user.getLanguage()) ; 
String friendtime1 = Util.fromScreen(request.getParameter("friendtime1") , user.getLanguage()) ; 
String fristarttime2 = Util.fromScreen(request.getParameter("fristarttime2") , user.getLanguage()) ; 
String friendtime2 = Util.fromScreen(request.getParameter("friendtime2") , user.getLanguage()) ; 

String satstarttime1 = Util.fromScreen(request.getParameter("satstarttime1") , user.getLanguage()) ; 
String satendtime1 = Util.fromScreen(request.getParameter("satendtime1") , user.getLanguage()) ; 
String satstarttime2 = Util.fromScreen(request.getParameter("satstarttime2") , user.getLanguage()) ; 
String satendtime2 = Util.fromScreen(request.getParameter("satendtime2") , user.getLanguage()) ; 

String sunstarttime1 = Util.fromScreen(request.getParameter("sunstarttime1") , user.getLanguage());
String sunendtime1 = Util.fromScreen(request.getParameter("sunendtime1") , user.getLanguage()) ; 
String sunstarttime2 = Util.fromScreen(request.getParameter("sunstarttime2") , user.getLanguage()) ; 
String sunendtime2 = Util.fromScreen(request.getParameter("sunendtime2") , user.getLanguage()) ; 

// 增加有效日期
String validedatefrom = Util.fromScreen(request.getParameter("validedatefrom") , user.getLanguage()) ; 
String validedateto = Util.fromScreen(request.getParameter("validedateto") , user.getLanguage()) ; 

//增加类型和对象
String scheduleType = Util.fromScreen(request.getParameter("scheduleType") , user.getLanguage()) ;
if(scheduleType.trim().equals("")){
	scheduleType="3";
}
String relatedId= weaver.common.StringUtil.vString(request.getParameter("relatedId") , "0") ;
//获取对象中文名
String relatedname = Util.fromScreen(request.getParameter("relatedname") , user.getLanguage()) ;
if(!operation.equals("deleteschedule")){
	relatedname = new weaver.hrm.schedule.HrmDefaultSchedule().getRelatedName(relatedId,scheduleType);
}
if(scheduleType.equals("3")&&relatedname.equals("")){
	relatedname=SystemEnv.getHtmlLabelName(140,user.getLanguage());
}
String signType = weaver.common.StringUtil.vString(request.getParameter("signType") , "1");
String signStartTime = weaver.common.StringUtil.vString(request.getParameter("signStartTime"));

String totaltime = "" ; 
totaltime = Util.addTime(Util.subTime(monendtime1 , monstarttime1) , Util.subTime(monendtime2 , monstarttime2)) ; 
totaltime = Util.addTime(totaltime , Util.addTime(Util.subTime(tueendtime1 , tuestarttime1) , Util.subTime(tueendtime2 , tuestarttime2))) ; 
totaltime = Util.addTime(totaltime , Util.addTime(Util.subTime(wedendtime1 , wedstarttime1) , Util.subTime(wedendtime2 , wedstarttime2))) ; 
totaltime = Util.addTime(totaltime , Util.addTime(Util.subTime(thuendtime1 , thustarttime1) , Util.subTime(thuendtime2 , thustarttime2))) ; 
totaltime = Util.addTime(totaltime , Util.addTime(Util.subTime(friendtime1 , fristarttime1) , Util.subTime(friendtime2 , fristarttime2))) ; 
totaltime = Util.addTime(totaltime , Util.addTime(Util.subTime(satendtime1 , satstarttime1) , Util.subTime(satendtime2 , satstarttime2))) ; 
totaltime = Util.addTime(totaltime , Util.addTime(Util.subTime(sunendtime1 , sunstarttime1) , Util.subTime(sunendtime2 , sunstarttime2))) ; 

char separator = Util.getSeparator() ; 

if(operation.equals("editschedule")) { 
	
	String procedurepara= "" + id + separator  + relatedId + separator + monstarttime1 + separator + monendtime1 + separator + monstarttime2 + separator + monendtime2 + separator + tuestarttime1 + separator + tueendtime1 + separator + tuestarttime2 + separator + tueendtime2 + separator + wedstarttime1 + separator + wedendtime1 + separator + wedstarttime2 + separator + wedendtime2 + separator +  thustarttime1 + separator+ thuendtime1 + separator + thustarttime2 + separator + thuendtime2 + separator + fristarttime1 + separator+ friendtime1 + separator + fristarttime2 + separator + friendtime2 + separator + satstarttime1 + separator+ satendtime1 + separator + satstarttime2 + separator + satendtime2 + separator + sunstarttime1 + separator+ sunendtime1 + separator + sunstarttime2 + separator + sunendtime2 + separator + totaltime + separator+ validedatefrom + separator+ validedateto+ separator+ scheduleType ; 
	RecordSet.executeProc("HrmSchedule_Update" , procedurepara) ; 
	RecordSet.executeSql("update HrmSchedule set sign_type = "+signType+", sign_start_time = '"+(signType.equals("1") ? "" : signStartTime)+"' where id = "+id);
	log.resetParameter() ; 
	log.setRelatedId(id) ; 
    log.setRelatedName(relatedname) ; 
    log.setOperateType("2") ; 
//  log.setOperateDesc("HrmSchedule_Update") ; 
    log.setOperateItem("13") ; 
    log.setOperateUserid(user.getUID()) ; 
    log.setClientAddress(request.getRemoteAddr()) ; 
    log.setSysLogInfo() ; 
    
    new weaver.hrm.schedule.HrmKqSystemComInfo().removeSystemCache() ;
    
    response.sendRedirect("/hrm/schedule/HrmDefaultSchedule.jsp?isclose=1&id="+id) ; 
 
}
if(operation.equals("insertschedule")) {
	String[] _ids = relatedId.split(",");
	if(_ids.length > 0 )  {
		for(String _id : _ids){
			if(_id.length() == 0&&!scheduleType.equals("3")){
				continue;
			}
			String procedurepara = "" + _id + separator  + monstarttime1 + separator+ monendtime1 + separator + monstarttime2 + separator + monendtime2 + separator + tuestarttime1 + separator+ tueendtime1 + separator + tuestarttime2 + separator + tueendtime2 + separator + wedstarttime1 + separator+ wedendtime1 + separator + wedstarttime2 + separator + wedendtime2 + separator + thustarttime1 + separator+ thuendtime1 + separator + thustarttime2 + separator + thuendtime2 + separator + fristarttime1 + separator +  friendtime1 + separator + fristarttime2 + separator + friendtime2 + separator + satstarttime1 + separator+ satendtime1 + separator + satstarttime2 + separator + satendtime2 + separator +            sunstarttime1 + separator+ sunendtime1 + separator + sunstarttime2 + separator + sunendtime2 + separator + totaltime + separator+ validedatefrom + separator+ validedateto+ separator+ scheduleType ; 
				
			RecordSet.executeProc("HrmSchedule_Insert" , procedurepara) ; 
			if( RecordSet.next() )  id = RecordSet.getInt(1) ; 
			RecordSet.executeSql("update HrmSchedule set sign_type = "+signType+", sign_start_time = '"+signStartTime+"' where id = "+id);
			log.resetParameter() ; 
			log.setRelatedId(id) ; 
			log.setRelatedName(relatedname) ; 
			log.setOperateType("1") ; 
		//  log.setOperateDesc("HrmSchedule_Insert") ; 
			log.setOperateItem("13") ; 
			log.setOperateUserid(user.getUID()) ; 
			log.setClientAddress(request.getRemoteAddr()) ; 
			log.setSysLogInfo() ; 
		}
	}
	
	new weaver.hrm.schedule.HrmKqSystemComInfo().removeSystemCache() ;
	
    response.sendRedirect("/hrm/schedule/HrmDefaultScheduleAdd.jsp?isclose=1&id="+id) ; 
 } 

if(operation.equals("deleteschedule")) { //删除
	
	String procedurepara = "" + id ;
	RecordSet.executeSql("select relatedid,scheduleType from HrmSchedule where id = "+id);
	if(RecordSet.next()){
		relatedname = new weaver.hrm.schedule.HrmDefaultSchedule().getRelatedName(RecordSet.getString("relatedid"),RecordSet.getString("scheduleType"));
		if(relatedname.equals("-")||relatedname.equals("")){
			relatedname=SystemEnv.getHtmlLabelName(140,user.getLanguage());
		}
	}
	RecordSet.executeProc("HrmSchedule_Delete" , procedurepara) ; 
	
	log.resetParameter() ; 
	log.setRelatedId(id) ; 
    log.setRelatedName(relatedname) ; 
    log.setOperateType("3") ; 
//  log.setOperateDesc("HrmSchedule_Insert") ; 
    log.setOperateItem("13") ; 
    log.setOperateUserid(user.getUID()) ; 
    log.setClientAddress(request.getRemoteAddr()) ; 
    log.setSysLogInfo() ;
    
    new weaver.hrm.schedule.HrmKqSystemComInfo().removeSystemCache() ;
    
	response.sendRedirect("/hrm/schedule/HrmDefaultScheduleList.jsp") ; 
 }
%>