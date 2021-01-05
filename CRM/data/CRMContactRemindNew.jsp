
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<head>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%
int pagesize=10;
String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
String backFields = "t1.id, t2.before, t2.lastestContactDate";
String sqlFrom = "CRM_CustomerInfo t1, CRM_ContacterLog_Remind t2";
String sqlWhere = "t1.id = t2.customerid AND t1.manager = " + user.getUID()
		+ " AND t1.deleted <> 1 AND t2.isremind = 0"
		+" AND (t2.lastestContactDate is null";
	if(rs.getDBType().equals("oracle")){
		sqlWhere += "  or ((trunc(sysdate,'dd') - trunc(to_date(t2.lastestContactDate ,'yyyy-mm-dd hh24:mi:ss'),'dd' ))  >= before)";
	 }else{
		 sqlWhere += "  or datediff(day , t2.lastestContactDate ,getdate())  >= before";
	 }
	
	sqlWhere += ")";		
String operateString= "<operates width=\"15%\">";
		operateString+=" <popedom transmethod=\"weaver.crm.report.CRMContractTransMethod.getContractInfo\"></popedom> ";
		operateString+="     <operate  href=\"javascript:doViewContactLog()\" linkkey=\"CustomerID\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(6082,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>";
		operateString+="</operates>";
String tableString =" <table instanceid=\"readinfo\"  pageId=\""+PageIdConst.CRM_ContactRemind+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_ContactRemind,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+ 
                "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\"lastestContactDate\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"/>"+
                "<head>"+
				"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(6061,user.getLanguage()) +"\" column=\"id\" orderkey=\"t1.id\"  transmethod=\"weaver.crm.report.CRMContractTransMethod.getCRMName\" />"+ 
				"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(15232,user.getLanguage()) +"\"  column=\"lastestContactDate\" orderkey=\"lastestContactDate\"/>"+
				"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(15792,user.getLanguage()) +"\" column=\"before\" orderkey=\"before\"/>"+
				"</head>"+ operateString+  			
				"</table>";

%>
</head>
  <body>
  	<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_ContactRemind%>"> 
    <wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="true" />
  </body>
  
 <script type="text/javascript">
 	
 	var dialog = null;
	function closeDialog(){
		if(dialog)
			dialog.close();
	}
 	
 	
 	function doViewContactLog(crmid){
		dialog =new window.top.Dialog();
		dialog.currentWindow = window; 
		dialog.Modal = true;
		dialog.Drag=true;
		dialog.Width =600;
		dialog.Height =500;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(31704,user.getLanguage())%>";
		dialog.URL="/CRM/data/ViewContactLog.jsp?log=n&isfromtab=false&CustomerID="+crmid;
		dialog.show();
		document.body.click();
 	}
 	
 	
 
 
 </script> 
</html>
