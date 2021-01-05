/**
 * @author liuzy 2016-01-26
 * SQL联动改造，提取、封装、解决性能问题
 * 1、Html模式(PC端、手机端)(新建、编辑、查看)页面字段属性联动提取到此JS，依赖全局变量wf__info
 * 2、表单加载时，明细SQL联动N条数据单个赋值字段只发起一次ajax请求
 * 3、单个字段触发多个联动赋值字段，只发起一次ajax请求
 */
var fieldAttrOperate = (function(){
	
	function getAjaxRequestPath(){
		if(wf__info.belmobile)
			return "/mobile/plugin/1/";
		else
			return "/workflow/request/";
	}

	/**
	 * 页面加载触发SQL属性联动
	 * @param {assignField} SQL赋值字段
	 * @param {flag} 	-1计算主字段；>=0计算明细某行字段；AllRow初始化计算明细所有行
	 */
	function pageLoadInitValue(assignField, flag){
		if(wf__info.onlyview)
			return;
		var fieldsql = jQuery("#fieldsql"+assignField).val();
		if(!!!fieldsql)
			return;
		var wvals = "";
		
		
		//如果字段属性同时 使用主表字段，明细字段作为查询条件，且主表字段变动时
		if(!document.getElementById("field"+assignField) && flag === "AllRow"){
			var fieldRange = fieldsql.match(/\$(requestid|-?\d+)\$/ig);
			if(fieldRange != null){
				for(var j=0; j<fieldRange.length; j++){
					var fieldid = fieldRange[j].replace(/\$/g,"");
					
					if(!document.getElementById("field"+fieldid)){
						jQuery("[name^='field"+fieldid+"_']").each(function(){
							var idtemp = jQuery(this).attr("id");
							doSqlFieldAjax(document.getElementById(idtemp),assignField);
						});						
					}else{						
						doSqlFieldAjax(document.getElementById("field"+fieldid),assignField);
					}
				}
				return;
			}
		}
	
		if(flag === "AllRow"){		//肯定是明细页面打开
			var oTable = jQuery("[name='field"+assignField+"_0']").closest("table[name^=oTable]");
			oTable.find("input[type='checkbox'][name^=check_node_]").each(function(index){
				var rowIndex = parseInt(jQuery(this).val());
				if(index != 0)
					wvals += wf__info.datassplit;
				wvals += getSingleRecordParamStr(assignField, rowIndex, fieldsql);
			});
		}else{	//单条数据请求，主表或明细addRow计算单条
			var rowIndex = parseInt(flag);
			wvals += getSingleRecordParamStr(assignField, rowIndex, fieldsql);
		}
		if(wvals === "")
			return;
		if(window.console)	console.log("SQL属性联动请求--"+wvals);
		wvals = escape(wvals);
		var paramstr = "nodeid="+wf__info.nodeid+"&formid="+wf__info.formid+"&isbill="+wf__info.isbill+
			"&f_weaver_belongto_userid="+wf__info.f_bel_userid+"&f_weaver_belongto_usertype="+wf__info.f_bel_usertype+
			"&requestid="+wf__info.requestid+"&wvals="+wvals;
		jQuery.ajax({
			url : getAjaxRequestPath()+"WfFieldAttrAjax.jsp",
			type : "post",
			processData : false,
			data : paramstr,
			dataType : "json",
			success: function(result){
				parseFieldAttrAjaxResult(result, true);
			}
		});
	}
	
	/**
	 * 字段变更触发SQL属性联动
	 * @param {obj} 	触发对象
	 * @param {assignFields} 	联动结果字段，逗号隔开
	 */
	function doSqlFieldAjax(obj, assignFields){
		if(jQuery.browser.msie && window.event){
			var propertyName = window.event.propertyName;
			if(!!propertyName && propertyName != 'value')	//可能onchange触发propertyName为空
				return;
		}
		if(wf__info.onlyview)		
			return;
		var thisfieldid = "";
		try{
			if(obj.id.indexOf("field") > -1){
				thisfieldid = obj.id.substring(5);
			}else{
				if(obj.name == "requestname")
					thisfieldid = "-1";
				else if(obj.name == "requestlevel")
					thisfieldid = "-2";
				else if(obj.name == "messageType")
					thisfieldid = "-3";
			}
		}catch(e){}
		if(thisfieldid === "")
			return;
		var rowIndex = -1;
		if(thisfieldid.indexOf("_") > -1)
			rowIndex = parseInt(thisfieldid.substring(thisfieldid.indexOf("_")+1));
		var wvals = "";
		var assignFieldArr = assignFields.split(",");
		var k = 0;
		for(var i=0; i<assignFieldArr.length; i++){
			var assignField = assignFieldArr[i];
			var fieldsql = jQuery("#fieldsql"+assignField).val();
			if(!!!assignField || !!!fieldsql )
				continue;
			
			var needcontinue = false;
			//如果字段属性同时 使用主表字段，明细字段作为查询条件，且主表字段变动时
			if(rowIndex == -1){
				var fieldRange = fieldsql.match(/\$(requestid|-?\d+)\$/ig);
				if(fieldRange != null){
					for(var j=0; j<fieldRange.length; j++){
						var fieldid = fieldRange[j].replace(/\$/g,"");
						
						if(!document.getElementById("field"+fieldid)){
							jQuery("[name^='field"+fieldid+"_']").each(function(){
								var idtemp = jQuery(this).attr("id");
								doSqlFieldAjax(document.getElementById(idtemp),assignField);
							});
							needcontinue = true;
						}
					}
				}
			}
			
			if(needcontinue)
				continue;
			
			if(k > 0)
				wvals += wf__info.datassplit;
			wvals += getSingleRecordParamStr(assignField, rowIndex, fieldsql);
			k++;
		}
		if(wvals === "")
			return;
		if(window.console)	console.log("SQL属性联动请求--"+wvals);
		var changeTemp = wvals;
		wvals = escape(wvals);
		var paramstr = "nodeid="+wf__info.nodeid+"&formid="+wf__info.formid+"&isbill="+wf__info.isbill+
			"&f_weaver_belongto_userid="+wf__info.f_bel_userid+"&f_weaver_belongto_usertype="+wf__info.f_bel_usertype+
			"&requestid="+wf__info.requestid+"&wvals="+wvals;
		if(changeTemp.charAt(changeTemp.length - 1) != "|") {
			setTimeout(function(){
				jQuery.ajax({
					url : getAjaxRequestPath()+"WfFieldAttrAjax.jsp",
					type : "post",
					processData : false,
					data : paramstr,
					dataType : "json",
					success: function(result){
						parseFieldAttrAjaxResult(result, false);
					}
				});
			},500);
		}else {
			jQuery.ajax({
				url : getAjaxRequestPath()+"WfFieldAttrAjax.jsp",
				type : "post",
				processData : false,
				data : paramstr,
				dataType : "json",
				success: function(result){
					parseFieldAttrAjaxResult(result, false);
				}
			});
		}
	}
	
	/**
	 * 拼接单条联动请求数据参数
	 */
	function getSingleRecordParamStr(assignField, rowIndex, fieldsql){
		var fieldRange = fieldsql.match(/\$(requestid|-?\d+)\$/ig);
		var calculateFieldStr = "";
		if(fieldRange != null){
			for(var i=0; i<fieldRange.length; i++){
				var fieldid = fieldRange[i].replace(/\$/g,"");
				var fieldval = getFieldValue(fieldid, rowIndex);
				calculateFieldStr += fieldid + "|" + fieldval;
				if(i != fieldRange.length-1)
					calculateFieldStr += wf__info.valuesplit;
			}
		}
		var singleParamStr = "";
		singleParamStr += assignField + wf__info.paramsplit;
		singleParamStr += rowIndex + wf__info.paramsplit;
		if(calculateFieldStr === "")
			calculateFieldStr = " ";	//无取值字段给个占位符便于后台解析时split
		singleParamStr += calculateFieldStr;
		return singleParamStr;
	}
	
	/**
	 * 根据字段ID取字段值（PC、手机端共用）
	 */
	function getFieldValue(fieldid, rowIndex){
		var fieldValue = "";
		try{
			if(rowIndex > -1){	//明细字段
				//明细字段sql属性中，采用主字段做参数的情况
				if(document.getElementById("field"+fieldid+"_"+rowIndex)){
					fieldid = fieldid+"_"+rowIndex;
				}
			}
			if(fieldid == "-1"){
				fieldValue = jQuery("[name=requestname]").val();
			}else if(fieldid == "-2"){
				fieldValue = jQuery('input[name="requestlevel"]:checked ').val();
			}else if(fieldid == "-3"){
				fieldValue = jQuery("[name=messageType]").val();
			}else if(fieldid.toLowerCase() == "requestid"){
				fieldValue = wf__info.requestid;
				if(parseInt(fieldValue) < 0)
					fieldValue = "0";	//手机端新建时为-1，数据库可能含requestid为-1的垃圾数据，导致执行SQL结果异常
			}else{
				fieldValue = jQuery("#field"+fieldid).val();
				if(jQuery("#field"+fieldid).nodeName == 'TEXTAREA'){
				   fieldValue = document.getElementById("field"+fieldid).innerHTML.replace(/&nbsp;/g," ");
				}
			}
		}catch(e){}
		return fieldValue;
	}
	
	/**
	 * 日期时间计算
	 */
	function doFieldDateAjax(para, fieldidtmp, fieldExt){
		if(wf__info.onlyview)		
			return;
		var sql = para;
		var thisfieldid = "0"+fieldExt;
		jQuery.ajax({
			url : getAjaxRequestPath()+"WfFieldDateAjax.jsp",
			type : "post",
			processData : false,
			data : sql+"&formid="+wf__info.formid+"&isbill="+wf__info.isbill+"&nodeid="+wf__info.nodeid+"&fieldid="+fieldidtmp,
			dataType : "xml",
			success: function do4Success(xmlstr){
				var name = "";
				var key = "";
				var htmltype = "";
				var type = "";
				try{
					name = xmlstr.getElementsByTagName("name")[0].childNodes[0].nodeValue;
					key = xmlstr.getElementsByTagName("key")[0].childNodes[0].nodeValue;
					htmltype = xmlstr.getElementsByTagName("htmltype")[0].childNodes[0].nodeValue;
					type = xmlstr.getElementsByTagName("type")[0].childNodes[0].nodeValue;
				}catch(e){}
				var rowIndex = -1;
				if(fieldExt.indexOf("_") > -1)
					rowIndex = parseInt(fieldExt.substring(fieldExt.indexOf("_")+1));
				setFieldValueByJson(fieldidtmp, rowIndex, name, key, htmltype, type, false);
			}
		});
	}
	
	
	/**
	 * 解析ajax请求结果
	 * @param {result} 	封装所有请求数据结果，已为JSON格式
	 */
	function parseFieldAttrAjaxResult(result, needInitCheckData){
		try{
			if(jQuery.isEmptyObject(result.datas))
				return;
			var datas = result.datas;
			for(var i=0; i<datas.length; i++){
				var fieldid = "";
				var rowIndex = -1;
				var name = "";
				var key = "";
				var htmltype = "";
				var type = "";
				try{
					var singlejson = datas[i];
					fieldid = singlejson.assignField;	//赋值字段ID
					name = singlejson.name;
					key = singlejson.key;
					htmltype = singlejson.htmltype;
					type = singlejson.type;
					rowIndex = parseInt(singlejson.rowIndex);
				}catch(e){}
				if(rowIndex == -1){
					if(document.getElementById('field'+fieldid) ||  fieldid == -1  || fieldid == -2 || fieldid == -3){
						setFieldValueByJson(fieldid, rowIndex, name, key, htmltype, type, needInitCheckData);
					}else{//如果主字段作为明细字段sql属性的参数，那么需要联动修改所有明细
						jQuery("[name^='field"+fieldid+"_']").each(function(){
							var name_temp = jQuery(this).attr("name");
							if(name_temp.indexOf("_") > -1){
								var rowIndex_temp = name_temp.substring(name_temp.indexOf("_")+1);
								setFieldValueByJson(fieldid, rowIndex_temp, name, key, htmltype, type, needInitCheckData);
							}
						});
					}
				}else{
					setFieldValueByJson(fieldid, rowIndex, name, key, htmltype, type, needInitCheckData);
				}
			}
		}catch(e){
			if(window.console)	console.log("parseFieldAttrAjaxResult Error:"+e);
		}
	}
	
	/**
	 * 单个请求结果赋值，操作DOM
	 * @param {fieldid} 	赋值字段ID
	 * @param {rowIndex} 	主表为-1，明细表为行号
	 * @param {name} 	值
	 * @param {key} 	键
	 * @param {htmltype} 	字段类型
	 * @param {type} 	字段小类型
	 * @param {needInitCheckData} 	是否页面初始化调用
	 */
	function setFieldValueByJson(fieldid, rowIndex, name, key, htmltype, type, needInitCheckData){
		if(wf__info.belmobile){		//手机端单独方法操作DOM
			setFieldValueByJsonMobile(fieldid, rowIndex, name, key, htmltype, type, needInitCheckData);
			return;
		}
		name = name.replace(/&lt;/g, "<").replace(/&gt;/g, ">");
		var rowStr = "";
		if(rowIndex > -1)
			rowStr = "_"+rowIndex;
		//必填标示
		var viewtype = "0";
		var requiredstr  = "";
		try{
			viewtype = document.getElementById("field"+fieldid+rowStr).getAttribute('viewtype');
		}catch(e){}
		if(viewtype === "1"){
			requiredstr  = '<img src="/images/BacoError_wev8.gif" align="absMiddle">';
		}
		//字段赋值
		try{
			if(fieldid == "-1"){
				var requestnameObj = jQuery("input[name='requestname']")[0];
				requestnameObj.value = name;
				if(requestnameObj.type != "hidden"){
					if(name != "")
						jQuery("span#requestnamespan").html("");
				}else{
					jQuery("span#requestnamespan").html(name);
				}
			}else if(fieldid == "-2"){
				var fieldObjs = document.getElementsByName("requestlevel");
				for(var i=0; i<fieldObjs.length; i++){
					if(fieldObjs[i].value == name){
						fieldObjs[i].checked = true;
					}else{
						fieldObjs[i].checked = false;
					}
				}
			}else if(fieldid == "-3"){
				var fieldObjs = document.getElementsByName("messageType");
				for(var i=0; i<fieldObjs.length; i++){
					if(fieldObjs[i].value == name){
						fieldObjs[i].checked = true;
					}else{
						fieldObjs[i].checked = false;
					}
				}
			}else{
				if(htmltype=="1"){//input
					try{
						if(document.getElementById("field"+fieldid+rowStr).type!="hidden"){
							document.getElementById("field"+fieldid+rowStr).value = getShowName(name);
							if(name){
								jQuery("#field"+fieldid+rowStr+"span").html('');
							}else{
								jQuery("#field"+fieldid+rowStr+"span").html(requiredstr);
							}
						}else{
							document.getElementById("field"+fieldid+rowStr+"span").innerHTML = name;
							document.getElementById("field"+fieldid+rowStr).value = name;
						}
					}catch(e){
						try{
							document.getElementById("field"+fieldid+rowStr+"span").innerHTML = name;
						}catch(e){}
					}
					if(type == "4"){//金额转换
						try{
							document.getElementById("field_lable"+fieldid+rowStr).value = name;
							if(rowStr.length == 0){	
								if(document.getElementById("field_lable"+fieldid).value != ""){
									var floatNum = floatFormat(document.getElementById("field_lable"+fieldid).value);
									var val = numberChangeToChinese(floatNum)
									if(val == ""){
										alert(msgWarningJinEConvert);
										document.getElementById("field"+fieldid).value = "";
										document.getElementById("field_lable"+fieldid).value = "";
										document.getElementById("field_chinglish"+fieldid).value = "";
									} else {
										document.getElementById("field"+fieldid).value = floatNum;
										document.getElementById("field_lable"+fieldid).value = milfloatFormat(floatNum);
										document.getElementById("field_chinglish"+fieldid).value = val;
									}
								}else{
									document.getElementById("field"+fieldid).value = "";
									document.getElementById("field_chinglish"+fieldid).value = "";
								}
							}
							//numberToChinese(""+fieldid+rowStr);
							if(rowStr != null || rowStr != ""){
								if($G("field_lable"+""+fieldid+rowStr).value != ""){
								var floatNum = floatFormat($G("field_lable"+""+fieldid+rowStr).value);
								var val = numberChangeToChinese(floatNum);
									if(val == ""){
										alert("整数位数长度不能超过12位，请重新输入！");
										$G("field_lable"+""+fieldid+rowStr).value = "";
										$G("field"+""+fieldid+rowStr).value = "";
									}else{
										if(rowStr != ""){
											$G("field_lable"+""+fieldid+rowStr).value = val;
											$G("field"+""+fieldid+rowStr).value = floatNum;
										}
									}
								} else {
									$G("field"+""+fieldid+rowStr).value = "";
								}
							}
							try{
								document.getElementById("field"+fieldid+rowStr+"span").innerHTML = "";
								if(document.getElementById("field"+fieldid+rowStr)) {
									document.getElementById("field"+fieldid+rowStr).value = name;
								}
							}catch(e){}
						}catch(e){}
					}
					if(type == "5"){ // 千分位
						try{
							var datalength = document.getElementById("field"+fieldid+rowStr).datalength;
							if(datalength == null || datalength == '') {
								datalength = 2;
							}
							document.getElementById("field"+fieldid+rowStr).value = changeToThousandsVal(toPrecision(name, datalength));
						}catch(e){}
					}
					if(rowStr !== "" && (type=="2" || type=="3" || type=="4" || type=="5")){	//触发行列规则
						try{
							var oTableObjs = jQuery("table[id^='oTable']");
							var tableLength = oTableObjs.size();
							for(var cx=0; cx<tableLength; cx++){
								var id_tmp = oTableObjs.get(cx).id;
								var groupid_tmp = parseInt(id_tmp.substr(6));
								triDetailCalSumField = "field"+fieldid+rowStr;
								calSum(groupid_tmp,false,rowIndex);
							}
						}catch(e){}
					}
				}else if(htmltype=="2"){
					try{
						if (jQuery("textarea[name='field"+fieldid+rowStr+"']").length > 0 && jQuery("#field"+fieldid+rowStr).hasClass('edui-default')) {
							setTimeout(function(){CkeditorExt.setHtml(getShowName(name), "field"+fieldid+rowStr);},700);
						} else {
							if(document.getElementById("field"+fieldid+rowStr).style.display!="none" && document.getElementById("field"+fieldid+rowStr).tagName=="TEXTAREA"){
								document.getElementById("field"+fieldid+rowStr).value = getShowName(convertBr(name));
								if(name){
									jQuery("#field"+fieldid+rowStr+"span").html('');
								}else{
									jQuery("#field"+fieldid+rowStr+"span").html(requiredstr);
								}
							}else{
								document.getElementById("field"+fieldid+rowStr).value = name;
								document.getElementById("field"+fieldid+rowStr+"span").innerHTML = name;
							}
						}
					}catch(e){
						try{
							document.getElementById("field"+fieldid+rowStr+"span").innerHTML = name;
						}catch(e){}
					}
					try{
						var fieldtemptype = "1";
						try{
							fieldtemptype = document.getElementById("field"+fieldid+rowStr).temptype;
						}catch(e){
							fieldtemptype = "1";
						}
						if(fieldtemptype == "2"){
							window.setTimeout(function(){setFckText("field"+fieldid, "field"+fieldid+"span", name, fieldid);},100);
						}
					}catch(e){
						//alert(e);
					}
					try{
						if(document.getElementById("FCKiframe"+fieldid)){
							document.getElementById("field"+fieldid+"span").style.display = "";
							document.getElementById("field"+fieldid+"span").innerHTML = name;
							document.getElementById("FCKiframe"+fieldid).width = "0px";
							document.getElementById("FCKiframe"+fieldid).height = "0px";
						}else{
							if(document.getElementById("field"+fieldid+rowStr).style.display!="none" && document.getElementById("field"+fieldid+rowStr).tagName=="TEXTAREA"){
								document.getElementById("field"+fieldid+"span").innerHTML = "";
							}
						}
					}catch(e){
						//alert(e);
					}
				}else if(htmltype == "3"){//button
				
					if(type == "34"){
						try{
							var selectField = document.getElementById("field"+fieldid+rowStr);
							//非只读时
							if(document.getElementById("disfield"+fieldid+rowStr) && document.getElementById("disfield"+fieldid+rowStr).tagName == "SELECT"){
							
								jQuery("#disfield"+fieldid+rowStr).find("option").each(function(index,ele){
									jQuery(ele).removeAttr("selected");
								});
								if(key !== ""){
									jQuery("#disfield"+fieldid+rowStr).find("option[value='" + parseInt(key,10) + "']").attr("selected","selected");
									selectField.value = parseInt(key,10);
									if(selectField.onchange && selectField.onchange.toString().indexOf("changeshowattr") != -1){
									   jQuery(selectField).trigger("change");
									}
								}
							}else {
								for(var i=0; i<selectField.options.length; i++){
									var optionTmp = selectField.options[i];
									if(optionTmp.value == key){
										optionTmp.selected = true;
									}else{
										optionTmp.selected = false;
									}
								}
								if(selectField.onchange && selectField.onchange.toString().indexOf("changeshowattr") != -1){
								   jQuery(selectField).trigger("change");
								}
							}
							var newLeaveType = jQuery("select[name='newLeaveType']");
							$(newLeaveType).selectbox('hide');
							jQuery(newLeaveType).autoSelect({showAll: 'true'});
						}catch(e){}
					}else{
						try{
							//如果只有name，没有key，而赋值字段又为浏览按钮，则显示的值，即为保存的值
							if (key == null || key == undefined || key == "") {
								if (!!name) {
									key = name.replace(/&nbsp;/g, ",");
								}
							}
							document.getElementById("field"+fieldid+rowStr).value = key;
						}catch(e){}
						if (name) {
							var keys=key.split(",");
							var names=name.replace(/&nbsp;/g, ",").split(",");
							name="";
							var _isedit = jQuery("#field"+fieldid+rowStr).attr("_isedit");
							var isedit = true;
							if (!!_isedit && _isedit == 0) {
								isedit = false;
							}
							
							var _nbtnobj = jQuery("#field" + fieldid + rowStr + "_browserbtn")[0];
							//var _obtnobj = jQuery("#field" + fieldid + rowStr + "browser")[0];
							if (!!_nbtnobj) {
								isedit = true;
							} else {
								isedit = false;
							}
							/*
							for(var i=0;i<keys.length;i++){
								name += '<span class="e8_showNameClass"><a onclick="pointerXY(event);" href="javaScript:openhrm('+keys[i]+');">'+names[i]+'</a>';
								if (isedit) {
									name += '<span id="'+keys[i]+'" class="e8_delClass" style="opacity: 0; visibility: hidden;" onclick="del(event,this,1,false,{});"> x </span>';
								}
								name += '</span>';
							}
							*/
							
							for(var i=0;i<keys.length;i++){
								name += '<span class="e8_showNameClass"><a onclick="javascript:return false;" href="javascript:return false;">'+names[i]+'</a>';
								if (isedit) {
									name += '<span id="'+keys[i]+'" class="e8_delClass" style="opacity: 0; visibility: hidden;" onclick="del(event,this,1,false,{});"> x </span>';
								}
								name += '</span>';
							}
							
							//name = '<span class="e8_showNameClass"><a onclick="pointerXY(event);" href="javaScript:openhrm('+key+');">'+name+'</a><span id="'+key+'" class="e8_delClass" style="opacity: 0; visibility: hidden;" onclick="del(event,this,1,false,{});"> x </span></span>';
							document.getElementById("field"+fieldid+rowStr+"span").innerHTML = name;
						}
						if (name) {
							jQuery("#field"+fieldid+rowStr+"span span").mouseover(function() {
								jQuery("#field"+fieldid+rowStr+"span").addClass('e8_showNameHoverClass');
								jQuery("#field"+fieldid+rowStr+"span span span").css('opacity', '1').css('visibility', 'visible');
							}).mouseout(function() {
								jQuery("#field"+fieldid+rowStr+"span").removeClass('e8_showNameHoverClass');
								jQuery("#field"+fieldid+rowStr+"span span span").css('opacity', '0').css('visibility', 'hidden');
							});
						}else{
							jQuery("#field"+fieldid+rowStr+"span").html('');
						}
						
						//必填标识
						if(viewtype === "1"){
							if(name){
								jQuery("#field"+fieldid+rowStr+"spanimg").html('');
							}else{
								jQuery("#field"+fieldid+rowStr+"spanimg").html(requiredstr);
							}
						}
						try{
							if(rowStr==''){
								triggerCallback("field"+fieldid+rowStr);
							}
						}catch(e){if(window.console)console.log(e)}
					}
				}else if(htmltype == "5"){//select
					try{
						var selectField = document.getElementById("field"+fieldid+rowStr);
						//非只读时
                        if(document.getElementById("disfield"+fieldid+rowStr) && document.getElementById("disfield"+fieldid+rowStr).tagName == "SELECT"){
                        
					        jQuery("#disfield"+fieldid+rowStr).find("option").each(function(index,ele){
					            jQuery(ele).removeAttr("selected");
					        });
					        if(key !== ""){
					            jQuery("#disfield"+fieldid+rowStr).find("option[value='" + parseInt(key,10) + "']").attr("selected","selected");
					            selectField.value = parseInt(key,10);
					            if(selectField.onchange && selectField.onchange.toString().indexOf("changeshowattr") != -1){
					               jQuery(selectField).trigger("change");
					            }
					        }
                        }else {
                            for(var i=0; i<selectField.options.length; i++){
                                var optionTmp = selectField.options[i];
                                if(optionTmp.value == key){
                                    optionTmp.selected = true;
                                }else{
                                    optionTmp.selected = false;
                                }
                            }
				            if(selectField.onchange && selectField.onchange.toString().indexOf("changeshowattr") != -1){
				               jQuery(selectField).trigger("change");
				            }
                        }
					}catch(e){}
				}else if(htmltype == "7"){//especial
					try{
						document.getElementById("field"+fieldid+"span").innerHTML = name;
					}catch(e){}
				}
			}
		}catch(e){
			//alert(e);
		}
		if(needInitCheckData == undefined)
			needInitCheckData = false;
		if(needInitCheckData == true){//如果是初始化页面的时候调用了Ajax去修改页面元素的值，则需要在这里初始化一下页面用于存放初始值的div的innerHTML
			try{
				createTags();
			}catch(e){}
		}
	}

	function encodeToHTMLText(strText,ishtml){
		if(ishtml=='1'){
		   strText=strText.replace(/&amp;/gi,"&");
		}else{
			strText=strText.replace(/&amp;/gi,"&");
			strText=strText.replace(/&#47;/gi,"/");
			strText=strText.replace(/&nbsp;/gi," ");
			strText=strText.replace(/&gt;/gi,">");
			strText=strText.replace(/&lt;/gi,"<");
		}
		return strText;
    }
	
		/**
	 * 手机端赋值操作DOM
	 */
	function setFieldValueByJsonMobile(fieldid, rowIndex, name, key, htmltype, type, needInitCheckData){
		var rowStr = "";
		if(rowIndex > -1)
			rowStr = "_"+rowIndex;
		try {
			if(fieldid == "-1"){
				var requestnameObj = jQuery("input[name='requestname']")[0];
				requestnameObj.value = name;
				if(requestnameObj.type != "hidden"){
					if(name != "")
						jQuery("span#requestnamespan").html("");
				}else{
					jQuery("span#requestnamespan").html(name);
				}
			}else if(fieldid == "-2"){
				var fieldObjs = document.getElementsByName("requestlevel");
				for(var i=0; i<fieldObjs.length; i++){
					if(fieldObjs[i].value == name){
						fieldObjs[i].checked = true;
					}else{
						fieldObjs[i].checked = false;
					}
				}
			}else if(fieldid == "-3"){
				var fieldObjs = document.getElementsByName("messageType");
				for(var i=0; i<fieldObjs.length; i++){
					if(fieldObjs[i].value == name){
						fieldObjs[i].checked = true;
					}else{
						fieldObjs[i].checked = false;
					}
				}
			}else if (fieldid == "-4") {
			} else {
				var detailhtmlvalue=name;
				if (htmltype == "1") {//input
					name = name.replace(/&nbsp;/g, " ");
					if ($("#field" + fieldid + rowStr).attr("type") == "hidden") {
						$("#field" + fieldid + rowStr + "_span").html(name);
					}
					$("#field" + fieldid + rowStr).val(encodeToHTMLText(name,'0'));
					
					//金额转换
					if (type == "4") {
						if (!!$("#field_lable" + fieldid + rowStr)[0]) {
							$("#field_lable" + fieldid + rowStr).val(name);
							$("#field_chinglish" + fieldid + rowStr).val(numberChangeToChinese(name));
							
							//避免金额千分位值被认为是非数字
							$("#field_lable" + fieldid + rowStr).trigger("onfocus");
							$("#field_lable" + fieldid + rowStr).trigger("onblur");
						} else {
							$("#field" + fieldid + rowStr + "_span").html(numberChangeToChinese(name));
						}
						detailhtmlvalue=numberChangeToChinese(name);
					}
					
					//金额千分位
					if (type == "5") {
						if ($("#field" + fieldid + rowStr).attr("type") == "hidden") {
							try {
								var sourcevalue = name;
								var re;
							    if(sourcevalue.indexOf(".")<0)
							        re = /(\d{1,3})(?=(\d{3})+($))/g;
							    else
							        re = /(\d{1,3})(?=(\d{3})+(\.))/g;
							    var tovalue = sourcevalue.replace(re,"$1,");
								$("#field" + fieldid + rowStr + "_span").html(tovalue);
								detailhtmlvalue=tovalue;
							} catch (e) {}
						} 
						$("#field" + fieldid + rowStr).trigger("onfocus");
						$("#field" + fieldid + rowStr).trigger("onblur");
						
					}
				} else if (htmltype == "2") {
					tarObj = $("#field" + fieldid + rowStr);
					if (!!tarObj && !!K && !!KE && !!K.g["field" + fieldid]) {
						$(tarObj).html(name);
						KE.html("field" + fieldid, name);
					} else {
						tarObj.html(name);
						$("#field" + fieldid + rowStr + "_span").html(name);
					}
					detailhtmlvalue=name;
				} else if (htmltype == "3") {//button
					var keysname="";
					try {
						//如果只有name，没有key，而赋值字段又为浏览按钮，则显示的值，即为保存的值
						if (key == null || key == undefined || key == "") {
							if (!!name) {
								key = name.replace(/&nbsp;/g, ",");
							}
						}
						if($("input[name='field" + fieldid + rowStr+"']").attr("id")== "manager"){
							$("#manager").val(key);
						}else{
							$("#field" + fieldid + rowStr).val(key);
						}
						

						var keyarray = key.split(",");
						var namearray = name.split("&nbsp;");
						var namehtml = "";
						for (var w = 0; w < keyarray.length; w++) {
							if(w==(keyarray.length-1)){
								namehtml += "<span keyid='" + keyarray[w] + "'>" + namearray[w] + "</span>";
								keysname += keyarray[w];
							}else{
								namehtml += "<span keyid='" + keyarray[w] + "'>" + namearray[w] + "</span> <div style='height:10px;overflow:hidden;width:1px;'></div>";
							   keysname += keyarray[w]+",";
							}
						}
					}
					catch (e) {
					}
						var displayBockEle = "";
					if($("input[name='field" + fieldid + rowStr+"']").attr("id")== "manager"){
						//if element not edit  manager_span
							displayBockEle = $("TD#manager_span");
						if (!!!displayBockEle[0]) {
							displayBockEle = $("SPAN#manager_span");
						}
					
					}else{
						//if element not edit 
							var displayBockEle = $("TD#field" + fieldid + rowStr + "_span");
						if (!!!displayBockEle[0]) {
								displayBockEle = $("SPAN#field" + fieldid + rowStr + "_span");
							}
					}			
					
					displayBockEle.html(namehtml);
					detailhtmlvalue=namehtml;
				} else if (htmltype == "5") {//select
					try {
						var tarSpanObj = $("#field" + fieldid + "_span")[0];
						if(tarSpanObj != null && tarSpanObj != undefined){
							var selectKVobj = $("#field" + fieldid + "_" + name);
							if (!!selectKVobj[0]) {
								tarSpanObj.innerHTML = selectKVobj.text();
								detailhtmlvalue=selectKVobj.text();
							}
							$("#field" + fieldid + rowStr).val(name);
						} else {
							$("select#field" + fieldid + rowStr+ " option[value=" + name + "]").attr("selected", "selected");
							$("#field" + fieldid + rowStr).trigger("onfocus");
							$("#field" + fieldid + rowStr).trigger("onblur");
							try{
							  detailhtmlvalue=$("select#field" + fieldid + rowStr+ " option[value=" + name + "]").text();
							}catch(ev){}
						}
					} catch (e) {}
				} else if (htmltype == "7") {//especial
					try {
						document.getElementById("field" + fieldid + "_span").innerHTML = name;
					}catch (e) {}
				}

				if(rowStr.trim() !=''){ //明细表字段赋值
					 var showdivid=jQuery("#"+fieldid+rowStr.replace("_","")).val();
					 jQuery("#"+showdivid).html(encodeToHTMLText(detailhtmlvalue,'1'));
					 //jQuery("#field" + fieldid + rowStr+"_d").val(encodeToHTMLText(jQuery("#field" + fieldid + rowStr).val(),'0'));
					 //jQuery("#field" + fieldid + rowStr+"_span_d").html(encodeToHTMLText(detailhtmlvalue,'1'));
					 if(jQuery("input[name='field" + fieldid + rowStr+"']").attr("id")== "manager" || jQuery("input[name='field" + fieldid + rowStr+"_d']").attr("id")== "manager"){
							$("#manager").val(encodeToHTMLText(jQuery("#field" + fieldid + rowStr).val(),'0'));
							$("#manager_span").html(encodeToHTMLText(detailhtmlvalue,'1'));
						}else{
								 if(jQuery("#field" + fieldid + rowStr+"_d").length>0){
									   jQuery("#field" + fieldid + rowStr+"_d").val(encodeToHTMLText(jQuery("#field" + fieldid + rowStr).val(),'0'));
								 }else{
									 jQuery("#field" + fieldid + rowStr).attr("value",encodeToHTMLText(jQuery("#field" + fieldid + rowStr).val(),'0'));
								 }
								 if(jQuery("#field" + fieldid + rowStr+"_span_d").length>0){
									  jQuery("#field" + fieldid + rowStr+"_span_d").html(encodeToHTMLText(detailhtmlvalue,'1'));
								 }else{
									 jQuery("#field" + fieldid + rowStr+"_span").html(encodeToHTMLText(detailhtmlvalue,'1'));
								 }

						}
				}
				
			}
		}catch (e) {
			//alert(e);
		}
		if (needInitCheckData == undefined)
			needInitCheckData = false;
		if (needInitCheckData == true) {//如果是初始化页面的时候调用了Ajax去修改页面元素的值，则需要在这里初始化一下页面用于存放初始值的div的innerHTML
			try {
				createTags();
			}catch (e) {}
		}
		  
		$("#field" + fieldid + rowStr).trigger("blur");
		$("#field" + fieldid + rowStr).trigger("change");
	}
	
	function setFckText(ename, espan, textvalue, fieldid){
		try{
			if(document.getElementById("FCKiframe"+fieldid)){
				document.getElementById("field"+fieldid+"span").style.display = "";
			}else{
				FCKEditorExt.setHtml(textvalue, ename);
				document.getElementById("field"+fieldid+"span").innerHTML = "";
			}
		}catch(e){
			window.setTimeout(function(){setFckText(ename, espan, textvalue, fieldid);},100);
		}
	}

	function convertBr(str) {
		return str.replace(/<br>/g, '\n').replace(/<br\/>/g, '\n');
	}
	
	function getShowName(sname){
		var divt=document.createElement("div");
		divt.innerHTML=sname;
		return jQuery.trim(jQuery(divt).text());
	}
	
	
	return {
		//页面加载触发SQL属性联动
		pageLoadInitValue: function(assignField, flag){
			return pageLoadInitValue(assignField, flag);
		},
		//字段变更触发SQL属性联动
		doSqlFieldAjax: function(obj, assignFields){
			return doSqlFieldAjax(obj, assignFields);
		},
		//日期时间计算
		doFieldDateAjax: function(para, fieldidtmp, fieldExt){
			return doFieldDateAjax(para, fieldidtmp, fieldExt);
		}
	}

})();