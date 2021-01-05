
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>

<%@ page import="weaver.workflow.browserdatadefinition.Condition" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
	</HEAD>
	<BODY style='overflow-x: hidden'>
<%!
public static Map<String, String> getParameterMap(HttpServletRequest request) {
	Map m = request.getParameterMap();
	Set keyset = request.getParameterMap().keySet();
    Map<String, String> returnMap = new HashMap<String, String>();
    String value = "";
    for (Object key : keyset) {
        Object valueObj = m.get(key);
        String name = (String) key;
        if (null == valueObj) {
            value = "";
        } else if (valueObj instanceof String[]) {
            String[] values = (String[])valueObj;
            for (int i = 0; i < values.length; i++){
                value = values[i] + ",";
            }
            value = value.substring(0, value.length()-1);
        } else {
            value = valueObj.toString();
        }
        returnMap.put(name, value);
    }
    return returnMap;
}
%>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(32752,user.getLanguage());
	String needfav = "1";
	String needhelp = "";

	String workflowId = request.getAttribute("wfid").toString();
	String fieldId = request.getAttribute("fieldId").toString();
	String fieldType = request.getAttribute("type").toString();
	String viewType = request.getAttribute("viewType").toString();
	String isBill = request.getAttribute("isBill").toString();
    String formId = request.getAttribute("formId").toString();

    Condition condition = Condition.read(workflowId, fieldId, viewType, fieldType);
    String title = condition.getTitle();

    String optionmethod = Util.null2String(request.getParameter("optionmethod"));
    boolean hasChangeData = false;
    if ("add".equals(optionmethod)) {
    	Map<String, String> params = getParameterMap(request);
    	params.put("workflowId", workflowId);
    	params.put("fieldId", fieldId);
    	params.put("fieldType", fieldType);
    	params.put("viewType", viewType);
    	params.put("isBill", isBill);
    	params.put("formId", formId);
    	condition.saveOrUpdate(params);
    	hasChangeData = true;
    } else if ("del".equals(optionmethod)) {
    	Map<String, String> params = new HashMap<String, String>();
    	params.put("workflowId", workflowId);
    	params.put("fieldId", fieldId);
    	params.put("fieldType", fieldType);
    	params.put("viewType", viewType);
    	params.put("isBill", isBill);
    	params.put("formId", formId);
    	condition.remove(params);
    	hasChangeData = true;
    }
%>

<!-- start -->
<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="workflow" />
	<jsp:param name="navName" value="<%=titlename%>" />
