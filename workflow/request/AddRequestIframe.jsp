<%@page import="org.json.JSONObject"%>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.rdeploy.portal.PortalUtil" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />
<jsp:useBean id="WechatPropConfig" class="weaver.wechat.util.WechatPropConfig" scope="page"/>
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="CptWfUtil" class="weaver.cpt.util.CptWfUtil" scope="page" />
<%
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
%> 
<%
//System.out.println("addrequestiframe.jsp start...");

int fromtest = Util.getIntValue(request.getParameter("fromtest"), 0);
//获得工作流的基本信息
String workflowid = Util.null2String(request.getParameter("workflowid"));

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

String workflowname = WorkflowComInfo.getWorkflowname(workflowid);
workflowname = Util.processBody(workflowname,user.getLanguage()+"");
String workflowtype = WorkflowComInfo.getWorkflowtype(workflowid);   //工作流种类


String importwf= WorkflowComInfo.getIsImportwf(workflowid);//可导入流程


String nodeid= "" ;
String formid= "" ;
String isbill="0";
int helpdocid = 0;
int messageType=0;
int chatsType=0;//微信提醒(QC:98106)
int defaultName=0;
String smsAlertsType = "0";
String chatsAlertType = "0";//微信提醒(QC:98106)
String docCategory="";
String isannexupload="";
String annexdocCategory="";
String needAffirmance="";   //是否需要提交确认


String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
String isworkflowdoc = "0";//是否是公文,1代表是


//把session存储在SESSION中，供浏览框调用，达到不同的流程可以使用同一浏览框，不同的条件


session.setAttribute("workflowidbybrowser",workflowid);

//获得当前用户的id，类型和名称。如果类型为1，表示为内部用户（人力资源），2为外部用户（CRM）

//开启云部署后，自由节点流程是否已在高级设置中修改过
PortalUtil putil = new PortalUtil();
boolean cloudstatus = putil.isuserdeploy();
boolean cloudchange = false;
String iscnodefree = "0";
RecordSet.execute("select 1 from Workflow_Initialization where wfid = 35");
if(RecordSet.next()){
	cloudchange = true;
}
if(cloudstatus && cloudchange && workflowid.equals("35")){
	iscnodefree = "1";
}


FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid = user.getUID();
String logintype = user.getLogintype();
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

String custompage = "";
//查询该工作流的表单id，是否是单据（0否，1是），帮助文档id
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid);
if(RecordSet.next()){
	formid = Util.null2String(RecordSet.getString("formid"));
	isbill = ""+Util.getIntValue(RecordSet.getString("isbill"),0);
	helpdocid = Util.getIntValue(RecordSet.getString("helpdocid"),0);
  //modify by xhheng @20050318 for TD1689, 顺便将messageType、docCategory的获取统一至此
  messageType=RecordSet.getInt("messageType");
    smsAlertsType = RecordSet.getString("smsAlertsType");
  //微信提醒START(QC:98106)
    chatsType=RecordSet.getInt("chatsType");
  chatsAlertType = RecordSet.getString("chatsAlertType");
  //微信提醒END(QC:98106)
  defaultName=RecordSet.getInt("defaultName");
  docCategory=RecordSet.getString("docCategory");
  isannexupload=Util.null2String(RecordSet.getString("isannexUpload"));
  annexdocCategory=Util.null2String(RecordSet.getString("annexdoccategory"));
    needAffirmance=Util.null2o(RecordSet.getString("needAffirmance"));
	custompage = Util.null2String(RecordSet.getString("custompage"));
}

//查询该工作流的当前节点id （即改工作流的创建节点 ）


RecordSet.executeProc("workflow_CreateNode_Select",workflowid);
if(RecordSet.next())  nodeid = Util.null2String(RecordSet.getString(1)) ;


//检查用户是否有创建权限
RequestCheckUser.setUserid(userid);
RequestCheckUser.setWorkflowid(Util.getIntValue(workflowid,0));
RequestCheckUser.setLogintype(logintype);
RequestCheckUser.checkUser();
int  hasright=RequestCheckUser.getHasright();
//modify by mackjoe at 2005-09-14 增加代理新建流程权限
int isagent=Util.getIntValue(request.getParameter("isagent"),0);
int beagenter=Util.getIntValue(request.getParameter("beagenter"),0);
if(isagent==1){
    hasright=1;
}
session.setAttribute(workflowid+"isagent"+user.getUID(),""+isagent);
session.setAttribute(workflowid+"beagenter"+user.getUID(),""+beagenter);
//end by mackjoe
if(hasright==0){
	response.sendRedirect("/notice/noright.jsp");
    return;
}
//判断是否有流程创建文档，并且在该节点是有正文字段
boolean docFlag=flowDoc.haveDocFiled(workflowid,nodeid);
String  docFlagss=docFlag?"1":"0";
session.setAttribute("requestAdd"+user.getUID(),docFlagss);

//判断正文字段是否显示选择按钮
ArrayList newTextList = flowDoc.getDocFiled(workflowid);
if(newTextList != null && newTextList.size() > 0){
  String newTextNodes = ""+newTextList.get(5);
  String flowDocField = ""+newTextList.get(1);
  session.setAttribute("requestFlowDocField"+user.getUID(),flowDocField);
  session.setAttribute("requestAddNewNodes"+user.getUID(),newTextNodes);
}

if (!fromFlowDoc.equals("1"))
{
if (docFlag)
{
isworkflowdoc = "1";
//response.sendRedirect("WorkflowAddRequestDocBody.jsp?workflowid="+workflowid+"&isagent="+isagent);
//return;
}
}
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
if(isbill.equals("1")){
	session.setAttribute("topage_ForAllBill",topage);
}

Map fieldMap = request.getParameterMap();
Set keySet = fieldMap.keySet();
Iterator it = keySet.iterator();
String fieldUrl = "";
while(it.hasNext()) {
	String key = Util.null2String((String) it.next());
	if(key.startsWith("field")) {
		String[] valueArr = (String[]) fieldMap.get(key);
		for(int i = 0; i < valueArr.length; i++) {
			String value = valueArr[i];
			fieldUrl += "&" + key + "=" + URLEncoder.encode(value);
		}
	}
}
if(!"".equals(fieldUrl)) {
	fieldUrl = fieldUrl.substring(1, fieldUrl.length());
	fieldUrl = URLEncoder.encode(fieldUrl);
}


//获得当前的日期和时间
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;

//请求提交的时候需要检查必输的字段名，多个必输项用逗号格开，requestname为新建请求中第一行的请求说明，是每一个请求都必须有的
String needcheck="requestname";



//TopTitle.jsp 页面参数
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18015,user.getLanguage())+":"
	+SystemEnv.getHtmlLabelName(125,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage())+" - " +SystemEnv.getHtmlLabelName(125,user.getLanguage());

//if(helpdocid !=0 ) {titlename=titlename + "";}
String needfav ="1";
String needhelp ="";

//add by xhheng @20050206 for TD 1544，requestid设为-1
String requestid="-1";
//add by mackjoe at 2005-12-20 增加模板应用
String ismode="";
int modeid=0,version=0;
int isform=0;
int showdes=0;
String isSignMustInputOfThisJsp="0";
String isHideInputOfThisJsp="0";
String isFormSignatureOfThisJsp=null;
String FreeWorkflowname="";
int formSignatureWidthOfThisJsp=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeightOfThisJsp=RevisionConstants.Form_Signature_Height_Default;
RecordSet.executeSql("select ismode,showdes,isFormSignature,formSignatureWidth,formSignatureHeight,freewfsetcurnameen,freewfsetcurnametw,freewfsetcurnamecn,issignmustinput,ishideinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
String hasModeSign="0";
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
    showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
	isFormSignatureOfThisJsp = Util.null2String(RecordSet.getString("isFormSignature"));
	formSignatureWidthOfThisJsp= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeightOfThisJsp= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
    if(user.getLanguage() == 8){
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnameen"));
    }
    else if(user.getLanguage() == 9)
    {
    	FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnametw"));
    }
    else {
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnamecn"));
    }
    isSignMustInputOfThisJsp = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
    isHideInputOfThisJsp = ""+Util.getIntValue(RecordSet.getString("ishideinput"), 0);
}
int isUseWebRevisionOfThisJsp = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
if(isUseWebRevisionOfThisJsp != 1){
	isFormSignatureOfThisJsp = "";
}

