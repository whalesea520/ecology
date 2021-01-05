<%@page import="weaver.systeminfo.systemright.CheckSubCompanyRight"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
if(!HrmUserVarify.checkUserRight("MobileModeSet:All", user)){
	return;
}
int defaultSubCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
if(mmdetachable.equals("1")){//开启移动建模分权
	if(defaultSubCompanyId==-1){
		defaultSubCompanyId =  Util.getIntValue(Util.null2String(session.getAttribute("mobilemode_defaultSubCompanyId")),-1);
	}
	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
	int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"MobileModeSet:All",0);
	if(defaultSubCompanyId!=-1){
		boolean subFlag = false;
		for(int i=0;i<mSubCom.length;i++){
			if(defaultSubCompanyId==mSubCom[i]){
				subFlag = true;
				break;
			}
		}
		if(!subFlag){
			session.removeAttribute("mobilemode_defaultSubCompanyId");
			defaultSubCompanyId = -1;
		}
	}
	if(defaultSubCompanyId==-1){
		for(int i=0;i<mSubCom.length;i++){
			if(mmdftsubcomid.equals(""+mSubCom[i])){
				defaultSubCompanyId = mSubCom[i];
				break;
			}
		}
		if(defaultSubCompanyId==-1&&mSubCom.length>0){
			defaultSubCompanyId = mSubCom[0];
		}
	}
	if(defaultSubCompanyId!=-1){
	 	session.setAttribute("mobilemode_defaultSubCompanyId",String.valueOf(defaultSubCompanyId));
	}
}
String userRightStr = "MobileModeSet:All";
int operatelevel = getCheckRightSubCompanyParam(userRightStr,user,mmdetachable ,defaultSubCompanyId);//权限等级-> 2完全控制 1 编辑 0 只读
MobileAppBaseManager mobileAppBaseManager=MobileAppBaseManager.getInstance();
JSONArray jsonArray=new JSONArray();
if(mmdetachable.equals("1")){
	jsonArray=mobileAppBaseManager.getAppBaseInfoWithJSONByParam(defaultSubCompanyId);
}else{
	jsonArray=mobileAppBaseManager.getAppBaseInfoWithJSON();
}

String rightframeurl=StringHelper.null2String(request.getParameter("rightframeurl"),"/mobilemode/appComponentlist.jsp");

