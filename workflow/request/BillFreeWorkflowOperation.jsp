<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.ArrayList" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetBED"class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetBHF"class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page"/>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page"/>
<jsp:useBean id="WFFreeFlowManager" class="weaver.workflow.request.WFFreeFlowManager" scope="page"/>
<jsp:useBean id="FreeWorkflowUtil" class="weaver.formmode.worklfowinterface.FreeWorkflowUtil" scope="page"/>


<%

FileUpload fu = new FileUpload(request);

int isfreeworkflowbindform=Util.getIntValue(fu.getParameter("isfreeworkflowbindform"),-1);

int fc_billid=0;

int fc_formmodeid=0;

int fc_formid=0;

//流程绑定表单
if(isfreeworkflowbindform==1)
{
  fc_billid=FreeWorkflowUtil.saveFreeWorkflowData(fu);
  fc_formmodeid= Util.getIntValue(fu.getParameter("formmodeid"),-1);
  fc_formid=Util.getIntValue(fu.getParameter("fc_formid"),-1);
}

String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = 1;
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));
//标识该页面为创建页面
String isfreewfcreater = Util.null2String(fu.getParameter("isfreewfcreater"));

//正文
String remarkinfo = Util.null2String(fu.getParameter("remarkinfo"));

//创建人id
int createid=Util.getIntValue(fu.getParameter("createid"),-1);
int userid=user.getUID();

if(createid!=-1  &&  createid!=userid)
{
    //代理人创建
    session.setAttribute(workflowid+"isagent"+user.getUID(),1+"");
    session.setAttribute(workflowid+"beagenter"+user.getUID(),createid+"");

}else  if(createid!=-1  &&  createid==userid)
{
	//本人创建
    session.setAttribute(workflowid+"isagent"+user.getUID(),0+"");
    session.setAttribute(workflowid+"beagenter"+user.getUID(),0+"");
}


String crmids = "" ;
String projectids = "" ;

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



//add by chengfeng.han 2011-7-28 td20647 
int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);



RequestManager.setIsagentCreater(isagentCreater);
RequestManager.setBeAgenter(beagenter);
//end
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = RequestManager.saveRequestInfo() ;

requestid = RequestManager.getRequestid() ;
nodeid=RequestManager.getNodeid();

//保存自由流程节点
int freeNode = Util.getIntValue(fu.getParameter("freeNode"),0);

int freeDuty= Util.getIntValue(fu.getParameter("freeDuty"),0);

if((src.equals("save") || src.equals("submit")) && freeNode==1){
	if(freeDuty==1){//加签模式保存
		WFFreeFlowManager.SaveFreeFlow(request,requestid,nodeid,user.getLanguage());
	}else if(freeDuty==2){//后续模式保存
		WFFreeFlowManager.SaveFreeFlowForAllChildren(request,workflowid,requestid,nodeid,user.getLanguage());
	}
}





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
        out.print("<script>alert('ccccc');wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}


if( isfreewfcreater.equals("1")) {      // 修改细表和主表信息


    //新建自由流程并增加自由节点
	String  operators=Util.null2String(fu.getParameter("operator_0"));

    if(!operators.equals(""))
	{
		if(operators.indexOf(",")==0)
		operators=operators.substring(1);
        String[]  ops=operators.split(",");
        String sqltemp="";
		sqltemp="delete from bill_FreeWorkflowConnector  where  requestid='"+requestid+"'";
		RecordSet.executeSql(sqltemp);
		for(String op:ops)
		{
            //记录联系人信息
		   sqltemp="insert into  bill_FreeWorkflowConnector(requestid,creater,operator)  values("+requestid+","+createid+","+op+")";
		   RecordSet.executeSql(sqltemp);
		}

	}


}




boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;

//System.out.println("src==================>"+src);

// 相关客户和相关项目更新
if( src.equals("save") || src.equals("submit") ) {      // 修改细表和主表信息
    String updatesql="";
	if( !crmids.equals("") || !projectids.equals("") ) {
        updatesql = " update workflow_requestbase set crmids = '" + crmids + "' , prjids = '" +
                           projectids + "' where requestid = " + requestid ;
        RecordSet.executeSql( updatesql ) ;
    }
	 if(fc_billid!=0)
	 {
		 //更新自由流程绑定的表单数据
		 updatesql="update bill_FreeWorkflow   set  remarkinfo='"+remarkinfo+"',tableformid='"+fc_formid+"',tablemodeid='"+fc_formmodeid+"',tablebillid='"+fc_billid+"'  where  requestid="+requestid  ; 
	 }
	 else
	{   //更新自由流程数据
        updatesql="update bill_FreeWorkflow   set  remarkinfo='"+remarkinfo+"'  where  requestid="+requestid  ; 
	}
     RecordSet.executeSql( updatesql ) ;
}

if( src.equals("delete") ) {           //  修改 bill_HrmFinance 表的状态
   
}
else if( src.equals("active") ) {

}
else if( RequestManager.getNextNodetype().equals("3")) {

  
}
if( isfreewfcreater.equals("1"))
out.print("<script>window.top.windowdialog.close();//wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1');</script>");
else
out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1');</script>");

%>
