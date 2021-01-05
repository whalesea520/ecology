
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="ApproveParameter" class="weaver.workflow.request.ApproveParameter" scope="session"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>

<%

FileUpload fu = new FileUpload(request);

String sql = "";
String src = "";
String iscreate = "";
int requestid = 0;
int workflowid = 0;
String workflowtype = "";
int isremark = 0;
int formid = 0;
int isbill = 0;
int billid = 0;
int nodeid = 0;
String nodetype = "";
String requestname = "";
String requestlevel = "";
String messageType = "";
String remark = "";
String redirectUrl = "";

int templateId = Util.getIntValue(fu.getParameter("templateID"));
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;

src = Util.null2String(fu.getParameter("src"));
iscreate = Util.null2String(fu.getParameter("iscreate"));
requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
workflowtype = Util.null2String(fu.getParameter("workflowtype"));
isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
formid = Util.getIntValue(fu.getParameter("formid"),-1);
isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
billid = Util.getIntValue(fu.getParameter("billid"),-1);
nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
nodetype = Util.null2String(fu.getParameter("nodetype"));
requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
remark = Util.null2String(fu.getParameter("remark"));
/**
if(src.equals("submit")&&iscreate.equals("1")) {//新建request时
	workflowid=ApproveParameter.getWorkflowid();
	formid=ApproveParameter.getFormid();
	requestname=ApproveParameter.getRequestname();
	nodeid=ApproveParameter.getNodeid();
	nodetype=ApproveParameter.getNodetype();
}
**/
isbill=1;

if( "".equals(src) || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || "".equals(nodetype) ) {
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

boolean logstatus = RequestManager.saveRequestLog() ;




//创建时
if(src.equals("submit")&&iscreate.equals("1")) {
	rs2.executeSql("UPDATE BillProjTemplateApprove SET projTemplateId="+templateId+" WHERE requestid="+requestid+"");
	if( RequestManager.getNextNodetype().equals("3")) {
		rs2.executeSql("UPDATE Prj_Template SET status='1' WHERE id="+templateId+"");
		//response.sendRedirect(ApproveParameter.getGopage());
		//out.println("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
		
		
		%><%@ include file="/workflow/request/RedirectPage.jsp" %> 
	     <%
		
		
		return;
	}else{
		rs2.executeSql("UPDATE Prj_Template SET status='2' WHERE id="+templateId+"");
		//response.sendRedirect(ApproveParameter.getGopage());
		//out.println("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
		%><%@ include file="/workflow/request/RedirectPage.jsp" %> 
	     <%
		return;
	}
}


if(src.equals("save")&&iscreate.equals("1")) {
	%>
	<%@ include file="/workflow/request/RedirectPage.jsp" %> 
    <%
	//out.println("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
	return;
}


if(src.equals("save")&&iscreate.equals("0")) {
	%><%@ include file="/workflow/request/RedirectPage.jsp" %> 
    <%
	//out.println("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
	return;
}

if(src.equals("delete")&&iscreate.equals("0")) {
	out.println("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
	return;
}


/*提交时*/
if(src.equals("submit")&&iscreate.equals("0")){
	/*审批通过时*/
	if( RequestManager.getNextNodetype().equals("3")) {
		rs.executeSql("SELECT projTemplateId FROM BillProjTemplateApprove WHERE requestid="+requestid+"");
		if(rs.next()){
			rs2.executeSql("UPDATE Prj_Template SET status='1' WHERE id="+rs.getInt("projTemplateId")+"");
		}
		//out.println("<script type='text/javascript'>self.close();this.opener.document.location.reload();</script>");
		//out.println("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
		
		%><%@ include file="/workflow/request/RedirectPage.jsp" %> 
	     <%
		return;
	}
	/*退回提交时*/
	if( RequestManager.getNextNodetype().equals("1")) {
		rs.executeSql("SELECT projTemplateId FROM BillProjTemplateApprove WHERE requestid="+requestid+"");
		if(rs.next()){
			rs2.executeSql("UPDATE Prj_Template SET status='2' WHERE id="+rs.getInt("projTemplateId")+"");
		}
		//out.println("<script type='text/javascript'>self.close();this.opener.document.location.reload();</script>");
		%>
	<%@ include file="/workflow/request/RedirectPage.jsp" %> 
	<%
		return;
	}
}



/*退回处理*/
if(src.equals("reject")&&iscreate.equals("0")){
	if( RequestManager.getNextNodetype().equals("0")) {
		rs.executeSql("SELECT projTemplateId FROM BillProjTemplateApprove WHERE requestid="+requestid+"");
		if(rs.next()){
			rs2.executeSql("UPDATE Prj_Template SET status='3' WHERE id="+rs.getInt("projTemplateId")+"");
		}
		//out.println("<script type='text/javascript'>self.close();this.opener.document.location.reload();</script>");
	%>
	<%@ include file="/workflow/request/RedirectPage.jsp" %> 
	<%
		return;
	}
}


/*归档处理*/
if( RequestManager.getNextNodetype().equals("3")) {
	rs.executeSql("SELECT projTemplateId FROM BillProjTemplateApprove WHERE requestid="+requestid+"");
	if(rs.next()){
		rs2.executeSql("UPDATE Prj_Template SET status='1' WHERE id="+rs.getInt("projTemplateId")+"");
	}
	//out.println("<script type='text/javascript'>self.close();this.opener.document.location.reload();</script>");
	%>
	<%@ include file="/workflow/request/RedirectPage.jsp" %> 
	<%
 
	return;
}

//response.sendRedirect(redirectUrl);
%>
<%@ include file="/workflow/request/RedirectPage.jsp" %>