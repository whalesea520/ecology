<%@page import="weaver.file.FileUpload"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.fna.maintenance.FnaBorrowAmountControl"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String _____guid1 = Util.null2String(request.getParameter("_____guid1")).trim();
int jklc = Util.getIntValue(request.getParameter("jklc"), -1);
int dnxh = Util.getIntValue(request.getParameter("dnxh"), -1);
int requestid = Util.getIntValue(request.getParameter("requestid"));

if(jklc <= 0 && dnxh <= 0){
    FileUpload fu = new FileUpload(request,false);
    _____guid1 = Util.null2String(fu.getParameter("_____guid1")).trim();
    jklc = Util.getIntValue(fu.getParameter("jklc"), 0);
    dnxh = Util.getIntValue(fu.getParameter("dnxh"), 0);
    requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
}

%><jsp:include page="/fna/wfPage/getBorrowRequestInfo.jsp" flush="true">
	<jsp:param name="_____guid1" value="<%=_____guid1%>" />
	<jsp:param name="jklc" value="<%=jklc%>" />
	<jsp:param name="dnxh" value="<%=dnxh%>" />
	<jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="isMobile" value="1" />
</jsp:include>