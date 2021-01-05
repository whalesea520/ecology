<%--和原来的工作流后台操作页面基本上一样，增加了返回值来配合其他页面的工作--%>
<%@ page import="weaver.general.Util,java.net.*,
                 weaver.hrm.User"%>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
String src = Util.null2String(request.getParameter("src"));
String iscreate = Util.null2String(request.getParameter("iscreate"));
int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
int isremark = Util.getIntValue(request.getParameter("isremark"),-1);
int formid = Util.getIntValue(request.getParameter("formid"),-1);
int isbill = Util.getIntValue(request.getParameter("isbill"),-1);
int billid = Util.getIntValue(request.getParameter("billid"),-1);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),-1);
String nodetype = Util.null2String(request.getParameter("nodetype"));
String requestname = Util.null2String(request.getParameter("requestname"));
String requestlevel = Util.null2String(request.getParameter("requestlevel"));
String remark = Util.null2String(request.getParameter("remark"));

//从参数中获得用户信息，因为客户端提交的POST请求并不支持session
int userid = Util.getIntValue(request.getParameter("userid"));
String logintype = Util.null2String(request.getParameter("logintype"));
User user = new User();
user.setUid(userid);
user.setLogintype(logintype);


if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    out.print("3");
    return ;
}

RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(request) ;
RequestManager.setUser(user) ;


boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {
        out.print("3");
        return ;
    }
    else {
        out.print("3");
        return ;
    }
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
    out.print("");
    return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;
out.print("0");
%>