<!DOCTYPE html>
<%@page import="weaver.general.Util"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobiledeviceManager"%>
<%@page import="com.weaver.formmodel.mobile.types.ClientType"%>
<%@page import="com.weaver.formmodel.mobile.utils.MobileCommonUtil"%>
<%@page import="com.weaver.formmodel.mobile.model.MobileAppBaseInfo"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.filter.MultiLangFilter"%>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
int appid = NumberHelper.string2Int(request.getParameter("appid"),0);
int appHomepageId = NumberHelper.string2Int(request.getParameter("appHomepageId"), -1);
int uiid = NumberHelper.string2Int(request.getParameter("uiid"), -1);
ClientType clienttype = MobileCommonUtil.getClientType(request);
int mobiledeviceid = MobiledeviceManager.getInstance().getDeviceByClienttype(clienttype);
MobileAppHomepageManager mobileAppHomepageManager=MobileAppHomepageManager.getInstance();
AppHomepage appHomepage;

if(uiid != -1) {
	
}else if(appHomepageId == -1){
	appHomepage = mobileAppHomepageManager.getAppHomepageByAppid(appid, mobiledeviceid);
	appHomepageId = appHomepage.getId();
}else {
	appHomepage = mobileAppHomepageManager.getAppHomepage(appHomepageId, mobiledeviceid);
	appid = appHomepage.getAppid();
}
MobileAppBaseManager mobileAppBaseManager = MobileAppBaseManager.getInstance();
MobileAppBaseInfo mobileAppBaseInfo = mobileAppBaseManager.get(appid);
MobileAppUIManager mobileAppUIManager=MobileAppUIManager.getInstance();
JSONArray jsonArray=mobileAppUIManager.getFormUiTree(appid);
for(int i = jsonArray.size() - 1; i >= 0; i--){
	JSONObject jsonObj = (JSONObject)jsonArray.get(i);
	String iconSkin = Util.null2String(jsonObj.get("iconSkin"));
	if(iconSkin.equals("diy03") || iconSkin.equals("diy05")){
		jsonArray.remove(i);
	}
}
jsonArray = JSONArray.fromObject(new MultiLangFilter().processBody(jsonArray.toString(), user.getLanguage()+""));

