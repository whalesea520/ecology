<%@page import="weaver.formmode.FormModeConfig"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.formmode.service.AppInfoService"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.systeminfo.systemright.CheckSubCompanyRight"%>
<%@ include file="/formmode/pub.jsp"%>

<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
	int defaultSubCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
	if(fmdetachable.equals("1")){//开启了表单建模分权
		RecordSet rs = new RecordSet();
		String fmdftsubcomid = Util.null2String(session.getAttribute("fmdftsubcomid"));
		String checkSql = "SELECT count(1) as num FROM modeTreeField WHERE subcompanyid IS NULL";
		rs.executeSql(checkSql);
		if(rs.next()){
			int num = rs.getInt("num");
			if(num>0){
				rs.executeSql("update modeTreeField set subcompanyid="+fmdftsubcomid+" where subcompanyid IS NULL ");
			}
		}
		
		checkSql = "SELECT count(1) as num FROM modeinfo WHERE subcompanyid IS NULL";
		rs.executeSql(checkSql);
		if(rs.next()){
			int num = rs.getInt("num");
			if(num>0){
				rs.executeSql("update modeinfo set subcompanyid="+fmdftsubcomid+" where subcompanyid IS NULL ");
			}
		}
		
		checkSql = "SELECT count(1) as num FROM workflow_bill WHERE subcompanyid3 IS NULL";
		rs.executeSql(checkSql);
		if(rs.next()){
			int num = rs.getInt("num");
			if(num>0){
				rs.executeSql("update workflow_bill set subcompanyid3="+fmdftsubcomid+" where subcompanyid3 IS NULL ");
				rs.executeSql("update workflow_formbase set subcompanyid3="+fmdftsubcomid+" where subcompanyid3 IS NULL ");
			}
		}
		
		
		if(defaultSubCompanyId==-1){
			defaultSubCompanyId =  Util.getIntValue(Util.null2String(session.getAttribute("defaultSubCompanyId")),-1);
		}
		CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
		int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"FORMMODEAPP:ALL",0);
		if(defaultSubCompanyId!=-1){//判断session中获取的值是否正确，未关闭浏览器切换账号session未被注销
			boolean subFlag = false;
			for(int i=0;i<mSubCom.length;i++){
				if(defaultSubCompanyId==mSubCom[i]){
					subFlag = true;
					break;
				}
			}
			if(!subFlag){
				session.removeAttribute("defaultSubCompanyId");
				defaultSubCompanyId = -1;
			}
		}
		if(defaultSubCompanyId!=-1){
			String userRightStr = "FORMMODEAPP:ALL";
			Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable ,defaultSubCompanyId,"",request,response,session);
			int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
			if(operatelevel<0){
				defaultSubCompanyId = -1;
			}
		}
		
		if(defaultSubCompanyId==-1){
			for(int i=0;i<mSubCom.length;i++){
				if(fmdftsubcomid.equals(""+mSubCom[i])){
					defaultSubCompanyId = mSubCom[i];
					break;
				}
			}
			if(defaultSubCompanyId==-1&&mSubCom.length>0){
				defaultSubCompanyId = mSubCom[0];
			}
		}
		if(defaultSubCompanyId!=-1){
		 	session.setAttribute("managefield_subCompanyId",String.valueOf(defaultSubCompanyId));
		 	session.setAttribute("defaultSubCompanyId",String.valueOf(defaultSubCompanyId));
		}
		
	}
	String userRightStr = "FORMMODEAPP:ALL";
	Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable ,defaultSubCompanyId,"",request,response,session);
	int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);

	AppInfoService appInfoService = new AppInfoService();
	JSONArray modeinfoArr = new JSONArray();
	if(fmdetachable.equals("1")){
		Map map = new HashMap();
		map.put("subCompanyId",defaultSubCompanyId);
		map.put("user",user);
		modeinfoArr = appInfoService.getAllAppInfoForTreeParam(map);
	}else{
		modeinfoArr = appInfoService.getAllAppInfoForTree();
	}
	String rightframeurl=StringHelper.null2String(request.getParameter("rightframeurl"),"/formmode/setup/appSettings.jsp");
	FormModeConfig formModeConfig = new FormModeConfig();
