<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.formmode.service.FormInfoService"%>
<%@page import="com.weaver.formmodel.data.manager.FormInfoManager"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
String v = Util.null2String(request.getParameter("v"));
String dsName = Util.null2String(request.getParameter("dsName"));
String tbName = Util.null2String(request.getParameter("tbName"));
String formType = Util.null2String(request.getParameter("formType"));
String workflowId = Util.null2String(request.getParameter("workflowId"));
boolean isUF = tbName.toLowerCase().startsWith("uf_") || tbName.toLowerCase().startsWith("formtable_main_");

List<Map<String, Object>> detailTables = new ArrayList<Map<String,Object>>();
if(isUF){
	int formid = 0;
	FormInfoService fis = new FormInfoService();
	RecordSet rs = new RecordSet();
	rs.executeSql("select id from workflow_bill where upper(tablename) = upper('"+tbName+"')");
	if(rs.next()){
		formid = rs.getInt("id");
		detailTables = fis.getAllDetailTable(formid);
	}
}
int detailTableSize = detailTables.size();
String functionTips = "* 在添加函数时函数参数暂时会使用中文解释代替，需要在函数添加后将中文解释替换为相应的字段（注意，在将中文解释替换为相应字段时，除中文外，其它的比如 逗号，引号等如果有都需要原样保留）。";
if(user.getLanguage() == 8){
	functionTips = "* when the function is added, the function parameters will be replaced by the English interpretation for the time being. It is necessary to replace the English interpretation as the corresponding field after the function is added (note that when the English interpretation is replaced with the corresponding field, except for the English interpretation, other such as commas, quotes, etc. if any need to be retained in the original form).";
}else if(user.getLanguage() == 9){
	functionTips = "* 在添加函數時函數參數暫時會使用中文解釋代替，需要在函數添加後將中文解釋替換為相應的字段（註意，在將中文解釋替換為相應字段時，除中文外，其它的比如 逗號，引號等如果有都需要原樣保留）。";
}
%>
<html>
<head>
	<title></title>
	<script type="text/javascript" src="/formmode/js/jquery/nicescroll/jquery.nicescroll.min_wev8.js"></script>
