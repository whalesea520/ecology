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
<%@page import="com.weaver.formmodel.data.manager.ThreadLocalPageModel"%>
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
<%@page import="com.weaver.formmodel.mobile.utils.UIParser"%>
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
int modelid = NumberHelper.string2Int(request.getParameter("modeId"),0);
int formid = NumberHelper.string2Int(request.getParameter("formId"),0);

String sqlwhere=StringHelper.null2String(request.getParameter("sqlwhere"));

int isdeleted = NumberHelper.string2Int(request.getParameter("isdeleted"),0);
if(isdeleted == 1){
	String script = "<script>" +
			"if(top && typeof(top.backPage) == \"function\"){" +
			"	top.backPage();" +
			"}"+
			"</script>";
	out.print(script);
	return;
}

MobileAppUIManager mobileAppUIManager = MobileAppUIManager.getInstance();

//String clienttype = StringHelper.null2String(request.getParameter("clienttype"));	//当前访问客户端类型 可能的值：Webclient|iphone|ipad|Android
ClientType clienttype = MobileCommonUtil.getClientType(request);
int mobiledeviceid = MobiledeviceManager.getInstance().getDeviceByClienttype(clienttype);

//获取布局模板内容
String uicontent=mobileAppUIManager.getDefaultTemplate(modelid,formid,1);
String uitemplate = UIParser.formatUIContent(uicontent);

//AppFormUI appFormUI = mobileAppUIManager.getByIdAndDeviceid(0, mobiledeviceid);
AppFormUI appFormUI = new AppFormUI();
appFormUI.setKeyfield("id");
appFormUI.setFormId(formid);
appFormUI.setUiContent(uicontent);
appFormUI.setUiTemplate(uitemplate);
appFormUI.setMobiledeviceid(mobiledeviceid);
appFormUI.setUiType(1);

int appid = 0;
int uitype = 1;//0：新建、1：查看、2：编辑、3：列表

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
WebUIView uiview = WebUIManager.getInstance().getViewContentBroswer(uiContext);
int totalPageCount = 0;
int totalSize=0;
PageModel pageModel=null;
if(uitype==3){
	pageModel = ThreadLocalPageModel.getPageModel();
	ThreadLocalPageModel.destory();
}

if(pageModel!=null){
	totalPageCount = pageModel.getTotalPageCount();
	totalSize=pageModel.getTotalSize();
}

int isShowInTabV = NumberHelper.string2Int(request.getParameter("isShowInTab"), 0);
boolean isShowInTab = isShowInTabV == 1;

List<WebUIResouces> btnResoucesList = uiview.getButtonPageResources();
boolean isUseIScroll = (uitype == 3);
//boolean isUseIScroll = true;
boolean disableDownRefresh = ((uitype == 3) ? false : true);
%>

