<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="true"%>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager" %>
<%@ page import="com.weaver.formmodel.mobile.ui.manager.MobileAppFieldManager" %>
<%@ page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager" %>
<%@ page import="com.weaver.formmodel.mobile.model.MobileAppModelInfo" %>
<%@ page import="com.weaver.formmodel.data.manager.FormInfoManager" %>
<%@ page import="com.weaver.formmodel.data.model.Forminfo" %>
<%@ page import="com.weaver.formmodel.mobile.ui.model.AppFieldUI" %>
<%@ page import="com.weaver.formmodel.mobile.ui.model.AppFormUI" %>
<%@ page import="com.weaver.formmodel.mobile.ui.model.AppField" %>
<%@ page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%@ page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@ page import="com.weaver.formmodel.mobile.ui.manager.MobiledeviceManager"%>
<%@ page import="com.weaver.formmodel.mobile.ui.model.Mobiledevice"%>
<%@ page import="com.weaver.formmodel.mobile.mec.model.MobileExtendComponent"%>
<%@ page import="com.weaver.formmodel.mobile.mec.service.MECService"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@page import="com.weaver.formmodel.mobile.mec.MECManager"%>
<%@page import="com.weaver.formmodel.mobile.model.MobileAppBaseInfo"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileAppModelManager"%>
<%@page import="com.weaver.formmodel.mobile.jscode.JSCodeManager"%>
<%@page import="com.weaver.formmodel.mobile.jscode.model.JSCodeConfig"%>
<%@page import="com.weaver.formmodel.mobile.plugin.Plugin"%>
<%@page import="com.weaver.formmodel.mobile.plugin.PluginCenter"%>
<%@page import="com.weaver.formmodel.mobile.skin.SkinManager"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
int subCompanyId=-1;
if(mmdetachable.equals("1")){
	subCompanyId=Util.getIntValue(Util.null2String(session.getAttribute("mobilemode_defaultSubCompanyId")),-1);
    if(subCompanyId == -1){
        subCompanyId = user.getUserSubCompany1();
    }
}
int operatelevel = getCheckRightSubCompanyParam("MobileModeSet:All",user,mmdetachable ,subCompanyId);//权限等级-> 2完全控制 1 编辑 0 只读

MobiledeviceManager mobiledeviceManager = MobiledeviceManager.getInstance();
//手机应用id
int appid=Util.getIntValue(Util.null2String(request.getParameter("appid")),0);
//布局id
int id=Util.getIntValue(Util.null2String(request.getParameter("id")),0);
String refresh = Util.null2o(request.getParameter("refresh"));
//是否为首页
String ishomepage=Util.null2String(request.getParameter("ishomepage"));
//移动设备id
int mobiledeviceid=Util.getIntValue(Util.null2String(request.getParameter("mobiledeviceid")),0);
//父布局id
int parentid=Util.getIntValue(Util.null2String(request.getParameter("parentid")),id);
//手机模块id
int entityid = 0;
//布局类型
int uiType = 2;
//表单id
int formid=0;

String content="";
//移动设备html
String devicesHtml="";



MobileAppUIManager mobileAppUIManager = MobileAppUIManager.getInstance();

MobileAppHomepageManager mobileAppHomepageManager=MobileAppHomepageManager.getInstance();
AppHomepage appHomepage=new AppHomepage();
if(id!=0){
	appHomepage=mobileAppHomepageManager.getAppHomepageWithModel(id);
	appid=appHomepage.getAppid();
	parentid=appHomepage.getParentid()==null?appHomepage.getId():appHomepage.getParentid();
	mobiledeviceid=appHomepage.getMobiledeviceid()==null?0:appHomepage.getMobiledeviceid();
}else if(parentid!=0){
	appHomepage=mobileAppHomepageManager.getAppHomepageWithModel(parentid);
	appHomepage.setId(null);
	appid=appHomepage.getAppid();
}else{
	appHomepage=mobileAppHomepageManager.getDefaultAppHomepageByAppid(appid);
	id=appHomepage.getId()==null?0:appHomepage.getId();
	parentid=appHomepage.getId()==null?0:appHomepage.getId();
	mobiledeviceid=appHomepage.getMobiledeviceid()==null?0:appHomepage.getMobiledeviceid();
}