<style>
*{
	font-family: 'Microsoft YaHei', Arial;
}
textarea:focus{outline:none;}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px;
	overflow-x: hidden;
	overflow-y: auto;
}
.content-area {
    border-bottom: 6px solid #efefef;
    line-height: 0px;
}
#content {
    box-sizing: border-box;
    width: 100%;
    height: 84px;
    border: none;
    padding: 5px;
    background: #f9f9f9;
    color: #000;
    font-size: 14px;
    resize:none;
    line-height: normal;
    overflow: auto;
}
.opt-area {
    display: table;
    width: 100%;
    border-collapse: collapse;
    border-bottom: 1px solid #333;
}
.opt-area-left {
    display: table-cell;
    vertical-align: top;
}
.opt-area-right {
    display: table-cell;
    width: 80px;
    vertical-align: top;
}
.symbol {
	width: 80px;
    height: 80px;
    text-align: center;
    line-height: 80px;
    font-size: 38px;
    background-color: #F98D12;
    color: #fff;
    border: 1px solid #333;
    border-bottom: none;
    box-sizing: border-box;
    cursor: pointer;
}
.symbol:HOVER{
	opacity: 0.8;
}
.fix {
    width: 320px;
    overflow: hidden;
}
.lb {
    font-size: 24px;
    float: left;
    border-right: none;
}
#clearBtn,#delBtn{
	font-size: 16px;
	background-color: #F46b0a;
}
#delBtn{
	background-image: url("/mobilemode/images/backspace_wev8.png");
	background-repeat: no-repeat;
	background-position: center;
}
.field-wrap{
	height: 400px;
	overflow: hidden;
	background-color: #D1D2D5;
}
.field{
	float: left;
	background-color: #D1D2D5;
    color: #333;
	font-size: 14px;
	border-right: none;
	line-height: normal;
	display: table;
}
.field > div {
    display: table-cell;
    vertical-align: middle;
    word-break: break-all;
}
#okBtn {
    background-color: #0066b1;
    font-size: 16px;
}
.empty{
	cursor: not-allowed; 
}
.empty:HOVER{
	opacity: 1;
}
#fnBtn{
	font-size: 16px;
}
.fn-area {
    position: absolute;
    top: 90px;
    left: 160px;
    right: 0px;
    bottom: 0px;
    background-color: #f9f9f9;
    -webkit-transition: -webkit-transform 0.3s;
    transition: transform 0.3s;
    box-shadow: 0px 0px 22px #aaa;
}
.fn-area.hide{
	-webkit-transform: translate3d(100%, 0, 0);
	transform: translate3d(100%, 0, 0);
	box-shadow: none;
}
.fn-entry {
    padding: 8px;
    cursor: pointer;
    position: relative;
}
.fn-entry:AFTER{
	content: '';
	position: absolute;
	height: 1px;
	left: 5px;
	right: 5px;
	bottom: 0px;
	background-color: #ccc;
}
.fn-entry:hover{
	background-color: #0066b1;
}
.fn-entry:hover:AFTER{
	background-color: #0066b1;
}
.fn-subject {
    font-size: 16px;
    color: #000;
}
.fn-entry:hover .fn-subject {
    color: #fff;
}
.fn-desc {
    padding-top: 4px;
    font-size: 12px;
    color: #999;
}
.fn-entry:hover .fn-desc {
    color: #fefefe;
}
.fn-help {
    padding: 5px 8px 0px 8px;
    color: red;
}
.tab-area{
	box-sizing: border-box;
	width: 100%;
	overflow-x: auto;
	-webkit-overflow-scrolling: touch;
	border-bottom: 1px solid #d9d9d9;
}
.tab-area > ul{
	list-style: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    display: table;
}
.tab-area > ul > li{
	line-height: 34px;
    font-size: 16px;
    cursor: pointer;
    padding: 0 16px;
    display: table-cell;
    position: relative;
    color: #a8a8a8;
    text-align: center;
    border: 0;
    white-space: nowrap;
}

.tab-area > ul > li.tab-selected{
	border-bottom: 2px solid #0066b1;
    color: #0066b1;
    font-weight: normal;
}
</style>

<script type="text/javascript">
var tableFieldsArray = {};
$(function() {
	var $content = $("#content");
	var content = $content.val();
	$content.val("").focus().val(content);
	initFieldWrapData("<%=tbName%>");
	initEnv();
	<%if(detailTableSize > 0){ %>
	$(".tab-area ul li").bind("click", function(){
		var $that = $(this);
		var tablename = $that.attr("data-value");
		if(!$that.hasClass("tab-selected")){
			$that.siblings("li.tab-selected").removeClass("tab-selected");
			$that.addClass("tab-selected");
			initFieldWrapData(tablename);
		}
	});
	<%}%>
});

function initFieldWrapData(tablename){
	if(tableFieldsArray[tablename]){
		initFieldWrapContent(tableFieldsArray[tablename], tablename);
	}else{
		var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getFieldsByTable&tbName="+tablename+"&dsName=<%=dsName%>&formType=<%=formType%>&workflowId=<%=workflowId%>&pagefrom=veset");
		var timestamp = (new Date()).valueOf();	//时间戳，防止缓存
		url += (url.indexOf("?") == -1 ? "?" : "&") + timestamp;
		$.get(url, function(responseText){
			var result = $.parseJSON(responseText);
	 		var status = result.status;
			if(status == "1"){
				tableFieldsArray["tablename"] = result.data;
				initFieldWrapContent(result.data, tablename);
			}
		});
	}
}

