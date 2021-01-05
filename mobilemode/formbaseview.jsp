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
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="com.weaver.formmodel.data.model.EntityInfo"%>
<%@page import="com.weaver.formmodel.data.manager.EntityInfoManager"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="com.weaver.formmodel.base.model.PageModel"%>
<%@page import="com.weaver.formmodel.mobile.model.MobileAppModelInfo"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileAppModelManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppFormUI"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobiledeviceManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppFieldUI"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileFieldUIManager"%>
<%@page import="weaver.formmode.setup.ModeRightInfoExtend"%>
<%@page import="com.weaver.formmodel.mobile.utils.MobileCommonUtil"%>
<%@page import="com.weaver.formmodel.mobile.types.ClientType"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.net.URLEncoder"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="FormInfoService" class="weaver.formmode.service.FormInfoService" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String billid = StringHelper.null2String(request.getParameter("billid"));
String sqlwhere=StringHelper.null2String(request.getParameter("sqlwhere"));

int isdeleted = NumberHelper.string2Int(request.getParameter("isdeleted"),0);
if(isdeleted == 1){
	String script = "<script>" +
			"var _top = null;var _win = window;try{while((_win.parent) != _win){_win = _win.parent;if(_win._mobilemode_root_page == true){_top = _win;break;}}}catch(e){}if(_top == null){_top = _win;}" +
			"if(_top && typeof(_top.backPage) == \"function\"){" +
			" 	var $activeFrame = _top.$(\"#mobileFrameContainer iframe.activeFrame\");"+
			" 	var $prevFrame = $activeFrame.prev(\"iframe.mobileFrame\");"+
			" 	if($prevFrame.length > 0){"+
			"		try{ "+
			"			var frameWin = $prevFrame[0].contentWindow;"+
			"			frameWin.Mobile_NS.refreshList();"+
			"		}catch(e){"+
			"		}"+
			"		try{ "+
			"			var frameWin = $prevFrame[0].contentWindow;"+
			"			frameWin.Mobile_NS.refreshTimelinr();"+
			"		}catch(e){"+
			"		}"+
			"		try{ "+
			"			var frameWin = $prevFrame[0].contentWindow;"+
			"			frameWin.Mobile_NS.GridTable.refresh();"+
			"		}catch(e){"+
			"		}"+
			"	}"+
			"	_top.backPage();" +
			"}"+
			"</script>";
	out.print(script);
	return;
}
String uiid = StringHelper.null2String(request.getParameter("uiid"));
if(StringHelper.isEmpty(uiid)){
	request.getRequestDispatcher("/mobilemode/message.jsp?errorCode=1387").forward(request, response);
	return;
}

MobileAppUIManager mobileAppUIManager = MobileAppUIManager.getInstance();
MobileAppModelManager mobileAppModelManager = MobileAppModelManager.getInstance();

//String clienttype = StringHelper.null2String(request.getParameter("clienttype"));	//当前访问客户端类型 可能的值：Webclient|iphone|ipad|Android
ClientType clienttype = MobileCommonUtil.getClientType(request);
int mobiledeviceid = MobiledeviceManager.getInstance().getDeviceByClienttype(clienttype);

AppFormUI appFormUI = mobileAppUIManager.getByIdAndDeviceid(Util.getIntValue(uiid), mobiledeviceid);

if(appFormUI==null){
	request.getRequestDispatcher("/mobilemode/message.jsp?errorCode=1387").forward(request, response);
	return;
}
int appid = appFormUI.getAppid();
int uitype = appFormUI.getUiType();//0：新建、1：查看、2：编辑、3：列表
MobileAppModelInfo appmodel = mobileAppModelManager.getAppModelInfo(appFormUI.getEntityId());
int modelid = appmodel.getModelId();
int formid=appFormUI.getFormId();

User user = MobileUserInit.getUser(request,response);

if(billid.trim().equals("") && (uitype == 1 || uitype == 2)){
	request.getRequestDispatcher("/mobilemode/message.jsp?errorCode=1388").forward(request, response);
	return;
}

boolean isRight = false;
boolean isEdit = false;		//是否有编辑权限，主要针对右键按钮是否显示
boolean isDel = false;		//是否有删除权限，主要针对右键按钮是否显示
boolean isVirtualForm=VirtualFormHandler.isVirtualForm(formid);
if(uitype==3){//列表
	isRight=true;
	if(!isVirtualForm){
		//自定义查询列表查看权限
		int customid=appFormUI.getSourceid();
		rs.executeSql("select * from mode_searchPageshareinfo where righttype=1 and pageid = " + customid);
		if(rs.next()){
			FormModeRightInfo.setUser(user);
			isRight = FormModeRightInfo.checkUserRight(customid,1);
		}else{
			//没有设置任何查看权限数据，则认为有权限查看
			isRight = true;
		}
	}
}else{
	//某条数据查看、编辑、删除权限
	int type=0;
	if(uitype==0){
		type=1;
	}else if(uitype==1){
		type=0;
	}else if(uitype==2){
		type=2;
	}
	if(!isVirtualForm){
		int customid = 0;
		ModeRightInfo.setModeId(modelid);
		ModeRightInfo.setType(type);
		ModeRightInfo.setUser(user);
		if(type == 1 || type == 3){//新建、监控权限判断
			//isRight = ModeRightInfo.checkUserRight(type);
			FormModeRightInfo.setUser(user);
			isRight = FormModeRightInfo.checkUserRight(customid,4);
			if(!isRight){  //如果自定义查询页面无监控权限，则检查全局监控权限
				ModeRightInfo.setModeId(modelid);
				ModeRightInfo.setType(type);
				ModeRightInfo.setUser(user);
				
				isRight = ModeRightInfo.checkUserRight(type);
			}
		}

		ModeShareManager.setModeId(modelid);
		int MaxShare = 0;
		if(type == 0 || type == 2){//查看、编辑权限
			String rightStr = ModeShareManager.getShareDetailTableByUser("formmode",user);
			rs.executeSql("select * from "+rightStr+" t where sourceid="+billid);
			if(rs.next()){
				MaxShare = rs.getInt("sharelevel");
				isRight = true;
				if(MaxShare > 1) {
					isEdit = true;		//有编辑或完全控制权限的出现编辑按钮
					if(MaxShare == 3) isDel = true;		//有编辑或者完全控制权限的出现删除按钮
				}
			}
		}
	}else{
		ModeRightInfoExtend modeRightInfoExtend=new ModeRightInfoExtend();
		modeRightInfoExtend.setModeId(modelid);
		modeRightInfoExtend.setUser(user);
		modeRightInfoExtend.setFormid(formid);
		modeRightInfoExtend.setBillid(billid);
		if(type==1){//新建
			isRight = modeRightInfoExtend.checkUserRight(1);
		}else if(type==0||type==2){//查看、编辑时判断是否显示编辑、删除按钮
			isRight=true;//查看权限
			isDel=modeRightInfoExtend.checkUserRightByRightType(3);//完全控制权限
			if(isDel){
				isEdit=true;
			}else{
				isEdit=modeRightInfoExtend.checkUserRightByRightType(2);//编辑权限
			}
		}
	}
}
if(!isRight){
	request.getRequestDispatcher("/mobilemode/message.jsp?errorCode=1389").forward(request, response);
	return;
}

int pageIndex = NumberHelper.string2Int(request.getParameter("pageIndex"), 1);
int pageSize = NumberHelper.string2Int(request.getParameter("pageSize"), 10);

WebUIContext uiContext = new WebUIContext();
uiContext.setClient(com.weaver.formmodel.ui.types.ClientType.CLIENT_TYPE_MOBILE);
uiContext.setBusinessid(billid);
uiContext.setModelid(modelid);
uiContext.setUIType(uitype);
uiContext.setAppid(appid);
uiContext.setCurrentUser(user);
uiContext.setPageNo(pageIndex);
uiContext.setPageSize(pageSize);
uiContext.setSqlwhere(sqlwhere);
uiContext.setAppFormUI(appFormUI);
uiContext.setRequest(request);
WebUIView uiview = WebUIManager.getInstance().getViewContent(uiContext);
int totalPageCount = 0;
int totalSize=0;
PageModel pageModel=null;
if(uitype==3){
	totalPageCount = uiview.getTotalPageCount();;
	totalSize = uiview.getTotalSize();
}

int isShowInTabV = NumberHelper.string2Int(request.getParameter("isShowInTab"), 0);
boolean isShowInTab = isShowInTabV == 1;

