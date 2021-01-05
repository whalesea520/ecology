
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.workflow.browserdatadefinition.ConditionFieldConfig" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField" %>
<%@ page import="weaver.workflow.search.WorkflowSearchUtil" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User" %>
<%@ taglib uri="/browserTag" prefix="brow" %>
<%
	//浏览数据自定义-浏览框

	User bdfUser = (User) request.getAttribute("bdfUser");
	ConditionField field = (ConditionField) request.getAttribute("bdfField");
	ConditionFieldConfig conf = field.getConfig();

    String formId = Util.null2String(request.getParameter("formId"));
	String isBill = Util.null2String(request.getParameter("isBill"));
	String value = field.getValue();
	String browserType = conf.getBrowserType();
	String browserUrl = conf.getBrowserUrl();
	browserUrl += "?";
	if (conf.getBrowserParams() != null && !conf.getBrowserParams().isEmpty()) {
		browserUrl += conf.getBrowserParams() + "&";
	}
	browserUrl += "selectedids=";
%>
<brow:browser viewType="0"
	hasInput="true" hasBrowser="true"
	isMustInput="1" completeUrl='<%=WorkflowSearchUtil.getBrowserCompleteUrl(browserType)%>'
	browserUrl='<%=browserUrl%>'
	isSingle='<%=String.valueOf(conf.isSingleBrowser())%>'
	name='<%=conf.getFieldSign()%>'
	browserValue='<%=value%>'
	browserSpanValue='<%=conf.getBrowserSpanValue(formId, isBill, value, bdfUser.getLanguage())%>'>
</brow:browser>
<button type="button" style="display:none;" class="_reset" onclick="_writeBackData('<%=conf.getFieldSign()%>', 1, {id:'',name:''});" />
