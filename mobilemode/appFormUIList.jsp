
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.mobile.model.MobileAppBaseInfo" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager" %>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager"%>
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

MobileAppUIManager mobileAppUIManager=MobileAppUIManager.getInstance();
String appid=Util.null2String(request.getParameter("id"));
int idInt = Util.getIntValue(appid,-1);
MobileAppBaseInfo appbaseInfo = MobileAppBaseManager.getInstance().get(idInt);
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String treeFieldId=Util.null2String(request.getParameter("treeFieldId"));
String err=Util.null2String(request.getParameter("err"));
String step = Util.null2String(request.getParameter("step"));
String appname = appbaseInfo.getAppname();
JSONArray jsonArray=mobileAppUIManager.getFormUiTree(idInt);
%>
<HTML><HEAD>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext-3.4.1/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/ext-all_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/ux/miframe_wev8.js"></script>
	<link rel="stylesheet" href="/formmode/js/jquery/zTree3.5.15/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/formmode/js/jquery/zTree3.5.15/js/jquery.ztree.all-3.5.min_wev8.js"></script>
	
	<link rel="stylesheet" type="text/css" href="/formmode/js/jquery/contextMenu/jquery.contextMenu_wev8.css?v=2016040701"/>
	<style type="text/css">
		html,body{
			height:100%;
		}
		body{
			overflow-x:hidden;
		}
		.active{background-color:#A9A9A9!important;}
		
		/*--center start--*/
		
		.div_center_head{
			display:block;
			height:25px;
			background-color:#eee;
		}
		.div_center_head ul{
			list_style:none;
		}
		.div_center_head li{
			width:66px;
			height:25px;
			line-height:25px;
			float:left;
			background-color:#eee;
			cursor:pointer;
		}
		.div_center_head a{display:block;text-align:center;height:25px;}
		/*--center end--*/
		
		.ui_selected{
			background-color:#FEFFFF!important;
		}
		
		.ui_icon td{
			text-align:center;
		}
		
		.x-layout-split{
			background-color:#eee !important;
		}
		
		.x-tab-panel-header{
			background-color:#eee !important;
			border-bottom:0px !important;
			padding-bottom:0px !important;
		}
		.x-tab-strip-top{
			background-color:#eee !important;
			background-image:none !important;
			border-bottom:0px !important;
		}
		.x-tab-strip-top .x-tab-left{
			background-image:none !important;
		}
		.x-tab-strip-top .x-tab-right{
			background-image:none !important;
		}
		.x-tab-strip-top .x-tab-strip-inner{
			background-image:none !important;
		}
		.x-tab-strip-top .x-tab-strip-active{
			background-color:#FEFFFF !important;
		}
		
	#div_center_ui ul{
		list-style: none;
	}
	#div_center_ui ul li{
		padding: 2px 18px;
		cursor: pointer;
		border-bottom: 0px solid #ddd;
	}
	#div_center_ui ul li a{
		text-decoration: none !important;
	}
	#div_center_ui ul li a .e8_data_label{
		color: #000;
		font-size: 12px;
	}
	#div_center_ui ul li a .e8_data_label2{
		color: #aaa;
		font-size: 10px;
		line-height: 14px;
	}
	#div_center_ui ul li a .e8_data_subtablecount{
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
	
	#div_center_ui ul li:hover{
		background-color: #eee;
	}
	#div_center_ui ul li:hover a{
		border-bottom-color: #ddd;
	}
	#div_center_ui ul li:hover a .e8_data_label{
		
	}
	#div_center_ui ul li:hover a .e8_data_label2{
		
	}
	#div_center_ui ul li:hover a .e8_data_subtablecount{
	}
	#div_center_ui ul li.selected{
		
		background-color: #ddd;
	}
	#div_center_ui ul li.selected a{
		border-bottom-color: #;
	}
	#div_center_ui ul li.selected a .e8_data_label{
		color: ;
	}
	#div_center_ui ul li.selected a .e8_data_label2{
		color: #999;
	}
	#div_center_ui ul li.selected a .e8_data_subtablecount{
		background: url(/formmode/images/circleBgWhite_wev8.png) no-repeat 1px 1px;
		color: #fff;
	}
	#div_center_ui ul li.nodata a{
		border-bottom: none;
		color: #333;	
		padding: 6px 1px;
	}
	</style>
	<style type="text/css">
		* {font:12px Microsoft YaHei}
		
		.e8_module_tree{
			padding: 7px 0px 0px 0px;
			margin: 0px;
		}
		.e8_module_tree li{
			padding: 1px 0px 1px 0px;
			position:relative;
		}
		.e8_module_tree li a{
			text-decoration: none !important;
		}
		.e8_module_tree li a.curSelectedNode{
			height: 17px;
			padding-top: 1px;
			border: none;
			background-color: transparent;
		}
		.e8_module_tree li a span{
			color: #333;
		}
		.e8_module_tree li ul{
			padding-left: 0px;
		}
		.e8_module_tree li ul.level1{
			margin-left: -14px;
		} 
		.e8_module_tree li ul.level2{
			margin-left: -28px;
		} 
		.e8_module_tree li.level1 {
			padding-left: 14px;
		}
		.e8_module_tree li.level2 {
			padding-left: 28px;
		}
		.e8_module_tree li.level3 {
			padding-left: 42px;
		}
		.e8_module_tree li:hover{
			background:url("/formmode/images/ztree_over_bg_wev8.png") repeat-x;	
		}
		.e8_module_tree li:hover a span{
			color: #333;
		}
		.e8_module_tree li.noover{
			background: none;
		}
		.e8_module_tree li.ztreeNodeBgColor{
			/*background:url("/formmode/images/ztree_select_bg_wev8.png") repeat-x;*/	
		}
		.e8_module_tree li.ztreeNodeBgColor>a span{
			color: #0072c6;
			font-weight: bold;
		}
		.e8_module_tree li span.noline_docu.button,
		.e8_module_tree li span.noline_close.button,
		.e8_module_tree li span.noline_open.button{
			margin-left: 5px;
		}
		.e8_module_tree li span.noline_close.button{
			background: url("/formmode/images/arrow_right_close_wev8.png") no-repeat center !important;
		}
		.e8_module_tree li span.noline_open.button{
			background: url("/formmode/images/arrow_right_wev8.png") no-repeat center !important;
		}

