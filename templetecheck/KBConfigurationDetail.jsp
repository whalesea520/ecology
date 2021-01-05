<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.templetecheck.CheckConfigFile" %>
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
String titlename = "集成登录设置";
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
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{批量检查配置,javascript:checkConfig(1),_self} " ;

String filename = Util.null2String(request.getParameter("filename"));
String filepath = Util.null2String(request.getParameter("filepath"));
String qcnumber  = Util.null2String(request.getParameter("qcnumber"));
String fileinfo  = Util.null2String(request.getParameter("fileinfo"));
// String configtype = Util.null2String(request.getParameter("configtype"));
String kbversion = Util.null2String(request.getParameter("kbversion"));
String sysversion = Util.null2String(request.getParameter("sysversion"));
String allcheckids ="";

String backfields = " t1.* ";
String fromSql  = " from configFileManager t1 left join CustomerKBVersion t2 on t1.kbversion = t2.name  ";
String sqlWhere = " where t1.isdelete=0 ";
if(!"".equals(filename)) {
	sqlWhere+=" and  lower(t1.filename) like '%"+filename.toLowerCase()+"%'";
}
if(!"".equals(filepath)) {
	sqlWhere+=" and  lower(t1.filepath) like '%"+filepath.toLowerCase()+"%'";
}

if(!"".equals(qcnumber)) {
	sqlWhere+=" and  lower(t1.qcnumber) like '%"+qcnumber.toLowerCase()+"%'";
}
if(!"".equals(fileinfo)) {
	sqlWhere+=" and  lower(t1.fileinfo) like '%"+fileinfo.toLowerCase()+"%'";
}
if(!"".equals(kbversion)) {
	sqlWhere+=" and lower(t1.kbversion) like '%"+kbversion.toLowerCase()+"%'";
}else{
	if(!sysversion.equals("")){
		sqlWhere=sqlWhere + "and ( lower(t1.kbversion)  like '%"+sysversion.toLowerCase()+"%' or lower(t2.sysversion) like '%"+sysversion.toLowerCase()+"%' )";
	}
}
//对版本号做过滤
CheckConfigFile checkConfigFile = new CheckConfigFile();
String currentUsedFileIds =  checkConfigFile.getCurrentUsedFileIds();
if(!currentUsedFileIds.equals("")){
	sqlWhere+=" and t1.id in("+currentUsedFileIds+") ";
}

sqlWhere = sqlWhere+" and t1.configtype!=2 and t1.labelid is not null";
String sql1 = "select t1.id" +fromSql + sqlWhere;
rs.execute(sql1);
while (rs.next()) {
	allcheckids= allcheckids+Util.null2String(rs.getString("id"))+",";
}
String sourceparams= "filename:"+filename + "+fileinfo:"+fileinfo+"+kbversion:"+kbversion+"+sysversion:"+sysversion;

String tableString = "<table instanceid=\"kbconfigmanager\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize("kbconfigmanager",user.getUID())+"\" >"+
"<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"    sqlprimarykey=\"t1.id\" sqlsortway=\"desc\" sqlisdistinct=\"false\"/>"+
"<head>"+
  "<col width=\"10%\"  text=\""+"QC"+"\" column=\"qcnumber\" orderkey=\"qcnumber\" />"+
  "<col width=\"10%\"  text=\"功能说明\" column=\"fileinfo\" orderkey=\"fileinfo\" />"+
  "<col width=\"10%\"  text=\"文件名称\" column=\"filename\" orderkey=\"filename\" />"+
  "<col width=\"10%\"  text=\"文件路径\" column=\"filepath\" orderkey=\"filepath\" />"+
  "<col width=\"10%\"  text=\"版本号\" column=\"kbversion\" orderkey=\"kbversion\" />"+
"</head>"+
"<operates width=\"10%\">";
	tableString = tableString + "<operate href=\"javascript:checkConfig(0);\" index=\"4\" text=\"检查配置\" />"+
"</operates>"+
	"</table>";  

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="KBConfigurationDetail.jsp" method="post" name="form1" id="form1" >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="hidden" class="searchInput" id="flowTitle" name="flowTitle" value="" onchange=""/>
			<input type="button" value="批量检查配置" style="width:100%;max-width:120px!important;" class="e8_btn_top" onclick="checkConfig(1)"/>
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
			<wea:item>文件名称</wea:item>
			<wea:item><input type="text" name="filename" value="<%=filename%>"></wea:item>
			<wea:item>文件路径</wea:item>
			<wea:item><input type="text" name="filepath" value="<%=filepath%>"></wea:item>
			<wea:item>QC</wea:item>
			<wea:item><input type="text" id="qcnumber" name="qcnumber" onchange="checkqcnumber()"  value="<%=qcnumber%>"></wea:item>	
			<wea:item>功能说明</wea:item>
			<wea:item><input type="text" name="fileinfo" value="<%=fileinfo%>"></wea:item>
			<wea:item>系统版本</wea:item>
			<wea:item>
				<brow:browser viewType="0"  id="sysversion" name="sysversion" browserValue="<%=sysversion %>" 
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
        	<input type="hidden" name="pageId" id="pageId" value="kbconfigmanager"/>
           	<wea:SplitPageTag  tableString="<%=tableString %>" isShowTopInfo="true" mode="run" />
        </td>
    </tr>
</TABLE>

</form>
<iframe id="exportsql" src="" style="display:none"></iframe>
</BODY>

<script type="text/javascript">
$(document).ready(function(){
	//设置标题栏高级查询
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	
// 	showcustomer();
});
/*
 * 动态获得url地址
 */
function onShowKBVersion() {
	var url = "/systeminfo/BrowserMain.jsp?url=/templetecheck/KBBrowser.jsp?sysversion="+$("#sysversion").val();
	return url;
}


function closeDialog(){
	if(dialog)
		dialog.close();
}

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

function checkConfig(type,id){
	var checkids="";
	if(type == 0||type == "0"){
		checkids = id;
	}else if(type == 1||type == "1"){
		checkids = _xtable_CheckedCheckboxId();
	
	}

	if(checkids == ""){
		checkids = "<%=allcheckids%>";
	}
	$.ajax({
		url:'ConfigOperation.jsp',
		dataType:'json',
		type:'post',
		data:{
			'method':'checklocalfile',					
			'checklocalids': checkids
		},
		success:function(data){
			if(data) {
				var res = data.status;
				var msg = data.msg;
				if(res == "ok") {
					var url = "/templetecheck/CheckConfigResultIframe.jsp?checkids="+checkids;
					doOpen(url,"编辑配置",1300,1100);
				} else {
					top.Dialog.alert(msg);
					return;
				}
			}
		}
	});
}

function doOpen(url,title,dWidth,dHeight){
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
	} catch(e) {
		
	}
}
function reloadtable() {
	_table.reLoad();
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

function doRefresh(){
	$("#form1").submit();
}
// function showcustomer() {
// 	var val = $("input[name='configtype']:checked").val();
// 	if("1"==val) {
// 		$("#customeridspan").hide();
// 	} else {
// 		$("#customeridspan").show();
// 	}
// }

</script>
</HTML>