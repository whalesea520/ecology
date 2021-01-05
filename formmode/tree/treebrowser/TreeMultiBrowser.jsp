<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="selectRs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@page import="weaver.formmode.data.FieldInfo"%>
<jsp:useBean id="FormModeBrowserSqlwhere" class="weaver.formmode.browser.FormModeBrowserSqlwhere" scope="page"/>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
//============================================重要参数====================================
int treeid = Util.getIntValue(Util.null2String(request.getParameter("treeid")));
String beanids = Util.null2String(request.getParameter("beanids"));
String browsertype = Util.null2String(request.getParameter("browsertype"));
String customid=Util.null2String(request.getParameter("customid"));

//============================================一般参数====================================
String nodetype=Util.null2String(request.getParameter("nodetype"));
int during=Util.getIntValue(request.getParameter("during"),0);
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"));
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
//链接地址中sqlwhere
String sqlwhereparam=Util.null2String(request.getParameter("sqlwhere"));
//sqlwhereparam = URLDecoder.decode(sqlwhereparam);
String tempquerystring = Util.null2String(request.getQueryString());
String[] tempquerystrings = tempquerystring.split("&");
for(int i=0;i<tempquerystrings.length;i++){
	String tmpqs = tempquerystrings[i];
	if(StringHelper.isEmpty(tmpqs)){
		continue;
	}
	String[] tmpqsArray = tmpqs.split("=");
	if(tmpqsArray.length>1){
		if(tmpqsArray[0].toLowerCase().equals("sqlwhere")){
			sqlwhereparam = URLDecoder.decode(tmpqsArray[1],"UTF-8");
			sqlwhereparam = FormModeBrowserSqlwhere.decode(sqlwhereparam);
		}
	}
}

//是否为预览
boolean isview="1".equals(Util.null2String(request.getParameter("isview")));

//============================================browser框基础数据====================================
String userid = ""+user.getUID();
boolean issimple=true;
String isbill="1";
String formID="0";
String workflowname="";
String customname=SystemEnv.getHtmlLabelName(21003,user.getLanguage());//自定义多选
String titlename ="";


//加上自定以字段
List<String> showfieldLabelList=new ArrayList<String>();
showfieldLabelList.add(SystemEnv.getHtmlLabelName(30828,user.getLanguage()));

String initselectfield = "";
List iframeList = new ArrayList();
String multiselectid="";
ArrayList<String> ldselectfieldid=new ArrayList<String>();
String sqlcondition = Util.null2String(request.getParameter("sqlcondition"));
List<String> checkconlist = new ArrayList<String>();
Hashtable conht=new Hashtable();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery.ui.widget.min_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery.ui.core.min_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery.ui.mouse.min_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery.ui.sortable.min_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowserNew_wev8.js?v=<%=System.currentTimeMillis() %>"></script>

<script language=javascript src="/formmode/js/modebrow_wev8.js?v=<%=System.currentTimeMillis() %>"></script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<LINK href="/js/jquery/plugins/multiselect/jquery.multiselect_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/jquery/plugins/multiselect/style_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/js/jquery/jquery-ui-1.10.3/themes/base/jquery-ui_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script>
<script language="javascript" src="/js/jquery/plugins/multiselect/jquery.multiselect.min_wev8.js"></script>
<script language="javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>

<script type="text/javascript">

