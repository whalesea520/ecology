/**
*部署单个接口
*fromPage   标志来自哪个页面
*/
function doDeploy(id,fromPage){
	if(fromPage){}else{fromPage=1;}
	if(confirm("此操作需要重启服务，请确认")){
		jQuery("#ids").val(id);
		jQuery("#interface").attr("action","/weaver/weaver.admincenter.servlet.InterfaceServlet?src=deploy&fromPage="+fromPage);
		jQuery("#interface").submit();
	}
}

/**
*批量部署接口
*fromPage   标志来自哪个页面
*/
function doMultiDeploy(fromPage){
	if(fromPage){}else{fromPage=1;}
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
		alert("请选择要部署的记录！");
		return;
	}
	if(confirm("此操作需要重启服务，请确认")){
		jQuery("#ids").val(ids);
		jQuery("#interface").attr("action","/weaver/weaver.admincenter.servlet.InterfaceServlet?src=deploy&fromPage="+fromPage);
		jQuery("#interface").submit();
	}
}