<%@ page import="weaver.general.Util,java.util.*,weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%	
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int start =Util.getIntValue(request.getParameter("start"),1);

String isrequest = Util.null2String(request.getParameter("isrequest")); // 是否是从相关工作流的链接中来,1:是
String requestname="";      //请求名称
String requestlevel="";     //请求重要级别 0:正常 1:重要 2:紧急
String requestmark = "" ;   //请求编号
String isbill="0";          //是否单据 0:否 1:是
int creater=0;              //请求的创建人
int creatertype = 0;        //创建人类型 0: 内部用户 1: 外部用户
int deleted=0;              //请求是否删除  1:是 0或者其它 否
int billid=0 ;              //如果是单据,对应的单据表的id

int workflowid=0;           //工作流id
int formid=0;               //表单或者单据的id
int helpdocid = 0;          //帮助文档 id
int nodeid=0;               //节点id
String nodetype="";         //节点类型  0:创建 1:审批 2:实现 3:归档
String workflowname = "" ;         //工作流名称

int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;

boolean canview = false ;               // 是否可以查看
boolean canactive = false ;             // 是否可以对删除的工作流激活

String sql = "" ;
char flag = Util.getSeparator() ;

// 查询请求的相关工作流基本信息
RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){	
    requestname= Util.null2String(RecordSet.getString("requestname")) ;
	requestlevel = Util.null2String(RecordSet.getString("requestlevel"));
    requestmark = Util.null2String(RecordSet.getString("requestmark")) ;
    creater = Util.getIntValue(RecordSet.getString("creater"),0);
	creatertype = Util.getIntValue(RecordSet.getString("creatertype"),0);
    deleted = Util.getIntValue(RecordSet.getString("deleted"),0);
	workflowid = Util.getIntValue(RecordSet.getString("workflowid"),0);
	nodeid = Util.getIntValue(RecordSet.getString("currentnodeid"),0);
	nodetype = Util.null2String(RecordSet.getString("currentnodetype"));
    workflowname = WorkflowComInfo.getWorkflowname(workflowid+"");
    workflowname = Util.processBody(workflowname,user.getLanguage()+"");
}


RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");
if(RecordSet.next()){
	formid = Util.getIntValue(RecordSet.getString("formid"),0);
	isbill = ""+Util.getIntValue(RecordSet.getString("isbill"),0);
	helpdocid = Util.getIntValue(RecordSet.getString("helpdocid"),0);
}

if( isbill.equals("1") ) {
    RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
    RecordSet.next();
    formid = Util.getIntValue(RecordSet.getString("billformid"),0);
    billid= Util.getIntValue(RecordSet.getString("billid"));
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage()) + " " +  requestmark ;
String needfav ="1";
String needhelp ="";

%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps>
    <div align="right">
        <% if(helpdocid !=0 ) {%> 
        <img src='/images/help_wev8.gif'  style="CURSOR: hand" width=12 onclick="location.href='/docs/docs/DocDsp.jsp?id=<%=helpdocid%>'">
        <%}%>
        <a href="#" onClick="displaydiv()">
            <SPAN id=spanimage><img src="/images/ArrowDownRed_wev8.gif" border=0></span>
        </a>
    </div>
</DIV>


<DIV id=wait style="filter:alpha(opacity=30); height:100%; width:100%">
<TABLE width="100%" height="100%">
	<TR><TD align=center style="font-size: 36pt;">工作流流转...</TD></TR>
</TABLE>
</DIV>

<%@ include file="/workflow/request/WorkflowRequestPicture.jsp" %>


<%
String viewpage= "";
if(isbill.equals("1")){
    RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
    if(RecordSet.next()) viewpage = RecordSet.getString("viewpage");
}
if( !viewpage.equals("")) {
%>
<jsp:include page="<%=viewpage%>" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="requestmark" value="<%=requestmark%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="canactive" value="<%=canactive%>" />
    <jsp:param name="start" value="<%=start%>" />
</jsp:include>
<%}else{%>

<form name="frmmain" method="post" action="/system/systemmonitor/MonitorOperation.jsp">
    <%@ include file="WorkflowViewRequestBody.jsp" %>
    <%@ include file="WorkflowViewSign.jsp" %>
</form>
<%}%>
</body>
</html>
