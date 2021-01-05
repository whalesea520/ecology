<%@page import="weaver.fna.report.FnaReport"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="weaver.file.ExcelRow"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.file.ExcelSheet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
boolean canview = HrmUserVarify.checkUserRight("TotalBudgetTable:qry",user) ;

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();

String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();



HashMap<String, String> retHm = FnaReport.getFnaReportShareLevel(_guid1, user.getUID());

boolean isView = "true".equals(retHm.get("isView"));//查看
boolean isEdit = "true".equals(retHm.get("isEdit"));//编辑
boolean isFull = "true".equals(retHm.get("isFull"));//完全控制
if(!isView && !isEdit && !isFull) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}


String tbName = "";
String rptTbName = "";
rs.executeSql("select * from fnaTmpTbLog where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"'");
if(rs.next()){
	tbName = Util.null2String(rs.getString("tbName")).trim();
	rptTbName = Util.null2String(rs.getString("tbDbName")).trim();
}
   

ExcelFile.init();

ExcelSheet es = new ExcelSheet();

String sheetname = SystemEnv.getHtmlLabelName(82502, user.getLanguage());//预算总额表
ExcelFile.addSheet(sheetname, es);

ExcelRow er = es.newExcelRow();

er.addStringValue(SystemEnv.getHtmlLabelName(18748,user.getLanguage()));//预算单位
er.addStringValue(SystemEnv.getHtmlLabelName(18648,user.getLanguage()));//预算期间
er.addStringValue(SystemEnv.getHtmlLabelName(23577,user.getLanguage()));//预算数
er.addStringValue(SystemEnv.getHtmlLabelName(18769,user.getLanguage()));//审批中费用
er.addStringValue(SystemEnv.getHtmlLabelName(82510,user.getLanguage()));//实际发生数
er.addStringValue(SystemEnv.getHtmlLabelName(82511,user.getLanguage()));//可用预算数
er.addStringValue(SystemEnv.getHtmlLabelName(82512,user.getLanguage()));//执行比

String sql = "select * from "+rptTbName+" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' order by id";
rs.executeSql(sql);
while(rs.next()){
	String orgId = Util.null2String(rs.getString("orgId"));
	String orgType = Util.null2String(rs.getString("orgType"));
	String feeperiod = Util.null2String(rs.getString("feeperiod"));
	String q = Util.null2String(rs.getString("q"));
	String fnayear = Util.null2String(rs.getString("fnayear"));
	String budgetAmt = Util.null2String(rs.getString("budgetAmt"));
	String approvalAmt = Util.null2String(rs.getString("approvalAmt"));
	String actualAmt = Util.null2String(rs.getString("actualAmt"));
	String availableAmt = Util.null2String(rs.getString("availableAmt"));
	String execRatio = Util.null2String(rs.getString("execRatio"));
	
	er = es.newExcelRow();
	
	er.addStringValue(fnaSplitPageTransmethod.getOrgName(orgId, orgType));
	er.addStringValue(fnaSplitPageTransmethod.feeperiodFullName(feeperiod, q+"+"+fnayear+"+"+user.getLanguage()));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(budgetAmt));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(approvalAmt));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(actualAmt));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(availableAmt));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmountRatio(execRatio));
}

ExcelFile.setFilename(sheetname);
%>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script type="text/javascript">
var iframe_ExcelOut = document.getElementById("ExcelOut");
iframe_ExcelOut.src = "/weaver/weaver.file.ExcelOut";
</script>