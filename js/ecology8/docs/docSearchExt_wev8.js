
//设置关键字
function setKeyword(source,target,formId){
	jQuery("#"+target).val(jQuery("#"+source).val());
}


/**
*日期更改
*/
function changeDate(obj,id,val){
	if(val==null)val='6';
	if(obj.value==val){
		jQuery("#"+id).show();
	}else{
		jQuery("#"+id).hide();
		jQuery("#"+id).siblings("input[type='hidden']").val("");
	}
}

/**
*刷新左侧树数量
*/
function refreshLeftTreeNumForDoc(urlType,options){
	options = jQuery.extend({
		operationcode:-1,
		offical:"",
		officalType:"",
	},options);
	options.urlType = urlType;
	options.onlyCount = "1";
	jQuery.ajax({
		url:"DocSearchMenu.jsp",
		type:"post",
		dataType:"json",
		data:options,
		success:function(data){
			parent.parent.jQuery(".ulDiv").leftNumMenu(data,"update");
		}
	});
}

/**
*获取列表中选中的项
*/
function getCheckedId(){
	var checks = jQuery("input[name='chkInTableTag']:checked");
	var delids = "";
	checks.each(function(){
		if(delids==""){
			delids = jQuery(this).attr("checkboxid");
		}else{
			delids += "," + jQuery(this).attr("checkboxid");
		}
	});
	return delids;		
}