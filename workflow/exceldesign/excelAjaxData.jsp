
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="ExcelLayoutManager" class="weaver.workflow.exceldesign.ExcelLayoutManager" scope="page" />
<jsp:useBean id="HtmlLayoutOperate" class="weaver.workflow.exceldesign.HtmlLayoutOperate" scope="page" />
<jsp:useBean id="FormatFieldValue" class="weaver.workflow.exceldesign.FormatFieldValue" scope="page" />
<jsp:useBean id="FinancialElement" class="weaver.workflow.field.FinancialElement" scope="page" />
<%
String src=Util.null2String(request.getParameter("src"));
if("getMainFields".equals(src)){
	ExcelLayoutManager.setRequest(request);
	JSONObject json = new org.json.JSONObject();
	json =ExcelLayoutManager.getMainFields();
	out.print(json);
}else if("getDetailFields".equals(src)){
	ExcelLayoutManager.setRequest(request);
	JSONObject json = new org.json.JSONObject();
	json = ExcelLayoutManager.getDetailFields();
	out.print(json);
}else if("getWfNodes".equals(src)){
	ExcelLayoutManager.setRequest(request);
	JSONObject json = new org.json.JSONObject();
	json = ExcelLayoutManager.getWfNodes();
	out.print(json);
}else if("formatToDate".equals(src)){
	String formatVal=FormatFieldValue.FormatToDate(Util.null2String(request.getParameter("realVal")),Util.getIntValue(request.getParameter("formatPattern"),-1));
	out.print(formatVal);
}else if("formatToTime".equals(src)){
	String formatVal=FormatFieldValue.FormatToTime(Util.null2String(request.getParameter("realVal")),Util.getIntValue(request.getParameter("formatPattern"),-1));
	out.print(formatVal);
}else if("formatToPercent".equals(src)){
	String formatVal=FormatFieldValue.FormatToPercent(Util.null2String(request.getParameter("realVal")),Util.getIntValue(request.getParameter("decimals"),-1));
	out.print(formatVal);
}else if("formatToScience".equals(src)){
	String formatVal=FormatFieldValue.FormatToScience(Util.null2String(request.getParameter("realVal")),Util.getIntValue(request.getParameter("decimals"),-1));
	out.print(formatVal);
}else if("formatToSpecial".equals(src)){
	String formatVal=FormatFieldValue.FormatToSpecial(Util.null2String(request.getParameter("realVal")),Util.getIntValue(request.getParameter("formatPattern"),-1));
	out.print(formatVal);
}else if("formatToMoneyUpper".equals(src)){
	String formatVal=FormatFieldValue.FormatToMoneyUpper(Util.null2String(request.getParameter("realVal")));
	out.print(formatVal);
}else if("transFinancialVal".equals(src)){
	String fieldval=request.getParameter("fieldval");
	char[] valArr=FinancialElement.getValCharArr(fieldval);
	out.print(new String(valArr));
}else if("getHistoryLayout".equals(src)){
	String wfid = Util.null2String(request.getParameter("wfid"));
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	int layouttype = Util.getIntValue(request.getParameter("layouttype"));
	int languageid = Util.getIntValue(request.getParameter("languageid"));
	List historylist = HtmlLayoutOperate.getHistoryLayout(wfid, nodeid, layouttype, languageid);
	JSONArray result = new net.sf.json.JSONArray();
	out.print(result.fromObject(historylist));
}else if("deleteLayout".equals(src)){
	int layoutid = Util.getIntValue(request.getParameter("layoutid"));
	String result = HtmlLayoutOperate.deleteLayout(layoutid);
	out.print(result);
}else if("setLayoutToActive".equals(src)){
	int wfid = Util.getIntValue(request.getParameter("wfid"));
	int nodeid = Util.getIntValue(request.getParameter("nodeid"));
	int layouttype = Util.getIntValue(request.getParameter("layouttype"));
	int layoutid = Util.getIntValue(request.getParameter("layoutid"));
	String result = HtmlLayoutOperate.setLayoutToActive(wfid, nodeid, layouttype, layoutid);
	out.print(result);
}else if("saveChooseLayout".equals(src)){
	HtmlLayoutOperate.setRequest(request);
	String result = HtmlLayoutOperate.saveLayout_choose();
	out.print(result);
}

%>