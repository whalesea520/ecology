
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%><%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
StringBuffer result = new StringBuffer();
int oldBudgetinfoid = Util.getIntValue(request.getParameter("budgetinfoid"), 0);
String tabFeeperiod = Util.null2String(request.getParameter("tabFeeperiod")).trim();
String fromPage = Util.null2String(request.getParameter("fromPage")).trim();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(31374,user.getLanguage()))+"}");//登录超时,请清理IE缓存重新登录!
	out.flush();
	return;
}else if(oldBudgetinfoid > 0){
	RecordSet rs = new RecordSet();
	boolean canEditSp1 = HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user);
	int budgetperiods = 0;
	int organizationid = 0;
	int organizationtype = 0;
	if(canEditSp1){
		rs.executeSql("select budgetperiods, budgetorganizationid, organizationtype from FnaBudgetInfo where status=2 and id = "+oldBudgetinfoid);
		if(rs.next()){
			budgetperiods = Util.getIntValue(rs.getString("budgetperiods"), 0);
			organizationid = Util.getIntValue(rs.getString("budgetorganizationid"), 0);
			organizationtype = Util.getIntValue(rs.getString("organizationtype"), 0);
		}else{
			canEditSp1 = false;
		}
		
		if(canEditSp1){
			String sql = "select count(*) cnt from FnaYearsPeriods where id = "+budgetperiods+" and status = 1 ";
			rs.executeSql(sql);
			if(!(rs.next() && rs.getInt("cnt") == 1)){
				canEditSp1 = false;
			}
		}
	
		if(canEditSp1){
			if(!FnaBudgetInfoComInfo.getSupOrgIdHaveEnableFnaBudgetRevision(organizationid+"", organizationtype+"", budgetperiods+"")){
				canEditSp1 = false;
			}
		}
	}
	
	if(canEditSp1){
		int newBudgetinfoid = BudgetHandler.copyeFnaBudgetInfo2Status0(oldBudgetinfoid, user, true);
		if(newBudgetinfoid > 0){
			String hrefParam = "?organizationtype="+organizationtype+"&organizationid="+organizationid+"&budgetinfoid="+newBudgetinfoid+"&budgetperiods="+budgetperiods+
					"&status=0&revision=0&guid1=&tabFeeperiod="+tabFeeperiod;
			String locationHref = "/fna/budget/FnaBudgetViewInner1.jsp"+hrefParam;
			if("FnaBudgetHistoryView".equalsIgnoreCase(fromPage)){
				locationHref = "/fna/budget/FnaBudgetView.jsp"+hrefParam;
			}
			out.println("{\"flag\":true,\"msg\":"+JSONObject.quote("")+",\"locationHref\":"+JSONObject.quote(locationHref)+"}");//成功
			out.flush();
			return;
		}else{
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(126817,user.getLanguage()))+"}");//生成草稿版本失败
			out.flush();
			return;
		}
	}else{
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(126816,user.getLanguage()))+"}");//不能进行该操作
		out.flush();
		return;
	}
	
}else{
	out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(34115,user.getLanguage()))+"}");//"请正确提交数据！"
	out.flush();
	return;
}
















































%>