function showMultiDocDialog(selectids,srchead,srcfield){
	var config = null;
	config= rightsplugingForBrowser.createConfig();
    config.srchead=srchead||["任务名称","所属项目","负责人"];
    config.srcfield=srcfield||['id','subject','prjid','hrmid'];
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;
    config.saveurl= "/proj/data/MultiTaskBrowserAjax.jsp?src=save";
    config.srcurl = "/proj/data/MultiTaskBrowserAjax.jsp?src=src";
    config.desturl = "/proj/data/MultiTaskBrowserAjax.jsp?src=dest";
    config.delteurl="/proj/data/MultiTaskBrowserAjax.jsp?src=save";
    config.pagesize = 10;
    config.formId = "weaver";
    config.selectids = selectids;
    config.searchAreaId = "e8QuerySearchArea";
	try{
		config.dialog = dialog;
	}catch(e){
	
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


