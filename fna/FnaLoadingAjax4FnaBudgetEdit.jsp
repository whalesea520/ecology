<%@page import="java.util.List"%>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.interfaces.thread.FnaThreadResult"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
boolean isDone = true;
String infoStr = "";
String resultJson = "{}";
User user = HrmUserVarify.getUser(request, response);
if(user == null){
	isDone = true;
}else{
	String guid = Util.null2String(request.getParameter("guid")).trim();
	FnaThreadResult fnaThreadResult = new FnaThreadResult();
	isDone = "true".equalsIgnoreCase((String)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_isDone"));
	infoStr = Util.null2String((String)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_infoStr")).trim();
	resultJson = Util.null2String((String)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_resultJson")).trim();
	if(isDone){
		List<String> mbudgetvalues = null;
		List<String> msubject3names = null;
		List<String> qbudgetvalues = null;
		List<String> qsubject3names = null;
		List<String> hbudgetvalues = null;
		List<String> hsubject3names = null;
		List<String> ybudgetvalues = null;
		List<String> ysubject3names = null;
		List<String> budgetValues = null;
		List<String> subjectNames = null;
		
		String _subject_action = Util.null2String((String)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_subject_action")).trim();
		if("setAttribute".equals(_subject_action)){
			mbudgetvalues = (List<String>)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_mbudgetvalues");
			msubject3names = (List<String>)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_msubject3names");
			qbudgetvalues = (List<String>)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_qbudgetvalues");
			qsubject3names = (List<String>)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_qsubject3names");
			hbudgetvalues = (List<String>)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_hbudgetvalues");
			hsubject3names = (List<String>)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_hsubject3names");
			ybudgetvalues = (List<String>)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_ybudgetvalues");
			ysubject3names = (List<String>)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_ysubject3names");
			budgetValues = (List<String>)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_budgetValues");
			subjectNames = (List<String>)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_subjectNames");
		}
		
		fnaThreadResult.removeInfoByGuid(guid);

		if("setAttribute".equals(_subject_action)){
			session.setAttribute("FnaBudgetEditSaveFnaAjax.jsp_mbudgetvalues_"+guid, mbudgetvalues); 
			session.setAttribute("FnaBudgetEditSaveFnaAjax.jsp_msubject3names_"+guid, msubject3names);
			session.setAttribute("FnaBudgetEditSaveFnaAjax.jsp_qbudgetvalues_"+guid, qbudgetvalues);
			session.setAttribute("FnaBudgetEditSaveFnaAjax.jsp_qsubject3names_"+guid, qsubject3names);
			session.setAttribute("FnaBudgetEditSaveFnaAjax.jsp_hbudgetvalues_"+guid, hbudgetvalues);
			session.setAttribute("FnaBudgetEditSaveFnaAjax.jsp_hsubject3names_"+guid, hsubject3names);
			session.setAttribute("FnaBudgetEditSaveFnaAjax.jsp_ybudgetvalues_"+guid, ybudgetvalues);
			session.setAttribute("FnaBudgetEditSaveFnaAjax.jsp_ysubject3names_"+guid, ysubject3names);
			session.setAttribute("FnaBudgetEditSaveFnaAjax.jsp_budgetValues_"+guid, budgetValues);
			session.setAttribute("FnaBudgetEditSaveFnaAjax.jsp_subjectNames_"+guid, subjectNames);
		}else if("removeAttribute".equals(_subject_action)){
			session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_mbudgetvalues_"+guid); 
			session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_msubject3names_"+guid);
			session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_qbudgetvalues_"+guid);
			session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_qsubject3names_"+guid);
			session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_hbudgetvalues_"+guid);
			session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_hsubject3names_"+guid);
			session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_ybudgetvalues_"+guid);
			session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_ysubject3names_"+guid);
		}
	}
}
if("".equals(resultJson)){
	resultJson = "{}";
}
%><%="{\"flag\":"+isDone+",\"infoStr\":"+JSONObject.quote(infoStr)+",\"resultJson\":"+resultJson+"}" %>