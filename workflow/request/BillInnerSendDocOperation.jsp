
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,
                 java.sql.Timestamp"%>
<%@ page import="java.net.*" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestAddShareInfo" class="weaver.workflow.request.RequestAddShareInfo" scope="page"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ApproveParameter" class="weaver.workflow.request.ApproveParameter" scope="page"/>

<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />

<%

Calendar todaycal = Calendar.getInstance ();
String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
  Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
  Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;


String src = Util.null2String(request.getParameter("src"));
String iscreate = Util.null2String(request.getParameter("iscreate"));
int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
int docid = Util.getIntValue(request.getParameter("docid"),-1);
String  docsubject = Util.fromScreen(request.getParameter("docsubject"),user.getLanguage());
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
int isfromdoc = Util.getIntValue(request.getParameter("isfromdoc"),-1);         //是否从文档显示页面提交审批过来的

char flag = 2 ;
String Procpara = "" ;
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
int userid = user.getUID();
String logintype = user.getLogintype();
if(requestlevel.equals("")) requestlevel="0";
if(messageType.equals("")) messageType="0";
 String strSql="select d.docsubject,s.approveworkflowid from  docseccategory s "+
                               "right join docdetail d  on s.id=d.seccategory where d.id="+docid;        
  RecordSet.executeSql(strSql);
   if(RecordSet.next()) {
     docsubject=Util.null2String(RecordSet.getString("docsubject"));
     workflowid=Util.getIntValue(RecordSet.getString("approveworkflowid"));
                }
      //流程有时不能触发，怀疑是SESSION的客户端问题，故在这里初始化
      ApproveParameter.resetParameter();
      ApproveParameter.setWorkflowid(workflowid);
      ApproveParameter.setNodetype("0");
      ApproveParameter.setApproveid(Util.getIntValue(docid+""));
      ApproveParameter.setApprovetype("9");
      ApproveParameter.setRequestname(docsubject);          
      ApproveParameter.setGopage("/docs/docs/DocApprove.jsp?id=");
      ApproveParameter.setBackpage("/docs/docs/DocApprove.jsp?id="); 
              
if(src.equals("save")&&iscreate.equals("1")) {//新建request时
    if (ApproveParameter.getWorkflowid()>0){
        workflowid=ApproveParameter.getWorkflowid();
        formid=ApproveParameter.getFormid();
        requestname=ApproveParameter.getRequestname();
        nodeid=ApproveParameter.getNodeid();
        nodetype=ApproveParameter.getNodetype();
    }
}
isbill=1;
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

boolean savestatus = true ;
if( isfromdoc != 1 )  savestatus = RequestManager.saveRequestInfo() ;    //不是从文档显示页面提交审批过来的才作saveRequestInfo否则会由于文档显示页面没有单据的字段信息而被清空
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

if(src.equals("save")&&iscreate.equals("1")) {
	String approveid=ApproveParameter.getApproveid()+"";
	String approvetype=ApproveParameter.getApprovetype()+"";
	String gopage=ApproveParameter.getGopage();
	String backpage=ApproveParameter.getBackpage();
    billid = RequestManager.getBillid() ;
	if(nodetype.equals("3")) {
		//写DocApproveRemark表,跳转到文档审批的操作页面去处理文档的状态改变
		//Procpara= ""+userid+flag+"2"+flag+CurrentDate+flag+CurrentTime+flag+approveid;
		//RecordSet.executeProc("DocDetail_Approve",Procpara);
		DocManager.approveDocFromWF("approve",approveid,CurrentDate,CurrentTime,userid+"");
	}
    if (ApproveParameter.getWorkflowid()>0) {
        RecordSet.executeSql("update bill_InnerSendDoc set docId = "+approveid+",resourceId="+userid+",departmentId="+ResourceComInfo.getDepartmentID(""+userid)+",pieces=1 where id="+billid) ;
        boolean  blnOsp = "true".equals(request.getParameter("blnOsp")) ;

        if (blnOsp){%>
          <SCRIPT LANGUAGE="JavaScript">   
              window.close(); 
              window.parent.returnValue="1";   
          </SCRIPT>
        <% return;   
        }
        //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid);
        out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"');</script>");
        return;
    }
}

