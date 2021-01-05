
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.workflow.workflow.WFDocumentManager" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page" /> 

<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />

<jsp:useBean id="WorkflowManage" class="weaver.workflow.workflow.WorkflowManage" scope="page" />
<!-- 微信提醒(QC:98106) -->
<jsp:useBean id="WechatPropConfig" class="weaver.wechat.util.WechatPropConfig" scope="page"/>
<%
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String viewdoc = "0";
%> 
<%
//获得工作流的基本信息
String workflowid = Util.null2String(request.getParameter("workflowid"));
String workflowname = WorkflowComInfo.getWorkflowname(workflowid);
workflowname = Util.processBody(workflowname,user.getLanguage()+"");

String workflowtype = WorkflowComInfo.getWorkflowtype(workflowid);   //工作流种类

String importwf= WorkflowComInfo.getIsImportwf(workflowid);//可导入流程

// 判断当前工作流的当前节点，是否需要默认打开正文tab页
boolean isOpenTextTab = new WFDocumentManager().isOpenTextTab(workflowid,"-1");

String nodeid= "" ;
String formid= "" ;
String isbill="0";
int helpdocid = 0;
//微信提醒START(QC:98106)
int chatsType=0; 
//微信提醒END(QC:98106)
int messageType=0;
int defaultName=0;
String isshared="";
String docCategory="";
String isannexupload="";
String annexdocCategory="";
String needAffirmance="";   //是否需要提交确认

String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
String isworkflowdoc = "0";//是否是公文,1代表是

//把session存储在SESSION中，供浏览框调用，达到不同的流程可以使用同一浏览框，不同的条件

session.setAttribute("workflowidbybrowser",workflowid);

//获得当前用户的id，类型和名称。如果类型为1，表示为内部用户（人力资源），2为外部用户（CRM）

int userid = user.getUID();
String logintype = user.getLogintype();
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

int fromtest = Util.getIntValue(request.getParameter("fromtest"), 0);
int isvalid = -1;
//查询该工作流的表单id，是否是单据（0否，1是），帮助文档id
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid);
if(RecordSet.next()){
	formid = Util.null2String(RecordSet.getString("formid"));
	isbill = ""+Util.getIntValue(RecordSet.getString("isbill"),0);
	helpdocid = Util.getIntValue(RecordSet.getString("helpdocid"),0);
	//微信提醒START(QC:98106)
	chatsType=RecordSet.getInt("chatsType"); 
	//微信提醒END(QC:98106)
  //modify by xhheng @20050318 for TD1689, 顺便将messageType、docCategory的获取统一至此
  messageType=RecordSet.getInt("messageType");
  defaultName=RecordSet.getInt("defaultName");
  docCategory=RecordSet.getString("docCategory");
  isannexupload=Util.null2String(RecordSet.getString("isannexUpload"));
  annexdocCategory=Util.null2String(RecordSet.getString("annexdoccategory"));
    needAffirmance=Util.null2o(RecordSet.getString("needAffirmance"));
    isvalid = Util.getIntValue(RecordSet.getString("isvalid"), 0);
}
session.setAttribute("__isbill",isbill);
session.setAttribute("__formid",formid);

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
if((isvalid==2 && fromtest!=1) || isvalid==0){
	hasright = 0;
}
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
int modeid=0;
int isform=0;
int showdes=0;
String isSignMustInputOfThisJsp="0";
String isFormSignatureOfThisJsp=null;
String FreeWorkflowname="";
int formSignatureWidthOfThisJsp=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeightOfThisJsp=RevisionConstants.Form_Signature_Height_Default;
RecordSet.executeSql("select ismode,showdes,isFormSignature,formSignatureWidth,formSignatureHeight,freewfsetcurnameen,freewfsetcurnametw,freewfsetcurnamecn,issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);

if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
    showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
	isFormSignatureOfThisJsp = Util.null2String(RecordSet.getString("isFormSignature"));
	formSignatureWidthOfThisJsp= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeightOfThisJsp= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
    if(user.getLanguage() == 8){
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnameen"));
    }
    else if(user.getLanguage() == 9){
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnametw"));
    }
    else {
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnamecn"));
    }
    isSignMustInputOfThisJsp = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}
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
}
session.setAttribute(userid+"_"+logintype+"username",username);
session.setAttribute(userid+"_"+workflowid+"workflowname",workflowname);
session.setAttribute(userid+"_"+workflowid+"isannexupload",isannexupload);
session.setAttribute(userid+"_"+workflowid+"annexdocCategory",annexdocCategory);     
session.setAttribute(userid+"_"+requestid+"nodeid",""+nodeid);
boolean IsFreeWorkflow=WFForwardManager.getIsFreeWorkflow(Util.getIntValue(requestid),Util.getIntValue(nodeid),0);
boolean isImportDetail=RequestDetailImport.getAllowesImport(Util.getIntValue(requestid),Util.getIntValue(workflowid),Util.getIntValue(nodeid),0,user);


