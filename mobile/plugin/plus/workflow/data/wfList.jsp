<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>流程查询</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
<link type="text/css" rel="stylesheet" href="/main/assets/css/font-awesome.css">
<link rel="stylesheet" href="/main/assets/weui/weui.css">
<script type="text/javascript" src="/main/assets/js/jquery.js"></script>
<script type="text/javascript" src="/main/assets/js/iscroll.js?1"></script>
<script type="text/javascript" src="/main/assets/js/swipe.js"></script>
<style type="text/css">
body {
	background:#fff;
	margin: 0;
	padding: 0;
	font: 14px/1.5 "Microsoft Yahei",arial,"Hiragino Sans GB",sans-serif;
	color: #666;
}

a {
	text-decoration: none;
}

table {
	border-collapse: separate;
	border-spacing: 0px;
}
#userChooseDiv{
	position:fixed;
    left: 0px;
    top: 0px;
    width: 100%;
    height: 100%;
    z-index: 99999;
    transition:All 0.3s;
	-webkit-transition:All 0.3s;
	-webkit-transform: translate3d(100%, 0, 0);
	transform: translate3d(100%, 0, 0);
	visibility: hidden;
}
body.hrmshow #userChooseDiv{
	-webkit-transform: translate3d(0, 0, 0);
	transform: translate3d(0, 0, 0);
	visibility: visible;
}
#userChooseFrame{
	width: 100%;
    height: 100%;
}
.weui_btn_primary{
	background-color:#007afb;
}
#page {
	width:100%;
	height:100%;
}

#loading {
	position: fixed;
	top: 50%;
	left: 50%;
	width: 40px;
	height: 40px;
	text-align: center;
	margin-top: -20px;
	margin-left: -20px;
	z-index: 9999;
	background: url("/main/wxpublic/images/loading.gif") 0 0 no-repeat;
	-webkit-background-size: 40px 40px;
	background-size: 40px 40px;
	display: none;
}

#loadingmask {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	z-index: 9998;
	background-color: #000;
	opacity: 0.1;
	display: none;
}

/* 列表区域 */
.list {
	width: 100%;
}
/* 列表项*/
.listitem {
	width: 100%;
	height: 70px;
	border-bottom: 1px solid #eee;
}
/* 列表项后置导航 */
.itemnavpoint {
	height: 100%;
	width: 26px;
	text-align: center;
}
/* 列表项后置导航图  */
.itemnavpoint img {
	width: 10px;
	heigth: 14px;
}
/* 流程创建人头像区域  */
.itempreview {
	height: 100%;
	width: 40px;
	text-align: center;
	padding-left: 5px;
	padding-right: 5px;
}
/* 流程创建人头像  */
.itempreview .item-avatar {
	width: 40px;
	height: 40px;
	margin-top: 5px;
}

.itempreview .collect-sign {
	width: 30px;
	height: 30px;
	vertical-align: middle;
}

/* 列表项内容区域 */
.itemcontent {
	width: *;
	height: 100%;
	font-size: 14px;
}

/* 列表项内容名称 */
.itemcontenttitle {
	width: 100%;
	height: 23px;
	overflow-y: hidden;
	line-height: 23px;
	word-break: keep-all;
	text-overflow: ellipsis;
	white-space: nowrap;
	overflow: hidden;
	font-size: 16px;
	color: #333;
}

