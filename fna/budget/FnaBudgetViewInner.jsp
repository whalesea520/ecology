<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util"%>
<%
if(true){
	request.getRequestDispatcher("/fna/budget/FnaBudgetViewInner1.jsp").forward(request, response);
	return;
}else{
    String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
    String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
    int budgetinfoid = Util.getIntValue(request.getParameter("budgetinfoid"), 0);//预算设置主表id
    int budgetperiods = Util.getIntValue(request.getParameter("budgetperiods"), 0);//预算年度id
    int status = Util.getIntValue(request.getParameter("status"), 0);//预算状态
    int revision = Util.getIntValue(request.getParameter("revision"), 0);//预算版本
    boolean edit = "true".equalsIgnoreCase(Util.null2String(request.getParameter("edit")).trim());//是否直接打开编辑页面
	
	//不显示版本toorbar，直接显示预算信息FnaBudgetViewInner1.jsp页面内容
	if(true){
		String url = "/fna/budget/FnaBudgetViewInner1.jsp?"+
			"organizationtype="+organizationtype+"&organizationid="+organizationid+"&budgetinfoid="+budgetinfoid+"&budgetperiods="+budgetperiods+"&status="+status+"&revision="+revision+
			"&edit="+edit;
		response.sendRedirect(url);
		return ;
	}
}
%>
<html><head></head><body></body></html>