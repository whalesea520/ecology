<%@page import="com.weaver.formmodel.mobile.template.Template"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.mobile.template.TemplateManager"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
if(!HrmUserVarify.checkUserRight("MobileModeSet:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String appHomepageId = Util.null2String(request.getParameter("appHomepageId"));
String type = Util.null2String(request.getParameter("type"));
String beOverride = Util.null2String(request.getParameter("beOverride"));
String noImg = "/mobilemode/images/noImg.jpg";

TemplateManager templateManager = new TemplateManager();
List<Template> tmpList = templateManager.getAllTemplate();
List<String> cList = templateManager.getCategory(tmpList);
List<String> c2List = templateManager.getCategory2(tmpList);
Map<String, String> c2Map = templateManager.getCategory2Ref(tmpList);

%>
<!DOCTYPE HTML>
<head>
<title><%=SystemEnv.getHtmlLabelName(127365,user.getLanguage())%><!-- 存为模板 --></title>
<script type="text/javascript" src="/formmode/js/jquery/hoverIntent/jquery.hoverIntent.minified_wev8.js"></script>
<style type="text/css">
*{
	font: 12px Microsoft YaHei;
}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px;
	overflow: hidden;
}
.title{
	border-bottom: 1px solid #e6e6e6;
	overflow: hidden;
	padding: 0px 10px;
	font-family: 'Microsoft YaHei';
	height: 60px;
	overflow: hidden;
	position: relative;
}
.text{
	float: left;
	background: url("/formmode/images/appIconRounded_wev8.png") no-repeat;
	padding-left: 48px;
	margin-top: 10px;
	height: 42px;
}
.text .big{
	font-size: 16px;
	margin-top: -1px;
}
.text .small{
	float:left;
	margin-top: 5px;
	height:24px;
	line-height:24px;
	display:inline-block;
}
.text .small ul{
	list-style: none;
	margin: 0px;
	padding: 0px;
}
.text .small ul li{
	float: left;
	padding-right: 10px;
	padding-left: 10px;
	padding-bottom: 8px;
	position: relative;
	font-size: 12px;
	color: #242424;
	cursor: pointer;
}
.text .small ul li:FIRST-CHILD{
	padding-left: 0px;
}
.text .small ul li.active{
	color: rgb(13,147,246);
}
.text .small ul li .rightBorder{
	position: absolute;
	top: 2px;
	right: 0px;
	background-color: #B8B8B8;
	width: 1px;
	height: 13px;
}
.text .small ul li:last-child .rightBorder{
	display: none;
}
.title2{
	height: 30px;
	line-height:30px;
	border-bottom: 1px solid #e6e6e6;
	padding-left: 12px;
	display:inline-block;
	float:left;
}
.title2 ul{
	list-style: none;
	margin: 0px;
	padding: 0px;
	line-height: 30px;
	height:30px;
}
.title2 ul li{
	display: inline-block;
}
.title2 ul li a{
	text-decoration: none;
	display: block;
	padding:3px 8px;
	cursor: pointer;
}
.title2 ul li.active a{
	background-color: #2690e3;
	border-radius: 4px;
	color: #fff
}
.angle{
	background-image: url(/images/ecology8/angle_wev8.png);
	background-position: 50% 50%;
	background-repeat: no-repeat;
	color: rgb(184, 184, 184);
	cursor: pointer;
	height: 19px;
	left: 63px;
	position: absolute;
	top: 48px;
	width: 14px;
}

.button{
	float: right;
	margin-top: 28px;
	margin-right: 112px;
}
.button div{
	background-color: #30b5ff;
	color: #fff;
	padding: 0px 10px;
	height: 24px;
	line-height: 24px;
	cursor: pointer;
}
.button div.disabled{
	background-color: #eee;
	color: #444;	
}
	
.template-container{
	position: absolute;
	top: 92px;
	left: 0px;
	bottom: 0px;
	right: 0px;
	padding: 0px 0px 20px 30px;
	background: #ededed;
	overflow-x: hidden;
	overflow-y: auto;
}
.tmp-card{
	display: block;
	position: relative;
	float: left;
	width: 260px;
	height: 420px;
	margin-top: 20px;
	margin-right: 30px;
	background-color: #f9f9f9;
	border: 1px solid #e3e3e3;
	box-shadow: 0 1px 4px rgba(0,0,0,0.1);
	overflow: hidden;
}
.card-view-style8{
	height: 415px;
	width: 335px;
}
.tmp-card.unMatch{
	display: none !important;
}
.tmp-card .tmp-content{
	padding: 10px 10px 0 10px;
}
.card-edit .card-view-panel{
	display: none;
}
.card-view .card-edit-panel{
	display: none;
}
.card-edit .tmp-btn-wrap{
	display: none;
}
.card-edit-panel .tableWrap{
	width: 220px;
	height: 350px;
	padding: 0px 10px 10px 10px;
	background-color: #fff;
}
.card-edit-panel .tableWrap-style8{
	width: 300px;
}
.card-edit-panel table{
	width: 100%;
	border-collapse: collapse;
	font-size: 13px;
}
.card-edit-panel table td{
	vertical-align: top;
	padding-top: 10px;
	position:relative;
}
.card-edit-panel .textStyle{
	width: 70%;
	float: right;
	border: none;
	border-bottom: 1px solid #eee;
}
.card-edit-panel .textStyle-style8{
	width: 50%;
}
.card-edit-panel textarea{
	height: 60px;
	max-height: 100px;
	max-width:206px;
}
.card-edit-panel input{
	height: 27px;
}
.card-edit-panel .textLabel{
	height: 27px;
	line-height: 27px;
}

.Design_FPhoto_EntryWrap{
	padding: 2px 0px 3px 1px;
	overflow: hidden;
	display:inline-block;
	position:absolute;
}
.Design_FPhoto_EntryBorder{
	padding-top: 5px;
	position: relative;
	float: left;
}
.Design_FPhoto_Entry{
	margin-right: 8px;
}
.Design_FPhoto_Entry img{
	width: 53px;
	height: 53px;
	border-radius:3px;
	border: 1px solid #ccc;
}
.Design_FPhoto_DeleteBtn{
	width: 16px;
	height: 18px;
	position: absolute;
	top: 0px;
	right: 2px;
	background: url("/images/delete_wev8.gif") no-repeat;
	background-position: -3px -3px;
	z-index: 99999;
}
.Design_FPhoto_EntryBtn{
	margin-right: 8px;
	background: url("/mobilemode/images/emobile/photo_wev8.png") no-repeat;
	background-size: 54px 54px;
}
.Design_FPhoto_EntryBtn .upLoadFile{
	position: absolute;
	font-size: 20px;
	width: 61px;
	height: 61px;
	bottom: 0px;
	left: 0px;
	filter: alpha(opacity=0);
	opacity: 0;
	cursor: pointer;
}
.btn-wrap{
	height: 50px;
}
.btn{
	height: 30px;
	padding: 0px 15px;
	float: right;
	line-height: 30px;
	margin: 10px 0px 0px 10px;
	cursor: pointer;
}
.saveBtn{
	background-color: #017afd;
	color: #fff;
}
.canelBtn{
	background-color: #ddd;
	color: #333;
}
.card-view-panel .tmp-desc-wrap{
	position: absolute;
	bottom: 50px;
	width: 240px;
	height: 120px;
	right: 10px;
	-webkit-transition: -webkit-transform 0.3s;
	transition: transform 0.3s;
}
.card-view-panel .tmp-desc-shade{
	position: absolute;
	background: #000;
	width: 240px;
	height: 120px;
	opacity: 0.57;
	filter:alpha(opacity=57);
}
.card-view-panel .tmp-desc{
	position: absolute;
	font-family: 微软雅黑, 微软雅黑, 'Microsoft YaHei', Helvetica, Tahoma, sans-serif;
	font-size: 13px;
	padding:5px;
	height: 110px;
	color: #fff;
	overflow: hidden;
	text-overflow: ellipsis;
	line-height: 16px;
}
.tmp-desc span{
	z-index: -1;
}
.tmp-desc-wrap.hide{
	-webkit-transform: translate3d(0px, 200%, 0);
	transform: translate3d(0px, 200%, 0);
}
.card-view-panel img {
	display: block;
	width: 238px;
	height: 358px;
	border: 1px solid rgb(245, 245, 245);
}
.card-view-panel .head {
	height: 50px;
	line-height: 50px;
	padding: 0px 3px 0px 6px;
	font-size: 14px;
	color: #666;
}
.card-view-panel .head h2 {
	width: 50%;
	height: 50px;
	line-height: 50px;
	float: left;
	white-space: nowrap;
	overflow: hidden;
	-ms-text-overflow: ellipsis;
	-o-text-overflow: ellipsis;
	text-overflow: ellipsis;
	font-family: 微软雅黑, 微软雅黑, 'Microsoft YaHei', Helvetica, Tahoma, sans-serif;
	font-size: 14px;
	font-weight: normal;
	padding: 0px;
	margin: 0px;
}
.card-view-panel .head .crdate{
	float: right;
	height: 50px;
	line-height: 50px;
	font-size: 12px;
	color: #aaa;
}
.searchWrap{
	position: absolute;
	right: 10px;
	bottom: 8px;
}
.searchWrap input{
	border: 1px solid #ddd;
	width: 80px;
	height: 20px;
	padding: 1px 20px 1px 5px;
}
.searchWrap .searchBtn{
	position: absolute;
	top: 1px;
	right: 1px;
	width: 22px;
	height: 22px;
	background: url("/mobilemode/images/mec/search-input_wev8.png") no-repeat;
	background-position: center 2px;
	cursor: pointer;
}
.spinner {
  margin: 22px auto 0px;
  text-align: center;
}
 
.spinner > div {
  width: 10px;
  height: 10px;
  background-color: rgb(0, 122, 251);
 
  border-radius: 100%;
  display: inline-block;
  -webkit-animation: bouncedelay 1.4s infinite ease-in-out;
  animation: bouncedelay 1.4s infinite ease-in-out;
  /* Prevent first frame from flickering when animation starts */
  -webkit-animation-fill-mode: both;
  animation-fill-mode: both;
}
 
.spinner .bounce1 {
  -webkit-animation-delay: -0.32s;
  animation-delay: -0.32s;
}
 
.spinner .bounce2 {
  -webkit-animation-delay: -0.16s;
  animation-delay: -0.16s;
}
 
@-webkit-keyframes bouncedelay {
  0%, 80%, 100% { -webkit-transform: scale(0.0) }
  40% { -webkit-transform: scale(1.0) }
}
 
@keyframes bouncedelay {
  0%, 80%, 100% {
    transform: scale(0.0);
    -webkit-transform: scale(0.0);
  } 40% {
    transform: scale(1.0);
    -webkit-transform: scale(1.0);
  }
}
#s_loading{
	position: absolute;
	top: 0px;
	left: 250px;
	right: 250px;
	text-align: center;
	font-family: 'Microsoft YaHei';
	font-size: 13px;
	z-index: 999;
	height: 60px;
	line-height: 60px;
	overflow: hidden;
	display: none;
}
#message {
	position: absolute;
	top: 0px;
	left: 250px;
	right: 250px;
	text-align: center;
	font-family: 'Microsoft YaHei';
	font-size: 13px;
	z-index: 999;
	height: 60px;
	padding-top: 20px;
	box-sizing: border-box;
	overflow: hidden;
	display: none;
}
#message.success{
	color: #007AFB;
}
#message.error{
	color: #F699B4;	
}
#message.fff{
	color: #fff;
}
.tmp-btn-wrap{
	position: absolute;
	z-index: 3;
	top: 0px;
	right: 15px;
	-webkit-transition: -webkit-transform 0.3s;
	transition: transform 0.3s;
}
.tmp-btn-wrap.hide{
	-webkit-transform: translate3d(0px, -100%, 0);
	transform: translate3d(0px, -100%, 0);
}

