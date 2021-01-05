<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<%
	String CustomerID=Util.null2String(request.getParameter("CustomerID"));
	String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(431,user.getLanguage());
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		
		<%
			String backfields = " id,crmid,case requesttype when '0' then '接口'  when '1' then '缓存' end as requesttype,requestdate,requesttime,requestuid  ";
			String fromSql  = " from crm_busniessinfolog";
			String sqlWhere = " where crmid = '"+CustomerID+"' ";
			String orderby = " id " ;
			
			String tableString =" <table pageId=\"CRMBusinessInfoLog\" pagesize=\""+PageIdConst.getPageSize("CRMBusinessInfoLog",user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"\"/>"+
			"	<head>"+
			"       <col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(33451,user.getLanguage())+"\" column=\"requestuid\" orderkey=\"requestuid\"  transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(20971,user.getLanguage())+"\" column=\"requesttype\" orderkey=\"requesttype\" />"+
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(31131,user.getLanguage())+"\" column=\"requestdate\" orderkey=\"requestdate\" />"+
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(25130,user.getLanguage())+"\" column=\"requesttime\" orderkey=\"requesttime\" />"+
			"	</head>"+
			" </table>";
		%>
		<input type="hidden" name="pageId" id="pageId" value="CRMBusinessInfoLog">
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
	</body>
</HTML>
