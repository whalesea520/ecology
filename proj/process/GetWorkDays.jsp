<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<%


User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String begindate=Util.null2String(request.getParameter("begindate"));
String begintime=Util.null2String(request.getParameter("begintime"));
String enddate=Util.null2String(request.getParameter("enddate"));
String endtime=Util.null2String(request.getParameter("endtime"));
String resourceId=Util.null2String(request.getParameter("manager"));



String departmentId=ResourceComInfo.getDepartmentID(""+resourceId); 
String subCompanyId=DepartmentComInfo.getSubcompanyid1(departmentId);

//获取countryId
String localsql = "select locationid from HrmResource where id ="+resourceId;
RecordSet.executeSql(localsql);
String locationid = "";
if (RecordSet.next()){
   locationid=RecordSet.getString("locationid");
}
String countrysql = "select countryid from HrmLocations where id="+locationid;
RecordSet.executeSql(countrysql);
String countryId = "";
if (RecordSet.next()){
   countryId =  RecordSet.getString("countryid");
}

user.setCountryid(countryId);

HrmScheduleDiffUtil.setUser(user);

//日期
String totalWorkingDays="";
int datedays = TimeUtil.dateInterval(begindate,enddate);
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
Long begintimedays = sdf.parse(begindate+" "+begintime).getTime();
Long endtimedays = sdf.parse(enddate+" "+endtime).getTime();
if(datedays<0){
	totalWorkingDays="-1";
}else if(begintimedays-endtimedays>0){
	totalWorkingDays="-2";
}else {
	totalWorkingDays=HrmScheduleDiffUtil.getTotalWorkingDays(begindate,begintime,enddate,endtime,Util.getIntValue(subCompanyId,0));
}

%>

<%=totalWorkingDays %>