List<WebUIResouces> btnResoucesList = uiview.getButtonPageResources();
//boolean isUseIScroll = (uitype == 3);
boolean isUseIScroll = false;
boolean disableDownRefresh = ((uitype == 3) ? false : true);
%>

<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
	<title><%=uiview.getUiTitle() %></title>
	<link rel="stylesheet" href="/mobilemode/jqmobile4/css/themes/default/jquery.mobile-1.4.0.min_wev8.css">
	<link rel="stylesheet" href="/mobilemode/css/formbase_wev8.css?v=2017041801">
<style>
html, body{
	background-color: #fff;
}
*{
	font-family: 'Microsoft Yahei', Arial;
	font-size: 12px;
}
.ui-mini .ui-input-text input, .ui-mini .ui-input-search input, .ui-input-text.ui-mini input, .ui-input-search.ui-mini input, .ui-mini textarea.ui-input-text, textarea.ui-mini{
	font-size: 12px;
}
.ui-shadow-inset{
	box-shadow: none;
}
.ui-corner-all{
	border-radius: 0;
	-webkit-border-radius: 0;
}
.ui-btn-corner-all, .ui-btn.ui-corner-all, .ui-slider-track.ui-corner-all, .ui-flipswitch.ui-corner-all, .ui-li-count{
	border-radius: 0;
	-webkit-border-radius: 0;
}
.ui-shadow{
	box-shadow: none;
}
.ui-input-search{
	margin-left: 10px;
	margin-right: 10px;
}
.ui-input-text input, .ui-input-search input, textarea.ui-input-text{

}
.ui-input-text{
	margin: 2px 0;
}
.ui-slider-track{
	border: 0;
}
.ui-slider-track.ui-body-a .ui-btn-active {
	text-shadow: 0;
}
.ui-btn-uploadBtn{
	width: 70px;
	font-size: 12px;
}
.ui-loader{
	top:auto;bottom:200px;background:none;
}
#browserSearchContainer div.ui-input-search{
	display: inline-block;
}
		
.ui-filterable{
	position: relative;
}
.expandBtnDiv{
	border: 1px solid rgb(221, 221, 221);
	display: inline-block;
	position: absolute;
	top: 0px;
	right: 10px;
	height: 26px;
	line-height: 26px;
	background-color: #fff;
}
.expandBtnDivHasMore{
	padding-right: 25px;
}
.expandBtnDiv .text{
	padding: 0px 8px 0px 8px;
	display: inline-block;
	cursor: pointer;
}
.expandBtnDiv .moreFlag{
	position: absolute;
	top: 0px;
	right: 0px;
	width: 25px;
	height: 26px;
	display: none;
	background-image: url("/mobilemode/images/homepage/homepage_bottom_wev8.jpg");
	background-repeat: no-repeat;
	background-position: center center;
	cursor: pointer;
}
.expandBtnDivHasMore .moreFlag{ 
	display: block;
}
.expandBtnDivMore{
	background-color: #fff;
	border: 1px solid rgb(221, 221, 221);
	position: absolute;
	z-index: 1000;
	top:35px;
	right: 10px;
	display: none;
}
.expandBtnDivMore ul{
	list-style: none;
	margin: 0px;
	padding: 0px;
}
.expandBtnDivMore ul li{
	height: 32px;
	padding: 0px 33px 0px 8px;
	line-height: 32px;
	border-bottom: 1px solid rgb(221, 221, 221);
	cursor: pointer;
}
.expandBtnDivMore ul li:HOVER {
	background-color: rgb(93, 156, 236);
	color: #fff;
}
.nodata_border{
	background: #f6f6f6;
	padding-top: 10px;
	padding-bottom: 10px;
	margin: 8px 0;
	text-shadow: 0 1px 0 #f3f3f3;
	font-family: sans-serif;
	color: #333;
	font-weight: 700;
	overflow: hidden;
	cursor: pointer;
	border-width: 1px;
	border-style: solid;
	border-radius: 4.96px;
	border-color: #ddd;
	box-shadow: none;
}
.nodata_content{
	position: relative;
	height: 22px;
	line-height: 22px;
	padding-left: 26px;
	white-space: nowrap;
	text-align: center;
	width:150px;
	margin:0 auto;
	font-size: 16px;
}
.nodata_img{
	position: absolute;
	left: 0;
	width: 22px;
	height:22px;
	background-color: rgba(0,0,0,.3);
	border-radius: 1em;
	background-image: url('data:image/svg+xml;charset=US-ASCII,%3C%3Fxml%20version%3D%221.0%22%20encoding%3D%22iso-8859-1%22%3F%3E%3C!DOCTYPE%20svg%20PUBLIC%20%22-%2F%2FW3C%2F%2FDTD%20SVG%201.1%2F%2FEN%22%20%22http%3A%2F%2Fwww.w3.org%2FGraphics%2FSVG%2F1.1%2FDTD%2Fsvg11.dtd%22%3E%3Csvg%20version%3D%221.1%22%20id%3D%22Layer_1%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20xmlns%3Axlink%3D%22http%3A%2F%2Fwww.w3.org%2F1999%2Fxlink%22%20x%3D%220px%22%20y%3D%220px%22%20%20width%3D%2214px%22%20height%3D%2214px%22%20viewBox%3D%220%200%2014%2014%22%20style%3D%22enable-background%3Anew%200%200%2014%2014%3B%22%20xml%3Aspace%3D%22preserve%22%3E%3Cpath%20fill%3D%22%23FFF%22%20d%3D%22M7%2C0C3.134%2C0%2C0%2C3.134%2C0%2C7s3.134%2C7%2C7%2C7s7-3.134%2C7-7S10.866%2C0%2C7%2C0z%20M7%2C2c0.552%2C0%2C1%2C0.447%2C1%2C1S7.552%2C4%2C7%2C4S6%2C3.553%2C6%2C3%20S6.448%2C2%2C7%2C2z%20M9%2C11H5v-1h1V6H5V5h3v5h1V11z%22%2F%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3Cg%3E%3C%2Fg%3E%3C%2Fsvg%3E');
	background-repeat: no-repeat;
	background-position: 4px;
}
td.promptValidateFail{
	background-color: yellow !important;
}
.isManPrompt{
	background-image: url(/mobilemode/images/isman_wev8.png);
	background-repeat: no-repeat;
	background-size: 7px 6px;
	background-position: 5px center;
}
.addtable{
	display: none;
	position: fixed;
	top: 0px;
	left: 0px;
	bottom: 0px;
	right:0px;
	z-index: 999;
}
.addtableInner{
	max-height:80%;
	overflow-y:auto ;
	position: absolute;
	left: 0px;
	bottom: 35px;
	right:0px;
	background-color: #fff;
	-webkit-transition: -webkit-transform 0.3s;
	transition: transform 0.3s;
}
.addtableInner.hide{
	-webkit-transform: translate3d(0, 100%, 0);
	transform: translate3d(0, 100%, 0);
}
.form_detail_back{
	position: absolute;
    overflow: hidden;
    left: 0px;
    bottom: 0px;
    width: 100%;
    background: #fff;
}
.form_detailbuttonStyle{
	float:right;
	width: 25px;
	height: 15px;
	line-height: normal;
	text-align:center;
	font-size: 12px;
	cursor:pointer;
	padding: 5px 10px;
	text-shadow: none;
	margin-right: 5px;
	margin-bottom: 5px;
	margin-top: 5px;
}
.addtableMask{
 	width:100%;height:100%;
 	background-color: #000;
	opacity: 0;
	-webkit-transition: opacity .282s ease-in-out;
	transition: opacity .282s ease-in-out;
}
.addtableMask.show{
	opacity: 0.4;
}
.divoverflow{
	width:100%;
	 margin-top:10px;
	overflow-x:auto;
	-webkit-overflow-scrolling:touch;
}
.entrydel{
	display: none;
}
</style>
<script src="/mobilemode/jqmobile4/js/jquery_wev8.js"></script>
<script src="/mobilemode/jqmobile4/js/jquery.mobile-1.4.0.min_wev8.js"></script>
<script src="/mobilemode/js/lazyload/jquery.lazyload.min_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/mobilemode/js/mobiscroll/css/mobiscroll-2.5.2-min.css"/>
<script type="text/javascript" src="/mobilemode/js/mobiscroll/mobiscroll-2.5.2-min.js"></script>

