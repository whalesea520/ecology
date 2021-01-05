var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;


function saveViewMould(obj){
	//先执行套红选择模板设置的保存

	var mouldIds = "";
	var mouldObj = jQuery("#defaultSelectMould").find("input[type='hidden'][name^='multimouldids_']");
	//保存套红模板     
	if(mouldObj.length>0){
		mouldObj.each(function(){
			var index = jQuery(this).attr("name").replace(/\D/g,"");
			var seccategory = jQuery(this).closest("tr").find("#seccategory_"+index).val();
			if(!mouldIds){
				mouldIds=seccategory+"_"+jQuery(this).val();
			}else{
				mouldIds = mouldIds+"|"+seccategory+"_"+jQuery(this).val();
			}
		});
		jQuery.ajax({
			url:"officalwf_operation.jsp",
			dataType:"json",
			type:"post",
			data:{
				wfid:javaWorkflowId,
				mouldids:mouldIds,
				mouldType:"1",
				from:"selectMulti",
				operation:"attachViewMould"
			},
			success:function(data){
				if(data.result==1){
					saveEditMould(obj);
				}else{
					success = false;
					top.Dialog.alert(msg_83409);
				}
			}
		   });
	}else{
		saveEditMould(obj);
	}
}

function saveEditMould(obj){
	var mouldIds = "";
	//保存编辑模板
	mouldObj = jQuery("#editSelectMould").find("input[type='hidden'][name^='multimouldids_']");
	if(mouldObj.length>0){
		mouldObj.each(function(){
			var index = jQuery(this).attr("name").replace(/\D/g,"");
			var seccategory = jQuery(this).closest("tr").find("#seccategory_"+index).val();
			if(!mouldIds){
				mouldIds=seccategory+"_"+jQuery(this).val();
			}else{
				mouldIds = mouldIds+"|"+seccategory+"_"+jQuery(this).val();
			}
		});
	
		jQuery.ajax({
			url:"officalwf_operation.jsp",
			dataType:"json",
			type:"post",
			data:{
				wfid:javaWorkflowId,
				mouldids:mouldIds,
				mouldType:"4",
				from:"selectMulti",
				operation:"attachViewMould"
			},
			success:function(data){
				if(data.result==1){
					//保存过程设置
					var wfProcess = jQuery("#wfProcess").css("display");
					if(wfProcess!="none"){
						//保存过程设置中设置的套红节点
						jQuery("#saveThNode").val(1);
					}
					saveCreateDocument2(obj);
				}else{
					success = false;
					top.Dialog.alert(msg_83409);
				}
			}
		  });
	  }else{
		saveCreateDocument2(obj);
	  }
}

