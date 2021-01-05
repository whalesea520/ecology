<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.general.Util,weaver.file.ExcelSheet,weaver.file.ExcelRow,weaver.secondary.file.ExcelStyle" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecExcelFile" class="weaver.secondary.file.ExcelFile" scope="session" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<%
	String sql = (String)request.getSession().getAttribute("GP_ACCESSRESULT_SQL");
	String titlename = (String)request.getSession().getAttribute("GP_ACCESSRESULT_TITLE")+TimeUtil.getCurrentTimeString().replaceAll("-","").replaceAll(":","").replaceAll(" ","");
	
	ExcelSheet es = new ExcelSheet();

	es.addColumnwidth(4000);
	es.addColumnwidth(4000);
	es.addColumnwidth(6000);
	es.addColumnwidth(6000);
	es.addColumnwidth(6000);
	es.addColumnwidth(3000);

	ExcelRow title = es.newExcelRow();
	title.setHight(20);
	title.addStringValue("编号", "title");
	title.addStringValue("姓名", "title");
	title.addStringValue("分部", "title");
	title.addStringValue("部分", "title");
	title.addStringValue("岗位", "title");
	title.addStringValue("得分", "title");

	rs.executeSql(sql);
	while (rs.next()) {
		ExcelRow er = es.newExcelRow();
		er.setHight(20);
		er.addStringValue(Util.toScreen(rs.getString("workcode"), user.getLanguage()),"normal");
		er.addStringValue(Util.toScreen(rs.getString("lastname"), user.getLanguage()),"normal");
		er.addStringValue(SubCompanyComInfo.getSubCompanyname(rs.getString("subcompanyid1")),"normal");
		er.addStringValue(DepartmentComInfo.getDepartmentname(rs.getString("departmentid")),"normal");
		er.addStringValue(JobTitlesComInfo.getJobTitlesname(rs.getString("jobtitle")),"normal");
		er.addValue(Util.null2String(rs.getString("result")),"normal");
	}
	SecExcelFile.init();

	ExcelStyle titleStyle = SecExcelFile.newExcelStyle("title");
	titleStyle.setGroundcolor(ExcelStyle.BLUE_Color);
	titleStyle.setFontcolor(ExcelStyle.WHITE_Color);
	titleStyle.setFontbold(ExcelStyle.Strong_Font);
	titleStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
	titleStyle.setAlign(ExcelStyle.ALIGN_LEFT);
	
	ExcelStyle normalStyle = SecExcelFile.newExcelStyle("normal");
	normalStyle.setValign(ExcelStyle.VALIGN_CENTER);
	
	ExcelStyle detailStyle = SecExcelFile.newExcelStyle("detail");
	detailStyle.setWrapText(true);
	detailStyle.setFontheight(9);

	SecExcelFile.setFilename(titlename);
	SecExcelFile.addSheet(titlename, es);
%>

<script language="javascript">
	window.location="/weaver/weaver.secondary.file.ExcelOut";
</script>