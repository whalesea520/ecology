<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*,weaver.hrm.common.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%!
public Hashtable<Integer, Integer> getHolidaySet(String countryid, int year){
	Hashtable<Integer, Integer> htHoliday = new Hashtable<Integer, Integer>();
	if(countryid.length()==0)return htHoliday;
	String sql = "";
	
	
	RecordSet rs = new RecordSet();
	if (rs.getDBType().equals("oracle")){
		sql=" SELECT changetype, COUNT(*) AS sum_num FROM HrmPubHoliday "
		 + " WHERE countryid = "+countryid+" and substr(holidaydate, 1, 4) ='"+year+"' "
		 + " GROUP BY changetype ";
	}else{
		sql=" SELECT changetype, COUNT(*) AS sum_num FROM HrmPubHoliday "
			 + " WHERE countryid = "+countryid+" and SUBSTRING(holidaydate, 1, 4) ='"+year+"' "
			 + " GROUP BY changetype ";
	}
	rs.executeSql(sql);
	while(rs.next()){
		htHoliday.put(rs.getInt("changetype"), rs.getInt("sum_num"));
	}
	return htHoliday;
}
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<HTML>
	<HEAD>
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
<style type="text/css">
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
<script language=javascript>

// 获取event
function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}

function PublicHolidays_OnMouseOver(){
	var event = getEvent();
	var el = event.srcElement || event.target;
	if (el.tagName == "TD"){
		jQuery("#Info").html();
		window.parent.location.href="/hrm/schedule/HrmPubHolidayAdd.jsp";
	}
}

jQuery(document).ready(function(){

});

function doCopy(){
	if(check_form(document.frmmain,'countryid')){
	document.frmmain.action="HrmPubHolidayCopy.jsp";
	document.frmmain.submit();	
	}
}
function submitData() {
    if(check_form(document.frmmain,'countryid')){
		document.frmmain.action="HrmPubHoliday.jsp?countryid="+document.frmmain.countryid.value;
        document.frmmain.submit();
    }
}
function jsSubmit(e,datas,name){
	onBtnSearchClick();
}
function changeType(type){
	if(!type){
		type = "";
	}
	$GetEle("attendancetype").value = type;
	onBtnSearchClick();
}

function onBtnSearchClick(){
	jQuery("#weaver").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"HrmPubHolidayOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
		onBtnSearchClick();
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
function openDialog1(){
openDialog('', '');
}

function openDialog(id, holidaydate){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var countryid = jQuery("#countryid").val();
	var year = jQuery("#year").val();
	var showtype = jQuery("#showtype").val();

	var url = "/hrm/schedule/HrmPubHolidayOperation.jsp?isdialog=1&operation=selectdate&holidaydate="+holidaydate;
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(16750,user.getLanguage())%>";
		url = "/hrm/schedule/HrmPubHolidayEdit.jsp?isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(16750,user.getLanguage())%>";
	}
	url+="&year="+year+"&showtype="+showtype+"&countryid="+countryid;
	dialog.Width = 600;
	dialog.Height = 261;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=21 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=21")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16750,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String qname = Util.null2String(request.getParameter("flowTitle"));
boolean CanAdd = HrmUserVarify.checkUserRight("HrmPubHolidayAdd:Add", user);
boolean CanEdit = HrmUserVarify.checkUserRight("HrmPubHolidayEdit:Edit", user);
int showtype=Util.getIntValue(request.getParameter("showtype"),0);
String countryid=Util.null2String(request.getParameter("countryid"));
int year=Util.getIntValue(request.getParameter("year"),0);
String dept_id=Util.null2String(request.getParameter("dept_id"));

if(countryid.equals("")){
	if(dept_id.equals("")){
        String locationid = user.getLocationid();
        countryid = LocationComInfo.getLocationcountry(locationid);
	}
}
if(	countryid.length()==0) countryid = "1";

Calendar today = Calendar.getInstance();
int bywhat = Util.getIntValue(request.getParameter("bywhat"),1);
String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
String attendancetype = Util.null2String(request.getParameter("attendancetype"));
String datenow = "";
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

int fromyear=currentyear-5;
int toyear=currentyear+5;
if(year==0) year=currentyear;

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
		
		year = currentyear;
		datenow = String.valueOf(currentyear);
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
}

	
currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;  
currentday=today.get(Calendar.DATE);  
int tempCurrentMonth = currentmonth;
currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
// 获得一般工作时间,判断休息日
String monstarttime1 = "" ; 
String monendtime1 = "" ; 
String monstarttime2 = "" ; 
String monendtime2 = "" ;  

