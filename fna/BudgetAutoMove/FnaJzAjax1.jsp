<%@page import="org.json.JSONObject"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="weaver.fna.budget.BudgetHandler"%><%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.budget.BudgetAutoMove"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String spzCntText = "";
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
}else{
	if (!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user) && !HrmUserVarify.checkUserRight("BudgetManualTransfer:do", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	RecordSet rs = new RecordSet();
	String fnayear = Util.null2String(request.getParameter("fnayear"));
	int periodsid = Util.getIntValue(request.getParameter("periodsid"));
	String _guid1 = Util.null2String(request.getParameter("_guid1"));
	boolean mBudgetMove = "true".equalsIgnoreCase(Util.null2String(request.getParameter("mBudgetMove")));
	boolean qBudgetMove = "true".equalsIgnoreCase(Util.null2String(request.getParameter("qBudgetMove")));
	boolean hBudgetMove = "true".equalsIgnoreCase(Util.null2String(request.getParameter("hBudgetMove")));
	
	if(!"".equals(fnayear) && periodsid >= 1 && periodsid < 12){
		BudgetHandler budgetHandler = new BudgetHandler();
		
		String sql = " select b.fnayearid,b.fnayear,b.Periodsid,b.startdate,b.enddate,a.status"+
			" from FnaYearsPeriods a join FnaYearsPeriodsList b on a.id = b.fnayearid "+
			" where b.Periodsid>=1 and b.Periodsid<12 "+
			" and a.fnayear = '"+StringEscapeUtils.escapeSql(fnayear)+"' and b.periodsid = "+periodsid+" ";
		rs.executeSql(sql);
		if(rs.next()){
			int fnayearid = Util.getIntValue(rs.getString("fnayearid"), 0);
			
			//月度
			if(mBudgetMove){
				int budgetperiodslist = periodsid;
				int spzCnt = 0;
				String[] dateArray = BudgetHandler.getBudgetPeriodArray(fnayearid, "1", budgetperiodslist);
				sql = "select count(DISTINCT requestid) cnt from FnaExpenseInfo "+
					" where status = 0 "+
					" and occurdate >= '"+StringEscapeUtils.escapeSql(dateArray[0])+"' "+
					" and occurdate <= '"+StringEscapeUtils.escapeSql(dateArray[1])+"' ";
				//new BaseBean().writeLog("月度："+sql);
				rs.executeSql(sql);
				if(rs.next()){
					spzCnt = Util.getIntValue(rs.getString("cnt"), 0);
				}
				spzCntText += SystemEnv.getHtmlLabelName(19398,user.getLanguage())+"："+spzCnt+"；";
			}
			
			//季度
			if(qBudgetMove && (periodsid>=3 && periodsid<=11)){
				int budgetperiodslist = 0;
				//结转第N季度
				if(periodsid>=3 && periodsid<=5){
					budgetperiodslist = 1;
				}else if(periodsid>=6 && periodsid<=8){
					budgetperiodslist = 2;
				}else if(periodsid>=9 && periodsid<=11){
					budgetperiodslist = 3;
				}
				int spzCnt = 0;
				String[] dateArray = BudgetHandler.getBudgetPeriodArray(fnayearid, "2", budgetperiodslist);
				sql = "select count(DISTINCT requestid) cnt from FnaExpenseInfo "+
					" where status = 0 "+
					" and occurdate >= '"+StringEscapeUtils.escapeSql(dateArray[0])+"' "+
					" and occurdate <= '"+StringEscapeUtils.escapeSql(dateArray[1])+"' ";
				//new BaseBean().writeLog("季度："+sql);
				rs.executeSql(sql);
				if(rs.next()){
					spzCnt = Util.getIntValue(rs.getString("cnt"), 0);
				}
				if(!"".equals(spzCntText)){
					spzCntText += "<br />";
				}
				spzCntText += SystemEnv.getHtmlLabelName(17495,user.getLanguage())+"："+spzCnt+"；";
			}
			
			//半年度
			if(hBudgetMove && (periodsid>=6 && periodsid<=11)){
				int budgetperiodslist = 0;
				//结转第N季度
				if(periodsid>=6 && periodsid<=11){
					budgetperiodslist = 1;
				}
				int spzCnt = 0;
				String[] dateArray = BudgetHandler.getBudgetPeriodArray(fnayearid, "3", budgetperiodslist);
				sql = "select count(DISTINCT requestid) cnt from FnaExpenseInfo "+
					" where status = 0 "+
					" and occurdate >= '"+StringEscapeUtils.escapeSql(dateArray[0])+"' "+
					" and occurdate <= '"+StringEscapeUtils.escapeSql(dateArray[1])+"' ";
				//new BaseBean().writeLog("半年度："+sql);
				rs.executeSql(sql);
				if(rs.next()){
					spzCnt = Util.getIntValue(rs.getString("cnt"), 0);
				}
				if(!"".equals(spzCntText)){
					spzCntText += "<br />";
				}
				spzCntText += SystemEnv.getHtmlLabelName(19483,user.getLanguage())+"："+spzCnt+"；";
			}
		}
		
	}
}
%>{"spzCntText":<%=JSONObject.quote(spzCntText) %>}