
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ page import="weaver.workflow.request.SubWorkflowTriggerService" %>
<%@	page import="weaver.workflow.request.RequestShare"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONException" %>
<%@ page import="weaver.common.StringUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/>
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page" />
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" />
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="WFLinkInfo_nf" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="RecordSet6" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet7" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet8" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RecordSet9" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RequestTriDiffWfManager" class="weaver.workflow.request.RequestTriDiffWfManager" scope="page" /> 
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<!-- 微信提醒(QC:98106) -->
<jsp:useBean id="WechatPropConfig" class="weaver.wechat.util.WechatPropConfig" scope="page"/>
<jsp:useBean id="CptWfUtil" class="weaver.cpt.util.CptWfUtil" scope="page"/>
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



int modeid = Util.getIntValue(request.getParameter("modeid"),0);
int isform = Util.getIntValue(request.getParameter("isform"),0);
String docCategory="";
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
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
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

String topage = Util.null2String(request.getParameter("topage")) ;        //返回的页面



String isaffirmance=Util.null2String(request.getParameter("isaffirmance"));//是否需要提交确认



String reEdit=Util.null2String(request.getParameter("reEdit"));//是否为编辑



// 工作流新建文档的处理
String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
String isrejectremind="";
String ischangrejectnode="";
//td30785
String isselectrejectnode="";
// 董平 2004-12-2 FOR TD1421  新建流程时如果点击表单上的文档新建按钮，在新建完文档之后，能返回流程，但是文档却没有挂带进来。



String newdocid = Util.null2String(request.getParameter("newdocid"));        // 新建的文档



int desrequestid=0;

// 操作的用户信息



String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
int usertype = 0;                           //用户在工作流表中的类型 0: 内部 1: 外部
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";

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
docCategory=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"docCategory"));
boolean IsCanSubmit="true".equals(session.getAttribute(userid+"_"+requestid+"IsCanSubmit"))?true:false;
String IsPendingForward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsPendingForward"));
String IsTakingOpinions=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsTakingOpinions"));
String IsHandleForward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsHandleForward"));
String IsBeForward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForward"));
String IsBeForwardTodo=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForwardTodo"));
String IsBeForwardAlready=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForwardAlready"));  // 已办转发
String IsBeForwardSubmitAlready=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForwardSubmitAlready"));
String IsBeForwardSubmitNotaries=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForwardSubmitNotaries"));
String IsFromWFRemark_T=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsFromWFRemark_T"));
boolean canForwd = false;
if(isremark == 1 && takisremark ==2 && "1".equals(IsPendingForward)){  //征询意见回复\
canForwd = true;
}

RecordSet.executeSql("select * from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
IsPendingForward=Util.null2String(RecordSet.getString("IsPendingForward"));
IsTakingOpinions=Util.null2String(RecordSet.getString("IsTakingOpinions"));
IsHandleForward=Util.null2String(RecordSet.getString("IsHandleForward"));
}
if(takisremark !=2){
if(("0".equals(IsFromWFRemark_T) && "1".equals(IsBeForwardTodo)) 
        || ("1".equals(IsFromWFRemark_T) && "1".equals(IsBeForwardAlready)) 
        || ("2".equals(IsFromWFRemark_T) && "1".equals(IsBeForward))){
	canForwd = true;
}
}
currentnodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"currentnodeid"),0);
currentnodetype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"currentnodetype"));
boolean IsFreeWorkflow="true".equals(session.getAttribute(userid+"_"+requestid+"IsFreeWorkflow"))?true:false;
boolean isImportDetail="true".equals(session.getAttribute(userid+"_"+requestid+"isImportDetail"))?true:false;

boolean IsCanModify="true".equals(session.getAttribute(userid+"_"+requestid+"IsCanModify"))?true:false;
//String coadisforward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"coadisforward"));
boolean coadCanSubmit="true".equals(session.getAttribute(userid+"_"+requestid+"coadCanSubmit"))?true:false;
String coadsigntype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"coadsigntype"));

lastOperator=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"lastOperator"),0);
lastOperateDate=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateDate"));
lastOperateTime=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateTime"));


//资产自定义流程类型

	String cptwftype=CptWfUtil.getAllCptWftype(""+workflowid);
	boolean isCptwf=false;
	boolean ismodeCptwf=false;
	if(!"".equals(cptwftype)){
		isCptwf="fetch".equalsIgnoreCase(cptwftype)
				||"move".equalsIgnoreCase(cptwftype)
				||"lend".equalsIgnoreCase(cptwftype)
				||"discard".equalsIgnoreCase(cptwftype)
				||"back".equalsIgnoreCase(cptwftype)
				||"loss".equalsIgnoreCase(cptwftype)
				||"mend".equalsIgnoreCase(cptwftype)
				||"mode_fetch".equalsIgnoreCase(cptwftype)
				||"mode_move".equalsIgnoreCase(cptwftype)
				||"mode_lend".equalsIgnoreCase(cptwftype)
				||"mode_discard".equalsIgnoreCase(cptwftype)
				||"mode_back".equalsIgnoreCase(cptwftype)
				||"mode_loss".equalsIgnoreCase(cptwftype)
				||"mode_mend".equalsIgnoreCase(cptwftype);
		ismodeCptwf=cptwftype.startsWith("mode_");
	}
//是否具有分享权限
boolean iscanshare = false;
RecordSet.executeSql("select isremark,nodeid from workflow_currentoperator where (isremark<8 or isremark>8) and requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by isremark,islasttimes desc");
while(RecordSet.next())	{
	iscanshare = true;
    int tempisremark = Util.getIntValue(RecordSet.getString("isremark"),0) ;
    int tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"));
    if( tempisremark == 0 || tempisremark == 1 || tempisremark == 5 || tempisremark == 9|| tempisremark == 7) {                       // 当前操作者或被转发者



        isremark = tempisremark ;
        nodeid=tmpnodeid;
        nodetype=WFLinkInfo_nf.getNodeType(nodeid);
        break ;
    }
}

RecordSet.executeSql("select isremark from workflow_currentoperator where isremark=8 and requestid="+requestid+" and userid="+userid+" and usertype="+usertype);
while(RecordSet.next())	{
	iscanshare = true;
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
	//RecordSet.executeSql("update workflow_currentoperator set isremark=2,operatedate='"+currentdate+"',operatetime='"+currenttime+"' where requestid="+requestid+" and userid="+userid+" and usertype=0"+usertype);
  //时间与数据库保持一致，所以采用存储过程来更新数据库。



  RecordSet.executeProc("workflow_CurrentOperator_Copy",requestid+""+flag+userid+flag+usertype+"");
  if(currentnodetype.equals("3")){
  	RecordSet.executeSql("update workflow_currentoperator set iscomplete=1 where requestid="+requestid+" and userid="+userid+" and usertype="+usertype);
  }
	response.sendRedirect("/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+requestid+"&isremark=8&fromFlowDoc="+fromFlowDoc);
	return;
}
/*--  xwj for td2104 on 20050802 begin  --*/
boolean isOldWf = false;
RecordSet.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSet.next()){
	if(RecordSet.getString("nodeid") == null || "".equals(RecordSet.getString("nodeid")) || "-1".equals(RecordSet.getString("nodeid"))){
			isOldWf = true;
	}
}

