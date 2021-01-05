
<%@page import="weaver.fna.interfaces.thread.FnaBudgetBatchOpThread"%>
<%@page import="weaver.fna.maintenance.FnaYearsPeriodsComInfo"%>
<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.general.FnaSynchronized"%><%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%><%@page import="java.lang.Exception"%><%@page import="weaver.systeminfo.SystemEnv"%><%@page import="weaver.fna.budget.FnaBudgetUtil"%><%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%><%@page import="weaver.fna.budget.BudgetHandler"%><%@page import="weaver.fna.maintenance.FnaBudgetControl"%><%@page import="weaver.hrm.company.CompanyComInfo"%><%@page import="weaver.hrm.company.SubCompanyComInfo"%><%@page import="weaver.hrm.company.DepartmentComInfo"%><%@page import="weaver.hrm.resource.ResourceComInfo"%><%@page import="weaver.conn.RecordSet"%><%@page import="org.apache.commons.lang.StringEscapeUtils"%><%@page import="java.text.DecimalFormat"%><%@ page import="weaver.fna.maintenance.FnaBudgetInfo" %><%@page import="java.text.SimpleDateFormat"%><%@page import="weaver.general.BaseBean"%><%@page import="weaver.general.TimeUtil"%><%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="java.util.*,java.sql.Timestamp" %><%@ page import="weaver.general.GCONST" %><%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%><%
BaseBean bb = new BaseBean();
String result = "";

User user = HrmUserVarify.getUser (request , response) ;

boolean effect = HrmUserVarify.checkUserRight("BudgetDraftBatchEffect:effect", user);//预算草稿批量生效
boolean imp = HrmUserVarify.checkUserRight("BudgetDraftBatchImport:imp", user);//预算草稿批量导入

RecordSet rs = new RecordSet();


String op = Util.null2String(request.getParameter("op")).trim();

String fnayearId = Util.null2String(request.getParameter("fnayearId")).trim();
String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();

request.getSession().removeAttribute("index:"+_guid1);
request.getSession().removeAttribute("isDone:"+_guid1);

if("update".equals(op) && effect){
	String fnaBudgetInfoIds = Util.null2String(request.getParameter("fnaBudgetInfoIds")).trim();
	boolean isAll = "1".equals(request.getParameter("isAll"));
	String sql_qryAllId = (String)request.getSession().getAttribute("FnaBudgetBatchInner.jsp_sql_qryAllId_"+_guid1);
	
	FnaBudgetBatchOpThread fnaBudgetBatchOpThread = new FnaBudgetBatchOpThread();

	fnaBudgetBatchOpThread.setUser(user);
	fnaBudgetBatchOpThread.setGuid(_guid1);

	fnaBudgetBatchOpThread.setFnayearId(fnayearId);
	fnaBudgetBatchOpThread.setFnaBudgetInfoIds(fnaBudgetInfoIds);
	fnaBudgetBatchOpThread.setAll(isAll);
	fnaBudgetBatchOpThread.setSql_qryAllId(sql_qryAllId);
	

	fnaBudgetBatchOpThread.setIsprint(false);


	Thread thread_1 = new Thread(fnaBudgetBatchOpThread);
	thread_1.start();
	
	
	
}else if("delete".equals(op) && (effect || imp)){
	FnaYearsPeriodsComInfo fnaYearsPeriodsComInfo = new FnaYearsPeriodsComInfo();
	int periodStatus = Util.getIntValue(fnaYearsPeriodsComInfo.get_status(fnayearId), 0);
	if(periodStatus == -1){
		request.getSession().setAttribute("errorInfo:"+_guid1, SystemEnv.getHtmlLabelName(129921,user.getLanguage()));//预算期间已关闭，不可提交
		request.getSession().setAttribute("isDone:"+_guid1, "true");
		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(129921,user.getLanguage()))+"}");//预算期间已关闭，不可提交
		out.flush();
		return;
	} 

	RecordSet rs1 = new RecordSet();
	String fnaBudgetInfoIds = Util.null2String(request.getParameter("fnaBudgetInfoIds")).trim();
	if(!"".equals(fnaBudgetInfoIds)){
		String[] fnaBudgetInfoIdsArray = fnaBudgetInfoIds.split(",");
		int fnaBudgetInfoIdsArrayLen = fnaBudgetInfoIdsArray.length;
		for(int i=0;i<fnaBudgetInfoIdsArrayLen;i++){
			int delFnaBudgetInfoId = Util.getIntValue(fnaBudgetInfoIdsArray[i]);
			//只允许删除草稿版本
			rs1.executeSql("select 1 from FnaBudgetInfo where status=0 and id = "+delFnaBudgetInfoId);
			if(rs1.next()){
				BudgetHandler.deleteFnaBudgetInfoAndFnaBudgetInfoDetail(delFnaBudgetInfoId);
			}
		}
		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(20461,user.getLanguage()))+"}");//删除成功
		out.flush();
		return;
		
	}else{
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(32568,user.getLanguage()))+"}");//请选择要删除的记录!
		out.flush();
		return;
	}
	
}else{
	result = SystemEnv.getHtmlLabelName(34115,user.getLanguage());//"请正确提交数据！"
}







%><%=result %>