<script type="text/javascript">
var _top = null;var _win = window;try{while((_win.parent) != _win){_win = _win.parent;if(_win._mobilemode_root_page == true){_top = _win;break;}}}catch(e){}if(_top == null){_top = _win;}
//默认值触发字段联动
function defaultValueLinkage(groupid){
	//浏览框类型
	fieldBrowserLinkfn(groupid);
	var $objs;
	if(groupid != undefined){
		var $container = $("#detaildiv"+groupid);
		$objs = $("input[id^=field],textarea[id^=field],select[id^=field]",$container);
	}else{
		$objs = $("input[id^=field],textarea[id^=field],select[id^=field]");
	}
	if($objs && $objs.length){
		$objs.each(function(){
			var that = $(this);
			var fieldid = that.attr("id").substring(5);
			var bid = that.attr("bid");
			var value = that.val();
			//非浏览框
			if(!bid && value){
				if(that.hasClass("field_select")){
					//选择框
					fieldLinkfn(this);
				}else{
					//字段联动-单行文本框、多行文本框、Check框
					textLinkage(fieldid);
				}
			}
		});
	}
}
//字段联动-单行文本框、多行文本框、Check框
function textLinkage(fieldid){
	var textValue = $("#field" + fieldid).val();
	var result = {"name" : textValue, "value" : textValue};
	
	//触发联动
	readyToTrigger(fieldid, result);
}

function getValueByKey(jsonObj, key){
	var value = "";
	for(var k in jsonObj){
		if(k.toLowerCase() == key.toLowerCase()){
			value = jsonObj[k];
		}
	}
	
	return value;
}
//执行SQL
function SQL(sqlstr, datasource, callbackFn){
	sqlstr = encodeURIComponent(sqlstr);
	if(!datasource){
		datasource = "";
	}
	var asyncFlag = false;
	/* if(typeof(callbackFn) == "function"){
		asyncFlag = true;
	} */
	var result = "";
	 $.ajax({
	 	type: "GET",
	 	contentType: "application/json",
	 	url: jionActionUrl("com.weaver.formmodel.mobile.security.EDAction", "action=runSQL"),
	 	data: "&content="+sqlstr+"&datasource="+datasource,
	 	async: asyncFlag,
	 	success: function(responseText, textStatus) 
	 	{
	 		var data = $.parseJSON(responseText);
	 		var status = data["status"];
	 		if(status != "-1"){	//server端没有出现未知异常
	 			result = data["result"];
	 		}
	 		if(typeof(callbackFn) == "function"){
	 			callbackFn.call(this, result);
	 		}
	 	},
	    error: function(){
	    	//alert("error");
	    }
	});
	return result;
}
</script>

<link type="text/css" rel="stylesheet" href="/mobilemode/css/browser_wev8.css"/>
<script type="text/javascript" src="/mobilemode/js/browser_wev8.js?v=2016112901"></script>
<script type="text/javascript" src="/mobilemode/js/formbaseview_wev8.js?v=201611291644"></script>
<script type="text/javascript" src="/mobilemode/js/fieldsLinkage_wev8.js?v=2017062901"></script>
<script type="text/javascript" language="javascript" src="/formmode/js/jquery/aop/jquery.aop.min_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/formmode/js/json2_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/mobilemode/js/FieldPrompt_wev8.js"></script>

<%if(isUseIScroll){ %>
	<script type="text/javascript">
		var disableDownRefresh = <%=disableDownRefresh%>;
	</script>
	<script type="text/javascript" src="/mobilemode/js/iscroll/iscroll5_wev8.js"></script>
	<script type="text/javascript" src="/mobilemode/js/iscroll/iScrollHandler_wev8.js"></script>
	<link type="text/css" rel="stylesheet" media="all" href="/mobilemode/css/iScroll_wev8.css" />
<%}else{%>
	<style>
	html, body {
	    overflow: hidden;
	    margin: 0;
	}
	#myPage{
		position: absolute;
		top: 0px;
		left: 0px;
		bottom: 0px;
		width: 100%;
		overflow-y: auto;
		overflow-x: hidden;
		-webkit-overflow-scrolling:touch;
		min-height: 382px !important;
	}
	</style>
<%} %>

