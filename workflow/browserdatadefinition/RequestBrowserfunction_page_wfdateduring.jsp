
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionFieldConfig" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField" %>

<%@ page import="java.util.List" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.User" %>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>

<%
	//浏览数据自定义-期间

	User bdfUser = (User) request.getAttribute("bdfUser");
	ConditionField field = (ConditionField) request.getAttribute("bdfField");
	ConditionFieldConfig conf = field.getConfig();

	String value = field.getValue();
	if (value == null || value.isEmpty()) {
		//默认选择全部
		value = "38";
	}
	List wfdatedurings = Util.TokenizerString(Util.null2String(baseBean.getPropValue("wfdateduring", "wfdateduring")), ",");
%>
<select id="<%=conf.getFieldSign()%>" name="<%=conf.getFieldSign()%>">
<%
	for (Object wfdateduring : wfdatedurings) {
%>
	<option value="<%=wfdateduring%>" <%if(wfdateduring.equals(value)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(24515, bdfUser.getLanguage())%><%=wfdateduring%><%=SystemEnv.getHtmlLabelName(26301, bdfUser.getLanguage())%></option>
<%}%>
	<option value="38" <%if ("38".equals(value)) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332, bdfUser.getLanguage())%></option>
</select>
<button type="button" style="display:none;" class="_reset" onclick="setSelectBoxValue('#<%=conf.getFieldSign()%>', '38');" />