boolean flowstatus = RequestManager.flowNextNode() ;

if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;

if(RequestManager.getNextNodetype().equals("3")) {
  //实现共享
  String sqlStr="select department_1,department_2,department_3,department_4 from bill_InnerSendDoc where id="+billid;
  String department="";
  String department_1="";
  String department_2="";
  String department_3="";
  String department_4="";
  ArrayList resources=new ArrayList();
  rs.executeSql(sqlStr) ;
  if (rs.next()){
      department_1=Util.null2String(rs.getString("department_1"));
	  department_2=Util.null2String(rs.getString("department_2"));
	  department_3=Util.null2String(rs.getString("department_3"));
	  department_4=Util.null2String(rs.getString("department_4"));
	  if (!department_1.equals("")) {
		department+=department_1+",";
	  }
	  if (!department_2.equals("")) {
		department+=department_2+",";
	  }
	  if (!department_3.equals("")) {
		department+=department_3+",";
	  }
	  if (!department_4.equals("")) {
		department+=department_4+",";
	  }
	  if (!department.equals("")){
		  department=department.substring(0,department.length()-1);
		  sqlStr="select id from HrmResource where departmentid in ("+department+") order by id desc";
		  rs1.executeSql(sqlStr);
		  while(rs1.next())
			resources.add(rs1.getString("id"));
	  }
      RequestAddShareInfo.addShareInfo(""+requestid,resources);
  }
}


if(src.equals("save")&&iscreate.equals("0")){//处理request且选择保存logtype=1
	if(isremark==1){
			//记录签字意见
			if(!nodetype.equals("0")){
				//写DocApproveRemark表,跳转到文档审批的操作页面去处理文档的状态改变
				RecordSet.executeSql("select docId from bill_InnerSendDoc where id="+billid);
				RecordSet.next();
				String approveid=RecordSet.getString("docId");
				Procpara=approveid+flag+remark+flag+""+userid+flag+CurrentDate+flag+CurrentTime+flag+"2";
				RecordSet.executeProc("DocApproveRemark_Insert",Procpara);
			}
	}
}

if(src.equals("submit")&&iscreate.equals("0")){//处理request且选择提交logtype=2
    if( RequestManager.getNextNodetype().equals("3") )    {
            //写DocApproveRemark表,跳转到文档审批的操作页面去处理文档的状态改变
            RecordSet.executeSql("select docId from bill_InnerSendDoc where id="+billid);
            RecordSet.next();
            String approveid=RecordSet.getString("docId");
            String gopage="/docs/docs/DocApprove.jsp";
            Procpara=approveid+flag+remark+flag+""+userid+flag+CurrentDate+flag+CurrentTime+flag+"1";
            RecordSet.executeProc("DocApproveRemark_Insert",Procpara);
            //response.sendRedirect(gopage+"?id="+approveid+"&type=approve");
            out.print("<script>wfforward('"+gopage+"?id="+approveid+"&type=approve');</script>");
            return;
    }
}

if(src.equals("reject")&&iscreate.equals("0")){//处理request且选择退回logtype=3
    if(!nodetype.equals("0")){
        //写DocApproveRemark表
        RecordSet.executeSql("select docId from bill_InnerSendDoc where id="+billid);
        RecordSet.next();
        String approveid=RecordSet.getString("docId");
        String gopage="/docs/docs/DocApprove.jsp";
        Procpara=approveid+flag+remark+flag+""+userid+flag+CurrentDate+flag+CurrentTime+flag+"0";
        RecordSet.executeProc("DocApproveRemark_Insert",Procpara);
        //response.sendRedirect(gopage+"?id="+approveid+"&type=reject");
        out.print("<script>wfforward('"+gopage+"?id="+approveid+"&type=reject');</script>");
        return;
    }
}

//response.sendRedirect("/workflow/request/RequestView.jsp");
out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
%>