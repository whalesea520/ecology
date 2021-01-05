<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.templetecheck.FileFilter" %>
<%@ page import="weaver.templetecheck.CheckConfigFile" %>
<%@ page import="java.io.File,weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
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


%>
<script type="text/javascript">

jQuery(document).ready(function(){
	 jQuery("td[_samepair='rulelist']").css("padding","0px!important");
});
</script>
</head>
<%
if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
 	//response.sendRedirect("/notice/noright.jsp");
 	//return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "集成登录设置";
String needfav ="1";
String needhelp ="";
String type = Util.null2String(request.getParameter("type"));
String note = "选填。输入多个路径请以\",\"分隔";
String filename =  replaceStr(Util.null2String(request.getParameter("filename")));
String fileinfo =  replaceStr(Util.null2String(request.getParameter("fileinfo")));
String kbversion =  Util.null2String(request.getParameter("kbversion"));
String sysversion = Util.null2String(request.getParameter("sysversion"));
String sqlwhere = " a.isdelete=0  ";
String allcheckids ="";


%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
// 	RCMenu += "{新增配置信息,javascript:add(),_self} " ;
// 	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{批量检查配置,javascript:checkConfig(1),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{批量一键配置,javascript:oneKeyConfig(1),_self} " ;
// 	RCMenuHeight += RCMenuHeightStep ;
// 	RCMenu += "{批量删除,javascript:dodelete2(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
String PageConstId = "configManagerList";

if(!filename.equals("")){
	sqlwhere=sqlwhere+ "and lower(a.filename) like '%"+filename.toLowerCase()+"%'";
}
if(!fileinfo.equals("")){
	sqlwhere=sqlwhere+ "and lower(a.fileinfo) like '%"+fileinfo.toLowerCase()+"%'";
}

if(!kbversion.equals("")){
	sqlwhere=sqlwhere + "and lower(a.kbversion) like '%"+kbversion.toLowerCase()+"%' ";
}
if(!sysversion.equals("")){
	sqlwhere=sqlwhere +"and lower(b.sysversion) like '%"+sysversion.toLowerCase()+"%' ";
}

//对版本号做过滤
CheckConfigFile checkConfigFile = new CheckConfigFile();
String currentUsedFileIds =  checkConfigFile.getCurrentUsedFileIds();
if(!currentUsedFileIds.equals("")){
	sqlwhere+=" and a.id in("+currentUsedFileIds+") ";
}
	String sql1 = "select a.id from configFileManager a  left join CustomerKBVersion b on a.kbversion = b.name where " + sqlwhere;

	RecordSet rs = new RecordSet();
	rs.execute(sql1);
	while (rs.next()) {
		allcheckids = allcheckids + Util.null2String(rs.getString("id")) + ",";
	}

	String sourceparams = "filename:" + filename + "+fileinfo:" + fileinfo + "+kbversion:" + kbversion + "+sysversion:" + sysversion;
	// if(kbversion.equals("")&&!sysversion.equals("")){
	// 	sqlwhere=sqlwhere + "and lower(kbversion) in(select name from CustomerKBVersion where lower(sysversion) like '%"+sysversion+"%')";
	// }

	String tableStringConfig = "" + "<table instanceid=\"RULE_LIST\" pageId=\"" + "configManagerList" + "\" " + " pagesize=\"" + PageIdConst.getPageSize(PageConstId, user.getUID())
			+ "\" tabletype=\"checkbox\" datasource=\"weaver.templetecheck.ConfigOperation.getConfigFileList\" sourceparams=\"" + sourceparams + "\">" 
			+ "<sql backfields=\"*\" sqlform=\"tmpTable\" sqlsortway=\"asc\"  sqlprimarykey=\"id\"/>" 
			+ "<head>" + "<col width=\"10%\"  text=\"版本号  \" column=\"kbversion\"  />" 
			+ "<col width=\"6%\"  text=\"文件名称" + "\" column=\"filename\" />"
			+ "<col width=\"6%\"  text=\"QC号" + "\" column=\"qcnumber\"  transmethod=\"weaver.templetecheck.PageTransMethod.getALink\"  />" 
			+ "<col width=\"19%\"  text=\"文件路径" + "\" column=\"filepath\" />" 
			+ "<col width=\"30%\"  text=\"功能说明  \" column=\"fileinfo\" />" 
			+ "<col width=\"10%\"  text=\"系统版本号" + "\" column=\"sysversion\" />" 
			// 	             "<col width=\"10%\"  text=\"是否为系统配置"+"\" column=\"isSystemConfig\" orderkey=\"isSystemConfig\"/>"+
			+"<col width=\"10%\"  text=\"是否正确配置" + "\" column=\"isconfiged\"  otherpara=\"column:isconfiged+column:isconfiged\" transmethod=\"weaver.templetecheck.ConfigOperation.getConfigColor\"  />" +

			"</head>" 
			+ "	<operates>" 
			+ " <popedom transmethod=\"weaver.templetecheck.PageTransMethod.getOpratePopedomForConfigManager\" otherpara=\"5+column:isconfiged+column:filetype\" ></popedom> " 
			//+ "	<operate href=\"javascript:edit();\" 		  text=\"编辑" + "\" index=\"0\"/>"
			//+ "	<operate href=\"javascript:dodelete();\" 	  text=\"删除" + "\" otherpara=\"column:labelid\"  index=\"1\"/>" 
			+ "	<operate href=\"javascript:oneKeyConfig(0);\" text=\"一键配置" + "\" otherpara=\"column:filetype\" index=\"4\"/>"
			+ "	<operate href=\"javascript:configSetting();\" text=\"配置项设置\" otherpara=\"column:filetype\" index=\"2\"/>" 
			+ "	<operate href=\"javascript:checkConfig(0);\"     text=\"检查配置\" index=\"3\"/>" +

			"</operates></table>";
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe name="excels" id="excels" src="" style="display:none" ></iframe> 
<form action="ConfigManager.jsp" method="post" name="form2" id="form2" >

