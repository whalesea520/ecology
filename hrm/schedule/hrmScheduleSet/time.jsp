<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-20[排班设置] Generated from 长东设计 www.mfstyle.cn -->
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(16695, user.getLanguage());
	int cp = strUtil.parseToInt(request.getParameter("cp"), 0);
	boolean showResource = cp == 1;
	boolean canSearch = HrmUserVarify.checkUserRight("HrmScheduling:set", user);
	if(!canSearch && !showResource) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String jsName = user.getLanguage() == 8 ? "US" : (user.getLanguage() == 9 ? "HK" : "ZH");
	String resourceId = strUtil.vString(request.getParameter("resourceId"), String.valueOf(user.getUID()));
	String resourceName = Util.toScreen(ResourceComInfo.getResourcename(resourceId), user.getLanguage());
	titlename = showResource ? (resourceName + SystemEnv.getHtmlLabelNames("18946,33604", user.getLanguage())) : titlename;
	String field004Param = strUtil.vString(request.getParameter("field004"), strUtil.vString(request.getParameter("subcompanyid")));
	String allIds = "";
	if(!user.getLoginid().equalsIgnoreCase("sysadmin") && strUtil.vString(detachCommonInfo.getDetachable()).equals("1")) {
		int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "HrmScheduling:set");
		StringBuffer sIds = new StringBuffer();
		for(int i=0;i<subCompany.length;i++) sIds.append(sIds.length()==0?"":",").append(subCompany[i]);
		allIds = strUtil.vString(sIds.toString(), "-99999");
	}
	int field004 = strUtil.parseToInt(field004Param, 0);
	int bywhat = strUtil.parseToInt(request.getParameter("bywhat"), 2);
	int inNum = strUtil.parseToInt(request.getParameter("inNum"));
	String currentdate = strUtil.vString(request.getParameter("currentdate"));
	String movedate = strUtil.vString(request.getParameter("movedate"));
	String sId = strUtil.getURLDecode(request.getParameter("sId"));
	String field001 = strUtil.getURLDecode(request.getParameter("field001"));
	String startDate = strUtil.getURLDecode(request.getParameter("startDate"));
	String endDate = strUtil.getURLDecode(request.getParameter("endDate"));
	String defaultStartDate = startDate;
	String defaultEndDate = endDate;
	
	Calendar today = strUtil.isNull(currentdate) ? Calendar.getInstance() : dateUtil.getCalendar(currentdate);
	int currentyear = today.get(Calendar.YEAR);
	int currentmonth = today.get(Calendar.MONTH);
	int currentday = today.get(Calendar.DATE);
	String cBeginDate="";
	String cEndDate="";
	String datenow = "";
	switch(bywhat) {
	case 1:
		today.set(currentyear, 0, 1);
		if(movedate.equals("1")) today.add(Calendar.YEAR, 1);
		else if(movedate.equals("-1")) today.add(Calendar.YEAR, -1);
		
		cBeginDate = dateUtil.getFirstDayOfYear(today.getTime());
		cEndDate = dateUtil.getLastDayOfYear(today.getTime());
		datenow = dateUtil.getYear(today);
		break ;
	case 2:
		today.set(currentyear, currentmonth, 1) ;
		if(movedate.equals("1")) today.add(Calendar.MONTH, 1);
		else if(movedate.equals("-1")) today.add(Calendar.MONTH, -1);
		
		cBeginDate = dateUtil.getFirstDayOfMonthToString(today.getTime());
		cEndDate = dateUtil.getLastDayOfMonthToString(today.getTime());
		datenow = dateUtil.getCalendarDate(today, "yyyy-MM");
		break ;
	case 3:
		if(movedate.equals("1")) today.add(Calendar.WEEK_OF_YEAR, 1);
		else if(movedate.equals("-1")) today.add(Calendar.WEEK_OF_YEAR, -1);
		
		cBeginDate = dateUtil.getFirstWeekDateToString(today.getTime());
		cBeginDate = dateUtil.addDate(cBeginDate, -1);
		cEndDate = dateUtil.getLastWeekDateToString(today.getTime());
		cEndDate = dateUtil.addDate(cEndDate, -1);
		datenow = dateUtil.getCalendarDate(today);
		break;
	case 4:
		if(movedate.equals("1")) today.add(Calendar.DATE, 1);
		else if(movedate.equals("-1")) today.add(Calendar.DATE, -1);
		
		cBeginDate = cEndDate = dateUtil.getCalendarDate(today);
		datenow = dateUtil.getCalendarDate(today);
		break;
	}
	currentdate = dateUtil.getCalendarDate(today);
