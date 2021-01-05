
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ page import="weaver.workflow.request.SubWorkflowTriggerService" %>
<%@ page import="weaver.workflow.workflow.WFDocumentManager" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet5" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet6" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RecordSet7" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RecordSet8" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RecordSet9" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RequestTriDiffWfManager" class="weaver.workflow.request.RequestTriDiffWfManager" scope="page" /> 
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/>
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page" />
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" />
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="WFLinkInfo_nf" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page" />

<!-- 微信提醒(QC:98106) -->
 <jsp:useBean id="WechatPropConfig" class="weaver.wechat.util.WechatPropConfig" scope="page"/>
<%
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String viewdoc = Util.null2String(request.getParameter("viewdoc"));
%>
<%
String isworkflowdoc = Util.getIntValue(request.getParameter("isworkflowdoc"),0)+"";//是否为公文

int seeflowdoc = Util.getIntValue(request.getParameter("seeflowdoc"),0);

String newfromdate="a";
String newenddate="b";
String  isrequest = Util.null2String(request.getParameter("isrequest")); // 是否是从相关工作流的链接中来,1:是

int salesMessage = Util.getIntValue(request.getParameter("salesMessage"),-1);
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
String wfdoc = Util.null2String((String)session.getAttribute(requestid+"_wfdoc"));
String message = Util.null2String(request.getParameter("message"));  // 返回的错误信息

int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
String requestname="";      //请求名称
String requestlevel="";     //请求重要级别 0:正常 1:重要 2:紧急

String requestmark = "" ;   //请求编号
String isbill="0";          //是否单据 0:否 1:是

int creater=0;              //请求的创建人
int creatertype = 0;        //创建人类型 0: 内部用户 1: 外部用户
int deleted=0;              //请求是否删除  1:是 0或者其它 否

int billid=0 ;              //如果是单据,对应的单据表的id

int workflowid=0;           //工作流id
String workflowtype = "" ;  //工作流种类

int formid=0;               //表单或者单据的id
int helpdocid = 0;          //帮助文档 id
int nodeid=0;               //节点id
String nodetype="";         //节点类型  0:创建 1:审批 2:实现 3:归档
String workflowname = "" ;          //工作流名称

String isreopen="";                 //是否可以重打开
String isreject="";                 //是否可以退回

int isremark = -1 ;              //当前操作状态  modify by xhheng @ 20041217 for TD 1291
int handleforwardid = -1;     //转办状态

int takisremark = -1;     //意见征询状态


String status = "" ;     //当前的操作类型

String needcheck="requestname";
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
String topage = Util.null2String(request.getParameter("topage")) ;        //返回的页面

String isaffirmance=Util.null2String(request.getParameter("isaffirmance"));//是否需要提交确认

String reEdit=Util.null2String(request.getParameter("reEdit"));//是否为编辑

// 工作流新建文档的处理
String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
String fromPDA=Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录


// 董平 2004-12-2 FOR TD1421  新建流程时如果点击表单上的文档新建按钮，在新建完文档之后，能返回流程，但是文档却没有挂带进来。

String newdocid = Util.null2String(request.getParameter("newdocid"));        // 新建的文档

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
// 操作的用户信息

int userid=user.getUID();                   //当前用户id
int usertype = 0;                           //用户在工作流表中的类型 0: 内部 1: 外部
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";

String reportid = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"reportid"));
String isfromreport = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isfromreport"));
String isfromflowreport = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isfromflowreport"));


if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;

String sql = "" ;
char flag = Util.getSeparator() ;
boolean wfmonitor="true".equals(session.getAttribute(userid+"_"+requestid+"wfmonitor"))?true:false;                //流程监控人

boolean haveBackright=false;            //强制收回权限
boolean haveOverright=false;            //强制归档权限
boolean haveStopright = false;			//暂停权限
boolean haveCancelright = false;		//撤销权限
boolean haveRestartright = false;		//启用权限
String currentnodetype = "";
int currentnodeid = 0;

status = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"status"));
requestname= Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestname"));
requestlevel=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestlevel"));
requestmark= Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestmark"));
creater= Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"creater"),0);
creatertype=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"creatertype"),0);
deleted=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"deleted"),0);
workflowid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"workflowid"),0);
nodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"nodeid"),0);
nodetype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"nodetype"));
workflowname=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"workflowname"));
workflowtype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"workflowtype"));
formid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"formid"),0);
billid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"billid"),0);
isbill=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isbill"));
isremark=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"isremark"));
handleforwardid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"handleforwardid"));
takisremark=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"takisremark"));
helpdocid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"helpdocid"),0);
String IsPendingForward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsPendingForward"));
String IsTakingOpinions=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsTakingOpinions"));
String IsHandleForward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsHandleForward"));
boolean IsCanSubmit="true".equals(session.getAttribute(userid+"_"+requestid+"IsCanSubmit"))?true:false;
String IsBeForward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForward"));
currentnodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"currentnodeid"),0);
currentnodetype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"currentnodetype"));
boolean IsFreeWorkflow="true".equals(session.getAttribute(userid+"_"+requestid+"IsFreeWorkflow"))?true:false;
boolean isImportDetail="true".equals(session.getAttribute(userid+"_"+requestid+"isImportDetail"))?true:false;

boolean IsCanModify="true".equals(session.getAttribute(userid+"_"+requestid+"IsCanModify"))?true:false;
//String coadisforward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"coadisforward"));
boolean coadCanSubmit="true".equals(session.getAttribute(userid+"_"+requestid+"coadCanSubmit"))?true:false;
String coadsigntype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"coadsigntype"));
String IsBeForwardTodo=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForwardTodo"));
String IsBeForwardAlready=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForwardAlready"));  // 已办转发
String IsBeForwardSubmitAlready=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForwardSubmitAlready"));
String IsBeForwardSubmitNotaries=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForwardSubmitNotaries"));
String IsFromWFRemark_T=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsFromWFRemark_T"));

RecordSet.executeSql("select * from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
IsPendingForward=Util.null2String(RecordSet.getString("IsPendingForward"));
IsTakingOpinions=Util.null2String(RecordSet.getString("IsTakingOpinions"));
IsHandleForward=Util.null2String(RecordSet.getString("IsHandleForward"));
}

// 判断当前工作流的当前节点，是否需要默认打开正文tab页
boolean isOpenTextTab = new WFDocumentManager().isOpenTextTab(workflowid+"",nodeid+"");

boolean canForwd=false;
if(isremark == 1 && takisremark ==2 && "1".equals(IsPendingForward)){  //征询意见回复\
canForwd = true;
}
if(takisremark !=2){
if(("0".equals(IsFromWFRemark_T) && "1".equals(IsBeForwardTodo)) 
        || ("1".equals(IsFromWFRemark_T) && "1".equals(IsBeForwardAlready)) 
        || ("2".equals(IsFromWFRemark_T) && "1".equals(IsBeForward))){
	canForwd = true;
}
}
String nextnodetype = "";//提交的下一个节点类型