//---------------------------------------------------------------------------------
//跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 START
//---------------------------------------------------------------------------------
//模板模式-如果用户使用的是非IE则自动使用一般模式来显示流程 START 2011-11-23 CC
//if (!isIE.equalsIgnoreCase("true") && ismode.equals("1")) {

if (!isIE.equalsIgnoreCase("true") && ismode.equals("1")) {
	String messageLableId = "";
	if (ismode.equals("1")) {
		messageLableId = "18017";
	} else {
		messageLableId = "23682";
	}
	ismode = "0";	
	//response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=" + messageLableId);
	%>

	<script type="text/javascript">
	
	window.parent.location.href = "/wui/common/page/sysRemind.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&labelid=<%=messageLableId %>";
	
	</script>

<%
	return;
}
//模板模式-如果用户使用的是非IE则自动使用一般模式来显示流程 END
//---------------------------------------------------------------------------------
// 跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 END
//---------------------------------------------------------------------------------

if(ismode.equals("1") && showdes!=1){
    RecordSet.executeSql("select id from workflow_nodemode where isprint='0' and workflowid="+workflowid+" and nodeid="+nodeid);
    if(RecordSet.next()){
        modeid=RecordSet.getInt("id");
    }else{
        RecordSet.executeSql("select id from workflow_formmode where isprint='0' and formid="+formid+" and isbill="+isbill);
        if(RecordSet.next()){
            modeid=RecordSet.getInt("id");
            isform=1;
        }
    }
}else if("2".equals(ismode)){
	weaver.workflow.exceldesign.HtmlLayoutOperate htmlLayoutOperate = new weaver.workflow.exceldesign.HtmlLayoutOperate();
	modeid = htmlLayoutOperate.getActiveHtmlLayout(Util.getIntValue(workflowid), Util.getIntValue(nodeid), 0);
	version = htmlLayoutOperate.getLayoutVersion(modeid);
}
session.setAttribute(userid+"_"+logintype+"username",username);
session.setAttribute(userid+"_"+workflowid+"workflowname",workflowname);
session.setAttribute(userid+"_"+workflowid+"isannexupload",isannexupload);
session.setAttribute(userid+"_"+workflowid+"annexdocCategory",annexdocCategory);     
session.setAttribute(userid+"_"+requestid+"nodeid",""+nodeid);
boolean IsFreeWorkflow=WFForwardManager.getIsFreeWorkflow(Util.getIntValue(requestid),Util.getIntValue(nodeid),0);
boolean isImportDetail=RequestDetailImport.getAllowesImport(Util.getIntValue(requestid),Util.getIntValue(workflowid),Util.getIntValue(nodeid),0,user);

String createpage = "";//TD11055 DS 下面需要公用，定义移到上面

WFManager.setWfid(Util.getIntValue(workflowid));
WFManager.getWfInfo();
String isFree = WFManager.getIsFree();
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<LINK href="/hrm/area/browser/areabrowser.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script language=javascript src="/js/xmlextras_wev8.js"></script>
<SCRIPT language="javascript" src="/hrm/area/browser/areabrowser_wev8.js"></script>

 
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwfat_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>

<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>

<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>
<script language="javascript">
<%if(!ismode.equals("1") || modeid<1){%>
function setwtableheight(){
    /*
    var totalheight=5;
    var bodyheight=document.body.clientHeight;
    if($GetEle("divTopTitle")!=null){
        totalheight+=$GetEle("divTopTitle").clientHeight;
    }
    <%if (fromFlowDoc.equals("1")){%>
        totalheight+=100;
        bodyheight=parent.document.body.clientHeight;
    <%}%>
    $GetEle("w_table").height=bodyheight-totalheight;
    */
}

function addrequestiframeonload() {
	displayAllmenu();
	setwtableheight();
}

window.onresize = function (){
    setwtableheight();
}
<%}else{%>
function windowonload(){
    init();
    displayAllmenu();
    //funcremark_log();
}
<%}%>
</script>
<style>
.wordSpan{font-family:MS Shell Dlg,Arial;CURSOR: hand;font-weight:bold;FONT-SIZE: 10pt}
</style>

