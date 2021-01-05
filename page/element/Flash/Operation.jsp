<%@ include file="/page/element/operationCommon.jsp"%>
<%@ include file="common.jsp"%>
<%
	String operationSql = "";

	for (int i = 0; i < nameList.size(); i++)
	{
		if (!nameList.get(i).equals("flashSrcType"))
		{
			operationSql = "update hpElementSetting set value = '" + Util.null2String(request.getParameter(nameList.get(i) + "_" + eid))
					+ "' where eid=" + eid + " and name = '" + nameList.get(i) + "'";
			rs_Setting.execute(operationSql);
		}
		else
		{
			operationSql = "update hpElementSetting set value = '" + Util.null2String(request.getParameter(nameList.get(i) + "_" + eid))
					+ "' where eid=" + eid + " and name = '" + nameList.get(i) + "'";
			rs_Setting.execute(operationSql);
			if ("1".equals(Util.null2String(request.getParameter("flashSrcType_" + eid))))
			{
				operationSql = "update hpElementSetting set value = '" + Util.null2String(request.getParameter("flashSrc_" + eid))
						+ "' where eid=" + eid + " and name = 'flashSrc'";
				rs_Setting.execute(operationSql);
			}
			else
			{
				operationSql = "update hpElementSetting set value = '" + Util.null2String(request.getParameter("flashUrl_" + eid))
						+ "' where eid=" + eid + " and name = 'flashSrc'";
				rs_Setting.execute(operationSql);
			}
			break;
		}
	}
%>