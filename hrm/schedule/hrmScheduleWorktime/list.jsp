<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-10[工作时段] Generated from 长东设计 www.mfstyle.cn -->
<%
	if(!HrmUserVarify.checkUserRight("HrmSchedulingWorkTime:set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(125799, user.getLanguage());
	String qCondition = strUtil.vString(request.getParameter("qCondition"));
%>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/mfcommon_wev8.css">
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			var common = new MFCommon();
			var dialog = null;

			function onBtnSearchClick() {
				jQuery("#searchfrm").submit();
			}

			function closeDialog() {
				if(dialog) dialog.close();
			}

			function showContent(id, cnt) {
				id = id && id != "" ? id : "";
				if(!cnt || cnt < 0) cnt = 0;
				closeDialog();
				dialog = common.showDialog("/hrm/schedule/hrmScheduleWorktime/tab.jsp?topage=content&id="+id+"&cnt="+cnt, id == "" ? "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" : (cnt > 0 ? "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>" : "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"));
			}

			function doDel(id) {
				if(!id) id = _xtable_CheckedCheckboxId();
				if(!id) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)) id = id.substring(0,id.length-1);
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function() {
					common.ajax("/hrm/schedule/hrmScheduleWorktime/save.jsp?cmd=delete&ids="+id, false, function(result){_table.reLoad();});
				});
			}

		</script>
	</head>
	<body style="overflow:hidden">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			TopMenu topMenu = new TopMenu(out, user);
			topMenu.add(SystemEnv.getHtmlLabelName(82,user.getLanguage()), "showContent()");
			topMenu.add(SystemEnv.getHtmlLabelName(32136,user.getLanguage()), "doDel()");
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
						<input type="text" class="searchInput" name="qCondition" value="<%=qCondition%>"/>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		</form>
		<%
			String sqlField = "id, field001, field002, field003, field004, field005, field006, field007, cnt";
			String sqlFrom = "from (select t.*, (select count(id) from hrm_schedule_shifts_wt where field002 = t.id and field001 in (select id from hrm_schedule_shifts_set where delflag='0')) as cnt from hrm_schedule_worktime t where t.delflag = 0) t";
			String sqlWhere = "where delflag = 0";
			if(qCondition.length() > 0) {
				sqlWhere += " and field001 like '%"+qCondition+"%'";
			}
			SplitPageTagTable table = new SplitPageTagTable("Hrm_HrmScheduleWorktime", out, user);
			table.addOperate(SystemEnv.getHtmlLabelName(93,user.getLanguage()), "javascript:showContent();", "+column:cnt+==0", "+column:cnt+");
			table.addOperate(SystemEnv.getHtmlLabelName(91,user.getLanguage()), "javascript:doDel();", "+column:cnt+==0");
			table.setPopedompara("+column:cnt+==0");
			table.setSql(sqlField, sqlFrom, sqlWhere, "id", "desc");
			table.addFormatCol("14%", SystemEnv.getHtmlLabelName(125808,user.getLanguage()), "field001", "{cmd:link[+column:field001+|javascript:showContent;+column:id+___+column:cnt+]}");
			table.addCol("14%", SystemEnv.getHtmlLabelName(125809,user.getLanguage()), "field002");
			table.addCol("14%", SystemEnv.getHtmlLabelName(125810,user.getLanguage()), "field003");
			table.addFormatCol("13%", SystemEnv.getHtmlLabelName(125811,user.getLanguage()), "field004", "{cmd:clean}{cmd:append["+SystemEnv.getHtmlLabelName(125813,user.getLanguage())+"+column:field004+"+SystemEnv.getHtmlLabelName(15049,user.getLanguage())+"]}");
			table.addFormatCol("13%", SystemEnv.getHtmlLabelName(125812,user.getLanguage()), "field005", "{cmd:clean}{cmd:append["+SystemEnv.getHtmlLabelName(125814,user.getLanguage())+"+column:field005+"+SystemEnv.getHtmlLabelName(15049,user.getLanguage())+"]}");
			table.addCol("14%", SystemEnv.getHtmlLabelNames("380,391,27601",user.getLanguage()), "field007");
			table.addCol("13%", SystemEnv.getHtmlLabelName(85,user.getLanguage()), "field006");
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString="<%=table.toString()%>" selectedstrs="" mode="run"/>
	</body>
</html>