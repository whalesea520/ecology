<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.templetecheck.CheckUtil" %>
<%@ page import="weaver.templetecheck.RulePath" %>
<%@ page import="weaver.templetecheck.FileFilter" %>
<%@ page import="weaver.templetecheck.FileUtil" %>
<%@ page import="java.io.File" %>
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
FileUtil fileUtil = new FileUtil();
String tabtype = request.getParameter("tabtype");
String ishtml = request.getParameter("ishtml");
StringBuffer ajaxdata = new StringBuffer();
CheckUtil checkUtil = new CheckUtil();
RulePath rulePath = new RulePath();
boolean  dulfile = false;//判断action文件是否包含有类型名称的备份文件  如：action1.xml

String path = Util.null2String(rulePath.getpath(tabtype));
if("2".equals(ishtml)&&("".equals(path)||null==path)) {
	path = GCONST.getRootPath() + "WEB-INF" + File.separatorChar + "web.xml";
}
if("checkaction".equals(tabtype)) {
	File f = new File(fileUtil.getPath(GCONST.getRootPath() + "WEB-INF" + File.separatorChar +"service"+File.separatorChar));
	String[] filenames = f.list(new FileFilter("action"));
	if(filenames.length>1) {
		dulfile = true;
	}
}
//action配置文件
if("checkaction".equals(tabtype)&&("".equals(path)||null==path)) {
	path = GCONST.getRootPath() + "WEB-INF" + File.separatorChar +"service"+File.separatorChar+ "action.xml";
}
//service配置文件
if("checkservice".equals(tabtype)) {
	File f = new File(fileUtil.getPath(GCONST.getRootPath() + "classbean" + File.separatorChar + "META-INF" + File.separatorChar + "xfire" + File.separatorChar));
	if(f == null || !f.exists()) {
		f =new File(GCONST.getRootPath() + "WEB-INF" + File.separatorChar + "classes" + File.separatorChar + "META-INF" + File.separatorChar + "xfire" + File.separatorChar+ "services.xml");
	}
	
	String[] filenames = f.list(new FileFilter("service"));
	if(filenames.length>1) {
		dulfile = true;
	}
}
if("checkservice".equals(tabtype)&&("".equals(path)||null==path)) {
	path = GCONST.getRootPath() + "classbean" + File.separatorChar + "META-INF" + File.separatorChar + "xfire" + File.separatorChar+ "services.xml";
	File serviceFile = new File(fileUtil.getPath(path));
	if(serviceFile==null || !serviceFile.exists()) {
		path = GCONST.getRootPath() + "WEB-INF" + File.separatorChar + "classes" + File.separatorChar + "META-INF" + File.separatorChar + "xfire" + File.separatorChar+ "services.xml";
	}
}

String navName = Util.null2String(request.getParameter("navName"));
String confirmnote = "请确认文件已做好备份，只自动配置必配项。部分文件修改之后，需要重启服务才能生效。";
if(path!=null && path.indexOf("web.xml") > 0) {
	confirmnote += "<span style=\\\"color:red;\\\">(web.xml修改之后将自动重启服务)</span>";
}

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
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
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
if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
 	//response.sendRedirect("/notice/noright.jsp");
 	//return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