<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
	<title><%=uiview.getUiTitle() %></title>
	<link rel="stylesheet" href="/mobilemode/jqmobile4/css/themes/default/jquery.mobile-1.4.0.min_wev8.css">
	<link rel="stylesheet" href="/mobilemode/css/formbase_wev8.css?v=2015102201">
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
<script type="text/javascript" src="/mobilemode/js/browser_wev8.js?v=201510181815"></script>
<script type="text/javascript" src="/mobilemode/js/fieldsLinkage_wev8.js?v=201510181815"></script>
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
		location.href = "/download.do?fileid="+fileid+"&module=3&scope=11&filename="+encodeURI(filename)+"";
		top.hideLoading();
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
		if(top && typeof(top.registUploadWindow) == "function"){
			top.registUploadWindow(window);
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
				refreshIScroll();
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
				if(filetype == "jpg" || filetype == "jpeg" || filetype == "png" || filetype == "gif" || filetype == "bmp") {
					imagesrc = "/mobilemode/images/icon/jpg_wev8.png";
				}else if(filetype == "doc" || filetype == "docx") {
					imagesrc = "/mobilemode/images/icon/doc_wev8.png";
				}else if(filetype == "xls" || filetype == "xlsx") {
					imagesrc = "/mobilemode/images/icon/xls_wev8.png";
				}else if(filetype == "pdf") {
					imagesrc = "/mobilemode/images/icon/pdf_wev8.png";
				}else if(filetype == "htm" || filetype == "html") {
					imagesrc = "/mobilemode/images/icon/html_wev8.png";
				}else if(filetype == "ppt") {
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
	
	var isBeScrolling = false;
	function openDetail(url){
		if(isBeScrolling){
			return;
		}
		if(top && typeof(top.openUrl) == "function"){
			top.openUrl(url);
		}else{
			location.href = url;
		}
	}
	
	function onBack(){
		if(top && typeof(top.backPage) == "function"){
			top.backPage();
		}
	}
	
	var pageIndex=<%=pageIndex%>;
	var totalPageCount=<%=totalPageCount%>;
	var fieldsJsonArray = [];
	$(document).ready(function(){
		  
		
		Mobile_NS.groupViewImg();
		
		$("img.lazy").each(function(){
			$(this).attr("src",$(this).attr("data-original"));
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
		
	});
	
	// 字段联动-选择框
	function fieldLinkfn(obj){
		var $this = $(obj);
		var value = $this.val();
		if(value != ""){
			var fieldid = $this.attr("id");
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
	
	// 判断input框中是否输入的是小数,包括小数点
	/*
	 * p（精度） 指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。
	 * 
	 * s（小数位数） 指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <=
	 * p。最大存储大小基于精度而变化。
	 */
	function ItemDecimal_KeyPress(elementname,p,s)
	{
		var evt = getEvent();
		var keyCode = evt.which ? evt.which : evt.keyCode;
		tmpvalue = $GetEle(elementname).value;
	
	    var dotCount = 0;
		var integerCount=0;
		var afterDotCount=0;
		var hasDot=false;
	
	    var len = -1;
	    if(elementname){
			len = tmpvalue.length;
	    }
	
	    for(i = 0; i < len; i++){
			if(tmpvalue.charAt(i) == "."){ 
				dotCount++;
				hasDot=false;
			}else{
				if(hasDot==false){
					integerCount++;
				}else{
					afterDotCount++;
				}
			}		
	    }
	
	    if(!(((keyCode>=48) && (keyCode<=57)) || keyCode==46 || keyCode==45) || (keyCode==46 && dotCount == 1)){  
			if (evt.keyCode) {
		     	evt.keyCode = 0;evt.returnValue=false;     
		     } else {
		     	evt.which = 0;evt.preventDefault();
		     }
	    }
		if(integerCount>=p-s && hasDot==false && (keyCode>=48) && (keyCode<=57)){
			if (evt.keyCode) {
		     	evt.keyCode = 0;evt.returnValue=false;     
		     } else {
		     	evt.which = 0;evt.preventDefault();
		     }
		}
		if(afterDotCount>=s&&integerCount>=p-s){
			 if (evt.keyCode) {
		     	evt.keyCode = 0;evt.returnValue=false;     
		     } else {
		     	evt.which = 0;evt.preventDefault();
		     }
		}
		/* 新增 */
		var rtnflg = false;
		
		var cursorPosition = getCursortPosition($GetEle(elementname));
		var vidValue = $GetEle(elementname).value;
		var dotIndex = vidValue.indexOf(".");
		if (hasDot) {
			if (cursorPosition <= dotIndex) {
				if (integerCount >= (p - s)) {
					rtnflg = true;
				}
			} else {
				if(afterDotCount >= s) {
					rtnflg = true;
				}
			}
		}
		
		if (rtnflg) {
			if (evt.keyCode != undefined) {
				evt.keyCode = 0;
				evt.returnValue=false;     
			} else {
				evt.which = 0;
				evt.preventDefault();
			}
		}
	}
	
	function getEvent() {
		if (window.ActiveXObject) {
			return window.event;// 如果是ie
		}
		var func = getEvent.caller;
		while (func != null) {
			var arg0 = func.arguments[0];
			if (arg0) {
				if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
						|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
					return arg0;
				}
			}
			func = func.caller;
		}
		return null;
	}
	
	/**
	 * 根据标识（name或者id）获取元素，主要用于解决系统中很多元素没有id属性，
	 * 却在js中使用document.getElementById(name)来获取元素的问题。
	 * @param identity name或者id
	 * @return 元素
	 */
	function $GetEle(identity, _document) {
		var rtnEle = null;
		if (_document == undefined || _document == null) _document = document;
		
		rtnEle = _document.getElementById(identity);
		if (rtnEle == undefined || rtnEle == null) {
			rtnEle = _document.getElementsByName(identity);
			if (rtnEle.length > 0) rtnEle = rtnEle[0];
			else rtnEle = null;
		}
		return rtnEle;
	}
	
	/**
	 * 获取光标所在位置
	 */
	function getCursortPosition(inputElement) {
		var CaretPos = 0; 
		if (document.selection) {
			inputElement.focus();
			var Sel = document.selection.createRange();
			Sel.moveStart('character', -inputElement.value.length);
			CaretPos = Sel.text.length;
		} else if (inputElement.selectionStart || inputElement.selectionStart == '0') { //ff
			CaretPos = inputElement.selectionStart;
		}
		return (CaretPos);
	}
	
	function changeToNormalFormat(inputfieldname){
	    var sourcevalue = $GetEle(inputfieldname).value;
	    sourcevalue = sourcevalue.replace(/,/g,"");
	    $GetEle(inputfieldname).value = sourcevalue;
	}
	
	function changeToThousands(inputfieldname,qfws){
	    var sourcevalue = $GetEle(inputfieldname).value;
		var dlength =$GetEle(inputfieldname).getAttribute("datalength")
		if(0 < dlength && $GetEle(inputfieldname).getAttribute("datavaluetype") != "5"){
			sourcevalue = addZero(sourcevalue,dlength);
		}else if($GetEle(inputfieldname).getAttribute("datavaluetype") == "5"){
			sourcevalue = addZero(sourcevalue,qfws);
			sourcevalue=sourcevalue.replace(/\s+/g,""); 
			if(sourcevalue != ''){
				sourcevalue =commafy(sourcevalue);
			}
		}
	    $GetEle(inputfieldname).value = sourcevalue;
	}
	
	function addZero(aNumber,precision){
		if(aNumber==null || aNumber.trim()=="" || isNaN(aNumber))return "";
		var valInt = (aNumber.toString().split(".")[1]+"").length;
		if(valInt != precision){
		    var lengInt = precision-valInt;
			//判断添加小数位0的个数
			if(lengInt == 1){
				aNumber += "0";
			}else if(lengInt == 2){
				aNumber += "00";
			}else if(lengInt == 3){
				aNumber += "000";
			}else if(lengInt < 0){
				if(precision == 1){
					aNumber += ".0";
				}else if(precision == 2){
					aNumber += ".00";
				}else if(precision == 3){
					aNumber += ".000";
				}else if(precision == 4){
					aNumber += ".0000";
				}
				var ins = aNumber.toString().split(".");
				if(ins.length>2){
					aNumber = parseFloat(ins[0]+"."+ins[1]).toFixed(precision);
				}
			}		
		}
		return  aNumber;			
	}
	
	/**  
	 * 数字格式转换成千分位  
	 * @param{Object}num  
	 */  
	function commafy(num) { 
	 
		num = num + "";   
		num = num.replace(/[ ]/g, ""); //去除空格  
	 
	   if (num == "") {   
	       return;   
	    }   
	 
	    if (isNaN(num)){  
	    return;   
	   }   
	 
	   //2.针对是否有小数点，分情况处理   
	   var index = num.indexOf(".");   
	    if (index==-1) {//无小数点   
	      var reg = /(-?\d+)(\d{3})/;   
	       while (reg.test(num)) {   
	        num = num.replace(reg, "$1,$2");   
	        }   
	    } else {   
	        var intPart = num.substring(0, index);   
	       var pointPart = num.substring(index + 1, num.length);   
	       var reg = /(-?\d+)(\d{3})/;   
	      while (reg.test(intPart)) {   
	       intPart = intPart.replace(reg, "$1,$2");   
	       }   
	      num = intPart +"."+ pointPart;   
	   }   
	   
	   return num;  
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
	<input type=hidden name="isShowInTab" id="isShowInTab" value="<%=isShowInTabV%>">
	<%=uiview.getHiddenContent() %>
</div>
<%
if(uitype!=3) {}else{%>
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