function saveCreateDocument(obj)
{   

	
	var success = true;
	
	if(jQuery("#wfDocProp").css("display")!="none"){
		//以ajax方式保存文档属性

		if(jQuery("#docPropDetailDiv").children("table").length>0){
			var docData = {
				workflowId:javaWorkflowId,
		      	selectItemId:-1,
		      	docPropId:javaDocPropIdDefault,
		      	secCategoryId:jQuery("#secCategoryDocument").val(),
		      	objId:jQuery("#objId").val(),
		      	objType:jQuery("#objType").val(),
		      	rowNum:jQuery("#rowNum").val(),
		      	isuser:jQuery("#isuser").val(),
		      	number:jQuery("#number").val(),
		      	isAjax:1
			};
			
			var params = jQuery("#oTableProp").find("input[type='hidden'],select");
			params.each(function(){
				docData[jQuery(this).attr("name")] = jQuery(this).val();
			});
			
			jQuery.ajax({
		      	url:"WorkflowDocPropDetailOperation.jsp",
		      	dataType:"json",
		      	type:"post",
		      	data:docData,
		      	success:function(data){
		      		top.Dialog.alert(msg_18758);
		      		if(dialog)
		      			dialog.getPageData(dialog,"initData",0);
		      	}
		     });
		}
	} else if(jQuery("#wfTraceProp").css("display")!="none") {
		if(jQuery("#tracePropDetailDiv").children("table").length>0){
			var docData = {
				workflowId:javaWorkflowId,
		      	docPropId_Trace:javaDocPropId_Trace,
		      	tracesavesecpath:jQuery("#tracesavesecpath").val(),
		      	rowNum_Trace:jQuery("#rowNum_Trace").val(),
		      	isAjax:1,
		      	tracefieldid:jQuery("#tracefieldid").val(),
		      	tracesavesecid:jQuery("#tracesavesecid").val(),
		      	tracedocownertype:jQuery("#tracedocownertype").val(),
		      	tracedocownerfieldid:jQuery("#tracedocownerfieldid").val(),
				tracedocowner:jQuery("#tracedocowner").val()			
			};
							
			var params = jQuery("#oTableProp_Trace").find("input[type='hidden'],select");
			params.each(function(){
				docData[jQuery(this).attr("name")] = jQuery(this).val();
			});
			
			jQuery.ajax({
		      	url:"WorkflowTracePropDetailOperation.jsp",
		      	dataType:"json",
		      	type:"post",
		      	beforeSend:function(){
					e8showAjaxTips(msg_33113,true);
				},
				complete:function(){
					e8showAjaxTips("",false);
				},
		      	data:docData,
		      	success:function(data){
		      		top.Dialog.alert(msg_18758);
		      	}
		     });
		}
	} else {
		//以ajax方式保存动作
		var lastTR = jQuery("#actionList").find("table.grouptable tbody tr[class='contenttr']:last");
		var name = lastTR.children("td:first").find("input[type='checkbox']").attr("name");
		if(!jQuery("#wfEditMould").is(":hidden") ){
		  jQuery("#tabIndex").val("3");
		}

			var idx = -1;
			try{
				idx = name.substring(name.lastIndexOf("_")+1,name.length);
			}catch(e){}
			var docData = {
					wfid:javaWorkflowId,
					operation:"saveActionList",
			      	rowNum:parseInt(idx)+1,
					isUse:jQuery("#isUse").attr("checked") ? 1 : 0
				};
			var params = jQuery("#actionList").find("input[type='hidden'],input[type='checkbox'],select");
			params.each(function(){
				if(jQuery(this).attr("type")=="checkbox" && !jQuery(this).hasClass("groupselectbox")){
					docData[jQuery(this).attr("name")] = jQuery(this).attr("checked")?"1":"0";
				}else{
					docData[jQuery(this).attr("name")] = jQuery(this).val();
				}
			});			
			jQuery.ajax({
		      	url:"officalwf_operation.jsp",
		      	dataType:"json",
		      	type:"post",
		      	data:docData,
		      	success:function(data){
		      		if(data.result==1){
						saveViewMould(obj);						   
					}else{success = false;}
		      	}
		     });
	}
}


function saveCreateDocument2(obj){
	if($GetEle("show").checked)
	    {
	        if (check_form(createDocumentByWorkFlow,'pathCategoryDocument'))
	    	{
	    	    createDocumentByWorkFlow.submit();
	    	    obj.disabled=true;
	    	}
	    }
	    else
	    {
	        createDocumentByWorkFlow.submit();
	        obj.disabled=true;
	    }  
    
}

function showContent()
{
    if($GetEle("show").checked)
    {
        showGroup("abbrtable");
    }
    else
    {
    	hideGroup("abbrtable");
    }
}

function onShowPrintNodes(inputName,spanName){
    var workflowId = javaWorkflowId;
	printNodes=inputName.value;
    tempUrl=escape("/workflow/workflow/WorkflowNodeBrowserMulti.jsp?printNodes="+printNodes+"&workflowId="+workflowId);
    var result =window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+tempUrl,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");

    if (result != null){
		if (result.id!=""){  
		    inputName.value=result.id;
		    spanName.innerHTML="<a href='#"+result.id+"'>"+result.name+"</a>";
		}else{
		    inputName.value="0";
		    spanName.innerHTML="";
		}
    }
}

function onchangeIsCompellentMark(){
	var cIsCompellentMark = $GetEle("isCompellentMark").checked;
	if(cIsCompellentMark == true){
		jQuery("#isCancelCheck").trigger("checked",true);
		jQuery("#isCancelCheck").trigger("disabled",true);
		$GetEle("isCancelCheckInput").value = "1";
	}else{
		jQuery("#isCancelCheck").trigger("disabled",false);
	}
}

