
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.common.StringUtil" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONException" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ page import="weaver.workflow.request.SubWorkflowTriggerService" %>
<%@ page import="weaver.workflow.request.RequestShare"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<!-- 
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
-->

<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<!--添加插件-->
<script type="text/javascript" charset="UTF-8" src="/js/nicescroll/jquery.nicescroll_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwfat_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
<LINK href="/hrm/area/browser/areabrowser.css" type=text/css rel=STYLESHEET>
<style type="text/css">
._uploadForClass .progressBarInProgress {
	height:2px;
	background:#6b94fe;
	margin:0!important;
}
._uploadForClass .progressWrapper {
	height:30px!important;
	width:100%!important;
	border-bottom:1px solid #dadada;
}
._uploadForClass .progressContainer  {
	background-color:#f5f5f5!important;
	border:solid 0px!important;
	padding-top:5px!important;
	padding-left:0px!important;
	padding-right:0px!important;
	padding-bottom:5px!important;
	margin:0px!important;
}
._uploadForClass .progressCancel {
	width:20px!important;
	height:20px!important;
	background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;
}
._uploadForClass .progressBarStatus {
	display:none!important;
}
._uploadForClass .edui-for-wfannexbutton{
	cursor:pointer!important;
}
._uploadForClass .progressName{
	width:350px!important;
	height:18px;
	padding-left:5px;
	font-size:12px;
	font-family:寰蒋闆呴粦;
	font-weight:normal!important;
	white-space:nowrap;
	overflow:hidden;
	text-overflow:ellipsis;
	color:#242424;
}
</style>
<!-- ckeditor的一些方法在uk中的实现 -->
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>
<SCRIPT language="javascript" src="/hrm/area/browser/areabrowser_wev8.js"></script>
<script language=javascript>
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>

<!-- word转html插件 -->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet5" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet6" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RecordSet7" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RecordSet8" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RecordSet9" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RequestTriDiffWfManager" class="weaver.workflow.request.RequestTriDiffWfManager" scope="page" />
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page" />
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page" />
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
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<!-- 微信提醒(QC:98106) -->
<jsp:useBean id="WechatPropConfig" class="weaver.wechat.util.WechatPropConfig" scope="page"/>
<%
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
%>
<%
int init_road=-1;//当前节点的路径编辑权限
String init_nodename=SystemEnv.getHtmlLabelName(15070, user.getLanguage());
int init_frms=-1;
int currtype=-1;//当前节点的类型


String isworkflowdoc = Util.getIntValue(request.getParameter("isworkflowdoc"),0)+"";//是否为公文
int seeflowdoc = Util.getIntValue(request.getParameter("seeflowdoc"),0);

String newfromdate="a";
String newenddate="b";
String  isrequest = Util.null2String(request.getParameter("isrequest")); // 是否是从相关工作流的链接中来,1:是
int salesMessage = Util.getIntValue(request.getParameter("salesMessage"),-1);
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
String wfdoc = Util.null2String((String)session.getAttribute(requestid+"_wfdoc"));
String message = Util.null2String(session.getAttribute("errormsgid_"+user.getUID()+"_"+requestid));  // 返回的错误信息
if(StringUtil.isNull(message)){
    message = Util.null2String(request.getParameter("message"));
}
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

// 操作的用户信息
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
int usertype = 0;                           //用户在工作流表中的类型 0: 内部 1: 外部
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";
String isrejectremind="";
String ischangrejectnode="";
String isselectrejectnode="";
int desrequestid=0;
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

int lastOperator=0;
String lastOperateDate="";
String lastOperateTime="";

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

boolean canForwd = false;
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
currentnodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"currentnodeid"),0);
boolean isImportDetail="true".equals(session.getAttribute(userid+"_"+requestid+"isImportDetail"))?true:false;

currentnodetype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"currentnodetype"));
boolean IsFreeWorkflow="true".equals(session.getAttribute(userid+"_"+requestid+"IsFreeWorkflow"))?true:false;
boolean IsCanModify="true".equals(session.getAttribute(userid+"_"+requestid+"IsCanModify"))?true:false;
//String coadisforward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"coadisforward"));
boolean coadCanSubmit="true".equals(session.getAttribute(userid+"_"+requestid+"coadCanSubmit"))?true:false;
String coadsigntype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"coadsigntype"));

lastOperator=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"lastOperator"),0);
lastOperateDate=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateDate"));
lastOperateTime=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateTime"));

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
		window.top.Dialog.alert(tips,function(){
			window.location.href="/notice/noright.jsp?isovertime=<%=isovertime%>";
		});
	</script>
<%
    return ;
}
int IsFreeNode=0;
/*------ xwj for td3131 20051117 ----- end----------*/
RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
if(RecordSet.next()){
	isreopen=RecordSet.getString("isreopen");
	isreject=RecordSet.getString("isreject");
	IsFreeNode=Util.getIntValue(RecordSet.getString("IsFreeNode"),0);
}
// 记录查看日志
weaver.workflow.request.WorkflowIsFreeStartNode stnode=new weaver.workflow.request.WorkflowIsFreeStartNode();
 String nodeidss= stnode.getIsFreeStartNode(""+nodeid);
 String freedis=stnode.getNodeid(nodeidss);
 String isornotFree=stnode.isornotFree(""+nodeid);
  
 //判断是不是创建保存
 boolean iscreate=stnode.IScreateNode(""+requestid); 
  if(!isornotFree.equals("")&&!freedis.equals("")&&!iscreate){
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

if(! currentnodetype.equals("3") )
    RecordSet.executeProc("SysRemindInfo_DeleteHasnewwf",""+userid+flag+usertype+flag+requestid);
else
    RecordSet.executeProc("SysRemindInfo_DeleteHasendwf",""+userid+flag+usertype+flag+requestid);

String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(18015,user.getLanguage())+":"
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage())+ " - " + status + " "+requestmark;//Modify by 杨国生 2004-10-26 For TD1231
String needfav ="1";
String needhelp ="";
//if(helpdocid !=0 ) {titlename=titlename + "<img src=/images/help_wev8.gif style=\"CURSOR:hand\" width=12 onclick=\"location.href='/docs/docs/DocDsp.jsp?id="+helpdocid+"'\">";}

boolean docFlag=flowDoc.haveDocFiled(""+workflowid,""+nodeid);
String isSignMustInput="0";
String isFormSignature=null;
rssign.execute("select issignmustinput,isFormSignature from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(rssign.next()){
	isSignMustInput = ""+Util.getIntValue(rssign.getString("issignmustinput"), 0);
	isFormSignature = Util.null2String(rssign.getString("isFormSignature"));
}
int isUseWebRevision_t = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
if(isUseWebRevision_t != 1){
	isFormSignature = "";
}
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

WFManager.setWfid(Util.getIntValue(""+workflowid));
WFManager.getWfInfo();
String isFree = WFManager.getIsFree();

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>    
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 
<style>
.wordSpan{font-family:MS Shell Dlg,Arial;CURSOR: hand;font-weight:bold;FONT-SIZE: 10pt}
</style>
 -->
</head>
<title><%=requestname%></title>


<script language="javascript">

//TD4262 增加提示信息  开始
function windowOnload()
{
<%
	if( message.equals("1") ) {//工作流信息保存错误
%>
//	      contentBox = $GetEle("divFavContent16332");
//          showObjectPopup(contentBox);
//          window.setTimeout("oPopup.hide()", 2000);
		  var content="<%=SystemEnv.getHtmlLabelName(16332,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("$GetEle('message_table_Div').style.display='none';$GetEle('HelpFrame').style.display='none'", 2000);
<%
	} else if( message.equals("2") ) {//工作流下一节点或下一节点操作者错误
%>
//	      contentBox = $GetEle("divFavContent16333");
//          showObjectPopup(contentBox);
//          window.setTimeout("oPopup.hide()", 2000);
		  var content="<%=SystemEnv.getHtmlLabelName(16333,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("$GetEle('message_table_Div').style.display='none';$GetEle('HelpFrame').style.display='none'", 2000);
<%
	} else if( message.equals("3") ) {//子流程创建人无值，请检查子流程创建人设置。
%>

		  var content="<%=SystemEnv.getHtmlLabelName(19455,user.getLanguage())%>";
		  showPrompt(content);
          //window.setTimeout("$GetEle('message_table_Div').style.display='none';$GetEle('HelpFrame').style.display='none'", 2000);
          window.setTimeout("$GetEle('message_table_Div').style.display='none';$GetEle('HelpFrame').style.display='none'", 2000);

<%
	} else if( message.equals("4") ) {//已经流转到下一节点，不可以再提交。
%>

		  var content="<%=SystemEnv.getHtmlLabelName(21266,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("$GetEle('message_table_Div').style.display='none';$GetEle('HelpFrame').style.display='none'", 2000);

<%
	} else if( message.equals("5") ) {//流程流转超时，请重试。
%>

		  var content="<%=SystemEnv.getHtmlLabelName(21270,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("$GetEle('message_table_Div').style.display='none';$GetEle('HelpFrame').style.display='none'", 2000);

<%
	} else if( message.equals("6") ) {//转发失败，请重试！
%>

		  var content="<%=SystemEnv.getHtmlLabelName(21766,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("$GetEle('message_table_Div').style.display='none';$GetEle('HelpFrame').style.display='none'", 2000);

<%
	} else if( message.equals("7") ) {//已经处理，不可重复处理！
%>

		  var content="<%=SystemEnv.getHtmlLabelName(22751,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("$GetEle('message_table_Div').style.display='none';$GetEle('HelpFrame').style.display='none'", 2000);

<%
	} else if( message.equals("8") ) {//流程数据已更改，请核对后再处理！
%>

		  var content="<%=SystemEnv.getHtmlLabelName(24676,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("$GetEle('message_table_Div').style.display='none';$GetEle('HelpFrame').style.display='none'", 2000);

<%
	}
%>
window.setTimeout(function(){displayAllmenu();},3000);
}
//TD4262 增加提示信息  结束

