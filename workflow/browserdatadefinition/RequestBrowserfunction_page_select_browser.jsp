
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.workflow.browserdatadefinition.ConditionFieldConfig" %>
<%@ page import="weaver.workflow.browserdatadefinition.SelectItemConfig" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField" %>
<%@ page import="weaver.workflow.search.WorkflowSearchUtil" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User" %>

<%@ taglib uri="/browserTag" prefix="brow" %>

<%
	//浏览数据自定义-下拉选择框+浏览框

	User bdfUser = (User) request.getAttribute("bdfUser");
	ConditionField field = (ConditionField) request.getAttribute("bdfField");
	ConditionFieldConfig conf = field.getConfig();
	String valueType = field.getValueType();
	String value = "";

    String formId = Util.null2String(request.getParameter("formId"));
	String isBill = Util.null2String(request.getParameter("isBill"));

	SelectItemConfig selectedItemConfig = null;
	String valueTypeIdOrName = conf.getFieldSign() + "ValueType";
%>
<select name="<%=valueTypeIdOrName%>" id="<%=valueTypeIdOrName%>" onchange="selectBrowser_selectChanged('<%=conf.getFieldSign()%>');" style="float:left;">
	<option value=""></option>
<%
	for (SelectItemConfig itemConfig : conf.getSelectItems()) {
		String itemValue = itemConfig.getValue();
		String attrStr = "";
		if (itemConfig.hasBrowser()) {
			String browserUrl = itemConfig.getBrowserUrl();
			if (itemConfig.isFormFieldBrowser()) {
				browserUrl += "?wfid=" + field.getWorkflowId() + "&fieldid=" + field.getFieldId();
				if (itemConfig.getBrowserParams() != null && !itemConfig.getBrowserParams().isEmpty()) {
					browserUrl += "&" + itemConfig.getBrowserParams();
				}
			} else {
				browserUrl += "?";
				if (itemConfig.getBrowserParams() != null && !itemConfig.getBrowserParams().isEmpty()) {
					browserUrl += itemConfig.getBrowserParams() + "&";
				}
				browserUrl += "selectedids=";
			}
			attrStr += "_browserurl='" + browserUrl + "'";
			attrStr += " _issinglebrowser='" + itemConfig.isSingleBrowser() + "'";
			if (itemConfig.isFormFieldBrowser()) {
				if (itemConfig.getBrowserParams().startsWith("type=")) {					
					attrStr += " _completeurl='/data.jsp?type=fieldBrowser&wfid="+field.getWorkflowId()+"&fieldid="+field.getFieldId()+"&htmltype=3&f"+itemConfig.getBrowserParams()+"'";
				}
			} else {
				attrStr += " _completeurl='" + WorkflowSearchUtil.getBrowserCompleteUrl(itemConfig.getBrowserType()) + "'";
			}
		}
		if (itemValue.equals(valueType)) {
			attrStr += " selected";
			selectedItemConfig = itemConfig;
		}
%>
	<option value="<%=itemValue%>" <%=attrStr%>><%=itemConfig.getShowName(bdfUser.getLanguage())%></option>
<%}%>
</select>
<%
	String browserSpanValue = "";
	boolean hideBrowser = true;
	String isSingle = "true";
	if (selectedItemConfig != null) {
		if (selectedItemConfig.hasBrowser()) {
			hideBrowser = false;
			value = field.getValue();
			isSingle = Boolean.toString(selectedItemConfig.isSingleBrowser());
			browserSpanValue = selectedItemConfig.getBrowserSpanValue(formId, isBill, value, bdfUser.getLanguage());
		}
	}

	String compurl = "javascript:getCompleteUrl('"+conf.getFieldSign()+"')"; 
	String urlFnparams = "'"+conf.getFieldSign()+"'";
%>
<span id="<%=conf.getFieldSign()%>Span" <%if (hideBrowser) {%>style="display:none;"<%}%>>
	<brow:browser viewType="0" width="200px"
		hasInput="true" hasBrowser="true"
		isMustInput="2" completeUrl='<%=compurl%>'
		getBrowserUrlFn="getSelectBrowserUrl"
		getBrowserUrlFnParams='<%=urlFnparams%>'
		isSingle='<%=isSingle%>'
		name='<%=conf.getFieldSign()%>'
		browserValue='<%=value%>'
		browserSpanValue='<%=browserSpanValue%>'>
	</brow:browser>
</span>
<button type="button" style="display:none;" class="_reset" onclick="setSelectBoxValue('#<%=valueTypeIdOrName%>', '');" />