.tmp-btn-wrap .tmp-btn{
	width: 50px;
	height: 50px;
	background-color: rgba(0, 0, 0, 0.8);
	text-align: center;
	color: #fff;
	border-radius: 2.25em;
	margin-bottom: 15px;
	margin-top: 15px;
	box-sizing: border-box;
	padding-top: 27px;
	cursor: pointer;
}
.tmp-btn-wrap .tmp-btn:hover{
	background-color: rgba(0, 0, 0, 0.6);
}
.tmp-btn-wrap .tmp-btn.edit{
	background-image: url("/mobilemode/images/emobile/edit_wev8.png");
	background-repeat: no-repeat;
	background-position: center 5px;
	background-size: 20px 20px;
}
.tmp-btn-wrap .tmp-btn.delete{
	background-image: url("/mobilemode/images/emobile/delete_wev8.png");
	background-repeat: no-repeat;
	background-position: center 7px;
	background-size: 16px 16px;
}
.tmp-btn-wrap .tmp-btn.export{
	background-image: url("/mobilemode/images/emobile/daochu_wev8.png");
	background-repeat: no-repeat;
	background-position: center 5px;
	background-size: 20px 20px;
}
.tmp-btn-wrap .tmp-btn.disabled{
	background-color: rgba(0, 0, 0, 0.2);
}
#import-panel{
	position: absolute;
	top: 0px;
	left: 0px;
	height: 100%;
	width: 100%;
	overflow: hidden;
	-webkit-transition: -webkit-transform 0.3s;
	transition: transform 0.3s;
}
#import-panel.hide{
	-webkit-transform: translate3d(0px, 100%, 0);
	transform: translate3d(0px, 100%, 0);
}
#import-panel.show{
	background-color: rgba(0, 0, 0, 0.6);
}
.import-proxy{
	position: absolute;
	top: 0px;
	bottom: 0px;
	left: 0px;
	width: 100%;
	background: transparent;
	z-index: 0;
}
.import-close{
	position: absolute;
	width: 50px;
	height: 25px;
	top: 20px;
	right: 20px;
	border-top-left-radius: 25px;
	border-top-right-radius: 25px;
	z-index: 2;
	background: url("/images/delete_wev8.gif") no-repeat;
	background-position: center 2px;
	background-color: #fff;
	cursor: pointer;
}
.import-wrap{
	position: absolute;
	top: 40px;
	bottom: 0px;
	left: 0px;
	width: 100%;
	background-color: #fff;
	z-index: 1;
}
.import-inner{
	margin: 30px 0px 0px 0px;
}
.import-choose{
	height: 36px;
	width: 100px;
	background: #3385ff;
	border-bottom: 1px solid #2d78f4;
	color: #fff;
	text-align: center;
	line-height: 36px;
	font-size: 14px;
	letter-spacing: 1px;
	cursor: pointer;
	margin: 0px auto;
	position: relative;
}
.import-choose:HOVER {
	box-shadow: 1px 1px 1px #ccc;
	background: #317ef3;
	border-bottom: 1px solid #2868c8;
}
.import-choose.disabled{
	background: #aaa !important;
	border-bottom: 1px solid #aaa !important;
	box-shadow: none !important;
}
.import-file{
	position: absolute;
	font-size: 20px;
	width: 100px;
	height: 36px;
	bottom: 0px;
	left: 0px;
	filter: alpha(opacity=0);
	opacity: 0;
	cursor: pointer;
}
.import-choose.disabled .import-file{
	display: none;
}
.import-desc{
	color: #aaa;
	width: 530px;
	margin: 30px auto 0px;
	text-align: left;
	border: 1px solid #bbb;
}
.import-desc ul{
	margin: 0px;
	padding: 0px;
	list-style: decimal;
	list-style-position: outside;
	padding-left: 25px;
	padding-right: 8px;
	padding-bottom: 3px;
}
.import-desc ul li{
	line-height: 25px;
}
.tabs-scroller-left{
	position:relative;
	float:left;
	width:20px;
	height:20px;
	display: none;
	border:none;
	margin-top:6px;
	background: url("/mobilemode/images/template/left_wev8.png") center 20% no-repeat;
	cursor: pointer;
}
.tabs-scroller-right{
	position:relative;
	float:left;
	display: none;
	width:20px;
	height:20px;
	border:none;
	margin-top:6px;
	background: url("/mobilemode/images/template/right_wev8.png") center 20% no-repeat;
	cursor: pointer;
}
.small .hide, .title2 .hide{
	display: none;
}
.textArowWrap{position: relative;width:80%;}
.textArow{
	width: 20px;
	height: 20px;
	position: absolute;
	top: 17px;
	right: 1px;
	background: url("/mobilemode/images/homepage/homepage_bottom_wev8.jpg");
	cursor: pointer;
}
.categoryChoose{
	position: absolute;width: 155px;max-height:200px;background-color: red;right:20px;
	background-color: #fff;
	overflow-x: hidden;
	overflow-y: auto; 
	border: 1px solid #bcbcbc;
	box-sizing: border-box;
	display: none;
}
.categoryChoose1{
	top: 90px;
}
.categoryChoose2{
	top: 132px;
}
.categoryChoose ul{
	list-style: none;
	margin: 0px;
	padding: 0px;
}
.categoryChoose ul li{
	padding: 3px 3px;
}
.categoryChoose ul li:HOVER {
	background-color: #cdcdcd;
}
.categoryChoose div.t{
	padding: 3px;
	color: #cbcbcb;
}
</style>
<script type="text/javascript">
function preview(id){
	var file = document.getElementById("file"+id);
	if(file.files && file.files[0]){
		var reader = new FileReader();
	   	reader.onload = function(evt){
			var result = evt.target.result;
			$("#img" + id).attr("src", result).show();
			$("#previewImg" + id)[0].value = result;
	   	}
	   	reader.readAsDataURL(file.files[0]);
	}
}
function showLoading(){
	var $msg = $("#message");
	if($msg.is(":hidden")){
		$("#s_loading").show();
	}
}

