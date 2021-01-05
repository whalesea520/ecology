<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.service.CustomResourceService"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean   id="xssUtil" class="weaver.filter.XssUtil" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />

    <link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/workplan/calendar/css/dp_wev8.css" rel="stylesheet" type="text/css" />   
    <link href="/workplan/calendar/css/main_wev8.css" rel="stylesheet" type="text/css" /> 
    <%
    if(user.getLanguage()==8){
%>
    <script src="/car/calendar/src/Plugins/datepicker_lang_US_wev8.js" type="text/javascript"></script> 
<%
	}else if(user.getLanguage()==9){
%>
    <script src="/car/calendar/src/Plugins/datepicker_lang_HK_wev8.js" type="text/javascript"></script> 
<%
    }else{
%>
    <script src="/car/calendar/src/Plugins/datepicker_lang_ZH_wev8.js" type="text/javascript"></script> 
<%
    }
%>	
    <script src="/car/calendar/src/Plugins/jquery.datepickernew_wev8.js" type="text/javascript"></script>

<%
    if(user.getLanguage()==8){
%>
    <script src="/car/calendar/src/Plugins/wdCalendar_lang_US_wev8.js" type="text/javascript"></script>  
<%
	}else if(user.getLanguage()==9){
%>
    <script src="/car/calendar/src/Plugins/wdCalendar_lang_HK_wev8.js" type="text/javascript"></script>  
<%
    }else{
%>
    <script src="/car/calendar/src/Plugins/wdCalendar_lang_ZH_wev8.js" type="text/javascript"></script>  
<%
    }
%>
<META http-equiv=Content-Type content="text/html; charset=UTF-8" />

</head>
<%!
public String formatText(String str, int len){
	return str.length() > len?str.substring(0,len)+"...":str;
}
%>

<%
int userSub = user.getUserSubCompany1(); 
Calendar calendar = Calendar.getInstance();
    
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19018,user.getLanguage());//车辆使用情况
String needfav ="1";
String needhelp ="";
char flag=2;
String userid=user.getUID()+"" ;
ArrayList newCarIds = new ArrayList() ;
boolean cancelRight = HrmUserVarify.checkUserRight("Canceledpermissions:Edit",user);
//1: year 2:month 3:week 4:today but the year haven`t been used!
int bywhat = Util.getIntValue(request.getParameter("bywhat"),4);

String resourceId =  Util.null2String(request.getParameter("resourceId"));
if(resourceId.equals("")){
	resourceId = Util.null2String(request.getParameter("id"));
}

String resourcesqlwhere = new String(Util.null2String(request.getParameter("resourcesqlwhere")).getBytes("ISO-8859-1"),"UTF-8");

String datasqlwhere = new String(Util.null2String(request.getParameter("datasqlwhere")).getBytes("ISO-8859-1"),"UTF-8");
String sqlwhere = new String(Util.null2String(request.getParameter("sqlwhere")).getBytes("ISO-8859-1"),"UTF-8");

if(!resourcesqlwhere.equals("")){
	resourcesqlwhere = resourcesqlwhere.trim().startsWith("and")?resourcesqlwhere:" and "+resourcesqlwhere;
}
if(!datasqlwhere.equals("")){
	datasqlwhere = datasqlwhere.trim().startsWith("and")?datasqlwhere:" and "+datasqlwhere;
}

if(!sqlwhere.equals("")){
	datasqlwhere += sqlwhere.trim().startsWith("and")?sqlwhere:" and "+sqlwhere;
}

String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));//上一个时段或下一个时段，-1或1 
String relatewfid = Util.null2String(request.getParameter("relatewfid"));
String operation=Util.null2String(request.getParameter("operation"));
String content = Util.null2String(request.getParameter("content")).trim();
int subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
int carid=Util.getIntValue(request.getParameter("id"),0);
int subids = Util.getIntValue(request.getParameter("subids"), -1);
Calendar today = Calendar.getInstance();
Calendar temptoday1 = Calendar.getInstance();
Calendar temptoday2 = Calendar.getInstance();
String nowdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String nowtime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                Util.add0(today.get(Calendar.SECOND), 2);   
if(operation.equals("cancel")){
    //TODO 车辆使用取消状态
}

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
String datefrom = "" ;
String dateto = "" ;
String datenow = "" ;
String cBeginDate="";
String cEndDate="";

