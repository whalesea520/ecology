<%@ include file="/page/element/operationCommon.jsp"%>
<%@ include file="common.jsp"%>
<%
	String operationSql = "";

	for (int i = 0; i < nameList.size(); i++)
	{
		String pname = (String)nameList.get(i);
		String pvalue = Util.null2String(request.getParameter(pname + "_" + eid));
		operationSql = "update hpElementSetting set value = '" + Util.null2String(request.getParameter(pname + "_" + eid))+ "' where eid=" + eid + " and name = '" + pname + "'";
		rs_Setting.execute(operationSql);
	}
%>