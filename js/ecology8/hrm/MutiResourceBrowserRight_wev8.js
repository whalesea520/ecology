function showMultiDocDialog(selectids){
	var config = null;
	config= rightsplugingForBrowser.createConfig();
  config.srchead=["人员","部门","分部"];
  config.container =$("#colShow");
  config.searchLabel="";
  config.hiddenfield="id";
  config.saveLazy = true;//取消实时保存
  config.srcurl = "/hrm/resource/MutiResourceBrowserRightAjax.jsp?src=src";
  config.desturl = "/hrm/resource/MutiResourceBrowserRightAjax.jsp?src=dest";
  config.pagesize = 10;
  config.formId = "SearchForm";
  config.target = "frame1";
  config.parentWin = window.parent.parent;
  config.selectids = selectids;
	try{
		config.dialog = dialog;
	}catch(e){
		alert(e)
	}
   	jQuery("#colShow").html("");
    rightsplugingForBrowser.createRightsPluing(config);
    jQuery("#btnok").bind("click",function(){
    	rightsplugingForBrowser.system_btnok_onclick(config);
    });
    jQuery("#btnclear").bind("click",function(){
    	rightsplugingForBrowser.system_btnclear_onclick(config);
    });
    jQuery("#btncancel").bind("click",function(){
    	rightsplugingForBrowser.system_btncancel_onclick(config);
    });
    jQuery("#btnsearch").bind("click",function(){
    	rightsplugingForBrowser.system_btnsearch_onclick(config);
    });
}

function btnOnSearch(){
	jQuery("#btnsearch").trigger("click");
}


