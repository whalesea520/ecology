function showMultiDocDialog(selectids,srchead){
 	var config = null;
 	config= rightsplugingForBrowser.createConfig();
	config.srchead=srchead;
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;
    config.srcurl = "/formmode/browser/CommonMultiBrowserAjax.jsp?src=src";
    config.desturl = "/formmode/browser/CommonMultiBrowserAjax.jsp?src=dest";
    config.pagesize = 10;
    config.formId = "frmmain";
    config.selectids = selectids;
    config.searchAreaId = "e8QuerySearchArea";//新版自定义多选框微调增加
    var istree = jQuery("#istree");
    if(istree.length>0&&istree.val()=="1"){//树形组合查询，返回数据前进行格式化
	    config.formatCallbackFn = function (config,destMap,destMapKeys){
	    	return formateTreeData(config,destMap,destMapKeys);
	    }
    } else {
    	 config.formatCallbackFn = function(config,destMap,destMapKeys){
    		 var ids="",names="";
    		 var nameKey = destMap["__nameKey"];
    		 for(var i=0;destMapKeys&&i<destMapKeys.length;i++){
					var key = destMapKeys[i];
					var dataitem = destMap[key];
					var name = dataitem[nameKey];
					var obj = null;
					try{
						obj = jQuery(name);
					}catch(e){}
					if(ids==""){
						ids = key;
					}else{
						ids = ids+","+key;
					}
					if(names==""){
	        			//names = (obj && obj.length>0)?obj.text().replace(/\,/g,""):name.replace(/\,/g,"");
						names = (obj && obj.length>0)?obj.text():name;//qc370946
	        		}else{
	        			//names=names + ","+((obj && obj.length>0)?obj.text().replace(/\,/g,""):name).replace(/\,/g,"");
	        			names=names + "~~WEAVERSplitFlag~~"+((obj && obj.length>0)?obj.text():name);//qc370946
	        		}
			 }
	         return {id:ids,name:names};
	    }
    }
    try{
		config.dialog = dialog;
	}catch(e){}
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

function formateTreeData (config,destMap,destMapKeys){
	var treenodeid = jQuery("#treenodeid").val();
	var nameKey = destMap["__nameKey"];
	var ids = "";
	var names = "";
	for(var i=0;destMapKeys&&i<destMapKeys.length;i++){
		var key = destMapKeys[i];
		var dataitem = destMap[key];
		var name = dataitem[nameKey];
		var obj = null;
		try{
			obj = jQuery(name);
		}catch(e){}
		
		key = treenodeid+"_"+key;
		
		if(ids==""){
			ids = key;
		}else{
			ids = ids+","+key;
		}
		var text = (obj && obj.length>0)?obj.text().replace(/\,/g,""):name.replace(/\,/g,"");
		if(dialog){
			text = "<a target='_blank' href='/formmode/search/CustomSearchOpenTree.jsp?pid="+key+"' >"+text+"</a>";
		}
		if(names==""){
			names = text;
		}else{
			names=names + ","+text;
		}
	}
	var json = new Object();
	json.id = ids;
	json.name = names;
	return json;
}

function btnOnSearch(){
 jQuery("#btnsearch").trigger("click");
}
/*
rightsplugingForBrowser.system_btnok_onclick=function(config){
	var dest = config.container.find("table.e8_box_target tbody tr");
	var ids = config.container.find("#systemIds").val();
	var names = "";
	if(!!ids){
		ids = "";
    	dest.each(function(){
    		var name = jQuery(this).children("td").eq(1).html();
			var id = jQuery(this).children("td").eq(0).find("input[type='hidden']").val();
			if(ids==""){
    			ids = id;
    		}else{
    			ids=ids + ","+id;
    		}
    		if(names==""){
    			names = name;
    		}else{
    			names=names + ","+name;
    		}
    	});
	}
	try{
			if(config.dialog){
				try{
				config.dialog.callback({id:ids,name:names});
				}catch(e){}
				try{
				config.dialog.close({id:ids,name:names});
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
			config.parentWin.returnValue = {id:ids,name:names};
			config.parentWin.close();
		}else{
			window.parent.returnValue = {id:ids,name:names};
			window.parent.close();
		}
	}
}
*/