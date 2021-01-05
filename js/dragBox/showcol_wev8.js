var parentWin = null;
var dialog = null;
var pageId = null;
var config = null;
jQuery(document).ready(function(){
	dialog = parent.getDialog(window); 
	parentWin = parent.getParentWindow(window);
	showColDialog();
});

function showColDialog(){
	if(!!pageId){}else{
		pageId = jQuery("#pageId",parentWin.document).val();
	}
	jQuery.ajax({
		url:"/weaver/weaver.common.util.taglib.ShowColServlet?ts="+new Date().getTime()+"&src=updateColInfo&pageId="+pageId+"&__tableStringKey__="+parentWin.__tableStringKey__,
		complete:function(){
			config= rightspluging.createConfig();
	    config.srchead=[SystemEnv.getHtmlNoteName(3528,readCookie("languageidweaver"))];
	    config.container =$("#colShow");
	    config.searchLabel="";
	    config.srcLabel = SystemEnv.getHtmlNoteName(3503,readCookie("languageidweaver"));
	    config.targetLabel = SystemEnv.getHtmlNoteName(3504,readCookie("languageidweaver"));
	    config.hiddenfield="id";
	    config.saveLazy = true;//取消实时保存
	    config.saveurl= "/weaver/weaver.common.util.taglib.ShowColServlet?ts="+new Date().getTime()+"&src=save&pageId="+pageId;
	    config.srcurl = "/weaver/weaver.common.util.taglib.ShowColServlet?ts="+new Date().getTime()+"&src=src&pageId="+pageId;
	    config.desturl = "/weaver/weaver.common.util.taglib.ShowColServlet?ts="+new Date().getTime()+"&src=dest&pageId="+pageId;
	    config.delteurl="/weaver/weaver.common.util.taglib.ShowColServlet?ts="+new Date().getTime()+"&src=save&pageId="+pageId+"&isNot=1";
	    config.pagesize = 100;
	   	jQuery("#colShow").html("");
	    rightspluging.createRightsPluing(config);
		}
	});
}

function saveShowColInfo(){
	if(!!pageId){}else{
		pageId = jQuery("#pageId",parentWin.document).val();
	}
	function addItem(data){
		if(data.result=="1"){
			if(jQuery("span#searchblockspan",parentWin.parent.document).find("img:first").length>0){
					jQuery("span#searchblockspan",parentWin.parent.document).find("img:first").click();
				}else{
					parentWin.location.reload();
				}
			dialog.close();
		}else{
			parentWin.top.Dialog.alert(data.msg);
		}
	}
	 var saveurl = config.saveurl + "&systemIds="+jQuery("#systemIds").val();
	 ajaxHandler(saveurl, "", addItem, "json", false);
}