%>
<html>
<head>
	<title></title>
	<script type="text/javascript" src="/formmode/js/jquery/pagination/jquery.pagination_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/jquery/hoverIntent/jquery.hoverIntent.minified_wev8.js"></script>

	<link rel="stylesheet" type="text/css" href="/formmode/css/leftPartTemplate_wev8.css" />
	<script type="text/javascript" src="/formmode/js/leftPartTemplate_wev8.js"></script>
	
	<script type="text/javascript" src="/formmode/js/jquery/contextMenu/jquery.contextMenu_wev8.js"></script>
	<link rel="stylesheet" type="text/css" href="/formmode/js/jquery/contextMenu/jquery.contextMenu_wev8.css"/>
	
	<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
	<script type="text/javascript" src="/js/nicescroll/jquery.nicescroll_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
	<style>
	html{
		background-color: #53A2E0;
	}
	body{
		overflow:hidden;
	}
	* {
		font-size: 12px;
		font-family: 'Microsoft Yahei', Arial;
	}
	input{outline:none}
	a:focus { outline: none; } 
	#leftPart{
		height: 100%;
		background-color: #53A2E0!important;
		position: relative;
		overflow: hidden;
	}
	.e8_left_top{
		position: relative;
		top: 0px;
		left: 0px;
		padding: 10px 15px 5px 13px;
	}
	.e8_left_top .e8_module_range{
	
		cursor: pointer;
	}
	.e8_searchTable{
		border-collapse:collapse;border:1px solid #66bafc;background-color:#53a2e0;height:24px;width:100%;
	}
	.e8_searchText{
		width: 160px;
		border: 0px;
		background-color:#53a2e0;
		color: #fff;
	}
	.e8_btnCreate_mouseover{
		background-color:#66bafc !important;
	}
	.e8_searchText_tip{
		position: absolute;
		top: 4px;
		left: 5px;
		color: #ccc;
	}
	.e8_left_center{
		padding-top:8px;
		padding-bottom: 0px;
		overflow: hidden;
		position:relative;
	}
	.e8_left_center .e8_title{
		padding: 0px 12px;
	}
	.e8_left_center .e8_title span{
		display: block;
		padding: 5px 0 7px 0;
		border-bottom: 1px solid #D3D3D3;
		font-size: 12px;
		font-weight: bold;
		color: #333;
		padding-left: 1px;
	}
	.e8_left_center ul{
		margin:0px;
		padding:0px;
		list-style: none;
	}
	.e8_left_center ul li{
		margin:0px;
		padding: 2px 12px;
		cursor: pointer;
	}
	.e8_left_center ul li a{
		display: block;
		padding: 3px 0px;
		border-bottom: 0px solid #CFCFCF;
		padding-left: 0px;
		text-decoration: none;
		position: relative;
	}
	.e8_left_center ul li a .e8_data_label{
		color: #fff;
		font-size: 14px;
	}
	.e8_left_center ul li a .e8_data_label2{
		color: #a9d1f0;
		font-size: 10px;
		line-height: 14px;
	}
	.e8_left_center ul li a .e8_data_subtablecount{
		background: url(/formmode/images/circleBg_wev8.png) no-repeat 1px 1px;
		font-size: 9px;
		font-style: italic;
		color: #333;
		width: 16px;
		/*
		float: right;
		*/
		position: absolute;
		top: 5px;
		right: 0px;
		padding-left: 4px;
	}
	
	.e8_left_center ul li:hover{
		background-color: #5FACE9;
	}
	.e8_left_center ul li:hover a{
		border-bottom-color: #5FACE9;
	}
	.e8_left_center ul li:hover a .e8_data_label{
		
	}
	.e8_left_center ul li:hover a .e8_data_label2{
		
	}
	.e8_left_center ul li:hover a .e8_data_subtablecount{
	}
	.e8_left_center ul li.selected{
		/*background-color: #e6e6e6;*/
		background-image: url("/formmode/images/ztree_select_bg_blackborder_wev8.png");
	}
	.e8_left_center ul li.selected a{
		border-bottom-color: #E5E5E5;
	}
	.e8_left_center ul li.selected div.line{
		background-color: #e5e5e5;
	}
	.e8_left_center ul li.selected a .e8_data_label{
		color: #2F5E85;
	}
	.e8_left_center ul li.selected a .e8_data_label2{
		color: #396d97;
	}
	.e8_left_center ul li.selected a .e8_data_subtablecount{
		background: url(/formmode/images/circleBgWhite_wev8.png) no-repeat 1px 1px;
		color: #fff;
	}
	.e8_left_center ul li.nodata a{
		border-bottom: none;
		color: #fff;	
		padding: 6px 1px;
	}
	.line{
		height:1px;background-color:#5FACE9;
	}
	.pagination{
		width: 200px;
		text-align: center;
	}
	.pagination a{
		color: #fff !important;
	}
	.pagination span{
		color: #a9d1f0 !important;
	}
	.e8_left_button{
		padding: 8px 0px 0px 0px;
	}
	.e8_left_button span{
		color: #666;
		padding-bottom: 0px;
		padding-left: 2px;
		padding-right: 2px;
		padding-top: 0px;
	}
	.e8_left_button  A{
		color: #ccc;
		padding-bottom: 0px;
		padding-left: 2px;
		padding-right: 2px;
		padding-top: 0px;
		text-decoration:underline
	}
	.publishedFlag{
		margin: 3px 0 0 0;
		text-align: center;
		background: url(/formmode/images/cloud_white_wev8.png) no-repeat;
		font-size: 9px;
		font-style: italic;
		line-height: 15px;
		color: #fff;
		width: 14px;
		height: 15px;
	}
	
	#drillmenu{
		overflow:hidden;
	}
	</style>
	
	<script type="text/javascript">
		var datas=<%=jsonArray.toString()%>;
		var operatelevel=<%=operatelevel+""%>;
		var pSize = 8;
		var currentDatas;
		
		var currMobileAppId = null;
		
		$(document).ready(function () {
			currMobileAppId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_Mobile_APP, datas, "id");
			document.getElementById("currMobileAppId").value = currMobileAppId;
			
			if(window.parent.location.href.indexOf("/formmode/setup/ModeSettingMain.jsp")!=-1){
				if(typeof(parent.changeRightUrl)=="function"){
					parent.changeRightUrl(currMobileAppId);
				}
			}
			
			currPageIndex = FormmodeUtil.getLastIdPageIndex(currMobileAppId,datas,"id",pSize);
			
			initSearchText(onSearchTextChange);
			currentDatas = datas;
			doPagination(datas, pagedDataRender, pSize);
			
			selectedApp();
			initRightMenu();
			
			$("#btnCreate").bind("click", function(){createMobileApp();});
			$("#btnCreate").mouseover(function(){
				$(this).addClass("e8_btnCreate_mouseover");
			});
			$("#btnCreate").mouseout(function(){
				$(this).removeClass("e8_btnCreate_mouseover");
			});
			
			updateLeftPartHeight();
		});
		
		function updateLeftPartHeight(option){
			var winHeight=$(window).height();
			var e8_left_top_height = $(".e8_left_top").height();
			var e8_left_button_height = $(".e8_left_button").height();
			var e8_left_center_height = winHeight - e8_left_top_height - e8_left_button_height - 34;
			$("#leftPart").height(winHeight);
			$("#e8_left_center").height(e8_left_center_height);
			
			if(!!option){
				$("#e8_left_center").perfectScrollbar(option);
			}else{
				$("#e8_left_center").perfectScrollbar();
			}
		}
		
		$(window).resize(function() {
			updateLeftPartHeight("update");
		});
		
		function onSearchTextChange(text){
			var srarchData;
			if(text == ""){
				srarchData = currentDatas;
			}else{
				srarchData = [];
				for(var i = 0; i < currentDatas.length; i++){
					if(currentDatas[i].appname.toLowerCase().indexOf(text.toLowerCase()) != -1 || currentDatas[i].descriptions.toLowerCase().indexOf(text.toLowerCase()) != -1){
						srarchData.push(currentDatas[i]);
					}
				}
			}
			
			doPagination(srarchData, pagedDataRender, pSize);
			initRightMenu();
		}
		
		function doSearchTextChange(){
			var st = $(".e8_searchText").val();
			onSearchTextChange(st);
		}
		
		function changeRightFrameUrl(id){
			var $AElement = $("#A_" + id);
			var $li = $AElement.parent();
			$li.siblings().removeClass("selected");
			$li.addClass("selected");
			
			currMobileAppId=id;
			document.getElementById("currMobileAppId").value = currMobileAppId;
			FormmodeUtil.writeCookie(FormModeConstant._CURRENT_Mobile_APP, id);
			var rightFrame = getRightFrame();
			$(rightFrame).attr("src", "/mobilemode/appComponentlist.jsp?id="+id);
		}
		
		function pagedDataRender(data){
			var descriptions=data["descriptions"];
			if(descriptions.length>7){
				descriptions=descriptions.substring(0,7)+"...";
			}else if(descriptions.length==0){
				descriptions = "<%=SystemEnv.getHtmlLabelName(127449,user.getLanguage())%>";//无描述信息
			}
			var ispublish=data["ispublish"];
			var publishedFlag="";
			if(ispublish==1){
				publishedFlag="<div class=\"publishedFlag\" title=\"<%=SystemEnv.getHtmlLabelName(20517,user.getLanguage())%>\"></div>";//已发布
			}
			return "<a id=\"A_"+data["id"]+"\" appname=\""+data["appname"]+"\" ispublish=\""+data["ispublish"]+"\" href=\"javascript:void(0);\" onclick=\"javascript:changeRightFrameUrl("+data["id"]+");\">" +
				"<table width=\"100%\"><tr>" +
				"<td style=\"padding-right:10px;width:25px;\"><img src=\""+data["picpath"]+"\" border=\"0\" width=32 height=\"32\"/></td>"+
				"<td valign='top'><div class=\"e8_data_label\">"+data["appname"]+"</div>" +
				"<div class=\"e8_data_label2\" title=\""+data["descriptions"]+"\">"+descriptions+"</div></td>" +
				"<td width='12px' align='right' style='vertical-align:top;'>"+publishedFlag+"</td>"+
				"</tr></table></a><div class=\"line\"/>";
		}
		
		var mobileAppDlg;
		function createMobileApp(id){
			mobileAppDlg = top.createTopDialog();//定义Dialog对象
			mobileAppDlg.Model = true;
			mobileAppDlg.Width = 700;//定义长度
			mobileAppDlg.Height = 370;  
			if(id==undefined){
				id="";
			}
			mobileAppDlg.URL = "/mobilemode/appbase.jsp?id="+id;
			mobileAppDlg.Title = id ? "<%=SystemEnv.getHtmlLabelName(127450,user.getLanguage())%>" : "<%=SystemEnv.getHtmlLabelName(127448,user.getLanguage())%>";//编辑移动应用：新建移动应用
			mobileAppDlg.onCloseCallbackFn=function(result){
				refreshData(result);
			}
			mobileAppDlg.show();
		}
		
		function refreshData(id){
			var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=getAppBaseInfoWithJSON");
			if(jQuery("#subCompanyId").length>0){
				var subCompanyId = jQuery("#subCompanyId").val();
				if(subCompanyId!=""){
					url = url + "&subCompanyId="+subCompanyId;
				}
			}
			FormmodeUtil.doAjaxDataLoad(url, function(mobileAppBaseDatas){
				currentDatas = mobileAppBaseDatas;
				if(id){
					refreshLeftPart(currentDatas, id);
				}else{
					doSearchTextChange();
				}
			});
		}
		
		/**
		*左侧菜单新建应用时定位并选中此应用
		*/
		function refreshLeftPart(currentDatas, id){
			fixPageIndex(currentDatas, id);
			doPagination(currentDatas, pagedDataRender, pSize);
			changeRightFrameUrl(id);
		}
		
		/**
		*根据新建应用id定位所在页
		*/
		function fixPageIndex(currentDatas, id){
			for ( var i = 0; i < currentDatas.length; i++) {
				if(id == currentDatas[i].id){
					if((i+1)%pSize == 0){// 整除另算
						currPageIndex = (i+1)/pSize-1;
					}else{
						currPageIndex = Math.floor((i+1)/pSize);
					}
				}
			}
		}
		
		function initRightMenu(){
			initBodyRightMenu();
			initEditEvent();
		}
		
		/**
		 * 初始化编辑事件
		 */
		function initEditEvent(){
			$(".e8_left_center ul li:not([class='nodata']) a").contextMenu({
				menu: 'appRightMenu'
			}, function(action, el, pos) {
				var id=el.attr("id").substring(2);
				var appname=el.attr("appname");
				if(action == "create"){
					createMobileApp();
				}else if(action == "edit"){
					createMobileApp(id);
				}else if(action == "onPublish"){
					publish(id,1);
				}else if(action == "unPublish"){
					publish(id,2);
				}else if(action == "delete"){
					onDelete(id,appname);
				}else if(action == "waste"){
					onWaste(id,appname);
				}else if(action == "export"){
					onExport(id,appname);
				}else if(action == "import"){
					onImport();
				}else if(action == "skin"){
					openSkin(id);
				}
				
				$(el).removeClass("rightMenuSelected");
			});
			
			$(".e8_left_center ul li:not([class='nodata']) a").mousedown(function(e){
				e.stopPropagation();
				var ispublish=$(this).attr("ispublish");
				if(e.which == 3){ // 鼠标右键单击事件
					
					$('#appRightMenu').enableContextMenuItems('#onPublish,#unPublish,#delete,#waste');	
					
					var disableMenuItems = "";	//需要被禁用的右键菜单
					
					if(ispublish=="1"){
						disableMenuItems += "#onPublish,#delete,#waste,"; 
					}else{
						disableMenuItems += "#unPublish,"; 
					}
					
					if(operatelevel == 0){//只读
						disableMenuItems += "#create,#edit,#onPublish,#unPublish,#delete,#waste,#export,#import,#skin,";
					}
					if(operatelevel == 1){//编辑
						disableMenuItems += "#create,#onPublish,#unPublish,#delete,#waste,#export,#import,";
					}
					if(disableMenuItems != ""){
						disableMenuItems.substring(0, disableMenuItems.length - 1);
						$('#appRightMenu').disableContextMenuItems(disableMenuItems);
					}
					
					$(".e8_left_center li a.rightMenuSelected").removeClass("rightMenuSelected");
					$(this).addClass("rightMenuSelected");
				}
			});
		}
		
		function initBodyRightMenu(){
			$("body").contextMenu({
				menu: 'bodyRightMenu'
			}, function(action, el, pos) {
				if(action=="create"){
					createMobileApp();
				}else if(action=="import"){
					onImport();
				}
			});
			
			$("body").mousedown(function(e){
				e.stopPropagation();
				if(e.which == 3){ // 鼠标右键单击事件
					var disableMenuItems = "";
					if(operatelevel <= 1){
						disableMenuItems += "#create,#import,";
					}
					if(disableMenuItems != ""){
						disableMenuItems.substring(0, disableMenuItems.length - 1);
						$('#bodyRightMenu').disableContextMenuItems(disableMenuItems);
					}
				}
			});
		}
		
		function publish(id,ispublish){
			var cfmMessage="<%=SystemEnv.getHtmlNoteName(4975,user.getLanguage())%>";//发布应用
			if(ispublish!="1"){
				cfmMessage="<%=SystemEnv.getHtmlNoteName(4976,user.getLanguage())%>";//下架应用
			}
			mobileAppDlg = top.createTopDialog();//定义Dialog对象
			mobileAppDlg.Model = true;
			mobileAppDlg.Width = 540;//定义长度
			mobileAppDlg.Height = 200;
			mobileAppDlg.URL = "/mobilemode/setup/publish.jsp?id="+id+"&ispublish="+ispublish;
			mobileAppDlg.Title = cfmMessage;
			mobileAppDlg.normalDialog = false;
			mobileAppDlg.onCloseCallbackFn=function(result){
				var publishStatus = result.publishStatus;
				var synchronousStatus = result.synchronousStatus;
				var synchronousRequestURL = result.synchronousRequestURL;
				var publishLabel = "<%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%>";//发布
				var underLabel = "<%=SystemEnv.getHtmlLabelName(127383,user.getLanguage())%>";//下架 
				var successLabel = "<%=SystemEnv.getHtmlLabelName(84565,user.getLanguage())%>";//成功
				var failLabel = "<%=SystemEnv.getHtmlLabelName(84566,user.getLanguage())%>";//失败
				if(publishStatus == "1"){
					var publishMsg = publishLabel+successLabel;//发布成功
					if(ispublish != "1"){
						publishMsg = underLabel+successLabel;//下架成功
					}
					Dialog.alert(publishMsg,function(){ 
						refreshData();
					});
				}else{
					var publishMsg = publishLabel+failLabel;//发布失败
					if(ispublish != "1"){
						publishMsg = underLabel+failLabel;//下架失败
					}
					Dialog.alert(publishMsg,function(){});
				}
				if(synchronousStatus != "1"){
					try{ //ie下console.log可能会报错
					console.error("未能成功通知emobile更新应用，接口地址 "+synchronousRequestURL + " 访问失败");
					}catch(e){}
				}
			}
			mobileAppDlg.show();
		}
		
		function onDelete(id,appname){
			if(confirm("<%=SystemEnv.getHtmlLabelName(127418,user.getLanguage())%>")) {  //你确定要删除此移动应用吗？
				var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=delete");
				FormmodeUtil.doAjaxDataSave(url, {"id":id,"setting":"1"}, function(res){
					if(res == "1"){
						refreshData();
					}else{
						alert("error:\n" + res);
					}
				});
			}
		}
		
		function onWaste(id,appname){
			if(confirm("<%=SystemEnv.getHtmlLabelName(127420,user.getLanguage())%>")) {  //你确定要废弃此移动应用吗？
				var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=waste");
				FormmodeUtil.doAjaxDataSave(url, {"id":id,"setting":"1"}, function(res){
					if(res == "1"){
						refreshData();
					}else{
						alert("error:\n" + res);
					}
				});
			}
		}
		
		function onExport(id,appname){
			if(confirm("<%=SystemEnv.getHtmlLabelName(127453,user.getLanguage())%>")) {  //你确定要导出此移动应用吗？
				var url = jionActionUrl("com.weaver.formmodel.mobile.appio.exports.MobileAppioAction", "action=export");
				var paramData={id:id};
				jQuery.ajax({
				    url: url,
				    timeout:240000,
				    data: paramData,
				    type: 'POST',
				    success: function (res) {
				    	var downxml = res.replace(/(^\s*)|(\s*$)/g, "");
			   			window.open(downxml,"_self");
				    },
				    error: function(){
				    }
				});
			}
		}
		
		function onImport(){
			mobileAppDlg = top.createTopDialog();//定义Dialog对象
			mobileAppDlg.Model = true;
			mobileAppDlg.Width = 405;//定义长度
			mobileAppDlg.Height = 125;
			mobileAppDlg.URL = "/mobilemode/appio.jsp";
			mobileAppDlg.Title = "<%=SystemEnv.getHtmlLabelName(127454,user.getLanguage())%>";//导入移动应用
			mobileAppDlg.onCloseCallbackFn=function(result){
				refreshData();
			}
			mobileAppDlg.show();
		}
		
		function openSkin(id){
			mobileAppDlg = top.createTopDialog();//定义Dialog对象
			mobileAppDlg.Model = true;
			mobileAppDlg.Width = 900;//定义长度
			mobileAppDlg.Height = 575;
			mobileAppDlg.URL = "/mobilemode/setup/skinChoose.jsp?appid="+id;
			mobileAppDlg.Title = "<%=SystemEnv.getHtmlLabelName(127458,user.getLanguage())%>";//皮肤选择
			mobileAppDlg.onCloseCallbackFn=function(result){
				if(!result){
					return;
				}
				var isChange = result["isChange"];
				var skin = result["skin"];
				if(isChange){
					var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=updateSkin");
					FormmodeUtil.doAjaxDataSave(url, {"id":id, "skin":skin}, function(res){
						if(res == "1"){
							top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30700,user.getLanguage())%>");//操作成功
							changeRightFrameUrl(id);
						}else{
							alert("<%=SystemEnv.getHtmlLabelName(127456,user.getLanguage())%>");//设置皮肤时出现错误
						}
					});
				}
			}
			mobileAppDlg.show();
		}
		
		function selectedApp(){
			if(currMobileAppId != null){
				$("#A_" + currMobileAppId).parent().addClass("selected");
			}
		}
		
		function onPagedCallback(){
			initRightMenu();
			selectedApp();
		}
		
		function getRightFrame(){
			 return parent.document.getElementById("mainFrame");
		}
		function selectOrg(){
			var winHight = jQuery(window).height();
			var winWidth = jQuery(window).width();
			var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			dialog.Width = 580;
			dialog.Height = 630;
			dialog.normalDialog = false;
			dialog.URL = "/systeminfo/BrowserMain.jsp?url=/mobilemode/setup/SubcompanyBrowser.jsp?rightStr=MobileModeSet:All";
			dialog.callbackfun = function (paramobj, id1) {
				if(id1){
					var id = id1.id;
					var name = id1.name;
					if(id!=""){
						window.location.href="/mobilemode/MobileSettings.jsp?subCompanyId="+id;
					}
				}
			};
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(33256,user.getLanguage())%>";//选择分部
			dialog.Drag = false;
			dialog.show();
		}
	</script>
