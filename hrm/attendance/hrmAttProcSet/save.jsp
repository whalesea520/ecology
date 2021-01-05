<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.attendance.domain.*,org.json.JSONObject"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="attProcSetManager" class="weaver.hrm.attendance.manager.HrmAttProcSetManager" scope="page" />
<jsp:useBean id="attProcActionManager" class="weaver.hrm.attendance.manager.HrmAttProcActionManager" scope="page" />
<jsp:useBean id="attProcRelationManager" class="weaver.hrm.attendance.manager.HrmAttProcRelationManager" scope="page" />
<jsp:useBean id="workflowBillfieldManager" class="weaver.hrm.attendance.manager.WorkflowBillfieldManager" scope="page" />
<%
	int id = strUtil.parseToInt(request.getParameter("id"), 0);
	String cmd = strUtil.vString(request.getParameter("cmd"), "save");
	JSONObject obj = new JSONObject();
	if(cmd.equals("save")) {
		int field001 = strUtil.parseToInt(request.getParameter("field001"), 0);
		int field002 = strUtil.parseToInt(request.getParameter("field002"), 0);
		int field003 = strUtil.parseToInt(request.getParameter("field003"), 0);
		int field004 = strUtil.parseToInt(request.getParameter("field004"), 0);
		int field005 = strUtil.parseToInt(request.getParameter("field005"), 1);
		int field006 = strUtil.parseToInt(request.getParameter("field006"));
		int field007 = strUtil.parseToInt(request.getParameter("field007"), 0);
		String field008 = strUtil.vString(request.getParameter("field008"), dateUtil.getCurrentDate());
		String field009 = strUtil.vString(request.getParameter("field009"), dateUtil.getCurrentDate());
		String field010 = strUtil.vString(request.getParameter("field010"));
		
		rs.executeSql("select * from view_workflowForm_selectAll where isoldornew = 1 and id > 0 and id = "+field002);
		if(rs.next()) field003 = 1;
		HrmAttProcSet bean = null;
		if(id > 0) bean = attProcSetManager.get(id);
		bean = bean == null ? new HrmAttProcSet(true) : bean;
		bean.setField001(field001);
		bean.setField002(field002);
		bean.setField003(field003);
		bean.setField004(field004);
		bean.setField005(field005);
		bean.setField006(field006);
		if(id <= 0) {
			bean.setField007(field007);
			bean.setField008(field008);
		} else {
			bean.setField010(field010);
		}
		bean.setField009(field009);
		obj.put("id", String.valueOf(attProcSetManager.save(bean)));
		
		if(field002 < 0 && field003 == 0 && (field006 == 0 || field006 == 3)) attProcSetManager.welcomeToSet(field001, field006);
	} else if(cmd.equals("changeStatus")) {
		HrmAttProcSet bean = attProcSetManager.get(id);
		if(bean != null) {
			bean.setField005(strUtil.parseToInt(request.getParameter("field005"), 1));
			bean.setField009(dateUtil.getCurrentDate());
			attProcSetManager.update(bean);
			obj.put("status", "true");
		} else obj.put("status", "false");
	} else if(cmd.equals("delete")) {
		attProcSetManager.delete(strUtil.vString(request.getParameter("ids")));
	} else if(cmd.equals("getSelectValue")) {
		String _type = strUtil.vString(request.getParameter("type"));
		String fType = strUtil.vString(request.getParameter("fType"));
		String billId = strUtil.vString(request.getParameter("billId"));
		String languageid = strUtil.vString(request.getParameter("languageid"));
		Boolean ck = Boolean.valueOf(strUtil.vString(request.getParameter("ck")));
		List fieldList = workflowBillfieldManager.find(workflowBillfieldManager.getMapParam("billid:"+billId+";languageid:"+languageid+";sql_id:and t.id not in(654,655)"));
		WorkflowBillfield wfBean = null;
		StringBuffer keys = new StringBuffer(), values = new StringBuffer();
		for(int i=0; i<(fieldList == null ? 0 : fieldList.size()); i++){
			wfBean = (WorkflowBillfield)fieldList.get(i);
			if(!ck && (!wfBean.getFieldhtmltype().equals(_type) || !String.valueOf(wfBean.getType()).equals(fType))) continue;
			keys.append(keys.length() == 0 ? "" : ",").append(wfBean.getFieldname()+"___"+wfBean.getId());
			values.append(values.length() == 0 ? "" : ",").append(wfBean.getLabelName());
		}
		obj.put("keys", keys.toString());
		obj.put("values", values.toString());
	} else if(cmd.equals("saveRelation")) {
		HrmAttProcSet bean = attProcSetManager.get(strUtil.parseToInt(request.getParameter("field001"), 0));
		if(bean != null) {
			bean.setField009(dateUtil.getCurrentDate());
			attProcSetManager.update(bean);
		}
		attProcRelationManager.save(request);
	} else if(cmd.equals("saveSet")) {
		attProcActionManager.save(request, response);
	}
	out.print(obj.toString());
%>