//如果应用id为空，则返回
if(appid==0)return;

MobileAppBaseInfo appBaseInfo = MobileAppBaseManager.getInstance().get(appid);

String pageAttr ="";
if(appHomepage.getId()==null){
	content=mobileAppHomepageManager.getEmptyHomepageContent();
	pageAttr="{}";
}else{
	content=appHomepage.getPageContent();
	pageAttr=(Util.null2String(appHomepage.getPageAttr()).equals(""))?"{}":appHomepage.getPageAttr();
}

JSONObject pageAttrJson = JSONObject.fromObject(Util.null2String(pageAttr));
int isDownRefresh = Util.getIntValue(Util.null2String(pageAttrJson.get("isDownRefresh")));
boolean isDisabledSkin = Util.null2String(pageAttrJson.get("isDisabledSkin")).equals("1");
String onloadScript = (String)pageAttrJson.get("onloadScript");
onloadScript = (onloadScript==null)?"":onloadScript;

devicesHtml=mobiledeviceManager.getHomepageMobiledevicesHtml(appid,mobiledeviceid,parentid);

Mobiledevice mobiledevice=mobiledeviceManager.getMobiledevice(mobiledeviceid);
int width=mobiledevice.getWidth()==null?346:mobiledevice.getWidth();
int height=mobiledevice.getHeight()==null?619:mobiledevice.getHeight();

MECService mecService = new MECService();
String mec_objtype = (!ishomepage.equals("1")) ? "1" : "0";
List<MobileExtendComponent> mecObjList = mecService.getMecByObjid(String.valueOf(id), mec_objtype);

JSONArray mecObjJsonArr = JSONArray.fromObject(mecObjList);

JSONArray common_mec_nav_items = new JSONArray();//所有页面，包括自定义页面和布局页面
JSONArray common_mec_nav_layoutpages = new JSONArray();//新建布局，包括模块布局和自定义页面布局
JSONArray common_homepage_items = new JSONArray();//自定义页面,不包括自定义页面布局
JSONArray common_list_items = new JSONArray();	//公共查询列表

List<AppHomepage> appHomepages = MobileAppHomepageManager.getInstance().getAllAppHomepagesByAppid(appid);
for(int i = 0; i < appHomepages.size(); i++){
	AppHomepage homepage = appHomepages.get(i);
	JSONObject nav_item = new JSONObject();
	nav_item.put("iconpath", "/mobilemode/images/homepage/homepage_left_"+i+"_wev8.png");
	nav_item.put("icontype", "1");
	nav_item.put("id", homepage.getId());
	nav_item.put("uiid", MECManager.APPHOMEPAGE_ID_PREFIX + homepage.getId());
	
	nav_item.put("source", "1");
	nav_item.put("custom", "");
	
	nav_item.put("isremind", "0");
	nav_item.put("isgroup", "0");
	nav_item.put("ishide", "0");
	int uitype = Util.getIntValue(Util.null2String(homepage.getUitype()));
	int modelid = Util.getIntValue(Util.null2String(homepage.getModelid()));
	String homepagename = Util.formatMultiLang(homepage.getPagename());
	if(uitype != -1){
		MobileAppModelInfo mobileAppModelInfo=MobileAppModelManager.getInstance().getAppModel(appid, modelid);
		String modename= Util.formatMultiLang(mobileAppModelInfo.getEntityName());
		nav_item.put("uiname", homepagename + " （"+modename+"）");
		if(uitype == 0){
			common_mec_nav_layoutpages.add(nav_item);
		}else if(uitype == 3){
			common_list_items.add(nav_item);
		}
	}else{
		nav_item.put("uiname", homepagename);
		common_homepage_items.add(nav_item);
	}
	common_mec_nav_items.add(nav_item);
}

List<AppFormUI> formuiList = mobileAppUIManager.getDefaultAppUIListForHomepage(appid);

