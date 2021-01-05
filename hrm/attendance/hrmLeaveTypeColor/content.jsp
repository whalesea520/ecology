<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-06-02[请假类型] -->
<%@ page import="weaver.hrm.attendance.domain.HrmLeaveTypeColor"%>
<jsp:useBean id="hrmLeaveTypeColorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<%
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(1881, user.getLanguage());
	String isDialog = strUtil.vString(request.getParameter("isdialog"), "1");
	String id = strUtil.vString(request.getParameter("id"));

	HrmLeaveTypeColor bean = id.length() > 0 ? hrmLeaveTypeColorManager.get(id) : null;
	bean = bean == null ? new HrmLeaveTypeColor() : bean;
	if(strUtil.isNull(bean.getField007())) bean.setField007(bean.getField001());
	if(strUtil.isNull(bean.getField008())) bean.setField008(bean.getField001());
	if(strUtil.isNull(bean.getField009())) bean.setField009(bean.getField001());
%>
<html>
	<head>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			var common = new MFCommon();

			function doSave() {
				if(!check_form(document.frmMain,'field007,field008,field009')) return;
				try{parent.disableTabBtn();}catch(e){}
				common.ajax($("#weaver").attr("action")+"?cmd=update&"+$("#weaver").serialize(), false, function(result) {parentWin.closeDialog();});
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
				topMenu.add(SystemEnv.getHtmlLabelName(86,user.getLanguage()), "javascript:doSave();");
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
			<form id="weaver" name="frmMain" action="/hrm/attendance/hrmLeaveTypeColor/save.jsp" method="post" >
				<input type="hidden" name="id" value="<%=id%>">
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(33597,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="field007Span" required='<%=String.valueOf(bean.getField007()).length() == 0%>'>
								<input class="inputstyle" type="text" maxlength="100" name="field007" onchange="checkinput('field007','field007Span')" value="<%=bean.getField007()%>">
							</wea:required>
						</wea:item>
						<wea:item>English</wea:item>
						<wea:item>
							<wea:required id="field008Span" required='<%=String.valueOf(bean.getField008()).length() == 0%>'>
								<input class="inputstyle" type="text" maxlength="100" name="field008" onchange="checkinput('field008','field008Span')" value="<%=bean.getField008()%>">
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(33598,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="field009Span" required='<%=String.valueOf(bean.getField009()).length() == 0%>'>
								<input class="inputstyle" type="text" maxlength="100" name="field009" onchange="checkinput('field009','field009Span')" value="<%=bean.getField009()%>">
							</wea:required>
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
