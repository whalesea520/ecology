<%@ page import="weaver.general.*,java.util.*,weaver.conn.*" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>

<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
String newfromdate="a";
String newenddate="b";
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
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
int formid = Util.getIntValue(request.getParameter("formid"),0) ;               //表单或者单据的id
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0) ;               //节点id
int billid = Util.getIntValue(request.getParameter("billid"),0) ;                   //对应的单据id
String nodetype = Util.null2String(request.getParameter("nodetype")) ;         //节点类型  0:创建 1:审批 2:实现 3:归档
String nextnodetype = Util.null2String(request.getParameter("nextnodetype")) ;//提交的下一个节点类型
String workflowname = WorkflowComInfo.getWorkflowname(workflowid+"");         //工作流名称
workflowname = Util.processBody(workflowname,user.getLanguage()+"");

String isreopen = Util.null2String(request.getParameter("isreopen")) ;        //是否可以重打开
String isreject = Util.null2String(request.getParameter("isreject")) ;        //是否可以退回
int isremark = Util.getIntValue(request.getParameter("isremark"),0) ;         //当前操作状态
String currentdate = Util.null2String(request.getParameter("currentdate")) ;        //是否可以重打开
String currenttime = Util.null2String(request.getParameter("currenttime")) ;        //是否可以退回

String topage = Util.null2String(request.getParameter("topage")) ;        //返回的页面

String needcheck="requestname";


// 工作流新建文档的处理
String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
//String newdocid = Util.null2String(request.getParameter("docid"));        // 新建的文档
String newdocid = Util.null2String(request.getParameter("newdocid"));        // 新建的文档

int userid=user.getUID();                                           //当前用户id
int usertype = 0;                           //用户在工作流表中的类型 0: 内部 1: 外部
String logintype = user.getLogintype();                             //当前用户类型  1: 类别用户  2:外部用户
String username = "";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;

String sql = "" ;
char flag = Util.getSeparator() ;
RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){	
    requestname= Util.null2String(RecordSet.getString("requestname")) ;
}

//boolean isurger = Util.null2String(request.getParameter("isurger")).equalsIgnoreCase("true") ;
//boolean wfmonitor = Util.null2String(request.getParameter("wfmonitor")).equalsIgnoreCase("true") ;
int languageidtemp  = Util.getIntValue(request.getParameter("languageid"));
//String isrequest = Util.null2String(request.getParameter("isrequest")); 
session.setAttribute(userid+"_"+requestid+"requestname",requestname);
session.setAttribute(userid+"_"+requestid+"workflowname",workflowname);

int lastOperator=0;
String lastOperateDate="";
String lastOperateTime="";

lastOperator=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"lastOperator"),0);
lastOperateDate=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateDate"));
lastOperateTime=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateTime"));

%>