<%--added by xwj for td3247 20051201--%>
window.onbeforeunload = function protectManageBillFlow(event){
	var opt = true;
	try {
		var __aeleclicktime = window.__aeleclicktime;
		var __currenttime = new Date().getTime();
		if (isIE()) {
			if (__currenttime <= __aeleclicktime + 500) {
				opt = false;
			}
		}
	} catch (e) {}
	
  	if(opt && !checkDataChange())//added by cyril on 2008-06-10 for TD:8828
        return "<%=SystemEnv.getHtmlLabelName(18877,user.getLanguage())%>";
   }

     function doBack(){
        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
        parent.document.location.href="/workflow/request/RequestView.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>"; //xwj for td3425 20051201
   }

		function downloads(files)
		{ jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		$GetEle("fileDownload").src="/weaver/weaver.file.FileDownload?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&fileid="+files+"&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&fromrequest=1";
		}
    function downloadsBatch(fieldvalue,requestid)
    { 
       jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
       $GetEle("fileDownload").src="/weaver/weaver.file.FileDownload?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&fieldvalue="+fieldvalue+"&download=1&downloadBatch=1&desrequestid=<%=desrequestid%>&fromrequest=1&requestid="+requestid;
    }
		function opendoc(showid,versionid,docImagefileid)
		{jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>");
		}
		function opendoc1(showid)
		{
		jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		openFullWindowHaveBar("/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&id="+showid+"&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>");
		}
function replaceAll(strOrg,strFind,strReplace){ 
var index = 0; 
while(strOrg.indexOf(strFind,index) != -1){ 
strOrg = strOrg.replace(strFind,strReplace); 
index = strOrg.indexOf(strFind,index); 
} 
return strOrg 
} 

/**
  解决表单序列化中文编码
  (jquery默认序列化采用的是encodeuricompent方法,转码成utf8,所以我们先反转,然后escape编码)
**/
function serialize(objs)

{

    var parmString = jQuery(objs).serialize();

    var parmArray = parmString.split("&");

    var parmStringNew="";

    jQuery.each(parmArray,function(index,data){

        var li_pos = data.indexOf("=");

        if(li_pos >0){

            var name = data.substring(0,li_pos);

            var value = escape(decodeURIComponent(data.substr(li_pos+1)));

            var parm = name+"="+value;

            parmStringNew = parmStringNew=="" ? parm : parmStringNew + '&' + parm;

        }

    });

    return parmStringNew;

}


//打开转发对话框
function openDialog(title, url) {
	url = url.replace(/&{2,5}/g,"&");　
	var dlg = new window.top.Dialog(); //定义Dialog对象
	dlg.currentWindow = window;
	dlg.Model = false;　　　
	dlg.Width = 1060; //定义长度
	dlg.Height = 500;　　　
	dlg.URL = url;　　　
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(24964,user.getLanguage())%>";
	dlg.maxiumnable = true;　　　
	dlg.show();
	//保留对话框对象
	window.dialog = dlg;
}

//打开转发对话框
function openDialog2(title, url) {
	url = url.replace(/&{2,5}/g,"&");　
	var dlg = new window.top.Dialog(); //定义Dialog对象
	dlg.currentWindow = window;
	dlg.Model = false;　　　
	dlg.Width = 1060; //定义长度
	dlg.Height = 500;　　　
	dlg.URL = url;　　　
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(82578,user.getLanguage())%>";
	dlg.maxiumnable = true;　　　
	dlg.show();
	//保留对话框对象
	window.dialog = dlg;
}

//打开转发对话框
function openDialog3(title, url) {
	url = url.replace(/&{2,5}/g,"&");　
	var dlg = new window.top.Dialog(); //定义Dialog对象
	dlg.currentWindow = window;
	dlg.Model = false;　　　
	dlg.Width = 1060; //定义长度
	dlg.Height = 500;　　　
	dlg.URL = url;　　　
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(23746,user.getLanguage())%>";
	dlg.maxiumnable = true;　　　
	dlg.show();
	//保留对话框对象
	window.dialog = dlg;
}