</head>
  
<body>
<input type="hidden" id="currMobileAppId"/>
<input type="hidden" id="rightFrameUrl" value="<%=rightframeurl%>"/>

<div id="leftPart">
	<div class="e8_left_top">
	<%if(mmdetachable.equals("1")){%>
		<div id="detachDiv"> 
			<table style="padding-bottom: 5px;">
				<tbody><tr>
					<td width="18" style="padding-right:5px;line-height:5px;"><a title="查询" href="javascript:selectOrg();"> <img src="/formmode/images/globalwhite_wev8.png" width="16" height="16" border="0px"  /></a></td>
					<td style="padding:0 0 0 5px;position: relative;">
					<div  id="subCompanyIdSpan" name="subCompanyIdSpan" onclick="selectOrg()" style="overflow: hidden;height: 20px;line-height: 20px;color: #fff;">
						<%
						if(defaultSubCompanyId == -1){%>
							<%=SystemEnv.getHtmlLabelName(82181,user.getLanguage())%><!-- 请选择分部 -->
						<%}else{%>
							<%=SubCompanyComInfo.getSubCompanyname(""+defaultSubCompanyId)%>
						<%} %>
						
					</div>
					<input style="display: none" type="text" id="subCompanyId" name="subCompanyId" value="<%=defaultSubCompanyId %>"/></td>
					</td>
					</tr>
				</tbody>
			</table>
		</div> 
		<%}else{%>
		<span style="color:#66bafc;font-size:18px;">Apps</span>
		<%} %>
		<table class="e8_searchTable">
			<tr>
				<td style="padding:0 0 0 5px;position: relative;"><input type="text" class="e8_searchText" value=""/></td>
				<!-- <td width="18" style="padding:1px;line-height:5px;"><img src="/formmode/images/btnSearch2_wev8.png" /></td> -->
				<%if(operatelevel > 1){%>
				<td width="20" style="padding:1px 0 1px 2px;line-height:5px;border-left:1px solid #66bafc;cursor:pointer;" id="btnCreate" title="<%=SystemEnv.getHtmlLabelName(127448,user.getLanguage())%>"><!-- 新建移动应用 --><img src="/mobilemode/images/btnCreate_wev8.png" /></td>
				<%} %>
			</tr>
		</table>
	</div>
	<div id="e8_left_center" class="e8_left_center">
		<div id="drillmenu">
			<ul>
			</ul>
		</div>
	</div>
	<div class="e8_left_button" id="pagination" style=""></div>
