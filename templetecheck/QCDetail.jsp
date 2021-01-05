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
String qcnumber = Util.null2String(request.getParameter("qcnumber"));
String description = Util.null2String(request.getParameter("description"));

String kbversion = Util.null2String(request.getParameter("kbversion"));
String sysversion = Util.null2String(request.getParameter("sysversion"));

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

RCMenu += "{查询,javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String backfields = " t1.* ";
String fromSql  = " from KBQCDetail t1 ";
String sqlWhere = " where 1=1 ";

//先判断是否有与KB补丁包相同的，如果没有再判断系统补丁包
if(!"".equals(kbversion)) {
	sqlWhere+=" and kbversion like '%"+kbversion+"%'";
} else {
	if(sysversion!=null&&!"".equals(sysversion)) {
		sqlWhere+=" and (kbversion like '%"+sysversion+"%' or sysversion like '%"+sysversion+"%')";
	}
}

if(!"".equals(qcnumber)) {
	sqlWhere+=" and qcnumber like '%"+qcnumber+"%'";
}
if(!"".equals(description)) {
	sqlWhere+=" and description like '%"+description+"%'";
}
String tableString = "<table instanceid=\"qcdetaillist\" tabletype=\"none\" pageId=\"qcdetaillist\" pagesize=\""+PageIdConst.getPageSize("qcdetaillist",user.getUID())+"\" >"+
"<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"    sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
"<head>"+
  "<col width=\"40%\"  text=\""+"QC"+"\" column=\"qcnumber\" orderkey=\"qcnumber\"/>"+
  "<col width=\"30%\"  text=\"描述\" column=\"description\" orderkey=\"description\" />"+
  "<col width=\"30%\"  text=\"KB版本\" column=\"kbversion\" orderkey=\"kbversion\" />"+
"</head>"+
		"</table>";  

%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM name="form1" id="form1" STYLE="margin-bottom:0" action="QCDetail.jsp" method=post>
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
			<wea:item>QC</wea:item>
			<wea:item>
			<input type="text" id="qcnumber" name="qcnumber"  onchange="checkqcnumber()" value="<%=qcnumber%>">
			</wea:item>
			<wea:item>描述</wea:item>
			<wea:item>
			<input type="text" name="description" value="<%=description%>">
			</wea:item>
			<wea:item>系统版本</wea:item>
			<wea:item>
				<brow:browser viewType="0"  id="sysversion" name="sysVersionId" browserValue="<%=sysversion %>" 
			    browserUrl="/systeminfo/BrowserMain.jsp?url=/templetecheck/SysBrowser.jsp"
			    hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
			    width="165px" browserSpanValue="<%=sysversion %>"></brow:browser>
			</wea:item>
			<wea:item>补丁包版本</wea:item>
			<wea:item>
				<brow:browser viewType="0"  id="kbversion" name="kbversion" browserValue="<%=kbversion %>" 
			    browserUrl="" getBrowserUrlFn='onShowKBVersion'
			    hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
			    width="165px" browserSpanValue="<%=kbversion %>"></brow:browser>
			</wea:item>
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
        	<input type="hidden" name="pageId" id="pageId" value="qcdetailist"/>
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

function checkqcnumber(){
var qcnumber = $("#qcnumber").val();
	if(qcnumber!=""){
		//判断输入的qc号是否是正整数
		var patrn = /^[0-9]+.?[0-9]*$/;
		var isallnum  = patrn.test(qcnumber);
		if(!isallnum) {
			$("#qcnumber").val("");
			alert("QC号只能为数字!");
			$("#qcnumber").focus();
			return;
		}else if(qcnumber>2147483646){
			$("#qcnumber").val("");
			alert("QC号过大");
			$("#qcnumber").focus();
			return;
		}
	}	
}

function showDialog(url,title,width,height){
	
	if(typeof dialog  == 'undefined' || dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width =  1200;
	dialog.Height =  650;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	try {
		dialog.show();
	}catch(e) {
	
	}
}

/*
 * 动态获得url地址
 */
function onShowKBVersion() {
	var url = "/systeminfo/BrowserMain.jsp?url=/templetecheck/KBBrowser.jsp?sysversion="+$("#sysversion").val();
	return url;
}

function doRefresh(){
	$("#form1").attr("action","QCDetail.jsp");
	$("#form1").submit();
}
</script>
</HTML>