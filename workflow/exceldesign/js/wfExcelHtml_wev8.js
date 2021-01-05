/**
 * @author liuzy 2015-09-07
 * 表单设计器模板，前台显示/操作时需要的相关JS方法
 */
 
var readyOperate = (function(){
	
	function isIE(){
		return jQuery.browser.msie;
	}
	
	function adjustTemplate(){
		var mainTable = jQuery("table.excelMainTable");
		//处理附件上传字段最小宽度400px
		mainTable.find("table[_target='mainFileUploadField']").each(function(){
			var curWidth = parseInt(jQuery(this).parent().width());
			if (curWidth>10 && curWidth < 400) {	//兼容后台模板隐藏时宽度为零
				mainTable.removeClass("tablefixed");
				if(mainTable.attr("_haspercent") == "false"){
					mainTable.css("width","auto");
				}
				return false;
			}
		});
		//处理IE下节点意见放置在模板上，含图片是撑开模板,使用max-width无效问题
		if(isIE()){
			var nodeSignImg = jQuery("td.td_etype_5").find("img");
			nodeSignImg.hide();		//先隐藏才能取到未被撑开的TD宽度
			nodeSignImg.each(function(){
				var imgObj = jQuery(this);
				var tdObj = imgObj.closest("td.td_etype_5");
				if(parseInt(imgObj.width()) > parseInt(tdObj.width()))
					imgObj.css("width", "90%");
			});
			nodeSignImg.show();
		}
		//处理IE下select设置font-size无法自适应撑开
		if(isIE()){
			mainTable.find("select[name^='field'],select[name^='disfield']").each(function(){
				var _fontsize = jQuery(this).find("option:eq(0)").css("font-size");
				if(!!_fontsize && ((_fontsize.indexOf("px")>-1 && parseFloat(_fontsize.replace("px",""))>12) || (_fontsize.indexOf("pt")>-1 && parseFloat(_fontsize.replace("pt",""))>9))){	
					//字体大于12px时IE下特殊处理
					/*if(parseInt(jQuery.browser.version, 10) < 9){		//IE8特殊处理（不特殊处理，计算/选择框联动有问题）
						var optionlen = 0;
						var options = jQuery(this).find("option");
						for(var j=0; j<options.length; j++){
							if(jQuery(options[j]).text().length > optionlen)
		                		optionlen = jQuery(options[j]).text().length;
						}
						jQuery(this).css("height", "30px");
						var setSelectWidth = 35;
						if(optionlen>1)		setSelectWidth=optionlen*25;
						jQuery(this).css("width", (setSelectWidth+"px"));
					}else{*/
						var _style = jQuery(this).attr("style");
						if(!!!_style)	_style="";
						//IE下拉框不会继承font-size属性，且必须写在style属性中，且不可通过cssText修改，诡异...
						jQuery(this).attr("style",_style+";height:auto;font-size:"+_fontsize+" !important;");
					//}
				}
			});
		}
		//处理财务格式外层div在可编辑状态下未撑开，必填状态下正常。
		jQuery("div.ffielddiv").each(function(){
			jQuery(this).parent().css("height","100%");
		});
	}
	
	return {
		//ready执行函数，type:0(显示模板)、1(打印模板)、2(移动模板)
		execute: function(type){
			try{
				if(type==0 || type==1){
					adjustTemplate();
				}
				//二维码、条形码自适应大小
				scancodeOperate.readyAdjustSize();
			}catch(e){
				if(window.console)	console.log("wfExcelHtmlReadyError:"+e);
			}
		}
	}
})();

/**
 * 调整明细合计样式。合计样式默认取表头标示所在行上一行样式
 * 可通过此JS调整调整,以头部某个单元格样式应用给合计样式
 * detailIdx 第几个明细表，从0计数
 * applyCellRow 应用单元格行(若是合并单元格，取合并区域左上角单元格行)
 * applyCellCol 应用单元格列(若是合并单元格，取合并区域左上角单元格列)
 */
function template_adjustSumCss(detailIdx, applyCellRow, applyCellCol){
	var applyCellClass = "detail"+detailIdx+"_"+applyCellRow+"_"+applyCellCol;
	jQuery("table#oTable"+detailIdx+">tfoot>tr:last-child").children().each(function(){
		jQuery(this).removeAttr("class").addClass(applyCellClass);
	});
}

