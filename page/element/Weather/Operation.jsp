
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/element/operationCommon.jsp"%>
<%@ include file="common.jsp"%>
<%

	String operationSql = "";
	for (int i = 0; i < nameList.size(); i++)
	{
		String targetName = (String)nameList.get(i);
		operationSql = "update hpElementSetting set value = '" + Util.null2String(java.net.URLDecoder.decode(request.getParameter(targetName + "_" + eid), "UTF-8"))
				+ "' where eid=" + eid + " and name = '" + targetName + "'";
		rs_Setting.execute(operationSql);
	}
%>