function showMultiDocDialog(selectids,srchead){
 	var config = null;
 	config= rightsplugingForBrowser.createConfig();
	config.srchead=srchead;
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;
    config.srcurl = "/formmode/tree/treebrowser/TreeMultiBrowserAjax.jsp?src=src";
    config.desturl = "/formmode/tree/treebrowser/TreeMultiBrowserAjax.jsp?src=dest";
    config.pagesize = 10;
    config.formId = "frmmain";
    config.selectids = selectids;
    config.searchAreaId = "e8QuerySearchArea";//新版自定义多选框微调增加
    config.formatCallbackFn = function (config,destMap,destMapKeys){
    	return formateTreeData(config,destMap,destMapKeys);
    }
    try{
		config.dialog = dialog;
	}catch(e){}
    jQuery("#colShow").html("");
    rightsplugingForBrowser.createRightsPluing(config);
    jQuery("#btnok").bind("click",function(){
     rightsplugingForBrowser.system_btnok_onclick(config);
    });
    jQuery("#btnclear").bind("click",function(){
     rightsplugingForBrowser.system_btnclear_onclick(config);
    });
    jQuery("#btncancel").bind("click",function(){
     rightsplugingForBrowser.system_btncancel_onclick(config);
    });
    jQuery("#btnsearch").bind("click",function(){
     rightsplugingForBrowser.system_btnsearch_onclick(config);
    });
}

function formateTreeData (config,destMap,destMapKeys){
	var treenodeid = jQuery("#treenodeid").val();
	var nameKey = destMap["__nameKey"];
	var ids = "";
	var names = "";
	for(var i=0;destMapKeys&&i<destMapKeys.length;i++){
		var key = destMapKeys[i];
		var dataitem = destMap[key];
		var name = dataitem[nameKey];
		var obj = null;
		try{
			obj = jQuery(name);
		}catch(e){}
		
		
		if(ids==""){
			ids = key;
		}else{
			ids = ids+","+key;
		}
		var text = (obj && obj.length>0)?obj.text():name;
		if(dialog){
			text = "<a target='_blank' href='/formmode/search/CustomSearchOpenTree.jsp?pid="+key+"' >"+text+"</a>";
		}
		if(names==""){
			names = text;
		}else{
			names=names + ","+text;
		}
	}
	var json = new Object();
	json.id = ids;
	json.name = names;
	return json;
}

function btnOnSearch(){
 jQuery("#btnsearch").trigger("click");
}

</script>
<style>
.ui-multiselect-menu{
	z-index:9999999;
}
.ui-multiselect-displayvalue{
	background-image:none;
}
.ui-widget-content label{
	background-color:rgb(255, 255, 255);
	font-weight:normal;
}

.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default{
	background-image:none;
	background-color: rgb(255,255,255);
}

.ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus{
	background-image:none;
	background-color: rgb(255,255,255);
	font-weight:normal;
}

.ui-widget-header {
	background-image:none;
	font-weight:normal;
}
</style>
<script type="text/javascript">
var dialog;
var parentWin;
try{
	parentWin = window.parent.parent.parent.getParentWindow(parent);
	dialog = window.parent.parent.parent.getDialog(parent);
	if(!dialog){
		parentWin = parent.parentWin;
		dialog = parent.dialog;
	}
}catch(e){
	
}
</script>
<script>
var srchead=new Array();
<%
for(int i=0;i<showfieldLabelList.size();i++){
	%>
	srchead[<%=i%>]="<%=showfieldLabelList.get(i)%>";
	<%
}
%>
</script>
</head>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsearch_onclick(),_self}" ;//搜索
RCMenuHeight += RCMenuHeightStep ;
if(!isview){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;//确定
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
%>
<div class="zDialog_div_content">
<form id="frmmain" name="frmmain" method="post" action="" onsubmit="return false;">
<input name="src" type=hidden value="multi">
<input name=customid type=hidden value="<%=customid%>">
<input name="treeid" type=hidden value="<%=treeid%>">
<input name=browsertype type=hidden value="<%=browsertype%>">
<input type=hidden name=formid id="formid" value="<%=formID%>">
<input type="hidden" name="sqlwhere" value="<%=xssUtil.put(sqlwhereparam)%>">
<input type="hidden" name="isCustomPageSize" id="isCustomPageSize" value="">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="btnsearch1" class="e8_btn_top" onclick="javascript:btnsearch_onclick();" ><!-- 搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea"><!-- 新版自定义多选框微调增加div start -->
<wea:layout type="2col">
	<!-- 查询条件 -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}"><!-- attributes属性，新版自定义多选框微调增加 -->
