<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.templetecheck.RulePath" %>
<%@ page import="weaver.templetecheck.FileUtil" %>
<%@ page import="weaver.templetecheck.IgnoreDTDEntityResolver" %>
<%@ page import="org.dom4j.*,org.dom4j.io.*"%>
<%@ page import="java.io.*,weaver.templetecheck.ReadXml"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
FileUtil fileUtil = new FileUtil();
String tabtype = request.getParameter("tabtype");
String ishtml = request.getParameter("ishtml");
String allauto  = Util.null2String(request.getParameter("allauto"));
StringBuffer ajaxdata = new StringBuffer();

RulePath rulePath = new RulePath();
String path = rulePath.getpath(tabtype);
path  = path.replaceAll("\\\\","/");

String confirmnote = "请确认文件已做好备份，只自动配置必配项。部分文件修改之后，需要重启服务才能生效。";
if(path!=null && path.indexOf("web.xml") > 0) {
	confirmnote += "<span style=\\\"color:red;\\\">(web.xml修改之后将自动重启服务)</span>";
}
String isxml = "0";//0  是xml 1;文件不存在  2：xml格式有问题
try {
	File file = new File(fileUtil.getPath(path));
	if(file.exists()) {
		ReadXml readxml = new ReadXml();
		Document doc = readxml.read(file.getPath());
		if(doc == null) {
			isxml = "2";
		}
	} else {
		isxml = "1";
	}
} catch(Exception e) {
	isxml = "2";
}


%>
</head>
<%
int userid = user.getUID();
if(userid!=1) {
	response.sendRedirect("/notice/noright.jsp");
    return;
}
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
String status = Util.null2String(request.getParameter("status"));
if("".equals(status)) {
	status = "0";
}

String tnavName =  Util.null2String(request.getParameter("navName"));
String navName = tnavName + "--文件检测结果";

%>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
parentWin = parent.getParentWindow(window);
dialog = parent.parent.getDialog(window);
}catch(e){}
 
</script>
<style>
.searchImg {
    display: none!important;
}
</style>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
RCMenu += "{"+"批量配置"+",javascript:batchAutoConfig(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{导出,javascript:exportExcel(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{返回,javascript:back(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

String backFields = "";
String PageConstId = "matchconfigrule1";
name = replaceStr(name);
description = replaceStr(description);
sourceparams = "type:1"+"+tabtype:"+tabtype+"+ruleid:"+ruleid+"+ishtml:"+ishtml+"+description:"+description+"+name:"+name+"+status:"+status;
String tableString="";