</head>
<BODY id="flowbody"  <%if(ismode.equals("1") && modeid>0){%> onload="windowonload()" <%}else{%> onload="addrequestiframeonload()"<%}%>>
<%if (!fromFlowDoc.equals("1")) {%>
<%@ include file="RequestTopTitle.jsp" %>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%//TD9145
Prop prop = Prop.getInstance();
String ifchangstatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
String sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+nodeid;
RecordSet.executeSql(sqlselectName);
String submitName = "";
String subnobackName = "";//提交不需反馈
String subbackName = "";//提交需反馈
String hasnoback = "";//使用提交不需反馈按钮
String hasback = "";//使用提交需反馈按钮
String saveName = "";
String newWFName = "";//新建流程按钮
String newSMSName = "";//新建短信按钮
String newCHATSName = "";//新建微信按钮 微信提醒(QC:98106)
String haswfrm = "";//是否使用新建流程按钮
String hassmsrm = "";//是否使用新建短信按钮
String haschats = "";//是否使用新建微信按钮 微信提醒(QC:98106)
int t_workflowid = 0;//新建流程的ID
int subbackCtrl = 0;
String strBar = "[";//菜单
if(RecordSet.next()){
	if(user.getLanguage() == 7){
		submitName = Util.null2String(RecordSet.getString("submitName7"));
		saveName = Util.null2String(RecordSet.getString("saveName7"));
		newWFName = Util.null2String(RecordSet.getString("newWFName7"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName7"));
		newCHATSName = Util.null2String(RecordSet.getString("newCHATSName7")); //微信提醒(QC:98106)
		subnobackName = Util.null2String(RecordSet.getString("subnobackName7"));
		subbackName = Util.null2String(RecordSet.getString("subbackName7"));
	}else if(user.getLanguage() == 9){
		submitName = Util.null2String(RecordSet.getString("submitName9"));
		saveName = Util.null2String(RecordSet.getString("saveName9"));
		newWFName = Util.null2String(RecordSet.getString("newWFName9"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName9"));
		newCHATSName = Util.null2String(RecordSet.getString("newCHATSName9")); //微信提醒(QC:98106)
		subnobackName = Util.null2String(RecordSet.getString("subnobackName9"));
		subbackName = Util.null2String(RecordSet.getString("subbackName9"));
	}
	else{
		submitName = Util.null2String(RecordSet.getString("submitName8"));
		saveName = Util.null2String(RecordSet.getString("saveName8"));
		newWFName = Util.null2String(RecordSet.getString("newWFName8"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName8"));
		newCHATSName = Util.null2String(RecordSet.getString("newCHATSName8")); //微信提醒(QC:98106)
		subnobackName = Util.null2String(RecordSet.getString("subnobackName8"));
		subbackName = Util.null2String(RecordSet.getString("subbackName8"));
	}
	haswfrm = "0"; //Util.null2String(RecordSet.getString("haswfrm"));
	hassmsrm = Util.null2String(RecordSet.getString("hassmsrm"));
	haschats = Util.null2String(RecordSet.getString("haschats")); //微信提醒(QC:98106)
	hasnoback = Util.null2String(RecordSet.getString("hasnoback"));
	hasback = Util.null2String(RecordSet.getString("hasback"));
	t_workflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
	subbackCtrl = Util.getIntValue(Util.null2String(RecordSet.getString("subbackCtrl")), 0);
}
ArrayList newMenuList1 = new ArrayList(); // 新建短信菜单列表
ArrayList newMenuList2 = new ArrayList(); // 新建微信菜单列表
RecordSet.executeSql("select * from workflow_nodeCustomNewMenu where enable = 1 and wfid=" + workflowid + " and nodeid=" + nodeid + " order by menuType, id");
while(RecordSet.next()) {
	int menuType = Util.getIntValue(RecordSet.getString("menuType"), -1);
	if(menuType <= 0) {
		continue;
	}
	HashMap newMenuMap = new HashMap();
	newMenuMap.put("id", Util.getIntValue(RecordSet.getString("id"), 0));
	newMenuMap.put("newName", Util.null2String(RecordSet.getString("newName" + user.getLanguage())));
	if(1 == menuType) {
		newMenuList1.add(newMenuMap);
	}else if(2 == menuType) {
		newMenuList2.add(newMenuMap);
	}
}
if("".equals(submitName)){
	submitName = SystemEnv.getHtmlLabelName(615,user.getLanguage());
}
if("".equals(saveName)){
	saveName = SystemEnv.getHtmlLabelName(86,user.getLanguage());
}
if("".equals(FreeWorkflowname.trim())){
	FreeWorkflowname = SystemEnv.getHtmlLabelName(21781,user.getLanguage());
}    
if("".equals(subbackName)){
	if(("1".equals(hasnoback) || "1".equals(hasback)) && subbackCtrl == 2){
		subbackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"）";
	}else{
		subbackName = SystemEnv.getHtmlLabelName(615,user.getLanguage());
	}
}
if("".equals(subnobackName)){
	if(subbackCtrl == 2) {
	subnobackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"）";
	}else {
		subnobackName = SystemEnv.getHtmlLabelName(615,user.getLanguage());
	}
}
if("".equals(ifchangstatus)){
	if(!needAffirmance.equals("1")){
		RCMenu += "{"+submitName+",javascript:doSubmitBack(this),_self}";
		RCMenuHeight += RCMenuHeightStep;
        strBar += "{text: '"+submitName+"',iconCls:'btn_submit',handler: function(){doSubmitBack(this);}},";
	}else{
		RCMenu += "{"+submitName+",javascript:doAffirmanceBack(this),_self}";
		RCMenuHeight += RCMenuHeightStep;
        strBar += "{text: '"+submitName+"',iconCls:'btn_submit',handler: function(){doAffirmanceBack(this);}},";
	}
}else{//必须至少有一个按钮


	if(!needAffirmance.equals("1")){
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
	}else{
		if(!"1".equals(hasnoback)){
			RCMenu += "{"+subbackName+",javascript:doAffirmanceBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
            strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doAffirmanceBack(this);}},"; 
		}else{
			if("1".equals(hasback)){
				RCMenu += "{"+subbackName+",javascript:doAffirmanceBack(this),_self}";
				RCMenuHeight += RCMenuHeightStep;
                strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doAffirmanceBack(this);}},"; 
			}
			RCMenu += "{"+subnobackName+",javascript:doAffirmanceNoBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){doAffirmanceNoBack(this);}},";
		}
	}
}
if(IsFreeWorkflow){
	if(iscnodefree.equals("0")){
	    RCMenu += "{"+FreeWorkflowname+",javascript:doFreeWorkflow(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	}
	
	
    strBar += "{text: '"+FreeWorkflowname+"',iconCls:'btn_edit',handler: function(){doFreeWorkflow(this);}},";
}
if(isImportDetail){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(26255,user.getLanguage())+",javascript:doImportDetail(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}
if("1".equals(importwf)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(24270,user.getLanguage())+",javascript:doImportWorkflow(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+SystemEnv.getHtmlLabelName(24270,user.getLanguage())+"',iconCls:'btn_edit',handler: function(){doImportWorkflow(this);}},";
}
RCMenu += "{"+saveName+",javascript:doSave_nNew(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+saveName+"',iconCls:'btn_wfSave',handler: function(){doSave_nNew();}},";
if("1".equals(haswfrm)){
	if("".equals(newWFName)){
		newWFName = SystemEnv.getHtmlLabelName(1239,user.getLanguage());
	}
	RequestCheckUser.resetParameter();
	RequestCheckUser.setUserid(userid);
	RequestCheckUser.setWorkflowid(t_workflowid);
	RequestCheckUser.setLogintype(logintype);
	RequestCheckUser.checkUser();
	int  t_hasright=RequestCheckUser.getHasright();
	if(t_hasright == 1){
		RCMenu += "{"+newWFName+",javascript:onNewRequest("+t_workflowid+",0),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
        strBar += "{text: '"+newWFName+"',iconCls:'btn_newWFName',handler: function(){onNewRequest("+t_workflowid+",0);}},";
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
	RCMenu += "{"+newSMSName+",javascript:onNewSms("+workflowid+", "+nodeid+", " + menuid + "),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+newSMSName+"',iconCls:'btn_newSMSName',handler: function(){onNewSms("+workflowid+", "+nodeid+", " + menuid + ");}},";
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
	RCMenu += "{"+newCHATSName+",javascript:onNewChats("+workflowid+", "+nodeid+", "+requestid+", " + menuid + "),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+newCHATSName+"',iconCls:'btn_newChatsName',handler: function(){bodyiframe.onNewChats("+workflowid+", "+nodeid+", "+requestid+", " + menuid + ");}},";
		}
	}
}
//微信提醒END(QC:98106)
if(strBar.lastIndexOf(",")>-1) strBar = strBar.substring(0,strBar.lastIndexOf(","));
strBar+="]";
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<input type=hidden name=_isagent id=_isagent value="<%=isagent%>">
        <input type=hidden name=_beagenter id="_beagenter" value="<%=beagenter%>">
		<input type=hidden name=isworkflowdoc id="isworkflowdoc" value="<%=isworkflowdoc%>">		

			<%
            //add by mackjoe at 2005-12-20 增加模板应用
            if(modeid>0 && "1".equals(ismode)){
            %>
                <jsp:include page="modehead.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="workflowtype" value="<%=workflowtype%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="topage" value="<%=topage%>" />
                <jsp:param name="needcheck" value="<%=needcheck%>" />
                <jsp:param name="defaultName" value="<%=defaultName%>" />
                <jsp:param name="currentdate" value="<%=currentdate%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="messageType" value="<%=messageType%>" />
				<jsp:param name="smsAlertsType" value="<%=smsAlertsType%>" />
				<jsp:param name="chatsType" value="<%=chatsType%>" />
				<jsp:param name="chatsAlertType" value="<%=chatsAlertType%>" />
                <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
				</jsp:include>
                <jsp:include page="/workflow/mode/loadmode.jsp" flush="true">
                <jsp:param name="modeid" value="<%=modeid%>" />
                <jsp:param name="isform" value="<%=isform%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />    
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="isFormSignature" value="<%=isFormSignatureOfThisJsp%>" />
                <jsp:param name="isHideInput" value="<%=isHideInputOfThisJsp%>" />
				</jsp:include>
                <jsp:include page="hiddenfield.jsp" flush="true">
				<jsp:param name="workflowid" value="<%=workflowid%>" />
				<jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="billid" value="<%=formid%>" />    
                <jsp:param name="docCategory" value="<%=docCategory%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="prjid" value="<%=prjid%>" />
				<jsp:param name="reqid" value="<%=reqid%>" />
                <jsp:param name="docid" value="<%=docid%>" />
                <jsp:param name="crmid" value="<%=crmid%>" />
                <jsp:param name="hrmid" value="<%=hrmid%>" />
                <jsp:param name="currentdate" value="<%=currentdate%>" />
                <jsp:param name="currenttime" value="<%=currenttime%>" />
                <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="isFormSignature" value="<%=isFormSignatureOfThisJsp%>" />
                <jsp:param name="defaultName" value="<%=defaultName%>" />
                <jsp:param name="isSignMustInput" value="<%=isSignMustInputOfThisJsp%>" />
                <jsp:param name="fieldUrl" value="<%=fieldUrl %>" />
				</jsp:include>
				<%
				//模板中是否设置签字字段，如果设置了按模板模式显示，如果没有设置按以前模式显示
				RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-4");
				if(!RecordSet.next()){%>
                <jsp:include page="modeend.jsp" flush="true" >
                <jsp:param name="nodeid" value="<%=nodeid %>" />
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="isFormSignature" value="<%=isFormSignatureOfThisJsp%>" />
                <jsp:param name="formSignatureWidth" value="<%=formSignatureWidthOfThisJsp%>" />
                <jsp:param name="formSignatureHeight" value="<%=formSignatureHeightOfThisJsp%>" />
                <jsp:param name="isSignMustInput" value="<%=isSignMustInputOfThisJsp%>" />
                <jsp:param name="isHideInput" value="<%=isHideInputOfThisJsp%>" />
                </jsp:include>
         <%}else{
         		hasModeSign="1";%>
            <script>
                function funcremark_log() {
                }
            </script>
         <%}%>
		 <input type="hidden" name="needwfback" id="needwfback" value="1" />
		 <input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
			<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
            <input type="hidden" id="docFlags"  value="<%=docFlagss%>" />
            <input type="hidden" name="<%=userid%>_<%=workflowid %>_addrequest_submit_token" value="<%=System.currentTimeMillis() %>"/>
			<input type="hidden" name="lastloginuserid" value="<%=user.getUID()%>">
		   </form>
            <%
            }else{
            //end by mackjoe
			String operationpage = "" ;
            String hasfileup="";
			if(isbill.equals("1")) {
				RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
				if(RecordSet.next())  {
					createpage = Util.null2String(RecordSet.getString("createpage"));
					operationpage = Util.null2String(RecordSet.getString("operationpage"));
                    hasfileup=Util.null2String(RecordSet.getString("hasfileup"));
				}
			}

			//---------------------------------------------------------------------------------
			// 跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 START
			//---------------------------------------------------------------------------------
			if (!isIE.equalsIgnoreCase("true") && false) {
				if (isbill.equals("1") && formid.indexOf("-") == -1 && !createpage.equals("")) {
					if (!"159".equals(formid) && !"180".equals(formid) && !"85".equals(formid) &&!"7".equals(formid) && !"79".equals(formid) && !"158".equals(formid) && !"157".equals(formid) && !"156".equals(formid) ) {
						//response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=15590");
			%>

			<script type="text/javascript">

			window.parent.location.href = "/wui/common/page/sysRemind.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&labelid=27826";

			</script>

			<%
						return;
					}
				}
			}
			//---------------------------------------------------------------------------------
			//跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 END
			//---------------------------------------------------------------------------------
			
			
			//if( ! createpage.equals("") ) {
			if( ! createpage.equals("") && (!formid.equals("7")||!"2".equals(ismode))) {//排除html模式费用报销单  QC29615
			%>
				<jsp:include page="<%=createpage%>" flush="true">
				<jsp:param name="workflowid" value="<%=workflowid%>" />
				<jsp:param name="workflowtype" value="<%=workflowtype%>" />
				<jsp:param name="nodeid" value="<%=nodeid%>" />
				<jsp:param name="formid" value="<%=formid%>" />
				<jsp:param name="prjid" value="<%=prjid%>" />
				<jsp:param name="reqid" value="<%=reqid%>" />
				<jsp:param name="docid" value="<%=docid%>" />
				<jsp:param name="hrmid" value="<%=hrmid%>" />
				<jsp:param name="crmid" value="<%=crmid%>" />
				<jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
				<jsp:param name="topage" value="<%=topage%>" />
				<jsp:param name="docCategory" value="<%=docCategory%>" />
				<jsp:param name="currentdate" value="<%=currentdate%>" />
				<jsp:param name="currenttime" value="<%=currenttime%>" />
        <jsp:param name="helpdocid" value="<%=Integer.toString(helpdocid)%>" />
        <jsp:param name="messageType" value="<%=messageType%>" />
		<jsp:param name="smsAlertsType" value="<%=smsAlertsType%>" />
		<jsp:param name="chatsType" value="<%=chatsType%>" />
		<jsp:param name="chatsAlertType" value="<%=chatsAlertType%>" />
        <jsp:param name="defaultName" value="<%=defaultName%>" />
		<jsp:param name="isSignMustInput" value="<%=isSignMustInputOfThisJsp%>" />
				</jsp:include>
			<%
			} else{
        //modify by xhheng @20050315 for 附件上传
				if( operationpage.equals("") ){
          operationpage = "RequestOperation.jsp" ;
          %>
          <%
             //add by liaodong for qc62834 in 2013年10月15日 start html模式下的边框
             if("2".equals(ismode) && modeid>0){
            %>
             <form name="frmmain" method="post"  action="<%=operationpage%>" style="<%=version==2?"":"margin-top:10px;" %>">
            <% 
             }else{
            %>
             <form name="frmmain" method="post"  action="<%=operationpage%>" >
            <% 
             }//end
             %>
          <%
        }else{
          if(hasfileup.equals("1")){
          %>
            <% 
             //add by liaodong for qc62834 in 2013年10月15日 start html模式下的边框
             if("2".equals(ismode) && modeid>0){
            %>
              <form name="frmmain" method="post"  action="<%=operationpage%>" style="margin-top:10px;">
            <% 
             }else{
            %>
              <form name="frmmain" method="post"  action="<%=operationpage%>" >
            <% 
             }//end
             %>
          <%}else{%>
               <% 
                  //add by liaodong for qc62834 in 2013年10月15日 start html模式下的边框
                 if("2".equals(ismode) && modeid>0){
               %>
                 <form name="frmmain" method="post" action="<%=operationpage%>" style="margin-top:10px;">
               <% 
                 }else{
               %>
                  <form name="frmmain" method="post"  action="<%=operationpage%>">
               <% 
                 }//end
               %>
          <%
            }
        }
        if("2".equals(ismode) && modeid>0){
		%>
		
			<%if(isbill.equals("1") && formid.equals("7")){//针对费用报销增加财务信息  QC29615%>
    <div id="t_headother">
			    <table class="ListStyle" cellspacing='1' border='0'>
			      <tbody>
			      <TR class="header">
			          <TH><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></TH>
			      </TR>
			      <%
			      RecordSet.executeSql("select sum(amount) as sumamount from fnaloaninfo where organizationtype=3 and organizationid="+userid);
			      RecordSet.next();
			      double loanamount=Util.getDoubleValue(RecordSet.getString(1),0);
			      %>
			      <tr class="datalight">
			        <td><%=SystemEnv.getHtmlLabelName(16271,user.getLanguage())%><%=loanamount%></td>
			      </tr>
			      </tbody>
			    </table>
    </div>
			<%}%>
			
			<jsp:include page="WorkflowAddRequestHtml.jsp" flush="true">
				<jsp:param name="modeid" value="<%=modeid%>" />
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="workflowtype" value="<%=workflowtype%>" />
                <jsp:param name="docCategory" value="<%=docCategory%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
				<jsp:param name="nodetype" value="0" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
                <jsp:param name="currentdate" value="<%=currentdate%>" />
                <jsp:param name="currenttime" value="<%=currenttime%>" />
                <jsp:param name="needcheck" value="<%=needcheck%>" />
                <jsp:param name="prjid" value="<%=prjid%>" />
                <jsp:param name="reqid" value="<%=reqid%>" />
                <jsp:param name="docid" value="<%=docid%>" />
                <jsp:param name="hrmid" value="<%=hrmid%>" />
                <jsp:param name="crmid" value="<%=crmid%>" />
                <jsp:param name="messageType" value="<%=messageType%>" />
				<jsp:param name="smsAlertsType" value="<%=smsAlertsType%>" />
				<jsp:param name="chatsType" value="<%=chatsType%>" />
				<jsp:param name="chatsAlertType" value="<%=chatsAlertType%>" />
                <jsp:param name="defaultName" value="<%=defaultName%>" />
                <jsp:param name="topage" value="<%=topage%>" />
                <jsp:param name="logintype" value="<%=logintype%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
				<jsp:param name="iscreate" value="1" />
				<jsp:param name="isremark" value="0" />
                <jsp:param name="fieldUrl" value="<%=fieldUrl %>" />
            </jsp:include>
		<%}else{%>
			<jsp:include page="WorkflowAddRequestBodyAction.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="workflowtype" value="<%=workflowtype%>" />
                <jsp:param name="docCategory" value="<%=docCategory%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
                <jsp:param name="currentdate" value="<%=currentdate%>" />
                <jsp:param name="currenttime" value="<%=currenttime%>" />
                <jsp:param name="needcheck" value="<%=needcheck%>" />
                <jsp:param name="prjid" value="<%=prjid%>" />
                <jsp:param name="reqid" value="<%=reqid%>" />
                <jsp:param name="docid" value="<%=docid%>" />
                <jsp:param name="hrmid" value="<%=hrmid%>" />
                <jsp:param name="crmid" value="<%=crmid%>" />
                <jsp:param name="messageType" value="<%=messageType%>" />
				<jsp:param name="smsAlertsType" value="<%=smsAlertsType%>" />
				<jsp:param name="chatsType" value="<%=chatsType%>" />
				<jsp:param name="chatsAlertType" value="<%=chatsAlertType%>" />
                <jsp:param name="defaultName" value="<%=defaultName%>" />
                <jsp:param name="topage" value="<%=topage%>" />
                <jsp:param name="logintype" value="<%=logintype%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="fieldUrl" value="<%=fieldUrl %>" />
            </jsp:include>
		<%}%>
			<input type="hidden" name="needwfback"  id="needwfback" value="1"/>
			<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
			<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
			<input type="hidden" id="docFlags"  value="<%=docFlagss%>" />
			<input type="hidden" name="<%=userid%>_<%=workflowid %>_addrequest_submit_token" value="<%=System.currentTimeMillis() %>"/>
			<input type="hidden" name="lastloginuserid" value="<%=user.getUID()%>">
			</form>
			<%}
            }%>			

			<%
				if(!custompage.equals("")){
			%>
					<jsp:include page="<%=custompage%>" flush="true">
		                <jsp:param name="workflowid" value="<%=workflowid%>" />
		                <jsp:param name="workflowtype" value="<%=workflowtype%>" />
		                <jsp:param name="docCategory" value="<%=docCategory%>" />
		                <jsp:param name="nodeid" value="<%=nodeid%>" />
		                <jsp:param name="requestid" value="<%=requestid%>" />
		                <jsp:param name="isbill" value="<%=isbill%>" />
		                <jsp:param name="formid" value="<%=formid%>" />
		                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
		                <jsp:param name="currentdate" value="<%=currentdate%>" />
		                <jsp:param name="currenttime" value="<%=currenttime%>" />
		                <jsp:param name="needcheck" value="<%=needcheck%>" />
		                <jsp:param name="prjid" value="<%=prjid%>" />
		                <jsp:param name="reqid" value="<%=reqid%>" />
		                <jsp:param name="docid" value="<%=docid%>" />
		                <jsp:param name="hrmid" value="<%=hrmid%>" />
		                <jsp:param name="crmid" value="<%=crmid%>" />
		                <jsp:param name="messageType" value="<%=messageType%>" />
						<jsp:param name="smsAlertsType" value="<%=smsAlertsType%>" />
						<jsp:param name="chatsType" value="<%=chatsType%>" />
						<jsp:param name="chatsAlertType" value="<%=chatsAlertType%>" />
		                <jsp:param name="defaultName" value="<%=defaultName%>" />
		                <jsp:param name="topage" value="<%=topage%>" />
		                <jsp:param name="logintype" value="<%=logintype%>" />
		                <jsp:param name="userid" value="<%=userid%>" />
		                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
		            </jsp:include>
			<%		
				}
			%>
<iframe id="fileDownload" frameborder=0 scrolling=no src=""  style="display:none"></iframe>       
		
<SCRIPT LANGUAGE="JavaScript">

function changefileaon(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#008aff!important;text-decoration:underline!important;");
}

function changefileaout(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#8b8b8b!important;text-decoration:none!important;");
}

function returnTrue(o){
	return;
}

function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}

function openDocExt(showid,versionid,docImagefileid,isedit){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
    
	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>");
	}
}

function openAccessory(fileId){ 
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&fromrequest=1");
}

function downloads(files)
{ 
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	$G("fileDownload").src="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1&fromrequest=1";
}
function downloadsBatch(fieldvalue,requestid)
{ 
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	$G("fileDownload").src="/weaver/weaver.file.FileDownload?fieldvalue="+fieldvalue+"&download=1&downloadBatch=1&fromrequest=1&requestid="+requestid;
}
function changecancleon(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#f4fcff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","block");
}

function changecancleout(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#ffffff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","none");
}

function changebuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#8d8d8d");
	}
}

function changebuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#aaaaaa");
	}
}

function showProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-2px 0px!important;display:block;float:right;");
}

function hideProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-14px 0px!important;display:none;float:right;");
}

function clearAllQueue(oUploadcancle){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())+SystemEnv.getHtmlLabelName(21407,user.getLanguage())%>?", function(){
		//jQuery("#fsUploadProgress"+oUploadId).empty();
		//var oUploadcancle = "oUpload"+oUploadId;
		oUploadcancle.cancelQueue();
	}, function () {}, 320, 90,true);
}

<%--added by xwj for td3247 20051201--%>
window.onbeforeunload=function protectCreatorFlow(event){
		//modified by cyril on 20080605 for td8828
		var opt = true;
		try {
			opt = document.getElementById('src').value=='';
		}
		catch(e){
			opt = true;
		}
		
		try {
			var __aeleclicktime = window.__aeleclicktime;
			var __currenttime = new Date().getTime();
			if (isIE()) {
				if (__currenttime <= __aeleclicktime + 500) {
					opt = false;
				}
			}
		} catch (e) {}
		
		if(opt && !checkDataChange())
    return "<%=SystemEnv.getHtmlLabelName(18674,user.getLanguage())%>";
}
function showWFHelp(docid){
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    var operationPage = "/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id="+docid;
    window.open(operationPage,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}
function onNewRequest(wfid,agent){
	var redirectUrl =  "AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
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
function onNewSms(wfid, nodeid, menuid){
	var redirectUrl =  "/sms/SendRequestSms.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&workflowid="+wfid+"&nodeid="+nodeid + "&menuid=" + menuid;
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
//微信提醒START(QC:98106) 
function onNewChats(wfid, nodeid, reqid, menuid){ 
	var redirectUrl =  "/wechat/sendWechat.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&workflowid="+wfid+"&nodeid="+nodeid+"&reqid="+reqid+"&actionid=dialog&menuid=" + menuid;
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
//微信提醒END(QC:98106)
function doSubmitBack(obj){
	var iscnodefree = "<%=iscnodefree%>";
	var IsFreeWorkflow = "<%=IsFreeWorkflow%>";

	if(<%=isCptwf %>){//自定义资产流程


		cptcusifover(function(){
			document.getElementById("needwfback").value = "1";
			getRemarkText_log();
			doSubmit(obj);
		});
	}else if(iscnodefree == "1" && IsFreeWorkflow == "true"){
		try {
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        } catch(e) {
            var ischeckok = "";
            try {
                if (check_form($GetEle("frmmain"), $GetEle("needcheck").value + $GetEle("inputcheck").value))
                    ischeckok = "true";
            } catch(e) {
                ischeckok = "false";
            }
            if (ischeckok == "true") {
                if (checktimeok()) {
                    $GetEle("frmmain").src.value = 'save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

                    //TD4262 增加提示信息  开始


                <%
                    if(modeid>0 && "1".equals(ismode)){
                %>
                    contentBox = document.getElementById("divFavContent18979");
                    showObjectPopup(contentBox)
                <%
                    }else{
                %>
                    var content = "<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                    showPrompt(content);
                <%
                    }
                %>
                    //TD4262 增加提示信息  结束
                <%
                topage = URLEncoder.encode(topage);
                %>
                    $GetEle("frmmain").topage.value = "ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";

				//保存签章数据
                <%if("1".equals(isFormSignatureOfThisJsp) && "0".equals(hasModeSign)&& !isHideInputOfThisJsp.equals("1")){%>
                    if (SaveSignature()) {
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                    } else {
                        if(isDocEmpty==1){
                        	alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
                        	isDocEmpty=0;
                        }else{
                        	alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
                        }
                        return;
                    }
                <%}else{%>
                    //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                <%}%>
                }
            }
        }
	
	}else{
		document.getElementById("needwfback").value = "1";
		getRemarkText_log();
		doSubmit(obj);
	}
	
}

function dowfsubmit(){
	document.getElementById("needwfback").value = "1";
	getRemarkText_log();
	doSubmit(obj);
}

function doSubmitNoBack(obj){
	if(<%=isCptwf %>){//自定义资产流程


		cptcusifover(function(){
			document.getElementById("needwfback").value = "0";
			getRemarkText_log();
			doSubmit(obj);
		});
			
	}else{
		document.getElementById("needwfback").value = "0";
		getRemarkText_log();
		doSubmit(obj);
	}
	
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
	document.getElementById("needwfback").value = "1";
	getRemarkText_log();
	doAffirmance(obj);
}
function doAffirmanceNoBack(obj){
	document.getElementById("needwfback").value = "0";
	getRemarkText_log();
	doAffirmance(obj);
}
function doSave_nNew(){
	getRemarkText_log();
	doSave();
}
function getRemarkText_log(){
	try{
		
		var reamrkNoStyle = CkeditorExt.getText("remark");
		
		if(reamrkNoStyle == ""){
			document.getElementById("remarkText10404").value = reamrkNoStyle;
		}else{
			var remarkText = CkeditorExt.getTextNew("remark");
			document.getElementById("remarkText10404").value = remarkText;
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
function uescape(url){
    return escape(url);
}
</SCRIPT>
<%  
if(modeid<1 || ismode.equals("2")){
%>


<script type="text/javascript">

function onShowBrowser(id,url,linkurl,type1,ismand) {
	var funFlag = "";
	var id1 = null;
	
    if (type1 == 9  && <%=docFlag%>) {
        if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
        	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>"
        } else {
	    	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
        }
	}

    spanname = "field" + id + "span";
    inputname = "field" + id;
	if (type1 == 2 || type1 == 19 ) {
		if (type1 == 2) {
			onWorkFlowShowDate(spanname,inputname,ismand);
		} else {
			onWorkFlowShowTime(spanname, inputname, ismand);
		}
	} else {
	    if (type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170 && type1!=194) {
			id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170 || type1 == 194) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 37) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 142 ) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			} else if (type1 == 162 ) {
				tmpids = $GetEle("field"+id).value;

				if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
					url = url + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
				} else {
					url = url + "|" + id + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
			} else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
		        	tmpids=uescape("?isdetail=1&isbill=<%=isbill%>&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
		        	tmpids = uescape("?fieldid=" + id + "&isbill=<%=isbill%>&resourceids=" + $GetEle("field" + id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        }
			} else {
		        tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			}
		}
		
	    if (id1 != undefined && id1 != null) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170 || type1==194) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = ""
					if(resourceids.substr(0,1)==","){
						resourceids = resourceids.substr(1);
						resourcename = resourcename.substr(1);
					}

					$GetEle("field"+id).value= resourceids
					
					var tlinkurl = linkurl;
					var resourceIdArray = resourceids.split(",");
					var resourceNameArray = resourcename.split(",");
					for (var _i=0; _i<resourceIdArray.length; _i++) {
						var curid = resourceIdArray[_i];
						var curname = resourceNameArray[_i];

						if (tlinkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml += "<a href=" + tlinkurl + curid + " target=_new>" + curname + "</a>&nbsp";
						}
					}
					
					$GetEle("field"+id+"span").innerHTML = sHtml;
					$GetEle("field"+id).value= resourceids;
				} else {
 					if (ismand == 0) {
 						$GetEle("field"+id+"span").innerHTML = "";
 					} else {
 						$GetEle("field"+id+"span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
 					}
 					$GetEle("field"+id).value = "";
				}

			} else {
			   if (wuiUtil.getJsonValueByIndex(id1, 0) != ""  ) {
	               if (type1 == 162) {
				   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						sHtml = ""
						if(ids.substr(0,1)==","){
							ids = ids.substr(1);
							names = names.substr(1);
							descs = descs.substr(1);
						}
						$GetEle("field"+id).value= ids;
						
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
					   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						$GetEle("field"+id).value = ids;
						sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return ;
				   }

					if(wuiUtil.getJsonValueByIndex(id1, 0) != "0"){
				   if (type1 == 16) {
					   curid = wuiUtil.getJsonValueByIndex(id1, 0);
                   	   linkno = getWFLinknum("slink" + id + "_rq" + curid);
	                   if (linkno>0) {
	                       curid = curid + "&wflinkno=" + linkno;
	                   } else {
	                       linkurl = linkurl.substring(0, linkurl.indexOf("?") + 1) + "requestid=";
	                   }
	                   $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
					   if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
						   $GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(e);'>" + wuiUtil.getJsonValueByIndex(id1, 1)+ "</a>&nbsp";
					   } else {
	                       $GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + curid + " target='_new'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
					   }
	                   return;
				   }
				   
	               if (type1 == 9 && <%=docFlag%>) {
		                tempid = wuiUtil.getJsonValueByIndex(id1, 0);
		                $GetEle("field" + id + "span").innerHTML = "<a href='#' onclick=\"createDoc(" + id + ", " + tempid + ", 1)\">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a><button type=\"button\" id=\"createdoc\" style=\"display:none\" class=\"AddDocFlow\" onclick=\"createDoc(" + id + ", " + tempid + ",1)\"></button>";
	               } else {
	            	    if (linkurl == "") {
				        	$GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
				        } else {
							if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
								$GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
							} else {
								$GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
							}
				        }
	               }
	               $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
	                if (type1 == 9 && <%=docFlag%>) {
	                	var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=CreateNewDoc]").html("");
	                }
	                
					}else{
						if (ismand == 0) {
							$GetEle("field"+id+"span").innerHTML = "";
						} else {
							$GetEle("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
						}
						$GetEle("field"+id).value="";
						if (type1 == 9 && <%=docFlag%>){
							var evt = getEvent();
							var targetElement = evt.srcElement ? evt.srcElement : evt.target;
							jQuery(targetElement).next("span[id=CreateNewDoc]").html("<button type=button id='createdoc' class=AddDocFlow onclick=createDoc(" + id + ",'','1') title='<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%></button>");
						}
					}
			   } else {
					if (ismand == 0) {
						$GetEle("field"+id+"span").innerHTML = "";
					} else {
						$GetEle("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					}
					$GetEle("field"+id).value="";
					if (type1 == 9 && <%=docFlag%>){
						var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=CreateNewDoc]").html("<button type=button id='createdoc' class=AddDocFlow onclick=createDoc(" + id + ",'','1') title='<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%></button>");
					}
			   }
			}
		}
	}
}

function getDate(i) {
	var returndate = window.showModalDialog("/systeminfo/Calendar.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>","","dialogHeight:320px;dialogwidth:275px")
	$GetEle("datespan"  + i).innerHTML= returndate;
	$GetEle("dff0" + i).value=returndate;
}

function onShowSignBrowser(url,linkurl,inputname,spanname,type1) {
    var tmpids = jQuery("#" + inputname).val();
    
    var url;
    var dialog = new window.top.Dialog();
    if (type1 === 37) {
        url = "/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&url=" + url + "?documentids=" + tmpids;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(857,user.getLanguage()) %>";
    } else {
        url = "/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&url=" + url + "?resourceids=" + tmpids;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage()) %>";
    }

    dialog.currentWindow = window;
    dialog.callbackfunParam = null;
    dialog.URL = url;
    dialog.callbackfun = function (paramobj, id1) {
        if (id1) {
		   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
				var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
				var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
				var sHtml = ""
				$GetEle(inputname).value = resourceids;
				var resourceidArray = resourceids.split(",");
				var resourcenameArray = resourcename.split(",");
				for (var _i=0; _i<resourceidArray.length; _i++) {
					var curid = resourceidArray[_i];
					var curname = resourcenameArray[_i];
					sHtml = sHtml + "<a href=" + linkurl + curid + " target='_blank'>" + curname + "</a>&nbsp";
				}
				$GetEle(spanname).innerHTML = sHtml;
		   } else {
			    $GetEle(spanname).innerHTML = "";
				$GetEle(inputname).value="";
		   }
       }
    } ;
    dialog.Height = 620 ;
    dialog.Drag = true;
    dialog.show();
}

