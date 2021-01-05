<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-10[工作时段] Generated from 长东设计 www.mfstyle.cn -->
<%@ page import="weaver.hrm.schedule.domain.HrmScheduleWorktime"%>
<jsp:useBean id="hrmScheduleWorktimeManager" class="weaver.hrm.schedule.manager.HrmScheduleWorktimeManager" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("HrmSchedulingWorkTime:set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(125799, user.getLanguage());
	String isDialog = strUtil.vString(request.getParameter("isdialog"), "1");
	String id = strUtil.vString(request.getParameter("id"));
	boolean allowSave = strUtil.parseToInt(request.getParameter("cnt"), 0) == 0;

	HrmScheduleWorktime bean = id.length() > 0 ? hrmScheduleWorktimeManager.get(id) : null;
	bean = bean == null ? new HrmScheduleWorktime() : bean;
%>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			var common = new MFCommon();

			function doSave() {
				if(!check_form(document.frmMain,'field001,field002,field003,field004,field005,field007')) return;
				try{parent.disableTabBtn();}catch(e){}
				common.ajax($("#weaver").attr("action")+"?cmd=save&"+$("#weaver").serialize()+"&randomstr="+randomString(6), false, function(result) {
					parentWin._table.reLoad();
					result = jQuery.parseJSON(result);
					parentWin.closeDialog();
				});
			}
			
			function onShowTimeCallBack(field002, field003) {
				if(field002 && field003) {
					var startTime = field002.value;
					var endTime = field003.value;
					common.post({"cmd":"getWorkTime", "startTime":startTime, "endTime":endTime}, function(data) {
						$GetEle("field007").value = data.result;
						jQuery("#field007Span").html(data.result);
						//checkinput('field007','field007Span');
					}, "/hrm/schedule/hrmScheduleWorktime/save.jsp");
				}
			}

		</script>
	</head>
	<body>
	<%if("1".equals(isDialog)){ %>
		<div class="zDialog_div_content">
	<%} %>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
				TopMenu topMenu = new TopMenu(out, user);
				if(allowSave) topMenu.add(SystemEnv.getHtmlLabelName(86,user.getLanguage()), "javascript:doSave();");
				RCMenu += topMenu.getRightMenus();
				RCMenuHeight += RCMenuHeightStep * topMenu.size();
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%topMenu.show();%>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<form id="weaver" name="frmMain" action="/hrm/schedule/hrmScheduleWorktime/save.jsp" method="post" >
				<input type="hidden" name="id" value="<%=id%>">
				<wea:layout type="2col">
					<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
						<wea:item><%=SystemEnv.getHtmlLabelName(125808,user.getLanguage())%></wea:item>
						<wea:item>
							<%if(allowSave){%>
							<wea:required id="field001Span" required="<%=String.valueOf(bean.getField001()).length() == 0%>">
								<input class="inputstyle" type="text" maxlength="100" name="field001" onchange="checkinput('field001','field001Span')" value="<%=bean.getField001()%>">
							</wea:required>
							<%} else {%>
							<%=bean.getField001()%>
							<%}%>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(125809,user.getLanguage())%></wea:item>
						<wea:item>
							<%if(allowSave){%>
							<button class="Clock" type="button" id="field002Date" onclick="onWorkFlowShowTime(field002TimeSpan, field002, 1, function(){try{onShowTimeCallBack(field002, $GetEle('field003'));}catch(e){}})"></button>
							<span id="field002TimeSpan"><%=String.valueOf(bean.getField002()).length() == 0 ? "<img src='/images/BacoError_wev8.gif' align='absMiddle'>" : String.valueOf(bean.getField002())%></span>
							<input type="hidden" id="field002" name="field002" value="<%=bean.getField002()%>">
							<%} else {%>
							<%=bean.getField002()%>
							<%}%>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(125810,user.getLanguage())%></wea:item>
						<wea:item>
							<%if(allowSave){%>
							<button class="Clock" type="button" id="field003Date" onclick="onWorkFlowShowTime(field003TimeSpan, field003, 1, function(){try{onShowTimeCallBack($GetEle('field002'), field003);}catch(e){}})"></button>
							<span id="field003TimeSpan"><%=String.valueOf(bean.getField003()).length() == 0 ? "<img src='/images/BacoError_wev8.gif' align='absMiddle'>" : String.valueOf(bean.getField003())%></span>
							<input type="hidden" id="field003" name="field003" value="<%=bean.getField003()%>">
							<%} else {%>
							<%=bean.getField003()%>
							<%}%>
						</wea:item>
						<wea:item attributes="{'samePair':'field007Item'}"><%=SystemEnv.getHtmlLabelNames("380,391,27601",user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field007Item'}">
							<%if(allowSave){%>
							<span id="field007Span"><%=bean.getField007() == 0 ? "" : String.valueOf(bean.getField007())%></span>
							<input type="hidden" id="field007" name="field007" value="<%=bean.getField007() == 0 ? "" : String.valueOf(bean.getField007())%>">
							<%} else {
							%>
								<%=bean.getField007() == 0 ? "" : String.valueOf(bean.getField007())%>
							<%}%>
						</wea:item>
						<wea:item attributes="{'samePair':'field004Item'}"><%=SystemEnv.getHtmlLabelName(125811,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field004Item'}">
							<%=SystemEnv.getHtmlLabelName(125813,user.getLanguage())%>
							<%if(allowSave){%>
							<wea:required id="field004Span" required="<%=String.valueOf(bean.getField004()).length() == 0%>">
								<input class="inputstyle" style="width:10%" type="text" maxlength="3" name="field004" onKeyPress="ItemCount_KeyPress()" onBlur="common.checkInteger('field004');checkinput('field004','field004Span')" onchange="checkinput('field004','field004Span')" value="<%=bean.getField004()%>">
							</wea:required>
							<%} else {%>
							<%=" "+bean.getField004()+" "%>
							<%}%>
							<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
						</wea:item>
						<wea:item attributes="{'samePair':'field005Item'}"><%=SystemEnv.getHtmlLabelName(125812,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field005Item'}">
							<%=SystemEnv.getHtmlLabelName(125814,user.getLanguage())%>
							<%if(allowSave){%>
							<wea:required id="field005Span" required="<%=String.valueOf(bean.getField005()).length() == 0%>">
								<input class="inputstyle" style="width:10%" type="text" maxlength="3" name="field005" onKeyPress="ItemCount_KeyPress()" onBlur="common.checkInteger('field005');checkinput('field005','field005Span')" onchange="checkinput('field005','field005Span')" value="<%=bean.getField005()%>">
							</wea:required>
							<%} else {%>
							<%=" "+bean.getField005()+" "%>
							<%}%>
							<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
						<wea:item>
							<%if(allowSave){%>
							<textarea class="inputstyle" cols="50" rows="4" name="field006"><%=bean.getField006()%></textarea>
							<%} else {%>
							<%=bean.getField006()%>
							<%}%>
						</wea:item>
					</wea:group>
				</wea:layout>
			</form>
	<%if("1".equals(isDialog)){ %>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.closeByHand();">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<script type="text/javascript">jQuery(document).ready(function(){resizeDialog(document);});</script>
	<%} %>
	</body>
</html>
