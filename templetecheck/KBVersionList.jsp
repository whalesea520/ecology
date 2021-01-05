<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<%
String titlename = "";
String needfav ="1";
String needhelp ="";

boolean isright = true;
String patchtype = Util.null2String(request.getParameter("patchtype"));
String sysversion = Util.null2String(request.getParameter("sysversion"));
String kbversion = Util.null2String(request.getParameter("kbversion"));
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
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

// RCMenu += "{查询,javascript:submitData(),_self} " ;
// RCMenuHeight += RCMenuHeightStep ;
// RCMenu += "{清除,javascript:onClear(),_self} " ;
// RCMenuHeight += RCMenuHeightStep ;

String fromSql = "";
if("patch".equals(patchtype)) {
	fromSql = " from CustomerKBVersion t1 ";
} else {
	fromSql = " from CustomerSysVersion t1 ";
}

String backfields = "";
String sqlWhere  = " where 1=1 ";
String orderby = "";
String instanceidStr="";
if("patch".equals(patchtype)){
	backfields = " t1.id, t1.name, t1.sysversion ";
	
	if(sysversion!=null && !"".equals(sysversion)) {
		sqlWhere = sqlWhere + "  and t1.sysversion like '%"+sysversion+"%' ";
	}
	if(kbversion!=null && !"".equals(kbversion)) {
		sqlWhere = sqlWhere + " and t1.name like '%"+kbversion+"%' ";
	}
	orderby = " t1.sysversion desc,t1.name desc ";
	instanceidStr="kbversionlist1";
}else{
	backfields = " t1.id,t1.name ";
	if(sysversion!=null && !"".equals(sysversion)) {
		sqlWhere = sqlWhere + "  and t1.name like '%"+sysversion+"%' ";
	}
	orderby = " t1.name desc";
	instanceidStr="kbversionlist2";
}

String tableString = "<table instanceid=\"instanceidStr\" tabletype=\"none\" pageId=\""+instanceidStr+"\" pagesize=\""+PageIdConst.getPageSize(instanceidStr,user.getUID())+"\" >"+
"<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
"<head>"+
  "<col width=\"20%\"  text=\"名称\" column=\"name\" orderkey=\"name\"/>";
  if("patch".equals(patchtype)) {
	  tableString = tableString + "<col width=\"30%\"  text=\"系统版本\" column=\"sysversion\" orderkey=\"sysversion\" />";
  }
tableString = tableString + "</head>"+
"<operates width=\"10%\">"+
	"<operate href=\"javascript:showconfigdetail();\" index=\"0\" otherpara=\"column:name\" text=\"配置信息\" />"+
	"<operate href=\"javascript:qcdetail();\" index=\"1\" otherpara=\"column:name\" text=\""+"QC详细信息\" />"+
"</operates></table>";  

%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name="form1" id="form1" STYLE="margin-bottom:0" action="KBVersionList.jsp" method=post>
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

		<wea:item>系统版本</wea:item>
			<wea:item>
			<brow:browser viewType="0"  id="sysversion" name="sysversion" browserValue="<%=sysversion %>" 
			    browserOnClick=""
			    browserUrl="/systeminfo/BrowserMain.jsp?url=/templetecheck/SysBrowser.jsp"
			    hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
			    width="165px"
			    browserSpanValue="<%=sysversion %>"></brow:browser>
			</wea:item>
			
						
			<% if("patch".equals(patchtype)) {%>
			<wea:item>补丁包版本</wea:item>
			<wea:item>
				<brow:browser viewType="0"  id="kbversion" name="kbversion" browserValue="<%=kbversion %>" 
			    browserUrl="" getBrowserUrlFn='onShowKBVersion'
			    hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
			    width="165px" browserSpanValue="<%=kbversion %>"></brow:browser>
			</wea:item>
			<%}%>
			
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
<input name="patchtype" value="<%=patchtype%>" type="hidden"/>
<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%=instanceidStr%>>"/>
           	<wea:SplitPageTag  tableString="<%=tableString %>" isShowTopInfo="true" mode="run" />
        </td>
    </tr>
</TABLE>
</FORM>
</BODY>
<script type="text/javascript">
$(document).ready(function(){
	//设置标题栏高级查询
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});

function showconfigdetail(id,name) {
	$("input[name='type']").val("config");
	if("<%=patchtype%>" == "patch"){
		parent.window.location.href = "/templetecheck/ConfigManagerIframe.jsp?type=config&kbversion="+name+"&patchtype=<%=patchtype%>";
	}else if("<%=patchtype%>" == "sys"){
		parent.window.location.href = "/templetecheck/ConfigManagerIframe.jsp?type=config&sysversion="+name+"&patchtype=<%=patchtype%>";
	}
	return;
}

function qcdetail(id,name) {
	if("<%=patchtype%>" == "patch"){
		parent.window.location.href = "/templetecheck/ConfigManagerIframe.jsp?type=qc&kbversion="+name+"&patchtype=<%=patchtype%>";
	}else if("<%=patchtype%>" == "sys"){
		parent.window.location.href = "/templetecheck/ConfigManagerIframe.jsp?type=qc&sysversion="+name+"&patchtype=<%=patchtype%>";
	}
	 
	return;
}

/*
 * 动态获得url地址
 */
function onShowKBVersion() {
	var url = "/systeminfo/BrowserMain.jsp?url=/templetecheck/KBBrowser.jsp?sysversion="+$("#sysversion").val();
	return url;
}

function doRefresh(){
	$("#form1").attr("action","KBVersionList.jsp");
	$("#form1").submit();
}
</script>
</HTML>