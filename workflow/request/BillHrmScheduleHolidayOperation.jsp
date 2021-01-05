<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.file.FileUpload" %>

<%

Calendar todaycal = Calendar.getInstance ();
String currentdate = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
      Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
      Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;

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

if( RequestManager.getNextNodetype().equals("3") ) {
	rs.executeSql(" select * from Bill_HrmScheduleHoliday where id = " + billid ) ;
	if( rs.next() ) {
		String resource_n = Util.null2String(rs.getString("resource_n"));
		String diffid  = Util.null2String(rs.getString("diffid"));
		String startdate =    Util.null2String(rs.getString("startdate"));
		String starttime = Util.null2String(rs.getString("starttime"));
		String enddate = Util.null2String(rs.getString("enddate")) ;       
		String endtime = Util.null2String(rs.getString("endtime")) ;	
		String reason = Util.null2String(rs.getString("reason")) ;	
		
        weaver.hrm.tools.Time thetimes = new weaver.hrm.tools.Time() ;

        String totaltime = thetimes.getTotalTimeOnce(resource_n , diffid , startdate , starttime , enddate , endtime) ; 

        char separator = Util.getSeparator() ; 

        // 现有系统
        
        String realdifftime = "0" ;
        if( totaltime.length() >= 5 ) {
            int totalhour = Util.getIntValue(totaltime.substring(0,totaltime.length()-3),0) ;
            int totalmin = Util.getIntValue(totaltime.substring(3,5),0) ;
            realdifftime = "" + ( totalhour*60 + totalmin ) ;
        }
        
        String difftype = "" ;
        //rs.executeSql( " select difftype from HrmScheduleDiff where id = " + diffid ) ;
        //if( rs.next() ) difftype = Util.null2String(rs.getString("difftype")) ;
		if(!diffid.equals("")){
			rs.executeSql( " select difftype from HrmScheduleDiff where id = " + diffid ) ;
			if( rs.next() ){
				difftype = Util.null2String(rs.getString("difftype")) ;
			}
		}

        String para = diffid + separator + resource_n + separator + startdate + separator + starttime +  separator + enddate + separator + endtime + separator + reason  + separator + "0" + separator + resource_n + separator + currentdate + separator + realdifftime + separator + difftype; 

        rs.executeProc("HrmScheduleMain_Insert" , para) ; 
	}
}
 
%><%@ include file="/workflow/request/RedirectPage.jsp" %> 