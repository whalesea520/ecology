
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:include page="/systeminfo/DatepickerLangJs.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>
<jsp:include page="/systeminfo/WdCalendarLangJs.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />

    <link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/workplan/calendar/css/dp_wev8.css" rel="stylesheet" type="text/css" />   
    <link href="/workplan/calendar/css/main_wev8.css" rel="stylesheet" type="text/css" /> 
	
    <script src="/meeting/calendar/src/Plugins/jquery.datepickernew_wev8.js" type="text/javascript"></script>


<script src="/js/ecology8/meeting/meetingbase_wev8.js" type="text/javascript"></script> 
<META http-equiv=Content-Type content="text/html; charset=UTF-8" />
<style type=text/css>

td.room-selecting .tdfcs{
	BACKGROUND-COLOR: #59b0f2;
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
	BORDER-RIGHT: 1px solid #d0d0d0; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; min-width:1000px !important;
}
.MI {
	TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; min-width:1000px !important;
}

.M1 {
	BORDER-top: 0px solid #d0d0d0;
}
.WE {
	BORDER-LEFT-WIDTH: 0px
}
.PI TD {
	BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: lightgrey 1px solid; BORDER-BOTTOM: 1px solid
}
 
.roomnames {
	
	background:#f7f7f7;
}
.roomnames .tdtxt {
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		width:90px;
		float:left;
		text-align: center;
}

</style>
</head>
<%
int userSub = user.getUserSubCompany1(); 
Calendar calendar = Calendar.getInstance();
int objType=1;    
int userDept=user.getUserDepartment();
int userId=user.getUID();

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33959,user.getLanguage()); 
String needfav ="1";
String needhelp ="";
char flag=2;
String userid=user.getUID()+"" ;
//1: year 2:month 3:week 4:today but the year haven`t been used!
int bywhat = Util.getIntValue(request.getParameter("bywhat"),3);

String currentdate =  Util.null2String(request.getParameter("currentdate"));
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



int currentyear=today.get(Calendar.YEAR);
int thisyear=currentyear;
int currentmonth=today.get(Calendar.MONTH);  
int currentday=today.get(Calendar.DATE);
 

currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;  
currentday=today.get(Calendar.DATE); 

currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;

String datenow = "" ;
String cBeginDate="";
String cEndDate="";

