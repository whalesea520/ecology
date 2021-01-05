<%@page import="weaver.fna.maintenance.FnaYearsPeriodsListComInfo"%>
<%@page import="weaver.fna.maintenance.FnaYearsPeriodsComInfo"%>
<%@page import="weaver.fna.budget.FnaYearsPeriodsHelp"%>
<%@ page import="weaver.general.Util" %>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="org.json.JSONObject"%>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

String operation = Util.null2String(request.getParameter("operation")) ; 
char separator = Util.getSeparator() ; 
 
if(operation.equals("addyearperiods")) { 
	if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsAdd:Add" , user)) { 
		response.sendRedirect("/notice/noright.jsp");
    	return;
	}
    String fnayear = Util.null2String(request.getParameter("fnayear")) ; 
	String startdate = Util.null2String(request.getParameter("startdate")) ;
    String status = Util.null2o(request.getParameter("status")) ;
    int tempyear = Util.getIntValue(startdate.substring(0 , 4)) ;
	int tempmonth = Util.getIntValue(startdate.substring(5 , 7)) - 1 ; 
	int tempdate = Util.getIntValue(startdate.substring(8 , 10)) ; 

    String erroInfo="";
    
	Calendar _fromday = Calendar.getInstance() ; 
	Calendar _today = Calendar.getInstance() ; 
	_fromday.set(tempyear,tempmonth,tempdate) ; 
	_today.set(tempyear,tempmonth,tempdate) ; 
	_today.add(Calendar.YEAR, 1); _today.add(Calendar.DATE , -1) ; 
	
	String _startdate = "";
	String _enddate = "";
	for(int i = 1 ; i < 13 ; i++)  {
		String tempstartdate = Util.add0(_fromday.get(Calendar.YEAR), 4) + "-" +
								Util.add0(_fromday.get(Calendar.MONTH) + 1 , 2) + "-" +
								Util.add0(_fromday.get(Calendar.DAY_OF_MONTH) , 2) ; 
		_fromday.add(Calendar.MONTH, 1) ; _fromday.add(Calendar.DATE , -1) ; 
		String tempenddate = Util.add0(_fromday.get(Calendar.YEAR) , 4) + "-" + 
								Util.add0(_fromday.get(Calendar.MONTH) + 1, 2) + "-" + 
								Util.add0(_fromday.get(Calendar.DAY_OF_MONTH) , 2) ;
		
		if(i==1){
			_startdate = tempstartdate;
		}else if(i==12){
			_enddate = tempenddate;
		}
		
		_fromday.add(Calendar.DATE , 1) ; 
	}
	erroInfo = FnaYearsPeriodsHelp.checkAdd(fnayear, _startdate, _enddate, user.getLanguage(), -1);
	
	if("".equals(erroInfo)){
		Calendar fromday = Calendar.getInstance() ; 
		Calendar today = Calendar.getInstance() ; 
		fromday.set(tempyear,tempmonth,tempdate) ; 
		today.set(tempyear,tempmonth,tempdate) ; 
		today.add(Calendar.YEAR, 1); today.add(Calendar.DATE , -1) ; 
		String enddate = Util.add0(today.get(Calendar.YEAR) , 4) + "-" +
	                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
	                     Util.add0(today.get(Calendar.DAY_OF_MONTH) , 2) ; 
		
		String para = fnayear + separator + startdate + separator + enddate + separator + status ;
		String paraold = para ;
		RecordSet.executeProc("FnaYearsPeriods_Insert" , para) ;
		RecordSet.next() ;
		int	id = RecordSet.getInt(1) ;
		if(id == -1) {
			erroInfo=SystemEnv.getErrorMsgName(53, user.getLanguage());
		}
		for(int i = 1 ; i < 13 ; i++)  {
			String tempstartdate = Util.add0(fromday.get(Calendar.YEAR), 4) + "-" +
									Util.add0(fromday.get(Calendar.MONTH) + 1 , 2) + "-" +
									Util.add0(fromday.get(Calendar.DAY_OF_MONTH) , 2) ; 
			fromday.add(Calendar.MONTH, 1) ; fromday.add(Calendar.DATE , -1) ; 
			String tempenddate = Util.add0(fromday.get(Calendar.YEAR) , 4) + "-" + 
									Util.add0(fromday.get(Calendar.MONTH) + 1, 2) + "-" + 
									Util.add0(fromday.get(Calendar.DAY_OF_MONTH) , 2) ;
			
			para = "" + id + separator + "" + i + separator + fnayear + separator + tempstartdate + separator + tempenddate+separator + "1" ; 
			RecordSet.executeProc("FnaYearsPeriodsList_Insert" , para) ; 
			fromday.add(Calendar.DATE , 1) ; 
		}
		para = "" + id + separator + "13" + separator + fnayear + separator + "" + separator + "" + separator + "0" ; 
		RecordSet.executeProc("FnaYearsPeriodsList_Insert" , para) ; 	
		
		new FnaYearsPeriodsComInfo().removeFnaYearsPeriodsCache();
		new FnaYearsPeriodsListComInfo().removeFnaYearsPeriodsListCache();
		
		if("".equals(erroInfo)){
			SysMaintenanceLog.resetParameter() ; 
			SysMaintenanceLog.setRelatedId(id) ; 
			SysMaintenanceLog.setRelatedName(fnayear) ; 
			SysMaintenanceLog.setOperateType("1") ; 
			SysMaintenanceLog.setOperateDesc("FnaYearsPeriods_Insert," + paraold) ; 
			SysMaintenanceLog.setOperateItem("37") ; 
			SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
			SysMaintenanceLog.setSysLogInfo() ; 
			out.println("{\"flag\":true,\"erroInfo\":\"\",\"fnayearid\":"+id+"}");
		}else{
			out.println("{\"flag\":false,\"erroInfo\":"+JSONObject.quote(erroInfo)+"}");
		}
	}else{
		out.println("{\"flag\":false,\"erroInfo\":"+JSONObject.quote(erroInfo)+"}");
	}

}
else if(operation.equals("edityearperiods")) {
	if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsAdd:Add" , user)) { 
		response.sendRedirect("/notice/noright.jsp");
    	return;
	}
  	int id = Util.getIntValue(request.getParameter("id")) ; 
	String fnayear = Util.null2String(request.getParameter("fnayear")) ; 
	String budgetid = Util.null2String(request.getParameter("budgetid")) ; 
	String para = "" + id + separator + budgetid ; 
	RecordSet.executeProc("FnaYearsPeriods_Update" , para) ; 	
	
	new FnaYearsPeriodsComInfo().removeFnaYearsPeriodsCache();
	new FnaYearsPeriodsListComInfo().removeFnaYearsPeriodsListCache();
	
    SysMaintenanceLog.resetParameter() ; 
    SysMaintenanceLog.setRelatedId(id) ; 
    SysMaintenanceLog.setRelatedName(fnayear) ; 
    SysMaintenanceLog.setOperateType("2") ; 
    SysMaintenanceLog.setOperateDesc("FnaYearsPeriods_Update," + para) ; 
    SysMaintenanceLog.setOperateItem("37") ; 
    SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
    SysMaintenanceLog.setSysLogInfo() ; 
 	response.sendRedirect("FnaYearsPeriods.jsp") ; 
 }
 else if(operation.equals("deleteyearperiods")) {
	 if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)) {
		response.sendRedirect("/notice/noright.jsp");
    	return;
	 }
   	int id = Util.getIntValue(request.getParameter("id")) ;
   	String para = "";
   	String fnayear = "";
   	String erroInfo = "";
   	RecordSet.executeSql("select fnayear from FnaYearsPeriods where id = "+id);
   	if(RecordSet.next()){
		fnayear = RecordSet.getString("fnayear");
		para = "" + id ; 
		RecordSet.executeProc("FnaYearsPeriods_Delete" , para) ; 
		if(RecordSet.next() && RecordSet.getString(1).equals("20")) {
			//response.sendRedirect("FnaYearsPeriodsEdit.jsp?id=" + id + "&msgid=20") ; 
			erroInfo = SystemEnv.getErrorMsgName(20, user.getLanguage());
		}
   	}	
	
	new FnaYearsPeriodsComInfo().removeFnaYearsPeriodsCache();
	new FnaYearsPeriodsListComInfo().removeFnaYearsPeriodsListCache();
   	
   	if("".equals(erroInfo)){
		SysMaintenanceLog.resetParameter() ; 
		SysMaintenanceLog.setRelatedId(id) ; 
		SysMaintenanceLog.setRelatedName(fnayear) ; 
		SysMaintenanceLog.setOperateType("3") ; 
		SysMaintenanceLog.setOperateDesc("FnaYearsPeriods_Delete," + para) ; 
		SysMaintenanceLog.setOperateItem("37") ; 
		SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
		SysMaintenanceLog.setSysLogInfo() ; 

 		out.print("{\"flag\":true,\"erroInfo\":\"\"}");
   	}else{
 		out.print("{\"flag\":false,\"erroInfo\":"+JSONObject.quote(erroInfo)+"}");
   	}
	out.flush();
	return;
 }
 else if(operation.equals("haseffectyearperiods")) {
	if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)) {	
		response.sendRedirect("/notice/noright.jsp");
    	return;
	}
	out.print("{\"flag\":false}");//return false，表示校验通过
	out.flush();
	return;
 }
 else if(operation.equals("takeeffectyearperiods")) {
	 if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)) {
		response.sendRedirect("/notice/noright.jsp");
    	return;
	 }
	 String fnayear="";
	 String para="";
	 String erroInfo="";
   	 
	 int id = Util.getIntValue(request.getParameter("id"));
	 if(Boolean.valueOf(request.getParameter("_flag"))){
		 RecordSet.executeSql("update FnaYearsPeriods set status=-1 where status=1");
	 }
	 RecordSet.executeSql("select fnayear from FnaYearsPeriods where id = "+id);
   	 if(RecordSet.next()){
		 fnayear = Util.null2String(RecordSet.getString("fnayear"));
		 para = "" + id ; 
   	 }
	 para = "" + id ; 
	 /*
	 RecordSet.executeProc("FnaYearsPeriods_TakeEffect" , para) ; 
	 if(RecordSet.next() && RecordSet.getString(1).equals("-1")) {
		 //response.sendRedirect("FnaYearsPeriodsEdit.jsp?id=" + id + "&msgid=53") ; 
		 erroInfo=SystemEnv.getErrorMsgName(53, user.getLanguage());
	 }
	 */
	 RecordSet.executeSql("UPDATE FnaYearsPeriods SET status = 1 WHERE id = "+id);	
		
	new FnaYearsPeriodsComInfo().removeFnaYearsPeriodsCache();
	new FnaYearsPeriodsListComInfo().removeFnaYearsPeriodsListCache();
	 
	 if("".equals(erroInfo)){
	 	SysMaintenanceLog.resetParameter() ; 
	 	SysMaintenanceLog.setRelatedId(id) ; 
	 	SysMaintenanceLog.setRelatedName(fnayear) ; 
	 	SysMaintenanceLog.setOperateType("2") ;
	 	SysMaintenanceLog.setOperateDesc("FnaYearsPeriods_TakeEffect," + para) ; 
	 	SysMaintenanceLog.setOperateItem("37") ; 
	 	SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
	 	SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
	 	SysMaintenanceLog.setSysLogInfo() ; 
	 	
		out.print("{\"flag\":true}");
	 }else{
//		 response.sendRedirect("FnaYearsPeriodsEdit.jsp?id=" + id) ;
		 out.print("{\"flag\":false,\"erroInfo\":"+JSONObject.quote(erroInfo)+"}");
	 }
     out.flush();
	 return;
 }
 else if(operation.equals("closedownyearperiods")) {
	 if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)) {
		response.sendRedirect("/notice/noright.jsp");
    	return;
	 }
   	int id = Util.getIntValue(request.getParameter("id")) ; 
   	String fnayear="";
   	String para="";
	RecordSet.executeSql("select fnayear from FnaYearsPeriods where id = "+id);
   	if(RecordSet.next()){
		fnayear = Util.null2String(RecordSet.getString("fnayear"));
	    para = "" + id ; 
   	} 
	RecordSet.executeProc("FnaYearsPeriods_Close" , para) ; 	
	
	new FnaYearsPeriodsComInfo().removeFnaYearsPeriodsCache();
	new FnaYearsPeriodsListComInfo().removeFnaYearsPeriodsListCache();

	SysMaintenanceLog.resetParameter() ; 
	SysMaintenanceLog.setRelatedId(id) ; 
	SysMaintenanceLog.setRelatedName(fnayear) ; 
	SysMaintenanceLog.setOperateType("2") ; 
	SysMaintenanceLog.setOperateDesc("FnaYearsPeriods_Close," + para) ; 
	SysMaintenanceLog.setOperateItem("37") ; 
	SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
	SysMaintenanceLog.setSysLogInfo() ; 

	out.print("{\"flag\":true}");
	out.flush();
	return;
 }
 /* end */
 else if(operation.equals("edityearperiodslist")) { 
	if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Edit",user)) {
		response.sendRedirect("/notice/noright.jsp");
    	return;
	}