<%//以下开始列出自定义查询条件
String sql="";

%>
<wea:item><%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%></wea:item>
<wea:item><input id="showname" name="showname"  value="" class="InputStyle"></wea:item>
	</wea:group>
</wea:layout>
</div><!-- 新版自定义多选框微调增加div end -->
</form>
<style>

#contentDiv .fieldName{
	padding-left: 0px !important;
}

#contentDiv .Spacing{
	display:none;
}
</style>

<script type="text/javascript">
document.ready = function(){
	var $ = jQuery;
	var tr = $("#contentDiv tr.items:first");
	tr.hide();
	setContentHeight();
	document.onclick = function (e){//浏览框里面 让链接点击无效
	 	var e=e||event;
   		var target=e.srcElement||e.target;
	 	var tagName = target.tagName;
	 	if(tagName=="A" || tagName=="a"){
	 		return false;
	 	}
	} 
	pageSizeChage();
}

function pageSizeChage(){
	var srcpagesize = jQuery("#srcpagesize");
	if(srcpagesize.length==0){
		setTimeout(function(){pageSizeChage()},500);
		return;
	}
	srcpagesize.get(0).onchange = function(){
		jQuery("#isCustomPageSize").val("1");
	};
}
var isneedSetContentHieght = true;//用来判断收缩条件的时候，是否需要动态设置高度的标志
function setContentHeight(){//设置中间内容的高度
	var $ = jQuery;
	var sHeight = $(".zDialog_div_content").get(0).scrollHeight;
	var zDialog_div_content = sHeight;
	var searchHeight = $("#frmmain").height();
	var height = zDialog_div_content-searchHeight-75;
	$("#src_box_middle").height(height);
	$("#dest_box_middle").height(height);
}

</script>
<div id="contentDiv">
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
					<wea:item>
						<div id="dialog">
							<div id='colShow'></div>
						</div>
					</wea:item>
				</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<div style="display:none;">
<!-- 此搜索按钮不能去掉，隐藏掉 -->
	<input  type="button" class=zd_btn_submit accessKey=S  id=btnsearch  value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"><!-- 搜索 -->
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
			<%
			if(!isview){
			%>
				<input type="button" class=zd_btn_submit accessKey=O  id=btnok  value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"><!-- 确定 -->
			<%
			}
			%>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear  value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"><!-- 清除 -->
			<input type="button" class=zd_btn_submit accessKey=T  id=btncancel  value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"><!-- 取消 -->
</wea:item>
</wea:group>
</wea:layout>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
function changeChildField(obj, fieldid, childfieldid){
	var multiselectflag="0";
	if("<%=multiselectid%>".indexOf(fieldid)>-1){
		multiselectflag="1";
	}
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value+"&isSearch=1&browserid=<%=customid%>&multiselectflag="+multiselectflag+"&multiselectvalue="+jQuery("#multiselectValue_con"+fieldid+"_value").val();
    document.getElementById("selectChange_"+fieldid).src = "/formmode/search/SelectChange.jsp?"+paraStr;
}