RecordSet.executeSql("select b.nodetype as nextnodetype from workflow_nodelink a, workflow_flownode b where a.destnodeid=b.nodeid and a.workflowid="+workflowid+" and a.nodeid="+nodeid+" and (a.isreject is null or a.isreject='') order by a.nodepasstime,a.id");
if(RecordSet.next()) nextnodetype = RecordSet.getString("nextnodetype");
RecordSet.executeSql("select isremark,nodeid from workflow_currentoperator where (isremark<8 or isremark>8) and requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by isremark,islasttimes desc");
while(RecordSet.next())	{
    int tempisremark = Util.getIntValue(RecordSet.getString("isremark"),0) ;
    int tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"));
    if( tempisremark == 0 || tempisremark == 1 || tempisremark == 5 || tempisremark == 9|| tempisremark == 7) {                       // 当前操作者或被转发者

        isremark = tempisremark ;
        nodeid=tmpnodeid;
        nodetype=WFLinkInfo_nf.getNodeType(nodeid);
        break ;
    }
}
if( isremark != 0 && isremark != 1  && isremark != 5 && isremark != 8 && isremark != 9&& isremark != 7) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int currentstatus = -1;//当前流程状态(对应流程暂停、撤销而言)
String isModifyLog = "";
RecordSet.executeSql("select t1.ismodifylog,t2.currentstatus from workflow_base t1, workflow_requestbase t2 where t1.id=t2.workflowid and t2.requestid="+requestid);
if(RecordSet.next()) {
	currentstatus = Util.getIntValue(RecordSet.getString("currentstatus"));
	isModifyLog = RecordSet.getString("isModifyLog");
	
}
haveStopright = WfFunctionManageUtil.haveStopright(currentstatus,creater,user,currentnodetype,requestid,false);//流程不为暂停或者撤销状态，当前用户为流程发起人或者系统管理员，并且流程状态不为创建和归档
haveCancelright = WfFunctionManageUtil.haveCancelright(currentstatus,creater,user,currentnodetype,requestid,false);//流程不为撤销状态，当前用户为流程发起人，并且流程状态不为创建和归档
haveRestartright = WfFunctionManageUtil.haveRestartright(currentstatus,creater,user,currentnodetype,requestid,false);//流程为暂停或者撤销状态，当前用户为系统管理员，并且流程状态不为创建和归档
if(currentstatus>-1&&!haveCancelright&&!haveRestartright)
{
	String tips = "";
	if(currentstatus==0)
	{
		tips = SystemEnv.getHtmlLabelName(26154,user.getLanguage());//流程已暂停,请与流程发起人或系统管理员联系!
	}
	else
	{
		tips = SystemEnv.getHtmlLabelName(26155,user.getLanguage());//流程已撤销,请与系统管理员联系!
	}
%>
	<script language="JavaScript">
		var tips = '<%=tips%>';
		jQuery(function(){
			window.top.Dialog.alert(tips,function(){
				window.location.href="/notice/noright.jsp?isovertime=<%=isovertime%>";
			});
		});

	</script>
<%
    return ;
}
RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
if(RecordSet.next()){
	isreopen=RecordSet.getString("isreopen");
	isreject=RecordSet.getString("isreject");
}
weaver.workflow.request.WorkflowIsFreeStartNode stnode=new weaver.workflow.request.WorkflowIsFreeStartNode();
String nodeidss= stnode.getIsFreeStartNode(""+nodeid);
String freedis=stnode.getNodeid(nodeidss);
String isornotFree=stnode.isornotFree(""+nodeid);
WFManager.setWfid(Util.getIntValue(""+workflowid));
WFManager.getWfInfo();
String isFree = WFManager.getIsFree();
//判断是不是创建保存

boolean iscreate=stnode.IScreateNode(""+requestid);
if(!isornotFree.equals("")&&!freedis.equals("")&&!iscreate&&(!"1".equals(isFree) || !"2".equals(nodetype))){
  isreject = "1";
}
// 记录查看日志
String clientip = request.getRemoteAddr();
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;
if(isremark == 8){
	//RecordSet2.executeSql("update workflow_currentoperator set isremark=2,operatedate='"+currentdate+"',operatetime='"+currenttime+"' where requestid="+requestid+" and userid="+userid+" and usertype=0"+usertype);
  //时间与数据库保持一致，所以采用存储过程来更新数据库。

  RecordSet2.executeProc("workflow_CurrentOperator_Copy",requestid+""+flag+userid+flag+usertype+"");
  if(currentnodetype.equals("3")){
    RecordSet2.executeSql("update workflow_currentoperator set iscomplete=1 where requestid="+requestid+" and userid="+userid+" and usertype="+usertype);
  }
	response.sendRedirect("/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+requestid+"&isremark=8&fromFlowDoc="+fromFlowDoc);
	return;
}
/*--  xwj for td2104 on 20050802 begin  --*/
boolean isOldWf = false;
RecordSet3.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSet3.next()){
	if(RecordSet3.getString("nodeid") == null || "".equals(RecordSet3.getString("nodeid")) || "-1".equals(RecordSet3.getString("nodeid"))){
			isOldWf = true;
	}
}
if(isOldWf){//老数据 , 相对 td2104 以前
RecordSet.executeProc("workflow_RequestViewLog_Insert",requestid+"" + flag + userid+"" + flag + currentdate +flag + currenttime + flag + clientip + flag + usertype +flag + nodeid + flag + "9" + flag + -1);
//程序中没有任何地方使用了ordertype='-1'的条件，所以此处直接把-1改成9 by ben 2006-05-24 for TD4396
}
else{
int showorder = 10000;
String orderType = ""; 
RecordSet.executeSql("select agentorbyagentid, agenttype, showorder from workflow_currentoperator where userid = " + userid +
" and nodeid = " + nodeid + " and requestid = " + requestid + " and isremark in ('0','1','4','5','9','7') and usertype = " + usertype);
if(RecordSet.next()){ 
  orderType = "1"; // 当前节点操作人

  showorder  = RecordSet.getInt("showorder");
}
else{

orderType = "2";// 非当前节点操作人
RecordSet2.executeSql("select max(showorder) from workflow_requestviewlog where id = " + requestid + "  and ordertype = '2' and currentnodeid = " + nodeid);
RecordSet2.next();
if(RecordSet2.getInt(1) != -1){ 
showorder = RecordSet2.getInt(1) + 1;
}
}
RecordSet.executeProc("workflow_RequestViewLog_Insert",requestid+"" + flag + userid+"" + flag + currentdate +flag + currenttime + flag + clientip + flag + usertype + flag + nodeid + flag + orderType + flag + showorder);
}
/*--  xwj for td2104 on 20050802 end  --*/

if(! currentnodetype.equals("3") )
    RecordSet.executeProc("SysRemindInfo_DeleteHasnewwf",""+userid+flag+usertype+flag+requestid);
else
    RecordSet.executeProc("SysRemindInfo_DeleteHasendwf",""+userid+flag+usertype+flag+requestid);

String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(18015,user.getLanguage())+":"
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage())+ " - " + status + " "+"<span id='requestmarkSpan'>"+requestmark+"</span>";//Modify by 杨国生 2004-10-26 For TD1231
String needfav ="1";
String needhelp ="";
//if(helpdocid !=0 ) {titlename=titlename + "<img src=/images/help_wev8.gif style=\"CURSOR:hand\" width=12 onclick=\"location.href='/docs/docs/DocDsp.jsp?id="+helpdocid+"'\">";}

String iswfshare = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"iswfshare"));
String isshared = "";
RecordSet.executeSql("select isshared from workflow_base where id = "+workflowid);
if(RecordSet.next()) {
	isshared = RecordSet.getString("isshared");
}

boolean docFlag=flowDoc.haveDocFiled(""+workflowid,""+nodeid);