<%=uiview.getResLink() %>
<script type="text/javascript">
	function downloadattach(fileid,filename){
		top.location.href = "/download.do?fileid="+fileid+"&module=3&scope=11&filename="+encodeURI(filename)+"";
		if(_top && typeof(_top.hideLoading) == "function"){
			_top.hideLoading();
		}
		var e=event || window.event;
	    if (e && e.stopPropagation){
	        e.stopPropagation();    
	    }
	    else{
	        e.cancelBubble=true;
	    }
	}
	
	//显示加载器
	function showLoader() {
	    //显示加载器.for jQuery Mobile 1.2.0
	    $.mobile.loading('show', {
	        text: '加载中...', //加载器中显示的文字
	        textVisible: true, //是否显示文字
	        theme: 'a',        //加载器主题样式a-e
	        textonly: false,   //是否只显示文字
	        html: ""           //要显示的html内容，如图片等
	    });
	}
	
	//隐藏加载器.for jQuery Mobile 1.2.0
	function hideLoader()
	{
	    //隐藏加载器
	    $.mobile.loading('hide');
	}
	
	function callbackUpload(name,data,fieldid) {
		if(fieldid){
			var $uploadname = $('#uploadname'+fieldid);
			$uploadname.val('');
			var $uploaddata = $('#uploaddata'+fieldid);
			$uploaddata.val('');
			if(name){ 
				$uploadname.val(name);
			}
			if(data){
				$uploaddata.val(data);
			}
		
			var uploadKey = data.substring("emobile:upload:".length);
			var url = "/client.do?method=getupload&uploadID="+uploadKey;
			var $entryImg = $("<div class=\"field_upload_entryImg\"><img src=\""+url+"\"></img></div>");
			var $entryDelete = $("<div class=\"field_upload_deleteBtn\"></div>");
			var $entry = $("<div class=\"field_upload_entry\"></div>");
			$entry.append($entryImg).append($entryDelete);
			var $entryBtn = $("#entryBtn"+fieldid);
			var $entryWrap = $("#entryWrap" + fieldid);
			$entryWrap.children().remove();
			$entryWrap.append($entry).append($entryBtn);
			
			$entryDelete.click(function(){
				delUpload(this, fieldid); 
			});
		}
	}
	
	function delUpload(obj,fieldid,docid){
		var str="";
		var strAry=$("#field" + fieldid).val().split(",");
		for(i=0;i<strAry.length;i++){
			if(strAry[i]!=docid){
				str = str+strAry[i]+","
			}			
		}
		str = str.substring(0,str.length-1);
		$("#field" + fieldid).val(str);
		$(obj).parent().remove();
	}
	
	function clearUpload(fieldid) {
		$("#field" + fieldid).val("");
		var $entryBtn = $("#entryBtn"+fieldid);
		var $entryWrap = $("#entryWrap" + fieldid);
		$entryWrap.children().remove();
		$entryWrap.append($entryBtn);
	}
	
	function addUpload(e, fieldid) {
		if(_top && typeof(_top.registUploadWindow) == "function"){
			_top.registUploadWindow(window);
		}
		location = "emobile:upload:callbackUpload:"+fieldid+":"+e.clientY+":clearUpload";
	}
	
	function addUpload1(fieidid){
	if(fieidid){
	var file = document.getElementById("file"+fieidid);
		if(file.files && file.files[0]){
			var reader = new FileReader();
		   	reader.onload = function(evt){
				
				var $field = $("#photoField"+fieidid);
				var fieldArray = $field.val().split(",");
				var fieldNum = parseInt(fieldArray[0]);
				fieldNum += 1;
				var fieldStr = fieldNum+","+ fieidid;
				$field.val(fieldStr);
				
				var temp = 0;
				$("input[type='file']", "#entryWrap"+fieidid).each(function(){
					if($(this).attr("fileNum") > temp){
						temp = $(this).attr("fileNum");
					}
				});
				
				++temp;
				var $file = $("#file"+fieidid);
				$file.attr("name","file"+fieidid+(temp));
				$file.attr("id","file"+fieidid+(temp));
				$file.attr("fileNum",(temp));
				$file.css("display","none");
				var $entryImg = $("<div class=\"field_upload_entry\"><img src=\""+evt.target.result+"\"></img></div>");
				var $entryDelete = $("<div class=\"field_upload_DeleteBtn\"></div>");
				var $entryBorder = $("<div class=\"field_upload_entryBorder\"></div>");
				$entryBorder.append($entryImg).append($entryDelete).append($file);
				$("#photoBorder"+fieidid).before($entryBorder);
				
				$entryDelete.click(function(){
					$(this).parent().remove();
				});
				
				var $originalFile = $("<input id=\"file"+fieidid+"\" type=\"file\" name=\"file\" fileNum=\"0\" class=\"upLoadFile\" accept=\"image/jpg,image/jpeg,image/png,image/gif\" single=\"single\"  onchange=\"addUpload1('"+fieidid+"');\" data-role=\"none\"/>");
				$("#entryBtn"+fieidid).append($originalFile);
				//refreshIScroll();
				$originalFile.focus();
		   	}
		   	reader.readAsDataURL(file.files[0]);
		}
	}
}
	
	function addUploadattach(fieidid){
		if(fieidid){
		var file = document.getElementById("file"+fieidid);
			if(file.files && file.files[0]){
				var filefullname = file.files[0].name;
				var splitpoint = filefullname.lastIndexOf(".");
				var filename = filefullname.substring(0, splitpoint);
				var filetype = filefullname.substring(splitpoint + 1);
				
				var imagesrc = "";
				if(filetype.toLowerCase() == "jpg" || filetype.toLowerCase() == "jpeg" || filetype.toLowerCase() == "png" || filetype.toLowerCase() == "gif" || filetype.toLowerCase() == "bmp") {
					imagesrc = "/mobilemode/images/icon/jpg_wev8.png";
				}else if(filetype.toLowerCase() == "doc" || filetype.toLowerCase() == "docx") {
					imagesrc = "/mobilemode/images/icon/doc_wev8.png";
				}else if(filetype.toLowerCase() == "xls" || filetype.toLowerCase() == "xlsx") {
					imagesrc = "/mobilemode/images/icon/xls_wev8.png";
				}else if(filetype.toLowerCase() == "pdf") {
					imagesrc = "/mobilemode/images/icon/pdf_wev8.png";
				}else if(filetype.toLowerCase() == "htm" || filetype.toLowerCase() == "html") {
					imagesrc = "/mobilemode/images/icon/html_wev8.png";
				}else if(filetype.toLowerCase() == "ppt") {
					imagesrc = "/mobilemode/images/icon/ppt_wev8.png";
				}else {
					imagesrc = "/mobilemode/images/icon/txt_wev8.png";
				}
				
				var filesize = file.files[0].size;
            	var showfilesize = "";
            	if(filesize>=(1024 * 1024)){
            		showfilesize = (filesize / 1024 / 1024).toFixed(2) + "M";
            	} else if(filesize>=1024){
            		showfilesize = Math.floor(filesize / 1024) + "K";
            	} else{
            		showfilesize = filesize+ "B";
            	}
				
				var reader = new FileReader();
			   	reader.onload = function(evt){
					
					var $field = $("#photoField"+fieidid);
					var fieldArray = $field.val().split(",");
					var fieldNum = parseInt(fieldArray[0]);
					fieldNum += 1;
					var fieldStr = fieldNum+","+ fieidid;
					$field.val(fieldStr);
					
					var temp = 0;
					$("input[type='file']", "#entryWrap"+fieidid).each(function(){
						if($(this).attr("fileNum") > temp){
							temp = $(this).attr("fileNum");
						}
					});
					
					++temp;
					var $file = $("#file"+fieidid);
					$file.attr("name","file"+fieidid+(temp));
					$file.attr("id","file"+fieidid+(temp));
					$file.attr("fileNum",(temp));
					$file.css("display","none");
					var $attach_upload_entry = 
						$("<div class=\"attach_upload_entry\">" +
								"<table style=\"width: 100%; table-layout: fixed;\">" +
									"<tr>" +
										"<td class=\"icon\"><img width=\"20\" height=\"20\" src=\"" + imagesrc + "\"></td>" +
										"<td class=\"name\">" + filefullname + "</td>" +
										"<td class=\"size\">" + showfilesize + "</td>" +
										"<td class=\"flag\"><img width=\"20\" height=\"20\" src=\"/mobilemode/images/mec/arrow_right_wev8.png\"></td>" +
									"</tr>" +
								"</table>" +
							"</div>");
					var $attach_upload_DeleteBtn = $("<div class=\"attach_upload_DeleteBtn\"></div>");
					var $attach_upload_entryborder = $("<div class=\"attach_upload_entryborder\" style=\"padding-right: 30px;\"></div>");
					$attach_upload_entryborder.append($attach_upload_entry).append($attach_upload_DeleteBtn).append($file);
					
					$("#attachBorder"+fieidid).before($attach_upload_entryborder);
					
					$attach_upload_DeleteBtn.click(function(){
						$(this).parent().remove();
					});
					
					var $originalFile = $("<input id=\"file"+fieidid+"\" type=\"file\" name=\"file\" fileNum=\"0\" class=\"upLoadFile\" single=\"single\"  onchange=\"addUploadattach('"+fieidid+"');\" data-role=\"none\"/>");
					$("#entryBtn"+fieidid).append($originalFile);
					//refreshIScroll();
					$originalFile.focus();
			   	}
			   	reader.readAsDataURL(file.files[0]);
			}
		}
	}
	
	//附件行编辑(附件)
	function addattachtoedit(fieidid,rownum){
		$("a", "#entryWrap"+fieidid+"_"+rownum).each(function(){
			var $attach_upload_entryborder = $("<div class=\"attach_upload_entryborder\" style=\"padding-right: 30px;\"></div>");
			var attachid = $(this).attr("attachid");
			var docid = $(this).attr("docid");
			$attach_upload_entryborder.append($(this).clone()).append("<div class=\"attach_upload_DeleteBtn\" onclick=\"delUpload(this, '"+fieidid+"','"+docid+"');\"></div>");
			$("#attachBorder"+fieidid).before($attach_upload_entryborder);
		});
		
		var temp = 0;
		$("input[type='file']", "#entryWrap"+fieidid+"_"+rownum).each(function(){
			if($(this).attr("fileNum") > temp){
				temp = $(this).attr("fileNum");
			}
		});
		for(var i = 1;  i <= temp; i++){
			var $attach_upload_entryborder =$("<div class=\"attach_upload_entryborder\" style=\"padding-right: 30px;\"></div>");
			var $field_upload_entry = $("#file"+fieidid+"_"+rownum+i).parent(".attach_upload_entryborder").children(".attach_upload_entry").clone();
			var $file = $("#file"+fieidid+"_"+rownum+i);
			$file.attr("name","file"+fieidid+i);
			$file.attr("id","file"+fieidid+i);
			var $entryDelete = $("<div class=\"attach_upload_DeleteBtn\"></div>");
			$attach_upload_entryborder.append($field_upload_entry).append($entryDelete).append($file);
			$("#attachBorder"+fieidid).before($attach_upload_entryborder);
			$entryDelete.click(function(){
				//$(this).parent().remove();
				$(this).parent().addClass("entrydel");
			});
		}
		$("#photoField"+fieidid).val(temp+","+fieidid);
		$("#field"+fieidid).val($("#field"+fieidid+"_"+rownum).val());
	}
	
	//附件行编辑(图片)
	function addimgtoedit(fieidid,rownum){
		$("img", "#entryWrap"+fieidid+"_"+rownum).each(function(){
			if(typeof($(this).attr("docid"))!="undefined"){
				var $attach_upload_entryborder = $("<div class=\"field_upload_entryBorder\"></div>");
				var $field_upload_entry = $("<div class=\"field_upload_entry\"></div>");
				$(this).removeAttr("data-groupev");
				var attachid = $(this).attr("attachid");
				var docid = $(this).attr("docid");
				$field_upload_entry.append($(this).clone());
				$attach_upload_entryborder.append($field_upload_entry).append("<div class=\"field_upload_DeleteBtn\" onclick=\"delUpload(this, '"+fieidid+"','"+docid+"');\"></div>");
				$("#photoBorder"+fieidid).before($attach_upload_entryborder);
			}
		});
		
		var temp = 0;
		$("input[type='file']", "#entryWrap"+fieidid+"_"+rownum).each(function(){
			if($(this).attr("fileNum") > temp){
				temp = $(this).attr("fileNum");
			}
		});
		for(var i = 1;  i <= temp; i++){
			var $attach_upload_entryborder = $("<div class=\"field_upload_entryBorder\"></div>");
			var $field_upload_entry = $("#file"+fieidid+"_"+rownum+i).parent(".field_upload_entryBorder").children(".field_upload_entry").clone();
			var $file = $("#file"+fieidid+"_"+rownum+i);
			$file.attr("name","file"+fieidid+i);
			$file.attr("id","file"+fieidid+i);
			var $entryDelete = $("<div class=\"field_upload_DeleteBtn\"></div>");
			$attach_upload_entryborder.append($field_upload_entry).append($entryDelete).append($file);
			$("#photoBorder"+fieidid).before($attach_upload_entryborder);
			$entryDelete.click(function(){
				//$(this).parent().remove();
				$(this).parent().addClass("entrydel");
			});
		}
		$("#photoField"+fieidid).val(temp+","+fieidid);
		$("#field"+fieidid).val($("#field"+fieidid+"_"+rownum).val());
		Mobile_NS.groupViewImg();	
	}
	
	//附件添加行，确定(附件)
	function doaddattachobj(fieidid,rownum){
		var $entryWrap = $("#entryWrap"+fieidid+"_"+rownum);
		var temp = 0;
		$("input[type='file']", "#entryWrap"+fieidid).each(function(){
			if($(this).attr("fileNum") > temp){
				temp = $(this).attr("fileNum");
			}
		});
		
		for(var i = 1;  i <= temp; i++){
			var $field_upload_entry = $("#file"+fieidid+i).parent(".attach_upload_entryborder").children(".attach_upload_entry");
			var $file = $("#file"+fieidid+i);
			$file.attr("name","file"+fieidid+"_"+rownum+i);
			$file.attr("id","file"+fieidid+"_"+rownum+i);
			$file.attr("isold","1");
			var $attach_upload_entryborder = $("<div class=\"attach_upload_entryborder\"></div>");
			$attach_upload_entryborder.append($field_upload_entry).append($file).append("<div id=\"addfile"+fieidid+"_"+rownum+i+"\"></div>");
			$entryWrap.append($attach_upload_entryborder);
		}
		var $fieldobj = $("#field"+fieidid);
			$fieldobj.attr("name","field"+fieidid+"_"+rownum);
			$fieldobj.attr("id","field"+fieidid+"_"+rownum);
		var $photoField = $("#photoField"+fieidid);
			$photoField.attr("name","photoField"+fieidid+"_"+rownum);
			$photoField.attr("id","photoField"+fieidid+"_"+rownum);
			$photoField.val(temp+","+fieidid+"_"+rownum);
		$entryWrap.append($fieldobj).append($photoField);	
	}
	
	//附件添加行，确定(图片)
	function doaddimgobj(fieidid,rownum){
		var $entryWrap = $("#entryWrap"+fieidid+"_"+rownum);
		var temp = 0;
		$("input[type='file']", "#entryWrap"+fieidid).each(function(){
			if($(this).attr("fileNum") > temp){
				temp = $(this).attr("fileNum");
			}
		});
		
		for(var i = 1;  i <= temp; i++){
			var $field_upload_entry = $("#file"+fieidid+i).parent(".field_upload_entryBorder").children(".field_upload_entry");
			var $file = $("#file"+fieidid+i);
			$file.attr("name","file"+fieidid+"_"+rownum+i);
			$file.attr("id","file"+fieidid+"_"+rownum+i);
			$file.attr("isold","1");
			var $attach_upload_entryborder = $("<div class=\"field_upload_entryBorder\"></div>");
			$attach_upload_entryborder.append($field_upload_entry).append($file).append("<div id=\"addfile"+fieidid+"_"+rownum+i+"\"></div>");
			$entryWrap.append($attach_upload_entryborder);
		}
		var $fieldobj = $("#field"+fieidid);
			$fieldobj.attr("name","field"+fieidid+"_"+rownum);
			$fieldobj.attr("id","field"+fieidid+"_"+rownum);
		var $photoField = $("#photoField"+fieidid);
			$photoField.attr("name","photoField"+fieidid+"_"+rownum);
			$photoField.attr("id","photoField"+fieidid+"_"+rownum);
			$photoField.val(temp+","+fieidid+"_"+rownum);
		$entryWrap.append($fieldobj).append($photoField);	
	}
	
	//附件编辑行，确定(附件)
	function doeditattachobj(fieidid,rownum){
		$(".entrydel").remove();
		$("#field"+fieidid+"_"+rownum).remove();
		$("#entryWrap"+fieidid+"_"+rownum).children().remove();
		//已经存在的附件
		var $entryWrap = $("#entryWrap"+fieidid+"_"+rownum);
		$("#entryWrap"+fieidid+" a").each(function(){
			var $attach_upload_entryborder =$("<div class=\"attach_upload_entryborder\"></div>");
			$attach_upload_entryborder.append($(this));
			$entryWrap.append($attach_upload_entryborder);
		});
		
		//添加的附件
		var temp = 0;
		$("input[type='file']", "#entryWrap"+fieidid).each(function(){
			if($(this).attr("fileNum") > temp){
				temp = $(this).attr("fileNum");
			}
		});
		
		for(var i = 1;  i <= temp; i++){
			var $field_upload_entry = $("#file"+fieidid+i).parent(".attach_upload_entryborder").children(".attach_upload_entry");
			var $file = $("#file"+fieidid+i);
			$file.attr("name","file"+fieidid+"_"+rownum+i);
			$file.attr("id","file"+fieidid+"_"+rownum+i);
			$file.attr("isold","1");
			var $attach_upload_entryborder = $("<div class=\"attach_upload_entryborder\"></div>");
			$attach_upload_entryborder.append($field_upload_entry).append($file).append("<div id=\"addfile"+fieidid+"_"+rownum+i+"\"></div>");
			$entryWrap.append($attach_upload_entryborder);
		}
		
		var $fieldobj = $("#field"+fieidid);
			$fieldobj.attr("name","field"+fieidid+"_"+rownum);
			$fieldobj.attr("id","field"+fieidid+"_"+rownum);
		var $photoField = $("#photoField"+fieidid);
			$photoField.attr("name","photoField"+fieidid+"_"+rownum);
			$photoField.attr("id","photoField"+fieidid+"_"+rownum);
			$photoField.val(temp+","+fieidid+"_"+rownum);
		$entryWrap.append($fieldobj).append($photoField);
	}
	
	//附件编辑行，确定(图片)
	function doeditimgobj(fieidid,rownum){
		$(".entrydel").remove();
		$("#field"+fieidid+"_"+rownum).remove();
		$("#entryWrap"+fieidid+"_"+rownum).children().remove();
		//已经存在的附件
		var $entryWrap = $("#entryWrap"+fieidid+"_"+rownum);
		$("#entryWrap"+fieidid+" img").each(function(){
			if(typeof($(this).attr("docid"))!="undefined"){
				var $attach_upload_entryborder = $("<div class=\"field_upload_entryBorder\"></div>");
				var $field_upload_entry = $("<div class=\"field_upload_entry\"></div>");
				$field_upload_entry.append($(this));
				$attach_upload_entryborder.append($field_upload_entry);
				$entryWrap.append($attach_upload_entryborder);
			}
		});
		
		//添加的附件
		var temp = 0;
		$("input[type='file']", "#entryWrap"+fieidid).each(function(){
			if($(this).attr("fileNum") > temp){
				temp = $(this).attr("fileNum");
			}
		});
		
		for(var i = 1;  i <= temp; i++){
			var $field_upload_entry = $("#file"+fieidid+i).parent(".field_upload_entryBorder").children(".field_upload_entry");
			var $file = $("#file"+fieidid+i);
			$file.attr("name","file"+fieidid+"_"+rownum+i);
			$file.attr("id","file"+fieidid+"_"+rownum+i);
			$file.attr("isold","1");
			var $attach_upload_entryborder = $("<div class=\"field_upload_entryBorder\"></div>");
			$attach_upload_entryborder.append($field_upload_entry).append($file).append("<div id=\"addfile"+fieidid+"_"+rownum+i+"\"></div>");
			$entryWrap.append($attach_upload_entryborder);
		}
		var $fieldobj = $("#field"+fieidid);
			$fieldobj.attr("name","field"+fieidid+"_"+rownum);
			$fieldobj.attr("id","field"+fieidid+"_"+rownum);
		var $photoField = $("#photoField"+fieidid);
			$photoField.attr("name","photoField"+fieidid+"_"+rownum);
			$photoField.attr("id","photoField"+fieidid+"_"+rownum);
			$photoField.val(temp+","+fieidid+"_"+rownum);
		$entryWrap.append($fieldobj).append($photoField);
	}
	
	//附件编辑行，取消(附件)
	function addRowbacktoattach(fieidid,rownum){
		var temp = 0;
		$("input[type='file'][isold='1']", "#entryWrap"+fieidid).each(function(){
			if($(this).attr("fileNum") > temp){
				temp = $(this).attr("fileNum");
			}
			var fileNum = $(this).attr("fileNum");
			var $file = $("#file"+fieidid+fileNum);	
			$file.attr("name","file"+fieidid+"_"+rownum+fileNum);
			$file.attr("id","file"+fieidid+"_"+rownum+fileNum);
			var $addfile = $("#addfile"+fieidid+"_"+rownum+fileNum);
			$addfile.before($file);
		});
		var $photoField = $("#photoField"+fieidid);
				$photoField.attr("name","photoField"+fieidid+"_"+rownum);
				$photoField.attr("id","photoField"+fieidid+"_"+rownum);
				$photoField.val(temp+","+fieidid+"_"+rownum);
	}
	
	//附件编辑行，取消(图片)
	function addRowbacktoimg(fieidid,rownum){
		var temp = 0;
		$("input[type='file'][isold='1']", "#entryWrap"+fieidid).each(function(){
			if($(this).attr("fileNum") > temp){
				temp = $(this).attr("fileNum");
			}
			var fileNum = $(this).attr("fileNum");
			var $file = $("#file"+fieidid+fileNum);	
			$file.attr("name","file"+fieidid+"_"+rownum+fileNum);
			$file.attr("id","file"+fieidid+"_"+rownum+fileNum);
			var $addfile = $("#addfile"+fieidid+"_"+rownum+fileNum);
			$addfile.before($file);
		});
		var $photoField = $("#photoField"+fieidid);
				$photoField.attr("name","photoField"+fieidid+"_"+rownum);
				$photoField.attr("id","photoField"+fieidid+"_"+rownum);
				$photoField.val(temp+","+fieidid+"_"+rownum);
	}
	
	var isBeScrolling = false;
	function openDetail(url){
		if(isBeScrolling){
			return;
		}
		if(_top && typeof(_top.openUrl) == "function"){
			_top.openUrl(url);
		}else{
			location.href = url;
		}
	}
	
	function onBack(){
		if(_top && typeof(_top.backPage) == "function"){
			_top.backPage();
		}
	}
	
	var pageIndex=<%=pageIndex%>;
	var totalPageCount=<%=totalPageCount%>;
	var fieldsJsonArray = [];
	$(document).ready(function(){
		//新建编辑时，给必填字段添加一个标记
		<%if(uitype == 0 || uitype == 2){%>
			$("input[ismust='true']").each(function(){
				if($(this).parents("tr").find(".field_label").length > 0){
					$(this).parents("tr").find(".field_label").addClass("isManPrompt");
				}else{
					$(this).parents("tr").find(".field_label_colspan").addClass("isManPrompt");
				}
				var id = $(this).attr("id");
				fieldsJsonArray.push(id);
			});
			$("select[ismust='true']").each(function(){
				$(this).parents("tr").find(".field_label").addClass("isManPrompt");
				var id = $(this).attr("id");
				fieldsJsonArray.push(id);
			});
			$("textarea[ismust='true']").each(function(){
				$(this).parents("tr").find(".field_label_colspan").addClass("isManPrompt");
				var id = $(this).attr("id");
				fieldsJsonArray.push(id);
			});
		<%}%>
		
		// 新建布局，字段默认值联动
		<%if(uitype == 0){%>
			defaultValueLinkage();
		<%}%>  

	   $("#moreListData").click(function(){
			if(pageIndex<totalPageCount){
				if(typeof(_top.lockPage) == "function"){
					_top.lockPage();
				}
				showLoader();
				
				var locationSearch = location.search;
				if(locationSearch.indexOf("?") > -1) {  
					locationSearch = locationSearch.substring(1,locationSearch.length);
				}
				var requestParams = "action=getListData&uiid=<%=appFormUI.getId()%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>&pageSize=<%=pageSize%>&pageIndex=" +(pageIndex+1);
				if(locationSearch != ""){
					requestParams += "&"+locationSearch;
				} 
				var url = jionActionUrl("com.weaver.formmodel.ui.servlet.WebUIViewAction",requestParams);
				$.post(url, null,
	  				function(data){
						pageIndex+=1;
						if(pageIndex==totalPageCount){
							$("#moreListData").hide();
						}
						$("#myPage").trigger("create");
						var $listContainer = $("#frmmain > ul");
						var $pageObj = $(data)
						$listContainer.append($pageObj);
				        $listContainer.listview('refresh');
				        hideLoader();
				        $("img.lazy", $pageObj).lazyload({
							container : "#myPage"
						});
				        //refreshIScroll();
				        
				        if(parent && typeof(parent.changeFrameHeightByScrollHeight) == "function"){
				        	parent.changeFrameHeightByScrollHeight();
				        }else{
				        	if(_top && typeof(_top.resetActiveFrame) == "function"){
								_top.resetActiveFrame();
							}
				        }
						
						//触发查询
						var $searchText = $listContainer.prev().find("input[data-type='search']");
						if($searchText.val() != ""){
							$searchText.attr("data-lastval", "");
							$searchText.keyup();
						}
						
						if(typeof(_top.lazyReleasePage) == "function"){
				    		_top.lazyReleasePage();
				    	}
				    	
				    	Mobile_NS.groupViewImg();
	  				});
			}					
	    });	    
	   
		<%if(uitype == 3 && !btnResoucesList.isEmpty()){ //列表扩展按钮%>   
			var $uiFilterable = $('ul').prev();
			var $listSearchContainer = $uiFilterable.find("div.ui-input-search");
		  
			var $expandBtnDiv = $("div.expandBtnDiv");
			var aw = $expandBtnDiv.outerWidth(true);
			
			$listSearchContainer.width($listSearchContainer.width() - (aw+10));
			
			$uiFilterable.append($expandBtnDiv);
			
			<%if(btnResoucesList.size() > 1){%>
				var $expandBtnDivMore = $("div.expandBtnDivMore");
				
				var at = $expandBtnDiv.offset().top + $expandBtnDiv.height();
				$expandBtnDivMore.css("top", (at+3));
				
				$("div.expandBtnDiv .moreFlag").click(function(){
					$expandBtnDivMore.slideToggle(0);
				});
			<%}%>
		<%}%>
		
		Mobile_NS.groupViewImg();
		
		$("img.lazy").lazyload({
			container : "#myPage"
		});
		
		var currYear = (new Date()).getFullYear();	
		var opt={};
		opt.date = {preset : 'date'};
		opt.datetime = {preset : 'datetime'};
		opt.time = {preset : 'time'};
		opt.default = {
			theme: 'android-ics light', //皮肤样式
	        display: 'modal', //显示方式 
	        mode: 'scroller', //日期选择模式
	        dateFormat : "yy-mm-dd",
			lang:'zh',
	        startYear:currYear - 50, //开始年份
	        endYear:currYear + 50 //结束年份
		};
		var optCurrDate = $.extend(opt['date'], opt['default']);
		$(".dateStyle").mobiscroll(optCurrDate).date(optCurrDate);
		var optCurrTime = $.extend(opt['time'], opt['default']);
		$(".timeStyle").mobiscroll(optCurrTime).time(optCurrTime);
		
		$(".field_inputTime").each(function(){
			if($(this).val() != ""){
				var fieldid = $(this).attr("fieldid");
				$("#fieldSub"+fieldid).click(function(e){
					e.stopPropagation();
					var fieldval = $("#field"+fieldid).val();
					if(fieldval && fieldval != ""){
						$("#field"+fieldid).val("");
						$(this).hide();
						$(this).unbind();
					}
				}).show();
			}
		});
		
		//去掉明细水平滚动条样式，不然导致iPhone6，显示不全
		$(".divoverflow").each(function(){
			var $table = $(this).children("table");
			if($table.width() <= $(this).width()){
				$(this).css("overflow", "hidden");
			}
		});
	});
	
	// 字段联动-浏览按钮
	function fieldBrowserLinkfn(groupid){
		var $objs;
		if(groupid != undefined){
			var $container = $("#detaildiv"+groupid);
			$objs = $("input[bid]", $container);
		}else{
			$objs = $("input[bid]");
		}
		$objs.each(function(){
			var that = this;
			
			var browserid = $(that).attr("name").split("field")[1];
			var idValue = $(that).val();
			
			if(idValue != ""){
				var nameValue = "";
				var $span = $("#field"+browserid+"span");
				var $label = $span.find("label");
				if(!!$label){
					nameValue = $label.html();
				}else{
					nameValue = $span.html();
				}
				
				var rtt = {"name" : nameValue, "value" : idValue};
				readyToTrigger(browserid, rtt);
			}
			
		});
	}

	// 字段联动-选择框
	function fieldLinkfn(obj){
		var $this = $(obj);
		var value = $this.val();
		if(value != ""){
			var fieldid = $this.attr("id").substring(5);
			var text = $this.find("option:selected").text();
			var result = {"name" : text, "value" : value};
			readyToTrigger(fieldid, result);//触发联动
		}
	}
	
	function jionActionUrl(invoker, queryStr){
		if(!queryStr){
			queryStr = "";
		}
		if(queryStr.indexOf("&") != 0){
			queryStr = "&" + queryStr;
		}
		return "/mobilemode/Action.jsp?invoker=" + invoker + queryStr;
	}
	
	// 布局页面日期字段清空方法
	function showClearBtn(fieldid){
		var $clearBtn = $("#fieldSub"+fieldid);
		$clearBtn.show();
		$clearBtn.click(function(e){
			e.stopPropagation();
			var fieldval = $("#field"+fieldid).val();
			if(fieldval && fieldval != ""){
				$("#field"+fieldid).val("");
				$clearBtn.hide();
				$clearBtn.unbind();
			}
		});
	}
	
	

	
	
	if(typeof(Mobile_NS) == 'undefined'){
		Mobile_NS = {};
	}

	Mobile_NS.groupViewImg = function(source){
		$("img[data-groupid]").each(function(){
			var that = this;
			var hasEvent = $(that).attr("data-groupev") == "true";
			if(!hasEvent){
				$(that).attr("data-groupev", "true");
				$(that).click(function(e){
					var groupid = $(this).attr("data-groupid");
					var currSrc = $(this).attr("src");
					
					var imgSrcs = "";
					$("img[data-groupid='"+groupid+"']").each(function(){
						var src = $(this).attr("src");
						imgSrcs += src + "|";
					});
					if(imgSrcs != ""){
						imgSrcs = imgSrcs.substring(0, imgSrcs.length - 1);
					}
					
					imgSrcs = encodeURIComponent(imgSrcs);
					currSrc = encodeURIComponent(currSrc);
					var url = "/mobilemode/displayPicOnMobile.jsp?imgSrc="+imgSrcs+"&imgSrcActive="+currSrc+"&1=1";
					openDetail(url);
					
					e.stopPropagation();
				});
			}
		});
	};
