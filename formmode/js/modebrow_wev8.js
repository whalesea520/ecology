/**
 * browser回调方法
 */
function wfbrowvaluechange(obj, fieldid, rowindex) {
	
}

function wrapshowhtml(ahtml, id,ismast) {
	var str = "<span class=\"e8_showNameClass\">";
	str += ahtml;
	var mastinput = 1;//2：必须输入 ；1：可编辑
	if(ismast){
		mastinput = ismast;
	}
	str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this,"+mastinput+",false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
	return str;
}

function getajaxurl(typeId, fielddbtype, inputIdOrName, iscustom) {
	var url = "";
	if(typeId==12|| typeId==4||typeId==57||typeId==7 || typeId==18 || typeId==164 || typeId== 194 || typeId==23 || typeId==26 || typeId==3 || typeId==8 || typeId==135
	   || typeId== 65 || typeId==9 || typeId== 89 || typeId==87 || typeId==58 || typeId==59){
		url = "/data.jsp?type=" + typeId;			
	} else if(typeId==1 || typeId==165 || typeId==166 || typeId==17){
		url = "/data.jsp";
	} else {
		url = "/data.jsp?type=" + typeId;
		if(fielddbtype){
			url += "&fielddbtype="+encodeURIComponent(fielddbtype);
		}
	}
	//拼接浏览数据自定义参数
    try {
		if (isCanConfigType(typeId)) {
			if (url.indexOf('?') < 0) {
				url += '?' + getUserDefinedRequestParam(inputIdOrName);
			} else {
				url += '&' + getUserDefinedRequestParam(inputIdOrName);
			}
		}
	} catch(e) {}
	if(typeId==161||typeId==162){
	    return getUrlPara(url, fielddbtype, inputIdOrName, iscustom);
	}else{
		return url;
	}
}

function getUrlPara(url, fielddbtype, fieldid, iscustom) {
	var formid = getDialogArgumentValueByName("formid");
	var isbill = getDialogArgumentValueByName("isbill");
	var workflowid = getDialogArgumentValueByName("workflowid");
	var browserType = fielddbtype;
	var frombrowserid = fieldid;
	var strdata = "formid="+formid+"&isbill="+isbill+"&workflowid="+workflowid+"&browserType="+browserType+"&frombrowserid="+frombrowserid+"&iscustom="+iscustom;
	jQuery.ajax({
		url : "/formmode/browser/GetBrowserParas.jsp",
		type : "post",
		async:false,
		contentType: "application/x-www-form-urlencoded; charset=utf-8",
		processData : false,
		data : strdata,
		dataType : "xml",
		success: function do4Success(msg){
			try{
				var needChangeField = msg.getElementsByTagName("value")[0].childNodes[0].nodeValue;
				var fieldids = needChangeField.split(",");
				for(var i=0;i<fieldids.length;i++){
					var fieldid = fieldids[i].replace(/(^\s*)|(\s*$)/g,"");
					if(fieldid!=""){
						if(fieldid.indexOf("=")>1)
						{
							var newfilenames = fieldid.split("=");
							var searchfieldname = newfilenames[0];
							var workflowfieldid = newfilenames[1];
							url += "&"+searchfieldname+"=";
							if(iscustom==1){
								var tempfieldid="";
								if (workflowfieldid.indexOf("field") > -1) {
									tempfieldid = "con"+workflowfieldid.substring(workflowfieldid.indexOf("field")+5)+"_value";
								} else {
									tempfieldid = "con"+workflowfieldid+"_value";
								}
								url += getDialogArgumentValueByName(tempfieldid);
							} else {
								url += getDialogArgumentValueByName(workflowfieldid);
							}
						}
					}
				}
			}catch(e){
			}
		},
		error:function(){
		}
	});
	//alert(url);
	return url;
}

function getDialogArgumentValueByName(name) {
	var ele = document.getElementById(name);
	if (ele == undefined || ele == null) {
		var eles = document.getElementsByName(name);
		if (eles != undefined && eles != null && eles.length > 0) {
			ele = eles[0];
		}
	}
	if (ele) {
		return escape(ele.value);
	}
	return "";
}

function showOrHideBrowserImg(ismand,_fieldStr,id,value){
	if (ismand == 0) {
			jQuery("#"+_fieldStr+id+"spanimg").html("");
	} else {
		if(value==""){
			jQuery("#"+_fieldStr+id+"spanimg").html("<img align='absmiddle' src='/images/BacoError_wev8.gif'>");
		}else{
			jQuery("#"+_fieldStr+id+"spanimg").html("");
		}
	}
}


