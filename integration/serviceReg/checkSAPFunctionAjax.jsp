
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util, com.weaver.integration.datesource.*,com.weaver.integration.log.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.*,com.sap.mw.jco.JCO" %>
<%
	String poolid = Util.null2String(request.getParameter("poolid"));
	String funName = Util.null2String(request.getParameter("funName"));
	SAPInterationOutUtil sou = new SAPInterationOutUtil();
	boolean flag = false;
	LogInfo li = new LogInfo();
	JSONObject jsa = new JSONObject();
	JCO.Function fun = sou.getSAPFunction(poolid, funName, li);
	String message = "";
	if(fun == null) {
		message = SystemEnv.getHtmlLabelName(30626,user.getLanguage());//"该函数不存在,请提供正确的函数！";
	}else {
		flag = true;
		message = SystemEnv.getHtmlLabelName(30628,user.getLanguage());
	}
	jsa.accumulate("flag", flag);
	jsa.accumulate("message", message);
    out.clear();
    out.println(jsa);

%>