String type = Util.null2String(request.getParameter("type"));
String note = SystemEnv.getHtmlLabelName(129341 ,user.getLanguage());
String sourceparams = "";
String description = Util.null2String(request.getParameter("description"));
String name  = Util.null2String(request.getParameter("name"));
String replacecontent = Util.null2String(request.getParameter("replacecontent"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86 ,user.getLanguage())+",javascript:save(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,579",user.getLanguage())+",javascript:add(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("23777,579",user.getLanguage())+",javascript:dodelete2(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("20839,22011,724",user.getLanguage())+",javascript:match(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

String backFields = "";

String PageConstId = "rulelist1";
String newdescription = checkUtil.replaceStr(description);
String newname = checkUtil.replaceStr(name);
String newreplacecontent = checkUtil.replaceStr(replacecontent);
String sourceparamsrule = "tabtype:"+tabtype+"+description:"+newdescription+"+name:"+newname+"+replacecontent:"+newreplacecontent;
String tableStringrule=""+
	       "<table instanceid=\"RULE_LIST\" pageId=\""+"rulelist1"+"\" "+
	    	" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" tabletype=\"checkbox\" datasource=\"weaver.templetecheck.CheckUtil.getRulesByCondition\" sourceparams=\""+sourceparamsrule+"\">"+
	      	"<sql backfields=\"*\" sqlform=\"tmpTable\" sqlsortway=\"asc\"  sqlprimarykey=\"flageid\"/>"+
	       "<head>"+
	      			
	             "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"flageid\"/>"+
				 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\"/>"+
	             "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"desc\"/>"+
	             //"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(579,user.getLanguage())+"\" column=\"content\" orderkey=\"content\"/>"+
	     	     "<col width=\"30%\"  text=\"配置内容"+"\" column=\"replacecontent\"/>"+
	     	     "<col width=\"10%\"  text=\""+"XPath路径"+"\" column=\"xpath\" />"+
	     	     "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(567,user.getLanguage())+"\" column=\"version\"/>"+
	     	     "<col width=\"10%\"  text=\""+"必须配置"+"\" column=\"requisite\" transmethod=\"weaver.templetecheck.PageTransMethod.getRequisite\"/>"+	
	     	     "<col width=\"10%\"  text=\""+"是否配置"+"\" column=\"flageid\" transmethod=\"weaver.templetecheck.PageTransMethod.getMatchRes\" otherpara=\""+tabtype+"+"+path+"\"/>"+	
	       "</head>"+
			"		<operates>"+
			"			<operate href=\"javascript:matchsingle();\" text=\""+SystemEnv.getHtmlLabelNames("22011,724",user.getLanguage())+"\" index=\"0\"/>"+
			"			<operate href=\"javascript:edit();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"1\"/>"+
			"			<operate href=\"javascript:dodelete();\" text=\""+SystemEnv.getHtmlLabelName(23777, user.getLanguage())+"\" index=\"2\"/>"+
	       "</operates></table>";
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="matchoperation.jsp" method="post" name="form1" id="form1" >
<input type="hidden" name="tabtype" value="<%=tabtype%>"></input>
<input type="hidden" name="ishtml" value="<%=ishtml%>"></input>
<input type="hidden" name="navName" value="<%=navName%>"></input>
<input type="hidden" name="type" value="<%=type%>"></input>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="hidden" class="searchInput" id="flowTitle" name="flowTitle" value="" onchange=""/>
			<input type="button" value="一键自动配置" style="width:100%;max-width:120px!important;" class="e8_btn_top" onclick="autoConfig()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("20839,22011,724",user.getLanguage())%>" style="width:100%;max-width:120px!important;" class="e8_btn_top" onclick="match()"/>
		<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
			
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=SystemEnv.getHtmlLabelName(33267 ,user.getLanguage()) %></span>
</div>
	
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context="<%= SystemEnv.getHtmlLabelName(347,user.getLanguage())%>">
			<wea:item>名称</wea:item>
			<wea:item><input  type="text" name="name" value="<%=name%>"></wea:item>
			<wea:item>描述</wea:item>
			<wea:item><input   type="text" name="description" value="<%=description%>"></wea:item>
			<wea:item>配置内容</wea:item>
			<wea:item><input type="text" name="replacecontent" value="<%=replacecontent%>"></wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
					<input type="submit"  onclick="doRefresh()" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="zd_btn_submit"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>	



<wea:layout>
<%
String tabname = SystemEnv.getHtmlLabelNames("18493,18499",user.getLanguage());
String groupname = SystemEnv.getHtmlLabelNames("579",user.getLanguage());
%>

<wea:group context="<%=tabname%>">
<wea:item><%=SystemEnv.getHtmlLabelNames("18493,18499",user.getLanguage())%></wea:item>
<%if(!dulfile){ %>
<wea:item><textarea  id="path" rows="4" name="path"><%=path %></textarea></wea:item>
<%} else { %>
<wea:item><%=path %>，<span style="color:red;"><b><%=SystemEnv.getHtmlLabelNames("129783",user.getLanguage())%></b></span></wea:item>
<%}%>
</wea:group>
<wea:group context="<%=groupname%>">
<wea:item attributes="{colspan:'full',id:'tableitem'}">
<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="rulelist1"/>
           	<wea:SplitPageTag  tableString="<%=tableStringrule %>" isShowTopInfo="true" mode="run" />
        </td>
    </tr>
</TABLE>
</wea:item>
</wea:group>
</wea:layout>
<br>
<input name="tabtype" value="<%=tabtype %>" type="hidden"></input>
<INPUT type="hidden" name="ishtml"  id="ishtml" value="<%=ishtml %>" >
</form>
<div id="message_table_Div2" class="xTable_message" style="display: none; position: absolute; top: 203px; left: 787.5px;"><%=SystemEnv.getHtmlLabelName(81558 ,user.getLanguage()) %></div>

<iframe id="excels" src="" style="display:none"></iframe>
</BODY>
</HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
var openwinwidth = "1000px";
$(document).ready(function(){
	$(parent.document.getElementById("objName")).html("<%=navName %>");
	$("#tableitem").removeClass("fieldName");
	
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	
	openwinwidth = $(document.body).width();
	openwinwidth = openwinwidth*0.8;
});

/**
 *一键自动配置
 */
function autoConfig() {
	top.Dialog.confirm("<%=confirmnote%>",
			function(){
			var path = $("#path").val();
			$.ajax({
				url:'/templetecheck/changeXmlOperation.jsp',
				dataType:'json',
				type:'post',
				data:{
					"autoconfig":"1",
					"tabtype":"<%=tabtype%>",
					"path" : path,
					"ruleid":""
				},
				success:function(data){
					var res = data.status;
					if(res == "ok") {
						//如果是web.xml系统会自动重启，直接跳转到登陆页面
						if(path.indexOf("web.xml") >= 0) {
							top.Dialog.alert("修改web.xml成功<span style=\"color:red;\">(稍后将自动重启)</span>");
							setTimeout(logout,1000);
						} else {
							window.location.reload();
						}
						return;
					} else {
						top.Dialog.alert("自动配置失败");
						return;
					}
				}
			});
		});
}

function matchsingle(id) {
	var path = $("#path").val();
	if(path=="") {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83869,18493,18499" ,user.getLanguage()) %>");
		return;
	}
	$.ajax({
		url:'CheckPath.jsp',
		dataType:'json',
		type:'post',
		data:{
			'path':path
		},
		success:function(data){
			var status = data.status;
			if(status == "no") {
				top.Dialog.alert("文件路径不存在");
				return;
			} else {
				doOpen2("/templetecheck/matchruleConfigResult.jsp?type=1&ruleid="+id+"&tabtype=<%=tabtype %>&ishtml=<%=ishtml%>&navName=<%=navName%>","检查结果");
			}
		}
	});
}

