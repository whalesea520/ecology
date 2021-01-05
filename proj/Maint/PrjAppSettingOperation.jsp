<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page" />

<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}


StringBuilder sb=new StringBuilder();
sb.append(" UPDATE Prj_Settings")
.append(" SET subcompanyid = -1")
.append(" ,departmentid = -1")
.append(" ,userid = -1")
.append(" ,prj_dsc_doc = '"+Util.null2String(request.getParameter("prj_dsc_doc"))+"'")
.append(" ,prj_dsc_wf = '"+Util.null2String(request.getParameter("prj_dsc_wf"))+"'")
.append(" ,prj_dsc_crm = '"+Util.null2String(request.getParameter("prj_dsc_crm"))+"'")
.append(" ,prj_dsc_prj = '"+Util.null2String(request.getParameter("prj_dsc_prj"))+"'")
.append(" ,prj_dsc_tsk = '"+Util.null2String(request.getParameter("prj_dsc_tsk"))+"'")
.append(" ,prj_dsc_acc = '"+Util.null2String(request.getParameter("prj_dsc_acc"))+"'")
.append(" ,prj_dsc_accsec = '"+Util.getIntValue(request.getParameter("prj_dsc_accsec"),-1)+"'")
.append(" ,tsk_dsc_doc = '"+Util.null2String(request.getParameter("tsk_dsc_doc"))+"'")
.append(" ,tsk_dsc_wf = '"+Util.null2String(request.getParameter("tsk_dsc_wf"))+"'")
.append(" ,tsk_dsc_crm = '"+Util.null2String(request.getParameter("tsk_dsc_crm"))+"'")
.append(" ,tsk_dsc_prj = '"+Util.null2String(request.getParameter("tsk_dsc_prj"))+"'")
.append(" ,tsk_dsc_tsk = '"+Util.null2String(request.getParameter("tsk_dsc_tsk"))+"'")
.append(" ,tsk_dsc_acc = '"+Util.null2String(request.getParameter("tsk_dsc_acc"))+"'")
.append(" ,tsk_dsc_accsec = '"+Util.getIntValue(request.getParameter("tsk_dsc_accsec"),-1)+"'")
.append(" ,prj_acc = '"+Util.null2String(request.getParameter("prj_acc"))+"'")
.append(" ,prj_accsec = '"+Util.getIntValue(request.getParameter("prj_accsec"),-1)+"'")
.append(" ,tsk_acc = '"+Util.null2String(request.getParameter("tsk_acc"))+"'")
.append(" ,tsk_accsec = '"+Util.getIntValue(request.getParameter("tsk_accsec"),-1)+"'")
.append(" ,prj_gnt_showplan_ = '"+Util.null2String(request.getParameter("prj_gnt_showplan_"))+"'")
.append(" ,prj_gnt_warningday = '"+Util.getIntValue(request.getParameter("prj_gnt_warningday"),0)+"'")
.append(" ,tsk_approval = '"+Util.null2String(request.getParameter("tsk_approval"))+"'")
.append(" ,tsk_approval_type = '"+Util.getIntValue(request.getParameter("tsk_approval_type"),1)+"'")
.append(" WHERE id=-1")

;

rs.executeSql(sb.toString());

PrjSettingsComInfo.removeCache();


%>