function hideLoading(){
	$("#s_loading").hide();
}

function showMsg(msg, cn, t){
	var $msg = $("#message");
	$msg.html(msg);
	$msg.show();
	
	if(cn){
		$msg[0].className = "";
		$msg.addClass(cn);
	}
	
	if(t){
		setTimeout(function(){
			$msg.hide();
		}, t);
	}
}

function hideMsg(){
	var $msg = $("#message");
	$msg.hide();
}

function loadData(){
	var url = jionActionUrl("com.weaver.formmodel.mobile.template.TemplateAction", "action=getAllTemplate");
	showLoading();
	FormmodeUtil.doAjaxDataLoad(url, function(result){
		hideLoading();
		var status = result["status"];
		if(status == "0"){
			var message = result["message"];
			showMsg("<%=SystemEnv.getHtmlLabelName(127692,user.getLanguage())%>" + message, "error", 10000);  //加载模板时出现错误：
		}
		$(".template-container .tmp-card").remove();
		var data = result["data"];
		for(var i = 0; i < data.length; i++){
			addTmpCard(data[i]);
		}
	});
}

function addTmpCard(data){
	var id = data["id"];
	var name = data["name"];
	var desc = data["desc"];
	var category = data["category"];
	var category2 = data["category2"];
	var previewImg = data["previewImg"];
	var createDate = data["createDate"];
	if($.trim(previewImg) == ""){
		previewImg = "/mobilemode/images/noImg.jpg";
	}
	var $card = $("<div class=\"tmp-card card-view card-view-style<%=user.getLanguage()%>\" id=\"tmp-card-"+id+"\" data-id=\""+id+"\" data-category=\""+category+"\" data-category2=\""+category2+"\"></div>");
	
	var html = "<div class=\"tmp-content\">"
				 + "<div class=\"card-view-panel\">"
					+ "<img src=\""+previewImg+"\">"
					+ "<div class=\"tmp-desc-wrap hide\"><div class=\"tmp-desc-shade\"></div><div class=\"tmp-desc\">"+desc+"</div></div>"
	                + "<div class=\"head\">"
	                    + "<h2>"+name+"</h2>"
	                    //创建于
	                    + "<div class=\"crdate\"><%=SystemEnv.getHtmlLabelName(127511,user.getLanguage())%>"+createDate+"</div>"  
	                + "</div>"
				 + "</div>"
				 + "<div class=\"card-edit-panel\">"
				 	+ "<iframe name=\"formFrame"+id+"\" style=\"display: none;\"></iframe>"
				 	+ "<form target=\"formFrame"+id+"\" method=\"post\">"
				 		+ "<input type=\"hidden\" name=\"id\" value=\""+id+"\">"
						+ "<div class=\"tableWrap tableWrap-style<%=user.getLanguage()%>\">"
							+ "<table>"
								+ "<tr>"
									+ "<td><span class=\"textLabel\"><%=SystemEnv.getHtmlLabelName(127693,user.getLanguage())%></span><input type=\"text\" name=\"name\" class=\"textStyle textStyle-style<%=user.getLanguage()%>\" placeholder=\"<%=SystemEnv.getHtmlLabelName(28050,user.getLanguage())%>\" value=\""+name+"\"/></td>"  //模板名称：   //模板名称
								+ "</tr>"
								+ "<tr>"
									+ "<td><span class=\"textLabel\"><%=SystemEnv.getHtmlLabelName(127694,user.getLanguage())%></span><input type=\"text\" name=\"category\" class=\"textStyle textStyle-style<%=user.getLanguage()%>\" placeholder=\"<%=SystemEnv.getHtmlLabelName(127554,user.getLanguage())%>\" readonly=\"readonly\" value=\""+category+"\"/><div class=\"textArow textArow1\"></div></td>"   //行业分类：  行业分类
								+ "</tr>"
								+ "<tr>"
									+ "<td><span class=\"textLabel\"><%=SystemEnv.getHtmlLabelName(127695,user.getLanguage())%></span><input type=\"text\" name=\"category2\" class=\"textStyle textStyle-style<%=user.getLanguage()%>\" placeholder=\"<%=SystemEnv.getHtmlLabelName(127556,user.getLanguage())%>\" readonly=\"readonly\" value=\""+category2+"\"/><div class=\"textArow textArow2\"></div></td>"  //页面分类：   页面分类
								+ "</tr>"
								+ "<tr>"
									+ "<td><span class=\"textLabel\"><%=SystemEnv.getHtmlLabelName(127696,user.getLanguage())%></span><textarea name=\"desc\" class=\"textStyle textStyle-style<%=user.getLanguage()%>\" placeholder=\"<%=SystemEnv.getHtmlLabelName(18627,user.getLanguage())%>\" /></textarea></td>"  //模板描述：    模板描述
								+ "</tr>"
								+ "<tr>"
									+ "<td>"
										+ "<div style=\"display:inline-block;margin-top:5px;\">"
											+ "<%=SystemEnv.getHtmlLabelName(127472,user.getLanguage())%>"  //效果图片：
										+ "</div>"
										+ "<div class=\"Design_FPhoto_EntryWrap\">"
											+ "<div class=\"Design_FPhoto_EntryBorder\" id=\"photoBorder"+id+"\">"
												+ "<div class=\"Design_FPhoto_EntryBtn\" id=\"entryBtn"+id+"\" style=\"width:55px;height:55px;\">"
													+ "<div class=\"Design_FPhoto_Entry\"><img id=\"img"+id+"\" src=\""+previewImg+"\"></img></div>"
													+ "<input id=\"file"+id+"\" type=\"file\" name=\"file\" filenum=\"0\" class=\"upLoadFile\" accept=\"image/jpg,image/jpeg,image/png,image/gif\" single=\"single\" onchange=\"preview('"+id+"');\" data-role=\"none\">"
												+ "</div>"
											+ "</div>"
											+ "<input type=\"hidden\" name=\"previewImg\" id=\"previewImg"+id+"\" value=\""+previewImg+"\">"
											+ "<input type=\"hidden\" name=\"id\" value=\""+id+"\"/>"
											+ "<input type=\"hidden\" name=\"saveType\" value=\"2\"/>"
										+ "</div>"
									+ "</td>"
								+ "</tr>"
							+ "</table>"
						+ "</div>"
						+ "<div class=\"btn-wrap\">"
							+ "<div class=\"btn canelBtn\"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%></div>"  //取消
							+ "<div class=\"btn saveBtn\"><%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%></div>"  //保存
						+ "</div>"
					+ "</form>"
				+ "</div>"
             + "</div>"
             + "<div class=\"tmp-btn-wrap hide\">"
             	+ "<div class=\"tmp-btn edit\"><%=SystemEnv.getHtmlLabelName(126036,user.getLanguage())%></div>"  //编辑
				+ "<div class=\"tmp-btn delete\"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%></div>"  //删除
				+ "<div class=\"tmp-btn export\"><%=SystemEnv.getHtmlLabelName(17416,user.getLanguage())%></div>"  //导出
			+ "</div>"
			
            
			
			
			
    $card.html(html);
	$(".template-container").append($card);
	
	$("textarea[name='desc']", $card).val(desc);
	if(desc.length == 0){
		$(".tmp-desc-wrap", $card).css("display", "none");
	}
	
	$card.hoverIntent({
	    over: function(){
	    	$(".tmp-btn-wrap", $(this)).removeClass("hide");
	    	$(".tmp-desc-wrap", $(this)).removeClass("hide");
	    },
	    out: function(){
	    	$(".tmp-btn-wrap", $(this)).addClass("hide");
	    	$(".tmp-desc-wrap", $(this)).addClass("hide");
	    },
	    interval: 30
	});
	
	$(".tmp-btn-wrap .tmp-btn", $card).click(function(){
		var $that = $(this);
		
		$that.parent().addClass("hide");
		
		var $cd = $that.closest(".tmp-card");
		var id = $cd.attr("data-id");
			
		if($that.hasClass("delete")){
			removeCardOnServer(id);
		}else if($that.hasClass("export")){
			location.href = jionActionUrl("com.weaver.formmodel.mobile.template.TemplateAction", "action=export&id=" + id);
		}else if($that.hasClass("edit")){
			setEditPanelShow(id);
		}
	});
	$(".canelBtn", $card).click(function(){
		canelCardEdit(id);
	});
	$(".saveBtn", $card).click(function(){
		submitTmpToServer(id);
	});
	
}

