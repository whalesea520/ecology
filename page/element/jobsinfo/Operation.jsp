<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/element/operationCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>

<%
	String operationSql = "";

	for(int i=0;i<nameList.size();i++){
		
	operationSql = "update hpElementSetting set value = '"+Util.null2String(request.getParameter(nameList.get(i)+"_"+eid))+"' where eid="+eid+" and name = '"+nameList.get(i)+"'";
	baseBean.writeLog("==============2==================="+operationSql);
	rs_Setting.execute(operationSql);
			
	}
%>