function doLocationHref(resourceid){
	var workflowRequestLogId=0;
	if($GetEle("workflowRequestLogId")!=null){
		workflowRequestLogId=$GetEle("workflowRequestLogId").value;
	}

	var id = <%=requestid%>;
	var remark = "";
	var signdocids="";
    var signworkflowids="";
    //附件上传参数
    var param ="";
	try{
		FCKEditorExt.updateContent();
		
		var params=serialize("#formitem");
		
		var remark="";
		try{
			remark = CkeditorExt.getHtml("remark");
		}catch(e){}
		//附件上传
		StartUploadAll();
		checkfileuploadcompletforremark();
		if(resourceid)
		openDialog("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid + "&requestname=<%=requestname %>"+"&remark="+escape(remark));
		else
        openDialog("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&requestname=<%=requestname %>"+"&remark="+escape(remark));

	}catch(e){
		//alert(12563);
	}
}

function doLocationHref(resourceid,forwardflag){
    //获取相关文档-相关流程-相关附件参数
    //var signdocids=$G("signdocids").value;
    //var signworkflowids=$G("signworkflowids").value;
    //附件上传参数
    //var param = "&annexmainId=" + signannexParam.annexmainId + "&annexsubId=" + signannexParam.annexsubId + "&annexsecId=" + signannexParam.annexsecId + "&userid=" + signannexParam.userid + "&logintype=" + signannexParam.logintype + "&annexmaxUploadImageSize=" + signannexParam.annexmaxUploadImageSize + "&userlanguage=" + signannexParam.userlanguage + "&field_annexupload=" + $G("field-annexupload").value + "&field_annexupload_del_id=" + $G("field_annexupload_del_id").value;
    //获取参数end
	var id = <%=requestid%>;
	var workflowRequestLogId=0;
	var signdocids="";
    var signworkflowids="";
    //附件上传参数
    var param ="";
	//var remarklag = flag;

   // var oEditor = CKEDITOR.instances['remark'];

	//alert(oEditor.getData());

	if($G("workflowRequestLogId")!=null){
		workflowRequestLogId=$G("workflowRequestLogId").value;
	}
	try{
		CkeditorExt.updateContent('remark');

		var params=serialize("#formitem");


		//附件上传
                        StartUploadAll();
                        checkfileuploadcomplet();
		var remark="";
		try{
			remark = CkeditorExt.getHtml("remark");
		}catch(e){}
		 //frmmain.target = "_blank";
		 //frmmain.action = "/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId;
         //document.frmmain.submit();

		if(forwardflag==2){
		if(resourceid)
		openDialog2("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid +"&forwardflag="+forwardflag + "&requestname=<%=requestname %>");
		else
        openDialog2("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&forwardflag=" + forwardflag + "&requestname=<%=requestname %>");
		}else if (forwardflag==3)
		{
			if(resourceid)
		openDialog3("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid +"&forwardflag="+forwardflag + "&requestname=<%=requestname %>");
		else
        openDialog3("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&forwardflag=" + forwardflag + "&requestname=<%=requestname %>");
		}else{
		if(resourceid)
		openDialog("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid +"&forwardflag="+forwardflag + "&requestname=<%=requestname %>");
		else
        openDialog("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&forwardflag=" + forwardflag + "&requestname=<%=requestname %>");
		}
	}catch(e){
		var remark="";
		try{
			remark = CkeditorExt.getHtml("remark");
		}catch(e){}
		var forwardurl = "/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&signdocids="+signdocids + "&forwardflag="+ forwardflag +"&signworkflowids="+signworkflowids+param+"&workflowRequestLogId="+workflowRequestLogId;
		openFullWindowHaveBar(forwardurl);
	}
}

function doLocationHrefnoback(resourceid,forwardflag){
    //获取相关文档-相关流程-相关附件参数
    //var signdocids=$G("signdocids").value;
    //var signworkflowids=$G("signworkflowids").value;
    //附件上传参数
    //var param = "&annexmainId=" + signannexParam.annexmainId + "&annexsubId=" + signannexParam.annexsubId + "&annexsecId=" + signannexParam.annexsecId + "&userid=" + signannexParam.userid + "&logintype=" + signannexParam.logintype + "&annexmaxUploadImageSize=" + signannexParam.annexmaxUploadImageSize + "&userlanguage=" + signannexParam.userlanguage + "&field_annexupload=" + $G("field-annexupload").value + "&field_annexupload_del_id=" + $G("field_annexupload_del_id").value;
    //获取参数end
	var id = <%=requestid%>;
	var workflowRequestLogId=0;
	//var remarklag = flag;

   // var oEditor = CKEDITOR.instances['remark'];

	//alert(oEditor.getData());

	if($G("workflowRequestLogId")!=null){
		workflowRequestLogId=$G("workflowRequestLogId").value;
	}
	try{
		CkeditorExt.updateContent('remark');

		var params=serialize("#formitem");


		//附件上传
                        StartUploadAll();
                        checkfileuploadcomplet();
		var remark="";
		try{
			remark = CkeditorExt.getHtml("remark");
		}catch(e){}
		 //frmmain.target = "_blank";
		 //frmmain.action = "/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId;
         //document.frmmain.submit();
		if(forwardflag==2){
		if(resourceid)
		openDialog2("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid +"&forwardflag="+forwardflag+"&needwfback=0&requestname=<%=requestname %>");
		else
        openDialog2("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&forwardflag=" + forwardflag + "&needwfback=0&requestname=<%=requestname %>");
		}else if (forwardflag==3)
		{
			if(resourceid)
		openDialog3("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid +"&forwardflag="+forwardflag + "&needwfback=0&requestname=<%=requestname %>");
		else
        openDialog3("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&forwardflag=" + forwardflag + "&needwfback=0&requestname=<%=requestname %>");
		}else{
		if(resourceid)
		openDialog("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid +"&forwardflag="+forwardflag + "&needwfback=0&requestname=<%=requestname %>");
		else
        openDialog("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&forwardflag=" + forwardflag + "&needwfback=0&requestname=<%=requestname %>");
		}
	}catch(e){
		var remark="";
		try{
			remark = CkeditorExt.getHtml("remark");
		}catch(e){}
		var forwardurl = "/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+ "&forwardflag="+ forwardflag +"&needwfback=0&signworkflowids="+signworkflowids+param+"&workflowRequestLogId="+workflowRequestLogId;
		openFullWindowHaveBar(forwardurl);
	}
}


<%
String isFormSignatureOfThisJsp=null;
RecordSet.executeSql("select ismode,showdes,isFormSignature from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isFormSignatureOfThisJsp = Util.null2String(RecordSet.getString("isFormSignature"));
}
%>

   function doReview(resourceid){


         jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

//保存签章数据
<%if("1".equals(isFormSignatureOfThisJsp)){%>
	                    //转发时不验证签字意见必填
	            try{  
					if(typeof(eval("SaveSignature"))=="function"){
	                    if(SaveSignature()||!SaveSignature()){
                            doLocationHref(resourceid);
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							return ;
						}
					}
			   }catch(e){
			        doLocationHref(resourceid);
			   }
<%}else{%>
                        doLocationHref(resourceid);
<%}%>

   }
   /**
征求意见
resourceid（转发人id）
**/
function doReview2(resourceid){
         jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
//保存签章数据
<%if("1".equals(isFormSignatureOfThisJsp)){%>
				try{  
					if(typeof(eval("SaveSignature"))=="function"){
	                    //转发时不验证签字意见必填
	                    if(SaveSignature()||!SaveSignature()){
                            doLocationHref(resourceid,2);
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							return ;
						}
					   }
				    }catch(e){
				    	doLocationHref(resourceid,2);
				    }
<%}else{%>
                        doLocationHref(resourceid,2);
<%}%>

   }
   
   
   /**
转办
resourceid（转发人id）
**/
function doReview3(resourceid){
         jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
//保存签章数据
<%if("1".equals(isFormSignatureOfThisJsp)){%>
				try{  
					if(typeof(eval("SaveSignature"))=="function"){
	                    //转发时不验证签字意见必填
	                    if(SaveSignature()||!SaveSignature()){
                            doLocationHref(resourceid,3);
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							return ;
						}
					   }
				    }catch(e){
				    	doLocationHref(resourceid,3);
				    }
<%}else{%>
                        doLocationHref(resourceid,3);
<%}%>

   }
      /**
转办
resourceid（转发人id）
**/
function doReviewback3(resourceid){
			$G("needwfback").value = "1";
         jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
//保存签章数据
<%if("1".equals(isFormSignatureOfThisJsp)){%>
				try{  
					if(typeof(eval("SaveSignature"))=="function"){
	                    //转发时不验证签字意见必填
	                    if(SaveSignature()||!SaveSignature()){
                            doLocationHref(resourceid,3);
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							return ;
						}
					   }
				    }catch(e){
				    	doLocationHref(resourceid,3);
				    }
<%}else{%>
                        doLocationHref(resourceid,3);
<%}%>

   }

   
      /**
转办
resourceid（转发人id）
**/
function doReviewnoback3(resourceid){
	$G("needwfback").value = "0";
         jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
//保存签章数据
<%if("1".equals(isFormSignatureOfThisJsp)){%>
				try{  
					if(typeof(eval("SaveSignature"))=="function"){
	                    //转发时不验证签字意见必填
	                    if(SaveSignature()||!SaveSignature()){
                            doLocationHrefnoback(resourceid,3);
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							return ;
						}
					   }
				    }catch(e){
				    	doLocationHrefnoback(resourceid,3);
				    }
<%}else{%>
                        doLocationHrefnoback(resourceid,3);
<%}%>

   }

var isfirst = 0 ;

function displaydiv()
{
    if(oDivAll.style.display == ""){
		oDivAll.style.display = "none";
		oDivInner.style.display = "none";
        oDiv.style.display = "none";

        spanimage.innerHTML = "<img src='/images/ArrowDownRed_wev8.gif' border=0>" ;
    }
    else{
        if(isfirst == 0) {
			$GetEle("picInnerFrame").src="/workflow/request/WorkflowRequestPictureInner.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>";				
			$GetEle("picframe").src="/workflow/request/WorkflowRequestPicture.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>";

            isfirst ++ ;
        }

        spanimage.innerHTML = "<img src='/images/ArrowUpGreen_wev8.gif' border=0>" ;
		oDivAll.style.display = "";
		oDivInner.style.display = "";
        oDiv.style.display = "";
        workflowStatusLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19678,user.getLanguage())%></font>";
        workflowChartLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font>";
    }
}


function displaydivOuter()
{
    if(oDiv.style.display == ""){
        oDiv.style.display = "none";
        workflowStatusLabelSpan.innerHTML="<font color=red><%=SystemEnv.getHtmlLabelName(19677,user.getLanguage())%></font>";
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none"){
		    oDivAll.style.display = "none";
            spanimage.innerHTML = "<img src='/images/ArrowDownRed_wev8.gif' border=0>" ;
		}
    }
    else{
        oDiv.style.display = "";
        workflowStatusLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19678,user.getLanguage())%></font>";
    }
}

function displaydivInner()
{
    if(oDivInner.style.display == ""){
        oDivInner.style.display = "none";
        workflowChartLabelSpan.innerHTML="<font color=red><%=SystemEnv.getHtmlLabelName(19675,user.getLanguage())%></font>";
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none"){
		    oDivAll.style.display = "none";
            spanimage.innerHTML = "<img src='/images/ArrowDownRed_wev8.gif' border=0>" ;
		}
    }
    else{
        oDivInner.style.display = "";
        workflowChartLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font>";
    }
}

<%-----------xwj for td3131 20051115 begin -----%>
function numberToFormat(index){
    if($GetEle("field_lable"+index).value != ""){
		var floatNum = floatFormat($GetEle("field_lable"+index).value);
       	var val = numberChangeToChinese(floatNum)
       	if(val == ""){
       		alert("<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage())%>");
            $GetEle("field"+index).value = "";
            $GetEle("field_lable"+index).value = "";
            $GetEle("field_chinglish"+index).value = "";
       	} else {
	        $GetEle("field"+index).value = floatNum;
	        $GetEle("field_lable"+index).value = milfloatFormat(floatNum);
       		$GetEle("field_chinglish"+index).value = val;
       	}
    }else{
        $GetEle("field"+index).value = "";
        $GetEle("field_chinglish"+index).value = "";
    }
}
function FormatToNumber(index){
	var elm = $GetEle("field_lable"+index);
	var n = getLocation(elm);
    if($GetEle("field_lable"+index).value != ""){
        $GetEle("field_lable"+index).value = $GetEle("field"+index).value;
    }else{
        $GetEle("field"+index).value = "";
        $GetEle("field_chinglish"+index).value = "";
    }
	setLocation(elm,n);
}
<%-----------xwj for td3131 20051115 end -----%>

</SCRIPT>

<BODY id="flowbody" <%if (docFlag) {%> onload="changeTab()"<%}%>  <%if (!docFlag&&!fromPDA.equals("1")) {%>  <%}%>><%--Modified by xwj for td3247 20051201--%>
<%if (!docFlag) {%>
<%@ include file="RequestTopTitle.jsp" %>
<%}%>
<iframe id="fileDownload" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
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

//---------------------------------------------------------------------------------
// 跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 START
//---------------------------------------------------------------------------------
if (!isIE.equalsIgnoreCase("true") && false) {
	if (isbill.equals("1") && formid > 0 && !managepage.equals("")) {
		if (!"159".equals(formid + "") && !"180".equals(formid + "") && !"85".equals(formid + "") &&!"7".equals(formid + "") && !"79".equals(formid + "") && !"158".equals(formid + "") && !"157".equals(formid + "") && !"156".equals(formid + "") ) {
			//response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=15590");
%>

<script type="text/javascript">

window.parent.location.href = "/wui/common/page/sysRemind.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&labelid=27826";

</script>

<%
			return;
		}
	}
}
//---------------------------------------------------------------------------------
//跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 END
//---------------------------------------------------------------------------------

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

//微信提醒(QC:98106)
String newCHATSName = "";//新建微信按钮
String haschats = "";//是否使用新建微信按钮
//微信提醒(QC:98106)
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
	}else if(nodetype.equals("0") ){
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(16634,user.getLanguage())+",javascript:doSubmit_Pre(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(16634,user.getLanguage())+"',iconCls:'btn_submit',handler: function(){doSubmit_Pre(this);}},";
	if(!"1".equals(isSubmitDirectNode)) {
		isSubmitDirect = Util.null2String(request.getParameter("isSubmitDirect"));
	}
}    
topage = URLEncoder.encode(topage);
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"',iconCls:'btn_edit',handler: function(){parent.location.href='ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&reEdit=1&fromFlowDoc="+fromFlowDoc+"&requestid="+requestid+"&isovertime="+isovertime+"&topage="+topage+"';}},";
}else{
if(isremark == 1||isremark == 9||isremark == 7){

 if("".equals(ifchangstatus)){
		RCMenu += "{"+submitname+",javascript:doRemark_nNoBack(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+submitname+"',iconCls:'btn_submit',handler: function(){doRemark_nNoBack();}},";
	}else{
	if(takisremark == 2){
		if(!"1".equals(hastakingOpinionsback)&&!"1".equals(hastakingOpinionsnoback)&&isremark==1 && takisremark ==2){
			RCMenu += "{"+submitname+",javascript:doRemark_nBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+submitname+"',iconCls:'btn_subbackName',handler: function(){doRemark_nBack(this);}},";
		}
		}else if((!"1".equals(hasforback)&&!"1".equals(hasfornoback)&&isremark==1) || (!"1".equals(hasccback)&&!"1".equals(hasccnoback)&&isremark==9)){
			RCMenu += "{"+submitname+",javascript:doRemark_nBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+submitname+"',iconCls:'btn_subbackName',handler: function(){doRemark_nBack(this);}},";
		}
		if(takisremark == 2){
		if( ("1".equals(hastakingOpinionsback)&&isremark==1 && takisremark ==2)){
				RCMenu += "{"+subbackName+",javascript:doRemark_nBack(this),_self}";
				RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doRemark_nBack(this);}},";
			}
		if(("1".equals(hastakingOpinionsnoback)&&isremark==1 && takisremark ==2)){
			RCMenu += "{"+subnobackName+",javascript:doRemark_nNoBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName ',handler: function(){doRemark_nNoBack(this);}},";
			}
		}else{
		  	if(("1".equals(hasforback)&&isremark==1) || ("1".equals(hasccback)&&isremark==9)){
				RCMenu += "{"+subbackName+",javascript:doRemark_nBack(this),_self}";
				RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doRemark_nBack(this);}},";
			}
		if(("1".equals(hasfornoback)&&isremark==1) || ("1".equals(hasccnoback)&&isremark==9)){
			RCMenu += "{"+subnobackName+",javascript:doRemark_nNoBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName ',handler: function(){doRemark_nNoBack(this);}},";
			}
		}
		}
	
	  if(isremark==1&&IsCanModify){
        RCMenu += "{"+saveName+",javascript:doSave_nNew(this),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
        strBar += "{text: '"+saveName+"',iconCls:'btn_wfSave',handler: function(){doSave_nNew(this);}},";
    }
    if((isremark==1&&canForwd)||(isremark==9&&IsPendingForward.equals("1"))){
        RCMenu += "{"+forwardName+",javascript:doReview(),_self}" ;//add by mackjoe
        RCMenuHeight += RCMenuHeightStep ;
        strBar += "{text: '"+forwardName+"',iconCls:'btn_forward',handler: function(){doReview();}},";
    }
}else if(isremark == 5){		//超时
    if("".equals(ifchangstatus)){
		RCMenu += "{"+submitname+",javascript:doSubmitNoBack(this),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+submitname+"',iconCls:'btn_submit',handler: function(){doSubmitNoBack(this);}},";
	}else{
		if(!"1".equals(hasnoback)){
			RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doSubmitBack(this);}},";
		}else{
			if("1".equals(hasback)){
				RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
				RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doSubmitBack(this);}},";
			}
			RCMenu += "{"+subnobackName+",javascript:doSubmitNoBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){doSubmitNoBack(this);}},";
		}
	}
    if("1".equals(isSubmitDirect)) {
		RCMenu += "{" + submitDirectName + ", javascript:doSubmitDirect(this, \\\"Submit\\\"), _self}";
		RCMenuHeight += RCMenuHeightStep;
		strBar += "{text: '" + submitDirectName + "', iconCls: 'btn_submit', handler: function(){doSubmitDirect(this, \\\"Submit\\\");}},";
	}
}else {

if(IsCanSubmit||coadCanSubmit){
if (isaffirmance.equals("1") && nodetype.equals("0") && reEdit.equals("1")){
    if("".equals(ifchangstatus)){
		RCMenu += "{"+submitname+",javascript:doAffirmanceNoBack(this),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+submitname+"',iconCls:'btn_submit',handler: function(){doAffirmanceNoBack(this);}},";
	}else{
		if((!"1".equals(hasnoback)&&!"1".equals(hasback))){
			RCMenu += "{"+submitname+",javascript:doAffirmanceBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+submitname+"',iconCls:'btn_subbackName',handler: function(){doAffirmanceBack(this);}},";
		}else{
				if("1".equals(hasback)){
				RCMenu += "{"+subbackName+",javascript:doAffirmanceBack(this),_self}";
				RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doAffirmanceBack(this);}},";
			}
			if("1".equals(hasnoback) ){
			RCMenu += "{"+subnobackName+",javascript:doAffirmanceNoBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){doAffirmanceNoBack(this);}},";
			}
		}
	}
    if("1".equals(isSubmitDirect)) {
		RCMenu += "{" + submitDirectName + ", javascript:doSubmitDirect(this, \\\"Affirmance\\\"), _self}";
		RCMenuHeight += RCMenuHeightStep;
		strBar += "{text: '" + submitDirectName + "', iconCls: 'btn_submit', handler: function(){doSubmitDirect(this, \\\"Submit\\\");}},";
	}
}else{
    if("".equals(ifchangstatus)){
		RCMenu += "{"+submitname+",javascript:doSubmitNoBack(this),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+submitname+"',iconCls:'btn_submit',handler: function(){doSubmitNoBack(this);}},";
	}else{
		if((!"1".equals(hasnoback)&&!"1".equals(hasback))){
			RCMenu += "{"+submitname+",javascript:doSubmitBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+submitname+"',iconCls:'btn_subbackName',handler: function(){doSubmitBack(this);}},";
		}else{
			if("1".equals(hasback)){
				RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
				RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doSubmitBack(this);}},";
			}
			if("1".equals(hasnoback)){
			RCMenu += "{"+subnobackName+",javascript:doSubmitNoBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){doSubmitNoBack(this);}},";
			}
		}
	}
    if("1".equals(isSubmitDirect)) {
		RCMenu += "{" + submitDirectName + ", javascript:doSubmitDirect(this, \\\"Submit\\\"), _self}";
		RCMenuHeight += RCMenuHeightStep;
		strBar += "{text: '" + submitDirectName + "', iconCls: 'btn_submit', handler: function(){doSubmitDirect(this, \\\"Submit\\\");}},";
	}
}
if(IsFreeWorkflow){
    RCMenu += "{"+FreeWorkflowname+",javascript:doFreeWorkflow(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+FreeWorkflowname+"',iconCls:'btn_edit',handler: function(){doFreeWorkflow(this);}},";
}
if(isImportDetail){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(26255,user.getLanguage())+",javascript:doImportDetail(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+saveName+",javascript:doSave_nNew(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+saveName+"',iconCls:'btn_wfSave',handler: function(){doSave_nNew(this);}},";
if( isreject.equals("1")&&isremark==0 ){
    RCMenu += "{"+rejectName+",javascript:doReject_New(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+rejectName+"',iconCls:'btn_rejectName',handler: function(){doReject_New();}},";
}
}
if(IsPendingForward.equals("1")){
RCMenu += "{"+forwardName+",javascript:doReview(),_self}" ;//Modified by xwj for td3247 20051201
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+forwardName+"',iconCls:'btn_forward',handler: function(){doReview();}},";
}

//System.out.println("-I-1188----IsTakingOpinions-----"+IsTakingOpinions);
if(IsTakingOpinions.equals("1")){  //征求意见
RCMenu += "{"+takingopinionsName+",javascript:doReview2(),_self}" ;//Modified by xwj for td3247 20051201
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+takingopinionsName+"',iconCls:'btn_forward',handler: function(){doReview2();}},";
//rmklag = 2;
}
//System.out.println("-I-1194----IsHandleForward-----"+IsHandleForward);
if(IsHandleForward.equals("1")){   //转办
	if("".equals(ifchangstatus)){
		RCMenu += "{"+HandleForwardName+",javascript:doReview3(),_self}" ;//Modified by xwj for td3247 20051201
		RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+HandleForwardName+"',iconCls:'btn_forward',handler: function(){doReview3();}},";
	}else{
		if((!"1".equals(hasforhandnoback)&&!"1".equals(hasforhandback))){
			RCMenu += "{"+HandleForwardName+",javascript:doReview3(),_self}" ;//Modified by xwj for td3247 20051201
			RCMenuHeight += RCMenuHeightStep ;
			strBar += "{text: '"+HandleForwardName+"',iconCls:'btn_forward',handler: function(){doReview3();}},";
		}else{
			if( "1".equals(hasforhandback)){
				RCMenu += "{"+forhandbackName+",javascript:doReview3(),_self}" ;//Modified by xwj for td3247 20051201
			RCMenuHeight += RCMenuHeightStep ;
			strBar += "{text: '"+forhandbackName+"',iconCls:'btn_forwardback3',handler: function(){doReviewback3();}},";
				//strBar += "{text: '"+forhandbackName+"',iconCls:'btn_forward',handler: function(){bodyiframe.doReview3();}},";  //转发
			}
			if( "1".equals(hasforhandnoback)){
				RCMenu += "{"+forhandnobackName+",javascript:doReview3(),_self}" ;//Modified by xwj for td3247 20051201
			RCMenuHeight += RCMenuHeightStep ;
			strBar += "{text: '"+forhandnobackName+"',iconCls:'btn_forwardnobacke3',handler: function(){doReviewnoback3();}},";
		//strBar += "{text: '"+forhandnobackName+"',iconCls:'btn_forward',handler: function(){bodyiframe.doReview3();}},";  //转发
			}
		}
	}


//rmklag = 3;
}

%>

<%  if(isreopen.equals("1") && false ){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:doReopen(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+"',iconCls:'btn_doReopen',handler: function(){doReopen();}},";
%>
<%  }
}
%>
<%
/*added by cyril on 2008-07-10 for TD:8835*/
if(isModifyLog.equals("1")) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(21625,user.getLanguage())+",javascript:doViewModifyLog(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(21625,user.getLanguage())+"',iconCls:'btn_doViewModifyLog',handler: function(){doViewModifyLog();}},";
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
		RCMenu += "{"+newWFName+",javascript:onNewRequest("+t_workflowid+", "+requestid+",0),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+newWFName+"',iconCls:'btn_newWFName',handler: function(){onNewRequest("+t_workflowid+", "+requestid+",0);}},";
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
	RCMenu += "{"+newSMSName+",javascript:onNewSms("+workflowid+", "+nodeid+", "+requestid+", " + menuid + "),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+newSMSName+"',iconCls:'btn_newSMSName',handler: function(){onNewSms("+workflowid+", "+nodeid+", "+requestid+", " + menuid + ");}},";
		}
	}
}
//微信提醒(QC:98106)
if("1".equals(haschats) && WechatPropConfig.isUseWechat()){
	for(int i = 0; i < newMenuList2.size(); i++) {
		HashMap newMenuMap = (HashMap) newMenuList2.get(i);
		int menuid = (Integer) newMenuMap.get("id");
		if(menuid > 0) {
			newCHATSName = (String) newMenuMap.get("newName");
	if("".equals(newCHATSName)){
		newCHATSName = SystemEnv.getHtmlLabelName(32818,user.getLanguage()) + (i + 1);
	}
	RCMenu += "{"+newCHATSName+",javascript:onNewChats("+workflowid+", "+nodeid+", "+requestid+", " + menuid + "),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+newCHATSName+"',iconCls:'btn_newChatsName',handler: function(){onNewChats("+workflowid+", "+nodeid+", "+requestid+", " + menuid + ");}},";
		}
	}
}
//微信提醒(QC:98106)
/*TD9145 END*/
if("1".equals(hasovertime)&&isremark==0){
	if("".equals(newOverTimeName)){
		newOverTimeName = SystemEnv.getHtmlLabelName(18818,user.getLanguage());
	}
	RCMenu += "{"+newOverTimeName+",javascript:onNewOverTime(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+newOverTimeName+"',iconCls:'btn_newSMSName',handler: function(){onNewOverTime();}},";
}
String isTriDiffWorkflow=null; 
RecordSet.executeSql("select a.isTriDiffWorkflow, b.* from workflow_base a, workflow_flownode b where a.id = b.workflowid and a.id="+workflowid + " and b.nodeid=" + nodeid);

