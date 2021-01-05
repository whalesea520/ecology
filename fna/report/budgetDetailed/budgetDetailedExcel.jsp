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
boolean canview = HrmUserVarify.checkUserRight("fnaRptBudgetDetailed:qry",user) ;

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

String sheetname = SystemEnv.getHtmlLabelName(82629, user.getLanguage());//费用预算细化表
ExcelFile.addSheet(sheetname, es);

ExcelRow er = es.newExcelRow();

List colDbName_list = new ArrayList();
rs.executeSql("select * from fnaTmpTbLogColInfo a where a.guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' ORDER BY id");
int colCount = rs.getCounts();
while(rs.next()){
	String colDbName = Util.null2String(rs.getString("colDbName")).trim();
	String colType = Util.null2String(rs.getString("colType")).trim();
	int colValueInt = Util.getIntValue(rs.getString("colValueInt"));
	
	
	if(SystemEnv.getHtmlLabelNames("585,18621", user.getLanguage()).equals(colType)){
		er.addStringValue(SystemEnv.getHtmlLabelName(1462,user.getLanguage()));//预算科目
	}else{
		colDbName_list.add(colDbName);
		er.addStringValue(SystemEnv.getHtmlLabelName(colValueInt,user.getLanguage()));//结果列名称
	}
}

DecimalFormat df = new DecimalFormat("####################################################0.00");
HashMap<String, String> sumAmtHm = new HashMap<String, String>();
String sql = "select * from "+rptTbName+" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' order by id";
rs.executeSql(sql);
while(rs.next()){
	String subject = Util.null2String(rs.getString("subject"));
	
	er = es.newExcelRow();
	
	er.addStringValue(fnaSplitPageTransmethod.getSubjectNames(subject));

	for(int i=0;i<colDbName_list.size();i++){
		String colDbName = (String)colDbName_list.get(i);
		String _showVal = Util.null2String(rs.getString(colDbName));
		er.addStringValue(fnaSplitPageTransmethod.fmtAmount(_showVal));
		FnaReport.sumAmount(colDbName, Util.getDoubleValue(_showVal, 0.0), sumAmtHm, df);
	}
}

er = es.newExcelRow();

er.addStringValue(SystemEnv.getHtmlLabelName(358,user.getLanguage()));//合计
for(int i=0;i<colDbName_list.size();i++){
	String colDbName = (String)colDbName_list.get(i);
	String _showVal = sumAmtHm.get(colDbName);
	er.addStringValue(_showVal);
}

ExcelFile.setFilename(sheetname);
%>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script type="text/javascript">
var iframe_ExcelOut = document.getElementById("ExcelOut");
iframe_ExcelOut.src = "/weaver/weaver.file.ExcelOut";
</script>