for(int i = 0; i < formuiList.size(); i++){
	AppFormUI appFormUI = formuiList.get(i);
	int uiid = appFormUI.getId();
	String ishide = Util.null2String(appFormUI.getIsHide());
	String uiname = Util.formatMultiLang(appFormUI.getUiName());
	int uitype = appFormUI.getUiType();
	MobileAppModelInfo mobileAppModelInfo=MobileAppModelManager.getInstance().getAppModelInfo(appFormUI.getEntityId());
	String modename= Util.formatMultiLang(mobileAppModelInfo.getEntityName());
	
	JSONObject nav_item = new JSONObject();
	nav_item.put("iconpath", "/mobilemode/images/homepage/homepage_left_"+(appHomepages.size() + i)+"_wev8.png");
	nav_item.put("icontype", "1");
	nav_item.put("uiid", uiid);
	nav_item.put("uiname", uiname+" （"+modename+"）");
	nav_item.put("source", "1");
	nav_item.put("custom", "");
	
	nav_item.put("isremind", "0");
	nav_item.put("isgroup", "0");
	nav_item.put("ishide", ishide);
	common_mec_nav_items.add(nav_item);
	
	if(uitype == 3){
		common_list_items.add(nav_item);
	}else{
		common_mec_nav_layoutpages.add(nav_item);
	}
}

//List<JSCodeConfig> pageJSCodeItems = JSCodeManager.getPageJSCodeItems(content);
JSONArray jscode_items = new JSONArray();

int maxMECCount = user.getLanguage() == 8 ? 7 : 9;

String appname = appBaseInfo.getAppname();
String pgname = appHomepage.getPagename();
String titlename = SystemEnv.getHtmlLabelName(81788,user.getLanguage())+"/" + appname + "/" + pgname;// 移动建模  收藏页名称  

PluginCenter pluginCenter = PluginCenter.getInstance();
List<Plugin> plugins = pluginCenter.loadPlugin();
%>


<!DOCTYPE HTML>
<HEAD>

<link type="text/css" rel="stylesheet" href="/formmode/js/jquery/jquery-ui-1.10.3/themes/base/jquery.ui.all_wev8.css" />
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script>
<script async type="text/javascript" src="/formmode/js/json2_wev8.js"></script>
<script async type="text/javascript" src="/mobilemode/scriptlib/js/ScriptLib.js?v=2016012502"></script>

<!-- scroll plugin -->
<script async type="text/javascript" src="/formmode/js/jquery/nicescroll/jquery.nicescroll.min_wev8.js"></script>

<script async type="text/javascript" src="/formmode/js/jquery/contextMenu/jquery.contextMenu_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/formmode/js/jquery/contextMenu/jquery.contextMenu_wev8.css"/>

<script async type="text/javascript" src="/mobilemode/js/modernizr/modernizr.min_wev8.js"></script>
<script async type="text/javascript" src="/mobilemode/js/pep/jquery.pep_wev8.js"></script>

<link type="text/css" rel="stylesheet" href="/mobilemode/css/appuidesign_wev8.css?v=2016031601" />

<!-- color pick -->
<link type="text/css" rel="stylesheet" href="/mobilemode/js/colorpick/css/colpick_wev8.css"/>
<script async type="text/javascript" src="/mobilemode/js/colorpick/colpick_wev8.js"></script>

<script async type="text/javascript" src="/mobilemode/js/zclip/jquery.zclip.js"></script>

<!-- Mec -->
<script type="text/javascript" src="/mobilemode/js/mec/handler/MECHandlerPool_wev8.js?v=2016_01_11_03"></script>
<script async type="text/javascript" src="/mobilemode/js/UUID_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/js/mec/mec_wev8.js?v=2016_01_11_05"></script>
<link type="text/css" rel="stylesheet" href="/mobilemode/css/mec/mec_design_wev8.css?v=2016_01_11_06" />
<link type="text/css" rel="stylesheet" href="/mobilemode/css/mec/mec_wev8.css" />

<script async type="text/javascript" src="/mobilemode/js/urlSelector/urlSelector_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/mobilemode/js/urlSelector/urlSelector_wev8.css" />

<%if(operatelevel < 1){%>
<style>
.Design_MecHandler .copy_btn{
	right:5px;
}
.Design_MecHandler:HOVER .del_btn{
	display: none;	
	visibility: visible;
}
</style>
<%}%>
<script type="text/javascript" src="/mobilemode/js/mec/ResourceLoader.js?v=2016032801"></script>

