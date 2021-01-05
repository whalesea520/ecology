<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.common.StringUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ page import="weaver.workflow.request.SubWorkflowTriggerService" %>
<%@page import="weaver.workflow.request.RequestShare"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.rdeploy.portal.PortalUtil" %>
<%@ page import="java.net.URLEncoder" %>
<!-- word转html插件 -->
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet5" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td3665 on 20060227--%>
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
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page" /><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" /><!--xwj for td3665 20060224-->
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="sysPubRefComInfo" class="weaver.general.SysPubRefComInfo" scope="page" />
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page" />
<jsp:useBean id="WFLinkInfo_nf" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="CptWfUtil" class="weaver.cpt.util.CptWfUtil" scope="page" />
<!-- 微信提醒(QC:98106) -->
<jsp:useBean id="WechatPropConfig" class="weaver.wechat.util.WechatPropConfig" scope="page"/>
<jsp:useBean id="SystemEnv" class="weaver.systeminfo.SystemEnv" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
int init_road = Util.getIntValue(request.getParameter("init_road"),-1);//当前节点的路径编辑权限
String init_nodename=SystemEnv.getHtmlLabelName(15070, user.getLanguage());
int init_frms = Util.getIntValue(request.getParameter("init_frms"),-1);
int currtype=-1;//当前节点的类型
String init_nodeDo="";
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
%>
<%
String isworkflowdoc = Util.getIntValue(request.getParameter("isworkflowdoc"),0)+"";//是否为公文
int seeflowdoc = Util.getIntValue(request.getParameter("seeflowdoc"),0);
int userlanguage=Util.getIntValue(request.getParameter("languageid"),7);
String clientip = request.getRemoteAddr();
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;
                     
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
session.removeAttribute("errormsgid_"+user.getUID()+"_"+requestid);
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
String needcheck="requestname,";

String topage = Util.null2String(request.getParameter("topage")) ;        //返回的页面
topage = URLEncoder.encode(topage);
String isaffirmance=Util.null2String(request.getParameter("isaffirmance"));//是否需要提交确认
String reEdit=Util.null2String(request.getParameter("reEdit"));//是否为编辑
// 工作流新建文档的处理
String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
String isrejectremind="";
String ischangrejectnode="";
String isselectrejectnode="";
// 董平 2004-12-2 FOR TD1421  新建流程时如果点击表单上的文档新建按钮，在新建完文档之后，能返回流程，但是文档却没有挂带进来。
String newdocid = Util.null2String(request.getParameter("newdocid"));        // 新建的文档

// 操作的用户信息
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
//System.out.println("-wfadd--89-222222222222222222222222222222222-userid------"+userid);
int usertype = 0;                           //用户在工作流表中的类型 0: 内部 1: 外部
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";
boolean wfmonitor="true".equals(session.getAttribute(userid+"_"+requestid+"wfmonitor"))?true:false;                //流程监控人
boolean haveBackright=false;            //强制收回权限
boolean haveOverright=false;            //强制归档权限
boolean haveStopright = false;			//暂停权限
boolean haveCancelright = false;		//撤销权限
boolean haveRestartright = false;		//启用权限
String currentnodetype = "";
int currentnodeid = 0;
int desrequestid=0;
int lastOperator=0;
String lastOperateDate="";
String lastOperateTime="";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;

String sql = "" ;
char flag = Util.getSeparator() ;
String fromPDA= Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录

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
helpdocid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"helpdocid"),0);
currentnodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"currentnodeid"),0);
currentnodetype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"currentnodetype"));

lastOperator=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"lastOperator"),0);
lastOperateDate=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateDate"));
lastOperateTime=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateTime"));
String coadsigntype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"coadsigntype"));

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