.x-tab-panel-header{
	border-bottom: 1px solid #ccc;
}
ul.x-tab-strip-top{
	border-bottom: 1px solid #ccc !important;
	padding-left: 5px;

}
.x-tab-strip-active .x-tab-right{
	border-top: 1px solid #ccc;
	border-left: 1px solid #ccc;
	border-right: 1px solid #ccc;
	border-bottom: 1px solid #fff !important;
}
.x-tab-strip-active SPAN.x-tab-strip-text{
	color: #0072c6;
}
.e8_module_tree li span.button.ico_open{
	background: none no-repeat center !important;
	width:0px;
}
.e8_module_tree li span.button.ico_close{
	background: none no-repeat center !important;
	width:0px;
}
/*首页图标*/
.e8_module_tree li span.button.diy01_ico_docu{
	background: url("/mobilemode/images/treeNodeEdit_wev8.png") no-repeat !important;
}
/*其他自定义页面图标*/
.e8_module_tree li span.button.diy02_ico_docu{
	background: url("/mobilemode/images/treeNodeHomepage_wev8.png") no-repeat !important;	
}
/*appformui图标--显示*/
.e8_module_tree li span.button.diy03_ico_docu{
	background: url("/mobilemode/images/treeNodeModelUI_wev8.png") no-repeat !important;
}
/*appformui图标--新建*/
.e8_module_tree li span.button.diy04_ico_docu{
	background: url("/mobilemode/images/treeNodeAdd2_wev8.png") no-repeat !important;
}
/*appformui图标--编辑*/
.e8_module_tree li span.button.diy05_ico_docu{
	background: url("/mobilemode/images/treeNodeEdit_wev8.png") no-repeat !important;
}
/*appformui图标--列表*/
.e8_module_tree li span.button.diy06_ico_docu{
	background: url("/mobilemode/images/treeNodeList_wev8.png") no-repeat !important;
}
.errorEntry{
	color: red !important;
}
.tip{
	color: red !important;
	font-size: 11px !important;
}

