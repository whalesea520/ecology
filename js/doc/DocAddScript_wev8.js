var __lastSeccategory = null;
function loadPropAndAcc(seccategory,treeNode,catoptions){
	var _document = document;
	if(catoptions){
		_document = catoptions._document || document;
	}
	if(treeNode){
		options = treeNode.options;
		if(treeNode[options.rightKey]==="N"){
			jQuery("#divContentInfoATab",_document).trigger("click");
			jQuery("#divPropATab",_document).addClass("x-tab-strip-div-disabled").hide();
			jQuery("#divAccATab",_document).addClass("x-tab-strip-div-disabled").hide();
			jQuery("#seccategory",_document).val("");
			jQuery("#SecId",_document).val("");
			__lastSeccategory = null;
			//jQuery("div#edui156").addClass("hideuploaditem");
			jQuery("div.fileupload").hide();
			return;
		}
	}
	if(!__lastSeccategory){
		__loadPropAndAcc(seccategory,treeNode,catoptions);
		__lastSeccategory = seccategory;
	}else if(__lastSeccategory!=seccategory){
		top.Dialog.confirm(__reSelectCatMsg,function(){
			__loadPropAndAcc(seccategory,treeNode,catoptions);
			__lastSeccategory = seccategory;
		},function(){
			parent.selectDefaultNode("categoryid",__lastSeccategory);
		});
	}
}

var __ajaxNum = 0;

//加载文档属性页、附件信息
function __loadPropAndAcc(seccategory,treeNode,catoptions){
	var _document = document;
	var options = null;
	
	var url = "/docs/docs/DocAddBaseInfo.jsp?timestamp="+new Date().getTime()+"&secid="+seccategory+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&prjid="+prjid+"&coworkid="+coworkid+"&crmid="+crmid+"&hrmid="+hrmid;
	if(window.__DocAddExtPage===true){
		url = "/docs/docs/DocAddExtBaseInfo.jsp?timestamp="+new Date().getTime()+"&secid="+seccategory+"&docType="+doctype+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromFlowDoc="+fromFlowDoc+"&prjid="+prjid+"&coworkid="+coworkid+"&crmid="+crmid+"&hrmid="+hrmid;
	}
	
	jQuery.post("/docs/docs/AddSecIdUseCount.jsp",{secid:seccategory});
	
	//检查最大上传附件大小
	jQuery.ajax({
		url:"/docs/category/docajax_operation.jsp?ts="+new Date().getTime()+"&secid="+seccategory,
		type:"get",
		data:{
			src:"getSecMaxUploadSize"
		},
		dataType:"json",
		beforeSend:function(){
			__ajaxNum++;
			//e8showAjaxTips(__ajaxStartMsg,true);
		},
		complete:function(xhr){
			__ajaxNum--;
			if(__ajaxNum<=0)
				e8showAjaxTips("",false);
		},
		success:function(data){
			try{
				if(parseInt(data.maxUploadSize)>0){
					bindAttachmentUpload(data.maxUploadSize);
				}else{
					//jQuery("div#edui156").addClass("hideuploaditem");
					jQuery("div.fileupload").hide();
				}
			}catch(e){}
		}
	});
	
	//加载文档属性页、附件信息
	jQuery.ajax({
		url:url,
		type:"get",
		dataType:"html",
		data:catoptions,
		beforeSend:function(){
			__ajaxNum++;
			//e8showAjaxTips(__ajaxStartMsg,true);
		},
		complete:function(xhr){
			__ajaxNum--;
			if(__ajaxNum<=0)
				e8showAjaxTips("",false);
		},
		success:function(data){
			var divPropContent = jQuery("#divPropContent",_document);
			divPropContent.html(data);
			jQuery("#divPropATab",_document).removeClass("x-tab-strip-div-disabled").show();
			var accUrl="/docs/docs/DocAcc.jsp?mode=add&pagename=docadd&isFromWf=false&operation=getDivAcc&secid="+seccategory+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
			jQuery("#e8DocAccIfrm",_document).attr("src",accUrl);
			try{
				var imageidsExt = jQuery("#imageidsExt",_document).val();
				jQuery("#delImageidsExt",_document).val(imageidsExt);
				jQuery("#imageidsExt",_document).val("");
				jQuery("#imagenamesExt",_document).val("");
			}catch(e){}
			jQuery("#divAccATab",_document).removeClass("x-tab-strip-div-disabled").show();
			jQuery("#seccategory",_document).val(seccategory);
			jQuery("#SecId",_document).val(seccategory);
			var __needinputitems = jQuery("#__needinputitems").val();
			var needinputitems = jQuery("#needinputitems").val();
			if(__needinputitems){
				if(needinputitems){
					needinputitems = needinputitems+","+__needinputitems;
				}else{
					needinputitems = __needinputitems;
				}
				jQuery("#needinputitems").val(needinputitems);
			}
			try{
				beautySelect("select");
				jQuery("#divPropContent").jNice();
			}catch(e){
				if(window.console)console.log(e,"/docs/docs/DocList.jsp#leftMenuClickFn");
			}
		}
	});
	catoptions = jQuery.extend({mouldid:-1},catoptions);
	//加载显示模板
	loadEditMould(seccategory,catoptions);
}