function setEditPanelShow(id, callbackFn){
	var $card = $("#tmp-card-" + id);
	var $editPanel = $(".card-edit-panel", $card);
	var $viewPanel = $(".card-view-panel", $card);
	$viewPanel.fadeOut(300, function(){
		$editPanel.fadeIn(300, function(){
			$card.removeClass("card-view").addClass("card-edit");
			if(typeof(callbackFn) == "function"){
				callbackFn.call(this, id);
			}
		});
	});
	if($(".categoryChoose", $card).length == 0){
		$("#categoryChooseContainer .categoryChoose1").clone().appendTo($card);
		$("#categoryChooseContainer .categoryChoose2").clone().appendTo($card);
		$(".textArow1", $card).click(function(e){
			$(".categoryChoose2", $card).hide();
			$(".categoryChoose1", $card).toggle();
			e.stopPropagation();
		});
		
		$(".textArow2", $card).click(function(e){
			$(".categoryChoose1", $card).hide();
			$(".categoryChoose2", $card).toggle();
			e.stopPropagation();
		});
		$(".categoryChoose li", $card).click(function(){
			var cid = $(this).closest(".categoryChoose").attr("value-for");
			$("input[name='"+cid+"']", $card).val($(this).text());
		});
	}	
}

function canelCardEdit(id){
	var $card = $("#tmp-card-" + id);
	if($card.hasClass("card-new")){
		removeCardOnPage(id);
	}else{
		setViewPanelShow(id);
	}
}

