<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.tools.Time" %>
<%@ page import="weaver.conn.*,weaver.hrm.common.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.attendance.domain.HrmScheduleDiffMonthAtt"%>
<%@page import="weaver.common.DateUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement" %>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement" %>
<%@ page import="weaver.hrm.resource.SptmForLeave"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.hrm.attendance.domain.HrmLeaveTypeColor" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ScheduleDiffComInfo" class="weaver.hrm.schedule.HrmScheduleDiffComInfo" scope="page"/>
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page"/>
<jsp:useBean id="attVacationManager" class="weaver.hrm.attendance.manager.HrmAttVacationManager" scope="page"/>
<jsp:useBean id="paidLeaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page" />
<jsp:useBean id="HrmScheduleDiffOtherManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffOtherManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffMonthAttManager" class="weaver.hrm.attendance.manager.HrmScheduleDiffMonthAttManager" scope="page"/>
<%
Time time = new Time();
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6140,user.getLanguage());
String needfav ="1";
String needhelp ="";

String nosignLabel = SystemEnv.getHtmlLabelName(32104, user.getLanguage());
String belateLabel = SystemEnv.getHtmlLabelName(20081, user.getLanguage());
String leaveEarlyLabel = SystemEnv.getHtmlLabelName(20082, user.getLanguage());
String leaveEarlyLabel1 = SystemEnv.getHtmlLabelName(32104, user.getLanguage());
String absentLabel = SystemEnv.getHtmlLabelName(20085, user.getLanguage());
String evectionLabel = SystemEnv.getHtmlLabelName(20084, user.getLanguage());
String outLabel = SystemEnv.getHtmlLabelName(24058, user.getLanguage());
String overLabel = SystemEnv.getHtmlLabelName(6151, user.getLanguage());
String otherLabel = SystemEnv.getHtmlLabelNames("32104,563,26740", user.getLanguage());
String commonLabel = SystemEnv.getHtmlLabelNames("15880,17463", user.getLanguage());
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
//日期控件处理
String dateselect = Util.null2String(request.getParameter("dateselect"));

String resourceid=Util.null2String(request.getParameter("resourceid"));
String diffid =Util.null2String(request.getParameter("diffid"));
String subcompanyid = ResourceComInfo.getSubCompanyID(resourceid);

rs.executeSql("select countryid from HrmResource where id = "+resourceid);
rs.next();
String countryId = Util.null2String(rs.getString("countryid"));

titlename = ResourceComInfo.getLastname(resourceid)+SystemEnv.getHtmlLabelName(125404,user.getLanguage());

String attendancetype = Util.null2String(request.getParameter("attendancetype"));
String attendancetypename = Util.null2String(request.getParameter("attendancetypename"));
String leavetype = "";
String otherleavetype = "";
String leavesqlwhere = "";
if(!attendancetype.equals("")){
	leavetype = Util.TokenizerString2(attendancetype,"_")[1];
}

String departmentid = ResourceComInfo.getDepartmentID(resourceid);

int bywhat = Util.getIntValue(request.getParameter("bywhat"),2);
String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
String relatewfid = Util.null2String(request.getParameter("relatewfid"));

Calendar today = Calendar.getInstance();
Calendar temptoday1 = Calendar.getInstance();
Calendar temptoday2 = Calendar.getInstance();

if(!currentdate.equals("")) {
	int tempyear = Util.getIntValue(currentdate.substring(0,4)) ;
	int tempmonth = Util.getIntValue(currentdate.substring(5,7))-1 ;
	int tempdate = Util.getIntValue(currentdate.substring(8,10)) ;
	today.set(tempyear,tempmonth,tempdate);
}
	
int currentyear=today.get(Calendar.YEAR);
int currentmonth=today.get(Calendar.MONTH);  
int currentday=today.get(Calendar.DATE);  
currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth+1,2)+"-"+Util.add0(currentday,2) ;

String cBeginDate="";
String cEndDate="";
switch(bywhat) {
	case 1:
		today.set(currentyear,0,1) ;
		if(movedate.equals("1")) today.add(Calendar.YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.YEAR,-1) ;
		
		currentyear=today.get(Calendar.YEAR);
		currentmonth=today.get(Calendar.MONTH);  
		currentday=today.get(Calendar.DATE);  
		currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth+1,2)+"-"+Util.add0(currentday,2) ;
		
		cBeginDate = Tools.getFirstDayOfYear(today.getTime());
		cEndDate = Tools.getLastDayOfYear(today.getTime());
		break ;
	case 2:
		today.set(currentyear,currentmonth,1) ;
		if(movedate.equals("1")) today.add(Calendar.MONTH,1) ;
		if(movedate.equals("-1")) today.add(Calendar.MONTH,-1) ;
		
		currentyear=today.get(Calendar.YEAR);
		currentmonth=today.get(Calendar.MONTH);  
		currentday=today.get(Calendar.DATE);  
		currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth+1,2)+"-"+Util.add0(currentday,2) ;
		
		cBeginDate = TimeUtil.getMonthBeginDay(currentdate);
		cEndDate = TimeUtil.getMonthEndDay(currentdate);
		break ;
	case 3:
		Date thedate = today.getTime() ;
		int diffdate = (-1)*thedate.getDay() ;
		today.add(Calendar.DATE,diffdate) ;
		if(movedate.equals("1")) today.add(Calendar.WEEK_OF_YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.WEEK_OF_YEAR,-1) ;
		
		currentyear=today.get(Calendar.YEAR);
		currentmonth=today.get(Calendar.MONTH);  
		currentday=today.get(Calendar.DATE);  
		currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth+1,2)+"-"+Util.add0(currentday,2) ;
		
		cBeginDate = TimeUtil.getWeekBeginDay(currentdate);
		cEndDate = TimeUtil.getWeekEndDay(currentdate);
		break;
	case 4:
		if(movedate.equals("1")) today.add(Calendar.DATE,1) ;
		if(movedate.equals("-1")) today.add(Calendar.DATE,-1) ;
		
		currentyear=today.get(Calendar.YEAR);
		currentmonth=today.get(Calendar.MONTH);  
		currentday=today.get(Calendar.DATE);  
		currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth+1,2)+"-"+Util.add0(currentday,2) ;
		
		cBeginDate = currentdate;
		cEndDate = currentdate;
		break;
	case 5:
		today.set(currentyear,currentmonth,1) ;
		if(movedate.equals("1")) today.add(Calendar.MONTH,1) ;
		if(movedate.equals("-1")) today.add(Calendar.MONTH,-1) ;
		
		currentyear=today.get(Calendar.YEAR);
		currentmonth=today.get(Calendar.MONTH);  
		currentday=today.get(Calendar.DATE);  
		currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth+1,2)+"-"+Util.add0(currentday,2) ;
		
		cBeginDate = TimeUtil.getMonthBeginDay(currentdate);
		cEndDate = TimeUtil.getMonthEndDay(currentdate);
		break ;
	case 6:
		today.set(currentyear,0,1) ;
		if(movedate.equals("1")) today.add(Calendar.YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.YEAR,-1) ;
		
		currentyear=today.get(Calendar.YEAR);
		currentmonth=today.get(Calendar.MONTH);  
		currentday=today.get(Calendar.DATE);  
		currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth+1,2)+"-"+Util.add0(currentday,2) ;
		
		cBeginDate = Tools.getFirstDayOfYear(today.getTime());
		cEndDate = Tools.getLastDayOfYear(today.getTime());
		break ;
}

	
currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;  
currentday=today.get(Calendar.DATE);  
int tempCurrentMonth = currentmonth;
currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
temptoday1.set(currentyear,currentmonth-1,currentday) ;
temptoday2.set(currentyear,currentmonth-1,currentday) ;