/**
 * 针对新表单设计器显示模板，明细表头行合并占多行，序号样式及合计样式处理
 * @param detailIdx 明细几，例：明细1则detailIdx:0
 * @param row 表头占几行（不包括按钮行）,占一行的无需调用此方法
 */
function template_adjustDetailCss(detailIdx, row){
	try{
		var oTable = jQuery("table#oTable"+detailIdx);
		if(oTable.length == 0)
			return;
		if(oTable.find("tr[name='controlwidth']").size() == 0)
			return;
		var lasttitlerow = oTable.find("tr.exceldetailtitle").last().index();
		lasttitlerow = lasttitlerow -1;		//最后一个title所占行
		if(lasttitlerow < row)
			return;
		//处理序号样式
		var serHtml = "";
		for(var i=0; i<row; i++){
			var _class = "detail"+detailIdx+"_"+(lasttitlerow-i)+"_0";
			var _obj = oTable.find("tr.exceldetailtitle").find("td."+_class).first();
			if(!!!serHtml)
				serHtml = _obj.html();
			if(i === row-1){
				_obj.attr("rowspan", row).html(serHtml);
			}else{
				_obj.remove();
			}
		}
		//处理合计样式，直接以序号单元格样式覆盖合计行样式
		var lastSumRow = oTable.find("tr").last();
		if(lastSumRow.attr("class") != "header")
			return;
		var replaceClass = "detail"+detailIdx+"_"+(lasttitlerow-(row-1))+"_0";
		var reg = new RegExp("(detail"+detailIdx+"_)(\\d+)_(\\d+)","gm"); 
		lastSumRow.children().each(function(){
			var setClass = jQuery(this).attr("class").replace(reg, replaceClass);
			jQuery(this).attr("class", setClass);
		});
	}catch(e){}
}

/**
 * 函数名不可变更，门户调用
 * 门户元素加载完成，隐藏loadding效果，显示iframe内容
 */
function portalIframeLoadingOver(hpid, height){
	jQuery("div#portalLoading_"+hpid).hide();
	var portalIframe = jQuery("iframe#portalIframe_"+hpid);
	portalIframe.show();
	if(!!height)
		portalIframe.css("height", height);
}

var portalOperate = (function(){
	
	var __interval = {};
	function reloadPortalIframe(hpid, target, vthis){
		if(target == 'init' || target == 'blur'){
			refreshIframe(hpid);
		}else if(target == 'propchange'){
			var activeElm = document.activeElement;
			var curElm = jQuery(vthis);
			if(typeof(activeElm)!="undefined" && activeElm.id == curElm.attr("id") && curElm.attr("_hasbindblur") == 'y')
				return;
			if(__interval[hpid]){
				window.clearTimeout(__interval[hpid]);
			}
			__interval[hpid] = window.setTimeout(function(){
				refreshIframe(hpid);
			}, 1000);
		}	
	}
	
	function refreshIframe(hpid){
		var portalInfo = jQuery("input#portalInfo_"+hpid);
		var iframeSrc = portalInfo.val();
		var trifieldArr = jQuery("input#portalInfo_"+hpid).attr("_trifields").split(",");
		for(var i=0; i<trifieldArr.length; i++){
			iframeSrc += "&"+trifieldArr[i]+"="+encodeURIComponent(getTriFieldValue(trifieldArr[i]));
		}
		if(window.console)	console.log("门户元素src:"+iframeSrc);
		jQuery("iframe#portalIframe_"+hpid).attr("src", iframeSrc);
	}
	
	function getTriFieldValue(fieldid){
		var fieldval = "";
		var fieldObj = jQuery("#"+fieldid);
		if(fieldObj.size()>0){
			if(fieldObj.is("textarea")){
				//fieldval = fieldObj.text();  //chrome手动输入值不在text里
				fieldval = fieldObj.val();
			}else{
				fieldval = fieldObj.val();
				if(!!fieldval && fieldObj.is("input") && fieldObj.attr("datavaluetype")=="5"){
					fieldval = fieldval.replace(/,/g,"");
				}
			}
		}
		return fieldval;
	} 
	
	
	return{ 
		//表单字段联动门户元素，ready调用初始化事件
		initEvent: function(hpid){
			try{
				var trifieldArr = jQuery("input#portalInfo_"+hpid).attr("_trifields").split(",");
				for(var i=0; i<trifieldArr.length; i++){
					var trifieldObj = jQuery("#"+trifieldArr[i]);
					if(trifieldObj.size() == 0)
						continue;
					trifieldObj.bindPropertyChange(function(vthis){
						reloadPortalIframe(hpid, 'propchange', vthis);
					});
					if(trifieldObj.is("textarea") || trifieldObj.is("input[type!='hidden']")){
						trifieldObj.attr("_hasbindblur", "y");
						trifieldObj.bind("blur",function(){
							reloadPortalIframe(hpid, 'blur', jQuery(this));
						})
					}
				}
				reloadPortalIframe(hpid, 'init');
			}catch(e){}
		}
	}
})();