function onchangeIsCancelCheck(){
	var cIsCancelCheck = $GetEle("isCancelCheck").checked;
	if(cIsCancelCheck == true){
		$GetEle("isCancelCheckInput").value = "1";
	}else{
		$GetEle("isCancelCheckInput").value = "0";
	}
}

function onShowCatalogOfDocument(spanName) 
{
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if (result != null) 
    {
        if (result.tag =="1")  
        {
            $("#"+spanName).html("<a href='#"+result.id+"'>"+result.path+"</a>");
            $("input[name=pathCategoryDocument]").val(result.path);
            $("#mainCategoryDocument").val(result.mainid);
            $("#subCategoryDocument").val(result.subid);
            $("#secCategoryDocument").val(result.id);
        }
        else
        {
            $("#"+spanName).empty();
            $("input[name=pathCategoryDocument]").val("");
            $("input[name=mainCategoryDocument]").val("");
            $("input[name=subCategoryDocument]").val("");
            $("input[name=secCategoryDocument]").val("");
        }
    }
}

function onShowCatalogData(event,datas,name,paras){
	var ids = datas.id;
	var idarr= new Array();
	idarr=ids.split(",");
    $("#pathCategoryDocument").val(datas.path);
    $("#mainCategoryDocument").val(datas.mainid);
    $("#subCategoryDocument").val(datas.subid);
    $("#secCategoryDocument").val(datas.id);
    if(datas.id){
    	initDefaultDocProp();
    }else{
    	jQuery("#docPropDetailDiv").html("");
    }	 
}

function onShowCatalogData_trace(event,datas,name,paras) {
	var allId = '';
	var secId = '';
	if (!!datas.mainid && !!datas.subid && !!datas.id) {
		allId = datas.mainid+","+datas.subid+","+datas.id;
		secId = datas.id;
	} else {
		allId = datas.id;
		secId = allId.split(',')[2];
	}
	jQuery("#tracesavesecpath").val(allId);
	jQuery("input:hidden[name='tracesavesecid']").val(secId);
	getDocProperties(secId);
}

function getDocProperties(id,isInit){
	jQuery.ajax({
		url:"WorkflowTracePropDetailAjax.jsp",
		type:"post",
		dataType:"html",
		data:{
			workflowId:javaWorkflowId,
			secCategoryId:""+id,
			docPropId_Trace:javaDocPropId_Trace
		},
		beforeSend:function(xhr){
			try{
				e8showAjaxTips("正在获取数据，请稍候...",true);
			}catch(e){}
		},
		complete:function(xhr){
			e8showAjaxTips("",false);
		},
		success:function(data){
			jQuery("#tracePropDetailDiv").html(data);
			initLayoutForCss();
			beautySelect();
		}
	});
}

jQuery(document).ready(function(){
	getDocProperties(javaTracesavesecid,true);
});

function _userDelCallback(text,name){
	if(name=="pathCategoryDocument"){
	  $("input[name=pathCategoryDocument]").val("");
	  $("input[name=mainCategoryDocument]").val("");
	  $("input[name=subCategoryDocument]").val("");
	  $("input[name=secCategoryDocument]").val("");
	  jQuery("#docPropDetailDiv").html("");
	}
}

function detailConfig(flowID, selectItemID, pathCategory, secCategoryID, formID, mouldID)
{
	if("" == pathCategory || null == pathCategory)
	{
		alert(msg_19373);
		return;
	}
	else
	{
		pathCategory = escape(pathCategory);
		window.location = 'CreateDocumentDetailByWorkFlow.jsp?ajax=1&flowID=' + flowID + '&selectItemID=' + selectItemID + '&pathCategory=' + pathCategory + '&secCategoryID=' + secCategoryID + '&formID=' + formID + '&mouldID=' + mouldID;
	}
}

