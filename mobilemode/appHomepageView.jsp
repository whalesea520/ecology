<!DOCTYPE html>
<%@page import="com.weaver.formmodel.mobile.security.SecurityUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.util.NumberHelper"%>
<%@ page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%@ page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@ page import="com.weaver.formmodel.mobile.mec.MECManager"%>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="com.weaver.formmodel.mobile.ui.manager.MobiledeviceManager"%>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="com.weaver.formmodel.mobile.utils.MobileCommonUtil"%>
<%@ page import="com.weaver.formmodel.mobile.types.ClientType"%>
<%@ page import="com.weaver.formmodel.mobile.plugin.Resource"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="com.weaver.formmodel.mobile.skin.SkinManager"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%
request.setCharacterEncoding("UTF-8");
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("服务器端重置了登录信息，请重新登录");
	return;
}
int appid = NumberHelper.string2Int(request.getParameter("appid"),0);
int appHomepageId = NumberHelper.string2Int(request.getParameter("appHomepageId"), -1);
//String clienttype = StringHelper.null2String(request.getParameter("clienttype"));	//当前访问客户端类型 可能的值：Webclient|iphone|ipad|Android
ClientType clienttype = MobileCommonUtil.getClientType(request);
boolean isOpenedOnTopfloor = StringHelper.null2String(request.getParameter("isOpenedOnTopfloor")).trim().equals("1");	//标识该自定义页面是否为顶层打开的
int isShowInTabV = NumberHelper.string2Int(request.getParameter("isShowInTab"), 0); //是否为Tab页布局

int mobiledeviceid = MobiledeviceManager.getInstance().getDeviceByClienttype(clienttype);
MobileAppHomepageManager mobileAppHomepageManager=MobileAppHomepageManager.getInstance();
AppHomepage appHomepage;
if(appHomepageId == -1){
	appHomepage = mobileAppHomepageManager.getAppHomepageByAppid(appid, mobiledeviceid);
}else{
	appHomepage = mobileAppHomepageManager.getAppHomepage(appHomepageId, mobiledeviceid);
}

if(appHomepage.getId() == null){
	request.getRequestDispatcher("/mobilemode/message.jsp?errorCode=1387").forward(request, response);
	return;
}

appHomepageId = appHomepage.getId();
appid = appHomepage.getAppid();

//明细表数据排序要用到layoutid
request.setAttribute("layoutid", appHomepage.getLayoutid());

//布局页面权限判断
int modelid = -1;
if(appHomepage.getModelid() != null){
	modelid = appHomepage.getModelid().intValue();
}
String billid = StringHelper.null2String(request.getParameter("billid"));
int uitype = NumberHelper.string2Int(appHomepage.getUitype());
if(uitype != -1 && modelid != -1){
	int sourceid = Util.getIntValue(appHomepage.getSourceid());
	if(!mobileAppHomepageManager.hasAppHomepageRight(uitype, modelid, billid, sourceid, request, response)){
		request.getRequestDispatcher("/mobilemode/message.jsp?errorCode=1389").forward(request, response);
		return;
	}
	//页面拓展
	request.setAttribute("appid", appid);
	request.setAttribute("modelid", modelid);
	request.setAttribute("appHomepageId", appHomepageId);
}

String pageAttr=(StringHelper.null2String(appHomepage.getPageAttr()).equals(""))?"{}":appHomepage.getPageAttr();
JSONObject pageAttrJson = JSONObject.fromObject(Util.null2String(pageAttr));
boolean disableDownRefresh = Util.getIntValue(Util.null2String(pageAttrJson.get("isDownRefresh"))) != 1;
boolean isDisabledSkin = Util.null2String(pageAttrJson.get("isDisabledSkin")).equals("1");
String onloadScript = (String)pageAttrJson.get("onloadScript");
onloadScript = SecurityUtil.encryptKeyCode(onloadScript);

String skinCssPath = "";
if(!isDisabledSkin){
	SkinManager skinManager = new SkinManager();
	skinCssPath = skinManager.getSkinCssPathWithApp(appid);
}
		
String pageContent = StringHelper.null2String(appHomepage.getPageContent());
Map<String, Object> paramMap = new HashMap<String, Object>();
paramMap.put("appid", appid);
paramMap.put("pageContent", pageContent);
paramMap.put("request", request);
paramMap.put("response", response);
Map<String, Object> resultMap = MECManager.parseUIContent(paramMap);

pageContent = (String)resultMap.get("pageContent");
List<Resource> refResources = (List<Resource>)resultMap.get("refResources");

