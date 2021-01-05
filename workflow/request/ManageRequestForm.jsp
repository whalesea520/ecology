<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.rtx.RTXConfig" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />

<%
String newfromdate="a";
String newenddate="b";
String viewdoc = Util.null2String(request.getParameter("viewdoc"));

int salesMessage = Util.getIntValue(request.getParameter("salesMessage"),-1);
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
String message = Util.null2String(request.getParameter("message"));  // 返回的错误信息

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
String status = "" ;     //当前的操作类型

String needcheck="requestname";

String topage = Util.null2String(request.getParameter("topage")) ;        //返回的页面


// 工作流新建文档的处理
String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
// modify by xhheng @2004-12-16 FOR TD1421  
String newdocid = Util.null2String(request.getParameter("newdocid"));        // 新建的文档



String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
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

// 当前用户表中该请求对应的信息 isremark为0为当前操作者, isremark为1为当前被转发者,isremark为2为可跟踪查看者

RecordSet.executeProc("workflow_currentoperator_SByUs",userid+""+flag+usertype+flag+requestid+"");
while(RecordSet.next())	{
    int tempisremark = Util.getIntValue(RecordSet.getString("isremark"),0) ;
    if( tempisremark == 0 ) {                       // 当前操作者或被转发者

        isremark = tempisremark ;
        break ;
    }
    if( tempisremark == 1 ) isremark = tempisremark ;
}
if( isremark != 0 && isremark != 1 ) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}

// 查询请求的相关工作流基本信息
RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){
    status = Util.null2String(RecordSet.getString("status")) ;
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
    workflowtype = WorkflowComInfo.getWorkflowtype(workflowid+"");
}


RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
if(RecordSet.next()){
	isreopen=RecordSet.getString("isreopen");
	isreject=RecordSet.getString("isreject");
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

// 记录查看日志
String clientip = request.getRemoteAddr();
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;


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
" and nodeid = " + nodeid + " and requestid = " + requestid + " and isremark in ('0','1','4') and usertype = " + usertype);
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



if(! nodetype.equals("3") )
    RecordSet.executeProc("SysRemindInfo_DeleteHasnewwf",""+userid+flag+usertype+flag+requestid);
else
    RecordSet.executeProc("SysRemindInfo_DeleteHasendwf",""+userid+flag+usertype+flag+requestid);

String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(18015,user.getLanguage())+":"
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage())+ " - " + status + " "+requestmark;//Modify by 杨国生 2004-10-26 For TD1231
String needfav ="1";
String needhelp ="";
//if(helpdocid !=0 ) {titlename=titlename + "<img src=/images/help_wev8.gif style=\"CURSOR:hand\" width=12 onclick=\"location.href='/docs/docs/DocDsp.jsp?id="+helpdocid+"'\">";}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<SCRIPT language=VBS>

Sub oc_CurrentMenuOnMouseOut(icount)
    document.getElementById("oc_divMenuDivision"&icount).style.visibility = "hidden"
End Sub

Sub oc_CurrentMenuOnClick(icount)
    document.getElementById("oc_divMenuDivision"&icount).style.visibility = ""
End Sub
</SCRIPT>

<script language="javascript">
var isfirst = 0 ;

function displaydiv()
{
    if(oDiv.style.display == ""){
        oDiv.style.display = "none";
        spanimage.innerHTML = "<img src='/images/ArrowDownRed_wev8.gif' border=0>" ;
    }
    else{
        if(isfirst == 0) {
            document.getElementById("picframe").src="/workflow/request/WorkflowRequestPicture.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>";

            isfirst ++ ;
        }

        spanimage.innerHTML = "<img src='/images/ArrowUpGreen_wev8.gif' border=0>" ;
        oDiv.style.display = "";
    }
}
</SCRIPT>


<body  id="flowbody">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%//TD9145
String submitname = "" ; // 提交按钮的名称 : 创建, 审批, 实现
String forwardName = "";//转发
String saveName = "";//保存
String rejectName = "";//退回

String forsubName = "";//转发提交
String ccsubName = "";//抄送提交