function initFieldWrapContent(data, tablename){
	if(!data) return;
	var prefix = "";
	if(tablename && tablename != "<%=tbName%>"){
		prefix = tablename + ".";
	} 
	var html = "";
	var continueCount = 0;
	for(var i = 0; i < data.length; i++){
		var column_name = data[i]["column_name"];
		if(<%=isUF%>){
			var sysFieldArr = ["id", "requestid", "formmodeid", "modedatacreater", "modedatacreatertype", "modedatacreatedate", "modedatacreatetime", "mainid"];
			if($.inArray(column_name.toLowerCase(), sysFieldArr) != -1){
				continueCount++;
				continue;
			}
		}
		var column_label = data[i]["column_label"];
		if(column_label && column_label!=""){
			column_name = column_name + "<br/>("+column_label+")";
		}
		html+= "<div class=\"field symbol\" data-value=\"{" + prefix + data[i]["column_name"] + "}\"><div>"+column_name+"</div></div>";
	}
	var count = data.length - continueCount;
	var c = 20;
	var emptyCount = 0;
	if(count < c){
		emptyCount = c - count;
	}else{
		var moreCount = (count - c) % 4;
		if(moreCount != 0){
			emptyCount = 4 - moreCount;
		}
	}
	for(var i = 0; i < emptyCount; i++){
		html+= "<div class=\"field symbol empty\"><div></div></div>";
	}
	$(".field-wrap").html(MLanguage.parse(html));
	initFieldEvent();
}

function initFieldEvent(){
	$(".field.symbol[data-value]").click(function(){
		var v = $(this).attr("data-value");
		insertText(document.getElementById("content"), v);
	});
	$(".field-wrap").getNiceScroll().resize();
}

function initEnv(){
	$(".field-wrap").niceScroll({cursorcolor:"#000",cursorwidth:2});
	$(".tab-area").niceScroll({cursorcolor:"#999",cursorwidth:5});
	$(".symbol[data-value],.fn-entry[data-value]").click(function(){
		var v = $(this).attr("data-value");
		insertText(document.getElementById("content"), v);
	});
	$("#clearBtn").click(function(){
		$("#content").val("")[0].focus();
	});
	$("#okBtn").click(function(){
		returnResult();
	});
	$("#delBtn").click(function(){
		deleteText(document.getElementById("content"));
	});
	$("#fnBtn").click(function(e){
		$(".fn-area").toggleClass("hide");
		e.stopPropagation();
	});
	$(document.body).click(function(e){
		$(".fn-area").addClass("hide");
	});
}

function insertText(obj,str) { 
	obj.focus();
	if (document.selection) {
		var sel = document.selection.createRange(); 
		sel.text = str; 
	} else if (typeof obj.selectionStart === 'number' && typeof obj.selectionEnd === 'number') { 
		var startPos = obj.selectionStart, 
		endPos = obj.selectionEnd, 
		cursorPos = startPos, 
		tmpStr = obj.value; 
		obj.value = tmpStr.substring(0, startPos) + str + tmpStr.substring(endPos, tmpStr.length); 
		cursorPos += str.length; 
		obj.selectionStart = obj.selectionEnd = cursorPos; 
	} else { 
		obj.value += str; 
	} 
}

function deleteText(obj){
	obj.focus();
	if (typeof obj.selectionStart === 'number' && typeof obj.selectionEnd === 'number') { 
		var startPos = obj.selectionStart, 
		endPos = obj.selectionEnd, 
		cursorPos = startPos, 
		tmpStr = obj.value; 
		if(startPos != endPos){
			obj.value = tmpStr.substring(0, startPos) + tmpStr.substring(endPos, tmpStr.length); 
		}else{
			if(cursorPos != 0){
				var bv = tmpStr.substring(0, cursorPos);
				var i;
				if(bv.lastIndexOf("}") == (bv.length - 1) && (i = bv.lastIndexOf("{")) != -1){
					obj.value = bv.substring(0, i) + tmpStr.substring(cursorPos, tmpStr.length); 
					cursorPos = cursorPos - (bv.length - i);
				}else{
					obj.value = tmpStr.substring(0, cursorPos - 1) + tmpStr.substring(cursorPos, tmpStr.length); 
					cursorPos = cursorPos - 1;
				}
			}
		}
		obj.selectionStart = obj.selectionEnd = cursorPos; 
	} else { 
		var tmpStr = obj.value;
		if(tmpStr != ""){
			obj.value = tmpStr.substring(0, tmpStr.length-1);
		} 
	} 
}