<script type="text/javascript" src="/mobilemode/js/appuidesign_wev8.js?v=2017110101"></script>


<%if(!isDisabledSkin){%>
	<%=new SkinManager().getCssHtml(appBaseInfo.getSkin()) %>
<%}%>

<script>
var common_mec_nav_items = <%=common_mec_nav_items%>;
var common_list_items = <%=common_list_items%>;//布局列表
var common_homepage_items = <%=common_homepage_items%>;
var common_mec_nav_layoutpages = <%=common_mec_nav_layoutpages%>;
var appName = "<%=appBaseInfo.getAppname()%>";
var appHomepageName = "<%=appHomepage.getPagename()%>";
var appHomepageId = "<%=appHomepage.getId()%>";
var _isHomePage = "<%=appHomepage.getIshomepage()%>";
var operatelevel = <%=operatelevel%>;
var _appid = "<%=appid%>";
var _uitype = <%=Util.getIntValue(appHomepage.getUitype())%>;
var _mobiledeviceid = "<%=mobiledeviceid%>";
var jscode_items = <%=jscode_items%>;
var _viewUrlTip = "<%=SystemEnv.getHtmlLabelName(81664,user.getLanguage())%>";
var _viewUrlPublic = "<%=SystemEnv.getHtmlNoteName(4702,user.getLanguage())%>";
var _userLanguage = "<%=user.getLanguage()%>";

var pluginConfigArr = null;

var $navmainScroll = null;

function doGetContentFromMobile(){
	$("#loading-msg").html("<%=SystemEnv.getHtmlLabelName(127522,user.getLanguage())%>"); //正在操作，请稍候...
	$(".loading").show();
	enableAllmenu();
	var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppHomepageAction", "action=getContentFromMobile&id=<%=id%>&parentid=<%=parentid%>&appid=<%=appid%>&mobiledeviceid=<%=mobiledeviceid%>");
	FormmodeUtil.doAjaxDataLoad(url, function(datas){
		$(".loading").hide();
		var url = '/mobilemode/appuidesign2.jsp?id='+datas+"&parentid=<%=parentid%>&mobiledeviceid=<%=mobiledeviceid%>&ishomepage=<%=ishomepage%>";
		location.href=url;
	});
}

$(document).ready(function () {
	
	
	$("#tabs").tabs({heightStyle:"fill",active:0});
	$( "#draggable" ).draggable({ containment: "#content",cursor:"move",handle:"#draggable_title"});
	
	//最小化
	$( "#button" ).click(function() {
		runEffect();
	});
	
	$("#sourceFrame").height($(window).height()-110);
	
	$("#ishomepage").val("1");
	//$("#draggable").hide();
	
	$("#mobiledevices").html("<%=devicesHtml%>");
	$(".metro").show();

	initPluginConfig(true);
	
	MECHandlerPool.initHandler(<%=mecObjJsonArr%>, function(){
		mecLoaded();
	});
	
	$("#navItemsPanel .nav_left li").on("click", function(){
		if(!$(this).hasClass("selected")){
			$(this).siblings("li.selected").removeClass("selected");
			$(this).addClass("selected");
			var tHref = $(this).attr("href");
			$("#navItemsPanel .nav_main .panel").hide();
			$("#navItemsPanel ."+tHref).show();
			var containerscroll = $("#navItemsPanel .nav_main");
		    containerscroll.scrollTop(0);
			$navmainScroll.resize();
		}
	});
	$("#navItemsPanel .nav_main span").on("click", function(){
		$("#navItemsPanel .nav_main span").removeClass("sellabel");
		$(this).addClass("sellabel");
		var uiid = $(this).attr("id");
		var unname = $(this).html();
		var mec_id = $("#navItemsPanel").attr("mec_id");
		var currRowIndex = $("#navItemsPanel").attr("currRowIndex");
		$("#ui_"+currRowIndex+"_"+mec_id).val(uiid);
		$("#source_"+currRowIndex+"_"+mec_id).val(1);
		$("#uiview_"+currRowIndex+"_"+mec_id).val(unname);
		$("#ui_"+currRowIndex+"_"+mec_id).parent().find("a").removeClass("sbToggle-btc-reverse");
		$("#navItemsPanel").slideUp(150);
		$navmainScroll.hide();
	});
	
	$("body").click(function(){
		nav_closePanel();
		if(typeof(window.MADFDTABLE_closeFieldPropPanel) == "function"){
			MADFDTABLE_closeFieldPropPanel();
		}
	});
	
	$("#navItemsPanel").bind("click",function(event){
       	var e=event || window.event;
	    if (e && e.stopPropagation){
	        e.stopPropagation();    
	    }
    });
    $navmainScroll = $("#navItemsPanel .nav_main").niceScroll({
						cursorcolor:"#aaa",
						cursorwidth:3,
						zindex:2147483633
					  });
	
	var d_urls = [];
	$.each(common_mec_nav_items, function(){
		if(this.ishide == "1"){
			return true;
		}
		var uiid = this.uiid;
		var url;		
		if(uiid.toString().indexOf("homepage_") == 0){
			url = "/mobilemode/appHomepageView.jsp?appHomepageId=" + (uiid.substring("homepage_".length));
		}else{
			url = "/mobilemode/formbaseview.jsp?uiid=" + uiid;
		}
		d_urls.push({"url":url, "name":this.uiname});
	});				  
	URLSelector.initData(d_urls);
});

