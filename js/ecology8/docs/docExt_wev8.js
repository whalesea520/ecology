
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
		jQuery("#"+id).children("input[type='hidden']").val("");
		jQuery("#"+id).children("span").html("");
	}
}

/**
*调查类型设置页面的删除记录方法
*/
function selectChecked(valId,formId){
	var checks = jQuery("input[name='chkInTableTag']:checked");
	var ids = "";
	checks.each(function(){
		if(ids==""){
			ids = jQuery(this).attr("checkboxid");
		}else{
			ids += "," + jQuery(this).attr("checkboxid");
		}
	});
	if(ids==""){
		window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3529,readCookie("languageidweaver")));
		return;
	}
	jQuery("#"+valId).val(ids);
	jQuery('#'+formId).submit();
}