function setViewPanelShow(id, callbackFn){
	var $card = $("#tmp-card-" + id);
	var $editPanel = $(".card-edit-panel", $card);
	var $viewPanel = $(".card-view-panel", $card);
	$editPanel.fadeOut(300, function(){
		$viewPanel.fadeIn(300, function(){
			$card.removeClass("card-edit").addClass("card-view");
			if(typeof(callbackFn) == "function"){
				callbackFn.call(this, id);
			}
		});
	});
}

function submitTmpToServer(id){
	var $card = $("#tmp-card-" + id);
	var $saveBtn = $(".saveBtn", $card);
	if(!$saveBtn.hasClass("disabled")){
		var flag = true;
		
		var $name = $("input[name='name']", $card);
		if($name.val() == ""){
			showMsg("<%=SystemEnv.getHtmlLabelName(127697,user.getLanguage())%>", "error", 3000);  //模板名称不能为空！
			$name[0].focus();
			flag = false;
		}
		var saveType = $("input[name='saveType']:checked").val();
		if(saveType == "2"){
			var overrideTmp = $("#overrideTmp").val();
			if(overrideTmp == ""){
				$("#overrideTmpSpan").show();
				flag = false;
			}
		}
		if(flag){
			$saveBtn.addClass("disabled");
			var $form = $("form", $card);
			$form[0].action = jionActionUrl("com.weaver.formmodel.mobile.template.TemplateAction", "action=updateTmp");
			showLoading();
			$form.submit();
		}
	}
}

function submitTmpCallback(result){
	hideLoading();
	
	var id = result["id"];
	var status = result["status"];
	
	var $card = $("#tmp-card-" + id);
	
	if(status == "1"){
		var $editPanel = $(".card-edit-panel", $card);
		var $viewPanel = $(".card-view-panel", $card);
		
		var name = $("input[name='name']", $editPanel).val();
		var category = $("input[name='category']", $editPanel).val();
		var category2 = $("input[name='category2']", $editPanel).val().trim();
		var desc = $("textarea[name='desc']", $editPanel).val().trim();
		var previewImg = $("input[name='previewImg']", $editPanel).val();
		var firstImg = "<%=noImg%>";
		if($.trim(previewImg) != ""){
			firstImg = previewImg.split(";;")[0];
		}
		
		$(".head h2", $viewPanel).html(name);
		$(".tmp-desc", $viewPanel).html(desc);
		$("img", $viewPanel).attr("src", firstImg);
		
		$card.attr("data-category", category);
		$card.attr("data-category2", category2);
		
		var $descWrap = $(".tmp-desc-wrap", $card);
		if(!desc){
			$(".tmp-desc-wrap", $card).css("display", "none");
		}else{
			$(".tmp-desc-wrap", $card).css("display", "block");
		}
		var currCategory = $(".title ul li.active").text();
		var currCategory2 = $(".title2 ul li.active").text();
		if(currCategory != "<%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%>" && currCategory2 == "<%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%>"){   //全部
			if(category != currCategory){
				$card.addClass("unMatch");
			}
		}
		if(currCategory == "<%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%>" && currCategory2 != "<%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%>"){  //全部
			if(category2 != currCategory2){
				$card.addClass("unMatch");
			}
		}
		if(currCategory != "<%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%>" && currCategory2 != "<%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%>"){  //全部
			if(category != currCategory || category2 != currCategory2){
				$card.addClass("unMatch");
			}
		}
		
		$editPanel.fadeOut(300, function(){
			$viewPanel.fadeIn(300, function(){
				$card.removeClass("card-edit").addClass("card-view");
				showMsg("<%=SystemEnv.getHtmlLabelName(83551,user.getLanguage())%>", "success", 2000);  //保存成功！
			});
		});
	}else{
		var message = result["message"];
		showMsg("<%=SystemEnv.getHtmlLabelName(127474,user.getLanguage())%>" + message, "error", 10000);  //保存时出现错误：
		
	}
	
	var $saveBtn = $(".saveBtn", $card);
	$saveBtn.removeClass("disabled");
	
}

