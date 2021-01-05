var isLightBool = false ;
var rowBgValue = "" ;
function getRowBg()
{	
	isLightBool = !isLightBool ;
	if (isLightBool)
	{
		rowBgValue = "rgb(245, 250, 250)";//"#e7e7e7" ;
	}
	else
	{	
		rowBgValue = "rgb(245, 250, 250)";
	}
	return rowBgValue ;
}

function getRowClassName(){	
	isLightBool = !isLightBool ;
	if (isLightBool){
		rowBgValue = "datalight";//"#e7e7e7" ;
	}else{	
		rowBgValue = "datadark";
	}
	return rowBgValue ;
}

function initE8Browser(_fieldId, _insertindex, _ismand, _browserValue, _browserSpanValue, _detailbrowclick, _completeUrl, _linkUrl){
	if(_linkUrl==null){
		_linkUrl = "";
	}
	jQuery("#"+_fieldId+"wrapspan").html("");
	var _isMustInput = "1";
	if(_ismand==1){
		_isMustInput = "2";
	}
	jQuery("#"+_fieldId+"wrapspan").e8Browser({
	   name:_fieldId,
	   viewType:"1",
	   browserValue: _browserValue,
	   browserSpanValue: _browserSpanValue,
	   browserOnClick: _detailbrowclick,
	   hasInput:true,
	   isSingle:true,
	   hasBrowser:true, 
	   isMustInput:_isMustInput,
	   completeUrl:_completeUrl,
	   width:"95%",
	   linkUrl:_linkUrl,
	   onPropertyChange:"wfbrowvaluechange(this, \'"+_fieldId+"\', "+_insertindex+")"
	});
	//needHidden:false,
}







function wrapshowhtml(ahtml, id) {
	var str = "<span class=\"e8_showNameClass\">";
	str += ahtml;
	str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this,1,false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
	return str;
}