String tuestarttime1 = "" ; 
String tueendtime1 = "" ; 
String tuestarttime2 = "" ;  
String tueendtime2 = "" ; 

String wedstarttime1 = "" ;  
String wedendtime1 = "" ; 
String wedstarttime2 = "" ; 
String wedendtime2 = "" ; 

String thustarttime1 = "" ; 
String thuendtime1 = "" ; 
String thustarttime2 = "" ; 
String thuendtime2 = "" ;  

String fristarttime1 = "" ; 
String friendtime1 = "" ; 
String fristarttime2 = "" ; 
String friendtime2 = "" ; 

String satstarttime1 = "" ; 
String satendtime1 = "" ; 
String satstarttime2 = "" ; 
String satendtime2 = "" ; 

String sunstarttime1 = "" ; 
String sunendtime1 = "" ; 
String sunstarttime2 = "" ; 
String sunendtime2 = "" ; 

ArrayList weekrestdays = new ArrayList() ;
RecordSet.executeProc("HrmSchedule_Select_Current" , currentdate) ; 
if( RecordSet.next() ) {
    
    monstarttime1 = Util.null2String(RecordSet.getString("monstarttime1")) ;
    monendtime1 = Util.null2String(RecordSet.getString("monendtime1")) ;
    monstarttime2 = Util.null2String(RecordSet.getString("monstarttime2")) ;
    monendtime2 = Util.null2String(RecordSet.getString("monendtime2")) ;

    tuestarttime1 = Util.null2String(RecordSet.getString("tuestarttime1")) ;
    tueendtime1 = Util.null2String(RecordSet.getString("tueendtime1")) ;
    tuestarttime2 = Util.null2String(RecordSet.getString("tuestarttime2")) ;
    tueendtime2 = Util.null2String(RecordSet.getString("tueendtime2")) ;

    wedstarttime1 = Util.null2String(RecordSet.getString("wedstarttime1")) ;
    wedendtime1 = Util.null2String(RecordSet.getString("wedendtime1")) ;
    wedstarttime2 = Util.null2String(RecordSet.getString("wedstarttime2")) ;
    wedendtime2 = Util.null2String(RecordSet.getString("wedendtime2")) ;

    thustarttime1 = Util.null2String(RecordSet.getString("thustarttime1")) ;
    thuendtime1 = Util.null2String(RecordSet.getString("thuendtime1")) ;
    thustarttime2 = Util.null2String(RecordSet.getString("thustarttime2")) ;
    thuendtime2 = Util.null2String(RecordSet.getString("thuendtime2")) ;

    fristarttime1 = Util.null2String(RecordSet.getString("fristarttime1")) ;
    friendtime1 = Util.null2String(RecordSet.getString("friendtime1")) ;
    fristarttime2 = Util.null2String(RecordSet.getString("fristarttime2")) ;
    friendtime2 = Util.null2String(RecordSet.getString("friendtime2")) ;

    satstarttime1 = Util.null2String(RecordSet.getString("satstarttime1")) ;
    satendtime1 = Util.null2String(RecordSet.getString("satendtime1")) ;
    satstarttime2 = Util.null2String(RecordSet.getString("satstarttime2")) ;
    satendtime2 = Util.null2String(RecordSet.getString("satendtime2")) ; 

    sunstarttime1 = Util.null2String(RecordSet.getString("sunstarttime1")) ;
    sunendtime1 = Util.null2String(RecordSet.getString("sunendtime1")) ;
    sunstarttime2 = Util.null2String(RecordSet.getString("sunstarttime2")) ;
    sunendtime2 = Util.null2String(RecordSet.getString("sunendtime2")) ;
}

