
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.*" %>

<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsf" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="cOperation" class="weaver.hrm.performance.targetcheck.CheckOperation" scope="page"/>
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

//如果尚未打分提示打分
   String cycle="";
   String checkType="";
   String type_c="";
   int objId=0;
   String checkDate="";
   String item="";
//退回及创建节点不做评分提示
boolean needcheck = true;
//退回及创建节点不做评分提示
if ("reject".equals(src) || "0".equals(nodetype)) {
	needcheck = false;
}
if(needcheck) {
  rsf.execute("select requestname,item,cycle,checkType,type_c,objId,checkDate,currentnodeid,d.id as groupid from workflow_requestbase left join workflow_currentoperator on workflow_requestbase.requestid=workflow_currentoperator.requestid left join workflow_nodegroup d on d.nodeid=workflow_currentoperator.nodeid left join GradeGroup on GradeGroup.requestId=workflow_requestbase.requestid where workflow_currentoperator.userid="+user.getUID()+" and workflow_requestbase.requestid="+requestid);
 
			 if (rsf.next())
			 {
			  cycle=rsf.getString("cycle");
			  checkType=rsf.getString("checkType");
			  type_c=rsf.getString("type_c");
			 int nodeidt=rsf.getInt("currentnodeid");
			  objId=rsf.getInt("objId");
			 int groupid=rsf.getInt("groupid");
			  checkDate=rsf.getString("checkDate");
			  item=rsf.getString("item");
			 requestname=rsf.getString("requestname");
             rs.execute("select * from HrmPerformanceNodePoint where cycle='"+cycle+"' and checkType='"+checkType+"' and objId="+objId+" and checkDate='"+checkDate+"' and nodeId="+nodeidt+" and operationId="+groupid);
             //out.print("select * from HrmPerformanceNodePoint where cycle='"+cycle+"' and checkType='"+checkType+"' and objId="+objId+" and checkDate='"+checkDate+"' and nodeId="+nodeidt+" and operationId="+groupid);
 
            if (!rs.next())
            {
             out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18246,user.getLanguage())+"');history.back(-1);</script>");
             return ;
            }
            else
            {
            String point=rs.getString("point1");
            if (type_c.equals("0")&&item.equals("0")&&point.equals("")) 
            {
            out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18246,user.getLanguage())+"');history.back(-1);</script>");
             return ;
            } 
            point=rs.getString("point2");
            if (type_c.equals("0")&&item.equals("1")&&point.equals("")) 
            {
             out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18246,user.getLanguage())+"');history.back(-1);</script>");
             return ;
            } 
            point=rs.getString("point3");
            if (type_c.equals("1")&&point.equals("")) 
            {
             out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18246,user.getLanguage())+"');history.back(-1);</script>");
             return ;
            } 
            point=rs.getString("point4");
            if (type_c.equals("2")&&point.equals("")) 
            {
             out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18246,user.getLanguage())+"');history.back(-1);</script>");
             return ;
            } 
            }
       
            }
            else
            {
             //response.sendRedirect("/notice/RequestError.jsp");
             out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
             return ;
            }
}
//判断结束      

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

/*完成流程处理*/
if( RequestManager.getNextNodetype().equals("3")) 
{
//计算当前考核类型的得分
cOperation.getPoint(cycle,checkType,checkDate,""+objId,type_c,item);

}

// out.print("<script>window.close();window.opener.location.reload();</script>");
//response.sendRedirect("/workflow/request/RequestView.jsp");


%><%@ include file="/workflow/request/RedirectPage.jsp" %> 

