var mutildoSetValue=function(config,ids,names,type,destMap,destMapKeys){ 
		var descs = getDescs(config,destMap,destMapKeys);
		
		var opWin = window.parent;
		if (config.parentWin)
			opWin = config.parentWin;
		try {
			//chrome37+ 处理
			var dialogflag = (typeof (systemshowModalDialog) == 'undefined' && !!!window.showModalDialog);
			dialogflag = (dialogflag || systemshowModalDialog);
			
			//设置值
			if(type==1){
				if (dialogflag) {
					try {
						opWin.opener.dialogReturnValue = {
							id : ids,
							name : names,
							descs: descs,
							href : href
						};
					} catch (_96e) {
					}
				}
				opWin.returnValue = {
					id : ids,
					name : names,
					descs: descs,
					href : href
				};
			}
			//关闭
			if (dialogflag) {
				try {
					opWin.opener.closeHandle();
				} catch (_96e) {
				}
			}
			opWin.close();
		} catch (e) {
			//设置值
			if (type == 1) {
				opWin.returnValue = {
					id : ids,
					name : names,
					descs: descs,
					href : href
				};
			}
			//关闭
			opWin.close();
		}
};
var mutilreturnValue = function(config,ids,names,type,destMap,destMapKeys){
		var descs = getDescs(config,destMap,destMapKeys);
		
		try {
			if (config.dialog) {
				//E8弹出窗口模式
				
				//设置值
				if(type==1){
					try {
						config.dialog.callback({
							id : ids,
							name : names,
							descs: descs,
							href : href
						});
					} catch (e) {
					}
					try {
						config.dialog.close({
							id : ids,
							name : names,
							descs: descs,
							href : href
						});
					} catch (e) {
					}
				}
				//关闭
				try {
					config.dialog.close();
				} catch (e) {
				}
			} else {
				//老式弹出窗口操作
				mutildoSetValue(config,ids,names,type,destMap,destMapKeys);
			}
		} catch (e) {
			//老式弹出窗口操作
			mutildoSetValue(config,ids,names,type,destMap,destMapKeys);
		}
};

function getDescs(config,destMap,destMapKeys){
	var descs = "";
	var nameKey = destMap["__nameKey"];
	var idKey = config.hiddenfield;
	for(var i=0; i<destMapKeys.length;i++ ){
		var key = destMapKeys[i];
		var dataitem = destMap[key];
		for (var item in dataitem) {
			if(item===idKey||item===nameKey||item==="__state"||item==="__checked"||item==="__loaded" )continue;
			if(descs==""){
				descs = dataitem[item];
			}else{
				descs=descs + ","+dataitem[item];
			}
			break;
		}
	}
	
	return descs;
}

function showMultiBrowserDialog(selectids,srcheads,othercallback,isreport){
	var config = null;
	config= rightsplugingForBrowser.createConfig();
	var tempsrcheads=eval(srcheads);
    config.srchead=tempsrcheads;//["标题","文档所有者"];
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;//取消实时保存
    config.saveurl= "/interface/js/MutilCommomBrowserAjax.jsp?src=save&isreport="+isreport;
    config.srcurl = "/interface/js/MutilCommomBrowserAjax.jsp?src=src&isreport="+isreport;
    config.desturl = "/interface/js/MutilCommomBrowserAjax.jsp?src=dest&isreport="+isreport;
    config.delteurl="/interface/js/MutilCommomBrowserAjax.jsp?src=save&isreport="+isreport;
    config.pagesize = 10;
    config.formId = "weaver";
    config.selectids = selectids;
    config.showHead = true;
	config.searchAreaId = "e8QuerySearchArea";
    if(othercallback=="1"){
    	config.okCallbackFn = getData;
    	config.clearCallbackFn = clearData;
    }
	try{
		config.dialog = dialog;
	}catch(e){
	
	}
	
   	jQuery("#colShow").html("");
    rightsplugingForBrowser.createRightsPluing(config);
    jQuery("#btnok").bind("click",function(){
    	//alert(111);
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
    return config;
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



