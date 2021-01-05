<%@ page import="weaver.general.*,java.util.*,weaver.conn.*" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />

<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //???????????
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String requestname= "" ;   //请求名称
String requestlevel= Util.null2String(request.getParameter("requestlevel")) ; //请求重要级别 0:正常 1:重要 2:紧急
String requestmark = Util.null2String(request.getParameter("requestmark")) ;     //请求编号
String isbill= "1";          //是否单据 0:否 1:是
int creater= Util.getIntValue(request.getParameter("creater"),0) ;              //请求的创建人
int creatertype = Util.getIntValue(request.getParameter("creatertype"),0) ;     //创建人类型 0: 内部用户 1: 外部用户
int deleted = Util.getIntValue(request.getParameter("deleted"),0) ;  //请求是否删除  1:是 0或者其它 否
int workflowid= Util.getIntValue(request.getParameter("workflowid"),0) ;           //工作流id
int formid = Util.getIntValue(request.getParameter("formid"),0) ;               //表单或者单据的id
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0) ;               //节点id
int billid = Util.getIntValue(request.getParameter("billid"),0) ;                   //对应的单据id
String nodetype = Util.null2String(request.getParameter("nodetype")) ;         //节点类型  0:创建 1:审批 2:实现 3:归档
String workflowname = WorkflowComInfo.getWorkflowname(workflowid+"");         //工作流名称
workflowname = Util.processBody(workflowname,user.getLanguage()+"");
boolean canactive = Util.null2String(request.getParameter("canactive")).equalsIgnoreCase("true") ;         //工作流名称
boolean isprint = Util.null2String(request.getParameter("isprint")).equals("1")?true:false;
int desrequestid=Util.getIntValue(request.getParameter("desrequestid"),0);

int userid=user.getUID();                                           //当前用户id
String logintype = user.getLogintype();                             //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;

String sql = "" ;
char flag = Util.getSeparator() ;
RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){	
    requestname= Util.null2String(RecordSet.getString("requestname")) ;
}

boolean isurger = Util.null2String(request.getParameter("isurger")).equalsIgnoreCase("true") ;
boolean wfmonitor = Util.null2String(request.getParameter("wfmonitor")).equalsIgnoreCase("true") ;
int languageidtemp  = Util.getIntValue(request.getParameter("languageid"));
String isrequest = Util.null2String(request.getParameter("isrequest")); 
%>