//处理移动端js中文字多语言
int languageid = user.getLanguage(); 
JSONObject multiLJson = new JSONObject();
multiLJson.put("4971", StringHelper.null2String(SystemEnv.getHtmlNoteName(4971, languageid)));//下拉刷新
multiLJson.put("4986", StringHelper.null2String(SystemEnv.getHtmlNoteName(4986, languageid)));//释放立即刷新
multiLJson.put("4987", StringHelper.null2String(SystemEnv.getHtmlNoteName(4987, languageid)));//正在刷新...
multiLJson.put("383802", StringHelper.null2String(SystemEnv.getHtmlLabelName(383802, languageid)));//用户拒绝了获取地理位置的请求。
multiLJson.put("383803", StringHelper.null2String(SystemEnv.getHtmlLabelName(383803, languageid)));//位置信息是不可用的。
multiLJson.put("383804", StringHelper.null2String(SystemEnv.getHtmlLabelName(383804, languageid)));//请求用户地理位置超时。
multiLJson.put("129710", StringHelper.null2String(SystemEnv.getHtmlLabelName(129710, languageid)));//未知错误
multiLJson.put("383751", StringHelper.null2String(SystemEnv.getHtmlLabelName(383751, languageid)));//定位失败
multiLJson.put("383805", StringHelper.null2String(SystemEnv.getHtmlLabelName(383805, languageid)));//响应码
multiLJson.put("383806", StringHelper.null2String(SystemEnv.getHtmlLabelName(383806, languageid)));//保存图片
multiLJson.put("130277", StringHelper.null2String(SystemEnv.getHtmlLabelName(130277, languageid)));//查看
multiLJson.put("31129", StringHelper.null2String(SystemEnv.getHtmlLabelName(31129, languageid)));//取消
multiLJson.put("83446", StringHelper.null2String(SystemEnv.getHtmlLabelName(83446, languageid)));//确定
multiLJson.put("16631", StringHelper.null2String(SystemEnv.getHtmlLabelName(16631, languageid)));//确认
multiLJson.put("383807", StringHelper.null2String(SystemEnv.getHtmlLabelName(383807, languageid)));//呼叫
multiLJson.put("125977", StringHelper.null2String(SystemEnv.getHtmlLabelName(125977, languageid)));//发送短信
multiLJson.put("383808", StringHelper.null2String(SystemEnv.getHtmlLabelName(383808, languageid)));//发送提醒成功

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<title><%=appHomepage.getPagename() %></title>
<script src="/mobilemode/js/resource_cache_wev8.js?v=2017080201" type="text/javascript"></script>
<script>
	MResourceCache.pushNeedLoad("/mobilemode/js/zepto/zepto.min_wev8.js")
		.pushNeedLoad("/mobilemode/js/fastclick/fastclick.min_wev8.js")
		.pushNeedLoad("/mobilemode/css/mobile_homepage_wev8.css?v=2017042702")
		.pushNeedLoad("/mobilemode/js/mobile_homepage_wev8.js?v=2018050901")
		<%if(!disableDownRefresh){%>
		.pushNeedLoad("/mobilemode/css/iScroll_wev8.css")
		.pushNeedLoad("/mobilemode/js/iscroll/iscroll5_wev8.js")
		.pushNeedLoad("/mobilemode/js/iscroll/iScrollHandler_wev8.js?v=2018050901")
		<%}%>
		<%for(Resource r : refResources){%>
		.pushNeedLoad("<%=r.getPath()%>")
		<%}%>
		<%if(!skinCssPath.trim().equals("")){%>
		.pushNeedLoad("<%=skinCssPath%>")
		<%}%>
		.pushNeedLoad("/mobilemode/js/lazyload/jquery.lazyload.min_wev8.js")
		.pushNeedLoad("/mobilemode/js/hammer/hammer.min_wev8.js")
		.batchLoad().batchExec();
</script>

<script type="text/javascript">
var E3005CF26D9F9AC78773E16572827297 = "<%=(user == null) ? "" : user.getUID()%>";
var pageIdentifier = {type : "1", id : "<%=appHomepageId%>"};
var isBeScrolling = false;
var disableDownRefresh = <%=disableDownRefresh%>;
var isOpenedOnTopfloor = <%=isOpenedOnTopfloor%>;
var appid = <%=appid%>;
var isShowInTabV = <%=isShowInTabV%>;

var _multiLViewJson = <%=multiLJson.toString()%>;
$(document).ready(function(){
	FastClick.attach(document.body);
	
	Mobile_NS.groupViewImg();
	
	Mobile_NS.listenPageChange(Mobile_NS.groupViewImg);
	
	Mobile_NS.pressImgForSave();
	
	Mobile_NS.listenPageChange(Mobile_NS.pressImgForSave);
	
	var bCss = Mobile_NS.isRunInMobile() ? "mobile" : "pc";
	$(document.body).addClass(bCss);
	
	//Mobile_NS.imgLazyload();
	$("img.lazy").not(".horiListContainer img.lazy").lazyload({
		container : "#scroll_wrapper",
		failurelimit : 10
	});
	
	try {
	   <%=onloadScript%>
	} catch (e) {
	    console.error(e);
	}
	//解决标签页控件在ios下不能滑动的问题
	var wrapperHeight = $("#scroll_wrapper").height();
	var scrollHeight = $("#scroll_scroller").height();
	if($(".tabBarContainer").length > 0 && scrollHeight < wrapperHeight && _top && typeof(_top.isIOS) == "function" && _top.isIOS()){
		$("#scroll_scroller").css("height", wrapperHeight+1);
	}
});
</script>
</head>
<body>
<input type="hidden" id="appid" value="<%=appid %>"/>
<div id="page_view">
	<div id="center_view">
		<div id="scroll_header"></div>
		<div id="scroll_wrapper">
			<div id="scroll_scroller">
				<div id="pullDown">
					<span class="pullDownIcon"></span><span class="pullDownLabel"><%=SystemEnv.getHtmlNoteName(4971,user.getLanguage())%></span><!-- 下拉刷新  -->
				</div>
				<%=pageContent %>
			</div>
		</div>
		<div id="scroll_footer"></div>
	</div>
	<div id="right_view">
		<div></div>
	</div>
</div>
</body>
</html>