<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<%
%>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
boolean canEditKBVersion = true;
%>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
parentWin = parent.getParentWindow(window);
dialog = parent.parent.getDialog(window);
}catch(e){}
 
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String workflowname = Util.null2String(request.getParameter("workflowname"));
String custompage = Util.null2String(request.getParameter("custompage"));

String backfields = " t1.* ";
String fromSql  = " from workflow_base t1 ";
String sqlWhere = " where 1=1 and custompage is not null "+(rs.getDBType().equals("oracle")?"":" and custompage<>''");
if(!"".equals(workflowname)) {
	sqlWhere+=" and workflowname like '%"+workflowname+"%'";
}
if(!"".equals(custompage)) {
	sqlWhere+=" and custompage like '%"+custompage+"%'";
}


String tableString = "<table instanceid=\"workflowcustompage\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize("custompagelist1",user.getUID())+"\" >"+
"<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"    sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
"<head>"+
  "<col width=\"10%\"  text=\""+"ID"+"\" column=\"id\" orderkey=\"id\"/>"+
  "<col width=\"10%\"  text=\"流程名称\" column=\"workflowname\" orderkey=\"workflowname\" />"+
  "<col width=\"70%\"  text=\"自定义页面\" column=\"custompage\" orderkey=\"custompage\" />"+
  "<col width=\"10%\"  text=\""+"编码格式"+"\" column=\"id\" orderkey=\"id\"  transmethod=\"weaver.templetecheck.PageTransMethod.getFileCharset\"/>"+
"</head>"+
"<operates width=\"10%\">"+
"</operates></table>";  

RCMenu += "{导出,javascript:exportexcel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="/templetecheck/SearchCustomPage.jsp" method="post" name="form1" id="form1" >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="hidden" class="searchInput" id="flowTitle" name="flowTitle" value="" onchange=""/>
			<span id="advancedSearch" class="advancedSearch">高级搜索</span>
			<span title="菜单" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;">LDAP账号列表（未分配部门）</span>
</div>
	
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context="高级搜索">
			<wea:item>流程名称</wea:item>
			<wea:item><input class=InputStyle name="workflowname" id="workflowname" value="<%=workflowname%>"></input></wea:item>
			<wea:item>自定义页面</wea:item>
			<wea:item><input class=InputStyle name="custompage" id="custompage"  value="<%=custompage%>"></input></wea:item>						
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
					<input type="submit"  onclick="doRefresh()" value="搜索" class="zd_btn_submit"/>
					<input type="button" value="重置" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="取消" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="custompagelist1"/>
           	<wea:SplitPageTag  tableString="<%=tableString %>" isShowTopInfo="true" mode="run" />
        </td>
    </tr>
</TABLE>
<div style="color:red;margin-left:10px;">
<h1><b>请查看该文件是否是UTF-8编码；如果不是请按照下面步骤操作：</b></h1>
1)把文件另存为成“UTF-8”编码（或者使用转码工具）；<br>
2)修改contentType，把charset=gbk改成charset=UTF-8；<br>
3)修改weaver.js、Weaver.css成weaver_wev8.js、Weaver_wev8.css（其他引用标准的js、css的地方，请在文件名也加上“_wev8”）；<br>
4)修改TopTitle.jsp、RightClickMenuConent.jsp、RightClickMenu_wev8.jsp成TopTitle_wev8.jsp、RightClickMenuConent_wev8.jsp、RightClickMenu_wev8.jsp。<br>
</div>
</form>
</BODY>

<script type="text/javascript">
$(document).ready(function(){
	$(parent.document.getElementById("objName")).html("流程自定义页面查询");
	//设置标题栏高级查询
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});

function resetCondtion() {
	$("#custompage").val("");
	$("#workflowname").val("");
}
function exportexcel() {
	_xtable_getExcel();
}
function closeDialog(){
	if(dialog)
		dialog.close();
}

function reloadtable() {
	_table.reLoad();
}


function doRefresh(){
	$("#form1").submit();
}


</script>
</HTML>