
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%> 
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/cpcompanyinfo/style/Business_wev8.css" rel="stylesheet"
			type="text/css" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<style type="text/css">
<!--
TABLE.ListStyle {
	width:"100%" ;
	BACKGROUND-COLOR: #b8c2c8 ;
	BORDER-Spacing:1px; 
}
.xTable_info{
	margin-top:0px;
	text-align:right;
	font-size:9pt;
}
-->

</style>

<%	
	String feCompany = Util.null2String(request.getParameter("feCompany"));
	String isselected = Util.null2String(request.getParameter("isselected"));
	String backfields ="";
	if("sqlserver".equals(rs.getDBType())){
		 backfields = " t1.companyid,t1.archivenum,t1.companyregion,t1.companyname,t2.usefulbegindate,t2.registercapital,t2.companytype,t2.usefulenddate,t3.stituenddate,t3.effectenddate,(case substring(t1.archivenum,0,1) when 'L' then 1 when 'H' then 2 when 'R' then 3 when 'W' then 4 end ) as abilty ";
	}else{
		 backfields = " t1.companyid,t1.archivenum,t1.companyregion,t1.companyname,t2.usefulbegindate,t2.registercapital,t2.companytype,t2.usefulenddate,t3.stituenddate,t3.effectenddate,(case substr(t1.archivenum,0,1) when 'L' then 1 when 'H' then 2 when 'R' then 3 when 'W' then 4 end ) as abilty ";
	}
	
	
	String fromSql = " CPCOMPANYINFO t1 left join (select tb.* from CPBUSINESSLICENSE tb,CPLMLICENSEAFFIX tl where tb.licenseaffixid=tl.licenseaffixid and tl.licensetype=1 and tb.isdel='T') t2 on t1.companyid = t2.companyid left join CPCONSTITUTION t3 on  t1.companyid=t3.companyid ";
	String sqlwhere = " where t1.isdel='T' ";
	sqlwhere += " and t1.businesstype not in( select id from CompanyBusinessService where affixindex=-1)  ";	//过滤掉自然人
	//System.out.println(user.getUID());
	if(!feCompany.equals("")){
		sqlwhere +=" and t1.subcompanyid="+feCompany;
	}
	if(isselected.equals("0")){
		sqlwhere +=" and t1.subcompanyid = 0";
	}
	
	String sqlorderby = " abilty,t1.archivenum ";
	String sqlsortway = " asc ";
	
	StringBuffer tableString = new StringBuffer();
	tableString .append(" <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\"10\" width=\"100%\" isfixed=\"true\" isnew= \"true\" _style= \"true\"> ");
	tableString .append(" <checkboxpopedom    popedompara=\"column:companyid\" showmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getIsShowBox\" />");
	tableString .append(" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+sqlwhere+"\"  sqlorderby=\""+sqlorderby+"\"  sqlprimarykey=\"t1.companyid\" sqlsortway=\""+sqlsortway+"\"  />");
	tableString .append(" <head>");                  
	      
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\"  column=\"archivenum\"   orderkey=\"archivenum\"  align=\"center\"   		width=\"8%\"  />");
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(15114,user.getLanguage())+"\" column=\"companyregion\"    align=\"center\" transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getCompanyRegion\" width=\"10%\"	 />");
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(1976,user.getLanguage())+"\" column=\"companyname\"   align=\"center\"  width=\"20%\" />");        
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(30975,user.getLanguage())+"\"   column=\"usefulbegindate\" orderkey=\"usefulbegindate\" align=\"center\"  width=\"10%\"  />");
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(30976,user.getLanguage())+"\" column=\"companytype\"   orderkey=\"progress\" width=\"15%\"  align=\"center\"  />");     
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(20668,user.getLanguage())+"\" column=\"registercapital\"    align=\"center\"  width=\"8%\" />");           
    tableString.append(" </head> </table>");
	        
%>
<wea:SplitPageTag   tableString='<%=tableString.toString()%>'  mode="run"  isShowTopInfo="false" isShowBottomInfo="true"/>	

<script type="text/javascript">
	jQuery(document).ready(function(){
		
	});
	/*刷新自身页面*/
	function reloadListContent(){
		window.location.reload();
	}
	/*获得公司资料 ID*/
	function getrequestids(){
		var requestids = _xtable_CheckedCheckboxId();
		return requestids;
	}
</script>