String  docFlagss=docFlag?"1":"0";
session.setAttribute("requestAdd"+requestid,docFlagss);
//判断正文字段是否显示选择按钮
ArrayList newTextList = flowDoc.getDocFiled(""+workflowid);
if(newTextList != null && newTextList.size() > 0){
  String flowDocField = ""+newTextList.get(1);
  String newTextNodes = ""+newTextList.get(5);
  session.setAttribute("requestFlowDocField"+user.getUID(),flowDocField);
  session.setAttribute("requestAddNewNodes"+user.getUID(),newTextNodes);
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>
<title><%=requestname%></title>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<iframe id="triSubwfIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%
String managepage= "";
String operationpage = "" ;
String hasfileup="";
if(isbill.equals("1")){
    RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
    if(RecordSet.next()) {
        managepage = Util.null2String(RecordSet.getString("managepage"));
        operationpage = Util.null2String(RecordSet.getString("operationpage"));
        hasfileup=Util.null2String(RecordSet.getString("hasfileup"));
    }
}



//TD9145
Prop prop = Prop.getInstance();
String ifchangstatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
String submitname = "" ; // 提交按钮的名称 : 创建, 审批, 实现
String forwardName = "";//转发
String takingopinionsName = ""; //征求意见
String HandleForwardName = ""; //转办
String saveName = "";//保存
String rejectName = "";//退回

String forsubName = "";//转发提交
String forhandName = ""; //转办提交
String forhandbackName = ""; //转办需反馈
String forhandnobackName = ""; //转办不需反馈
String givingopinionsName ="";  //回复
String givingOpinionsnobackName = ""; // 回复不反馈

String givingOpinionsbackName = ""; // 回复需反馈

String ccsubName = "";//抄送提交

String newWFName = "";//新建流程按钮
String newSMSName = "";//新建短信按钮
//微信提醒START(QC:98106)
String newCHATSName = "";//新建微信按钮
String haschats = "";//是否使用新建微信按钮 
//微信提醒END(QC:98106)
String haswfrm = "";//是否使用新建流程按钮
String hassmsrm = "";//是否使用新建短信按钮
int t_workflowid = 0;//新建流程的ID
String subnobackName = "";//提交不需反馈
String subbackName = "";//提交需反馈
String hasnoback = "";//使用提交不需反馈按钮
String hasback = "";//使用提交需反馈按钮
String forsubnobackName = "";//转发批注不需反馈
String forsubbackName = "";//转发批注需反馈
String hasfornoback = "";//使用转发批注不需反馈按钮
String hasforback = "";//使用转发批注需反馈按钮
String ccsubnobackName = "";//抄送批注不需反馈
String ccsubbackName = "";//抄送批注需反馈
String hasccnoback = "";//使用抄送批注不需反馈按钮
String hasccback = "";//使用抄送批注需反馈按钮
String newOverTimeName=""; //超时设置按钮
String hasovertime="";    //是否使用超时设置按钮
String hasforhandback = "";  //是否转办反馈
String hasforhandnoback = ""; //是否转办不需反馈
String hastakingOpinionsback = ""; //是否回复反馈
String hastakingOpinionsnoback = "";//是否回复不需反馈
String isSubmitDirect = ""; // 是否启用提交至退回节点
String submitDirectName = ""; // 提交至退回节点按钮名称
int subbackCtrl = 0;
int forhandbackCtrl = 0;
int forsubbackCtrl = 0;
int ccsubbackCtrl = 0;
int takingOpinionsbackCtrl = 0;

String FreeWorkflowname=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"FreeWorkflowname"));
String sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+nodeid;
String sqlselectNewName = "select * from workflow_nodeCustomNewMenu where enable = 1 and wfid=" + workflowid + " and nodeid=" + nodeid + " order by menuType, id";
if(isremark != 0){
	RecordSet.executeSql("select nodeid from workflow_currentoperator c where c.requestid="+requestid+" and c.userid="+userid+" and c.usertype="+usertype+" and c.isremark='"+isremark+"' ");
	String tmpnodeid="";
	if(RecordSet.next()){
		tmpnodeid = Util.null2String(RecordSet.getString("nodeid"));
	}
	sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+tmpnodeid;
	sqlselectNewName = "select * from workflow_nodeCustomNewMenu where enable = 1 and wfid=" + workflowid + " and nodeid=" + tmpnodeid + " order by menuType, id";
}

RecordSet.executeSql(sqlselectName);

