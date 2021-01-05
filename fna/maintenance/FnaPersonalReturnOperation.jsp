<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.fna.budget.BudgetHandler"%>
<%@ page import="weaver.fna.budget.WipeInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("FinanceWriteOff:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

char flag = Util.getSeparator() ;
String operation = Util.null2String(request.getParameter("operation"));
String para = "";

if (operation.equals("add")) {
	String loantypeid = "2";
	String organizationid = Util.null2String(request.getParameter("organizationid"));
    String organizationtype = Util.null2String(request.getParameter("organizationtype"));
    String crmid = "" ;
	String projectid = "" ;
	String occurdate = Util.fromScreen(request.getParameter("occurdate"),user.getLanguage());
	double amount = Util.getDoubleValue(request.getParameter("amount"),0);
	int operationtype =  Util.getIntValue(Util.null2String(request.getParameter("operationtype")),0);
	if(operationtype>0) amount = Math.abs(amount);
	else amount = -1 * Math.abs(amount);
	String credenceno = Util.null2String(request.getParameter("debitremark"));
	int releatedid = Util.getIntValue(request.getParameter("requestid"),0);
	String description = Util.null2String(request.getParameter("summary"));
	String releatedname = "" ;
	String returndate = "" ;
	String dealuser = ""+user.getUID();

    String sql="insert into FnaLoanInfo(organizationid,organizationtype,occurdate,amount,debitremark,remark,requestid,processorid,loantype) values ("
            +organizationid+","+organizationtype+",'"+occurdate+"',"+amount+",'"+StringEscapeUtils.escapeSql(credenceno)+"','"+StringEscapeUtils.escapeSql(description)+"',"+releatedid+","+dealuser+","+loantypeid+")";
    rs.executeSql(sql);
    response.sendRedirect("/fna/maintenance/FnaPersonalReturnInner.jsp?organizationtype="+organizationtype+"&organizationid="+organizationid);
} else if (operation.equals("edit") && false) {
	String id = Util.null2String(request.getParameter("paraid"));
	String loantypeid = "2";
	String organizationid = Util.null2String(request.getParameter("organizationid"));
    String organizationtype = Util.null2String(request.getParameter("organizationtype"));
	String crmid = "" ;
	String projectid = "" ;
	String occurdate = Util.fromScreen(request.getParameter("occurdate"),user.getLanguage());
	double amount = Util.getDoubleValue(request.getParameter("amount"),0);
	int operationtype =  Util.getIntValue(Util.null2String(request.getParameter("operationtype")),0);
	if(operationtype>0) amount = Math.abs(amount);
	else amount = -1 * Math.abs(amount);
	String credenceno = Util.null2String(request.getParameter("debitremark"));
	int releatedid = Util.getIntValue(request.getParameter("requestid"),0);
	String description = Util.null2String(request.getParameter("summary"));
	String releatedname = "" ;
	String returndate = "" ;
	String dealuser = ""+user.getUID();

    String sql="update FnaLoanInfo set organizationid="+organizationid+",organizationtype="+organizationtype+
                ",occurdate='"+occurdate+"',amount="+amount+",debitremark='"+StringEscapeUtils.escapeSql(credenceno)+"',"+
    			"remark='"+StringEscapeUtils.escapeSql(description)+"',requestid="+releatedid+",processorid="+dealuser+",loantype="+loantypeid+
                 " where id=" +id;
    rs.executeSql(sql);
	response.sendRedirect("FnaPersonalReturnView.jsp?paraid="+id);
} else if (operation.equals("delete") && false) { 
	String id = Util.null2String(request.getParameter("paraid"));
	String organizationid = "";
    String organizationtype= "";
    rs.executeSql("SELECT organizationid,organizationtype FROM FnaLoanInfo WHERE id = " + id);
	if (rs.next()){
		organizationid = Util.null2String(rs.getString("organizationid"));
        organizationtype = Util.null2String(rs.getString("organizationtype"));
    }

    rs.executeSql("delete from FnaLoanInfo where id="+id);
	response.sendRedirect("FnaPersonalReturn.jsp?organizationtype="+organizationtype+"&organizationid="+organizationid);
}
%>