<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String poststr  = Util.null2String(request.getParameter("poststr")).trim();//科目+报销类型+报销单位+报销日期+实报金额
int requestid  = Util.getIntValue(request.getParameter("requestid"),0);
int workflowid  = Util.getIntValue(request.getParameter("workflowid"),0);

if("".equals(poststr) && requestid <= 0 && workflowid <= 0){
    FileUpload fu = new FileUpload(request,false);
    poststr = Util.null2String(fu.getParameter("poststr")).trim();
    requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
    workflowid = Util.getIntValue(fu.getParameter("workflowid"), 0);
}

//由于手机版做了特殊处理，不能使用|等字符传参，故使用了,s,替换了|进行传参，此处需要将,s,替换成|以便后续业务逻辑识别
poststr = poststr.replaceAll(",s,", "|");

%><jsp:include page="/fna/budget/FnaShareifoverJsonAjax.jsp" flush="true">
	<jsp:param name="poststr" value="<%=poststr%>" />
	<jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="workflowid" value="<%=workflowid%>" />
	<jsp:param name="isMobile" value="1" />
</jsp:include>