</script>
<script>
<%=uiview.getResScript()%>
</script>
<style>
	
</style>
</HEAD>
<body>
<div data-role="page" id="myPage" data-dom-cache="true">

<%if(isUseIScroll){ %>
<div id="scroll_wrapper">
	<div id="scroll_scroller">
		<%if(!disableDownRefresh){%>
			<div id="pullDown">
				<span class="pullDownIcon"></span><span class="pullDownLabel">下拉刷新</span>
			</div>
		<%} %>
<!-- 滚动条包裹区域 (start)-->		
<%} %>

<%if(uitype == 3 && !btnResoucesList.isEmpty()){ //列表扩展按钮
	WebUIResouces f_btnResouces = btnResoucesList.get(0);
	String className = btnResoucesList.size() > 1 ? " expandBtnDivHasMore" : "";
%>
	<div class="expandBtnDiv<%=className%>">
		<div class="text" onclick="javascript:openDetail('<%=f_btnResouces.getResourceContent()%>');"><%=f_btnResouces.getResourceName() %></div>
		<div class="moreFlag"></div>
	</div>
	
	<%if(btnResoucesList.size() > 1){%>
		<div class="expandBtnDivMore">
			<ul>
				<%for(int i = 1; i < btnResoucesList.size(); i++){
					WebUIResouces btnResouces = btnResoucesList.get(i);
				%>
					<li onclick="javascript:openDetail('<%=btnResouces.getResourceContent()%>');"><%=btnResouces.getResourceName() %></li>
				<%} %>
			</ul>
		</div>
	<%} %>
<%} %>

