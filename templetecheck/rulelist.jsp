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

</head>
<%
//判断只有管理员才有权限
int userid = user.getUID();
if(userid!=1) {
	response.sendRedirect("/notice/noright.jsp");
  return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "集成登录设置";
String needfav ="1";
String needhelp ="";
String sourceparams = "";
String description = Util.null2String(request.getParameter("description"));
String name  = Util.null2String(request.getParameter("name"));
String content = Util.null2String(request.getParameter("content"));

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

//RCMenu += "{搜索,javascript:doRefresh(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{新建,javascript:add(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{删除,javascript:dodelete2(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String backFields = "";
sourceparams = "name:"+name+"+description:"+description+"+content:"+content;
String tableString=""+
	       "<table instanceid=\"RULE_LIST\" pageId=\""+"checkrule"+"\" "+
	      		" pagesize=\"10\" tabletype=\"checkbox\" datasource=\"weaver.templetecheck.CheckUtil.getRulesByCondition\" sourceparams=\""+sourceparams+"\">"+
	      	"<sql backfields=\"*\" sqlform=\"tmpTable\" sqlsortway=\"asc\"  sqlprimarykey=\"flageid\"/>"+
	       "<head>"+
	             "<col width=\"10%\"  text=\"标识\" column=\"flageid\" orderkey=\"flageid\" />"+
				 "<col width=\"10%\"  text=\"名称\" column=\"name\" orderkey=\"name\" />"+
	             "<col width=\"20%\"  text=\"描述\" column=\"desc\" orderkey=\"desc\" />"+
	             "<col width=\"30%\"  text=\"规则\" column=\"content\" orderkey=\"content\"/>"+
				 "<col width=\"30%\"  text=\"替换为\" column=\"replacecontent\" orderkey=\"replacecontent\" />"+
	       "</head>"+
			"		<operates>"+
			"			<operate href=\"javascript:edit();\" text=\"编辑\" index=\"0\"/>"+
			"			<operate href=\"javascript:dodelete();\" text=\"删除\" index=\"1\"/>"+
	       "</operates></table>";

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="" method="post" name="checklist" id="checklist" >

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="新建" class="e8_btn_top" onclick="add()"/>
			<input type="button" value="删除" class="e8_btn_top" onclick="dodelete2()"/>
			<span id="advancedSearch" class="advancedSearch">高级搜索</span>&nbsp;&nbsp;
			<span title="菜单" class="cornerMenu"></span>
			
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context="查询条件">
			<wea:item>名称</wea:item>
			<wea:item><input  type="text" id="name" name="name" value="<%=name%>"></wea:item>
			<wea:item>描述</wea:item>
			<wea:item><input   type="text" id="description" name="description" value="<%=description%>"></wea:item>
			<wea:item>规则</wea:item>
			<wea:item><input   type="text" id="content" name="content" value="<%=content%>"></wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" value="搜索" class="e8_btn_cancel"  onclick="doRefresh()"/>
				<input type="button" value="重置" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="取消" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="rulelist"/>
           	<wea:SplitPageTag  tableString="<%=tableString %>" isShowTopInfo="true" mode="run" />
        </td>
    </tr>
</TABLE>
</form>
</BODY>
</HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
});
function resetCondtion()
{
	$("#name").val("");
	$("#description").val("");
	$("#content").val("");
}
function doRefresh()
{
	var name = $("#name").val();
	var description = $("#description").val();
	var content = $("#content").val();
	window.location.href="rulelist.jsp?name="+name+"&description="+description+"&content="+content;
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
	dialog.Height =  dWidth || 300;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	
	dialog.show();
}

function add() {
	var url = "ruleadd.jsp";
	doOpen(url,"新建规则");
}
function edit(flageid) {
	var url = "ruleadd.jsp?flageid="+flageid;
	doOpen(url,"编辑规则!");
}

function dodelete(flageids) {
	
	if(flageids==undefined||""==flageids) {
		top.Dialog.alert("请选择记录！");
		return;
	}
	flageids = ","+flageids+",";
	$.ajax({
		url:'ruleoperation.jsp?method=delete',
		dataType:'json',
		type:'post',
		data:{
			'delflageids':""+flageids
		},
		success:function(data){
			if(data) {
				var res = data.status;
				if(res == "ok") {
					_table.reLoad();
					return;
				} else {
					top.Dialog.alert("删除失败!");
					return;
				}
			}
		}
	});
}
function dodelete2() {
	dodelete(_xtable_CheckedCheckboxId());
}
</script>