function getNeedinputitems(){
	return jQuery("#needinputitems").val();
}

//加载显示模板
function loadEditMould(seccategory,catoptions){
	catoptions = jQuery.extend({mouldid:0,clearContent:false},catoptions);
	if(catoptions.clearContent===true){
		if(window.__DocAddExtPage===true){//office编辑模板
			
		}else{
			if(!ue)return;
			ue.setContent("");
		}
	}
	if(catoptions.mouldid){
		//加载编辑模板
		if(window.__DocAddExtPage===true){//office编辑模板
			if(catoptions.mouldid>0){
				try{
					weaver.WebOffice.Template=catoptions.mouldid;
					weaver.WebOffice.WebOpen();  	//打开该文档
				}catch(e){
					if(window.console)console.log(e,"/js/doc/DocAddScript.js#loadEditMould");
				}
			}else{
				jQuery.ajax({
					url:"/docs/docs/LoadEditMould.jsp?timestamp="+new Date().getTime(),
					type:"get",
					dataType:"json",
					data:{
						secid:seccategory,
						mouldid:catoptions.mouldid,
						__DocAddExtPage:window.__DocAddExtPage
					},
					beforeSend:function(){
						__ajaxNum++;
						//e8showAjaxTips(__ajaxStartMsg,true);
					},
					complete:function(xhr){
						__ajaxNum--;
						if(__ajaxNum<=0)
							e8showAjaxTips("",false);
					},
					success:function(data){
						try{
							if(data.mouldid>0){
								weaver.WebOffice.Template=data.mouldid;
								weaver.WebOffice.WebOpen();  	//打开该文档
							}

						}catch(e){
							if(window.console)console.log(e,"/js/doc/DocAddScript.js#loadEditMould");
						}
					}
				});
			}
		}else{
			jQuery.ajax({
				url:"/docs/docs/LoadEditMould.jsp?timestamp="+new Date().getTime(),
				type:"get",
				dataType:"html",
				data:{
					secid:seccategory,
					mouldid:catoptions.mouldid,
					__DocAddExtPage:window.__DocAddExtPage
				},
				beforeSend:function(){
					__ajaxNum++;
					//e8showAjaxTips(__ajaxStartMsg,true);
				},
				complete:function(xhr){
					__ajaxNum--;
					if(__ajaxNum<=0)
						e8showAjaxTips("",false);
				},
				success:function(data){
					if(window.__DocAddExtPage===true){//office编辑模板
						
					}else{
						if(!ue)return;
						var content = ue.getContent();
						if(catoptions.clearContent===true){
							content = "";
						}
						content = data + content;
						ue.setContent(content);
					}
				}
			});
		}
	}
}

function afterSelectCategory(e,datas,name,params){
	if(datas){
		//if(datas.tag>0){
			 loadPropAndAcc(datas.id);
			 parent.selectDefaultNode("categoryid",datas.id);
		//}
	}
}
function afterSelectMainDoc(e,datas,name,params){
	if(datas){
		$GetEle("maindoc").value=datas.id;
	}
}

function onChangeDocType(doPage,docType){
    top.Dialog.confirm(__switchTypeMsg,function(){
        window.onbeforeunload=null;
        var gotoUrl=getGotoPage(doPage,docType);
		gotoUrl=gotoUrl+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
        location.href=gotoUrl;
        return true;
    },function(){return false;});
}