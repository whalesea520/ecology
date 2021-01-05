//===========================  字段联动功能实现 start  ==============================
	function setClearField(fieldIds){
		for(var i =0; i< fieldIds.length; i++){
			var fieldId = fieldIds[i];
			var obj = document.getElementById(fieldId);
			if(fieldId.indexOf("_check") > 0){
				obj = document.getElementById(fieldId.substr(0, fieldId.length - 6));
			}
			if(obj == null || obj == undefined){
				if(fieldId.split("_").length==3){
					fieldId = fieldId.substring(0, fieldId.length-2);
					obj = document.getElementById(fieldId);
				}
			}
			if(obj != null && obj != undefined){
				if(fieldId.indexOf("_check") > 0){
					//The special deal of the check box.
					obj.checked = false;
					jQuery(obj).trigger("onchange");
				}else if(fieldId.indexOf("_span") > 0){
					//The special deal of the browser button.
					obj.innerHTML = "";
					if(fieldId.split("_").length==3){//明细表
						try{
							//var objs = jQuery("[id=" + fieldId + "]");
							/*
							for(var k=0;k<objs.length;k++){
                                if(objs[k]){
									objs[k].innerHTML=""; 
								}
							}
							*/
							jQuery("[id=" + fieldId + "]").html("");
							jQuery("[name=" + fieldId + "]").parent("[id^=isshow]").html("");
							
							var tardivobjid = $("#" + fieldId.replace("field", "").split("_")[0] + fieldId.replace("field", "").split("_")[1]).val();
							$("#" + tardivobjid).html("");
							/*
							var objsd = jQuery("[id=" + fieldId + "_d]");//document.getElementsByName(fieldId+"_d");
							for(var k=0;k<objsd.length;k++){
                                if(objsd[k]){
									objsd[k].innerHTML=""; 
								}
							}
							*/
							jQuery("[id=" + fieldId + "_d]").html("");
						}catch(e){}
					}
				}else{
					if (!!K && !!KE && !!K.g[fieldId]) {
						$(obj).html("");
						KE.html(fieldId, "");
					} else {
						var fieldHtmlType = $(obj).attr("_fieldhtmlType") ;
						if (fieldHtmlType != undefined && fieldHtmlType != "" && fieldHtmlType != "3") {
							$("#" + fieldId + "_span").html("");
							$("#" + fieldId + "_span_d").html("");
						}
						
						if(fieldId.indexOf("_")>=0){//明细表
							try{
								/*
								var objs = document.getElementsByName(fieldId);
								for(var k=0;k<objs.length;k++){
									if(objs[k]){
										objs[k].value=""; 
									}
								}
								*/
								$("#" + fieldId).val("");
								$("#" + fieldId).trigger("change");
								/*
								var objsd = document.getElementsByName(fieldId+"_d");
								for(var k=0;k<objsd.length;k++){
									if(objsd[k]){
										objsd[k].value=""; 
									}
								}
								*/
								$("#" + fieldId + "_d").val("");
								$("#" + fieldId + "_d").trigger("change");
								//被触发字段为当行文本且为只读时
								var tardivobjid = $("#" + fieldId.replace("field", "").split("_")[0] + fieldId.replace("field", "").split("_")[1]).val();
								$("#" + tardivobjid).html("");
							}catch(e){}
					    }else{
						   obj.value = "";
						}
						// Jin E Change  
						if(fieldId.indexOf("field_lable") == 0){
							jQuery(obj).trigger("onblur");
						}
					}
				}
			}
		}
	}

	function setValueLinkage(val,triname){
		for(var i =0; i< val.length; i++){
			var arrObj = val[i];
			for(var j =0; j< arrObj.length; j++){
				var tempObj = arrObj[j];
				if(tempObj.fieldLabel != undefined){
					// Jin E Change  
					var tarObj = document.getElementById(tempObj.fieldLabel);
					if(tarObj != null && tarObj != undefined){
						$(tarObj).val(tempObj.fieldValue);
						$(tarObj).attr("value",tempObj.fieldValue);
						jQuery(tarObj).trigger("onblur");
                        if($("#"+tempObj.fieldLabel.replace("field_lable","").replace("_","")).length>0){
							 $("#"+$("#"+tempObj.fieldLabel.replace("field_lable","").replace("_","")).val()).html(numberChangeToChinese(tempObj.fieldValue)+"("+milfloatFormat(tempObj.fieldValue)+")");
						}
					} else {
						// 金额千分位类型在只读的情况下
						// 保存具体值
						// 显示中文大写
						tarObj = document.getElementById(tempObj.fieldLabel.replace("field_lable", "field"));
						if(tarObj != null && tarObj != undefined){
							tarObj.value = tempObj.fieldValue;
							var chinasespanobj = document.getElementById(tempObj.fieldLabel.replace("field_lable", "field") + "_span");
							if (!!chinasespanobj) {
								chinasespanobj.innerHTML = numberChangeToChinese(tempObj.fieldValue);
							}
							if($("#"+tempObj.fieldLabel.replace("field_lable","").replace("_","")).length>0){
							    $("#"+$("#"+tempObj.fieldLabel.replace("field_lable","").replace("_","")).val()).html(numberChangeToChinese(tempObj.fieldValue)+"("+milfloatFormat(tempObj.fieldValue)+")");
						    }
						} 
					}
				} else if(tempObj.checked != undefined) {
					// Checkbox
					var tarObj = $("input[id='"+tempObj.fieldId+"']");
					if(tarObj != null && tarObj != undefined){
						tarObj.checked = tempObj.checked;
						if($(tempObj).is(":checked")){
						    tarObj.attr("checked","true");
						}
						if(triname!=$(tarObj).attr("id")){
						   tarObj.trigger("onchange");
						}
					}
				} else {
					var tarObj = document.getElementById(tempObj.fieldId);
					if (!!tarObj && !!K && !!KE && !!K.g[tempObj.fieldId]) {
						$(tarObj).html(tempObj.fieldValue);
						KE.html(tempObj.fieldId, tempObj.fieldValue);
					} else {
						if(tarObj == null || tarObj == undefined){
							if(tempObj.fieldId.split("_").length==3){
								tempObj.fieldId = tempObj.fieldId.substring(0, tempObj.fieldId.length-2);
								tarObj = document.getElementById(tempObj.fieldId);
							}
						}

						var fieldHtmlType = $(tarObj).attr("_fieldhtmlType") ;
						var fieldtype = $(tarObj).attr("_fieldtype") ;
						if (fieldHtmlType != undefined && fieldHtmlType != "" && (fieldHtmlType != "3" || (fieldHtmlType == "3" && ( fieldtype == "2" || fieldtype == "19" || fieldtype == "178")))) {
							$("#" + tempObj.fieldId + "_span").html(tempObj.fieldValue);
						} 
						//选择框特殊处理
						if (fieldHtmlType == "5") {
							var tarSpanObj = document.getElementById(tempObj.fieldId + "_span");
							if(tarSpanObj != null && tarSpanObj != undefined){
								var selectKVobj = $("#" + tempObj.fieldId + "_" + tempObj.fieldValue)
								if (!!selectKVobj[0]) {
									tarSpanObj.innerHTML = selectKVobj.text();
								}
							}
						}
						if($(tarObj).is("textarea")){
							  $("#" + tempObj.fieldId).html(tempObj.fieldValue);
						}
						if($(tarObj).is("select")){
							$("#" + tempObj.fieldId).find("option[value='"+tempObj.fieldValue+"']").attr("selected",true);
						}
						
						if(tarObj != null && tarObj != undefined){
							tarObj.value = tempObj.fieldValue;
							//避免金额千分位值被认为是非数字
							jQuery(tarObj).trigger("onfocus");
							jQuery(tarObj).trigger("onblur");
							if(triname!=$(tarObj).attr("id")){
							  jQuery(tarObj).trigger("onchange");
							}
						}
						if(tempObj.fieldId.indexOf("_")>=0 && (fieldHtmlType != "3"||(fieldHtmlType == "3"&&(fieldtype=='2'||fieldtype=='19'||fieldtype=='178')))){ //明细表
							try{
							   if(document.getElementById(tempObj.fieldId)){
                                   document.getElementById(tempObj.fieldId).value=tempObj.fieldValue;
                                   document.getElementById(tempObj.fieldId).setAttribute("value",tempObj.fieldValue);
								   if(document.getElementById(tempObj.fieldId).getAttribute("fieldtype")!='browse'){
									   try{
									   var tempFieldShow=tempObj.fieldId.split("_")[0].replace("field","")+tempObj.fieldId.split("_")[1];
									   var showName = document.getElementById(tempFieldShow).value;
									   ////QC173971 解决字段联动，整数赋值给明细选择框，选择框显示数字的问题
									   if(jQuery("#" + tempObj.fieldId).length > 0 && "select-one" == jQuery("#" + tempObj.fieldId)[0].type){
									       var selectValue = "";
									       jQuery("#" + tempObj.fieldId).find("option").each(function(){
									           if(this.value == tempObj.fieldValue){
									               selectValue = this.text;
									               $(this).attr("selected");
									           }else{
									               $(this).removeAttr("selected");
									           }
									       });
                                           document.getElementById(showName).innerHTML = selectValue;
                                       }else if(jQuery("#" + tempObj.fieldId + "_" + tempObj.fieldValue).length > 0){
                                           document.getElementById(showName).innerHTML =jQuery("#" + tempObj.fieldId + "_" + tempObj.fieldValue).html();
                                       }else{
                                           document.getElementById(showName).innerHTML =tempObj.fieldValue;
                                       }
									   }catch(e){}
							      }





							   }
							   if(document.getElementById(tempObj.fieldId).getAttribute("fieldtype")!='browse'){
								   if(document.getElementById(tempObj.fieldId+"_d")){
								        if(jQuery("#" + tempObj.fieldId + "_" + tempObj.fieldValue).length > 0){
                                            document.getElementById(tempObj.fieldId+"_d").value=jQuery("#" + tempObj.fieldId + "_" + tempObj.fieldValue).html();
                                            document.getElementById(tempObj.fieldId+"_d").setAttribute("value",jQuery("#" + tempObj.fieldId + "_" + tempObj.fieldValue).html());
								        }else{
	                                        document.getElementById(tempObj.fieldId+"_d").value=tempObj.fieldValue;
	                                        document.getElementById(tempObj.fieldId+"_d").setAttribute("value",tempObj.fieldValue);
								        }
								   }
								   if(document.getElementById(tempObj.fieldId+"_span")){
                                        if(jQuery("#" + tempObj.fieldId + "_" + tempObj.fieldValue).length > 0){
                                            document.getElementById(tempObj.fieldId+"_span").innerHTML=jQuery("#" + tempObj.fieldId + "_" + tempObj.fieldValue).html();
                                        }else{
                                            document.getElementById(tempObj.fieldId+"_span").innerHTML=tempObj.fieldValue;
                                        }
                                        
                                        
								   }
								   if(document.getElementById(tempObj.fieldId+"_span_d")){
                                        if(jQuery("#" + tempObj.fieldId + "_" + tempObj.fieldValue).length > 0){
                                            document.getElementById(tempObj.fieldId+"_span_d").innerHTML=jQuery("#" + tempObj.fieldId + "_" + tempObj.fieldValue).html();
                                        }else{
                                            document.getElementById(tempObj.fieldId+"_span_d").innerHTML=tempObj.fieldValue;
                                        }
								   }
							   }
							}catch(e){}
						}
					}
				}
				
			}
		}
	}
	
	function setMandLinkage(fieldIds){
		for(var i =0; i< fieldIds.length; i++){
			var fieldId = fieldIds[i];
			var obj = document.getElementById(fieldId);
			var mandObj = document.getElementById(fieldId + "_ismandspan");
			if(obj != null && mandObj != null){
				if(obj.value == ""){
					mandObj.style.display = "";
				} else {
					mandObj.style.display = "none";
				}
			}
		}
	}
	
	function setDisplayInfo(val){
		for(var i =0; i< val.length; i++){
			var arrObj = val[i];
			for(var j =0; j< arrObj.length; j++){
				var tempObj = arrObj[j];
				if(tempObj.fieldId.indexOf("_")>=0){
					var tarObj = $("#" + tempObj.fieldId + "_span");
					var tardivobjid = $("#" + tempObj.fieldId.replace("field", "").split("_")[0] + tempObj.fieldId.replace("field", "").split("_")[1]).val();
					var tardivobj = $("#" + tardivobjid);
					if(tarObj != null && tarObj != undefined){
						var strShowInfo = tempObj.showInfo.replace(/&lt;/g, "<");
						strShowInfo = strShowInfo.replace(/&gt;/g, ">");
						strShowInfo = strShowInfo.replace(/&quot;/g, "\"");
						tardivobj.html(strShowInfo);
						tarObj.html(strShowInfo);
						/*
						for(var k=0;k<tarObj.length;k++){
							  tarObj[k].innerHTML = strShowInfo;
						}
						*/
					}
					var tarObjd = document.getElementById(tempObj.fieldId + "_span_d");
					if(tarObjd != null && tarObjd != undefined){
						var strShowInfo = tempObj.showInfo.replace(/&lt;/g, "<");
						strShowInfo = strShowInfo.replace(/&gt;/g, ">");
						strShowInfo = strShowInfo.replace(/&quot;/g, "\"");
						tarObjd.innerHTML = strShowInfo;
					}
					var tarSpanObjd = document.getElementById(tempObj.fieldId + "_span");
					if(tarSpanObjd != null && tarSpanObjd != undefined){
						var strShowInfo = tempObj.showInfo.replace(/&lt;/g, "<");
						strShowInfo = strShowInfo.replace(/&gt;/g, ">");
						strShowInfo = strShowInfo.replace(/&quot;/g, "\"");
						tarSpanObjd.innerHTML = strShowInfo;
					}
				}else{
					var tarObj = document.getElementById(tempObj.fieldId + "_span");
					if(tarObj != null && tarObj != undefined){
						var strShowInfo = tempObj.showInfo.replace(/&lt;/g, "<");
						strShowInfo = strShowInfo.replace(/&gt;/g, ">");
						strShowInfo = strShowInfo.replace(/&quot;/g, "\"");
						tarObj.innerHTML = strShowInfo;
					}
				}
			}
		}
	}
   
    //主字段联动明细字段
	function setGropIdInfo(groupinfo){
		if(groupinfo&&groupinfo.length>0){
			  for(var i=0;i<groupinfo.length;i++){
			       var groupObj = groupinfo[i];
				   if(groupObj.rowcount>0){
					   var  groupid = groupObj.groupid;
					   var rowcount = groupObj.rowcount;
					   if($("#nodenum"+groupid).length>0){ //是否显示表单字段
						     for(var j=0;j<rowcount;j++){
								  eval("addRow"+groupid+"("+groupid+",'trigroupinfo');");
							 }
							 setValueLinkage(groupObj.values);
	    		             setDisplayInfo(groupObj.displays);
					   }
				   }
			  }

		}
	}
