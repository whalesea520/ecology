<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-10[排班人员范围] Generated from 长东设计 www.mfstyle.cn -->
<%
	if(!HrmUserVarify.checkUserRight("HrmSchedulingPersonnel:set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(32766, user.getLanguage());
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

			function showContent(id) {
				id = id && id != "" ? id : "";
				closeDialog();
				common.initDialog({width:600,height:350});
				dialog = common.showDialog("/hrm/schedule/hrmSchedulePersonnel/tab.jsp?topage=content&id="+id, id == "" ? "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" : "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>");
			}

			function doDel(id) {
				if(!id) id = _xtable_CheckedCheckboxId();
				if(!id) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)) id = id.substring(0,id.length-1);
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function() {
					common.ajax("/hrm/schedule/hrmSchedulePersonnel/save.jsp?cmd=delete&ids="+id, false, function(result){_table.reLoad();});
				});
			}

		</script>
	</head>
	<body style="overflow:hidden">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			TopMenu topMenu = new TopMenu(out, user);
			topMenu.add(SystemEnv.getHtmlLabelName(611,user.getLanguage()), "showContent()");
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
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		</form>
		<%
			String field003Sql = rs.getDBType().equalsIgnoreCase("oracle") ? "(case when field001 = 0 then ''  when field001 = 7 then '' else cast(field003 as varchar2(100)) || ' - ' || cast(field004 as varchar2(100)) end) as field003" : "(case when field001 = 0 then '' when field001 = 7 then '' else cast(field003 as varchar(100)) + ' - ' + cast(field004 as varchar(100)) end) as field003";
			String sqlField = "id, field001, field002, " + field003Sql + ", field005, field006, REPLACE(field007,',',';') as field007, cnt";
			String sqlFrom = "from (select t.*, 0 as cnt from hrm_schedule_personnel t where t.delflag = 0) t";
			String sqlWhere = "where delflag = 0";
			SplitPageTagTable table = new SplitPageTagTable("Hrm_HrmSchedulePersonnel", out, user);
			table.addOperate(SystemEnv.getHtmlLabelName(93,user.getLanguage()), "javascript:showContent();", "true");
			table.addOperate(SystemEnv.getHtmlLabelName(91,user.getLanguage()), "javascript:doDel();", "+column:cnt+==0");
			table.setPopedompara("+column:cnt+==0");
			table.setSql(sqlField, sqlFrom, sqlWhere, "id", "desc");
			table.addFormatCol("32%", SystemEnv.getHtmlLabelName(63,user.getLanguage()), "field001", "{cmd:array["+user.getLanguage()+";default=179,1=124,2=141,3=122,4=1340,7=6086]}");
			table.addFormatCol("32%", SystemEnv.getHtmlLabelName(106,user.getLanguage()), "field002", "{cmd:class[weaver.hrm.schedule.manager.HrmSchedulePersonnelManager.getField002Value(+column:field001+,+column:field002+,+column:field005+,+column:field006+,+column:field007+,"+user.getLanguage()+")]}");
			table.addCol("31%", SystemEnv.getHtmlLabelName(683,user.getLanguage()), "field003");
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString="<%=table.toString()%>" selectedstrs="" mode="run"/>
	</body>
</html>