String createpage = "";//TD11055 DS 下面需要公用，定义移到上面
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
</head>
<BODY >
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
User user2=new User();
if(isagent == 1){
	user2.setUid(beagenter);
}else{
	user2.setUid(user.getUID());
}
WorkflowManage.setUser(user2);
WorkflowManage.setWorkflowid(workflowid);
boolean isSbmit = WorkflowManage.isSubmit();
if(!isSbmit){
%>
<script type="text/javascript">
function document.onreadystatechange(){
	if (document.readyState=="complete") {
		alert("<%=SystemEnv.getHtmlLabelName(27566,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22938,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(594,user.getLanguage())%>！");
		window.close();
	}
}
</script>
<%} %>
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
String newCHATSName = "";//新建微信按钮(QC:98106)
String haswfrm = "";//是否使用新建流程按钮
String hassmsrm = "";//是否使用新建短信按钮
String haschats = "";//是否使用新建微信按钮(QC:98106)
int t_workflowid = 0;//新建流程的ID
int subbackCtrl = 0;
String strBar = "[";//菜单
if(RecordSet.next()){
	if(user.getLanguage() == 7){
		submitName = Util.null2String(RecordSet.getString("submitName7"));
		saveName = Util.null2String(RecordSet.getString("saveName7"));
		newWFName = Util.null2String(RecordSet.getString("newWFName7"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName7"));
		newCHATSName = Util.null2String(RecordSet.getString("newCHATSName7"));//微信提醒(QC:98106)
		subnobackName = Util.null2String(RecordSet.getString("subnobackName7"));
		subbackName = Util.null2String(RecordSet.getString("subbackName7"));
	}else if(user.getLanguage() == 9){
		submitName = Util.null2String(RecordSet.getString("submitName9"));
		saveName = Util.null2String(RecordSet.getString("saveName9"));
		newWFName = Util.null2String(RecordSet.getString("newWFName9"));
		newCHATSName = Util.null2String(RecordSet.getString("newCHATSName9"));//微信提醒(QC:98106)
		newSMSName = Util.null2String(RecordSet.getString("newSMSName9"));
		subnobackName = Util.null2String(RecordSet.getString("subnobackName9"));
		subbackName = Util.null2String(RecordSet.getString("subbackName9"));
	}
	else{
		submitName = Util.null2String(RecordSet.getString("submitName8"));
		saveName = Util.null2String(RecordSet.getString("saveName8"));
		newWFName = Util.null2String(RecordSet.getString("newWFName8"));
		newCHATSName = Util.null2String(RecordSet.getString("newCHATSName8"));//微信提醒(QC:98106)
		newSMSName = Util.null2String(RecordSet.getString("newSMSName8"));
		subnobackName = Util.null2String(RecordSet.getString("subnobackName8"));
		subbackName = Util.null2String(RecordSet.getString("subbackName8"));
	}
	haswfrm = "0";//新建节点未保存，不显示新建流程菜单 Util.null2String(RecordSet.getString("haswfrm"));
	hassmsrm = Util.null2String(RecordSet.getString("hassmsrm"));
	hasnoback = Util.null2String(RecordSet.getString("hasnoback"));
	hasback = Util.null2String(RecordSet.getString("hasback"));
	haschats = Util.null2String(RecordSet.getString("haschats"));//微信提醒(QC:98106)
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
		RCMenu += "{"+submitName+",javascript:bodyiframe.doSubmitBack(this),_self}";
		RCMenuHeight += RCMenuHeightStep;
        strBar += "{text: '"+submitName+"',iconCls:'btn_submit',handler: function(){bodyiframe.doSubmitBack(this);}},";
	}else{
		RCMenu += "{"+submitName+",javascript:bodyiframe.doAffirmanceBack(this),_self}";
		RCMenuHeight += RCMenuHeightStep;
        strBar += "{text: '"+submitName+"',iconCls:'btn_submit',handler: function(){bodyiframe.doAffirmanceBack(this);}},";
	}
}else{//必须至少有一个按钮

	if(!needAffirmance.equals("1")){
		if(!"1".equals(hasnoback)){
			RCMenu += "{"+subbackName+",javascript:bodyiframe.doSubmitBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
            strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doSubmitBack(this);}},"; 
		}else{
			if("1".equals(hasback)){
				RCMenu += "{"+subbackName+",javascript:bodyiframe.doSubmitBack(this),_self}";
				RCMenuHeight += RCMenuHeightStep;
                strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doSubmitBack(this);}},";
			}
			RCMenu += "{"+subnobackName+",javascript:bodyiframe.doSubmitNoBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
            strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doSubmitNoBack(this);}},";
		}
	}else{
		if(!"1".equals(hasnoback)){
			RCMenu += "{"+subbackName+",javascript:bodyiframe.doAffirmanceBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
            strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doAffirmanceBack(this);}},"; 
		}else{
			if("1".equals(hasback)){
				RCMenu += "{"+subbackName+",javascript:bodyiframe.doAffirmanceBack(this),_self}";
				RCMenuHeight += RCMenuHeightStep;
                strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doAffirmanceBack(this);}},"; 
			}
			RCMenu += "{"+subnobackName+",javascript:bodyiframe.doAffirmanceNoBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doAffirmanceNoBack(this);}},";
		}
	}
}
if(IsFreeWorkflow){
    RCMenu += "{"+FreeWorkflowname+",javascript:bodyiframe.doFreeWorkflow(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    if(WFForwardManager.judgeIsFreeWorkflow(Util.getIntValue(workflowid)))
    	strBar += "{text: '"+FreeWorkflowname+"',iconCls:'btn_freeWf',handler: function(){bodyiframe.doFreeWorkflow(this);}},";
}
if(isImportDetail){
    strBar += "{text: '"+SystemEnv.getHtmlLabelName(26255,user.getLanguage())+"',iconCls:'btn_edit',handler: function(){bodyiframe.doImportDetail();}},";
}