</script>
</HEAD>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	systemAdminMenu = ""; //去除掉管理员菜单，没什么用
	if(operatelevel >= 1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}
    if(parentid > 0 && mobiledeviceid == 2){
    	RCMenu += "{" + SystemEnv.getHtmlLabelName(127523,user.getLanguage()) + ",javascript:getContentFromMobile(),_self} "; //从Mobile获取内容
    	RCMenuHeight += RCMenuHeightStep ;
    }
    if(id > 0) {
    	RCMenu += "{" + SystemEnv.getHtmlLabelName(126095,user.getLanguage()) + ",javascript:onPreview(),_self} "; //预览
    	RCMenuHeight += RCMenuHeightStep ;
    	if(operatelevel >= 1){
	    	AppHomepage appHomepageWithModel = mobileAppHomepageManager.getAppHomepageWithModel(id);
	    	if(appHomepageWithModel != null){
	    		int uitype = Util.getIntValue(Util.null2String(appHomepageWithModel.getUitype()));
				int modelid = Util.getIntValue(Util.null2String(appHomepageWithModel.getModelid()));
				if(uitype != -1 && modelid != -1){
					RCMenu += "{"+SystemEnv.getHtmlLabelName(20873,user.getLanguage())+ SystemEnv.getHtmlLabelName(33368,user.getLanguage())+",javascript:onInitLayout(),_self} "; //内容
	    			RCMenuHeight += RCMenuHeightStep ;
				}
	    	}
	    	RCMenu += "{"+SystemEnv.getHtmlLabelName(20873,user.getLanguage())+ SystemEnv.getHtmlLabelName(22967,user.getLanguage()) + ",javascript:onInitContent(),_self} "; //页面
	    	RCMenuHeight += RCMenuHeightStep ;
    	
	    	RCMenu += "{" + SystemEnv.getHtmlLabelName(127365,user.getLanguage()) + ",javascript:onSaveAsTmp(),_self} "; //存为模板
	    	RCMenuHeight += RCMenuHeightStep ;
    	}
    	RCMenu += "{" + SystemEnv.getHtmlLabelName(81664,user.getLanguage()) + ",javascript:viewUrl(),_self} "; //页面地址
    	RCMenuHeight += RCMenuHeightStep ;
    	RCMenu += "{" + SystemEnv.getHtmlNoteName(4702,user.getLanguage()) + ",javascript:viewUrl2(),_self} "; //页面地址（供外部）
    	RCMenuHeight += RCMenuHeightStep ;
    }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body class="mobiledevice<%=mobiledeviceid == 2 ? 2 : 1%> style_language_<%=user.getLanguage() %>">
<div class="loading">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
	<span  id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(23278, user.getLanguage())%></span>
</div>