tableString=""+
	       "<table instanceid=\"MATCH_LIST_CON\" pageId=\""+"matchconfigrule1"+"\" "+
	    	" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" tabletype=\"checkbox\" datasource=\"weaver.templetecheck.MatchUtil.getMatchResult\" sourceparams=\""+sourceparams+"\">"+
	      	"<sql backfields=\"*\" sqlform=\"tmpTable\" sqlsortway=\"asc\"  sqlprimarykey=\"ruleid\"/>"+
	       "<head>"+
	       		"<col width=\"10%\"  text=\"标识\" column=\"ruleid\" orderkey=\"ruleid\" />"+
	             "<col width=\"10%\"  text=\"规则名称\" column=\"name\" />"+
				 "<col width=\"10%\"  text=\"描述\" column=\"desc\" />"+
	             "<col width=\"20%\"  text=\"地址\" column=\"file\"/>"+ 
	             "<col width=\"25%\"  text=\"标准配置\" column=\"replacecontent\"/>"+
	             "<col width=\"25%\"  text=\"本地配置\" column=\"localconfig\"/>"+
	             "<col width=\"10%\"  text=\"版本\" column=\"version\"/>"+ 
	             "<col width=\"10%\"  text=\"XPath路径\" column=\"xpath\" />"+	 
	             "<col width=\"10%\"  text=\"必须配置\" column=\"requisite\" transmethod=\"weaver.templetecheck.PageTransMethod.getRequisite\"/>"+	
	             "<col width=\"10%\"  text=\"状态\" column=\"status\" transmethod=\"weaver.templetecheck.PageTransMethod.getConfigColor\"/>"+ 
	             
	            
	           // "<col width=\"5%\"  text=\"行号\" column=\"line\" orderkey=\"line\" />"+ 
	       "</head>"+
			"<operates>"+
			 " <popedom transmethod=\"weaver.templetecheck.PageTransMethod.getOpratePopedom\" otherpara=\"2+column:status\" ></popedom> "+
			"	<operate href=\"javascript:change();\" text=\""+"自动配置"+"\" otherpara=\"3+column:ruleid\" index=\"0\"/>"+
			"	<operate href=\"javascript:change();\" text=\""+"修改配置"+"\" otherpara=\"2+column:ruleid\" index=\"1\"/>"+
			"	<operate href=\"javascript:change();\" text=\""+"删除配置"+"\" otherpara=\"1+column:ruleid\" index=\"2\"/>"+
	       "</operates></table>";

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="matchoperation.jsp" method="post" name="form1" id="form1" >
<input type="hidden" name="tabtype" value="<%=tabtype%>"></input>
<input type="hidden" name="ishtml" value="<%=ishtml%>"></input>
<input type="hidden" name="type" value="<%=type%>"></input>
<input type="hidden" name="ruleid" value="<%=ruleid%>"></input>
<input type="hidden" name="navName" value="<%=tnavName%>"></input>
<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="<%=tnavName%>" />
</jsp:include>


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="hidden" class="searchInput" id="flowTitle" name="flowTitle" value="" onchange=""/>
			<input type="button" value="批量配置" class="e8_btn_top" onclick="batchAutoConfig()"/>
			<!-- input type="button" value="导出" class="e8_btn_top" onclick="exportExcel()"/> -->
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
			<wea:item>名称</wea:item>
			<wea:item><input type="text" name="name" value="<%=name%>"></wea:item>
			<wea:item>描述</wea:item>
			<wea:item><input type="text" name="description" value="<%=description%>"></wea:item>
			<wea:item>配置状态</wea:item>
			<wea:item>
				<select name="status" id="status" class="InputStyle" value="<%=status%>">
				<option value="0" <%if("0".equals(status)){ %>selected<%} %>>全部</option>
				<option value="1" <%if("1".equals(status)){ %>selected<%} %>>已配置</option>
				<option value="2" <%if("2".equals(status)){ %>selected<%} %>>未配置</option>
				<option value="3" <%if("3".equals(status)){ %>selected<%} %>>与标准不一致</option>
				<option value="4" <%if("4".equals(status)){ %>selected<%} %>>解析出错</option>
				<option value="5" <%if("5".equals(status)){ %>selected<%} %>>找到多个相同元素</option>
				<option value="6" <%if("6".equals(status)){ %>selected<%} %>>配置内容不符合XML格式</option>
				<option value="7" <%if("7".equals(status)){ %>selected<%} %>>配置内容不一致</option>
				<option value="8" <%if("8".equals(status)){ %>selected<%} %>>已过期，请忽略</option>
				</select>
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
        	<input type="hidden" name="pageId" id="pageId" value="matchconfigrule1"/>
           	<wea:SplitPageTag  tableString="<%=tableString %>" isShowTopInfo="true" mode="run" />
        </td>
    </tr>
</TABLE>
</form>
<div id="message_table_Div2" class="xTable_message" style="display: none; position: absolute; top: 203px; left: 787.5px;">正在执行，请稍候...</div>

<iframe id="excels" src="" style="display:none"></iframe>
</BODY>
</HTML>
<script type="text/javascript">
$(document).ready(function(){
	//$(parent.document.getElementById("objName")).html("文件检测结果");
	$(parent.document.getElementById("objName")).html("<%=navName %>");
	
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	var isxml = "<%=isxml%>";
	if("1" == isxml) {
		top.Dialog.alert("文件不存在");
	} else if("2" == isxml){
		top.Dialog.alert("XML文件格式有问题");
	}
});

