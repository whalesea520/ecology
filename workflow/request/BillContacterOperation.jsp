<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.fna.budget.BudgetApproveWFHandler"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*,
                 java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SendMail" class="weaver.general.SendMail" scope="page" />
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<jsp:useBean id="PortalUserTransform" class="weaver.portal.PortalUserTransform" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />

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
if(src.equals("reject")&&iscreate.equals("0")){
	
    String defmailserver = SystemComInfo.getDefmailserver();
    String defneedauth = SystemComInfo.getDefneedauth();
    String defmailuser = SystemComInfo.getDefmailuser();
    String defmailpassword = SystemComInfo.getDefmailpassword();
    SendMail.setMailServer(defmailserver);
    if (defneedauth.equals("1")) {
    SendMail.setNeedauthsend(true);
    SendMail.setUsername(defmailuser);
    SendMail.setPassword(defmailpassword);
    } else{
    SendMail.setNeedauthsend(false);
    }

	String subject = SystemEnv.getHtmlLabelName(20893,user.getLanguage())+"!";

	RecordSet1.executeProc("HrmCompany_Select","");
    RecordSet1.next();
    String companyname = Util.null2String(RecordSet1.getString("companyname"));
    String companydesc = Util.null2String(RecordSet1.getString("companydesc"));

	RecordSet.executeSql(" select * from bill_Contacter where id="+ billid);
	RecordSet.next();
	
	String tmpname = Util.null2String(RecordSet.getString("name"));
    String tempto = Util.null2String(RecordSet.getString("email"));
    
	String body = SystemEnv.getHtmlLabelName(84469 ,user.getLanguage())+tmpname+SystemEnv.getHtmlLabelName(21273 ,user.getLanguage()) + "<br>" +
				  "Mr.(Mrs) "+tmpname+" , " + "<br>" +
				  SystemEnv.getHtmlLabelName(84470 ,user.getLanguage())+companyname+SystemEnv.getHtmlLabelName(84471 ,user.getLanguage()) + "<br>" +
				  SystemEnv.getHtmlLabelName(84472 ,user.getLanguage()) + "<br>" +
				  "                                               " + companyname + "<br>" +
				  "                                               " + companydesc;

	if(tempto!=null&&!"".equals(tempto)) SendMail.sendhtml(defmailuser, tempto, null, null,subject , body, 3, "3");
	
}
if( RequestManager.getNextNodetype().equals("3")) {
	String sql="insert into CRM_CustomerContacter(fullname,title,jobtitle,email,phoneoffice,fax,customerid,remark) (select name,title,responsibility,email,tel,fax,customer,remark from bill_Contacter where id="+ billid + ")" ;
    RecordSet.executeSql(sql);
    
    int ContacterID = 0;
	RecordSet.executeSql("SELECT MAX(id) as id from CRM_CustomerContacter");
	if (RecordSet.next()) ContacterID = Util.getIntValue(Util.null2String(RecordSet.getString("id")));
	
	CustomerContacterComInfo.addContacterInfoCache(""+ContacterID);
    
    PortalUserTransform.initializeContacter(ContacterID);
	ResourceComInfo.removeResourceCache();
    
    String defmailserver = SystemComInfo.getDefmailserver();
    String defneedauth = SystemComInfo.getDefneedauth();
    String defmailuser = SystemComInfo.getDefmailuser();
    String defmailpassword = SystemComInfo.getDefmailpassword();
    SendMail.setMailServer(defmailserver);
    if (defneedauth.equals("1")) {
    SendMail.setNeedauthsend(true);
    SendMail.setUsername(defmailuser);
    SendMail.setPassword(defmailpassword);
    } else{
    SendMail.setNeedauthsend(false);
    }

	String subject = SystemEnv.getHtmlLabelName(20877,user.getLanguage())+"!";
    
    RecordSet1.executeProc("HrmCompany_Select","");
    RecordSet1.next();
    String companyname = Util.null2String(RecordSet1.getString("companyname"));
    String companydesc = Util.null2String(RecordSet1.getString("companydesc"));

	RecordSet.executeSql(" select * from CRM_CustomerContacter where id="+ ContacterID);
	RecordSet.next();
	
	String tmpname = Util.null2String(RecordSet.getString("fullname"));
    String tempto = Util.null2String(RecordSet.getString("email"));
    String tmpLoginId = Util.null2String(RecordSet.getString("loginid"));
    String tmpPassword = Util.null2String(RecordSet.getString("password"));
    

	String body = SystemEnv.getHtmlLabelName(84469 ,user.getLanguage())+tmpname+SystemEnv.getHtmlLabelName(21273 ,user.getLanguage()) + "<br>" +
				  "Mr.(Mrs) "+tmpname+" , " + "<br>" +
				  SystemEnv.getHtmlLabelName(84470 ,user.getLanguage())+companyname+SystemEnv.getHtmlLabelName(84471 ,user.getLanguage()) + "<br>" +
				  SystemEnv.getHtmlLabelName(84472 ,user.getLanguage()) + "<br>" +
				  "                                               " + companyname + "<br>" +
				  "                                               " + companydesc;
	String body = SystemEnv.getHtmlLabelName(84469 ,user.getLanguage())+tmpname+SystemEnv.getHtmlLabelName(21273 ,user.getLanguage()) + "<br>" +
				  "Mr.(Mrs) "+tmpname+" , " + "<br>" +
				  //SystemEnv.getHtmlLabelName(84470 ,user.getLanguage())+companyname+SystemEnv.getHtmlLabelName(84471 ,user.getLanguage()) + "<br>" +
				  SystemEnv.getHtmlLabelName(84470 ,user.getLanguage())+companyname+SystemEnv.getHtmlLabelName(84473 ,user.getLanguage())+ "<br>" +
				 // "Welcome to use our intranet system, we always concentrate on your recognition." + "<br>" +
				  SystemEnv.getHtmlLabelName(27301 ,user.getLanguage())+"：" + tmpLoginId + "<br>" +
				  SystemEnv.getHtmlLabelName(83865 ,user.getLanguage())+  ":  " + tmpPassword + "<br>" +
				  SystemEnv.getHtmlLabelName(84474 ,user.getLanguage()) + "<br>" +
				  SystemEnv.getHtmlLabelName(84472 ,user.getLanguage()) + "<br>" +
				  "                                               " + companyname + "<br>" +
				  "                                               " + companydesc;

	if(tempto!=null&&!"".equals(tempto)) SendMail.sendhtml(defmailuser, tempto, null, null,subject , body, 3, "3");
    
}
//response.sendRedirect("/workflow/request/RequestView.jsp");
out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
%>