switch (bywhat) {
	case 1 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4) ;
		temptoday1.add(Calendar.YEAR,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4) ;

		temptoday2.add(Calendar.YEAR,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4) ;
		break ;
	case 2 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;
		temptoday1.add(Calendar.MONTH,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-31" ;

		temptoday2.add(Calendar.MONTH,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-01" ;
		cBeginDate = TimeUtil.getMonthBeginDay(currentdate);
		cEndDate = TimeUtil.getMonthEndDay(currentdate);
		break ;
 	case 3 :
 		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.DATE,-2) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;

		temptoday2.add(Calendar.WEEK_OF_YEAR,1) ;
		temptoday2.add(Calendar.DATE,-1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday2.get(Calendar.DATE),2) ;
		cBeginDate = TimeUtil.getWeekBeginDay(currentdate);
		cEndDate = TimeUtil.getWeekEndDay(currentdate);
		break ;
	case 4 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.DATE,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		
		Calendar datetos = Calendar.getInstance();
		temptoday2.add(Calendar.DATE,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday2.get(Calendar.DATE),2) ;
		cBeginDate = currentdate;
		cEndDate = currentdate;
}


CustomResourceService customResourceService = new CustomResourceService();
Map<String, String> fields = customResourceService.convertResourceFieldsById(resourceId);

String modename = fields.get("modename");
String modeid = fields.get("modeid");
String formid = fields.get("formid");
String customSearchId = fields.get("customSearchId");

//String startDateFieldName = fields.get("startDateFieldName");
//String endDateFieldName = fields.get("endDateFieldName");
String resourceFieldName = fields.get("resourceFieldName");
String createUrl = Util.null2String(fields.get("createUrl"));

//datasqlwhere = " and (t1."+startDateFieldName+">'"+datefrom+"' and t1."+startDateFieldName+"<'"+dateto+"' or t1."+endDateFieldName+">'"+datefrom+"' and t1."+endDateFieldName+"<'"+dateto+"')"+datasqlwhere;
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
////月使用情况
RCMenu += "{"+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+SystemEnv.getHtmlLabelName(160,user.getLanguage())+SystemEnv.getHtmlLabelName(622,user.getLanguage())+",javascript:ShowMONTH(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
////周使用情况
RCMenu += "{"+SystemEnv.getHtmlLabelName(1926,user.getLanguage())+SystemEnv.getHtmlLabelName(160,user.getLanguage())+SystemEnv.getHtmlLabelName(622,user.getLanguage())+",javascript:ShowWeek(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
////日使用情况
RCMenu += "{"+SystemEnv.getHtmlLabelName(390,user.getLanguage())+SystemEnv.getHtmlLabelName(160,user.getLanguage())+SystemEnv.getHtmlLabelName(622,user.getLanguage())+",javascript:ShowDay(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!createUrl.trim().equals("")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83981,user.getLanguage())+modename+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<style type=text/css>
td.car-selecting .tdfcs{
	BACKGROUND-COLOR: #59b0f2;
}
.tdfcs{
	width:4px;
	height:100%;
	float:left;
}
.thbgc{
	background:#f7f7f7;
}

