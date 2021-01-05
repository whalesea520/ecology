<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.templetecheck.CheckUtil" %>
<%@ page import="weaver.templetecheck.MatchUtil" %>
<%@ page import="weaver.templetecheck.RulePath" %>
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
<%!
public String replaceStr(String str) {
	if(str != null) {
		str = str.replace("<","&lt;");
		str = str.replace(">","&gt;");
	}
	return str;
}
%>
<%
//防止占了太多的内存 进入这个页面之前先把内存清除
MatchUtil match = new MatchUtil();
match.clearCache();

//判断只有管理员才有权限
int userid = user.getUID();
if(userid!=1) {
	response.sendRedirect("/notice/noright.jsp");
  return;
}

String tabtype = request.getParameter("tabtype");

String ishtml = request.getParameter("ishtml");
StringBuffer ajaxdata = new StringBuffer();
CheckUtil checkUtil = new CheckUtil();
RulePath rulePath = new RulePath();
String path = rulePath.getpath(tabtype);


%>
<script type="text/javascript">
function addRow(v){
	group.addRow(null);

}
function removeRow(v)
{
	var count = 0;//删除数据选中个数
	jQuery("#"+v+" input[name='paramid']").each(function(){
		if($(this).is(':checked')){
			count++;
		}
	});
	if(count==0){
		top.Dialog.alert("请选择需要删除的数据!");
	}else{
		group.deleteRows();
	}
}
jQuery(document).ready(function(){
	 jQuery("td[_samepair='rulelist']").css("padding","0px!important");
});
</script>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "集成登录设置";
String needfav ="1";
String needhelp ="";
String type = Util.null2String(request.getParameter("type"));
String note = "选填。输入多个路径请以\",\"分隔";
String sourceparams = "";
String description = Util.null2String(request.getParameter("description"));
String name  = Util.null2String(request.getParameter("name"));
String content = Util.null2String(request.getParameter("content"));
String navName = Util.null2String(request.getParameter("navName"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
RCMenu += "{保存,javascript:save(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{新建规则,javascript:add(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{删除规则,javascript:dodelete2(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{批量检测规则,javascript:match(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String backFields = "";

String PageConstId = "rulelist1";


String newdescription = checkUtil.replaceStr(description);
String newname = checkUtil.replaceStr(name);
String newcontent = checkUtil.replaceStr(content);

String sourceparamsrule = "tabtype:"+tabtype+"+description:"+newdescription+"+name:"+newname+"+content:"+newcontent;
String tableStringrule=""+
	       "<table instanceid=\"RULE_LIST\" pageId=\""+"rulelist1"+"\" "+
	    		   " pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" tabletype=\"checkbox\" datasource=\"weaver.templetecheck.CheckUtil.getRulesByCondition\" sourceparams=\""+sourceparamsrule+"\">"+
	      	"<sql backfields=\"*\" sqlform=\"tmpTable\" sqlsortway=\"asc\"  sqlprimarykey=\"flageid\"/>"+
	       "<head>"+
	             "<col width=\"10%\"  text=\"标识\" column=\"flageid\" orderkey=\"flageid\" />"+
				 "<col width=\"10%\"  text=\"名称\" column=\"name\" orderkey=\"name\" />"+
	             "<col width=\"20%\"  text=\"描述\" column=\"desc\" orderkey=\"desc\" />"+
	             "<col width=\"30%\"  text=\"规则\" column=\"content\" orderkey=\"content\"/>"+
				 "<col width=\"30%\"  text=\"替换为\" column=\"replacecontent\" orderkey=\"replacecontent\" />"+
	       "</head>"+
			"		<operates>"+
			"			<operate href=\"javascript:matchsingle();\" text=\"检测规则\" index=\"0\"/>"+
			"			<operate href=\"javascript:edit();\" text=\"编辑\" index=\"1\"/>"+
			"			<operate href=\"javascript:dodelete();\" text=\"删除\" index=\"2\"/>"+
	       "</operates></table>";
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="matchoperation.jsp" method="post" name="form1" id="form1" >

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="hidden" class="searchInput" id="flowTitle" name="flowTitle" value="" onchange=""/>
			<input type="button" value="批量检测规则" style="width:100%;max-width:120px!important;" class="e8_btn_top" onclick="match()"/>
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
			<wea:item>规则</wea:item>
			<wea:item><input   type="text" name="content" value="<%=content%>"></wea:item>
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
        	<input type="hidden" name="pageId" id="pageId" value="rulelist1"/>
           	<wea:SplitPageTag  tableString="<%=tableStringrule %>" isShowTopInfo="true" mode="run" />
        </td>
    </tr>
</TABLE>

<input name="tabtype" value="<%=tabtype %>" type="hidden"></input>
<input name="ishtml" value="<%=ishtml %>" type="hidden"></input>
<input type="hidden" name="navName" value="<%=navName%>"></input>
<input type="hidden" name="type" value="<%=type%>"></input>
</form>
<div id="message_table_Div2" class="xTable_message" style="display: none; position: absolute; top: 203px; left: 787.5px;">正在加载数据，请稍候...</div>

<iframe id="excels" src="" style="display:none"></iframe>
</BODY>
</HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$(parent.document.getElementById("objName")).html("<%=navName %>");
	$("#tableitem").removeClass("fieldName");
	
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	
});
function matchsingle(id) {
	window.location.href="matchruleHtmlResult.jsp?type=1&ruleid="+id+"&ishtml=<%=ishtml%>&tabtype=<%=tabtype%>&navName=<%=navName%>";
}

//保存自定义规则
function save() {
	
	$("#form1").submit();
}
function match() {
	var ids = _xtable_CheckedCheckboxId();
	window.location.href="matchruleHtmlResult.jsp?type=1&ruleid="+ids+"&ishtml=<%=ishtml%>&tabtype=<%=tabtype%>&navName=<%=navName%>";
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
	try {
		dialog.show();		
	}catch(e) {
		
	}

}

function add() {
	var url = "/templetecheck/ruleadd.jsp?tabtype=<%=tabtype%>";
	doOpen(url,"新建规则");
}
function edit(flageid) {
	var url = "/templetecheck/ruleadd.jsp?flageid="+flageid+"&tabtype=<%=tabtype%>";
	doOpen(url,"编辑规则");
}

function dodelete(flageids) {
	
	if(flageids==undefined||""==flageids) {
		top.Dialog.alert("请选择记录！");
		return;
	}
	flageids = ","+flageids+",";
	try {
	top.Dialog.confirm("提示:是否确认删除?",
			function(){
	$.ajax({
		url:'ruleoperation.jsp?method=delete',
		dataType:'json',
		type:'post',
		data:{
			'delflageids':""+flageids,
			'tabtype':""+"<%=tabtype%>"
		},
		success:function(data){
			if(data) {
				var res = data.status;
				if(res == "ok") {
					_table.reLoad();
					return;
				} else {
					top.Dialog.alert("删除失败");
					return;
				}
			}
		}
	});
	},function(){}
	);
	}catch(e) {
		
	}
}
function dodelete2() {
	dodelete(_xtable_CheckedCheckboxId());
}

function doRefresh(){
	$("#form1").attr("action","matchruleHtml.jsp");
	$("#form1").submit();
}

</script>