.contextMenu LI:hover{
	background-color:rgb(239,239,239);
}
.contextMenu{
} 
#copy_success_tip{
	position: fixed;
    background-color: rgba(0,0,0,0.8);
	border-image-outset: 0px;
	border-image-repeat: stretch;
	border-image-slice: 100%;
	border-image-source: none;
	border-image-width: 1;
	border-color: rgba(0, 0, 0, 0);
	border-style: solid;
	border-width: 1px;
	border-radius: 4px;
	box-sizing: border-box;
	color: rgb(255, 255, 255);
	font-family: 'Microsoft Yahei', Arial, sans-serif;
	font-size: 12px;
	height: 26px;
	line-height: 26px;
	padding: 0px;
	text-align: center;
	vertical-align: middle;
	left:0px;
	right:0px;
	margin-left:auto;
	margin-right:auto;
	width: 80%;
	margin:0 auto;
	z-index: 98;
	zoom: 1;
	display:none;
}

	</style>
	<script type="text/javascript">
		var zNodes =<%=jsonArray.toString()%>;
		var currMobileFormUiId = null;
		$(document).ready(function () {
			initAppTree(zNodes);
			changeRightFrameUrl();
		});
		function changeRightFrameUrl(){
			try{
				var rightFrame=window.parent.parent.document.getElementById("rightFrame");
				var appuidesignUrl="appuidesign.jsp?appid=<%=appid%>";
				if(currMobileFormUiId != null){
					if(currMobileFormUiId.substring(0,1)!='S'){
						appuidesignUrl+="&id="+currMobileFormUiId;
					}else if(currMobileFormUiId!='S'){
						window.parent.southPanel.hideTabStripItem("uiid");
						window.parent.southPanel.setActiveTab("codeid");
						var id=currMobileFormUiId.substring(1,currMobileFormUiId.length);
						appuidesignUrl = "appuidesign2.jsp?appid=<%=appid%>";
						appuidesignUrl+="&id="+id+"&ishomepage=1";
					}
				}
				rightFrame.src=appuidesignUrl;
			}catch(e){}
		}
		
		function initAppTree(treeDatas){
			currMobileFormUiId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_Mobile_FORMUI, treeDatas, "id");
			if(currMobileFormUiId == "S" && treeDatas.length > 1 ){	//如果未找到，不让其选择第一个无意义的数据项"自定义首页"，而是选择第一个自定义首页数据。
				currMobileFormUiId = treeDatas[1]["id"];
			}
			var treeSetting = {
				edit: {
					enable: true,
					showRemoveBtn: false,
					showRenameBtn: false,
					drag: {
						isCopy: false,
						isMove: true,
						prev: true,
						inner: false,
						next: true
					}
				},
				view: {
					showLine: false,
					showIcon: true,
					nameIsHTML: true
				},
				data: {
					simpleData: {
						enable: true
					}
				},
				callback: {
					onClick: function(e,treeId, treeNode) {
						$('.e8_module_tree a:not(.curSelectedNode)').parent().removeClass("ztreeNodeBgColor");
						$('.e8_module_tree a:not(.curSelectedNode)').parent().addClass("noover");
						$('.e8_module_tree .curSelectedNode').parent().addClass("ztreeNodeBgColor");
					},
					onRightClick: OnRightClick,
					beforeDrag: zTreeBeforeDrag,
					beforeDrop: zTreeBeforeDrop,
					onDrop: zTreeOnDrop,
					onNodeCreated: function(event, treeId, treeNode){
						var $nodeA = $("#"+treeNode.tId+"_a");
						if(treeNode && treeNode.typeRM == "homepage" && treeNode.id){
							var tid = treeNode.id.substring(1);
							$nodeA.attr("title", "id：" + tid);
						}
						if(treeNode && treeNode.treeFieldName){
							$nodeA.attr("title", "<%=SystemEnv.getHtmlLabelName(127563,user.getLanguage())%>" + treeNode.treeFieldName); //所属应用：
						}
					}
				}
			};
			
			$.fn.zTree.init($("#e8_module_tree"), treeSetting, treeDatas);
			
			var treeObj = $.fn.zTree.getZTreeObj("e8_module_tree");
			treeObj.expandAll(true);	//展开全部
			var selectedNode = treeObj.getNodeByParam("id", currMobileFormUiId, null);
			treeObj.selectNode(selectedNode, true, true);
			treeObj.setting.callback.onClick(null, treeObj.setting.treeId, selectedNode);//调用事件 
		}
		
		function refreshData(needChangeRightframeUrl,id){
			var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUIAction", "action=getFormUiTree&appid=<%=appid%>");
			FormmodeUtil.doAjaxDataLoad(url, function(mobileAppFormUiDatas){
				if(id){
					currMobileFormUiId = id;
					FormmodeUtil.writeCookie(FormModeConstant._CURRENT_Mobile_FORMUI, currMobileFormUiId);
				}
				initAppTree(JSON.parse(MLanguage.parse(JSON.stringify(mobileAppFormUiDatas))));
				if(needChangeRightframeUrl){
					changeRightFrameUrl();
				}
			});
		}
		
		function OnRightClick(event, treeId, treeNode) {
			var needRM=treeNode.needRM;
			if(needRM!=1)return;
			var id=treeNode.id;
			var rightMenu = '';
			var tops = event.clientY + $(window.document).scrollTop();
			var ulpos= {
				"top":tops+"px", 
				"left":event.clientX+"px"
			};
			var relateModel = /^m\d+/i.test(treeNode.pId)
			var typeRM=treeNode.typeRM;
			var pageid = id;
			if(typeRM=="homepage"){
				pageid = id.substring(1,id.length);
				if(relateModel){
					rightMenu = 'appRightMenuHomepageFormUI';
					openContextMenu(rightMenu, ulpos, function(action){
						if(action == "edit"){		//编辑
							editHomepage(pageid);
						}else if(action == "delete"){	//删除
							deleteHomepage(pageid);
						}else if(action == "setToHomepage"){		//设置成首页
							setToHomepage(pageid);
						}
					});
				}else{
					//默认显示首页
					if(currMobileFormUiId=="S"&&treeNode.ishomepage == "1"){
						currMobileFormUiId=id;
					}
					rightMenu = 'appRightMenu';
					// 首页禁用部分右键菜单
					disableMenuItems(rightMenu, treeNode);
					openContextMenu(rightMenu, ulpos, function(action){
						if(action == "edit"){		//编辑
							editHomepage(pageid);
						}else if(action == "delete"){	//删除
							deleteHomepage(pageid);
						}else if(action == "copyPage"){// 复制页面
							copyPage(pageid);
						}else if(action == "transformPage"){// 转移页面
							transformPage(pageid);
						}else if(action == "setToHomepage"){		//设置成首页
							setToHomepage(pageid);
						}else if(action == "initContent"){	//初始化内容
							initContent(pageid);
						}
					});
				}
			}else if(typeRM=="formui"){
				rightMenu = 'appRightMenuFormUI';
				openContextMenu(rightMenu, ulpos, function(action){
					if(action == "delete"){	//删除
						deleteFormUI(id);
					}
				});
			}
			setCopyUrl(pageid, rightMenu);
			copyPageId(pageid, rightMenu);
		}
		
		function openContextMenu(rightMenu, ulpos, callbackfn){
			var $ul = $("#" + rightMenu);
			$(".contextMenu").hide();
			$ul.css(ulpos).show();
			$("body").click(function(e){
				$(this).unbind();
				$ul.hide();
			});
			$ul.find("a").unbind();
			$ul.find("li:not(.disabled) a").click( function() {
				$("body").unbind();
				$ul.hide();
				var action = $(this).attr("href").substr(1);
				if(callbackfn) callbackfn.call(this, action);
			}); 
		}
		
		function disableMenuItems(rightMenu, treeNode){
			//需要被禁用的右键菜单
			var d = ["#delete", "#setToHomepage", "#transformPage"];
			for( var i = 0; i < d.length; i++ ) {
				$("#" + rightMenu).find("a[href='"+ d[i] +"']").parent().removeClass("disabled");
			}
			if(treeNode.ishomepage == "1"){
				for( var i = 0; i < d.length; i++ ) {
					$("#" + rightMenu).find("a[href='"+ d[i] +"']").parent().addClass("disabled");
				}
			}
		}
		
		function zTreeBeforeDrag(treeId, treeNodes) {
			return treeNodes[0].typeRM == "homepage" ? true : false ;
		}
		function zTreeBeforeDrop(treeId, treeNodes, targetNode, moveType) {
			return targetNode.typeRM == "homepage" ? true : false ;
		}
		function zTreeOnDrop(event, treeId, treeNodes, targetNode, moveType) {
			var sourceId = treeNodes[0].id.substr(1);
			var targetId = targetNode.id.substr(1);
			var appid = "<%=appid%>";
			
			if(sourceId == targetId) return;
			myMask = new Ext.LoadMask(Ext.getBody(), {
				msg: '<%=SystemEnv.getHtmlLabelName(127564,user.getLanguage())%>',  //操作中,请稍后...
				removeMask: true //完成后移除
			});
			myMask.show();
			
			var data = {"sourceId":sourceId, "targetId":targetId, "appid":appid};
			var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppHomepageAction", "action=sortableHomePage");
			FormmodeUtil.doAjaxDataSave(url, data, function(res){
				if(res != "1"){
					alert("error:\n" + res);
				}
				myMask.hide();
			});
		}
		
		
		//编辑自定义页面
		function editHomepage(id){
			window.parent.parent.createAppHomepage(id);
		}
		
		//删除自定义页面
		function deleteHomepage(id){
			if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
				myMask = new Ext.LoadMask(Ext.getBody(), {
					msg: '<%=SystemEnv.getHtmlLabelName(127564,user.getLanguage())%>',  //操作中,请稍后...
					removeMask: true //完成后移除
				});
				myMask.show();
			
				var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppHomepageAction", "action=delete");
				FormmodeUtil.doAjaxDataSave(url, {"id":id,"setting":"1"}, function(res){
					if(res == "1"){
						refreshData();
					}else{
						alert("error:\n" + res);
					}
					myMask.hide();
				});
			}
		}
		
		// 复制自定义页面ID
		function copyPageId(id, containerid){
			$('#'+containerid+' .copyID a').attr("copy-content", id);
		}
		
		function setCopyUrl(id, containerid){
			var url = "";
			if(containerid == "appRightMenuFormUI"){
				url = "/mobilemode/formbaseview.jsp?uiid=" + id;
			}else{
				url = "/mobilemode/appHomepageView.jsp?appHomepageId=" + id;
			}
			$('#'+containerid+' .copyUrl a').attr("copy-content", url);
		}
		
		//复制自定义页面
		function copyPage(id){
			window.parent.parent.copyPage(id);
		}
		
		//转移自定义页面
		function transformPage(id){
			window.parent.parent.transformPage(id);
		}
		
		//设置成首页
		function setToHomepage(id){
			currMobileFormUiId = "S" + id;
			FormmodeUtil.writeCookie(FormModeConstant._CURRENT_Mobile_FORMUI, currMobileFormUiId);
			myMask = new Ext.LoadMask(Ext.getBody(), {
				msg: '<%=SystemEnv.getHtmlLabelName(127564,user.getLanguage())%>',  //操作中,请稍后...
				removeMask: true //完成后移除
			});
			myMask.show();
		
			var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppHomepageAction", "action=setToHomepage");
			FormmodeUtil.doAjaxDataSave(url, {"id":id}, function(res){
				if(res == "1"){
					refreshData(true);
				}else{
					alert("error:\n" + res);
				}
				myMask.hide();
			});
		}
		
		//初始化首页内容
		function initContent(id){
			window.parent.parent.createInitAppHomepage(id);
		}
		
		//删除formui
		function deleteFormUI(id){
			if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
				myMask = new Ext.LoadMask(Ext.getBody(), {
					msg: '<%=SystemEnv.getHtmlLabelName(127564,user.getLanguage())%>',  //操作中,请稍后...
					removeMask: true //完成后移除
				});
				myMask.show();
			
				var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUIAction", "action=delete");
				FormmodeUtil.doAjaxDataSave(url, {"id":id,"setting":"1"}, function(res){
					if(res == "1"){
						refreshData();
					}else{
						alert("error:\n" + res);
					}
					myMask.hide();
				});
			}
		}
	</script>
	<script>
	function createMobileModel(){
		rightMenu.style.visibility = "hidden";
		window.parent.parent.createMobileModel();
	}
	
	function createMobileModelOnClick(appid, modeid){
		FormmodeUtil.writeCookie(FormModeConstant._CURRENT_APP, appid);
		FormmodeUtil.writeCookie(FormModeConstant._CURRENT_FORM, modeid);
		window.parent.parent.createMobileModel();
	}

	function openAppUi(id,entityid) {
		window.parent.southPanel.unhideTabStripItem("uiid");
		window.parent.southPanel.setActiveTab("uiid");
		currMobileFormUiId = id;
		FormmodeUtil.writeCookie(FormModeConstant._CURRENT_Mobile_FORMUI, id);
		window.parent.parent.document.getElementById("rightFrame").src="appuidesign.jsp?id="+id+"&entityid="+entityid+"&appid=<%=appid%>";
	}
	
	function createMobileUI(entityid){
		window.parent.parent.document.getElementById("rightFrame").src="appuidesign.jsp?entityid="+entityid+"&appid=<%=appid%>";
	}
	
	function openHomepage(id){
		window.parent.southPanel.hideTabStripItem("uiid");
		window.parent.southPanel.setActiveTab("codeid");
		currMobileFormUiId = "S"+id;
		FormmodeUtil.writeCookie(FormModeConstant._CURRENT_Mobile_FORMUI, currMobileFormUiId);
		window.parent.parent.document.getElementById("rightFrame").src="appuidesign2.jsp?appid=<%=appid%>&id="+id+"&ishomepage=1";
	}
	</script>
