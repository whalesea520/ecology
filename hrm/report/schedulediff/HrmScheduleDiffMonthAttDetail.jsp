<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.settings.ChgPasswdReminder"%>
<!-- Added by wcd 2015-05-14 [月考勤日历报表] -->

<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	boolean hasViewAllRight = HrmUserVarify.checkUserRight("HrmMonthAttendanceReport:report", user);
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage()) +":" + SystemEnv.getHtmlLabelName(82801,user.getLanguage()) ;
	String needfav ="1";
	String needhelp ="";

	String isself = strUtil.vString(request.getParameter("isself"), "0");
	int subCompanyId = strUtil.parseToInt(request.getParameter("subCompanyId"),0);
	int departmentId = strUtil.parseToInt(request.getParameter("departmentId"),0);
	String resourceId = strUtil.vString(request.getParameter("resourceId"));
	String status = strUtil.vString(request.getParameter("status"));
	if(status.equals("")){
		status = "8";
	}
	String _level = "";
	if(!hasViewAllRight){
		resourceId = String.valueOf(user.getUID());
		departmentId = user.getUserDepartment();
		subCompanyId = user.getUserSubCompany1();
		isself = "1";
	} else {
		_level = strUtil.vString(HrmUserVarify.getRightLevel("BohaiInsuranceScheduleReport:View", user));
		if(_level.equals("0")) {
			departmentId=user.getUserDepartment();
			subCompanyId=user.getUserSubCompany1();
		} else if(_level.equals("1")) {
			subCompanyId=user.getUserSubCompany1();
		}
	}
	
	String currentdate = strUtil.vString(request.getParameter("currentdate"));
	int movedate = strUtil.parseToInt(request.getParameter("movedate"), 0);
	Calendar today = Calendar.getInstance();
	if(!currentdate.equals("")) {
		int tempyear = strUtil.parseToInt(currentdate.substring(0,4)) ;
		int tempmonth = strUtil.parseToInt(currentdate.substring(5,7))-1 ;
		int tempdate = strUtil.parseToInt(currentdate.substring(8,10)) ;
		today.set(tempyear,tempmonth,tempdate);
	}
	today.add(Calendar.MONTH, movedate);
	currentdate = dateUtil.getDate(today.getTime());
	//String datenow = dateUtil.getDate(today.getTime(), "yyyy"+SystemEnv.getHtmlLabelName(445, user.getLanguage())+"MM"+SystemEnv.getHtmlLabelName(6076, user.getLanguage()));
     String datenow = currentdate.substring(0,7);
	
	ChgPasswdReminder reminder=new ChgPasswdReminder();
	RemindSettings settings=reminder.getRemindSettings();
	String checkUnJob = Util.null2String(settings.getCheckUnJob(),"0");//非在职人员信息查看控制 启用后，只有有“离职人员查看”权限的用户才能检索非在职人员