</div>
<ul id="appRightMenu" class="contextMenu">
	<li class="create1"><a href="#create"><%=SystemEnv.getHtmlLabelName(127448,user.getLanguage())%><!-- 新建移动应用 --></a></li>
	<li class="edit"><a href="#edit"><%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%><!-- 编辑 --></a></li>
	<li class="onPublish"><a href="#onPublish"><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%><!-- 发布 --></a></li>
	<li class="unPublish"><a href="#unPublish"><%=SystemEnv.getHtmlLabelName(127383,user.getLanguage())%><!-- 下架 --></a></li>
	<li class="delete"><a href="#delete"><%=SystemEnv.getHtmlLabelName(126371,user.getLanguage())%><!-- 删除 --></a></li>
	<li class="create1"><a href="#waste"><%=SystemEnv.getHtmlLabelName(81999,user.getLanguage())%><!-- 废弃 --></a></li>
	<li class="export"><a href="#export"><%=SystemEnv.getHtmlLabelName(17416,user.getLanguage())%><!-- 导出 --></a></li>
	<li class="import"><a href="#import"><%=SystemEnv.getHtmlLabelName(32935,user.getLanguage())%><!-- 导入 --></a></li>
	<li class="create1"><a href="#skin"><%=SystemEnv.getHtmlLabelName(84213,user.getLanguage())%><!-- 皮肤 --></a></li>
</ul>
<ul id="bodyRightMenu" class="contextMenu">
	<li class="create1"><a href="#create"><%=SystemEnv.getHtmlLabelName(127448,user.getLanguage())%><!-- 新建移动应用 --></a></li>
	<li class="import"><a href="#import"><%=SystemEnv.getHtmlLabelName(32935,user.getLanguage())%><!-- 导入 --></a></li>
</ul>
</body>
</html>
