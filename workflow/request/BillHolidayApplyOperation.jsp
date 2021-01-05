<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RequestHolidayApplyManager" class="weaver.workflow.request.RequestHolidayApplyManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
FileUpload fu = new FileUpload(request);
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
String requestname = Util.fromScreen3(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));
String method = Util.fromScreen(fu.getParameter("method"),user.getLanguage()); // 作为新建文档时候的参数传递
String topage=URLDecoder.decode(Util.null2String(fu.getParameter("topage")));  //返回的页面


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
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;
//System.out.println("messageType===="+messageType);
RequestManager.setUser(user) ;


boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;

//added by pony on 2006-04-14 for TD4169
RequestHolidayApplyManager.updateTotalHours(requestid);
//added end.

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

/**Save the detail info of the request**/
	//move this part to do in the class of RequestManager
	
/**Save Detail end**/

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;

if( method.equals("") ) 
	if(!topage.equals("")){
        	if(topage.indexOf("?")!=-1){
        		//response.sendRedirect(topage+"&requestid="+requestid);
        		out.print("<script>wfforward('"+topage+"&requestid="+requestid+"');</script>");
        	}else{
				//response.sendRedirect(topage+"?requestid="+requestid);
				out.print("<script>wfforward('"+topage+"?requestid="+requestid+"');</script>");
			}
		}
    else {
        if(iscreate.equals("1")){
			//response.sendRedirect("/workflow/request/RequestView.jsp");

 weaver.general.DateUtil DateUtil=new weaver.general.DateUtil();
		if(DateUtil.isCurrendUserid(""+requestid,""+user.getUID())){
				out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1');</script>");
			}else{
				 out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
			}
			
        }
        else{
            if("delete".equals(src) && savestatus && flowstatus){%>
            <SCRIPT LANGUAGE="JavaScript">
            alert("<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>");
            window.close();
            </SCRIPT>
            <%}
            else{
            //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1");//td3450 xwj 20060207
            out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1');</script>");
            }
        }
    }

else {
    String adddocfieldid = method.substring(7) ;
    topage = URLEncoder.encode("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&docfileid="+adddocfieldid+"&topage="+topage);
    //response.sendRedirect("/docs/docs/DocList.jsp?topage="+topage);
    out.print("<script>wfforward('/docs/docs/DocList.jsp?topage="+topage+"');</script>");
//  showsubmit 为0的时候新建文档将不显示提交按钮  response.sendRedirect("/docs/docs/DocList.jsp?topage="+topage+"&showsubmit=0");
}

%>