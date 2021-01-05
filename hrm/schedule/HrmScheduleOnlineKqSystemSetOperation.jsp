<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="HrmKqSystemComInfo" class="weaver.hrm.schedule.HrmKqSystemComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
    
int needSign = Util.getIntValue(request.getParameter("needSign"),0) ; //是否启用签到功能
int onlyWorkDay = Util.getIntValue(request.getParameter("onlyworkday"),0);//是在工作日显示
String signTimeScope = Util.null2String(request.getParameter("signTimeScope"));//是在工作日显示
String signIpScope = Util.null2String(request.getParameter("signIpScope")) ; //签到签退ip

int id = Util.getIntValue(Util.null2String(request.getParameter("id")),0) ; //一般工作时间id
int relatedid = Util.getIntValue(Util.null2String(request.getParameter("relatedid")),0)  ; //适用分部

//检查分部是否和一般工作时间的分部一致
String checkIfOk = "select count(1) from hrmschedule where id="+id+" and relatedid="+relatedid;
RecordSet.executeSql(checkIfOk);
RecordSet.next();
int checkCount = RecordSet.getInt(1);
if(checkCount > 0){
	String sql = " update HrmSchedule set needSign="+needSign+", onlyworkday="+onlyWorkDay+", " 
						 + " signTimeScope='"+signTimeScope+"', signIpScope='"+signIpScope+"'"
						 +" where id="+id;
	RecordSet.executeSql(sql);
	HrmKqSystemComInfo.removeSystemCache() ; //
	response.sendRedirect("/hrm/schedule/HrmScheduleOnlineKqSystemSet.jsp?isclose=1&id="+id) ; 
}else{
	response.sendRedirect("/hrm/schedule/HrmScheduleOnlineKqSystemSet.jsp?isdialog=1&id="+id+"&msg=1") ; 
}

%>
