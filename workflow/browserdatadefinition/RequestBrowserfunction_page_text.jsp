
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionFieldConfig" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField" %>

<%@ page import="weaver.general.Util" %>

<%
	//数据自定义-单文本

	ConditionField field = (ConditionField) request.getAttribute("bdfField");
	String value = field.getValue();
	ConditionFieldConfig conf = field.getConfig();
%>

<input name="<%=conf.getFieldSign()%>" id="<%=conf.getFieldSign()%>" class=Inputstyle value="<%=Util.toScreenForWorkflowReadOnly(value)%>">
<button type="button" style="display:none;" class="_reset" onclick="jQuery('#<%=conf.getFieldSign()%>').val('');" />