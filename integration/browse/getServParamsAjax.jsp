
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,weaver.conn.*,com.weaver.integration.params.*" %>
<%@ page import="com.weaver.integration.datesource.*" %>
<%@ page import="com.weaver.integration.log.*" %>

<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.*" %>
<%
	
	String regServiceId = Util.null2String(request.getParameter("regservice"));
	String poolid = Util.null2String(request.getParameter("poolid"));
	String sql = "select funname from sap_service where id="+regServiceId;
	RecordSet rs = new RecordSet();
	rs.execute(sql);
	String funnname = "";
	String message = "";
	boolean flag = false;
	if(rs.next()) {
		funnname = rs.getString("funname");
		SAPInterationOutUtil sou = new SAPInterationOutUtil();
		ServiceParamsUtil.delParamsByServId(regServiceId);
		LogInfo li = new LogInfo();
		List list = ServiceParamsUtil.changeTypeBySAPAllBean(sou.getALLParamsByFunctionName(poolid, funnname, li));
		boolean temp = ServiceParamsUtil.insertServiceParams(list, regServiceId);
		boolean temp2= ServiceParamsUtil.insertServiceCompParms(poolid, funnname, regServiceId, li);
		if(temp&&temp2) {
			flag  = true;
			message=SystemEnv.getHtmlLabelName(30680 ,user.getLanguage());
		}else {
			message =SystemEnv.getHtmlLabelName(30682 ,user.getLanguage())+ ","+SystemEnv.getHtmlLabelName(30683 ,user.getLanguage());
		}
	}else {
		message = SystemEnv.getHtmlLabelName(30684 ,user.getLanguage())+"SAP-ABAP"+ SystemEnv.getHtmlLabelName(30686 ,user.getLanguage());
	}
	
	JSONObject jsa = new JSONObject();
	jsa.accumulate("flag", flag);
	jsa.accumulate("message", message);
    out.clear();
    out.println(jsa);
	
%>