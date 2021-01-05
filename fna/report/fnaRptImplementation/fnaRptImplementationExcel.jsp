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
boolean canview = HrmUserVarify.checkUserRight("fnaRptImplementation:qry",user) ;

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

String sheetname = SystemEnv.getHtmlLabelName(82612, user.getLanguage());//预算执行情况表
ExcelFile.addSheet(sheetname, es);

ExcelRow er = es.newExcelRow();

er.addStringValue(SystemEnv.getHtmlLabelName(18748,user.getLanguage()));//预算单位
er.addStringValue(SystemEnv.getHtmlLabelName(18648,user.getLanguage()));//预算期间
er.addStringValue(SystemEnv.getHtmlLabelName(1462,user.getLanguage()));//预算科目
er.addStringValue(SystemEnv.getHtmlLabelName(82644,user.getLanguage()));//上期结余预算数
er.addStringValue(SystemEnv.getHtmlLabelName(82645,user.getLanguage()));//本期原预算数
er.addStringValue(SystemEnv.getHtmlLabelName(82616,user.getLanguage()));//本期预算总数
er.addStringValue(SystemEnv.getHtmlLabelName(18769,user.getLanguage()));//审批中费用
er.addStringValue(SystemEnv.getHtmlLabelName(82510,user.getLanguage()));//实际发生数
er.addStringValue(SystemEnv.getHtmlLabelName(82511,user.getLanguage()));//可用预算数

String lastOrgNameKey = "";
String feeperiodFullNameKey = "";

String sql = "select * from "+rptTbName+" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' order by id";
rs.executeSql(sql);
while(rs.next()){
	String orgId = Util.null2String(rs.getString("orgId"));
	String orgType = Util.null2String(rs.getString("orgType"));
	String feeperiod = Util.null2String(rs.getString("feeperiod"));
	String q = Util.null2String(rs.getString("q"));
	String fnayear = Util.null2String(rs.getString("fnayear"));
	String subjectId = Util.null2String(rs.getString("subjectId"));
	String budgetAmt1 = Util.null2String(rs.getString("budgetAmt1"));
	String budgetAmt2 = Util.null2String(rs.getString("budgetAmt2"));
	String budgetAmt = Util.null2String(rs.getString("budgetAmt"));
	String approvalAmt = Util.null2String(rs.getString("approvalAmt"));
	String actualAmt = Util.null2String(rs.getString("actualAmt"));
	String availableAmt = Util.null2String(rs.getString("availableAmt"));
	
	er = es.newExcelRow();
	
	String orgName = fnaSplitPageTransmethod.getOrgName(orgId, orgType);
	if(lastOrgNameKey.equals(orgId+"_"+orgType)){
		orgName = "";
	}else{
		lastOrgNameKey = orgId+"_"+orgType;
	}
	
	String feeperiodFullName = fnaSplitPageTransmethod.feeperiodFullName(feeperiod, q+"+"+fnayear+"+"+user.getLanguage());
	if(feeperiodFullNameKey.equals(feeperiod+"_"+q+"_"+fnayear+"_"+user.getLanguage())){
		feeperiodFullName = "";
	}else{
		feeperiodFullNameKey = feeperiod+"_"+q+"_"+fnayear+"_"+user.getLanguage();
	}
	
	er.addStringValue(orgName);
	er.addStringValue(feeperiodFullName);
	er.addStringValue(fnaSplitPageTransmethod.getSubjectNames(subjectId));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(budgetAmt1));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(budgetAmt2));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(budgetAmt));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(approvalAmt));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(actualAmt));
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(availableAmt));
}

ExcelFile.setFilename(sheetname);
%>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script type="text/javascript">
var iframe_ExcelOut = document.getElementById("ExcelOut");
iframe_ExcelOut.src = "/weaver/weaver.file.ExcelOut";
</script>