.selectable .ui-selecting { background: #E1ECFF;}
.selectable .ui-selected { background: #F39814; color: white; }
.selectable { list-style-type: none; margin: 0; padding: 0;cursor :pointer; }

.TH {
	CURSOR: auto; BACKGROUND-COLOR: beige
}
.PARENT {
	CURSOR: auto
}
.TH1 {
	CURSOR: auto; HEIGHT: 25px; BACKGROUND-COLOR: beige
}
.TODAY {
	CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.T_HOUR {
	BORDER-LEFT: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.TI TD {
	BORDER-TOP: 0px; FONT-SIZE: 1px; LEFT: -1px; BORDER-LEFT: 0px; CURSOR: auto; POSITION: relative; TOP: -1px
}
.CU {
	
}
.SD {
	CURSOR: auto; COLOR: white; BACKGROUND-COLOR: mediumblue
}
.L {
	BORDER-TOP: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.LI {
	BORDER-TOP: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.L1 {
	BORDER-TOP: white 1px solid; BORDER-LEFT: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.M1 TD {
	 BORDER-bottom: 1px solid #d0d0d0;BORDER-LEFT: 1px solid #d0d0d0;color:#606060;
}

.M1 {
	BORDER-RIGHT: 1px solid #d0d0d0; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; min-width:900px !important;
}
.MI {
	TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; min-width:900px !important;
}

.M1 {
	BORDER-top: 1px solid #d0d0d0;
}
.WE {
	BORDER-LEFT-WIDTH: 0px
}
.PI TD {
	BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: lightgrey 1px solid; BORDER-BOTTOM: 1px solid
}

.searchBox .searchInput{
	height:19px;
	border-right:none;
	width:170px;
	background:#fff;
}
.searchBox{
    margin-left:0px;
    margin-bottom:2px;
	background:#f7f7f7;
	line-height:23px;
	font-weight:bold;
	text-align:center;
	width:200px;
	height:23px;
	_height:25px;
	cursor:pointer;
	display:inline-block;
	opacity: 1;
}
.carnames {
		height:25px;
		cursor :pointer;
		background:#f7f7f7;
}
.carnames .tdtxt {
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		height:25px;
		line-height:25px;
		width:214px;
		float:left
}

.searchBox .Browser:hover{
	background:#f1eeee;
}

.subidsSpan{
	width:100px;
	word-break: keep-all;
	text-overflow: ellipsis;
	white-space: nowrap;
	overflow: hidden;
}


</style>
<BODY style="overflow: hidden;">
<FORM id=frmmain name=frmmain method=post action="/formmode/view/ModeViewByResource.jsp?id=<%=resourceId %>&sqlwhere=<%=sqlwhere %>" style="height: 100%;">
<input type=hidden name=currentdate value="<%=currentdate%>"/>
<input type=hidden name=bywhat value="<%=bywhat%>"/>
<input type=hidden name=movedate value="" />
<div> 
<%
      String addBtnUrl="/car/calendar/css/images/icons/addBtn_wev8.png";
	  if(user.getLanguage()==8){
		  addBtnUrl="/car/calendar/css/images/icons/addBtn_EN_wev8.png";
	  }
%>
  </div>
    <div id="calhead" class="calHd" style="height:36px;padding-left:20px;min-width:900px !important;background-color: #f7f7f7;z-index: 999;position: absolute;width: 100%">
      		<div style="float:left;margin-left:10px;border:none;height:24px;display: none;"><!-- 显示/隐藏分部树 -->
      			<div id="showLayoutbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName(33402,user.getLanguage()) %>" val="0" unselectable="on" class="calHdBtn showLayoutbtnT" style="margin-left:10px;border:none;height:24px;">
				<INPUT type=hidden name="subids" id="subids" value="<%if(subids > 0){%><%=subids %><%} %>" />
				</div>
				<!-- 选择分部 -->
	      		<div  id="showsubcompanybtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName(33256,user.getLanguage())%>" class="calHdBtn" style="margin-left:0px;width:auto !important;padding-left:0px;padding-right:10px;text-align:left;color:#59b0f2" >
						
						<% String subidsSpan = SystemEnv.getHtmlLabelName(141,user.getLanguage());//分部
							if(subids > 0){
								subidsSpan += " : "+SubCompanyComInfo.getSubCompanyname(""+subids);
							} else {
								RecordSet.executeSql("SELECT companyname FROM HrmCompany WHERE id = 1");
								if(RecordSet.next()){//总部
									subidsSpan =  SystemEnv.getHtmlLabelName(140,user.getLanguage())+" : "+Util.null2String(RecordSet.getString("companyname"));
								}
							} 
						%>
						<%=subidsSpan%>
	      		</div>
	      		<div class="rightBorder" style="margin-left:10px;margin-right:13px">|</div>
      		</div>
      		<div  id="firstButtons" style="float:left;min-width:40px !important;display: <%=createUrl.trim().equals("")?"none":"block" %>">
      			<div id="faddbtn" class="calHdBtn faddbtn" title="<%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())+modename %>" style="border:none;height:25px;">
      			</div>
				<div class="rightBorder" style="margin-left:10px;margin-right:10px">|</div>
      		</div>
			<div id="editButtons2" style="float:left;min-width:60px !important;">
		      		  <%if(user.getLanguage()==9) {%><!-- 日 -->
      		    <div id="showdaybtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 27296 ,user.getLanguage())%>" class="calHdBtn     <% if(bywhat==4) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="margin-left:0px;width:30px;font-size: 15px;">
	      			D
	      		</div><!-- 周 -->
	      		<div id="showweekbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 1926 ,user.getLanguage())%> " class="calHdBtn   <% if(bywhat==3) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
	      			W
	      		</div><!-- 月 -->
	      		<div id="showmonthbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%>" class="calHdBtn   <% if(bywhat==2) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
	      			M
	      		</div>
      		    <%} else { %>
            	<div id="showdaybtn" unselectable="on" class="calHdBtn <% if(bywhat==4)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="margin-left:0px;width:30px;font-size: 15px;">
	      			<%=SystemEnv.getHtmlLabelName( 27296 ,user.getLanguage())%> <!-- 日 -->
	      		</div>
	      		<div id="showweekbtn" unselectable="on" class="calHdBtn <% if(bywhat==3)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
	      			<%=SystemEnv.getHtmlLabelName( 1926 ,user.getLanguage())%> <!-- 周 -->
	      		</div>
	      		<div id="showmonthbtn" unselectable="on" class="calHdBtn <% if(bywhat==2)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
	      			<%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%> <!-- 月 -->
	      		</div>
	      		<%} %><!-- 刷新 -->
					<div id="showreflashbtn" unselectable="on" class="calHdBtn showreflashbtn" title="<%=SystemEnv.getHtmlLabelName( 354 ,user.getLanguage())%>" style="height:24px;border:none;margin-left:10px;border:none;">
					</div>
				<div class="rightBorder" style="margin-left:10px;margin-right:15px">|</div>
               </div>
			   
			<div id="editButtons1" style="float:left;min-width:122px !important;">
					<% String titlestrnow=""; 
					if(bywhat==2) {
		      			titlestrnow =SystemEnv.getHtmlLabelName( 15541 ,user.getLanguage());//本月
					}else if(bywhat==3){
						titlestrnow=SystemEnv.getHtmlLabelName( 15539 ,user.getLanguage());//本周
					}else if(bywhat==4){
						titlestrnow=SystemEnv.getHtmlLabelName( 15537 ,user.getLanguage()); //今天
					}%>
					<div id="showtodaybtn" unselectable="on" class="calHdBtn showtodaybtn" title="<%=titlestrnow%>" style="height:24px;margin-left:0px;border:none;">
		      			 
		      		</div><!-- 上一个时段 -->
		      		<div id="sfprevbtn" unselectable="on" class="calHdBtn sfprevbtn" title="<%=SystemEnv.getHtmlLabelName(33960,user.getLanguage())%>"  style="height:24px;border:none;margin-left:10px;width:23px;_width:25px;">
		      		</div>
					<input type="hidden" name="txtshow" id="hdtxtshow" />
					<div id="txtdatetimeshow" unselectable="on" class="calHdBtn txtbtncls" style="border:none;width:auto;padding-left:1px;padding-right:10px;">
						
					</div><!-- 下一个时段 -->
		      		<div id="sfnextbtn" unselectable="on" class="calHdBtn sfnextbtn" title="<%=SystemEnv.getHtmlLabelName(33961,user.getLanguage())%>"  style="height:24px;border:none;border-left:none;width:23px;_width:25px;">
		      		</div>
					
				</div>
      </div>
  <table class=MI id=AbsenceCard cellSpacing=0 cellPadding=0 style="height: 100%;position: absolute;z-index: 998;">
  		<tr style="height: 37px;"></tr>
		<tr>
			<td id="treetd" style="display:none; BORDER-top: 1px solid #d0d0d0; BORDER-LEFT: 0px;width:247px;vertical-align: top;" rowspan="2">
				
				<div id="subCompanytDiv" style="position:absolute;width:245px;min-height:300px;background:#f7f7f7;BORDER-right: 1px solid #d0d0d0;">
					<IFRAME  id="subCompanytifm"  width="100%"  frameborder=no scrolling=no src="">
				</IFRAME>
				</div>
			</td>
			<td style="BORDER-TOP: 0px; BORDER-LEFT: 0px;vertical-align: top;">
			<div id="tablediv" style="overflow-y: hidden;position: relative;width:100%">
			<div id="tableChlddiv">
				<input type="hidden" name="datenow" id="datenow" value="<%=datenow%>" />
				<table  class=M1 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
				    <COLGROUP>
						<col width="221">
						<col width="">
				    <tr  class="thbgc">
						 	<td class="schtd" align=center style="width:220px;background:#f7f7f7;BORDER-left: 1px solid #d0d0d0;height:25px; ">
								<table height="100%" width="100%" border=0 cellspacing=0 cellpadding=0>
									<tr>
										<td width="20px" style="BORDER-bottom:0px;BORDER-LEFT: 0px">
										<button class="Browser" id=namebtn name=namebtn type="button" onclick="submit();" style="margin-top: 3px !important;"  ></button>
										</td>
										<td  width="200px" style="BORDER-bottom:0px;BORDER-LEFT: 0px">
										<INPUT id=content name=content class="searchInput" onmouseover="this.select()" onfocus="clearVal(this);" onblur="recoverVal(this);"   value="<%=content %>" style="width:180px;height:23px;border:0px;background:#f7f7f7;color:#606060" /> 
										</td>
									</tr>
								</table>
							</td>
						<%for(int i=0;i<=23;i++){%>
							<%if(i == 0) { %>
								<td class="thcls" style="BORDER-left: 1px solid #d0d0d0;" align=center><%=i%></td>
							<%}else{%>
								<td class="thcls" style="BORDER-LEFT: 0px" align=center><%=i%></td>
							<%}%>
						<%}%>
				    </tr>
				</table>
			</div>
			</div>
		</td>
	</tr>
	<tr>
		<td id="searchTd">
			<div style="height: 100%;overflow: hidden;border: 0;">
				<IFRAME name="listframe" id="listframe" style="width: 100%;height: 100%;border: 0" src="">
				</IFRAME>
			</div>
		</td>
	</tr>
</table>



	
</FORM>

<script language=javascript>
var showCnt = 0;
var diag_vote;
jQuery(document).ready(function(){
	submit();
	var cBeginDate="<%=cBeginDate%>";
	var cEndDate="<%=cEndDate%>";
	var showtime = "";
	var titletime=""; 
	
	<% if(bywhat==2) {%>
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
		titletime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), null, null, true)+"&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>";//单位:小时
		showtime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));
	<%}%>

	//车辆管理不做拖拽
	//jQuery("body").bind("mousemove", function(event){createCarinfoAction.moving(event)});
	//jQuery("body").bind("mouseup", function(event){createCarinfoAction.stopDrag(event)});
	
	jQuery("#tablediv").perfectScrollbar();
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
   
   $("#showLayoutbtn").click(function(e) {
		showCompanyTree();
   });
    
   //Add a new car
   $("#faddbtn").click(function(e) {
   	 	onAdd();
   });
   
   	$(window).resize(function(){
   		setCalHeight(dataCount);
	});
   
    jQuery('#tablediv').perfectScrollbar();
   
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
	    	}
	     } 
		<% if(bywhat==2) {%>
        ,selectMode:"1"
		<%}%>
   });
   
   recoverVal($GetEle("content"));
   
	var bodyheight = document.body.offsetHeight;
	$("#subCompanytDiv").height(bodyheight - 44);
	$("#subCompanytifm").height(bodyheight - 44);
   $(".thcls").css("border-bottom","1px solid #59b0f2");
   $(".schtd").css("border-bottom","1px solid #59b0f2");
   $(".schtd").css("border-left","0px");
   $(".carnames").css("border-left","0px");
   $("#txtdatetimeshow").text(showtime);
})
var enable = true;

