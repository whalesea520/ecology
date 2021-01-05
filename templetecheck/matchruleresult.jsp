<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.templetecheck.CheckUtil" %>
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
//判断只有管理员才有权限

int userid = user.getUID();
if(userid!=1) {
	response.sendRedirect("/notice/noright.jsp");
    return;
}

String tabtype =  Util.null2String(request.getParameter("tabtype"));
String ishtml =  Util.null2String(request.getParameter("ishtml"));
String path =  Util.null2String(request.getParameter("path"));
//System.out.println("path:"+path);
StringBuffer ajaxdata = new StringBuffer();
CheckUtil checkUtil = new CheckUtil();
RulePath rulePath = new RulePath();
rulePath.savePath(tabtype,path);

%>
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
String ruleid = Util.null2String(request.getParameter("ruleid"));
String tnavName =  Util.null2String(request.getParameter("navName"));
String navName = tnavName + "--文件检测结果";


%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{批量替换,javascript:replaceall(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{导出,javascript:exportExcel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{返回,javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

String backFields = "";
String PageConstId = "matchrule1";
name = replaceStr(name);
description = replaceStr(description);

sourceparams = "type:1"+"+tabtype:"+tabtype+"+ruleid:"+ruleid+"+ishtml:"+ishtml+"+description:"+description+"+name:"+name;
String tableString="";
if("1".equals(type)){ 
	tableString=""+
		       "<table instanceid=\"MATCH_LIST\" pageId=\""+"matchrule1"+"\" "+
		    	" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" tabletype=\"none\" datasource=\"weaver.templetecheck.MatchUtil.getMatchResult\" sourceparams=\""+sourceparams+"\">"+
		      	"<sql backfields=\"*\" sqlform=\"tmpTable\" sqlsortway=\"asc\"  sqlprimarykey=\"ruleid\"/>"+
		       "<head>"+
		             "<col width=\"25%\"  text=\"地址\" column=\"file\" orderkey=\"file\" />"+ 
		             "<col width=\"25%\"  text=\""+"详情"+"\" column=\"detail\"/>"+ 
		           // "<col width=\"5%\"  text=\"行号\" column=\"line\" orderkey=\"line\" />"+ 
		            
		       "</head>"+
				"<operates>"+
				"	<operate href=\"javascript:replace();\" text=\""+"替换"+"\" otherpara=\"column:file+\" index=\"0\"/>"+
		       "</operates></table>";
}

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="matchoperation.jsp" method="post" name="form1" id="form1" >
<input type="hidden" name="tabtype" value="<%=tabtype%>"></input>
<input type="hidden" name="ishtml" value="<%=ishtml%>"></input>
<input type="hidden" name="type" value="<%=type%>"></input>
<input type="hidden" name="ruleid" value="<%=ruleid%>"></input>
<input type="hidden" name="navName" value="<%=tnavName%>"></input>
<input type="hidden" name="path" value="<%=path%>"></input>


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="hidden" class="searchInput" id="flowTitle" name="flowTitle" value="" onchange=""/>
			<input type="button" value="批量替换" class="e8_btn_top" onclick="replaceall()"/>
			<input type="button" value="导出" class="e8_btn_top" onclick="exportExcel()"/>
			<!-- span id="advancedSearch" class="advancedSearch">高级搜索</span>&nbsp;&nbsp; -->
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
        	<input type="hidden" name="pageId" id="pageId" value="matchrule1"/>
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
	$(parent.document.getElementById("objName")).html("<%=navName %>");
	
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});
function back() {
	window.location.href="matchrule.jsp?tabtype=<%=tabtype%>&ishtml=<%=ishtml%>&navName=<%=tnavName%>";
}

function replace(id,paras) {
	var contents = paras.split("\+");
	var filepath = contents[0];
	if(filepath=="") {
		top.Dialog.alert("路径为空，无法匹配");
		return;
	}
	top.Dialog.confirm("请确认文件已备份", function(){
		$("#message_table_Div2").ajaxStart(function(){//div是要进行数据提示时显示的块
			  $("#message_table_Div2").show();});
		$.ajax({
			url:'replaceoperation.jsp?tabtype=<%=tabtype%>'+'&ishtml=<%=ishtml%>'+"&isall=1",
			dataType:'json',
			data:{
				"filepath":filepath,
			},
			type:'post',
			ayc:false,//同步加载
			success:function(data){
				if(data) {
					$("#message_table_Div2").hide()
					var res = data.status;
					if(res == "ok") {
						_table.reLoad();
						//top.Dialog.alert("替换成功");
						return;
					} else {
						//top.Dialog.alert("替换失败");
						return;
					}
				}
			}
		});
	});
}



function replaceall() {
	top.Dialog.confirm("请确认文件已备份", function(){
		$("#message_table_Div2").ajaxStart(function(){//div是要进行数据提示时显示的块
			  $("#message_table_Div2").show();});
		$.ajax({
			url:'replaceoperation.jsp?tabtype=<%=tabtype%>&ruleid=<%=ruleid%>&ishtml=<%=ishtml%>&isall=4',
			dataType:'json',
			type:'post',
			ayc:false,//同步加载
			success:function(data){
				if(data) {
					$("#message_table_Div2").hide()
					var res = data.status;
					if(res == "ok") {
						_table.reLoad();
						//top.Dialog.alert("替换成功");
						return;
					} else {
						//top.Dialog.alert("替换失败");
						return;
					}
				}
			}
		});
	});
}
function exportExcel() {
	document.getElementById("excels").src = "/templetecheck/match2excel.jsp?tabtype=<%=tabtype%>&ruleid=<%=ruleid%>&ishtml=<%=ishtml%>&name=<%=name%>&description=<%=description%>&status=0";
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
	dialog.Width =  1200;
	dialog.Height =  800;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	
	dialog.show();
}


function doRefresh(){
	$("#form1").attr("action","matchruleresult.jsp");
	$("#form1").submit();
}

function showdetail(path,ruleid) {
	doOpen2("/templetecheck/matchruleresultdetailiframe.jsp?filepath="+path+"&tabtype=<%=tabtype%>&ishtml=<%=ishtml%>&ruleid="+ruleid,"");
}

</script>