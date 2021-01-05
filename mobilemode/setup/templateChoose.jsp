<%@page import="com.weaver.formmodel.mobile.template.Template"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.mobile.template.TemplateManager"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
if(!HrmUserVarify.checkUserRight("MobileModeSet:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String id = Util.null2String(request.getParameter("id"));
String appHomepageId = Util.null2String(request.getParameter("appHomepageId"));
String type = Util.null2String(request.getParameter("type"));
String beOverride = Util.null2String(request.getParameter("beOverride"));

TemplateManager templateManager = new TemplateManager();
List<Template> tmpList = templateManager.getAllTemplate();
List<String> cList = templateManager.getCategory(tmpList);
Map<String, String> c2Map = templateManager.getCategory2Ref(tmpList);

%>
<!DOCTYPE HTML>
<head>
<title><%=SystemEnv.getHtmlLabelName(127365,user.getLanguage())%></title> <!-- 存为模板 -->
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
.div_bottom{
	position: absolute;
	left:0px;
	bottom: 0px;
	height: 45px;
	width: 100%;
	background-color: #FAFAFA;
	border-top: 1px solid #e6e6e6;
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
	background-color: transparent;
}
.div_bottom button:HOVER {
	background-color: #2690e3;
	color: #fff;
}
.div_bottom button.disabled{
	color: #aaa;	
}
.div_bottom button.disabled:HOVER {
	background-color: #eee;
}

.template-container{
	position: absolute;
	top: 92px;
	left: 0px;
	bottom: 46px;
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
	cursor: pointer;
}
.tmp-card.active {
	border: 1px solid #2690e3;
	outline: 1px solid #2690e3;
}
.tmp-card.active:before {
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
.tmp-card.active:after {
	content: "<%=SystemEnv.getHtmlLabelName(128206,user.getLanguage())%>";
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
.tmp-card.unMatch{
	display: none !important;
}
.tmp-card .tmp-content{
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
</style>
<script type="text/javascript">

function showLoading(){
	$("#s_loading").show();
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

function initWithTmp(id){
	var $saveBtn = $("#okBtn");
	$saveBtn.addClass("disabled");
	showLoading();
	var url = jionActionUrl("com.weaver.formmodel.mobile.template.TemplateAction", "action=initWithTmp&appHomepageId=<%=appHomepageId%>");
	FormmodeUtil.doAjaxDataSave(url, {"id" : id}, function(result){
		hideLoading();
		var status = result["status"];
		if(status == "1"){
			top.closeTopDialog();
		}else{
			var message = result["message"];
			showMsg("<%=SystemEnv.getHtmlLabelName(127507,user.getLanguage())%>" + message, "error", 10000); //使用模板时出现错误：
		}
	});
}

function onOk(){
	if($("#okBtn").hasClass("disabled")){
		return;
	}
	
	var id = "";
	var $card = $(".template-container .tmp-card.active");
	if($card.length > 0){
		id = $card.attr("data-id");
	}
	if(id == ""){
		alert("<%=SystemEnv.getHtmlLabelName(127508,user.getLanguage())%>"); //请选择一个模板
	}else{
		if("<%=type%>" == "1"){
			if("<%=beOverride%>" == "1"){
				if(confirm("<%=SystemEnv.getHtmlLabelName(127509,user.getLanguage())%>")){  //选择的模板内容会覆盖掉当前页面的内容，确定继续吗？
					initWithTmp(id);
				}
			}else{
				initWithTmp(id);
			}
		}else if("<%=type%>" == "2"){
			var name = $(".head h2", $card).text();
			var result = {"id": id, "name": name};
			top.closeTopDialog(result);
		}
	}
}

function titleWidthResize(){
	var windowWidth = $(window).width();
	var title1MaxWidth = windowWidth - 220;
	var title1Width = $(".small").width();
	var title2MaxWidth = windowWidth - 60;
	var title2Width = 0;
	var activeTitle = $(".small ul li.active").text();
	var $tabs = $(".title2 ul li[data-ref*='"+activeTitle+"']");
	if(activeTitle == "<%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%>"){  //全部
		$tabs = $(".title2 ul li");
	}else{
		title2Width = 40;
	}
	$tabs.each(function(){
		title2Width += $(this).width();
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
	
	$(".template-container .tmp-card").click(function(){
		$(this).siblings(".tmp-card").removeClass("active");
		$(this).toggleClass("active");
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
			if(activeTitle == "<%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%>"){   //全部
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
        
        if(activeTitle == "<%=SystemEnv.getHtmlLabelName(126831,user.getLanguage())%>"){ //全部
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
});
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
			<div class="big"><%=SystemEnv.getHtmlLabelName(18167,user.getLanguage())%><!-- 模板选择 --></div>
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
		
		<div id="aaa"></div>
		<div class="searchWrap">
			<input type="text" id="searchKey" placeholder="<%=SystemEnv.getHtmlLabelName(127510,user.getLanguage())%>"/><!-- 检索模板 -->
			<div class="searchBtn"></div>
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
			String cn = "";
			if(id.equals(tmp.getId())){
				cn = " active";
			}
		%>
		<div class="tmp-card card-view<%=cn %>" id="tmp-card-<%=Util.null2String(tmp.getId())%>" data-id="<%=Util.null2String(tmp.getId())%>" data-category="<%=Util.null2String(tmp.getCategory())%>" data-category2="<%=Util.null2String(tmp.getCategory2())%>">
			<div class="tmp-content">
				<div class="card-view-panel">
					<img src="<%=previewImg%>">
					<div class="head">
						<h2><%=Util.null2String(tmp.getName())%></h2>
						<div class="crdate"><%=SystemEnv.getHtmlLabelName(127511,user.getLanguage())%><!-- 创建于 --><%=Util.null2String(tmp.getCreateDate())%></div>
					</div>
				</div>
			</div>
		</div>
		<% } %>
	</div>
	
	<div class="div_bottom">
		<button type="button" id="okBtn" onclick="onOk()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
	</div>
</body>
</html>
