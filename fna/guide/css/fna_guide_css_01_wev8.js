jQuery(document).ready(function(){
	jQuery("#formName,#wfName").bind("keypress", function(){
		var key = event.keyCode;
		if(key==13){
			return false;
		}
	});
	resizeDialog(document);
});

//保存表单
function fnaWfCreat_doSave(){
	var formName = null2String(jQuery("#formName").val());
	var subcompanyid = null2String(jQuery("#subcompanyid").val());
	var isFnaFeeDtl = null2String(jQuery("#isFnaFeeDtl").val());
	var enableRepayment = jQuery("#enableRepayment").attr("checked")?1:0;
	if(formName==""){
		top.Dialog.alert(_getHtmlLabelName30702);
		return;
	}
	if(jQuery("#subcompanyid").length==1 && subcompanyid==""){
		top.Dialog.alert(_getHtmlLabelName30702);
		return;
	}
	try{
		var _data = "operation=fnaWfCreat_doSave&creatType="+_creatType+"&formName="+formName+"&subcompanyid="+subcompanyid+
			"&isFnaFeeDtl="+isFnaFeeDtl+"&enableRepayment="+enableRepayment;
		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/guide/FnaWfCreatOp.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
			    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
			    	doRefreshParentGrid();
					if(_json.flag){
						window.location.href = "/fna/guide/FnaWfEditForm.jsp?fnaFeeWfInfoId="+_json.fnaFeeWfInfoId+"&formid="+_json.formid+
							"&subcompanyid="+_json.subcompanyid+"&creatType="+_creatType+
							"&isFnaFeeDtl="+isFnaFeeDtl+"&enableRepayment="+enableRepayment+"&subcompanyid="+subcompanyid;
					}else{
						top.Dialog.alert(_json.msg);
					}
			    }catch(e1){
			    }
			}
		});	
	}catch(e1){
		showRightMenuIframe();
	}
}

//打开表单编辑页面
function openEditForm(formid, titleName){
	var _w = 1046;
	var _h = 612;
	_fnaOpenDialog("/workflow/form/addDefineForm.jsp?formid="+formid+"&dialog=1", 
			titleName, 
			_w, _h);
}

//保存流程
function fnaWfCreatWf_doSave(fnaFeeWfInfoId, formid, isFnaFeeDtl, enableRepayment){
	var wfName = null2String(jQuery("#wfName").val());
	var wfTypeid = null2String(jQuery("#wfTypeid").val());
	var subcompanyid = null2String(jQuery("#subcompanyid").val());
	if(wfName=="" || wfTypeid==""){
		top.Dialog.alert(_getHtmlLabelName30702);
		return;
	}
	if(jQuery("#subcompanyid").length==1 && subcompanyid==""){
		top.Dialog.alert(_getHtmlLabelName30702);
		return;
	}
	try{
		var _data = "operation=fnaWfCreatWf_doSave&creatType="+_creatType+"&fnaFeeWfInfoId="+fnaFeeWfInfoId+"&formid="+formid+
			"&wfName="+wfName+"&wfTypeid="+wfTypeid+"&isFnaFeeDtl="+isFnaFeeDtl+"&enableRepayment="+enableRepayment+"&subcompanyid="+subcompanyid;
		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/guide/FnaWfCreatOp.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
			    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
			    	doRefreshParentGrid();
					if(_json.flag){
						window.location.href = "/fna/guide/FnaWfEditWf.jsp?fnaFeeWfInfoId="+_json.fnaFeeWfInfoId+"&formid="+_json.formid+
							"&wfid="+_json.wfid+"&creatType="+_creatType+
							"&isFnaFeeDtl="+isFnaFeeDtl+"&enableRepayment="+enableRepayment+"&subcompanyid="+subcompanyid;
					}else{
						top.Dialog.alert(_json.msg);
					}
			    }catch(e1){
			    }
			}
		});	
	}catch(e1){
		showRightMenuIframe();
	}
}

//打开流程编辑页面
function openEditWf(wfid, titleName){
	var _w = 1046;
	var _h = 612;
	_fnaOpenDialog("/workflow/workflow/addwf.jsp?src=editwf&wfid="+wfid+"&isTemplate=0", 
			titleName, 
			_w, _h);
}

//打开费用相关流程编辑页面
function openEditFnaFeeWfInfo(openUrl, titleName){
	var _w = 1046;
	var _h = 612;
	_fnaOpenDialog(openUrl, 
			titleName, 
			_w, _h);
}

function doRefresh(){
	window.location.href = window.location.href;
}

function goToUrl(_url){
	doRefreshParentGrid();
	window.location.href = _url;
}

function doRefreshGrid(){
	try{_table.reLoad();}catch(ex1){}
}

function doRefreshParentGrid(){
	try{
		var dialog = parent.getDialog(window);
		dialog.currentWindow._table.reLoad();
	}catch(ex1){}
}

function workflowid_callback(){
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

function onCancel(){
	doRefreshParentGrid();
	var dialog = parent.getDialog(window);	
	dialog.close();
}

//关闭
function doClose(){
	onCancel();
}