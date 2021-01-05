<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
MobileAppHomepageManager mobileAppHomepageManager=MobileAppHomepageManager.getInstance();
int id=NumberHelper.string2Int(request.getParameter("id"),0);
AppHomepage appHomepage = mobileAppHomepageManager.getAppHomepage(id);

MobileAppBaseManager mobileAppBaseManager=MobileAppBaseManager.getInstance();
JSONArray jsonArray=new JSONArray();
jsonArray=mobileAppBaseManager.getAppBaseInfoWithJSON();
%>
<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style>
*{
	font: 12px Microsoft YaHei;
}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px;
	overflow: hidden;
}
.loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
.sourceSearch{
	border: 1px solid rgb(223, 223, 223);
	height: 20px;
	width:125px;
	background-image: url('/formmode/images/btnSearch_wev8.png');
	background-repeat: no-repeat;
	background-position: 108px center;
}
.sourceSearchTip{
	position: absolute;
	left: 5px;
	top: 4px;
	color: #ccc;
	font: 12px Microsoft YaHei;
	font-style: italic;
}
.sourceSearchResult{
	position: absolute;
	top: 54px;
	right: 8px;
	z-index: 100001;
	margin: 0px;
	padding: 3px 5px;
	height: 80px;
	width: 150px;
	overflow: auto;
	background-color: #fff;
	border: 1px solid #e9e9e9;
	display: none;
}
.sourceSearchResult ul{
	margin: 0px;
	padding: 0px;
	list-style: none;
}
.sourceSearchResult ul li{
	border-bottom: #eee 1px dotted;
}
.sourceSearchResult ul li a{
	padding: 2px 0px 2px 2px;
	text-decoration: none;
	color: #333;
	display: block;
}
.sourceSearchResult ul li a:hover{
	background-color: #0072C6;
	color: #fff;
}
.sourceSearchResult ul li .tip{
	padding: 2px 0px 2px 2px;
	color: #ccc;
}
</style>
<script>
$(document).ready(function () {
	var datas=<%=jsonArray.toString()%>;
	var $newAppid = $("#newAppid");
	var htm = "";
	for(var i = 0; i < datas.length; i++){
		htm = "<option value=\""+datas[i].id+"\">"+datas[i].appname+"</option>";
		$newAppid.append(htm);
	}
	initSourceSearch();
});
function onSave(){
	$(".loading").show();
	document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppHomepageAction", "action=transform");
	document.frmMain.submit();
}
function onClose(){
	top.closeTopDialog();
}
function initSourceSearch(){
	var $searchText = $(".sourceSearch");
	var $searchTextTip = $(".sourceSearchTip");
	
	$searchTextTip.click(function(e){
		$searchText[0].focus();
		e.stopPropagation(); 
	});
	
	$searchText.focus(function(){
		$searchTextTip.hide();
	});
	
	$searchText.blur(function(){
		if(this.value == ""){
			$searchTextTip.show();
		}
	});
	
	$searchText.click(function(e){
		e.stopPropagation(); 
	});
	
	var $srarchResult = $(".sourceSearchResult");
	function hideSearchResult(){
		$srarchResult.hide();	
	}
	
	function showSearchResult(){
		$srarchResult.show();	
	}
	
	function clearSearchResult(){
		$srarchResult.children("ul").find("*").remove();	
	}
	
	var preSearchText = "";
	
	$searchText.keyup(function(event){
		if(this.value == ""){
			preSearchText = "";
			hideSearchResult();
			clearSearchResult();
		}else{
			if(this.value != preSearchText){
				preSearchText = this.value;
				var searchValue = this.value;
				var resultHtml = "";
				var $newAppid = $("#newAppid");
				$newAppid.find("option").each(function(){
					var vt = $(this).text();
					var vv = $(this).attr("value");
					if(vt.toLowerCase().indexOf(searchValue) != -1){
						resultHtml += "<li><a href=\"javascript:setSourceSelected('"+vv+"');\">"+vt+"</a></li>";
					}
				});
				
				if(resultHtml == ""){
					resultHtml = "<li><font class='tip'><%=SystemEnv.getHtmlLabelName(82090,user.getLanguage())%></font></li>";  //无匹配的结果
				}
				
				$srarchResult.children("ul").html(resultHtml);
				showSearchResult();
			}
		}
	});
	
	$("body").bind("click", function(){
		hideSearchResult();
	});
}

function setSourceSelected(v){
	var $source = $("#newAppid");
	$source.val(v);
	
	preSearchText = "";
	var $searchText = $(".sourceSearch");
	$searchText.val("");
	$searchText.trigger("blur");
	initSourceSearch();
}
</script>
</HEAD>
<body>
<FORM id=weaver name=frmMain method=post target="_self">
<input type=hidden name=id value="<%=id%>">
<div style="margin: 10px 20px;">
	<div style="margin-bottom:5px;color:rgb(164,169,174);"><%=SystemEnv.getHtmlLabelName(128205,user.getLanguage())%><!-- 选择一个移动应用以转移 --></div>
	<div>
		<select style="width:150px;border:1px solid #ccc; height: 22px;color: #333;" id="newAppid" name="newAppid"></select>
		<span style="margin-left: 10px; position: relative;display: inline-block;">
			<input  class="sourceSearch" type="text"/>
			<div  class="sourceSearchTip"><%=SystemEnv.getHtmlLabelName(128204,user.getLanguage())%><!-- 在来源中检索... --></div>
		</span>
	</div>
	<div class="sourceSearchResult"><ul></ul></div>
</div>
</FORM>

<div class="e8_zDialog_bottom" style="position: absolute;right: 0px;bottom:0px;margin-right: 16px;">
	<button type="button" class="e8_btn_submit" onclick="onSave()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
	<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%><!-- 取消 --></button>
</div>
 </body>
</html>