//保存自定义规则
function save() {
	
	$("#form1").submit();
}
function match() {
	var path = $("#path").val();
	if($("#path").val()=="") {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83869,18493,18499" ,user.getLanguage()) %>");
		return;
	}
	$.ajax({
		url:'CheckPath.jsp',
		dataType:'json',
		type:'post',
		data:{
			'path':path
		},
		success:function(data){
			var status = data.status;
			if(status == "no") {
				top.Dialog.alert("文件路径不存在");
				return;
			} else {
				var ids = _xtable_CheckedCheckboxId();
				doOpen2("/templetecheck/matchruleConfigResult.jsp?type=1&ruleid="+ids+"&tabtype=<%=tabtype %>&ishtml=<%=ishtml%>&navName=<%=navName%>","检查结果");
			}
		}
	});

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
	} catch(e) {
		
	}

}

function doOpen2(url,title){
	
	var dialog2 = new window.top.Dialog();
	dialog2.currentWindow = window;
	dialog2.Title = title;
	dialog2.Width = openwinwidth;
	dialog2.Height = 600;
	dialog2.Drag = true;
	dialog2.maxiumnable = true;
	dialog2.URL = url;
	if(url.indexOf("matchruleConfigResult") > -1){//跳转检查结果页后，关闭结果页，强制对该页面reload
		dialog2.CancelEvent = function(){ 
			_table.reLoad()
			dialog2.close()
			}
	}
	
	try {
		dialog2.show();
	} catch(e) {
		
	}

}

function add() {
	var url = "/templetecheck/ruleadd.jsp?tabtype=<%=tabtype %>&ishtml=<%=ishtml%>";
	doOpen(url,"<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(579 ,user.getLanguage()) %>");
}
function edit(flageid) {
	var url = "/templetecheck/ruleadd.jsp?flageid="+flageid+"&tabtype=<%=tabtype %>&ishtml=<%=ishtml%>";
	doOpen(url,"<%=SystemEnv.getHtmlLabelName(93 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(579 ,user.getLanguage()) %>");
}

function dodelete(flageids) {
	
	if(flageids==undefined||""==flageids) {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83439 ,user.getLanguage()) %>");
		return;
	}
	flageids = ","+flageids+",";
	try {
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84034 ,user.getLanguage()) %>",
		function(){
	$.ajax({
		url:'/templetecheck/ruleoperation.jsp?method=delete',
		dataType:'json',
		type:'post',
		data:{
			'delflageids':""+flageids,
			'tabtype':""+"<%=tabtype %>"
		},
		success:function(data){
			if(data) {
				var res = data.status;
				if(res == "ok") {
					_table.reLoad();
					return;
				} else {
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20462 ,user.getLanguage()) %>");
					return;
				}
			}
		}
	});
	},function(){}
	);
} catch(e) {
		
}
}
function dodelete2() {
	dodelete(_xtable_CheckedCheckboxId());
}

function doRefresh(){
	$("#form1").attr("action","/templetecheck/matchruleConfig.jsp");
	$("#form1").submit();
}

function logout() {
	top.location ="/login/Login.jsp";
}

</script>