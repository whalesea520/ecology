
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.file.ExcelSheet,weaver.file.ExcelRow,weaver.secondary.file.ExcelStyle" %>
<jsp:useBean id="CRM_Feedback" class="weaver.secondary.file.ExcelFile" scope="session" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerTransUtil" class="weaver.crm.report.CustomerTransUtil" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />

<%
	String sql = (String)session.getAttribute("crm_feedback_exportsql");
	
	ExcelSheet es = new ExcelSheet();

	es.addColumnwidth(10000);
	es.addColumnwidth(3000);
	es.addColumnwidth(3000);
	es.addColumnwidth(3000);
	es.addColumnwidth(3000);
	es.addColumnwidth(15000);
	
	ExcelRow title = es.newExcelRow();
	title.setHight(22);
	title.addStringValue(SystemEnv.getHtmlLabelName(1268, user.getLanguage()), "title");//客户
	title.addStringValue(SystemEnv.getHtmlLabelName(1278, user.getLanguage()), "title");//客户经理
	title.addStringValue(SystemEnv.getHtmlLabelName(1929, user.getLanguage()), "title");//当前状态
	title.addStringValue(SystemEnv.getHtmlLabelName(722, user.getLanguage()), "title");//创建日期
	title.addStringValue(SystemEnv.getHtmlLabelName(15591, user.getLanguage()), "title");//是否有效
	title.addStringValue(SystemEnv.getHtmlLabelName(85, user.getLanguage()), "title");//说明
	

	rs.executeSql(sql);
	while (rs.next()) {
		ExcelRow er = es.newExcelRow();
		er.setHight(25);
		er.addStringValue(Util.toScreen(CustomerTransUtil.getCustomer(rs.getString("id")), user.getLanguage()),"normal");
		er.addStringValue(Util.toScreen(CustomerTransUtil.getPerson(rs.getString("manager")), user.getLanguage()),"normal");
		er.addStringValue(Util.toScreen(CustomerStatusComInfo.getCustomerStatusname(rs.getString("status")), user.getLanguage()),"normal");
		er.addStringValue(Util.toScreen(rs.getString("createdate"), user.getLanguage()),"normal");
		er.addStringValue(Util.toScreen(CustomerTransUtil.getIsvalid(rs.getString("isValid"),user.getLanguage()+""), user.getLanguage()),"normal");
		er.addStringValue(Util.toScreen(rs.getString("remark"), user.getLanguage()),"remark");
	}
	CRM_Feedback.init();
	
	ExcelStyle titleStyle = CRM_Feedback.newExcelStyle("title");
	titleStyle.setGroundcolor(ExcelStyle.LIGHT_BLUE_Color);
	titleStyle.setFontcolor(ExcelStyle.WHITE_Color);
	titleStyle.setFontheight(10);
	titleStyle.setFontbold(ExcelStyle.Strong_Font);
	//titleStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
	titleStyle.setAlign(ExcelStyle.ALIGN_LEFT);

	ExcelStyle normalStyle = CRM_Feedback.newExcelStyle("normal");
	normalStyle.setValign(ExcelStyle.VALIGN_CENTER);
	
	ExcelStyle discussStyle = CRM_Feedback.newExcelStyle("remark");
	discussStyle.setWrapText(true);
	discussStyle.setFontheight(8);
	
	CRM_Feedback.setFilename(SystemEnv.getHtmlLabelName(136, user.getLanguage())+SystemEnv.getHtmlLabelName(26180,user.getLanguage())+SystemEnv.getHtmlLabelName(320,user.getLanguage()));
	CRM_Feedback.addSheet(SystemEnv.getHtmlLabelName(136, user.getLanguage())+SystemEnv.getHtmlLabelName(26180,user.getLanguage())+SystemEnv.getHtmlLabelName(320,user.getLanguage()), es);
%>

<script language="javascript">
    window.location="/weaver/weaver.secondary.file.ExcelOut?excelfile=CRM_Feedback";
</script>