/* 列表项内容简介 */
.itemcontentitdt {
	width: 100%;
	height: 23px;
	padding-left: 5px;
	overflow-y: hidden;
	line-height: 23px;
	font-size: 12px;
	color: #999;
	word-break: keep-all;
	text-overflow: ellipsis;
	white-space: nowrap;
	overflow: hidden;
}
/* 更多 */
.total-info {
	height: 50px;
	line-height: 50px;
	text-align: center;
	font-weight: bold;
	color: #777878;
	display: none;
}
/* 列表更新时间 */
.lastupdatedate {
	width: 100%;
	height: 20px;
	text-align: right;
	font-size: 12px;
	line-height: 20px;
	background: #E1E8EC;
	background: -moz-linear-gradient(0, white, #E1E8EC);
	background: -webkit-gradient(linear, 0 0, 0 100%, from(white),
		to(#E1E8EC) );
}

/* 列表项标题 */
.ictwz {
	width: *;
	word-break: keep-all;
	text-overflow: ellipsis;
	white-space: nowrap;
	overflow: hidden;
}

/* new */
.ictnew {
	width: 20px;
}

/***************** mobilemode/css/mobile_webhead_wev8.css?v=20150423 begin **************/
#webHeadContainer_top{
	position: fixed;
	left: 0px;
	top: 0px;
	width: 100%;
	height: 40px !important;
	z-index: 8888; 
	font-family: 'Microsoft Yahei', Arial;
	overflow: hidden;
	-webkit-transform: rotateY(0deg);
	transform: rotateY(0deg);
}
.webClientHeadContainer_top{
	width: 100%;
	height: 40px;	
	background-color: rgb(0, 122, 251);
	border-collapse: collapse;
	border: none;
}
.webClientHeadContainer_top td{
	vertical-align: top;
}
.webClientHeadContainer_top td.leftTD_top{
	text-align: left;
	padding-left: 10px;	
}
.webClientHeadContainer_top td.leftTD_top #leftButtonName_top{
	font-size: 16px;
	background-position: -4px center;
	background-size: 26px;
	padding-left: 14px;
	height:100%;
	line-height: 40px;
}
.webClientHeadContainer_top td.leftTD_top #leftButtonName_top_change{
	display:none;
	height: 100%;
	position: relative;
}
#leftButtonName_top_change > img{
	position: absolute;
	left: 0px;
	top: 9px;
	width: 32px;
	height: 32px;
}
.webClientHeadContainer_top td.centerTD_top{
	text-align: center;
}
.webClientHeadContainer_top td.centerTD_top div .menu_arrow_up{
	margin-left:5px;
	width:9px;
	height:9px;
	display:none;
}
.webClientHeadContainer_top td.centerTD_top div .menu_arrow_down{
	margin-left:5px;
	width:9px;
	height:9px;
	display:none;
}
#middleBtnName_top{
	height: 100%;
}
#middlePageName_top{
	height: 100%;
	line-height: 40px;
}
.webClientHeadContainer_top td.rightTD_top{
	text-align: right;	
	padding-right: 10px;
}
#rightBtnName_top{
	height: 100%;
	position: relative;
}
#rightBtnName_top > img{
	position: absolute;
	top: 9px;
	right: 0px;
	width: 32px;
	height: 32px;
}
.webClientHeadContainer_top td div{
	color: #fff;	
}
.webClientHeadContainer_top td.centerTD_top div{
	font-size: 18px;	
	font-weight: bold;
}
/***************** mobilemode/css/mobile_webhead_wev8.css?v=20150423 end **************/

/***************** iscroll begin **************/
#scroll-wrapper {
	position:absolute;
	z-index:1;
	top: 40px;
	bottom:0px;
	left:-9999px;
	width:100%;
	overflow: hidden;
}

#scroll-scroller {
	position:absolute; z-index:1;
/*	-webkit-touch-callout:none;*/
	-webkit-tap-highlight-color: rgba(0,0,0,0);
	width:100%;
	padding:0;
	-webkit-transform: translateZ(0);
	-moz-transform: translateZ(0);
	-ms-transform: translateZ(0);
	-o-transform: translateZ(0);
	transform: translateZ(0);
	-webkit-touch-callout: none;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
	-webkit-text-size-adjust: none;
	-moz-text-size-adjust: none;
	-ms-text-size-adjust: none;
	-o-text-size-adjust: none;
	text-size-adjust: none;
}

#pullDown, #pullUp {
	background:#fff;
	height:40px;
	line-height:40px;
	padding:5px 10px;
	font-weight:bold;
	font-size:14px;
	color:#888;
	text-align: center;
}