//===========================  字段联动功能实现 end  ==============================
	
//===========================  请假申请单专用方法 start  ==========================
	function doChangeLeaveType(obj){
		var divSelOlt = $('#selectOtherLeaveType');
		var oltObj = jQuery("select[nameBak='otherLeaveType']");
		if(obj.value == "4"){
			if(divSelOlt != null && divSelOlt != undefined && divSelOlt.size() != 0){
				divSelOlt.show();
			}
			
			//如果请假类型 是 “其它带薪假”，则根据 “其它请假类型” 的值来显示部分带薪信息的字段值。
			if(oltObj != null && oltObj != undefined && oltObj.size() != 0){
				oltObj.trigger("onchange");
			}
		} else {
			if(divSelOlt != null && divSelOlt != undefined && divSelOlt.size() != 0){
				divSelOlt.hide();
			}
			
			//如果请假类型 不是 “其它带薪假”，则清空 “其它请假类型” 的值。
			if(oltObj != null && oltObj != undefined && oltObj.size() != 0){
				oltObj.val("");
			}
			dispalyAnnualInfo("0");
		}
	}
	
	function dispalyAnnualInfo(val){
		  if(val == "2"){
			  setParentNodeDisplay(jQuery("input[nameBak='thisyearannualdays']")[0],"");
			  setParentNodeDisplay(jQuery("input[nameBak='lastyearannualdays']")[0],"");
			  setParentNodeDisplay(jQuery("input[nameBak='allannualdays']")[0],"");
			  
			  setParentNodeDisplay(jQuery("input[nameBak='thisyearpsldays']")[0],"none");
			  setParentNodeDisplay(jQuery("input[nameBak='lastyearpsldays']")[0],"none");
			  setParentNodeDisplay(jQuery("input[nameBak='allpsldays']")[0],"none");
		  }else if(val == "11"){
			  setParentNodeDisplay(jQuery("input[nameBak='thisyearannualdays']")[0],"none");
			  setParentNodeDisplay(jQuery("input[nameBak='lastyearannualdays']")[0],"none");
			  setParentNodeDisplay(jQuery("input[nameBak='allannualdays']")[0],"none");
			  
			  setParentNodeDisplay(jQuery("input[nameBak='thisyearpsldays']")[0],"");
			  setParentNodeDisplay(jQuery("input[nameBak='lastyearpsldays']")[0],"");
			  setParentNodeDisplay(jQuery("input[nameBak='allpsldays']")[0],"");
		  }else{
			  setParentNodeDisplay(jQuery("input[nameBak='thisyearannualdays']")[0],"none");
			  setParentNodeDisplay(jQuery("input[nameBak='lastyearannualdays']")[0],"none");
			  setParentNodeDisplay(jQuery("input[nameBak='allannualdays']")[0],"none");
			  
			  setParentNodeDisplay(jQuery("input[nameBak='thisyearpsldays']")[0],"none");
			  setParentNodeDisplay(jQuery("input[nameBak='lastyearpsldays']")[0],"none");
			  setParentNodeDisplay(jQuery("input[nameBak='allpsldays']")[0],"none");
		  }
	}

	function setParentNodeDisplay(tmpObj, strDisplay){
		if(tmpObj != null && tmpObj != undefined){
			tmpObj.parentNode.parentNode.parentNode.style.display = strDisplay;
			tmpObj = tmpObj.parentNode.parentNode.parentNode.previousSibling.previousSibling;
			if(tmpObj != null && tmpObj != undefined){
				tmpObj.style.display = strDisplay;
			}
		}
	}
//===========================  请假申请单专用方法 end  ============================