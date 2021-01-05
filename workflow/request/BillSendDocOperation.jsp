<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SendDoc" class="weaver.docs.senddoc.SendDoc" scope="page" />
<jsp:useBean id="OpenSendDoc" class="weaver.docs.senddoc.OpenSendDoc" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />


<%

Calendar todaycal = Calendar.getInstance ();
String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
  Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
  Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;


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
String requestname = Util.fromScreen(request.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(request.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(request.getParameter("remark"));

if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
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
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = RequestManager.saveRequestInfo() ;
rs.executeSql("update bill_SendDoc set subject='"+requestname+"' where id="+billid);
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;

if(RequestManager.getNextNodetype().equals("3")&&OpenSendDoc.isOpen()) {
  String separator="||";   //作为分隔符
  String systemIps="";    //各个系统的地址
  String sqlStr="select systemIds from bill_SendDoc where id="+billid;
  rs.executeSql(sqlStr) ;
  if (rs.next()){
      systemIps=Util.null2String(rs.getString("systemIds"));
      SendDoc.send(""+billid,separator,systemIps);
  }
}

	//response.sendRedirect("/workflow/request/RequestView.jsp");
	out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
%>