<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.util.NumberHelper"%>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="java.util.List"%>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileAppModelManager"%>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="com.weaver.formmodel.ui.base.model.WebUIResouces" %>
<%@ page import="com.weaver.formmodel.ui.manager.WebUIManager"%>
<%@ page import="com.weaver.formmodel.mobile.model.MobileAppModelInfo"%>
<%
request.setCharacterEncoding("UTF-8");
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("服务器端重置了登录信息，请重新登录");
	return;
}
int appid = NumberHelper.string2Int(request.getParameter("appid"),0);
int modelid = NumberHelper.getIntegerValue(request.getParameter("modelid"), -1);
int uitype = NumberHelper.getIntegerValue(request.getParameter("uitype"), -1);
String billid = StringHelper.null2String(request.getParameter("billid"));

int appHomepageId = NumberHelper.getIntegerValue(request.getParameter("appHomepageId"), -1);
MobileAppModelInfo appmodel = MobileAppModelManager.getInstance().getAppModel(appid, modelid);
String clienttype = StringHelper.null2String(request.getParameter("clienttype"));

List<WebUIResouces> uiresouces = WebUIManager.getInstance().getAppHomepageResources(appmodel, uitype, billid, appHomepageId, 1, user);
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
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<title></title>
	<script src="/mobilemode/js/resource_cache_wev8.js" type="text/javascript"></script>
	<script>
		MResourceCache.pushNeedLoad("/mobilemode/js/zepto/zepto.min_wev8.js")
			.pushNeedLoad("/mobilemode/js/fastclick/fastclick.min_wev8.js")
			.pushNeedLoad("/mobilemode/css/mobile_homepageexpand_wev8.css?v=2017041901")
			.batchLoad().batchExec();
	</script>
	
</head>
<body >
   
   <div id="nav" class="swiper-nav swiper-container">
		<ul class="swiper-wrapper">
	    <%
	  		for(int i = 0; i < uiresouces.size(); i++) {
	  			WebUIResouces uires = uiresouces.get(i);
	  			String defaultSelectedStr = (i == 0) ? "defaultSelected=\"true\"" : "";
		%>
				<li class="swiper-slide" href="#tabs-content-<%=i %>" <%=defaultSelectedStr %>>
					<span><%=uires.getResourceName() %></span>
					<div class="arrow"></div>
					<div class="split"></div>
				</li>
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
				<iframe id="tabs-content-<%=i %>" class="tabFrame" frameborder="0" style="width: 100%;" scrolling="auto" lazy-src="<%=resourceContent %>&_t=<%=System.currentTimeMillis() %>">
							
				</iframe>
				
		<%	} %>
	</div>
	
<script type="text/javascript">
    $(function(){
		FastClick.attach(document.body);
		var _m = true;
		if(top && typeof(top.mobilecheck) == "function"){
			_m = top.mobilecheck();
		}
		var bCss = _m ? "mobile" : "pc";
		$(document.body).addClass(bCss);
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
				var src = $frame.attr("src") == undefined ? "" : "";
				if($frame.length != 0 && $frame.attr("src") == ""){
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
</script>
</body>
</html>