<div class="metro" style="display:none;">
	<div id="tabs">
		<ul>
			<li><a href="#tabs-3"><%=SystemEnv.getHtmlLabelName(127520, user.getLanguage())%><!-- 布局设计器 --></a></li>
		</ul>
	
		<div id="tabs-3" style="font-family:'Microsoft Yahei', Arial;font-size:11px;padding:8px 8px 0 8px;">
			<div onclick="javascript:onSave();" style="<%if(operatelevel < 1){%>color:#999;cursor:not-allowed !important;<%}%>width: 40px;text-align:center;float:left;background-color:#fff;padding: 3px;line-height:14px;cursor:pointer;">
				<img src="images/toolbar/t04_wev8.png" style="width:32px;"/>
				<br/>
				<span><%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%><!-- 保存 --></span>
			</div>
			<div onclick="javascript:refresh();" style="width: 40px;text-align:center;float:left;background-color:#fff;padding: 3px;line-height:14px;cursor:pointer;">
				<img src="images/toolbar/t05_wev8.png" style="width:32px;"/>
				<br/>
				<span><%=SystemEnv.getHtmlLabelName(354, user.getLanguage())%><!-- 刷新 --></span>
			</div>
			<div onclick="javascript:toggleDesignerSize();" style="width: 40px;text-align:center;float:left;background-color:;padding: 3px;line-height:14px;cursor:pointer;">
				<img id="imgToggle" src="images/toolbar/t09_wev8.png" style="width:32px;"/>
				<br/>
				<%=SystemEnv.getHtmlLabelName(127728, user.getLanguage())%><!-- 最大化 -->
			</div>
			<div class="mec_split" style="background-color:#ccc;height:55px;width:1px;float:left;margin:0 5px;"></div>
			<!-- mec : Mobile Extend Component -->
			<div id="mec_item_container">
			<% 
			int firstMecCount = 0;
			int pluginI = 0;
			for(; pluginI < plugins.size(); pluginI++){ 
				Plugin plugin = plugins.get(pluginI);
				if(!plugin.isEnabled()){
					continue;
				}
				firstMecCount++;
				if(firstMecCount > maxMECCount){
					break;
				}
			%>
				<div class="mec_item">
					<div class="mec_node" id="<%=plugin.getId() %>" mec="true" mec_init="false" mec_type="<%=plugin.getId() %>">
						<em class="<%=plugin.getId() %>"></em>
						<span><%=SystemEnv.getHtmlLabelName(Util.getIntValue(plugin.getText()), user.getLanguage())%></span>
					</div>
				</div>
			<% } %>
			
			<% if(plugins.size() > maxMECCount){ %>
				<div id="mec_item_expand">
				</div>
				<script type="text/javascript">
					$("#mec_item_expand").click(function(e){
						expandMEC();
						e.stopPropagation();
					});
				</script>
			<% } %>
			
			</div>
			
			<div class="mec_split" style="background-color:#ccc;height:55px;width:1px;float:left;margin:0 5px;"></div>
			<div onclick="javascript:Mec_Source();" style="width: 40px;text-align:center;float:left;background-color:;padding: 3px;line-height:14px;cursor:pointer;">
				<img src="images/toolbar/t06_wev8.png" style="width:32px;"/>
				<br/>
				<span><%=SystemEnv.getHtmlLabelName(127521, user.getLanguage())%><!-- 源码 --></span>
			</div>
			
			<div style="background-color:#ccc;height:55px;width:1px;float:left;margin:0 5px;"></div>
				
			<div id="mobiledevices">
			
			</div>
		</div>
	</div>
</div>

<% if(plugins.size() > pluginI){ %>
<div id="mecExpandContainer">
	<% for(int i = pluginI; i < plugins.size(); i++){ 
		Plugin plugin = plugins.get(i);
		if(!plugin.isEnabled()){
			continue;
		}
	%>
		<div class="mec_item">
			<div class="mec_node" id="<%=plugin.getId() %>" mec="true" mec_init="false" mec_type="<%=plugin.getId() %>">
				<em class="<%=plugin.getId() %>"></em>
				<span><%=SystemEnv.getHtmlLabelName(Util.getIntValue(plugin.getText()), user.getLanguage())%></span>
			</div>
		</div>
	<% } %>
</div>
<%} %>