if(RecordSet.next()){
	isTriDiffWorkflow=Util.null2String(RecordSet.getString("isTriDiffWorkflow"));
    isrejectremind=Util.null2String(RecordSet.getString("isrejectremind"));
    ischangrejectnode=Util.null2String(RecordSet.getString("ischangrejectnode"));
	  isselectrejectnode=Util.null2String(RecordSet.getString("isselectrejectnode"));
}

if (isremark != 1 && isremark != 8 && isremark != 9) {
	List<Map<String, String>> buttons = SubWorkflowTriggerService.getManualTriggerButtons(workflowid, nodeid);
	for(int indexId = 0; indexId < buttons.size() ; indexId++){
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
		RCMenu += "{"+triSubwfName+",javascript:triSubwf2("+subwfSetId+",\\\""+workflowNames+"\\\"),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+triSubwfName+"',iconCls:'btn_relateCwork',handler: function(){triSubwf2("+subwfSetId+",\\\""+workflowNames+"\\\");}},";
	}
}

if(!isfromtab&&!"1".equals(session.getAttribute("istest"))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self}" ;//td3425 xwj 2005-12-31
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+"',iconCls:'btn_back',handler: function(){doBack();}},";
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+",javascript:doDrawBack(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+"',iconCls:'btn_doDrawBack',handler: function(){doDrawBack(this);}},";
}
if(haveBackright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(18359,user.getLanguage())+",javascript:doRetract(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(18359,user.getLanguage())+"',iconCls:'btn_doRetract',handler: function(){doRetract(this);}},";
}
if(haveStopright)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20387,user.getLanguage())+",javascript:doStop(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(20387,user.getLanguage())+"',iconCls:'btn_end',handler: function(){bodyiframe.doStop(this);}},";
}
if(haveCancelright)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16210,user.getLanguage())+",javascript:doCancel(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(16210,user.getLanguage())+"',iconCls:'btn_backSubscrible',handler: function(){bodyiframe.doCancel(this);}},";
}
if(haveRestartright)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+",javascript:doRestart(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"',iconCls:'btn_next',handler: function(){bodyiframe.doRestart(this);}},";
}
if(nodetype.equals("0")&&isremark != 1&&isremark != 9&&isremark != 7&&isremark != 5&&WfFunctionManageUtil.IsShowDelButtonByReject(requestid,workflowid)){    // 创建节点(退回创建节点也是)
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"',iconCls:'btn_doDelete',handler: function(){doDelete();}},";
}
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:openSignPrint(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;        
strBar += "{text: '"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+"',iconCls:'btn_print',handler: function(){openSignPrint();}},";        
}


