	/**
	 *	created by bpf in Oct,2013
	**/
	window.typeid=null;
	window.workflowid=null;
	window.nodeids=null;
	
	/**
	 *	wuiform.init针对本页的功能来说无任何作用，纯粹用于解决兼容init.jsp中的JS/css冲突的问题
	**/
	wuiform.init=function(){
		wuiform.textarea();
		wuiform.wuiBrowser();
		wuiform.select();
	}
	
	function ajaxinit(){
		var ajax=false;
		try {
			ajax = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
	        try {
	        	ajax = new ActiveXObject("Microsoft.XMLHTTP");
	        } catch (E) {
	        	ajax = false;
	        }
       }
        if (!ajax && typeof XMLHttpRequest!='undefined') {
        	ajax = new XMLHttpRequest();
        }
        return ajax;
	}
	
	/*flowPageManager.loadFunctions.leftNumMenu = function(){
		
		var needflowOut=true;
		var needflowResponse=true;
		
		var	numberTypes={
				flowNew:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:"新的流程"}
		};
		if(needflowOut==true || needflowOut=="true"){
			numberTypes.flowOut={hoverColor:"#CB9CF4",color:"#CB9CF4",title:"超时的流程"};
		}
		if(needflowResponse==true || needflowResponse=="true"){
			numberTypes.flowResponse={hoverColor:"#FFC600",color:"#FFC600",title:"有反馈的流程"};
		}
		numberTypes.flowAll={hoverColor:"#A6A6A6",color:"black",title:"全部流程"};
		if(demoLeftMenus != null)
		{
			$(".ulDiv").leftNumMenu(demoLeftMenus,{
				numberTypes:numberTypes,
				showZero:false,
				menuStyles:["menu_lv1",""],
				clickFunction:function(attr,level,numberType){
					leftMenuClickFn(attr,level,numberType);
				},
				deleteIfAllZero : true
			});
		}
		var sumCount=0;
		$(".e8_level_2").each(function(){
			sumCount+=parseInt($(this).find(".e8_block:last").html());
		});
		//$(".leftType").append("("+sumCount+")");
		
	}*/
			
	function e8InitTreeWfSearch(options){
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
			jQuery(".e8_li_selected").find(".e8menu_icon_close_select").removeClass("e8menu_icon_close_select").addClass("e8menu_icon_close");
			jQuery(".e8_li_selected").find(".e8menu_icon_open_select").removeClass("e8menu_icon_open_select").addClass("e8menu_icon_open");
			jQuery(".e8_li_selected").removeClass("e8_li_selected");
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
				var method = "all";
				var complete = jQuery("#complete",_document).val();
				var viewcondition = jQuery("#viewcondition",_document).val();
				$.ajax({ 
			        type: "post",
			        url: "/workflow/search/WFSearchTemp.jsp?method="+method+"&complete="+complete+"&viewcondition="+viewcondition,
			        async:false,
			        success:function(data){
			        	//成功后不需要做操作
			        },
			        complete:function(data)
			        {
			        	jQuery(options.formID,_document).submit();
			        }
		        });
				
			}
		}catch(e){
			if(window.console)console.log(e+"---/systeminfo/leftMenuCommon.jsp-->e8InitTreeSearch");
		}
	}
