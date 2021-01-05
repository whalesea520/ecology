<%@page import="weaver.fna.maintenance.FnaCostCenter"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<jsp:useBean id="BudgetHandler" class="weaver.fna.budget.BudgetHandler" scope="page" />
<%
User user = HrmUserVarify.getUser(request, response) ;
if(user==null){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

int budgetfeetype  = Util.getIntValue(request.getParameter("budgetfeetype"),0);//科目
int orgtype = Util.getIntValue(request.getParameter("orgtype"),0);//报销类型 人员0/部门1/分部2   3/2/1
int orgid  = Util.getIntValue(request.getParameter("orgid"),0);//报销单位
String applydate  = request.getParameter("applydate");//报销日期
int dtl_id  = Util.getIntValue(request.getParameter("dtl_id"),0);//该明细对应数据库明细表PkId，0表示新增的明细行，无对应数据库记录PkId
int requestid  = Util.getIntValue(request.getParameter("requestid"),0);
String returnStr = "";
if(orgtype==0){//个人
	orgtype=3;
}else if(orgtype==1){//部门
	orgtype=2;
}else if(orgtype==2){//分部
	orgtype=1;
}else if(orgtype==3){//成本中心
	orgtype=FnaCostCenter.ORGANIZATION_TYPE;
}
 
String infos = BudgetHandler.getBudgetKPI4DWR(applydate,orgtype,orgid,budgetfeetype, true, true, dtl_id, requestid);
returnStr = infos;
%>   
<%=returnStr%>