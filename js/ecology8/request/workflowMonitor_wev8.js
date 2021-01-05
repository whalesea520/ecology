	/**
	 *	created by bpf in Oct,2013
	**/
	
	//页面初始化
	$(function(){
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
	
	wfSearchManager.loadFunctions.hoverBtn = function(){
		//$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
		//$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		$("#tabDiv").remove();
		$("#hoverBtnSpan").hoverBtn();
	}
	
	
	
	/**
	 *左侧菜单显示\隐藏功能
	**/
	wfSearchManager.loadFunctions.flowToggle = function(){
		$(".toggleLeft").click(function(){
			$(".leftTypeSearch,.flowMenusTd",window.parent.document).toggle();
		});
	}
	
	/**
	 *右侧横向菜单事件处理
	**/
	wfSearchManager.loadFunctions.dealrightTitle = function(){
		/**
		 *右侧横向菜单点击事件
		**/
		$("span[doingType]").click(function(){
			var doingType=$(this).attr("doingType");//
			
			//complete的值是依据原来的代码找出来的
			var doingTypes={
				"flowAll":{complete:0},			//全部
				"flowNew":{complete:3},			//新的
				"flowResponse":{complete:4},	//反馈的
				"flowOut":{complete:8}			//超时的
			};
			var doing=doingTypes[doingType];
			var complete=doing.complete;
			var url="";
			//如果左侧二级菜单被选中
			if(window.parent.workflowid!=null){
				var workflowid=window.parent.workflowid;
				var nodeids=window.parent.nodeids;
				 url="/workflow/search/WFSearchTemp.jsp?method=reqeustbywfidNode&workflowid="+workflowid+"&nodeids="+nodeids+"&complete="+complete;
			}else{//如果左侧一级菜单被选中
				if(window.parent.typeid!=null){
					var typeid=window.parent.typeid;
					 url="/workflow/search/WFSearchTemp.jsp?method=reqeustbywftype&wftype="+typeid+"&complete="+complete;
				}else{
					var url="/workflow/search/WFSearchTemp.jsp?method=all&complete="+complete;
				}
			}
//			$("iframe").attr("src",url);
			window.location.reload();
		});
	}

