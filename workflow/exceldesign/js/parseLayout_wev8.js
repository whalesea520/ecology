/**
 * liuzy 2016/03/02
 * 模板解析相关的JS方法
 */
 
//高级明细解析相关JS
var detailOperate = (function(){
	
	//新增行操作DOM
	function addRowOperDom(groupid, addRowHtmlStr){
		var oTable = jQuery("table#oTable"+groupid);
		var rowindex = parseInt($G("indexnum"+groupid).value);
		var curindex = parseInt($G("nodesnum"+groupid).value);
		//追加DOM行
		var datarow = oTable.find("tr[_target='datarow']");
		if(datarow.size() > 0)
			datarow.last().after(addRowHtmlStr);
		else
			oTable.find("tr[_target='headrow']").last().after(addRowHtmlStr);
		try{
			//新增行绑定事件，用于明细性能优化
			addRowBindClickEvent(groupid, rowindex);
		}catch(e){}
		//更改隐藏域
		if($G('submitdtlid'+groupid).value == '')
			$G('submitdtlid'+groupid).value = rowindex;
		else
			$G('submitdtlid'+groupid).value += ","+rowindex;
		$G("indexnum"+groupid).value = rowindex + 1;
		$G("nodesnum"+groupid).value = curindex + 1;
	}
	
	//新增行后执行相应JS方法
	function addRowExecFun(groupid, initDetailFields){
		//重新绑定监听对象
		loadListener();
		//字段联动触发
		if(!!initDetailFields){
			try{
				datainputd(initDetailFields);
			}catch(e){}
		}
		//表单设计器，新增行触发公式计算
		triFormula_addRow(groupid);
		try{
			calSum(groupid);
		}catch(e){}
		try{		//自定义函数接口,必须在最后，必须try-catch
			eval("_customAddFun"+groupid+"()");
		}catch(e){}
	}
	
	//删除行方法
	function delRowFun(groupid, isfromsap){
		var oTable = jQuery("table#oTable"+groupid);
		var checkObj = oTable.find("input[name='check_node_"+groupid+"']:checked");
		if(isfromsap || checkObj.size()>0){
			if(isfromsap || isdel()){
				var curindex = parseInt($G("nodesnum"+groupid).value);
				var submitdtlStr = $G("submitdtlid"+groupid).value;
				var deldtlStr = $G("deldtlid"+groupid).value;
				checkObj.each(function(){
					var rowIndex = jQuery(this).val();
					var belRow = oTable.find("tr[_target='datarow'][_rowindex='"+rowIndex+"']");
					var keyid = belRow.find("input[name='dtl_id_"+groupid+"_"+rowIndex+"']").val();
					//提交序号串删除对应行号
					var submitdtlArr = submitdtlStr.split(',');
					submitdtlStr = "";
					for(var i=0; i<submitdtlArr.length; i++){
						if(submitdtlArr[i] != rowIndex)
							submitdtlStr += ","+submitdtlArr[i];
					}
					if(submitdtlStr.length > 0 && submitdtlStr.substring(0,1) === ",")
						submitdtlStr = submitdtlStr.substring(1);
					//已有明细主键存隐藏域
					if(keyid != "")
						deldtlStr += ","+keyid;
					//IE下需先销毁附件上传的object对象，才能remove行
					try{
						belRow.find("td[_fieldid][_fieldtype='6_1'],td[_fieldid][_fieldtype='6_2']").each(function(){
							var swfObj = eval("oUpload"+jQuery(this).attr("_fieldid"));
							swfObj.destroy();
						});
					}catch(e){}
					belRow.remove();
					curindex--;
				});
				$G("submitdtlid"+groupid).value = submitdtlStr;
				if(deldtlStr.length >0 && deldtlStr.substring(0,1) === ",")
					deldtlStr = deldtlStr.substring(1);
				$G("deldtlid"+groupid).value = deldtlStr;
				$G("nodesnum"+groupid).value = curindex;
				//序号重排
				oTable.find("input[name='check_node_"+groupid+"']").each(function(index){
					var belRow = oTable.find("tr[_target='datarow'][_rowindex='"+jQuery(this).val()+"']");
					belRow.find("span[name='detailIndexSpan"+groupid+"']").text(index+1);
				});
				oTable.find("input[name='check_all_record']").attr("checked", false);
				//表单设计器，删除行触发公式计算
				triFormula_delRow(groupid);
				try{
					calSum(groupid);
				}catch(e){}
				try{		//自定义函数接口,必须在最后，必须try-catch
					eval("_customDelFun"+groupid+"()");
				}catch(e){}
			}
		}else{
			var language = readCookie("languageidweaver");
			top.Dialog.alert(SystemEnv.getHtmlNoteName(3529, language));
			return;
		}
	}
	
	//明细全选记录
	function checkAllFun(groupid){
		var oTable = jQuery("table#oTable"+groupid);
		var checkAllObj = oTable.find("input[name='check_all_record']");
		var checkObj = oTable.find("input[type='checkbox'][name='check_node_"+groupid+"']").not(":disabled");
		if(checkObj.length == 0)
			return;
		if(checkObj.first().parent().is("div.detailRowHideArea"))		//隐藏区域(check框未放置在模板上)忽略
			return;
		checkObj.attr("checked", checkAllObj.is(":checked"));
	}
	
	return {
		addRowOperDom: function(groupid, addRowHtmlStr){
			return addRowOperDom(groupid, addRowHtmlStr);
		},
		addRowExecFun: function(groupid, initDetailFields){
			return addRowExecFun(groupid, initDetailFields);
		},
		delRowFun: function(groupid, isfromsap){
			return delRowFun(groupid, isfromsap);
		},
		checkAllFun: function(groupid){
			return checkAllFun(groupid);
		}
	}

})();