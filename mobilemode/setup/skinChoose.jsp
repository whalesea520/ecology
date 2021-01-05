<%@page import="com.weaver.formmodel.mobile.model.MobileAppBaseInfo"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/mobilemode/init.jsp"%>
<%
if(!HrmUserVarify.checkUserRight("MobileModeSet:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String id = "";
int appid = Util.getIntValue(Util.null2String(request.getParameter("appid")));
MobileAppBaseManager mobileAppBaseManager = MobileAppBaseManager.getInstance();
MobileAppBaseInfo mobileAppBaseInfo = mobileAppBaseManager.get(appid);
if(mobileAppBaseInfo != null){
	id = Util.null2String(mobileAppBaseInfo.getSkin());
}

String noImg = "/mobilemode/images/noImg.jpg";
%>
<!DOCTYPE HTML>
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(81788,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(127458,user.getLanguage())%><!-- 移动建模-皮肤选择 --></title>
<link rel="stylesheet" href="/mobilemode/js/photoSwipe/css/photoswipe_wev8.css"> 
<link rel="stylesheet" href="/mobilemode/js/photoSwipe/css/default-skin2/default-skin_wev8.css"> 
<script src="/mobilemode/js/photoSwipe/js/photoswipe.min_wev8.js"></script> 
<script src="/mobilemode/js/photoSwipe/js/photoswipe-ui-default.min_wev8.js"></script> 
<style type="text/css">
*{
	font-family: 'Microsoft YaHei', Arial;
	font-size: 12px;
}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px;
	overflow: hidden;
}
.spinner {
  margin: 0px auto 0px;
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
#main-panel{
	height: 100%;
	position: relative;
}
.title{
		border-bottom: 1px solid #DADADA;
		overflow: hidden;
		padding: 0px 10px;
		font-family: 'Microsoft YaHei';
		height: 60px;
		overflow: hidden;
	}
	.text{
		float: left;
		background: url("/js/tabs/images/nav/mnav7_wev8.png") no-repeat;
		padding-left: 48px;
		margin-top: 10px;
		height: 42px;
	}
	.text .big{
		font-size: 16px;
		color: #333;
	}
	.text .small{
		font-size: 12px;
		color: #AFAFAF;
		margin-top: 2px;
	}
	.button{
		float: right;
		margin-top: 29px;
	}
	.button div{
		background-color: #2690e3;
		color: #fff;
		padding: 0px 12px;
		height: 25px;
		line-height: 25px;
		cursor: pointer;
	}
.skin-container{
	position: absolute;
	top: 61px;
	left: 0px;
	bottom: 46px;
	right: 0px;
	padding: 0px 0px 20px 30px;
	background: #ededed;
	overflow-x: hidden;
	overflow-y: auto;
}
.skin-card{
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
.skin-card.active{
	border: 1px solid #2690e3;
	outline: 1px solid #2690e3;
}
.skin-card.active:before {
	content: ".";
	position: absolute;
	right: -8px;
	transform: rotate(135deg);
	-ms-transform: rotate(135deg);
	-webkit-transform: rotate(135deg);
	top: -33px;
	width: 0px;
	height: 0px;
	border-bottom: 50px solid transparent;
	border-top: 50px solid transparent;
	border-right: 50px solid #2690e3;
	font-size: 0px;
	line-height: 0px;
	z-index: 1;
}
.skin-card.active:after {
	content: "<%=SystemEnv.getHtmlLabelName(128208,user.getLanguage())%>"; 
	transform: rotate(45deg);
	-ms-transform: rotate(45deg);
	-webkit-transform: rotate(45deg);
	position: absolute;
	right: -4px;
	top: 13px;
	color: #fff;
	font-size: 14px;
	z-index: 1;
}
.skin-card .skin-content{
	padding: 10px 10px 0 10px;
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
	padding: 0 10px;
	font-size: 14px;
	color: #666;
}
.card-view-panel .head h2 {
	width: 60%;
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
.skin-card .zoom{
	width: 50px;
	height: 50px;
	background: url(/mobilemode/images/zoom.png) no-repeat;
	background-position: right center;
	background-size: 16px 16px;
	float: right;
	cursor: pointer;
}
.skin-card.no-img .zoom{
	display: none;
}
.div_bottom{
	position: absolute;
	left:0px;
	bottom: 0px;
	height: 45px;
	width: 100%;
	background-color: #FAFAFA;
	border-top: 1px solid #DADADA;
	text-align: center;
	line-height: 45px;
}
.div_bottom button{
	color: #007aff;
	height: 30px;
	line-height: 30px;
	padding-left: 18px;
	padding-right: 18px;
	font-size: 12px;
	background-color: #2690e3;
	color: #fff;
}
.div_bottom button.cancel {
	background-color: #eee;
	color: #007aff;
	margin-left: 5px;
}
</style>
<script type="text/javascript">
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

function showLoading(){
	var $msg = $("#message");
	if($msg.is(":hidden")){
		$("#s_loading").show();
	}
}

function hideLoading(){
	$("#s_loading").hide();
}
function loadData(){
	var url = jionActionUrl("com.weaver.formmodel.mobile.skin.SkinAction", "action=getAllSkin&_frompage=chooseSkin");
	showLoading();
	FormmodeUtil.doAjaxDataLoad(url, function(result){
		hideLoading();
		var status = result["status"];
		if(status == "0"){
			var message = result["message"];
			showMsg("<%=SystemEnv.getHtmlLabelName(127465,user.getLanguage())%>" + message, "error", 10000);//加载皮肤时出现错误：
		}
		$(".skin-container .skin-card").not(".add-card").remove();
		var data = result["data"];
		for(var i = 0; i < data.length; i++){
			addSkinCard(data[i]);
		}
		$("#skin-card-<%=id%>").addClass("active");
	});
}

function addSkinCard(data){
	var id = data["id"];
	var name = data["name"];
	var previewImg = data["previewImg"];
	var cn = "card-view";
	var firstImg;
	if($.trim(previewImg) != ""){
		firstImg = previewImg.split(";;")[0];
	}else{
		firstImg = "<%=noImg%>";
		cn += " no-img";
	}
	var $card = $("<div class=\"skin-card "+cn+"\" id=\"skin-card-"+id+"\" data-sid=\""+id+"\"></div>");
	
	var html = "<div class=\"skin-content\">"
				 + "<div class=\"card-view-panel\">"
					+ "<img src=\""+firstImg+"\">"
	                + "<div class=\"head\">"
	                    + "<h2>"+name+"</h2>"
	                    + "<div class=\"zoom\" title=\"<%=SystemEnv.getHtmlLabelName(127466,user.getLanguage())%>\"></div>"//查看大图
	                + "</div>"
				 + "</div>"
            + "</div>";
    $card.html(html);
	$(".skin-container").append($card);
	
	$card.click(function(){
		$(this).siblings(".skin-card").removeClass("active");
		$(this).toggleClass("active");
	});
	
	$(".zoom", $card).click(function(e){
		openPhotoSwipe(previewImg);
		e.stopPropagation();
	});
}

var openPhotoSwipe = function(previewImg) {
    var pswpElement = document.querySelectorAll('.pswp')[0];
    var items = [];
    
    var imgArr = previewImg.split(";;");
    for(var i = 0; i < imgArr.length; i++){
    	items.push({
    		src: imgArr[i],
            w: 800,
            h: 1142
    	});
    }
    
    var options = {
        history: false,
        focus: false,
        showAnimationDuration: 0,
        hideAnimationDuration: 0,
        loop : false
    };
    var gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, items, options);
    gallery.init();
};

function onOk(){
	var id = "";
	var $card = $(".skin-container .skin-card.active");
	if($card.length > 0){
		id = $card.attr("data-sid");
	}
	var isChange = id != "<%=id%>";
	var result = {"isChange": isChange, "skin": id};
	top.closeTopDialog(result);
}

function onClose(){
	top.closeTopDialog();
}

$(document).ready(function(){
	loadData();
	
	$("#impBtn").click(function(){
		var url = "/mobilemode/setup/skinManage.jsp";
		window.open(url, "skinManage");
	});
});
</script>
</head>
  
<body>
<div class="pswp" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="pswp__bg"></div>
	<div class="pswp__scroll-wrap">
	    <div class="pswp__container">
	        <div class="pswp__item"></div>
	        <div class="pswp__item"></div>
	        <div class="pswp__item"></div>
	    </div>

		<div class="pswp__ui pswp__ui--hidden">
			<div class="pswp__top-bar">
				<div class="pswp__counter"></div>
	            <div class="pswp__preloader">
	               <div class="pswp__preloader__icn">
	                 <div class="pswp__preloader__cut">
	                   <div class="pswp__preloader__donut"></div>
	                 </div>
	               </div>
	            </div>
			</div>
	         <div class="pswp__share-modal pswp__share-modal--hidden pswp__single-tap">
	            <div class="pswp__share-tooltip"></div> 
	         </div>
			 <button class="pswp__button pswp__button--arrow--left" title="Previous (arrow left)"></button>
			 <button class="pswp__button pswp__button--arrow--right" title="Next (arrow right)"></button>
	         <div class="pswp__caption">
	            <div class="pswp__caption__center"></div>
	         </div>
		</div>
	</div>
</div>
		 
<div id="s_loading">
	<div class="spinner">
	  <div class="bounce1"></div>
	  <div class="bounce2"></div>
	  <div class="bounce3"></div>
	</div>
</div>
<div id="message"></div>
<div id="main-panel">
	<div class="title">
		<div class="text">
			<div class="big"><%=SystemEnv.getHtmlLabelName(81788,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(127458,user.getLanguage())%><!-- 移动建模-皮肤选择 --></div>
			<div class="small">Skin Choose</div>
		</div>
		
		<div class="button">
			<div id="impBtn"><%=SystemEnv.getHtmlLabelName(127462,user.getLanguage())%><!-- 皮肤管理 --></div>
		</div>
	</div>
	<div class="skin-container">
		
	</div>
	<div class="div_bottom">
		<button type="button" onclick="onOk()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
		<button type="button" onclick="onClose()" class="cancel"><%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%><!-- 关闭 --></button>
	</div>
</div>
</body>
</html>
