<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
	User user=HrmUserVarify.getUser(request, response);
	if(user==null){
		return;
	}
	if (!HrmUserVarify.checkUserRight("Customer:Settings", user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String CRM_addRemind = Util.null2String(request.getParameter("CRM_addRemind"),"N");//是否开启创建客户提醒。             Y：开启，    N：关闭
	String CRM_addRemindTo = Util.null2String(request.getParameter("CRM_addRemindTo"),"1");//创建客户提醒对象。            1：直接上级，2：所有上级
	String Sell_addRemind = Util.null2String(request.getParameter("Sell_addRemind"),"N");//是否开启创建商机提醒。             Y：开启，    N：关闭
	String Sell_addRemindTo = Util.null2String(request.getParameter("Sell_addRemindTo"),"1");//创建商机提醒对象。            1：直接上级，2：所有上级
	StringBuilder sb=new StringBuilder();
	sb.append(" update crm_customerSettings")
	.append(" set modifydate='"+TimeUtil.getCurrentDateString()+"'")
	.append(" ,modifytime='"+TimeUtil.getOnlyCurrentTimeString()+"'")
	.append(" ,modifyuser='"+user.getUID()+"'")
	.append(" ,crm_rmd_create='"+CRM_addRemind+"'")
	.append(" ,crm_rmd_create2='"+CRM_addRemindTo+"'")
	.append(" ,sell_rmd_create='"+Sell_addRemind+"'")
	.append(" ,sell_rmd_create2='"+Sell_addRemindTo+"'")
	.append(" where id=-1");
	
	RecordSet.executeSql(sb.toString());
	
	response.sendRedirect("CustomerSettings.jsp");
	
%>
