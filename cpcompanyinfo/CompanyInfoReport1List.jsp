
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
	String o4searchTX = Util.null2String(request.getParameter("o4searchTX"));
	String o4searchSL = Util.null2String(request.getParameter("o4searchSL"));
	String sqlwhere1 = "";
	String sqlwhere2 = "";
	String sqlwhere3 = "";
	if(o4searchSL.equals("d-officename")){
		//System.out.println();
		if(!o4searchTX.equals("")){
			sqlwhere2 = " and co.officename like '%"+o4searchTX+ "%'";
		}
		sqlwhere3 = " and 1 = 2";
	}else if(o4searchSL.equals("j-officename")){
		sqlwhere2 = " and 1 = 2";
		if(!o4searchTX.equals("")){
			sqlwhere3 = " and cu.supername like '%"+o4searchTX+ "%'";
		}
	}else{
		if(!o4searchTX.equals("")){
				sqlwhere1 = " and "+o4searchSL+" like '%"+o4searchTX+ "%'";
		}
	}
	//System.out.println("sqlwhere1"+sqlwhere1);
	//System.out.println("sqlwhere2"+sqlwhere2);
	//System.out.println("sqlwhere3"+sqlwhere3);
	String backfields="";
	StringBuffer fromSql = new StringBuffer();
	if("sqlserver".equals(rs.getDBType())){
			backfields = " companyid,archivenum,companyname,effectdate,corporation,usefuldate,officename,officedate,generalmanager,managerdate ";
			fromSql.append("(");
			fromSql.append(" select ci.companyid,ci.archivenum,ci.companyname,(cs.effectbegindate+' - '+cs.effectenddate) as effectdate,");
			fromSql.append(" (select cb.corporation from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1) as corporation,");
			fromSql.append(" ((select cb.usefulbegindate from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1)+' - '+");
			fromSql.append(" (select cb.usefulenddate from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1)) as usefuldate,");
			fromSql.append(" co.officename,(co.officebegindate+' - '+co.officeenddate) as officedate,cd.generalmanager,(cd.managerbegindate+' - '+cd.managerenddate) as managerdate");
			fromSql.append(" from cpcompanyinfo ci,cpconstitution cs,cpboarddirectors cd,cpboardofficer co where ci.companyid = cs.companyid");
			fromSql.append(" and cd.companyid = ci.companyid and cd.directorsid = co.directorsid" + sqlwhere2);
			fromSql.append(" union");
			fromSql.append(" select ci.companyid,ci.archivenum,ci.companyname,(cs.effectbegindate+' - '+cs.effectenddate) as effectdate,");
			fromSql.append(" (select cb.corporation from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1) as corporation,");
			fromSql.append(" ((select cb.usefulbegindate from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1)+' - '+");
			fromSql.append(" (select cb.usefulenddate from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1)) as usefuldate,");
			fromSql.append(" cu.supername,(cu.superbegindate+' - '+cu.superenddate) as officedate,cd.generalmanager,(cd.managerbegindate+' - '+cd.managerenddate) as managerdate");
			fromSql.append(" from cpcompanyinfo ci,cpconstitution cs,cpboarddirectors cd,cpboardsuper cu where ci.companyid = cs.companyid");
			fromSql.append(" and cd.companyid = ci.companyid and cd.directorsid = cu.directorsid "+ sqlwhere3 +") s ");
	}else{
			backfields = " companyid,archivenum,companyname,effectdate,corporation,usefuldate,officename,officedate,generalmanager,managerdate ";
			fromSql.append("(");
			fromSql.append(" select ci.companyid,ci.archivenum,ci.companyname,(cs.effectbegindate||' - '||cs.effectenddate) as effectdate,");
			fromSql.append(" (select cb.corporation from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1) as corporation,");
			fromSql.append(" ((select cb.usefulbegindate from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1)||' - '||");
			fromSql.append(" (select cb.usefulenddate from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1)) as usefuldate,");
			fromSql.append(" co.officename,(co.officebegindate||' - '||co.officeenddate) as officedate,cd.generalmanager,(cd.managerbegindate||' - '||cd.managerenddate) as managerdate");
			fromSql.append(" from cpcompanyinfo ci,cpconstitution cs,cpboarddirectors cd,cpboardofficer co where ci.companyid = cs.companyid");
			fromSql.append(" and cd.companyid = ci.companyid and cd.directorsid = co.directorsid" + sqlwhere2);
			fromSql.append(" union");
			fromSql.append(" select ci.companyid,ci.archivenum,ci.companyname,(cs.effectbegindate||' - '||cs.effectenddate) as effectdate,");
			fromSql.append(" (select cb.corporation from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1) as corporation,");
			fromSql.append(" ((select cb.usefulbegindate from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1)||' - '||");
			fromSql.append(" (select cb.usefulenddate from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1)) as usefuldate,");
			fromSql.append(" cu.supername,(cu.superbegindate||' - '||cu.superenddate) as officedate,cd.generalmanager,(cd.managerbegindate||' - '||cd.managerenddate) as managerdate");
			fromSql.append(" from cpcompanyinfo ci,cpconstitution cs,cpboarddirectors cd,cpboardsuper cu where ci.companyid = cs.companyid");
			fromSql.append(" and cd.companyid = ci.companyid and cd.directorsid = cu.directorsid "+ sqlwhere3 +") s ");
	}
			
	String sqlwhere = "   where 1=1 " + sqlwhere1;
	String sqlorderby = " archivenum ";
	String sqlsortway = " asc ";
	StringBuffer tableString = new StringBuffer();
	tableString .append(" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\"10\" width=\"100%\" isfixed=\"true\" isnew= \"true\" _style= \"true\"> ");
	tableString .append(" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+sqlwhere+"\"  sqlorderby=\""+sqlorderby+"\"  sqlprimarykey=\"companyid\" sqlsortway=\""+sqlsortway+"\"  />");
	tableString .append(" <head>");
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\"  column=\"archivenum\"   orderkey=\"archivenum\"  align=\"center\"   		width=\"5%\"  />");
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(1976,user.getLanguage())+"\" column=\"companyname\" orderkey=\"companyname\"  align=\"center\"  width=\"15%\"	/>");        
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(31063,user.getLanguage())+"\"   column=\"effectdate\" orderkey=\"usefulbegindate\" align=\"center\"  width=\"10%\"  />");
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(23797,user.getLanguage())+"\" column=\"corporation\"   orderkey=\"corporation\" width=\"8%\"  align=\"center\"  />");     
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(31064,user.getLanguage())+"\" column=\"usefuldate\"  orderkey=\"usefuldate\"  align=\"center\"  width=\"10%\" />");           
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(31065,user.getLanguage())+"\" column=\"officename\" orderkey=\"officename\"  width=\"8%\"	 align=\"center\"   />");    
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(31064,user.getLanguage())+"\" column=\"officedate\"  orderkey=\"officedate\"  align=\"center\"   width=\"10%\" />"); 
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(20696,user.getLanguage())+"\" column=\"generalmanager\" orderkey=\"generalmanager\"   align=\"center\"   width=\"8%\" />");
    tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(31064,user.getLanguage())+"\" column=\"managerdate\"  orderkey=\"managerdate\"  align=\"center\"   width=\"10%\" />");
    tableString.append(" </head> </table>");
	        
%>
<div style="padding: 10px">
<wea:SplitPageTag   tableString='<%=tableString.toString()%>'  mode="run"  isShowTopInfo="false" isShowBottomInfo="true"/>	
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		
	});
	/*刷新自身页面*/
	function reloadListContent(){
		window.location.reload();
	}
</script>
