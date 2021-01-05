
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Requestlog" class="weaver.workflow.request.RequestLog" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="basebean" class="weaver.general.BaseBean" scope="page" />

<%//TD9144 专门处理不需要提交的被抄送人点击“提交不需要反馈”按钮的操作 chujun
FileUpload fu = new FileUpload(request);

String src = Util.null2String(fu.getParameter("src"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String needwfback = Util.null2String(fu.getParameter("needwfback"));

String isremark = Util.null2String(fu.getParameter("isremark"));
String ifchangstatus=Util.null2String(basebean.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
if( src.equals("") || workflowid == -1 ||  nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}
String userid=""+user.getUID();
int usertype = (user.getLogintype()).equals("1") ? 0 : 1;
char flag = Util.getSeparator();

if(!"0".equals(needwfback)){
	RecordSet.executeProc("workflow_CurOpe_UbySend", "" + requestid + flag + userid + flag + usertype+flag+isremark);
}else{
	RecordSet.executeProc("workflow_CurOpe_UbySendNB", "" + requestid + flag + userid + flag + usertype+flag+isremark);
	RecordSet.execute("update workflow_currentoperator set needwfback='0' where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" and isremark='2' and preisremark='8'");
}

String isShowPrompt="true";
String docFlags=(String)session.getAttribute("requestAdd"+requestid);
if (docFlags.equals("1"))
			{%>
			<SCRIPT LANGUAGE="JavaScript">
             parent.document.location.href="/workflow/request/ViewRequest.jsp?nodetypedoc=<%=nodetype%>&requestid=<%=requestid%>&fromoperation=1&updatePoppupFlag=1&isShowPrompt=<%=isShowPrompt%>&src=<%=src%>";
            </SCRIPT>
			<%}else{
//response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src);
out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src+"');</script>");
}

%>