</jsp:include>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:btnok_onclick(),_self}";
	RCMenuHeight += RCMenuHeightStep;

	RCMenu += "{"
			+ SystemEnv.getHtmlLabelName(2022, user.getLanguage())
			+ ",javascript:btncz_onclick(),_self} ";
	RCMenuHeight += RCMenuHeightStep;

	RCMenu += "{"
			+ SystemEnv.getHtmlLabelName(23777, user.getLanguage())
			+ ",javascript:btnsc_onclick(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align: right;">
			<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>" onClick="btnok_onclick();" />
			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%>" onClick="btncz_onclick();" />
			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage())%>" onClick="btnsc_onclick();" />
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="mainDiv">
	<FORM id=frmMain name=frmMain action=RequestBrowserfunction.jsp method=post>
		<wea:layout type="4col" attributes="{expandAllGroup:true}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></wea:item>
				<wea:item>
					<input name="title" id="title" class="Inputstyle" maxlength="100" value="<%=Util.toScreenForWorkflowReadOnly(title)%>" onchange="onTitleChanged(this);" />
					<span id="titleSpan" <%if (title != null && !title.isEmpty()) {%>style="display:none;"<%}%>>
						<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
					</span>
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelNames("149,20331", user.getLanguage())%>'>
				<wea:item attributes="{'colspan':'full','isTableList':'true'}">

					<input type="hidden" name="wfid" value="<%=workflowId%>">
					<input type="hidden" name="fieldid" value="<%=fieldId%>">
					<input type="hidden" name="type" value="<%=fieldType%>">
					<input type="hidden" name="viewtype" value="<%=viewType%>">
					<input type="hidden" name="optionmethod" id="optionmethod" value="">

					<table id="mainTable" class="ListStyle" cellspacing="0" style="table-layout: fixed;">
						<col width="15%">
						<col width="50%">
						<col width="15%">
						<col width="10%">
						<col width="10%">
						<thead>
							<tr class="HeaderForXtalbe"> 
							    <th colspan=2><%=SystemEnv.getHtmlLabelNames("15364,33508", user.getLanguage())%></th>
							    <th><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></th>
							    <th><input id="allHide" type="checkbox" onclick="onAllHideClick(this);" />&nbsp;<%=SystemEnv.getHtmlLabelName(16636, user.getLanguage())%></th>
							    <th><input id="allReadonly" type="checkbox" onclick="onAllReadonlyClick(this);" />&nbsp;<%=SystemEnv.getHtmlLabelName(17873, user.getLanguage())%></th>
							</tr>
						</thead>
						<tbody>
							<%
								request.setAttribute("bdfUser", user);
								for (ConditionField field : condition.getFields()) {
									request.setAttribute("bdfField", field);
									String showOrderIdOrName = field.getConfig().getFieldSign() + "ShowOrder";
									String hideIdOrName = field.getConfig().getFieldSign() + "Hide";
									String readonlyIdOrName = field.getConfig().getFieldSign() + "Readonly";
							%>
								<TR>
								<TD><%=field.getConfig().getShowName(user.getLanguage())%></TD>
								<TD>
									<jsp:include page="<%=field.getConfig().getPagePath()%>">
										<jsp:param name="isBill" value="<%=isBill%>" />
										<jsp:param name="formId" value="<%=formId%>" />
									</jsp:include>
								</TD>
								<TD>
									<input class="_showOrder" _defaultShowOrder="<%=field.getConfig().getDefaultShowOrder()%>" onblur="checkPlusnumber2(this)" name="<%=showOrderIdOrName%>" type="text" size=4 value="<%=field.getShowOrder()%>">
								</TD>
								<TD>
									<input class="_hide" name="<%=hideIdOrName%>" <%if(field.isHide()){%> checked <%}%> type="checkbox" value="1" onclick="onHideClick(this);" />
								</TD>
								<TD>
									<input class="_readonly" name="<%=readonlyIdOrName%>" <%if(field.isReadonly()){%> checked <%}%> type="checkbox" value="1" onclick="onReadonlyClick(this);" />
								</TD>
							</TR>
							<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
							<%
								}
								request.removeAttribute("bdfField");
								request.removeAttribute("bdfUser");
							%>
						</tbody>
					</table>
				</wea:item>
			</wea:group>
		</wea:layout>
	</FORM>
</div>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>" class="zd_btn_cancle" onclick="dialog.closeByHand();" style="width: 50px!important;">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
<!-- end -->

<script type="text/javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try {
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
} catch(e) {}

function submitData() {
	if (dialog) {
		dialog.callback();
	} else {
		window.parent.parent.close();
	}
}

<%if (hasChangeData) {%>
	submitData();
<%}%>

function onTitleChanged(ele) {
	var title = jQuery(ele).val();
	title = jQuery.trim(title);
	if (title == '') {
		jQuery('#frmMain #titleSpan').show();
	} else {
		jQuery('#frmMain #titleSpan').hide();
	}
	jQuery(ele).val(title);
}

jQuery(function() {
	changeAllHideStatus();
	changeReadonlyEnableStatus();
	changeAllReadonlyStatus();
	resizeDialog(document);
});

function checkPlusnumber2(obj) {
	var value = obj.value;
	var reg =/^\d{0,3}(\.\d{0,2})?$/g;
	if (!reg.test(value)){
	   obj.value = jQuery(obj).attr('_defaultShowOrder');
	}
}

function onAllHideClick(ele) {
	if (jQuery(ele).is(':checked')) {
		changeCheckboxStatus('#mainTable input[type="checkbox"]._hide', true);
	} else {
		changeCheckboxStatus('#mainTable input[type="checkbox"]._hide', false);
	}
	changeReadonlyEnableStatus();
	changeAllReadonlyStatus();
}

