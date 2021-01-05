<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-25[取消排班] Generated from 长东设计 www.mfstyle.cn -->
<%@ page import="weaver.hrm.schedule.domain.HrmScheduleShiftsSet"%>
<jsp:useBean id="hrmScheduleShiftsSetManager" class="weaver.hrm.schedule.manager.HrmScheduleShiftsSetManager" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("HrmScheduling:set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(125950, user.getLanguage());
	String isDialog = strUtil.vString(request.getParameter("isdialog"), "1");
	String id = strUtil.vString(request.getParameter("id"));
	String startDate = strUtil.vString(request.getParameter("startDate"));
	String endDate = strUtil.vString(request.getParameter("endDate"));
	List list = hrmScheduleShiftsSetManager.getScheduleShifts(id, startDate, endDate);
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.getParentWindow(this);
			var parentDialog = parent.parent.getDialog(parent);
			var common = new MFCommon();

			function doSave() {
				var checkbox = document.getElementsByName("sId");
				var sIds = "";
				for(var i=0; i<checkbox.length; i++) {
					if(checkbox[i].checked) {
						sIds+= (sIds == "" ? "" : ",") + checkbox[i].value;
					}
				}
				if(sIds == "") {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84093,user.getLanguage())%>");
					return;
				}
				try{parent.disableTabBtn();}catch(e){}
				common.ajax($("#weaver").attr("action")+"?cmd=cancel&sIds="+sIds+"&"+$("#weaver").serialize()+"&randomstr="+randomString(6), false, function(result) {
					result = jQuery.parseJSON(result);
					parentWin.cloaseAndreLoad();
				});
			}

		</script>
	</head>
	<body>
	<%if("1".equals(isDialog)){ %>
		<div class="zDialog_div_content">
	<%} %>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<div id="scrollContainer" style="overflow:hidden;margin:10px 0px 0px 30px">
			<form id="weaver" name="frmMain" action="/hrm/schedule/hrmScheduleSet/save.jsp" method="post" >
				<input type="hidden" name="id" value="<%=id%>">
				<input type="hidden" name="startDate" value="<%=startDate%>">
				<input type="hidden" name="endDate" value="<%=endDate%>">
				<table>
					<%
						HrmScheduleShiftsSet bean = null;
						for(int i=0; i<list.size(); i++) {
							bean = (HrmScheduleShiftsSet)list.get(i);
					%>
					<tr><td><input type="checkbox" name="sId" value="<%=bean.getId()%>"><%=bean.getField001()+"("+bean.getField007()+")"%></td></tr>
					<%	}%>
				</table>
			</form>
			</div>
	<%if("1".equals(isDialog)){ %>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" class="e8_btn_cancel" onclick="doSave();">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.closeByHand();">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<script type="text/javascript">jQuery(document).ready(function(){resizeDialog(document);});</script>
	<%} %>
	<script type="text/javascript">jQuery('#scrollContainer').perfectScrollbar();</script>
	</body>
</html>