//  	int id = Util.getIntValue(request.getParameter("id")) ; 
	String fnayearid = Util.null2String(request.getParameter("id")) ; 
	String fnayear = Util.null2String(request.getParameter("fnayear")) ; 

    String erroInfo="";
    String[] startdateArray = new String[]{"","","","","","","","","","","",""};
    String[] enddateArray =   new String[]{"","","","","","","","","","","",""};
	for(int i=1;i<=12;i++){
		String beginDate = Util.null2String(request.getParameter("beginDate_"+i)) ;
		String endDate = Util.null2String(request.getParameter("endDate_"+i)) ;

		startdateArray[i-1] = beginDate;
		enddateArray[i-1] = endDate;
	}
	
	erroInfo = FnaYearsPeriodsHelp.checkUpdate(fnayear, startdateArray, enddateArray, user.getLanguage(), Util.getIntValue(fnayearid));
	
	if("".equals(erroInfo)){
		String sql = "update FnaYearsPeriods"+ 
				" set startdate = '"+StringEscapeUtils.escapeSql(startdateArray[0])+"', "+
				" enddate = '"+StringEscapeUtils.escapeSql(enddateArray[11])+"' "+
				" where id = "+Util.getIntValue(fnayearid);
		RecordSet.executeSql(sql);
	
		for(int i=1;i<=12;i++){
			String beginDate = Util.null2String(request.getParameter("beginDate_"+i)) ;
			String endDate = Util.null2String(request.getParameter("endDate_"+i)) ;
			sql = "update FnaYearsPeriodsList"+ 
				" set startdate = '"+StringEscapeUtils.escapeSql(beginDate)+"', "+
				" enddate = '"+StringEscapeUtils.escapeSql(endDate)+"' "+
				" where fnayearid = "+Util.getIntValue(fnayearid)+ 
				" and Periodsid = "+i;
			RecordSet.executeSql(sql);
		}	
		
		new FnaYearsPeriodsComInfo().removeFnaYearsPeriodsCache();
		new FnaYearsPeriodsListComInfo().removeFnaYearsPeriodsListCache();
				
		SysMaintenanceLog.resetParameter() ; 
		SysMaintenanceLog.setRelatedId(Util.getIntValue(fnayearid)) ; 
		SysMaintenanceLog.setRelatedName(fnayear) ; 
		SysMaintenanceLog.setOperateType("2") ; 
		SysMaintenanceLog.setOperateDesc("FnaYearsPeriodsList_Update,"); 
		SysMaintenanceLog.setOperateItem("37") ; 
		SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
		SysMaintenanceLog.setSysLogInfo() ; 
		
		out.print("{\"flag\":true}");
		out.flush();
		return;
	}else{
		out.println("{\"flag\":false,\"erroInfo\":"+JSONObject.quote(erroInfo)+"}");
	}
 }
 
 else if(operation.equals("closeyearperiods")) {
	if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)){
		response.sendRedirect("/notice/noright.jsp");
	   	return;
	}
  	int id = Util.getIntValue(request.getParameter("id")) ; 
	String fnayearid = Util.null2String(request.getParameter("fnayearid")) ; 
	String fnayearperiodsid = Util.null2String(request.getParameter("fnayearperiodsid")) ; 
	String para = "" + id + separator + fnayearperiodsid ; 
	RecordSet.executeProc("FnaYearsPeriodsList_Close" , para) ; 
	if(RecordSet.next()) {
		out.print(RecordSet.getString(1)) ; 
		if(RecordSet.getString(1).equals("-1")) {
			response.sendRedirect("FnaYearsPeriodsEdit.jsp?id=" + fnayearid + "&msgid=26") ; 
			return ; 
		}
		if(RecordSet.getString(1).equals("-2")) {
			response.sendRedirect("FnaYearsPeriodsEdit.jsp?id=" + fnayearid + "&msgid=26") ; 
			return ; 
		}
	}	
	
	new FnaYearsPeriodsComInfo().removeFnaYearsPeriodsCache();
	new FnaYearsPeriodsListComInfo().removeFnaYearsPeriodsListCache();
	
 	response.sendRedirect("FnaYearsPeriodsEdit.jsp?id="+fnayearid); 
 }
 
 else if(operation.equals("reopenyearperiods")) {
    if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)){
	   response.sendRedirect("/notice/noright.jsp");
   	   return;
    }
  	int id = Util.getIntValue(request.getParameter("id")) ; 
	RecordSet.execute("select fnyear from FnaYearsPeriods where id="+id);
	String fnayearperiodsid ="";
	if(RecordSet.next())
	{
		fnayearperiodsid =RecordSet.getString("fnayear");
	}	
	String para = "" + id + separator + fnayearperiodsid ; 
	RecordSet.executeProc("FnaYearsPeriodsList_Reopen" , para) ; 	
	
	new FnaYearsPeriodsComInfo().removeFnaYearsPeriodsCache();
	new FnaYearsPeriodsListComInfo().removeFnaYearsPeriodsListCache();
	
	out.print("{\"flag\":true,\"erroInfo\":\"\"}");
	return;
	
 	//response.sendRedirect("FnaYearsPeriodsEdit.jsp?id=" + fnayearid) ; 
 }
 else if (operation.equals("reopenDD")){
	 if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)){
		response.sendRedirect("/notice/noright.jsp");
    	return;
	 }
		int id = Util.getIntValue(request.getParameter("id")) ; 
		String fnayear ="";
		if(RecordSet.next())
		{
			fnayear =RecordSet.getString("fnayear");
		}	
        String sqlStr = "UPDATE FnaYearsPeriods SET status = 0 WHERE  id ="+ id;
        RecordSet.executeSql(sqlStr);  //重新打开	
		
		new FnaYearsPeriodsComInfo().removeFnaYearsPeriodsCache();
		new FnaYearsPeriodsListComInfo().removeFnaYearsPeriodsListCache();

		SysMaintenanceLog.resetParameter() ; 
		SysMaintenanceLog.setRelatedId(id) ; 
		SysMaintenanceLog.setRelatedName(fnayear) ; 
		SysMaintenanceLog.setOperateType("2") ; 
		SysMaintenanceLog.setOperateDesc("UPDATE FnaYearsPeriods SET status = 0 WHERE  id ="+ id) ; 
		SysMaintenanceLog.setOperateItem("37") ; 
		SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
		SysMaintenanceLog.setSysLogInfo() ; 

		out.print("{\"flag\":true}");
		out.flush();
		return;
    }
%>