if("1".equals(importwf)){
    strBar += "{text: '"+SystemEnv.getHtmlLabelName(24270,user.getLanguage())+"',iconCls:'btn_edit',handler: function(){bodyiframe.doImportWorkflow(this);}},";
}
RCMenu += "{"+saveName+",javascript:bodyiframe.doSave_nNew(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+saveName+"',iconCls:'btn_wfSave',handler: function(){bodyiframe.doSave_nNew();}},";
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
		RCMenu += "{"+newWFName+",javascript:bodyiframe.onNewRequest("+t_workflowid+",0),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
        strBar += "{text: '"+newWFName+"',iconCls:'btn_newWFName',handler: function(){bodyiframe.onNewRequest("+t_workflowid+",0);}},";
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
if(valid == true && "1".equals(hassmsrm) && HrmUserVarify.checkUserRight("CreateSMS:View", user)){
	for(int i = 0; i < newMenuList1.size(); i++) {
		HashMap newMenuMap = (HashMap) newMenuList1.get(i);
		int menuid = (Integer) newMenuMap.get("id");
		if(menuid > 0) {
			newSMSName = (String) newMenuMap.get("newName");
	if("".equals(newSMSName)){
		newSMSName = SystemEnv.getHtmlLabelName(16444,user.getLanguage()) + (i + 1);
	}
	RCMenu += "{"+newSMSName+",javascript:bodyiframe.onNewSms("+workflowid+", "+nodeid+", " + menuid + "),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+newSMSName+"',iconCls:'btn_newSMSName',handler: function(){bodyiframe.onNewSms("+workflowid+", "+nodeid+", " + menuid + ");}},";
		}
	}
}
//收藏
strBar +="{text: '"+SystemEnv.getHtmlLabelName(22255,user.getLanguage())+"',iconCls:'btn_collect',handler: function(){openFavouriteBrowser();}},";
//帮助
strBar +="{text: '"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+"',iconCls:'btn_help',handler: function(){showHelp();}},";
//微信提醒START(QC:98106)
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
	strBar += "{text: '"+newCHATSName+"',iconCls:'btn_newChatsName',handler: function(){bodyiframe.onNewChats("+workflowid+", "+nodeid+", "+requestid+", " + menuid + ");}},";
		}
	}
}
//微信提醒END(QC:98106)
if(strBar.lastIndexOf(",")>-1) strBar = strBar.substring(0,strBar.lastIndexOf(","));
strBar+="]";
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/workflow/request/RequestShowHelpDoc.jsp" %>
		<input type=hidden name=_isagent id="_isagent" value="<%=isagent%>">
        <input type=hidden name=_beagenter id="_beagenter" value="<%=beagenter%>">
		<input type=hidden name=isworkflowdoc id="isworkflowdoc" value="<%=isworkflowdoc%>">
		<input type=hidden name=picInnerFrameurl id="picInnerFrameurl" value="WorkflowRequestPictureInner.jsp?fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&f_weaver_belongto_userid=<%=request.getParameter("f_weaver_belongto_userid") %>">
		<input type=hidden name=statInnerFrameurl id="statInnerFrameurl" value="WorkflowRequestPicture.jsp?hasExt=true&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&f_weaver_belongto_userid=<%=request.getParameter("f_weaver_belongto_userid") %>">
		<%@ include file="/workflow/request/NewRequestFrame.jsp" %>