if( sunstarttime1.equals("") && sunendtime1.equals("") && sunstarttime2.equals("") && sunendtime2.equals("") )   weekrestdays.add("0") ;
if( monstarttime1.equals("") && monendtime1.equals("") && monstarttime2.equals("") && monendtime2.equals("") )   weekrestdays.add("1") ;
if( tuestarttime1.equals("") && tueendtime1.equals("") && tuestarttime2.equals("") && tueendtime2.equals("") )   weekrestdays.add("2") ;
if( wedstarttime1.equals("") && wedendtime1.equals("") && wedstarttime2.equals("") && wedendtime2.equals("") )   weekrestdays.add("3") ;
if( thustarttime1.equals("") && thuendtime1.equals("") && thustarttime2.equals("") && thuendtime2.equals("") )   weekrestdays.add("4") ;
if( fristarttime1.equals("") && friendtime1.equals("") && fristarttime2.equals("") && friendtime2.equals("") )   weekrestdays.add("5") ;
if( satstarttime1.equals("") && satendtime1.equals("") && satstarttime2.equals("") && satendtime2.equals("") )   weekrestdays.add("6") ;
char separator = Util.getSeparator();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:openDialog1();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:doCopy(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(HrmUserVarify.checkUserRight("HrmPubHoliday:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmmain method=post onSubmit="return check_form(this,'countryid')">
<input  class=inputstyle type=hidden name=currentdate id=currentdate value="<%=currentdate%>">
<input class=inputstyle type=hidden name=bywhat id=bywhat value="<%=bywhat%>">
<input class=inputstyle type=hidden name=showtype id=showtype value="<%=showtype%>">
<input class=inputstyle type=hidden name=movedate id=movedate value="">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		 	<%if(showtype==1){ %>
		 	<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>"></input>
		 	<%}if(CanAdd){ %>
			<input type=button class="e8_btn_top" onclick="openDialog('','');" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}if(showtype==1) {%>
				<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="calhead" class="calHd" style="height:36px;padding-left:0px;min-width:900px !important;background-color: #f7f7f7;">
			<div id="editButtons2" style="float:left;margin-left:5px;min-width:210px;border:none;height:24px;">
				<div id="rContent" unselectable="on" title="" class="calHdBtn   txtbtncls" style="border-left:none;min-width:200px;font-size:12px;width:auto;">
					<table width="100%">
					<tr>
						<td><%=SystemEnv.getHtmlLabelName( 377 ,user.getLanguage())%>&nbsp;:&nbsp;</td>
						<td>	
							<brow:browser viewType="0" id="countryid" name="countryid" browserValue='<%=countryid %>' 
							   browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/country/CountryBrowser.jsp?selectedids="
							   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							   completeUrl="/data.jsp?type=country" width="150px"
							   _callback="jsSubmit"
							   browserSpanValue='<%=Util.toScreen(CountryComInfo.getCountrydesc(countryid),user.getLanguage()) %>'>
							</brow:browser>
						</td>
					</table>
	      		</div>
				<div class="rightBorder" style="margin-left:10px;margin-right:13px;">|</div>
			</div>
			<div id="editButtons2" style="float:left;min-width:60px !important;padding-top: 3px;">
	      		<div id="showCalbtn" unselectable="on" class="calHdBtn <% if(showtype==0)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;min-width:30px;font-size: 15px;width: auto;">
	      			<%=SystemEnv.getHtmlLabelName( 490 ,user.getLanguage())%> 
	      		</div>
	      		<div id="showLstbtn" unselectable="on" class="calHdBtn <% if(showtype==1)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;padding-left:15px;min-width:30px;font-size: 15px;width: auto;">
	      			<%=SystemEnv.getHtmlLabelName( 491 ,user.getLanguage())%> 
	      		</div>
				<div class="rightBorder" style="margin-left:10px;margin-right:15px;">|</div>
			</div>
			   
			<div id="editButtons1" style="float:left;min-width:122px !important;">
					<% String titlestrnow=""; 
					if(bywhat==1) {
						titlestrnow =SystemEnv.getHtmlLabelName( 15384 ,user.getLanguage());
					}if(bywhat==2) {
		      			titlestrnow =SystemEnv.getHtmlLabelName( 15541 ,user.getLanguage());
					}else if(bywhat==3){
						titlestrnow=SystemEnv.getHtmlLabelName( 15539 ,user.getLanguage());
					}%>
					<div id="showtodaybtn" unselectable="on" class="calHdBtn showtodaybtn" title="<%=titlestrnow%>" style="height:24px;margin-left:0px;border:none;">
		      			 
		      		</div>
		      		<div id="sfprevbtn" unselectable="on" class="calHdBtn sfprevbtn" title="<%=SystemEnv.getHtmlLabelName(33960,user.getLanguage())%>"  style="height:24px;border:none;margin-left:10px;width:23px;_width:25px;">
		      		</div>
					<input type="hidden" name="txtshow" id="hdtxtshow" />
					<div id="txtdatetimeshow" unselectable="on" class="calHdBtn txtbtncls" style="border:none;width:auto;padding-left:1px;padding-right:10px;">
						
					</div>
		      		<div id="sfnextbtn" unselectable="on" class="calHdBtn sfnextbtn" title="<%=SystemEnv.getHtmlLabelName(33961,user.getLanguage())%>"  style="height:24px;border:none;border-left:none;width:23px;_width:25px;">
		      		</div>
				</div>
			<INPUT class=inputstyle type=hidden name=attendancetype value="<%=attendancetype%>">
			<div style="float:right;padding-right:5px;">
				<div  width="15" unselectable="on" class="calHdBtn txtbtncls" style="margin-left:10px;width:auto !important;padding-left:10px;padding-right:10px;text-align:left;">
					<%
						out.println("<font:color='blue'><span onclick=\"changeType()\">"+SystemEnv.getHtmlLabelName(21979,user.getLanguage())+"</span></font>&nbsp;&nbsp;&nbsp;&nbsp;");
					%>
				</div>
				<%
					Hashtable<Integer, Integer> htHoliday = getHolidaySet(countryid,year); 
					String[][] colorArray = new String[3][3];
					colorArray[0][0] = SystemEnv.getHtmlLabelName(16478,user.getLanguage())+"："+(htHoliday.get(1)==null?"0":htHoliday.get(1))+SystemEnv.getHtmlLabelName(32751 ,user.getLanguage());
					colorArray[0][1] = "1";
					colorArray[0][2] = "red";
					colorArray[1][0] = SystemEnv.getHtmlLabelName(16751,user.getLanguage())+"："+(htHoliday.get(2)==null?"0":htHoliday.get(2))+SystemEnv.getHtmlLabelName(32751 ,user.getLanguage());
					colorArray[1][1] = "2";
					colorArray[1][2] = "green";
					colorArray[2][0] = SystemEnv.getHtmlLabelName(16752,user.getLanguage())+"："+(htHoliday.get(3)==null?"0":htHoliday.get(3))+SystemEnv.getHtmlLabelName(32751 ,user.getLanguage());
					colorArray[2][1] = "3";
					colorArray[2][2] = "mediumblue";
					for(int i=0;i<colorArray.length;i++){
				%>
				<div  width="15" unselectable="on" class="calHdBtn txtbtnnoselcls" style="margin-left:0px;width:auto !important;padding-left:0px;padding-right:10px;text-align:left;">
					<%
						out.println("<font color='"+Tools.vString(colorArray[i][2])+"'>●</font><span onclick=\"changeType('"+Tools.vString(colorArray[i][1])+"')\">"+Tools.vString(colorArray[i][0])+"</span>&nbsp;");
					%>
				</div>
				<%
					}
				%>
      		</div>
      		
      </div>
			<%if(showtype==0){%>
	<table ID=PublicHolidays class="altrowstable" border=1 cellspacing=0 cellpadding=0 style="width: 99.5%;margin-left: 0.2%;margin-top: -1px">
	<tr style="height: 2px;background-color: #f7f7f7;border-bottom:2px solid #B7E0FE;">
		<td style="width: 7%;">
			<span style="text-align:center;"><%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;\&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName( 390 ,user.getLanguage())%></span>
		</td>
	  <%
	  for(int i=1;i<32;i++){
	  	%>
	  	<td height=20px width="3%" ALIGN=CENTER><%=i%></td>
	  	<%
	  }
	  %>
	</tr>
	<tr>
	<%
	RecordSet.executeProc("HrmPubHoliday_SelectByYear",year+""+separator+countryid);
	boolean hasholiday = RecordSet.next();
	String innertext="";
    String innertitle=""; // 第一列显示月份
	String bgcolor="white";
	Calendar tempday = Calendar.getInstance();
	
    String tempholiday = "";
    int tempchangetype = 1;

	String nowday="";
	int canlink=1;
	int isholiday=0;
	String id="";
	String holidayname="";
	for(int j=1;j<13;j++){
		for(int i=0;i<32;i++){
		canlink=1;
		isholiday=0;
		bgcolor="white";   // 默认为工作日

        tempday.clear();
        tempday.set(year,j-1,i);

        nowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
                Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
                Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;

        if(i==0){
			bgcolor="#f7f7f7";
			canlink=0;
			innertitle = ""+j;
        }
        else {
            innertitle = "" ;

            if(tempday.getTime().getDay()==0) innertext=SystemEnv.getHtmlLabelName(398,user.getLanguage());
            if(tempday.getTime().getDay()==1) innertext=SystemEnv.getHtmlLabelName(392,user.getLanguage());
            if(tempday.getTime().getDay()==2) innertext=SystemEnv.getHtmlLabelName(393,user.getLanguage());
            if(tempday.getTime().getDay()==3) innertext=SystemEnv.getHtmlLabelName(394,user.getLanguage());
            if(tempday.getTime().getDay()==4) innertext=SystemEnv.getHtmlLabelName(395,user.getLanguage());
            if(tempday.getTime().getDay()==5) innertext=SystemEnv.getHtmlLabelName(396,user.getLanguage());
            if(tempday.getTime().getDay()==6) innertext=SystemEnv.getHtmlLabelName(397,user.getLanguage());
        }
        
        if(weekrestdays.indexOf(""+tempday.getTime().getDay()) != -1 && i>0) bgcolor="#F0F0F0"; // 如果为休息日

        if((tempday.getTime().getMonth()!=(j-1))&&i>0) { bgcolor="#d0d0d0"; canlink=0;}
        if(!bgcolor.equals("#d0d0d0")&&i>0){
            if ( hasholiday ) {
                tempholiday = RecordSet.getString("holidaydate");
                tempchangetype = Util.getIntValue(RecordSet.getString("changetype"),1);
                holidayname=RecordSet.getString("holidayname");
                id=RecordSet.getString("id");
            }
			if(nowday.equals(tempholiday)){
				hasholiday = RecordSet.next();
				if(attendancetype.length()==0 || attendancetype.equals(String.valueOf(tempchangetype))){
					switch( tempchangetype ) {
					case 1 :
						bgcolor="RED";      // 法定假日
						break ;
					case 2 :
						bgcolor="GREEN";      // 工作日
						break ;
					case 3 :
						bgcolor="MEDIUMBLUE";      // 休息日
						break ;
						}
					isholiday=1;
				}
			}
        }
		%>


	<td height=20px ALIGN=CENTER style="background-color: <%=bgcolor%>;border-color: #E6E6E6"
		<%if((i>0)&&!bgcolor.equals("#d0d0d0")){%>
			style="CURSOR:HAND" 
		<%}
		if(isholiday == 1 ) {%> 
			ID="<%=holidayname%>:<%=nowday%>" 
		<%}%> 
			title="<%=innertext%>">



		<%if(canlink==1&&isholiday==0&&CanAdd&&i>0){%>
			<a style="width: 100%; display: inline-block; height: 100%; text-decoration: none;" href="javascript:void('0')" onclick="openDialog('','<%=nowday%>')">
		<%}%>
		<%if(canlink==1&&isholiday==1&&CanEdit&&i>0){%>
			<a style="width: 100%; display: inline-block; height: 100%; text-decoration: none;" href="javascript:void('0')" onclick="openDialog('<%=id%>','')">
		<%}%>

			<%=innertitle%>&nbsp;</a></td>
			<%
		if(i==31){%> 
			</tr>
		<%  }
		}
	}
	%>
	</table>
<%}else if(showtype==1){
	String sqlwhere = "";
	int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
	int perpage=Util.getIntValue(request.getParameter("perpage"),0);
	RecordSet.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
	if(RecordSet.next()){
		perpage =Util.getIntValue(RecordSet.getString(36),-1);
	}

	if(perpage<=1 )	perpage=10;
	
  String id = Util.null2String(RecordSet.getString("id")) ;
  String holidayname = Util.toScreen(RecordSet.getString("holidayname"),user.getLanguage()) ;
  String holidaydate = Util.null2String(RecordSet.getString("holidaydate")) ;
  int changetype = Util.getIntValue(RecordSet.getString("changetype"),1) ;
  int relateweekday = Util.getIntValue(RecordSet.getString("relateweekday"),1) ;
  
	String backfields = " id, holidayname, holidaydate, changetype, relateweekday "; 
	String fromSql  = " from HrmPubHoliday ";
	String sqlWhere = " where 1=1 ";
	String orderby = " id " ;
	String tableString = "";

if(!qname.equals("")){
	sqlWhere += " and holidayname like '%"+qname+"%'";
}	
if(attendancetype.length()>0){
	sqlWhere += " and changetype = "+attendancetype;
}

if (countryid.length()>0) {
	sqlWhere += " and countryid = "+countryid;
	}  	  	

if(year!=0){
	if (RecordSet.getDBType().equals("oracle")){
		sqlWhere += " and substr(holidaydate, 1, 4) = "+year;
	}else{
		sqlWhere += " and SUBSTRING(holidaydate, 1, 4) = "+year;
	}
}

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom></popedom> ";
		   operateString+="     <operate href=\"javascript:openDialog()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" isalwaysshow='true' index=\"1\"/>";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" isalwaysshow='true' index=\"2\"/>";
 	       operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" isalwaysshow='true' index=\"3\"/>";
 	       operateString+="</operates>";	
String tabletype="checkbox";
tableString =" <table instanceid=\"hrmPubHolidayTable\" tabletype=\""+tabletype+"\" pagesize=\""+perpage+"\" >"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    			operateString+
    "			<head>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(97,user.getLanguage())+"\" column=\"holidaydate\" orderkey=\"holidaydate\"/>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(85,user.getLanguage())+"\" column=\"holidayname\" orderkey=\"holidayname\"/>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"changetype\" orderkey=\"changetype\" transmethod=\"weaver.hrm.schedule.HrmPubHoliday.getChangeTypeName\" otherpara=\""+user.getLanguage()+"\"/>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(454,user.getLanguage())+"\" column=\"relateweekday\" orderkey=\"relateweekday\" transmethod=\"weaver.hrm.schedule.HrmPubHoliday.getRelateWeekdayDesc\" otherpara=\"column:changetype\" />"+
    "			</head>"+
    " </table>";
%>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
<%} %>
</form>
<script language=javascript>
function submitData() {
	document.frmmain.submit();
}
function getSubdate() {
	document.frmmain.movedate.value = "-1" ;
	document.frmmain.submit() ;
}
function getSupdate() {
	document.frmmain.movedate.value = "1" ;
	document.frmmain.submit() ;
}
function getYear(year){
	document.frmmain.movedate.value = year ;
	document.frmmain.submit() ;
}
function ShowYear() {
	document.frmmain.bywhat.value = "1" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowCal(){
	document.frmmain.showtype.value = "0" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowLst(){
	document.frmmain.showtype.value = "1" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowMONTH() {
	document.frmmain.bywhat.value = "2" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowWeek() {
	document.frmmain.bywhat.value = "3" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowDay() {
	document.frmmain.bywhat.value = "4" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
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
	<%}%>
	$("#showCalbtn").click(function(e) {
		changeShowType(this);
		ShowCal();
	});
	$("#showLstbtn").click(function(e) {
		changeShowType(this);
		ShowLst();
	});
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
		submit();
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
	   			jQuery("#weaver")[0].currentdate.value = dateFormat.call(r, i18n.xgcalendar.dateformat.fulldayvalue);
				submit();
				$("#hdtxtshow").val(dateFormat.call(r, i18n.datepicker.dateformat.fulldayvalue));
	    	}
	     } 
		<% if(bywhat==1) {%>
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
	if($("#showCalbtn").hasClass("txtbtncls")){
		$("#showCalbtn").removeClass("txtbtncls");
	}
	if(!$("#showCalbtn").hasClass("txtbtnnoselcls")){
		$("#showCalbtn").addClass("txtbtnnoselcls");
	}
	if($("#showLstbtn").hasClass("txtbtncls")){
		$("#showLstbtn").removeClass("txtbtncls");
	}
	if(!$("#showLstbtn").hasClass("txtbtnnoselcls")){
		$("#showLstbtn").addClass("txtbtnnoselcls");
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
	submitData();
}

</script>
</body>
</html>