function onHideClick(ele) {
	changeAllHideStatus();
	changeReadonlyEnableStatus();
	changeAllReadonlyStatus();
}

function changeAllHideStatus() {
	changeCheckboxStatus('#mainTable #allHide', jQuery('#mainTable input[type="checkbox"]._hide:checked').length == jQuery('#mainTable input[type="checkbox"]._hide').length);
}

function onAllReadonlyClick(ele) {
	if (jQuery(ele).is(':checked')) {
		changeCheckboxStatus('#mainTable input[type="checkbox"]._readonly:enabled', true);
	} else {
		changeCheckboxStatus('#mainTable input[type="checkbox"]._readonly', false);
	}
}

function onReadonlyClick(ele) {
	changeAllReadonlyStatus();
}

function changeAllReadonlyStatus() {
	changeCheckboxStatus('#mainTable #allReadonly', jQuery('#mainTable input[type="checkbox"]._readonly:checked').length == jQuery('#mainTable input[type="checkbox"]._readonly:enabled').length);
}

function changeReadonlyEnableStatus() {
	var notHideTrs = jQuery('#mainTable input[type="checkbox"]._hide:not(:checked)').closest('tr');
	var readonlys = jQuery(notHideTrs).find('input[type="checkbox"]._readonly');
	disOrEnableCheckbox(readonlys, false);
	var hideTrs = jQuery('#mainTable input[type="checkbox"]._hide:checked').closest('tr');
	readonlys = jQuery(hideTrs).find('input[type="checkbox"]._readonly');
	disOrEnableCheckbox(readonlys, true);
	changeCheckboxStatus(readonlys, false);
}

function checkDataValid() {
	var requiredInputs = jQuery('input:hidden[ismustinput="2"]');
	for (var i = 0; i < requiredInputs.length; i++) {
		var browserInput = jQuery(requiredInputs[i]);
		var browserSpan = jQuery('span#' + browserInput.attr('name') + 'Span');
		if ((browserSpan.is(':visible') || browserSpan.css('display') != 'none') && browserInput.val() == '') {
			return false;
		}
	}
	return true;
}

function btnok_onclick() {
	var title = jQuery("#title").val();
	title = jQuery.trim(title);
	if (title == '') {
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("84,18622", user.getLanguage())%>');
		return;
	} else {
		if (checkDataValid()) {
			jQuery("#optionmethod").val("add");
			document.frmMain.submit();
		} else {
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("30933", user.getLanguage())%>');
			return;
		}
	}
}

function btncz_onclick() {
	jQuery('#title').val('');
	jQuery('#frmMain #titleSpan').show();
	jQuery('#mainTable input[type="text"]._showOrder').each(function() {
		jQuery(this).val(jQuery(this).attr('_defaultShowOrder'));
	});
	changeCheckboxStatus('#mainTable input[type="checkbox"]._hide', false);
	changeCheckboxStatus('#mainTable #allHide', false);
	disOrEnableCheckbox('#mainTable input[type="checkbox"]._readonly', false);
	changeCheckboxStatus('#mainTable input[type="checkbox"]._readonly', false);
	changeCheckboxStatus('#mainTable #allReadonly', false);
	jQuery('#mainTable button._reset').click();
	jQuery('#title').focus();
}

function btnsc_onclick() {
	top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("17048", user.getLanguage())%>', function() {
		jQuery("#optionmethod").val("del");
		document.frmMain.submit();
	});
}