</body>
</html>
<script language="JavaScript">
function oc_CurrentMenuOnMouseOut(icount) {
	jQuery($GetEle("oc_divMenuDivision" + icount)).css("visibility", "hidden");
}
function oc_CurrentMenuOnClick(icount) {
	jQuery($GetEle("oc_divMenuDivision" + icount)).css("visibility", "");
}
</script>

<script language="JavaScript">
	var bodyiframeurl = location.href.substring(location.href.indexOf("AddRequest.jsp?")+15);
	var piciframe = "WorkflowRequestPictureInner.jsp?fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&f_weaver_belongto_userid=<%=request.getParameter("f_weaver_belongto_userid") %>&f_weaver_belongto_usertype=<%=request.getParameter("f_weaver_belongto_usertype") %>";
	function setbodyiframe(){
		document.getElementById("bodyiframe").src="AddRequestIframe.jsp?"+bodyiframeurl+"&isfromtab=<%=isfromtab%>&fromFlowDoc=<%=fromFlowDoc%>&prjid=<%=prjid%>&docid=<%=docid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&reqid=<%=reqid%>&topage="+escape("<%=topage%>") + "&f_weaver_belongto_userid=<%=request.getParameter("f_weaver_belongto_userid") %>&f_weaver_belongto_usertype=<%=request.getParameter("f_weaver_belongto_usertype") %>";
		//initNewRequestFrame();
		initNewRequestFrame1();
		//eventPush(document.getElementById('bodyiframe'),'load',loadcomplete);
		//document.getElementById("piciframe").src=piciframe;
		<%
		String docfileid_xx = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
		String newdocid_xx = Util.null2String(request.getParameter("newdocid"));        // 新建的文档	
		String uselessFlag = Util.null2String(request.getParameter("uselessFlag"));
		//System.out.println("--------4------docfileid_xx="+docfileid_xx+",newdocid_xx="+newdocid_xx+",uselessFlag="+uselessFlag+",isOpenTextTab="+isOpenTextTab);
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
	
</script>