if(! currentnodetype.equals("3") )
    RecordSet.executeProc("SysRemindInfo_DeleteHasnewwf",""+userid+flag+usertype+flag+requestid);
else
    RecordSet.executeProc("SysRemindInfo_DeleteHasendwf",""+userid+flag+usertype+flag+requestid);

String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(18015,user.getLanguage())+":"
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage())+ " - " + status + " "+"<span id='requestmarkSpan'>"+requestmark+"</span>";//Modify by 杨国生 2004-10-26 For TD1231
String needfav ="1";
String needhelp ="";

//判断是否有流程创建文档，并且在该节点是有正文字段
boolean docFlag=flowDoc.haveDocFiled(""+workflowid,""+nodeid);
String  docFlagss=docFlag?"1":"0";
session.setAttribute("requestAdd"+requestid,docFlagss);

WFManager.setWfid(Util.getIntValue(""+workflowid));
WFManager.getWfInfo();
String isFree = WFManager.getIsFree();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>

<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<!--添加插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwfat_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
<!-- ckeditor的一些方法在uk中的实现 -->
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>
<script language=javascript>
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>

<!-- word转html插件 -->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>

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
<SCRIPT language=VBS>

Sub oc_CurrentMenuOnMouseOut(icount)
    document.getElementById("oc_divMenuDivision"&icount).style.visibility = "hidden"
End Sub

Sub oc_CurrentMenuOnClick(icount)
    document.getElementById("oc_divMenuDivision"&icount).style.visibility = ""
End Sub
</SCRIPT>

<script language="javascript">

//TD4262 增加提示信息  开始



function windowOnload()
{
    init();
    //funcremark_log();
<%
	if( message.equals("1") ) {//工作流信息保存错误



%>
	      //contentBox = document.getElementById("divFavContent16332");
          //showObjectPopup(contentBox);
          //window.setTimeout("oPopup.hide()", 2000);
<%
	} else if( message.equals("2") ) {//工作流下一节点或下一节点操作者错误



%>
	      //contentBox = document.getElementById("divFavContent16333");
          //showObjectPopup(contentBox);
          //window.setTimeout("oPopup.hide()", 2000);
<%
	} else if( message.equals("3") ) {//子流程创建人无值，请检查子流程创建人设置。



%>

		  //var content="<%=SystemEnv.getHtmlLabelName(19455,user.getLanguage())%>";
		  //showPrompt(content);
          //window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	} else if( message.equals("4") ) {//已经流转到下一节点，不可以再提交。



%>

		  //var content="<%=SystemEnv.getHtmlLabelName(21266,user.getLanguage())%>";
		  //showPrompt(content);
          //window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	} else if( message.equals("5") ) {//流程流转超时，请重试。



%>

		  //var content="<%=SystemEnv.getHtmlLabelName(21270,user.getLanguage())%>";
		  //showPrompt(content);
          //window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	} else if( message.equals("6") ) {//转发失败，请重试！



%>
		
		  //var content="<%=SystemEnv.getHtmlLabelName(21766,user.getLanguage())%>";
		  //showPrompt(content);
          //window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);
		
<%
	} else if( message.equals("7") ) {//已经处理，不可重复处理！
%>

		  //var content="<%=SystemEnv.getHtmlLabelName(22751,user.getLanguage())%>";
		  //showPrompt(content);
          //window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	} else if( message.equals("8") ) {//流程数据已更改，请核对后再处理！
%>

	      //contentBox = document.getElementById("divFavContent24676");
          //showObjectPopup(contentBox);
          //window.setTimeout("oPopup.hide()", 2000);

<%
	}
%>
//window.setTimeout(function(){displayAllmenu();},3000);
displayAllmenu();
}


//TD4262 增加提示信息  结束

window.onbeforeunload =  function protectManageBillFlow(){
  	if(!checkDataChange())//modified by cyril on 2008-06-10 for TD:8828
        return "<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
   }
   function doBack(){
	   jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		 <%if (!fromFlowDoc.equals("1")) {%>
        parent.document.location.href="/workflow/request/RequestView.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>"; //xwj for td3425 20051201
		<%}else {%>
        parent.document.location.href="/workflow/request/RequestView.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>"; 
		<%}%>
   }