function onShowBrowser2_fna(id,url,linkurl,type1,ismand, funFlag, _fieldStr){
	_fieldStr = "";
	
	var formid;
	var isbill;
	var workflowid;
	var tmpids = '';
//	var requestid;
	//待后续处理
	var docFlags = "<%=docFlags %>";
	try {
		formid = $G("formid").value;
		isbill = $G("isbill").value;
		workflowid = $G("workflowid").value;
		//requestid = $G("requestid").value;
	} catch (e){}
	var dialogurl = url;
	
	if(_fieldStr==null){
		_fieldStr = "field";
	}
	
	//url = encodeURI(url);
	//alert(url);
	
	var id1 = null;
    if (type1 == 9  && docFlags == "1" ) {
        if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
        	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
        } else {
	    	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp";
        }
	}
	//资产浏览
	if (type1 == 23||type1 ==26||type1==3) {
		var reqid=-1;
		if($G("requestid")){
			reqid=$G("requestid").value;
		}
		url += "?billid=" + formid+"%26wfid="+workflowid+"%26reqid="+reqid;
	}
	if (type1 == 224||type1 == 225||type1 == 226||type1 == 227) {
		if(url.indexOf("|")==-1){
			url += "|"+id;
		}
		if(url.indexOf("-")==-1){
			if(id.split("_")[1]){
				//zzl-拼接行号
				url += "_"+id.split("_")[1];
			}
		}
		
		dialogurl = url;
	}
	
	if (type1 == 2 || type1 == 19 ) {
	    spanname = _fieldStr + id + "span";
	    inputname = _fieldStr + id;
	    
		if (type1 == 2) {
			onFlownoShowDate(spanname,inputname,ismand);
		} else {
			onWorkFlowShowTime(spanname, inputname, ismand);
		}
	} else {
		ismand = 0;
	    if (type1 != 256&&type1 != 257&&type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170 && type1!=194) {
	    	if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
	    		//id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
	    	} else {
			    if (type1 == 161) {
				    //id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
				    dialogurl = url + "|" + id;
				} else {
                   if(type1 ==16){
		            dialogurl = url+tmpids;
			       		//id1 = window.showModalDialog(url+tmpids, window, "dialogWidth=550px;dialogHeight=550px");
			 	   }else{
			 		  try{
			 			 //系统表单
			 			 if(type1==22 || type1==251){
			 				if(url.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("%3F") > -1 
			 						|| url.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("?") > -1){
			 					dialogurl = url + "%26workflowid="+workflowid+"%26billid="+formid;
							}else{
								dialogurl = url + "%3Fworkflowid="+workflowid+"%26billid="+formid;
							}
			 			 }
			 			 
			 			 if(window._FnaBillRequestJsFlag && type1==22){
			 				 if(id.split("_")[0]=="subject"){
			 					 var __dtIdx = id.split("_")[1];
			 				 
			 					 var __orgType = jQuery("#organizationtype_"+__dtIdx).val();
			 					 var __orgId = jQuery("#organizationid_"+__dtIdx).val();
			 				 
			 					 if(dialogurl.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("%3F") > -1 
			 							 || dialogurl.replace("/systeminfo/BrowserMain.jsp?url=", "").indexOf("?") > -1){
			 						 dialogurl = dialogurl + "%26orgType=" + __orgType+"%26orgId="+__orgId+"%26fromFnaRequest=1";
			 					 }else{
			 						 dialogurl = dialogurl + "%3ForgType=" + __orgType+"%26orgId="+__orgId+"%26fromFnaRequest=1";
			 					 }
			 				 }
			 			 }
			 			 
			 		  }catch(ex){}
					  // id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
			 	   }
				}
	    	}
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle(_fieldStr+id).value;
				dialogurl = url + "?projectids=" + tmpids;
				//id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        //} else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) { 
	        //type1 = 167 是:分权单部门-分部 不应该包含在这里面 ypc 2012-09-06 修改
	       } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170 || type1 == 194) {
		        tmpids = $GetEle(_fieldStr+id).value;
		        if((url.indexOf("%3F")>-1 || url.indexOf("?")>-1 )&& !(url.substring((url.length-4),url.length).indexOf(".jsp")>-1)){
		        	dialogurl = url + "&selectedids=" + tmpids;
		        }else{
		        	dialogurl = url + "?selectedids=" + tmpids;
		        }
				//id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 37) {
		        tmpids = $GetEle(_fieldStr+id).value;
		        dialogurl = url + "?documentids=" + tmpids;
				//id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 142 ) {
		        tmpids = $GetEle(_fieldStr+id).value;
		        dialogurl = url + "?receiveUnitIds=" + tmpids;
				//id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			} else if (type1 == 162 ) {
				tmpids = $GetEle(_fieldStr+id).value;

				if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
					url = url + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					dialogurl = url;
					//id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
				} else {
					url = url + "|" + id + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					dialogurl = url;
					//id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
			}else if (type1 == 256|| type1 == 257) {
				tmpids = $GetEle(_fieldStr+id).value;
				url = url + "_" + type1 + "&selectedids=" + tmpids;
				url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
				dialogurl = url;
				//id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
			}else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
		        	tmpids=uescape("?isdetail=1&isbill=" + isbill + "&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle(_fieldStr+id).value+"&selectedids="+$GetEle(_fieldStr+id).value);
		        	dialogurl = url + tmpids;
		        	//id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
		        	tmpids = uescape("?fieldid=" + id + "&isbill=" + isbill + "&resourceids=" + $GetEle(_fieldStr + id).value+"&selectedids="+$GetEle(_fieldStr+id).value);
		        	dialogurl = url + tmpids;
		        	//把此行的dialogWidth=550px; 改为600px
		        	//id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=600px;dialogHeight=550px");
		        }
			} else {
				if (type1 == 17 && id.indexOf('_') == -1) {
					var othparam = null;
					othparam = browUtil.getBrowData(id);
					if (othparam.indexOf(",") == 0) {
						othparam = othparam.substr(1);
					}
					
					if (dialogurl.indexOf("?") != -1) {
						dialogurl += "?";
					} else {
						dialogurl += "&";
					}
					dialogurl += "workflow=1&selectedids=" + othparam;
				} else {
		        	tmpids = $GetEle(_fieldStr + id).value;
		        	dialogurl = url + "?resourceids=" + tmpids;
		        }
				//id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
				  //id1 = window.showModalDialog(url + "?resourceids=" + tmpids+uescape("&fieldid="+id+"&currworkflowid=" + workflowid),  "", "dialogWidth=550px;dialogHeight=550px");
			}
			/*
			if (type1 == 152 || type1 == 171) {
	            dialogurl += tmpids;
	         	alert(dialogurl);
			}
			*/
		}
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		//dialog.callbackfunParam = null;
//alert(dialogurl);
//资产浏览按钮
if((type1==23||type1==26||type1==3)&&dialogurl.indexOf("/cpt/capital/CapitalBrowser.jsp?")>=0){
	var reqid=-1;
	if($GetEle("requestid")){
		reqid=$GetEle("requestid").value;
	}
	dialogurl=dialogurl+"%26wfid="+workflowid+"%26reqid="+reqid;
}else if((type1==23||type1==26||type1==3)&&dialogurl.indexOf("/cpt/capital/CapitalBrowser.jsp")>=0){
	var reqid=-1;
	if($GetEle("requestid")){
		reqid=$GetEle("requestid").value;
	}
	dialogurl=dialogurl+"?wfid="+workflowid+"%26reqid="+reqid;
}
		//拼接浏览数据自定义参数
        try {
        	if (isCanConfigType(type1)) {
        		var _tempUrl = dialogurl;
        		if (_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') >= 0) {
        			_tempUrl = _tempUrl.substring(_tempUrl.indexOf('/systeminfo/BrowserMain.jsp?url=') + '/systeminfo/BrowserMain.jsp?url='.length);
        			_tempUrl = unescape(_tempUrl);
        		}
				if (_tempUrl.indexOf('?') < 0) {
					dialogurl += uescape('?' + getUserDefinedRequestParam(_fieldStr + id));
				} else {
					dialogurl += uescape('&' + getUserDefinedRequestParam(_fieldStr + id));
				}
			}
		} catch(e_bdf) {}
		dialog.URL = dialogurl;
		dialog.callbackfun = function (paramobj, id1) {
			if (id1 != undefined && id1 != null) {
				if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170 || type1==194) {
					if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
						var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
						var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
						var sHtml = ""
						
						//人力资源特殊处理
						if (type1 == 17 && id.indexOf('_') == -1) {
							var _rtvjson = browUtil.paserBrowData(id1, $G(_fieldStr+id).getAttribute("viewtype"), id);
							//缓存数据
							//browUtil.saveBrowData(id, testjson, _rtvjson.id);
							
							resourceids = _rtvjson.id;
							sHtml = _rtvjson.html;
							
						} else {
							if (resourceids.indexOf(",") == 0) {
								resourceids = resourceids.substr(1);
								resourcename = resourcename.substr(1);
							}
							var resourceIdArray = resourceids.split(",");
							var resourceNameArray = resourcename.split(",");
							for (var _i=0; _i<resourceIdArray.length; _i++) {
								var curid = resourceIdArray[_i];
								var curname = resourceNameArray[_i];
								if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
									sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp", curid);
								} else {
									sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=" + linkurl + curid + " target=_blank>" + curname + "</a>&nbsp", curid);
								}
								
							}
							
						}
						
						
						jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
						$GetEle(_fieldStr + id).value= resourceids;
					} else {
	 					if (ismand == 0) {
	 						jQuery($GetEle(_fieldStr+id+"span")).html("");
	 					} else {
	 						jQuery($GetEle(_fieldStr+id+"span")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
	 					}
	 					$GetEle(_fieldStr+id).value = "";
					}
	
				} else {
				   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" ) {
		               if (type1 == 162) {
					   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
							var names = wuiUtil.getJsonValueByIndex(id1, 1);
							var descs = wuiUtil.getJsonValueByIndex(id1, 2);
							var href = wuiUtil.getJsonValueByIndex(id1, 3);
							sHtml = ""
							if(ids.indexOf(",") == 0){
								ids = ids.substr(1);
								names = names.substr(1);
								descs = descs.substr(1);
							}
							$GetEle(_fieldStr+id).value= ids;
							var idArray = ids.split(",");
							var nameArray = names.split(",");
							var descArray = descs.split(",");
							for (var _i=0; _i<idArray.length; _i++) {
								var curid = idArray[_i];
								var curname = nameArray[_i];
								var curdesc = descArray[_i];
								
								curid = curid.replace(/\(/g, "\\(");
								curid = curid.replace(/\)/g, "\\)");
								
								//sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
								if(href==''){
									sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a title='" + curdesc + "' >" + curname + "</a>&nbsp", curid);
								}else{
									sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a title='' href='" + href + curid + "' target='_blank'>" + curname + "</a>&nbsp", curid);
								}
							}
							
							jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
							//return;
		               }
					   if (type1 == 161) {
						   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
							var descs = wuiUtil.getJsonValueByIndex(id1, 2);
							var href = wuiUtil.getJsonValueByIndex(id1, 3);
							$GetEle(_fieldStr+id).value = ids;
							//sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
							if(href==''){
								sHtml = wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a title='" + descs + "'>" + names + "</a>&nbsp", ids);
							}else{
								sHtml = wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp", ids);
							}
							jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
							//return ;
					   }
					   if(type1==256||type1==257){
	           	    		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
	           	    		var names = wuiUtil.getJsonValueByIndex(id1, 1);
	           	    		var idArray = ids.split(",");
	           	    		var nameArray = names.split(",");
	           	    		var sHtml = "";
	           	    		for (var _i=0; _i<idArray.length; _i++) {
								var curid = idArray[_i];
								var curname = nameArray[_i];
								sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"),curname + "&nbsp", curid);
							}
	           	    		$GetEle(_fieldStr+id).value = ids;
				        	jQuery($GetEle(_fieldStr + id + "span")).html(sHtml);
	           	       }
		               if (type1 == 9 && docFlags == "1" && (funFlag == undefined || funFlag != 3)) {
			                tempid = wuiUtil.getJsonValueByIndex(id1, 0);
					        $GetEle(_fieldStr + id + "span").innerHTML = "<a href='#' onclick=\"createDoc(" + id + ", " + tempid + ", 1)\">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a><button type=\"button\"  type=\"button\" id=\"createdoc\" style=\"display:none\" class=\"AddDocFlow\" onclick=\"createDoc(" + id + ", " + tempid + ",1)\"></button>";
		               } else if (type1 != 161 && type1 != 162 && type1 != 256 && type1 != 257){
		               		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
							if(ids.indexOf(",") >-1){
								ids = ids.substr(1);
								var names = wuiUtil.getJsonValueByIndex(id1, 1);
								sHtml = ""
								var idArray = ids.split(",");
								var nameArray = names.split(",");
								for (var _i=0; _i<idArray.length; _i++) {
									var curid = idArray[_i];
									var curname = nameArray[_i];
									if (linkurl == "") {
										sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=javascript:void(0)>" + curname + "</a>&nbsp", curid);
							        } else {
										sHtml += wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=" + linkurl + curid + " target=_blank>" + curname + "</a>&nbsp", curid);
							        }
						        
								}
								jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
							
							}else{
			            	    if (linkurl == "") {
						        	jQuery($GetEle(_fieldStr + id + "span")).html(wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), wuiUtil.getJsonValueByIndex(id1, 1), wuiUtil.getJsonValueByIndex(id1, 0)));
						        } else {
									if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
										jQuery($GetEle(_fieldStr+id+"span")).html(wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp", wuiUtil.getJsonValueByIndex(id1, 0)));
									} else {
										jQuery($GetEle(_fieldStr+id+"span")).html(wrapshowhtml0($G(_fieldStr+id).getAttribute("viewtype"), "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>", wuiUtil.getJsonValueByIndex(id1, 0)));
									}
						        }
							}
		               }
		               $GetEle(_fieldStr+id).value = jQuery.trim(wuiUtil.getJsonValueByIndex(id1, 0));
		                if (type1 == 9 && docFlags == "1" && (funFlag == undefined || funFlag != 3)) {
		                	var evt = getEvent();
		               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
		               		jQuery(targetElement).next("span[id=CreateNewDoc]").html("");
		                }
		                
				   } else {
						if (ismand == 0) {
							jQuery($GetEle(_fieldStr+id+"span")).html("");
						} else {
							jQuery($GetEle(_fieldStr+id+"span")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>"); 
						}
						$GetEle(_fieldStr+id).value="";
						if (type1 == 9 && docFlags == "1" && (funFlag == undefined || funFlag != 3)) {
							var evt = getEvent();
		               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
		               		//jQuery(targetElement).next("span[id=CreateNewDoc]").html("<button type=button id='createdoc' class=AddDocFlow onclick=createDoc(" + id + ",'','1') title='<%=SystemEnv.getHtmlLabelName(82, userlanguage)%>'><%=SystemEnv.getHtmlLabelName(82, userlanguage)%></button>");
						}
						
						//人力资源特殊处理
						/*
						if (type1 == 17) {
							browUtil.saveBrowData(id, null);
						} 
						*/
				   }
				}
			}
			hoverShowNameSpan(".e8_showNameClass");
			try {
				var onppchgfnstr = jQuery("#"+ _fieldStr + id).attr('onpropertychange');
				eval(onppchgfnstr);
				if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
					onpropertychange();
				}
			} catch (e) {
			}
			try {
				var onppchgfnstr = jQuery("#"+ _fieldStr + id + "__").attr('onpropertychange').toString();
				eval(onppchgfnstr);
				if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
					onpropertychange();
				}
			} catch (e) {
			}
			
			var _ismand = $G(_fieldStr+id).getAttribute("viewtype");
			if ($GetEle(_fieldStr + id).value == "") {
				//html模式相关文档，相关流程没有id号，所以生成input时，name不符合规范，没有viewtype属性，ismand为undefined
				if (_ismand == 0||!_ismand) {
					jQuery($GetEle(_fieldStr+id+"spanimg")).html("");
				} else {
					jQuery($GetEle(_fieldStr+id+"spanimg")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
				}
			} else {
				jQuery($GetEle(_fieldStr+id+"spanimg")).html("");
			}
		} ;
		dialog.Title = "请选择";
		dialog.Width = 550 ;
		if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){
  		dialog.Width=648;
  	}
		if(dialogurl.indexOf("/MultiRequestBrowser.jsp")!=-1||dialogurl.indexOf("/MultiRequestedBrowser.jsp")!=-1){
			if(jQuery.browser.msie){
				dialog.Height = 570;
			}else{
				dialog.Height = 570;
			}
		}else if(dialogurl.indexOf("/MutiCustomerBrowser.jsp")!=-1){
			if(jQuery.browser.msie){
				dialog.Height = 640;
			}else{
				dialog.Height = 630;
			}
		}else{
			dialog.Height = 600;
		}
		dialog.Drag = true;
		//dialog.maxiumnable = true;
		dialog.show();
	}
}

