
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanExchange" %>
<%@ page import="weaver.WorkPlan.WorkPlanHandler" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSeti" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="workPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="sysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="workPlanValuate" class="weaver.WorkPlan.WorkPlanValuate" scope="page" />
<jsp:useBean id="workPlanShare" class="weaver.WorkPlan.WorkPlanShare" scope="page" />
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
//消息提醒 Request06
RequestManager.setMessageType(messageType) ;
RequestManager.setUser(user) ;


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

if (src.equals("submit")&&RequestManager.getNodetype().equals("0"))   //创建者递交时任务倒入计划中
{
RecordSet.execute("select * from planDetailBill where MainId="+RequestManager.getBillid());
while  (RecordSet.next())
{
        String[] params;
        String planType="0";
        
        params = new String[] {planType, Util.null2String(RecordSet.getString("planContent")), Util.null2String(RecordSet.getString("acceptids")), Util.null2String(RecordSet.getString("beginDate")), Util.null2String(RecordSet.getString("beginTime")), Util.null2String(RecordSet.getString("endDate")), Util.null2String(RecordSet.getString("endTime")),
                               Util.null2String(RecordSet.getString("memo")), Util.null2String(RecordSet.getString("requestIds")),  Util.null2String(RecordSet.getString("projids")), Util.null2String(RecordSet.getString("crmids")), Util.null2String(RecordSet.getString("docids")), "0",
                               "1", "0", ""+user.getUID(), user.getLogintype(), "", "1", "0","","","","",                               
                               "1",  //日程提醒方式
                               "0",  //是否开始前提醒
                               "0",  //是否结束前提醒
                               "",  //开始前提醒时间数
                               "",  //结束前提醒时间数
                               "",  //开始前提醒日期
                               "",  //开始前提醒时间
                               "",  //结束前提醒日期
                               "",  //结束前提醒时间 
                               ""  //自定义考核叶子节点
                               };
        WorkPlanHandler workPlanHandler = new WorkPlanHandler();
		String planId = String.valueOf(workPlanHandler.addPlus(params));

		String[] logParams;
        WorkPlanLogMan logMan = new WorkPlanLogMan();
		logParams = new String[] {planId,
									WorkPlanLogMan.TP_CREATE,
									""+user.getUID(),
									request.getRemoteAddr()};
		logMan.writeViewLog(logParams);
		workPlanViewer.setWorkPlanShareById(planId);
}
}
//把明细中的接收人存入主表中的接收人，以实现流程操作人的取得！（如果是用从人力资源字段取操作人）
String hrmids="";
RecordSet.execute("select * from planDetailBill where MainId="+RequestManager.getBillid());

while  (RecordSet.next())
{  
 ArrayList hrmidss = Util.TokenizerString(Util.null2String(RecordSet.getString("acceptids")), ",");
		 for (int k=0;k<hrmidss.size();k++)
		 {
		 if (hrmids.indexOf(""+hrmidss.get(k))<0)
		 {
         if (hrmids.equals("")) hrmids=""+hrmidss.get(k);
         else hrmids=hrmids+","+hrmidss.get(k);
         }
         }
       
}

if(!"".equals(hrmids))
{
//更新workflow_requestbase
RecordSet.execute("update WorkPlanBill set tacceptids='"+hrmids+"' where requestid="+requestid+" and id="+RequestManager.getBillid());
}

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
			out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
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