function docPropDetailConfig(docPropId,workflowId,selectItemId, pathCategory, secCategoryId){
	if("" == pathCategory || null == pathCategory){
		alert(msg_19373);
		return;
	}else{
		pathCategory = escape(pathCategory);
		window.location = 'WorkflowDocPropDetail.jsp?ajax=1&docPropId=' + docPropId + '&workflowId=' + workflowId+ '&selectItemId=' + selectItemId + '&pathCategory=' + pathCategory + '&secCategoryId=' + secCategoryId;
	}
}

function detailBarCodeSet(workflowId, formID, isbill){
		window.location = 'WorkflowBarCodeSet.jsp?ajax=1&workflowId=' + workflowId + '&formId=' + formID + '&isBill=' + isbill ;
}

function onShowSubcompanyShowAttr(workflowId,formId,isBill,fieldId,selectValue){
	var url = "/systeminfo/BrowserMain.jsp?mouldID=workflow&url="+encode("/workflow/workflow/showSubcompanyShowAttrList.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&fieldId="+fieldId+"&selectValue="+selectValue);
	mouldDialog = new top.Dialog();
	mouldDialog.currentWindow = window;
	mouldDialog.URL=url;
	mouldDialog.checkData = false;
	mouldDialog.Title = msg_22878_33405;
	mouldDialog.Width = 600;
	mouldDialog.Height = 500;
	mouldDialog.maxiumnable = true;
	mouldDialog.show();
}

function encode(str){
    return escape(str);
}

function toggleTitleFieldId(obj){
	var val = jQuery(obj).val();
	if(val=="-1"){
		hideEle("titleFieldId");
	}else{
		showEle("titleFieldId");
	}
}

function toggleGroup(obj){
	var val = jQuery(obj).val();
	if(val=="-1"){
		hideGroup("defaultMouldSetting");
		hideGroup("selectMouldSetting");
	}else{
		showGroup("defaultMouldSetting");
		toggleSelectGroup("#documentLocation");
	}
}

function toggleSelectGroup(obj){
	var val = jQuery(obj).val();
	if(val=="-1"){
		hideGroup("selectMouldSetting");
	}else{
		showGroup("selectMouldSetting");
	}
}

function togglePropSelectGroup(obj){
	var val = jQuery(obj).val();
	if(val=="-1"){
		hideGroup("propSetting");
	}else{
		showGroup("propSetting");
	}
}

function toggleEditSelectGroup(obj){
	var val = jQuery(obj).val();
	if(val=="-1"){
		hideGroup("selectEditMouldSetting");
	}else{
		showGroup("selectEditMouldSetting");
	}
}

var mouldDialog = null;

//type  0:默认套红模板  1：选择字段套红模板
//mouldId  模板ID
function setMouldBookMark(type,mouldId){
	mouldDialog = new top.Dialog();
	mouldDialog.currentWindow = window;
	mouldDialog.URL="/docs/tabs/DocCommonTab.jsp?selectItemID=-1&isWorkflowDoc=1&_fromURL=51&isdialog=1&mouldId="+mouldId+"&type="+type+"&flowID="+javaWorkflowId+"&secCategoryID="+jQuery("#secCategoryDocument").val()+"&formID="+jQuery("#formID").val()+"&fromdefMould=1";
	mouldDialog.Title = msg_33338;
	mouldDialog.Width = 600;
	mouldDialog.Height = 400;
	mouldDialog.maxiumnable = true;
	mouldDialog.show();
}

function setMouldBookMarkEdit(type,mouldId){
	mouldDialog = new top.Dialog();
	mouldDialog.currentWindow = window;
	mouldDialog.URL="/docs/tabs/DocCommonTab.jsp?selectItemID=-1&isWorkflowDoc=1&_fromURL=54&isdialog=1&mouldId="+mouldId+"&type="+type+"&flowID="+javaWorkflowId+"&secCategoryID="+jQuery("#secCategoryDocument").val()+"&formID="+jQuery("#formID").val()+"&fromdefMould=1";
	mouldDialog.Title = msg_33338;
	mouldDialog.Width = 600;
	mouldDialog.Height = 400;
	mouldDialog.maxiumnable = true;
	mouldDialog.show();
}

