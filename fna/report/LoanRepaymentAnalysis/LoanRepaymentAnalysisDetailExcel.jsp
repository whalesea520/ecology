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
if(user==null || !canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}


String jklc = Util.null2s(request.getParameter("jklc"),"-100");
int hrmid = Util.getIntValue(request.getParameter("hrmid"), -100);

String backFields = " temp.* ";

String temp = " from ( select  wb.id, wr.requestid, wr.requestname, wr.creater, wr.creatertype, wr.createdate , SUM(fe.amountBorrow * fe.borrowDirection) sum_amountBorrow \n "+
		      " from FnaBorrowInfo fe "+
 			  " left join workflow_requestbase wr on fe.borrowRequestId = wr.requestid "+
 			  " left join workflow_base wb on wb.id = wr.workflowid \n" +
 			  " where fe.applicantid = "+hrmid+" and fe.borrowRequestId in ("+jklc+") "+
  		      " group by wb.id, wr.requestid, wr.requestname, wr.creater, wr.creatertype, wr.createdate " +
  		      " )temp ";//临时视图

String fromSql = temp ;

String sqlWhere = "";

String orderBy = " temp.createdate "; 

String sql = "select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy;

FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();


ExcelFile.init();
ExcelSheet es = new ExcelSheet();
String sheetname = SystemEnv.getHtmlLabelName(126747, user.getLanguage());//个人借款汇总表 125498
ExcelFile.addSheet(sheetname, es);

ExcelRow er = es.newExcelRow();
er.addStringValue(SystemEnv.getHtmlLabelName(26876, user.getLanguage()));//流程标题
er.addStringValue(SystemEnv.getHtmlLabelName(882, user.getLanguage()));//创建人
er.addStringValue(SystemEnv.getHtmlLabelName(1339, user.getLanguage()));//创建时间
er.addStringValue(SystemEnv.getHtmlLabelName(83288, user.getLanguage()));//未还金额

rs.executeSql(sql);
while(rs.next()){
	String requestname = Util.null2String(rs.getString("requestname"));
	String hrmids = Util.null2String(rs.getString("creater"));
	String createdate = Util.null2String(rs.getString("createdate"));
	String sum_amountBorrow = Util.null2String(rs.getString("sum_amountBorrow"));
	
	er = es.newExcelRow();
	
	er.addStringValue(requestname);//流程标题
	er.addStringValue(fnaSplitPageTransmethod.getOrgNameByHrm(hrmids));//创建人
	er.addStringValue(createdate);//创建日期
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(sum_amountBorrow));//未还金额
}

ExcelFile.setFilename(sheetname);
%>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script type="text/javascript">
var iframe_ExcelOut = document.getElementById("ExcelOut");
iframe_ExcelOut.src = "/weaver/weaver.file.ExcelOut";
</script>