function initDetailBrow(fieldid, detaibrowshowid, detaibrowshowname, detailbrowclick, isSingle, isdemand, completeUrl, onPropertyChange, hasAdd, addOnClick) {
	var hasinput = true;
	var nameSplitFlag = null;
	if(completeUrl&&(completeUrl.indexOf("getajaxurl(256,")!=-1||completeUrl.indexOf("getajaxurl(257,")!=-1)){
		hasinput = false;
		nameSplitFlag = "&nbsp";
	}
	if(completeUrl&&(completeUrl.indexOf("getajaxurl(161,")!=-1)){
		nameSplitFlag = "&nbsp";
	}
	jQuery("#" + fieldid + "wrapspan").e8Browser({
	   name:fieldid,
	   viewType:"1",
	   browserValue: detaibrowshowid,
	   browserSpanValue: detaibrowshowname,
	   browserOnClick : detailbrowclick,
	   hasInput: hasinput,
	   isSingle: isSingle,
	   hasBrowser: true, 
	   isMustInput: isdemand,
	   completeUrl: completeUrl,
	   width: "80%",
	   needHidden: false,
	   onPropertyChange: onPropertyChange,
	   hasAdd: hasAdd,
	   addOnClick: addOnClick,
	   nameSplitFlag : nameSplitFlag
	});
}

/**
 * 角色人员
 */
function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {
	var tmpids = $GetEle("field" + id).value;
	url = url + roleid + "_" + tmpids;
	//id1 = window.showModalDialog(url);
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = null;
	dialog.URL = url;
	dialog.callbackfun = function (paramobj, id1) {
		if (id1) {
			if (wuiUtil.getJsonValueByIndex(id1, 0) != ""
					&& wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
	
				var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
				var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
				var sHtml = "";
	
				resourceids = resourceids.substr(1);
				resourcename = resourcename.substr(1);
	
				$GetEle("field" + id).value = resourceids;
	
				var idArray = resourceids.split(",");
				var nameArray = resourcename.split(",");
				for ( var _i = 0; _i < idArray.length; _i++) {
					var curid = idArray[_i];
					var curname = nameArray[_i];
	
					sHtml = sHtml + "<a href=" + linkurl + curid
							+ " target='_new'>" + curname + "</a>&nbsp";
				}
	
				$GetEle("field" + id + "span").innerHTML = sHtml;
	
			} else {
				if (ismand == 0) {
					$GetEle("field" + id + "span").innerHTML = "";
				} else {
					$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
				}
				$GetEle("field" + id).value = "";
			}
		}
	
	};
	dialog.Title = "请选择";
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	//dialog.maxiumnable = true;
	dialog.show();
}

/**
 * 人力资源条件
 */
function onShowResourceConditionBrowser(id, url, linkurl, type1, ismand) {
	var tmpids = $GetEle("field" + id).value;
	//var dialogId = window.showModalDialog(url + "?resourceCondition=" + tmpids);
	
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = null;
	dialog.URL = url + "?resourceCondition=" + tmpids;
	dialog.callbackfun = function (paramobj, dialogId) {
		if (dialogId) {
			if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
				var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
				var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
				var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
				var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
				var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
				var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
				var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
				var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);
	
				var sHtml = "";
				var fileIdValue = "";
				
				var shareTypeValueArray = shareTypeValues.split("~");
				var shareTypeTextArray = shareTypeTexts.split("~");
				var relatedShareIdseArray = relatedShareIdses.split("~");
				var relatedShareNameseArray = relatedShareNameses.split("~");
				var rolelevelValueArray = rolelevelValues.split("~");
				var rolelevelTextArray = rolelevelTexts.split("~");
				var secLevelValueArray = secLevelValues.split("~");
				var secLevelTextArray = secLevelTexts.split("~");
				for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {
					var shareTypeValue = shareTypeValueArray[_i];
					var shareTypeText = shareTypeTextArray[_i];
					var relatedShareIds = relatedShareIdseArray[_i];
					var relatedShareNames = relatedShareNameseArray[_i];
					var rolelevelValue = rolelevelValueArray[_i];
					var rolelevelText = rolelevelTextArray[_i];
					var secLevelValue = secLevelValueArray[_i];
					var secLevelText = secLevelTextArray[_i];
					if (shareTypeValue == "") {
						continue;
					}
					fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
							+ relatedShareIds + "_" + rolelevelValue + "_"
							+ secLevelValue;
					
					if (shareTypeValue == "1") {
						sHtml = sHtml + "," + shareTypeText + "("
								+ relatedShareNames + ")";
					} else if (shareTypeValue == "2") {
						sHtml = sHtml
								+ ","
								+ shareTypeText
								+ "("
								+ relatedShareNames
								+ ")"
								+ "安全级别>="
								+ secLevelValue
								+ "的分部成员";
					} else if (shareTypeValue == "3") {
						sHtml = sHtml
								+ ","
								+ shareTypeText
								+ "("
								+ relatedShareNames
								+ ")"
								+ "安全级别>="
								+ secLevelValue
								+ "的部门成员";
					} else if (shareTypeValue == "4") {
						sHtml = sHtml
								+ ","
								+ shareTypeText
								+ "("
								+ relatedShareNames
								+ ")"
								+ "共享级别="
								+ rolelevelText
								+ "  安全级别>="
								+ secLevelValue
								+ "的角色成员";
					} else {
						sHtml = sHtml
								+ ","
								+ "安全级别>="
								+ secLevelValue
								+ "的所有人";
					}
	
				}
				
				sHtml = sHtml.substr(1);
				fileIdValue = fileIdValue.substr(1);
	
				$GetEle("field" + id).value = fileIdValue;
				$GetEle("field" + id + "span").innerHTML = sHtml;
				if (!!$GetEle("field" + id + "spanimg")) {
                        $GetEle("field" + id + "spanimg").innerHTML = "";
                }
			} else {
				if (ismand == 0) {
					$GetEle("field" + id + "span").innerHTML = "";
					if (!!$GetEle("field" + id + "spanimg")) {
                        $GetEle("field" + id + "spanimg").innerHTML = "";
                	}
				} else {
					if(!!$GetEle("field" + id + "spanimg")){
                    	$GetEle("field" + id + "spanimg").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                    	$GetEle("field" + id + "span").innerHTML = "";
					} else {
						$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
				}
				$GetEle("field" + id).value = "";
		    }
		}
	}; 
	dialog.Title = "请选择";
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	//dialog.maxiumnable = true;
	dialog.show();
}