function checkSameSubject_E8(index){
	var currentOrgType = jQuery("#organizationtype_" + index).val();
	var currentOrgId = jQuery("#organizationid_" + index).val();
	var currentSubjectValue = jQuery("#subject_" + index).val();
	var currentBudgetPeriodValue = jQuery("#budgetperiod_"+index).val();

	
	var result = false;
	if(currentSubjectValue=='' || currentBudgetPeriodValue=='' || currentOrgType =='' || currentOrgId==''){
		return result;
	}
	
	var nodesnum = document.frmmain.nodesnum.value;
	var maxIndex = 0;
	if(nodesnum!=null && nodesnum!='' ){
		maxIndex = parseInt(nodesnum);
	}
	if(document.all("budgetperiod_" + index)){
		
		currentBudgetPeriodValue = currentBudgetPeriodValue.substring(0,7);
		//alert("index="+index+"\n"+"currentSubjectValue="+currentSubjectValue+"\n"+"currentBudgetPeriodValue="+currentBudgetPeriodValue);
		for(var i=0;i<maxIndex;i++){
			if(document.all("subject_" + i) && i!=index ){			
				var indexSubjectValue = document.all("subject_" + i).value;
				var indexBudgetPeriodValue = document.all("budgetperiod_" + i).value;
				indexBudgetPeriodValue = indexBudgetPeriodValue.substring(0,7);
				
				var indexOrgType = document.all("organizationtype_" + i).value;
				var indexOrgId = document.all("organizationid_" + i).value;
				if(currentBudgetPeriodValue == indexBudgetPeriodValue && currentSubjectValue == indexSubjectValue
					&& indexOrgType == currentOrgType && indexOrgId == currentOrgId){
					result = true;
					break;
				}
			}
		}
	}
	return result;
}