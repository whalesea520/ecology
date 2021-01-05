function showMultiDocDialog(selectids){
	var config = null;
	config= rightsplugingForBrowser.createConfig();
    config.srchead=[SystemEnv.getHtmlNoteName(3534,readCookie("languageidweaver")),SystemEnv.getHtmlNoteName("3561,3535",readCookie("languageidweaver")),SystemEnv.getHtmlNoteName(3536,readCookie("languageidweaver"))];
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;//取消实时保存
    config.saveurl= "/docs/docs/MutiDocBrowserAjax.jsp?src=save&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&f_weaver_belongto_userid="+f_weaver_belongto_userid;
    config.srcurl = "/docs/docs/MutiDocBrowserAjax.jsp?src=src&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&f_weaver_belongto_userid="+f_weaver_belongto_userid;
    config.desturl = "/docs/docs/MutiDocBrowserAjax.jsp?src=dest&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&f_weaver_belongto_userid="+f_weaver_belongto_userid;
    config.delteurl="/docs/docs/MutiDocBrowserAjax.jsp?src=save&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&f_weaver_belongto_userid="+f_weaver_belongto_userid;
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