//计算两块高度
var topHeight = 37;
var tdHeight = 26;
var dataCount = 1;
function setCalHeight(_dataCount){
	dataCount = _dataCount;
	var docHeight = $(document.body).height();
	var maxHeight = docHeight-topHeight-docHeight*40/100;
	var currHeight = tdHeight*(dataCount+1)+1;
	if(currHeight>maxHeight){
		$("#tablediv").css("height",maxHeight);
		$("#searchTd").css("height",docHeight-maxHeight-topHeight);
	}else{
		$("#tablediv").css("height",currHeight);
		$("#searchTd").css("height",docHeight-currHeight-topHeight);
	}
}

function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	submit();
}

function dataRfsh(){
	submit();
}

function showCompanyTree(){
	if($("#treetd").css("display")=="none"){
		$("#treetd").css("display","");
		$("#showLayoutbtn").removeClass("showLayoutbtnT");
		$("#showLayoutbtn").addClass("showLayoutbtnO");
	}else{
		$("#treetd").css("display","none");
		$("#showLayoutbtn").removeClass("showLayoutbtnO");
		$("#showLayoutbtn").addClass("showLayoutbtnT");
	}
	if($("#subCompanytifm").attr("src") == ""){
		$("#subCompanytifm").attr("src","/car/CarSubCompanyTree.jsp");
	}
	setWindowSize(document);
}

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
	
	if(!$(obj).hasClass("txtbtncls")){
		$(obj).addClass("txtbtncls");
	}
	if($(obj).hasClass("txtbtnnoselcls")){
		$(obj).removeClass("txtbtnnoselcls");
	}
}


