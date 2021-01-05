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
boolean canview = HrmUserVarify.checkUserRight("LoanRepaymentAnalysis:qry",user) ;

/* if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
} */

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

String sheetname = SystemEnv.getHtmlLabelName(125498, user.getLanguage());//个人借款汇总表
ExcelFile.addSheet(sheetname, es);

ExcelRow er = es.newExcelRow();

er.addStringValue(SystemEnv.getHtmlLabelName(124, user.getLanguage()));//预算单位
er.addStringValue(SystemEnv.getHtmlLabelName(413, user.getLanguage()));//姓名
er.addStringValue(SystemEnv.getHtmlLabelName(25960, user.getLanguage()));//借款总金额
er.addStringValue(SystemEnv.getHtmlLabelName(83286, user.getLanguage()));//已还金额
er.addStringValue(SystemEnv.getHtmlLabelName(83287, user.getLanguage()));//审批中待还金额
er.addStringValue(SystemEnv.getHtmlLabelName(83288, user.getLanguage()));//未还金额

String sql = "select * from "+rptTbName+" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' order by id";
rs.executeSql(sql);
while(rs.next()){
	String departmentid = Util.null2String(rs.getString("departmentid"));
	String hrmid = Util.null2String(rs.getString("hrmid"));
	String borrowAmt = Util.null2String(rs.getString("borrowAmt"));
	String repayAmt = Util.null2String(rs.getString("repayAmt"));
	String pendingRepayAmt = Util.null2String(rs.getString("pendingRepayAmt"));
	String remainAmt = Util.null2String(rs.getString("remainAmt"));
	
	er = es.newExcelRow();
	
	er.addStringValue(fnaSplitPageTransmethod.getOrgNameByDept(departmentid));
	er.addStringValue(fnaSplitPageTransmethod.getOrgNameByHrm(hrmid));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(borrowAmt));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(repayAmt));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(pendingRepayAmt));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(remainAmt));
}

ExcelFile.setFilename(sheetname);
%>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script type="text/javascript">
var iframe_ExcelOut = document.getElementById("ExcelOut");
iframe_ExcelOut.src = "/weaver/weaver.file.ExcelOut";
</script>