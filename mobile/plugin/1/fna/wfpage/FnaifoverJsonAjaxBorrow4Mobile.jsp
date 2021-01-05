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

String poststr1  = Util.null2String(request.getParameter("poststr1")).trim();
String poststr2  = Util.null2String(request.getParameter("poststr2")).trim();
int requestid  = Util.getIntValue(request.getParameter("requestid"),0);//流程id
int workflowid  = Util.getIntValue(request.getParameter("workflowid"),0);//流程id

if(workflowid <= 0){
    FileUpload fu = new FileUpload(request,false);
    poststr1 = Util.null2String(fu.getParameter("poststr1")).trim();
    poststr2 = Util.null2String(fu.getParameter("poststr2")).trim();
    requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
    workflowid = Util.getIntValue(fu.getParameter("workflowid"), 0);
}

poststr1 = poststr1.replaceAll(",s,", "|");
poststr2 = poststr2.replaceAll(",s,", "|");

//new BaseBean().writeLog("111111111111111 poststr1="+poststr1);
//new BaseBean().writeLog("222222222222222 poststr2="+poststr2);

%><jsp:include page="/fna/wfPage/FnaifoverJsonAjaxBorrow.jsp" flush="true">
	<jsp:param name="poststr1" value="<%=poststr1%>" />
	<jsp:param name="poststr2" value="<%=poststr2%>" />
	<jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="workflowid" value="<%=workflowid%>" />
	<jsp:param name="isMobile" value="1" />
</jsp:include>