RCMenu += "{"+SystemEnv.getHtmlLabelName(21533,user.getLanguage())+",javascript:doPrintViewLog(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(21533,user.getLanguage())+"',iconCls:'btn_collect',handler: function(){doPrintViewLog();}},";


if(strBar.lastIndexOf(",")>-1) strBar = strBar.substring(0,strBar.lastIndexOf(","));
strBar+="]";

String needconfirm="";
RecordSet.executeSql("select t1.ismodifylog,t1.needAffirmance from workflow_base t1, workflow_requestbase t2 where t1.id=t2.workflowid and t2.requestid="+requestid);
if(RecordSet.next()) {
	needconfirm = RecordSet.getString("needAffirmance");
}

%>
<%-- end--%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="javascript">
enableAllmenu();
</script>
        <input type=hidden name=seeflowdoc value="<%=seeflowdoc%>">
		<input type=hidden name=isworkflowdoc value="<%=isworkflowdoc%>">
        <input type=hidden name=wfdoc value="<%=wfdoc%>">
        <input type="hidden" name="isovertime" value="<%=isovertime%>">
        <input type=hidden name=picInnerFrameurl value="/workflow/request/WorkflowRequestPictureInner.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>">

		<TABLE width="100%">
		<tr>
		<td valign="top">

    <table width="100%">
        <tr>
        <td width="80%" align=left>
			<jsp:include page="/workflow/request/wfSubmitErrorMsg.jsp">
       			<jsp:param name="message" value="<%=message %>" />
       			<jsp:param name="requestid" value="<%=requestid %>" />
       		</jsp:include>
        </td>
        <td width="20%" align=right>
        </td></tr>
    </table>