//开启云部署后，自由节点流程是否已在高级设置中修改过
PortalUtil putil = new PortalUtil();
boolean cloudstatus = putil.isuserdeploy();
boolean cloudchange = false;
String iscnodefree = "0";
RecordSet.execute("select 1 from Workflow_Initialization where wfid = 35");
if(RecordSet.next()){
	cloudchange = true;
}
if(cloudstatus && cloudchange && workflowid == 35){
	iscnodefree = "1";
}
//是否具有分享权限
boolean iscanshare = false;
// 当前用户表中该请求对应的信息 isremark为0为当前操作者, isremark为1为当前被转发者,isremark为2为可跟踪查看者
//RecordSet.executeProc("workflow_currentoperator_SByUs",userid+""+flag+usertype+flag+requestid+"");
RecordSet.executeSql("select * from workflow_currentoperator where (isremark<8 or isremark>8) and requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by isremark,islasttimes desc");
while(RecordSet.next())	{
	iscanshare = true;
    int tempisremark = Util.getIntValue(RecordSet.getString("isremark"),0) ;
	handleforwardid = Util.getIntValue(RecordSet.getString("handleforwardid"),-1) ;     //转办状态
	 takisremark = Util.getIntValue(RecordSet.getString("takisremark"),0) ;     //意见征询状态

    //if(tempisremark==8){//抄送（不提交）查看页面即更新为已办事宜。
    //	RecordSet2.executeSql("update workflow_currentoperator set isremark=2,operatedate='"+currentdate+"',operatetime='"+currenttime+"' where requestid="+requestid+" and userid="+userid+" and usertype="+usertype);
    //	response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&isremark=8");
    //}
    if( tempisremark == 0 || tempisremark == 1 || tempisremark == 5 || tempisremark == 9|| tempisremark == 7) {                       // 当前操作者或被转发者
        isremark = tempisremark ;
        break ;
    }
}
if(isremark==-1){
	RecordSet.executeSql("select isremark from workflow_currentoperator where isremark=8 and requestid="+requestid+" and userid="+userid+" and usertype="+usertype);
	while(RecordSet.next())	{
	iscanshare = true;
    int tempisremark = Util.getIntValue(RecordSet.getString("isremark"),0) ;
    if(tempisremark==8){//抄送（不提交）查看页面即更新为已办事宜。
    	//RecordSet2.executeSql("update workflow_currentoperator set isremark=2,operatedate='"+currentdate+"',operatetime='"+currenttime+"' where requestid="+requestid+" and userid="+userid+" and usertype="+usertype);
    	//时间与数据库保持一致，所以采用存储过程来更新数据库。
    	RecordSet2.executeProc("workflow_CurrentOperator_Copy",requestid+""+flag+userid+flag+usertype+"");
    	if(currentnodetype.equals("3")){
    		RecordSet2.executeSql("update workflow_currentoperator set iscomplete=1 where requestid="+requestid+" and userid="+userid+" and usertype="+usertype);
    	} 
    	response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&isremark=8&fromFlowDoc="+fromFlowDoc+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype);
    	return;
    }
	}
}
if( isremark != 0 && isremark != 1&& isremark != 5 && isremark != 9&& isremark != 7) {
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
String IsPendingForward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsPendingForward"));
String IsTakingOpinions=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsTakingOpinions"));
String IsHandleForward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsHandleForward"));
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
boolean IsCanSubmit="true".equals(session.getAttribute(userid+"_"+requestid+"IsCanSubmit"))?true:false;
boolean IsFreeWorkflow="true".equals(session.getAttribute(userid+"_"+requestid+"IsFreeWorkflow"))?true:false;
boolean isImportDetail="true".equals(session.getAttribute(userid+"_"+requestid+"isImportDetail"))?true:false;
session.setAttribute(userid+"_"+requestid+"isremark",""+isremark);
boolean IsCanModify="true".equals(session.getAttribute(userid+"_"+requestid+"IsCanModify"))?true:false;
//String coadisforward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"coadisforward"));
boolean coadCanSubmit="true".equals(session.getAttribute(userid+"_"+requestid+"coadCanSubmit"))?true:false;
boolean isMainSubmitted="true".equals(session.getAttribute(userid+"_"+requestid+"isMainSubmitted"))?true:false;
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
//add by mackjoe at 2005-12-20 增加模板应用
String ismode="";
int modeid=0;
int isform=0;
int showdes=0;
String isFormSignatureOfThisJsp=null;
String FreeWorkflowname="";
RecordSet.executeSql("select ismode,showdes,isFormSignature,freewfsetcurnameen,freewfsetcurnametw,freewfsetcurnamecn from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
    showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
	isFormSignatureOfThisJsp = Util.null2String(RecordSet.getString("isFormSignature"));
    if(user.getLanguage() == 8){
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnameen"));
    }
    else if(user.getLanguage() == 9){
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnametw"));
    }
    else {
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnamecn"));
    }
}
int isUseWebRevisionOfThisJsp = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
if(isUseWebRevisionOfThisJsp != 1){
	isFormSignatureOfThisJsp = "";
}
if("".equals(FreeWorkflowname.trim())){
	FreeWorkflowname = SystemEnv.getHtmlLabelName(21781,user.getLanguage());
}
session.setAttribute(userid+"_"+requestid+"FreeWorkflowname",FreeWorkflowname);

if(ismode.equals("1") && showdes!=1){
    RecordSet.executeSql("select id from workflow_nodemode where isprint='0' and workflowid="+workflowid+" and nodeid="+nodeid);
    if(RecordSet.next()){
        modeid=RecordSet.getInt("id");
    }else{
            RecordSet.executeSql("select id from workflow_formmode where isprint='0' and formid="+formid+" and isbill='"+isbill+"'");
        if(RecordSet.next()){
            modeid=RecordSet.getInt("id");
            isform=1;
        }
    }
}else if("2".equals(ismode)){
	weaver.workflow.exceldesign.HtmlLayoutOperate htmlLayoutOperate = new weaver.workflow.exceldesign.HtmlLayoutOperate();
	modeid = htmlLayoutOperate.getActiveHtmlLayout(workflowid, nodeid, 0);
}

//---------------------------------------------------------------------------------
//跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 START
//---------------------------------------------------------------------------------
//模板模式-如果用户使用的是非IE则自动使用一般模式来显示流程 START 2011-11-23 CC
//if (!isIE.equalsIgnoreCase("true") && ismode.equals("1")) {
String isIE = (String)session.getAttribute("browser_isie");
if (isIE == null || "".equals(isIE)) {
	isIE = "true";
}
//模板模式-如果用户使用的是非IE则自动使用一般模式来显示流程 END
//---------------------------------------------------------------------------------
//跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 END
//---------------------------------------------------------------------------------


//end by mackjoe
ArrayList specialBillIDList = sysPubRefComInfo.getDetailCodeList("SpecialBillID");
boolean isSpecialBill = specialBillIDList.contains(""+formid);
/*------ xwj for td3131 20051117 ----- begin--------*/
if(isSpecialBill==true && isbill.equals("1")){
    topage = URLEncoder.encode(topage);
    response.sendRedirect("ManageRequestNoFormBill.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&fromFlowDoc="+fromFlowDoc+"&fromPDA="+fromPDA+"&requestid="+requestid+"&message="+message+"&topage="+topage+"&docfileid="+
            docfileid+"&newdocid="+newdocid+"&isovertime="+isovertime+"&isrequest="+isrequest+"&isaffirmance="+isaffirmance+"&reEdit="+reEdit+"&seeflowdoc="+seeflowdoc+"&isworkflowdoc="+isworkflowdoc+"&isfromtab="+isfromtab);
    return;
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
WFManager.setWfid(Util.getIntValue(""+workflowid));
WFManager.getWfInfo();
String isFree = WFManager.getIsFree();
 //判断是不是创建保存
 boolean iscreate=stnode.IScreateNode(""+requestid); 
  if(!isornotFree.equals("")&&!freedis.equals("")&&!iscreate&&(!"1".equals(isFree) || !"2".equals(nodetype))){
   isreject = "1";
 }
String isTriDiffWorkflow=null; 
RecordSet.executeSql("select a.isTriDiffWorkflow, b.* from workflow_base a, workflow_flownode b where a.id = b.workflowid and a.id="+workflowid + " and b.nodeid=" + nodeid);

if(RecordSet.next()){
	isTriDiffWorkflow=Util.null2String(RecordSet.getString("isTriDiffWorkflow"));
    isrejectremind=Util.null2String(RecordSet.getString("isrejectremind"));
    ischangrejectnode=Util.null2String(RecordSet.getString("ischangrejectnode"));
	  isselectrejectnode=Util.null2String(RecordSet.getString("isselectrejectnode"));

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
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage())+ " - " + status + " "+"<span id='requestmarkSpan'>"+requestmark+"</span>";//Modify by 杨国生 2004-10-26 For TD1231
String needfav ="1";
String needhelp ="";
//if(helpdocid !=0 ) {titlename=titlename + "<img src=/images/help_wev8.gif style=\"CURSOR:hand\" width=12 onclick=\"location.href='/docs/docs/DocDsp.jsp?id="+helpdocid+"'\">";}
//判断是否有流程创建文档，并且在该节点是有正文字段
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


<%//TD9145
Prop prop = Prop.getInstance();
String ifchangstatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
String submitname = "" ; // 提交按钮的名称 : 创建, 审批, 实现
String forwardName = "";//转发
String takingopinionsName = ""; //征求意见
String HandleForwardName = ""; //转办
String forhandName = ""; //转办提交
String forhandbackName = ""; //转办需反馈
String forhandnobackName = ""; //转办不需反馈
String givingopinionsName ="";  //回复
String givingOpinionsnobackName = ""; // 回复不反馈
String givingOpinionsbackName = ""; // 回复需反馈

String saveName = "";//保存
String rejectName = "";//退回
String forsubName = "";//转发提交
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
String newCHATSName = "";//新建微信按钮 (QC:98106)
String haschats = "";//是否使用新建微信按钮 (QC:98106)

String hasforhandback = "";  //是否转办反馈
String hasforhandnoback = ""; //是否转办不需反馈
String hastakingOpinionsback = ""; //是否回复反馈
String hastakingOpinionsnoback = "";//是否回复不需反馈
String isSubmitDirect =  Util.null2String(request.getParameter("isSubmitDirect")); // 是否启用提交至退回节点
String submitDirectName = ""; // 提交至退回节点按钮名称
int subbackCtrl = 0;
int forhandbackCtrl = 0;
int forsubbackCtrl = 0;
int ccsubbackCtrl = 0;
int takingOpinionsbackCtrl = 0;

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
}

%>
<%
//add by ben for relationgrequests 2006-05-09
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
		            if(modeid<1){
		            	printmodeid=RecordSet.getInt("id");
		            }
		        }
		    }
		}
		%>

