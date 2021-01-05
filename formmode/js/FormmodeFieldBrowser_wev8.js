var parentWin = null;
var dialog = null;
var pageId = null;
var config = null;
jQuery(document).ready(function(){
	dialog = parent.parent.getDialog(parent);
	parentWin = parent.parent.getParentWindow(parent);
	showColDialog();
});

function showColDialog(){
	var modeid = document.getElementById("modeid").value;
	var type = document.getElementById("type").value;
	var selfieldid = document.getElementById("selfieldid").value;
	var fieldids = document.getElementById("fieldids").value;
	var rownum = document.getElementById("rownum").value;
	
	config= rightsplugingForBrowser.createConfig();
    config.srchead=["列名"];
    config.container =$("#colShow");
    config.searchLabel="";
    config.srcLabel = SystemEnv.getHtmlNoteName(3503,readCookie("languageidweaver"));
    config.targetLabel = SystemEnv.getHtmlNoteName(3504,readCookie("languageidweaver"));
    config.hiddenfield="id";
    config.saveLazy = true;//取消实时保存
    config.saveurl= "/weaver/weaver.formmode.setup.FormmodeFieldBrowserServlet?action=save";
    config.desturl = "/weaver/weaver.formmode.setup.FormmodeFieldBrowserServlet?action=selected&fieldids="+fieldids+"&rownum="+rownum;
    config.srcurl = "/weaver/weaver.formmode.setup.FormmodeFieldBrowserServlet?action=select&modeid="+modeid+"&type="+type+"&selfieldid="+selfieldid+"&fieldids="+fieldids+"&rownum="+rownum;
    config.delteurl="/weaver/weaver.formmode.setup.FormmodeFieldBrowserServlet?action=del";
    config.pagesize = 10;
   	jQuery("#colShow").html("");
    rightsplugingForBrowser.createRightsPluing(config);
    
    jQuery("#zd_btn_submit").bind("click",function(){
    	var dest = config.container.find("table.e8_box_target tbody tr");
        var ids = config.container.find("#systemIds").val();
        var names = "";
        if(!!ids){
	        dest.each(function(){
	        	var name = jQuery(this).children("td").eq(1).text();
	        	if(names==""){
	        		names = name;
	        	}else{
	        		names=names + ","+name;
	        	}
	        });
        }
        //alert(ids+"----"+names);
        try{
	        if(dialog){
				try{
					dialog.callback({id:ids,name:names});
				}catch(e){}
				try{
					dialog.callbackfunParam = {rownum:rownum};
					dialog.close({id:ids,name:names});
				}catch(e){}
			}else{
				if(config.parentWin){
					config.parentWin.returnValue = {id:ids,name:names};
					config.parentWin.close();
				}else{
					window.parent.returnValue = {id:ids,name:names};
					window.parent.close();
				}
			}
		}catch(e){
				if(config.parentWin){
					alert(5);
					config.parentWin.returnValue = {id:ids,name:names};
					config.parentWin.close();
				}else{
					alert(6);
					window.parent.returnValue = {id:ids,name:names};
					window.parent.close();
				}
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

