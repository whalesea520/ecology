<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ include file="/jsp/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.Prop"%>
<%@ page import="com.weaver.update.PackageUtil"%>

<%@ page import="weaver.general.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><head>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

</head>
<BODY>

<% 
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33728,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(30947,user.getLanguage())+",javascript:onSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

String packageno = Util.null2String(request.getParameter("packageno"));
String sqlfilename = Util.null2String(request.getParameter("sqlfilename"));

String backfields = " t1.* ";
String fromSql  = " from SqlFileLogInfo t1 ";
String sqlWhere = " where 1=1 ";
if(!"".equals(packageno)) {
	sqlWhere = sqlWhere + " and packageno like '%"+packageno+"%'";
}
if(!"".equals(sqlfilename)) {
	sqlWhere = sqlWhere + " and sqlfilename like '%"+sqlfilename+"%'";
}

String orderby  = " t1.id ";
String PageConstId = "sqlfilelist"; 
String tableString = "<table instanceid=\"designateTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" >"+
"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlorderby=\"" + orderby + "\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"    sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
"			<head>";
tableString += "<col width=\"10%\"   text=\""+"ID"+"\" column=\"id\"  orderkey=\"t1.id\"/>";
tableString +="	<col width=\"10%\"   text=\""+"补丁包编号"+"\" column=\"packageno\" orderkey=\"t1.packageno\"/>";
tableString +="	<col width=\"30%\"   text=\""+"脚本名称"+"\" column=\"sqlfilename\" orderkey=\"t1.sqlfilename\"/>";
tableString +="	<col width=\"20%\"   text=\""+"执行日期"+"\" column=\"rundate\" orderkey=\"t1.rundate\"/>";
tableString +="	<col width=\"20%\"   text=\""+"执行时间"+"\" column=\"runtime\" orderkey=\"t1.versionNo\"/>";
tableString +="	<col width=\"10%\"   text=\""+"耗时(单位：秒)"+"\" column=\"exectime\" orderkey=\"t1.exectime\"/>";
tableString +="</head></table>";

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="脚本执行效率报表" />
</jsp:include>
<iframe name="excels" id="excels" src="" style="display:none" ></iframe> 
<form action="/jsp/sqlLog.jsp" name="sqlLog" id="sqlLog">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="text" class="searchInput" id="content1" name="content1" value=""/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch" onclick="clicksearch()"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
		</td>
	</tr>
</table>
<div id="tabDiv" >
	 <span style="font-size:14px;font-weight:bold;"></span> 
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context="<%= SystemEnv.getHtmlLabelName(347,user.getLanguage())%>">
			<wea:item>补丁包编号</wea:item>
			<wea:item><input type="text" name="packageno" value="<%=packageno%>"></wea:item>
			<wea:item>脚本名称</wea:item>
			<wea:item><input type="text" name="sqlfilename" value="<%=sqlfilename%>"></wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
					<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="zd_btn_submit"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>	
<%

%>
<TABLE width="100%" id="datatable">
 <tr>
     <td valign="top">  
     	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
        	<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
        </td>
    </tr>
</TABLE>	
</form>
</BODY></HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script>
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});

function clicksearch() {

	$("#content1").val("");
}
function resetCondtion() {
	$("#sqlLog input[type=text]").val('');
}
function doRefresh()
{
	$("#sqlLog").submit(); 
}


function onSearch(){
	sqlLog.submit();
}


</script>