function openHrefWithChinese(url){
    url = dealChineseOfFieldParams(url);
    window.open(url);
}
//encodeURIComponent
function dealChineseOfFieldParams(url){
	if(url.indexOf("/workflow/request/AddRequest.jsp")==-1 && url.indexOf("/formmode/view/AddFormMode.jsp") != 0) {
		return url;
	}
	var params = "";
	var path = url.substring(0,url.indexOf("?")+1);
	var filedparams = url.substring(url.indexOf("?")+1);
	var fieldparam = filedparams.split("&");
	 for(var i=0;i<fieldparam.length;i++) {
		var tmpindex = fieldparam[i].indexOf("=");
		if(tmpindex != -1) {
			var key = fieldparam[i].substring(0, tmpindex);
			var value = encodeURIComponent(fieldparam[i].substring(tmpindex+1));
			params+="&"+key+"="+value
		}
	} 
	return path+params.substring(1);
}


</script>
<%}%>
<script language="javascript">
var isfirst = 0 ;
var objSubmit="";
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
        	$GetEle("picInnerFrame").src="/workflow/request/WorkflowRequestPictureInner.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>";				
        	$GetEle("picframe").src="/workflow/request/WorkflowRequestPicture.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>";

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



function doAffirmance(obj){          //
	    
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        }catch(e){
            var ischeckok="";
            try{
            	var needCheckStr = $GetEle("needcheck").value+$GetEle("inputcheck").value;
            	if(!!needCheckStr && jQuery("input#edesign_layout").length>0)
					needCheckStr = viewattrOperator.filterHideField(needCheckStr);
				if(check_form($GetEle("frmmain"),needCheckStr)){
				   if($GetEle("formid").value == 85 || $GetEle("formid").value==163){ 
					  try{
						  if(!checkmeetingtimeok()){
							  ischeckok = "false";
						  } else {
							  ischeckok="true";
						  }	  
					  }catch(e2){ischeckok="true";}
					}else{
						ischeckok="true";
					}
				}       
			}catch(e){
			  ischeckok="false";
			}
			try{
				frmmain.ChinaExcel.EndCellEdit(true);
			}catch(e1){}

<%
	if(isSignMustInputOfThisJsp.equals("1")){
	    if("1".equals(isFormSignatureOfThisJsp)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>

            if(ischeckok=="true"){
                if(checktimeok()) {
                    <%if(isbill.equals("1") && Util.getIntValue(formid,0)<0 && "AddBillDataCenter.jsp".equalsIgnoreCase(createpage)){%>
                        objSubmit=obj;
					    checkReportData("Affirmance");						
					<%}else{%>
                        $GetEle("frmmain").src.value='save';
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

                       //TD4262 增加提示信息  开始


	                   <%
    if(modeid>0 && "1".equals(ismode)){
%>
	                    contentBox = document.getElementById("divFavContent18979");
                        showObjectPopup(contentBox)
<%
    }else{
%>
		       var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
		       showPrompt(content);
<%
    }
%>

                        <%
                        topage = URLEncoder.encode(topage);
                        %>
                        $GetEle("frmmain").topage.value="ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&isaffirmance=1&reEdit=0&fromFlowDoc=<%=fromFlowDoc%>&topage=<%=topage%>";

//保存签章数据
<%if("1".equals(isFormSignatureOfThisJsp) && "0".equals(hasModeSign)&& !isHideInputOfThisJsp.equals("1")){%>
	                    if(SaveSignature()){
                       //TD4262 增加提示信息  结束
                        obj.disabled=true;
                            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							return ;
						}
<%}else{%>
                       //TD4262 增加提示信息  结束
                        obj.disabled=true;
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}}%>
                    }
             }
        }
	}


	 jQuery(document).ready(function(){
	 		//在流程表单中创建一个隐藏的div，用于存放自由流程设置信息


 		jQuery('[name=frmmain]').append(
 			'<div class="freeNode" style="display:none;">'
	 			+'<input type="hidden" name="freeNode" value="0">'
	 			+'<input type="hidden" name="freeDuty" value="1">'
			+'</div>'
		);
	 });

function showPrompt(content)
{

     var showTableDiv  = $GetEle('_xTable');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = $GetEle("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     message_table_Div.style.top=pTop;
     message_table_Div.style.left=pLeft;

     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
     var top = document.body.offsetHeight/2 - (parent.document.body.offsetHeight/2 - document.body.offsetHeight/2) - 55;   
     jQuery("#_xTable").css( { position : 'fixed', 'top' : top, 'left' : pLeft } ).show();
}
    function doFreeWorkflow() {
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
		　　dlg.URL = "/workflow/request/FreeNodeShow.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&workflowid=<%=workflowid%>";
		　　dlg.Title = "<%=SystemEnv.getHtmlLabelName(83284,user.getLanguage())%>";
			dlg.maxiumnable = false;
		　　dlg.show();
			// 保留对话框对象


			window.top.freewindow = window;
			window.top.freedialog = dlg;

    		return;
    	}
    	
    	
    	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21798,user.getLanguage())%>", function() {
	        try {
	            //为了对《工作安排》流程作特殊的处理，请参考MR1010
	            $GetEle("planDoSave").click();
	        } catch(e) {
	            var ischeckok = "";
	            try {
	                if (check_form($GetEle("frmmain"), $GetEle("needcheck").value + $GetEle("inputcheck").value))
	                    ischeckok = "true";
	            } catch(e) {
	                ischeckok = "false";
	            }
	            if (ischeckok == "true") {
	                if (checktimeok()) {
	                    $GetEle("frmmain").src.value = 'save';
	                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

	                    //TD4262 增加提示信息  开始


	                <%
	                    if(modeid>0 && "1".equals(ismode)){
	                %>
	                    contentBox = document.getElementById("divFavContent18979");
	                    showObjectPopup(contentBox)
	                <%
	                    }else{
	                %>
	                    var content = "<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
	                    showPrompt(content);
	                <%
	                    }
	                %>
	                    //TD4262 增加提示信息  结束
	                <%
	                topage = URLEncoder.encode(topage);
	                %>
	                    $GetEle("frmmain").topage.value = "ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";

	//保存签章数据
	                <%if("1".equals(isFormSignatureOfThisJsp) && "0".equals(hasModeSign)&& !isHideInputOfThisJsp.equals("1")){%>
	                    if (SaveSignature()) {
	                        //附件上传
	                        StartUploadAll();
	                        checkuploadcomplet();
	                    } else {
	                        if(isDocEmpty==1){
	                        	alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
	                        	isDocEmpty=0;
	                        }else{
	                        	alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
	                        }
	                        return;
	                    }
	                <%}else{%>
	                    //附件上传
	                        StartUploadAll();
	                        checkuploadcomplet();
	                <%}%>
	                }
	            }
	        }
	    });
	}

