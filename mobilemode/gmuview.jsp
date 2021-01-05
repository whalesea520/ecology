<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@page import="com.weaver.formmodel.ui.manager.*"%>
<%@page import="com.weaver.formmodel.ui.model.*"%>
<%@page import="com.weaver.formmodel.ui.base.*"%>
<%@page import="com.weaver.formmodel.ui.types.*"%>
<%@page import="com.weaver.formmodel.util.NumberHelper" %>
<%@page import="com.weaver.formmodel.ui.base.model.WebUIResouces" %>
<%@page import="weaver.hrm.*" %>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileAppModelManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppFormUI"%>
<%@page import="com.weaver.formmodel.mobile.model.MobileAppModelInfo"%>
<%
String uiid = StringHelper.null2String(request.getParameter("uiid"));
String billid = StringHelper.null2String(request.getParameter("billid"));
String clienttype = StringHelper.null2String(request.getParameter("clienttype"));
if(StringHelper.isEmpty(uiid)){
	request.getRequestDispatcher("/mobilemode/message.jsp?errorCode=1387").forward(request, response);
	return ;	
}

MobileAppUIManager mobileAppUIManager = MobileAppUIManager.getInstance();
MobileAppModelManager mobileAppModelManager = MobileAppModelManager.getInstance();
AppFormUI appFormUI = mobileAppUIManager.getById(Util.getIntValue(uiid));
int appid = appFormUI.getAppid();
int uitype = appFormUI.getUiType();
MobileAppModelInfo appmodel = mobileAppModelManager.getAppModelInfo(appFormUI.getEntityId());
int modelid = appmodel.getModelId();

User user = MobileUserInit.getUser(request,response);
WebUIContext uiContext = new WebUIContext();
uiContext.setClient(ClientType.CLIENT_TYPE_MOBILE);
uiContext.setBusinessid(billid);
uiContext.setModelid(modelid);
uiContext.setUIType(uitype);
uiContext.setAppid(appid);
uiContext.setCurrentUser(user);
uiContext.setAppFormUI(appFormUI);
uiContext.setRequest(request);
WebUIView uiview = WebUIManager.getInstance().getViewContent(uiContext);

List<WebUIResouces> uiresouces = uiview.getTabPageResources();
if(uiresouces.isEmpty()){
	return;
}else if(uiresouces.size() == 1){
	WebUIResouces uires = uiresouces.get(0);
	String resourceContent = uires.getResourceContent();
	request.getRequestDispatcher(resourceContent).forward(request, response);
	return;
}

%>
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
	<title><%=uiview.getUiTitle() %></title>
	
	<script type="text/javascript" src="/mobilemode/jqmobile4/js/jquery.min_wev8.js"></script>
	<link type="text/css" rel="stylesheet" href="/mobilemode/css/mobile_homepageexpand_wev8.css" />
	
</HEAD>
<body >
   
   <div id="nav" class="swiper-nav swiper-container">
		<ul class="swiper-wrapper">
	    <%
	  		for(int i = 0; i < uiresouces.size(); i++) {
	  			WebUIResouces uires = uiresouces.get(i);
	  			String defaultSelectedStr = (i == 0) ? "defaultSelected=\"true\"" : "";
		%>
				<li class="swiper-slide" href="#tabs-content-<%=i %>" <%=defaultSelectedStr %>><span><%=uires.getResourceName() %></span><div class="arrow"></div><div class="split"></div></li>
		<%	} %>
    	</ul>
		<div class="line"></div>
	</div>

	<div id="frameContainerWrap">
		<div id="loading">
			<div class="loadMask"></div>
			<div class="loadText"></div>
		</div>
		
		<%
	  		for(int i = 0; i < uiresouces.size(); i++) {
	  			WebUIResouces uires = uiresouces.get(i);
	  			String resourceContent = uires.getResourceContent();
				resourceContent += (resourceContent.indexOf("?") == -1 ? "?" : "&") + "isShowInTab=1";
		%>
				<iframe id="tabs-content-<%=i %>" class="tabFrame" frameborder="0" style="width: 100%;" scrolling="auto" lazy-src="<%=resourceContent %>">
				</iframe>
		<%	} %>
	</div>
	
