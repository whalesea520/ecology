
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.formmode.service.AppInfoService"%>
<%@ page import="net.sf.json.JSONArray"%>
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
	if(operatelevel < 1){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String appid=Util.null2String(request.getParameter("appid"));
	AppInfoService appInfoService = new AppInfoService();
	JSONArray modeinfoArr = appInfoService.getAllAppInfoForTree();
%>
<html>
<head>
	<title></title>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext-3.4.1/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/ext-all_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/ux/miframe_wev8.js"></script>
	
	<script type="text/javascript" src="/formmode/js/jquery/pagination/jquery.pagination_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/jquery/hoverIntent/jquery.hoverIntent.minified_wev8.js"></script>
	
	<link rel="stylesheet" href="/formmode/js/jquery/zTree3.5.15/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/formmode/js/jquery/zTree3.5.15/js/jquery.ztree.all-3.5.min_wev8.js"></script>
	
	<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	
	<script type="text/javascript" src="/formmode/js/jquery/contextMenu/jquery.contextMenu_wev8.js"></script>
	<link rel="stylesheet" type="text/css" href="/formmode/js/jquery/contextMenu/jquery.contextMenu_wev8.css?<%=System.currentTimeMillis() %>"/>

	<style type="text/css">
		.x-layout-split{
			background-color:#fff;
		}
		* {font:12px Microsoft YaHei}
		.e8_module_tree{
			padding: 15px 0px 0px 0px;
			margin: 0px;
		}
		.e8_module_tree li{
			padding: 3px 0px 3px 0px;
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
			background:url("/formmode/images/ztree_select_bg_wev8.png") repeat-x;
		}
		.e8_module_tree li.ztreeNodeBgColor>a span{
			color: #0072C6;
			font-weight: bold;
		}
		.e8_module_tree li span.noline_docu.button,
		.e8_module_tree li span.noline_close.button,
		.e8_module_tree li span.noline_open.button{
			margin-left: 5px;
		}
		.e8_module_tree li span.noline_close.button{
			background: url("/formmode/images/arrow_right_wev8.png") no-repeat center;
		}
		.e8_module_tree li span.noline_open.button{
			background: url("/formmode/images/arrow_right_wev8.png") no-repeat center;
		}
		
		.e8_module_tree li.rightMenuSelected{
			background:url("/formmode/images/ztree_over_bg_wev8.png") repeat-x !important;	
		}
	</style>
	<script type="text/javascript">
		
		var zNodes = <%=modeinfoArr.toString()%>;
		
		var currModelId = null;
		
		$(document).ready(function () {
			
			currModelId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_APP, zNodes, "id");
			document.getElementById("currModelId").value = currModelId;
			
			var leftPanel = new Ext.Panel({
				header:false,
				contentEl: "leftPart",
				region: "west",
				width:160,
				border: false,
            	split:false,
            	collapsible: true,
            	autoScroll:true,
           		collapsed : false
			});
			
			var viewport = new Ext.Viewport({
				layout: 'border',
				items: [leftPanel,
                {
					region:'center',
					xtype     :'iframepanel',
 					frameConfig: {
                    	id:'rightFrame', 
                    	name:'rightFrame', 
                    	frameborder:0 ,
                    	eventsFollowFrameLinks : false,
                    	src: "/mobilemode/appModelDesign.jsp?appid="+<%=appid%>+"&modelId="+currModelId
					},
                	autoScroll:true,
                	border: false
 				}]
			});
			
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
		});
		
		function initAppTree(treeDatas){
			
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
				}
			};
			
			$.fn.zTree.init($("#e8_module_tree"), treeSetting, treeDatas);
			
			var treeObj = $.fn.zTree.getZTreeObj("e8_module_tree");
			//treeObj.expandAll(true);	//展开全部
			
			var selectedNode = treeObj.getNodeByParam("id", currModelId, null);
			treeObj.selectNode(selectedNode, true, true);
			treeObj.setting.callback.onClick(null, treeObj.setting.treeId, selectedNode);//调用事件 
			
		}
		
		
		function onModuleChange(id){
			
			currModelId = id;
			document.getElementById("currModelId").value = currModelId;
			FormmodeUtil.writeCookie(FormModeConstant._CURRENT_APP, id);
			
			var rightFrame = document.getElementById("rightFrame");
			var url = "/mobilemode/appModelDesign.jsp?appid=<%=appid%>";
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
			rightFrame.src = url;
		}
	</script>
</head>
  
<body>
	<input type="hidden" id="currModelId"/>
	<div id="leftPart">
		<ul class="e8_module_tree ztree" id="e8_module_tree"></ul>
	</div>
</body>
</html>