String datefrom = "" ;
String dateto = "" ;
String datenow = "" ;

switch (bywhat) {
	case 1 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4) ;
		temptoday1.add(Calendar.YEAR,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4) ;

		temptoday2.add(Calendar.YEAR,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4) ;
        leavesqlwhere += " and ( (startdate >= '" + datenow + "-01-01' and startdate <= '" + datenow + "-12-31') or (enddate >= '" + datenow + "-01-01' and enddate <= '" + datenow + "-12-31') or (startdate < '" + datenow + "-01-01' and enddate > '" + datenow + "-12-31') )";
		break ;
	case 2 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;
		temptoday1.add(Calendar.MONTH,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;

		temptoday2.add(Calendar.MONTH,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2) ;
        leavesqlwhere += " and ( (startdate >= '" + datenow + "-01' and startdate <= '" + datenow + "-31') or (enddate >= '" + datenow + "-01' and enddate <= '" + datenow + "-31') or (startdate < '" + datenow + "-01' and enddate > '" + datenow + "-31') )";
		break ;
 	case 3 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.WEEK_OF_YEAR,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;

		temptoday2.add(Calendar.WEEK_OF_YEAR,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday2.get(Calendar.DATE),2) ;
        leavesqlwhere += " and ( (startdate >= '" + datenow + "' and startdate < '" + dateto + "') or (enddate >= '" + datenow + "' and enddate < '" + dateto + "') or (startdate < '" + datenow + "' and enddate >= '" + dateto + "') )";
		break ;
	case 4 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.DATE,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		
		Calendar datetos = Calendar.getInstance();
		temptoday2.add(Calendar.DATE,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday2.get(Calendar.DATE),2) ;
        leavesqlwhere += " and startdate <= '" + datenow + "' and enddate >= '" + datenow + "'";
	case 5 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;
		temptoday1.add(Calendar.MONTH,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;

		temptoday2.add(Calendar.MONTH,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2) ;
        leavesqlwhere += " and ( (startdate >= '" + datenow + "-01' and startdate <= '" + datenow + "-31') or (enddate >= '" + datenow + "-01' and enddate <= '" + datenow + "-31') or (startdate < '" + datenow + "-01' and enddate > '" + datenow + "-31') )";
		break ;
	case 6 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4) ;
		temptoday1.add(Calendar.YEAR,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4) ;

		temptoday2.add(Calendar.YEAR,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4) ;
        leavesqlwhere += " and ( (startdate >= '" + datenow + "-01-01' and startdate <= '" + datenow + "-12-31') or (enddate >= '" + datenow + "-01-01' and enddate <= '" + datenow + "-12-31') or (startdate < '" + datenow + "-01-01' and enddate > '" + datenow + "-12-31') )";
		break ;
}

ArrayList ids = new ArrayList() ;
ArrayList resourceids = new ArrayList() ;
ArrayList diffids = new ArrayList() ;
ArrayList startdates = new ArrayList() ;
ArrayList starttimes = new ArrayList() ;
ArrayList enddates = new ArrayList() ;
ArrayList endtimes = new ArrayList() ;
ArrayList subjects = new ArrayList() ;

ArrayList memos = new ArrayList() ;

List personelList = new ArrayList() ;
HrmScheduleDiffMonthAtt personelBean = null;
if(countryId.length()>0){
	List scheduleList = HrmScheduleDiffOtherManager.getScheduleList(user,cBeginDate,cEndDate,strUtil.parseToInt(subcompanyid, 0),strUtil.parseToInt(departmentid, 0),resourceid,0, true, true, leavetype);
	Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
		ids.add(strUtil.vString(scheduleMap.get("id"))) ;
		resourceids.add(strUtil.vString(scheduleMap.get("resourceId"))) ;
		diffids.add(strUtil.vString(scheduleMap.get("leaveColor"))) ;
		startdates.add(strUtil.vString(scheduleMap.get("fromDate"))) ;
		starttimes.add(strUtil.vString(scheduleMap.get("fromTime"))) ;
		enddates.add(strUtil.vString(scheduleMap.get("toDate"))) ;
		endtimes.add(strUtil.vString(scheduleMap.get("toTime"))) ;
		memos.add(strUtil.vString(scheduleMap.get("memo"))) ;
		subjects.add(strUtil.vString(scheduleMap.get("leaveType"))) ;
	}
	User tmpUser = User.getUser(strUtil.parseToInt(resourceid),0);
	HrmScheduleDiffMonthAttManager.setUser(tmpUser);
	HrmScheduleDiffMonthAttManager.setResourceAbsense(true);
	personelList = HrmScheduleDiffMonthAttManager.getMonthReport("fromDate:"+cBeginDate+";toDate:"+cEndDate+";subCompanyId:"+subcompanyid+";departmentId:"+departmentid+";resourceId:"+resourceid);
}  
List colors = colorManager.find("[map]subcompanyid:0;field002:1;");
HrmLeaveTypeColor bean = null;
String sql = "";
if(countryId.length()>0){
if(RecordSet.getDBType().equals("oracle")){
	sql = "select id,holidaydate,holidayname,changetype from HrmPubHoliday where substr(holidaydate,1,4)="+datenow.substring(0,4)+" and countryid="+countryId+" order by holidaydate ";
}else{
	sql = "select id,holidaydate,holidayname,changetype from HrmPubHoliday where substring(holidaydate,1,4)="+datenow.substring(0,4)+" and countryid="+countryId+" order by holidaydate ";
}
RecordSet.executeSql(sql);

while(RecordSet.next()) {
ids.add(Util.null2String(RecordSet.getString("id")));
resourceids.add(Util.null2String(resourceid));
int tempchangetype = Util.getIntValue(RecordSet.getString("changetype"),1);

if(tempchangetype==1) {
	diffids.add(Util.null2String("rgba(207, 243, 207, 1)"));
}else if(tempchangetype==3){
	diffids.add(Util.null2String("rgba(182, 225, 253, 1)"));
}else {
	diffids.add(Util.null2String("white"));
}
	
Map onDutyAndOffDutyTimeMap = HrmScheduleDiffUtil.getOnDutyAndOffDutyTimeMap(RecordSet.getString("holidaydate"),1);
startdates.add(Util.null2String(RecordSet.getString("holidaydate")));
starttimes.add(Util.null2String((String)onDutyAndOffDutyTimeMap.get("onDutyTimeAM")));
enddates.add(Util.null2String(RecordSet.getString("holidaydate")));
endtimes.add(Util.null2String((String)onDutyAndOffDutyTimeMap.get("offDutyTimePM")));
memos.add(Util.null2String(RecordSet.getString("memo")));
subjects.add(RecordSet.getString("holidayname")) ;
}
}
%>
<HTML><HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/workplan/calendar/css/dp_wev8.css" rel="stylesheet" type="text/css" />   
    <link href="/workplan/calendar/css/main_wev8.css" rel="stylesheet" type="text/css" /> 
	<script language="javascript" src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
	<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
    <script src="/meeting/calendar/src/Plugins/jquery.datepickernew_wev8.js" type="text/javascript"></script>
    <%
    if(user.getLanguage()==8){
%>
    <script src="/meeting/calendar/src/Plugins/datepicker_lang_US_wev8.js" type="text/javascript"></script> 
<%
	}else if(user.getLanguage()==9){
%>
    <script src="/meeting/calendar/src/Plugins/datepicker_lang_HK_wev8.js" type="text/javascript"></script> 
<%
    }else{
%>
    <script src="/meeting/calendar/src/Plugins/datepicker_lang_ZH_wev8.js" type="text/javascript"></script> 
<%
    }