String newWFName = "";//新建流程按钮
String newSMSName = "";//新建短信按钮
String haswfrm = "";//是否使用新建流程按钮
String hassmsrm = "";//是否使用新建短信按钮
int t_workflowid = 0;//新建流程的ID
String sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+nodeid;
if(isremark != 0){
	RecordSet.executeSql("select nodeid from workflow_currentoperator c where c.requestid="+requestid+" and c.userid="+userid+" and c.usertype="+usertype+" and c.isremark='"+isremark+"' ");
	int tmpnodeid = 0;
	if(RecordSet.next()){
		tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"), 0);
	}
	sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+tmpnodeid;
}

RecordSet.executeSql(sqlselectName);

if(RecordSet.next()){
	if(user.getLanguage() == 7){
		submitname = Util.null2String(RecordSet.getString("submitname7"));
		forwardName = Util.null2String(RecordSet.getString("forwardName7"));
		saveName = Util.null2String(RecordSet.getString("saveName7"));
		rejectName = Util.null2String(RecordSet.getString("rejectName7"));
		forsubName = Util.null2String(RecordSet.getString("forsubName7"));
		ccsubName = Util.null2String(RecordSet.getString("ccsubName7"));
		newWFName = Util.null2String(RecordSet.getString("newWFName7"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName7"));
	}
	else if(user.getLanguage() == 9){
		submitname = Util.null2String(RecordSet.getString("submitname9"));
		forwardName = Util.null2String(RecordSet.getString("forwardName9"));
		saveName = Util.null2String(RecordSet.getString("saveName9"));
		rejectName = Util.null2String(RecordSet.getString("rejectName9"));
		forsubName = Util.null2String(RecordSet.getString("forsubName9"));
		ccsubName = Util.null2String(RecordSet.getString("ccsubName9"));
		newWFName = Util.null2String(RecordSet.getString("newWFName9"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName9"));
	}
	else{
		submitname = Util.null2String(RecordSet.getString("submitname8"));
		forwardName = Util.null2String(RecordSet.getString("forwardName8"));
		saveName = Util.null2String(RecordSet.getString("saveName8"));
		rejectName = Util.null2String(RecordSet.getString("rejectName8"));
		forsubName = Util.null2String(RecordSet.getString("forsubName8"));
		ccsubName = Util.null2String(RecordSet.getString("ccsubName8"));
		newWFName = Util.null2String(RecordSet.getString("newWFName8"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName8"));
	}
	haswfrm = Util.null2String(RecordSet.getString("haswfrm"));
	hassmsrm = Util.null2String(RecordSet.getString("hassmsrm"));
	t_workflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
}
if(isremark == 1){
	submitname = forsubName;
}
if(isremark == 9){
	submitname = ccsubName;
}
if("".equals(forwardName)){
	forwardName = SystemEnv.getHtmlLabelName(6011,user.getLanguage());
}
if("".equals(saveName)){
	saveName = SystemEnv.getHtmlLabelName(86,user.getLanguage());
}
if("".equals(rejectName)){
	rejectName = SystemEnv.getHtmlLabelName(236,user.getLanguage());
}
if("".equals(submitname)){
	if(nodetype.equals("0") || isremark == 1 )	{
		submitname = SystemEnv.getHtmlLabelName(615,user.getLanguage());      // 创建节点或者转发, 为提交

	}else if(nodetype.equals("1")){
		submitname = SystemEnv.getHtmlLabelName(142,user.getLanguage());  // 审批
	}else if(nodetype.equals("2")){
		submitname = SystemEnv.getHtmlLabelName(725,user.getLanguage());  // 实现
	}
}

%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<% if(isremark == 1){ 

RCMenu += "{"+submitname+",javascript:doRemark(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

} else { 

RCMenu += "{"+submitname+",javascript:doSubmit(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+forwardName+",Remark.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+requestid+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+saveName+",javascript:doSave(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

  if(isreopen.equals("1") && false ){

RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:doReopen(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
  }
  if( isreject.equals("1") ){

RCMenu += "{"+rejectName+",javascript:doReject(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
  }
  if(nodetype.equals("0") &&isremark != 1 && isremark != 9 && isremark != 5&&WfFunctionManageUtil.IsShowDelButtonByReject(requestid,workflowid)){    // 创建节点(退回创建节点也是) 

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
  }
}
/*TD9145 START*/
if("1".equals(haswfrm)){
	if("".equals(newWFName)){
		newWFName = SystemEnv.getHtmlLabelName(1239,user.getLanguage());
	}
	RequestCheckUser.setUserid(userid);
	RequestCheckUser.setWorkflowid(t_workflowid);
	RequestCheckUser.setLogintype(logintype);
	RequestCheckUser.checkUser();
	int  t_hasright=RequestCheckUser.getHasright();
	if(t_hasright == 1){
		RCMenu += "{"+newWFName+",javascript:onNewRequest("+t_workflowid+", "+requestid+",0),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
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
	if("".equals(newSMSName)){
		newSMSName = SystemEnv.getHtmlLabelName(16444,user.getLanguage());
	}
	RCMenu += "{"+newSMSName+",javascript:onNewSms("+workflowid+", "+nodeid+", "+requestid+"),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
/*TD9145 END*/
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",RequestView.jsp,_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

    <table width="100%">
        <tr><td width="80%" align=left>
        <% if( message.equals("1") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(16332,user.getLanguage())%></font>
        <% } else if( message.equals("2") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(16333,user.getLanguage())%></font>
		<%}%>
		<font color=red><%=Util.null2String(SystemEnv.getHtmlLabelName(salesMessage,user.getLanguage()))%></font>
        </td>
        <td width="20%" align=right>
        <% if(helpdocid !=0 ) {%>
        <img src="/images/help_wev8.gif" style="CURSOR:hand" width=12 onclick="showWFHelp(<%=helpdocid%>)">
        <%}%>
        <a href="#" onClick="displaydiv()">
            <SPAN id=spanimage><img src="/images/ArrowDownRed_wev8.gif" border=0></span>
        </a>
        </td></tr>
    </table>

<div  id=oDiv style="display:none"  width="100%">
<TABLE border=0 cellpadding=0 cellspacing=0 width="100%"><TR><TD ID='IMAGETD'></TD></TR></TABLE>
<BR>
</div>

<DIV>
<iframe ID="picframe" BORDER=0 FRAMEBORDER=no height="0%" width="0%" scrolling="NO" src=""></iframe>
</DIV>


<%
String managepage= "";
String operationpage = "" ;
if(isbill.equals("1")){
    RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
    if(RecordSet.next()) {
        managepage = Util.null2String(RecordSet.getString("managepage"));
        operationpage = Util.null2String(RecordSet.getString("operationpage"));
    }
}
if( !managepage.equals("")) {
%>
<jsp:include page="<%=managepage%>" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="requestmark" value="<%=requestmark%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isreopen" value="<%=isreopen%>" />
    <jsp:param name="isreject" value="<%=isreject%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="docfileid" value="<%=docfileid%>" />
    <jsp:param name="newdocid" value="<%=newdocid%>" />
</jsp:include>
<%}else{
    if( operationpage.equals("") ) operationpage = "RequestOperation.jsp" ;
%>
<form name="frmmain" method="post" action="<%=operationpage%>">
    <%@ include file="WorkflowManageRequestFormBody.jsp" %>
    <%@ include file="WorkflowManageSign.jsp" %>
</form>
<%}%>
<!-- modify by xhheng @20050304 for TD 1691 -->
<a href='javascript:openSignPrint();'><%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%></a>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
function showWFHelp(docid){
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    var operationPage = "/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id="+docid;
    window.open(operationPage,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}
// modify by xhheng @20050304 for TD 1691
function openSignPrint() {
    window.open("PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&isprint=1", "", "toolbar,resizable,scrollbars,dependent,height=500,width=550");
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
function onNewSms(wfid, nodeid, reqid){
	var redirectUrl =  "/sms/SendRequestSms.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&workflowid="+wfid+"&nodeid="+nodeid+"&reqid="+reqid;
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
</SCRIPT>