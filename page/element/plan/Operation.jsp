<%@ include file="/page/element/operationCommon.jsp"%>
<%@ include file="common.jsp"%>
<%
	String operationSql = "";

	for (int i = 0; i < nameList.size(); i++)
	{
		operationSql = "update hpElementSetting set value = '" + Util.null2String(request.getParameter("_"+nameList.get(i) + "_" + eid))
					+ "' where eid=" + eid + " and name = '" + nameList.get(i) + "'";
		rs_Setting.execute(operationSql);
	}
%>