%>	

<%
    if(user.getLanguage()==8){
%>
    <script src="/meeting/calendar/src/Plugins/wdCalendar_lang_US_wev8.js" type="text/javascript"></script>  
<%
	}else if(user.getLanguage()==9){
%>
    <script src="/meeting/calendar/src/Plugins/wdCalendar_lang_HK_wev8.js" type="text/javascript"></script>  
<%
    }else{
%>
    <script src="/meeting/calendar/src/Plugins/wdCalendar_lang_ZH_wev8.js" type="text/javascript"></script>  
<%
    }
%>
<script type="text/javascript">
var showdivDetail = false; 
jQuery(document).ready(function(){
	showdivDetail = false;
 	parent.parent.setTabObjName('<%=titlename%>');
	todo("<%=resourceid%>","");
	jQuery("#submitloaddingdiv_out", parent.document).hide();
	jQuery("#submitloaddingdiv", parent.document).hide();
});

function resizeParent(){
	if(showdivDetail){
		jQuery("#contentdiv", parent.document).height(jQuery("#absenseTable").height());
      	clearInterval(int);
	}
}

var dialog = null;
var dWidth = 800;
var dHeight = 500;
function todo(resourceId,curDate){
	jQuery.ajax({
		type: "post",
		url: "/hrm/resource/HrmScheduleAbsenseDateDetail.jsp",
	    data:{"curDate":curDate,"resourceId":resourceId}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){
           try{
         		//document.all("divDetail").innerHTML=data.responseText;
				int = setInterval(resizeParent,100);
         		document.all("divDetail").innerHTML=data.responseText;
         		toggleHrm();
         		toggleFlow();
         		showdivDetail = true;
           }catch(e){
           }
    	}
   });
}
function toggleHrm(){
	jQuery("tr[_samepair='hrmStatus'] .hideBlockDiv").unbind("click").bind("click", function () {
		var _status = jQuery(this).attr("_status");
		var currentTREle = jQuery(this).closest("table").closest("TR");
		if (!!!_status || _status == "0") {
			jQuery(this).attr("_status", "1");
			jQuery(this).html("<image src='/wui/theme/ecology8/templates/default/images/1_wev8.png'>");
			currentTREle.next("TR.Spacing").next("TR.items").hide();
		} else {
			jQuery(this).attr("_status", "0");
			jQuery(this).html("<image src='/wui/theme/ecology8/templates/default/images/2_wev8.png'>");
			currentTREle.next("TR.Spacing").next("TR.items").show();
		}
	}).hover(function(){
		$(this).css("color","#000000");
	},function(){
		$(this).css("color","#cccccc");
	});	
}

function toggleFlow(obj){
	jQuery("tr[_samepair='flowStatus'] .hideBlockDiv").unbind("click").bind("click", function () {
		var _status = jQuery(this).attr("_status");
		var currentTREle = jQuery(this).closest("table").closest("TR");
		if (!!!_status || _status == "0") {
			jQuery(this).attr("_status", "1");
			jQuery(this).html("<image src='/wui/theme/ecology8/templates/default/images/1_wev8.png'>");
			currentTREle.next("TR.Spacing").next("TR.items").hide();
		} else {
			jQuery(this).attr("_status", "0");
			jQuery(this).html("<image src='/wui/theme/ecology8/templates/default/images/2_wev8.png'>");
			currentTREle.next("TR.Spacing").next("TR.items").show();
		}
	}).hover(function(){
		$(this).css("color","#000000");
	},function(){
		$(this).css("color","#cccccc");
	});	
}