<iframe id="sourceFrame" name="sourceFrame" frameborder="0" scrolling="no">			
</iframe>
<div class="ruler_x"></div>
<div id="content">
	<table width="100%" height="100%">
		<tr>
			<td class="ruler_y"><div style="display:block;width:18px;"></div></td>
			<td class="main_content">
		    	<div class="content_left">
		    		<div id="pageAttr_setting"></div>
		    		<div id="copy_success_tip" style="display:none;"><%=SystemEnv.getHtmlLabelName(127525,user.getLanguage())%> <!-- 插件ID已复制到剪切板 --></div>
		    		<div id="editor_resource_loading"><%=SystemEnv.getHtmlLabelName(127526,user.getLanguage())%><!-- 正在初始化插件资源，请稍后..... --></div>
		    		<div id="content_editor_wrap" style="width:<%=width%>px; height:<%=height%>px;">
				    	<div id="content_editor" class="content_editor" style="width:<%=width%>px; height:<%=height%>px;">
							<%=Util.null2String(content)%>			            
						</div>
			            
			            <div id="content_editor_bottom">
			            </div>
		            </div>
			        <div id="draggable" style="display: none;">
			        	
			        	<div id="draggable_title">
			        		<img id="button" src="images/arrowdown_wev8.png" style="width:16px;margin:5px 0px 5px 8px;vertical-align:middle;"/> 
			        		<span id="draggable_titlename"><%=SystemEnv.getHtmlLabelName(127527,user.getLanguage())%><!-- 组件管理 --></span>
			        		<span id="draggable_title_copy"></span>
			        	</div>
			        	
			        	<div id="draggable_center">
			        		<div id="MAD_Empty_Tip">
			        			<%=SystemEnv.getHtmlLabelName(127528,user.getLanguage())%><!-- 请在左侧手机区域选择组件 -->
			        		</div>
			        		<div id="pageAttr_setting_dlg" style="position: relative; display: none;">
								<div class="pageAttr_setting_dlg_div">
									<span class="pageAttr_setting_dlg_label pageAttr_setting_dlg_label1"><%=SystemEnv.getHtmlLabelName(127529,user.getLanguage())%><!-- 下拉刷新： --></span>
									<input type="checkbox" id="pageAttr_isDownRefresh" 
									<% if(isDownRefresh==1){ %>
										checked="checked"
									<%}%>
									>
								</div>
								<div class="pageAttr_setting_dlg_div">
									<span class="pageAttr_setting_dlg_label pageAttr_setting_dlg_label2"><%=SystemEnv.getHtmlLabelName(127530,user.getLanguage())%><!-- 禁用皮肤： --></span>
									<input type="checkbox" id="pageAttr_isDisabledSkin" 
									<% if(isDisabledSkin){ %>
										checked="checked"
									<%}%>
									>
									
									<span style="margin-left: 10px; color:#ccc;"><%=SystemEnv.getHtmlLabelName(127531,user.getLanguage())%><!-- (此项若被勾选，该页面将不会使用皮肤样式) --></span>
								</div>
								<div class="pageAttr_setting_dlg_div">
									<span class="pageAttr_setting_dlg_label pageAttr_setting_dlg_label3"><%=SystemEnv.getHtmlLabelName(127532,user.getLanguage())%><!-- 页面加载执行JS： --></span>
									<textarea id="pageAttr_onloadScript" class="pageAttr_setting_dlg_textarea"><%=onloadScript%></textarea>
								</div>
			        		</div>
			            </div>
			        </div>
			        <div id="navItemsPanel" >
						<div class="nav_left">
							<ul>
								<li href="searchPanel" sourcetype="0"><%=SystemEnv.getHtmlLabelName(81289,user.getLanguage())%><!-- 搜索结果 --></li>
								<li class="selected" href="homepagePanel" sourcetype="1"><div><%=SystemEnv.getHtmlLabelName(32309,user.getLanguage())%><!-- 自定义页面 --></div></li>
								<li href="layoutPanel" sourcetype="2"><div><%=SystemEnv.getHtmlLabelName(127533,user.getLanguage())%><!-- 布局新建 --></div></li>
								<li href="listPanel" sourcetype="3"><div><%=SystemEnv.getHtmlLabelName(127534,user.getLanguage())%><!-- 布局列表 --></div></li>
								<li href="customPanel" sourcetype="4"><div><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%><!-- 自定义链接 --></div></li>
								<li href="jscodePanel" sourcetype="5"><div><%=SystemEnv.getHtmlLabelName(127495,user.getLanguage())%><!-- 脚本 --></div></li>
							</ul>
						</div>
						<div class="nav_main">
							<div class="searchPanel panel"><%=SystemEnv.getHtmlLabelName(127535,user.getLanguage())%><!-- 没有搜索结果 -->
							</div>
							<div class="homepagePanel panel">
								<% for(int m=0;m<common_homepage_items.size();m++){
									JSONObject nav_item = (JSONObject)common_homepage_items.get(m);
									String uid = Util.null2String(nav_item.get("uiid"));
									String uiname = Util.null2String(nav_item.get("uiname"));%>
									<span id="<%=uid%>"><%=uiname%></span>
								<%}%>
							</div>
							<div class="layoutPanel panel">
								<% for(int m=0;m<common_mec_nav_layoutpages.size();m++){
									JSONObject nav_item = (JSONObject)common_mec_nav_layoutpages.get(m);
									String uid = Util.null2String(nav_item.get("uiid"));
									String uiname = Util.null2String(nav_item.get("uiname"));%>
									<span id="<%=uid%>"><%=uiname%></span>
								<%}%>
							</div>
							<div class="listPanel panel">
								<% for(int m=0;m<common_list_items.size();m++){
									JSONObject nav_item = (JSONObject)common_list_items.get(m);
									String isHide = Util.null2String(nav_item.get("ishide"));
									if("1".equals(isHide)) continue;
									String uid = Util.null2String(nav_item.get("uiid"));
									String uiname = Util.null2String(nav_item.get("uiname"));%>
									<span id="<%=uid%>"><%=uiname%></span>
								<%}%>
							</div>
							<div class="customPanel panel">
								<div style="padding-top: 10px;"><input type="text" id="nav_custom" value="" placeholder="<%=SystemEnv.getHtmlLabelName(127536,user.getLanguage())%>"/></div><!-- 请输入自定义链接 -->
								<div class="panelBtn" onclick="nav_customSave(this);"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></div>
							</div>
							<div class="jscodePanel panel">
								<div style="padding-top: 10px;"><textarea id="nav_jscode" placeholder="<%=SystemEnv.getHtmlLabelName(127537,user.getLanguage())%>"></textarea></div><!-- 请输入脚本 -->
								<div class="panelBtn" onclick="nav_jscodeSave(this);"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></div>
							</div>
							<div class="delFlag" onclick="nav_closePanel();"></div>
					</div>
		    	</div>
			</td>
		</tr>
	</table>
</div>
<form id=weaver name=frmMain method=post target="_self" >
	<input type=hidden name=appid id="appid" value="<%=appid%>">
	<input type=hidden name=id id="id" value="<%=id%>">
	<input type=hidden name=entityId id="entityId" value="<%=entityid%>">
	<input type=hidden name=formid id="formid" value="<%=formid%>">
	<input type=hidden name=uicontent id="uicontent">
	<input type=hidden name=pageAttr id="pageAttr">
	<input type=hidden name=ishomepage id="ishomepage" value="<%=ishomepage%>">
	<input type="hidden" name="mobiledeviceid" id="mobiledeviceid" value="<%=mobiledeviceid%>"/>
	<input type="hidden" name="parentid" id="parentid" value="<%=parentid%>"/>
	<input type="hidden" name="mecJsonStr" id="mecJsonStr"/>
	<input type="hidden" name="uiType" id="uiType" value="<%=uiType%>"/>
</form>

<ul id="changePicRightMenu" class="contextMenu">
	<li class="edit"><a href="#changePic"><%=SystemEnv.getHtmlLabelName(127538,user.getLanguage())%><!-- 更改图片 --></a></li>
</ul>
<!-- 时间控件 -->
<script async type="text/javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>