function setDef(){
	jQuery("input[name='setDef']").unbind("click.custom").bind("click.custom",function(){
			var docData = {
				option:"viewMould",
				docMouldID:jQuery(this).val(),
				wfid:javaWorkflowId
		      
			};
	   jQuery.ajax({
		      	url:"setDefOperation.jsp",
		      	dataType:"json",
		      	type:"post",		      
		      	data:docData,
		      	success:function(data){
		      		
		      	}
		     });
		});
	

}

function setDefEdit(){
	jQuery("input[name='setDefEdit']").unbind("click.custom").bind("click.custom",function(){
			var docData = {
				option:"editMould",
				docMouldID:jQuery(this).val(),
				wfid:javaWorkflowId
		      
			};
	   jQuery.ajax({
		      	url:"setDefOperation.jsp",
		      	dataType:"json",
		      	type:"post",		      
		      	data:docData,
		      	success:function(data){
		      		
		      	}
		     });
		});
	

}


function setMouldBookMarkMulti(type,selectItemID,secCategoryID,idx){
	
	var mouldids = jQuery("#defaultSelectMould").find("#multimouldids_"+idx).val();
	if(!mouldids){
		top.Dialog.alert(msg_33400);
		return;
	}
	mouldDialog = new top.Dialog();
	mouldDialog.currentWindow = window;
	mouldDialog.URL="/docs/tabs/DocCommonTab.jsp?selectItemID="+selectItemID+"&isWorkflowDoc=1&_fromURL=51&isdialog=1&mouldId="+mouldids+"&type=1&flowID="+javaWorkflowId+"&secCategoryID="+secCategoryID+"&formID="+jQuery("#formID").val();
	mouldDialog.Title = msg_33338;
	mouldDialog.Width = 600;
	mouldDialog.Height = 400;
	mouldDialog.maxiumnable = true;
	mouldDialog.show();
}

function setMouldBookMarkEditMulti(type,selectItemID,secCategoryID,idx){
	
	var mouldids = jQuery("#editSelectMould").find("#multimouldids_"+idx).val();
	if(!mouldids){
		top.Dialog.alert(msg_33400);
		return;
	}
	mouldDialog = new top.Dialog();
	mouldDialog.currentWindow = window;
	mouldDialog.URL="/docs/tabs/DocCommonTab.jsp?selectItemID="+selectItemID+"&isWorkflowDoc=1&_fromURL=54&isdialog=1&mouldId="+mouldids+"&type=1&flowID="+javaWorkflowId+"&secCategoryID="+secCategoryID+"&formID="+jQuery("#formID").val();
	mouldDialog.Title = msg_33338;
	mouldDialog.Width = 600;
	mouldDialog.Height = 400;
	mouldDialog.maxiumnable = true;
	mouldDialog.show();
}

function setPropMulti(docPropId,selectItemID,selectvalue,secCategoryID,docCategory,idx){
	mouldDialog = new top.Dialog();
	mouldDialog.currentWindow = window;
	mouldDialog.URL="/docs/tabs/DocCommonTab.jsp?fieldId="+selectItemID+"&selectItemId="+selectvalue+"&isWorkflowDoc=1&_fromURL=53&isdialog=1&docPropId="+docPropId+"&type=1&workflowId="+javaWorkflowId+"&secCategoryId="+secCategoryID+"&formID="+jQuery("#formID").val();
	mouldDialog.Title = msg_33197_30747;
	mouldDialog.Width = 600;
	mouldDialog.Height = 500;
	mouldDialog.maxiumnable = true;
	mouldDialog.show();
}

function attachRelative(container){
	mouldDialog = new top.Dialog();
	mouldDialog.currentWindow = window;
	var mouldids = ""; 
	jQuery("#"+container+" table tbody").find("input[type='checkbox']").each(function(){
		if(mouldids==""){
			mouldids = jQuery(this).val();
		}else{
			mouldids +=","+ jQuery(this).val();
		}
	});
	if(container==="defaultMouldList"){
		mouldDialog.URL="/docs/tabs/DocCommonTab.jsp?isWorkflowDoc=1&_fromURL=50&mouldType=0&isdialog=1&wfid="+javaWorkflowId+"&selectids="+mouldids;
	}else if(container==="defaultEditMouldList"){
		mouldDialog.URL="/docs/tabs/DocCommonTab.jsp?isWorkflowDoc=1&_fromURL=50&mouldType=3&isdialog=1&wfid="+javaWorkflowId+"&selectids="+mouldids;
	}
	mouldDialog.Title = msg_33325;
	mouldDialog.Width = 600;
	mouldDialog.Height = 210;
	mouldDialog.show();
}