$(document).ready(function(){
	$(".small ul li").click(function(e){
		if(!$(this).hasClass("active")){
			$(this).siblings(".active").removeClass("active");
			$(this).addClass("active");
			
			var l;
			if($(this).index() == 0){
				l = 63;
				
				$(".title2 ul li.d").removeClass("hide");
			}else{
				var offset = $(this).offset();
				l = offset.left - 7 + ($(this).outerWidth(true) / 2);
				
				var c = $.trim($(this).text());
				$(".title2 ul li.d").each(function(){
					var ref = $(this).attr("data-ref");
					if(ref.indexOf("," + c + ",") == -1){
						$(this).addClass("hide");
					}else{
						$(this).removeClass("hide");
					}
				});
			}
			$(".angle").css("left", l + "px");
			
			$(".title2 ul li").eq(0).trigger("click", ["1"]);
		}
		titleWidthResize();
	});
	
	$(".title2 ul li").click(function(e, t){
		if(!$(this).hasClass("active") || t == "1"){
			$(this).siblings(".active").removeClass("active");
			$(this).addClass("active");
			
			var $card = $(".template-container .tmp-card");
			
			var $category = $(".small ul li.active");
			if($category.index() == 0){
				if($(this).index() == 0){
					$card.removeClass("unMatch");
				}else{
					var category2 = $.trim($(this).text());
					$card.each(function(){ 
						var c_category2 = $.trim($(this).attr("data-category2"));
						if(c_category2 == category2){
							$(this).removeClass("unMatch");
						}else{
							$(this).addClass("unMatch");
						}
					});
				}
			}else{
				var category = $.trim($category.text());
				if($(this).index() == 0){
					$card.each(function(){
						var c_category = $.trim($(this).attr("data-category"));
						if(c_category == category){
							$(this).removeClass("unMatch");
						}else{
							$(this).addClass("unMatch");
						}
					});
				}else{
					var category2 = $.trim($(this).text());
					$card.each(function(){
						var c_category = $.trim($(this).attr("data-category"));
						var c_category2 = $.trim($(this).attr("data-category2"));
						if(c_category == category && c_category2 == category2){
							$(this).removeClass("unMatch");
						}else{
							$(this).addClass("unMatch");
						}
					});
				}
			}
			
			$(".searchBtn").trigger("click");
		}
	});
	$("#searchKey").bind("keypress",function(event){
  		if(event.keyCode==13) $(".searchBtn").click();
  	});
	$(".searchBtn").click(function(){
		var currSearchKey = $("#searchKey").val();
		$(".template-container .tmp-card:not(.unMatch)").each(function(){
			var data_label = $(".head h2", this).text();
			
			if(data_label.toLowerCase().indexOf(currSearchKey.toLowerCase()) == -1){
				$(this).hide();	
			}else{
				$(this).show();
			}
		});
	});
	
	$("#impBtn").click(function(){
		showImportPanel();
	});
	
	$("#title1-scroll-left").click(function(){
		var tabs=$(".small .hide");
		if(tabs.length > 0){
			tabs.last().removeClass("hide");
        }
    });
    $("#title1-scroll-right").click(function(){
    	var tabs = $(".small ul").children();
    	var first = null;
        tabs.each(function(){
        	var className = $(this).attr("class");
        	if((typeof className) != "undefined" && className.indexOf("hide") != -1){
                first = $(this);
            }
        });
        if(first == null){
            tabs.first().addClass("hide");
        }else{
        	first.next().addClass("hide");
        } 
    });
	
	$("#title2-scroll-left").click(function(){
		var tabs=$(".title2 .hide");
		if(tabs.length > 0){
			var activeTitle = $(".small ul li.active").text();
			if(activeTitle == "<%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%>"){  //全部
				tabs.last().removeClass("hide");
			}else{
				var length = tabs.length;
				for(var i = length - 1; i >= 0; i--){
					var $last = tabs.eq(i);
					var ref = $last.attr("data-ref");
					if((typeof ref) == "undefined"){
						$last.removeClass("hide");
						break;
					}else if(ref.indexOf("," + activeTitle + ",") != -1){
						$last.removeClass("hide");
						break;
					}
				}
			}
			
        }
    });
    $("#title2-scroll-right").click(function(){
    	var tabs = $(".title2 ul li.d");
        var first = null;
        var activeTitle = $(".small ul li.active").text();
        
        if(activeTitle == "<%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%>"){  //全部
			tabs.each(function(){
            	var className = $(this).attr("class");
        		if((typeof className) != "undefined" && className.indexOf("hide") != -1){
        			first = $(this);
            	}
        	});
        	if(first == null){
            	tabs.first().addClass("hide");
        	}else{
        		first.next().addClass("hide");
        	}
		}else{
			var index = 0;
			tabs = $(".title2 ul li.d[data-ref*='"+activeTitle+"']");
			tabs.each(function(){
            	var className = $(this).attr("class");
        		if((typeof className) != "undefined" && className.indexOf("hide") != -1){
        			first = $(this);
        			index++;
            	}
        	});
        	if(first == null){
            	tabs.first().addClass("hide");
        	}else{
        		tabs.eq(index).addClass("hide");
        	}
		}
        
    });
    
    titleWidthResize();
	
	$("#import-panel .import-close, #import-panel .import-proxy").click(function(){
		hideImportPanel();
	});
	$(document.body).click(function(){
		$(".categoryChoose").hide();
	});
	loadData();
});

