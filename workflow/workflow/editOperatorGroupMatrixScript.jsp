
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*" %>

<%
	User user = HrmUserVarify.getUser (request , response); 
	String wfid = Util.null2String(request.getParameter("wfid"));
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
%>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript">
//matrix start
function selectAllMatrixRow(checked) {
	changeCheckboxStatus('#matrixTable tr.data td input:checkbox', checked);
}

function changeSelectAllMatrixRowStatus(checked) {
	changeCheckboxStatus('#matrixTable tr.header td input:checkbox', checked);
}

function checkMatrix() {
	var indexinsert =0;
	//var matrix = jQuery('#matrix').val();
	//var vf = jQuery('#vf').val();
	var matrix = jQuery('#matrixTmp').val();
	var vf = jQuery('#matrixTmpfield').val();
	// alert("-2-matrix--"+cf);
	 // alert("-2-vf--"+cf);
	if (vf == null || matrix == '' || vf == '') {
		return false;
	}
	var ret = true;
	var matrixTableRows = jQuery('#matrixTable tr.data');
	/*matrixTableRows.each(function() {
		var cf = jQuery('[id^=matrixCfield]').val();
		var wf = jQuery('[id^=matrixRulefield]').val();
		if (cf == '' || wf == '') {
			ret = false;
		}
		if (cf == 0 || wf == null) {
			ret = false;
		}
	});*/
	var existsMatrixTableRows = false;
	for(indexinsert=0;indexinsert<(matrixTableRows.length+10);indexinsert++){
		//alert("-43--indexinsert-"+indexinsert);
	//alert("-44--matrixTableRows.length-"+matrixTableRows.length);
		// alert("-EEEEE--indexinsert->>"+indexinsert"---asadas---->>>"+jQuery('#matrixCfield_'+indexinsert));
		
	  var cf = jQuery('#matrixCfield_'+indexinsert).val();
	  var wf = jQuery('#matrixRulefield_'+indexinsert).val();
	 if(typeof(cf) == "undefined" || typeof(wf) == "undefined") {
		   	  continue;
		   }
		   existsMatrixTableRows = true;
	 	if (cf == '' || wf == '') {
			ret = false;
		}
		if (cf == 0 || wf == null || cf == null || wf == 0) {
			//alert("-56--cf-"+cf);
		   //alert("-56--wf-"+wf);
			ret = false;
		}
	}
	if(!existsMatrixTableRows){
		ret = false;
	}
	  
	return ret;
}

function getMatrixBrowserUrl(fieldtype) {
	var matrix = jQuery('#matrix').val();
	if (matrix) {
		return '/systeminfo/BrowserMain.jsp?url=/matrixmanage/pages/matrixfieldbrowser.jsp?matrixid=' + matrix + '&fieldtype=' + fieldtype;
	} else {
		Dialog.alert('<%=SystemEnv.getHtmlLabelName(129434, user.getLanguage())%>');
		return '';
	}
}

function addMatrixRow() {
	var lastRow = jQuery('<tr class="data"><td style="padding-left: 30px !important;"><input type="checkbox" /></td><td><div class="cf"><span></span></div></td><td><div class="wf"><span></span></div></td><td></td></tr>');
	var lineRow = jQuery('<tr class="Spacing" style="height:1px!important;display:;"><td class="paddingLeft0" colspan="4"><div class="intervalDivClass"></div></td></tr>');
	var matrixTable = jQuery('#matrixTable');
	matrixTable.append(lastRow);
	matrixTable.append(lineRow);
	lastRow.jNice();
	lastRow.find('div.cf span').e8Browser({
	   name: 'cf',
	   viewType:"0",
	   hasInput:true,
	   isSingle:true,
	   hasBrowser:true, 
	   isMustInput:1,
	   completeUrl:"javascript:getMatrixDataUrl(0);",
	   getBrowserUrlFn: "getMatrixBrowserUrl",
	   getBrowserUrlFnParams: "0"
	});
	lastRow.find('div.wf span').e8Browser({
	   name: 'wf',
	   viewType:"0",
	   hasInput:true,
	   isSingle:true,
	   hasBrowser:true, 
	   isMustInput:1,
	   completeUrl:"/data.jsp?type=fieldBrowser&wfid=<%=wfid%>",
	   getBrowserUrlFn: "getFieldUrl"
	});
	changeSelectAllMatrixRowStatus(false);
}



function removeMatrixRow() {
	jQuery('#matrixTable tr.data input:checked').closest('tr.data').each(function() {
		jQuery(this).next('.Spacing').remove();
		jQuery(this).remove();
	});
	changeSelectAllMatrixRowStatus(false);
}

