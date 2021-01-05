
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>

<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>


<%	
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
//获得工作流的基本信息
String workflowid = Util.null2String(request.getParameter("workflowid"));
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
String nodeid= Util.null2String(request.getParameter("nodeid")) ;
String formid= Util.null2String(request.getParameter("formid")) ;
String workflowname = WorkflowComInfo.getWorkflowname(workflowid);
workflowname = Util.processBody(workflowname,user.getLanguage()+"");
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //???????????
String isbill = "1" ;
int helpdocid = Util.getIntValue(request.getParameter("helpdocid"),0);
int messageType= Util.getIntValue(request.getParameter("messageType"),0);
int chatsType= Util.getIntValue(request.getParameter("chatsType"),0);//微信提醒(QC:98106)
int defaultName= Util.getIntValue(request.getParameter("defaultName"),0);
String docCategory= Util.null2String(request.getParameter("docCategory")) ;

//获得当前用户的id，类型和名称。如果类型为1，表示为内部用户（人力资源），2为外部用户（CRM）
int userid = user.getUID();
String logintype = user.getLogintype();
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());


//对不同的模块来说,可以定义自己相关的内容，作为请求默认值，比如将 docid 赋值，作为该请求的默认文档
//默认的值可以赋多个，中间用逗号格开

String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
String reqid = Util.null2String(request.getParameter("reqid"));
if(hrmid.equals("") && logintype.equals("1")) hrmid = "" + userid ;
if(crmid.equals("") && logintype.equals("2")) crmid = "" + userid ;

//工作流建立完成后将返回的页面
String topage = Util.null2String(request.getParameter("topage"));


//获得当前的日期和时间
String currentdate = Util.null2String(request.getParameter("currentdate"));
String currenttime = Util.null2String(request.getParameter("currenttime"));


//请求提交的时候需要检查必输的字段名，多个必输项用逗号格开，requestname为新建请求中第一行的请求说明，是每一个请求都必须有的
String needcheck="requestname";

//开始日期和结束日期比较用
String newfromdate="a";
String newenddate="b";
%>