switch (bywhat) {
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
}	
	
	
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354, user.getLanguage())+",javaScript:submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(17416, user.getLanguage())+",javaScript:exportExecl(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=frmmain name=frmmain method=post>
<input type=hidden id="currentdate" name="currentdate" value="<%=currentdate%>"/>
<input type=hidden id="bywhat" name="bywhat" value="<%=bywhat%>"/>
<input type=hidden id="movedate" name="movedate" value="" />
<div style="overflow:auto;"> 
    <div id="calhead" class="calHd" style="height:36px;padding-left:0px;min-width:1000px !important;background-color: #f7f7f7;">
      		<div  id="firstButtons" style="margin-left:10px;float:left;min-width:40px !important;">
      			<div id="faddbtn" class="calHdBtn faddbtn" title="<%=SystemEnv.getHtmlLabelName( 18481 ,user.getLanguage())%>" style="border:none;height:25px;">
      			</div>
      			<div id="importbtn" class="calHdBtn importbtn" title="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())+SystemEnv.getHtmlLabelName(2211,user.getLanguage()) %>" style="margin-left:10px;border:none;height:25px;">
      			</div>
				<div class="rightBorder" style="margin-left:10px;margin-right:10px">|</div>
      		</div>
			<div id="editButtons2" style="float:left;min-width:60px !important;">
		      		  <%if(user.getLanguage()==8) {%>
      		    <div id="showdaybtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 27296 ,user.getLanguage())%>" class="calHdBtn     <% if(bywhat==4) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="margin-left:0px;width:30px;font-size: 15px;">
	      			D
	      		</div>
	      		<div id="showweekbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 1926 ,user.getLanguage())%> " class="calHdBtn   <% if(bywhat==3) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
	      			W
	      		</div>
	      		<div id="showmonthbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%>" class="calHdBtn   <% if(bywhat==2) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
	      			M
	      		</div>
      		    <%} else { %>
            	<div id="showdaybtn" unselectable="on" class="calHdBtn <% if(bywhat==4)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="margin-left:0px;width:30px;font-size: 15px;">
	      			<%=SystemEnv.getHtmlLabelName( 27296 ,user.getLanguage())%> 
	      		</div>
	      		<div id="showweekbtn" unselectable="on" class="calHdBtn <% if(bywhat==3)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
	      			<%=SystemEnv.getHtmlLabelName( 1926 ,user.getLanguage())%> 
	      		</div>
	      		<div id="showmonthbtn" unselectable="on" class="calHdBtn <% if(bywhat==2)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
	      			<%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%> 
	      		</div>
	      		<%} %>
					<div id="showreflashbtn" unselectable="on" class="calHdBtn showreflashbtn" title="<%=SystemEnv.getHtmlLabelName( 354 ,user.getLanguage())%>" style="height:24px;border:none;margin-left:10px;border:none;">
					</div>
				<div class="rightBorder" style="margin-left:10px;margin-right:15px">|</div>
               </div>
			   
			<div id="editButtons1" style="float:left;min-width:122px !important;">
					<% String titlestrnow=""; 
					if(bywhat==2) {
		      			titlestrnow =SystemEnv.getHtmlLabelName( 15541 ,user.getLanguage());
					}else if(bywhat==3){
						titlestrnow=SystemEnv.getHtmlLabelName( 15539 ,user.getLanguage());
					}else if(bywhat==4){
						titlestrnow=SystemEnv.getHtmlLabelName( 15537 ,user.getLanguage()); 
					}%>
					<div id="showtodaybtn" unselectable="on" class="calHdBtn showtodaybtn" title="<%=titlestrnow%>" style="height:24px;margin-left:0px;border:none;">
		      			 
		      		</div>
		      		<div id="sfprevbtn" unselectable="on" class="calHdBtn sfprevbtn" title="<%=SystemEnv.getHtmlLabelName( 33960 ,user.getLanguage()) %>"  style="height:24px;border:none;margin-left:10px;width:23px;_width:25px;">
		      		</div>
					<input type="hidden" name="txtshow" id="hdtxtshow" />
					<div id="txtdatetimeshow" unselectable="on" class="calHdBtn txtbtncls" style="border:none;width:auto;padding-left:1px;padding-right:10px;">
						
					</div>
		      		<div id="sfnextbtn" unselectable="on" class="calHdBtn sfnextbtn" title="<%=SystemEnv.getHtmlLabelName( 33961 ,user.getLanguage()) %>"  style="height:24px;border:none;border-left:none;width:23px;_width:25px;">
		      		</div>
		      		<div id="showModelbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 33963 ,user.getLanguage()) %>" val="0" class="calHdBtn calendarbtn" style="margin-left:0px;border:none;height:24px;">
					</div>
					
				</div>
      		 
			<div style="float:right;padding-right:5px;">
				<div style="float:left;margin-top: 5px;width:290px;">
					<select name="objType" id="objType" style="width:40px;float:left" onchange="changeType(this)"> 
				  		<option value="1" <%=objType==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %></option>
				  		<option value="2" <%=objType==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage()) %></option>
				  		<option value="3" <%=objType==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage()) %></option>
				  	</select>
				  	<div id="div1" name="showdiv" style="float:left;width:210px;margin-left:10px;">
					<!-- 部门 -->
					<brow:browser viewType="0" tempTitle='<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>' name="objId1" browserValue='<%=""+userDept%>'
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  
								completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
								browserSpanValue='<%=departmentComInfo.getDepartmentname(""+userDept) %>' _callback="CallBk" width="200px"></brow:browser>
					</div>
				  	<div id="div2" name="showdiv" style="display:none;float:left;width:210px;margin-left:10px;">
			  		 <!-- 分部 -->	
			  	     <brow:browser viewType="0" tempTitle='<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>' name="objId2" browserValue='<%=""+userSub %>'
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  
								completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
								browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(""+userSub) %>' _callback="CallBk" width="200px"></brow:browser>
					</div>
					<div id="div3" name="showdiv" style="display:none;float:left;width:210px;margin-left:10px;">
					<!-- 人力资源 -->
				    <brow:browser viewType="0" tempTitle='<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>' name="objId3" browserValue='<%=""+userId %>'
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  
								completeUrl="/data.jsp" linkUrl="/hrm/resource/HrmResource.jsp?id=" 
								browserSpanValue='<%=resourceComInfo.getLastname(""+userId) %>' width="200px" _callback="CallBk" ></brow:browser>
					</div>
					<input type="hidden" id="objIds" value="">
				</div>
				<div style="float:left;margin-top: 5px; width: 250px;">  	
					<span style="float:left;line-height:24px;margin-right:5px; width: 50px;white-space: nowrap;" title="<%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></span>
					<SELECT id="workPlanType" name="workPlanType" onchange="changeWorkPlanType()" style="width:80px">
						<OPTION value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
		  			<%
		  				RecordSet.executeSql("SELECT * FROM WorkPlanType WHERE 1=1 ORDER BY displayOrder ASC");
			  			while(RecordSet.next())
			  			{
			  		%>
			  			<OPTION value="<%= RecordSet.getInt("workPlanTypeID") %>"><%=Util.forHtml(RecordSet.getString("workPlanTypeName")) %></OPTION>
			  		<%
			  			}
			  		%>
			  		</SELECT>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(17416,user.getLanguage())%>" style="margin-left: 5px" class="e8_btn_top_first" onclick="exportExecl()">
				</div>
      		</div>
			 
      		
      </div>
	 <table class=MI id=AbsenceCard cellSpacing=0 cellPadding=0>
			<tr>
				<td style="BORDER-TOP: 0px; BORDER-LEFT: 0px;vertical-align: top;">
				<div id="tablediv" style="overflow: hidden;position: relative;">
					<div id="tableChlddiv">
						<input type="hidden" name="datenow" id="datenow" value="<%=datenow%>" />
					</div>
				</div>
				</td>
			</tr>
	</table>
	<iframe id="iframeExcelOut" style="display: none"></iframe>
