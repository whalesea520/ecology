<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/page/element/operationCommon.jsp" %>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	ArrayList nameList = new ArrayList();
	
	nameList.add("coreMailList");// 显示未读列表
	nameList.add("coreMailPerpage");// 显示条数
	nameList.add("coreMailLinkMode");// 链接方式
	nameList.add("coreMailTitle");// 主题
	nameList.add("coreMailUser");// 发件人
	nameList.add("coreMailTime");// 发件时间
	
	nameList.add("coreMailPrompt");// 显示提示信息
	nameList.add("coreMailText");// 提示文字
	nameList.add("coreMailNumberColor");// 未读邮件数量颜色
	nameList.add("coreMailLinkColor");// 单点登录链接颜色
	nameList.add("coreMailSysid");// 单点登录
	
	String operationSql = "";
	
	for(int i = 0; i < nameList.size(); i++) {
		operationSql = "update hpElementSetting set value = '" + Util.null2String(request.getParameter(nameList.get(i)+"_"+eid)) + 
			"' where eid = " + eid + " and name = '" + nameList.get(i) + "' ";
     	baseBean.writeLog("CoreMailOperationSQL == " + operationSql);
     	rs.execute(operationSql);
	}
	
%>