<form  name=frmmain id=frmmain method="post" enctype="multipart/form-data">
<div id="uploaddiv"></div>
<%=uiview.getUiContent()%>

<div style="display: none;">
	<input type=hidden name=formmodeid id="formmodeid" value="<%=modelid%>">
	<input type=hidden name=billid id="billid" value="<%=billid%>">
	<input type=hidden name="client" id="client" value="mobile">
	<input type=hidden name=appid id="appid" value="<%=appid%>">
	<input type=hidden name=uiid id="uiid" value="<%=uiid%>">
	<input type=hidden name="isShowInTab" id="isShowInTab" value="<%=isShowInTabV%>">
	<%=uiview.getHiddenContent() %>
</div>
<%
if(uitype!=3) {
	AppFormUI appFormUIEdit=mobileAppUIManager.getFormUI(appFormUI,2);
	String edituuid = "";
	if(appFormUIEdit!=null){
		edituuid = ""+appFormUIEdit.getId();
	}
JSONArray promptFieldArr = FormInfoService.getPromptFieldWithJSON(formid);
%>
<script type="text/javascript">
var formId = "<%=formid%>";
var dataId = "<%=billid%>";
var promptFieldArr = <%=promptFieldArr.toString()%>;	
function onSave(obj){
	var showIsMan = "";
	for(var k = 0; fieldsJsonArray && k < fieldsJsonArray.length; k++){
   		var v_fieldid = fieldsJsonArray[k];
   		v_fieldid = v_fieldid.replace("field", "");
		if($("#field"+v_fieldid).val() == ""){
			//图片、附件
			var photovalue = $("#photoField"+v_fieldid).val();
	   		if(photovalue==null||photovalue=="0"){
	   			showIsMan += ($("#field"+v_fieldid).parents("tr").find(".isManPrompt").text()+"\n");
	   		}
		}
   	}
   	if(showIsMan != ""){
   		alert("以下必填项未填写：\n"+showIsMan);
   		return;
   	}
	var submitClass = "form_buttonStyle_onsubmit";
	if(obj.className.indexOf(submitClass) == -1){
		$(obj).addClass("form_buttonStyle_onsubmit");
		//判断字段唯一性
		$(".promptValidateFail").removeClass("promptValidateFail");
		var changedFiledInfo = [];
		for(var i = 0; i < promptFieldArr.length; i++){
			var promptField = promptFieldArr[i];
			promptField["checkStatus"] = "true";
			var fieldInfo = promptField["fieldInfo"];
			var fieldElement = getFieldElement(fieldInfo); //获取相应的字段元素
			if(!fieldElement){	//字段在页面中不存在,或者这种字段类型暂时不做唯一性验证
				continue;
			}
			var isChanged = fieldIsChanged(fieldElement);	//判断该元素值是否有被改变过
			if(isChanged){
				var v = getFieldValue(fieldInfo);
				promptField["val"] = v;
				if(v){	//此处值判断一来是判断防止程序出现未期值，更重要的目的是过滤掉如果改变为空值的情况将不参与唯一性验证
					changedFiledInfo.push({"fieldid":fieldInfo["id"], "fieldname":fieldInfo["fieldname"], "changedValue":v});
				}					
			}
		}
		if(changedFiledInfo.length > 0){	//有需要唯一性验证的改变数据的字段
			//createLoadingTip();
			var jsonstr = JSON.stringify(changedFiledInfo);
			var paramData = {"data":encodeURI(jsonstr), "formId":formId, "dataId":dataId};
			var url = jionActionUrl("com.weaver.formmodel.data.servlet.BusinessDataAction", "action=validatePromptFieldData");
			$.post(url,paramData,function (res) {
					res = eval("(" + res + ")");
			    	//dropLoadingTip();
			    	for(var i = 0; res && i < res.length; i++){
			    		var r_fieldid = res[i]["fieldid"];
			    		var r_dcount = res[i]["dcount"];
			    		if(r_dcount > 0){
			    			//此处统一更改集合中的状态，提示啥的再后面统一做，代码剥离
			    			for(var j = 0; j < promptFieldArr.length; j++){
								var promptField = promptFieldArr[j];
								var fieldInfo = promptField["fieldInfo"];
								var p_fieldid = fieldInfo["id"];
								if(r_fieldid == p_fieldid){
									promptField["checkStatus"] = "false";
									break;
								}
							}
			    		}
			    	}
			    	
			    	//验证加提醒
			    	var isSuccess = true;
			    	var fieldTipHtml = "";
			    	for(var i = 0; i < promptFieldArr.length; i++){
			    		var promptField = promptFieldArr[i];
			    		if(promptField["checkStatus"] == "false"){
			    			isSuccess = false;
			    			
			    			var fieldInfo = promptField["fieldInfo"];
							var fieldElement = getFieldElement(fieldInfo); //获取相应的字段元素
							var $p_td = $(fieldElement).parent("td");
							$p_td.addClass("promptValidateFail");
							
							fieldTipHtml += "【"+fieldInfo["labelName"]+"：\""+promptField["val"]+"\"】,";
			    		}
			    	}
	
			    	if(isSuccess){

						var b_flag = true;
			    		if(typeof(beforeOnSave) == "function"){
			    			b_flag = beforeOnSave();
			    		}
			    		if(b_flag){
			    			document.frmmain.action = jionActionUrl("com.weaver.formmodel.data.servlet.BusinessDataAction", "action=create");
							document.frmmain.submit();
			    		}

			    	}else{	//有字段数据违反了唯一性验证
			    		$(obj).removeClass("form_buttonStyle_onsubmit");
			    		var msg = "";
						msg += "您录入的";
						msg += fieldTipHtml.substring(0,fieldTipHtml.length-1);
						msg += "已存在，违反了唯一性验证，请重新录入";
						alert(msg);
			    	}
			    });
		}else{
			var b_flag = true;
    		if(typeof(beforeOnSave) == "function"){
    			b_flag = beforeOnSave();
    		}
    		if(b_flag){
    			document.frmmain.action = jionActionUrl("com.weaver.formmodel.data.servlet.BusinessDataAction", "action=create");
				document.frmmain.submit();
    		}
		}
	}
}

function onEdit(){
	location.href="/mobilemode/formbaseview.jsp?uiid=<%=edituuid%>&billid=<%=billid%>";
}
function onDelete(){
	document.frmmain.action =  jionActionUrl("com.weaver.formmodel.data.servlet.BusinessDataAction", "action=delete");
	document.frmmain.submit();
}
function doInterfacesAction(interfaceurl, openurl){
	var url = jionActionUrl("com.weaver.formmodel.data.servlet.BusinessDataAction", "action=doInterfacesAction");
	jQuery.ajax({
		url : url,
		type : "get",
		processData : false,
		data : interfaceurl+"&billid=<%=billid%>",
		dataType : "text",
		async : true,//改为异步
		success: function do4Success(msg){}
	});
	jsORopenUrl(openurl);
}
function jsORopenUrl(url){
	url = decodeURIComponent(url);
	if(url.substring(0,11) == "javascript:"){
		eval(url.substring(11));
	}else{
		openDetail(url);
	}
}
function dodetailcheck(){
	var e=event || window.event;
    if (e && e.stopPropagation){
        e.stopPropagation();    
    }
    else{
        e.cancelBubble=true;
    }
}

function adddetailshow(groupid){
	var $addtable = $("#addtable"+groupid);
	$addtable.show();
	setTimeout(function(){
		$(".addtableMask", $addtable).addClass("show");
		$(".addtableInner", $addtable).removeClass("hide");
	}, 10);
}

function showafter(groupid){
	var $addtable = $("#addtable"+groupid);
	<%if(uitype == 0 || uitype == 2){%>
		$("#addtable"+groupid).find("input[ismust='true']").each(function(){
			if($(this).parents("tr").find(".field_label").length > 0){
				$(this).parents("tr").find(".field_label").addClass("isManPrompt");
			}else{
				$(this).parents("tr").find(".field_label_colspan").addClass("isManPrompt");
			}
		});
		$("#addtable"+groupid).find("select[ismust='true']").each(function(){
			$(this).parents("tr").find(".field_label").addClass("isManPrompt");
		});
		$("#addtable"+groupid).find("textarea[ismust='true']").each(function(){
			$(this).parents("tr").find(".field_label").addClass("isManPrompt");
		});
		
		var currYear = (new Date()).getFullYear();	
		var opt={};
		opt.date = {preset : 'date'};
		opt.datetime = {preset : 'datetime'};
		opt.time = {preset : 'time'};
		opt.default = {
			theme: 'android-ics light', //皮肤样式
	        display: 'modal', //显示方式 
	        mode: 'scroller', //日期选择模式
	        dateFormat : "yy-mm-dd",
			lang:'zh',
	        startYear:currYear - 10, //开始年份
	        endYear:currYear + 10 //结束年份
		};
		var optCurrDate = $.extend(opt['date'], opt['default']);
		$("#addtable"+groupid).find(".dateStyle").mobiscroll(optCurrDate).date(optCurrDate);
		var optCurrTime = $.extend(opt['time'], opt['default']);
		$("#addtable"+groupid).find(".timeStyle").mobiscroll(optCurrTime).time(optCurrTime);
		
		$("#addtable"+groupid).find(".field_inputTime").each(function(){
			if($(this).val() != ""){
				var fieldid = $(this).attr("fieldid");
				$("#fieldSub"+fieldid).click(function(e){
					e.stopPropagation();
					var fieldval = $("#field"+fieldid).val();
					if(fieldval && fieldval != ""){
						$("#field"+fieldid).val("");
						$(this).hide();
						$(this).unbind();
					}
				}).show();
			}
		});
		$addtable.trigger("create");
	<%}%>
}

function replaceGN(s){
	return s.replace(/\n/g,"<BR>").replace(/\r/g,"<BR>");
}

function adddetailhide(groupid){
	var $table = $("#divoverflow"+groupid).children("table");
	if($table.width() > $("#divoverflow"+groupid).width()){
		$("#divoverflow"+groupid).css("overflow", "auto");
	}
		
	var $addtable = $("#addtable"+groupid);
	$(".addtableMask", $addtable).removeClass("show");
	$(".addtableInner", $addtable).addClass("hide");
	setTimeout(function(){
		$addtable.hide();
	}, 300);
	$("#addrowindex"+groupid).val("");
}
</script>
<div class="footerBtnContainer">
	<%if(uitype==1&&isEdit){%>
	<div class="form_buttonStyle  form_buttonStyle_edit" onclick="onEdit()">编辑</div>
	<%}      
	if(uitype==0||uitype==2){%>
	<div class="form_buttonStyle  form_buttonStyle_edit" onclick="onSave(this)">提交</div>
	<%}
	if((uitype==1||uitype==2)&&isDel){%>
	<div class="form_buttonStyle  form_buttonStyle_delete" onclick="onDelete()">删除</div>
	<%}%>
	<%
		for(WebUIResouces btnResouces : btnResoucesList){
			String resourceContent = "";
			try {
				resourceContent = URLEncoder.encode(btnResouces.getResourceContent().trim(), "UTF-8").replaceAll("\\+","%20");
			} catch (Exception e) {
				e.printStackTrace();
			}
			if(btnResouces.getInterfaceUrl() == null){
			%>
				<div class="form_buttonStyle  form_buttonStyle_delete" onclick="javascript:jsORopenUrl('<%=resourceContent%>');"><%=btnResouces.getResourceName() %></div>
			<%		
			}else{
			%>
				<div class="form_buttonStyle  form_buttonStyle_delete" onclick="doInterfacesAction('<%=btnResouces.getInterfaceUrl()%>','<%=resourceContent%>');"><%=btnResouces.getResourceName() %></div>
			<%	
			}
		}
	%>
</div>
<%}else{%>
	<% if(totalSize==0){ %>
		<div  class="nodata_border"><div class="nodata_content"><div class="nodata_img"></div>没有可显示的数据</div></div>
	<% }else if(totalPageCount>1){ %>
		<a href="javascript:void(0);" data-role="button" data-corners="true" id="moreListData" >加载更多</a>
	<% } %>
<%}%>
</form>

<%if(isUseIScroll){ %>
<!-- 滚动条包裹区域 (end)-->	
	</div>
</div>
<%} %>

</div>
</body>
</html>