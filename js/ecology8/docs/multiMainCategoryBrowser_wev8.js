function showMultiDocDialog(selectids){
	var config = null;
	config= rightsplugingForBrowser.createConfig();
    config.srchead=[SystemEnv.getHtmlNoteName(3538,readCookie("languageidweaver")),"ID"];
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;//取消实时保存
    config.saveurl= "/docs/category/DocMainCategoryMutiBrowserAjax.jsp?src=save";
    config.srcurl = "/docs/category/DocMainCategoryMutiBrowserAjax.jsp?src=src";
    config.desturl = "/docs/category/DocMainCategoryMutiBrowserAjax.jsp?src=dest";
    config.delteurl="/docs/category/DocMainCategoryMutiBrowserAjax.jsp?src=save";
    config.pagesize = 10;
    config.formId = "SearchForm";
    config.selectids = selectids;
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
function btnok_onclick(){
	jQuery("#btnok").trigger("click");
}

function submitClear(){
	jQuery("#btnclear").trigger("click");
}

function onClose(){
	try{
		if(dialog){
			jQuery("#btncancel").trigger("click");
		}else{
			window.parent.close();
		}
	}catch(e){
		window.parent.close();
	}
}

function onReset(){
	SearchForm.reset();
}



