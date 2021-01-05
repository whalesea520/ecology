<%@ include file="/page/element/operationCommon.jsp"%>
<%@ include file="common.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");

	String operationSql = "";
	for (int i = 0; i < nameList.size(); i++)
	{
		String targetName = (String)nameList.get(i);
		String vales = Util.null2String(request.getParameter("_"+targetName + "_" + eid));
		vales = Util.toHtml(vales);
		operationSql = "update hpElementSetting set value = '" + vales + "' where eid=" + eid + " and name = '" + targetName + "'";
		rs_Setting.execute(operationSql);
	}
%>