function titleWidthResize(){
	var windowWidth = $(window).width();
	var title1MaxWidth = windowWidth - 300;
	var title1Width = $(".small").width();
	var title2MaxWidth = windowWidth - 80;
	var title2Width = 0;
	var activeTitle = $(".small ul li.active").text();
	var $tabs = $(".title2 ul li[data-ref*='"+activeTitle+"']");
	if(activeTitle == "<%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%>"){   //全部
		$tabs = $(".title2 ul li");
	}else{
		title2Width = 40;
	}
	$tabs.each(function(){
		title2Width += $(this).width() + 2;
	});
	if(title1Width >= title1MaxWidth){
		$(".small").css("width", title1MaxWidth);
		$("#title1-scroll-left").show();
		$("#title1-scroll-right").show();
	}else{
		$("#title1-scroll-left").hide();
		$("#title1-scroll-right").hide();
	}
	
	if(title2Width >= title2MaxWidth){
		$(".title2").css("width", title2MaxWidth);
		$("#title2-scroll-left").show();
		$("#title2-scroll-right").show();
	}else{
		$(".title2").css("width", title2Width + 10);
		$("#title2-scroll-left").hide();
		$("#title2-scroll-right").hide();
	}
}

function removeCardOnPage(id){
	var $card = $("#tmp-card-" + id);
	$card.animate({width: '0px'}, 120, function(){
		$card.remove();
	});
}

function removeCardOnServer(id){
	var $card = $("#tmp-card-" + id);
	var name = $(".head h2", $card).text();
	if(confirm("<%=SystemEnv.getHtmlLabelName(127699,user.getLanguage())%>")){   //确定要删除此模板吗？
		var url = jionActionUrl("com.weaver.formmodel.mobile.template.TemplateAction", "action=delete");
		showLoading();
		FormmodeUtil.doAjaxDataSave(url, {"id" : id}, function(result){
			hideLoading();
			var status = result["status"];
			if(status == "1"){
				removeCardOnPage(id);
				showMsg("<%=SystemEnv.getHtmlLabelName(20461,user.getLanguage())%>", "success", 2000);  //删除成功
			}else{
				var message = result["message"];
				showMsg("<%=SystemEnv.getHtmlLabelName(127478,user.getLanguage())%>" + message, "error", 10000);  //删除时出现错误：
			}
		});
	}
};

function showImportPanel(callbackFn){
	var $importPanel = $("#import-panel");
	$importPanel.removeClass("hide");
	setTimeout(function(){
		$importPanel.addClass("show");
		if(typeof(callbackFn) == "function"){
			callbackFn.call(this);
		}
	}, 300);	
}

function hideImportPanel(callbackFn){
	var $importPanel = $("#import-panel");
	$importPanel.removeClass("show");
	$importPanel.addClass("hide");
	setTimeout(function(){
		if(typeof(callbackFn) == "function"){
			callbackFn.call(this);
		}
	}, 300);
}

function doImport(){
	var $importPanel = $("#import-panel");
	var $file = $(".import-file", $importPanel);
	if($file[0].value != ""){
		if(!$file[0].value.match(/.zip|.rar/i)){
			alert("<%=SystemEnv.getHtmlLabelName(127485,user.getLanguage())%>");  //文件格式错误，请选择一个压缩文件(.zip | .rar)
		}else{
			submitImportToServer();
		}
	}
}

function submitImportToServer(){
	var $impBtn = $("#import-panel .import-choose");
	if(!$impBtn.hasClass("disabled")){
		$impBtn.addClass("disabled");
		var $form = $("#importForm");
		$form[0].action = jionActionUrl("com.weaver.formmodel.mobile.template.TemplateAction", "action=import");
		showLoading();
		$form.submit();
	}
}

function submitImportCallback(result){
	var status = result["status"];
	
	function resetImp(){
		hideLoading();
		var $impBtn = $("#import-panel .import-choose");
		$impBtn.removeClass("disabled");
		
		var $importPanel = $("#import-panel");
		var file = $(".import-file", $importPanel)[0];
		if (file.outerHTML) {
			file.outerHTML = file.outerHTML;
		} else {
			file.value = "";
		}
	}
		
	if(status == "1"){
		var impMeta = result["impMeta"];
		var status2 = impMeta["status"];
		var id = impMeta["id"];
		if(status2 == "1"){
			var dirname = impMeta["dirname"];
			var isoverride = confirm("<%=SystemEnv.getHtmlLabelName(127700,user.getLanguage())%>");  //系统已包含将导入的模板，确定要覆盖吗？\n\n单击“确定”将使用导入的模板覆盖系统中已存在的模板。\n\n单击“取消”终止导入。
			var url = jionActionUrl("com.weaver.formmodel.mobile.template.TemplateAction", "action=import2");
			FormmodeUtil.doAjaxDataSave(url, {"id" : id, "dirname" : dirname, "isoverride" : isoverride}, function(result2){
				var status3 = result2["status"];
				if(status3 == "1"){
					resetImp();
					if(isoverride){
						hideImportPanel(function(){
							showMsg("<%=SystemEnv.getHtmlLabelName(25750,user.getLanguage())%>", "success", 2000);  //导入成功
							loadData();
						});
					}else{
						showMsg("<%=SystemEnv.getHtmlLabelName(127487,user.getLanguage())%>", "fff", 2000);  //已终止导入
					}
				}else{
					resetImp();
					var message = result2["message"];
					if(isoverride){
						showMsg("<%=SystemEnv.getHtmlLabelName(127488,user.getLanguage())%>" + message, "error", 10000);  //导入时出现错误：
					}else{
						showMsg("<%=SystemEnv.getHtmlLabelName(127489,user.getLanguage())%>" + message, "error", 10000);  //终止导入时出现错误：
					}
				}
			});
		}else if(status2 == "2"){
			resetImp();
			hideImportPanel(function(){
				showMsg("<%=SystemEnv.getHtmlLabelName(25750,user.getLanguage())%>", "success", 2000);  //导入成功
				loadData();
			});
		}
	}else{
		resetImp();
		var message = result["message"];
		showMsg("<%=SystemEnv.getHtmlLabelName(127488,user.getLanguage())%>" + message, "error", 10000);  //导入时出现错误：
	}
}
</script>
</head>
  
