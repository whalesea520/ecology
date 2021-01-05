function showMultiDocDialog(selectids,tabid){
	var config = null;
	config= rightsplugingForBrowser.createConfig();
  config.srchead=["简称","全称"];
  config.container =$("#colShow");
  config.searchLabel="";
  config.hiddenfield="id";
  config.saveLazy = true;//取消实时保存
  config.srcurl = "/hrm/jobtitles/MultiJobtitlesBrowserAjax.jsp?src=src";
  config.desturl = "/hrm/jobtitles/MultiJobtitlesBrowserAjax.jsp?src=dest";
  config.formId = "SearchForm";
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