<script type="text/javascript">
    
    $(function(){
    	$(".swiper-wrapper li").click(function(e){
			var that = this;
			if(!$(that).hasClass("selected")){
				$(that).siblings(".swiper-slide.selected").removeClass("selected");
				$(that).addClass("selected");
				
				var itemId = $(that).attr("href");
				$("#frameContainerWrap .tabFrame").addClass("hide");
				var $frame = $(itemId);
				var url = $frame.attr("lazy-src");
				$frame.removeClass("hide");
				$("#loading").show();
				if($frame.length != 0 && !$frame.attr("src")){
					$frame[0].src = url;
					$frame[0].onload = function(){
						$("#loading").hide();
						$frame.attr("lazy-src", "");
					};
				}else{
					$("#loading").hide();
				}
			}
		});
		$(".swiper-wrapper li[defaultSelected='true']").click();
	});
	
	function beforeIframeLoad(frame){
		$("#loading").show();
	}
	
	function whenIframeOnLoad(frame){
		$("#loading").hide();
		changeFrameHeight(frame);
	}
	
	function chooseLoadedIframe(frame){
		$("#loading").hide();
	}
	
	var bodyInitHeight = document.body.clientHeight;
	var frameContainerWrap = document.getElementById("frameContainerWrap");
	var frameContainerHeight = (bodyInitHeight-41);
	<% if(!clienttype.equalsIgnoreCase("iphone")){ %>
		/*iphone上不使用以下代码，这可能会导致iphone上无法使用tab页固定在头部的功能，
		但是如果固定frameContainer的高度会导致在iphone上只能显示这个高度的内容，并不能如预期的出现滚动条，这原本也违背了预期*/
		frameContainerWrap.style.height = frameContainerHeight + "px";
	<% } %>
    function changeFrameHeight(frame){
		var frameHieght=frame.contentWindow.document.body.scrollHeight;
		if((frameContainerHeight - 4) > frameHieght){
			frameHieght = (frameContainerHeight - 4);
		}
		frame.style.height=frameHieght+"px";
	}
    
    function changeFrameHeightByScrollHeight(){
    	var $tabFrame = $("iframe.tabFrame:visible");
    	if($tabFrame.length > 0){
    		var frame=$tabFrame[0];
			var frameHieght=frame.contentWindow.document.body.scrollHeight;
			frame.style.height=frameHieght+"px";
    	}
    }
    
    function cloneCurrFrameToRefresh(beCloneWindow){
    	if(typeof(top.lockPage) == "function"){
    		top.lockPage();
    	}
    	
    	var $selectedTab = $(".swiper-wrapper li.selected");
    	var h = $selectedTab.attr("href");
    	var $frameContainer = $(h);
    	
    	var $activeFrame = $frameContainer.children("iframe");
    	var url = $activeFrame.attr("src");
    	
    	var $cloneFrame = $("<iframe class=\"tabFrame beShowFrame\" frameborder=\"0\" scrolling=\"auto\" style=\"width: 100%;\"></iframe>");
		$frameContainer.append($cloneFrame);
		
		var cloneFrame = $cloneFrame[0];
		cloneFrame.onload = function(){
			beCloneWindow.pullDownEl.querySelector('.pullDownLabel').innerHTML = '刷新成功';
			beCloneWindow.pullDownEl.className = 'refresh_success';
			setTimeout(function () {
				beCloneWindow.myScroll.refresh();
				setTimeout(function () {
					if(typeof(top.releasePage) == "function"){
			    		top.releasePage();
			    	}
					
					$activeFrame.remove();
					
					changeFrameHeight(cloneFrame);
					
					$cloneFrame.removeClass("beShowFrame");
					
				}, 800);
			}, 800);
		}
		cloneFrame.src = url;
    }
    
    function getPageScrollTop(){
    	var t = $("#frameContainerWrap").scrollTop();
    	<% if(clienttype.equalsIgnoreCase("iphone")){ %>
    		if(top && typeof(top.getPageScrollTop) == "function"){
    			t = top.getPageScrollTop();
    			if(t <= 41){
    				t = 0;
    			}else{
    				t = t - 41;
    			}
    		}
    	<% } %>
		return t;
	}
</script>
</body>
</html>