function replaceAll(strOrg,strFind,strReplace){ 
    var index = 0; 
    while(strOrg.indexOf(strFind,index) != -1){ 
        strOrg = strOrg.replace(strFind,strReplace); 
        index = strOrg.indexOf(strFind,index); 
    } 
    return strOrg ;
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
	var id = <%=requestid%>;
	var workflowRequestLogId=0;
	var remarklag = "";
	if(document.getElementById("workflowRequestLogId")!=null){
		workflowRequestLogId=document.getElementById("workflowRequestLogId").value;
	}
	try{
		frmmain.ChinaExcel.EndCellEdit(true);
	}catch(e1){}
	try{
		FCKEditorExt.updateContent();
		//frmmain.target = "_blank";
		//frmmain.action = "/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId;
		//附件上传
        StartUploadAll();
        checkfileuploadcomplet();
		var remark="";
		try{
			remark = FCKEditorExt.getHtml("remark");
		}catch(e){}
		if(resourceid)
		openDialog("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid + "&remark=" + escape(remark));
		else
        openDialog("<%=requestname%>","/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&remark=" + escape(remark));
	}catch(e){
		var remark="";
		try{
			remark = FCKEditorExt.getHtml("remark");
		}catch(e){}
		var forwardurl;
		if(resourceid)
			forwardurl = "/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&resourceids="+resourceid+"&workflowRequestLogId="+workflowRequestLogId;	
		else
			forwardurl = "/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id+"&workflowRequestLogId="+workflowRequestLogId;	
		//openFullWindowHaveBar(forwardurl);
		openDialog("<%=requestname%>",forwardurl);
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


<%
String ismode="";
String isFormSignatureOfThisJsp=null;
int toexcel=0;
RecordSet.executeSql("select ismode,showdes,isFormSignature,toexcel from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	ismode=Util.null2String(RecordSet.getString("ismode"));
	isFormSignatureOfThisJsp = Util.null2String(RecordSet.getString("isFormSignature"));
	toexcel=Util.getIntValue(RecordSet.getString("toexcel"),0);
}
int isUseWebRevisionOfThisJsp = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
if(isUseWebRevisionOfThisJsp != 1){
	isFormSignatureOfThisJsp = "";
}
String hasSign = "0";
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-4");
if(RecordSet.next()){ hasSign = "1";}
%>

   function doReview(resourceid){


	   jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

//保存签章数据
<%if("1".equals(isFormSignatureOfThisJsp)&&"0".equals(hasSign)){%>
				try{  
					  if(typeof(eval("SaveSignature"))=="function"){
                        //转发时不验证签字意见必填
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


</SCRIPT>

<BODY id="flowbody"  ><%--Modified by xwj for td3247 20051201--%>

<%if (!docFlag) {%>
<%@ include file="RequestTopTitle.jsp" %>
<%}%>
<iframe id="fileDownload" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="triSubwfIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<%//TD9145
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
String FreeWorkflowname=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"FreeWorkflowname"));
String sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+nodeid;
String sqlselectNewName = "select * from workflow_nodeCustomNewMenu where enable = 1 and wfid=" + workflowid + " and nodeid=" + nodeid + " order by menuType, id";
if(isremark != 0){
	RecordSet.executeSql("select nodeid from workflow_currentoperator c where c.requestid="+requestid+" and c.userid="+userid+" and c.usertype="+usertype+" and c.isremark='"+isremark+"' ");
	int tmpnodeid = 0;
	if(RecordSet.next()){
		tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"), 0);
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
		saveName = Util.null2String(RecordSet.getString("saveName9"));
		rejectName = Util.null2String(RecordSet.getString("rejectName9"));
		forsubName = Util.null2String(RecordSet.getString("forsubName9"));

		takingopinionsName = Util.null2String(RecordSet.getString("takingOpName9"));
		HandleForwardName = Util.null2String(RecordSet.getString("forhandName9"));
		forhandnobackName = Util.null2String(RecordSet.getString("forhandnobackName9"));
		forhandbackName = Util.null2String(RecordSet.getString("forhandbackName9"));
		givingopinionsName = Util.null2String(RecordSet.getString("takingOpinionsName9"));
		givingOpinionsnobackName = Util.null2String(RecordSet.getString("takingOpinionsnobackName9"));
		givingOpinionsbackName = Util.null2String(RecordSet.getString("takingOpinionsbackName9"));


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
		saveName = Util.null2String(RecordSet.getString("saveName8"));
		rejectName = Util.null2String(RecordSet.getString("rejectName8"));
		forsubName = Util.null2String(RecordSet.getString("forsubName8"));

		takingopinionsName = Util.null2String(RecordSet.getString("takingOpName8"));
		HandleForwardName = Util.null2String(RecordSet.getString("forhandName8"));
		forhandnobackName = Util.null2String(RecordSet.getString("forhandnobackName8"));
		forhandbackName = Util.null2String(RecordSet.getString("forhandbackName8"));
		givingopinionsName = Util.null2String(RecordSet.getString("takingOpinionsName8"));
		givingOpinionsnobackName = Util.null2String(RecordSet.getString("takingOpinionsnobackName8"));
		givingOpinionsbackName = Util.null2String(RecordSet.getString("takingOpinionsbackName8"));

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

if("".equals(forhandbackName)){   //转办回复
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
<%
String strBar="[";//菜单
if(!wfmonitor){
    if (isaffirmance.equals("1") && nodetype.equals("0") && !reEdit.equals("1")){//提交确认菜单
if(IsCanSubmit||coadCanSubmit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(16634,user.getLanguage())+",javascript:doSubmit_Pre(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(16634,user.getLanguage())+"',iconCls:'btn_draft',handler: function(){doSubmit_Pre(this);}},";
	if(!"1".equals(isSubmitDirectNode)) {
		isSubmitDirect = Util.null2String(request.getParameter("isSubmitDirect"));
	}
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"',iconCls:'btn_draft',handler: function(){location.href='ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+requestid+"&isovertime="+isovertime+"&reEdit=1&fromFlowDoc="+fromFlowDoc+"';}},";
}else{%>
<% if(isremark == 1||isremark == 9){ %>
<%
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
		if(("1".equals(hastakingOpinionsback)&&isremark==1 && takisremark ==2)){
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
        RCMenu += "{"+saveName+",javascript:doSave_nNew(),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
        strBar += "{text: '"+saveName+"',iconCls:'btn_wfSave',handler: function(){doSave_nNew();}},";
    }
    if((isremark==1&&canForwd)||(isremark==9&&IsPendingForward.equals("1"))){
        RCMenu += "{"+forwardName+",javascript:doReview(),_self}" ;//add by mackjoe
        RCMenuHeight += RCMenuHeightStep ;
        strBar += "{text: '"+forwardName+"',iconCls:'btn_forward',handler: function(){doReview();}},";
    }
}else if(isremark == 5){
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
}else { %>
<%
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
			if("1".equals(hasnoback)){
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
				if("1".equals(hasback) || "1".equals(hasforhandback)){
				RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
				RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doSubmitBack(this);}},";
			}
			if("1".equals(hasnoback) || "1".equals(hasforhandnoback)){
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
RCMenu += "{"+saveName+",javascript:doSave_nNew(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+saveName+"',iconCls:'btn_wfSave',handler: function(){doSave_nNew();}},";
if( isreject.equals("1") &&isremark==0){
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
if(IsTakingOpinions.equals("1")){  //征求意见
RCMenu += "{"+takingopinionsName+",javascript:doReview2(),_self}" ;//Modified by xwj for td3247 20051201
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+takingopinionsName+"',iconCls:'btn_forward',handler: function(){doReview2();}},";
//rmklag = 2;
}
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
<%  }%>

<%
HashMap map = WfFunctionManageUtil.wfFunctionManageByNodeid(workflowid,nodeid);
String ov = (String)map.get("ov");
String rb = (String)map.get("rb");
haveOverright=((isremark != 1&&isremark != 9&&isremark != 5) || (isremark == 7 && !"2".equals(coadsigntype))) && "1".equals(ov) && WfForceOver.isNodeOperator(requestid,userid) && !currentnodetype.equals("3");
//haveBackright=isremark != 1&&isremark != 9&&isremark != 7&&isremark != 5&&!"0".equals(rb) && WfForceDrawBack.isHavePurview(requestid,userid,Integer.parseInt(logintype),-1,-1) && !currentnodetype.equals("0");
haveBackright=WfForceDrawBack.checkOperatorIsremark(requestid, userid, usertype, isremark)&&!"0".equals(rb) && WfForceDrawBack.isHavePurview(requestid,userid,Integer.parseInt(logintype),-1,-1) && !currentnodetype.equals("0");

if(haveOverright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+",javascript:doDrawBack(this),_self}" ;//xwj for td3665 20060224
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+"',iconCls:'btn_doDrawBack',handler: function(){doDrawBack(this);}},";
}

if(haveBackright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(18359,user.getLanguage())+",javascript:doRetract(this),_self}" ;//xwj for td3665 20060224
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(18359,user.getLanguage())+"',iconCls:'btn_doRetract',handler: function(){doRetract(this);}},";
}
if(haveStopright)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20387,user.getLanguage())+",javascript:doStop(this),_self}" ;//xwj for td3665 20060224
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
strBar += "{text: '"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"',iconCls:'btn_detele',handler: function(){doDelete();}},";
}
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
if(WechatPropConfig.isUseWechat()){
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
		RCMenu += "{"+triSubwfName+",javascript:triSubwf2("+subwfSetId+",\\\""+workflowNames+"\\\"),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+triSubwfName+"',iconCls:'btn_relateCwork',handler: function(){triSubwf2("+subwfSetId+",\\\""+workflowNames+"\\\");}},";
	}
}

if(!isfromtab&&!"1".equals(session.getAttribute("istest"))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+"',iconCls:'btn_back',handler: function(){doBack();}},";
}
}
if(toexcel==1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+" Excel,javascript:ToExcel(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+" Excel',iconCls:'btn_excel',handler: function(){ToExcel();}},";
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:openSignPrint(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+"',iconCls:'btn_print',handler: function(){openSignPrint();}},";
}

if(iscanshare){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(126091,user.getLanguage())+",javascript:doShare(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(126091,user.getLanguage())+"',iconCls:'btn_collect',handler: function(){doShare();}},";
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(21533,user.getLanguage())+",javascript:doPrintViewLog(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(21533,user.getLanguage())+"',iconCls:'btn_collect',handler: function(){doPrintViewLog();}},";


if(strBar.lastIndexOf(",")>-1) strBar = strBar.substring(0,strBar.lastIndexOf(","));
strBar+="]";
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="javascript">
enableAllmenu();
</script>
        <input type=hidden name=seeflowdoc value="<%=seeflowdoc%>">
		<input type=hidden name=isworkflowdoc value="<%=isworkflowdoc%>">
        <input type=hidden name=wfdoc value="<%=wfdoc%>">
        <input type=hidden name=picInnerFrameurl value="/workflow/request/WorkflowRequestPictureInner.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>">

		<TABLE width="100%">
		<tr>
		<td valign="top">

    <table width="100%" id="t_help">
        <tr><td width="80%" align=left>
			<jsp:include page="wfSubmitErrorMsg.jsp">
       			<jsp:param name="message" value="<%=message %>" />
       			<jsp:param name="requestid" value="<%=requestid %>" />
       		</jsp:include>
        </td>
        </tr>
    </table>

<%
String operationpage = "" ;
if("1".equals(isbill)) {
	RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
	if(RecordSet.next()){
		operationpage = Util.null2String(RecordSet.getString("operationpage"));
	}
}
if( operationpage.equals("") ){
	operationpage = "RequestOperation.jsp" ;
}
%>    
   <form name="frmmain" method="post" action="<%=operationpage%>">
	<TABLE class="ViewForm" id="t_header">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <%
    String isEdit_ = "-1";
    RecordSet.executeSql("select isedit from workflow_nodeform where nodeid = " + String.valueOf(nodeid) + " and fieldid = -1");
    if(RecordSet.next()){
   isEdit_ = Util.null2String(RecordSet.getString("isedit"));
    }
boolean hasRequestname = false;
boolean hasRequestlevel = false;
boolean hasMessage = false;
boolean hasChats = false;//微信提醒(QC:98106)
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-1");
if(RecordSet.next()) hasRequestname = true;
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-2");
if(RecordSet.next()) hasRequestlevel = true;
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-3");
if(RecordSet.next()) hasMessage = true;
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-5");//微信提醒(QC:98106)
if(RecordSet.next()) hasChats = true;//微信提醒(QC:98106)
String tempMessageType = "";
String tempChatsType = "";//微信提醒(QC:98106)
RecordSet.executeSql("select messageType,chatsType from workflow_base where id="+workflowid);//微信提醒(QC:98106)
if(RecordSet.next()){
    tempMessageType = Util.null2String(RecordSet.getString("messageType"));
    tempChatsType = Util.null2String(RecordSet.getString("chatsType"));//微信提醒(QC:98106)
}
  %>
  <TR class="Spacing" style="height:1px;">
    <TD class="Line1" colSpan=2></TD>
  </TR>

<%
if(!hasRequestname||!hasRequestlevel||!hasMessage||!hasChats){ //微信提醒(QC:98106)
boolean editflag = true;//流程的处理人可以编辑流程的优先级和是否短信提醒



if(isremark==1||isremark==8||isremark==9||isremark==7) editflag = false;//被转发人或被抄送（需提交）人不能编辑
if(editflag&&"0".equals(nodetype)&&(!isaffirmance.equals("1")||reEdit.equals("1"))){%>
<%if(!hasRequestname||!hasRequestlevel){%>
  <TR>
  	<%if(!hasRequestname){ %>
    <TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
    <td class=fieldvalueClass>
        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword('requestname',document.getElementById('requestname').value,1)" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
		<%}
		if(!hasRequestlevel){ %>
			<%if(hasRequestname){%>
			<TD><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></TD>
			<td class=fieldvalueClass>
			<%}%>
        <input type=radio value="0" name="requestlevel" <%if(requestlevel.equals("0")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio value="1" name="requestlevel" <%if(requestlevel.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <input type=radio value="2" name="requestlevel" <%if(requestlevel.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
     <%}%> 
      </TD>
  </TR>
  <TR style="height:1px;">
    <TD class="Line1" colSpan=2></TD>
  </TR>
<%}%>

<%if(!hasMessage&&tempMessageType.equals("1")){
      String sqlWfMessage = "select a.messagetype from workflow_requestbase a,workflow_base b where a.workflowid=b.id and b.messagetype='1' and a.requestid="+requestid ;
	  RecordSet.executeSql(sqlWfMessage);
      if (RecordSet.next()) {
		  int rqMessageType=RecordSet.getInt("messagetype");
%>
                  <TR>
                    <TD  class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
                    <td class=fieldvalueClass>
                          <span id=messageTypeSpan></span>
                          <input type=radio value="0" name="messageType"   <%if(rqMessageType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
                          <input type=radio value="1" name="messageType"   <%if(rqMessageType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
                          <input type=radio value="2" name="messageType"   <%if(rqMessageType==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
                        </td>
                  </TR>  	   	
                  <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
      <%}}%>
      <!-- 微信提醒START(QC:98106) -->
      <%if(!hasChats&&tempChatsType.equals("1")){
      String sqlWfChats = "select a.chatstype from workflow_requestbase a,workflow_base b where a.workflowid=b.id and b.chatstype='1' and a.requestid="+requestid ;
	  RecordSet.executeSql(sqlWfChats);
      if (RecordSet.next()) {
		  int rqChatsType=RecordSet.getInt("chatstype");
%>
                  <TR>
                    <TD class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></TD>
                    <td class="fieldvalueClass">
                          <span id=chatsTypeSpan></span>
                          <input type=radio value="0" name="chatsType"   <%if(rqChatsType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
                          <input type=radio value="1" name="chatsType"   <%if(rqChatsType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>
                          </td>
                  </TR>  	   	
                  <TR><TD class=Line2 colSpan=2></TD></TR>
      <%}}%> 
      <!-- 微信提醒END(QC:98106) -->
<%}else{ %>
  <TR>
    <TD class="fieldnameClass">
    	<%if(!hasRequestname){ %>
    	<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>
    	<%}else if(!hasRequestlevel){ %>
    		<%if(!hasMessage&&tempMessageType.equals("1")){%>
    			<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%>
    		<%}else{%>
    			<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>
    		<%}%>
    	<%}else if(tempMessageType.equals("1")){%>
    		<%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%>
    		<!-- 微信提醒START(QC:98106) -->
    	<%}else if(!hasChats&&tempChatsType.equals("1")){ %>
    		<%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%> 
    		<!-- 微信提醒END(QC:98106) -->
    	<%}%>
    </TD>
    <td class=fieldvalueClass>
<!--
        <%if(!"1".equals(isEdit_)){
            if(!"0".equals(currentnodetype)){%>
       <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
       <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
       <%}
       else{%>
        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan')" size=60  maxlength=100  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%}
		}else{%>
        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan')" size=60  maxlength=100  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%}%>
-->
<%if(!hasRequestname){%>
<%if("1".equals(isEdit_)&&(!isaffirmance.equals("1")||reEdit.equals("1"))){%>
        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword('requestname',document.getElementById('requestname').value,1)" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%}else{%>
       <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
       <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
<%}
}
if(!hasRequestlevel){%>

      &nbsp;&nbsp;&nbsp;&nbsp;
     
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
      <input type=hidden name=requestlevel value="<%=requestlevel%>">
<%}%>
<%if(!hasMessage&&tempMessageType.equals("1")){%>
      <!--add by xhheng @ 2005/01/25 for 消息提醒 Request06，流转过程中察看短信设置 -->
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%
      String sqlWfMessage = "select a.messagetype from workflow_requestbase a,workflow_base b where a.workflowid=b.id and b.messagetype='1' and a.requestid="+requestid ;
	  RecordSet.executeSql(sqlWfMessage);
      if (RecordSet.next()) {
        int rqMessageType=RecordSet.getInt("messagetype");
      /* 合并为一个sql执行，mackjoe at 2006-06-13 td4491
      String sqlWfMessage = select a.messagetype from workflow_requestbase a,workflow_base b where a.workflowid=b.id and b.messagetype='1' and requestid=116193 ;
      int wfMessageType=0;
      RecordSet.executeSql(sqlWfMessage);
      if (RecordSet.next()) {
        wfMessageType=RecordSet.getInt("messageType");
      }
      if(wfMessageType == 1){
        String sqlRqMessage = "select messageType from workflow_requestbase where requestid="+requestid;
        int rqMessageType=0;
        RecordSet.executeSql(sqlRqMessage);
        if (RecordSet.next()) {
          rqMessageType=RecordSet.getInt("messageType");
        }*/
        %>
        
        <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
        <%} else if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
        <%} else if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%> <%}%>
        <input type=hidden name=messageType value="<%=rqMessageType%>">
      <%}}%>
      <!-- 微信提醒(QC:98106) -->
      <% if(!hasChats&&tempChatsType.equals("1")){ %>     
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%
      String sqlWfChats = "select a.chatstype from workflow_requestbase a,workflow_base b where a.workflowid=b.id and b.chatstype='1' and a.requestid="+requestid ;
	  RecordSet.executeSql(sqlWfChats);
      if (RecordSet.next()) {
        int rqChatsType=RecordSet.getInt("chatstype"); 
        %> 
        <%if(rqChatsType==0){%><%=SystemEnv.getHtmlLabelName(32638,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
        <%} else if(rqChatsType==1){%><%=SystemEnv.getHtmlLabelName(32638,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>
        <%} %>
        <input type=hidden name=chatsType value="<%=rqChatsType%>">
      <%}
      }%>
      </TD>
  </TR>
  <TR style="height:1px;">
    <TD class="Line1" colSpan=2></TD>
  </TR>
<%}
}%>
  </table>  
    <input type=hidden name ="needcheck" value="<%=needcheck%>">
      
    <%if(fromFlowDoc.equals("1") || (isbill.equals("1") && formid==7)){%>
    <div id="t_headother"></div>
    <%}%>
    <%if(isbill.equals("1") && formid==7){%>
    <jsp:include page="/workflow/request/BillBudgetExpenseDetailMode.jsp" flush="true">
	<jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    </jsp:include>
    <%}%>
    <jsp:include page="Manageopenmode.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="modeid" value="<%=modeid%>" />
    <jsp:param name="isform" value="<%=isform%>" />
    <jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="formid" value="<%=formid%>" />    
    <jsp:param name="nodeid" value="<%=nodeid%>" />    
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="isaffirmance" value="<%=isaffirmance%>" />
    <jsp:param name="reEdit" value="<%=reEdit%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />    
    <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="currentdate" value="<%=currentdate%>" />
    <jsp:param name="currenttime" value="<%=currenttime%>" />
    </jsp:include>
    <jsp:include page="ManageHiddenField.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
	<jsp:param name="workflowid" value="<%=workflowid%>" />
	<jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="docCategory" value="<%=docCategory%>" />
	<jsp:param name="isaffirmance" value="<%=isaffirmance%>" />
    <jsp:param name="reEdit" value="<%=reEdit%>" />
	<jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="docfileid" value="<%=docfileid%>" />
    <jsp:param name="newdocid" value="<%=newdocid%>" />
    <jsp:param name="currentdate" value="<%=currentdate%>" />
    <jsp:param name="currenttime" value="<%=currenttime%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	</jsp:include>
    <%if(isbill.equals("1") && formid==158){%>
        <jsp:include page="/workflow/request/FnaWipeExpenseDetail.jsp" >
        <jsp:param name="billid" value="<%=billid%>" />
        <jsp:param name="requestid" value="<%=requestid%>" />
        <jsp:param name="creater" value="<%=creater%>" />
         </jsp:include>
    <%}%>
    <jsp:include page="WorkflowManageSignMode.jsp" flush="true">
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
    <jsp:param name="ismode" value="1" />
    <jsp:param name="isworkflowdoc" value="<%=isworkflowdoc%>" />
    </jsp:include>

    <input type=hidden name="workflowtype" value="<%=workflowtype%>">
    <input type=hidden name="nodeid" value="<%=nodeid%>">
    <input type=hidden name="nodetype" value="<%=nodetype%>">
    <input type=hidden name="src">
    <input type=hidden name="iscreate" value="0"> 
    <input type=hidden name ="billid" value="<%=billid%>">
    <input type=hidden name ="topage" value="<%=topage%>">
    <input type=hidden name ="method">
    <input type=hidden name ="inputcheck" value="">
    <input type="hidden" name="isovertime" value="<%=isovertime%>">
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
	            //System.out.println("init_road:"+init_road);
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
	                            
	                            int nextnodetype=Util.getIntValue(RecordSet.getString("nodetype"),0);
	                            if(nextnodetype==3){
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
	                            <input type='hidden' name='nodetype_<%=freeNum%>' value='<%=nextnodetype%>'/>
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
		int submit=Util.getIntValue(Util.null2String(request.getParameter("submit")), 0);
		int forward=Util.getIntValue(Util.null2String(request.getParameter("forward")), 0);
	%>
		<div id="picSignFrame">
			<jsp:include page="WorkflowViewSignMode.jsp" flush="true">
			<jsp:param name="isprint" value="false" />
			<jsp:param name="languageid" value="<%=user.getLanguage()%>" />
			<jsp:param name="userid" value="<%=userid%>" />
			<jsp:param name="requestid" value="<%=requestid%>" />
			<jsp:param name="workflowid" value="<%=workflowid%>" />
			<jsp:param name="nodeid" value="<%=nodeid%>" />
			<jsp:param name="isremark" value="<%=isremark%>" />
			<jsp:param name="isOldWf" value="<%=isOldWf%>" />
			<jsp:param name="desrequestid" value="<%=desrequestid%>" />
			<jsp:param name="submit" value="<%=submit%>" />
			<jsp:param name="forward" value="<%=forward%>" />
			<jsp:param name="isbill" value="<%=isbill%>" />
			<jsp:param name="formid" value="<%=formid%>" />
			</jsp:include>			
		</div>

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
		<%
		int printmodeid=0;
		int modeprintdes=0;
		RecordSet.executeSql("select printdes from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
		if(RecordSet.next()){
			modeprintdes=Util.getIntValue(Util.null2String(RecordSet.getString("printdes")),0);
		}
		if(  modeprintdes!=1){
		    RecordSet.executeSql("select id from workflow_nodemode where isprint='1' and workflowid="+workflowid+" and nodeid="+nodeid);
		    if(RecordSet.next()){
		    	printmodeid=RecordSet.getInt("id");
		    }else{
		        RecordSet.executeSql("select id from workflow_formmode where formid="+formid+" and isbill='"+isbill+"' order by isprint desc");
		        while(RecordSet.next()){
		            if(printmodeid<1){
		            	printmodeid=RecordSet.getInt("id");
		            }
		        }
		    }
		}
		%>
		<!-- 点击打印按钮 存在打印模板时使用以此隐藏打印时的主窗口 -->
		<iframe style="display: none;visibility: hidden;" id="loadprintmodeFrame" src="">
		</iframe>
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


function changeTab(){   
   /*
   for(i=0;i<=1;i++){
  		parent.document.getElementById("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.document.getElementById("oTDtype_"+i).className="cycleTD";
  	}
  	parent.document.getElementById("oTDtype_0").background="/images/tab.active2_wev8.png";
  	parent.document.getElementById("oTDtype_0").className="cycleTDCurrent";
	*/
}

function showWFHelp(docid){
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    var operationPage = "/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&id="+docid;
    window.open(operationPage,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}
// modify by xhheng @20050304 for TD 1691
function openSignPrint() {
    var redirectUrl = "PrintMode.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&isbill=<%=isbill%>&workflowid=<%=workflowid%>&formid=<%=formid%>&nodeid=<%=nodeid%>&billid=<%=billid%>" ;
  var printmodeid="<%=printmodeid%>";
  if(parseInt(printmodeid)>0){
  	printModePreview("loadprintmodeFrame",redirectUrl);
  	return ;
  }
  var width = screen.availWidth-10 ;
  var height = screen.availHeight-50 ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
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

function doShare(){
var requestid= "<%=requestid%>";
var requestname= "<%=requestname%>";
var returnjson = '[{"sharetype":"workflow","sharetitle":"'+requestname+'","objectname":"FW:CustomShareMsg","shareid":"'+requestid+'"}]';
socialshareToEmessage(returnjson);
}

var isfirst = 0 ;

function displaydiv()
{
    if(oDivAll.style.display == ""){
		oDivAll.style.display = "none";
		oDivInner.style.display = "none";
        oDiv.style.display = "none";
        oDivSign.style.display = "none";
        spanimage.innerHTML = "<img src='/images/ArrowDownRed_wev8.gif' border=0>" ;
    }
    else{
        if(isfirst == 0) {
			document.getElementById("picInnerFrame").src="/workflow/request/WorkflowRequestPictureInner.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>";
			document.getElementById("picframe").src="/workflow/request/WorkflowRequestPicture.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&desrequestid=<%=desrequestid%>";
            document.getElementById("picSignFrame").src="/workflow/request/WorkflowViewSignMode.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&isprint=false&languageid=<%=user.getLanguage()%>&userid=<%=userid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isOldWf=<%=isOldWf%>&desrequestid=<%=desrequestid%>";
            isfirst ++ ;
        }

        spanimage.innerHTML = "<img src='/images/ArrowUpGreen_wev8.gif' border=0>" ;
		oDivAll.style.display = "";
		oDivInner.style.display = "";
        oDiv.style.display = "";
        workflowStatusLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19678,user.getLanguage())%></font>";
        workflowChartLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font>";
        oDivSign.style.display = "";
        workflowSignLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(21200,user.getLanguage())%></font>";

    }
}


function displaydivOuter()
{
    if(oDiv.style.display == ""){
        oDiv.style.display = "none";
        workflowStatusLabelSpan.innerHTML="<font color=red><%=SystemEnv.getHtmlLabelName(19677,user.getLanguage())%></font>";
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none" &&oDivSign.style.display == "none"){
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
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none" &&oDivSign.style.display == "none"){
		    oDivAll.style.display = "none";
            spanimage.innerHTML = "<img src='/images/ArrowDownRed_wev8.gif' border=0>" ;
		}
    }
    else{
        oDivInner.style.display = "";
        workflowChartLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font>";
    }
}
        
function displaydivSign()
{
    if(oDivSign.style.display == ""){
        oDivSign.style.display = "none";
        workflowSignLabelSpan.innerHTML="<font color=red><%=SystemEnv.getHtmlLabelName(21199,user.getLanguage())%></font>";
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none"&&oDivSign.style.display == "none"){
		    oDivAll.style.display = "none";
            spanimage.innerHTML = "<img src='/images/ArrowDownRed_wev8.gif' border=0>" ;
		}
    }
    else{
        oDivSign.style.display = "";
        workflowSignLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(21200,user.getLanguage())%></font>";
    }
}
function returnTrue(o){
	return;
}
function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}
function downloads(files)
{ 
jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
document.getElementById("fileDownload").src="/weaver/weaver.file.FileDownload?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&fileid="+files+"&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>";
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
/** end by cyril on 2008-07-10 for TD:8835*/
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
	var width = screen.availWidth/2;
	var height = screen.availHeight/2;
	var top = height/2;
	var left = width/2;
	var szFeatures = "top="+top+"," ;
	szFeatures +="left="+left+"," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}
//微信提醒(QC:98106)
function onNewChats(wfid, nodeid, reqid, menuid){ 
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
function doEdit(obj){
	parent.location.href="ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&isovertime=<%=isovertime%>&reEdit=1&fromFlowDoc=<%=fromFlowDoc%>";
}

function doSubmitBack(obj){
	<% if("1".equals(isSubmitDirectNode)) { %>
		if($G("SubmitToNodeid")) {
	       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
		}
	<% } %>
	document.getElementById("needwfback").value = "1";
	getRemarkText_log();
	doSubmit(obj);
}
function doSubmitNoBack(obj){
	<% if("1".equals(isSubmitDirectNode)) { %>
		if($G("SubmitToNodeid")) {
	       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
		}
	<% } %>
	document.getElementById("needwfback").value = "0";
	getRemarkText_log();
	doSubmit(obj);
}
function doRemark_nBack(obj){
	document.getElementById("needwfback").value = "1";
	getRemarkText_log();
	doRemark_n(obj);
}
function doRemark_nNoBack(obj){
	document.getElementById("needwfback").value = "0";
	getRemarkText_log();
	doRemark_n(obj);
}
function doAffirmanceBack(obj){
	<% if("1".equals(isSubmitDirectNode)) { %>
		if($G("SubmitToNodeid")) {
	       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
		}
	<% } %>
	document.getElementById("needwfback").value = "1";
	getRemarkText_log();
	doAffirmance(obj);
}
function doAffirmanceNoBack(obj){
	<% if("1".equals(isSubmitDirectNode)) { %>
		if($G("SubmitToNodeid")) {
	       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
		}
	<% } %>
	document.getElementById("needwfback").value = "0";
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
function doSave_nNew(){
	getRemarkText_log();
	doSave();
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
			document.getElementById("remarkText10404").value = reamrkNoStyle;
		}else{
			var remarkText = FCKEditorExt.getTextNew("remark");
			document.getElementById("remarkText10404").value = remarkText;
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
	document.getElementById("triSubwfIframe").src="/workflow/request/TriSubwfIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&operation=triSubwf&requestId=<%=requestid%>&nodeId=<%=nodeid%>&paramSubwfSetId="+paramSubwfSetId+"&tempflag="+Math.random();
}

function triSubwf2(paramSubwfSetId,subworkflowname){
	subworkflowname = subworkflowname.replace(new RegExp(',',"gm"),'\n');
	var info = "<%=SystemEnv.getHtmlLabelName(25394,user.getLanguage())%>:"+"\n"+subworkflowname+"<%=SystemEnv.getHtmlLabelName(25395,user.getLanguage())%>";
	top.Dialog.confirm(info,function(){
		document.getElementById("triSubwfIframe").src="/workflow/request/TriSubwfIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&operation=triSubwf&requestId=<%=requestid%>&nodeId=<%=nodeid%>&paramSubwfSetId="+paramSubwfSetId+"&tempflag="+Math.random();
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
	　　//dlg.URL = "/workflow/request/FreeNodeShow.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&workflowid=<%=workflowid%>";
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
	//var url="/workflow/workflow/BrowserMain.jsp?url=/workflow/request/FreeWorkflowSet.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>";
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
}


function onNewOverTime(){
	var redirectUrl =  "/workflow/request/OverTimeSetByNodeUser.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&requestid=<%=requestid%>&formid=<%=formid%>&isbill=<%=isbill%>&billid=<%=billid%>";
	var dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    dialog.URL = redirectUrl;
	dialog.Title ="<%=SystemEnv.getHtmlLabelName(18818,user.getLanguage())%>";
    dialog.Height = screen.availHeight/2;
    dialog.Width = screen.availWidth/2;
    dialog.Drag = true;
    dialog.show();
}

function doImportDetail(){
    if(!checkDataChange()){
        if(confirm("<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>")){
            //window.showModalDialog("/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp?requestid=<%=requestid%>",window);
            var dialog = new window.top.Dialog();
        	dialog.currentWindow = window;
        	var url = "/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp"+uescape("?ismode=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>");
        	var title = "<%=SystemEnv.getHtmlLabelName(26255,user.getLanguage())%>";
        	dialog.Width = 550;
        	dialog.Height = 550;
        	dialog.Title=title;
        	dialog.Drag = true;
        	dialog.maxiumnable = true;
        	dialog.URL = url;
        	dialog.show();
        }
    }else{
        //window.showModalDialog("/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp?requestid=<%=requestid%>",window);
        var dialog = new window.top.Dialog();
    	dialog.currentWindow = window;
    	var url = "/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp"+uescape("?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&ismode=1&requestid=<%=requestid%>&workflowid=<%=workflowid%>");
    	var title = "<%=SystemEnv.getHtmlLabelName(26255,user.getLanguage())%>";
    	dialog.Width = 700;
    	dialog.Height = 650;
    	dialog.Title=title;
    	dialog.Drag = true;
    	dialog.maxiumnable = true;
    	dialog.URL = url;
    	dialog.show();
    }
}


function onSetRejectNode2(){

 <%
 
     if(!freedis.equals("")&&!isornotFree.equals("")){
		    String zjclNodeid=stnode.getIsFreeStart01Node(""+nodeid);
		    
		    
		    //逐级退回



		     if(freedis.equals("1")){
		    %>
		    <%
		         if(isrejectremind.equals("1")&&ischangrejectnode.equals("1")){%>
			        var url=escape("/workflow/request/RejectNodeSetFree.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&isrejecttype=1&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=currentnodeid%>&isrejectremind=<%=isrejectremind%>&ischangrejectnode=<%=ischangrejectnode%>&isselectrejectnode=<%=isselectrejectnode%>&isFreeNode=<%=nodeidss%>");
				    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
				    if (result != null) {
					    var val=result.split("|");
				        if($G("RejectNodes")) $G("RejectNodes").value=val[0];
				        if($G("RejectToNodeid")) $G("RejectToNodeid").value="<%=zjclNodeid%>"; 
				        if($G("RejectToType")) $G("RejectToType").value="0";
				         return true;
				    }else{ 
					     return false;
					 } 
		        	 
		    	<% }else{%>
		    	   if($G("RejectNodes")) $G("RejectNodes").value="<%=zjclNodeid%>";
		           if($G("RejectToNodeid")) $G("RejectToNodeid").value="<%=zjclNodeid%>"; 
		           if($G("RejectToType")) $G("RejectToType").value="0";
		           return true;
		    	<%}
		    
		     }else{//自由退回



		    %>
                  var url=escape("/workflow/request/RejectNodeSetFree.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=currentnodeid%>&isrejectremind=<%=isrejectremind%>&ischangrejectnode=<%=ischangrejectnode%>&isselectrejectnode=<%=isselectrejectnode%>&isFreeNode=<%=nodeidss%>");
			    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
			    if (result != null) {
			        $G("RejectNodes").value=result;
				    var val=result.split("|");
				    
			        if($G("RejectNodes")) $G("RejectNodes").value=val[0];
			        if($G("RejectToNodeid")) $G("RejectToNodeid").value=val[1]; 
			        if($G("RejectToType")) $G("RejectToType").value=val[2];
			        return true;
			    }else{ 
				       return false;
				 }
			<%}
    }else{
	    if((isrejectremind.equals("1")&&ischangrejectnode.equals("1"))||isselectrejectnode.equals("1") || "2".equals(isselectrejectnode)){
	 %>
	   
	    var url=escape("/workflow/request/RejectNodeSet.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=currentnodeid%>&isrejectremind=<%=isrejectremind%>&ischangrejectnode=<%=ischangrejectnode%>&isselectrejectnode=<%=isselectrejectnode%>");
	    var result =showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	    if (result != null) {
	         $G("RejectNodes").value=result;
		     var val=result.split("|");
	        if($G("RejectNodes")) $G("RejectNodes").value=val[0];
	        if($G("RejectToNodeid")) $G("RejectToNodeid").value=val[1]; 
	        if($G("RejectToType")) $G("RejectToType").value=val[2];
	        return true;
	    }else{
	        return false;
	    }
	    <%}else{%>
	       return true;
    <%}}%>
}


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
			  dialog.URL ="/systeminfo/BrowserMain.jsp?url="+url;
		   <%}else{%>
		      if($G("RejectNodes")) $G("RejectNodes").value="<%=zjclNodeid%>";
		      if($G("RejectToNodeid")) $G("RejectToNodeid").value="<%=zjclNodeid%>"; 
		      return true;
		   <%}
		   }else{//自由退回



		    %>
		      var url=escape("/workflow/request/RejectNodeSetFree.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=currentnodeid%>&isrejectremind=<%=isrejectremind%>&ischangrejectnode=<%=ischangrejectnode%>&isselectrejectnode=<%=isselectrejectnode%>&isFreeNode=<%=nodeidss%>");
			  dialog.URL ="/systeminfo/BrowserMain.jsp?url="+url;
			<%}
    }else{
	    if((isrejectremind.equals("1")&&ischangrejectnode.equals("1"))||isselectrejectnode.equals("1") || "2".equals(isselectrejectnode)){%>
		    var url=escape("/workflow/request/RejectNodeSet.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=currentnodeid%>&isrejectremind=<%=isrejectremind%>&ischangrejectnode=<%=ischangrejectnode%>&isselectrejectnode=<%=isselectrejectnode%>");
		    dialog.URL ="/systeminfo/BrowserMain.jsp?url="+url;
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
                if($G("RejectNodes")) 
                   $G("RejectNodes").value=val[0];
			    if($G("RejectToNodeid")) 
			       $G("RejectToNodeid").value=val[1];
			    if($G("RejectToType")) $G("RejectToType").value=val[2];   
			    showtipsinfo(<%=requestid%>,<%=workflowid%>,<%=nodeid%>,<%=isbill%>,1,<%=billid%>,"","reject","<%=ismode%>","divFavContent18980","<%=SystemEnv.getHtmlLabelName(18980,user.getLanguage())%>");
            }
        }
    } ;
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())%>";
    dialog.Height = 400 ;
    dialog.Drag = true;
    dialog.show();
}

<%
//自定义资产流程验证



if( isCptwf){
	JSONObject jsonObject=null;
	if(ismodeCptwf){
		jsonObject=CptWfUtil.getCptwfInfo4mode(""+workflowid);
	}else{
		jsonObject=CptWfUtil.getCptwfInfo(""+workflowid);
	}

	String zicFieldId= jsonObject.getString("zc");
	int zcViewtype=Util.getIntValue( ""+jsonObject.getInt("zctype"),0);
	String shulFieldId= null;
	int slViewtype=0;
	if(ismodeCptwf){
		if("mode_move".equalsIgnoreCase(cptwftype)
		||"mode_back".equalsIgnoreCase(cptwftype)
		||"mode_lend".equalsIgnoreCase(cptwftype)
		||"mode_mend".equalsIgnoreCase(cptwftype)
		){
			shulFieldId="-10000";
		}else{
			shulFieldId= jsonObject.getString("sl");
		}
		slViewtype=Util.getIntValue( ""+jsonObject.getInt("sltype"),0);
	}else{
		shulFieldId= jsonObject.getString("sl");
		slViewtype=Util.getIntValue( ""+jsonObject.getInt("sltype"),0);
	}


	%>
function cptcusifover(_callback){
	var cptwftype="<%=cptwftype %>";
	var returnval = false;
	var zcviewtype='<%=zcViewtype %>';
	var slviewtype='<%=slViewtype %>';
	var slviewtype='<%=slViewtype %>';
	var slviewtype='<%=slViewtype %>';
	if(cptwftype!="mode_move"&&cptwftype!="mode_lend"&&cptwftype!="mode_mend"&&cptwftype!="mode_back"){
		if(zcviewtype!=slviewtype){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84466,user.getLanguage())%>");
			return true;
		}
	}

	var temprequestid = "0";
	if(jQuery("input[name=requestid]").length){
		temprequestid = jQuery("input[name=requestid]").val();
	}
	var poststr = "";
	if(zcviewtype==0){//主字段


		var zcid = jQuery("input[name='field"+<%=zicFieldId %>+"']").val();//领用的资产id
		var cptnum = jQuery("input[name='field"+<%=shulFieldId %>+"']").val();//领用的数量

		if(zcid!=undefined&&zcid!=""){
			if(cptwftype=="mode_move"||cptwftype=="mode_lend"||cptwftype=="mode_mend"||cptwftype=="mode_back"){
				cptnum=1;
			}
			poststr += "|"+zcid+","+ cptnum;
		}

	}else{
		var indexnum0 = 0;
		var indexElement="indexnum0";
		if(zcviewtype==2){indexElement="indexnum1";}
		else if(zcviewtype==3){indexElement="indexnum2";}
		else if(zcviewtype==4){indexElement="indexnum3";}
		if(document.getElementById(indexElement)){
			indexnum0 = document.getElementById(indexElement).value * 1.0 - 1;
		}

		for(var i=0;i<=indexnum0;i++){
			try{
				var zcid = jQuery("input[name='field"+<%=zicFieldId %>+"_"+i+"']").val();//领用的资产id
				if(zcid==undefined||zcid==""){continue;}
				var cptnum = jQuery("input[name='field"+<%=shulFieldId %>+"_"+i+"']").val();//领用的数量

				if(cptwftype=="mode_move"||cptwftype=="mode_lend"||cptwftype=="mode_mend"||cptwftype=="mode_back"){
					cptnum=1;
				}

				if(cptnum==undefined||cptnum==""){continue;}
				poststr += "|"+zcid+","+ cptnum;

			}catch(e){alert(e)}
		}
		if(poststr!=""){
			poststr =poststr.substr(1);
		}else{
			
		}

	}
	if(poststr!=""){
		jQuery.ajax({
			url : "/cpt/capital/CptIfOverAjax.jsp",
			type : "post",
			async : true,
			processData : false,
			data : "poststr="+poststr+"&requestid="+temprequestid+"&cptwftype=<%=cptwftype %>&ismodecpt=<%=ismodeCptwf %>",
			dataType : "json",
			success: function do4Success(data){
				if(data&&data.msg&&data.msg!=""){
					window.top.Dialog.alert(data.msg);
					returnval=true;
				}else{
					try{
						if(_callback){
							_callback();
						}
					}catch(e){}
					returnval=false;
				}
			}
		});
	}else{
		try{
			if(_callback){
				_callback();
			}
		}catch(e){}
	}
}
<%
}else{
%>
function cptcusifover(_callback){
	try{
		if(_callback){
			_callback();
		}
	}catch(e){}
}

<%
}

%>
jQuery(document).ready(function(){
	var needChooseOperator = jQuery("input[name='needChooseOperator']",window.parent.document).val();
	if(needChooseOperator != 'y')
		return;
	window.setTimeout(function(){
		var url = "/workflow/request/requestChooseOperator.jsp";
		var frmmain = jQuery("form[name='frmmain']");
		var retVal = window.showModalDialog(url,null,"dialogWidth:800px;dialogHeight:650px");
		if(!!retVal){
			var datas = JSON.parse(retVal.trim());
			frmmain.append('<input type="hidden" name="eh_setoperator" value="y" />');
			frmmain.append('<input type="hidden" name="eh_relationship" value="'+datas.relationship+'" />');
			frmmain.append('<input type="hidden" name="eh_operators" value="'+datas.operators+'" />');
			doSubmitBack();		//模拟提交
		}else{
			frmmain.append('<input type="hidden" name="eh_setoperator" value="n" />');
			doSubmitBack();		//模拟提交
		}
	},300);
});

</SCRIPT>
<!-- added by cyril on 20080610 for td8828-->
<script language=javascript src="/js/checkData_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>

<script language="JavaScript">
if("<%=seeflowdoc%>"=="1"){
	if(document.getElementById("rightMenu")!=null){
		document.getElementById("rightMenu").style.display="none";
	}
}
</script>

<jsp:include page="/workflow/request/UserDefinedRequestBrowser.jsp" flush="true">
	<jsp:param name="workflowid" value="<%=workflowid%>" />
</jsp:include>