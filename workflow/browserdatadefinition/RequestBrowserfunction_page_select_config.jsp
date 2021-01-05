
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionFieldConfig" %>
<%@ page import="weaver.workflow.browserdatadefinition.SelectItemConfig" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField" %>

<%@ page import="java.util.List" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.User" %>

<%
	//数据自定义-选项设定

	User bdfUser = (User) request.getAttribute("bdfUser");
	ConditionField field = (ConditionField) request.getAttribute("bdfField");
	ConditionFieldConfig conf = field.getConfig();

	String canSelectValues = field.getCanSelectValues();
	String value = field.getValue();

	String canSelectValuesIdOrName = conf.getFieldSign() + "CanSelectValues";
	String canSelectValueShowNames = "";
	List<String> canSelectValueList = field.getCanSelectValueList();

	String allSelectItemValues = conf.getAllSelectItemValues();
	String allSelectItemShowNames = conf.getAllSelectItemShowNames(bdfUser.getLanguage());
	String defaultSelectItemValue = "";
	SelectItemConfig defaultSelectItemConfig = conf.getDefaultSelectItem();
	if (defaultSelectItemConfig != null) {	
		defaultSelectItemValue = defaultSelectItemConfig.getValue();
	}
	if (canSelectValueList == null || canSelectValueList.isEmpty()) {
		canSelectValues = allSelectItemValues;
		canSelectValueShowNames = allSelectItemShowNames;
		value = defaultSelectItemValue;
	} else {
		for (SelectItemConfig itemConfig : conf.getSelectItems()) {
			if (canSelectValueList.contains(itemConfig.getValue())) {
				canSelectValueShowNames += (canSelectValueShowNames.isEmpty() ? "" : ",") + itemConfig.getShowName(bdfUser.getLanguage());
				if (itemConfig.getValue().equals(value)) {
					canSelectValueShowNames += "("+SystemEnv.getHtmlLabelName(149, bdfUser.getLanguage())+")";
				}
			}
		}
	}
%>

<button class="e8_btn_top" style="margin-left: 0px;" type="button" onclick="showSelectConfigWindow('<%=conf.getId()%>', '<%=conf.getFieldSign()%>');"><%=SystemEnv.getHtmlLabelNames("1025,112", bdfUser.getLanguage())%></button>
<span id="<%=conf.getFieldSign()%>Span" style="margin-left: 5px;display:inline-block;width:250px;"><%=canSelectValueShowNames%></span>
<input type="hidden" id="<%=canSelectValuesIdOrName%>" name="<%=canSelectValuesIdOrName%>" value="<%=canSelectValues%>" />
<input type="hidden" id="<%=conf.getFieldSign()%>" name="<%=conf.getFieldSign()%>" value="<%=value%>" />
<button type="button" style="display:none;" class="_reset" onclick="jQuery('#<%=canSelectValuesIdOrName%>').val('<%=allSelectItemValues%>');jQuery('#<%=conf.getFieldSign()%>').val('<%=defaultSelectItemValue%>');jQuery('#<%=conf.getFieldSign()%>Span').text('<%=canSelectValueShowNames%>');" />