#pullDown .pullDownIcon, #pullUp .pullUpIcon {
	display:block; 
	position: absolute;
	left: 12%;
	width:40px; height:40px;
	background:url("/main/wxpublic/images/pull-icon@2x_wev8.png") 0 0 no-repeat;
	-webkit-background-size:40px 80px; background-size:40px 80px;
	-webkit-transition-property:-webkit-transform;
	-webkit-transition-duration:250ms;
}

#pullDown .pullDownIcon {
	-webkit-transform:rotate(0deg) translateZ(0);
}

#pullUp .pullUpIcon  {
	-webkit-transform:rotate(-180deg) translateZ(0);
}

#pullDown.flip .pullDownIcon {
	-webkit-transform:rotate(-180deg) translateZ(0);
}

#pullUp.flip .pullUpIcon {
	-webkit-transform:rotate(0deg) translateZ(0);
}

#pullDown.loading .pullDownIcon, #pullUp.loading .pullUpIcon {
	background-position:0 100%;
	-webkit-transform:rotate(0deg) translateZ(0);
	-webkit-transition-duration:0ms;

	-webkit-animation-name:loading;
	-webkit-animation-duration:2s;
	-webkit-animation-iteration-count:infinite;
	-webkit-animation-timing-function:linear;
}

#pullDown.refresh_success .pullDownIcon {
	background-image: url("/main/wxpublic/images/right_black_wev8.png");
	background-repeat: no-repeat;	
	-webkit-background-size:16px 13px; background-size:16px 13px;
	background-position: center center;
	-webkit-transform:none;
	-webkit-transition-duration:none;
	-webkit-animation-name:none;
	-webkit-animation-duration:none;
	-webkit-animation-iteration-count:none;
	-webkit-animation-timing-function:none;
	display: none;
}

#pullDown .pullDownLabel{
	line-height: 20px;
	display: inline-block;
	font-size: 12px;
}

#pullDown.refresh_success .pullDownLabel{
	background-image: url("/main/wxpublic/images/right_black_wev8.png");
	background-repeat: no-repeat;	
	background-position: left center;
	padding-left: 30px;	
	margin-left: -30px;
}
/***************** iscroll end **************/

.searchBox{
	position:fixed;
    top: 0px;
    width: 100%;
    height: 100%;
	top: 40px;
	left: 0;
	right:0;
	bottom:0;
	z-index: 100;
	background: #fff;
	-webkit-transform: translate3d(100%, 0, 0);
	transform: translate3d(100%, 0, 0);
}
.searchBoxshow{
	-webkit-transform: translate3d(0, 0, 0);
	transform: translate3d(0, 0, 0);
}


.tab-nav {
	height: 40px;
	line-height: 40px;
	padding-left: 5px;
	background-color: #fff;
	border-bottom: 1px #f0f0f0 solid;
	position: relative;
}

.tab-nav-item {
	width: 50px;
	margin-bottom: 3px;
	text-align: center;
	font-size: 16px;
	color: #666;
	display: inline-block;
}

.tab-nav-active {
	border-bottom: 2px #2a7ee7 solid;
}

.tab-nav-split {
	width: 5px;
	text-align: center;
	color: #666;
	display: inline-block;
}

.tab-nav-tags {
	position: absolute;
	top: 50px;
	left: 150px;
	width: 90px;
	min-height: 100px;
	border-radius: 5px;
	background-color: #ddd;
	display: none;
}

.tab-nav-tag {
	line-height: 28px;
	text-align: center;
	color: #555;
	border-bottom: 1px #eee solid;
}

.tab-nav-arraws {
	position: absolute;
	left: 190px;
	top: 40px;
	width: 0;
	height: 0;
	border-width: 0 5px 10px 5px;
	border-color: transparent transparent #ddd transparent;
	border-style: solid;
	display: none;
}

.swipe {
	overflow: hidden;
	visibility: hidden;
	position: relative;
	border-bottom: 1px solid #eee;
}

.swipe-wrap {
	overflow: hidden;
	position: relative;
}