<%
if( !managepage.equals("")) {
%>
  <%if (fromPDA.equals("1")) {%>
		<% if(isremark == 1){ %>
		<a href="javascript:$GetEle('isremark').value='1';$GetEle('src').value='save';$GetEle('frmmain').submit();"><%=submitname%></a>
		<%} if(isremark == 5) {%>
        <a href="javascript:$GetEle('src').value='submit';$GetEle('frmmain').submit();"><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></a>
		<%} else {%>
		<a href="javascript:$GetEle('src').value='submit';$GetEle('frmmain').submit();"><%=submitname%></a>
		<%} 
		 if (isreject.equals("1")) {%>
	   <a href="javascript:$GetEle('src').value='reject';$GetEle('frmmain').submit();" ><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></a>
		<%}%>
		<a href="javascript:$GetEle('src').value='save';$GetEle('frmmain').submit();"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a> 
		<a href="javascript:location.href='/workflow/search/WFSearchResultPDA.jsp'"><%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></a>
	    <%}%>
		<%
			int submit=Util.getIntValue(Util.null2String(request.getParameter("submit")), 0);
			int forward=Util.getIntValue(Util.null2String(request.getParameter("forward")), 0);
		 %>
<jsp:include page="<%=managepage%>" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />

    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="nextnodetype" value="<%=nextnodetype%>" />
    <jsp:param name="isreopen" value="<%=isreopen%>" />
    <jsp:param name="isreject" value="<%=isreject%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
	<jsp:param name="docfileid" value="<%=docfileid%>" />
    <jsp:param name="newdocid" value="<%=newdocid%>" />
    <jsp:param name="topage" value="<%=topage%>" />
    <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
	<jsp:param name="submit" value="<%=submit%>" />
	<jsp:param name="forward" value="<%=forward%>" />
    <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />
</jsp:include>
<%}else{
      //modify by xhheng @20050315 for 附件上传
      if( operationpage.equals("") ){ 
        operationpage = "RequestOperation.jsp" ;
        %>
        <form id='formitem' name="frmmain" method="post" action="<%=operationpage%>" >
	 <%if (fromPDA.equals("1")) {%>
		<% if(isremark == 1){ %>
		<a href="javascript:$GetEle('isremark').value='1';$GetEle('src').value='save';$GetEle('frmmain').submit();"><%=submitname%></a>
		<%} else if(isremark == 5) {%>
        <a href="javascript:$GetEle('src').value='submit';$GetEle('frmmain').submit();"><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></a>
		<%} else {%>
		<a href="javascript:$GetEle('src').value='submit';$GetEle('frmmain').submit();"><%=submitname%></a>
		<%} 
		 if (isreject.equals("1")) {%>
	   <a href="javascript:$GetEle('src').value='reject';$GetEle('frmmain').submit();" ><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></a>
		<%}%>
		<a href="javascript:$GetEle('src').value='save';$GetEle('frmmain').submit();"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a> 
		<a href="javascript:location.href='/workflow/search/WFSearchResultPDA.jsp'"><%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></a>
	    <%}%>
        <%
      }else{
        if(hasfileup.equals("1")){
          %>
      <form id='formitem' name="frmmain" method="post"  action="<%=operationpage%>" >
        <%if (fromPDA.equals("1")) {%>
		<% if(isremark == 1){ %>
		<a href="javascript:$GetEle('isremark').value='1';$GetEle('src').value='save';$GetEle('frmmain').submit();"><%=submitname%></a>
		<%} else if(isremark == 5) {%>
        <a href="javascript:$GetEle('src').value='submit';$GetEle('frmmain').submit();"><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></a>
		<%} else {%>
		<a href="javascript:$GetEle('src').value='submit';$GetEle('frmmain').submit();"><%=submitname%></a>
		<%} 
		 if (isreject.equals("1")) {%>
	   <a href="javascript:$GetEle('src').value='reject';$GetEle('frmmain').submit();" ><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></a>
		<%}%>
		<a href="javascript:$GetEle('src').value='save';$GetEle('frmmain').submit();"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a> 
		<a href="javascript:location.href='/workflow/search/WFSearchResultPDA.jsp'"><%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></a>
	    <%}%>
          <%}else{%>
     
          <form name="frmmain" method="post" action="<%=operationpage%>">
          <%
            }%>
		   <%if (fromPDA.equals("1")) {%>
		<% if(isremark == 1){ %>
		<a href="javascript:$GetEle('isremark').value='1';$GetEle('src').value='save';$GetEle('frmmain').submit();"><%=submitname%></a>
		<%} else if(isremark == 5) {%>
        <a href="javascript:$GetEle('src').value='submit';$GetEle('frmmain').submit();"><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></a>
		<%} else {%>
		<a href="javascript:$GetEle('src').value='submit';$GetEle('frmmain').submit();"><%=submitname%></a>
		<%} 
		 if (isreject.equals("1")) {%>
	   <a href="javascript:$GetEle('src').value='reject';$GetEle('frmmain').submit();" ><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></a>
		<%}%>
		<a href="javascript:$GetEle('src').value='save';$GetEle('frmmain').submit();"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a> 
		<a href="javascript:location.href='/workflow/search/WFSearchResultPDA.jsp'"><%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></a>
	    <%}%>	  
		  <%
       }%>
	   <%
			session.setAttribute(userid+"_"+workflowid+"workflowname", workflowname);
	   %>
    <%--@ include file="WorkflowManageRequestBody.jsp" --%>
<jsp:include page="WorkflowManageRequestBodyAction.jsp" flush="true">

	<jsp:param name="userid" value="<%=userid%>" />
    <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />

    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
	<jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isreopen" value="<%=isreopen%>" />
    <jsp:param name="isreject" value="<%=isreject%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
	<jsp:param name="topage" value="<%=topage%>" />
	<jsp:param name="newenddate" value="<%=newenddate%>" />
	<jsp:param name="newfromdate" value="<%=newfromdate%>" />
	<jsp:param name="docfileid" value="<%=docfileid%>" />
	<jsp:param name="newdocid" value="<%=newdocid%>" />
</jsp:include>
<%
//add by mackjoe at 2006-06-07 td4491 有明细时才加载
boolean  hasdetailb=false;
if(isbill.equals("0")) {
    RecordSet.executeSql("select count(*) from workflow_formfield  where isdetail='1' and formid="+formid);
}else{
    RecordSet.executeSql("select count(*) from workflow_billfield  where viewtype=1 and billid="+formid);
}
if(RecordSet.next()){
    if(RecordSet.getInt(1)>0) hasdetailb=true;
}
if(hasdetailb){
%>
    <%--@ include file="WorkflowManageRequestDetailBodyBill.jsp" --%>
    <jsp:include page="WorkflowManageRequestDetailBodyBill.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="newdocid" value="<%=newdocid%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
	<jsp:param name="docfileid" value="<%=docfileid%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
    <jsp:param name="isaffirmance" value="<%=isaffirmance%>" />
    <jsp:param name="reEdit" value="<%=reEdit%>" />
    </jsp:include>
<%
    }
%>
    <%--@ include file="WorkflowManageSign.jsp" --%>
    <jsp:include page="WorkflowManageSign1.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />

    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
	<jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isreopen" value="<%=isreopen%>" />
    <jsp:param name="isreject" value="<%=isreject%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
    <jsp:param name="isworkflowdoc" value="<%=isworkflowdoc%>" />
    </jsp:include>
<input type="hidden" name="needwfback"  id="needwfback" value="1"/>
	<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
	<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
	<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

	<%
    	//当流程为自由流程时，加载自由流程节点的信息，
    	//并在页面上创建div隐藏节点，用于存放自由节点设置信息
    	if( isFree.equals("1") ){
    %>
    	<!-- div freeNode 为自由流程设置信息-->
		<div class="freeNode" style="display:none;">
	        <%
	            RecordSet.executeSql("select * from("+
	                    "select base.id,node.workflowid,base.nodename,node.nodetype,node.isFormSignature,node.IsPendingForward,"+
	                    "base.operators,base.Signtype,base.floworder from workflow_flownode node,workflow_nodebase base where node.nodeid=base.id ) a "+
	                    "left join ("+
	                    "select rights.nodeid,manage.retract,manage.pigeonhole,rights.isroutedit,rights.istableedit from "+
	                    "workflow_function_manage manage full join workflow_freeright rights on manage.operatortype=rights.nodeid"+
	                    ") b on a.id=b.nodeid where a.workflowid="+workflowid+" and a.id="+nodeid);
	
	            
	
	            if(RecordSet.next()){
	                currtype=Util.getIntValue(RecordSet.getString("nodetype"),0);
	                if(currtype==0){//创建节点
	                    init_road=2;
	                    init_frms=1;
	                }else{
	                    init_road=Util.getIntValue(RecordSet.getString("isroutedit"),0);
	                    init_frms=Util.getIntValue(RecordSet.getString("istableedit"),0);
	                }
	            }
	
	            int freeNum=0;
	            String cheStr="";
	            if(init_road==1||currtype==0){
	                //当前节点只有加签权限
	                RecordSet.execute("select * from ("+
	                "select base.id,base.requestid,base.nodename,node.nodetype,node.isFormSignature,node.IsPendingForward,"+
	                "base.operators,base.Signtype,base.floworder from workflow_flownode node,workflow_nodebase base where "+
	                "node.nodeid=base.id and base.startnodeid="+nodeid+" and base.requestid="+requestid+
	                ") a "+
	                "left join ("+
	                "select rights.nodeid,manage.retract,manage.pigeonhole,rights.isroutedit,rights.istableedit from "+
	                "workflow_function_manage manage full join workflow_freeright rights on manage.operatortype=rights.nodeid"+
	                ") b on a.id=b.nodeid ");       
	                
	               
	
	                while (RecordSet.next()) {
	                    
	                        String operids=Util.null2String(RecordSet.getString("operators"));
	                        String opernames="";
	                        ArrayList operatorlist=Util.TokenizerString(operids,",");
	                        for(int j=0;j<operatorlist.size();j++){
	                            if(opernames.equals("")){
	                                opernames=ResourceComInfo.getLastname((String)operatorlist.get(j));
	                            }else{
	                                opernames+=","+ResourceComInfo.getLastname((String)operatorlist.get(j));
	                            }
	                        }
	                        String nodeDo="";
	                        int pforward=Util.getIntValue(RecordSet.getString("IsPendingForward"),0);
	                        if(pforward==1){
	                            nodeDo=nodeDo+"1,";
	                        }                           
	                        int pigeonhole=Util.getIntValue(RecordSet.getString("pigeonhole"),0);
	                        if(pigeonhole==1){
	                            nodeDo=nodeDo+"2,";
	                        }
	                        int retract=Util.getIntValue(RecordSet.getString("retract"),0);
	                        if(retract==1){
	                            nodeDo=nodeDo+"3,";
	                        }
	                        if(nodeDo.lastIndexOf(",")>-1){
	                            nodeDo = nodeDo.substring(0,nodeDo.lastIndexOf(","));
	                        }
	            %>      
	                    <input type='hidden' name='floworder_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("floworder"),0)%>'/>
	                    <input type='hidden' name='nodename_<%=freeNum%>' value='<%=Util.null2String(RecordSet.getString("nodename"))%>'/>
	                    <input type='hidden' name='nodeid_<%=freeNum%>' value='<%=Util.null2String(RecordSet.getString("nodeid"))%>'/>
	                    <input type='hidden' name='nodetype_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("nodetype"),0)%>'/>
	                    <input type='hidden' name='Signtype_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("Signtype"),0)%>'/>
	                    <input type='hidden' name='operators_<%=freeNum%>' value='<%=operids%>'/>
	                    <input type='hidden' name='operatornames_<%=freeNum%>' value='<%=opernames%>'/>
	                    
	                    <input type='hidden' name='road_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("isroutedit"),0)%>' />
	                    <input type='hidden' name='frms_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("istableedit"),0)%>'/>
	                    <input type='hidden' name='trust_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("isFormSignature"),0)%>'/>
	                    <input type='hidden' name='nodeDo_<%=freeNum%>' value='<%=nodeDo%>'/>
	            <%
	                    cheStr=cheStr+"nodename_"+freeNum+",operators_"+freeNum+",";
	                    freeNum++;  
	                }
	            }else if(init_road==2){
	                //当前节点有后续权限
	                //从当前节点进行遍历
	                int nextnode=nodeid;
	                while(nextnode!=-1){
	                    if(nextnode!=nodeid){   //当前节点除外
	                        RecordSet.executeSql("select * from("+
	                        "select base.id,node.workflowid,base.nodename,node.nodetype,node.isFormSignature,node.IsPendingForward,"+
	                        "base.operators,base.Signtype,base.floworder from workflow_flownode node,workflow_nodebase base where node.nodeid=base.id ) a "+
	                        "left join ("+
	                        "select rights.nodeid,manage.retract,manage.pigeonhole,rights.isroutedit,rights.istableedit from "+
	                        "workflow_function_manage manage full join workflow_freeright rights on manage.operatortype=rights.nodeid"+
	                        ") b on a.id=b.nodeid where a.workflowid="+workflowid+" and a.id="+nextnode);
	                        if (RecordSet.next()) {
	                            
	                            int nextNodeType=Util.getIntValue(RecordSet.getString("nodetype"),0);
	                            if(nextNodeType==3){
	                                //已经是归档节点了
	                                nextnode=-1;
	                                break;
	                            }
	                            String operids=Util.null2String(RecordSet.getString("operators"));
	                            String opernames="";
	                            ArrayList operatorlist=Util.TokenizerString(operids,",");
	                            for(int j=0;j<operatorlist.size();j++){
	                                if(opernames.equals("")){
	                                    opernames=ResourceComInfo.getLastname((String)operatorlist.get(j));
	                                }else{
	                                    opernames+=","+ResourceComInfo.getLastname((String)operatorlist.get(j));
	                                }
	                            }
	                            String nodeDo="";
	                            int pforward=Util.getIntValue(RecordSet.getString("IsPendingForward"),0);
	                            if(pforward==1){
	                                nodeDo=nodeDo+"1,";
	                            }                           
	                            int pigeonhole=Util.getIntValue(RecordSet.getString("pigeonhole"),0);
	                            if(pigeonhole==1){
	                                nodeDo=nodeDo+"2,";
	                            }
	                            int retract=Util.getIntValue(RecordSet.getString("retract"),0);
	                            if(retract==1){
	                                nodeDo=nodeDo+"3,";
	                            }
	                            if(nodeDo.lastIndexOf(",")>-1){
	                                nodeDo = nodeDo.substring(0,nodeDo.lastIndexOf(","));
	                            }
	                        %>
	                            <input type='hidden' name='floworder_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("floworder"),0)%>'/>
	                            <input type='hidden' name='nodename_<%=freeNum%>' value='<%=Util.null2String(RecordSet.getString("nodename"))%>'/>
	                            <input type='hidden' name='nodeid_<%=freeNum%>' value='<%=Util.null2String(RecordSet.getString("nodeid"))%>'/>
	                            <input type='hidden' name='nodetype_<%=freeNum%>' value='<%=nextNodeType%>'/>
	                            <input type='hidden' name='Signtype_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("Signtype"),0)%>'/>
	                            <input type='hidden' name='operators_<%=freeNum%>' value='<%=operids%>'/>
	                            <input type='hidden' name='operatornames_<%=freeNum%>' value='<%=opernames%>'/>
	                            
	                            <input type='hidden' name='road_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("isroutedit"),0)%>' />
	                            <input type='hidden' name='frms_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("istableedit"),0)%>'/>
	                            <input type='hidden' name='trust_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("isFormSignature"),0)%>'/>
	                            <input type='hidden' name='nodeDo_<%=freeNum%>' value='<%=nodeDo%>'/>                                   
	                        <%
	                            cheStr=cheStr+"nodename_"+freeNum+",operators_"+freeNum+",";
	                            freeNum++;
	                        }
	                    }
	                    //获取下一个节点
	                    RecordSet.executeSql("select destnodeid from workflow_nodelink where  nodeid="+nextnode+" and wfrequestid is null and workflowid = "+workflowid+" and (((select COUNT(1) from workflow_nodebase b where workflow_nodelink.nodeid=b.id and (IsFreeNode is null or IsFreeNode !='1'))>0 and (select COUNT(1) from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and (IsFreeNode is null or IsFreeNode !='1'))>0 ) or ((select COUNT(1) from workflow_nodebase b where workflow_nodelink.nodeid=b.id and IsFreeNode ='1' and requestid="+requestid+")>0  or (select COUNT(1) from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and IsFreeNode ='1' and requestid="+requestid+")>0 ))");
	                    String nextnodeid="";
	                    while (RecordSet.next()) {
	                        nextnodeid=nextnodeid+Util.null2String(RecordSet.getString("destnodeid"))+",";
	                    }
	                    if(!nextnodeid.equals("")){
	                        nextnodeid=nextnodeid.substring(0,nextnodeid.lastIndexOf(","));
	                        String[] nnode=nextnodeid.split(",");
	                        if(nnode.length>1){
	                            for(String nid:nnode){
	                                RecordSet.executeSql("select COUNT(id) as id from workflow_nodelink where destnodeid="+nid);
	                                if(RecordSet.next()) {
	                                    if(Util.getIntValue(RecordSet.getString("id"),0)==1){
	                                        nextnode=Util.getIntValue(nid,0);
	                                    }
	                                }else{//可能数据查询报错了
	                                    nextnode=-1;
	                                }
	                            }
	                        }else{
	                            nextnode=Util.getIntValue(nextnodeid,0);
	                        }
	                    }else{//没有下一节点，可能已是归档节点了
	                        nextnode=-1;
	                    }
	                }
	            }
	            if(freeNum>0){
	        %>
	                <input type='hidden' id='rownum' name='rownum' value='<%=freeNum%>'/>
	                <input type='hidden' id='indexnum' name='indexnum' value='<%=freeNum%>'/>
	                <input type='hidden' id='checkfield' name='checkfield' value='<%=cheStr%>'/>
	                <input type='hidden' name="freeNode" value="1"/>
	                <input type='hidden' name="freeDuty" value="<%=init_road%>"/>
	        <%
	            }else{
	        %>  
	                <input type='hidden' name="freeNode" value="0"/>
	        <%
	            }
	        %>
	  </div>
    <%
    	}
    %>
	 <input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
	<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
	<input type="hidden" name="<%=userid%>_<%=workflowid %>_addrequest_submit_token" value="<%=System.currentTimeMillis() %>"/>
</form>
<%
}
int haslinkworkflow=Util.getIntValue(String.valueOf(session.getAttribute("haslinkworkflow")),0);
if(haslinkworkflow==1&&!isrequest.equals("1")){
    session.setAttribute("desrequestid",""+requestid);
	desrequestid=requestid;
}else{
    if(haslinkworkflow==0&&!isrequest.equals("1")){
        session.removeAttribute("desrequestid");
        int linkwfnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")),0);
        for(int i=0;i<=linkwfnum;i++){
            session.removeAttribute("resrequestid"+i);
        }
        session.removeAttribute("slinkwfnum");
    }
}
//添加临时授权信息
if(haslinkworkflow == 1){
    RequestShare.addRequestViewRightInfo(request);
}
%>