</div>
</FORM>

<script language=javascript>
var DATA_EIDT_URL = "/workplan/data/WorkPlanEdit.jsp";
var DATA_VIEW_URL = "/workplan/data/WorkPlanDetail.jsp";
var isShare="<%=Util.null2String(request.getParameter("isShare"))%>";
var diag_vote;
jQuery(document).ready(function(){
	
	submit();
	var cBeginDate="<%=cBeginDate%>";
	var cEndDate="<%=cEndDate%>";
	var showtime = "";
	var titletime=""; 
	
	<% if(bywhat==2) {%>
		showtime = CalDateShowMonth(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));;
	<% }else if(bywhat==3){%>
	    showtime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), new Date(Date.parse(cEndDate.replace(/-/g,   "/"))));
	<% }else if(bywhat==4){%>
		showtime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));
	<%}%>
	
	//to show day view
   $("#showdaybtn").click(function(e) {
		changeShowType(this);
		ShowDay();
   });
   //to show week view
   $("#showweekbtn").click(function(e) {
		changeShowType(this);
		ShowWeek();
   });
   //to show month view
   $("#showmonthbtn").click(function(e) {
		changeShowType(this);
		ShowMONTH();
   });
   //refresh current View
   $("#showreflashbtn").click(function(e){
		submit();
   });
   
   $("#showModelbtn").click(function(e) {
       location.href='/workplan/data/WorkPlanView.jsp?isShare='+isShare;
   });
   $("#importbtn").click(function(e) {
		diag_vote = new Dialog();
		diag_vote.currentWindow = window;
		diag_vote.Width = 600;
		diag_vote.Height = 450;
		diag_vote.Modal = true;
		diag_vote.maxiumnable = false;
		diag_vote.checkDataChange = false;
		diag_vote.isIframe=false;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>";
		diag_vote.URL = "/workplan/config/import/WorkplanImport.jsp";
		diag_vote.show();
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
    
   //Add a new workplan
   $("#faddbtn").click(function(e) {
		var today=new Date();
   		var currentdate = dateFormat.call(today, i18n.xgcalendar.dateformat.fulldayvalue);
		var hours=today.getHours();
        var min=today.getMinutes();
     	 
		var data=["0",
                         "",
                         ""+currentdate,
                         ""+(hours>9?hours:"0"+hours)+":"+(min>9?min:"0"+min),
						 ""+currentdate,""];
       newWorkPlan(data);  	 
   });
   
   
   //显示时间控件 
   $("#hdtxtshow").datepickernew({ 
   	   picker: "#txtdatetimeshow", 
   	   showtarget: $("#txtdatetimeshow"),
	   onReturn:function(r){
	   		var d = CalDateShow(r);
	   		if(d && r){
	   			jQuery("#frmmain")[0].currentdate.value = dateFormat.call(r, i18n.xgcalendar.dateformat.fulldayvalue);
				$("#hdtxtshow").val(dateFormat.call(r, i18n.datepicker.dateformat.fulldayvalue));
				submit();
	    	}
	     } 
   });

   $("#txtdatetimeshow").text(showtime);
   
   jQuery(".e8_btn_top_first").hover(function(){
		jQuery(this).addClass("e8_btn_top_first_hover");
	},function(){
		jQuery(this).removeClass("e8_btn_top_first_hover");
	});
	$('#innerContentobjId3div').css("max-height","22px")
})
var enable = true;