%>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
		<link type="text/css" rel="stylesheet" href="/workplan/calendar/css/calendar_wev8.css" /> 
		<link type="text/css" rel="stylesheet" href="/workplan/calendar/css/dp_wev8.css" />   
		<link type="text/css" rel="stylesheet" href="/workplan/calendar/css/main_wev8.css" /> 
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/schedule.css" /> 
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
		<script type="text/javascript" src="/meeting/calendar/src/Plugins/jquery.datepickernew_wev8.js"></script>
		<script type="text/javascript" src="/meeting/calendar/src/Plugins/datepicker_lang_<%=jsName%>_wev8.js"></script> 
		<script type="text/javascript" src="/meeting/calendar/src/Plugins/wdCalendar_lang_<%=jsName%>_wev8.js"></script>  
		<script type="text/javascript" src="/meeting/calendar/src/Plugins/jquery.calendar_wev8.js"></script>   
		<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript">
			var common = new MFCommon();
			var dialog = null;
			var inNum = "<%=inNum%>";
			var bywhat = "<%=bywhat%>";
			var cBeginDate = "<%=cBeginDate%>";
			var cEndDate = "<%=cEndDate%>";
			var field004 = "<%=field004%>";
			var $showResource = "<%=showResource%>";
			var $resourceId = "<%=resourceId%>";
			var $uId = "<%=user.getUID()%>";
			
			try{parent.setTabObjName("<%=titlename%>");}catch(e){}

			function onBtnSearchClick() {
				jQuery("#searchfrm").submit();
			}

			function closeDialog() {
				if(dialog) dialog.close();
			}
			
			function jsSubmit(e, datas, name){
				if(datas.id && datas.name) onBtnSearchClick();
			}

			function showContent(startDate, endDate, bw, sId, field001) {
				if($showResource == "true") return;
				closeDialog();
				if(!startDate) startDate = cBeginDate;
				if(!endDate) endDate = cEndDate;
				
				if(!sId) {
					$("#groupDiv").hide();
					common.initDialog({width:800, height:500, showMax:true, closeEvent:null ,_callBack:null});
					dialog = common.showDialog("/hrm/schedule/hrmScheduleSet/tab.jsp?topage=content&cmd=time&startDate="+startDate+"&endDate="+endDate, "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>");
				} else {
					if(!bw) bw = bywhat;
					if(bw == 2) {
						common.initDialog({width:800, height:500, showMax:true, checkDataChange:false, closeEvent:function(){submit();}, _callBack:null});
						dialog = common.showDialog(encodeURI("/hrm/schedule/hrmScheduleSet/tab.jsp?topage=detail&sId="+sId+"&field001="+field001+"&startDate="+startDate+"&endDate="+endDate), "<%=SystemEnv.getHtmlLabelName(125840,user.getLanguage())%>");
					} else {					
						$GetEle("sId").value = sId;
						$GetEle("field001").value = field001;
						$GetEle("startDate").value = startDate;
						$GetEle("endDate").value = endDate;
						submit();
					}
				}
			}
			
			function closeAndSubmit() {
				closeDialog();
				$GetEle("sId").value = "";
				submit();
			}
			
			function showDatas(datas) {
				var result = common.getDialogReturnValue(datas);
				var sId = $GetEle("sId").value;
				var startDate = $GetEle("startDate").value;
				var endDate = $GetEle("endDate").value;
				common.ajax("/hrm/schedule/hrmScheduleSetPerson/save.jsp?cmd=mInsert&sId="+sId+"&startDate="+startDate+"&endDate="+endDate+"&field001=0&field002="+result.id, false, function(result){
					$GetEle("startDate").value = "<%=defaultStartDate%>";
					$GetEle("endDate").value = "<%=defaultEndDate%>";
					submit();
				});
			}
			
			function doAdd(id) {
				id = id && id != "" ? id : "";
				closeDialog();
				common.initDialog({width:650, height:600, showMax:false, closeEvent:null, _callBack:showDatas});
				dialog = common.showDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MultiResourceBrowser.jsp?show_virtual_org=-1&resourceids=", "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>");
			}
			
			function doDel(id) {
				if(!id) id = _xtable_CheckedCheckboxId();
				if(!id) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)) id = id.substring(0,id.length-1);
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function() {
					common.ajax("/hrm/schedule/hrmScheduleSetDetail/save.jsp?cmd=delete&ids="+id, false, function(result){
						$GetEle("sId").value = "";
						submit();
					});
				});
			}
			
			function ShowYear() {
				$GetEle("bywhat").value = "1";
				$GetEle("currentdate").value = "";
				$GetEle("sId").value = "";
				submit();
			}
			
			function ShowMonth(cDate) {
				$GetEle("bywhat").value = "2";
				$GetEle("currentdate").value = !cDate ? "" : cDate;
				$GetEle("sId").value = "";
				submit();
			}
			
			function ShowWeek() {
				$GetEle("bywhat").value = "3";
				$GetEle("currentdate").value = "";
				$GetEle("sId").value = "";
				submit();
			}
			
			function ShowDay() {
				$GetEle("bywhat").value = "4";
				$GetEle("currentdate").value = "";
				$GetEle("sId").value = "";
				submit();
			}
			
			jQuery(document).ready(function(){
				var showtime = "";
				var titletime=""; 
				loadContent();
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
				
				
			  $("#showdaybtn").click(function(e) {
					changeShowType(this);
					$("#txtdatetimeshow").attr("selectMode", '0');
					ShowDay();
			   });
			   
			   $("#showweekbtn").click(function(e) {
					changeShowType(this);
					$("#txtdatetimeshow").attr("selectMode", '0');
					ShowWeek();
			   });
			   
			   $("#showmonthbtn").click(function(e) {
					changeShowType(this);
					$("#txtdatetimeshow").attr("selectMode", '1');
					ShowMonth();

			   });
			   $("#showyearbtn").click(function(e) {
					changeShowType(this);
					$("#txtdatetimeshow").attr("selectMode", '1');
					ShowYear();

			   });
			   
			   $("#showreflashbtn").click(function(e){
					$GetEle("sId").value = "";
					submit();
			   });
			  
			   $("#showtodaybtn").click(function(e) {
					$GetEle("currentdate").value = "";
					$GetEle("sId").value = "";
					submit();
			   });
			   
			   $("#sfprevbtn").click(function(e) {
				  getSubdate();

			   });
			   
			   $("#sfnextbtn").click(function(e) {
				  getSupdate();
			   });
			   
			   $("#namebtn").live("click", function() {
					$GetEle("sId").value = "";
					submit();
			   });   
			   
			   $("#hdtxtshow").datepickernew({ 
				   picker: "#txtdatetimeshow", 
				   showtarget: $("#txtdatetimeshow"),
				   onReturn:function(r){
						var d = CalDateShow(r);
						if(d && r){
							$GetEle("currentdate").value = dateFormat.call(r, i18n.xgcalendar.dateformat.fulldayvalue);
							$GetEle("sId").value = "";
							submit();
							$("#hdtxtshow").val(dateFormat.call(r, i18n.datepicker.dateformat.fulldayvalue));
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
			});
			
			function loadContent() {
				var $dv = $("#calhead");
				var _MH = document.documentElement.clientHeight;
				var dvH = $dv.height() + $dv.offset().top + 10 + 2 + 5;
				var defaultHeight = _MH - dvH;
				
				common.post({"cmd":"showCalendar", "B":bywhat, "S":cBeginDate, "E":cEndDate, "D":defaultHeight, "R":$showResource, "M":$resourceId, "U":$uId, "C":field004}, function(result) {
					$("#gridcontainer").html(result.content);
					
					var $mv = $("#mvEventContainer");
					var dvM = $mv.height() + $mv.offset().top + 10;
					$("#groupDiv").css("top", dvM+"px");
					
				}, "/hrm/schedule/hrmScheduleSet/save.jsp");
			}
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
					"L": __MonthName[this.getMonth()]
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
				$GetEle("movedate").value = "-1";
				$GetEle("sId").value = "";
				submit() ;
			}
			
			function getSupdate() {
				$GetEle("movedate").value = "1";
				$GetEle("sId").value = "";
				submit();
			}

			function submit(){
				onBtnSearchClick();
			}

		</script>
	</head>
	<body style="overflow:auto">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			TopMenu topMenu = new TopMenu(out, user);
			if(!showResource) topMenu.add(SystemEnv.getHtmlLabelName(125836,user.getLanguage()), "showContent()");
			RCMenu += topMenu.getRightMenus();
			RCMenuHeight += RCMenuHeightStep * topMenu.size();
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form id="searchfrm" name="searchfrm" action="">
			<input type="hidden" id="cp" name="cp" value="<%=cp%>">
			<input type="hidden" id="sId" name="sId" value="<%=sId%>">
			<input type="hidden" id="startDate" name="startDate" value="<%=startDate%>">
			<input type="hidden" id="endDate" name="endDate" value="<%=endDate%>">
			<input type="hidden" id="field001" name="field001" value="<%=field001%>">
			<input type="hidden" id="field004" name="field004" value="<%=field004%>">
			<input type="hidden" id="currentdate" name="currentdate" value="<%=currentdate%>">
			<input type="hidden" id="bywhat" name="bywhat" value="<%=bywhat%>">
			<input type="hidden" id="movedate" name="movedate" value="">
			<input type="hidden" id="inNum" name="inNum" value="1">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%topMenu.show();%>
						<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div id="calhead" class="calHd" style="height:36px;padding-left:0px;min-width:900px !important;background-color: #f7f7f7;">
				<%if(showResource){%>
				<div id="editButtons2" style="float:left;margin-left:5px;min-width:170px;border:none;height:24px;">
					<div id="rContent" unselectable="on" title="" class="calHdBtn txtbtncls" style="border-left:none;width:230px;font-size:12px;">
						<table width="100%">
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%>&nbsp;:&nbsp;</td>
							<td>						
								<brow:browser viewType="0"  name="resourceId" browserValue='<%=resourceId%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
								hasInput='<%=String.valueOf(canSearch)%>' isSingle="true" hasBrowser = "true" isMustInput='<%=canSearch?"1":"0"%>'
								completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="150px"
								_callback="jsSubmit"
								browserSpanValue='<%=resourceName%>'>
								</brow:browser>
							</td>
						</table>
					</div>
					<div class="rightBorder" style="margin-left:10px;margin-right:10px">|</div>
				</div>
				<%}%>
				<div id="editButtons2" style="float:left;min-width:60px !important;">
					<%if(user.getLanguage()==9) {%>
					<div id="showyearbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName(445, user.getLanguage())%>" class="calHdBtn <% if(bywhat==1) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
						Y
					</div>
					<div id="showmonthbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName(6076, user.getLanguage())%>" class="calHdBtn <% if(bywhat==2) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
						M
					</div>
					<div id="showweekbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName(1926, user.getLanguage())%> " class="calHdBtn <% if(bywhat==3) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
						W
					</div>
					<div id="showdaybtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName(27296, user.getLanguage())%>" class="calHdBtn <% if(bywhat==4) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="margin-left:0px;width:30px;font-size: 15px;">
						D
					</div>
					<%} else {%>
					<div id="showyearbtn" unselectable="on" class="calHdBtn <% if(bywhat==1) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
						<%=SystemEnv.getHtmlLabelName(445, user.getLanguage())%> 
					</div>
					<div id="showmonthbtn" unselectable="on" class="calHdBtn <% if(bywhat==2) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
						<%=SystemEnv.getHtmlLabelName(6076, user.getLanguage())%> 
					</div>
					<div id="showweekbtn" unselectable="on" class="calHdBtn <% if(bywhat==3) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
						<%=SystemEnv.getHtmlLabelName(1926, user.getLanguage())%> 
					</div>
					<div id="showdaybtn" unselectable="on" class="calHdBtn <% if(bywhat==4) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="margin-left:0px;width:30px;font-size: 15px;">
						<%=SystemEnv.getHtmlLabelName(27296, user.getLanguage())%> 
					</div>
					<%}%>
					<div id="showreflashbtn" unselectable="on" class="calHdBtn showreflashbtn" title="<%=SystemEnv.getHtmlLabelName(354, user.getLanguage())%>" style="height:24px;border:none;margin-left:10px;border:none;"></div>
					<div class="rightBorder" style="margin-left:10px;margin-right:15px">|</div>
				</div>
				<div id="editButtons1" style="float:left;min-width:122px !important;">
					<%
						String titlestrnow = ""; 
						if(bywhat == 1) {
							titlestrnow = SystemEnv.getHtmlLabelName(15384, user.getLanguage());
						} else if(bywhat == 2) {
							titlestrnow = SystemEnv.getHtmlLabelName(15541, user.getLanguage());
						} else if(bywhat == 3) {
							titlestrnow = SystemEnv.getHtmlLabelName(15539, user.getLanguage());
						} else if(bywhat == 4) {
							titlestrnow = SystemEnv.getHtmlLabelName(15537, user.getLanguage()); 
						}
					%>
					<div id="showtodaybtn" unselectable="on" class="calHdBtn showtodaybtn" title="<%=titlestrnow%>" style="height:24px;margin-left:0px;border:none;"></div>
					<div id="sfprevbtn" unselectable="on" class="calHdBtn sfprevbtn" title="<%=SystemEnv.getHtmlLabelName(33960,user.getLanguage())%>"  style="height:24px;border:none;margin-left:10px;width:23px;_width:25px;"></div>
					<input type="hidden" name="txtshow" id="hdtxtshow" />
					<div id="txtdatetimeshow" unselectable="on" class="calHdBtn txtbtncls" style="border:none;width:auto;padding-left:1px;padding-right:10px;"></div>
					<div id="sfnextbtn" unselectable="on" class="calHdBtn sfnextbtn" title="<%=SystemEnv.getHtmlLabelName(33961,user.getLanguage())%>"  style="height:24px;border:none;border-left:none;width:23px;_width:25px;"></div>
				</div>
			</div>
			<div id="calContent" style="min-width:920px !important;border:none;vertical-align:top;">
				<div id="dvCalMain" class="calmain printborder" style="position:relative">
					<div id="gridcontainer" style="overflow:visible;visibility:visible;height:100%;border-top:#d0d0d0 1px solid;"></div>
				</div> 
			</div>
			<div id="groupDiv" style="overflow:hidden;position:absolute;left:0;width:100%;bottom:0;display:<%=sId.length() > 0 ? "" : "none"%>">
				<wea:layout type="2col">
					<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
						<wea:item attributes="{'samePair':'field001Item'}"><%=SystemEnv.getHtmlLabelNames("33604,740",user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field001Item'}">
							<button class="Calendar" type="button" id="field001Date" onclick="getDate(field001Span, startDate)"></button>
							<span id="field001Span"><%=startDate%></span>
						</wea:item>
						<wea:item attributes="{'samePair':'field002Item'}"><%=SystemEnv.getHtmlLabelNames("33604,741",user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field002Item'}">
							<button class="Calendar" type="button" id="field002Date" onclick="getDate(field002Span, endDate)"></button>
							<span id="field002Span"><%=endDate%></span>
						</wea:item>
						<wea:item attributes="{'samePair':'field003Item'}"><%=SystemEnv.getHtmlLabelName(24803,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field003Item'}">
							<span id="field003Span"><%=field001%></span>
						</wea:item>
					</wea:group>
					<wea:group context="<%=SystemEnv.getHtmlLabelName(125839,user.getLanguage())%>">
						<wea:item type="groupHead">
							<img class="toolpic additem" style="vertical-align:middle;margin-right:5px" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" accesskey="" src="/wui/theme/ecology8/weaveredittable/img/add_wev8.png" onclick="doAdd()">
							<img class="toolpic deleteitem" style="vertical-align:middle;margin-right:10px" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" accesskey="" src="/wui/theme/ecology8/weaveredittable/img/delete_wev8.png" onclick="doDel()">
						</wea:item>
						<wea:item attributes="{'isTableList':'true','colspan':'full', 'id':'Hrm_HrmScheduleSet_Table'}">
							<%
								String sqlField = "t.*";
								String sqlFrom = "from (select t2.lastname,t2.subcompanyid1,t3.subcompanyname,t4.departmentname,t5.jobtitlename, t.*, 0 as cnt from hrm_schedule_set_detail t right join hrmresource t2 on t.field002 = t2.id left join HrmSubCompany t3 on t2.subcompanyid1 = t3.id left join HrmDepartment t4 on t2.departmentid = t4.id left join HrmJobTitles t5 on t2.jobtitle = t5.id where t.delflag = 0) t";
								String sqlWhere = "where t.delflag = 0";
								if(sId.length() > 0) {
									sqlWhere += " and t.field001 = '"+sId+"'";
								}
								if(startDate.length() > 0 && endDate.length() > 0) {
									sqlWhere += " and t.field003 between '"+startDate+"' and '"+endDate+"'";
								}
								if(strUtil.vString(detachCommonInfo.getDetachable()).equals("1")) {
									if(field004 != 0) {
										sqlWhere += " and t.subcompanyid1 = "+field004;
									}
									if(allIds.length() > 0) {
										sqlWhere += " and t.subcompanyid1 in ("+allIds+")";
									}
								}
								SplitPageTagTable table = new SplitPageTagTable("Hrm_HrmScheduleSetPerson", false, out, user);
								table.addOperate(SystemEnv.getHtmlLabelName(91,user.getLanguage()), "javascript:doDel();", "+column:cnt+==0");
								table.setPopedompara("+column:cnt+==0");
								table.setSql(sqlField, sqlFrom, sqlWhere, "id", "desc");
								table.addCol("20%", SystemEnv.getHtmlLabelName(413,user.getLanguage()), "lastname");
								table.addCol("25%", SystemEnv.getHtmlLabelName(141,user.getLanguage()), "subcompanyname");
								table.addCol("25%", SystemEnv.getHtmlLabelName(124,user.getLanguage()), "departmentname");
								table.addCol("25%", SystemEnv.getHtmlLabelName(6086,user.getLanguage()), "jobtitlename");
							%>
							<wea:SplitPageTag isShowTopInfo="false" tableString="<%=table.toString()%>" selectedstrs="" mode="run"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>	
		<script type="text/javascript">
			jQuery('#groupDiv').perfectScrollbar();
			jQuery(document).ready(function(){
				if(inNum == -1 && $showResource == "true" && common.isIE()) {
					setTimeout(function(){submit();}, 100);
				}
			});
		</script>
	</body>
</html>