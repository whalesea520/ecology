 
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@page import="weaver.workflow.workflow.WFManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.file.FileUpload" %>
<%
FileUpload fu = new FileUpload(request);
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
int  createrid=Util.getIntValue(fu.getParameter("users"));
String remark = Util.null2String(fu.getParameter("remark"));
String from=Util.null2String(fu.getParameter("from"));

if(from.equals("1") || from.equals("2")){
	WFManager wfManager = new WFManager();
	wfManager.setWfid(workflowid);
	wfManager.getWfInfo();
	messageType = wfManager.getSmsAlertsType();	
}

if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}

if (from.equals("1")||from.equals("2"))
{
rs1.execute("select requestname from workflow_requestbase where requestid="+requestid);
rs1.next();
requestname=rs1.getString(1);
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
if (from.equals("1"))
{
User users=new User();
users.setUid(createrid);
users.setLogintype("1");
users.setLanguage(user.getLanguage());
RequestManager.setUser(users) ;
}
else
{
RequestManager.setUser(user) ;
}

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

/*退回处理*/
if( RequestManager.getNextNodetype().equals("0")) {
rs.execute("select * from workPlanGroup where requestId="+requestid);
if (rs.next())
{
String id=rs.getString("id");
rs1.execute("update workPlanGroup set status='7' where requestId="+requestid);
rs1.execute("update workPlan set status='7' where groupId="+id);
rs1.execute("update HrmPerformancePlanDown set status='0' where planId in (select id from workPlan where groupId="+id+")");
}

}

/*退回再次递交处理*/
if( RequestManager.getNextNodetype().equals("1")) {
rs.execute("update workPlanGroup set status='5' where requestId="+requestid);
rs1.execute("select id from  workPlanGroup where requestId="+requestid);
rs1.next();
String groupId=rs1.getString("id");
rs.execute("update workPlan set status='5' where  groupId="+groupId);
rs.execute("update HrmPerformancePlanDown set status='1' where  planId in (select id from workPlan where groupId="+groupId+" )");
}

/*完成流程处理*/
if( RequestManager.getNextNodetype().equals("3")) {
rs.execute("select * from workPlanGroup where requestId="+requestid);
if (rs.next())
{
String id=rs.getString("id");
rs1.execute("update workPlanGroup set status='6' where requestId="+requestid);
rs1.execute("update workPlan set status='6' where groupId="+id);
}

}



if (from.equals("")||from.equals("2"))
  out.print("<script>window.close();window.opener.location.reload();</script>"); 
 else if (from.equals("1"))
 {String planDate=Util.null2String(request.getParameter("planDate"));
  String type=Util.null2String(request.getParameter("type"));
  String urls="/hrm/performance/targetPlan/MyPlan.jsp?type="+type;
  if (type.equals("0"))
	{
	String years=planDate.substring(0,4);
	urls=urls+"&years="+years;
	}
	else if (type.equals("2"))
	{
	String years=planDate.substring(0,4);
	String months=planDate.substring(4,planDate.length());
	urls=urls+"&years="+years+"&months="+months;
	}
	else if (type.equals("1"))
	{
	String years=planDate.substring(0,4);
	String quarters=planDate.substring(4,planDate.length());
	urls=urls+"&years="+years+"&quarters="+quarters;
	
	}
	else if (type.equals("3"))
	{
	String years=planDate.substring(0,4);
	String weeks=planDate.substring(4,planDate.length());
	urls=urls+"&years="+years+"&weeks="+weeks;
	
	}
	//out.print(urls);
  response.sendRedirect(urls);
  out.print("<script>wfforward('"+urls+"');</script>");
 }

%>
<%@ include file="/workflow/request/RedirectPage.jsp" %> 