function jsSubmit(e,datas,name){
	if(datas.id && datas.name){
		onBtnSearchClick();
	}
}
function changeType(type){
	if(!type){
		type = "";
	}
	$GetEle("attendancetype").value = type;
	onBtnSearchClick();
}
function onBtnSearchClick(){
	var _resource = $GetEle("resourceid").value;
	if(_resource && _resource != ""){
		jQuery("#frmmain").submit();
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("18214,1867",user.getLanguage())%>");
	}
}
function getSubdate() {
	document.frmmain.movedate.value = "-1" ;
	submit();
}
function getSupdate() {
	document.frmmain.movedate.value = "1" ;
	submit();
}
function getYear(year){
	document.frmmain.movedate.value = year ;
	submit();
}
function ShowYear() {
	document.frmmain.bywhat.value = "1" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.movedate.value = "" ;
	submit();
}
function ShowMONTH() {
	document.frmmain.bywhat.value = "2" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.movedate.value = "" ;
	submit();
}
function ShowWeek() {
	document.frmmain.bywhat.value = "3" ;
	document.frmmain.currentdate.value = "" ;
	submit();
}
function ShowDay() {
	document.frmmain.bywhat.value = "4" ;
	document.frmmain.currentdate.value = "" ;
	submit();
}
function ShowCurMonth() {
	document.frmmain.bywhat.value = "5" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.movedate.value = "" ;
	submit();
}
function ShowCurYear() {
	document.frmmain.bywhat.value = "6" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.movedate.value = "" ;
	submit();
}
jQuery(document).ready(function(){
	var cBeginDate="<%=cBeginDate%>";
	var cEndDate="<%=cEndDate%>";
	var showtime = "";
	var titletime=""; 
	<% if(bywhat==1) {%>
		titletime = CalDateShowYear(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));
		showtime = "<%=datenow+SystemEnv.getHtmlLabelName(445, user.getLanguage())%>";
	<% }else if(bywhat==2) {%>
		titletime = CalDateShowMonth(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));
		showtime = titletime;
	<% }else if(bywhat==3){%>
	    titletime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), new Date(Date.parse(cEndDate.replace(/-/g,   "/"))), null, true);
	    showtime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), new Date(Date.parse(cEndDate.replace(/-/g,   "/"))));
		$(".weekclass").each(function(){
			var dateStr = new Date(Date.parse($(this).attr("val").replace(/-/g,   "/")));
			$(this).html(dateFormat.call(dateStr, getymformat(dateStr, null, null, true,null, false)));
		});
	<% }else if(bywhat==4){%>
		titletime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), null, null, true)+"&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>";
		showtime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));
	<%}else if(bywhat==5) {%>
		titletime = CalDateShowMonth(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));
		showtime = titletime;
	<% }else if(bywhat==6) {%>
		titletime = CalDateShowYear(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));
		showtime = "<%=datenow+SystemEnv.getHtmlLabelName(445, user.getLanguage())%>";
	<%}
	%>
	
	//to show day view
  $("#showdaybtn").click(function(e) {
		changeShowType(this);
		$("#txtdatetimeshow").attr("selectMode", '0');
		ShowDay();
   });
   //to show week view
   $("#showweekbtn").click(function(e) {
		changeShowType(this);
		$("#txtdatetimeshow").attr("selectMode", '0');
		ShowWeek();
   });
   //to show month view
   $("#showmonthbtn").click(function(e) {
		changeShowType(this);
		$("#txtdatetimeshow").attr("selectMode", '1');
		ShowMONTH();

   });
   $("#showyearbtn").click(function(e) {
		changeShowType(this);
		$("#txtdatetimeshow").attr("selectMode", '1');
		ShowYear();

   });
   //refresh current View
   $("#showreflashbtn").click(function(e){
   		document.frmmain.movedate.value = "" ;
		submit();
   });
   
   $("#showcurmonthbtn").click(function(e) {
		changeShowType(this);
		ShowCurMonth();
   });
   
   $("#showcuryearbtn").click(function(e) {
		changeShowType(this);
		ShowCurYear();
   });
   
   //go to today
   $("#showtodaybtn").click(function(e) {
   		document.frmmain.currentdate.value = "" ;
     	submit();
   });
   //previous date range
   $("#sfprevbtn").click(function(e) {
      getSubdate();

   });
   //next date range
   $("#sfnextbtn").click(function(e) {
      getSupdate();
   });
   
   $("#namebtn").live("click", function() {
      submit();
   });   
   //显示时间控件 
   $("#hdtxtshow").datepickernew({ 
   	   picker: "#txtdatetimeshow", 
   	   showtarget: $("#txtdatetimeshow"),
	   onReturn:function(r){
	   		var d = CalDateShow(r);
	   		if(d && r){
	   			jQuery("#frmmain")[0].currentdate.value = dateFormat.call(r, i18n.xgcalendar.dateformat.fulldayvalue);
				submit();
				$("#hdtxtshow").val(dateFormat.call(r, i18n.datepicker.dateformat.fulldayvalue));
	    		//$("#txtdatetimeshow").text(d);
	    	}
	     } 
		<% if(bywhat==1||bywhat==2) {%>
        ,selectMode:"1"
		<%}%>
   });
   
	var bodyheight = document.body.offsetHeight;
	$("#subCompanytDiv").height(bodyheight - 44);
	$("#subCompanytifm").height(bodyheight - 44);
   $(".thcls").css("border-bottom","1px solid #59b0f2");
   $(".schtd").css("border-bottom","1px solid #59b0f2");
   $(".schtd").css("border-left","0px");
   $(".roomnames").css("border-left","0px");
   $("#txtdatetimeshow").text(showtime);
})
var enable = true;
function changeShowType(obj){
	if($("#showdaybtn").hasClass("txtbtncls")){
		$("#showdaybtn").removeClass("txtbtncls");
	}
	if(!$("#showdaybtn").hasClass("txtbtnnoselcls")){
		$("#showdaybtn").addClass("txtbtnnoselcls");
	}
	
	if($("#showweekbtn").hasClass("txtbtncls")){
		$("#showweekbtn").removeClass("txtbtncls");
	}
	if(!$("#showweekbtn").hasClass("txtbtnnoselcls")){
		$("#showweekbtn").addClass("txtbtnnoselcls");
	}
	
	if($("#showmonthbtn").hasClass("txtbtncls")){
		$("#showmonthbtn").removeClass("txtbtncls");
	}
	if(!$("#showmonthbtn").hasClass("txtbtnnoselcls")){
		$("#showmonthbtn").addClass("txtbtnnoselcls");
	}
	
	if($("#showyearbtn").hasClass("txtbtncls")){
		$("#showyearbtn").removeClass("txtbtncls");
	}
	if(!$("#showyearbtn").hasClass("txtbtnnoselcls")){
		$("#showyearbtn").addClass("txtbtnnoselcls");
	}
	
	if($("#showcurmonthbtn").hasClass("txtbtncls")){
		$("#showcurmonthbtn").removeClass("txtbtncls");
	}
	if(!$("#showcurmonthbtn").hasClass("txtbtnnoselcls")){
		$("#showcurmonthbtn").addClass("txtbtnnoselcls");
	}
	
	if($("#showcuryearbtn").hasClass("txtbtncls")){
		$("#showcuryearbtn").removeClass("txtbtncls");
	}
	if(!$("#showcuryearbtn").hasClass("txtbtnnoselcls")){
		$("#showcuryearbtn").addClass("txtbtnnoselcls");
	}
	
	if(!$(obj).hasClass("txtbtncls")){
		$(obj).addClass("txtbtncls");
	}
	if($(obj).hasClass("txtbtnnoselcls")){
		$(obj).removeClass("txtbtnnoselcls");
	}
}

function CalDateShow(startday, endday, isshowtime, isshowweek) {
  if (!endday) {
      return dateFormat.call(startday, getymformat(startday,null,isshowtime,isshowweek));
  } else {
      var strstart= dateFormat.call(startday, getymformat(startday, null, isshowtime, isshowweek));
			var strend=dateFormat.call(endday, getymformat(endday, startday, isshowtime, isshowweek));
			var join = (strend!=""? " - ":"");
			return [strstart,strend].join(join);
  }
}

function CalDateShowMonth(startday) {
    return dateFormat.call(startday, getymformatMonth(startday));
}

function getymformatMonth(date) {
	var a = [];
	a.push(i18n.xgcalendar.dateformat.yM);
	return a.join("");
}

function CalDateShowYear(startday) {
    return dateFormat.call(startday, getymformatYear(startday));
}

function getymformatYear(date) {
	var a = [];
	a.push(i18n.xgcalendar.dateformat.fulldayshow);
	return a.join("");
}

function getymformat(date, comparedate, isshowtime, isshowweek, showcompare, ishowyear) {
            var showyear = isshowtime != undefined ? (date.getFullYear() != new Date().getFullYear()) : true;
            if(ishowyear != undefined && ishowyear == false){
            	showyear = false;
            }
            var showmonth = true;
            var showday = true;
            var showtime = isshowtime || false;
            var showweek = isshowweek || false;
            if (comparedate) {
                showyear = comparedate.getFullYear() != date.getFullYear();
                //showmonth = comparedate.getFullYear() != date.getFullYear() || date.getMonth() != comparedate.getMonth();
                if (comparedate.getFullYear() == date.getFullYear() &&
					date.getMonth() == comparedate.getMonth() &&
					date.getDate() == comparedate.getDate()
					) {
                    showyear = showmonth = showday = showweek = false;
                }
            }

            var a = [];
            if (showyear) {
                a.push(i18n.xgcalendar.dateformat.fulldayshow)
            } else if (showmonth) {
                a.push(i18n.xgcalendar.dateformat.Md3)
            } else if (showday) {
                a.push(i18n.xgcalendar.dateformat.day);
            }
            a.push(showweek ? " (W)" : "", showtime ? " HH:mm" : "");
            return a.join("");
        }


dateFormat = function(format) {
			var __WDAY = new Array(i18n.xgcalendar.dateformat.sun, i18n.xgcalendar.dateformat.mon, i18n.xgcalendar.dateformat.tue, i18n.xgcalendar.dateformat.wed, i18n.xgcalendar.dateformat.thu, i18n.xgcalendar.dateformat.fri, i18n.xgcalendar.dateformat.sat);                                                                                                                                                                      
			var __MonthName = new Array(i18n.xgcalendar.dateformat.jan, i18n.xgcalendar.dateformat.feb, i18n.xgcalendar.dateformat.mar, i18n.xgcalendar.dateformat.apr, i18n.xgcalendar.dateformat.may, i18n.xgcalendar.dateformat.jun, i18n.xgcalendar.dateformat.jul, i18n.xgcalendar.dateformat.aug, i18n.xgcalendar.dateformat.sep, i18n.xgcalendar.dateformat.oct, i18n.xgcalendar.dateformat.nov, i18n.xgcalendar.dateformat.dec); 
			
            var o = {
                "M+": this.getMonth() + 1,
                "d+": this.getDate(),
                "h+": this.getHours(),
                "H+": this.getHours(),
                "m+": this.getMinutes(),
                "s+": this.getSeconds(),
                "q+": Math.floor((this.getMonth() + 3) / 3),
                "w": "0123456".indexOf(this.getDay()),
                "W": __WDAY[this.getDay()],
                "L": __MonthName[this.getMonth()] //non-standard
            };
            if (/(y+)/.test(format)) {
                format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
            }
            for (var k in o) {
                if (new RegExp("(" + k + ")").test(format))
                    format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
            }
            return format;
};
function getSubdate() {
	document.frmmain.movedate.value = "-1" ;
	submit() ;
}
function getSupdate() {
	document.frmmain.movedate.value = "1" ;
	submit();
}