function detachRelative(container){
	var mouldids = "";
	jQuery("#"+container).find("input[type='checkbox']:checked").each(function(){
		if(mouldids==""){
			mouldids = jQuery(this).val();
		}else{
			mouldids +=","+ jQuery(this).val();
		}
	});
	if(!mouldids){
		top.Dialog.alert(msg_32568);
		return;
	}
	top.Dialog.confirm(msg_16344,function(){
		var operation = "";
		if(container==="defaultMouldList"){
			operation = "detachViewMould";
		}else if(container==="defaultEditMouldList"){
			operation = "detachEditMould";
		}
		jQuery.ajax({
			url:"/workflow/workflow/officalwf_operation.jsp?timestamp="+new Date().getTime(),
			type:"post",
			dataType:"json",
			data:{
				wfid:javaWorkflowId,
				operation:operation,
				mouldids:mouldids
			},
			beforeSend:function(){
				e8showAjaxTips(msg_33592,true);
			},
			complete:function(){
				e8showAjaxTips("",false);
			},
			success:function(data){
				if(data.result==1){
					if(container=="defaultMouldList"){
						group.deleteRows();
					}else{
						editGroup.deleteRows();
					}
				}else{
					top.Dialog.alert(msg_83473);
				}
			}
		});
	});
}

function loadMould(value,isInit){
	jQuery.ajax({
		url:"/workflow/workflow/chooseDisplayAttributeIForm.jsp?timestamp="+new Date().getTime()+"&wfid="+javaWorkflowId+"&fieldId="+value,
		type:"post",
		dataType:"html",
		beforeSend:function(){
			if(!isInit){
				e8showAjaxTips(msg_33592,true);
			}
		},
		complete:function(){
			e8showAjaxTips("",false);
		},
		success:function(data){
			jQuery("#defaultSelectMould").html(data);
			initLayoutForCss();
			if(isInit && dialog)
				dialog.getPageData(dialog,"initData",0);
		}
	});
}

function loadEditMould(value,isInit){
	jQuery.ajax({
		url:"/workflow/workflow/chooseEditAttributeIForm.jsp?timestamp="+new Date().getTime()+"&wfid="+javaWorkflowId+"&fieldId="+value,
		type:"post",
		dataType:"html",
		beforeSend:function(){
			if(!isInit){
				e8showAjaxTips(msg_33592,true);
			}
		},
		complete:function(){
			e8showAjaxTips("",false);
		},
		success:function(data){
			jQuery("#editSelectMould").html(data);
			initLayoutForCss();
			if(isInit && dialog)
				dialog.getPageData(dialog,"initData",0);
		}
	});
}

function loadProp(value,isInit){
	jQuery.ajax({
		url:"/workflow/workflow/chooseDisplayPropIForm.jsp?timestamp="+new Date().getTime()+"&wfid="+javaWorkflowId+"&fieldId="+value,
		type:"post",
		dataType:"html",
		beforeSend:function(){
			if(!isInit){
				e8showAjaxTips(msg_33592,true);
			}
		},
		complete:function(){
			e8showAjaxTips("",false);
		},
		success:function(data){
			jQuery("#selectPropDiv").html(data);
			initLayoutForCss();
			if(isInit && dialog)
				dialog.getPageData(dialog,"initData",0);
		}
	});
}

function initDefaultDocProp(isInit){
	jQuery.ajax({
		url:"WorkflowDocPropDetailAjax.jsp?timestamp="+new Date().getTime(),
		type:"get",
		dataType:"html",
		data:{
			docPropId:javaDocPropIdDefault,
			workflowId:javaWorkflowId,
			selectItemId:-1,
			secCategoryId:jQuery("#secCategoryDocument").val()
		},
		success:function(data){
			jQuery("#docPropDetailDiv").html(data);
			initLayoutForCss();
			beautySelect();
			if(isInit && dialog)
				dialog.getPageData(dialog,"initData",0);
		}
	});
}