</HEAD>
<body>
	<div id="copy_success_tip"><%=SystemEnv.getHtmlLabelName(128207,user.getLanguage())%><!-- 复制成功 --></div>
	<div id="div_top" class="div_top">
		<ul class="e8_module_tree ztree" id="e8_module_tree"></ul>
	</div>
	<div id="div_center" class="div_center">
	
	
	</div>
	<ul id="appRightMenu" class="contextMenu">
		<%if(operatelevel > 0){ %>
		<li class="edit"><a href="#edit"><%=SystemEnv.getHtmlLabelName(126036,user.getLanguage())%><!-- 编辑 --></a></li>
		<li class="delete"><a href="#delete"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%><!-- 删除 --></a></li>
		<%} %>
		<li class="copyID"><a href="#copyID"><%=SystemEnv.getHtmlLabelName(127565,user.getLanguage())%><!-- 复制ID --></a></li>
		<li class="copyUrl"><a href="#copyUrl"><%=SystemEnv.getHtmlLabelName(127566,user.getLanguage())%><!-- 复制url --></a></li>
		<%if(operatelevel > 0){ %>
		<li class="copyPage"><a href="#copyPage"><%=SystemEnv.getHtmlLabelName(127567,user.getLanguage())%><!-- 复制页面 --></a></li>
		<li class="transformPage"><a href="#transformPage"><%=SystemEnv.getHtmlLabelName(127568,user.getLanguage())%><!-- 转移页面 --></a></li>
		<li class="onPublish"><a href="#initContent"><%=SystemEnv.getHtmlLabelName(127503,user.getLanguage())%><!-- 初始化页面 --></a></li>
		<li class='unPublish'><a href="#setToHomepage"><%=SystemEnv.getHtmlLabelName(127569,user.getLanguage())%><!-- 设为首页 --></a></li>
		<%} %>
	</ul>
	<ul id="appRightMenuHomepageFormUI" class="contextMenu">
		<%if(operatelevel > 0){ %>
		<li class="edit"><a href="#edit"><%=SystemEnv.getHtmlLabelName(126036,user.getLanguage())%><!-- 编辑 --></a></li>
		<li class="delete"><a href="#delete"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%><!-- 删除 --></a></li>
		<%} %>
		<li class="copyID"><a href="#copyID"><%=SystemEnv.getHtmlLabelName(127565,user.getLanguage())%><!-- 复制ID --></a></li>
		<li class="copyUrl"><a href="#copyUrl"><%=SystemEnv.getHtmlLabelName(127566,user.getLanguage())%><!-- 复制url --></a></li>
		<%if(operatelevel > 0){ %>
		<li class='unPublish'><a href="#setToHomepage"><%=SystemEnv.getHtmlLabelName(127569,user.getLanguage())%><!-- 设为首页 --></a></li>
		<%} %>
	</ul>
	<ul id="appRightMenuFormUI" class="contextMenu">
		<li class="copyID"><a href="#copyID"><%=SystemEnv.getHtmlLabelName(127565,user.getLanguage())%><!-- 复制ID --></a></li>
		<li class="copyUrl"><a href="#copyUrl"><%=SystemEnv.getHtmlLabelName(127566,user.getLanguage())%><!-- 复制url --></a></li>
		<%if(operatelevel > 0){ %>
		<li class="delete"><a href="#delete"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%><!-- 删除 --></a></li>
		<%} %>
	</ul>
	<script type="text/javascript" src="/mobilemode/js/zclip2/ZeroClipboard.js"></script>
	<script type="text/javascript">
		var client = new ZeroClipboard( $('.copyUrl a, .copyID a'),{
			moviePath: "/mobilemode/js/zclip2/ZeroClipboard.swf"
		});
	
	   	client.on( 'ready', function(event) {
	     	client.on( 'copy', function(event) {
		       	event.clipboardData.setData('text/plain', event.target.getAttribute("copy-content"));
		    });
		
		    client.on( 'aftercopy', function(event) {
		       	$("#copy_success_tip").show();
		       	setTimeout(function(){
		       		$("#copy_success_tip").hide();
		       	}, 1000);
		    });
	   	});
	
	   	client.on( 'error', function(event) {
	     	ZeroClipboard.destroy();
	   	});
	</script>
 </body>
</html>