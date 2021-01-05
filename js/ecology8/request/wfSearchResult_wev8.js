	/**
	 *	created by bpf in Oct,2013
	**/
	
	//页面初始化
	jQuery(function(){
		wfSearchManager.onload();
	});
	
	//运行wfSearchManager.loadFunctions中的全部函数
	var wfSearchManager={onload:function(){
		var loadFunctions=this.loadFunctions;
		for(var xFn in loadFunctions){
			var value=loadFunctions[xFn];
			loadFunctions[xFn]();
		}
	},loadFunctions:{}
	};
	
	
	//complete的值是依据原来的代码找出来的
	var doingTypes={
		"flowAll":{complete:0},			//全部
		"flowNew":{complete:3},			//新的
		"flowResponse":{complete:4},	//反馈的
		"flowOut":{complete:8}		//超时的
	};
			
		
     function searchItem(){
		
		   var value=$("input[name='flowTitle']",parent.document).val();
		    $("input[name='requestname']").val(value);
		    document.frmmain.submit();
		}


	wfSearchManager.loadFunctions.hoverBtn = function(){
		jQuery(".topMenuTitle td:eq(0)").html("<div id='tabblock' style='width:100%;overflow:hidden;height:40px;'>" + jQuery("#tabDiv").html() + "</div>");
		jQuery("#tabDiv").remove();
		jQuery("#hoverBtnSpan").hoverBtn();
		
		var complete=jQuery("[name='complete']").val();
		var doingTypesObj={
			"0":"flowAll",			//全部
			"3":"flowNew",			//新的
			"4":"flowResponse",	//反馈的
			"8":"flowOut"			//超时的
		};
		var selectedTitle=jQuery("[doingType='"+doingTypesObj[complete]+"']");
		selectedTitle.addClass("selectedTitle");
		selectedTitle.append("("+jQuery("#wfCount").val()+")");
		//loadCounts();
	}
	
	function loadCounts(){
		var doingElement = jQuery("[doingType]").not(".selectedTitle");
		doingElement.each(function(i){
			var doingTypeSpan=jQuery(this);
			var doingType=doingTypeSpan.attr("doingType");
			jQuery.ajax({
				type:'POST',
				url: "/workflow/search/WFSearchTemp.jsp?getCount=true&complete="+doingTypes[doingType].complete,
				async:false,
				data:jQuery("[name='frmmain']").serialize(),
				success: function(html){
					html=jQuery.trim(html.substring(html.length-8,html.length));
					doingTypeSpan.append("("+html+")");
//					if (i == doingElement.length -1) {
//						//获取隐藏的元素
//						//将元素clone一份，放入下面菜单中即可，页面resize的时候，再次调用此方法计算即可
//						var overflowElements = getoverflowTabElement();
//					}
				},error:function(){
				}
			});
		});
	}

	/**
	 *右侧横向菜单事件处理
	**/
	wfSearchManager.loadFunctions.dealrightTitle = function(){
		/**
		 *右侧横向菜单点击事件
		**/
		jQuery("span[doingType]").click(function(){
			var doingType=jQuery(this).attr("doingType");//
			

			var doing=doingTypes[doingType];
			var complete=doing.complete;
//			var url="";
//			//如果左侧二级菜单被选中
//			if(window.parent.workflowid!=null){
//				var workflowid=window.parent.workflowid;
//				var nodeids=window.parent.nodeids;
//				 url="/workflow/search/WFSearchTemp.jsp?method=reqeustbywfidNode&workflowid="+workflowid+"&nodeids="+nodeids+"&complete="+complete;
//			}else{//如果左侧一级菜单被选中
//				if(window.parent.typeid!=null){
//					var typeid=window.parent.typeid;
//					 url="/workflow/search/WFSearchTemp.jsp?method=reqeustbywftype&wftype="+typeid+"&complete="+complete;
//				}else{
//					var url="/workflow/search/WFSearchTemp.jsp?method=all&complete="+complete;
//				}
//			}
//			window.location.reload();
			jQuery("[name='complete']").val(complete);
			jQuery("[name='frmmain']").attr("action","WFSearchTemp.jsp?reforward=true");
			jQuery("[name='frmmain']").submit();
		});
	}
	
	
	/**
	 *批量提交
	**/
	wfSearchManager.loadFunctions.batchSubmit = function(){
		jQuery(".batchSubmit").click(function(){
			alert("批量提交");
		});
	}
	
	
	/**
	 *左侧菜单显示\隐藏功能
	**/
	wfSearchManager.loadFunctions.flowToggle = function(){
		jQuery(".toggleLeft").click(function(){
			jQuery(".leftTypeSearch,.flowMenusTd",window.parent.document).toggle();
		});
	}
	

