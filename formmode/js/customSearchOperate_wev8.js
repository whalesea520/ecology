var customSearchOperate = (function(){
	//清除用户列宽设置
	function cleanColWidth(){
		var customid = jQuery("#customid").val();
		window.top.Dialog.confirm("确认初始化列宽？",function(){
			jQuery.ajax({
				type: "POST",
				dataType:"json",
				url: "/formmode/setup/customSearchActionForFront.jsp",
				data: "action=cleanColWidthByUser&customid="+customid,
				success: function(data){
					if(data.status==1){
						 window.location.href=window.location.href;
					}
				}
			});
		});
		
	}
	
	//只能输入数字
	function ItemCount_KeyPress(){
		var evt = getEvent();
	    var keyCode = evt.which ? evt.which : evt.keyCode;
		if(!(((keyCode>=48) && (keyCode<=57))|| keyCode==45)){
			return false;
		}
	}
	
	//日期选择
	function getCommonDate(inputname,spanname){
		var oncleaingFun = function(){
			$ele4p(spanname).innerHTML = '';
			$ele4p(inputname).value = '';
			var obj = jQuery("[name='"+inputname+"']");
			validateValChange(obj,3,2);
		}
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$(inputname).value = returnvalue;
			var obj = jQuery("[name='"+inputname+"']");
			validateValChange(obj,3,2);
			},oncleared:oncleaingFun});
	}
	
	//时间选择
	function getCommonTime(inputname,spanname){
		onWorkFlowShowTime(spanname, inputname, 0,function(){
			var obj = jQuery("[name='"+inputname+"']");
			validateValChange(obj,3,19)
		});
	}
	
	//打开browser框链接信息
	function openBrowserLinkUrl(linkUrl){
		openFullWindowForXtable(linkUrl);
	}
	
	//自定义单选、自定义多选、自定义树形单选、自定义树形多选，选择数据后给显示名称添加链接地址
	function commonBrowserCallbackFun(event,datas,name,cbParam){
		if(wuiUtil.isNullOrEmpty(datas)) return ;
		var ids = wuiUtil.getJsonValueByIndex(datas,0);
		if(ids == '' ){
			$G(name + 'span').innerHTML = '';
			$G(name).value = '';
		}else{
			var names = wuiUtil.getJsonValueByIndex(datas,1);
			var descs = wuiUtil.getJsonValueByIndex(datas,2);
			var href = wuiUtil.getJsonValueByIndex(datas,3);
			var paramObj = eval('(' + cbParam + ')');
			var fieldtype = paramObj.fieldtype;
			if (fieldtype == 161) {
				var hiddenid = $G(name).value;
				if(wuiUtil.isNullOrEmpty(href) && (","+hiddenid+",").indexOf(","+ids+",")!=-1){
					return;
				}
				if(href && href!=''){
					href = href+ids;
				}else{
					href = '';
				}
				var hrefstr='';
				if(href!=''){
					hrefstr=" href='"+href+"' target='_blank' ";
				}
				var sHtml = "<a "+hrefstr+"  title='" + names + "'>" + names + "</a>";
				sHtml = wrapshowhtml(sHtml,ids,1);
				$G(name+'span').innerHTML = sHtml;
				$G(name).value = ids;
			}else if(fieldtype == 162){
				if(ids.indexOf(",")==-1){
					var hiddenid = $G(name).value;
					if((","+hiddenid+",").indexOf(","+ids+",")!=-1){
						return;
					}
				}
				var sHtml = '';
				var idArray = ids.split(',');
				var curnameArray = names.split("~~WEAVERSplitFlag~~");
				if(curnameArray.length < idArray.length){
					curnameArray = names.split(",");
				}
				var curdescArray = descs.split(',');
				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					if(curdesc==''||curdesc=='undefined'||curdesc==null){
						curdesc = curname;
					}
					if(curdesc){
						curdesc = curname;
					}
					var showname = "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
					sHtml +=  wrapshowhtml(showname,curid,1);
				}
				$G(name + 'span').innerHTML = sHtml;
				$G(name).value = doReturnSpanHtml(ids);
			}else if (fieldtype == 256||fieldtype==257) {
	    		var idArray = ids.split(",");
	    		var nameArray = names.split(",");
	    		var sHtml = "";
	    		for (var _i=0; _i<idArray.length; _i++) {
					var curid = idArray[_i];
					var curname = nameArray[_i];
					sHtml += wrapshowhtml( curname + "&nbsp", curid,1);
				}
				$G(name + 'span').innerHTML = sHtml;
				$G(name).value = doReturnSpanHtml(ids);
			}
			jQuery("span[name='"+name+"span']").find(".e8_showNameClass").each(function(){
				hoverShowNameSpan(this);
			});
		}
	}
	
	function doReturnSpanHtml(obj){
		var t_x = obj.substring(0, 1);
		if(t_x == ','){
			t_x = obj.substring(1, obj.length);
		}else{
			t_x = obj;
		}
		return t_x;
	}
	
	//批量修改按钮事件
	function doBatchEdit(){
		if(!hasSetMaintableEditable){
			Dialog.alert("查询列表字段定义中批量修改没有勾选，请联系管理员处理！","",360);
			return ;
		}
		if(!fromgroup){
			var url = location.href+"&viewtype=2";
			location.href = url;
		}else{
			var url = parent.location.href+"&viewtype=2";
			parent.location.href = url;
		}
	}
	
	//批量保存按钮事件
	function batchEditSave(){
		var table=jQuery("#_xTable");
		if(table.find(".valChangeImg").size()==0){
			Dialog.alert("当前页面未做修改，不需要保存！");
		}else{
			var mRowsObject = fillModifiedRows();
			var mRows = JSON.stringify(mRowsObject);
			jQuery("#modifiedRows").html(mRows);
			table.find(".promptValidateFail").removeClass("promptValidateFail");
			var language=readCookie("languageidweaver");
			var loadText = SystemEnv.getHtmlNoteName(3403,language);
			e8showAjaxTips(loadText,true,"xTable_message");
			jQuery("#e8showAjaxTip").css("position","fixed");
			document.batcheditForm.submit();
		}
	}
	
	function fillModifiedRows(){
		var table=jQuery("#_xTable");
		var mRowsObject = {};
		table.find(".valChangeImg").each(function(){
			var $this = jQuery(this);
			var elname = $this.attr("elname");
			var $tr = $this.closest("tr");
			var $el = $tr.find("[name='"+elname+"']");
			var value = $el.val();
			var oval = $el.attr("oval");
			var elnameA = elname.split("_");
			var pluginname = elnameA[0];
			var rowindex = elnameA[1];
			var mainid = "";
			var detailid = "";
			if(hasSetMaintableEditable){
				mainid = $tr.find("input[name='pluginNameid_"+rowindex+"']").val();
			}
			if(hasSetDetailtableEditable){
				detailid = $tr.find("input[name='pluginNamed_id_"+rowindex+"']").val();
			}
			var field = {"pluginname":pluginname,"value":value,"oval":oval};
			var mRows = mRowsObject.mrows;
			if(!!mRows){
				var rowIndex = "row"+rowindex;
				var row = mRows[rowIndex];
				if(!!row){
					var fields = row.fields;
					fields.push(field);
				}else{
					var fields = [field];
					row = {"mainid":mainid,"detailid":detailid,"fields":fields};
					mRows[rowIndex] = row;
				}
			}else{
				var rowIndex = "row"+rowindex;
				var fields = [field];
				var row = {"mainid":mainid,"detailid":detailid,"fields":fields};
				mRows = {};
				mRows[rowIndex] = row;
				mRowsObject.mrows = mRows;
			}
		})
		return mRowsObject;
	}
	
	//批量保存完成后提示事件
	function batchEditCallbak(resultJson,dialogW,dialogH){
		var table=jQuery("#_xTable");
		e8showAjaxTips("",false);
		var resultStatus = resultJson.resultStatus;
		var resultMessage = resultJson.resultMessage
		if(resultStatus=="0"){
			window.top.Dialog.confirm(resultMessage,batchEditSuccessFunOK,batchEditGoBack);
			var _DialogBGDivWidth = jQuery("#_DialogBGDiv").width();
			var splitPageContinerWidth = jQuery("#splitPageContiner").width();
			if(_DialogBGDivWidth<splitPageContinerWidth){
				jQuery("#_DialogBGDiv").width(splitPageContinerWidth);
			}
		}else{
			var promptFieldsValidateFail = resultJson.promptFieldsValidateFail;
			var promptFieldsValidateFailArr = promptFieldsValidateFail.split(",");
			for(var i=0;i<promptFieldsValidateFailArr.length;i++){
				var pluginName = promptFieldsValidateFailArr[i];
				table.find("[name='"+pluginName+"']").closest("td").addClass("promptValidateFail");
			}
			window.top.Dialog.alert(resultMessage,"",dialogW,dialogH);
		}
	}
	
	function batchEditSuccessFunOK(){
		_table.reLoad();
	}
	
	//批量修改页面中返回按钮事件
	function batchEditGoBack(){
		if(!fromgroup){
			var url = location.href;
			url = removeParameter(url,"viewtype=");
			location.href = url;
		}else{
			var url = parent.location.href;
			url = removeParameter(url,"viewtype=");
			parent.location.href = url;
		}
	}
	
	function removeParameter(str,param) {
		eval("var re = /(^\\?|&)"+param+"[^&]*(&)?/g;")
	    return str.replace(re, function(p0, p1, p2) {
	        return p1 === '?' || p2 ? p1 : '';
	    });
	}
	
	function validateValChange(obj,fieldhtmltype,type){
		var oVal = jQuery(obj).attr("oval");
		var nVal = jQuery(obj).val();
		var name = jQuery(obj).attr("name");
		if(fieldhtmltype==3 && name.endWith("__")){
			return;
		}
		var tdCell = jQuery(obj).closest("td");
		var valChangeImg = tdCell.find(".valChangeImg");
		var valChangeSpan=jQuery("<span style='margin-left:2px;color:red;font-size:16px;font-weight:bold;vertical-align:middle;' class='valChangeImg' elname='"+name+"'>*</span>");
		var valChange = false;
		if(fieldhtmltype==1){
			if(type==1){
				if(nVal!=oVal){
					valChange = true;
				}
			}else{
				if(type==5){
					oVal = oVal.replace(/,/g,"")
				}
				var oValNum = Number(oVal);
				var nValNum = Number(nVal);
				if(nValNum-oValNum!=0){
					valChange = true;
				}
				if(oVal == ""){
				   if(nValNum-oValNum == 0){
				      valChange = true;
				   }
				}
				if(oVal == 0){
				   if(nVal == ""){
				      valChange = true;
				   }
				}
			}
		}else if(fieldhtmltype==4){
			var isChecked = jQuery(obj).is(":checked");
			nVal = isChecked ? "1" : "0";
			if(nVal!=oVal){
				valChange = true;
			}
		}else if(fieldhtmltype==5 || fieldhtmltype==3){
			if(nVal!=oVal){
				valChange = true;
			}
		}else if(fieldhtmltype==2 && type==1){
			if(nVal!=oVal){
				valChange = true;
			}
		}
		
		if(valChange){
			if(valChangeImg.size()==0){
				tdCell.append(valChangeSpan);
			}else if(valChangeImg){
				valChangeImg.show();
			}
		}else{
			if(valChangeImg.size()>0){
				valChangeImg.hide();
			}
		}
	}
	
	String.prototype.endWith=function(str){
		var reg=new RegExp(str+"$");
		return reg.test(this);
	}
	
	function jumpToAroundFun(invocation){
		var table=jQuery("#_xTable");
		if(table.find(".valChangeImg").size()>0){
			Dialog.confirm("当前页面数据有修改，是否需要保存？点击【确认】保存当前页，点击【取消】直接跳转！",batchEditSave,function(){
				invocation.proceed();
			});
		}else{
			invocation.proceed();
		}
	}
	
	function changeEmptyTRMessage(){
		jQuery("#_xTable").find(".e8EmptyTR:visible").children("td").html("没有可以编辑的数据");
	}
	
	return{
		cleanColWidth:function(){
			return cleanColWidth();
		}
		,ItemCount_KeyPress:function(){
			return ItemCount_KeyPress();
		}
		,getCommonDate:function(inputname,spanname){
			return getCommonDate(inputname,spanname);
		}
		,getCommonTime:function(inputname,spanname){
			return getCommonTime(inputname,spanname);
		}
		,openBrowserLinkUrl:function(linkUrl){
			return openBrowserLinkUrl(linkUrl);
		}
		,commonBrowserCallbackFun:function(event,datas,name,cbParam){
			return commonBrowserCallbackFun(event,datas,name,cbParam);
		}
		,doBatchEdit:function(){
			return doBatchEdit();
		}
		,batchEditSave:function(){
			return batchEditSave();
		}
		,batchEditCallbak:function(resultJson,dialogW,dialogH){
			return batchEditCallbak(resultJson,dialogW,dialogH);
		}
		,batchEditGoBack:function(){
			return batchEditGoBack();
		}
		,validateValChange:function(obj,fieldhtmltype,type){
			return validateValChange(obj,fieldhtmltype,type);
		}
		,jumpToAroundFun:function(invocation){
			return jumpToAroundFun(invocation);
		}
		,changeEmptyTRMessage:function(){
			return changeEmptyTRMessage();
		}
	}
})();