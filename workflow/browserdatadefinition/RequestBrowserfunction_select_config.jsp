
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionFieldConfig" %>
<%@ page import="weaver.workflow.browserdatadefinition.SelectItemConfig" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = "选项设定";
	String needfav = "1";
	String needhelp = "";

	String configId = Util.null2String(request.getParameter("configId"));
	String defaultValue = Util.null2String(request.getParameter("defaultValue"));
	List canSelectValues = Util.arrayToArrayList(Util.null2String(request.getParameter("canSelectValues")).split(","));

	ConditionFieldConfig conf = ConditionFieldConfig.read(configId);
	if (canSelectValues == null || canSelectValues.isEmpty()) {
		canSelectValues = conf.getAllSelectItemValueList();
		if (defaultValue.isEmpty()) {
			SelectItemConfig defaultSelectItemConfig = conf.getDefaultSelectItem();
			if (defaultSelectItemConfig != null) {				
				defaultValue = defaultSelectItemConfig.getValue();
			}
		}
	}
%>

<HTML>
	<HEAD>
	</HEAD>
	<BODY style='overflow-x: hidden'>

	<!-- start -->
	<jsp:include page="/systeminfo/commonTabHead.jsp">
		<jsp:param name="mouldID" value="workflow" />
		<jsp:param name="navName" value="<%=titlename%>" />
	</jsp:include>

	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:btnok_onclick(),_self}";
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
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>

	<table id="mainTable" class="ListStyle" cellspacing="0" style="table-layout: fixed;">
		<col width="10%">
		<col width="45%">
		<col width="45%">
		<thead>
			<tr class="HeaderForXtalbe"> 
			    <th style="display:none;">value</th>
			    <th><input class="_checkAll" type="checkbox" onclick="onAllCheckClick();"></th>
			    <th><%=SystemEnv.getHtmlLabelName(32715, user.getLanguage())%></th>
			    <th><%=SystemEnv.getHtmlLabelName(149, user.getLanguage())%></th>
			</tr>
		</thead>
		<tbody>
			<%
				if (conf != null) {
				for (SelectItemConfig itemConfig : conf.getSelectItems()) {
					String attrStr1 = "";
					String attrStr2 = "";
					if (canSelectValues.contains(itemConfig.getValue())) {
						attrStr1 = "checked";
						if (itemConfig.getValue().equals(defaultValue)) {
							attrStr2 = "checked";
						}
					} else {
						attrStr2 = "disabled";
					}
			%>
			<tr>
				<td style="display:none;"><input type="hidden" name="value" value="<%=itemConfig.getValue()%>"></td>
				<td><input class="_check" type="checkbox" onclick="onCheckClick(this);" <%=attrStr1%>></td>
				<td class="_name"><%=itemConfig.getShowName(user.getLanguage())%></td>
				<td><input class="_default" type="checkbox" onclick="onDefaultClick(this);" <%=attrStr2%>></td>
			</tr>
			<tr class="Spacing" style="height:1px!important;"><td colspan="3" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
			<%}}%>
		</tbody>
	</table>
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

	</BODY>
	<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}

		function onAllCheckClick() {
			if (jQuery('#mainTable ._checkAll').is(':checked')) {
				changeCheckboxStatus('#mainTable input[type="checkbox"]._check', true);
			} else {
				changeCheckboxStatus('#mainTable input[type="checkbox"]._check', false);
				changeCheckboxStatus('#mainTable input[type="checkbox"]._default', false);
			}
        	changeDefaultEnableStatus();
		}

		function onCheckClick(ele) {
			var _this = jQuery(ele);
			var tr = _this.closest('tr');
			var defaultCheck = jQuery(tr).find('input[type="checkbox"]._default');
			if (!_this.is(':checked')) {
				changeCheckboxStatus(defaultCheck, false);
			}
			changeDefaultEnableStatus();
			changeCheckboxStatus('#mainTable ._checkAll', jQuery('#mainTable input[type="checkbox"]._check:checked').length == jQuery('#mainTable input[type="checkbox"]._check').length);
		}

		function onDefaultClick(ele) {
			var _this = jQuery(ele);
			if (_this.is(':checked')) {
				changeCheckboxStatus('#mainTable input[type="checkbox"]._default', false);
				changeCheckboxStatus(_this, true);
			}
		}

		function changeDefaultEnableStatus() {
			var checkedTrs = jQuery('#mainTable input[type="checkbox"]._check:checked').closest('tr');
			var defaultChecks = jQuery(checkedTrs).find('input[type="checkbox"]._default');
			disOrEnableCheckbox(defaultChecks, false);
			var notCheckedTrs = jQuery('#mainTable input[type="checkbox"]._check:not(:checked)').closest('tr');
			defaultChecks = jQuery(notCheckedTrs).find('input[type="checkbox"]._default');
			disOrEnableCheckbox(defaultChecks, true);
		}

		function selectData(id, name, defaultId) {
			var returnjson = {id: id, name: name, defaultId: defaultId};
			if(dialog){
				try {
					dialog.callback(returnjson);
				} catch(e) {}

				try {
					dialog.close(returnjson);
				} catch(e) {}
			}else{
				window.parent.parent.returnValue = returnjson;
				window.parent.parent.close();
			}
		}

		function btnok_onclick() {
			var checkedTrs = jQuery('#mainTable input[type="checkbox"]._check:checked').closest('tr');
			if (checkedTrs.length <= 0) {
				top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(18353, user.getLanguage())%>');
				return;
			}
			var id = '';
			var name = '';
			var defaultId = '';
			for (var i = 0; i < checkedTrs.length; i++) {
				var checkedTr = jQuery(checkedTrs[i]);
				var tempId = checkedTr.find('input[name="value"]').val();
				var tempName = checkedTr.find('td._name').text();
				if (defaultId == '' && checkedTr.find('input[type="checkbox"]._default:checked').length > 0) {
					defaultId = tempId;
					tempName += '(<%=SystemEnv.getHtmlLabelName(149, user.getLanguage())%>)';
				}
				if (id != '') {
					id += ',';
				}
				id += tempId;
				if (name != '') {
					name += ',';
				}
				name += tempName;
			}
			selectData(id, name, defaultId);
		}
	</script>
</HTML>