function selectBrowser_selectChanged(fieldSign) {
	var selectOption = jQuery('#' + fieldSign + 'ValueType').find('option:selected');
	var browserUrl = selectOption.attr('_browserurl');
	if (!!browserUrl) {
		var isSingleBrowser = selectOption.attr('_issinglebrowser');
		if (jQuery('#' + fieldSign).attr('issingle') == isSingleBrowser) {
			_writeBackData(fieldSign, 2, {id:'',name:''});
		} else {
			var eleSpan = jQuery('#' + fieldSign + 'Span').empty();
			var oDiv = document.createElement("div");
			eleSpan.append(oDiv);
			jQuery(oDiv).e8Browser({
					name: fieldSign,
					viewType: '0',
					isMustInput: '2',
					getBrowserUrlFn: 'getSelectBrowserUrl',
					getBrowserUrlFnParams: fieldSign,
					hasInput: true,
					isSingle: (isSingleBrowser == 'true' ? true : false),
					completeUrl: 'javascript:getCompleteUrl("'+fieldSign+'")',
					hasAdd: false,
					width: '200px'
			});
		}
		jQuery('#' + fieldSign + 'Span').css('display', '');
	} else {
		_writeBackData(fieldSign, 2, {id:'',name:''});
		jQuery('#' + fieldSign + 'Span').css('display', 'none');
	}
}

function getSelectBrowserUrl(fieldSign) {
	return jQuery('#' + fieldSign + 'ValueType').find('option:selected').attr('_browserurl');
}

function showSelectConfigWindow(configId, fieldSign) {
	var url = '/systeminfo/BrowserMain.jsp?url=/workflow/browserdatadefinition/RequestBrowserfunction_select_config.jsp';
	var param = '?configId=' + configId + '&canSelectValues=' + jQuery('#' + fieldSign + 'CanSelectValues').val() + '&defaultValue=' + jQuery('#' + fieldSign).val();
	var callback = function(data) {
		jQuery('#' + fieldSign + 'CanSelectValues').val(data.id);
		jQuery('#' + fieldSign + 'Span').html(data.name);
		jQuery('#' + fieldSign).val(data.defaultId);
	};
	onShowCommonDialogWindow(null, null, url, param, null, null, null, callback);
}

function getTheStartDate(inputname,spanname,inputname2,spanname2) {
	WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
		$dp.$(inputname).value = returnvalue;
		  onShowBeginDate2(returnvalue,inputname,spanname,inputname2,spanname2);
		}
		,oncleared:function(dp){
		  $dp.$(inputname).value = ''
		}});
}

function getTheendDate(inputname,spanname,inputname2,spanname2) {
	WdatePicker({lang:languageStr,el:spanname2,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
		$dp.$(inputname2).value = returnvalue;
		  onShowBeginDate2(returnvalue,inputname,spanname,inputname2,spanname2);
		}
		,oncleared:function(dp){
		 $dp.$(inputname).value = ''
		}});
}

function onShowBeginDate2(returnvalue,inputname,spanname,inputname2,spanname2) {
	var date1=jQuery("#"+inputname).val();
	var date2=jQuery("#"+inputname2).val();
	if(date2!=''){
		if(date1>date2){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721, user.getLanguage())%>");
			jQuery("#"+inputname).val("");
			jQuery("#"+inputname2).val("");
			$G(spanname).innerHTML = "";
			$G(spanname2).innerHTML = "";
		}
	}
}

function onDateSelectChange(fieldSign) {
	var dateType = jQuery('#' + fieldSign + 'ValueType').val();
	if (dateType == '8') {
		jQuery('#' + fieldSign + 'DateSpan').hide();
		jQuery('#' + fieldSign + 'Span').show();
	} else if(dateType == '6') {
		jQuery('#' + fieldSign + 'Span').hide();
		jQuery('#' + fieldSign + 'DateSpan').show();
	} else {
		jQuery('#' + fieldSign + 'Span').hide();
		jQuery('#' + fieldSign + 'DateSpan').hide();
    }
}

function setSelectBoxValue(selector, value) {
	if (selector == null) {
		return;
	}
	if (typeof(selector) == 'string') {
		var reg = /^#mainTable/gi;
		if (!reg.test(selector)) {
			selector = '#mainTable ' + selector;
		}
	}
	if (value == null) {
		value = jQuery(selector).find('option').first().val();
	}
	jQuery(selector).selectbox('change', value, jQuery(selector).find('option[value="'+value+'"]').text());
}

function getCompleteUrl(fieldSign) {
	return jQuery('#' + fieldSign + 'ValueType').find('option:selected').attr('_completeurl');
}
</script>
<jsp:include page="/workflow/workflow/WorkflowUtil.jsp"></jsp:include>
</BODY>
</HTML>
