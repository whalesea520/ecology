<%@page import="weaver.fna.general.FnaCommon"%>
<%@ page import="weaver.general.Util,java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetStart" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
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
String remark = Util.null2String(fu.getParameter("remark"));

if(requestid != -1){
	String sqlwhere = FnaCommon.getCanQueryRequestSqlCondition(user, "a", "a");
	String _sql = "select 1 from workflow_requestbase a where 1=1 "+sqlwhere+" and a.requestid = "+requestid;
	RecordSetStart.executeSql(_sql);
	if(RecordSetStart.getCounts()<1){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}

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

if( iscreate.equals("1") ) {
    billid = RequestManager.getBillid() ;
    requestname = Util.fromScreen2(requestname,user.getLanguage());
    String basictype="3";       /* 1 因公流出 2 因公流入 3 因私流出 4 因私流入 */
    String detailtype="1"; 
    /*
	1-1 费用报销
	2-1 收入
	3-1 私人借款
	4-1 私人还款
	*/

    RecordSet.executeSql( " update Bill_HrmFinance set basictype = " + basictype + ", detailtype = "                     + detailtype + ", billid= "+ billid +",name= '"+requestname+"' ,status='0' "
                        + " where id = " + billid ) ;
}

if( src.equals("delete") ) {
    RecordSet.executeProc("bill_HrmFinance_UpdateStatus",""+billid + Util.getSeparator() + "2");
}
else if( src.equals("active") ) {
    if( RequestManager.getNextNodetype().equals("3")) 
        RecordSet.executeProc("bill_HrmFinance_UpdateStatus",""+billid + Util.getSeparator() + "1");
    else
        RecordSet.executeProc("bill_HrmFinance_UpdateStatus",""+billid + Util.getSeparator() + "0");
}
else if( RequestManager.getNextNodetype().equals("3")) {
    RecordSet.executeProc("bill_HrmFinance_UpdateStatus",""+billid + Util.getSeparator() + "1");
    
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    
    char flag=Util.getSeparator() ;
    String loantypeid = "1" ;
    String resourceid = "" ;
    String departmentid = "" ;
    String crmid = "" ;
    String projectid = "" ;
    double amount = 0;
    String description = "" ;
    String credenceno = "" ;
    String occurdate = currentdate ;
    String releatedid = "" + requestid ;
    String releatedname = requestname ;
    String returndate = "" ;
    String dealuser = "" ;

    
    RecordSet.executeSql(" select * from bill_HrmFinance where billid = "+billid+" or id = " + billid);
    
    if( RecordSet.next() ) {
        resourceid = Util.null2String( RecordSet.getString("resourceid") ) ;
        crmid = Util.null2String( RecordSet.getString("crmid") ) ;
        projectid = Util.null2String( RecordSet.getString("projectid") ) ;
        amount = Util.getDoubleValue( RecordSet.getString("amount"), 0) ;
        description = Util.null2String( RecordSet.getString("description") ) ;
        credenceno = Util.null2String( RecordSet.getString("debitremark") ) ;
        returndate = Util.null2String( RecordSet.getString("returndate") ) ;
        departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid));
    }

    String para = loantypeid + flag + resourceid + flag + departmentid + flag + crmid + flag + 
			projectid + flag + amount + flag + description + flag + credenceno + flag + occurdate + 
            flag + releatedid + flag + releatedname + flag + returndate + flag + dealuser;

    RecordSet.executeProc("FnaLoanLog_Insert",para);
     
}

 

//response.sendRedirect("/workflow/request/RequestView.jsp");
%>
<%@ include file="/workflow/request/RedirectPage.jsp" %> 