var iframeOperate = (function(){
	
	function showIframeArea(vthis){
		jQuery(vthis).closest("td").find(".iframeLoading").hide();
		jQuery(vthis).show();
	}
	
	//Iframe区域高度自适应高度
	function autoAdjustHeight(vthis){
		var iframeObj = jQuery(vthis);
		var funObj = function(){autoAdjustHeight(vthis)};
		var eachcount = parseInt(iframeObj.attr("eachcount"));
		if(eachcount > 10){
			iframeObj.css("height", "100px");
			return;
		}
		
		var contextObj = iframeObj[0].contentWindow.document;
		var bodyContentHeight = contextObj.body.scrollHeight;
		if(window.console) console.log("scrollHeight:"+bodyContentHeight+"  |offsetHeight:"+contextObj.body.offsetHeight)
		if(bodyContentHeight == 0){
			iframeObj.attr("eachcount", eachcount+1);
			window.setTimeout(funObj, 500);
		}else{
			iframeObj.css("height", bodyContentHeight+"px");
		}
	}


	return{
		//Iframe区域onload事件
		loadingOver: function(vthis){
			if(jQuery(vthis).attr("adjustheight") == "y"){
				window.setTimeout(function(){
					showIframeArea(vthis);
					autoAdjustHeight(vthis);
				},800);
			}else{
				showIframeArea(vthis);
			}
		}
	}
	
})();

var scancodeOperate = (function(){
	
	function adjustSize_scancode(vthis){
		try{
			var parentHeight = vthis.closest("td").height();
			var curHeight = vthis.height();
			if(window.console)console.log("二维码/条形码宽度调整:"+parentHeight+"  |  "+curHeight);
			if(parseInt(parentHeight)-parseInt(curHeight) > 8)		//td高度会包含图片高度及上边框高度，避免死循环触发
				vthis.css("height", parentHeight);
		}catch(e){}
	}
	
	return {
		//ready触发自适应单元格大小（针对所在行存在高度渐变时，故绑定个resize）
		readyAdjustSize: function(){
			window.setTimeout(function(){
				jQuery(".qrcodeimg,.barcodeimg").each(function(){
					var vthis = jQuery(this);
					vthis.resize(function(){
						adjustSize_scancode(vthis);
					});
					adjustSize_scancode(vthis);
				});
			},100);
		}
	}
})();

/**
 * 联动隐藏操作相关JS
 */
