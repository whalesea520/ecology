<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.file.FileUpload" %>
<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;


String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));

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
RequestManager.setRequest(fu) ;
RequestManager.setUser(user) ;
//add by chengfeng.han 2011-7-28 td20647 
int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
RequestManager.setIsagentCreater(isagentCreater);
RequestManager.setBeAgenter(beagenter);
//end
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {
        String message=RequestManager.getMessage();
        if(!"".equals(message)){
			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }
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

char flag = 2; 
String updateclause = "" ;
// add record into bill_CptApplyDetail
if( src.equals("save") || src.equals("submit") ) {      // 修改细表和主表信息
	if( !iscreate.equals("1") ) RecordSet.executeSql("delete from bill_CptRequireDetail where cptrequireid =" + billid);
    else {
        requestid = RequestManager.getRequestid() ;
        billid = RequestManager.getBillid() ;
    }

	int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
	float buynumbers =0;
	
	for(int i=0;i<rowsum;i++) {		
		int cpttype = Util.getIntValue(Util.null2String(fu.getParameter("node_"+i+"_cpttype")),0);
		int cptid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+i+"_cptid")),0);
		float number = Util.getFloatValue(fu.getParameter("node_"+i+"_number"),0);
		if (number <= 0) continue;
		float unitprice = Util.getFloatValue(fu.getParameter("node_"+i+"_unitprice"),0);
		String needdate = Util.null2String(fu.getParameter("node_"+i+"_needdate"));
		String purpose = Util.null2String(fu.getParameter("node_"+i+"_purpose"));
		String cptdesc = Util.null2String(fu.getParameter("node_"+i+"_cptdesc"));
		float buynumber = Util.getFloatValue(fu.getParameter("node_"+i+"_buynumber"),0);
		float adjustnumber = Util.getFloatValue(fu.getParameter("node_"+i+"_adjustnumber"),0);
		float fetchnumber = Util.getFloatValue(fu.getParameter("node_"+i+"_fetchnumber"),0);
		
		if(number!=0){
			String para = ""+billid+flag+cpttype+flag+cptid+flag+number+flag+unitprice+flag+needdate+flag+purpose+flag+cptdesc+flag+buynumber+flag+adjustnumber+flag+fetchnumber;
			RecordSet.executeProc("bill_CptRequireDetail_Insert",para);
		}
		buynumbers += buynumber;		
	}					
	updateclause += " set buynumbers = "+buynumbers+" ";
	updateclause="update bill_CptRequireMain "+updateclause+" where id = "+billid;
	//out.print(updateclause);
	RecordSet.executeSql(updateclause);
}

boolean logstatus = RequestManager.saveRequestLog() ;

//response.sendRedirect("/workflow/request/RequestView.jsp");
 
%>
 <%@ include file="/workflow/request/RedirectPage.jsp" %> 