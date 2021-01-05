
<%@ page language="java" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
<script type="text/javascript">
	jQuery(document).ready(function(){
	  setTimeout(function(){ 
		if((!jQuery.fn.zTree && !window.__xTreeNamespace__)||window.existXZtree){
			var head= document.getElementsByTagName('head')[0];  
			var script = document.createElement("script");
			script.src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js";
			script.type= 'text/javascript';  
			head.appendChild(script);
		}
	  },2000);
	});
</script>
<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />	
<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
<script type="text/javascript">
	var leftTypeSearchHeight = 60;
	function hideTree(){
		jQuery(".leftTypeSearch").hide();
		jQuery(".flowMenusTd").hide();
	}
	
	//页面初始化
	jQuery(function(){
			//jQuery('#overFlowDiv').perfectScrollbar();
			try{
				flowPageManager.onload();
			}catch(e){
				//console.log(e,"/systeminfo/leftMenuCommon.jsp");
			}
	});
	
	//运行flowPageManager.loadFunctions中的全部函数
	var flowPageManager={onload:function(){
		var loadFunctions=this.loadFunctions;
		for(var xFn in loadFunctions){
			var value=loadFunctions[xFn];
			loadFunctions[xFn]();
		}
	},loadFunctions:{}
	};
		
	/**
	 *页面自适应高度
	**/
	var __initAutoHeight = function(){
		var flowsTable = jQuery(".flowsTable");
		if(flowsTable.length>0){
			flowsTable.height(jQuery(window).height()-100);
			var tdHeight2=jQuery(window).height();
			var leftTypeHeight = leftTypeSearchHeight;
			//if(!jQuery.browser.msie)leftTypeHeight = jQuery("td.leftTypeSearch").height();
			jQuery("#overFlowDiv").css("height",(tdHeight2-leftTypeHeight-1)+"px");
			jQuery(".flowFrame").css("height",(tdHeight2-3)+"px");
			flowsTable.attr("_initComplete",true);
		}else{
			setTimeout(function(){__initAutoHeight();},50);
		}
	}
	
	jQuery(window).bind("resize",function(){
		__initAutoHeight();
	});
	
	__initAutoHeight();
	
	/**
	 *	这个function针对本页的功能来说无任何作用，纯粹用于解决兼容init.jsp中的JS/css冲突的问题
	**/
	flowPageManager.loadFunctions.dealConflcts = function(){
		var conflictClasses=["styled","input"];
		for(var i=0;i<conflictClasses.length;i++){
			jQuery("."+conflictClasses[i]).removeClass(conflictClasses[i]);
		}
	}
	
	
	/**
	 *左侧搜索功能
	**/
	flowPageManager.loadFunctions.dealLeftSearch = function(){
		//重写jQuery的contains选择器，让查询忽略大小写
		jQuery.expr[':'].contains = function(a, i, m) {
		  return jQuery(a).text().toUpperCase()
		      .indexOf(m[3].toUpperCase()) >= 0;
		};
		
		jQuery(".leftSearchInput").searchInput({
			searchFn:function(value){
				var searchStr=jQuery.trim(jQuery(".leftSearchInput").val());
				var showtype=parseInt(jQuery("#showtype").val());
				if(window.e8_custom_search_for_tree && showtype!=2){
					if((window.__xTreeNamespace__ ||window.__zTreeNamespace__ ) && window.oldtree!=false){
						if(window.__xTreeNamespace__){
							__xTreeNamespace__.e8_before();
						}else{
							__zTreeNamespace__.e8_before();
						}
						window.setTimeout(function(){
							e8_custom_search_for_tree(searchStr.toLowerCase());
						},100);
					}else{
						if(window.__weaverTreeNamespace__){
							__weaverTreeNamespace__.e8_before2();
						}
						window.setTimeout(function(){
							e8_custom_search_for_tree(searchStr.toLowerCase());
						},100);
					}
				}else{
					if((window.__xTreeNamespace__ ||window.__zTreeNamespace__) && window.oldtree!=false){
						if(window.__xTreeNamespace__){
							__xTreeNamespace__.e8_before();
						}else{
							__zTreeNamespace__.e8_before();
						}
						window.setTimeout(function(){
							if(showtype==2||(!showtype&&window.oldtree==false)){
								__xTreeNamespace__.e8_search_xtree(searchStr.toLowerCase());
							}else{
								if(window.__xTreeNamespace__){
									__xTreeNamespace__.e8_search_xtree(searchStr.toLowerCase());
								}else{
									__zTreeNamespace__.e8_search(searchStr.toLowerCase());
								}
							}
						},100);
					}else{
						if(window.__weaverTreeNamespace__){
							__weaverTreeNamespace__.e8_before2();
							window.setTimeout(function(){
								__weaverTreeNamespace__.e8_search2(searchStr.toLowerCase());
							},100);
						}						
					}
				}
			}
		});
		
		//jQuery(".leftSearchInput").removeClass("searchInput");
		
	}
	
	function refreshTop(_document,isClose,isOpen,changeIcon){
	if(!_document)_document = parent.parent.document;
	var e8_loading = jQuery("#e8_loading",_document);
	if(!changeIcon){
		if(isOpen){
			jQuery('.flowMenusTd',_document).show();
			jQuery('.leftTypeSearch',_document).show();
		}else{
			if(!!isClose){
				jQuery('.flowMenusTd',_document).hide();
				jQuery('.leftTypeSearch',_document).hide();
			}else{
				jQuery('.flowMenusTd',_document).toggle();
				jQuery('.leftTypeSearch',_document).toggle();
			}
		}
	}
	if(jQuery('.flowMenusTd',_document).length>0){
		if(jQuery('.flowMenusTd',_document).css("display")!="none"){
			jQuery("li.e8_tree a").text("<<");		
		}else{
			jQuery("li.e8_tree a").text(">>");
			e8_loading.hide();
		}
	}
	if(!changeIcon){
		var flowMenusTd = jQuery('.flowMenusTd',_document);
		var expandOrCollapseDiv = jQuery("div.e8_expandOrCollapseDiv",_document);
		if(flowMenusTd.length==0){
			flowMenusTd = jQuery('.flowMenusTd',parent.document);
			expandOrCollapseDiv = jQuery("div.e8_expandOrCollapseDiv",parent.document);
			isClose = false;
		}
		if(flowMenusTd.css("display")=="none" || flowMenusTd.length==0){
			expandOrCollapseDiv.removeClass("e8_expandOrCollapseDivCol");
			expandOrCollapseDiv.css({
				left:0
			});
		}else{
			expandOrCollapseDiv.addClass("e8_expandOrCollapseDivCol");
			expandOrCollapseDiv.css({
				left:flowMenusTd.position().left+flowMenusTd.width()-expandOrCollapseDiv.width()
			});
		}
		if(isClose){
			expandOrCollapseDiv.hide();
		}else{
			expandOrCollapseDiv.show();
		}
	}
} 
	
	/**
	*树形根节点点击事件
	*/
	function e8InitTreeSearch(options){
		var _document  = options._document
		if(!_document)_document = document;
		if(!options)return;
		options = jQuery.extend({ifrms:"#flowFrame,#tabcontentframe"},options);
		/*清除已选项样式*/
		jQuery(".leftSearchInput").val("");
		if(window.e8_search && window.oldtree!=false){
			if(jQuery(".webfx-tree-item").length>0){
				jQuery(".webfx-tree-item_selected").find("img[src*='w_']").each(function(){
					var lastSrc = jQuery(this).attr("src");
					jQuery(this).attr("src",lastSrc.replace("w_",""));
				});
				jQuery(".webfx-tree-item_selected").removeClass("webfx-tree-item_selected");
			}else{
				jQuery(".curSelectedNode").removeClass("curSelectedNode");
			}
			format("",true);
		}else{
			try{
				cancelSelectedNode();
			}catch(e){}
			format2("",true);
		}
		/*清除右侧查询条件并重新查询*/
		//1、找到查询条件对应的iframe
		var iframes = options.ifrms;
		if(!iframes)return;
		try{
			iframes = iframes.split(",");
			for(var i=0;i<iframes.length;i++){
				var ifrm1 = jQuery(iframes[i],_document).get(0);
				if(ifrm1){
					_document = ifrm1.contentWindow.document;
				}
			}
			if(options.conditions){
				jQuery(options.conditions,_document).val("");
				jQuery(options.formID,_document).submit();
			}
		}catch(e){
			if(window.console)console.log(e+"---/systeminfo/leftMenuCommon.jsp-->e8InitTreeSearch");
		}
	}
	
</script>