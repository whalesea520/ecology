<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.WorkPlan.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="net.sf.json.JSONArray" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="wpSetInfo" class="weaver.WorkPlan.WorkPlanSetInfo" scope="page" />
<jsp:useBean id="wpvList" class="weaver.WorkPlan.WorkPlanViewList" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="SptmForWorkPlan" class="weaver.splitepage.transform.SptmForWorkPlan" scope="session"/>


<%

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
int userSub = user.getUserSubCompany1(); 
Calendar calendar = Calendar.getInstance();
    

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
char flag=2;
String userid=user.getUID()+"" ;
//1: year 2:month 3:week 4:today but the year haven`t been used!
int bywhat = Util.getIntValue(request.getParameter("bywhat"),3);

String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
String objType=Util.null2String(request.getParameter("objType"));
String objIds=Util.null2String(request.getParameter("objIds"));
String workType=Util.null2String(request.getParameter("workPlanType"));

Calendar today = Calendar.getInstance();
Calendar temptoday1 = Calendar.getInstance();
Calendar temptoday2 = Calendar.getInstance();
String nowdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String nowtime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                Util.add0(today.get(Calendar.SECOND), 2);   

if(!currentdate.equals("")) {
	int tempyear = Util.getIntValue(currentdate.substring(0,4)) ;
	int tempmonth = Util.getIntValue(currentdate.substring(5,7))-1 ;
	int tempdate = Util.getIntValue(currentdate.substring(8,10)) ;
	today.set(tempyear,tempmonth,tempdate);
} 

int currentyear=today.get(Calendar.YEAR);
int thisyear=currentyear;
int currentmonth=today.get(Calendar.MONTH);  
int currentday=today.get(Calendar.DATE);

switch(bywhat) {
	case 1:
		today.set(currentyear,0,1) ;
		if(movedate.equals("1")) today.add(Calendar.YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.YEAR,-1) ;
		break ;
	case 2:
		today.set(currentyear,currentmonth,1) ;
		if(movedate.equals("1")) today.add(Calendar.MONTH,1) ;
		if(movedate.equals("-1")) today.add(Calendar.MONTH,-1) ;
		break ;
	case 3:
		Date thedate = today.getTime() ;
		int diffdate = (-1)*thedate.getDay() ;
		today.add(Calendar.DATE,diffdate) ;
		if(movedate.equals("1")) today.add(Calendar.WEEK_OF_YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.WEEK_OF_YEAR,-1) ;
		today.add(Calendar.DATE,1);
		break;
	case 4:
		if(movedate.equals("1")) today.add(Calendar.DATE,1) ;
		if(movedate.equals("-1")) today.add(Calendar.DATE,-1) ;
		break;
}

currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;  
currentday=today.get(Calendar.DATE); 

currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
temptoday1.set(currentyear,currentmonth-1,currentday) ;
temptoday2.set(currentyear,currentmonth-1,currentday) ;

calendar.set(currentyear, currentmonth - 1, currentday);
calendar.add(Calendar.MONTH, 1);
calendar.set(Calendar.DATE, 1);
calendar.add(Calendar.DATE, -1);
int daysOfThisMonth = calendar.get(Calendar.DATE);


switch (bywhat) {
	case 1 :
		today.add(Calendar.YEAR,1) ;
		break ;
	case 2:
		today.add(Calendar.MONTH,1) ;
		break ;
	case 3:
		today.add(Calendar.WEEK_OF_YEAR,1) ;
		break;
	case 4:
		today.add(Calendar.DATE,1) ;
		break;
}

currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;  
currentday=today.get(Calendar.DATE);  


String currenttodate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
String 	currentWeekEnd = "";
String datenow = "" ;
String cBeginDate="";
String cEndDate="";

switch (bywhat) {
	case 1 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4) ;
		break ;
	case 2 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;
		cBeginDate = TimeUtil.getMonthBeginDay(currentdate);
		cEndDate = TimeUtil.getMonthEndDay(currentdate);
		break ;
 	case 3 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		cBeginDate = TimeUtil.getWeekBeginDay(currentdate);
		cEndDate = TimeUtil.getWeekEndDay(currentdate);
		break ;
	case 4 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		cBeginDate = currentdate;
		cEndDate = currentdate;
		break ;
}
 
