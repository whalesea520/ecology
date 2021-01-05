
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="mtr" class="weaver.meeting.Maint.MeetingForTypeReport" scope="page"/>
<jsp:useBean id="SptmForMeeting" class="weaver.splitepage.transform.SptmForMeeting" scope="page"/>

<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />

    <link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/workplan/calendar/css/dp_wev8.css" rel="stylesheet" type="text/css" />   
    <link href="/workplan/calendar/css/main_wev8.css" rel="stylesheet" type="text/css" /> 

<META http-equiv=Content-Type content="text/html; charset=UTF-8" />
<style type="text/css">
.selectable .ui-selecting { background: #FECA40;}
.selectable .ui-selected { background: #F39814; color: white; }
.selectable { list-style-type: none; margin: 0; padding: 0;cursor :pointer; }
</style>
<style type=text/css>
.fcurrent{
	background:#2e9eb2!important;
	color:white;
}
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
.MI TD {
	BORDER-TOP: 1px solid #d0d0d0; BORDER-LEFT: 1px solid #d0d0d0;
}
.MI {
	BORDER-RIGHT: 1px solid #d0d0d0; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; BORDER-BOTTOM: 1px solid #d0d0d0;min-width:900px !important;
}
.WE {
	BORDER-LEFT-WIDTH: 0px
}
.PI TD {
	BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: lightgrey 1px solid; BORDER-BOTTOM: 1px solid
}

.searchBox .searchInput{
	float:left;
	height:19px;
	border-right:none;
	width:170px;
	background:#fff;
}
.searchBox{
    margin-left:10px;
    margin-bottom:2px;
	background:#f7f7f7;
	line-height:23px;
	font-weight:bold;
	text-align:center;
	width:200px;
	height:23px;
	_height:25px;
	border:1px solid #d0d0d0;
	cursor:pointer;
	display:inline-block;
	float:left;
	opacity: 1;
}

.roomnames {
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		background:#f7f7f7;
		height:25px;
		cursor :pointer;
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

.room-selecting{
	background:#59b0f2;
}
.ui-selecting{
	background:#FECA40;
}

.mp-next,.mp-prev{
	cursor:pointer;color: #007aff!important;
	font-size: 13pt;font-weight:bold;
}
.mp-year{
	font-size: 13pt;
}
.mp-next:hover,.mbtn:hover, .mp-prev:hover,.mp-year:hover,.mp-year A:hover{
	color: #FFFFFF!important;
	background-color: #2690E3;
}
</style>

</head>
<%!
public String formatText(String str, int len){
	return str.length() > len?str.substring(0,len)+"...":str;
}
%>

<%

int userSub = user.getUserSubCompany1(); 
Calendar calendar = Calendar.getInstance();
boolean isUseMtiManageDetach=ManageDetachComInfo.isUseMtiManageDetach();
int detachable=0;
if(isUseMtiManageDetach){
	detachable=1;
   session.setAttribute("detachable","1");
   session.setAttribute("meetingdetachable","1");
}else{
	detachable=0;
   session.setAttribute("detachable","0");
   session.setAttribute("meetingdetachable","0");
}

    
char flag=2;
String userid=user.getUID()+"" ;

Calendar today = Calendar.getInstance();
int currentyear=today.get(Calendar.YEAR);

String sqlwhere = "";

ArrayList meetingTypeids = new ArrayList() ;
Map meetingTypenames = new HashMap() ;

int year = Util.getIntValue(request.getParameter("year"),currentyear);
String types = Util.null2String(request.getParameter("types"));
if(!"".equals(types)){
	sqlwhere += " and a.id in ("+types+") ";
}

String sql = "select a.id, a.name from Meeting_Type a where 1=1 " +  MeetingShareUtil.getTypeShareSql(user) + sqlwhere + " order by id";
//System.out.println("sql2233:"+sql);
RecordSet.executeSql(sql);
while(RecordSet.next()){
    String tmpmeetingroomid=RecordSet.getString(1);
    String tmpmeetingroomname=RecordSet.getString(2);
    meetingTypeids.add(tmpmeetingroomid) ;
    meetingTypenames.put(tmpmeetingroomid, tmpmeetingroomname) ;
}

mtr.setYear(year);

Map dataMap = mtr.getReportDate();

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15881,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow-y: hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(2104,user.getLanguage())+",javascript:onShowMeetingTypeAll(event),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:getMeetingInfo(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:outputexcel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="meeting"/>
   <jsp:param name="navName" value=""/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%>"  class="e8_btn_top middle" onclick="onShowMeetingTypeAll(event);"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName( 354 ,user.getLanguage())%>"  class="e8_btn_top middle" onclick="getMeetingInfo();" />
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage())%>" class="e8_btn_top middle" onclick="outputexcel();"/>	

			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<FORM id=frmmain name=frmmain method=post action="MeetingForTypeRpt.jsp">
<input  type="hidden" id="year" name="year" value="<%=year %>" />
<input type="hidden" id="oldyear" name="oldyear" value="<%=year %>" />
<input class=inputstyle type="hidden" id="types" name="types" value="<%=types %>" />
 <div id="tablediv" style="overflow-y: hidden;position: relative;">
	  <div id="tableChlddiv">
  <table class=MI id=AbsenceCard  cellSpacing=0 cellPadding=0>
		<tr>	
			<td style="BORDER-TOP: 0px; BORDER-LEFT: 0px;">
				<table width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
				    <tr  bgcolor="#f7f7f7"  >
						<td width=28% style="border-bottom:1px solid #59b0f2"  height="25px" align=center >
						<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%>
						</td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;" align="center"><%=SystemEnv.getHtmlLabelName(1492,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1493,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1494,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1495,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1496,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1497,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1498,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1499,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1800,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1801,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1802,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1803,user.getLanguage())%></td>
				    </tr>
				   <% 			
				    for(int k=0;k<meetingTypeids.size();k++){
				        int tmptypeid=Util.getIntValue(meetingTypeids.get(k)==null?"-1":meetingTypeids.get(k).toString());
				        if(tmptypeid == -1) continue;
				        String tmpname = meetingTypenames.get(String.valueOf(tmptypeid)) == null?" ":meetingTypenames.get(String.valueOf(tmptypeid)).toString();
				   %>
				        <tr class="selectable">
							<%if(k==0) {%>
					            <td class="roomnames" style="BORDER-TOP: 0px" width=28% title="<%=tmpname%>" >&nbsp;<%=Util.forHtml(Util.toScreen(tmpname,user.getLanguage()))%></td>
					        <%}else{%>
								<td class="roomnames" width=28% title="<%=tmpname%>" >&nbsp;<%=Util.forHtml(Util.toScreen(tmpname,user.getLanguage()))%></td>
							<%}%>
							<%					        
					       
			            	if (!dataMap.containsKey(tmptypeid) || dataMap.get(tmptypeid) == null) { 
			            		for (int p=0 ;p<12;p++) {
			            			if(k==0) {
			            				out.println("<td  style=\"color:#fff;BORDER-TOP: 0px\" >&nbsp;</td>");
			            			}else{
			            				out.println("<td  style=\"color:#fff\" >&nbsp;</td>");
			            			}
			            		}
			            		continue;
			            	};	
			            	Integer[] dataArry = (Integer[])dataMap.get(tmptypeid);
			            	for(int i = 0; i < 12; i++){
			            		int dt = dataArry[i];
			            		if(dt > 0){
			            		 %>
									<%if(k==0) {%>
										<td bgcolor="#fdfbfa" style="BORDER-TOP: 0px" align=center onclick="showTypeMeetingList(<%=year %>,<%=i+1 %>,<%=tmptypeid %>,event)" ><%=dt %></td>
									<%}else{%>
										<td bgcolor="#fdfbfa" align=center onclick="showTypeMeetingList(<%=year %>,<%=i+1 %>,<%=tmptypeid %>,event)" ><%=dt %></td>
									<%}%>
								<%
					        	} else {
					        	%>
									<%if(k==0) {%>
										<td bgcolor="#fdfbfa" style="BORDER-TOP: 0px" align=center >&nbsp;</td>
									<%}else{%>
										<td bgcolor="#fdfbfa" align=center >&nbsp;</td>
									<%}%>
					        	<%
					        	}
			            	}
			            	%>
						</tr>
				<%}%>
			</table>
		</td>
	</tr>
</table>
</div>
</div>
</FORM>
	<!-- next show meeting use list-->
	<div id="MeetingListDiv" style="display:none;">
		<IFRAME name="listframe" id="listframe"  width="100%" frameborder=no scrolling=no>
		</IFRAME>
	</div>
  
<div style="height:10px"></div>
<div id="excelwaitDiv" style="position:absolute;top:0;left:0;z-index:100;display:none;height:100%;width:100%">
	<table name="scrollarea" width="100%" height="100%" style="display:inline;zIndex:-1" >
		<tr>
			<td align="center" valign="center" >
				<fieldset style="width: 200px; height: 30px;background:#Fff;">
					<img src="/images/loading2_wev8.gif"><span id="excelMsgSpan"><%=SystemEnv.getHtmlLabelName(26692,user.getLanguage())%></span></fieldset>
			</td>
		</tr>
	</table>
</div>
<div id="yearSelectDiv" style="position:absolute;display:none;top:40px;left:10px;z-index:9999;height:180px;width:68px;BORDER: 1px solid #d0d0d0;background:#fff;">
	<input type="hidden" class="crrentyear" value="2014" />
	<table class="WdayTable" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tbody>
			<tr>
				<td class="mbtn"><a href="javascript:void(0);" class="mp-prev">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a></td>
			</tr>
			<tr>
				<td class="mp-year" xyear="2012"><a href="javascript:void(0);">&nbsp;&nbsp;2012</a></td>
			</tr>
			<tr>
				<td class="mp-year" xyear="2013"><a href="javascript:void(0);">&nbsp;&nbsp;2013</a></td>
			</tr>
			<tr>
				<td class="mp-year" xyear="2014"><a href="javascript:void(0);">&nbsp;&nbsp;2014</a></td>
			</tr>
			<tr>
				<td class="mp-year" xyear="2015"><a href="javascript:void(0);">&nbsp;&nbsp;2015</a></td>
			</tr>
			<tr>
				<td class="mp-year" xyear="2016"><a href="javascript:void(0);">&nbsp;&nbsp;2016</a></td>
			</tr>
			<tr>
				<td class="mbtn"><a href="javascript:void(0);" class="mp-next">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a></td>
			</tr>
		</tbody>
	</table>
</div>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</div>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script language=javascript>
var diag_vote;
jQuery(document).ready(function(){
	
	//$("#listframe").attr("src","GetRoomMeetingList.jsp");

    //refresh current View
    
   $("#showreflashbtn").click(function(e){
		//document.frmmain.submit();
		getMeetingInfo();
   });
   $("#objName").html("<span id=\"yearsp\" style=\"color: #007aff!important;width:50px;BORDER-bottom: 1px solid #007aff;\"><%=year %></span><%=SystemEnv.getHtmlLabelName(32592,user.getLanguage())%> ");
   setWindowSize(document);
})


function showTypeMeetingList(year,month,typeid,event){
	this.roomid = "";
	var selected = false;
	event = jQuery.event.fix(event);
	var startElement = event.target;
	if(jQuery(startElement).hasClass("room-selecting")){
		jQuery(startElement).removeClass("room-selecting");
		jQuery("#tablediv").height(jQuery("#tablediv").height() + $("#MeetingListDiv").height());
		$("#MeetingListDiv").hide();
		//$("#listframe").attr("src","GetTypeMeetingList.jsp?year="+year+"&month="+month+"&type="+typeid);
	} else{
		$(".room-selecting").each(function(){
			$(this).removeClass("room-selecting");
		});
		this.roomid = startElement.id;
		jQuery(startElement).addClass("room-selecting");
		$("#MeetingListDiv").show();
		$("#listframe").attr("src","GetTypeMeetingList.jsp?year="+year+"&month="+month+"&type="+typeid);
	}
	
}

function setWindowSize(_document){
	if(!!_document)_document = document;
	var bodyheight = _document.body.offsetHeight;
	var listframeh = jQuery("#listdiv",window.frames["listframe"].document).height() + 10;
	//listframeh = 305;
	jQuery("#listframe").height(listframeh);
	var bottomheight = listframeh+2;
	jQuery("#MeetingListDiv").height(listframeh+2);
	
	if(bottomheight>0){
		bottomheight = 51 + bottomheight;
	}
	
	var tdh = jQuery(".MI").height();
	var cah = bodyheight-bottomheight-15;
	jQuery("#tablediv").css("height",tdh > cah ? cah:tdh+2);
	jQuery("#tablediv").perfectScrollbar();
}

function outputexcel() {
	var pTop= document.body.offsetHeight/4+document.body.scrollTop-100;
	excelwaitDiv.style.display = "block";
	
	excelwaitDiv.style.top = pTop;    
    var excelOutForm = document.getElementById("ExcelOut").contentWindow.document.createElement("form");
    document.getElementById("ExcelOut").contentWindow.document.body.appendChild(excelOutForm);
    var types = $("#types").val();
    var crrentyear = $(".crrentyear").val();
    excelOutForm.action = "/meeting/report/MeetingForTypeRptOutExcel.jsp?year="+crrentyear+"&types="+types;
    excelOutForm.method = "POST";
    excelOutForm.submit();
}

</script>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
</html>
<script language=javascript>
function yearChanged(){
	var year = $("#year").val();
	var oldyear = $("#oldyear").val();
	if(oldyear != year){
	 	//document.frmmain.submit();
		getMeetingInfo();
		$("#oldyear").val(year);
	 }
}

function meetingChangedCbk(datas){
	callBackValue(datas,"meetingtypespan","types");
	getMeetingInfo();
}


function meetingChanged(event,datas,name){
	
	getMeetingInfo();
}

$(function(){
	$("#yearSelectDiv .crrentyear").val($("#year").val());
	
	$(".WdayTable .mp-year").live("click",function(e){
		$("#yearsp").html($(this).attr("xyear"));
		$("#year").val($(this).attr("xyear"));
		$("#yearSelectDiv .crrentyear").val($(this).attr("xyear"));
		$("#yearSelectDiv").hide("slow",function() {$("*").unbind("click.yearPicker_1");});
		yearChanged();
	});
   
	$("#yearsp").click(function(e){
		var crrtyear = parseInt($("#yearSelectDiv .crrentyear").val());
		if(crrtyear == "NaN"){
			var date=new Date;
			crrtyear=parseInt(date.getFullYear()); 
		}
		rryear(crrtyear);
		setpos(this);
		$("#yearSelectDiv").show("slow");
		$("*").bind("click.yearPicker_1", function(e) {
			if($(e.target).hasClass("mbtn") || $(e.target).hasClass("mp-next") || $(e.target).hasClass("mp-prev") || $(e.target).hasClass("mp-year") || $(e.target).parent().hasClass("mp-year")){
				
			} else {
				if($("#yearSelectDiv").css("display") != "none"){
					$("#yearSelectDiv").hide("slow",function() {$("*").unbind("click.yearPicker_1");});
					$("#yearSelectDiv .crrentyear").val($("#year").val());
				}
			}
		});
		return false;
	});
   
   
   
	$(".WdayTable .mp-next").live("click",function(e){
		nextyear();
	});
   
	$(".WdayTable .mp-prev").live("click",function(e){
		prevyear();
	});
   
});

function setpos(obj){
	var t =  $(obj);
	var cp = $("#yearSelectDiv");
	var pos = t.offset();
	

	var height = t.outerHeight();
	var newpos = { left: pos.left, top: pos.top + height };
	var w = cp.width();
	var h = cp.height();
	var bw = document.documentElement.clientWidth;
	var bh = document.documentElement.clientHeight;
	if ((newpos.left + w) >= bw) {
		newpos.left = bw - w - 2;
	}
	if ((newpos.top + h) >= bh) {
		newpos.top = pos.top - h - 2;
	}
	if (newpos.left < 0) {
		newpos.left = 10;
	}
	if (newpos.top < 0) {
		newpos.top = 10;
	}
	newpos.visibility = "visible";
	cp.css(newpos);
}

function nextyear(){
	var crrtyear = parseInt($("#yearSelectDiv .crrentyear").val());
	if(crrtyear == "NaN"){
		var date=new Date;
		crrtyear=parseInt(date.getFullYear()); 
	}
	rryear(crrtyear + 1);
	$("#yearSelectDiv .crrentyear").val(crrtyear + 1);
}
function prevyear(){
	var crrtyear = parseInt($("#yearSelectDiv .crrentyear").val());
	if(crrtyear == "NaN"){
		var date=new Date;
		crrtyear=parseInt(date.getFullYear()); 
	}
	rryear(crrtyear - 1);
	$("#yearSelectDiv .crrentyear").val(crrtyear - 1);
}

function rryear(y) {
	var s = y - 2;
	var ar = [];
	for (var i = 0; i < 5; i++) {
		ar.push(s + i);
	}
	$(".WdayTable td.mp-year").each(function(i) {
		//if (y == ar[i]) {
		//	$(this).addClass("mp-sel");
		//}
		$(this).html("<a href='javascript:void(0);'>&nbsp;&nbsp;" + ar[i] + "</a>").attr("xyear", ar[i]);
	});
}

function getMeetingInfo(){
	var pTop= document.body.offsetHeight/4+document.body.scrollTop-100;
	excelwaitDiv.style.display = "block";
	excelwaitDiv.style.top = pTop;
	$.post("/meeting/report/AjaxMeetingForTypeRpt.jsp",{year:$GetEle("year").value,types:$GetEle("types").value},function(datas){
		jQuery("#tableChlddiv").html("");
		jQuery("#tableChlddiv").append(datas);
		excelwaitDiv.style.display = "none";
		jQuery("#tablediv").height(jQuery("#tablediv").height() + $("#MeetingListDiv").height());
		$("#MeetingListDiv").hide();
	});
}

function onShowMeetingTypeAll(spanname,inputname,isMuti, ismand,callbkfun) {
	  var tmpids = jQuery("#"+inputname).val();
	  linkurl="";
	  var url = "";
	  if(isMuti == 0){
		url = "/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingTypeBrowser.jsp";
	  } else {
		url = "/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MutiMeetingTypeBrowser.jsp";
	  }
	  showBrwDlg(url, "forall=1&resourceids=" + tmpids, 500,570,spanname,inputname,callbkfun);
}

function onShowMeetingTypeAll(objevent){
	var tmpids = jQuery("#types").val();
    showModalDialogForBrowser(objevent,'/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MutiMeetingTypeBrowser.jsp?resourceids='+tmpids,'/meeting/Maint/ListMeetingType.jsp?id=#id#','types',false,1,'',{name:'types',hasInput:true,zDialog:true,needHidden:true,dialogTitle:'',arguments:'',_callback:meetingTypeCallBk});
}

function meetingTypeCallBk(event,data,name,_callbackParams){
	if(data){
	    if(data.id!="") {
			$("#types").val(data.id);
		}else{
			$("#types").val("");
		}
		getMeetingInfo();
   }
}
</script>