function changeChildSelectItemField(obj, fieldid, childfieldid,isinit){
	if(isinit&&isinit==1){//缂栬緫鏃跺垵濮嬪寲
		obj = $G("con"+fieldid+"_value");
	}
	if(!obj){
		obj = $G("con"+fieldid+"_value");
	}
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    if(isinit&&isinit==1){
    	paraStr = paraStr + "&isinit="+isinit;
    }
    var iframe = jQuery("#selectChange_"+fieldid);
    if(iframe.length==0){
    	iframe = jQuery("#selectChange");
    }
    iframe.get(0).src = "/formmode/search/SelectItemChangeByQuery.jsp?"+paraStr;
}
jQuery(document).ready(function(){
	resizeDialog(document);
	showMultiDocDialog("<%=beanids%>",srchead);
	<%=initselectfield%>;
	<%
	String[] multiselectidArray = multiselectid.split(",");
	for(int m=0;m<multiselectidArray.length;m++){
		if(Util.null2String(multiselectidArray[m]).trim().equals(""))
			continue;
	%>
		jQuery("#<%=multiselectidArray[m]%>").multiselect({
			multiple: true,
			noneSelectedText: '',
			checkAllText: "<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>",
	        uncheckAllText: "<%=SystemEnv.getHtmlLabelName(84355,user.getLanguage())%>",
	        selectedList:100,
	        minWidth:180,
	        close: function(){
				var tmpmsv = jQuery("#<%=multiselectidArray[m]%>").multiselect("getChecked").map(function(){return this.value;}).get();
	  			jQuery("#multiselectValue_<%=multiselectidArray[m]%>").val(tmpmsv.join(","));
	  			var selectObj = jQuery("#<%=multiselectidArray[m]%>");
				var onchangeStr = selectObj.attr('onchange');
				if(onchangeStr&&onchangeStr!=""){
					var selObj = selectObj.get(0);
					if (selObj.fireEvent){
						selObj.fireEvent('onchange');
					}else{
						selObj.onchange();
					}
				}
			}
	  	});
	  	jQuery("#<%=multiselectidArray[m]%>").val(jQuery("#multiselectValue_<%=multiselectidArray[m]%>").val().split(","));
	  	jQuery("#<%=multiselectidArray[m]%>").multiselect("refresh");
	<%}%>
	
	 document.body.onclick = function (e){//浏览框里面 让链接点击无效
	 	var e=e||event;
   		var target=e.srcElement||e.target;
	 	var tagName = target.tagName;
	 	if(tagName=="A" || tagName=="a"){
	 		return false;
	 	}
	}
});

function nextSelectRefreshMultiSelect(selectid){
	var tmpmsv = jQuery("#"+selectid).multiselect("getChecked").map(function(){return this.value;}).get();
	jQuery("#multiselectValue_"+selectid).val(tmpmsv.join(","));
	jQuery("#"+selectid).val(jQuery("#multiselectValue_"+selectid).val().split(","));
	jQuery("#"+selectid).multiselect("refresh");
}

//多选下拉框赋值
function multselectSetValue(){
	var tmpmsv="";
    <%
	for(int m=0;m<multiselectidArray.length;m++){
		if(Util.null2String(multiselectidArray[m]).trim().equals(""))
			continue;
	%>
	  tmpmsv = jQuery("#<%=multiselectidArray[m]%>").multiselect("getChecked").map(function(){return this.value;}).get();
	  
	  jQuery("#multiselectValue_<%=multiselectidArray[m]%>").val(tmpmsv);
	<%}%>

}

jQuery(document).ready(function(){
	$("#showname").bind('keydown',function(event){
		if(event.keyCode == 13){    
			btnsearch_onclick();
		}
	});
})

function btnsearch_onclick(){
	multselectSetValue();
	jQuery("#btnsearch").click();
}
function btnok_onclick(){
	jQuery("#btnok").click();
}
function btnclear_onclick(){
	jQuery("#btnclear").click();
}
function btncancel_onclick(){
	jQuery("#btncancel").click();
}

function onSearchWFQTDate(spanname,inputname,inputname1){
    WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$(inputname).value = returnvalue;
	     },oncleared:function(){
		      spanname.innerHTML = '';
		      inputname.value = '';
		 }
	});	
}
function onSearchWFQTTime(spanname,inputname,inputname1){
    var dads  = document.all.meizzDateLayer2.style;
    setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop;
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft;
	var ttyp  = spanname.type;
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop;
		tleft += spanname.offsetLeft;
	}
	var t = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.top = t+"px";
	dads.left = tleft+"px";
	$(document.all.meizzDateLayer2).css("z-index",99999);
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
    CustomQuery=1;
    outValue1 = inputname1;
}

function onShowBrowser(id,url) {
	var url = url + "?selectedids=" + $G("con" + id + "_value").value;
	disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"), false);
	$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;
}

