<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "log" class = "weaver.systeminfo.SysMaintenanceLog" scope = "page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file = "/systeminfo/init_wev8.jsp" %>

<%
/*
if(!HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit", user)){
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
}  */

String operation = Util.fromScreen(request.getParameter("operation") , user.getLanguage()) ; 

int id = Util.getIntValue(request.getParameter("id") , 0) ; // 编辑或者删除的时候获得id
String shiftname = Util.fromScreen(request.getParameter("shiftname") , user.getLanguage()) ; 
String shiftbegintime = Util.fromScreen(request.getParameter("shiftbegintime") , user.getLanguage()) ; 
String shiftendtime = Util.fromScreen(request.getParameter("shiftendtime") , user.getLanguage()) ; 

// 增加有效日期
String validedatefrom = Util.fromScreen(request.getParameter("validedatefrom") , user.getLanguage()) ; 
String changeinhistory = Util.fromScreen(request.getParameter("changeinhistory") , user.getLanguage()) ; 
char separator = Util.getSeparator() ; 

if(operation.equals("editshift")) { //编辑（排班种类）

    if( changeinhistory.equals("1")) {
        String procedurepara= "" + id + separator + validedatefrom ;
        RecordSet.executeProc("HrmArrangeShift_UHistory" , procedurepara) ; 

        procedurepara= shiftname + separator + shiftbegintime + separator + shiftendtime + separator + validedatefrom + separator + "9999-12-31"  ; 
        RecordSet.executeProc("HrmArrangeShift_Insert" , procedurepara) ; 
    }
    else {
        String procedurepara= ""+id + separator + shiftname + separator + shiftbegintime + separator + shiftendtime + separator + validedatefrom  ; 
        RecordSet.executeProc("HrmArrangeShift_Update" , procedurepara) ;
    } 

	response.sendRedirect("/hrm/schedule/HrmArrangeShift.jsp?isclose=1&id="+id) ; 
 } 

if(operation.equals("insertshift")) { //插入（排班种类）
    String procedurepara = shiftname + separator + shiftbegintime + separator + shiftendtime + separator + validedatefrom + separator + "9999-12-31" ; 
	RecordSet.executeProc("HrmArrangeShift_Insert" , procedurepara) ; 
    response.sendRedirect("/hrm/schedule/HrmArrangeShiftAdd.jsp?isclose=1") ; 
 } 

if(operation.equals("deleteshift")) { //删除（排班种类）
    String procedurepara = "" + id ; 
	RecordSet.executeProc("HrmArrangeShift_Delete" , procedurepara) ; 
	response.sendRedirect("/hrm/schedule/HrmArrangeShiftList.jsp") ; 
 } 
/*
 if(operation.equals("save")){
	if(!HrmUserVarify.checkUserRight("HrmArrangeShiftMaintanceEdit:Edit", user)) { 
    		response.sendRedirect("/notice/noright.jsp") ; 
    		return ; 
	}
	procedurepara=id+"" + separator + diffid + separator + resourceids  + separator + startdate  + separator  + starttime + separator + enddate    + separator + endtime + separator + memo;        
	RecordSet.executeProc("HrmScheduleMain_Update",procedurepara);
	
	procedurepara = ""+id+separator+totaltime;	
	RecordSet.executeProc("HrmScheduleTotalTime",procedurepara);
	procedurepara = ""+id+separator+totalday;	
	RecordSet.executeProc("HrmScheduleTotalDay",procedurepara);
	
	
    response.sendRedirect("hrm/HrmMaintenance.jsp);
}
*/
%>