<input id="method" name="method" type="hidden" value=""/>	
<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align: right; width: 500px !important">
		<input type="hidden" class="searchInput" id="flowTitle" name="flowTitle" value="" onchange=""/>
		<input type="button" value="批量检查配置" style="width:100%;max-width:120px!important;" class="e8_btn_top" onclick="checkConfig(1)"/>
		<input type="button" value="批量一键配置" style="width:100%;max-width:120px!important;" class="e8_btn_top" onclick="oneKeyConfig(1)"/>
		<!--  
		<input type="button" value="导出Excel" style="width:100%;max-width:120px!important;" class="e8_btn_top" onclick="exportExcel()"/>
		<input type="button" value="新增配置信息" style="width:100%;max-width:120px!important;" class="e8_btn_top" onclick="add()"/>
		-->
		<span id="advancedSearch" class="advancedSearch">高级搜索</span>&nbsp;&nbsp;
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
			<wea:item>文件名</wea:item>
			<wea:item><input  type="text" name="filename" id="filename"  value="<%=filename%>"></wea:item>
			<wea:item>功能说明</wea:item>
			<wea:item><input   type="text" name="fileinfo" id="fileinfo"  value="<%=fileinfo%>"></wea:item>
			
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
					<input type="button" value="重置 " class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="取消 " class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>	





<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="configManagerList"/>
           	<wea:SplitPageTag  tableString="<%=tableStringConfig %>" isShowTopInfo="true" mode="run" />
        </td>
    </tr>
    <tr class=Spacing style="height: 1px"><td class=Line colspan=2></td></tr>
		<tr></tr>				
	<tr>
	    <td colspan="2" style="color:red">
	        <br><h1><b>操作提示：</b></h1><br>
			1）部分xml文件修改后，系统会自动重启，如:<b>web.xml</b><br>
			2）对配置文件进行修改、删除或批量修改、批量删除操作前，系统会自动备份文件到"<b>ecology\config_ubak\</b>年月日\时分秒\"文件夹下<br>
	    </td>
	</tr>
</TABLE>
<br>

</form>
<div id="message_table_Div2" class="xTable_message" style="display: none; position: absolute; top: 203px; left: 787.5px;">正在加载数据，请稍候...</div>

</BODY>
</HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#tableitem").removeClass("fieldName");
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});
	//点击qc号跳转到补丁包QC列表
	function changetoQCDetail(qcnumber){
		//跳转链接
		parent.window.location.href = "/templetecheck/ConfigManagerIframe.jsp?type=qc&qcnumber="+qcnumber;
	}
/*
 * 一键配置   /批量配置  type:0->单条配置  1—>批量配置
 */
 function oneKeyConfig(type,id){
	 var checkids="";
	 var tipMsg="提示:是否确认一键修改本地配置？";
	 var needRestart = false;
	 if(type == 0||type == "0"){
		checkids = id;
	 }else if(type == 1||type == "1"){
		checkids = _xtable_CheckedCheckboxId();
	 }
		
	 if(checkids == ""){
		tipMsg = "提示:未勾选记录，将默认一键配置所有文件！是否继续一键修改本地配置？";
		checkids = "<%=allcheckids%>";
	 }
	 $.ajax({
		 	sync:false,
			dataType:'json',
			type:'post',
			url:'ConfigOperation.jsp',
			
			data:{
				'method':'needRestart',					
				'checklocalconfigids': checkids
			},
			success:function(data){
				if(data) {
					var res =data.status;
					if(res=="ok"){
		 				tipMsg = tipMsg +"<span style=\"color:red\">(一键配置后系统将自动重启,需要重新登录系统)</span>";
						needRestart = true;
					}
				}
				top.Dialog.confirm(tipMsg, function(){
					 $.ajax({
						 	sync:false,	
							dataType:'json',
							type:'post',
						 	url:'ConfigOperation.jsp',
							data:{
								'method':'oneKeyConfig',					
								'checklocalconfigids': checkids
							},
							success:function(data){
								if(data) {
									var res = data.status;
									var msg = data.msg;
									//原先考虑如果web.xml配置不正确不让重启,但系统不支持
//  									if(needRestart&& msg.indexOf("web.xml")<0){
 									if(needRestart){
 										top.Dialog.alert(msg+"<span style=\"color:red\">(稍后自动重启)</span>",320,320);
										setTimeout("top.location ='/login/Login.jsp'", 1500);
										return;
 									}
										_table.reLoad();
										top.Dialog.alert(msg,320,320);
										return;
								}
							}
						});
					},function(){}
					);
			}
		});
	 
}
 
