var _wheight = window.innerHeight;
var _wwidth = window.innerWidth;
var _scrolltop = 0;
function showLoading(){
	$("#body").showLoading();
}
function hideLoading(){
	$("#body").hideLoading();
}
function doHistoryBack(){
	$("#searchDiv").animate({ "left":_wwidth*2 },400,null,function(){});
}
function selectUser(returnIdField,returnShowField,browserType){
	if(jQuery("#userChooseFrame").length>0){//此判断表示在云桥中访问，支持云桥选择人员方法
		//设置选择人员框参数
		jQuery("#userChooseFrame")[0].contentWindow.resetBrowser({
			"fieldId" : returnIdField, //存储ID值的元素id，一般为input
			"fieldSpanId" : returnShowField, //显示人员名字的元素id，一般为span
			"browserType" : browserType, //类型 1：多选  2：单选
			"showDept": "0", //是否只显示同部门的人员 1：是 0：否 
			"selectedIds" : jQuery("#"+returnIdField).val(), //已选择的值
			"callbackBack" : "onHrmBrowserBack_dt", //选择关闭回调方法
			"callbackOk" : "onHrmBrowserOk_dt" //选择确定回调方法
		});
		
		//打开选择人员框，固定写法，无需修改
		_scrolltop = jQuery(document).scrollTop();
		jQuery("#userChooseDiv").animate({ "left":"0" },400,null,function(){
			setTimeout(function(){
				jQuery(document).scrollTop(0);
			},500);
		});
	}else{
		//非云桥中访问可调用原始方法
	}
	
	}
	
	/*选择人员确定回调*/
function onHrmBrowserOk_dt(result){

	//设置返回值，可根据需要增加相关业务逻辑
	jQuery('#'+result["fieldId"]).val(result["idValue"]);//设置ID值
	jQuery('#'+result["fieldSpanId"]).val(result["nameValue"].replace(/,/g,' '));//设置显示值

	//关闭选择框，固定写法，无需修改
	jQuery(document).scrollTop(_scrolltop);
	jQuery("#userChooseDiv").animate({ "left":_wwidth*2 },400,null,function(){});
}
/*关闭选择人员回调*/
function onHrmBrowserBack_dt(){
	//固定写法，无需修改
	jQuery(document).scrollTop(_scrolltop);
	jQuery("#userChooseDiv").animate({ "left":_wwidth*2 },400,null,function(){});
}
/*选择部门或分部*/
function onBrowserDepart_dt(returnIdField,returnShowField,browserType,selectType){
	if(jQuery("#departBrowserFrame_eb").length>0){//此判断表示在云桥中访问，支持云桥选择部门分部方法
		//设置选择人员框参数
		jQuery("#departBrowserFrame_eb")[0].contentWindow.resetBrowser({
			"fieldId" : returnIdField, //存储ID值的元素id，一般为input
			"fieldSpanId" : returnShowField, //显示人员名字的元素id，一般为span
			"browserType" : browserType, //类型 1：多选  2：单选
			"selectType"  : selectType, //1:选择部门  2:选择分部 
			"selectedIds" : $("#"+returnIdField).val(), //已选择的值
			"callbackBack" : "onDepartBrowserBack_dt", //选择关闭回调方法
			"callbackOk" : "onDepartBrowserOk_dt" //选择确定回调方法
		});
		
		//打开选择部门分部框，固定写法，无需修改
		_scrolltop = jQuery(document).scrollTop();
		jQuery("#departBrowserDiv").animate({ "left":"0" },400,null,function(){
			setTimeout(function(){
				jQuery(document).scrollTop(0);
			},500);
		});
	}else{
		//非云桥中访问可调用原始方法
	}
}

/*选择部门分部确定回调*/
function onDepartBrowserOk_dt(result){

	//设置返回值，可根据需要增加相关业务逻辑
	jQuery('#'+result["fieldId"]).val(result["idValue"]);//设置ID值
	jQuery('#'+result["fieldSpanId"]).val(result["nameValue"]);//设置显示值

	
	//关闭选择框，固定写法，无需修改
	jQuery(document).scrollTop(_scrolltop);
	jQuery("#departBrowserDiv").animate({ "left":_wwidth*2 },400,null,function(){});
}
/*关闭选择人员回调*/
function onDepartBrowserBack_dt(){
	//固定写法，无需修改
	jQuery(document).scrollTop(_scrolltop);
	jQuery("#departBrowserDiv").animate({ "left":_wwidth*2 },400,null,function(){});
}
function stopDefaultProp(event){
	  var e = event || window.event;
	  if (window.event) {
		 e.cancelBubble=true;
	  } else {
		 e.stopPropagation();
	  }
	}