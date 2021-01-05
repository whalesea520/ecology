<%--接收客户端提交的参数数据，并将其格式转化为创建工作流页面所需要的格式，主要是工作流的数据信息的格式--%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RequestDataPost" class="weaver.workflow.request.RequestDataPost" scope="page" />

<%

//获得工作流的基本信息
String workflowid = Util.null2String(request.getParameter("workflowid"));   //必填项

//从参数中获得用户信息，因为客户端提交的POST请求并不支持session
int userid = Util.getIntValue(request.getParameter("userid"));  //必填项
String logintype = Util.null2String(request.getParameter("logintype")); //必填项

//工作流请求的名称，也就是工作流显示页面中的说明字段，这个字段为必填字段
String requestname = Util.null2String(request.getParameter("requestname")); //必填项

//请求解别，也就是工作流显示页面上的（正常 主页 标题）选项
String requestlevel = Util.null2String(request.getParameter("requestlevel")); //必填项

//得到用户的名称
String username = "";
if(logintype.equals("1"))
	username = ResourceComInfo.getResourcename(""+userid);
if(logintype.equals("2"))
	username = CustomerInfoComInfo.getCustomerInfoname(""+userid);

//检查用户是否有创建权限
RequestCheckUser.setUserid(userid);
RequestCheckUser.setWorkflowid(Util.getIntValue(workflowid,0));
RequestCheckUser.setLogintype(logintype);
RequestCheckUser.checkUser();
int  hasright=RequestCheckUser.getHasright();

//如果没有权限那么向返回的内容写入false字符串，标识创建失败
if(hasright==0){
    //out.println("false:没有创建权限");
    //return;
}

String nodeid= "" ;
String formid= "" ;
String isbill="0";

//查询该工作流的表单id，是否是单据（0否，1是）
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid);
if(RecordSet.next()){
	formid = Util.null2String(RecordSet.getString("formid"));
	isbill = ""+Util.getIntValue(RecordSet.getString("isbill"),0);
}

//因为这能创建表单，所以如果此类型是单据的话，那么返回错误信息
if(isbill.equals("1")){
    out.print("1");
    return;
}

//查询该工作流的当前节点id （即改工作流的创建节点 ）
RecordSet.executeProc("workflow_CreateNode_Select",workflowid);
if(RecordSet.next())  nodeid = Util.null2String(RecordSet.getString(1)) ;

//对不同的模块来说,可以定义自己相关的内容，作为请求默认值，比如将 docid 赋值，作为该请求的默认文档
//默认的值可以赋多个，中间用逗号格开
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
if(hrmid.equals("") && logintype.equals("1")) hrmid = "" + userid ;
if(crmid.equals("") && logintype.equals("2")) crmid = "" + userid ;

//获得当前的日期和时间
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;

%>



<%
//存储字段名称和字段id的映射

//存储主字段映射
ArrayList fieldids = new ArrayList();
ArrayList fieldNames = new ArrayList();
//存储明细字段映射
ArrayList detailFieldids = new ArrayList();
ArrayList detailFieldNames = new ArrayList();

//得到主字段数据
String selectSql = "SELECT a.fieldid, b.fieldname FROM workflow_formfield a, workflow_formdict b WHERE a.fieldid=b.id and (a.isdetail<>'1' or a.isdetail is null) and a.formid="+formid;
RecordSet.executeSql(selectSql);
while(RecordSet.next()){
    fieldids.add(RecordSet.getString(1));
    fieldNames.add(RecordSet.getString(2));
}

//得到明细字段数据
selectSql = "SELECT a.fieldid, b.fieldname FROM workflow_formfield a, workflow_formdictdetail b WHERE a.fieldid=b.id and a.isdetail='1' and a.formid="+formid;
RecordSet.executeSql(selectSql);
while(RecordSet.next()){
    detailFieldids.add(RecordSet.getString(1));
    detailFieldNames.add(RecordSet.getString(2));
}

//设置创建工作流需要的必要的参数
RequestDataPost.setParam("userid",""+userid);
RequestDataPost.setParam("logintype",logintype);
RequestDataPost.setParam("src","submit");
RequestDataPost.setParam("iscreate","1");
RequestDataPost.setParam("workflowid",workflowid);
RequestDataPost.setParam("requestlevel",requestlevel);
RequestDataPost.setParam("formid",formid);
RequestDataPost.setParam("isbill","0");
RequestDataPost.setParam("nodeid",nodeid);
RequestDataPost.setParam("nodetype","0");
RequestDataPost.setParam("requestname",requestname);
RequestDataPost.setParam("remark","<br>"+username+" "+currentdate+" "+currenttime);

//转化主字段的参数名称为内部数据工作流需要的名称格式
String fieldValue = "";
for(int i=0; i<fieldNames.size(); i++){
    if((fieldValue = request.getParameter("field_"+fieldNames.get(i))) != null){
        RequestDataPost.setParam("field"+fieldids.get(i),fieldValue);
    }
}

//得到明细数据的行数
int nodesnum = Util.getIntValue(request.getParameter("nodesnum"));
RequestDataPost.setParam("nodesnum",""+nodesnum);

//转化明细字段的参数名称为内部数据工作流需要的名称格式
for(int i=0; i<nodesnum; i++){
    for(int j=0; j<detailFieldNames.size(); j ++){
        if((fieldValue = request.getParameter("field_"+detailFieldNames.get(j)+"_"+i)) != null){
            RequestDataPost.setParam("field"+detailFieldids.get(j)+"_"+i,fieldValue);
        }
    }
}
String serverPage = "http://"+request.getServerName()+"/workflow/request/RequestOutOperation.jsp";

out.print(RequestDataPost.doPost(serverPage));
%>