String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
String desc = Util.null2String(mobileAppBaseInfo.getDescriptions());
String nodesc = SystemEnv.getHtmlLabelName(127449,user.getLanguage());
%>
<html lang="zh">

	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width,height=device-height,inital-scale=1.0,maximum-scale=1.0,user-scalable=1;">
		<link href="./js/colorpick/css/colpick_wev8.css" type="text/css"
			rel="stylesheet">
		<link href="./css/preview_wev8.css" type="text/css" rel="stylesheet" />
	</head>

	<body>
		<div class="left-menu no-active">
			<div class="top">
				<div class="project-title">
					<img class="item-image" src="<%=mobileAppBaseInfo.getPicpath() %>" />
					<span class="project-name"><%=mobileAppBaseInfo.getAppname() %></span>
					<span class="project-description"><%=desc.equals("") ? nodesc : desc %></span>
				</div>
				<div class="options">
					<label for="wrapper_type">
						<%=SystemEnv.getHtmlLabelName(1025,user.getLanguage())%>
					</label>
					<select id="wrapper_type">
						<option value="iphone5">
							iPhone 5
						</option>
						<option value="iphone6" selected>
							iPhone 6
						</option>
						<option value="iphone6p">
							iPhone 6p
						</option>
						<option value="Galaxy S5">
							Galaxy S5
						</option>
						<option value="ipad2">
							ipad 2
						</option>
						<option value="none">
							none
						</option>
					</select>
					<div class="color-picker">
						<div class="color-list">
							<span> </span>
							<span> </span>
							<span> </span>
							<span> </span>
							<span> </span>
							<span> </span>
						</div>
						<div id="colorBox">
							<span></span>
						</div>
					</div>
				</div>
				<div class="platform">
					<label>
						<%=SystemEnv.getHtmlLabelName(128647,user.getLanguage())%>
					</label>
					<a id="e-mobile" href="javascript:void(0)"><span></span>E-Mobile</a>
					<a id="wechat" href="javascript:void(0)"><span></span><%=SystemEnv.getHtmlLabelName(32638,user.getLanguage())%></a>
					<a id="dingding" href="javascript:void(0)"><span></span><%=SystemEnv.getHtmlLabelName(128649,user.getLanguage())%></a>
					<a id="browser" href="javascript:void(0)"><span></span><%=SystemEnv.getHtmlLabelName(128650,user.getLanguage())%></a>
				</div>
				<div id="qr">
					<label>
						<%=SystemEnv.getHtmlLabelName(128648,user.getLanguage()) %>
					</label>
				</div>
			</div>
			<div class="toggle-bar">
				<div class="split-bar">
				</div>
			</div>
			<div class="customer-page">
				<ul>
					<li id="page_title">
						<%=SystemEnv.getHtmlLabelName(22967,user.getLanguage()) %>
						<span></span>
					</li>
					<li class="page-list">
						<ul id="pages" class="ztree">
						</ul>
					</li>
				</ul>

			</div>
		</div>
		<div class="container no-active">
			<div class="scale">
				<ul>
					<li class="plus">+</li>
					<li class="minus"></li>
					<li class="default" title='100%'>100%</li>
				</ul>
				<ul>
					<li class="refresh"></li>
				</ul>
			</div>
			<div id="wrapper" class="phone" data-scale="1">
				<span class="border"></span>
				<div class="header">
					<span class="camera"></span>
					<!-- 传感器 -->
					<span class="sensor"></span>
					<span class="sensor2"></span>
					<span class="speaker"></span>
				</div>
				<div class="top-bar"></div>
				<div class="bottom-bar"></div>
				<div class="buttons power-button"></div>
				<div class="buttons voice-toogle"></div>
				<div class="buttons voice-plus"></div>
				<div class="buttons voice-minus"></div>

				<div class="screen">
					<div class="headline e-mobile">
						<div class="headline-time"></div>
						<div class="net"></div>
						<span class="operators">中国移动</span>
						<div class="electricity">
							80%
						</div>
						<div class="battery"></div>
					</div>
					<div class="url-field">
						<input id="input-url" type="text"/>
						<span id="btn-refresh"></span>
					</div>
                    <iframe id="mobile_content"></iframe>
                    <div class="loading">
						<div></div>
					</div>
				</div>
				<div class="home-button">
					<span></span>
				</div>
			</div>
		</div>
		<script src="./js/ueditor/third-party/jquery-1.10.2.min_wev8.js"
			type="text/javascript">
</script>
		<script src="./js/qrcode/jquery.qrcode.min_wev8.js"
			type="text/javascript">
</script>
		<script src="../js/hrm/ztree/js/jquery.ztree.core-3.5.min_wev8.js"
			type="text/javascript">
</script>
		<script src="../js/nicescroll/jquery.nicescroll.min_wev8.js"
			type="text/javascript">
</script>
		<script src="./js/colorpick/colpick_wev8.js" type="text/javascript">
</script>
		<script type="text/javascript">
		var platformV = null;