<SCRIPT LANGUAGE="JavaScript">

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
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-2px 0px!important;display:block;float:right;");
}

function hideProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-14px 0px!important;display:none;float:right;");
}

if (window.addEventListener){
    window.addEventListener("load", windowOnload, false);
}else if (window.attachEvent){
    window.attachEvent("onload", windowOnload);
}else{
    window.onload=windowOnload;
}

//qc 66179 by yl
var ffff  =    <%=formid%>;
var ffffIsbill  =    <%=isbill%>;
function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
        return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
                return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                        return false;
                    else
                        return true;
                }
                else
                    return true;
            }
        }
        else
            return true;
    }
}
function checktimeok(){         <!-- 结束日期不能小于开始日期 -->
    if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != "")
    {
        YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
        MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
        DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
        YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
        MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
        DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
        if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
            window.alert("<%=SystemEnv.getHtmlLabelName(15273,userlanguage)%>");
            return false;
        }
    }
    else{
        if( ffff == 181 && ffffIsbill==1){
            <%
            RecordSet rsss = new RecordSet();
            String fromdateid ="";
            String sql11="Select id from workflow_billfield where billid= 181 and fieldname='fromDate' ";
            rsss.executeSql(sql11);
            if(rsss.next()){
               fromdateid=rsss.getString("id");
            }
            String todateid="";
            String sql22="Select id from workflow_billfield where billid= 181 and fieldname='toDate' ";
            rsss.executeSql(sql22);
            if(rsss.next()){
               todateid=rsss.getString("id");
            }            
            String fromtimeid ="";
            String sql33="Select id from workflow_billfield where billid= 181 and fieldname='fromTime' ";
            rsss.executeSql(sql33);
            if(rsss.next()){
               fromtimeid=rsss.getString("id");
            }  
            String totimeid ="";
            String sql44="Select id from workflow_billfield where billid= 181 and fieldname='toTime' ";
            rsss.executeSql(sql44);
            if(rsss.next()){
               totimeid=rsss.getString("id");
            } 
            
                    String dbType =   rsss.getDBType();
                    String fromdate =  "field"+fromdateid;
                    String todate     = "field"+todateid;
                    String fromtime   = "field"+fromtimeid;
                    String totime     = "field"+totimeid;             
                    /*
                    String dbType =   rsss.getDBType();
                    String fromdate =  dbType=="sqlserver"?"field686":"field767";
                    String todate     =          dbType=="sqlserver"?"field688":"field769";
                    String fromtime   =     dbType=="sqlserver"?"field687":"field768";
                    String totime        =dbType=="sqlserver"?"field689":"field770";
                    */

            %>
            YearFrom=document.frmmain.<%=fromdate%>.value.substring(0,4);
            MonthFrom=document.frmmain.<%=fromdate%>.value.substring(5,7);
            DayFrom=document.frmmain.<%=fromdate%>.value.substring(8,10);
            YearTo=document.frmmain.<%=todate%>.value.substring(0,4);
            MonthTo=document.frmmain.<%=todate%>.value.substring(5,7);
            DayTo=document.frmmain.<%=todate%>.value.substring(8,10);
            HourFrom=document.frmmain.<%=fromtime%>.value.substring(0,2);
            MinFrom = document.frmmain.<%=fromtime%>.value.substring(3,5);
            HourTo=document.frmmain.<%=totime%>.value.substring(0,2);
            MinTo = document.frmmain.<%=totime%>.value.substring(3,5);
            if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
                window.alert("<%=SystemEnv.getHtmlLabelName(17362,userlanguage)%>!!!!");
                return false;
            }else{
                if(document.frmmain.<%=fromdate%>.value==document.frmmain.<%=todate%>.value){
                    if (!DateCompare(YearFrom, HourFrom, MinFrom,YearTo, HourTo,MinTo )){
                        window.alert("<%=SystemEnv.getHtmlLabelName(15273,userlanguage)%>!!!!!");
                        return false;
                    }else{
                        if(HourFrom==HourTo && MinFrom == MinTo){
                            window.alert("<%=SystemEnv.getHtmlLabelName(24981,userlanguage)%>"  +"<%=SystemEnv.getHtmlLabelName(26315,userlanguage)%>"+"<%=SystemEnv.getHtmlLabelName(17690,userlanguage)%>!!!!");
                            return false;
                        }
                    }
                }
            }
        }
    }
    return true;
}


