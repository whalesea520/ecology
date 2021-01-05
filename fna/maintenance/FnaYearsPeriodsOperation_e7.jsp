<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
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
		response.sendRedirect("FnaYearsPeriodsAdd.jsp?msgid=12") ; 
		return ; 
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

	SysMaintenanceLog.resetParameter() ; 
	SysMaintenanceLog.setRelatedId(id) ; 
	SysMaintenanceLog.setRelatedName(fnayear) ; 
	SysMaintenanceLog.setOperateType("1") ; 
	SysMaintenanceLog.setOperateDesc("FnaYearsPeriods_Insert," + paraold) ; 
	SysMaintenanceLog.setOperateItem("37") ; 
	SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
	SysMaintenanceLog.setSysLogInfo() ; 
	response.sendRedirect("FnaYearsPeriods.jsp") ; 
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
	String fnayear = Util.null2String(request.getParameter("fnayear")) ; 
	String para = "" + id ; 
	RecordSet.executeProc("FnaYearsPeriods_Delete" , para) ; 
	if(RecordSet.next() && RecordSet.getString(1).equals("20")) {
		response.sendRedirect("FnaYearsPeriodsEdit.jsp?id=" + id + "&msgid=20") ; 
		return ; 
	}

      SysMaintenanceLog.resetParameter() ; 
      SysMaintenanceLog.setRelatedId(id) ; 
      SysMaintenanceLog.setRelatedName(fnayear) ; 
      SysMaintenanceLog.setOperateType("3") ; 
      SysMaintenanceLog.setOperateDesc("FnaYearsPeriods_Delete," + para) ; 
      SysMaintenanceLog.setOperateItem("37") ; 
      SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
      SysMaintenanceLog.setSysLogInfo() ; 

 	response.sendRedirect("FnaYearsPeriods.jsp") ; 
 }
 /* add by wangdongli */
 else if(operation.equals("takeeffectyearperiods")) {
	 if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)) {
		response.sendRedirect("/notice/noright.jsp");
    	return;
	 }
   	int id = Util.getIntValue(request.getParameter("id")) ; 
	String fnayear = Util.null2String(request.getParameter("fnayear")) ; 
	String para = "" + id ; 
	RecordSet.executeProc("FnaYearsPeriods_TakeEffect" , para) ; 
	if(RecordSet.next() && RecordSet.getString(1).equals("-1")) {
		response.sendRedirect("FnaYearsPeriodsEdit.jsp?id=" + id + "&msgid=53") ; 
		return ; 
	}

	SysMaintenanceLog.resetParameter() ; 
	SysMaintenanceLog.setRelatedId(id) ; 
	SysMaintenanceLog.setRelatedName(fnayear) ; 
	SysMaintenanceLog.setOperateType("2") ;
	SysMaintenanceLog.setOperateDesc("FnaYearsPeriods_TakeEffect," + para) ; 
	SysMaintenanceLog.setOperateItem("37") ; 
	SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
	SysMaintenanceLog.setSysLogInfo() ; 

	response.sendRedirect("FnaYearsPeriodsEdit.jsp?id=" + id) ;
 }
 else if(operation.equals("closedownyearperiods")) {
	 if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)) {
		response.sendRedirect("/notice/noright.jsp");
    	return;
	 }
   	int id = Util.getIntValue(request.getParameter("id")) ; 
	String fnayear = Util.null2String(request.getParameter("fnayear")) ; 
	String para = "" + id ; 
	RecordSet.executeProc("FnaYearsPeriods_Close" , para) ; 

	SysMaintenanceLog.resetParameter() ; 
	SysMaintenanceLog.setRelatedId(id) ; 
	SysMaintenanceLog.setRelatedName(fnayear) ; 
	SysMaintenanceLog.setOperateType("2") ; 
	SysMaintenanceLog.setOperateDesc("FnaYearsPeriods_Close," + para) ; 
	SysMaintenanceLog.setOperateItem("37") ; 
	SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
	SysMaintenanceLog.setSysLogInfo() ; 

	response.sendRedirect("FnaYearsPeriodsEdit.jsp?id=" + id) ;
 }
 /* end */
 else if(operation.equals("edityearperiodslist")) { 
	if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Edit",user)) {
		response.sendRedirect("/notice/noright.jsp");
    	return;
	}
  	int id = Util.getIntValue(request.getParameter("id")) ; 
	String fnayear = Util.null2String(request.getParameter("fnayear")) ; 
	String startdate = Util.null2String(request.getParameter("startdate")) ; 
	String enddate = Util.null2String(request.getParameter("enddate")) ; 
	String fnayearid = Util.null2String(request.getParameter("fnayearid")) ; 
	String isactive = Util.null2String(request.getParameter("isactive")) ; 
	if(isactive.equals("")) isactive ="0" ; 
	String para = "" + id + separator + startdate + separator + enddate + separator + fnayearid +separator + isactive ; 
	RecordSet.executeProc("FnaYearsPeriodsList_Update" , para) ; 
	
      SysMaintenanceLog.resetParameter() ; 
      SysMaintenanceLog.setRelatedId(Util.getIntValue(fnayearid)) ; 
      SysMaintenanceLog.setRelatedName(fnayear) ; 
      SysMaintenanceLog.setOperateType("2") ; 
      SysMaintenanceLog.setOperateDesc("FnaYearsPeriodsList_Update," + para) ; 
      SysMaintenanceLog.setOperateItem("37") ; 
      SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
      SysMaintenanceLog.setSysLogInfo() ; 
      response.sendRedirect("FnaYearsPeriodsEdit.jsp?id=" + fnayearid) ; 
 }
 
 else if(operation.equals("closeyearperiods")) { 
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
//	out.print("cc") ; 
 	response.sendRedirect("FnaYearsPeriodsEdit.jsp?id="+fnayearid); 
 }
 
 else if(operation.equals("reopenyearperiods")) { 
  	int id = Util.getIntValue(request.getParameter("id")) ; 
	String fnayearid = Util.null2String(request.getParameter("fnayearid")) ; 
	String fnayearperiodsid = Util.null2String(request.getParameter("fnayearperiodsid")) ; 
	String para = "" + id + separator + fnayearperiodsid ; 
	RecordSet.executeProc("FnaYearsPeriodsList_Reopen" , para) ; 
 	response.sendRedirect("FnaYearsPeriodsEdit.jsp?id=" + fnayearid) ; 
 }
 else if (operation.equals("reopenDD")){
	 if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)){
		response.sendRedirect("/notice/noright.jsp");
    	return;
	 }
		int id = Util.getIntValue(request.getParameter("id")) ; 
		String fnayear = Util.null2String(request.getParameter("fnayear")) ;
        String sqlStr = "UPDATE FnaYearsPeriods SET status = 0 WHERE  id ="+ id;
        RecordSet.executeSql(sqlStr);  //重新打开

		SysMaintenanceLog.resetParameter() ; 
		SysMaintenanceLog.setRelatedId(id) ; 
		SysMaintenanceLog.setRelatedName(fnayear) ; 
		SysMaintenanceLog.setOperateType("2") ; 
		SysMaintenanceLog.setOperateDesc("UPDATE FnaYearsPeriods SET status = 0 WHERE  id ="+ id) ; 
		SysMaintenanceLog.setOperateItem("37") ; 
		SysMaintenanceLog.setOperateUserid(user.getUID()) ; 
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr()) ; 
		SysMaintenanceLog.setSysLogInfo() ; 

        response.sendRedirect("FnaYearsPeriodsEdit.jsp?&id="+id);
    }
%>