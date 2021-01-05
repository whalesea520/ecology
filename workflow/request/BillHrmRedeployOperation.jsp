<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.file.FileUpload" %>


<%
FileUpload fu = new FileUpload(request);
//add by lvyi 2015-04-22
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码

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
    out.print("<script>wfforward('/notice/RequestError.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
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
			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&message=1');</script>");
        return ;
    }
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;
if( RequestManager.getNextNodetype().equals("3") ) {
	rs.executeSql(" select * from Bill_HrmRedeploy where id = " + billid ) ;
	if( rs.next() ) {
		String resource_n = Util.null2String(rs.getString("resource_n"));
		String redeploydate =    Util.null2String(rs.getString("redeploydate"));
		String redeployreason = Util.null2String(rs.getString("redeployreason"));
		String oldjob = Util.null2String(rs.getString("oldjob")) ;       
		String oldjoblevel = Util.null2String(rs.getString("oldjoblevel")) ;	
		String newjob = Util.null2String(rs.getString("newjob")) ;	
		String newjoblevel = Util.null2String(rs.getString("newjoblevel")) ;	
		String ischangesalary = Util.null2String(rs.getString("ischangesalary")) ;
		
		String olddepartmentid = "";
		String oldmanagerid = "";
		rs.executeSql("select departmentid, managerid, seclevel, managerstr  from HrmResource where id=" + Util.getIntValue(resource_n));
		if(rs.next()){
			olddepartmentid = rs.getString("departmentid");
			oldmanagerid = rs.getString("managerid");
		}
		String oldsubcompanyid1 = "-1";
		rs.executeSql("select subcompanyid1 from HrmDepartment where id=" + Util.getIntValue(olddepartmentid));
		if(rs.next()){
			oldsubcompanyid1 = rs.getString("subcompanyid1");
		}
		
		String departmentid = "";
		rs.executeSql("select jobdepartmentid from HrmJobTitles where id=" + Util.getIntValue(newjob));
		if(rs.next()){
			departmentid = rs.getString("jobdepartmentid");
		}
		String subcompanyid1 = "-1";
		rs.executeSql("select subcompanyid1 from HrmDepartment where id=" + Util.getIntValue(departmentid));
		if(rs.next()){
			subcompanyid1 = rs.getString("subcompanyid1");
		}
		char separator = Util.getSeparator() ;  
		String para = resource_n + separator + redeploydate + separator + redeployreason + separator + oldjob + separator + oldjoblevel + separator + newjob + separator + newjoblevel + separator + "" + separator + "4" + separator + ischangesalary
		+separator+oldmanagerid+separator+oldmanagerid+separator+olddepartmentid+separator+departmentid+separator+oldsubcompanyid1+separator+subcompanyid1+separator+user.getUID();
        rs.executeProc("HrmResource_Redeploy",para);
	}
}
 
%>
 <%@ include file="/workflow/request/RedirectPage.jsp" %> 
			 