.swipe-wrap > div {
	float: left;
	width: 100%;
	position: relative;
}

.swipe-wrap .swipe-wrap-card {
	width: 100%;
	padding-bottom: 30px;
	background-color: #FFF;
}

.swipe-wrap .swipe-wrap-card-title {
	position: absolute;
	right: 90px;
	bottom: 0;
	left: 0;
	height: 30px;
	line-height: 30px;
	padding-left: 10px;
	color: #666;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}

nav.swipe-nav {
	position: absolute;
	right: 10px;
	bottom: 6px;
}

nav.swipe-nav .swipe-position {
	text-align: center;
	list-style: none;
	margin: 0;
	padding: 0;
}

nav.swipe-nav .swipe-position ul {
	list-style: none;
	list-style-image: none;
	margin: 0;
	padding: 0;
}

nav.swipe-nav .swipe-position li {
	display: inline-block;
	width: 8px;
	height: 8px;
	border: 1px #ddd solid;
	border-radius: 50%;
	background: #fff;
	margin-right: 2px;
	margin-left: 2px;
	cursor: pointer;
}

nav.swipe-nav .swipe-position li.on {
	background-color: #2a7ee7;
	background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #2a7ee7), color-stop(100%, #2a7ee7) );
	background-image: -webkit-linear-gradient(top, #2a7ee7, #2a7ee7);
	background-image: -moz-linear-gradient(top, #2a7ee7, #2a7ee7);
	background-image: -ms-linear-gradient(top, #2a7ee7, #2a7ee7);
	background-image: -o-linear-gradient(top, #2a7ee7, #2a7ee7);
	background-image: linear-gradient(top, #2a7ee7, #2a7ee7);
}

.goToTop {
	position: fixed;
	right: 10px;
	bottom: 20px;
	width: 40px;
	height: 40px;
	background-color: #000;
	border-radius: 3px;
	color: #FFF;
	font-size: 50px;
	text-align: center;
	opacity: .3;
	z-index: 2000;
	display: none;
}
.goToTop .topImg{
	width:40px;
	height:40px;
}

.goToTop i {
	position: absolute;
	top: -8px;
	left: 0;
	width: 40px;
}
</style>
<script type="text/javascript">
	function loadList(type, isscroll) {
		var module = $("#module").val();
		var pageindex = $("#pageindex").val();
		var pagesize = $("#pagesize").val();
		var keyword = $("#keyword").val();
		var createid = $("#createid").val();
		var createdatestart = $("#createdatestart").val();
		var createdateend = $("#createdateend").val();
		var pagecount = $("#pagecount").val();
		if(type==1) { //refresh
			pageindex = 1;
		} else if(type==2) { //add
			pageindex = parseInt(pageindex+"") + 1;
		}
		
		var url = "/mobile/plugin/plus/workflow/data/wfOperation.jsp?operation=getDataList&pagesize="
				+pagesize+"&pageindex="+pageindex+"&keyword="+keyword+"&createid="+createid+"&createdatestart="+createdatestart+"&createdateend="+createdateend;
		$.ajax({
			url : url,
			dataType : "json",
			async : ((isscroll == -1 || isscroll == 1 || isscroll == 2) ? true : false),
			beforeSend : function(XMLHttpRequest) {
				if (isscroll != -1 && isscroll != 1) {
					$("#loading").show();
					$("#loadingmask").show();
				}
			},
			success : function(data) {
				  try{
					  var errormsg = data.error;
						if(errormsg&&errormsg.length>0) {
							alert(errormsg);
							$(".total-info").html("加载失败").show();
							$("#pullUp").hide();
						}
						
						if(data.list) {
							if(type==1) {
								$("#list").html("");
								$(".swipe-wrap").html("");
								$(".swipe-position").html("");
							}

							if($("#page_"+data.pageindex).length>0) {
								$("#page_"+data.pageindex).html("");
							} else {
								$("#list").append('<div id="page_'+data.pageindex+'"></div>');
							}
							$("#pagesize").val(data.pagesize);
							$("#ishavepre").val(data.ishavepre);
							$("#count").val(data.count);
							$("#pagecount").val(data.pagecount);
							$("#pageindex").val(data.pageindex);
							$("#ishavenext").val(data.ishavenext);
							
							if (data.count == "0") {
								$(".total-info").html("没有数据").show();
								$("#pullUp").css("visibility", "hidden");
							} else if (data.ishavenext == "0") {
								$(".total-info").html("总共" + data.count + "条").show();
								$("#pullUp").css("visibility", "hidden");
							} else {
								$(".total-info").hide();
								$("#pullUp").css("visibility", "visible");
							}
							
							$.each(data.list,function(j,item){
								var imageurl = item.image;
								$("#page_"+pageindex).append(
										'<a href="javascript:goPage(\''+item.id+'\')">'+
										'<div class="listitem" id="id_'+item.id+'">'+
										'	<table style="width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;">'+
										'		<tbody>'+
										'			<tr>'+
										'				<td class="itempreview">'+
										'					<img class="item-avatar" src="'+imageurl+'" style="border-radius: 50%;">'+
										'				</td>'+
										'				<td class="itemcontent">'+
										'					<div class="itemcontenttitle">'+
										'						<table style="width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;">'+
										'							<tbody>'+
										'								<tr>'+
										'									<td class="ictwz">'+item.subject+'</td>'+
										(item.isnew==1?'					<td class=\"ictnew\" id=\"wfisnew_" + wfid + "\"><img src=\"/images/new.gif\" width=\"20\" ></td>':'')+
										'								</tr>'+
										'							</tbody>'+
										'						</table>'+
										'					</div>'+
										'					<div class="itemcontentitdt">'+item.description+'</div>'+
										'				</td>'+
										'				<td class="itemnavpoint">'+
										'					<img src="/images/icon-right.png">'+
										'				</td>'+
										'			</tr>'+
										'		</tbody>'+
										'	</table>'+
										'</div>'+
										'</a>'
								);
							});
							var d = new Date();
							$(".pullDownLabel-time").html("最后更新时间： 今天 "+d.getHours()+":"+d.getMinutes()+":"+d.getSeconds());
						}
						
						if (isscroll == -1) {
							pullDownEl.querySelector(".pullDownLabel-title").innerHTML = "刷新成功";
							pullDownEl.className = "refresh_success";
							setTimeout(function () {
								myScroll.refresh();
							}, 800);
						} else if (isscroll == 1) {
							pullUpEl.style.display = "none";
							myScroll.refresh();
						}
				}catch(e){
					$(".total-info").html("加载失败").show();
					$("#pullUp").hide();
				}
			},
			complete : function(XMLHttpRequest, textStatus) {
				if (isscroll != -1 && isscroll != 1) {
					$("#loading").hide();
					$("#loadingmask").hide();
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$(".total-info").html("读取数据失败，请退出重试或联系管理员！").show();
				$("#pullUp").hide();
			}
		});
	}
	
	function goPage(detailid) {
		$("#loading").show();
		$("#loadingmask").show();
		var module = $("#module").val();
		var scope = $("#scope").val();
		location = "/mobile/plugin/1/view.jsp?module=" + module + "&scope=" + scope + "&detailid=" + detailid;
		$("#loading").hide();
		$("#loadingmask").hide();
	}
	
	function toggleSearchBox() {
		if($("#searchBox").hasClass("searchBoxshow")){
			$("#searchBox").removeClass("searchBoxshow");
		}else{
			$("#searchBox").addClass("searchBoxshow");
		}
	}
	
	function doSearch(){
		$("#searchBox").removeClass("searchBoxshow");
		loadList(1);
	}
	
	
	var myScroll, pullDownEl, pullDownOffset, pullUpEl, pullUpOffset;
	
	function pullDownAction () {
		loadList(1, -1);
	}
	
	function pullUpAction () {
		loadList(2, 1);
	}
	
	function loaded() {
		pullDownEl = document.getElementById("pullDown");
		pullDownOffset = pullDownEl.offsetHeight;
		pullUpEl = document.getElementById("pullUp");	
		pullUpOffset = pullUpEl.offsetHeight;
		
		myScroll = new IScroll("#scroll-wrapper", {
			useTransform: false,
			useTransition: false,
			scrollbars: true,
			fadeScrollbars: true,
			topOffset: pullDownOffset,
			preventDefault: false
		});
		
		myScroll.on("refresh", function () {
			if (pullDownEl.className.match("loading") || pullDownEl.className.match("refresh_success")) {
				pullDownEl.className = "";
				pullDownEl.querySelector(".pullDownLabel-title").innerHTML = "下拉刷新";
			} else if (pullUpEl.className.match("loading") || pullUpEl.className.match("refresh_success")) {
				pullUpEl.className = "";
				pullUpEl.querySelector(".pullUpLabel").innerHTML = "上拉加载更多";
			}
		});
		
		myScroll.on("scrollMove", function () {
			if (this.y > 10 && !pullDownEl.className.match("flip")) {
				pullDownEl.className = "flip";
				pullDownEl.querySelector(".pullDownLabel-title").innerHTML = "释放立即刷新";
				this.minScrollY = 0;
			} else if (this.y < 10 && pullDownEl.className.match("flip")) {
				pullDownEl.className = "";
				pullDownEl.querySelector(".pullDownLabel-title").innerHTML = "下拉刷新";
				this.minScrollY = -pullDownOffset;
			} else if (this.y < (this.maxScrollY - 5) && !pullUpEl.className.match("flip")) {
				pullUpEl.style.display = "block";
				if (this.y < (this.maxScrollY - 40)) {
					pullUpEl.className = "flip";
					pullUpEl.querySelector(".pullUpLabel").innerHTML = "释放立即加载";
					this.maxScrollY = this.maxScrollY;
					myScroll.refresh();
				}
			} else if (this.y > (this.maxScrollY + 5) && pullUpEl.className.match("flip")) {
				/*
				pullUpEl.className = "";
				pullUpEl.querySelector(".pullUpLabel").innerHTML = "上拉加载更多";
				*/
			} else {
				if (this.y < -100)
					$(".goToTop").show();
				else
					$(".goToTop").hide();
			}
		});
		
		myScroll.on("scrollEnd", function () {
			if (pullDownEl.className.match("flip")) {
				pullDownEl.className = "loading";
				pullDownEl.querySelector(".pullDownLabel-title").innerHTML = "正在刷新...";
				pullDownAction();
			} else if (pullUpEl.className.match("flip")) {
				pullUpEl.className = "loading";
				pullUpEl.querySelector(".pullUpLabel").innerHTML = "正在加载...";
				pullUpAction();
			} else {
				pullUpEl.style.display = "none";
				myScroll.refresh();
			}
			
			if (this.y < -100)
				$(".goToTop").show();
			else
				$(".goToTop").hide();
		});
		
		pullUpEl.style.display = "none";
		myScroll.refresh();
		document.getElementById("scroll-wrapper").style.left = "0";
	}
	
	$(document).ready(function() {
		loadList(1,2);
		
		$(".searchImg").on("click", function() {
			loadList(1);
		});
		
		var module = 1;
		if (module == 1) {
			if (document.addEventListener)
				document.addEventListener("touchmove", function (e) { e.preventDefault(); }, false);
			else if (document.attachEvent)
				document.attachEvent("ontouchmove", function (e) { e.preventDefault(); });
			
			setTimeout(loaded, 600);
			
			// 回到页面顶部
			$(".goToTop").on("click", function() {
				myScroll.scrollTo(0, -50, 500);
				$(this).hide();
			});
		}
	});
	function showHrm(){
		top._BrowserWindow = window;
		$("#userChooseFrame")[0].contentWindow.resetBrowser({
			"fieldId" : "createid",
			"fieldSpanId" : "showCreater",
			"browserType" : "2",
			"selectedIds" : $("#createid").val()
		});
		$(document.body).addClass("hrmshow");
	}
	function onBrowserBack(){
		$(document.body).removeClass("hrmshow");
	}
	function onBrowserOk(result){
		var idValue = result["idValue"];
		var nameValue = result["nameValue"];
		$("#createid").val(idValue);
		$("#showCreater").html(nameValue);
		$(document.body).removeClass("hrmshow");
	};
</script>
</head>
<body>
	<div id="loading"></div>
	<div id="loadingmask"></div>
	
	<div id="webHeadContainer_top">
		<table class="webClientHeadContainer_top">
			<tbody>
				<tr>
					<td class="leftTD_top" width="20%">
						
					</td>
					<td class="centerTD_top" width="*">
						<div id="middleBtnName_top">
							<div id="middlePageName_top" style="display:inline-block;">查询流程</div>
						</div>
					</td>
					<td class="rightTD_top" width="20%">
						<a href="javascript:toggleSearchBox();" style="line-height: 40px; color: #FFF;">
							<i class="fa fa-search"></i>
						</a>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div id="searchBox" class="searchBox">
		<div class="weui_cells weui_cells_form">
			<div class="weui_cell">
                 <div class="weui_cell_hd">流程标题&nbsp;&nbsp;</div>
                 <div class="weui_cell_bd weui_cell_primary">
                     <input class="weui_input" id="keyword" placeholder="请输入流程标题"/>
                 </div>
            </div>
			<div class="weui_cell">
                 <div class="weui_cell_hd">发起人&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
                 <div class="weui_cell_bd weui_cell_primary">
                 	 <span id="showCreater"></span>
                     <a href="javascript:showHrm()">&nbsp;&nbsp;<i class="weui_icon_search"></i></a>
					 <input type="hidden" id="createid" value="" />
                 </div>
            </div>
			<div class="weui_cell">
                <div class="weui_cell_hd">创建日期从</div>
                <div class="weui_cell_bd weui_cell_primary">
                     <input class="weui_input" id="createdatestart" name="createdatestart" type="date" placeholder="请选择创建开始日期"/>
                </div>
            </div>
            <div class="weui_cell">
                <div class="weui_cell_hd">创建日期到</div>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" id="createdateend" name="createdateend" type="date" placeholder="请选择创建结束日期"/>
                </div>
            </div>
            <div class="weui_btn_area">
                <a class="weui_btn weui_btn_primary" href="javascript:doSearch();">查询</a>
            </div>
            </div>
	</div>
	
	<div id="scroll-wrapper">
		<div id="scroll-scroller">
			<div id="pullDown">
				<span class="pullDownIcon"></span>
				<div class="pullDownLabel">
					<div class="pullDownLabel-title">下拉刷新</div>
					<div class="pullDownLabel-time"></div>
				</div>
			</div>
			<table id="page">
				<tr>
					<td width="100%" height="100%" valign="top" align="left">
						<div class="list" id="list"></div>
						<div class="total-info"></div>
					</td>
				</tr>
			</table>
			
			<div id="pullUp">
				<span class="pullUpIcon"></span>
				<span class="pullUpLabel">上拉加载更多</span>
			</div>
		</div>
	</div>
	
	<div class="goToTop">
		<i class="fa fa-angle-up"></i>
	</div>
	
	<input type="hidden" id="module" name="module" value="1">
	<input type="hidden" id="pageindex" name="pageindex" value="1">
	<input type="hidden" id="pagesize" name="pagesize" value="10">
	<input type="hidden" id="ishavepre" name="ishavepre" value="">
	<input type="hidden" id="count" name="count" value="">
	<input type="hidden" id="pagecount" name="pagecount" value="10">
	<input type="hidden" id="ishavenext" name="ishavenext" value="">
	<input type="hidden" id="labelid" name="labelid" value="0">
	<div id="userChooseDiv">
		<iframe id="userChooseFrame" src="/mobile/plugin/plus/browser/hrmBrowser.jsp" frameborder="0" scrolling="auto">
		</iframe>
	</div>
</body>
</html>