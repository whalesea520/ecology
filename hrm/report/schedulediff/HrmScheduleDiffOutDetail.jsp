<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-07-25 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<%
	String fromDate = strUtil.vString(request.getParameter("fromDate"));
	String toDate = strUtil.vString(request.getParameter("toDate"));
	int subCompanyId = strUtil.parseToInt(request.getParameter("subCompanyId"),0);
	int departmentId = strUtil.parseToInt(request.getParameter("departmentId"),0);
	String resourceId = strUtil.vString(request.getParameter("resourceId"));
	String status = strUtil.vString(request.getParameter("status"));

	//非考勤管理员只能看到自己的记录
	if(!HrmUserVarify.checkUserRight("BohaiInsuranceScheduleReport:View", user)){
		resourceId = String.valueOf(user.getUID());
	}

	String imagefilename = "/images/hdReport_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16559,user.getLanguage())+"—"+SystemEnv.getHtmlLabelName(20094,user.getLanguage());
	String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentDialog = parent.parent.getDialog(parent);
			
			function exportExcel(){
				document.getElementById("excels").src = "HrmScheduleDiffReportExcel.jsp?cmd=HrmScheduleDiffOutDetail&tnum=20094&fromDate=<%=fromDate%>&toDate=<%=toDate%>&status=<%=status%>&resourceId=<%=resourceId%>&departmentId=<%=departmentId%>&subCompanyId=<%=subCompanyId%>";
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
			topMenu.add(SystemEnv.getHtmlLabelName(28343,user.getLanguage()), "exportExcel()");
			RCMenu += topMenu.getRightMenus();
			RCMenuHeight += RCMenuHeightStep * topMenu.size();
			topMenu.showTable();
			
			String dataParam = "fromDate:"+fromDate+"+toDate:"+toDate+"+subCompanyId:"+subCompanyId+"+departmentId:"+departmentId+"+resourceId:"+resourceId+"+status:"+status+"+type:2";
			SplitPageTagTable table = new SplitPageTagTable("HrmScheduleDiffOutDetail", out, user);
			table.setData("weaver.hrm.report.schedulediff.HrmScheduleDiffOtherManager.getScheduleList", dataParam);
			table.addCol("12%", SystemEnv.getHtmlLabelName(124,user.getLanguage()), "departmentName");
			table.addCol("6%", SystemEnv.getHtmlLabelName(714,user.getLanguage()), "workcode");
			table.addCol("15%", SystemEnv.getHtmlLabelName(413,user.getLanguage()), "resourceName");
			table.addCol("20%", SystemEnv.getHtmlLabelName(742,user.getLanguage()), "startTime");
			table.addCol("20%", SystemEnv.getHtmlLabelName(743,user.getLanguage()), "endTime");
			table.addCol("15%", SystemEnv.getHtmlLabelName(15378,user.getLanguage()), "status");
			table.addCol("12%", SystemEnv.getHtmlLabelName(20096,user.getLanguage()), "days");
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=table.toString()%>' mode="run" />
		<%if("1".equals(isDialog)){ %>
			</div>
			<div id="zDialog_div_bottom" class="zDialog_div_bottom">
				<wea:layout type="2col">
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.close();">
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
			<script type="text/javascript">jQuery(document).ready(function(){resizeDialog(document);});</script>
		<%} %>
	<iframe name="excels" id="excels" src="" style="display:none" ></iframe>
	</body>
</html>



