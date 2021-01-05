<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.fna.encrypt.Des"%><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(user.getUID()!=1){
	HrmUserVarify.checkUserRight("FnaBudget:All", user);
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String operation = Util.null2String(request.getParameter("operation"));
if("FnaInitData".equals(operation)){//初始化财务相关数据
	int subject = Util.getIntValue(request.getParameter("subject"),0);
	int fcc = Util.getIntValue(request.getParameter("fcc"),0);
	int fnaBudget = Util.getIntValue(request.getParameter("fnaBudget"),0);
	int fnaExpense = Util.getIntValue(request.getParameter("fnaExpense"),0);
	int fnaLoan = Util.getIntValue(request.getParameter("fnaLoan"),0);
	int fnaAdvance = Util.getIntValue(request.getParameter("fnaAdvance"),0);
	
    String timestrformart = "yyMMddHHmmss";
    SimpleDateFormat SDF = new SimpleDateFormat(timestrformart) ;
    Calendar calendar = Calendar.getInstance() ;
    String currentDateStringArray = SDF.format(calendar.getTime());
    
	String fnaBkTbName = user.getUID()+currentDateStringArray;
	
	boolean successFlag = true;
	
	if(successFlag){
		successFlag = false;
		String dStr = Util.null2String(request.getParameter("dStr"));
		if(!"".equals(dStr)){
		    Des desObj = new Des();
			dStr = desObj.strDec(dStr, Des.KEY1, Des.KEY2, Des.KEY3);
			if(!"".equals(dStr)){
				successFlag = rs.executeSql("select a.password from hrmresourcemanager a where a.id = 1 and a.id = "+user.getUID());
				if(successFlag){
					successFlag = false;
					if(rs.next()){
						String password = Util.null2String(rs.getString("password")).trim();
						successFlag = (!"".equals(password) && password.equals(Util.getEncrypt(dStr)));
					}
				}
			}else{
				successFlag = false;
			}
		}else{
			successFlag = false;
		}
	}
	
	
	if(subject==1){
		if("oracle".equalsIgnoreCase(rs.getDBType())){
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk01"+fnaBkTbName+" as Select * from FnabudgetfeetypeRuleSet");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk02"+fnaBkTbName+" as Select * from FnaBudgetfeeType");
			}
		}else if("mysql".equalsIgnoreCase(rs.getDBType())){
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk01"+fnaBkTbName+" ( Select * from FnabudgetfeetypeRuleSet )");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk02"+fnaBkTbName+" ( Select * from FnaBudgetfeeType )");
			}
		}else{
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk01"+fnaBkTbName+" from FnabudgetfeetypeRuleSet");
			}
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk02"+fnaBkTbName+" from FnaBudgetfeeType");
			}
		}
	}
	if(fcc==1){
		if("oracle".equalsIgnoreCase(rs.getDBType())){
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk03"+fnaBkTbName+" as Select * from FnaRuleSetDtlFcc");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk04"+fnaBkTbName+" as Select * from FnaRuleSet");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk05"+fnaBkTbName+" as Select * from FnaCostCenterDtl");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk06"+fnaBkTbName+" as Select * from FnaCostCenter");
			}
		}else if("mysql".equalsIgnoreCase(rs.getDBType())){
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk03"+fnaBkTbName+" ( Select * from FnaRuleSetDtlFcc )");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk04"+fnaBkTbName+" ( Select * from FnaRuleSet )");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk05"+fnaBkTbName+" ( Select * from FnaCostCenterDtl )");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk06"+fnaBkTbName+" ( Select * from FnaCostCenter )");
			}
		}else{
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk03"+fnaBkTbName+" from FnaRuleSetDtlFcc");
			}
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk04"+fnaBkTbName+" from FnaRuleSet");
			}
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk05"+fnaBkTbName+" from FnaCostCenterDtl");
			}
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk06"+fnaBkTbName+" from FnaCostCenter");
			}
		}
	}
	if(fnaBudget==1){
		if("oracle".equalsIgnoreCase(rs.getDBType())){
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk07"+fnaBkTbName+" as Select * from FnaBudgetInfoDetail");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk08"+fnaBkTbName+" as Select * from FnaBudgetInfo");
			}
		}else if("mysql".equalsIgnoreCase(rs.getDBType())){
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk07"+fnaBkTbName+" ( Select * from FnaBudgetInfoDetail )");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk08"+fnaBkTbName+" ( Select * from FnaBudgetInfo )");
			}
		}else{
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk07"+fnaBkTbName+" from FnaBudgetInfoDetail");
			}
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk08"+fnaBkTbName+" from FnaBudgetInfo");
			}
		}
	}
	if(fnaExpense==1){
		if("oracle".equalsIgnoreCase(rs.getDBType())){
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk09"+fnaBkTbName+" as Select * from FnaExpenseInfo");
			}
		}else if("mysql".equalsIgnoreCase(rs.getDBType())){
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk09"+fnaBkTbName+" ( Select * from FnaExpenseInfo )");
			}
		}else{
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk09"+fnaBkTbName+" from FnaExpenseInfo");
			}
		}
	}
	if(fnaLoan==1){
		if("oracle".equalsIgnoreCase(rs.getDBType())){
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk10"+fnaBkTbName+" as Select * from FnaLoanInfo");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk11"+fnaBkTbName+" as Select * from FnaBorrowInfoAmountLog");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk12"+fnaBkTbName+" as Select * from FnaBorrowInfo");
			}
		}else if("mysql".equalsIgnoreCase(rs.getDBType())){
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk10"+fnaBkTbName+" ( Select * from FnaLoanInfo )");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk11"+fnaBkTbName+" ( Select * from FnaBorrowInfoAmountLog )");
			}
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk12"+fnaBkTbName+" ( Select * from FnaBorrowInfo )");
			}
		}else{
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk10"+fnaBkTbName+" from FnaLoanInfo");
			}
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk11"+fnaBkTbName+" from FnaBorrowInfoAmountLog");
			}
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk12"+fnaBkTbName+" from FnaBorrowInfo");
			}
		}
	}
	if(fnaAdvance==1){
		if("oracle".equalsIgnoreCase(rs.getDBType())){
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk13"+fnaBkTbName+" as Select * from fnaFeeWfInfoLogicAdvanceR");
			}
		}else if("mysql".equalsIgnoreCase(rs.getDBType())){
			if(successFlag){
				successFlag = rs.executeSql("create table fnaBk13"+fnaBkTbName+" ( Select * from fnaFeeWfInfoLogicAdvanceR )");
			}
		}else{
			if(successFlag){
				successFlag = rs.executeSql("select * into fnaBk13"+fnaBkTbName+" from fnaFeeWfInfoLogicAdvanceR");
			}
		}
	}
	
	if(successFlag){
		String ip = request.getHeader("x-forwarded-for"); 
		if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
			ip = request.getHeader("Proxy-Client-IP"); 
		} 
		if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
			ip = request.getHeader("WL-Proxy-Client-IP"); 
		} 
		if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
			ip = request.getRemoteAddr(); 
		} 

		String opDate = TimeUtil.getCurrentDateString();
		String opTime = TimeUtil.getOnlyCurrentTimeString();
		successFlag = rs.executeSql("insert into FnaInitSetOpLog ("+
				"userId, ip, fnaBkTbName, "+
				"subject, fcc, fnaBudget, fnaExpense, fnaLoan, fnaAdvance, "+
				"opDate, opTime"+
				") "+
				"values ("+
				""+user.getUID()+", '"+StringEscapeUtils.escapeSql(ip)+"', '"+StringEscapeUtils.escapeSql(fnaBkTbName)+"', "+
				""+subject+", "+fcc+", "+fnaBudget+", "+fnaExpense+", "+fnaLoan+", "+fnaAdvance+", "+
				"'"+StringEscapeUtils.escapeSql(opDate)+"', '"+StringEscapeUtils.escapeSql(opTime)+"'"+
				")");
	}
	
	if(successFlag){
		if(subject==1){
			rs.executeSql("TRUNCATE table FnabudgetfeetypeRuleSet");
			rs.executeSql("TRUNCATE table FnaBudgetfeeType");
		}
		if(fcc==1){
			rs.executeSql("TRUNCATE table FnaRuleSetDtlFcc");
			rs.executeSql("TRUNCATE table FnaRuleSet");
			rs.executeSql("TRUNCATE table FnaCostCenterDtl");
			rs.executeSql("TRUNCATE table FnaCostCenter");
		}
		if(fnaBudget==1){
			rs.executeSql("TRUNCATE table FnaBudgetInfoDetail");
			rs.executeSql("TRUNCATE table FnaBudgetInfo");
		}
		if(fnaExpense==1){
			rs.executeSql("TRUNCATE table FnaExpenseInfo");
		}
		if(fnaLoan==1){
			rs.executeSql("TRUNCATE table FnaLoanInfo");
			rs.executeSql("TRUNCATE table FnaBorrowInfoAmountLog");
			rs.executeSql("TRUNCATE table FnaBorrowInfo");
		}
		if(fnaAdvance==1){
			rs.executeSql("TRUNCATE table fnaFeeWfInfoLogicAdvanceR");
		}
	}
	
	response.sendRedirect("/fna/init/FnaInitSetEditInner.jsp");
	
}else{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

































%>