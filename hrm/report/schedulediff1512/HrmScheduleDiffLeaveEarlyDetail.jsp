
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-07-24 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="HrmScheduleDiffDetSignOutManager" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffDetSignOutManager" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffUtil" scope="page"/>
<%
	String fromDate = Util.null2String(request.getParameter("fromDate"));
	String toDate = Util.null2String(request.getParameter("toDate"));
	String validDate = Util.null2String(request.getParameter("validDate"));
	String oldVDate = validDate;
	if(validDate.length()>0){
		String[] arrayValidDate = validDate.split(",");
		validDate = "";
		for(String _dt : arrayValidDate){
			validDate +=(validDate.length()>0?",":"")+"'"+_dt+"'";
		}
	}

	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
	int departmentId = Util.getIntValue(request.getParameter("departmentId"),0);
	String resourceId = strUtil.vString(request.getParameter("resourceId"));

	//安全检查  
	//查询的开始日期和结束日期必须有值且长度为10
	if(fromDate==null||fromDate.trim().equals("")||fromDate.length()!=10
	 ||toDate==null||toDate.trim().equals("")||toDate.length()!=10){
		return;
	}
	//非考勤管理员只能看到自己的记录
	if(!HrmUserVarify.checkUserRight("BohaiInsuranceScheduleReport:View", user)){
		resourceId = String.valueOf(user.getUID());
	}

	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16559,user.getLanguage())+"—"+SystemEnv.getHtmlLabelName(20089,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script type="text/javascript">
			var parentDialog = parent.parent.getDialog(parent);
			
			function exportExcel(){
				document.getElementById("excels").src = "HrmScheduleDiffReportExcel.jsp?cmd=HrmScheduleDiffLeaveEarlyDetail&tnum=20089&validDate=<%=oldVDate%>&fromDate=<%=fromDate%>&toDate=<%=toDate%>&resourceId=<%=resourceId%>&departmentId=<%=departmentId%>&subCompanyId=<%=subCompanyId%>";
			}
			
			function openMap(x, y, key, title){
				var result = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=networkIsConnection"));
				if(result && result=="false"){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81528,user.getLanguage())%>");
					return;
				}
				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.Title = "<%=SystemEnv.getHtmlLabelNames("367,81524",user.getLanguage())%>";
				dialog.Width = 800;
				dialog.Height = 500;
				dialog.Drag = true;
				dialog.URL = encodeURI(encodeURI("/hrm/report/schedulediff/showMap.jsp?x="+x+"&y="+y+"&key="+key+"&title="+(title=="null"?(x+","+y):title)));
				dialog.show();
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:exportExcel(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" class="e8_btn_top" onclick="exportExcel();" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage())%>"></input>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%
			String tableString=""+
				"<table datasource=\"weaver.hrm.report.schedulediff1512.HrmScheduleDiffDetLeaveEarlyManager.getScheduleList\" sourceparams=\"fromDate:"+fromDate+"+toDate:"+toDate+"+subCompanyId:"+subCompanyId+"+departmentId:"+departmentId+"+resourceId:"+resourceId+"\" pageId=\""+Constants.HRM_Q_001+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_001,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
				"<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  />"+
				"<head>"+
					"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentname\" orderkey=\"departmentname\" />"+
				    "		<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"resourceName\" orderkey=\"resourceName\" />"+
				    "		<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\"  column=\"resourceId\" orderkey=\"statusName\" transmethod=\"weaver.hrm.report.schedulediff1512.HrmScheduleDiffUtil.getStatusName\" otherpara=\""+user.getLanguage()+"\" />"+
				    "		<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(97,user.getLanguage())+"\" column=\"signDate\" orderkey=\"signDate\" />"+
				    "		<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(20039,user.getLanguage())+"\" column=\"signTime\" orderkey=\"signTime\" />"+
					"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(32531,user.getLanguage())+"\" column=\"clientAddress\" orderkey=\"clientAddress\" />"+
					"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(81524,user.getLanguage())+"\" column=\"addr\" orderkey=\"addr\" />"+
				"</head>"+
				"</table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
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
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	<%} %>
	<iframe name="excels" id="excels" src="" style="display:none" ></iframe>
	</body>
</html>
