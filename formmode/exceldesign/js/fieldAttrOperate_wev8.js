/**
 * @author liuzy 2016-01-26
 * SQL联动改造，提取、封装、解决性能问题
 * 1、Html模式(PC端、手机端)(新建、编辑、查看)页面字段属性联动提取到此JS，依赖全局变量mode__info
 * 2、表单加载时，明细SQL联动N条数据单个赋值字段只发起一次ajax请求
 * 3、单个字段触发多个联动赋值字段，只发起一次ajax请求
 */
var fieldAttrOperate = (function(){
	
	function getAjaxRequestPath(){
		return "/formmode/view/";
	}

	/**
	 * 页面加载触发SQL属性联动
	 * @param {assignField} SQL赋值字段
	 * @param {flag} 	-1计算主字段；>=0计算明细某行字段；AllRow初始化计算明细所有行
	 */
	function pageLoadInitValue(assignField, flag){
		var fieldsql = jQuery("#fieldsql"+assignField).attr("tempvalue");
		if(!!!fieldsql)
			return;
		var wvals = "";
		if(flag === "AllRow"){		//肯定是明细页面打开
			var oTable = jQuery("[name='field"+assignField+"_0']").closest("table[name^=oTable]");
			oTable.find("input[type='checkbox'][name^=check_mode_]").each(function(index){
				var rowIndex = parseInt(jQuery(this).val());
				if(index != 0)
					wvals += mode__info.datassplit;
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
		var paramstr = "layoutid="+mode__info.layoutid+"&formid="+mode__info.formid+
			"&f_weaver_belongto_userid="+mode__info.f_bel_userid+"&f_weaver_belongto_usertype="+mode__info.f_bel_usertype+
			"&billid="+mode__info.billid+"&wvals="+wvals;
		jQuery.ajax({
			url : getAjaxRequestPath()+"FieldAttrAjax.jsp",
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
		if(mode__info.onlyview)		
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
		for(var i=0; i<assignFieldArr.length; i++){
			var assignField = assignFieldArr[i];
			var fieldsql = jQuery("#fieldsql"+assignField).attr("tempvalue");
			if(!!!assignField || !!!fieldsql)
				continue;
			if(i > 0)
				wvals += mode__info.datassplit;
			wvals += getSingleRecordParamStr(assignField, rowIndex, fieldsql);
		}
		if(wvals === "")
			return;
		if(window.console)	console.log("SQL属性联动请求--"+wvals);
		wvals = escape(wvals);
		var paramstr = "layoutid="+mode__info.layoutid+"&formid="+mode__info.formid+
			"&f_weaver_belongto_userid="+mode__info.f_bel_userid+"&f_weaver_belongto_usertype="+mode__info.f_bel_usertype+
			"&billid="+mode__info.billid+"&wvals="+wvals;
		jQuery.ajax({
			url : getAjaxRequestPath()+"FieldAttrAjax.jsp",
			type : "post",
			processData : false,
			data : paramstr,
			dataType : "json",
			success: function(result){
				parseFieldAttrAjaxResult(result, false);
			}
		});
	}
	
	/**
	 * 拼接单条联动请求数据参数
	 */
	function getSingleRecordParamStr(assignField, rowIndex, fieldsql){
		var fieldRange = fieldsql.match(/\$(billid|-?\d+)\$/ig);
		var calculateFieldStr = "";
		if(fieldRange != null){
			for(var i=0; i<fieldRange.length; i++){
				var fieldid = fieldRange[i].replace(/\$/g,"");
				var fieldval = getFieldValue(fieldid, rowIndex);
				calculateFieldStr += fieldid + "|" + fieldval;
				if(i != fieldRange.length-1)
					calculateFieldStr += mode__info.valuesplit;
			}
		}
		var singleParamStr = "";
		singleParamStr += assignField + mode__info.paramsplit;
		singleParamStr += rowIndex + mode__info.paramsplit;
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
			}else if(fieldid.toLowerCase() == "billid"){
				fieldValue = mode__info.billid;
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
		if(mode__info.onlyview)		
			return;
		var sql = para;
		var thisfieldid = "0"+fieldExt;
		jQuery.ajax({
			url : getAjaxRequestPath()+"FieldDateAjax.jsp",
			type : "post",
			processData : false,
			data : sql+"&fieldid="+fieldidtmp,
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
					if(document.getElementById('field'+fieldid) || (htmltype == 2 && document.getElementById('field'+fieldid+"span"))){
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
		if(mode__info.belmobile){		//手机端单独方法操作DOM
			setFieldValueByJsonMobile(fieldid, rowIndex, name, key, htmltype, type, needInitCheckData);
			return;
		}
		var rowStr = "";
		if(rowIndex > -1)
			rowStr = "_"+rowIndex;
		//必填标示
		var viewtype = "0";
		try{
			viewtype = document.getElementById("field"+fieldid+rowStr).getAttribute('viewtype');
		}catch(e){}
		//字段赋值
		try{
			if(fieldid == "-1"){
				try{
					document.getElementById("requestname").value = name;
				}catch(e){}
					try{
						if(document.getElementById("requestname").type!="hidden"){
							document.getElementById("requestname").value = name;
							if(name != ""){
								document.getElementById("requestnamespan").innerHTML = "";
							}
						}else{
							document.getElementById("requestnamespan").innerHTML = name;
						}
					}catch(e){
						try{
							document.getElementById("requestname").innerHTML = name;
						}catch(e){}
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
							if(name != ""){
								document.getElementById("field"+fieldid+rowStr+"span").innerHTML = "";
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
							numberToChinese(""+fieldid+rowStr);
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
								calSum(groupid_tmp);
							}
						}catch(e){}
					}
				}else if(htmltype=="2"){
					try{
						if (jQuery("textarea[name='field"+fieldid+rowStr+"']").length > 0 && jQuery("#field"+fieldid+rowStr).hasClass('edui-default')) {
							setTimeout(function(){CkeditorExt.setHtml(getShowName(name), "field"+fieldid+rowStr);},700);
						} else {
							if(document.getElementById("field"+fieldid+rowStr).style.display!="none" && document.getElementById("field"+fieldid+rowStr).tagName=="TEXTAREA"){
								document.getElementById("field"+fieldid+rowStr).value = getShowName(name);
								if(name != ""){
									document.getElementById("field"+fieldid+rowStr+"span").innerHTML = "";
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
					}
					document.getElementById("field"+fieldid+rowStr+"span").innerHTML = name;
					if (name) {
						jQuery("#field"+fieldid+rowStr+"span span").mouseover(function() {
							jQuery("#field"+fieldid+rowStr+"span").addClass('e8_showNameHoverClass');
							jQuery("#field"+fieldid+rowStr+"span span span").css('opacity', '1').css('visibility', 'visible');
						}).mouseout(function() {
							jQuery("#field"+fieldid+rowStr+"span").removeClass('e8_showNameHoverClass');
							jQuery("#field"+fieldid+rowStr+"span span span").css('opacity', '0').css('visibility', 'hidden');
						});
					}
				}else if(htmltype == "5"){//select
					try{
						var selectField = document.getElementById("field"+fieldid+rowStr);
						for(var i=0; i<selectField.options.length; i++){
							var optionTmp = selectField.options[i];
							if(optionTmp.value == key){
								optionTmp.selected = true;
							}else{
								optionTmp.selected = false;
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
	
	/**
	 * 手机端赋值操作DOM
	 */
	function setFieldValueByJsonMobile(fieldid, rowIndex, name, key, htmltype, type, needInitCheckData){
		var rowStr = "";
		if(rowIndex > -1)
			rowStr = "_"+rowIndex;
		try {
			if (fieldid == "-1") {
			} else if (fieldid == "-2") {
			} else if (fieldid == "-3") {
			} else if (fieldid == "-4") {
			} else {
				if (htmltype == "1") {//input
					if ($("#field" + fieldid + rowStr).attr("type") == "hidden") {
						$("#field" + fieldid + rowStr + "_span").html(name);
					}
					$("#field" + fieldid + rowStr).val(name);
					
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
				} else if (htmltype == "3") {//button
					try {
						//如果只有name，没有key，而赋值字段又为浏览按钮，则显示的值，即为保存的值
						if (key == null || key == undefined || key == "") {
							if (!!name) {
								key = name.replace(/&nbsp;/g, ",");
							}
						}
						$("#field" + fieldid + rowStr).val(key);
						var keyarray = key.split(",");
						var namearray = name.split("&nbsp;");
						var namehtml = "";
						for (var w = 0; w < keyarray.length; w++) {
							namehtml += "<span keyid='" + keyarray[w] + "'>" + namearray[w] + "</span><div style='height:10px;overflow:hidden;width:1px;'></div>";
						}
					}
					catch (e) {
					}
					//if element not edit
					var displayBockEle = $("TD#field" + fieldid + rowStr + "_span");
					if (!!!displayBockEle[0]) {
						displayBockEle = $("SPAN#field" + fieldid + rowStr + "_span");
					}
					displayBockEle.html(namehtml);
				} else if (htmltype == "5") {//select
					try {
						var tarSpanObj = $("#field" + fieldid + "_span")[0];
						if(tarSpanObj != null && tarSpanObj != undefined){
							var selectKVobj = $("#field" + fieldid + "_" + name);
							if (!!selectKVobj[0]) {
								tarSpanObj.innerHTML = selectKVobj.text();
							}
							$("#field" + fieldid + rowStr).val(name);
						} else {
							$("select#field" + fieldid + " option[value=" + name + "]").attr("selected", "selected");
							$("#field" + fieldid + rowStr).trigger("onfocus");
							$("#field" + fieldid + rowStr).trigger("onblur");
						}
					} catch (e) {}
				} else if (htmltype == "7") {//especial
					try {
						document.getElementById("field" + fieldid + "_span").innerHTML = name;
					}catch (e) {}
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
		$("#field" + fieldid + rowStr).trigger("onchange");
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