function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	submit();
	try{
	diag_vote.close();
	}catch(e){};
}

function dataRfsh(){
	submit();
}
function CallBk(event,data,name,_callbackParams){
	submit();
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




function newWorkPlan(data){
	diag_vote = new Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width=600;
    diag_vote.Height=550;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>"; 
	diag_vote.URL = DATA_EIDT_URL+"?selectUser=<%=userid%>&planName="+data[1]+"&beginDate="+data[2]+"&beginTime="+data[3]+"&endDate="+data[4]+"&endTime="+data[5];
	diag_vote.show();
}

function View(id){
	diag_vote = new Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width=600;
    diag_vote.Height=550;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>"; 
	diag_vote.URL = DATA_VIEW_URL+"?workid="+id;
	diag_vote.show();
}

function closeDlgAndRfsh(){
	submit() ;
	diag_vote.close();
}

function refreshCal(){
	closeDlgAndRfsh();
}

function getSubdate() {
	$('#movedate').val("-1");
	submit() ;
}
function getSupdate() {
	$('#movedate').val("1");
	document.frmmain.movedate.value = "1" ;
	submit();
}
function ShowMONTH() {
	$('#bywhat').val("2");
	$('#currentdate').val("");
	submit();
}
function ShowWeek() {
	$('#bywhat').val("3");
	$('#currentdate').val("");
	submit();
}
function ShowDay() {
	$('#bywhat').val("4");
	$('#currentdate').val("");
	submit();
}
function changeWorkPlanType(){
	submit();
}

function submit(){
	hideRightClickMenu();
	forbiddenPage(); 
	$.post("/workplan/data/AjaxWorkPlanViewList.jsp",
		{	bywhat:$("#bywhat").val(),
			currentdate:$("#currentdate").val(),
			movedate:$("#movedate").val(),
			objType:$('#objType').val(),
			objIds:$('#objId'+$('#objType').val()).val(),
			workPlanType:$('#workPlanType').val()},
		function(datas){
			jQuery("#tableChlddiv").html("");
			jQuery("#tableChlddiv").append(datas);
			afterLoadDate();
			releasePage();
	});
}


function setWindowSize(bywhat){
	var $dv = $("#calhead"); 
	var _MH = document.documentElement.clientHeight;
	var dvH = $dv.height() + $dv.offset().top+10+2+18;
	if(bywhat==2){
		jQuery("#tableDataDiv").css("height",_MH - dvH);
	}else{
		jQuery("#tableDataDiv").css("height",_MH - dvH-18);
	}
	jQuery("#tablediv").css("width",$dv.width());
}


function exportExecl(){
	hideRightClickMenu();
	var bywhat=$("#bywhat").val();
	var	currentdate=$("#currentdate").val();
	var	objType=$("#objType").val();
	var	objIds=$('#objId'+$('#objType').val()).val();
	var	workType=$('#workPlanType').val();	
	document.getElementById("iframeExcelOut").src = "/workplan/data/AjaxWorkPlanViewListExcel.jsp?currentdate="+currentdate+"&bywhat="+bywhat+"&objType="+objType+"&objIds="+objIds+"&workPlanType="+workType;
}

function changeType(obj){
	$("div[name='showdiv']").hide();
	$("#div"+$(obj).val()).show();
	submit();
	
}

function forbiddenPage(){
	$("<div class=\"datagrid-mask\" style=\"position:fixed;z-index:2;opacity:0.4;filter:alpha(opacity=40);BACKGROUND-COLOR:#fff;\"></div>").css({display:"block",width:"100%",height:"100%",top:0,left:0}).appendTo("body");   
    $("<div class=\"datagrid-mask-msg\" style=\"background:#fff;position:fixed;z-index:3;padding: 10px;padding-top: 6px;padding-bottom: 6px;border: 1px solid;\"></div>").html("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});  
}  

function releasePage(){  
    $(".datagrid-mask,.datagrid-mask-msg").hide();  
}
</script>


</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</html>