function change(id,paras) {
	var contents = paras.split("\+");
	var status = contents[0];
	var ruleid = contents[1];
	//判断操作类型
	if(status=="1") {//删除
		top.Dialog.confirm("<%=confirmnote%>",
			function(){
				$.ajax({
					url : '/templetecheck/changeXmlOperation.jsp?delete=1',
					type:'post',
					data:{
						path : "<%=path%>",
						ruleid:ruleid,
						tabtype:"<%=tabtype%>",
					},
					dataType:'json',
					success:function(data){
						var path = "<%=path%>";
						var res = data.status;
						if("ok" == res) {
							if(path.indexOf("web.xml") >= 0) {
								top.Dialog.alert("删除成功<span style=\"color:red;\">(稍后将自动重启)</span>");
								setTimeout(logout,1000);
							} else {
								top.Dialog.alert("删除成功");
								_table.reLoad();
							}
							return;
						} else {
							top.Dialog.alert("删除失败");
							return;
						}
					}
				});
			});
	} else if(status=="2"){//修改配置
		showDialog("/templetecheck/selectXmlNode.jsp?path="+encodeURIComponent("<%=path%>")+"&ruleid="+ruleid+"&tabtype=<%=tabtype%>","选择XML元素父节点");
		return;
	} else if(status=="3") {//自动配置
		autoConfig(ruleid);
	}
}

function back() {
	window.location.href="matchruleConfig.jsp?ishtml=<%=ishtml%>&tabtype=<%=tabtype%>&navName=<%=tnavName%>";
}

function replaceall() {
	$("#message_table_Div2").ajaxStart(function(){//div是要进行数据提示时显示的块
		  $("#message_table_Div2").show();});
	$.ajax({
		url:'replaceoperation.jsp?tabtype=<%=tabtype%>&ruleid=<%=ruleid%>&ishtml=<%=ishtml%>',
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
}
function exportExcel() {
	document.getElementById("excels").src = "/templetecheck/match2excel.jsp?tabtype=<%=tabtype%>&ruleid=<%=ruleid%>&ishtml=<%=ishtml%>&name=<%=name%>&description=<%=description%>&status=<%=status%>";
}

function closeDialog(){
	if(dialog)
		dialog.close();
}
/**
 * 自动配置
 */
function autoConfig(ids) {
	var path = "<%=path%>";
	top.Dialog.confirm("<%=confirmnote%>",
		function(){
		$.ajax({
			url:'/templetecheck/changeXmlOperation.jsp',
			dataType:'json',
			type:'post',
			data:{
				"autoconfig":"1",
				"tabtype":"<%=tabtype%>",
				"path" : path,
				"ruleid":ids
			},
			success:function(data){
				var res = data.status;
				if(res == "ok") {
					//如果是web.xml系统会自动重启，直接跳转到登陆页面
					if(path.indexOf("web.xml") >= 0) {
						top.Dialog.alert("修改web.xml成功<span style=\"color:red;\">(稍后将自动重启)</span>");
						setTimeout(logout,1000);
					} else {
						_table.reLoad();
					}
					
					return;
				} else if(res == "no"){
					top.Dialog.alert("自动配置失败");
					return;
				} else {
					var res = "xpath错误：<br>";
					for(var obj in data) {
						res = res + data[obj]+"<br>";
					}
					top.Dialog.alert(res);
					return;
				}
			}
		});
	});

}

function batchAutoConfig() {
	var checkedids = _xtable_CheckedCheckboxId();
	//如果没有勾选任何一个选项 默认选择所有的选项
	if("" == checkedids) {
		checkedids = _xtable_unCheckedCheckboxId();
	}
	//alert(checkedids);
	autoConfig(checkedids);
}

function showDialog(url,title){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width =  600;
	dialog.Height =  550;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	try {
		dialog.show();
	}catch(e) {
	
	}
}

function logout() {
	top.location ="/login/Login.jsp";
}
function doRefresh(){
	$("#form1").attr("action","matchruleConfigResult.jsp");
	$("#form1").submit();
}

</script>