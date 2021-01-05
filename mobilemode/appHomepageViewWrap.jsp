<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="com.weaver.formmodel.mobile.utils.MobileCommonUtil"%>
<%@page import="com.weaver.formmodel.mobile.types.ClientType"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.util.List"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager"%>
<%@page import="com.weaver.formmodel.mobile.model.MobileAppBaseInfo"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobiledeviceManager"%>
<%@page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="net.sf.json.JSONObject"%>
<%
User user = MobileUserInit.getUser(request,response);
if(user == null){
	out.println("服务器端重置了登录信息，请重新登录");
	return;
}
int appid = NumberHelper.string2Int(request.getParameter("appid"), -1);
int appHomepageId = NumberHelper.string2Int(request.getParameter("appHomepageId"), -1);
String noLogin = StringHelper.null2String(request.getParameter("noLogin"));

ClientType clienttype = MobileCommonUtil.getClientType(request);
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";

String queryString = MobileCommonUtil.getFilterParameters(request, user);

String _preview = Util.null2String(request.getParameter("_preview"));
String _previewClass = _preview.trim().equals("") ? "" : "preview_" + _preview;

if(appid == -1){
	int mobiledeviceid = MobiledeviceManager.getInstance().getDeviceByClienttype(clienttype);
	AppHomepage appHomepage = MobileAppHomepageManager.getInstance().getAppHomepage(appHomepageId, mobiledeviceid);
	appid = appHomepage.getAppid();
}
MobileAppBaseInfo mobileAppBaseInfo = MobileAppBaseManager.getInstance().get(appid);

//处理移动端js中文字多语言
int languageid = user.getLanguage(); 
JSONObject multiLJson = new JSONObject();
multiLJson.put("383731", StringHelper.null2String(SystemEnv.getHtmlLabelName(383731, languageid)));//刷新成功
multiLJson.put("383740", StringHelper.null2String(SystemEnv.getHtmlLabelName(383740, languageid)));//参数设置不正确,请检查
multiLJson.put("383742", StringHelper.null2String(SystemEnv.getHtmlLabelName(383742, languageid)));//未找到id为
multiLJson.put("383743", StringHelper.null2String(SystemEnv.getHtmlLabelName(383743, languageid)));//的页面，请检查参数设置是否正确
multiLJson.put("383744", StringHelper.null2String(SystemEnv.getHtmlLabelName(383744, languageid)));//未在目标页面上找到刷新方法，请确认目标页面是否包含列表组件
multiLJson.put("31129", StringHelper.null2String(SystemEnv.getHtmlLabelName(31129, languageid)));//取消

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
<meta name="format-detection" content="telephone=no,email=no" />
<title><%=mobileAppBaseInfo.getAppname() %></title>
<script>
	var _clienttype = "<%=clienttype.toString()%>";
	var _appname = "";
	var _basepath = "<%=basePath%>";
	var _appid = "<%=appid%>";
	var _appHomepageId = "<%=appHomepageId%>";
	var _noLogin = "<%=noLogin%>";
	var _hasHeader = "";
	var _mobilemode_root_page = true;	//移动建模根页面
	var _queryString = "<%=queryString%>";
	var _multiLJson = <%=multiLJson.toString()%>;
</script>

<script src="/mobilemode/js/resource_cache_wev8.js?v=2016030701" type="text/javascript"></script>
<script>
	MResourceCache.pushNeedLoad("/mobilemode/js/zepto/zepto.min_wev8.js")
		.pushNeedLoad("/mobilemode/js/fastclick/fastclick.min_wev8.js")
		.pushNeedLoad("/mobilemode/css/mobile_homepagewrap_wev8.css?v=2018051801")
		.pushNeedLoad("/mobilemode/js/mobile_homepagewrap_wev8.js?v=2018051801")
		.batchLoad().batchExec();
</script>
</head>
<body class="<%=_previewClass%>">
<div id="main-container" class="main-container">
	<div id="page-view" class="page-view">	<!-- page-view start -->
		<div id="loading">
			<div class="loadMask"></div>
			<div class="loadText">
				<div class="spinner">
				  <div class="bounce1"></div>
				  <div class="bounce2"></div>
				  <div class="bounce3"></div>
				</div>
				<%=SystemEnv.getHtmlNoteName(4317,user.getLanguage())%><!-- 数据加载中，请等待... -->
			</div>
		</div>
		<div id="dialog"></div>
		
		<div id="webHeadContainer_top">
			<table class="webClientHeadContainer_top">
				<tr>
					<td class="leftTD_top" width="20%">
						<div id="leftButtonName_top" style="display:none;"><%=SystemEnv.getHtmlNoteName(4343,user.getLanguage())%></div><!-- 返回  -->
						<div id="leftButtonName_top_change" style="display:none;"><img src=""/></div>
					</td>
					<td class="centerTD_top" width="*">
						<div id="middleBtnName_top"><div id="middlePageName_top" style="display:inline-block;"></div></div>
					</td>
					<td class="rightTD_top" width="20%">
						<div id="rightBtnName_top" style="display:none;"><img src=""/></div>
					</td>
				</tr>
			</table>
		</div>
			
		<div id="st-container" class="st-container">
			<nav class="st-menu st-effect-1" id="st-menu_st-effect-1">
				<div class="st-loading"></div>
			</nav>
			
			<div class="st-pusher">
				
				<nav class="st-menu st-effect-2" id="st-menu_st-effect-2">
					<div class="st-loading"></div>
				</nav>
					
				<nav class="st-menu st-effect-3" id="st-menu_st-effect-3">
					<div class="st-loading"></div>
				</nav>
						
				<div id="mobileFrameContainer">
					<div id="mobileFrameLocker"></div>
					<iframe class="mobileFrame activeFrame blankFrame" frameborder="0" scrolling="auto">
					
					</iframe>
				</div>
			</div>
		</div>
		
		<div id="right-frame-container">
		</div>
	</div><!-- page-view end -->
</div>

<div id="dialogCoverContainer" class="dialogCoverContainer">
	<div class="dialogCoverMark"></div>
	<div class="dialogCoverWrap hide">
		<ul class="dialogCover"></ul>
	</div>
</div>
</body>
</html>