function doImportDetail() {
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21798,user.getLanguage())%>", function() {
		try {
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        } catch(e) {
            var ischeckok = "";
            try {
                //if (check_form($GetEle("frmmain"), $GetEle("needcheck").value + $GetEle("inputcheck").value))
                if (check_form($GetEle("frmmain"), "requestname"))
                    ischeckok = "true";
            } catch(e) {
                ischeckok = "false";
            }
            
            
            <%
            //签字意见是否必填
			 String isSignMustInputTemp="0";
			 RecordSet.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
			 if(RecordSet.next()){
				 isSignMustInputTemp = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
			 }
				if(isSignMustInputTemp.equals("1")){
				    if("1".equals(isFormSignatureOfThisJsp)){
					}else{
			%>
			            if(ischeckok=="true"){
			            	getRemarkText_log();
						    /* if(!check_form($GetEle("frmmain"),'remarkText10404')){
							    ischeckok="false";
						    } */
					    }
			<%
					}
				}
			%>
            
            if (ischeckok == "true") {
                if (checktimeok()) {
                    $GetEle("frmmain").src.value = 'save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

                <%
                topage = URLEncoder.encode(topage);
                %>
                    $GetEle("frmmain").topage.value = "ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";

		//保存签章数据
		<%if("1".equals(isFormSignatureOfThisJsp) && "0".equals(hasModeSign)&& !isHideInputOfThisJsp.equals("1")){ %>
                    if (SaveSignature_save()||!SaveSignature_save()) {
                        //TD4262 增加提示信息  开始


                <%
                    if(ismode.equals("1")){
                %>
                        contentBox = document.getElementById("divFavContent18979");
                        showObjectPopup(contentBox)
                <%
                    }else{
                %>
                        var content = "<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                        showPrompt(content);
                <%
                    }
                %>
                        //TD4262 增加提示信息  结束
                        //$GetEle("frmmain").submit();
			StartUploadAll();
                        checkuploadcomplet();
                        enableAllmenu();
                    } else {
							if(isDocEmpty==1){
								alert("<%=SystemEnv.getHtmlLabelName(24839,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
                        return;
                    }
                <%}else{%>
                    //TD4262 增加提示信息  开始


                <%
                    if(ismode.equals("1")){
                %>
                    contentBox = document.getElementById("divFavContent18979");
                    showObjectPopup(contentBox)
                <%
                    }else{
                %>
                    var content = "<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                    showPrompt(content);
                <%
                    }
                %>
                    //TD4262 增加提示信息  结束
                    //$GetEle("frmmain").submit();
		    StartUploadAll();
                    checkuploadcomplet();
                    enableAllmenu();
                <%}%>
                }
            }
        }
	});
}

