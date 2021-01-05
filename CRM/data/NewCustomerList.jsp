
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<head>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16400,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
int pagesize=10;
String backFields = "t1.id, t1.name,t1.type,t1.manager,t1.status,t2.movedate";
String sqlFrom = "CRM_CustomerInfo t1 ,CRM_ViewLog2 t2";
String sqlWhere = "(t1.deleted=0 or t1.deleted is null) and t1.id=t2.customerid and t1.manager="+user.getUID();
String orderby = "t2.movedate desc,t2.movetime";

String operateString= "<operates width=\"15%\">";
		operateString+=" <popedom transmethod=\"weaver.crm.report.CRMContractTransMethod.getContractInfo\"></popedom> ";
		operateString+="     <operate  href=\"/CRM/data/ViewContactLog.jsp\" linkkey=\"CustomerID\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(6082,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>";
		operateString+="</operates>";
String tableString =" <table instanceid=\"readinfo\"  pageId=\""+PageIdConst.CRM_NewCustomerList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_NewCustomerList,user.getUID(),PageIdConst.CRM)+"\" >"+ 
                "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"/>"+
                "<head>"+
				"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(1268,user.getLanguage()) +"\" column=\"name\" "+
					" href=\"/CRM/data/ViewCustomer.jsp\" linkkey=\"CustomerID\"  linkvaluecolumn=\"id\"/>"+ 
				"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(63,user.getLanguage()) +"\" column=\"type\""+
					" transmethod=\"weaver.crm.Maint.CustomerTypeComInfo.getCustomerTypename\"/>"+
				"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(1278,user.getLanguage()) +"\" column=\"id\" "+
					" href=\"/hrm/resource/HrmResource.jsp\" linkkey=\"id\"  linkvaluecolumn=\"manager\" "+
					" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+ 
				"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(1929,user.getLanguage()) +"\" column=\"status\""+
					" transmethod=\"weaver.crm.Maint.CustomerStatusComInfo.getCustomerStatusname\"/>"+
				"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(18901,user.getLanguage()) +"\" column=\"movedate\"/>"+ 
				"</head>"+  			
				"</table>";

%>
</head>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
		<td></td>
	</tr>
</table>

  <body>
  	<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_NewCustomerList%>">
    <wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="true" />
  </body>
  
  
</html>
