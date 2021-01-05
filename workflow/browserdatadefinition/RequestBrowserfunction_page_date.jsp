
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionFieldConfig" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField" %>
<%@ page import="weaver.workflow.search.WorkflowSearchUtil" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.User" %>
<%@ taglib uri="/browserTag" prefix="brow" %>

<%
	//浏览数据自定义-日期

	User bdfUser = (User) request.getAttribute("bdfUser");
	ConditionField field = (ConditionField) request.getAttribute("bdfField");
	ConditionFieldConfig conf = field.getConfig();

	String valueType = field.getValueType();
	String startDate = field.getStartDate();
	String endDate = field.getEndDate();
	String valueTypeIdOrName = conf.getFieldSign() + "ValueType";
	String startDateSpanIdOrName = conf.getFieldSign() + "StartDateSpan";
	String endDateSpanIdOrName = conf.getFieldSign() + "EndDateSpan";
	String startDateIdOrName = conf.getFieldSign() + "StartDate";
	String endDateIdOrName = conf.getFieldSign() + "EndDate";

	String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowFormFieldBrowser.jsp?type=2&wfid=" + field.getWorkflowId() + "&fieldid=" + field.getFieldId();
	String completeUrl = "/data.jsp?type=fieldBrowser&wfid="+field.getWorkflowId()+"&fieldid="+field.getFieldId()+"&htmltype=3&ftype=2";
	String browserValue = "";
	String browserSpanValue = "";
	if (field.isGetValueFromFormField()) {
	    String formId = Util.null2String(request.getParameter("formId"));
		String isBill = Util.null2String(request.getParameter("isBill"));
		browserValue = field.getValue();
		browserSpanValue = WorkflowSearchUtil.getFieldName(formId, browserValue, isBill, "7");
	}
%>
<select name="<%=valueTypeIdOrName%>" id="<%=valueTypeIdOrName%>" onchange="onDateSelectChange('<%=conf.getFieldSign()%>');" style="float:left;">
	<option value="0" <%if("0".equals(valueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332, bdfUser.getLanguage())%></option>
	<option value="1" <%if("1".equals(valueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15537, bdfUser.getLanguage())%></option>
	<option value="2" <%if("2".equals(valueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15539, bdfUser.getLanguage())%></option>
	<option value="3" <%if("3".equals(valueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15541, bdfUser.getLanguage())%></option>
	<option value="4" <%if("4".equals(valueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21904, bdfUser.getLanguage())%></option>
	<option value="5" <%if("5".equals(valueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15384, bdfUser.getLanguage())%></option>
	<option value="6" <%if("6".equals(valueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(32530, bdfUser.getLanguage())%></option>
	<option value="8" <%if("8".equals(valueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(23182, bdfUser.getLanguage())%></option>
</select>
<span id="<%=conf.getFieldSign()%>DateSpan" <%if (!"6".equals(valueType)) {%> style="display: none" <%}%>>
&nbsp;
<BUTTON class=Calendar type="button" onclick="getTheStartDate('<%=startDateIdOrName%>','<%=startDateSpanIdOrName%>','<%=endDateIdOrName%>','<%=endDateSpanIdOrName%>')"></BUTTON>
<SPAN id="<%=startDateSpanIdOrName%>"><%=startDate%></SPAN> -
<BUTTON class=Calendar type="button" onclick="getTheendDate('<%=startDateIdOrName%>','<%=startDateSpanIdOrName%>','<%=endDateIdOrName%>','<%=endDateSpanIdOrName%>')"></BUTTON>
<SPAN id="<%=endDateSpanIdOrName%>"><%=endDate%></SPAN>
<input type="hidden" name="<%=startDateIdOrName%>" id="<%=startDateIdOrName%>" value="<%=startDate%>">
<input type="hidden" name="<%=endDateIdOrName%>" id="<%=endDateIdOrName%>" value="<%=endDate%>">
</span>
<span id="<%=conf.getFieldSign()%>Span" <%if (!field.isGetValueFromFormField()) {%> style="display: none" <%}%>>
<brow:browser viewType="0" width="200px"
	hasInput="true" hasBrowser="true"
	isMustInput="2" completeUrl='<%=completeUrl%>'
	isSingle="true"
	browserUrl='<%=browserUrl%>'
	name='<%=conf.getFieldSign()%>'
	browserValue='<%=browserValue%>'
	browserSpanValue='<%=browserSpanValue%>'>
</brow:browser>
</span>
<button type="button" style="display:none;" class="_reset" onclick="setSelectBoxValue('#<%=valueTypeIdOrName%>', '0');" />