/**
 * 人力资源条件
 */
function onShowResourceConditionBrowserForCondition(id, url, linkurl, type1, ismand) {
	var tmpids = $GetEle(id).value;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = url + "?resourceCondition=" + tmpids;
	dialog.callbackfun = function (paramobj, dialogId) {
		if (dialogId) {
			if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
				var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
				var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
				var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
				var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
				var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
				var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
				var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
				var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);
	
				var sHtml = "";
				var fileIdValue = "";
				
				var shareTypeValueArray = shareTypeValues.split("~");
				var shareTypeTextArray = shareTypeTexts.split("~");
				var relatedShareIdseArray = relatedShareIdses.split("~");
				var relatedShareNameseArray = relatedShareNameses.split("~");
				var rolelevelValueArray = rolelevelValues.split("~");
				var rolelevelTextArray = rolelevelTexts.split("~");
				var secLevelValueArray = secLevelValues.split("~");
				var secLevelTextArray = secLevelTexts.split("~");
				for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {
					var shareTypeValue = shareTypeValueArray[_i];
					var shareTypeText = shareTypeTextArray[_i];
					var relatedShareIds = relatedShareIdseArray[_i];
					var relatedShareNames = relatedShareNameseArray[_i];
					var rolelevelValue = rolelevelValueArray[_i];
					var rolelevelText = rolelevelTextArray[_i];
					var secLevelValue = secLevelValueArray[_i];
					var secLevelText = secLevelTextArray[_i];
					if (shareTypeValue == "") {
						continue;
					}
					fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
							+ relatedShareIds + "_" + rolelevelValue + "_"
							+ secLevelValue;
					
					if (shareTypeValue == "1") {
						sHtml = sHtml + "," + shareTypeText + "("
								+ relatedShareNames + ")";
					} else if (shareTypeValue == "2") {
						sHtml = sHtml
								+ ","
								+ shareTypeText
								+ "("
								+ relatedShareNames
								+ ")"
								+ "安全级别>="
								+ secLevelValue
								+ "的分部成员";
					} else if (shareTypeValue == "3") {
						sHtml = sHtml
								+ ","
								+ shareTypeText
								+ "("
								+ relatedShareNames
								+ ")"
								+ "安全级别>="
								+ secLevelValue
								+ "的部门成员";
					} else if (shareTypeValue == "4") {
						sHtml = sHtml
								+ ","
								+ shareTypeText
								+ "("
								+ relatedShareNames
								+ ")"
								+ "共享级别="
								+ rolelevelText
								+ "  安全级别>="
								+ secLevelValue
								+ "的角色成员";
					} else {
						sHtml = sHtml
								+ ","
								+ "安全级别>="
								+ secLevelValue
								+ "的所有人";
					}
	
				}
				
				sHtml = sHtml.substr(1);
				fileIdValue = fileIdValue.substr(1);
	
				$GetEle(id).value = fileIdValue;
				$GetEle(id + "span").innerHTML = sHtml;
				if (!!$GetEle(id + "spanimg")) {
                        $GetEle(id + "spanimg").innerHTML = "";
                }
			} else {
				if (ismand == 0) {
					$GetEle(id + "span").innerHTML = "";
					if (!!$GetEle(id + "spanimg")) {
                        $GetEle(id + "spanimg").innerHTML = "";
                	}
				} else {
					if(!!$GetEle(id + "spanimg")){
                    	$GetEle(id + "spanimg").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                    	$GetEle(id + "span").innerHTML = "";
					} else {
						$GetEle(id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
				}
				$GetEle(id).value = "";
		    }
		}
	}; 
	dialog.Title = "请选择";
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	//dialog.maxiumnable = true;
	dialog.show();
}