function setTDWidth(cnt){

}

function showCarinfoList(resourceid,datasqlwhere,event){
	event = jQuery.event.fix(event);
	var startElement = event.target;
	clearVal($GetEle("content"));
	if(jQuery(startElement).parent("td.carnames").hasClass("car-selecting")){
		jQuery(startElement).parent("td.carnames").removeClass("car-selecting");
		$("#listframe").attr("src","/formmode/search/CustomSearchBySimple.jsp?customid=<%=customSearchId %>&datasqlwhere="+datasqlwhere);
	} else{
		$(".car-selecting").each(function(){
			$(this).removeClass("car-selecting");
		});
		jQuery(startElement).parent("td.carnames").addClass("car-selecting");
		$("#listframe").attr("src","/formmode/search/CustomSearchBySimple.jsp?customid=<%=customSearchId %>&datasqlwhere="+datasqlwhere);
	}
	
	recoverVal($GetEle("content"));
		
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

function CreateCarinfoAction()
{
	this.carid;
	this.active;
	this.startTime;
	this.endTime;
}
CreateCarinfoAction.prototype.startDrag = function(event)
{
	this.carid = "";
	this.startTime = "";
	this.endTime = "";
	this.active = false;
	event = jQuery.event.fix(event);
	if(enable && (0 == event.button || 1 == event.button))
	{
		var startElement = event.target;
		this.carid = startElement.id;
		this.startTime =jQuery(startElement).attr("target");
		this.endTime = jQuery(startElement).attr("target");
		startElement.className = "ui-selecting";
		jQuery(startElement).css("background-color","#E1ECFF");
		this.active = true;
	}
}
CreateCarinfoAction.prototype.moving = function(event)
{
	if(enable && this.active)
	{
		event = jQuery.event.fix(event);
		var movingElement = event.target;
		var pElement = movingElement.parentNode;
		if(pElement.tagName=="TR"&&pElement.className=="selectable")
		{
			var carid = movingElement.id;
			if(carid==this.carid)
			{
				this.carid = movingElement.id;
				this.endTime = jQuery(movingElement).attr("target");
				movingElement.className = "ui-selecting";
				jQuery(movingElement).css("background-color","#E1ECFF");
			}
		}
	}
}
CreateCarinfoAction.prototype.stopDrag = function(event)
{
	event = jQuery.event.fix(event);
	if(enable && this.active)
	{
		this.createCarinfo();
		this.active = false;
		resetCarinfo();
	}
}
CreateCarinfoAction.prototype.createCarinfo = function()
{
    //TODO 创建车辆使用
    var url = "/car/NewCaruseTab.jsp";
	url +="?carid="+this.carid;
	var currentdate = document.frmmain.currentdate.value;
	url +="&startdate="+currentdate;
	url +="&enddate="+currentdate;
	var tempStartTime = this.startTime;
	var tempEndTime = this.endTime;
	if(parseInt(tempStartTime)>parseInt(tempEndTime))
	{
		var temp = this.startTime;
		this.startTime = this.endTime;
		this.endTime = temp;
	}
	if(this.startTime.length==1)
	{
		this.startTime = "0"+this.startTime;
	}
	this.startTime += ":00";
	if(this.endTime.length==1)
	{
		this.endTime = "0"+this.endTime;
	}
	this.endTime += ":59";
	url +="&starttime="+this.startTime;
	url +="&endtime="+this.endTime;
	newCarinfo(url);
}

function onAdd() {
	var url = "<%=createUrl %>";
   	newResourceinfo(url);
}

function newResourceinfo(url){
    if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())+modename %>";//新增用车申请
	diag_vote.URL = url;
	diag_vote.show();
}

