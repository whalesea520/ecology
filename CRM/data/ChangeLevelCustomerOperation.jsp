<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
    //只有内部用户可以修改客户的等级
    if(!user.getLogintype().equals("1")){
        return;
    }
	if(!HrmUserVarify.checkUserRight("MutiApproveCustomerNoRequest", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return;
	}
    String customerids = Util.null2String(request.getParameter("customerids"));
    String operation = Util.null2String(request.getParameter("operation"));
    String updateSql = "";
    if(operation.equals("up")){
        updateSql = "update CRM_CustomerInfo set status=status+1 where id in("+customerids+") and status>=1 and status<8";
        RecordSet.executeSql(updateSql);
    }else{
        updateSql = "update CRM_CustomerInfo set status=status-1 where id in("+customerids+") and status>1 and status<=8";
        RecordSet.executeSql(updateSql);
    }
%>