var viewattrOperator = (function(){
	
	/**
	 * fieldids以逗号隔开
	 * fieldattr:4代表隐藏字段标签及字段区域内容，5代表隐藏字段所在行，否则为不隐藏
	 */
	function linkageControlHide(fieldids, fieldattr, ismobile){
		var fieldArr = fieldids.split(",");
		var needHideArea = jQuery();
		jQuery.each(fieldArr, function(i, value){
			value = jQuery.trim(value);
			if(!!!value || value.indexOf("_0")==-1)
				return true;
			var fieldid = value.substring(0, value.indexOf("_"));
			var hideObj_Content = getNeedHideObj_Content(fieldid);
			var hideObj_Row = getNeedHideObj_Row(fieldid);
			
			hideObj_Row.add(hideObj_Content).removeClass("edesign_hide");
			if(ismobile)
				hideObj_Row.add(hideObj_Content).find("input[name='ismandfield']").removeAttr("_uncheckmand");
			
			if(fieldattr == 4){
				hideObj_Content.addClass("edesign_hide");
				if(ismobile)
					needHideArea = needHideArea.add(hideObj_Content);
			}else if(fieldattr == 5){
				hideObj_Row.addClass("edesign_hide");
				if(ismobile)
					needHideArea = needHideArea.add(hideObj_Row);
			}
		});

		needHideArea.find("input[name='ismandfield']").attr("_uncheckmand", "y")
	}


	
	function getNeedHideObj_Content(fieldid){
		var hideObj = jQuery();
		var excelMain = jQuery("table.excelMainTable");
		var FcontentObj = excelMain.find("td.td_edesign[_fieldid='"+fieldid+"']");
		if(FcontentObj.length == 0){
			FcontentObj = excelMain.find("span.span_mc[_fieldid='"+fieldid+"']");
			if(FcontentObj.length > 0)		//多字段
				hideObj = hideObj.add(FcontentObj);
		}else{
			hideObj = hideObj.add(FcontentObj.children("div"));
		}
		var FlabelObj = excelMain.find("td.td_edesign[_fieldlabel='"+fieldid+"']");
		if(FlabelObj.length == 0){
			FlabelObj = excelMain.find("span.span_mc[_fieldlabel='"+fieldid+"']");
			if(FlabelObj.length > 0)		//多字段
				hideObj = hideObj.add(FlabelObj);
		}else{
			hideObj = hideObj.add(FlabelObj.children("div"));
		}
		return hideObj;
	}
	
	function getNeedHideObj_Row(fieldid){
		var hideObj = jQuery();
		var excelMain = jQuery("table.excelMainTable");
		var tdObj = excelMain.find("td.td_edesign[_fieldid='"+fieldid+"']");
		if(tdObj.length == 0)	//多字段
			tdObj = excelMain.find("span.span_mc[_fieldid='"+fieldid+"']").closest("td.td_edesign");
		if(tdObj.length > 0){
			var rowspan = 1;
			if(!!tdObj.attr("rowspan"))		rowspan = parseInt(tdObj.attr("rowspan"));
			var curRowObj = tdObj.parent();
			//只处理当隐藏字段本身占多行，则多行全部隐藏
			for(var i=0; i<rowspan; i++){
				hideObj = hideObj.add(curRowObj);
				curRowObj = curRowObj.next();
			}
		}
		return hideObj;
	}
	
	function filterHideField(needCheckStr){
		if(needCheckStr.length>0 && needCheckStr.substr(needCheckStr.length-1) != ",")
			needCheckStr += ",";
		var excelMain = jQuery("table.excelMainTable");
		var hideObj = jQuery();
		var hideRowObj = excelMain.find("tr.edesign_hide");
		hideObj = hideObj.add(hideRowObj.children("td.td_edesign"));
		hideObj = hideObj.add(hideRowObj.find("span.span_mc"));
		var tdObj = excelMain.find("td.td_edesign");
		hideObj = hideObj.add(tdObj.children("div.edesign_hide").parent());
		hideObj = hideObj.add(tdObj.find("span.span_mc.edesign_hide"));
		//通过JS隐藏明细列不校验必填
		hideObj = hideObj.add(excelMain.find(".excelDetailTable td.edesign_hide"));
		hideObj.each(function(){
			var _fieldid = jQuery(this).attr("_fieldid");
			if(!!!_fieldid)
				return true;
			_fieldid = "field"+_fieldid+",";
			if(needCheckStr.indexOf(_fieldid) != -1)
				needCheckStr = needCheckStr.replace(new RegExp(_fieldid, "gi"), "");
		});
		return needCheckStr;
	}
	
	return {
		//联动控制隐藏
		linkageControlHide: function(fieldids, fieldattr, ismobile){
			return linkageControlHide(fieldids, fieldattr, ismobile);
		},
		//必填校验去掉隐藏区域的字段
		filterHideField: function(needCheckStr){
			return filterHideField(needCheckStr);
		}
	}
})();



