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
boolean canview = HrmUserVarify.checkUserRight("TheCostOfQueryStatistics:query",user) ;

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

String sheetname = SystemEnv.getHtmlLabelName(82605, user.getLanguage());//费用查询统计表
ExcelFile.addSheet(sheetname, es);

ExcelRow er = es.newExcelRow();

er.addStringValue(SystemEnv.getHtmlLabelName(15486,user.getLanguage()));//序号
er.addStringValue(SystemEnv.getHtmlLabelName(18104,user.getLanguage()));//流程名称
er.addStringValue(SystemEnv.getHtmlLabelName(19502,user.getLanguage()));//流程编号
er.addStringValue(SystemEnv.getHtmlLabelName(18748,user.getLanguage()));//预算单位
er.addStringValue(SystemEnv.getHtmlLabelName(882,user.getLanguage()));//创建人
er.addStringValue(SystemEnv.getHtmlLabelName(783,user.getLanguage()));//相关客户
er.addStringValue(SystemEnv.getHtmlLabelName(782,user.getLanguage()));//相关项目
er.addStringValue(SystemEnv.getHtmlLabelName(722,user.getLanguage()));//创建日期
er.addStringValue(SystemEnv.getHtmlLabelName(1447,user.getLanguage()));//总金额

String sql = "select * from "+rptTbName+" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' order by id";
rs.executeSql(sql);
while(rs.next()){
	String orderNum = Util.null2String(rs.getString("orderNum"));
	String requestmark = Util.null2String(rs.getString("requestmark"));
	String requestname = Util.null2String(rs.getString("requestname"));
	String orgJsonStr = Util.null2String(rs.getString("orgJsonStr"));
	String creater = Util.null2String(rs.getString("creater"));
	String crmIds = Util.null2String(rs.getString("crmIds"));
	String prjIds = Util.null2String(rs.getString("prjIds"));
	String createdate = Util.null2String(rs.getString("createdate"));
	String createtime = Util.null2String(rs.getString("createtime"));
	String sumAmt = Util.null2String(rs.getString("sumAmt"));
	
	er = es.newExcelRow();
	
	er.addStringValue(orderNum);
	er.addStringValue(requestname);
	er.addStringValue(requestmark);
	er.addStringValue(fnaSplitPageTransmethod.getOrgNameByJsonStr(orgJsonStr, user.getLanguage()+"", "; "));
	er.addStringValue(fnaSplitPageTransmethod.getLastName(creater));
	er.addStringValue(fnaSplitPageTransmethod.getCrmNames(crmIds, "1"));
	er.addStringValue(fnaSplitPageTransmethod.getPrjNames(prjIds, "1"));
	er.addStringValue(createdate+" "+createtime);
	er.addStringValue(fnaSplitPageTransmethod.fmtAmount(sumAmt));
}

ExcelFile.setFilename(sheetname);
%>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script type="text/javascript">
var iframe_ExcelOut = document.getElementById("ExcelOut");
iframe_ExcelOut.src = "/weaver/weaver.file.ExcelOut";
</script>