<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

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
if (isremark!=1) {
char flag=Util.getSeparator() ;
int userid = user.getUID();
if( src.equals("save") || src.equals("submit") ) {      // 修改细表和主表信息
int rowsum1 = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum1"))); 
int rowsum2 = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum2")));
//out.print("rowsum1"+rowsum1);
	if( !iscreate.equals("1") ) {
		if (rowsum1==0) RecordSet.executeProc("bill_monthinfodetail_DByType",""+billid+flag+"2");
		if (rowsum2==0) RecordSet.executeProc("bill_monthinfodetail_DByType",""+billid+flag+"1");
	}
	 else {
        requestid = RequestManager.getRequestid() ;
        billid = RequestManager.getBillid() ;
    }   
	//操作detail表	
	String ids=Util.null2String(fu.getParameter("type1_id"));
	for(int i=0;i<rowsum1;i++) {	
		String workresult = Util.fromScreen(fu.getParameter("type1_"+i+"_result"),user.getLanguage());
		if(workresult.equals("")) continue ;
		String curscale = Util.fromScreen(fu.getParameter("type1_"+i+"_scale"),user.getLanguage());
		String curpoint = Util.fromScreen(fu.getParameter("type1_"+i+"_point"),user.getLanguage());
		if(curscale.equals(""))	curscale="0";
		String id=Util.null2String(fu.getParameter("type1_"+i+"_id"));
		//out.print(id+"<br>");
		//out.print(ids+"<br>");
		if (id.equals(""))
		{
		String para = (""+billid) + flag + "2" + flag + "" + flag + workresult + flag + "" 
					+ flag + curscale + flag + curpoint;
		RecordSet.executeProc("bill_monthinfodetail_Insert",para);
        }
		else
		{
		ids=Util.StringReplace(ids,","+id+",",",-1,");
		// out.print("update bill_weekinfodetail set workname='"+workname+"' ,workdesc='"+workdesc+"'  where id="+id);
         RecordSet.execute("update bill_monthinfodetail set targetresult='"+workresult+"' ,scale='"+curscale+"', point='"+curpoint+"' where id="+id);
		}
	}
	
	if (!ids.equals(",")&&!ids.equals(""))
	{
	ids="-1"+ids+"-1";
	//out.print("delete from bill_monthinfodetail where id in ("+ids+")");
     RecordSet.execute("delete from bill_monthinfodetail where id in ("+ids+") ");
	}

	ids=Util.null2String(fu.getParameter("type2_id"));
	for(int i=0;i<rowsum2;i++) {	
		String workname = Util.fromScreen(fu.getParameter("type2_"+i+"_name"),user.getLanguage());
		if(workname.equals("")) continue ;
		String workdesc = Util.fromScreen(fu.getParameter("type2_"+i+"_desc"),user.getLanguage());
		String curdate = Util.fromScreen(fu.getParameter("type2_"+i+"_date"),user.getLanguage());
		String curscale = Util.fromScreen(fu.getParameter("type2_"+i+"_scale"),user.getLanguage());
		if(curscale.equals(""))	curscale="0";
		String id=Util.null2String(fu.getParameter("type2_"+i+"_id"));
		if (id.equals(""))
		{
		String para = (""+billid) + flag + "1" + flag + workname + flag + workdesc + flag + curdate 
					+ flag + curscale + flag + "";
		RecordSet.executeProc("bill_monthinfodetail_Insert",para);
		}
		else
		{
		ids=Util.StringReplace(ids,","+id+",",",-1,");
		// out.print("update bill_weekinfodetail set workname='"+workname+"' ,workdesc='"+workdesc+"'  where id="+id);
         RecordSet.execute("update bill_monthinfodetail set targetname='"+workname+"' ,targetresult='"+workdesc+"', forecastdate='"+curdate+"',scale='"+curscale+"' where id="+id);
		}
	}
	if (!ids.equals(",")&&!ids.equals(""))
	{
	ids="-1"+ids+"-1";
	//out.print("delete from bill_monthinfodetail where id in ("+ids+") ");
    RecordSet.execute("delete from bill_monthinfodetail where id in ("+ids+") ");
	}
	}
}
 
	

	//response.sendRedirect("/workflow/request/RequestView.jsp");
 //out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");

%>
<%@ include file="/workflow/request/RedirectPage.jsp" %> 