<%
String custompage = "";
//查询该工作流的表单id，是否是单据（0否，1是），帮助文档id
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");
if(RecordSet.next()){
	custompage = Util.null2String(RecordSet.getString("custompage"));
}
%>
<%
	if(!custompage.equals("")){
%>
		<jsp:include page="<%=custompage%>" flush="true">
			<jsp:param name="userid" value="<%=userid%>" />
		    <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
		    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
		    <jsp:param name="requestid" value="<%=requestid%>" />
		    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
		    <jsp:param name="creater" value="<%=creater%>" />
		    <jsp:param name="creatertype" value="<%=creatertype%>" />
		    <jsp:param name="deleted" value="<%=deleted%>" />
		    <jsp:param name="billid" value="<%=billid%>" />
			<jsp:param name="isbill" value="<%=isbill%>" />
		    <jsp:param name="workflowid" value="<%=workflowid%>" />
		    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
		    <jsp:param name="formid" value="<%=formid%>" />
		    <jsp:param name="nodeid" value="<%=nodeid%>" />
		    <jsp:param name="nodetype" value="<%=nodetype%>" />
		    <jsp:param name="isreopen" value="<%=isreopen%>" />
		    <jsp:param name="isreject" value="<%=isreject%>" />
		    <jsp:param name="isremark" value="<%=isremark%>" />
			<jsp:param name="currentdate" value="<%=currentdate%>" />
			<jsp:param name="currenttime" value="<%=currenttime%>" />
		    <jsp:param name="needcheck" value="<%=needcheck%>" />
			<jsp:param name="topage" value="<%=topage%>" />
			<jsp:param name="newenddate" value="<%=newenddate%>" />
			<jsp:param name="newfromdate" value="<%=newfromdate%>" />
			<jsp:param name="docfileid" value="<%=docfileid%>" />
			<jsp:param name="newdocid" value="<%=newdocid%>" />
        </jsp:include>
<%		
	}
%>

</td>
		</tr>
		</TABLE>

</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
if (window.addEventListener){
    window.addEventListener("load", windowOnload, false);
}else if (window.attachEvent){
    window.attachEvent("onload", windowOnload);
}else{
    window.onload=windowOnload;
}

function changecancleon(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#f4fcff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","block");
}

function changecancleout(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#ffffff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","none");
}


function clearAllQueue(oUploadcancle){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())+SystemEnv.getHtmlLabelName(21407,user.getLanguage())%>?", function(){
		oUploadcancle.cancelQueue();
	}, function () {}, 320, 90,true);
}

function changebuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#8d8d8d");
	}
}

function uploadbuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#52ab2f");
	}
}

function changebuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#aaaaaa");
	}
}

function uploadbuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#6bcc44");
	}
}

function changefileaon(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#008aff!important;text-decoration:underline!important;");
}

function changefileaout(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#8b8b8b!important;text-decoration:none!important;");
}

function showProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-2px 0px!important;");
}

function hideProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-14px 0px!important;");
}

function changeTab()
{
   /*
   for(i=0;i<=1;i++){
  		parent.$GetEle("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.$GetEle("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$GetEle("oTDtype_0").background="/images/tab.active2_wev8.png";
  	parent.$GetEle("oTDtype_0").className="cycleTDCurrent";
  	*/
  	}



function doDrawBack(obj){
	if("<%=needconfirm%>"=="1"&&!confirm("<%=SystemEnv.getHtmlLabelName(24703,user.getLanguage())%>")){
		return false;
	}else{
	var ischeckok="true";
	<%
		if(isSignMustInput.equals("1")){
		    if("1".equals(isFormSignature)){
			}else{
	%>
	            if(ischeckok=="true"){
	            	getRemarkText_log();
				    if(!check_form($GetEle('frmmain'),'remarkText10404')){
					    ischeckok="false";
				    }
			    }
	<%
			}
		}
	%>
			if(ischeckok=="true"){	
				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
				obj.disabled=true;
				$GetEle('frmmain').action="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=ov&fromflow=1";
				//附件上传
			    StartUploadAll();
		        checkuploadcomplet();
		}
	}
}
function doRetract(obj){
obj.disabled=true;
document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=rb&requestid=<%=requestid%>" //xwj for td3665 20060224
}

function showWFHelp(docid){
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    var operationPage = "/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&id="+docid;
    window.open(operationPage,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}
// modify by xhheng @20050304 for TD 1691
function openSignPrint() {
    window.open("PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=<%=fromFlowDoc%>", "", "toolbar,resizable,scrollbars,dependent,height=500,width=550");
}

function returnTrue(o){
	return;
}

function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}

/** added by cyril on 2008-07-10 for TD:8835*/
function doViewModifyLog() {
	//window.open("/workflow/request/RequestModifyLogView.jsp?requestid=<%=requestid%>&nodeid=<%=nodeid%>&isAll=0&ismonitor=<%=wfmonitor?"1":"0"%>&urger=0");
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/request/RequestModifyLogView.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&nodeid=<%=nodeid%>&isAll=0&ismonitor=<%=wfmonitor?"1":"0"%>&urger=0";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(21625,user.getLanguage())%>";
	dialog.Width = 1000;
	dialog.Height = 550;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
/** end by cyril on 008-07-10 for TD:8835*/
function onNewRequest(wfid,requestid,agent){
	var redirectUrl =  "AddRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&workflowid="+wfid+"&isagent="+agent+"&reqid="+requestid;
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
	var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}
function onNewSms(wfid, nodeid, reqid, menuid){
	var redirectUrl =  "/sms/SendRequestSms.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&workflowid="+wfid+"&nodeid="+nodeid+"&reqid="+reqid + "&menuid=" + menuid;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32818,user.getLanguage())%>";
	dialog.Width = 1000;
	dialog.Height = 550;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = redirectUrl;
	dialog.show();
}
function doEdit(obj){
	parent.location.href="ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&reEdit=1&fromFlowDoc=<%=fromFlowDoc%>&requestid=<%=requestid%>&isovertime=<%=isovertime%>&topage=<%=topage%>";
}
function doSubmitBack(obj){
	<% if("1".equals(isSubmitDirectNode)) { %>
		if($G("SubmitToNodeid")) {
	       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
		}
	<% } %>
	$GetEle("needwfback").value = "1";
	getRemarkText_log();
	doSubmit(obj);
}
function doSubmitNoBack(obj){
	<% if("1".equals(isSubmitDirectNode)) { %>
		if($G("SubmitToNodeid")) {
	       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
		}
	<% } %>
	$GetEle("needwfback").value = "0";
	getRemarkText_log();
	doSubmit(obj);
}
function doRemark_nBack(obj){
	$GetEle("needwfback").value = "1";
	getRemarkText_log();
	doRemark_n(obj);
}
function doRemark_nNoBack(obj){
	$GetEle("needwfback").value = "0";
	getRemarkText_log();
	doRemark_n(obj);
}
function doAffirmanceBack(obj){
	<% if("1".equals(isSubmitDirectNode)) { %>
		if($G("SubmitToNodeid")) {
	       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
		}
	<% } %>
	$GetEle("needwfback").value = "1";
	getRemarkText_log();
	doAffirmance(obj);
}
function doAffirmanceNoBack(obj){
	<% if("1".equals(isSubmitDirectNode)) { %>
		if($G("SubmitToNodeid")) {
	       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
		}
	<% } %>
	$GetEle("needwfback").value = "0";
	getRemarkText_log();
	doAffirmance(obj);
}
function doSubmitDirect(obj, subfun) {
	if($G("SubmitToNodeid")) {
       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
	}
	<% if(!"".equals(ifchangstatus) && ("1".equals(hasback) || ("".equals(hasback) && "".equals(hasnoback)))) { %>
		if("Affirmance" == subfun) {
			doAffirmanceBack(obj);
		}else {
			doSubmitBack(obj);
		}
	<% }else { %>
		if("Affirmance" == subfun) {
			doAffirmanceNoBack(obj);
		}else {
			doSubmitNoBack(obj);
		}
	<% } %>
}
function doSave_nNew(obj){
	getRemarkText_log();
	doSave_n(obj);
}
function doReject_New(){
	getRemarkText_log();
	doReject();
}
function doSubmit_Pre(obj){
	<% if("1".equals(isSubmitDirectNode) || "1".equals(isSubmitDirect)) { %>
		if($G("SubmitToNodeid")) {
	       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
		}
	<% } %>
	getRemarkText_log();
	doSubmit(obj);
}
function getRemarkText_log(){
	try{
		var reamrkNoStyle = FCKEditorExt.getText("remark");
		if(reamrkNoStyle == ""){
			$GetEle("remarkText10404").value = reamrkNoStyle;
		}else{
			var remarkText = FCKEditorExt.getTextNew("remark");
			$GetEle("remarkText10404").value = remarkText;
		}
		for(var i=0; i<FCKEditorExt.editorName.length; i++){
			var tmpname = FCKEditorExt.editorName[i];
			try{
				if(tmpname == "remark"){
					continue;
				}
				$(tmpname).value = FCKEditorExt.getText(tmpname);
			}catch(e){}
		}
	}catch(e){
	}
}

