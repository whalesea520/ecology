<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/formmode/pub.jsp"%>
<%
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)
		&&!HrmUserVarify.checkUserRight("FORMMODEFORM:ALL", user)
		&&!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
/*
PageExpandManager peManager = PageExpandManager.getInstance();
FormModelInfoManager fmManager = FormModelInfoManager.getInstance();
*/
String pageExpandData = "";//peManager.getAllPageExpand();

String titlename="Web Service"+SystemEnv.getHtmlLabelName(68,user.getLanguage());//设置
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
	
	<link rel="stylesheet" type="text/css" href="/formmode/css/leftPartTemplate_wev8.css" />
	<script type="text/javascript" src="/formmode/js/leftPartTemplate_wev8.js"></script>
	
	<script type="text/javascript">
	
		var datas = [
			{"id":"1", "servicename":"<%=SystemEnv.getHtmlLabelName(82143,user.getLanguage())%>", "servicedesc":"String getAllModeDataList"},//获取表单数据列表(分页)
			{"id":"2", "servicename":"<%=SystemEnv.getHtmlLabelName(82144,user.getLanguage())%>", "servicedesc":"int getAllModeDataCount"},//获取表单数据总数
			{"id":"3", "servicename":"<%=SystemEnv.getHtmlLabelName(82161,user.getLanguage())%>", "servicedesc":"String getModeDataByID"},//获取表单内容
			{"id":"4", "servicename":"<%=SystemEnv.getHtmlLabelName(82162,user.getLanguage())%>", "servicedesc":"String saveModeData"},//保存(新增、更新)
			{"id":"5", "servicename":"<%=SystemEnv.getHtmlLabelName(82163,user.getLanguage())%>", "servicedesc":"String deleteModeDataById"}];//删除表单数据
		
		var currentDatas;
		
		var currFormId = null;
		
		$(document).ready(function () {
			currFormId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_INTERFACE, datas, "id");
			currPageIndex = FormmodeUtil.getLastIdPageIndex(currFormId,datas,"id",pageSize);
			
			var leftPanel = new Ext.Panel({
				contentEl: "leftPart",
				header: false,
				region: "west",
				width:250,
				border: false,
            	split:true,
            	collapsible: true,
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
                    	height:"100%",
                    	width:"100%",
                    	onload:"rightFrameLoad()",
                    	src: "/formmode/setup/interfaceInfo.jsp?id="+currFormId
					},
                	autoScroll:true,
                	border: false
 				}]
			});
			changeRightFrameUrl(currFormId);
			var $searchText = $(".e8_searchText");
			var $searchTextTip = $(".e8_searchText_tip");
			
			$searchTextTip.click(function(){
				$searchText[0].focus();
			});
			
			$searchText.focus(function(){
				$searchTextTip.hide();
			});
			
			$searchText.blur(function(){
				if(this.value == ""){
					$searchTextTip.show();
				}
			});
			
			var preSearchText = "";
			$searchText.keyup(function(event){
				if(this.value != preSearchText){
					preSearchText = this.value;
					doTextSearch(this.value);
				}
			});
			
			currentDatas = datas;
			doPagination(datas, pagedDataRender);
			
			corModuleDisplay();
			
			initModuleTree();
		});
		
		var srarchData;
		function doTextSearch(text){
			text = text.toLowerCase();
			if(text == ""){
				srarchData = currentDatas;
			}else{
				srarchData = [];
				for(var i = 0; i < currentDatas.length; i++){
					if(currentDatas[i].servicename.toLowerCase().indexOf(text) != -1 || currentDatas[i].servicedesc.toLowerCase().indexOf(text) != -1){
						srarchData.push(currentDatas[i]);
					}
				}
			}
			doPagination(srarchData, pagedDataRender);
		}
		
		function changeRightFrameUrl(id, AElement){
			var $li = $(AElement).parent();
			$li.siblings().removeClass("selected");
			$li.addClass("selected");
			currFormId = id;
			FormmodeUtil.writeCookie(FormModeConstant._CURRENT_INTERFACE, id);
			
			$("#rightFrame").attr("src", "/formmode/setup/interfaceInfo.jsp?id="+id);
		}
		
		function onModuleChange(module){
			var srarchData = [];
			for(var i = 0; i < datas.length; i++){
				if(module.id=="-1" || datas[i].moduleid == module.id){
					srarchData.push(datas[i]);
				}
			}
			currentDatas = srarchData;
			doPagination(srarchData, pagedDataRender);
			
			$(".e8_left_center .e8_title span").html(module.name + "(" + srarchData.length +")")
		}
		
		function corModuleDisplay(){
			var $moduleRange = $(".e8_left_top .e8_module_range");
			var $module = $(".e8_module");
			var $moduleTitle = $module.find(".e8_module_title span");
			
			
			var speed = 150;
			
			$moduleTitle.bind("click", function(){
				$module.animate({width: '0px'}, speed);
			});
			
			$moduleRange.bind("click", function(){
				$module.animate({width: '190px'}, speed);
			});
			
			$module.hoverIntent({
				over: function(){},
				out: function(){
					$module.animate({width: '0px'}, speed, function(){
						//$moduleRange.animate({width: '40px'},300);
					});
				}
			});
		}
		
		function initModuleTree(){
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
					}
				}
			};

			var zNodes = [];
			$.fn.zTree.init($(".e8_module_tree"), treeSetting, zNodes);
			
			$(".e8_module_tree li a").bind("mouseover", function(){
				/*
				$(this).parent().removeClass("noover");
				$('.e8_module_tree li a:not(#'+this.id+')').each(function(i){
					if(!$(this).hasClass("curSelectedNode")){	//当前选中节点除外
						$(this).parent().addClass("noover");
					}
				});*/
			});
			
			$(".e8_module_tree li").bind("mouseover", function(event){
				$(this).parents().addClass("noover");
				$(this).removeClass("noover");
				event.stopPropagation(); 
			});
		}
		
		//分页数据的填充回调函数(该函数返回的html，会被放置在单个li中)
		function pagedDataRender(data){
			var servicedesc = data["servicedesc"];
			if(servicedesc==""){
				servicedesc = "<%=SystemEnv.getHtmlLabelName(82164,user.getLanguage())%>";//无描述信息.
			}else if(servicedesc.length>30){
				servicedesc = servicedesc.substring(0, 25) + "...";
			}
			
			return "<a href=\"javascript:void(0);\" onclick=\"javascript:changeRightFrameUrl("+data["id"]+",this);\">" +
						"<div class=\"e8_data_label\">"+data["servicename"]+"</div>" +
						"<div class=\"e8_data_label2\">"+servicedesc+"</div>" +
					"</a>";
		}
		
		var pageSize = 10;
		function doPagination(pgDatas, dataRenderCallFn){
			var currPageIndex = 0;
			var totalSize = pgDatas.length;
			var pageNum = Math.ceil(totalSize/pageSize);
			var isInitPageForCall = true;
			
			var $pg = $('#pagination');
			if($pg.length > 0){	//怪异
				$pg.remove();
			}
			$pg.pagination(totalSize, {
				callback: PageCallback,    
				link_to: 'javascript:void(0);',
				prev_text: '',       //上一页按钮里text    
				next_text: '',       //下一页按钮里text    
				items_per_page: pageSize,  //显示条数    
				num_display_entries: 0,    //连续分页主体部分分页条目数   
				current_page: currPageIndex,   //当前页索引    
				num_edge_entries: 0        //两侧首尾分页条目数    
			});
			
			function toFirstPage(){
				$pg.trigger('setPage', [0]); 
			}
			
			function toPrevPage(){
				$pg.trigger('prevPage');
			}
			
			function toNextPage(){
				$pg.trigger('nextPage');
			}
			
			function toLastPage(){
				$pg.trigger('setPage', [pageNum - 1]); 
			}
			
			function changeEventAndStatusOfProxy(){
				var $pg_first = $(".e8_paginationProxy span.e8_pg_first");
				var $pg_prev = $(".e8_paginationProxy span.e8_pg_prev");
				var $pg_next = $(".e8_paginationProxy span.e8_pg_next");
				var $pg_last = $(".e8_paginationProxy span.e8_pg_last");
				
				$pg_first.unbind("click", toFirstPage);
				$pg_prev.unbind("click", toPrevPage);
				$pg_next.unbind("click", toNextPage);
				$pg_last.unbind("click", toLastPage);
				
				if(currPageIndex == 0){
					$pg_first.addClass("disabled");
					$pg_prev.addClass("disabled");
				}else{
					$pg_first.removeClass("disabled");
					$pg_prev.removeClass("disabled");
					$pg_first.bind("click", toFirstPage);
					$pg_prev.bind("click", toPrevPage);
				}
				if(currPageIndex >= (pageNum - 1)){
					$pg_next.addClass("disabled");
					$pg_last.addClass("disabled");
				}else{
					$pg_next.removeClass("disabled");
					$pg_last.removeClass("disabled");
					$pg_next.bind("click", toNextPage);
					$pg_last.bind("click", toLastPage);
				}
			}
			
			function getPagedData() {
				var start = currPageIndex * pageSize
				, end = (currPageIndex + 1) * pageSize
				, part  = [];
 
				if(end > totalSize){
  					end = totalSize;  
 				}
			    for(;start < end; start++) {
			  	  part.push(pgDatas[start]);
			    }
			    return part;
			}
			
			
			
			function PageCallback(index, jq) { 
				currPageIndex = index;
				changeEventAndStatusOfProxy();
				$(".e8_paginationProxy span.e8_pg_label").html("<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>" + (index + 1) + "<%=SystemEnv.getHtmlLabelName(30642,user.getLanguage())%>");//第 页
				
				if(typeof(dataRenderCallFn) == "function"){
					var speed = isInitPageForCall ? 0 : 200;
					var $dataContainer = $(".e8_left_center ul");
					$dataContainer.fadeOut(speed, function(){
						$dataContainer.find("*").remove();
						var pagedData = getPagedData();
						$.each(pagedData, function(i, data){
							var $dataLi = $("<li></li>");
							
							//临时代码(为了样式) start
							var currFormId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_INTERFACE, pagedData, "id");
							if(pagedData[i].id == currFormId){
								$dataLi.addClass("selected");
							}
							//临时代码(为了样式) end
							
							$dataLi.append(dataRenderCallFn.call(jq, data));
							$dataContainer.append($dataLi);
						});
						$dataContainer.fadeIn(speed);
					});
				}
				
				isInitPageForCall = false;
			}
		}
		
		function rightFrameLoad(){
			try{
				rightFrame.forPageResize();
			}catch(e){}
		}
	</script>
</head>
  
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	
	<%@ include file="/formmode/setup/leftPartTemplate.jsp" %>
	
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
</html>
