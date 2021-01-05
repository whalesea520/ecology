<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-20[排班设置] Generated from 长东设计 www.mfstyle.cn -->
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmScheduling:set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(16695, user.getLanguage());
	String paramField001Start = strUtil.vString(request.getParameter("paramField001Start"), dateUtil.getFirstDayOfMonthToString());
	String paramField001End = strUtil.vString(request.getParameter("paramField001End"), dateUtil.getLastDayOfMonthToString());
	String field003 = strUtil.vString(request.getParameter("field003"));
	String field004 = strUtil.vString(request.getParameter("field004"), strUtil.vString(request.getParameter("subcompanyid")));
	String workcode = strUtil.vString(request.getParameter("workcode"));
	String lastname = strUtil.vString(request.getParameter("lastname"));
	String jobtitle = strUtil.vString(request.getParameter("jobtitle"));
	String stype = strUtil.vString(request.getParameter("stype"), "1");
	String department = strUtil.vString(request.getParameter("department"));
	String allIds = "";
	if(!user.getLoginid().equalsIgnoreCase("sysadmin") && strUtil.vString(detachCommonInfo.getDetachable()).equals("1")) {
		int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "HrmScheduling:set");
		StringBuffer sIds = new StringBuffer();
		for(int i=0;i<subCompany.length;i++) sIds.append(sIds.length()==0?"":",").append(subCompany[i]);
		allIds = strUtil.vString(sIds.toString(), "-99999");
	}
	String dataParam = "paramField001Start:"+paramField001Start+"+paramField001End:"+paramField001End+"+allIds:"+allIds+"+shiftsSet:"+field003+"+subcompany:"+field004+"+workcode:"+workcode+"+lastname:"+lastname+"+jobtitle:"+jobtitle+"+stype:"+stype+"+department:"+department;