if(RecordSet.next()){
	if(user.getLanguage() == 7){
		submitname = Util.null2String(RecordSet.getString("submitname7"));
		forwardName = Util.null2String(RecordSet.getString("forwardName7"));
		saveName = Util.null2String(RecordSet.getString("saveName7"));
		rejectName = Util.null2String(RecordSet.getString("rejectName7"));
		forsubName = Util.null2String(RecordSet.getString("forsubName7"));
		takingopinionsName = Util.null2String(RecordSet.getString("takingOpName7"));
		HandleForwardName = Util.null2String(RecordSet.getString("forhandName7"));
		forhandnobackName = Util.null2String(RecordSet.getString("forhandnobackName7"));
		forhandbackName = Util.null2String(RecordSet.getString("forhandbackName7"));
		givingopinionsName = Util.null2String(RecordSet.getString("takingOpinionsName7"));
		givingOpinionsnobackName = Util.null2String(RecordSet.getString("takingOpinionsnobackName7"));
		givingOpinionsbackName = Util.null2String(RecordSet.getString("takingOpinionsbackName7"));

		ccsubName = Util.null2String(RecordSet.getString("ccsubName7"));
		newWFName = Util.null2String(RecordSet.getString("newWFName7"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName7"));
		newCHATSName = Util.null2String(RecordSet.getString("newCHATSName7"));//微信提醒(QC:98106)
		subnobackName = Util.null2String(RecordSet.getString("subnobackName7"));
		subbackName = Util.null2String(RecordSet.getString("subbackName7"));
		forsubnobackName = Util.null2String(RecordSet.getString("forsubnobackName7"));
		forsubbackName = Util.null2String(RecordSet.getString("forsubbackName7"));
		ccsubnobackName = Util.null2String(RecordSet.getString("ccsubnobackName7"));
		ccsubbackName = Util.null2String(RecordSet.getString("ccsubbackName7"));
        newOverTimeName = Util.null2String(RecordSet.getString("newOverTimeName7"));
        submitDirectName = Util.null2String(RecordSet.getString("submitDirectName7"));
	}
	else if(user.getLanguage() == 9){
		submitname = Util.null2String(RecordSet.getString("submitname9"));
		forwardName = Util.null2String(RecordSet.getString("forwardName9"));
		takingopinionsName = Util.null2String(RecordSet.getString("takingOpName9"));
		HandleForwardName = Util.null2String(RecordSet.getString("forhandName9"));
		forhandnobackName = Util.null2String(RecordSet.getString("forhandnobackName9"));
		forhandbackName = Util.null2String(RecordSet.getString("forhandbackName9"));
		givingopinionsName = Util.null2String(RecordSet.getString("takingOpinionsName9"));
		givingOpinionsnobackName = Util.null2String(RecordSet.getString("takingOpinionsnobackName9"));
		givingOpinionsbackName = Util.null2String(RecordSet.getString("takingOpinionsbackName9"));

		saveName = Util.null2String(RecordSet.getString("saveName9"));
		rejectName = Util.null2String(RecordSet.getString("rejectName9"));
		forsubName = Util.null2String(RecordSet.getString("forsubName9"));
		ccsubName = Util.null2String(RecordSet.getString("ccsubName9"));
		newWFName = Util.null2String(RecordSet.getString("newWFName9"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName9"));
		newCHATSName = Util.null2String(RecordSet.getString("newCHATSName9"));//微信提醒(QC:98106)
		subnobackName = Util.null2String(RecordSet.getString("subnobackName9"));
		subbackName = Util.null2String(RecordSet.getString("subbackName9"));
		forsubnobackName = Util.null2String(RecordSet.getString("forsubnobackName9"));
		forsubbackName = Util.null2String(RecordSet.getString("forsubbackName9"));
		ccsubnobackName = Util.null2String(RecordSet.getString("ccsubnobackName9"));
		ccsubbackName = Util.null2String(RecordSet.getString("ccsubbackName9"));
        newOverTimeName = Util.null2String(RecordSet.getString("newOverTimeName9"));
        submitDirectName = Util.null2String(RecordSet.getString("submitDirectName9"));
	}
	else{
		submitname = Util.null2String(RecordSet.getString("submitname8"));
		forwardName = Util.null2String(RecordSet.getString("forwardName8"));
		takingopinionsName = Util.null2String(RecordSet.getString("takingOpName8"));
		HandleForwardName = Util.null2String(RecordSet.getString("forhandName8"));
		forhandnobackName = Util.null2String(RecordSet.getString("forhandnobackName8"));
		forhandbackName = Util.null2String(RecordSet.getString("forhandbackName8"));
		givingopinionsName = Util.null2String(RecordSet.getString("takingOpinionsName8"));
		givingOpinionsnobackName = Util.null2String(RecordSet.getString("takingOpinionsnobackName8"));
		givingOpinionsbackName = Util.null2String(RecordSet.getString("takingOpinionsbackName8"));

		saveName = Util.null2String(RecordSet.getString("saveName8"));
		rejectName = Util.null2String(RecordSet.getString("rejectName8"));
		forsubName = Util.null2String(RecordSet.getString("forsubName8"));
		ccsubName = Util.null2String(RecordSet.getString("ccsubName8"));
		newWFName = Util.null2String(RecordSet.getString("newWFName8"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName8"));
		newCHATSName = Util.null2String(RecordSet.getString("newCHATSName8"));//微信提醒(QC:98106)
		subnobackName = Util.null2String(RecordSet.getString("subnobackName8"));
		subbackName = Util.null2String(RecordSet.getString("subbackName8"));
		forsubnobackName = Util.null2String(RecordSet.getString("forsubnobackName8"));
		forsubbackName = Util.null2String(RecordSet.getString("forsubbackName8"));
		ccsubnobackName = Util.null2String(RecordSet.getString("ccsubnobackName8"));
		ccsubbackName = Util.null2String(RecordSet.getString("ccsubbackName8"));
        newOverTimeName = Util.null2String(RecordSet.getString("newOverTimeName8"));
        submitDirectName = Util.null2String(RecordSet.getString("submitDirectName8"));
	}
	haschats = Util.null2String(RecordSet.getString("haschats"));//微信提醒(QC:98106)
	haswfrm = Util.null2String(RecordSet.getString("haswfrm"));
	hassmsrm = Util.null2String(RecordSet.getString("hassmsrm"));
	hasnoback = Util.null2String(RecordSet.getString("hasnoback"));
	hasback = Util.null2String(RecordSet.getString("hasback"));
	hasfornoback = Util.null2String(RecordSet.getString("hasfornoback"));
	hasforback = Util.null2String(RecordSet.getString("hasforback"));
	hasccnoback = Util.null2String(RecordSet.getString("hasccnoback"));
	hasccback = Util.null2String(RecordSet.getString("hasccback"));
	t_workflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
    hasovertime = Util.null2String(RecordSet.getString("hasovertime"));
	hasforhandback = Util.null2String(RecordSet.getString("hasforhandback"));
	hasforhandnoback = Util.null2String(RecordSet.getString("hasforhandnoback"));
	hastakingOpinionsback = Util.null2String(RecordSet.getString("hastakingOpinionsback"));
	hastakingOpinionsnoback = Util.null2String(RecordSet.getString("hastakingOpinionsnoback"));
	isSubmitDirect = Util.null2String(RecordSet.getString("isSubmitDirect"));
	subbackCtrl = Util.getIntValue(Util.null2String(RecordSet.getString("subbackCtrl")), 0);
	forhandbackCtrl = Util.getIntValue(Util.null2String(RecordSet.getString("forhandbackCtrl")), 0);
	forsubbackCtrl = Util.getIntValue(Util.null2String(RecordSet.getString("forsubbackCtrl")), 0);
	ccsubbackCtrl = Util.getIntValue(Util.null2String(RecordSet.getString("ccsubbackCtrl")), 0);
	takingOpinionsbackCtrl = Util.getIntValue(Util.null2String(RecordSet.getString("takingOpinionsbackCtrl")), 0);
}
ArrayList newMenuList0 = new ArrayList(); // 新建流程菜单列表
ArrayList newMenuList1 = new ArrayList(); // 新建短信菜单列表
ArrayList newMenuList2 = new ArrayList(); // 新建微信菜单列表
RecordSet.executeSql(sqlselectNewName);
while(RecordSet.next()) {
	int menuType = Util.getIntValue(RecordSet.getString("menuType"), -1);
	if(menuType < 0) {
		continue;
	}
	HashMap newMenuMap = new HashMap();
	newMenuMap.put("id", Util.getIntValue(RecordSet.getString("id"), 0));
	newMenuMap.put("newName", Util.null2String(RecordSet.getString("newName" + user.getLanguage())));
	if(0 == menuType) {
		newMenuMap.put("workflowid", Util.getIntValue(RecordSet.getString("workflowid"), 0));
		newMenuList0.add(newMenuMap);
	}else if(1 == menuType) {
		newMenuList1.add(newMenuMap);
	}else if(2 == menuType) {
		newMenuList2.add(newMenuMap);
	}
}
String lastnodeid = ""; // 上一次退回操作的节点id
String isSubmitDirectNode = ""; // 上一次退回操作的节点是否启用退回后再提交直达本节点
String sql_isreject = " select a.nodeid lastnodeid, a.logtype from workflow_requestlog a, workflow_nownode b where a.requestid = b.requestid and a.destnodeid = b.nownodeid "
	+ " and b.requestid=" + requestid + " and a.destnodeid=" + nodeid + " and a.nodeid != " + nodeid + " order by a.logid desc";
RecordSet.executeSql(sql_isreject);
while(RecordSet.next()) {
	String logtype = Util.null2String(RecordSet.getString("logtype"));
	if("3".equals(logtype)) {
		lastnodeid = Util.null2String(RecordSet.getString("lastnodeid"));
		break;
	}
	if("0".equals(logtype) || "2".equals(logtype) || "e".equals(logtype) || "i".equals(logtype) || "j".equals(logtype)){
		break;
	}
}
if(!"".equals(lastnodeid)&&!WFLinkInfo_nf.isCanSubmitToRejectNode(requestid,currentnodeid,Util.getIntValue(lastnodeid,0))){
	lastnodeid = "";
}
if(!"".equals(lastnodeid)) {
	RecordSet.executeSql("select * from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + lastnodeid);
	if(RecordSet.next()) {
		isSubmitDirectNode = Util.null2String(RecordSet.getString("isSubmitDirectNode"));
	}
	if("1".equals(isSubmitDirectNode)) { // 如果启用，退回到的节点点击【提交/批准】直接到达执行退回的这个节点。此时不再显示【提交至退回节点】操作按钮
		isSubmitDirect = "";
	}
}else {
	isSubmitDirect = "";
}
if("".equals(submitDirectName)) {
	submitDirectName = SystemEnv.getHtmlLabelName(126507, user.getLanguage());
}
//forhandName = HandleForwardName;

if("".equals(HandleForwardName)){
	HandleForwardName = SystemEnv.getHtmlLabelName(23745,user.getLanguage());
		//forhandName = SystemEnv.getHtmlLabelName(615,user.getLanguage());

}

if("".equals(forhandbackName)){
	if(forhandbackCtrl == 2) {
	forhandbackName = SystemEnv.getHtmlLabelName(23745,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+")";
	}else {
		forhandbackName = SystemEnv.getHtmlLabelName(23745,user.getLanguage());
	}
}


if("".equals(forhandnobackName)){
	if(forhandbackCtrl == 2) {
	forhandnobackName = SystemEnv.getHtmlLabelName(23745,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+")";
	}else {
		forhandnobackName = SystemEnv.getHtmlLabelName(23745,user.getLanguage());
	}
}

if("".equals(givingopinionsName)){
	givingopinionsName = SystemEnv.getHtmlLabelName(18540,user.getLanguage());
}

if("".equals(givingOpinionsnobackName)){
	if(takingOpinionsbackCtrl == 2) {
	givingOpinionsnobackName = SystemEnv.getHtmlLabelName(18540,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+")";
	}else {
		givingOpinionsnobackName = SystemEnv.getHtmlLabelName(18540,user.getLanguage());
	}
}


if("".equals(givingOpinionsbackName)){
	if(takingOpinionsbackCtrl == 2) {
	givingOpinionsbackName = SystemEnv.getHtmlLabelName(18540,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+")";
	}else {
		givingOpinionsbackName = SystemEnv.getHtmlLabelName(18540,user.getLanguage());
	}
}

if(handleforwardid > 0){
	submitname = submitname; // 转办批注
	subnobackName = subnobackName;
	subbackName = subbackName;
}

if(isremark == 1 && takisremark ==2){  //征询意见回复
	submitname = givingopinionsName;
	subnobackName = givingOpinionsnobackName;
	subbackName = givingOpinionsbackName;
}


if(isremark == 1 && takisremark !=2){
	submitname = forsubName;
	subnobackName = forsubnobackName;
	subbackName = forsubbackName;
}
if(isremark == 9||isremark == 7){
	submitname = ccsubName;
	subnobackName = ccsubnobackName;
	subbackName =  ccsubbackName;
}
if("".equals(submitname)){
	if(isremark == 1 || isremark == 9||isremark == 7){
		submitname = SystemEnv.getHtmlLabelName(1006,user.getLanguage()); 
	}
	else if(nodetype.equals("0") ){
		submitname = SystemEnv.getHtmlLabelName(615,user.getLanguage());      // 创建节点或者转发, 为批注

	}else if(nodetype.equals("1")){
		submitname = SystemEnv.getHtmlLabelName(142,user.getLanguage());  // 审批
	}else if(nodetype.equals("2")){
		submitname = SystemEnv.getHtmlLabelName(725,user.getLanguage());  // 实现
	}
}
if("".equals(subbackName)){
		if( isremark == 1 || isremark == 9||isremark == 7)	{
			if((isremark==1 && ("1".equals(hasforback) && forsubbackCtrl == 2)) || (isremark==9 && ("1".equals(hasccback) && ccsubbackCtrl == 2))){
				subbackName = SystemEnv.getHtmlLabelName(1006,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"）";      // 创建节点或者转发, 为提交

			}else{
				subbackName = SystemEnv.getHtmlLabelName(1006,user.getLanguage());
			}
		}else if(nodetype.equals("0"))	{
			if((nodetype.equals("0") && ("1".equals(hasback) && subbackCtrl == 2))){
				subbackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"）";      // 创建节点或者转发, 为提交

			}else{
				subbackName = SystemEnv.getHtmlLabelName(615,user.getLanguage());
			}
		}else if(nodetype.equals("1")){
			if("1".equals(hasback) && subbackCtrl == 2){
				subbackName = SystemEnv.getHtmlLabelName(142,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"）";  // 审批
			}else{
				subbackName = SystemEnv.getHtmlLabelName(142,user.getLanguage());
			}
		}else if(nodetype.equals("2")){
			if("1".equals(hasback) && subbackCtrl == 2){
				subbackName = SystemEnv.getHtmlLabelName(725,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"）";  // 实现
			}else{
				subbackName = SystemEnv.getHtmlLabelName(725,user.getLanguage());
			}
		}
}
if("".equals(subnobackName)){
	if( isremark == 1 || isremark == 9 ||isremark == 7)	{
		if((isremark==1 && forsubbackCtrl == 2) || (isremark==9 && ccsubbackCtrl == 2)){
		subnobackName = SystemEnv.getHtmlLabelName(1006,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"）";      //批注
		}else {
			subnobackName = SystemEnv.getHtmlLabelName(1006,user.getLanguage());
		}
	}else if(nodetype.equals("0"))	{
		if(subbackCtrl == 2) {
		subnobackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"）";      // 创建节点或者转发, 为提交
		}else {
			subnobackName = SystemEnv.getHtmlLabelName(615,user.getLanguage());
		}

	}else if(nodetype.equals("1")){
		if(subbackCtrl == 2) {
		subnobackName = SystemEnv.getHtmlLabelName(142,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"）";  // 审批
		}else {
			subnobackName = SystemEnv.getHtmlLabelName(142,user.getLanguage());
		}
	}else if(nodetype.equals("2")){
		if(subbackCtrl == 2) {
		subnobackName = SystemEnv.getHtmlLabelName(725,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"）";  // 实现
		}else {
			subnobackName = SystemEnv.getHtmlLabelName(725,user.getLanguage());
		}
	}
}
if("".equals(forwardName)){
	forwardName = SystemEnv.getHtmlLabelName(6011,user.getLanguage());
}

if("".equals(takingopinionsName)){
	takingopinionsName = SystemEnv.getHtmlLabelName(82578,user.getLanguage());
}

if("".equals(HandleForwardName)){
	HandleForwardName = SystemEnv.getHtmlLabelName(23745,user.getLanguage());
}

if("".equals(saveName)){
	saveName = SystemEnv.getHtmlLabelName(86,user.getLanguage());
}
if("".equals(rejectName)){
	rejectName = SystemEnv.getHtmlLabelName(236,user.getLanguage());
}
if("".equals(FreeWorkflowname.trim())){
	FreeWorkflowname = SystemEnv.getHtmlLabelName(21781,user.getLanguage());
}
%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%String strBar="[";//菜单%>
<%if (!fromPDA.equals("1") && !wfmonitor) {%>  <!--pda登录不要菜单-->
<%
if (isaffirmance.equals("1") && nodetype.equals("0") && !reEdit.equals("1")){//提交确认菜单
if(IsCanSubmit||coadCanSubmit){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(16634,user.getLanguage())+",javascript:doSubmit_Pre(this),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(16634,user.getLanguage())+"',iconCls:'btn_submit',handler: function(){bodyiframe.doSubmit_Pre(this);}},";
}    
topage = URLEncoder.encode(topage);
//RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location.href='ViewRequest.jsp?reEdit=1&fromFlowDoc=1&requestid="+requestid+"&isovertime="+isovertime+"&topage="+topage+"',_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"',iconCls:'btn_edit',handler: function(){do2ReEditPage();}},";
}else{
if(isremark == 1||isremark == 9||isremark == 7){

if("".equals(ifchangstatus)){
		//RCMenu += "{"+submitname+",javascript:doRemark_nNoBack(),_self}" ;
		//RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+submitname+"',iconCls:'btn_submit',handler: function(){bodyiframe.doRemark_nNoBack();}},";
	}else{
		if(takisremark == 2){
		if((!"1".equals(hastakingOpinionsback)&&!"1".equals(hastakingOpinionsnoback)&&isremark==1&& takisremark ==2)){
		//RCMenu += "{"+subbackName+",javascript:doRemark_nBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+submitname+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doRemark_nBack(this);}},";
		}
		}else if((!"1".equals(hasforback)&&!"1".equals(hasfornoback)&&isremark==1) || (!"1".equals(hasccback)&&!"1".equals(hasccnoback)&&isremark==9)){
			//RCMenu += "{"+subbackName+",javascript:doRemark_nBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+submitname+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doRemark_nBack(this);}},";
		}
		if(takisremark == 2){
		if(("1".equals(hastakingOpinionsback)&&isremark==1)){
				//RCMenu += "{"+subbackName+",javascript:doRemark_nBack(this),_self}";
				//RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doRemark_nBack(this);}},";
			}
			if(("1".equals(hastakingOpinionsnoback)&&isremark==1&& takisremark ==2)){
			//RCMenu += "{"+subnobackName+",javascript:doRemark_nNoBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doRemark_nNoBack(this);}},";
			}
		}else{
		   if(("1".equals(hasforback)&&isremark==1) || ("1".equals(hasccback)&&isremark==9)){
				//RCMenu += "{"+subbackName+",javascript:doRemark_nBack(this),_self}";
				//RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doRemark_nBack(this);}},";
			}
			if(("1".equals(hasfornoback)&&isremark==1) || ("1".equals(hasccnoback)&&isremark==9)){
			//RCMenu += "{"+subnobackName+",javascript:doRemark_nNoBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doRemark_nNoBack(this);}},";
			}
		}
	}

	  if(isremark==1&&IsCanModify){
        strBar += "{text: '"+saveName+"',iconCls:'btn_wfSave',handler: function(){bodyiframe.doSave_nNew(this);}},";
    }
    if((isremark==1&&canForwd)||(isremark==9&&IsPendingForward.equals("1"))){
        //RCMenu += "{"+forwardName+",javascript:doReview(),_self}" ;//add by mackjoe
        //RCMenuHeight += RCMenuHeightStep ;
        strBar += "{text: '"+forwardName+"',iconCls:'btn_forward',handler: function(){bodyiframe.doReview();}},";
    }
}else if(isremark == 5){		//超时
    if("".equals(ifchangstatus)){
		//RCMenu += "{"+submitname+",javascript:doSubmitNoBack(this),_self}" ;
		//RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+submitname+"',iconCls:'btn_submit',handler: function(){bodyiframe.doSubmitNoBack(this);}},";
	}else{
		if(!"1".equals(hasnoback)){
			//RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doSubmitBack(this);}},";
		}else{
			if("1".equals(hasback)){
				//RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
				//RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doSubmitBack(this);}},";
			}
			//RCMenu += "{"+subnobackName+",javascript:doSubmitNoBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doSubmitNoBack(this);}},";
		}
	}
    if("1".equals(isSubmitDirect)) {
		//RCMenu += "{" + submitDirectName + ", javascript:doSubmitDirect(this, \\\"Submit\\\"), _self}";
		//RCMenuHeight += RCMenuHeightStep;
		strBar += "{text: '" + submitDirectName + "', iconCls: 'btn_submit', handler: function(){doSubmitDirect(this, \\\"Submit\\\");}},";
	}
}else {

if(IsCanSubmit||coadCanSubmit){
if (isaffirmance.equals("1") && nodetype.equals("0") && reEdit.equals("1")){
    if("".equals(ifchangstatus)){
		//RCMenu += "{"+submitname+",javascript:doAffirmanceNoBack(this),_self}" ;
		//RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+submitname+"',iconCls:'btn_submit',handler: function(){bodyiframe.doAffirmanceNoBack(this);}},";
	}else{
		if((!"1".equals(hasnoback)&&!"1".equals(hasback))){
			//RCMenu += "{"+subbackName+",javascript:doAffirmanceBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+submitname+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doAffirmanceBack(this);}},";
		}else{
			if("1".equals(hasback)){
				//RCMenu += "{"+subbackName+",javascript:doAffirmanceBack(this),_self}";
				//RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doAffirmanceBack(this);}},";
			}
				if("1".equals(hasnoback)){
			//RCMenu += "{"+subnobackName+",javascript:doAffirmanceNoBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doAffirmanceNoBack(this);}},";
				}
		}
	}
    if("1".equals(isSubmitDirect)) {
		//RCMenu += "{" + submitDirectName + ", javascript:doSubmitDirect(this, \\\"Affirmance\\\"), _self}";
		//RCMenuHeight += RCMenuHeightStep;
		strBar += "{text: '" + submitDirectName + "', iconCls: 'btn_submit', handler: function(){doSubmitDirect(this, \\\"Affirmance\\\");}},";
	}
}else{
    if("".equals(ifchangstatus)){
		//RCMenu += "{"+submitname+",javascript:doSubmit(this),_self}" ;
		//RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+submitname+"',iconCls:'btn_submit',handler: function(){bodyiframe.doSubmitNoBack(this);}},";
	}else{
		if((!"1".equals(hasnoback)&&!"1".equals(hasback)) ){
			//RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+submitname+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doSubmitBack(this);}},";
		}else{
			if("1".equals(hasback) ){
				//RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
				//RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doSubmitBack(this);}},";
			}
			if("1".equals(hasnoback) ){
			//RCMenu += "{"+subnobackName+",javascript:doSubmitNoBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doSubmitNoBack(this);}},";
			}
		}
	}
    if("1".equals(isSubmitDirect)) {
		//RCMenu += "{" + submitDirectName + ", javascript:doSubmitDirect(this, \\\"Submit\\\"), _self}";
		//RCMenuHeight += RCMenuHeightStep;
		strBar += "{text: '" + submitDirectName + "', iconCls: 'btn_submit', handler: function(){doSubmitDirect(this, \\\"Submit\\\");}},";
	}
}
if(IsFreeWorkflow){
    //RCMenu += "{"+FreeWorkflowname+",javascript:doFreeWorkflow(),_self}" ;
    //RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+FreeWorkflowname+"',iconCls:'btn_edit',handler: function(){bodyiframe.doFreeWorkflow(this);}},";
}
  if (isImportDetail) {
        strBar += "{text: '" + SystemEnv.getHtmlLabelName(26255, user.getLanguage()) + "',iconCls:'btn_edit',handler: function(){bodyiframe.doImportDetail();}},";
    }

//RCMenu += "{"+saveName+",javascript:doSave_nNew(this),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+saveName+"',iconCls:'btn_wfSave',handler: function(){bodyiframe.doSave_nNew(this);}},";
if( isreject.equals("1")&&isremark==0){
    //RCMenu += "{"+rejectName+",javascript:doReject_New(),_self}" ;
    //RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+rejectName+"',iconCls:'btn_rejectName',handler: function(){bodyiframe.doReject_New();}},";
}
}
if(IsPendingForward.equals("1")){
//RCMenu += "{"+forwardName+",javascript:doReview(),_self}" ;//Modified by xwj for td3247 20051201
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+forwardName+"',iconCls:'btn_forward',handler: function(){bodyiframe.doReview();}},";
}

if(IsTakingOpinions.equals("1")){  //征求意见
strBar += "{text: '"+takingopinionsName+"',iconCls:'btn_forward',handler: function(){bodyiframe.doReview2();}},"; 
}
if(IsHandleForward.equals("1")){   //转办
	if("".equals(ifchangstatus)){
		//RCMenu += "{"+submitname+",javascript:do"+subfun+"NoBack(this),_self}" ;
		//RCMenuHeight += RCMenuHeightStep ; 
		strBar += "{text: '"+HandleForwardName+"',iconCls:'btn_forward',handler: function(){bodyiframe.doReview3();}},";  //转发
		//_iscanforward = true;
	}else{
		if((!"1".equals(hasforhandnoback)&&!"1".equals(hasforhandback))){
			//RCMenu += "{"+subbackName+",javascript:do"+subfun+"Back(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+HandleForwardName+"',iconCls:'btn_forward',handler: function(){bodyiframe.doReview3();}},";  //转发
		}else{
			if( "1".equals(hasforhandback)){
				//RCMenu += "{"+subbackName+",javascript:do"+subfun+"Back(this),_self}";
				//RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+forhandbackName+"',iconCls:'btn_forwardback3',handler: function(){bodyiframe.doReviewback3();}},";  //转发
			}
			if( "1".equals(hasforhandnoback)){
			//RCMenu += "{"+subnobackName+",javascript:do"+subfun+"NoBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
		strBar += "{text: '"+forhandnobackName+"',iconCls:'btn_forwardnobacke3',handler: function(){bodyiframe.doReviewnoback3();}},";  //转发
			}
		}
	}
}

%>

<%  if(isreopen.equals("1") && false ){%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:doReopen(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+"',iconCls:'btn_doReopen',handler: function(){bodyiframe.doReopen();}},";
%>
<%  }
}
%>
<%
/*added by cyril on 2008-07-10 for TD:8835*/
if(isModifyLog.equals("1")) {
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(21625,user.getLanguage())+",javascript:doViewModifyLog(),_self}" ;
	//RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(21625,user.getLanguage())+"',iconCls:'btn_doViewModifyLog',handler: function(){bodyiframe.doViewModifyLog();}},";
}
/*end added by cyril on 2008-07-10 for TD:8835*/
/*TD9145 START*/
for(int i = 0; i < newMenuList0.size(); i++) {
	HashMap newMenuMap = (HashMap) newMenuList0.get(i);
	int menuid = (Integer) newMenuMap.get("id");
	if(menuid > 0) {
		newWFName = (String) newMenuMap.get("newName");
		t_workflowid = (Integer) newMenuMap.get("workflowid");
	if("".equals(newWFName)){
		newWFName = SystemEnv.getHtmlLabelName(1239,user.getLanguage()) + (i + 1);
	}
	RequestCheckUser.resetParameter();
	RequestCheckUser.setUserid(userid);
	RequestCheckUser.setWorkflowid(t_workflowid);
	RequestCheckUser.setLogintype(logintype);
	RequestCheckUser.checkUser();
	int  t_hasright=RequestCheckUser.getHasright();
	if(t_hasright == 1){
		//RCMenu += "{"+newWFName+",javascript:onNewRequest("+t_workflowid+", "+requestid+",0),_top} " ;
		//RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+newWFName+"',iconCls:'btn_newWFName',handler: function(){bodyiframe.onNewRequest("+t_workflowid+", "+requestid+",0);}},";
	}
	}
}
RTXConfig rtxconfig = new RTXConfig();
String temV = rtxconfig.getPorp(rtxconfig.CUR_SMS_SERVER_IS_VALID);
boolean valid = false;
if (temV != null && temV.equalsIgnoreCase("true")) {
	valid = true;
} else {
	valid = false;
}
if(valid == true && HrmUserVarify.checkUserRight("CreateSMS:View", user)){
	for(int i = 0; i < newMenuList1.size(); i++) {
		HashMap newMenuMap = (HashMap) newMenuList1.get(i);
		int menuid = (Integer) newMenuMap.get("id");
		if(menuid > 0) {
			newSMSName = (String) newMenuMap.get("newName");
	if("".equals(newSMSName)){
		newSMSName = SystemEnv.getHtmlLabelName(16444,user.getLanguage()) + (i + 1);
	}
	//RCMenu += "{"+newSMSName+",javascript:onNewSms("+workflowid+", "+nodeid+", "+requestid+"),_top} " ;
	//RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+newSMSName+"',iconCls:'btn_newSMSName',handler: function(){bodyiframe.onNewSms("+workflowid+", "+nodeid+", "+requestid+", " + menuid + ");}},";
		}
	}
}
//微信提醒START(QC:98106)
if(WechatPropConfig.isUseWechat()){
	for(int i = 0; i < newMenuList2.size(); i++) {
		HashMap newMenuMap = (HashMap) newMenuList2.get(i);
		int menuid = (Integer) newMenuMap.get("id");
		if(menuid > 0) {
			newCHATSName = (String) newMenuMap.get("newName");
	if("".equals(newCHATSName)){
		newCHATSName = SystemEnv.getHtmlLabelName(32818,user.getLanguage()) + (i + 1);
	} 
	strBar += "{text: '"+newCHATSName+"',iconCls:'btn_newChatsName',handler: function(){bodyiframe.onNewChats("+workflowid+", "+nodeid+", "+requestid+", " + menuid + ");}},";
		}
	}
}
//微信提醒END(QC:98106)
/*TD9145 END*/
if("1".equals(hasovertime)&&isremark==0){
	if("".equals(newOverTimeName)){
		newOverTimeName = SystemEnv.getHtmlLabelName(18818,user.getLanguage());
	}
	//RCMenu += "{"+newOverTimeName+",javascript:onNewOverTime(),_top} " ;
	//RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+newOverTimeName+"',iconCls:'btn_newSMSName',handler: function(){bodyiframe.onNewOverTime();}},";
}
String isTriDiffWorkflow=null;
RecordSet.executeSql("select isTriDiffWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
	isTriDiffWorkflow=Util.null2String(RecordSet.getString("isTriDiffWorkflow"));
}

if (isremark != 1 && isremark != 8 && isremark != 9) {
	List<Map<String, String>> buttons = SubWorkflowTriggerService.getManualTriggerButtons(workflowid, nodeid);
	for( int indexId = 0; indexId < buttons.size() ; indexId++){
		Map<String, String> button = buttons.get(indexId);
		int subwfSetId = Util.getIntValue(button.get("subwfSetId"),0);
		int buttonNameId = Util.getIntValue(button.get("buttonNameId"),0);
		String triSubwfName7 = Util.null2String(button.get("triSubwfName7"));
		String triSubwfName8 = Util.null2String(button.get("triSubwfName8"));
		String workflowNames = Util.null2String(button.get("workflowNames"));
		String triSubwfName = "";
		if(user.getLanguage() == 8){
			triSubwfName = triSubwfName8;
		}else{
			triSubwfName = triSubwfName7;
		}
		if(triSubwfName.equals("")){
			triSubwfName = SystemEnv.getHtmlLabelName(22064,user.getLanguage())+(indexId+1);
		}
		strBar += "{text: '"+triSubwfName+"',iconCls:'btn_relateCwork',handler: function(){triSubwf2("+subwfSetId+",\\\""+workflowNames+"\\\");}},";
	}
}

if(!isfromtab&&!"1".equals(session.getAttribute("istest"))){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self}" ;//td3425 xwj 2005-12-31
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+"',iconCls:'btn_back',handler: function(){bodyiframe.doBack();}},";
}
%>
<%--add by ben for TD3665 begin--%>
<%
HashMap map = WfFunctionManageUtil.wfFunctionManageByNodeid(workflowid,nodeid);
String ov = (String)map.get("ov");
String rb = (String)map.get("rb");
haveOverright=((isremark != 1&&isremark != 9&&isremark != 5) || (isremark == 7 && !"2".equals(coadsigntype))) && "1".equals(ov) && WfForceOver.isNodeOperator(requestid,userid) && !currentnodetype.equals("3");
//haveBackright=isremark != 1&&isremark != 9&&isremark != 7&&isremark != 5&&!"0".equals(rb) && WfForceDrawBack.isHavePurview(requestid,userid,Integer.parseInt(logintype),-1,-1) && !currentnodetype.equals("0");
haveBackright=WfForceDrawBack.checkOperatorIsremark(requestid, userid, usertype, isremark)&&!"0".equals(rb) && WfForceDrawBack.isHavePurview(requestid,userid,Integer.parseInt(logintype),-1,-1) && !currentnodetype.equals("0");
if(haveOverright){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+",javascript:doDrawBack(this),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+"',iconCls:'btn_doDrawBack',handler: function(){bodyiframe.doDrawBack(this);}},";
}
if(haveBackright){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(18359,user.getLanguage())+",javascript:doRetract(this),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(18359,user.getLanguage())+"',iconCls:'btn_doRetract',handler: function(){bodyiframe.doRetract(this);}},";
}
if(haveStopright)
{
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(20387,user.getLanguage())+"',iconCls:'btn_end',handler: function(){bodyiframe.doStop(this);}},";
}
if(haveCancelright)
{
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(16210,user.getLanguage())+"',iconCls:'btn_backSubscrible',handler: function(){bodyiframe.doCancel(this);}},";
}
if(haveRestartright)
{
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"',iconCls:'btn_next',handler: function(){bodyiframe.doRestart(this);}},";
}
if(nodetype.equals("0")&&isremark != 1&&isremark != 9&&isremark != 7&&isremark != 5&&WfFunctionManageUtil.IsShowDelButtonByReject(requestid,workflowid)){    // 创建节点(退回创建节点也是)
//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"',iconCls:'btn_doDelete',handler: function(){bodyiframe.doDelete();}},";
}
}
strBar += "{text: '"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+"',iconCls:'btn_print',handler: function(){bodyiframe.openSignPrint();}},";        
}

strBar +="{text: '"+SystemEnv.getHtmlLabelName(21533,user.getLanguage())+"',iconCls:'btn_collect',handler: function(){doPrintViewLog();}},";

//帮助
strBar +="{text: '"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+"',iconCls:'btn_help',handler: function(){showHelp();}},";
//收藏
strBar +="{text: '"+SystemEnv.getHtmlLabelName(22255,user.getLanguage())+"',iconCls:'btn_collect',handler: function(){openFavouriteBrowser();}},";

if(strBar.lastIndexOf(",")>-1) strBar = strBar.substring(0,strBar.lastIndexOf(","));
strBar+="]";
%>
<%-- end--%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/workflow/request/RequestShowHelpDoc.jsp" %>
        <input type=hidden name=seeflowdoc value="<%=seeflowdoc%>">
		<input type=hidden name=isworkflowdoc value="<%=isworkflowdoc%>">
        <input type=hidden name=wfdoc value="<%=wfdoc%>">
        <input type=hidden name=isshared value="<%=isshared%>">
        <input type="hidden" name="isovertime" value="<%=isovertime%>">
        <input type=hidden name=picInnerFrameurl id=picInnerFrameurl value="/workflow/request/WorkflowRequestPictureInner.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&randpara=<%=System.currentTimeMillis()%>">
		<input type=hidden name=statInnerFrameurl id=statInnerFrameurl value="WorkflowRequestPicture.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&hasExt=true&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&randpara=<%=System.currentTimeMillis()%>">
		<input type=hidden name=reqeustresourceframeurl id="reqeustresourceframeurl" value="/workflow/request/RequestResourcesTab.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&workflowid=<%=workflowid%>&reportid=<%=reportid%>&isfromreport=<%=isfromreport%>&isfromflowreport=<%=isfromflowreport%>&iswfshare=<%=iswfshare%>">
		<input type=hidden name=workflowshareurl id="workflowshareurl" value="/workflow/request/WorkflowSharedScope.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&wfid=<%=workflowid%>">

		<%@ include file="/workflow/request/NewRequestFrame.jsp" %>
</body>
</html>

<script language="JavaScript">

function doPrintViewLog(){

if(window.top.Dialog){
	diag_vote = new window.top.Dialog();
} else {
	diag_vote = new Dialog();
}
diag_vote.currentWindow = window;
diag_vote.Width = 800;
diag_vote.Height = 550;
diag_vote.Modal = true;
diag_vote.maxiumnable = true;
diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(21533,user.getLanguage())%>";
diag_vote.URL = "/workflow/request/WorkflowLogNew.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>";
diag_vote.show();


}

	//转发权限
	var forward=0;
	//引用权限
	var submit=0;
	<%
		if(!"".equals(forwardName)){
	%>
			forward=1;
	<%
		}
		if(!"".equals(submitname)){
	%>
			submit=1;
	<%		
		}
	%>
	var bodyiframeurl = location.href.substring(location.href.indexOf("ManageRequestNoFormBill.jsp?")+28);
	bodyiframeurl=bodyiframeurl+"&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&forward="+forward+"&submit="+submit;
	function setbodyiframe(){
		document.getElementById("bodyiframe").src="ManageRequestNoFormBillIframe.jsp?"+bodyiframeurl;
		//initNewRequestFrame();
		initNewRequestFrame1();
		enableAllmenuParent();
		//eventPush(document.getElementById('bodyiframe'),'load',loadcomplete);
		<%
		String docfileid_xx = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
		String newdocid_xx = Util.null2String(request.getParameter("newdocid"));        // 新建的文档	
		String uselessFlag = Util.null2String(request.getParameter("uselessFlag"));
		System.out.println("-------2-------docfileid_xx="+docfileid_xx+",newdocid_xx="+newdocid_xx+",uselessFlag="+uselessFlag);
		if(("".equals(docfileid_xx) || "".equals(newdocid_xx)) && isOpenTextTab && "".equals(uselessFlag)) {
		%>
			eventPush(document.getElementById('bodyiframe'),'load',loadCompleteToWfText);
		<%}else{%>
			eventPush(document.getElementById('bodyiframe'),'load',loadcomplete);
		<%}%>
	}
	//window.attachEvent("onload", setbodyiframe);
	if (window.addEventListener){
	    window.addEventListener("load", setbodyiframe, false);
	}else if (window.attachEvent){
	    window.attachEvent("onload", setbodyiframe);
	}else{
	    window.onload=setbodyiframe;
	}

    var wftitle="<%=titlename%>";
	var isfromtab=<%=isfromtab%>;	
	var bar=eval("<%=strBar%>");
	if("<%=seeflowdoc%>"=="1"){
		bar = eval("[]");
		if(document.getElementById("rightMenu")!=null){
			document.getElementById("rightMenu").style.display="none";
		}
	}
	function do2ReEditPage(){
		location.href = "ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&reEdit=1&fromFlowDoc=<%=fromFlowDoc%>&requestid=<%=requestid%>&isovertime=<%=isovertime%>&topage=<%=topage%>";
	}
	
			function doImportDetail(){
    if(!checkDataChange()){
        if(confirm("<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>")){
            window.showModalDialog("/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>",window);
        }
    }else{
        window.showModalDialog("/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>",window);
    }
}
</script>