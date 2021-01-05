<%@page import="weaver.fna.interfaces.thread.FnaThreadResult"%>
<%@page import="weaver.fna.interfaces.thread.FnaBudgetEditSaveFnaThread"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.maintenance.FnaBudgetControl"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>

<%@page import="weaver.fna.general.FnaSynchronized"%><jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsDebug" class="weaver.conn.RecordSet" scope="page" />
<%
StringBuffer result = new StringBuffer();
String _guid1 = Util.null2String(request.getParameter("guid1")).trim();

FnaThreadResult fnaThreadResult = new FnaThreadResult();
fnaThreadResult.removeInfoByGuid(_guid1);

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	result.append("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(31374,user.getLanguage()))+"}");//登录超时,请清理IE缓存重新登录!
}else{
	boolean isSave = "true".equalsIgnoreCase(Util.null2String(request.getParameter("isSave")).trim());//是否是保存（包含，批准生效、提交审批）
	boolean isApprove = "true".equalsIgnoreCase(Util.null2String(request.getParameter("isApprove")).trim());//是否是批准生效
	boolean isSubmitApprove = "true".equalsIgnoreCase(Util.null2String(request.getParameter("isSubmitApprove")).trim());//是否是提交审批

	int organizationtype = Util.getIntValue(request.getParameter("organizationtype"), -1);//组织类型
	int organizationid = Util.getIntValue(request.getParameter("organizationid"), -1);//组织ID
	int budgetinfoid = Util.getIntValue(request.getParameter("budgetinfoid"), 0);//预算设置主表id
	int budgetperiods = Util.getIntValue(request.getParameter("budgetperiods"), 0);//预算年度id

	String _inputName_inputVal = Util.null2String(request.getParameter("_inputName_inputVal")).trim();

	String tabFeeperiod = Util.null2String(request.getParameter("tabFeeperiod")).trim();
	int qCount = Util.getIntValue(request.getParameter("qCount"), 0);
	String[] b3idArray = request.getParameterValues("b3id");
	String[] b2idArray = request.getParameterValues("b2id");
	String[] b1idArray = request.getParameterValues("b1id");

	
	List<String[]> mbudgetvalues = (List<String[]>)session.getAttribute("FnaBudgetEditSaveFnaAjax.jsp_mbudgetvalues_"+_guid1); 
	List<String> msubject3names = (List<String>)session.getAttribute("FnaBudgetEditSaveFnaAjax.jsp_msubject3names_"+_guid1);
	List<String[]> qbudgetvalues = (List<String[]>)session.getAttribute("FnaBudgetEditSaveFnaAjax.jsp_qbudgetvalues_"+_guid1);
	List<String> qsubject3names = (List<String>)session.getAttribute("FnaBudgetEditSaveFnaAjax.jsp_qsubject3names_"+_guid1);
	List<String[]> hbudgetvalues = (List<String[]>)session.getAttribute("FnaBudgetEditSaveFnaAjax.jsp_hbudgetvalues_"+_guid1);
	List<String> hsubject3names = (List<String>)session.getAttribute("FnaBudgetEditSaveFnaAjax.jsp_hsubject3names_"+_guid1);
	List<String[]> ybudgetvalues = (List<String[]>)session.getAttribute("FnaBudgetEditSaveFnaAjax.jsp_ybudgetvalues_"+_guid1);
	List<String> ysubject3names = (List<String>)session.getAttribute("FnaBudgetEditSaveFnaAjax.jsp_ysubject3names_"+_guid1);
	List<String[]> budgetValues = (List<String[]>)session.getAttribute("FnaBudgetEditSaveFnaAjax.jsp_budgetValues_"+_guid1);
	List<String> subjectNames = (List<String>)session.getAttribute("FnaBudgetEditSaveFnaAjax.jsp_subjectNames_"+_guid1);
	
	FnaBudgetEditSaveFnaThread fnaBudgetEditSaveFnaThread = new FnaBudgetEditSaveFnaThread();
	
	fnaBudgetEditSaveFnaThread.setGuid(_guid1);
	
	fnaBudgetEditSaveFnaThread.setUid(user.getUID());
	fnaBudgetEditSaveFnaThread.setLanguageId(user.getLanguage());
	fnaBudgetEditSaveFnaThread.setLoginType(user.getLogintype());
	
	fnaBudgetEditSaveFnaThread.setSave(isSave);
	fnaBudgetEditSaveFnaThread.setApprove(isApprove);
	fnaBudgetEditSaveFnaThread.setSubmitApprove(isSubmitApprove);
	
	fnaBudgetEditSaveFnaThread.setOrganizationtype(organizationtype);
	fnaBudgetEditSaveFnaThread.setOrganizationid(organizationid);
	fnaBudgetEditSaveFnaThread.setBudgetinfoid(budgetinfoid);
	fnaBudgetEditSaveFnaThread.setBudgetperiods(budgetperiods);
	
	fnaBudgetEditSaveFnaThread.set_inputName_inputVal(_inputName_inputVal);
	
	fnaBudgetEditSaveFnaThread.setTabFeeperiod(tabFeeperiod);
	fnaBudgetEditSaveFnaThread.setqCount(qCount);
	fnaBudgetEditSaveFnaThread.setB3idArray(b3idArray);
	fnaBudgetEditSaveFnaThread.setB2idArray(b2idArray);
	fnaBudgetEditSaveFnaThread.setB1idArray(b1idArray);

	fnaBudgetEditSaveFnaThread.setMbudgetvalues(mbudgetvalues);
	fnaBudgetEditSaveFnaThread.setMsubject3names(msubject3names);
	fnaBudgetEditSaveFnaThread.setQbudgetvalues(qbudgetvalues);
	fnaBudgetEditSaveFnaThread.setQsubject3names(qsubject3names);
	fnaBudgetEditSaveFnaThread.setHbudgetvalues(hbudgetvalues);
	fnaBudgetEditSaveFnaThread.setHsubject3names(hsubject3names);
	fnaBudgetEditSaveFnaThread.setYbudgetvalues(ybudgetvalues);
	fnaBudgetEditSaveFnaThread.setYsubject3names(ysubject3names);
	fnaBudgetEditSaveFnaThread.setBudgetValues(budgetValues);
	fnaBudgetEditSaveFnaThread.setSubjectNames(subjectNames);
	
	fnaBudgetEditSaveFnaThread.setIsprint(false);

    Thread thread_1 = new Thread(fnaBudgetEditSaveFnaThread);
    thread_1.start();
	
}












































%><%=result.toString() %>