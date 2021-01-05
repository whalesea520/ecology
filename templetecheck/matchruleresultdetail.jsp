<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<%
//判断只有管理员才有权限

int userid = user.getUID();
if(userid!=1) {
	response.sendRedirect("/notice/noright.jsp");
    return;
}
StringBuffer ajaxdata = new StringBuffer();

%>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "集成登录设置";
String needfav ="1";
String needhelp ="";
String sourceparams = "";
String description = Util.null2String(request.getParameter("description"));
String name  = Util.null2String(request.getParameter("name"));

String content = Util.null2String(request.getParameter("content"));
String ruleid = Util.null2String(request.getParameter("ruleid"));
String filepath = Util.null2String(request.getParameter("filepath"));
String navName ="文件检测结果";
%>
<style>
.searchImg {
    display: none!important;
}
</style>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{批量替换,javascript:replaceall(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{ 导出 ,javascript:exportExcel(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

String PageConstId = "matchruledetail";

String tabtype = Util.null2String(request.getParameter("tabtype"));
String ishtml = Util.null2String(request.getParameter("ishtml"));
String type = Util.null2String(request.getParameter("type"));
String pageid = Util.null2String(request.getParameter("pageid"));
sourceparams = "filepath:"+java.net.URLEncoder.encode(filepath,"UTF-8")+"+type:"+type+"+pageid:"+pageid+"+name:"+name+"+description:"+description;

String tableString="";
tableString=""+
		       "<table instanceid=\"MATCHDETAIL_LIST\" pageId=\""+"matchruledetail"+"\" "+
		    	" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" tabletype=\"checkbox\" datasource=\"weaver.templetecheck.MatchUtil.getMatchResultDetail\" sourceparams=\""+sourceparams+"\">"+
		      	"<sql backfields=\"*\" sqlform=\"tmpTable\" sqlsortway=\"asc\"  sqlprimarykey=\"ruleid\"/>"+
		       "<head>"+
	             "<col width=\"10%\"  text=\"规则名称\" column=\"name\" orderkey=\"name\" />"+
				 "<col width=\"10%\"  text=\"描述\" column=\"desc\" orderkey=\"desc\" />"+
				"<col width=\"10%\"  text=\"匹配内容\" column=\"matchcontent\" orderkey=\"matchcontent\" />"+ 
				"<col width=\"10%\"  text=\"替换为\" column=\"replacecontent\" orderkey=\"replacecontent\" />"+
	           // "<col width=\"5%\"  text=\"行号\" column=\"line\" orderkey=\"line\" />"+ 
		       "</head>"+
				"<operates>"+
				 " <popedom transmethod=\"weaver.templetecheck.PageTransMethod.getOpratePopedom3\" otherpara=\"1+column:replacecontent\" ></popedom> "+
				"	<operate href=\"javascript:replace();\" text=\"替换\" otherpara=\"column:ruleid+column:file+\" index=\"0\"/>"+
		       "</operates></table>";

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="matchoperation.jsp" method="post" name="form1" id="form1" >
<input name="tabtype" type="hidden" value="<%=tabtype%>"></input>
<input name="ishtml" type="hidden" value="<%=ishtml%>"></input>
<input name="filepath" type="hidden" value="<%=filepath%>"></input>
<input name="type" type="hidden" value="<%=type%>"></input>
<input name="pageid" type="hidden" value="<%=pageid%>"></input>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="hidden" class="searchInput" id="flowTitle" name="flowTitle" value="" onchange=""/>
			<input type="button" value="批量替换" class="e8_btn_top" onclick="replaceall()"/>
			<!--  <input type="button" value="导出" class="e8_btn_top" onclick="exportExcel()"/>-->
			<span id="advancedSearch" class="advancedSearch">高级搜索</span>&nbsp;&nbsp;
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
			<wea:item>名称</wea:item>
			<wea:item><input  type="text" name="name" value="<%=name%>"></wea:item>
			<wea:item>描述</wea:item>
			<wea:item><input   type="text" name="description" value="<%=description%>"></wea:item>
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
        	<input type="hidden" name="pageId" id="pageId" value="matchruledetail"/>
           	<wea:SplitPageTag  tableString="<%=tableString %>" isShowTopInfo="true" mode="run" />
        </td>
    </tr>
</TABLE>
</form>
<div id="message_table_Div2" class="xTable_message" style="display: none; position: absolute; top: 203px; left: 787.5px;">正在执行，请稍候...</div>

<iframe id="excels" src="" style="display:none"></iframe>
</BODY>
</HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	//$(parent.document.getElementById("objName")).html("<%=navName %>");
	
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});

function replace(id,paras) {
	var contents = paras.split("\+");
	var ruleid = contents[0];
	var filepath = contents[1];
	if(ruleid=="") {
		top.Dialog.alert("规则为空，无法匹配");
		return;
	}
	if(filepath=="") {
		top.Dialog.alert("路径为空，无法匹配");
		return;
	}
	top.Dialog.confirm("请确认文件已备份", function(){
		$("#message_table_Div2").ajaxStart(function(){//div是要进行数据提示时显示的块
			  $("#message_table_Div2").show();});
		$.ajax({
			url:'replaceoperation.jsp?tabtype=<%=tabtype%>'+'&ishtml=<%=ishtml%>'+'&isall=0',
			dataType:'json',
			data:{
				"filepath":filepath,
				"ruleid":ruleid,
				"type":"<%=type%>",
				"pageid":"<%=pageid%>"
			},
			type:'post',
			ayc:false,//同步加载
			success:function(data){
				if(data) {
					$("#message_table_Div2").hide();
					var res = data.status;
					if(res == "ok") {
						_table.reLoad();
						top.Dialog.alert("替换成功");
						return;
					} else {
						top.Dialog.alert("替换失败");
						return;
					}
				}
			}
		});
	});
}

/**
 * 单文件批量替换
 */
function replaceall() {
	var ruleid = _xtable_CheckedCheckboxId();
	var filepath = "<%=filepath%>";
	if(ruleid=="") {
		top.Dialog.alert("请选择需要配置的项");
		return;
	}
	if(filepath=="") {
		top.Dialog.alert("路径为空，无法匹配");
		return;
	}
	top.Dialog.confirm("请确认文件已备份", function(){
		$("#message_table_Div2").ajaxStart(function(){//div是要进行数据提示时显示的块
			  $("#message_table_Div2").show();});
		$.ajax({
			url:'replaceoperation.jsp?tabtype=<%=tabtype%>'+'&ishtml=<%=ishtml%>'+'&isall=2',
			dataType:'json',
			data:{
				"filepath":filepath,
				"ruleid":ruleid,
				"type":"<%=type%>",
				"pageid":"<%=pageid%>"
			},
			type:'post',
			ayc:false,//同步加载
			success:function(data){
				if(data) {
					$("#message_table_Div2").hide();
					var res = data.status;
					if(res == "ok") {
						_table.reLoad();
						top.Dialog.alert("替换成功");
						return;
					} else {
						top.Dialog.alert("替换失败");
						return;
					}
				}
			}
		});
	});
}
function exportExcel() {
	document.getElementById("excels").src = "/templetecheck/match2excel.jsp?status=0";
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
var dWidth = 600;
var dHeight = 500;

function doOpen(url,title){
	if(typeof dialog  == 'undefined' || dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width =  dWidth || 500;
	dialog.Height =  dHeight || 300;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	
	dialog.show();
}

function doOpen2(url,title){
	if(typeof dialog  == 'undefined' || dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width =  700;
	dialog.Height =  800;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	
	dialog.show();
}


function doRefresh(){
	$("#form1").attr("action","matchruleresultdetail.jsp");
	$("#form1").submit();
}


</script>