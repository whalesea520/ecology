<%@ include file="/page/element/operationCommon.jsp"%>
<%@ include file="common.jsp"%>
<%
	String operationSql = "";
	for (int i = 0; i < nameList.size(); i++)
	{
		String targetName = (String)nameList.get(i);
		operationSql = "update hpElementSetting set value = '" + Util.null2String(request.getParameter("_"+targetName + "_" + eid))+ "' where eid=" + eid + " and name = '" + targetName + "'";
		rs_Setting.execute(operationSql);
	}
%>