function doImportDetail(){
    if(!checkDataChange()){
        if(confirm("<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>")){
            //window.showModalDialog("/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp?requestid=<%=requestid%>",window);
            var dialog = new window.top.Dialog();
        	dialog.currentWindow = window;
        	var url = "/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>";
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
    	var url = "/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>";
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


function changeTab()
{
   /*
   for(i=0;i<=1;i++){
  		parent.$G("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.$G("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$G("oTDtype_0").background="/images/tab.active2_wev8.png";
  	parent.$G("oTDtype_0").className="cycleTDCurrent";
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
	<%
		boolean isnewprint = new weaver.workflow.request.WFDocPrintUtil().getWFIsNewPrint(nodeid);
		if(isnewprint){
			%>
	var redirectUrl = "/docs/docs/seconddev/docmouldprint/DocMouldPrintTab.jsp?requestid=<%=requestid%>&nodeid=<%=nodeid%>";
			<%
		}else{
			%>
	var redirectUrl = "PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1";
	var printmodeid="<%=printmodeid%>";
    if(parseInt(printmodeid)>0){
  	  printModePreview("loadprintmodeFrame",redirectUrl);
  	  return ;
    }
			<%
		}
	%>
	var width = screen.width ;
	var height = screen.height ;
	if (height == 768 ) height -= 75 ;
	if (height == 600 ) height -= 60 ;
	var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes," ;
	szFeatures +="menubar=no," ;
	szFeatures +="toolbar=yes," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}


function returnTrue(o){
	return;
}

function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}
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
function doEdit(obj){
	parent.location.href="ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&reEdit=1&fromFlowDoc=<%=fromFlowDoc%>&requestid=<%=requestid%>&isovertime=<%=isovertime%>&topage=<%=topage%>";
}
function doSubmitBack(obj){

	if(<%=isCptwf %>){//自定义资产流程
		cptcusifover(function(){
			<% if("1".equals(isSubmitDirectNode)) { %>
				if($G("SubmitToNodeid")) {
			       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
				}
			<% } %>
			$G("needwfback").value = "1";
			getRemarkText_log();
			doSubmit(obj);
		});
			
	}else{
		<% if("1".equals(isSubmitDirectNode)) { %>
			if($G("SubmitToNodeid")) {
		       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
			}
		<% } %>
		$G("needwfback").value = "1";
		getRemarkText_log();
		doSubmit(obj);
	}
	
}
function doSubmitNoBack(obj){
	if(<%=isCptwf %>){//自定义资产流程
		cptcusifover(function(){
			<% if("1".equals(isSubmitDirectNode)) { %>
				if($G("SubmitToNodeid")) {
			       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
				}
			<% } %>
			$G("needwfback").value = "0";
			getRemarkText_log();
			doSubmit(obj);
		});
			
	}else{
		<% if("1".equals(isSubmitDirectNode)) { %>
			if($G("SubmitToNodeid")) {
		       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
			}
		<% } %>
		$G("needwfback").value = "0";
		getRemarkText_log();
		doSubmit(obj);
	}
	
}
function doRemark_nBack(obj){
	$G("needwfback").value = "1";
	getRemarkText_log();
	doRemark_n(obj);
}
function doRemark_nNoBack(obj){
	$G("needwfback").value = "0";
	getRemarkText_log();
	doRemark_n(obj);
}
function doAffirmanceBack(obj){
	<% if("1".equals(isSubmitDirectNode)) { %>
		if($G("SubmitToNodeid")) {
	       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
		}
	<% } %>
	$G("needwfback").value = "1";
	getRemarkText_log();
	doAffirmance(obj);
}
function doAffirmanceNoBack(obj){
	<% if("1".equals(isSubmitDirectNode)) { %>
		if($G("SubmitToNodeid")) {
	       $G("SubmitToNodeid").value = "<%=lastnodeid %>";
		}
	<% } %>
	$G("needwfback").value = "0";
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
		var reamrkNoStyle = CkeditorExt.getText("remark");
		if(reamrkNoStyle == ""){
			$G("remarkText10404").value = reamrkNoStyle;
		}else{
			var remarkText = CkeditorExt.getTextNew("remark");
			$G("remarkText10404").value = remarkText;
		}
		for(var i=0; i<CkeditorExt.editorName.length; i++){
			var tmpname = CkeditorExt.editorName[i];
			try{
				if(tmpname == "remark"){
					continue;
				}
				$(tmpname).value = CkeditorExt.getText(tmpname);
			}catch(e){}
		}
	}catch(e){
	}


}

function triSubwf(paramSubwfSetId){
	$G("triSubwfIframe").src="/workflow/request/TriSubwfIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&operation=triSubwf&requestId=<%=requestid%>&nodeId=<%=nodeid%>&paramSubwfSetId="+paramSubwfSetId+"&tempflag="+Math.random();
}

function triSubwf2(paramSubwfSetId,subworkflowname){
	subworkflowname = subworkflowname.replace(new RegExp(',',"gm"),'\n');
	var info = "<%=SystemEnv.getHtmlLabelName(25394,user.getLanguage())%>:"+"\n"+subworkflowname+"<%=SystemEnv.getHtmlLabelName(25395,user.getLanguage())%>";
	top.Dialog.confirm(info,function(){
		$G("triSubwfIframe").src="/workflow/request/TriSubwfIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&operation=triSubwf&requestId=<%=requestid%>&nodeId=<%=nodeid%>&paramSubwfSetId="+paramSubwfSetId+"&tempflag="+Math.random();
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
	    jQuery('[name=frmmain]').append(
	        '<div class="freeNode" style="display:none;">'
	            + jQuery('.freeNode').html()
	        +'</div>'
	    );
	    if (jQuery('.freeNode').length > 1) {
	    	jQuery('.freeNode').eq(1).remove();
	    }
    }
	
<%if(iscnodefree.equals("1") && IsFreeWorkflow){ %>
		doFreeWorkflow();
<%}%>
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

    var title = " <%=SystemEnv.getHtmlLabelName(21781,user.getLanguage())%>";
	var url="/workflow/workflow/BrowserMain.jsp?&url=/workflow/request/FreeWorkflowSet.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&iscnodefree=<%=iscnodefree%>";
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
	var redirectUrl =  "/workflow/request/OverTimeSetByNodeUser.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&requestid=<%=requestid%>&formid=<%=formid%>&isbill=0&billid=<%=billid%>";
	var dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    dialog.URL = redirectUrl;
	dialog.Title ="<%=SystemEnv.getHtmlLabelName(18818,user.getLanguage())%>";
    dialog.Height = screen.availHeight/2;
    dialog.Width = screen.availWidth/2;
    dialog.Drag = true;
    dialog.show();
    
	//var width = screen.availWidth/2;
	//var height = screen.availHeight/2;
	//var top = height/2;
	//var left = width/2;
	//var szFeatures = "top="+top+"," ;
	//szFeatures +="left="+left+"," ;
	//szFeatures +="width="+width+"," ;
	//szFeatures +="height="+height+"," ;
	//szFeatures +="directories=no," ;
	//szFeatures +="status=yes,toolbar=no,location=no," ;
	//szFeatures +="menubar=no," ;
	//szFeatures +="scrollbars=yes," ;
	//szFeatures +="resizable=yes" ; //channelmode
	//window.open(redirectUrl,"",szFeatures) ;
}
//原退回方法-如果要启用，把名字改成onSetRejectNode
function onSetRejectNode2(){
    <%
     if(!freedis.equals("")&&!isornotFree.equals("")){
     //if(IsFreeWorkflow&&IsFreeNode==1){
		    String zjclNodeid=stnode.getIsFreeStart01Node(""+nodeid);
		    //逐级退回
		     if(freedis.equals("1")){
		    %>
		    <%
		         if(isrejectremind.equals("1")&&ischangrejectnode.equals("1")){%>
			        var url=escape("/workflow/request/RejectNodeSetFree.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&isrejecttype=1&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=currentnodeid%>&isrejectremind=<%=isrejectremind%>&ischangrejectnode=<%=ischangrejectnode%>&isselectrejectnode=<%=isselectrejectnode%>&isFreeNode=<%=nodeidss%>");
				    var result = showModalDialog("/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&url="+url);
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
			         //$G("RejectNodes").value=result;
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
	    var result = showModalDialog("/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&url="+url);
	    if (result != null) {
	         // $G("RejectNodes").value=result;
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
		showtipsinfo(<%=requestid%>,<%=workflowid%>,<%=nodeid%>,<%=isbill%>,1,<%=billid%>,"","reject","<%=ismode%>","divFavContent18980","<%=SystemEnv.getHtmlLabelName(18980,user.getLanguage())%>");
            }
        }
    } ;
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())%>";
    dialog.Height = 400 ;
    dialog.Drag = true;
    dialog.show();
}

</SCRIPT>
<!-- added by cyril on 20080605 for td8828-->
<script language=javascript src="/js/checkData_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>
<!-- end by cyril on 20080605 for td8828-->
<script language="JavaScript">
	if("<%=seeflowdoc%>"=="1"){
		if($G("rightMenu")!=null){
			$G("rightMenu").style.display="none";
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

function doShare(){
var requestid= "<%=requestid%>";
var requestname= "<%=requestname%>";
var returnjson = '[{"sharetype":"workflow","sharetitle":"'+requestname+'","objectname":"FW:CustomShareMsg","shareid":"'+requestid+'"}]';
socialshareToEmessage(returnjson);
}

jQuery(document).ready(function(){
	//add by liuzy QC146873 exception handle
	var needChooseOperator = jQuery("input[name='needChooseOperator']",window.parent.document).val();
	if(needChooseOperator != 'y')
		return;
	var frmmain = jQuery("form[name='frmmain']");
	var eh_dialog = null;
	if(window.top.Dialog)
		eh_dialog = new window.top.Dialog();
	else
		eh_dialog = new Dialog();
	eh_dialog.currentWindow = window;
	eh_dialog.Width = 650;
	eh_dialog.Height = 500;
	eh_dialog.Modal = true;
	eh_dialog.maxiumnable = false;
	eh_dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
	eh_dialog.URL = "/workflow/request/requestChooseOperator.jsp";
	eh_dialog.callbackfun = function(paramobj, datas) {
		frmmain.append('<input type="hidden" name="eh_setoperator" value="y" />');
		frmmain.append('<input type="hidden" name="eh_relationship" value="'+datas.relationship+'" />');
		frmmain.append('<input type="hidden" name="eh_operators" value="'+datas.operators+'" />');
		doSubmitBack();		//模拟提交
	};
	eh_dialog.closeHandle = function(paramobj, datas){
		if(frmmain.find("input[name='eh_setoperator']").size() == 0){
			frmmain.append('<input type="hidden" name="eh_setoperator" value="n" />');
			doSubmitBack();		//模拟提交
		}
	};
	eh_dialog.show();
});
</script>

<jsp:include page="/workflow/request/UserDefinedRequestBrowser.jsp" flush="true">
	<jsp:param name="workflowid" value="<%=workflowid%>" />
</jsp:include>