function onShowBrowser2(id, url, type1) {
	var tmpids = "";
	var id1 = null;
	if (type1 == 8) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?projectids=" + tmpids);
	} else if (type1 == 9) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?documentids=" + tmpids);
	} else if (type1 == 1) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 4) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?selectedids=" + tmpids
				+ "&resourceids=" + tmpids);
	} else if (type1 == 16) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 7) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 142) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids);
	}
	//id1 = window.showModalDialog(url)
	if (id1 != null) {
		resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
		resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			if(resourceids!=""&&resourceids.indexOf(",")==0){
				resourceids = resourceids.substr(1);
			}
			if(resourcename!=""&&resourcename.indexOf(",")==0){
				resourcename = resourcename.substr(1);
			}
			$G("con" + id + "_valuespan").innerHTML = resourcename;
			jQuery("input[name=con" + id + "_value]").val(resourceids);
			jQuery("input[name=con" + id + "_name]").val(resourcename);
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
}

function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}

function onShowBrowserCustom_old(id, url, type1) {
	url+="&iscustom=1";
	if (type1 == 256|| type1==257) {
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "&selectedids=" + tmpids;
	}
	var id1 = window.showModalDialog(url, window, 
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				descs = names;
				$G("con" + id + "_valuespan").innerHTML = "<a title='" + ids + "'>" + names + "</a>&nbsp";
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
			if (type1 == 162) {
				var sHtml = "";

				var idArray = ids.split(",");
				var curnameArray = names.split("~~WEAVERSplitFlag~~");
				if(curnameArray.length < idArray.length){
					curnameArray = names.split(",");
				}
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					if(curdesc==''||curdesc=='undefined'||curdesc==null){
						curdesc = curname;
					}
					if(curdesc){
						curdesc = curname;
					}
					sHtml = sHtml + "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
				}

				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
			}
			if (type1 == 256||type1 == 257) {
				$G("con" + id + "_valuespan").innerHTML =  names ;
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
}

function onShowBrowserCustom(id, url, type1) {
	if (type1 == 256|| type1==257) {
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "&selectedids=" + tmpids;
		url+="&iscustom=1";
	}else{
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "|" + id + "&beanids=" + tmpids;
		url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
		url+="&iscustom=1";
	}
	var dialogurl = url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.callbackfun = function (paramobj, id1) {
		if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				$G("con" + id + "_valuespan").innerHTML = wrapshowhtml("<a title='" + names + "'>" + names + "</a>&nbsp",ids,1);
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
			if (type1 == 162) {
				var sHtml = "";

				var idArray = ids.split(",");
				var curnameArray = names.split("~~WEAVERSplitFlag~~");
				if(curnameArray.length < idArray.length){
					curnameArray = names.split(",");
				}
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					if(curdesc==''||curdesc=='undefined'||curdesc==null){
						curdesc = curname;
					}
					if(curdesc){
						curdesc = curname;
					}

					sHtml +=  wrapshowhtml("<a title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
				}

				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
			}
			if (type1 == 256||type1 == 257) {
				$G("con" + id + "_valuespan").innerHTML =  names ;
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
		
	hoverShowNameSpan(".e8_showNameClass");
	   
	};
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
	dialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
		dialog.Width=648; 
	}
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();

}
function onShowWorkFlowSerach(inputname, spanname) {

	retValue = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	temp = $G(inputname).value;
	if(retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
			$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
			
			if (temp != wuiUtil.getJsonValueByIndex(retValue, 0)) {
				$G("frmmain").action = "WFCustomSearchBySimple.jsp";
				$G("frmmain").submit();
			}
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
			$G("frmmain").action = "WFSearch.jsp";
			$G("frmmain").submit();

		}
	}
}

function onShowCQWorkFlow(inputname, spanname) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
}

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}
</script>
<%for(int i=0;i<ldselectfieldid.size();i++){%>
<iframe id="selectChange_<%=ldselectfieldid.get(i) %>" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%} %>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<!-- browser 相关 -->
<script type="text/javascript" src="/formmode/js/modebrow_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</html>
