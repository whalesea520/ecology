<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,weaver.hrm.attendance.domain.*,org.json.JSONObject"%>
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="paidLeaveSetManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveSetManager" scope="page" />
<%
	int id = strUtil.parseToInt(request.getParameter("id"), 0);
	String cmd = strUtil.vString(request.getParameter("cmd"), "save");
	JSONObject obj = new JSONObject();
	int field001 = strUtil.parseToInt(request.getParameter("field001"));
	int field002 = strUtil.parseToInt(request.getParameter("field002"));
	int field003 = strUtil.parseToInt(request.getParameter("field003"));
	if(cmd.equals("save")) {
		HrmPaidLeaveSet bean = null;
		if(id != 0) bean = paidLeaveSetManager.get(id);
		else bean = paidLeaveSetManager.get(paidLeaveSetManager.getMapParam("field001:"+field001));
		bean = bean == null ? new HrmPaidLeaveSet() : bean;
		bean.setField001(field001);
		bean.setField002(field002);
		bean.setField003(field003);
		paidLeaveSetManager.save(bean);
	} else if(cmd.equals("sync")) {
		paidLeaveSetManager.sync(field001, field002, field003);		
	}
	out.print(obj.toString());
%>