function triSubwf(paramSubwfSetId){
	$GetEle("triSubwfIframe").src="/workflow/request/TriSubwfIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&operation=triSubwf&requestId=<%=requestid%>&nodeId=<%=nodeid%>&paramSubwfSetId="+paramSubwfSetId+"&tempflag="+Math.random();
}

function triSubwf2(paramSubwfSetId,subworkflowname){
	subworkflowname = subworkflowname.replace(new RegExp(',',"gm"),'\n');
	var info = "<%=SystemEnv.getHtmlLabelName(25394,user.getLanguage())%>:"+"\n"+subworkflowname+"<%=SystemEnv.getHtmlLabelName(25395,user.getLanguage())%>";
	top.Dialog.confirm(info,function(){
		$GetEle("triSubwfIframe").src="/workflow/request/TriSubwfIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&operation=triSubwf&requestId=<%=requestid%>&nodeId=<%=nodeid%>&paramSubwfSetId="+paramSubwfSetId+"&tempflag="+Math.random();
	});
}

function returnTriSubwf(returnString){
	if(returnString==1){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22064,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%>");
	}else {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22064,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>");
	}
	location.reload();
}

jQuery(document).ready(function(){
	if( '<%=isFree%>' == '1' ){
		//在流程表单中创建一个隐藏的div，用于存放自由流程设置信息
	    //jsp生成的div可能在form之外，此功能用于将div中的内容移入form中，保证数据正确提交
	    //在流程表单中创建一个隐藏的div，用于存放自由流程设置信息
	    //jsp生成的div可能在form之外，此功能用于将div中的内容移入form中，保证数据正确提交
	    jQuery('[name=frmmain]').append(
	        '<div class="freeNode" style="display:none;">'
	            + jQuery('.freeNode').html()
	        +'</div>'
	    );
	    if (jQuery('.freeNode').length > 1) {
	    	jQuery('.freeNode').eq(1).remove();
	    }
	}
});

function doFreeWorkflow(){
	//如果流程为自由流程，则默认显示自由流程设置窗体
	if( '<%=isFree%>' == '1' ){
		 //初始化自由流程设置
		if(jQuery(".freeNode").find("input[name='indexnum']").length <= 0){
			jQuery(".freeNode").append("<input type='hidden' id='rownum' name='rownum' value='1'/>");
			jQuery(".freeNode").append("<input type='hidden' id='indexnum' name='indexnum' value='1'/>");
			jQuery(".freeNode").append("<input type='hidden' id='checkfield' name='checkfield' value='nodename_0,operators_0'/>");
		}

		//打开自由流程设置浏览框
		var dlg = new window.top.Dialog();//定义Dialog对象
	　　dlg.Width = 1000;//定义长度
	　　dlg.Height = 550;
	    dlg.URL = "/workflow/request/FreeNodeShow.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&workflowid=<%=workflowid%>&requestid=<%=requestid%>&isroutedit=<%=init_road%>&istableedit=<%=init_frms%>";
	　　dlg.Title = "<%=SystemEnv.getHtmlLabelName(83284,user.getLanguage())%>";
		dlg.maxiumnable = false;
	　　dlg.show();
		// 保留对话框对象
		window.top.freewindow = window;
		window.top.freedialog = dlg;

		return;
	}
	
	var title = "<%=SystemEnv.getHtmlLabelName(21781,user.getLanguage())%>";
	var url="/workflow/workflow/BrowserMain.jsp?&url=/workflow/request/FreeWorkflowSet.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>";
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 550;
	dialog.Height = 550;
	dialog.Modal = true;
	dialog.Title = title;
	dialog.URL =url;
	dialog.isIframe=false;
	dialog.show();

    //window.showModalDialog("/workflow/workflow/BrowserMain.jsp?url=/workflow/request/FreeWorkflowSet.jsp?requestid=<%=requestid%>",window);
}
function onNewOverTime(){
	var redirectUrl =  "/workflow/request/OverTimeSetByNodeUser.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&requestid=<%=requestid%>&formid=<%=formid%>&isbill=1&billid=<%=billid%>";
	var dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    dialog.URL = redirectUrl;
	dialog.Title ="<%=SystemEnv.getHtmlLabelName(18818,user.getLanguage())%>";
    dialog.Height = screen.availHeight/2;
    dialog.Width = screen.availWidth/2;
    dialog.Drag = true;
    dialog.show();
}

function onSetRejectNode(){
	<% if(!"1".equals(GCONST.getWorkflowReturnNode())) { %>
		return true;
	<% } %>
    var boolean;
　　	var dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    dialog.callbackfunParam = null;
    <%
     if(!freedis.equals("")&&!isornotFree.equals("")){
		String zjclNodeid=stnode.getIsFreeStart01Node(""+nodeid);
		//逐级退回
		if(freedis.equals("1")){
		   if(isrejectremind.equals("1")&&ischangrejectnode.equals("1")){%>
			  var url=escape("/workflow/request/RejectNodeSetFree.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&isrejecttype=1&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=currentnodeid%>&isrejectremind=<%=isrejectremind%>&ischangrejectnode=<%=ischangrejectnode%>&isselectrejectnode=<%=isselectrejectnode%>&isFreeNode=<%=nodeidss%>");
			  dialog.URL ="/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&url="+url;
		   <%}else{%>
		      if($G("RejectNodes")) $G("RejectNodes").value="<%=zjclNodeid%>";
		      if($G("RejectToNodeid")) $G("RejectToNodeid").value="<%=zjclNodeid%>"; 
		      return true;
		   <%}
		   }else{//自由退回
		    %>
		      var url=escape("/workflow/request/RejectNodeSetFree.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=currentnodeid%>&isrejectremind=<%=isrejectremind%>&ischangrejectnode=<%=ischangrejectnode%>&isselectrejectnode=<%=isselectrejectnode%>&isFreeNode=<%=nodeidss%>");
			  dialog.URL ="/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&url="+url;
			<%}
    }else{
	    if((isrejectremind.equals("1")&&ischangrejectnode.equals("1"))||isselectrejectnode.equals("1") || "2".equals(isselectrejectnode)){%>
		    var url=escape("/workflow/request/RejectNodeSet.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=currentnodeid%>&isrejectremind=<%=isrejectremind%>&ischangrejectnode=<%=ischangrejectnode%>&isselectrejectnode=<%=isselectrejectnode%>");
		    dialog.URL ="/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&url="+url;
	 <%}else{%>
	    	return true;
     <%}
	}%>
     dialog.callbackfun = function (paramobj, id1) {
        if(id1) {          
            if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
                var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
                var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
                var sHtml = "";
                resourceids = resourceids.substr(0);
                resourcename = resourcename.substr(0);
                var val=resourcename.split("|");
                if($G("RejectNodes")) $G("RejectNodes").value=val[0];
			    if($G("RejectToNodeid")) $G("RejectToNodeid").value=val[1];
			    if($G("RejectToType")) $G("RejectToType").value=val[2];
			    showtipsinfo(<%=requestid%>,<%=workflowid%>,<%=nodeid%>,<%=isbill%>,1,<%=billid%>,"","reject","0","divFavContent18980","<%=SystemEnv.getHtmlLabelName(18980,user.getLanguage())%>");
            }
        }
    } ;
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())%>";
    dialog.Height = 400 ;
    dialog.Drag = true;
    dialog.show();
}
</SCRIPT>
<!-- added by cyril on 20080610 for td8828-->
<script language=javascript src="/js/checkData_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>
<script language="JavaScript">
 //微信提醒(QC:98106)
 function onNewChats(wfid, nodeid,reqid, menuid){ 
	var redirectUrl =  "/wechat/sendWechat.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&workflowid="+wfid+"&nodeid="+nodeid+"&reqid="+reqid+"&actionid=dialog&menuid=" + menuid;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32818,user.getLanguage())%>";
	dialog.Width = 1000;
	dialog.Height = 350;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = redirectUrl;
	dialog.show();
}
	if("<%=seeflowdoc%>"=="1"){
		if($GetEle("rightMenu")!=null){
			$GetEle("rightMenu").style.display="none";
		}
	}
<%if("1".equals(session.getAttribute("istest"))){%>
function setAdiabled(){
	jQuery("a").attr("disabled", true);
	jQuery("a").attr("onclick", "javascript:return false;");
	jQuery("a").attr("href", "javascript:return false;");
	jQuery("a").attr("target", "_blank");
}



function setAdiabledLoad(){
	setAdiabled();
	setInterval(setAdiabled, 500);
}
jQuery(document).ready(function(){
	setAdiabledLoad();
});
<%}%>



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
</script>

<jsp:include page="/workflow/request/UserDefinedRequestBrowser.jsp" flush="true">
	<jsp:param name="workflowid" value="<%=workflowid%>" />
</jsp:include>