String resourceID="";
if("1".equals(objType)){//部门
	if("".equals(objIds)){
		//objIds=user.getUserDepartment()<=0?"":""+user.getUserDepartment();
	}
	if(!"".equals(objIds)){
		if(Util.getIntValue(objIds)>-1){
			rs.executeSql("select id from HrmResource where status in ( 0,1,2,3 ) and departmentid="+objIds+" ORDER BY dsporder");
		}else{
			rs.executeSql("select id from HrmResource where status in ( 0,1,2,3 ) and id in (select resourceid from HrmResourceVirtual where departmentid="+objIds+") ORDER BY dsporder");
		}
	}else{
		rs.executeSql("select id from HrmResource where 1=2");
	}
	
}else if("2".equals(objType)){//分部
	if("".equals(objIds)){
		//objIds=user.getUserSubCompany1()<=0?"":""+user.getUserSubCompany1();
	}
	if(!"".equals(objIds)){
		if(Util.getIntValue(objIds)>-1){
			rs.executeSql("select id from HrmResource where status in ( 0,1,2,3 ) and subcompanyid1="+objIds+" ORDER BY dsporder");
		}else{
			rs.executeSql("select id from HrmResource where status in ( 0,1,2,3 ) and id in(select resourceid from HrmResourceVirtual where subcompanyid="+objIds+") ORDER BY dsporder");
		}
	}else{
		rs.executeSql("select id from HrmResource where 1=2");
	}
}else if("3".equals(objType)){//人力资源
	if("".equals(objIds)){
		//objIds=user.getUID()<=0?"":""+user.getUID();
	}

	if(!"".equals(objIds)){
		String[] objs=objIds.split(",");
		for(int i=0;i<objs.length;i++){
			if("".equals(objs[i])) continue;
			resourceID+="".equals(resourceID)?objs[i]:","+objs[i];
		}
		rs.executeSql("select id,dsporder from HrmResource where id in("+resourceID+")  UNION select id,9999 as dsporder from HrmResourceManager where id in("+resourceID+") ORDER BY dsporder");
	}else{
		rs.executeSql("select id from HrmResource where 1=2");
	}
}
resourceID="";
String rname="";
while(rs.next()){
	resourceID+="".equals(resourceID)?rs.getString("id"):","+rs.getString("id");
}
String[] resourceIDs=resourceID.split(",");
//get the mapping from the select type
Map<String,List<WorkPlanViewBean>> resultMap= wpvList.getExcelMapping(resourceIDs,cBeginDate,cEndDate,user,wpSetInfo,workType);
//System.out.println(JSONArray.fromObject(resultMap).toString());
List<WorkPlanViewBean> list=null;
WorkPlanViewBean bean=null;
  
 
ExcelSheet es = new ExcelSheet() ;


ExcelFile.init() ;
ExcelFile.setFilename(Util.toScreen(SystemEnv.getHtmlLabelName(33959, user.getLanguage())+"("+cBeginDate+SystemEnv.getHtmlLabelName(83903, user.getLanguage())+cEndDate+")",user.getLanguage())) ;
ExcelFile.addSheet(SystemEnv.getHtmlLabelName(33959, user.getLanguage()), es) ;

ExcelStyle estyle=new ExcelStyle();
estyle.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor1);
ExcelFile.addStyle("head",estyle);
 

String agent = request.getHeader("USER-AGENT"); 

	//websphere环境下如果设置application/vnd.ms-excel;charset=UTF-8;的时候导出为空,所以修改成以下的形式
	response.setContentType("application/vnd.ms-excel;");
	response.setCharacterEncoding("utf-8");
if(agent.indexOf("Trident")>-1||agent.indexOf("MSIE")>-1){
	response.setHeader("Content-disposition", "attachment;filename="+ExcelFile.getFilename());
}else{
	response.setHeader("Content-disposition", "attachment;filename="+new String((SystemEnv.getHtmlLabelName(33959, user.getLanguage())+"("+cBeginDate+SystemEnv.getHtmlLabelName(83903, user.getLanguage())+cEndDate+")").getBytes("utf-8"), "ISO8859-1" )+".xls");
}

%>
<style>
<!--
td {
	font: 12px
}

.trTitle td {
	font: bold
}

.title {
	font-weight: bold;
	font-size: 20px;
	text-align: center;
	margin: 10px 0 10px 0
}

br {
	mso-data-placement: same-cell;
}
-->
</style>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<table class=liststyle cellspacing=0 border=1>
	<TBODY>
		<TR class="header">
			<th colSpan=9>
				<p align="center"><%=SystemEnv.getHtmlLabelName(33959,user.getLanguage()) %></p>
			</th>
		</TR>
		<TR class=trTitle>
			<TD align="center">
				<%=wpSetInfo.getDataRule()==1?SystemEnv.getHtmlLabelName(882, user.getLanguage()):SystemEnv.getHtmlLabelName(15525, user.getLanguage()) %>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(16094,user.getLanguage()) %>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(229,user.getLanguage()) %>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(345,user.getLanguage()) %>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage()) %>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(740,user.getLanguage()) %>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(742,user.getLanguage()) %>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(741,user.getLanguage()) %>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(743,user.getLanguage()) %>
			</TD>
		</TR>
		<%  
		for(int k=0;k<resourceIDs.length;k++){
	    	resourceID= resourceIDs[k];
	    	if(!resultMap.containsKey(resourceID)) continue;
	    	rname=ResourceComInfo.getLastname(resourceID);	
	    	list=resultMap.get(resourceID);
	    	if(list!=null){
	    		for(int i=0;i<list.size();i++){
	    			bean=list.get(i);
		 		%>
		 		<TR>
		 			<TD>
						<%=rname%>
					</TD>
					<TD>
						<%=bean.getWorkplanTypeName()%>
					</TD>
					<TD>
						<%=bean.getTitle()%>
					</TD>
					<TD>
						<%=bean.getDescription()%>
					</TD>
					<TD>
						<%=SptmForWorkPlan.getUrgentName(""+bean.getUrgentLevel(),""+user.getLanguage())%>
					</TD>
					<TD>
						<%=bean.getBeginDate()%>
					</TD>
					<TD>
						<%=bean.getBeginTime()%>
					</TD>
					<TD>
						<%=bean.getEndDate()%>
					</TD>
					<TD>
						<%=bean.getEndTime()%>
					</TD>
				</tr>
		 		<%
	    		}
	    	}
		 
		 }
       	%>
	</TBODY>
</table>