function submit(){
	parent.__displayloaddingblock();
	onBtnSearchClick();
}


function setUser(uid){
	$GetEle("resourceid").value = uid;
	document.frmmain.bywhat.value = "2" ;
	submit();
//	window.location.href = "HrmResourceAbsense.jsp?resourceid="+uid;
}

function showPersonTree(id){
$("#persontree").attr("src","SubordinateTree.jsp?id="+id);
}

</script>
<style type=text/css>
.hideBlockDiv:hover{
   	cursor:pointer;
}
.groupbg{
	background-image:url(/wui/theme/ecology8/templates/default/images/groupHead_wev8.png);
	background-repeat:no-repeat;
	background-position:0 50%;
	display:inline-block;
	width:16px;
	height:17px;
	float:left;
}
.tableinfo{
	border : 1px solid rgba(228, 228, 228, 1);
    border-collapse:collapse;
}
.tableinfo td{
	height: 30px;
}

.tableinfo td span{
	margin-left:10px;
}
table.altrowstable {
	font-family: verdana,arial,sans-serif;
	font-size:11px;
	color:#333333;
	border-width: 1px;
	border-color: #E6E6E6;
	border-collapse: collapse;
}
table.altrowstable th {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #E6E6E6;
}
table.altrowstable td {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #E6E6E6;
	border-style: solid;
}

