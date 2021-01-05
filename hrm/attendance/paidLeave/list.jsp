<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.attendance.domain.HrmPaidLeaveTime"%>
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="paidLeaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page" />
<!-- Added by wcd 2015-04-30[调休管理-调休时间查询] -->
<%
	if(!HrmUserVarify.checkUserRight("HrmPaidLeaveTime:search", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdHRMCard_wev8.gif", needfav ="1", needhelp ="";
	String titlename = SystemEnv.getHtmlLabelName(82800,user.getLanguage());
	
	int subcompanyid = strUtil.parseToInt(request.getParameter("subcompanyid"), 0);
	int departmentid = strUtil.parseToInt(request.getParameter("departmentid"), 0);
	String showname = "", mapParam = "";
	if(departmentid > 0) {
		showname = DepartmentComInfo.getDepartmentname(String.valueOf(departmentid));
		mapParam = "departmentid:"+departmentid+"+";
	} else if(subcompanyid > 0) {
		showname = SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid));
		mapParam = "subcompanyid:"+subcompanyid+"+";
	} else {
		mapParam = "departmentid:-1+subcompanyid:-1+";
	}
	boolean bool = strUtil.parseToInt(request.getParameter("flg"), 0) == 1;
	String fromdate = strUtil.vString(request.getParameter("fromdate"), dateUtil.getFirstDayOfYear());
	String enddate = strUtil.vString(request.getParameter("enddate"), dateUtil.getLastDayOfYear());
	mapParam += "fromdate:"+fromdate+"+enddate:"+enddate;
%>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			jQuery(document).ready(function(){<%if(showname.length()>0){%>parent.setTabObjName('<%=showname%>')<%}%>});

			function doSearch() {
				jQuery("#searchfrm").submit();
			}
		</script>
	</head>
	<BODY style="overflow-x:hidden">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			TopMenu topMenu = new TopMenu(out, user);
			topMenu.add(SystemEnv.getHtmlLabelName(197,user.getLanguage()), "doSearch()");
			RCMenu += topMenu.getRightMenus();
			RCMenuHeight += RCMenuHeightStep * topMenu.size();
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<input type="hidden" name="subcompanyid" value="<%=subcompanyid%>">
			<input type="hidden" name="departmentid" value="<%=departmentid%>">
			<input type="hidden" name="flg" value="1">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%topMenu.show();%>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelNames("25733,19467",user.getLanguage())%></wea:item>
					<wea:item>
						<span class="wuiDateSpan" selectId="createdateselect" selectValue="<%=bool ? "" : "5"%>">
							<input class="wuiDateSel" type="hidden" name="fromdate" value="<%=fromdate%>">
							<input class="wuiDateSel" type="hidden" name="enddate" value="<%=enddate%>">
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(82845,user.getLanguage())%>'>
				<wea:item attributes="{'isTableList':'true','colspan':'full'}">
					<%
						SplitPageTagTable table = new SplitPageTagTable("Hrm_HrmPaidLeaveTime", out, user);
						table.setData("weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager.getResult", mapParam);
						table.addCol("10%", SystemEnv.getHtmlLabelName(413,user.getLanguage()), "ln", "");
						table.addCol("15%", SystemEnv.getHtmlLabelName(141,user.getLanguage()), "sn", "");
						table.addCol("15%", SystemEnv.getHtmlLabelName(124,user.getLanguage()), "dn", "");
						table.addCol("15%", SystemEnv.getHtmlLabelName(82846,user.getLanguage()), "sc", "");
						table.addCol("15%", SystemEnv.getHtmlLabelName(82847,user.getLanguage()), "od", "");
						table.addCol("15%", SystemEnv.getHtmlLabelName(82848,user.getLanguage()), "pv", "");
						table.addCol("15%", SystemEnv.getHtmlLabelName(82849,user.getLanguage()), "vl", "");
					%>
					<wea:SplitPageTag isShowTopInfo="false" tableString='<%=table.toString()%>' mode="run"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</BODY>
</HTML>