%>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/schedule.css">
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			var common = new MFCommon();
			var dialog = null;

			function onBtnSearchClick() {
				jQuery("#searchfrm").submit();
			}

			function closeDialog() {
				if(dialog) dialog.close();
			}

			function showContent(id) {
				id = id && id != "" ? id : "";
				closeDialog();
				common.initDialog({width:800, height:500, showMax:true});
				dialog = common.showDialog("/hrm/schedule/hrmScheduleSet/tab.jsp?topage=content&id="+id+"&startDate="+$V("paramField001Start")+"&endDate="+$V("paramField001End")+"&randomstr="+randomString(6), id == "" ? "<%=SystemEnv.getHtmlLabelName(125836,user.getLanguage())%>" : "<%=SystemEnv.getHtmlLabelName(125835,user.getLanguage())%>");
			}
			
			function cloaseAndreLoad() {
				closeDialog();
				parent.window.location.href = "/hrm/schedule/hrmScheduleSet/tab.jsp?topage=list";
			}
			
			function showContainer() {
				var obj = jQuery("#container");
				if(obj.hasClass("show")) {
					obj.removeClass("show");
					obj.addClass("hide");
					obj.hide();
				} else {
					obj.removeClass("hide");
					obj.addClass("show");
					obj.show();
				}
			}
			
			function showDetail(id, stype) {
				if(id != null) {
					common.ajax("/hrm/schedule/hrmScheduleSet/save.jsp?cmd=getContent&id="+id+"&stype="+stype+"&startDate="+$V("paramField001Start")+"&endDate="+$V("paramField001End")+"&randomstr="+randomString(6), false, function(result) {
						result = jQuery.parseJSON(result);
						$GetEle("scrollContainer").innerHTML = "<span id='content' class='wspan'>"+result.content+"</span>";
					});
				} else {
					$GetEle("scrollContainer").innerHTML = "<span id='content' class='wspan'><%=SystemEnv.getHtmlLabelName(125834,user.getLanguage())%></span>";
				}
			}

			function doDel(id) {
				if(!id) id = _xtable_CheckedCheckboxId();
				if(!id) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)) id = id.substring(0,id.length-1);
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function() {
					common.ajax("/hrm/schedule/hrmScheduleSet/save.jsp?cmd=delete&ids="+id, false, function(result){_table.reLoad();});
				});
			}
			
			function cancelSchedule(id) {
				var startDate = $V("paramField001Start");
				var endDate = $V("paramField001End");
				var url = "/hrm/schedule/hrmScheduleSet/save.jsp";
				var param = "id="+id+"&startDate="+startDate+"&endDate="+endDate;
				common.post({"cmd":"getScheduleShifts", "id":id, "startDate":startDate, "endDate":endDate}, function(data) {
					if(data.size > 1) {
						closeDialog();
						common.initDialog({width:350, height:150, normalDialog:false, showMax:false});
						dialog = common.showDialog("/hrm/schedule/hrmScheduleSet/cancel.jsp?"+param+"&randomstr="+randomString(6), "<%=SystemEnv.getHtmlLabelName(125950,user.getLanguage())%>");
					} else {
						window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(125838,user.getLanguage())%>",function() {
							common.ajax(url+"?cmd=cancel&sIds="+data.sid+"&"+param+"&randomstr="+randomString(6), false, function(result) {_table.reLoad();});
						});
					}
				}, url);
			}

		</script>
	</head>
	<body id="bContainer" style="overflow-x:hidden;overflow-y:auto">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			TopMenu topMenu = new TopMenu(out, user);
			topMenu.add(SystemEnv.getHtmlLabelName(197,user.getLanguage()), "onBtnSearchClick()");
			topMenu.add(SystemEnv.getHtmlLabelName(125836,user.getLanguage()), "showContent()");
			RCMenu += topMenu.getRightMenus();
			RCMenuHeight += RCMenuHeightStep * topMenu.size();
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form id="searchfrm" name="searchfrm" action="">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%topMenu.show();%>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<wea:layout type="4col">
				<wea:group context="<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>">
					<wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
					<wea:item>
						<span class="wuiDateSpan" selectId="createdateselect" selectValue="" _needAllOption="false">
							<input type="hidden" name="paramField001Start" class="wuiDateSel" value="<%=paramField001Start%>">
							<input type="hidden" name="paramField001End" class="wuiDateSel" value="<%=paramField001End%>">
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
					<wea:item>
						<input class="inputstyle" type="text" maxlength="30" id="workcode" name="workcode" value="<%=workcode%>">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
					<wea:item>
						<input class="inputstyle" type="text" maxlength="30" id="lastname" name="lastname" value="<%=lastname%>">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="field004" width="60%"
							browserValue="<%=String.valueOf(field004)%>"
							browserSpanValue="<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(field004))%>"
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1"
							hasInput="true" isSingle="true" hasBrowser="true" isMustInput="1"
							completeUrl="/data.jsp?type=164&show_virtual_org=-1" _callback="">
						</brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="department" width="60%"
							browserValue="<%=String.valueOf(department)%>"
							browserSpanValue="<%=DepartmentComInfo.getDepartmentname(department)%>"
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?show_virtual_org=-1"
							hasInput="true" isSingle="true" hasBrowser="true" isMustInput="1"
							completeUrl="/data.jsp?type=4&show_virtual_org=-1" _callback="">
						</brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="jobtitle" width="60%"
							browserValue="<%=String.valueOf(jobtitle)%>"
							browserSpanValue="<%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>"
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?show_virtual_org=-1"
							hasInput="true" isSingle="true" hasBrowser="true" isMustInput="1"
							completeUrl="/data.jsp?type=24&show_virtual_org=-1" _callback="">
						</brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(32765,user.getLanguage())%></wea:item>
					<wea:item>
						<select id="stype" name="stype" class="inputStyle" style="width:24%">
							<option value="-1"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="1" <%=stype.equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125832,user.getLanguage())%></option>
							<option value="0" <%=stype.equals("0") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125831,user.getLanguage())%></option>
						</select>
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
		<table class="LayoutTable" style="width:100%;">
			<colgroup>
				<col width="50%">
				<col width="50%">
			</colgroup>
			<tbody>
			<tr class="groupHeadHide">
				<td class="interval">
					<span class="groupbg"> </span>
					<span class="e8_grouptitle"><%=SystemEnv.getHtmlLabelNames("32765,27904",user.getLanguage())%></span>
				</td>
				<td class="interval" colspan="2" style="text-align:right;">
					<span class="toolbar"></span>
					<!--  style="display:none" -->
					<span _status="0" class="hideBlockDiv" onclick="showContainer();" style="color: rgb(204, 204, 204);"><img src="/wui/theme/ecology8/templates/default/images/2_wev8.png"></span>
				</td>
			</tr>
			<tr class="Spacing" style="height:1px;display:">
				<td class="Line" colspan="2"></td>
			</tr>
			</tbody>
		</table>
		<div id="container" class="show" style="width:100%;height:100%;" onclick="">
			<div style="width:75%;height:100%;float:left">
			<%
				SplitPageTagTable table = new SplitPageTagTable("Hrm_HrmScheduleSet", out, user);
				table.setData("weaver.hrm.schedule.manager.HrmSchedulePersonnelManager.getSchedulePersons", dataParam);
				table.addOperate(SystemEnv.getHtmlLabelName(125835,user.getLanguage()), "javascript:showContent();", "+column:stype+==0");
				table.addOperate(SystemEnv.getHtmlLabelName(125837,user.getLanguage()), "javascript:cancelSchedule();", "+column:stype+==1");
				table.setShowPopedom(true);
				table.setPopedompara("false");
				table.addAttribute("tabletype", "none");
				table.addAttribute("rowClick", "showDetail('+column:id+', '+column:stype+')");
				table.addCol("16%", SystemEnv.getHtmlLabelName(714,user.getLanguage()), "workcode");
				table.addCol("16%", SystemEnv.getHtmlLabelName(413,user.getLanguage()), "lastname");
				table.addCol("16%", SystemEnv.getHtmlLabelName(141,user.getLanguage()), "subcompanyName");
				table.addCol("16%", SystemEnv.getHtmlLabelName(124,user.getLanguage()), "departmentName");
				table.addCol("16%", SystemEnv.getHtmlLabelName(6086,user.getLanguage()), "jobtitleName");
				table.addFormatCol("15%", SystemEnv.getHtmlLabelName(32765,user.getLanguage()), "stype", "{cmd:array["+user.getLanguage()+";default=125831,1=125832]}");
			%>
				<wea:SplitPageTag isShowTopInfo="false" tableString="<%=table.toString()%>" selectedstrs="" mode="run"/>
			</div>
			<div style="width:25%;height:100%;float:left;background:rgb(242,243,248);"><div style="border-left:1px solid rgb(220,220,220);width:100%;height:100%">
				<div id="header"><p><%=SystemEnv.getHtmlLabelName(125833,user.getLanguage())%></p><!--[if lt IE 8]><span></span><![endif]--></div>
				<div id="scrollContainer" style="height:94%;overflow:hidden;"><span id="content" class="wspan"><%=SystemEnv.getHtmlLabelName(125834,user.getLanguage())%></span></div>
			</div></div>
		</div>
		<script type="text/javascript">jQuery('#scrollContainer').perfectScrollbar();</script>
	</body>
</html>