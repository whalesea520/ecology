
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT type="text/javascript" src="/formmode/js/WdatePicker/WdatePicker_wev8.js"></script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<style>
td.e8_tblForm_label{
	vertical-align: middle !important;
}
</style>
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String titlename = "";
	
	String customid = Util.null2String(request.getParameter("objid"));


%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<%


String SqlWhere = " where a.customid="+customid ;
String perpage = "10";
String backFields = " a.id,a.name,a.showname,a.customid,a.datasourceid,a.sqltext,a.detailpageurl ";
String sqlFrom = " from datashowset a ";
String tableString=""+
	"<table  pagesize=\""+perpage+"\" tabletype=\"none\" >"+
		"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			"<head>"+//标识          
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"showname\"  transmethod=\"weaver.formmode.service.BrowserInfoService.getBrowserTitle\" otherpara=\"column:showname+column:id+"+customid+"\"  />"+
				//名称
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\"  />"+
				//数据源
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18076,user.getLanguage())+"\" column=\"datasourceid\" transmethod=\"weaver.formmode.service.BrowserInfoService.getBrowserDs\"  />"+
				//无条件查询
				"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(23676,user.getLanguage())+"\" column=\"sqltext\"  />"+
				//链接地址
				"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(16208,user.getLanguage())+"\" column=\"detailpageurl\"  />"+
			"</head>"+
	"</table>";
%>

<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>

<script type="text/javascript">
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})
</script>

</BODY>
</HTML>