<body>
	<div id="s_loading">
		<div class="spinner">
		  <div class="bounce1"></div>
		  <div class="bounce2"></div>
		  <div class="bounce3"></div>
		</div>
	</div>
	<div id="message"></div>
	<div class="title">
		<div class="text">
			<div class="big"><%=SystemEnv.getHtmlLabelName(20823,user.getLanguage())%><!-- 模板管理 --></div>
			
			<div class="small">
				<ul>
					<li class="active"><%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%><!-- 全部 --><div class="rightBorder"></div></li>
					<% for(String c : cList){ %>
						<li><%=c %><div class="rightBorder"></div></li>
					<% } %>
					
				</ul>
			</div>
			<div id="title1-scroll-left" class="tabs-scroller-left"></div>
			<div id="title1-scroll-right" class="tabs-scroller-right"></div>
		</div>
		
		<div class="searchWrap">
			<input type="text" id="searchKey" placeholder="<%=SystemEnv.getHtmlLabelName(127510,user.getLanguage())%>"/><!-- 检索模板 -->
			<div class="searchBtn"></div>
		</div>
		
		<div class="button">
			<div id="impBtn"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%><!-- 导入 --></div>
		</div>
	</div>
	<div class="angle"></div>
	
	<div class="title2">
	
		<ul>
			<li class="active"><a href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%><!-- 全部 --></a></li>
			<% Set<String> c2Set = c2Map.keySet(); %>
			<% for(String c : c2Set){ %>
				<li data-ref="<%=c2Map.get(c)%>" class="d"><a href="javascript:void(0);"><%=c %></a></li>
			<% } %>
		</ul>
		
	</div>
	<div id="title2-scroll-left" class="tabs-scroller-left"></div>
	<div id="title2-scroll-right" class="tabs-scroller-right"></div>
	
	<div class="template-container">
		<% for(int i = 0; i < tmpList.size(); i++){
			Template tmp = tmpList.get(i);
			String previewImg = Util.null2String(tmp.getPreviewImg()).trim();
			previewImg = (previewImg.equals("")) ? "/mobilemode/images/noImg.jpg" : previewImg;
		%>
		<div class="tmp-card card-view card-view-style<%=user.getLanguage()%>" id="tmp-card-<%=Util.null2String(tmp.getId())%>" data-id="<%=Util.null2String(tmp.getId())%>" data-category="<%=Util.null2String(tmp.getCategory())%>" data-category2="<%=Util.null2String(tmp.getCategory2())%>">
			<div class="tmp-content">
				<div class="card-view-panel">
					<img src="<%=previewImg%>">
					<div class="head">
						<h2><%=Util.null2String(tmp.getName())%></h2>
						<div class="crdate"><%=SystemEnv.getHtmlLabelName(127511,user.getLanguage())%><!-- 创建于 --><%=Util.null2String(tmp.getCreateDate())%></div>
					</div>
				</div>
			</div>
			<div class="tmp-btn-wrap hide">
				<div class="tmp-btn delete">
					<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%><!-- 删除 -->
				</div>
				<div class="tmp-btn export">
					<%=SystemEnv.getHtmlLabelName(17416,user.getLanguage())%><!-- 导出 -->
				</div>
			</div>
		</div>
		<% } %>
	</div>
	
	<div id="import-panel" class="hide">
		<div class="import-proxy"></div>
		<div class="import-close"></div>
		<div class="import-wrap">
			<div class="import-inner">
				<iframe name="importFormFrame" style="display: none;"></iframe>
				<form target="importFormFrame" id="importForm" method="post" enctype="multipart/form-data">
				<div class="import-choose">
					<%=SystemEnv.getHtmlLabelName(125333,user.getLanguage())%><!-- 选择文件 -->
					<input type="file" name="file" class="import-file" accept="application/x-zip-compressed" single="single" onchange="doImport();" />
				</div>
				</form>
				
				<div class="import-desc">
					<div style="background-color: #aaa;color: #fff;padding:8px;"><%=SystemEnv.getHtmlLabelName(127463,user.getLanguage())%><!-- 导入说明： --></div>
					<div style="padding:5px 8px;"><%=SystemEnv.getHtmlLabelName(127701,user.getLanguage())%><!-- 每个模板都有一个唯一的ID。 --></div>
					<ul>
						<li><%=SystemEnv.getHtmlLabelName(127702,user.getLanguage())%><!-- 如果导入的模板和现有的模板ID一样，则在导入时会使用导入的模板覆盖现有的模板(常见操作为从系统中导出模板后再进行导入操作，此时则会覆盖掉系统现有模板，系统会有覆盖提示)。 --></li>
						<li><%=SystemEnv.getHtmlLabelName(127703,user.getLanguage())%><!-- 如果导入的模板和现有的模板ID不一样，则在导入后会将导入的模板作为一种新模板添加到系统中(常见操作为从其他系统或者模板库中导出一种新的模板，导入到当前系统)。 --></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div id="categoryChooseContainer">
		<div class="categoryChoose categoryChoose1" value-for="category">
			<% if(cList.isEmpty()){%>
				<div class="t"><%=SystemEnv.getHtmlLabelName(127562,user.getLanguage())%><!-- 暂无分类选择，请在上方的文本框中输入 --></div>
			<% }else{ %>
				<ul>
				<% for(String c : cList){ %>
					<li><%=c %></li>
				<% } %>
				</ul>
			<% } %>
		</div>
		
		<div class="categoryChoose categoryChoose2" value-for="category2">
			<% if(c2List.isEmpty()){%>
				<div class="t"><%=SystemEnv.getHtmlLabelName(127562,user.getLanguage())%><!-- 暂无分类选择，请在上方的文本框中输入 --></div>
			<% }else{ %>
				<ul>
				<% for(String c : c2List){ %>
					<li><%=c %></li>
				<% } %>
				</ul>
			<% } %>
		</div>
	</div>
</body>
</html>