function initProcessDefine(isInit){
	jQuery.ajax({
		url:"WorkflowProcessDefine.jsp?timestamp="+new Date().getTime(),
		type:"get",
		dataType:"html",
		data:{
			wfid:javaWorkflowId,
			officalType:jQuery("#officalType").val()
		},
		beforeSend:function(){
			if(!isInit){
				e8showAjaxTips(msg_33592,true);
			}
		},
		complete:function(){
			e8showAjaxTips("",false);
		},
		success:function(data){
			jQuery("#processDefineDiv").html(data);
			initLayoutForCss();
			beautySelect();
			if(isInit && dialog)
				dialog.getPageData(dialog,"initData",0);
		}
	});
}

function addPDFSet(formid,isbill){
       var dialog = new window.top.Dialog();
	    dialog.currentWindow = window; 
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=1101&subCompanyID="+javaSubCompanyID+"&isbill="+isbill+"&formid"+formid+"&wfid="+javaWorkflowId;
		dialog.Title = msg_82;
		dialog.Width = jQuery(document).width();
		dialog.Height = 610;
		dialog.checkDataChange = false;
		dialog.maxiumnable = true;
		dialog.show();

}

function delPDFSet(id){
	window.top.Dialog.confirm(msg_33435,function(){ 
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert(msg_32568);
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	 jQuery.ajax({
			url:"TextToPdfOperation.jsp",
			type:"post",
			beforeSend:function(){
				e8showAjaxTips(msg_33113,true);
			},
			complete:function(){
				e8showAjaxTips("",false);
			},
			data:{
				method:"delete",
				id:id	
			
			},
			success:function(data){
					_table.reLoad()	;
			}
		   });
	
    }); 
  }
  function delPDFSet2(id){
	  window.top.Dialog.confirm(msg_33435,function(){ 
	 jQuery.ajax({
			url:"TextToPdfOperation.jsp",
			type:"post",
			beforeSend:function(){
				e8showAjaxTips(msg_33113,true);
			},
			complete:function(){
				e8showAjaxTips("",false);
			},
			data:{
				method:"delete",
				id:id	
			
			},
			success:function(data){
					_table.reLoad()	;
			}
		   });
     }); 
  }

    function editPDFSet(id){
	  var dialog = new window.top.Dialog();
	  var formid = javaFormId;
	  var isbill = javaIsBill;
	    dialog.currentWindow = window; 
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?id="+id+"&_fromURL=1102&subCompanyID="+javaSubCompanyID+"&isbill="+isbill+"&formid="+formid+"&wfid="+javaWorkflowId;
		dialog.Title = msg_93;
		dialog.Width = jQuery(document).width();
		dialog.Height = 610;
		dialog.checkDataChange = false;
		dialog.maxiumnable = true;
		dialog.show();

  
  }

jQuery(document).ready(function(){
	jQuery(".e8tips").wTooltip({html:true});
	if(jQuery("#documentLocation").val()!=-1){
		loadMould(jQuery("#documentLocation").val(),true);
	}
	
	if(jQuery("#documentEditLocation").val()!=-1){
		loadEditMould(jQuery("#documentLocation").val(),true);
	}
	
	if(jQuery("#documentPropLocation").val()!=-1){
		loadProp(jQuery("#documentLocation").val(),true);
	}
	initDefaultDocProp(true);
	initProcessDefine(true);
});

function onchangetracedocownertype(objvalue){
	var tracedocownertype = objvalue;
	document.getElementById("selecttracedocowner").style.display = "none";
	document.getElementById("tracedocownerspan").style.display = "none";
	jQuery("#tracedocownerfieldid").selectbox("hide");
	try{
		if(tracedocownertype=="1"){
			document.getElementById("selecttracedocowner").style.display = "";
			document.getElementById("tracedocownerspan").style.display = "";
		}else if(tracedocownertype=="2"){
			jQuery("#tracedocownerfieldid").selectbox("show");
		}
	}catch(e){}
}