%>
<html>
<head>
	<title></title>
	<script type="text/javascript" src="/formmode/js/jquery/pagination/jquery.pagination_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/jquery/hoverIntent/jquery.hoverIntent.minified_wev8.js"></script>
	
	<link rel="stylesheet" href="/formmode/js/jquery/zTree3.5.15/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/formmode/js/jquery/zTree3.5.15/js/jquery.ztree.all-3.5.min_wev8.js"></script>
	
	<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	
	<script type="text/javascript" src="/formmode/js/jquery/contextMenu/jquery.contextMenu_wev8.js"></script>
	<link rel="stylesheet" type="text/css" href="/formmode/js/jquery/contextMenu/jquery.contextMenu_wev8.css?<%=System.currentTimeMillis() %>"/>
	
	<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
	<script type="text/javascript" src="/js/nicescroll/jquery.nicescroll_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/leftPartTemplate_wev8.js"></script>
	<style type="text/css">
		body, #leftPart, .noover{
			background-color: #53A2E0 !important;
		}
		
		body{
			height:100%;
			overflow:hidden;
		}
		
		* {font:12px Microsoft YaHei}
		
		.e8_module_tree{
			padding: 7px 0px 0px 0px;
			margin: 0px;
		}
		.e8_module_tree li{
			padding: 4px 0px;
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
			color: #fff;
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
			/*background:url("/formmode/images/ztree_over_bg_wev8.png") repeat-x;*/
		}
		.e8_module_tree li:hover a span{
			color: #fff;
		}
		.e8_module_tree li.noover{
			background: none;
		}
		.e8_module_tree li.ztreeNodeBgColor{
			background:url("/formmode/images/ztree_select_bg_blackborder_wev8.png") repeat-x;
		}
		.e8_module_tree li.ztreeNodeBgColor>a span{
			color: #2F5E85;
			font-weight: bold;
		}
		.e8_module_tree li span.noline_docu.button,
		.e8_module_tree li span.noline_close.button,
		.e8_module_tree li span.noline_open.button{
			margin-left: 5px;
		}
		.e8_module_tree li span.noline_close.button{
			background: url("/formmode/images/arrow_right_close_white_wev8.png") no-repeat center;
		}
		.e8_module_tree li span.noline_open.button{
			background: url("/formmode/images/arrow_right_white_wev8.png") no-repeat center;
		}
		
		.e8_module_tree li.rightMenuSelected{
			/*background:url("/formmode/images/ztree_over_bg_wev8.png") repeat-x !important;	*/
			background-color: #5FACE9;
		}
		
		#leftPart{
			overflow:hidden;
			position:relative;
		}
		
		#drillmenu{
			overflow:hidden;
		}
	</style>
	<script type="text/javascript">
		
		var zNodes = <%=modeinfoArr.toString()%>;
		
		var currModelId = null;
		
		$(document).ready(function () {
			currModelId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_APP, zNodes, "id");
			document.getElementById("currModelId").value = currModelId;
			
			if(window.parent.location.href.indexOf("/formmode/setup/ModeSettingMain.jsp")!=-1){
				if(typeof(parent.changeRightUrl)=="function"){
					parent.changeRightUrl(currModelId);
				}
			}
			
			initAppTree(zNodes);
			
			//replace jquery live on 10
			$(document).on('mouseover', '.e8_module_tree li', function(event) {
				$(this).parents().addClass("noover");
				$(this).removeClass("noover");
				event.stopPropagation(); 
			});
			
			$(document.body).click(function(){
				$(".e8_module_tree li.rightMenuSelected").removeClass("rightMenuSelected");
			});
			updateLeftPartHeight();
			
			initSearchText(doTextSearch);
			
		});
		
		function initAppTree(treeDatas, expandall){
			
			var treeSetting = {
				view: {
					showLine: false,
					showIcon: false
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
					onNodeCreated: zTreeOnNodeCreated,
					onCollapse: zTreeOnCollapse,
					onExpand: zTreeOnExpand
				}
			};
			
			$.fn.zTree.init($("#e8_module_tree"), treeSetting, treeDatas);
			
			var treeObj = $.fn.zTree.getZTreeObj("e8_module_tree");
			
			if(expandall){
				treeObj.expandAll(true);	//展开全部
			}
			//treeObj.expandAll(true);	//展开全部
			
			var selectedNode = treeObj.getNodeByParam("id", currModelId, null);
			treeObj.selectNode(selectedNode, true, true);
			zTreeOnAsyncSuccess();
			treeObj.setting.callback.onClick(null, treeObj.setting.treeId, selectedNode);//调用事件 
			
		}
		var firstAsyncSuccessFlag = 0;
		function zTreeOnAsyncSuccess() {
			if (firstAsyncSuccessFlag == 0) {
		          try {
		        	  	 var treeObj = $.fn.zTree.getZTreeObj("e8_module_tree");
		                 //调用默认展开第一个结点  
		                 var selectedNode = treeObj.getSelectedNodes();
		                 var nodes = treeObj.getNodes();
		                 treeObj.expandNode(nodes[0], true); 
		                 var childNodes = treeObj.transformToArray(nodes[0]);  
		                 treeObj.expandNode(childNodes[1], true);  
		                 //treeObj.selectNode(childNodes[1]);  
		                 var childNodes1 = treeObj.transformToArray(childNodes[1]);  
		                 treeObj.checkNode(childNodes1[1], true, true);  
		                 firstAsyncSuccessFlag = 1;  
		           } catch (err) {
		              
		           }
		     }
		}
		
		function zTreeOnRightClick(event, treeId, treeNode) {
			if(treeNode){
				$("#" + treeId).contextMenu({
					menu: 'appRightMenu'
				}, function(action, el, pos) {
					
				});
			}
		};
		
		function zTreeOnNodeCreated(event, treeId, treeNode) {
			$("#" + treeNode.tId).contextMenu({
				menu: 'appRightMenu'
			}, function(action, el, pos) {
				if(action == "create1"){		//新建下级应用
					createApp(treeNode.id);
				}else if(action == "create2"){	//新建同级应用
					createApp(treeNode.pId);
				}else if(action == "edit"){		//编辑
					editApp(treeNode.id);
				}else if(action == "delete"){	//删除
					deleteApp(treeNode.id, treeNode.pId, treeNode.name);
				}else if(action == "import"){	//导入
					preImportApp(treeNode.id);
				}else if(action == "export"){	//导出
					exportApp(treeNode.id);
				}else if(action == "importModel"){
					preImportModel(treeNode.id);
				}
				
				$(el).removeClass("rightMenuSelected");
			});
			
			$("#" + treeNode.tId).mousedown(function(e){
				if(e.which == 3){ // 鼠标右键单击事件
					$('#appRightMenu').enableContextMenuItems('#create1,#create2,#edit,#delete,#import,#export,#importModel');	
					
					var disableMenuItems = "";	//需要被禁用的右键菜单
					
					if(treeNode.id == "1"){
						disableMenuItems += "#create2,"; 
					}
					if(treeNode.childappcount > 0 || treeNode.id == "1"){
						disableMenuItems += "#delete,"; 
					}
					if(treeNode.id !=1){
						if(treeNode.isexpandNode==1||<%=operatelevel%><1){
							disableMenuItems += "#create1,#create2,#edit,#delete,#import,#export,#importModel,"; 
						}
						
						if(<%=operatelevel%><2){
							disableMenuItems += "#delete,";  
						}
					}
					if(disableMenuItems != ""){
						disableMenuItems.substring(0, disableMenuItems.length - 1);
						$('#appRightMenu').disableContextMenuItems(disableMenuItems);
					}
					
					$(".e8_module_tree li.rightMenuSelected").removeClass("rightMenuSelected");
					$(this).addClass("rightMenuSelected");
				}
			});
		};
		
		function zTreeOnCollapse(event, treeId, treeNode) {
			updateLeftPartHeight("update");
		};
		
		function zTreeOnExpand(event, treeId, treeNode) {
			updateLeftPartHeight("update");
		};
		
		function onModuleChange(id){
			currModelId = id;
			document.getElementById("currModelId").value = currModelId;
			FormmodeUtil.writeCookie(FormModeConstant._CURRENT_APP, id);
			
			var rightFrame = getRightFrame();
			var url = rightFrame.src;
			var paramStartIndex = url.indexOf("modelId=");
			if(paramStartIndex == -1){
				url += ((url.indexOf("?") == -1) ? "?" : "&") + "modelId=" + id;
			}else{
				var nextParamStartIndex = url.indexOf("&", paramStartIndex);
				if(nextParamStartIndex == -1){
					nextParamStartIndex = url.length;
				}
				url = url.substring(0,paramStartIndex) + ("modelId=" + id) + url.substring(nextParamStartIndex);
			}
			var index = url.indexOf("&t=");
			var connStr = "";
			if(index!=-1){
				connStr = "&";
			}else{
				index = url.indexOf("?t=");
				if(index!=-1){
					connStr = "?";
				}
			}
			
			if(connStr!=""){
				var tempurl = url;
				var nextIndex = index+tempurl.substring(index+3).indexOf("&");
				var url = tempurl.substring(0,index)
					+ connStr + "t=" + new Date().getTime();
				if(nextIndex>index){
					url += tempurl.substring(nextIndex+3);
				}
			}else{
				url += ((url.indexOf("?") == -1) ? "?" : "&") + "t=" + new Date().getTime();
			}
			rightFrame.src = url;
		}
		
		function refreshAppTree(){
			var url = "/formmode/setup/appSettingsAction.jsp?action=getAllAppInfoForTree";
			if(jQuery("#subCompanyId").length>0){
				var subCompanyId = jQuery("#subCompanyId").val();
				if(subCompanyId!=""){
					url = url + "&subCompanyId="+subCompanyId;
				}
			}
			FormmodeUtil.doAjaxDataLoad(url, function(treeDatas){
				initAppTree(treeDatas);
			});
		}
		
		var appDlg;
		function createApp(superFieldId){
			appDlg = top.createTopDialog();//定义Dialog对象
			appDlg.Model = true;
			appDlg.Width = 700;//定义长度
			appDlg.Height = 360;
			var url = "/formmode/setup/addDefineApp.jsp?superFieldId="+superFieldId+"&flag=create&isFromMode=1";
			if(jQuery("#subCompanyId").length>0){
				var subCompanyId = jQuery("#subCompanyId").val();
				if(subCompanyId!=""){
					url = url + "&subCompanyId="+subCompanyId;
				}
			}
			appDlg.URL = url;
			appDlg.Title = "<%=SystemEnv.getHtmlLabelName(82177,user.getLanguage())%>";//新增应用'
			appDlg.onCloseCallbackFn = function(result){
				if(result){
					refreshApp(result);
				}
			};
			appDlg.show();
		}
		
		function editApp(appId){
			var fmdetachable = "<%=fmdetachable%>";
			appDlg = top.createTopDialog();//定义Dialog对象
			appDlg.Model = true;
			appDlg.Width = 700;//定义长度
			if(fmdetachable == 1 && appId!=1) {
				appDlg.Height = 340;
			} else {
				appDlg.Height = 260;
			}
			appDlg.URL = "/formmode/setup/addDefineApp.jsp?appId="+appId+"&flag=edit&isFromMode=1";
			appDlg.Title = "<%=SystemEnv.getHtmlLabelName(82178,user.getLanguage())%>";//编辑应用
			appDlg.onCloseCallbackFn = function(result){
				if(result){
					refreshApp(result);
				}
			};
			appDlg.show();
		}
		
		var myMask;
		function deleteApp(appId, pid, name){
			if(confirm("<%=SystemEnv.getHtmlLabelName(82180,user.getLanguage())%>"+"\""+name+"\"" +"<%=SystemEnv.getHtmlLabelName(82179,user.getLanguage())%>")){//确定要废弃应用“ ”吗?
				var url = "/formmode/setup/appSettingsAction.jsp?action=wasteApp";
				FormmodeUtil.doAjaxDataSave(url, {"appId":appId}, function(res){
					if(res == "1"){
						refreshApp(pid);
					}else{
						alert("error:\n" + res);
					}
				});
			}
		}
		
		function refreshApp(selectedAppid){
			//closeCreateAppDlg();
			onModuleChange(selectedAppid);
			refreshAppTree();
		}
		
		function changeAppUrl(){
			var currModelId =document.getElementById("currModelId").value;
			var rightFrame = getRightFrame();
			var url = "/formmode/setup/appSettings.jsp?modelId="+currModelId;
			if(jQuery("#subCompanyId").length>0){
				var subCompanyId = jQuery("#subCompanyId").val();
				if(subCompanyId!=""){
					url = url + "&subCompanyId="+subCompanyId;
				}
			}
			rightFrame.src = url;
		}
		
		function getRightFrame(){
			 return parent.document.getElementById("mainFrame");
		}
		
		function updateLeftPartHeight(option){
			var winHeight=jQuery(window).height()-50;
			var detachDiv = jQuery("#detachDiv");//分权部分
			if(detachDiv.length==1){
				winHeight = winHeight-detachDiv.height();
			}
			if(window.parent.location.href.indexOf("/formmode/setup/ModeSettingMain.jsp")!=-1){
				if(jQuery.browser.msie){
					winHeight = winHeight -70;
				}else{
					winHeight = winHeight -30;
				}
			}
			jQuery("#leftPart").height(winHeight);
			if(!!option){
				jQuery("#leftPart").perfectScrollbar(option);
			}else{
				jQuery("#leftPart").perfectScrollbar();
			}
		}
		
		jQuery(window).resize(function() {
			updateLeftPartHeight("update");
		});
		
		function exportApp(appid){
			var xmlHttp = ajaxinit();
			xmlHttp.open("post","/formmode/setup/appoperationxml.jsp", true);
			var timestamp = (new Date()).valueOf();
			var postStr = "src=export&appid="+appid+"&ti="+timestamp;
			xmlHttp.onreadystatechange = function () 
			{
				switch (xmlHttp.readyState) 
				{
				   case 4 : 
				   		if (xmlHttp.status==200)
				   		{
				   			var downxml = xmlHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");
				   			window.open(downxml,"_self");
				   		}
					    break;
				} 
			}
			xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;");
			xmlHttp.send(postStr);
		}
		
		function preImportApp(appid){
			appDlg = top.createTopDialog();//定义Dialog对象
			appDlg.currentWindow = window;
			appDlg.Model = true;
			appDlg.Width = 400;//定义长度
			appDlg.Height = 400;
			<%if(formModeConfig.isImportchecksametable()){%>
			appDlg.URL = "/formmode/setup/addDefineApp.jsp?appId="+appid+"&flag=import&isImportant=<%=formModeConfig.isImportchecksametable()%>&isFromMode=1";
			<%}else{%>
			appDlg.URL = "/formmode/setup/addDefineApp.jsp?appId="+appid+"&flag=import&isImportant=<%=formModeConfig.isImportchecksametable()%>&isFromMode=1";
			<%}%>
			appDlg.Title = "<%=SystemEnv.getHtmlLabelName(81994,user.getLanguage())%>";//导入应用
			appDlg.onCloseCallbackFn = function(result){
				if(result){
					refreshApp(result);
				}
			};
			appDlg.show();
		}
		
		function preImportModel(appid){
			appDlg = top.createTopDialog();//定义Dialog对象
			appDlg.currentWindow = window;
			appDlg.Model = true;
			appDlg.Width = 400;//定义长度
			appDlg.Height = 300;
			appDlg.URL = "/formmode/setup/preimportapp.jsp?importmodel=1&appid="+appid;
			appDlg.Title = "<%=SystemEnv.getHtmlLabelName(81995,user.getLanguage())%>";//导入模块
			appDlg.onCloseCallbackFn = function(result){
				if(result){
					refreshApp(result);
				}
			};
			appDlg.show();
		}
		
	function selectOrg(){
		var winHight = jQuery(window).height();
		var winWidth = jQuery(window).width();
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Width = 580;
		dialog.Height = 630;
		dialog.normalDialog = false;
		dialog.URL = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/SubcompanyBrowser.jsp?rightStr=FORMMODEAPP:ALL";
		//dialog.Top = "100%";
		//dialog.Left = "0%";
		dialog.callbackfun = function (paramobj, id1) {
			if(id1){
				var id = id1.id;
				var name = id1.name;
				if(id!=""){
					window.location.href="/formmode/setup/main.jsp?subCompanyId="+id;
				}
			}
		};
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(33256,user.getLanguage())%>";//选择分部
		dialog.Drag = false;
		dialog.show();
	}
	</script>
	<style type="text/css">
	.e8_searchText{
		outline: none;
	}
	.e8_left_top {
		cursor: pointer;
		top: 0px;
    	left: 0px;
    	padding-left: 15px;
    	padding-right: 15px;
    	padding-bottom: 5px;
    	padding-top: 15px;
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
	</style>
</head>
  
<body id="mainBody" name="mainBody">
		<div class="e8_left_top">
			<%if(fmdetachable.equals("1")){%>
			<div id="detachDiv"> 
			<table style="padding-bottom: 5px;">
				<tbody><tr>
					<td width="18" style="padding-top:5px;padding-right:5px;line-height:5px;">
						<a title="查询" href="javascript:selectOrg();"> 
							<img src="/formmode/images/globalwhite_wev8.png" width="16" height="16" border="0px" />
						</a></td>
					<td style="padding:0 0 0 5px;position: relative;">
					<div  id="subCompanyIdSpan" name="subCompanyIdSpan" onclick="selectOrg()" style="overflow: hidden;height: 20px;line-height: 20px;color: #fff;">
						<%
						if(defaultSubCompanyId==-1){%>
							<%=SystemEnv.getHtmlLabelName(82181,user.getLanguage())%><!-- 请选择分部 -->
						<%}else{
							out.print(SubCompanyComInfo.getSubCompanyname(""+defaultSubCompanyId));
						} %>
						
					</div>
					<input style="display: none" type="text" id="subCompanyId" name="subCompanyId" value="<%=defaultSubCompanyId %>"/></td>
					</td>
					</tr>
				</tbody>
			</table>
		</div> 
		<%}%>
			<table class="e8_searchTable" >
				<tbody><tr>
					<td style="padding:0 0 0 5px;position: relative;"><input type="text" class="e8_searchText" value=""></td>
					<td width="18" style="padding-top:5px;padding-right:5px;line-height:5px;">
						<a title="查询" href="javascript:doTextSearch();">
							 <img src="/formmode/images/searchblue_wev8.png" width="16" height="16" border="0px"/>
						</a></td>
					</tr>
				</tbody>
			</table>
		</div>
	<input type="hidden" id="currModelId"/>
	<input type="hidden" id="rightFrameUrl" value="<%=rightframeurl%>"/>
	<div id="leftPart">
		<div id="drillmenu">
			<ul class="e8_module_tree ztree" id="e8_module_tree"></ul>
		</div>
	</div>
	
	<ul id="appRightMenu" class="contextMenu">
		<li class="create1"><a href="#create1"><%=SystemEnv.getHtmlLabelName(81996,user.getLanguage())%><!-- 新建下级应用 --></a></li>
		<li class="create2"><a href="#create2"><%=SystemEnv.getHtmlLabelName(81997,user.getLanguage())%><!-- 新建同级应用 --></a></li>
		<li class="edit"><a href="#edit"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><!-- 编辑 --></a></li>
		<li class="delete"><a href="#delete"><%=SystemEnv.getHtmlLabelName(81999,user.getLanguage())%><!-- 废弃 --></a></li>
		<%--
		<li class="import"><a href="#import"><%=SystemEnv.getHtmlLabelName(81994,user.getLanguage())%><!-- 导入应用 --></a></li>
		<li class="export"><a href="#export"><%=SystemEnv.getHtmlLabelName(81998,user.getLanguage())%><!-- 导出应用 --></a></li>
		--%>
		<%
		if(formModeConfig.isImportchecksametable()){
		%>
		<li class="import"><a href="#importModel"><%=SystemEnv.getHtmlLabelName(81995,user.getLanguage())%><!-- 导入模块 --></a></li>
		<%} %>
	</ul>
	<script type="text/javascript">
		function doTextSearch(){
			var searchText = jQuery(".e8_searchText").val();
			refreshAppTree4Search(searchText);
		}
		function refreshAppTree4Search(searchText){
			var url = "/formmode/setup/appSettingsAction.jsp?action=getAllAppInfoForTreeSearch&searchtext="+searchText;
			if(jQuery("#subCompanyId").length>0){
				var subCompanyId = jQuery("#subCompanyId").val();
				if(subCompanyId!=""){
					url = url + "&subCompanyId="+subCompanyId;
				}
			}
			FormmodeUtil.doAjaxDataLoad(url, function(treeDatas){
				initAppTree(treeDatas, true);
				jQuery(".e8_searchText").focus();
			});
		}
	</script>
</body>
</html>
