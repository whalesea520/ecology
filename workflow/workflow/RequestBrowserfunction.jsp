
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.request.Browsedatadefinition" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<% 
	int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
	int fieldId = Util.getIntValue(request.getParameter("fieldid"), 0);
	int viewType = Util.getIntValue(Util.null2String(request.getParameter("viewtype")), 0);
	int formId = Util.getIntValue(Util.null2String(request.getParameter("formid")), 0);
	int isBill = Util.getIntValue(Util.null2String(request.getParameter("isbill")), 0);
	int type = Util.getIntValue(Util.null2String(request.getParameter("type")), 0);
	if (type == 0 && isBill == 0) {
	 	type = Util.getIntValue(Browsedatadefinition.getFieldType(String.valueOf(wfid), String.valueOf(fieldId)));
	}
	request.setAttribute("wfid", wfid);
	request.setAttribute("fieldId", fieldId);
	request.setAttribute("type", type);
	request.setAttribute("viewType", viewType);
	request.setAttribute("formId", formId);
	request.setAttribute("isBill", isBill);

	switch (type) {
		case 16:
		case 152:
		case 171:
%>
	<jsp:include page="/workflow/browserdatadefinition/RequestBrowserfunction_workflow.jsp"></jsp:include>
<%
		break;
		case 22:
		case 251:
%>
	<jsp:include page="/workflow/browserdatadefinition/RequestBrowserfunction_FnaConfig.jsp"></jsp:include>
<%
		break;
		default:
%>
	<jsp:include page="/workflow/browserdatadefinition/RequestBrowserfunction_config.jsp"></jsp:include>
<%
		break;
	}
%>