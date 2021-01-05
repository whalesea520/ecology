
function onShowBrowser(id, url, linkurl, type1, ismand, targetObj, viewtypeObj ,sbaseid, ebaseid, btn) {

	if (!!!targetObj) {
		targetObj = jQuery(btn).parent().parent().find("select[name=browsertype]");
		viewtypeObj = jQuery(btn).parent().parent().find("select[name=valuetype]");
	}
	
	var selectedOption = $(targetObj).find("option:selected");
	
	url = $(selectedOption).attr("_url");
	linkurl = "";//$(selectedOption).attr("_linkurl");
	type1 = $(selectedOption).val();
	var spanId = id + "span";
	jQuery($GetEle(spanId)).attr("class","e8_showNameClass");
	var inputId = id;
	var id1 = null;
	var dlg=new window.top.Dialog();//定义Dialog对象
		dlg.Model=true;
		dlg.Width=550;//定义长度
		dlg.Height=550;
	if (!!viewtypeObj) {
		if ($(viewtypeObj).val() == "3") {
				dlg.URL = "/systeminfo/BrowserMain.jsp?url=/synergy/maintenance/SynergyParamBrowser.jsp?sysparam=sys";
				dlg.callback=function(result){
					if (!!result) {
				 		$GetEle(inputId).value = result.id;
						$GetEle(spanId).innerHTML = "<a href='#'>"+result.name+"</a>";
						dlg.close();
					}
					return ;
				}
				dlg.show();
				return;
		}
		if ($(viewtypeObj).val() == "6") {
				var dlg=new window.top.Dialog();//定义Dialog对象
				dlg.Model=true;
				dlg.Width=550;//定义长度
				dlg.Height=550;
				dlg.URL = "/systeminfo/BrowserMain.jsp?url=/synergy/maintenance/SynergyParamBrowser.jsp?wfformparam="+sbaseid;
				dlg.callback=function(result){
					if (!!result) {
				 		$GetEle(inputId).value = result.id;
						var pfiled = result.pfiled;
				 		$("#wfformidfilter").val(result.id+"||~WEAVERSPLIT~||"+pfiled);
						$GetEle(spanId).innerHTML = "<a href='#'>"+result.name+"</a>";
						dlg.close();
					}
					return ;
				}
				dlg.show();
				return;
		}
	}
	
	if (type1 == 224 || type1 == 225 || type1 == 226 || type1 == 227) {
		if (id.split("_")[1]) {
			//zzl-拼接行号
			url += "_" + id.split("_")[1];
		}
	}
	if (type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1 != 27 && type1 != 37 && type1 != 56 && type1 != 57 && type1 != 65 && type1 != 165 && type1 != 166 && type1 != 167 && type1 != 168 && type1 != 4 && type1 != 167 && type1 != 164 && type1 != 169 && type1 != 170 && type1 != 194) {
		if (type1 == 161) {
			//id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
			dlg.URL = url + "|" + id; 
		} else {
			//id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
			dlg.URL = url;
		}
	} else {
		if (type1 == 135) {
			tmpids = $GetEle(inputId).value;
			//id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			dlg.URL = url + "?projectids=" + tmpids ;
		} else {
			if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170 || type1 == 194) {
				tmpids = $GetEle(inputId).value;
				//id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
				dlg.URL = url + "?selectedids=" + tmpids ;
			} else {
				if (type1 == 37) {
					tmpids = $GetEle(inputId).value;
					//id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
					dlg.URL = url + "?documentids=" + tmpids ;
				} else {
					if (type1 == 142) {
						tmpids = $GetEle(inputId).value;
						//id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
						dlg.URL = url + "?receiveUnitIds=" + tmpids ;
					} else {
						if (type1 == 162) {
							tmpids = $GetEle(inputId).value;
							if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
								url = url + "&beanids=" + tmpids;
								url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
								//id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
								dlg.URL = url ;
							} else {
								url = url + "|" + id + "&beanids=" + tmpids;
								url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
								//id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
								dlg.URL = url ;
							}
						} else {
							if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168) {
								index = (id + "").indexOf("_");
								if (index != -1) {
									//tmpids = uescape("?isdetail=1&isbill=<%=isbill%>&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle(inputId).value + "&selectedids=" + $GetEle(inputId).value);
									tmpids = uescape("?isdetail=1&isbill=&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle(inputId).value + "&selectedids=" + $GetEle(inputId).value);
									//id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
									dlg.URL = url + tmpids ;
								} else {
									//tmpids = uescape("?fieldid=" + id + "&isbill=<%=isbill%>&resourceids=" + $GetEle(inputId).value + "&selectedids=" + $GetEle(inputId).value);
									tmpids = uescape("?fieldid=" + id + "&isbill=&resourceids=" + $GetEle(inputId).value + "&selectedids=" + $GetEle(inputId).value);
									//id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
									dlg.URL = url + tmpids ;
								}
							} else {
								tmpids = $GetEle(inputId).value;
								if (tmpids == "NULL" || tmpids == "Null" || tmpids == "null") {
									tmpids = "";
								}
								//id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
								dlg.URL = url + "?resourceids=" + tmpids ;
							}
						}
					}
				}
			}
		}
	}
	
	dlg.callback = function(id1) {
		if (id1 != undefined && id1 != null) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1 == 27 || type1 == 37 || type1 == 56 || type1 == 57 || type1 == 65 || type1 == 166 || type1 == 168 || type1 == 170 || type1 == 194) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = "";
					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					var tlinkurl = linkurl;
					var resourceIdArray = resourceids.split(",");
					var resourceNameArray = resourcename.split(",");
					for (var _i = 0; _i < resourceIdArray.length; _i++) {
						var curid = resourceIdArray[_i];
						var curname = resourceNameArray[_i];
						if (type1 == 171 || type1 == 152) {
							linkno = getWFLinknum("slink" + id + "_rq" + curid);
							if (linkno > 0) {
								curid = curid + "&wflinkno=" + linkno;
							} else {
								tlinkurl = linkurl.substring(0, linkurl.indexOf("?") + 1) + "requestid=";
							}
						}
						if (tlinkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml += "<a href=" + tlinkurl + curid + " target=_new>" + curname + "</a>&nbsp";
						}
					}
					$GetEle(spanId).innerHTML = sHtml;
					$GetEle(inputId).value = resourceids;
					dlg.close();
				} else {
					if (ismand == 0) {
						$GetEle(spanId).innerHTML = "";
					} else {
						$GetEle(spanId).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
					$GetEle(inputId).value = "";
					dlg.close();
				}
			} else {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
					if (type1 == 162) {
						var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						var href = wuiUtil.getJsonValueByIndex(id1, 3);
						sHtml = "";
						ids = ids.substr(1);
						$GetEle(inputId).value = ids;
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i = 0; _i < idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
								//sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
							if (href == "") {
								sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
							} else {
								sHtml += "<a title='" + curdesc + "' href='" + href + curid + "' target='_blank'>" + curname + "</a>&nbsp";
							}
						}
						$GetEle(spanId).innerHTML = sHtml;
						dlg.close();
						return;
					}
					if (type1 == 161) {
						var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						var href = wuiUtil.getJsonValueByIndex(id1, 3);
						$GetEle(inputId).value = ids;
							//sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						if (href == "") {
							sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						} else {
							sHtml = "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp";
						}
						$GetEle(spanId).innerHTML = sHtml;
						dlg.close();
						return;
					}
					if (type1 == 16) {
						curid = wuiUtil.getJsonValueByIndex(id1, 0);
						linkno = getWFLinknum("slink" + id + "_rq" + curid);
						if (linkno > 0) {
							curid = curid + "&wflinkno=" + linkno;
						} else {
							linkurl = linkurl.substring(0, linkurl.indexOf("?") + 1) + "requestid=";
						}
						$GetEle(inputId).value = wuiUtil.getJsonValueByIndex(id1, 0);
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							$GetEle(spanId).innerHTML = "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(e);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
						} else {
							$GetEle(spanId).innerHTML = "<a href=" + linkurl + curid + " target='_new'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
						}
						dlg.close();
						return;
					}
					
					if (linkurl == "") {
						$GetEle(spanId).innerHTML = "<a href='#1' >"+wuiUtil.getJsonValueByIndex(id1, 1)+"</a>";
					} else {
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							$GetEle(spanId).innerHTML = "<a href=javaScript:openhrm(" + wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
						} else {
							$GetEle(spanId).innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
						}
					}
					$GetEle(inputId).value = wuiUtil.getJsonValueByIndex(id1, 0);
					dlg.close();
				} else {
					if (ismand == 0) {
						$GetEle(spanId).innerHTML = "";
					} else {
						$GetEle(spanId).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
					$GetEle(inputId).value = "";
					dlg.close();
				}
			}
		}
	}
	dlg.show();
}