function doImportWorkflow(){
	//不再验证是否填写标题，如果没有添加，则根据规则生成一个


    //if(check_form($GetEle("frmmain"),"requestname")){
    	var dialog = new window.top.Dialog();
    	dialog.currentWindow = window;
    	//var url = "/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestImport.jsp?formid=<%=formid%>&isbill=<%=isbill%>&workflowid=<%=workflowid%>&status=2&ismode=<%=ismode%>";
    	var url = "/systeminfo/BrowserMain.jsp?url="+escape("/workflow/request/RequestImport.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&formid=<%=formid%>&isbill=<%=isbill%>&workflowid=<%=workflowid%>&status=2&ismode=<%=ismode%>");
    	var title = "<%=SystemEnv.getHtmlLabelName(24270,user.getLanguage())%>";
    	dialog.Width = 600;
    	dialog.Height = 600;
    	dialog.Title=title;
    	dialog.Drag = true;
    	dialog.maxiumnable = true;
    	dialog.URL = url;
    	dialog.show();
    //}
}
function doImport(reqid){
    if(reqid>0){
     //流程导入不再验证标题，如果没有输入标题，则自动根据规则生成一个默认标题


        //if (check_form($GetEle("frmmain"), "requestname")){
        $GetEle("frmmain").src.value='import';
        $GetEle("frmmain").action = "RequestImportOption.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&newmodeid=<%=modeid%>&ismode=<%=ismode%>&imprequestid="+reqid+"&isfrom=fromcreate";
        //$GetEle("frmmain").enctype="multipart/form-data"
        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
    <%
        if(modeid>0 && "1".equals(ismode)){
    %>
        contentBox = document.getElementById("divFavContent24272");
        showObjectPopup(contentBox)
    <%
        }else{
    %>
        var content = "<%=SystemEnv.getHtmlLabelName(24272,user.getLanguage())%>";
        showPrompt(content);
    <%
        }
    %>
        $GetEle("frmmain").submit();
        enableAllmenu();
        //}
    }
}
var oPopup;
try{
    oPopup = window.createPopup();
}catch(e){}
function showObjectPopup(contentBox){
  try{
    var iX=document.body.offsetWidth/2-50;
	var iY=document.body.offsetHeight/2+document.body.scrollTop-50;
	var oPopBody = oPopup.document.body;
    oPopBody.style.border = "1px solid #8888AA";
    oPopBody.style.backgroundColor = "white";
    oPopBody.style.position = "absolute";
    oPopBody.style.padding = "0px";
    oPopBody.style.zindex = 150;
    oPopBody.innerHTML = contentBox.innerHTML;
    oPopup.show(iX, iY, 180, 22, document.body);
  }catch(e){}  
}
<%if(fromtest==1){%>
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

</SCRIPT>

<script language=javascript src="/js/checkData_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>
<div id="divFavContent18979" style="display:none">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>
</body>
</html>

<jsp:include page="/workflow/request/UserDefinedRequestBrowser.jsp" flush="true">
	<jsp:param name="workflowid" value="<%=workflowid%>" />
</jsp:include>