%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
		<link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css" /> 
		<link href="/workplan/calendar/css/dp_wev8.css" rel="stylesheet" type="text/css" />   
		<link href="/workplan/calendar/css/main_wev8.css" rel="stylesheet" type="text/css" /> 
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<script src="/meeting/calendar/src/Plugins/jquery.datepickernew_wev8.js" type="text/javascript"></script>
		<script src="/meeting/calendar/src/Plugins/datepicker_lang_ZH_wev8.js" type="text/javascript"></script> 
		<script src="/meeting/calendar/src/Plugins/wdCalendar_lang_ZH_wev8.js" type="text/javascript"></script>  
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
		<script type="text/javascript"> 
			var common = new MFCommon();
			function submitData() {
				if($GetEle("subCompanyId").value==""&&$GetEle("departmentId").value==""&&$GetEle("resourceId").value=="") {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83279,user.getLanguage())%>");
				} else {
					jQuery("#frmMain").submit();
				}
			}
			
			function getParam(){
				return "currentdate="+document.frmMain.currentdate.value+"&status="+$GetEle("status").value+"&resourceId="+$GetEle("resourceId").value+"&departmentId="+$GetEle("departmentId").value+"&rstr="+randomString(10)+"&subCompanyId="+$GetEle("subCompanyId").value;
			}
			
			function exportExcel(){
				if("<%=hasViewAllRight%>"=="true"&&$GetEle("subCompanyId").value==""&&$GetEle("departmentId").value==""&&$GetEle("resourceId").value==""){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>");
					return;
				}
				document.getElementById("excels").src = "HrmScheduleDiffReportExcel.jsp?cmd=HrmScheduleDiffMonthAttDetail&tnum=82801&"+getParam();
			}
			
			function showdata() {
				common.ajax("/hrm/report/schedulediff/HrmScheduleDiffMonthAttData.jsp?"+getParam(), false, function(result){
					document.all("showdatadiv").innerHTML = result;
				});
			}
			
			function showWindow(rId, curDate){
				common.showDialog("/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=HrmScheduleDiffMonthAttDateDetail&resourceId="+rId+"&curDate="+curDate+"&status=<%=status%>", "<%=SystemEnv.getHtmlLabelNames("15880,17463",user.getLanguage())%>");
			}
		</script>
	</head>
	<body onload="<%=isself.equals("1")?"showdata()":""%>">
		<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:exportExcel(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
					<input type="button" class="e8_btn_top" onclick="exportExcel();" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage())%>"></input>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id="frmMain" name="frmMain" method="post" action="HrmScheduleDiffMonthAttDetail.jsp" >
			<input type="hidden" name="isself" value="1">
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(887,user.getLanguage())%></wea:item>
					<wea:item>
						<input type="hidden" name="movedate" id="movedate" value="">
						<input type="hidden" name="currentdate" id="currentdate" value="<%=currentdate%>">
						<div id="calhead" class="calHd" style="height:36px;padding-left:0px;min-width:900px !important;background-color: #f7f7f7;">
							<div id="editButtons1" style="float:left;min-width:122px !important;">
								<div id="showtodaybtn" unselectable="on" class="calHdBtn showtodaybtn" title="<%=SystemEnv.getHtmlLabelName(15384, user.getLanguage())%>" style="height:24px;margin-left:0px;border:none;display:none"></div>
								<div id="sfprevbtn" unselectable="on" class="calHdBtn sfprevbtn" title="<%=SystemEnv.getHtmlLabelName(32995, user.getLanguage())%>"  style="height:24px;border:none;margin-left:10px;width:23px;_width:25px;"></div>
								<input type="hidden" name="txtshow" id="hdtxtshow" />
								<div id="txtdatetimeshow" unselectable="on" class="calHdBtn txtbtncls" style="border:none;width:auto;padding-left:1px;padding-right:10px;"></div>
								<div id="sfnextbtn" unselectable="on" class="calHdBtn sfnextbtn" title="<%=SystemEnv.getHtmlLabelName(32996, user.getLanguage())%>"  style="height:24px;border:none;border-left:none;width:23px;_width:25px;"></div>
							</div>
						</div>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(hasViewAllRight && _level.equals("2")){%>
						<span>
							<brow:browser viewType="0" name="subCompanyId" browserValue='<%=String.valueOf(subCompanyId)%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=164&show_virtual_org=-1" width="60%" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId))%>'>
							</brow:browser>
						</span>
						<%}else{%>
							<span id=subCompanyNameSpan><%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId))%></span> 
							<input class=inputStyle id=subCompanyId type=hidden name=subCompanyId value="<%=subCompanyId%>">
						<%} %>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(hasViewAllRight && (_level.equals("1") || _level.equals("2"))){%>
						<span>
							<brow:browser viewType="0" name="departmentId" browserValue='<%=String.valueOf(departmentId)%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?show_virtual_org=-1"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=4&show_virtual_org=-1" width="60%" browserSpanValue='<%=DepartmentComInfo.getDepartmentname(String.valueOf(departmentId))%>'>
							</brow:browser>
						</span>
						<%}else{%>
							<SPAN id=departmentNameSpan><%=DepartmentComInfo.getDepartmentname(String.valueOf(departmentId))%></SPAN> 
							<INPUT class=inputstyle type=hidden name=departmentId value="<%=departmentId%>" >
						<%} %>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(hasViewAllRight){%>
						<span>
							<brow:browser viewType="0" name="resourceId" browserValue='<%=String.valueOf(resourceId)%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/resource/ResourceBrowser.jsp?excludeid="
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=1" width="60%" browserSpanValue='<%=resourceId.length() == 0 ? "" : ResourceComInfo.getMulResourcename1(String.valueOf(resourceId))%>'>
							</brow:browser>
						</span>
						<%}else{%>
							<SPAN id=resourceNameSpan><%=resourceId.length() == 0 ? "" : ResourceComInfo.getMulResourcename(String.valueOf(resourceId))%></SPAN> 
							<INPUT class=inputstyle type=hidden name=resourceId value="<%=resourceId%>" >
						<%} %>
					</wea:item>
					<%if(hasViewAllRight){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
					     	<SELECT class=inputstyle id=status name=status value="<%=status%>" style="width: 135px">
						        <%
						   		if("1".equals(checkUnJob)){//启用后，只有有“离职人员查看”权限的用户才能检索非在职人员
						     		if(HrmUserVarify.checkUserRight("hrm:departureView",user)){ %>
						        <OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
						        <%}}else{%>
						       	 	<OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
						        <%} %>
						        <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
						        <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
						        <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
						        <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
						        <%
						   		if("1".equals(checkUnJob)){//启用后，只有有“离职人员查看”权限的用户才能检索非在职人员
						        	if(HrmUserVarify.checkUserRight("hrm:departureView",user)){ %>
						        <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
						        <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
						        <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
						        <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
						         <%}}else{%>
						        <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
						        <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
						        <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
						        <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
						        <%} %>
						        <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>
					    	</SELECT>
						</span>
					</wea:item>
					<%}else{%>
					<wea:item>
						<input class=inputStyle id=status type=hidden name=status value="<%=status%>">
					</wea:item>
					<%}%>
				</wea:group>
			</wea:layout>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<div id="showdatadiv" style="<%=isself.equals("1")?"":"display:none"%>;width:100%;">
							<div id='message_table_Div' class="xTable_message">
								<%=SystemEnv.getHtmlLabelName(20204,user.getLanguage())%>
							</div>
						</div>
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
		<iframe name="excels" id="excels" src="" style="display:none" ></iframe>
		<script language=javascript>
			jQuery(document).ready(function(){
				var showtime = "<%=datenow%>";
				
				jQuery("#message_table_Div").hide();
				jQuery("#message_table_Div").css("position", "absolute");
				jQuery("#message_table_Div").css("top", document.body.offsetHeight/2+document.body.scrollTop-50);
				jQuery("#message_table_Div").css("left", document.body.offsetWidth/2-50);
				<%if(isself.equals("1")){%>
				jQuery("#message_table_Div").show();
				<%}%>
		   
				$("#showtodaybtn").click(function(e) {
					document.frmMain.currentdate.value = "";
					submitData();
				});
			   
				$("#sfprevbtn").click(function(e) {
					getSubdate();

				});
			   
				$("#sfnextbtn").click(function(e) {
					getSupdate();
				});
			   
				$("#hdtxtshow").datepickernew({ 
					picker: "#txtdatetimeshow", 
					showtarget: $("#txtdatetimeshow"),
					onReturn:function(r){
						var d = CalDateShow(r);
						if(d && r){
							jQuery("#frmMain")[0].currentdate.value = dateFormat.call(r, i18n.xgcalendar.dateformat.fulldayvalue);
							submitData();
							$("#hdtxtshow").val(dateFormat.call(r, i18n.datepicker.dateformat.fulldayvalue));
						}
					},
					selectMode:"1"
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
			
			function getSubdate() {
				document.frmMain.movedate.value = "-1" ;
				submitData();
			}
			
			function getSupdate() {
				document.frmMain.movedate.value = "1" ;
				submitData();
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
		</script>
	</body>
</html>