var createCarinfoAction = new CreateCarinfoAction();
function checkCarinfo()
{
	var tds = document.getElementsByTagName("TD");
	for(var i=0;i<tds.length;i++)
	{
		var cname = tds[i].className;
		if(cname=="ui-selecting")
		{
			var bc = tds[i].bgColor;
			if(bc !=""&&bc != "#f5f5f5")
			{
				return "1";
			}
		}
	}
}
function resetCarinfo()
{
	var tds = document.getElementsByTagName("TD");
	for(var i=0;i<tds.length;i++)
	{
		var cname = tds[i].className;
		if(cname=="ui-selecting")
		{
			tds[i].className = "";
			jQuery(tds[i]).css("background-color","");
		}
	}
}
function getSubdate() {
	document.frmmain.movedate.value = "-1" ;
	submit() ;
}
function getSupdate() {
	document.frmmain.movedate.value = "1" ;
	submit();
}
function ShowYear() {
	document.frmmain.bywhat.value = "1" ;
	document.frmmain.currentdate.value = "" ;
	submit();
}
function ShowMONTH() {
	document.frmmain.bywhat.value = "2" ;
	document.frmmain.currentdate.value = "" ;
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
function doCancel(id){
	document.frmmain.action="CarUseInfo.jsp?operation=cancel&id="+id;
	submit();
}

function setSubcompany(subid){
	$("#subids").val(subid);
	onSubChange();
}

function onSubChange(){
	submit();
}

function selectRoot(){
	$("#subids").val("");
	onSubChange();
}

function submit(){
	clearVal($GetEle("content"));
	getResourceInfo("");
}

function onSearch(){
	var content = $("#content").val();
	if(content!=""){
		clearVal($GetEle("content"));
		getResourceInfo(content);
	}
}
//zwbo 添加了sqlwhere参数
function getResourceInfo(content){
    $.post("/formmode/view/ModeViewByResourceAjax.jsp",{resourceId:"<%=resourceId %>",bywhat:$GetEle("bywhat").value,currentdate:$GetEle("currentdate").value,movedate:$GetEle("movedate").value,content:content,subids:$GetEle("subids").value,resourcesqlwhere:"<%=xssUtil.put(resourcesqlwhere) %>",datasqlwhere:"<%=xssUtil.put(datasqlwhere) %>",sqlwhere:"<%=xssUtil.put(sqlwhere) %>",content:"<%=content %>"},function(datas){
		jQuery("#tableChlddiv").html("");
		jQuery("#tableChlddiv").append(datas);
		afterLoadDate();
	});
}


function setWindowSize(_document){
	if(!!_document)_document = document;
	var bodyheight = _document.body.offsetHeight;
	var listframeh = jQuery("#listdiv",window.frames["listframe"].document).height() + 10;
	jQuery("#listframe").height(listframeh);
	var bottomheight = listframeh+2;
	jQuery("#CaruseListDiv").height(listframeh+2);
	
	if(bottomheight>0){
		bottomheight = 51 + bottomheight;
	}
	var tdhm1 = jQuery(".M1").height();
	if(jQuery(".M1").width() > jQuery("#tablediv").width()){
		tdhm1 = tdhm1 + 16;
	}
	
	var cah = bodyheight-bottomheight;
	jQuery("#tablediv").css("height",tdhm1 > cah ? cah:tdhm1+2);
	jQuery("#tablediv").perfectScrollbar('update');
	jQuery(".ps-scrollbar-y").position.top=jQuery("#tablediv").position.top;
}

<!--

function clearVal(obj){
	if(obj.value=='<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage()) %>'){ //搜索
		obj.value="";
		obj.style.color="#606060";
	}
}

function recoverVal(obj){
    
	if(obj.value==''||obj.value==null){
	    //alert(obj.value);
		obj.value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage()) %>";//搜索
		obj.style.color="#d0d0d0";
	}
}

//-->

</script>


</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script language="javascript" src="/car/carbase_wev8.js"></script>
</html>