.selected {
	background-color: #F0FBEA!important;
}
.mout{
   border-top:0px #f7f7f7 solid;
   width:0px;
   height:0px;
   border-left:80px #f7f7f7 solid;
   position:relative;
}
mf{font-style:normal;display:block;position:absolute;border:1;top:-10px;left:-10px;width:35px;}
mem{font-style:normal;display:block;position:absolute;border:1;top:0px;left:-80px;width:55x;}
</style>
</head>
<BODY style="width:100%;height:100%">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(445,user.getLanguage())+",javascript:ShowYear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+",javascript:ShowMONTH(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="absenseTable" style="width: 100%;table-layout: fixed;" width="100%">
	<tr style="height: 100%;" height="100%" id="contentTr">
	<td valign="top" width="100%" height="100%" >
<FORM id=frmmain name=frmmain method=post action="HrmResourceAbsense1.jsp">
<input  class=inputstyle type=hidden name=currentdate id=currentdate value="<%=currentdate%>">
<input class=inputstyle type=hidden name=bywhat id=bywhat value="<%=bywhat%>">
<input class=inputstyle type=hidden name=movedate id=movedate value="<%=movedate%>">
<input class=inputstyle type=hidden name=relatewfid id=relatewfid value="<%=relatewfid%>">
<input class=inputstyle type=hidden name=resourceid id=resourceid value="<%=resourceid%>">
<div id="calhead" class="calHd" style="height:36px;padding-left:0px;min-width:900px !important;">
			<div id="editButtons2" style="float:left;min-width:60px !important;">
		      		  <%if(user.getLanguage()==9) {%>
	      		<div id="showyearbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 445 ,user.getLanguage())%>" class="calHdBtn   <% if(bywhat==1) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 13px;margin-left: 10px;">
	      			Y
	      		</div>
	      		<div id="showmonthbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%>" class="calHdBtn   <% if(bywhat==2) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 13px;margin-left: 10px;">
	      			M
	      		</div>
      		    <%} else { %>
	      		<div id="showyearbtn" unselectable="on" class="calHdBtn <% if(bywhat==1 || bywhat==6)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 13px;margin-left: 10px;">
	      			<%=SystemEnv.getHtmlLabelName( 445 ,user.getLanguage())%> 
	      		</div>
	      		<div id="showmonthbtn" unselectable="on" class="calHdBtn <% if(bywhat==2 || bywhat==5)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 13px;margin-left: 10px;">
	      			<%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%> 
	      		</div>
	      		<%} %>
				<div class="rightBorder" style="margin-left:10px;margin-right:15px">|</div>
               </div>
			   
			<div id="editButtons1" style="float:left;min-width:122px !important;">
					<% String titlestrnow=""; 
					if(bywhat==1) {
						titlestrnow =SystemEnv.getHtmlLabelName( 15384 ,user.getLanguage());
					}if(bywhat==2) {
		      			titlestrnow =SystemEnv.getHtmlLabelName( 15541 ,user.getLanguage());
					}else if(bywhat==3){
						titlestrnow=SystemEnv.getHtmlLabelName( 15539 ,user.getLanguage());
					}else if(bywhat==4){
						titlestrnow=SystemEnv.getHtmlLabelName( 15537 ,user.getLanguage()); 
					}else if(bywhat==5){
						titlestrnow=SystemEnv.getHtmlLabelName( 15541 ,user.getLanguage()); 
					}else if(bywhat==6){
						titlestrnow =SystemEnv.getHtmlLabelName( 15384 ,user.getLanguage());
					}
					String CurMonth = DateUtil.getCurrentDate();
					boolean isCurMonth = false;
					boolean isCurYear = false;
					if(currentdate.length() > 7 && CurMonth.length() > 7){
						if(bywhat == 5 || bywhat == 2){
							if(currentdate.substring(0,7).equals(CurMonth.substring(0,7))){
								isCurMonth = true;
							}
						}
						if(bywhat == 1|| bywhat == 6){
							if(currentdate.substring(0,4).equals(CurMonth.substring(0,4))){
								isCurYear = true;
							}
						}
					}
					String curMonthClass = (bywhat==5 && isCurMonth) ? "txtbtncls":(bywhat==2 && isCurMonth?"txtbtncls":"txtbtnnoselcls");
					String curYearClass = (bywhat==6 && isCurYear) ? "txtbtncls":(bywhat==1 && isCurYear?"txtbtncls":"txtbtnnoselcls");
					%>
					<%
						if(bywhat == 1|| bywhat == 6){
							%>
		      		<div id="showcuryearbtn" unselectable="on" class="calHdBtn <%=curYearClass %> " style="border-left:none;width:30px;font-size: 13px;margin-left: 10px;">
		      			<%=SystemEnv.getHtmlLabelName( 15384 ,user.getLanguage())%> 
		      		</div>
									
					<%		
						}else if(bywhat == 2 || bywhat == 5){
					%>
					
		      		<div id="showcurmonthbtn" unselectable="on" class="calHdBtn <%=curMonthClass %> " style="border-left:none;width:30px;font-size: 13px;margin-left: 10px;">
		      			<%=SystemEnv.getHtmlLabelName( 15541 ,user.getLanguage())%> 
		      		</div>
					<%
						}
					%>
					
		      		<div id="sfprevbtn" unselectable="on" class="calHdBtn sfprevbtn" title="<%=SystemEnv.getHtmlLabelName(33960,user.getLanguage())%>"  style="height:24px;border:none;margin-left:10px;width:23px;_width:25px;">
		      		</div>
					<input type="hidden" name="txtshow" id="hdtxtshow" />
					<div id="txtdatetimeshow" unselectable="on" class="calHdBtn txtbtncls" style="border:none;width:auto;padding-left:1px;padding-right:10px;">
						
					</div>
		      		<div id="sfnextbtn" unselectable="on" class="calHdBtn sfnextbtn" title="<%=SystemEnv.getHtmlLabelName(33961,user.getLanguage())%>"  style="height:24px;border:none;border-left:none;width:23px;_width:25px;">
		      		</div>
		      		
					<div id="showreflashbtn" unselectable="on" class="calHdBtn showreflashbtn" title="<%=SystemEnv.getHtmlLabelName( 354 ,user.getLanguage())%>" style="height:24px;border:none;margin-left:10px;border:none;margin-left: 10px;">
					</div>
				</div>
			<INPUT class=inputstyle type=hidden name=attendancetype value="<%=attendancetype%>">
			<div style="float:right;padding-right:5px;">
				</div>
      		
				</div>
 <% if(bywhat==1 || bywhat == 2 || bywhat == 5 || bywhat == 6) {
				%>
      		
	<table class="altrowstable" style="width: 99.5%;margin-left: 0.2%;margin-top: -1px;table-layout: fixed;">
	<tr id="trHead" style="height: 2px;background-color: #f7f7f7;border-bottom:2px solid #B7E0FE;">
		<td style="width: 7%;">
			<span style="text-align:center;"><%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;\&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName( 390 ,user.getLanguage())%></span>
		</td>
	  <%
	  int i=0;
	  int j=0;
	  for(i=1;i<32;i++){
	  	%>
	  	<td style="width: 3%;"><%=i%></td>
	  	<%
	  }
	  %>
	</tr>
	<tr style="height: 2px" onmouseover="jQuery(jQuery(this).find('td')[0]).addClass('selected')" onmouseout="jQuery(jQuery(this).find('td')[0]).removeClass('selected')">
	<%

	String bgcolor="white";
	Calendar tempday = Calendar.getInstance();
	String tempcreatedate="";
	String thenowday="";
	String innertext = "" ;
	String innertextImg = "" ;
	ArrayList tempids = new ArrayList() ;
	ArrayList tempdiffids = new ArrayList() ;
	ArrayList tempstartdates = new ArrayList() ;
	ArrayList tempenddates = new ArrayList() ;
	ArrayList tempstarttimes = new ArrayList() ;
	ArrayList tempendtimes = new ArrayList() ;
	ArrayList tempsubjects = new ArrayList() ;
	
	
	int canlink = 0 ;
	for(j=1;j<13;j++){
		if(bywhat == 2 || bywhat == 5){
			if(j!=tempCurrentMonth){
				continue;
			}
		}
	  for(i=0;i<32;i++){
	    canlink=0 ;
	    bgcolor="white";
	    tempids.clear() ;
	    tempdiffids.clear() ;
     	    
 	    tempstartdates.clear() ;
	    tempenddates.clear() ;
	    tempstarttimes.clear() ;
	    tempendtimes.clear() ;
	    tempsubjects.clear() ;
	    
		
	    if(i==0){
			bgcolor="#f7f7f7";
			canlink=0;
			innertext = ""+j;
		}else  {
			if(personelList.size() > 0){
				personelBean = (HrmScheduleDiffMonthAtt)personelList.get(0);
			}
			innertext="&nbsp;";
			tempday.clear();
			tempday.set(Util.getIntValue(currentdate.substring(0,4)),j-1,i);
			if((tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)&&i>0) {
				bgcolor="rgba(243, 243, 243, 1)";
			}
			if((tempday.getTime().getMonth()!=(j-1))&&i>0) { bgcolor="rgba(134, 134, 134, 1)";canlink=1;}
			if(!bgcolor.equals("rgba(134, 134, 134, 1)")){
				thenowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
				for(int k=0 ; k<ids.size() ; k++) {
					String tempdatefrom = (String)startdates.get(k) ;
					String tempdateto = (String)enddates.get(k) ;
					if(thenowday.compareToIgnoreCase(tempdatefrom) < 0 || thenowday.compareToIgnoreCase(tempdateto)>0 ) continue ;
					if(Util.null2String(ids.get(k)).equals("")) continue;
					tempids.add((String)ids.get(k)) ;
					tempdiffids.add((String)diffids.get(k)) ;
					tempstartdates.add((String)startdates.get(k)) ;
					tempenddates.add((String)enddates.get(k)) ;
					tempstarttimes.add((String)starttimes.get(k)) ;
					tempendtimes.add((String)endtimes.get(k)) ;
					tempsubjects.add((String)subjects.get(k)) ;
				}
			}
			if(personelBean == null){
				innertext="";
			}else{
				innertext=personelBean.getValue(thenowday);
			}
			if(innertext.length() > 0 && !innertext.equals("√")) {
				if(innertext.equals(nosignLabel)){
					innertextImg = "<img src=\"/images/hrm/absense/nosign.png\"  align=\"absmiddle\"  />";
					innertext = "<a href=\"javascript:void(0);\" onclick=\"todo("+resourceid+",'"+thenowday+"');\">"+innertextImg+"</a>";
				}else if(innertext.equals(belateLabel)){
					innertextImg = "<img src=\"/images/hrm/absense/belate.png\"  align=\"absmiddle\"  />";
					innertext = "<a href=\"javascript:void(0);\" onclick=\"todo("+resourceid+",'"+thenowday+"');\">"+innertextImg+"</a>";
				}else if(innertext.equals(leaveEarlyLabel)){
					innertextImg = "<img src=\"/images/hrm/absense/leaveEarly.png\"  align=\"absmiddle\"  />";
					innertext = "<a href=\"javascript:void(0);\" onclick=\"todo("+resourceid+",'"+thenowday+"');\">"+innertextImg+"</a>";
				}else if(innertext.equals(absentLabel)){
					innertextImg = "<img src=\"/images/hrm/absense/absent.png\"  align=\"absmiddle\"  />";
					innertext = "<a href=\"javascript:void(0);\" onclick=\"todo("+resourceid+",'"+thenowday+"');\">"+innertextImg+"</a>";
				}else if(innertext.equals(evectionLabel)){
					innertextImg = "<img src=\"/images/hrm/absense/evection.png\"  align=\"absmiddle\"  />";
					innertext = "<a href=\"javascript:void(0);\" onclick=\"todo("+resourceid+",'"+thenowday+"');\">"+innertextImg+"</a>";
				}else if(innertext.equals(outLabel)){
					innertextImg = "<img src=\"/images/hrm/absense/out.png\"  align=\"absmiddle\"  />";
					innertext = "<a href=\"javascript:void(0);\" onclick=\"todo("+resourceid+",'"+thenowday+"');\">"+innertextImg+"</a>";
				}else if(innertext.equals(overLabel)){
					innertextImg = "<img src=\"/images/hrm/absense/over.png\"  align=\"absmiddle\"  />";
					innertext = "<a href=\"javascript:void(0);\" onclick=\"todo("+resourceid+",'"+thenowday+"');\">"+innertextImg+"</a>";
				}else if(innertext.equals(otherLabel)){
					innertextImg = "<img src=\"/images/hrm/absense/other.png\"  align=\"absmiddle\"  />";
					innertext = "<a href=\"javascript:void(0);\" onclick=\"todo("+resourceid+",'"+thenowday+"');\">"+innertextImg+"</a>";
				}else{
					/**
					**/
					for(int m=0;m<colors.size();m++){
						bean = (HrmLeaveTypeColor)colors.get(m);
						if(innertext.equals(bean.getField001())){
							innertextImg = "<img src=\"/images/hrm/absense/leave.png\"  align=\"absmiddle\"  />";
							innertext = "<a href=\"javascript:void(0);\" onclick=\"todo("+resourceid+",'"+thenowday+"');\">"+innertextImg+"</a>";
							break;
						}
	    			}
	    			
				}
			}else if("√".equals(innertext)){
				innertextImg = "<img src=\"/images/hrm/absense/ok.png\"  align=\"absmiddle\"  />";
					innertext = "<a href=\"javascript:void(0);\" onclick=\"todo("+resourceid+",'"+thenowday+"');\">"+innertextImg+"</a>";
			}else{
				innertext="&nbsp;";
			}
					/**
			if(!personelBean.getDateMap().get(thenowday)) {
				bgcolor="#F0F0F0";
				innertextImg = "<img src=\"/images/hrm/schedule/emoji-25.png\"  align=\"absmiddle\"  />";
				innertext = "<a href=\"javascript:void(0);\" onclick=\"todo("+resourceid+","+thenowday+");\">"+innertextImg+"</a>";
			}
			**/
	    }
	    if(tempids.size() > 0){
			if(tempids.size()==1){
		%>
			<TD style="padding:0px;background:<%=(String)tempdiffids.get(0)%>" align="center" >
<%=innertext %>
			</TD>
		<%
			}else{
		%>
			<TD style="padding:0px" align="center" ><%=innertext %>
			</TD>
		<%
			}
		} else {
		%>
		<TD style="height:2px;background-color:<%=bgcolor%>;" align="center"  onmouseover="jQuery(this).addClass('selected');jQuery(jQuery('#trHead').find('td')[$(this).index()]).addClass('selected');" onmouseout="jQuery(this).removeClass('selected');jQuery(jQuery('#trHead').find('td')[$(this).index()]).removeClass('selected');"
		       <% 
		       if(canlink==0) { 
		         if(i!=0) {
		       %> 
		       title=<%=thenowday%> 
		       <%
		         }
		       } else {
		       innertext = "&nbsp";
		       %>
		       title="<%=SystemEnv.getHtmlLabelName(1928,user.getLanguage())%>" 
		       <%}%>>
		       <%=innertext%>
		</TD>
		       <%}%>	
		  <%if(i==31){%> 
             </tr>
	     <%if(j!=12){ %>
	     <tr style="height: 2px" onmouseover="jQuery(jQuery(this).find('td')[0]).addClass('selected')" onmouseout="jQuery(jQuery(this).find('td')[0]).removeClass('selected');">
	     <%} %>
		  <%}
		}
	     }
	     %>
	</table>
<%}
	  	%>

<div id = "newbe" style="margin-top: 12px;">
	<div style="margin-top: 8px;margin-bottom: 8px;text-align: left;padding-left:15px;">
	       <%=SystemEnv.getHtmlLabelNames("22969,85",user.getLanguage())%>：
	       <span style="margin-right: 8px;"><img src="/images/hrm/absense/ok.png"  align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></span>
	       <span style="margin-right: 8px;"><img src="/images/hrm/absense/belate.png"  align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(20081,user.getLanguage())%></span>
	       <span style="margin-right: 8px;"><img src="/images/hrm/absense/leaveEarly.png"  align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(20082,user.getLanguage())%></span>
	       <span style="margin-right: 8px;"><img src="/images/hrm/absense/absent.png"  align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(20085,user.getLanguage())%></span>
	       <span style="margin-right: 8px;"><img src="/images/hrm/absense/nosign.png"  align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(20086,user.getLanguage())%></span>
           <span style="margin-right: 8px;"><img src="/images/hrm/absense/leave.png"  align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(670,user.getLanguage())%></span>
           <span style="margin-right: 8px;"><img src="/images/hrm/absense/evection.png"  align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(20084,user.getLanguage())%></span>
           <span style="margin-right: 8px;"><img src="/images/hrm/absense/out.png"  align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(24058,user.getLanguage())%></span>
           <span style="margin-right: 8px;"><img src="/images/hrm/absense/over.png"  align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(6151,user.getLanguage())%></span>
           <span style="margin-right: 8px;"><img src="/images/hrm/absense/other.png"  align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelNames("32104,563,26740",user.getLanguage())%></span>
	</div>
	<div style="margin-top: 8px;margin-bottom: 8px;text-align: left;padding-left:15px;">  
	<%=SystemEnv.getHtmlLabelNames("495,85",user.getLanguage())%>：
		  <span style="display:inline-block;vertical-align:bottom;width: 16px;height: 16px;background-color: rgba(207, 243, 207, 1);border-width:1px;border-color:rgba(228, 228, 228, 1);border-style:solid;">
	      </span>
	      <span style="margin-right: 5px;"><%=SystemEnv.getHtmlLabelName(16478,user.getLanguage())%></span>
	      
		  <span style="display:inline-block;vertical-align:bottom;width: 16px;height: 16px;background-color: rgba(182, 225, 253, 1);border-width:1px;border-color:rgba(228, 228, 228, 1);border-style:solid;">
	      </span>
	      <span style="margin-right: 5px;"><%=SystemEnv.getHtmlLabelName(16752,user.getLanguage())%></span>
	      
		  <span style="display:inline-block;vertical-align:bottom;width: 16px;height: 16px;background-color: rgba(243, 243, 243, 1);border-width:1px;border-color:rgba(228, 228, 228, 1);border-style:solid;">
	      </span>
	      <span style="margin-right: 5px;"><%=SystemEnv.getHtmlLabelName(130120,user.getLanguage())%></span>
		  <span style="display:inline-block;vertical-align:bottom;width: 16px;height: 16px;background-color: rgba(134, 134, 134, 1);border-width:1px;border-color:rgba(228, 228, 228, 1);border-style:solid;">
	      </span>
	      <span style="margin-right: 5px;"><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></span>
    </div>
</div>			
<div id="divDetail" name="divDetail" style="margin-top: 20px;margin-bottom: 50px;">
</div>

<%
float[] freezeDays = attVacationManager.getFreezeDays(resourceid);
Calendar annualtoday = Calendar.getInstance(); 
String nowdate = Util.add0(annualtoday.get(Calendar.YEAR),4) + "-" + Util.add0(annualtoday.get(Calendar.MONTH)+1,2) + "-" + Util.add0(annualtoday.get(Calendar.DAY_OF_MONTH),2);
String annualinfo = HrmAnnualManagement.getUserAannualInfo(resourceid,nowdate);
String thisyearannual = Util.TokenizerString2(annualinfo,"#")[0];
String lastyearannual = Util.TokenizerString2(annualinfo,"#")[1];
String allyearannual = Util.getDoubleValue(Util.TokenizerString2(annualinfo,"#")[2])+"";
if(freezeDays[0] > 0) allyearannual += " - "+freezeDays[0];

String pslinfo = HrmPaidSickManagement.getUserPaidSickInfo(resourceid,nowdate,"-12");
String thisyearpsl = Util.TokenizerString2(pslinfo,"#")[0];
String lastyearpsl = Util.TokenizerString2(pslinfo,"#")[1];
String allyearpsl = Util.TokenizerString2(pslinfo,"#")[2];
float freezeDay = attVacationManager.getPaidFreezeDays(resourceid,"-12");
if(freezeDay > 0) allyearpsl += " - "+freezeDay;	

String pdDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(resourceid));
if(freezeDays[2] > 0) pdDays += " - "+freezeDays[2];
%>
<table id="absenseInfo" width="100%" height="100%" style="margin-top: 20px;border-collapse:separate; border-spacing:10px;">
	<%
	String leaveTypes = colorManager.getPaidleaveStr();
	List list = colorManager.find(colorManager.getMapParam("mfsql:"+("and (field004 in (-6,-13) or ispaidleave = 1 )")));
	HrmLeaveTypeColor leaveTypebean = null;
	for(int i = 0 ;i < list.size()  ; ){
		
%>		
	<tr height="100%"  >
<%

		for(int j = 0 ; j < 3; j++){
			if(i >= list.size()){
				if(j == 0){
%>
<%
				}else if(j == 1){
 %>
				<td width="30%">
					<table class="tableinfo" style="display: none;" width="100%">
						<tr style="background-color:rgba(248, 248, 248, 1);">
							<td colspan="2" style="border-bottom:1px solid #B7E0FE;" >
							</td>
						</tr>
						<tr>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>    
						</tr>
					</table>
				</td>
		 		<td width="1%">
				&nbsp;
				</td>
				<td width="30%">
					<table class="tableinfo" style="display: none;" width="100%">
						<tr style="background-color:rgba(248, 248, 248, 1);">
							<td colspan="2" style="border-bottom:1px solid #B7E0FE;" >
							</td>
						</tr>
						<tr>
							<td></td>
							<td></td> 
						</tr>
						<tr>
							<td></td>
							<td></td> 
						</tr>
						<tr>
							<td></td>
							<td></td>       
						</tr>
					</table>
				</td>
<%
				}else if(j == 2){
 %>				
				<td width="30%">
					<table class="tableinfo" style="display: none;" width="100%">
						<tr style="background-color:rgba(248, 248, 248, 1);">
							<td colspan="2" style="border-bottom:1px solid #B7E0FE;" >
							</td>
						</tr>
						<tr>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>    
						</tr>
					</table>
				</td>
<%
				}
				break;
			}
			leaveTypebean = (HrmLeaveTypeColor)list.get(i);
			String field001 = leaveTypebean.getField001();//请假类型名称
			int ispaidleave = leaveTypebean.getIspaidleave();//默认值不是带薪假
			//请假类型
			String field004 = leaveTypebean.getField004()+"";
			String typeName = leaveTypebean.getField001();
			String titleInfo = "";
			String labelinfo1 = "",info1= "";
			String labelinfo2 = "",info2= "";
			String labelinfo3 = "",info3= "";

			//只有年假，调休和带薪假才会在这里进行显示
			if("-6".equals(field004)){
				titleInfo = SystemEnv.getHtmlLabelNames("21602,87",user.getLanguage());
				labelinfo1 = SystemEnv.getHtmlLabelName(21614,user.getLanguage());
				info1 = lastyearannual;
				labelinfo2 = SystemEnv.getHtmlLabelName(21615,user.getLanguage());
				info2 = thisyearannual;
				labelinfo3 = SystemEnv.getHtmlLabelName(21616,user.getLanguage());
				info3 = allyearannual;
			}else if("-13".equals(field004)){
				titleInfo = SystemEnv.getHtmlLabelNames("31297,87",user.getLanguage());
				labelinfo1 = SystemEnv.getHtmlLabelName(82854,user.getLanguage());
				info1 = pdDays;
				labelinfo2 = "";
				info2 = "";
				labelinfo3 = "";
				info3 = "";
			}else if(leaveTypes.indexOf(","+field004+",") > -1){
				String tmpPslinfo = HrmPaidSickManagement.getUserPaidSickInfo(resourceid,nowdate,field004);
				String tmpthisyearpsl = Util.TokenizerString2(tmpPslinfo,"#")[0];
				String tmplastyearpsl = Util.TokenizerString2(tmpPslinfo,"#")[1];
				String tmpallyearpsl = Util.TokenizerString2(tmpPslinfo,"#")[2];
				float tmpfreezeDay = attVacationManager.getPaidFreezeDays(resourceid,field004);
				if(tmpfreezeDay > 0) tmpallyearpsl += " - "+tmpfreezeDay;

				String combinelabelPS1 = SystemEnv.getHtmlLabelName(131649,user.getLanguage());
				String combinelabelPS2 = SystemEnv.getHtmlLabelName(131650,user.getLanguage());
				String combinelabelPS3 = SystemEnv.getHtmlLabelName(131651,user.getLanguage());
				if(typeName.length() > 0){
					combinelabelPS1 = SystemEnv.getHtmlLabelName(382185,user.getLanguage())+typeName+SystemEnv.getHtmlLabelName(496,user.getLanguage());
					combinelabelPS2 = SystemEnv.getHtmlLabelName(382186,user.getLanguage())+typeName+SystemEnv.getHtmlLabelName(496,user.getLanguage());
					combinelabelPS3 = SystemEnv.getHtmlLabelName(382187,user.getLanguage())+typeName+SystemEnv.getHtmlLabelName(496,user.getLanguage());
				}
				
				titleInfo = typeName+SystemEnv.getHtmlLabelNames("87",user.getLanguage());
				labelinfo1 = combinelabelPS1;
				info1 = tmplastyearpsl;
				labelinfo2 = combinelabelPS2;
				info2 = tmpthisyearpsl;
				labelinfo3 = combinelabelPS3;
				info3 = tmpallyearpsl;
			}else{
				i++;
				continue;
			}

			String label1Bottom = "border-bottom:1px solid rgba(242, 242, 242, 1);";
			String label2Bottom = "border-bottom:1px solid rgba(242, 242, 242, 1);";
			String label3Bottom = "border-bottom:1px solid rgba(242, 242, 242, 1);";

			if("".equals(labelinfo1)){
				label1Bottom = "";
			}
			if("".equals(labelinfo2)){
				label2Bottom = "";
			}
			if("".equals(labelinfo3)){
				label3Bottom = "";
			}
%>		
		<td width="30%">
			<table class="tableinfo" width="100%">
				<tr style="background-color:rgba(248, 248, 248, 1);">
					<td colspan="2" style="border-bottom:1px solid #B7E0FE;" >
					<span><%=titleInfo%></span> 
					</td>
				</tr>
				<tr style="<%=label1Bottom %>">
					<td>
					<span class="infolabel"><%=labelinfo1%></span> </td>
					<td>
					<span class="infolabel"><%=info1%></span> </td>
				</tr>
				<tr style="<%=label2Bottom %>">
					<td>
					<span class="infolabel"><%=labelinfo2%></span> </td>
					<td>
					<span class="infolabel"><%=info2%></span> </td>
				</tr>
				<tr style="<%=label3Bottom %>">
					<td>
					<span class="infolabel"><%=labelinfo3%></span> </td>
					<td>
					<span class="infolabel"><%=info3%></span> </td>       
				</tr>
			</table>
		</td>
		<td width="1%">
		&nbsp;
		</td>
<%			
i++;
		}
%>		
	</tr>	
<%
	}
	
%>
</table>
</form>
</td>
	</tr>
</table>
</body>
</html>