/*function getMatrixValue() {
	var matrixTableRows = jQuery('#matrixTable tr.data');
	//去除重复值

	var matrixTableValueObj = {};
	matrixTableRows.each(function() {
		var cf = jQuery(this).find('input[name="cf"]').val();
		var wf = jQuery(this).find('input[name="wf"]').val();
		matrixTableValueObj[cf] = wf;
	});
	var matrix = jQuery('#matrix').val();
	var vf = jQuery('#vf').val();
	var matrixTableValue = matrix + ',' + vf;
	for (var p in matrixTableValueObj) {
		matrixTableValue += ',' + p + ':' + matrixTableValueObj[p];
	}
	return matrixTableValue;
}*/


function getMatrixValue() {
	var matrixTableRows = jQuery('#matrixTable tr.data');
	var indexinsert =0;
	//去除重复值

	var matrixTableValueObj = {};
	/*matrixTableRows.each(function() {
		//var cf = jQuery(this).find('input[name="cf"]').val();
		//var wf = jQuery(this).find('input[name="wf"]').val();
		var cf = jQuery('#matrixCfield').val();
		var wf = jQuery('#matrixRulefield').val();
		matrixTableValueObj[cf] = wf;
	});*/
	for(indexinsert=0;indexinsert<(matrixTableRows.length+10);indexinsert++){
		// alert("-EEEEE--indexinsert->>"+indexinsert"-------->>>"+jQuery('#matrixCfield_'+indexinsert));
		
	  var cf = jQuery('#matrixCfield_'+indexinsert).val();
	  var wf = jQuery('#matrixRulefield_'+indexinsert).val();
		    if(typeof(cf) == "undefined" || typeof(wf) == "undefined") {
		   	  continue;
		   }
	  matrixTableValueObj[cf] = wf;
	}

	var matrix = jQuery('#matrix').val();
	//var vf = jQuery('#vf').val();
	var vf = 	 jQuery('#matrixTmpfield').val();
	var matrixTableValue = matrix + ',' + vf;
	for (var p in matrixTableValueObj) {
		matrixTableValue += ',' + p + ':' + matrixTableValueObj[p];
	}
	return matrixTableValue;
}

function getFieldUrl() {
	return "/systeminfo/BrowserMain.jsp?url=/workflow/ruleDesign/showFieldBrowser.jsp?formid=<%=formid%>&isbill=<%=isbill%>";
}

function getMatrixDisplayName() {
	var matrixDisplayName = jQuery("#matrixTmp").find("option:selected").text()	;
	var vfDisplayName = jQuery("#matrixTmpfield").find("option:selected").text();
	return getEditMatrixDialogLink(matrixDisplayName+'('+vfDisplayName+')');
}

function getEditMatrixDialogLink(matrixDisplayName) {
	return '<a href="javascript:void(0);" onclick="onShowEditMatrixDialog(this);">'+matrixDisplayName+'</a>';
}

function matrixChanged() {
	_writeBackData('vf', 1, {id:'',name:''});
	jQuery('#matrixTable tr.data #cf').val('');
	jQuery('#matrixTable tr.data #cfspan').html('');
}

function getMatrixDataUrl(fieldtype) {
	var matrix = jQuery('#matrix').val();
	if (matrix) {
		return '/data.jsp?type=matrixfield&matrixid=' + matrix + '&fieldtype=' + fieldtype;
	} else {
		Dialog.alert('<%=SystemEnv.getHtmlLabelName(129434, user.getLanguage())%>');
		return '';
	}
}

function onShowEditMatrixDialog(ele) {
	var editDialog = new top.Dialog();
	editDialog.Width = 600;
	editDialog.Height = 600;
	editDialog.URL = '/systeminfo/BrowserMain.jsp?url=/workflow/workflow/editOperatorGroupMatrix.jsp'+escape('?isdialog=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>&matrixvalue='+jQuery(ele).closest('tr').find('input[name^=group_][name$=_id]').val());
	editDialog.Title = '<%=SystemEnv.getHtmlLabelName(129418, user.getLanguage())%>';
	editDialog.checkDataChange = false;
	editDialog.callback = function(data) {
		editDialog.close();
		var retValue = data;
		if (retValue != null) {
			if (wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
				jQuery(ele).closest('tr	').find('input[name^=group_][name$=_id]').val(wuiUtil.getJsonValueByIndex(retValue, 0));
				jQuery(ele).text(wuiUtil.getJsonValueByIndex(retValue, 1));
			} 
		}
	};
	editDialog.show();
}
//matrix end
</script>