/*
 * 动态获得url地址
 */
function onShowKBVersion() {
	var url = "/systeminfo/BrowserMain.jsp?url=/templetecheck/KBBrowser.jsp?sysversion="+$("#sysversion").val();
	return url;
}

var dWidth = 600;
var dHeight = 500;

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
	if(url.indexOf("CheckConfigResultIframe")!=-1){//跳转检查结果页后，关闭结果页，强制对该页面reload
		dialog.CancelEvent = function(){ 
			_table.reLoad()
			dialog.close()}
	}
	dialog.URL = url;
	try {
		dialog.show();
 
	} catch(e) {
		
	}
}

/**
 * 导出EXCEL
 */
function exportExcel(){
	document.getElementById("excels").src ="/templetecheck/ConfigExcel.jsp?kbversion=<%=kbversion%>&filename=<%=filename%>&fileinfo=<%=fileinfo%>&sysversion=<%=sysversion%>&from=ConfigManager";
	
}

/**
 * 新增配置文件
 */
function add() {
	var url = "/templetecheck/ConfigAdd.jsp?method=add";
	doOpen(url,"添加配置",dWidth,dHeight);
}
/**
 * 编辑配置文件
 */
function edit(id) {
	var url = "/templetecheck/ConfigAdd.jsp?method=edit&id="+id;
	doOpen(url,"编辑配置文件信息",dWidth,dHeight);
}

/**
 * 配置项设置
 */
function configSetting(id,filetype) {
	if(typeof filetype  == 'undefined'||filetype == '0'||filetype == null){
		alert("文件类型错误！");
		return ;
	}
	var url="";
	// alert("类型（1pro,2xml）:"+filetype+"id:"+id)
	if(filetype == 1||filetype == '1'){
		url = "/templetecheck/ConfigProperties.jsp?id="+id;
	}else if(filetype == 2||filetype == '2'){
		url = "/templetecheck/ConfigXml.jsp?id="+id;
	}
	
	doOpen(url,"配置项设置",1400,1200);
}

/**
 * 删除配置文件
 */
function dodelete(flageids,labelid) {
	var delids = _xtable_CheckedCheckboxId();
	if(labelid.trim() != null && labelid.trim() !=  ""&&labelid!=0) {
		top.Dialog.alert("系统文件无法删除！");
		return;
	}
	if(flageids==undefined||""==flageids) {
		top.Dialog.alert("请选择记录！ ");
		return;
	}
	try {
	top.Dialog.confirm("提示:是否确认删除?",
		function(){
	$.ajax({
		url:'ConfigOperation.jsp?method=delete',
		dataType:'json',
		type:'post',
		data:{
			'delflageids':""+flageids,
		},
		success:function(data){
			if(data) {
				var res = data.status;
				if(res == "ok") {
					_table.reLoad();
					if(delids != "" && delids.length != flageids.length){   //delids!=""说明来自于批量删除
						top.Dialog.alert("批量删除选中文件中存在系统文件,已自动过滤");
					}else{
						top.Dialog.alert("删除成功！");
					}
					return;
				} else {
					top.Dialog.alert("删除失败 ！");
					return;
				}
			}
		}
	});
	},function(){}
	);
} catch(e) {}
};

/**
 * 批量删除配置文件
 */
function dodelete2() {
	var delids = _xtable_CheckedCheckboxId();
	if(delids == ""){
		top.Dialog.alert("请选择记录！");
	     return false; 
	}
	$.ajax({
		url:'ConfigOperation.jsp',
		dataType:'json',
		type:'post',
		data:{
			'method':'getdelids',					
			'delids': delids
		},
		success:function(data){
			if(data) {
				var res = data.status;
				var ids = data.delids;
				if(res == "ok"&& ids!="") {
					dodelete(ids,"");
					return;
				} else {
					top.Dialog.alert("批量删除选中项目全部为系统文件,无法删除");
					return;
				}
			}
		}
	});
};


/**
 * 检查配置文件
 */
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
		url:'ConfigOperation.jsp',//对本地文件进行检查，没有问题后，再去结果页
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
					doOpen(url,"配置文件检测结果",1300,1100);
				} else {
					alert(msg);
					return;
				}
			}
		}
	});
}

/**
 * 刷新本页面
 */
function doRefresh(){
	$("#form2").attr("action","ConfigManager.jsp");
	$("#form2").submit();
}

</script>