function returnResult(){
	if(top && top.callTopDlgHookFn){
		var result = {
			"content" : $("#content").val()
		};
		top.callTopDlgHookFn(result);
	}
	
	onClose();
}

function onClose(){
	if(top && top.closeTopDialog){
		top.closeTopDialog();
	}else{
		window.close();
	}
}

</script>

</head>
<body>
	<div class="content-area">
		<textarea id="content" style="<%if(detailTableSize == 0){ %>height:121px;<%}%>"><%=v %></textarea>
	</div>
	<%if(detailTableSize > 0){ %>
	<div class="tab-area">
		<ul>
			<li class="tab-selected" data-value="<%=tbName%>"><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></li><!-- 主表 -->
			<%for(int i=1;i<=detailTableSize;i++){ %>
				<li class="" data-value="<%=Util.null2String(detailTables.get(i-1).get("tablename"))%>"><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i %></li><!-- 明细表 -->
			<%} %>
		</ul>
	</div>
	<%} %>
	<div class="opt-area">
		<div class="opt-area-left">
			<div class="fix">
				<div id="clearBtn" class="lb symbol"><%=SystemEnv.getHtmlLabelName(125205,user.getLanguage())%></div><!-- 清空 -->
				<div id="fnBtn" class="lb symbol"><%=SystemEnv.getHtmlLabelName(30686,user.getLanguage())%></div><!-- 函数 -->
				<div class="lb symbol" data-value="(">(</div>
				<div class="lb symbol" data-value=")">)</div>
			</div>
			<div class="field-wrap">
			<!-- 
				<div class="field symbol"><div>title</div></div>
				<div class="field symbol"><div>name</div></div>
				<div class="field symbol"><div>age<br/>(年龄)</div></div>
				<div class="field symbol"><div>address</div></div>
				<div class="field symbol"><div>title</div></div>
				<div class="field symbol"><div>name</div></div>
				<div class="field symbol"><div>age</div></div>
				<div class="field symbol"><div>address</div></div>
				<div class="field symbol"><div>title</div></div>
				<div class="field symbol"><div>name</div></div>
				<div class="field symbol empty"><div></div></div>
				<div class="field symbol empty"><div></div></div> -->
			</div>
		</div>
		<div class="opt-area-right">
			<div id="delBtn" class="symbol"></div>
			<div class="symbol" data-value="+">+</div>
			<div class="symbol" data-value="-">-</div>
			<div class="symbol" data-value="*">×</div>
			<div class="symbol" data-value="/">÷</div>
			<div id="okBtn" class="symbol"><%=SystemEnv.getHtmlLabelName(130710,user.getLanguage())%></div><!-- 确定 -->
		</div>
	</div>
	<div class="fn-area hide" style="<%if(detailTableSize == 0){ %>top:127px;<%}%>">
		<div class="fn-help"><%=functionTips%></div>
		<div class="fn-entry" data-value="Mobile_NS.dateDiff(<%=SystemEnv.getHtmlNoteName(4958,user.getLanguage())%>, <%=SystemEnv.getHtmlNoteName(4959,user.getLanguage())%>)"><!-- Mobile_NS.dateDiff(开始日期字段, 结束日期字段) -->
			<div class="fn-subject"><%=SystemEnv.getHtmlNoteName(4957,user.getLanguage())%></div><!-- 日期函数 -->
			<div class="fn-desc"><%=SystemEnv.getHtmlNoteName(4960,user.getLanguage())%></div><!-- 用于计算两个日期字段之间相隔的天数 -->
		</div>
		<div class="fn-entry" data-value="Mobile_NS.calculateColSum('<%=SystemEnv.getHtmlNoteName(4961,user.getLanguage())%>')"><!-- Mobile_NS.calculateColSum('明细表字段名') -->
			<div class="fn-subject"><%=SystemEnv.getHtmlNoteName(4962,user.getLanguage())%></div><!-- 明细表字段求和函数 -->
			<div class="fn-desc"><%=SystemEnv.getHtmlNoteName(4963,user.getLanguage())%></div><!-- 用于计算明细表字段的和 -->
		</div>
	</div>
</body>
</html>