(function() {
	var originHeight = document.body.scrollHeight, settings = {
		view : {
			dblClickExpand : false,
			showIcon : true,
			nameIsHTML: true
		},
		data : {
			simpleData : {
				enable : true
			}
		},
		callback : {
			onClick : function(e, treeId, treeNode) {
				$.fn.zTree.getZTreeObj(treeId).expandNode(treeNode);
			}
		}
	}, zNodes = <%=jsonArray.toString()%>,
	location = window.location;

	initPageAction();

	function qrCode(url){
		$("#qr").find("canvas").remove();
		$("#qr").qrcode(url);
	}
	
	/* 浏览器地址栏 效果 */
	$("#input-url").off("focus.url")
		.on("focus.url", function() {
			var that = $(this);
			
			that.val( formatUrl( that.data("url") ) );
			$("#btn-refresh").hide();
		}).off("focusout.url").on("focusout.url", function() {
			var that = $(this),
				url = formatUrl( that.data("url"), true, true ),
				index = url.indexOf('/');
			
			that.val( index != -1 ? url.substring(0, index ) : url );
			$("#btn-refresh").show();
		}).off("keyup.url").on("keyup.url", function(e) {
			var that = $(this);
			
			if(e.keyCode == 13) {
				that.data("url", that.val());
				$("#mobile_content").attr("src", that.val());
				that.val( formatUrl(that.val(), true, true) );
			}
		}).val( formatUrl(location.host, true) ).data("url", location.href);
	
	$(".url-field").off("click.refresh", "span").on("click.refresh", "span", function() {
		var iframe = $("#mobile_content");
		iframe.attr("src", iframe.attr("src"));
	});
	
	function formatUrl(url, isRemove3W, isRemoveProtocol) {
		if(!url) return;
		
		if(isRemove3W) {
			url = url.replace("www.", "");
		}
		
		if(isRemoveProtocol) {
			url = url.replace(/^http:\/\/|https:\/\//g, "");
		}
		
		return url;
	}

	/*
	 ** 使用jquery niceScroll为页面列表的添加滚动条
	 */
	$("#pages").off("click.resize").on("click.resize", function() {
		$(this).getNiceScroll().resize();
	}).off("mouseover.resize", ".level0").on("mouseover.resize", ".level0",
			function() {
				$("#pages").getNiceScroll().resize();
			}).niceScroll( {
		cursorcolor : 'rgb(170, 170, 170)',
		cursorwidth : '3px'
	});

	/* wrapper change */
	$("#wrapper_type").off("change.type").on("change.type", function() {
		var className = this.value.replace(" ", "_"),
			iframe = $('#mobile_content');

		$(document.body).attr("class", className);
		setPreviewConfig( {
			"wrapperType" : this.value
		});
		setTimeout(function() {
			iframe.attr('src', iframe.attr('src').replace(/_preview=.*/, '_preview='+ platformV));
		},0);
	});

	/* background color change function */
	$(".color-picker").off("click.colorChange", "span")
		.on("click.colorChange", "span", function() {
				var ele = $(this), 
					bgColor = ele.css("background-color");

				ele.data("color", bgColor).addClass("active").siblings()
						.removeClass("active");
				$(document.body).css("background", bgColor);
				$("#colorBox").css("background", bgColor);
				setPreviewConfig( {
					"bgColor" : bgColor,
					"bgIndex" : ele.prevAll().length
				});
			});

	/* color box */
	$("#colorBox").colpick( {
		colorScheme : 'dark',
		onChange : function(hsb, hex) {
			$("#colorBox").css("background", "#" + hex);
		},
		onSubmit : function(hsb, hex) {
			hex = '#' + hex;
			$("#colorBox").css("background-color", hex);
			$(".color-picker span").removeClass("active");
			$(document.body).css("background-color", hex);
			setPreviewConfig( {
				"bgColor" : hex,
				"bgIndex" : -1
			});
		}
	}).off("keyup.color").on("keyup.color", function() {
		$(this).colpickSetColor(this.value);
	});

	/* scale function */
	$(".scale").off("click.scale", "li")
		.on("click.scale", "li", function() {
			var phone = $(".phone"), 
				leftMenu = $(".left-menu"),
				scale = parseFloat(phone.data("scale") || 1),
				iframe = $('#mobile_content'),
				type = $(this).attr('class');

			switch (type) {
				case 'plus':
					scale += 0.2;
					break;
				case 'minus':
					scale = scale - 0.2;
					scale = scale < 0.2 ? 0.2 : scale;
					break;
				case 'refresh':
					$('.loading').show();
					iframe.attr('src', iframe.attr('src').replace(/_preview=.*/, '_preview='+ platformV));
				default:
					scale = 1;
					break;
				}

			phone.data("scale", scale).css("transform", 'scale(' + scale + ',' + scale + ')');
			leftMenu.height(scale <= 1 ? leftMenu.data("height") : document.body.scrollHeight);
			setPreviewConfig( {"scale" : scale});
		});

	/* 
	 ** 当页面缩小到手机壳边距，自动收缩左边菜单栏 
	 */
	$(window).off('resize.toggle')
		.on("resize.toggle", function() {
			toggleForResize();
		});
	
	function toggleForResize(callback) {
		var isMobile = navigator.userAgent.match(/Android|iPhone|Mobile/),
			isActive = $('.left-menu').hasClass('active'),
			bar = $('.toggle-bar'), left, wrapper;
		
		if(callback) {
			return setTimeout(function() {
				callback();
			}, 200);
		}
		
		if(isMobile) {
			document.body.style.visibility =  'hidden';
			location.href = 'preview2.jsp?appHomepageId=<%=appHomepageId %>';
		} else {
			wrapper = $("#wrapper"); 
			left =  350 + wrapper.outerWidth(true); //wrapper.offset().left = 350
			if(bar.data('toggle')) {
				return; // 忽视手动点击的收缩
			}
			
			if(document.body.offsetWidth < left && !isActive ) {
				return toggleBar(); // 收起
			}
			
			if(document.body.offsetWidth > left && isActive) {
				toggleBar(); //弹出		
			}
		}
	}
	
	/*split bar*/
	$(".toggle-bar").off("click.toggle").on("click.toggle", function() {
				var bar = $(this);
					isShrink = $('.left-menu').hasClass("active"),
					pageScroll = $("#pages").getNiceScroll();

				toggleBar();
				
				pageScroll.hide();
				isShrink && pageScroll.show(); 
				bar.data("toggle", !isShrink);
			});
	
	function toggleBar () {
		var animateArr = [ $(".left-menu"), $(".container")];
		
		
		animateArr.forEach(function(ele) {
			ele.toggleClass("active").toggleClass("no-active");
		});
	}
	
	$("#mobile_content").load(function() {
		$(".loading").hide();
	});

	/*headline for different platform*/
	$(".platform").off("click.platform", "a").on("click.platform", "a",
			function() {
				var that = $(this);
			$(".platform a").removeClass();
			that.toggleClass("checked");
			$(".headline").removeClass()
					.addClass((this.id || "") + " headline");
			platformV = this.id;
			
			try{
				var frameBody = $("#mobile_content")[0].contentWindow.document.body;
				for(var i = 0; i < frameBody.classList.length; i++){
					var className = frameBody.classList.item(i);
					if(className.indexOf("preview_") == 0){
						frameBody.classList.remove(className);
					}
				}
				frameBody.classList.add("preview_" + platformV);
			}catch(e){console.log(e);}
			
			setPreviewConfig( {
				"platform" : platformV
			});
		});
	
	/*点击页面头部，页面将向上滑动*/
	$("#page_title").off("click.moveToTop")
		.on("click.moveToTop", function() {
			$('.customer-page').toggleClass("active");
			setTimeout(function() {
				$("#pages").getNiceScroll().resize(); //300ms动画结束后, 重置滚动条	
			},300);
		});
	
	window.initMobileContent = function(url) {
		$(".loading").show();
		$("#mobile_content").attr("src", url);
	};
	
	window.openHomepage = function(id){
		var baseUrl = "/mobilemode/appHomepageViewWrap.jsp?appHomepageId=" + id;
		var url = baseUrl + "&_preview="+platformV;
		var qrUrl = "<%=basePath%>" + baseUrl + "&noLogin=1";
		qrCode(qrUrl);
		initMobileContent(url);
	};
	
	window.openAppUi = function(id,entityid) {
		var baseUrl = "/mobilemode/formbaseview.jsp?uiid=" + id;
		var url = baseUrl + "&_preview="+platformV;
		var qrUrl = "<%=basePath%>" + baseUrl + "&noLogin=1";
		qrCode(qrUrl);
		initMobileContent(url);
	};
	
	/*private method*/
	function initPageAction() {
		initLeftMenuHeight();
		showHeadlineTime();
		initPreviewConfig();
	}

	/* 初始化左边菜单栏的高度 */
	function initLeftMenuHeight() {
		$(".left-menu").css("height", originHeight)
				.data("height", originHeight);
	}

	/*
	 ** 设置当前时间显示格式
	 ** 格式如: 上午10:02
	 */
	function setCurrentTimeForHeadline() {
		var date = new Date(),
			hours = date.getHours(), 
			minutes = date.getMinutes().toString(), 
			timeArea = hours < 12 ? '上午 ' : '下午 ';
		
		hours = hours <= 12 ? hours : Math.abs(hours - 12);
		$(".headline-time").text(
				timeArea + hours + ":" + minutes.replace(/^(\d{1}$)/g, "0$1"));
	}

	/*
	 ** 动态显示手机头部时间
	 ** 刷新频率为1分钟
	 */
	function showHeadlineTime() {
		setCurrentTimeForHeadline();
		setInterval(function() {
			setCurrentTimeForHeadline();
		}, 1000 * 60);
	}

	function initPreviewConfig() {
		var body = $(document.body), 
			wrapperType = $("#wrapper_type"), 
			config = JSON.parse(getPreviewConfig()) || {
					wrapperType : wrapperType.val(),
					bgColor : body.css("background-color"),
					platform : "e-mobile",
					bgIndex : 4,
					scale : "1"
				}, 
			type = config.wrapperType,
			bgColor = config.bgColor, 
			bgIndex = config.bgIndex,
			platform = config.platform, 
			scale = config.scale;

		if (bgIndex != -1) {
			$(".color-list").find("span").eq(bgIndex).addClass("active");
		} 
		
		wrapperType.val(type);
		$("#colorBox").css("background-color", bgColor);
		body.attr("class", type.replace(" ", "_")).css("background-color", bgColor);
		$(".platform span").removeClass();
		platformV = platform;
		$('#' + platform).toggleClass("checked");
		$(".headline").attr("class", platform + " headline");
		$(".phone").data("scale", scale).css("transform",
				'scale(' + scale + ',' + scale + ')');
		setPreviewConfig(config);
	}

	function setPreviewConfig(config) {
		var previewConfig = JSON.parse(getPreviewConfig()) || {};

		previewConfig = JSON.stringify($.extend(previewConfig, config));

		return sessionStorage
				&& sessionStorage.setItem("PreviewConfig", previewConfig);
	}

	function getPreviewConfig() {
		return sessionStorage && sessionStorage.getItem("PreviewConfig");
	}
	
	
	/*mock page list*/
	$.fn.zTree.init($("#pages"), settings, zNodes);
	var treeObj = $.fn.zTree.getZTreeObj("pages");
	treeObj.expandAll(true);	//展开全部
	var uiid = <%=uiid%>,
		selectedId = uiid != -1 ? uiid : "S<%=appHomepageId%>",
		selectedNode = treeObj.getNodeByParam("id", selectedId, null);
	treeObj.selectNode(selectedNode, true, true);
	treeObj.setting.callback.onClick(null, treeObj.setting.treeId, selectedNode);//调用事件 
	toggleForResize(function() {
		if(uiid != -1) {
			return openAppUi(uiid);
		}
		
		openHomepage("<%=appHomepageId%>");
	});
})()
</script>
	</body>

</html>

