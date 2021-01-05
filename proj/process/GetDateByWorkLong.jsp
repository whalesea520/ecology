<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" %>

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
String workLong=Util.null2String(request.getParameter("workLong"));
String resourceId=Util.null2String(request.getParameter("manager"));
String method=Util.null2String(request.getParameter("method"));

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
String returnvalue = "";
if("getEndDate".equals(method)){
	
	String[] workLongArr = workLong.split("\\.");
	String workLongdate="";
	Double workLongtime=0.0;
	int size = workLongArr.length;
	if(size>=2){
		workLongdate=workLongArr[0];
		workLongtime=Double.parseDouble("0."+workLongArr[1]);
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
		Long timeLong1 = sdf.parse(begintime).getTime();
		Long timeLong2 = sdf.parse("09:00").getTime();
		if(timeLong1<timeLong2){
			begintime="09:00";
		}
		
	}else{
		workLongdate=workLongArr[0];
	}
	
	returnvalue = getDateByWorkLong(method,1,begindate, begintime, workLongdate, size, workLongtime, subCompanyId, countryId);
	
	
}else if("getBeginDate".equals(method)){
	
	String[] workLongArr = workLong.split("\\.");
	String workLongdate="";
	Double workLongtime=0.0;
	int size = workLongArr.length;
	if(size>=2){
		workLongdate=workLongArr[0];
		workLongtime=Double.parseDouble("0."+workLongArr[1]);
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
		Long timeLong1 = sdf.parse(endtime).getTime();
		Long timeLong2 = sdf.parse("18:00").getTime();
		if(timeLong1>timeLong2){
			endtime="18:00";
		}
	}else{
		workLongdate=workLongArr[0];
	}
	
	returnvalue = getDateByWorkLong(method,-1,enddate, endtime, workLongdate, size, workLongtime, subCompanyId, countryId);
	
}

%>

<%=returnvalue %>

<%!
private String getDateByWorkLong(String method,int days,String begindate,String begintime,String workLongdate,int size,double workLongtime,String subCompanyId,String countryId){

		HrmScheduleDiffUtil HrmScheduleDiffUtil = new HrmScheduleDiffUtil();
		String returnvalue="";
	try{
		//取日期
		boolean isworkday = true; 
		for(int i=0;i<Integer.parseInt(workLongdate);){
			isworkday=HrmScheduleDiffUtil.getIsWorkday(begindate,Integer.parseInt(subCompanyId),countryId);
			if(isworkday){
				i++;
			}
			begindate = TimeUtil.dateAdd(begindate,days);
		}
	
		//取时间
		if(!"".equals(workLongtime)){
			Double time = workLongtime*8*60*60*1000;
			java.text.DecimalFormat df = new java.text.DecimalFormat();
			df.setGroupingUsed(false);
			String b = df.format(time);
			
			String datetime = begindate+" "+begintime;
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			
			Long timeLong = sdf.parse(datetime).getTime();
			
			Date date =null;
			
			if("getEndDate".equals(method)){
				date = new Date(timeLong+Long.parseLong(b)-60*1000);
			}else if("getBeginDate".equals(method)){
				date = new Date(timeLong+Long.parseLong(b)+60*1000);
			}
			
			returnvalue = sdf.format(date);
		}
	}catch(Exception e){
		
	}
	
	return returnvalue;
}


%>
