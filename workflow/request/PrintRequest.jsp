
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*,weaver.conn.*" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.worktask.worktask.*,java.text.*" %>
<%@ page import="weaver.workflow.request.SubWorkflowManager" %>
<%@page import="weaver.workflow.request.RequestShare"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet5" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td3665 on 20060227--%>
<jsp:useBean id="rs_1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/><!--xwj for td3450 20060112-->
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page" /><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" /><!--xwj for td3665 20060224-->
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<jsp:useBean id="wfShareAuthorization" class="weaver.workflow.request.WFShareAuthorization" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>

<jsp:useBean id="DateUtil" class="weaver.general.DateUtil" scope="page"/>
 
<%----xwj for td3665 20060301 begin---%>
<%
String info = (String)request.getParameter("infoKey");
int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
//if(0==0){
//out.println("<script>window.opener.btnWfCenterReload.onclick()</script>");
//return;
//}
%>
<script language="JavaScript">
<%if(isovertime==1){%>
        window.opener.location.href=window.opener.location.href;
<%}%>
<%if(info!=null && !"".equals(info)){

  if("ovfail".equals(info)){%>
 alert("<%=SystemEnv.getHtmlLabelName(18566,user.getLanguage())%>")
 <%}
 else if("rbfail".equals(info)){%>
 alert("<%=SystemEnv.getHtmlLabelName(18567,user.getLanguage())%>")
 <%}
 else{
 
 }
 }%>
</script>
<%----xwj for td3665 20060301 end---%>

<%
boolean isnotprintmode =Util.null2String(request.getParameter("isnotprintmode")).equals("1")?true:false;
boolean usePrePrint = false;	//Html模式在IE下启用预览模式打印

String ismultiprintmode = Util.null2String(request.getParameter("ismultiprintmode"));   //是否是批量打印

String reEdit=""+Util.getIntValue(request.getParameter("reEdit"),1);//是否为编辑

String isprintlogMode=Util.null2String(request.getParameter("isprintlogMode")); //


int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String isrequest = Util.null2String(request.getParameter("isrequest")); //
String nodetypedoc=Util.null2String(request.getParameter("nodetypedoc"));
int desrequestid=0;
int wflinkno=Util.getIntValue(request.getParameter("wflinkno"));
boolean isprint = Util.null2String(request.getParameter("isprint")).equals("1")?true:false;
String fromoperation=Util.null2String(request.getParameter("fromoperation"));

String fromPDA = Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录
//TD4262 增加提示信息  开始


String src=Util.null2String(request.getParameter("src"));//进入该界面前的操作，"submit"：提交，"reject"：退回。


String isShowPrompt=Util.null2String(request.getParameter("isShowPrompt"));//是否显示提示  取值"true"或者"false"
//TD4262 增加提示信息  结束

String requestname="";      //请求名称
String requestlevel="";     //请求重要级别 0:正常 1:重要 2:紧急


String requestmark = "" ;   //请求编号
String isbill="0";          //是否单据 0:否 1:是


int creater=0;              //请求的创建人
int creatertype = 0;        //创建人类型 0: 内部用户 1: 外部用户
int deleted=0;              //请求是否删除  1:是 0或者其它 否


int billid=0 ;              //如果是单据,对应的单据表的id
String isModifyLog = "";		//是否记录表单日志 by cyril on 2008-07-09 for TD:8835

int workflowid=0;           //工作流id
String workflowtype = "" ;  //工作流种类


int formid=0;               //表单或者单据的id
int helpdocid = 0;          //帮助文档 id
String workflowname = "" ;         //工作流名称


String status = ""; //当前的操作类型


String docCategory="";//工作流目录


int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;
int nodeid=WFLinkInfo.getCurrentNodeid(requestid,userid,Util.getIntValue(logintype,1));               //节点id
String nodetype=WFLinkInfo.getNodeType(nodeid);         //节点类型  0:创建 1:审批 2:实现 3:归档

//当前流程所处节点id和类型，用于判断是否有强制归档权限TD9023
String currentnodetype = "";
int currentnodeid = 0;

boolean canview = false ;               // 是否可以查看
boolean canactive = false ;             // 是否可以对删除的工作流激活


boolean isurger=false;                  //督办人可查看
boolean wfmonitor=false;                //流程监控人


boolean haveBackright=false;            //强制收回权限
//boolean haveOverright=false;            //强制归档权限

String sql = "" ;
char flag = Util.getSeparator() ;
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
if(isrequest.equals("1")){      // 从相关工作流过来,有查看权限


    //requestid=Util.getIntValue(String.valueOf(session.getAttribute("resrequestid"+wflinkno)),0);
    requestid = RequestShare.parserRequestidinfo(request);
    String realateRequest=Util.null2String(String.valueOf(session.getAttribute("relaterequest")));
	if (requestid==0&&realateRequest.equals("new"))  requestid=Util.getIntValue(request.getParameter("requestid"),0);
	int tempnum_ = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
	for(int cx_=0; cx_<=tempnum_; cx_++){
		//int resrequestid_ = Util.getIntValue(String.valueOf(session.getAttribute("resrequestid"+cx_)));
		int resrequestid_ = RequestShare.parserRequestidinfo(Util.null2String(session.getAttribute("resrequestid" + cx_)));
		if(resrequestid_ == requestid){
			desrequestid=Util.getIntValue(String.valueOf(session.getAttribute("desrequestid")),0);//父级流程ID
			rs.executeSql("select count(*) from workflow_currentoperator where userid="+userid+" and usertype="+usertype+" and requestid="+desrequestid);
		    if(rs.next()){
		        int counts=rs.getInt(1);
		        if(counts>0){
		            //获取父流程ID
		            int preqid = RequestShare.parserParentRequestidinfo(Util.null2String(session.getAttribute("resrequestid" + cx_)));
		            boolean hasviewright = RequestShare.requestRightCheck(userid, usertype, String.valueOf(requestid), 1, String.valueOf(preqid), null);
					if (hasviewright) {
					    canview=true;
					    break;
					}
		        }
		    }
		    if(!canview && desrequestid!=0){
		    	canview = wfShareAuthorization.getWorkflowShareJurisdiction(String.valueOf(desrequestid),user);
		    }
		}
	}
    session.setAttribute(requestid+"wflinkno",wflinkno+"");//解决相关流程，不是流程操作人无权限打印的问题    
}

//只有是主子流程查看时，才去验证权限


if (isrequest.equals("2") || isrequest.equals("3") || isrequest.equals("4")) {
	canview = SubWorkflowManager.hasRelation(request);
}

String reportid = Util.null2String(request.getParameter("reportid"));
String isfromreport = Util.null2String(request.getParameter("isfromreport"));
String isfromflowreport = Util.null2String(request.getParameter("isfromflowreport"));
if(isfromreport.equals("1") &&  requestid != 0){
	if(!canview){
		canview = ReportAuthorization.checkReportPrivilegesByRequest(request,user);
	}
}

if(isfromflowreport.equals("1") &&  requestid != 0){
	if(!canview){
		canview = ReportAuthorization.checkFlowReportByRequest(request,user);
	}
}

//从计划任务页面过来，有查看权限 Start
int isworktask = Util.getIntValue(request.getParameter("isworktask"), 0);
if(isworktask == 1){
	int haslinkworktask = Util.getIntValue((String)session.getAttribute("haslinkworktask"), 0);
	if(haslinkworktask == 1){
		int tlinkwfnum = Util.getIntValue((String)session.getAttribute("tlinkwfnum"), 0);
		int i_tmp = 0;
		for(i_tmp=0; i_tmp<tlinkwfnum; i_tmp++){
			int retrequestid = Util.getIntValue((String)session.getAttribute("retrequestid"+i_tmp), 0);
			if(retrequestid != requestid){
				session.removeAttribute("retrequestid"+i_tmp);
				session.removeAttribute("deswtrequestid"+i_tmp);
				continue;
			}
			int deswtrequestid = Util.getIntValue((String)session.getAttribute("deswtrequestid"+i_tmp), 0);
			rs.execute("select * from worktask_requestbase where requestid="+deswtrequestid);
			if(rs.next()){
				int wt_id = Util.getIntValue(rs.getString("taskid"), 0);
				int wt_status = Util.getIntValue(rs.getString("status"), 1);
				int wt_creater = Util.getIntValue(rs.getString("creater"), 0);
				int wt_needcheck = Util.getIntValue(rs.getString("needcheck"), 0);
				int wt_checkor = Util.getIntValue(rs.getString("checkor"), 0);
				int wt_approverequest = Util.getIntValue(rs.getString("approverequest"), 0);
				if(wt_needcheck == 0){
					wt_checkor = 0;
				}
				WTRequestManager wtRequestManager = new WTRequestManager(wt_id);
				wtRequestManager.setLanguageID(user.getLanguage());
				wtRequestManager.setUserID(user.getUID());
				Hashtable checkRight_hs = wtRequestManager.checkRight(deswtrequestid, wt_status, 0, wt_creater, wt_checkor, wt_approverequest);
				boolean canView_tmp = false;
				canView_tmp = (Util.null2String((String)checkRight_hs.get("canView"))).equalsIgnoreCase("true")?true:false;
				if(canView_tmp==false){
					checkRight_hs = wtRequestManager.checkTemplateRight(deswtrequestid, wt_status, 0, wt_creater, wt_checkor, wt_approverequest);
					canView_tmp = (Util.null2String((String)checkRight_hs.get("canView"))).equalsIgnoreCase("true")?true:false;
				}
				if(canView_tmp == true){
					canview = canView_tmp;
				}
			}
			session.removeAttribute("retrequestid"+i_tmp);
			session.removeAttribute("deswtrequestid"+i_tmp);
			session.setAttribute("haslinkworktask", "0");
			session.setAttribute("tlinkwfnum", "0");
			continue;
		}
	}

}
//从计划任务页面过来，有查看权限 End
ArrayList canviewwff = (ArrayList)session.getAttribute("canviewwf");
if(canviewwff!=null)
   if(canviewwff.indexOf(requestid+"")>-1)
         canview = true;

if(creater == userid && creatertype == usertype){   // 创建者本人有查看权限
	canview=true;
	canactive=true;
}

// 检查用户查看权限


// 检查用户是否可以查看和激活该工作流 (激活即是对删除的工作流,将删除状态改为删除前的状态)
// canview = HrmUserVarify.checkUserRight("ViewRequest:View", user);   //有ViewRequest:View权限的人可以查看全部工作流


// canactive = HrmUserVarify.checkUserRight("ViewRequest:Active", user);   //有ViewRequest:Active权限的人可以查看全部工作流


   

// 当前用户表中该请求对应的信息 isremark为0为当前操作者, isremark为1为当前被转发者,isremark为2为可跟踪查看者,isremark=5为干预人
//RecordSet.executeProc("workflow_currentoperator_SByUs",userid+""+flag+usertype+flag+requestid+"");
int preisremark=0;
String isremarkForRM = "";
RecordSet.executeSql("select isremark,isreminded,preisremark from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by isremark");
boolean istoManagePage=false;   //add by xhheng @20041217 for TD 1438
while(RecordSet.next())	{
    String isremark = Util.null2String(RecordSet.getString("isremark")) ;
	isremarkForRM = isremark;
    preisremark=Util.getIntValue(RecordSet.getString("preisremark"),0) ;
    //modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直需要处理即使流程已归档
    if( isremark.equals("1")||isremark.equals("5") || isremark.equals("8")|| isremark.equals("9") ||(isremark.equals("0")  && !nodetype.equals("3")) ) {
      //modify by xhheng @20041217 for TD 1438
      istoManagePage=true;
      canview=true;
      break;
    }
    canview=true;
}

//有查看流程权限时，加入主子流程相关的查看权限
if(canview){
	SubWorkflowManager.loadRelatedRequest(request);
}

String iswfshare = Util.null2String(request.getParameter("iswfshare"));
if(!canview && iswfshare.equals("1")){
	canview = wfShareAuthorization.getWorkflowShareJurisdiction(String.valueOf(requestid),user);
}

//add by mackjoe at 2006-04-24 td3994
int urger=Util.getIntValue(request.getParameter("urger"),0);
session.setAttribute(userid+""+requestid+"urger",""+urger);    
if(!canview || urger==1) isurger=WFUrgerManager.UrgerHaveWorkflowViewRight(requestid,userid,Util.getIntValue(logintype,1));
int ismonitor=Util.getIntValue(request.getParameter("ismonitor"),0);
session.setAttribute(userid+""+requestid+"ismonitor",""+ismonitor);    
if(!canview&&!isurger) wfmonitor=WFUrgerManager.getMonitorViewRight(requestid,userid); 
PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,10,(logintype).equals("1") ? "0" : "1",requestid);  
if(!canview && !isurger && !wfmonitor && !CoworkDAO.haveRightToViewWorkflow(Integer.toString(userid),Integer.toString(requestid))) {
    if(!WFUrgerManager.UrgerHaveWorkflowViewRight(desrequestid,userid,Util.getIntValue(logintype,1)) && !WFUrgerManager.getMonitorViewRight(desrequestid,userid)){//督办流程和监控流程的相关流程有查看权限


        response.sendRedirect("/notice/noright.jsp?isovertime="+isovertime);
        return ;
    }
}
// 查询请求的相关工作流基本信息
RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){
    status  = Util.null2String(RecordSet.getString("status")) ;
    requestname= Util.null2String(RecordSet.getString("requestname")) ;
	requestlevel = Util.null2String(RecordSet.getString("requestlevel"));
    requestmark = Util.null2String(RecordSet.getString("requestmark")) ;
    creater = Util.getIntValue(RecordSet.getString("creater"),0);
	creatertype = Util.getIntValue(RecordSet.getString("creatertype"),0);
    deleted = Util.getIntValue(RecordSet.getString("deleted"),0);
	workflowid = Util.getIntValue(RecordSet.getString("workflowid"),0);
	currentnodeid = Util.getIntValue(RecordSet.getString("currentnodeid"),0);
    if(nodeid<1) nodeid = currentnodeid;
	currentnodetype = Util.null2String(RecordSet.getString("currentnodetype"));
    if(nodetype.equals("")) nodetype = currentnodetype;
    docCategory=Util.null2String(RecordSet.getString("docCategory"));
    workflowname = WorkflowComInfo.getWorkflowname(workflowid+"");
    workflowname = Util.processBody(workflowname,user.getLanguage()+"");
    workflowtype = WorkflowComInfo.getWorkflowtype(workflowid+"");
}
if(urger==1 && isurger==true){//流程督办的入口，并且具有督办查看流程表单的权限


	nodeid = currentnodeid;
	nodetype = currentnodetype;
}
String isaffirmance=WorkflowComInfo.getNeedaffirmance(""+workflowid);//是否需要提交确认


//TD8715 获取工作流信息，是否显示流程图


WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String isShowChart = Util.null2String(WFManager.getIsShowChart());
//System.out.println("isShowChart = " + isShowChart);
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");
if(RecordSet.next()){
	isModifyLog = Util.null2String(RecordSet.getString("isModifyLog"));//by cyril on 2008-07-09 for TD:8835
	formid = Util.getIntValue(RecordSet.getString("formid"),0);
	isbill = ""+Util.getIntValue(RecordSet.getString("isbill"),0);
	helpdocid = Util.getIntValue(RecordSet.getString("helpdocid"),0);
}

session.setAttribute(userid+""+requestid+"isaffirmance",isaffirmance);
session.setAttribute(userid+""+requestid+"reEdit",reEdit);
//判断是否有流程创建文档，并且在该节点是有正文字段
boolean docFlag=flowDoc.haveDocFiled(""+workflowid,""+nodeid);
String  docFlagss=docFlag?"1":"0";
session.setAttribute("requestAdd"+requestid,docFlagss);
if (!fromFlowDoc.equals("1"))
{
if (docFlag)
{ if (fromoperation.equals("1"))
	{

	if (!nodetypedoc.equals("0")) {
	%>
	<script>
		<%if("1".equals(isShowChart)){%>
	 //setTimeout("window.close()",1);
     //window.opener._table.reLoad();
try{	
	window.opener.btnWfCenterReload.onclick();
}catch(e){}

try{
	window.opener._table.reLoad();
}catch(e){}
try{
   	parent.window.taskCallBack(2,<%=preisremark%>); 
}catch(e){}
     window.location.href="/workflow/request/WorkflowDirection.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
	 <%}else{%>
	 setTimeout("window.close()",1);
     //window.opener._table.reLoad();
try{
	window.opener.btnWfCenterReload.onclick();
}catch(e){}

try{
	window.opener._table.reLoad();
}catch(e){}
try{
   	parent.window.taskCallBack(2,<%=preisremark%>); 
}catch(e){}
		 <%}%>
    </script>
    <%return;}
	else
	{%>
			<script>
		try{
	window.opener.btnWfCenterReload.onclick();
}catch(e){}

try{
	window.opener._table.reLoad();
}catch(e){}
try{
   	parent.window.taskCallBack(2,<%=preisremark%>); 
}catch(e){}
</script>
<%
		if("1".equals(isShowChart)){
			response.sendRedirect("/workflow/request/WorkflowDirection.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+requestid+"&workflowid="+workflowid+"&isbill="+isbill+"&formid="+formid);
		}else{
		 response.sendRedirect("RequestView.jsp");
		}
     return;
	}
    }
session.setAttribute(userid+""+requestid+"requestname",requestname);
session.setAttribute(userid+""+requestid+"requestmark",requestmark);
session.setAttribute(userid+""+requestid+"status",status);
session.setAttribute(userid+""+requestid+"workflowname",workflowname);
response.sendRedirect("ViewRequestDoc.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+requestid+"&isrequest="+isrequest+"&isovertime="+isovertime+"&isaffirmance="+isaffirmance+"&reEdit="+reEdit+"&wflinkno="+wflinkno);
return;
}
}

if(fromoperation.equals("1")&&(src.equals("submit")||src.equals("reject"))){//fromoperation=1表示对流程做过操作,当做提交，退回操作时返回到流程图页面。


%>
<script>
try{
	window.opener.btnWfCenterReload.onclick();
}catch(e){}
try{
	window.opener._table.reLoad();
}catch(e){}
try{
   	parent.window.taskCallBack(2,<%=preisremark%>); 
}catch(e){}
<%if("1".equals(isShowChart)){%>
window.location.href="/workflow/request/WorkflowDirection.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
</script>
<%  return;
	}else{%>
</script>
    <%}

}
String tempremark = Util.null2String(request.getParameter("isremark"));
if(tempremark.equals("8")){
%>
<script>
     //window.opener._table.reLoad();
try{	
	window.opener.btnWfCenterReload.onclick();
}catch(e){}
try{
	window.opener._table.reLoad();
}catch(e){}
try{
   	parent.window.taskCallBack(2,<%=preisremark%>); 
}catch(e){}
</script>
<%
}

if( isbill.equals("1") ) {
    RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
    if(RecordSet.next()){
    formid = Util.getIntValue(RecordSet.getString("billformid"),0);
    billid= Util.getIntValue(RecordSet.getString("billid"));
    }
	if(formid == 207){//计划任务审批单单独处理


    	//特殊处理，直接跳转到计划任务界面，进行审批操作


    	int approverequest = Util.getIntValue(request.getParameter("requestid"), 0);
    	int wt_requestid = 0;
    	rs.execute("select * from worktask_requestbase where approverequest="+approverequest);
    	if(rs.next()){
    		wt_requestid = Util.getIntValue(rs.getString("requestid"), 0);
    	}
    	response.sendRedirect("/worktask/request/ViewWorktask.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+wt_requestid);
		return;
    }
}

//xwj for td3450 20060112
if(istoManagePage && !isprint){
PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,0,(logintype).equals("1") ? "0" : "1",requestid);
}
else{
String updatePoppupFlag = Util.null2String(request.getParameter("updatePoppupFlag"));
if( !"1".equals(updatePoppupFlag)){
PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,1,(logintype).equals("1") ? "0" : "1",requestid);
}
}
String message = Util.null2String(request.getParameter("message"));       // 返回的错误信息

session.setAttribute(userid + "" + requestid + "ismultiprintmode",ismultiprintmode);  //批量打印
//add by xhheng @20041217 for TD 1438 start
if(istoManagePage && !isprint && !wfmonitor){
    String topage = URLEncoder.encode(Util.null2String(request.getParameter("topage"))) ;        //返回的页面


    String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
    String newdocid = Util.null2String(request.getParameter("docid"));        // 新建的文档


    String actionPage = "ManageRequestNoForm.jsp?fromFlowDoc="+fromFlowDoc ;

    session.setAttribute(userid+""+requestid+"status",status);
    session.setAttribute(userid+""+requestid+"requestname",requestname);
    session.setAttribute(userid+""+requestid+"requestlevel",requestlevel);
    session.setAttribute(userid+""+requestid+"requestmark",requestmark);
    session.setAttribute(userid+""+requestid+"creater",""+creater);
    session.setAttribute(userid+""+requestid+"creatertype",""+creatertype);
    session.setAttribute(userid+""+requestid+"deleted",""+deleted);
    session.setAttribute(userid+""+requestid+"workflowid",""+workflowid);
    session.setAttribute(userid+""+requestid+"nodeid",""+nodeid);
    session.setAttribute(userid+""+requestid+"nodetype",nodetype);
    session.setAttribute(userid+""+requestid+"workflowname",workflowname);
    session.setAttribute(userid+""+requestid+"workflowtype",workflowtype);
    session.setAttribute(userid+""+requestid+"formid",""+formid);
    session.setAttribute(userid+""+requestid+"billid",""+billid);
    session.setAttribute(userid+""+requestid+"isbill",isbill);
    session.setAttribute(userid+""+requestid+"helpdocid",""+helpdocid);
    session.setAttribute(userid+""+requestid+"docCategory",docCategory);
    session.setAttribute(userid+""+requestid+"newdocid",newdocid);
    session.setAttribute(userid+""+requestid+"wfmonitor",""+wfmonitor);

    //RecordSet对象在一个客户程序多个执行之间，查询结果可以保留到下一次查询(见RecordSet类 Description 4)
    //但当第二次sql执行失败时，没有清空RecordSet对象，仍保留第一次sql执行结果
    //由此，为防止图形化表单相关脚本没有执行而以下sql执行失败所导致的逻辑错误，申明了新的RecordSet对象mrs
    //屏蔽老的图形化方式，默认为普通方式 mackjoe at 2006-06-12
    /*RecordSet mrs=new RecordSet();
    mrs.executeSql("select count(a.formid) from workflow_formprop a, workflow_base b, workflow_Requestbase c where a.formid = b.formid and b.id = c.workflowid and b.isbill='0' and c.requestid = "+requestid);

    if(mrs.next() && mrs.getInt(1) > 0 ){
      actionPage = "ManageRequestForm.jsp" ;
    }else{
      actionPage = "ManageRequestNoForm.jsp" ;
    }
    */
    //System.out.println("actionPage="+actionPage);

    //将本人的流程查看状态置为已查看2,已提交过的不要在更新操作时间
    if (RecordSet.getDBType().equals("oracle"))
		//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh begin
	{
        //RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate= to_char(sysdate,'yyyy-mm-dd'),operatetime=to_char(sysdate,'hh24:mi:ss'),orderdate=receivedate,ordertime=receivetime where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
        RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate=( case isremark when '2' then operatedate else to_char(sysdate,'yyyy-mm-dd') end  ) ,operatetime=( case isremark when '2' then operatetime else to_char(sysdate,'hh24:mi:ss') end  ) where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2 ");
	}
		//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh end
    else if (RecordSet.getDBType().equals("db2"))
		//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh begin
	{
        //RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate=to_char(current date,'yyyy-mm-dd'),operatetime=to_char(current time,'hh24:mi:ss'),orderdate=receivedate,ordertime=receivetime where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
        RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate=( case isremark when '2' then operatedate else to_char(current date,'yyyy-mm-dd') end ),operatetime=( case isremark when '2' then operatetime else to_char(current time,'hh24:mi:ss') end ) where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
	}
		//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh end
    else
		//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh begin
	{
        //RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate=convert(char(10),getdate(),20),operatetime=convert(char(8),getdate(),108),orderdate=receivedate,ordertime=receivetime where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
        //RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate=to_char(current date,'yyyy-mm-dd'),operatetime=to_char(current time,'hh24:mi:ss')  where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");//update by fanggsh 20060510
        RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate=( case isremark when '2' then operatedate else convert(char(10),getdate(),20) end ),operatetime=( case isremark when '2' then operatetime else convert(char(8),getdate(),108) end ) where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");//update by fanggsh 20060510

	}
		//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh end
    //记录第一次查看时间


    //RecordSet.executeProc("workflow_CurOpe_UpdatebyView",""+requestid+ flag + userid + flag + usertype);

    actionPage+="&requestid="+requestid+"&isrequest="+isrequest+"&isovertime="+isovertime+"&isaffirmance="+isaffirmance+"&reEdit="+reEdit;
    if(!message.equals("")) actionPage+="&message="+message;
    if(!topage.equals("")) actionPage+="&topage="+topage;
    if(!docfileid.equals("")) actionPage+="&docfileid="+docfileid;
    if(!newdocid.equals("")) actionPage+="&newdocid="+newdocid;
    response.sendRedirect(actionPage);

    //当前操作者或者被转发者,并且当前节点不为备案节点,直接进入管理页面
    return ;
}
//add by xhheng @20041217 for TD 1438 end

// 记录查看日志
String clientip = request.getRemoteAddr();
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;

// modify by xhheng @20050304 for TD 1691

/*--  xwj for td2104 on 20050802 begin  --*/
boolean isOldWf = false;
if(isprint==false){
RecordSet4.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSet4.next()){
	if(RecordSet4.getString("nodeid") == null || "".equals(RecordSet4.getString("nodeid")) || "-1".equals(RecordSet4.getString("nodeid"))){
			isOldWf = true;
	}
}

if(isOldWf){//老数据 , 相对 td2104 以前
RecordSet.executeProc("workflow_RequestViewLog_Insert",requestid+"" + flag + userid+"" + flag + currentdate +flag + currenttime + flag + clientip + flag + usertype +flag + nodeid + flag + "9" + flag + -1);
//程序中没有任何地方使用了ordertype='-1'的条件，所以此处直接把-1改成9 by ben 2006-05-24 for TD439
}
else{
int showorder = 10000;
String orderType = "";
RecordSet.executeSql("select agentorbyagentid, agenttype, showorder from workflow_currentoperator where userid = " + userid +
" and nodeid = " + nodeid + " and requestid = " + requestid + " and isremark in ('0','1','4','5','8','9','7') and usertype = " + usertype);

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
if(wfmonitor){
    orderType ="3";//流程监控人查看


}
if(isurger){
    orderType ="4";//流程督办人查看


}
RecordSet.executeProc("workflow_RequestViewLog_Insert",requestid+"" + flag + userid+"" + flag + currentdate +flag + currenttime + flag + clientip + flag + usertype +flag + nodeid + flag + orderType + flag + showorder);

}

/*--  xwj for td2104 on 20050802 end  --*/


//将本人的流程查看状态置为已查看2
	//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh begin
//RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,orderdate=receivedate,ordertime=receivetime where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
RecordSet.executeSql("update workflow_currentoperator set viewtype=-2 where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
    //TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh end
//记录第一次查看时间


RecordSet.executeProc("workflow_CurOpe_UpdatebyView",""+requestid+ flag + userid + flag + usertype);

if(! nodetype.equals("3") )
    RecordSet.executeProc("SysRemindInfo_DeleteHasnewwf",""+userid+flag+usertype+flag+requestid);
else
    RecordSet.executeProc("SysRemindInfo_DeleteHasendwf",""+userid+flag+usertype+flag+requestid);
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage()) + " - " +  status + " "+requestmark ;//Modify by 杨国生 2004-10-26 For TD1231
//if(helpdocid !=0 ) {titlename=titlename + "<img src=/images/help_wev8.gif style=\"CURSOR:hand\" width=12 onclick=\"location.href='/docs/docs/DocDsp.jsp?id="+helpdocid+"'\">";}
String needfav ="1";
String needhelp ="";
//add by mackjoe at 2005-12-20 增加模板应用
String ismode="";
int modeid=0;
int version=0;			//新老html模板标示
int isform=0;
int showdes=0;
int printdes=0;
int ishidearea = 0;
RecordSet.executeSql("select ismode,showdes,printdes,ishidearea from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
    showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
    printdes=Util.getIntValue(Util.null2String(RecordSet.getString("printdes")),0);
    ishidearea = Util.getIntValue(Util.null2String(RecordSet.getString("ishidearea")), 0);
}
if(!isprintlogMode.equals("true")){
//=========================新增打印日志start=================
SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
String currentdatestr=df.format(new Date());
int p_number=0;
String centip=request.getRemoteAddr();
rs1.executeSql("select  p_number from workflow_viewlog where requestid='"+requestid+"' and p_opteruid='"+user.getUID()+"' and p_nodeid='"+nodeid+"' order by  id desc");
if(rs1.next()){
p_number=Util.getIntValue(rs1.getString("p_number"),0);
}
String nodenamest=DateUtil.getWFNodename(""+nodeid,""+7);
String requestname2="";
rs1.executeSql("select requestname from workflow_requestbase where requestid='"+requestid+"'");
if(rs1.next()){
	requestname2=Util.null2String(rs1.getString("requestname"));
}
String workflowtype2="";
String workflowtypeid2="";
rs1.executeSql("select typename,id from workflow_type where id in(select workflowtype from workflow_base where id='"+workflowid+"' )");
if(rs1.next()){
	  workflowtype2=Util.null2String(rs1.getString("typename"));
	  workflowtypeid2=Util.null2String(rs1.getString("id"));
}
  rs1.executeSql("insert into workflow_viewlog(p_nodename,p_nodeid,p_opteruid,p_date,p_addip,p_number,requestid,workflowtype,requestname,workflowid,workflowtypeid)values('"+nodenamest+"','"+nodeid+"','"+user.getUID()+"','"+currentdatestr+"','"+centip+"','"+(p_number+1)+"','"+requestid+"','"+workflowtype2+"','"+requestname2+"','"+workflowid+"','"+workflowtypeid2+"')");
//rs.writeLog("==========sql:"+"insert into workflow_viewlog(p_nodename,p_nodeid,p_opteruid,p_date,p_addip,p_number,requestid,workflowtype,requestname,workflowid,workflowtypeid)values('"+nodenamest+"','"+nodeid+"','"+user.getUID()+"','"+currentdatestr+"','"+centip+"','"+(p_number+1)+"','"+requestid+"','"+workflowtype+"','"+requestname+"','"+workflowid+"','"+workflowtypeid+"')");
//=========================新增打印日志end===================
}	

//===================状态设为已打印=================
rs1.executeSql("update workflow_requestbase set ismultiprint = '1' where requestid = " + requestid);
	
//非ie下不支持模板模式打印
int print_modeid = 0;
if(  !isnotprintmode && isprint && printdes!=1){
	 RecordSet.executeSql("select id from workflow_nodemode where isprint='1' and workflowid="+workflowid+" and nodeid="+nodeid);
	    if(RecordSet.next()){
	    	print_modeid=RecordSet.getInt("id");
	    }else{
	        RecordSet.executeSql("select id from workflow_formmode where formid="+formid+" and isbill='"+isbill+"' and isprint='1'");
	       if(RecordSet.next()){
	            print_modeid=RecordSet.getInt("id");
	        }else{
	        	RecordSet.executeSql("select id from workflow_formmode where formid="+formid+" and isbill='"+isbill+"' and isprint='0'");
	        	if(RecordSet.next()){
	        		print_modeid=RecordSet.getInt("id");
	        	}
	        }
	    }
	    //跨浏览器用


	 	//if(print_modeid >0) {
		// 	response.sendRedirect("PrintMode.jsp?isprintlog=true&requestid="+requestid+"&isbill="+isbill+"&workflowid="+workflowid+"&formid="+formid+"&nodeid="+nodeid+"&billid="+billid);
		// 	return;
	 	//}
}



 


 
if (print_modeid > 0) {
	if ("true".equals((String)session.getAttribute("browser_isie"))) {
		response.sendRedirect("PrintMode.jsp?isprintlog=true&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+requestid+"&isbill="+isbill+"&workflowid="+workflowid+"&formid="+formid+"&nodeid="+nodeid+"&billid="+billid+"&reportid="+reportid+"&isfromreport="+isfromreport+"&isfromflowreport="+isfromflowreport+"&iswfshare="+iswfshare);
		return;
	} else {
%>
	<script type="text/javascript">
		var closeflg = window.confirm("<%=SystemEnv.getHtmlLabelName(84507,user.getLanguage())%>");
		if (!closeflg) {
			window.close();
		}
	</script>
<%}
} 

//普通模式用的Html打印模板
if(ismode.equals("0") && showdes!=1){
	RecordSet.executeSql("select id from workflow_nodehtmllayout where isactive=1 and type=1 and workflowid="+workflowid+" and nodeid="+nodeid);
	if(RecordSet.next()){
		ismode = "2";
	}
}
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
	modeid = htmlLayoutOperate.getActiveHtmlLayout(workflowid, nodeid, 1);
	version = htmlLayoutOperate.getLayoutVersion(modeid);
}



 

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>     
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">

<style>
.wordSpan{font-family:MS Shell Dlg,Arial;CURSOR: hand;font-weight:bold;FONT-SIZE: 10pt}
/**liuzy普通模式打印改背景色及边框色 **/
.gen_printtitle{height:40px;line-height:40px;background:#f0f2f7 !important;border-top:1px solid #bbc4d4;border-left:1px solid #bbc4d4;border-right:1px solid #bbc4d4;}
.gen_printmain{border-left:1px solid #bbc4d4 !important;border-right:1px solid #bbc4d4 !important;}
.gen_printmain .line1{background:#bbc4d4 !important;}
.gen_printmain .Line2{background:#bbc4d4 !important;}
.gen_printmain .fieldnameClass{background:#f0f2f7 !important;border-left:1px solid #bbc4d4 !important;border-right:1px solid #bbc4d4 !important;}
.gen_printdetail{border-left:1px solid #bbc4d4 !important;border-right:1px solid #bbc4d4 !important;border-bottom:1px solid #bbc4d4 !important;}
.gen_printsigntitle{border-top:1px solid #bbc4d4 !important;border-left:1px solid #bbc4d4 !important;border-right:1px solid #bbc4d4 !important;}
.gen_printsignbody{border-bottom:1px solid #bbc4d4 !important;border-left:1px solid #bbc4d4 !important;border-right:1px solid #bbc4d4 !important;}
</style>

</head>
<script language=javascript>

function hiddenPop(){
 try{
    <%
	if(modeid>0 && "1".equals(ismode)){
%>
    oPopup.hide();
<%
    }else{
%>
    showTableDiv.style.display='none';
    oIframe.style.display='none';
<%
    }
%>
}catch(e){}
}
var fromoperation="<%=fromoperation%>";
var overtime="<%=isovertime%>";
function windowOnload()
{
    <%if(modeid>0 && "1".equals(ismode)){%>
        init();
    <%}else{
     if(!"1".equals(ismultiprintmode)){
    %>
    	setwtableheight();
    <%}
     if("1".equals(ismultiprintmode)){
    %>
	    var childdoc = document.getElementById("rightMenuIframe").contentWindow.document;  //右键菜单的iframe
		jQuery("#menuTable>div:gt(1)",childdoc).each(function(index,ele){    //将除了打印之外的其他按钮都删除
			jQuery(ele).css("display","none");
		});
		document.oncontextmenu = function(){   //需要隐藏所有的菜单，然后再打开本iframe的菜单
			parent.hideAllMenu();
			showRightClickMenu();
		}
     	if(typeof primaryWfLogLoadding == "function"){
     		//primaryWfLogLoadding();   //有签字意见，则签字意见加载完后再调整iframe的大小
        }else{
        	frameResize();   //否则，直接调整大小
        } 
    <%	 
     } 
    }
        if( message.equals("4") ) {//已经流转到下一节点，不可以再提交。


%>

		  var content="<%=SystemEnv.getHtmlLabelName(21266,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);
<%
	} else if( message.equals("5") ) {//流程流转超时，请重试。


%>

		  var content="<%=SystemEnv.getHtmlLabelName(21270,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	}
%>
    if (fromoperation=="1") {
<%
         //TD4262 增加提示信息  开始


		 if(isShowPrompt.equals("true"))
		{
			 if(src.equals("submit")){
				 if(modeid>0 && "1".equals(ismode)){
%>
	                 contentBox = document.getElementById("divFavContent18982");
                     showObjectPopup(contentBox);
<%
				 }else{
%>
		             var content="<%=SystemEnv.getHtmlLabelName(18982,user.getLanguage())%>";
		             showPrompt(content);
<%
				 }
			 }else if(src.equals("reject")){
				 if(modeid>0 && "1".equals(ismode)){
%>
	                 contentBox = document.getElementById("divFavContent18983");
                     showObjectPopup(contentBox);
<%
				 }else {
%>
		             var content="<%=SystemEnv.getHtmlLabelName(18983,user.getLanguage())%>";
		             showPrompt(content);
<%
				 }
			}
		}
%>

         //TD4262 增加提示信息  结束
		<%if("1".equals(isShowChart)){%>
        //setTimeout("window.close()",1);
       			try{
				window.opener._table.reLoad();
			}catch(e){}
			try{
   				parent.window.taskCallBack(2,<%=preisremark%>); 
			}catch(e){}
			window.location.href="/workflow/request/WorkflowDirection.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
		<%}else{%>
			setTimeout("window.close()",1);
			try{
				window.opener._table.reLoad();
			}catch(e){}
			try{
   				parent.window.taskCallBack(2,<%=preisremark%>); 
			}catch(e){}
		<%}%>
        //window.opener.document.frmmain.submit();
        //将提交父窗口改为调用分页控件的刷新函数


        if( overtime!="1")
        {
        	try
        	{
        		window.opener.btnWfCenterReload.onclick();
        		window.opener._table.reLoad();
        	}
        	catch(e)
        	{
        	<%if("1".equals(isShowChart)){%>
				window.location.href="/workflow/request/WorkflowDirection.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
				<%}else{%>
					window.location.href = "RequestView.jsp";
				<%}%>
        	}
        	try{
   				parent.window.taskCallBack(2,<%=preisremark%>); 
			}catch(e){}
        }

    }
}
<%if(modeid<1 || "2".equals(ismode)){%>
function setwtableheight(){
    var totalheight=5;
    var bodyheight=document.body.clientHeight;
    if(document.all("divTopTitle")!=null){
        totalheight+=document.all("divTopTitle").clientHeight;
    }
    <%if (fromFlowDoc.equals("1")){%>
        totalheight+=100;
        bodyheight=parent.document.body.clientHeight;
    <%}%>
    document.all("w_table").height=bodyheight-totalheight;
}
<%if(!"1".equals(ismultiprintmode)){%>
window.onresize = function (e){
    setwtableheight();
}
<%}%>
<%}%>
</script>

<script language="javascript">
var isfirst = 0 ;

function displaydiv()
{
	var oDivAll = $GetEle("oDivAll");
    if(oDivAll.style.display == ""){
		oDivAll.style.display = "none";
		$GetEle("oDivInner").style.display = "none";
		$GetEle("oDiv").style.display = "none";
        <%if(modeid>0 && "1".equals(ismode)){%>  $GetEle("oDivSign").style.display = "none";<%}%>
        $GetEle("spanimage").innerHTML = "<img src='/images/ArrowDownRed_wev8.gif' border=0>" ;
    } else{
        if(isfirst == 0) {
        	$GetEle("divPicInnerFrame").style.display = "";
        	$GetEle("divPicFrame").style.display = "";
        	$GetEle("picInnerFrame").src = "/workflow/request/WorkflowRequestPictureInner.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&isview=1&fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>";				
        	$GetEle("picFrame").src = "/workflow/request/WorkflowRequestPicture.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&isurger=<%=isurger%>";
            <%if(modeid>0 && "1".equals(ismode)){%>  $GetEle("picSignFrame").src="/workflow/request/WorkflowViewSignMode.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&isprint=true&languageid=<%=user.getLanguage()%>&userid=<%=userid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isOldWf=<%=isOldWf%>&desrequestid=<%=desrequestid%>&ismonitor=<%=ismonitor%>&logintype=<%=logintype%>";<%}%>
            isfirst ++ ;
        } else {
        	$GetEle("divPicInnerFrame").style.display = "none";
        	$GetEle("divPicFrame").style.display = "none";
        	$GetEle("picInnerFrame").src = "";	
        	$GetEle("picFrame").src = "";
        }

        $GetEle(spanimage).innerHTML = "<img src='/images/ArrowUpGreen_wev8.gif' border=0>" ;
		oDivAll.style.display = "";
		$GetEle("oDivInner").style.display = "";
		$GetEle("oDiv").style.display = "";
		$GetEle("workflowStatusLabelSpan").innerHTML = "<font color=green><%=SystemEnv.getHtmlLabelName(19678,user.getLanguage())%></font>";
		$GetEle("workflowChartLabelSpan").innerHTML = "<font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font>";
        <%if(modeid>0 && "1".equals(ismode)){%>
        	$GetEle("oDivSign").style.display = "";
        	$GetEle("workflowSignLabelSpan").innerHTML = "<font color=green><%=SystemEnv.getHtmlLabelName(21200,user.getLanguage())%></font>";
        <%}%>
    }
}


function displaydivOuter()
{
	var oDiv = $GetEle("oDiv");
	var workflowStatusLabelSpan = $GetEle("workflowStatusLabelSpan");
    if(oDiv.style.display == ""){
        oDiv.style.display = "none";
        workflowStatusLabelSpan.innerHTML="<font color=red><%=SystemEnv.getHtmlLabelName(19677,user.getLanguage())%></font>";
		if(oDiv.style.display == "none" && $GetEle("oDivInner").style.display == "none" <%if(modeid>0 && "1".equals(ismode)){%> && $GetEle("oDivSign").style.display == "none"<%}%>){
			$GetEle("oDivAll").style.display = "none";
		    $GetEle("spanimage").innerHTML = "<img src='/images/ArrowDownRed_wev8.gif' border=0>" ;
		}
    }
    else{
        oDiv.style.display = "";
        workflowStatusLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19678,user.getLanguage())%></font>";
    }
}

function displaydivInner()
{
	var oDivInner = $GetEle("oDivInner");
	var workflowChartLabelSpan = $GetEle("workflowChartLabelSpan");
    if(oDivInner.style.display == ""){
        oDivInner.style.display = "none";
        workflowChartLabelSpan.innerHTML = "<font color=red><%=SystemEnv.getHtmlLabelName(19675,user.getLanguage())%></font>";
		if($GetEle("oDiv").style.display == "none" && oDivInner.style.display == "none" <%if(modeid>0 && "1".equals(ismode)){%> && $GetEle("oDivSign").style.display == "none"<%}%>){
			$GetEle("oDivAll").style.display = "none";
		    $GetEle(spanimage).innerHTML = "<img src='/images/ArrowDownRed_wev8.gif' border=0>" ;
		}
    }
    else{
        oDivInner.style.display = "";
        workflowChartLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font>";
    }
}
</SCRIPT>

<body style="overflow:auto">
<%if (!fromFlowDoc.equals("1")) {%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
     if("1".equals(ismultiprintmode)){   //批量打印时，增加右键菜单
    	 RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:parent.doPrint(),_self} " ;
    	 RCMenuHeight += RCMenuHeightStep ;
     }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% border="0" cellspacing="0" cellpadding="0" id="w_table">
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
		<%if("2".equals(ismode) && modeid>0){%>
			<%if(true || version==2){ //ViewForm含CSS导致老模板异常	%>
			<TABLE style="width:100%;margin:0px;padding:0px;">
			<%}else{ %>
			<TABLE class=ViewForm>
			<%} %>
		<%}else{%>
			<TABLE class=Shadow>
		<%}%>
		<tr>
		<td valign="top">
        <%if( message.equals("4") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(21266,user.getLanguage())%></font>
		<%} else if( message.equals("5") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(21270,user.getLanguage())%></font>
		<%}%>
        <div align="" id="t_help">
        <!-- modify by xhheng @20050304 for TD 1691 -->
        <% if(helpdocid !=0 && isprint==false) {%>
        <img src="/images/help_wev8.gif" style="CURSOR:hand" width=12 onclick="showWFHelp(<%=helpdocid%>)">
        <%}%>
        <%if(isprint==false){%>
        <a href="#" onClick="displaydiv()">
            <SPAN id="spanimage" name="spanimage"><img src="/images/ArrowDownRed_wev8.gif" border=0></span>
        </a></div>
        <%}%>

<div  id=oDivAll style="display:none"  width="100%">
  <TABLE border=0 cellpadding=0 cellspacing=0 width="100%">
  <TR>
    <TH align="right"><span id=workflowChartLabelSpan onclick="displaydivInner()" class="wordSpan"><font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font></span></TH>
  </TR>
  <TR>
    <TD align="left" >
    <div  id=oDivInner style="display:none"  width="100%">
        <TABLE border=0 cellpadding=0 cellspacing=0 width="100%"><TR><TD ID='ImageTdInner'></TD></TR></TABLE>
        <BR>
    </div>
	</TD>
  </TR>
  <TR>
    <TH align="right"><span id=workflowStatusLabelSpan onclick="displaydivOuter()" class="wordSpan"><font color=green><%=SystemEnv.getHtmlLabelName(19678,user.getLanguage())%></font></span></TH>
  </TR>
  <TR>
    <TD  align="left">
    <div  id=oDiv style="display:none"  width="100%">
       <TABLE border=0 cellpadding=0 cellspacing=0 width="100%"><TR><TD ID='IMAGETD'></TD></TR></TABLE>
       <BR>
    </div>
	</TD>
    </TR>
  <%if(modeid>0 && "1".equals(ismode)){%>
    <TR>
    <TH align="right"><span id=workflowSignLabelSpan onclick="displaydivSign()" class="wordSpan"><font color=green><%=SystemEnv.getHtmlLabelName(21200,user.getLanguage())%></font></span></TH>
  </TR>
  <TR>
    <TD  align="left">
    <div  id=oDivSign style="display:none"  width="100%">
       <TABLE border=0 cellpadding=0 cellspacing=0 width="100%"><TR><TD ID='IMAGETDSign'></TD></TR></TABLE>
       <BR>
    </div>
	</TD>
    </TR>
   <%}%>
  </TABLE>
</div>

<DIV id="divPicInnerFrame" style="display:none">
<iframe ID="picInnerFrame" BORDER=0 FRAMEBORDER=no height="0%" width="0%" scrolling="NO" src=""></iframe>
</DIV>

<DIV id="divPicFrame" style="display:none">
<iframe ID="picFrame" BORDER=0 FRAMEBORDER=no height="0%" width="0%" scrolling="NO" src=""></iframe>
</DIV>
<!--TD4262 增加提示信息  开始-->
<%
    if(modeid>0 && "1".equals(ismode)){
%>
<div id="divFavContent18982" style="display:none">  <!--流程提交成功。-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18982,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent18983" style="display:none"> <!--流程退回成功。-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18983,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>
<div id="divFavContent19205" style="display:none"> <!--正在获取数据。-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>
<%
    }else{
%>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<%
	}
%>
<!--TD4262 增加提示信息  结束-->

<%
if(modeid>0 && "1".equals(ismode)){
    request.setAttribute("requestname",requestname);
%>
<div id="divFavContent18978" style="display:none"><!--正在提交流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>
<div id="divFavContent18984" style="display:none"><!--正在删除流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18984,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>
<DIV>
<iframe ID="picSignFrame" BORDER=0 FRAMEBORDER=no height="0%" width="0%" scrolling="NO" src=""></iframe>
</DIV>
<%if(fromFlowDoc.equals("1") || (isbill.equals("1") && formid==7)){%>
<div id="t_headother"></div>
<%}%>
    <form name="frmmain" method="post" action="RequestOperation.jsp" <%if (!fromPDA.equals("1")) {%> enctype="multipart/form-data" <%}%>>
<%
boolean hasRequestname = false;
boolean hasRequestlevel = false;
boolean hasMessage = false;
boolean hasChats= false;//微信提醒(QC:98106)
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-1");
if(RecordSet.next()) hasRequestname = true;
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-2");
if(RecordSet.next()) hasRequestlevel = true;
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-3");
if(RecordSet.next()) hasMessage = true;
//微信提醒(QC:98106)
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-5");
if(RecordSet.next()) hasChats = true;
//微信提醒(QC:98106)
%>
<%
if(!hasRequestname||!hasRequestlevel||!hasMessage||!hasChats){//微信提醒(QC:98106)
%>
    <TABLE class="ViewForm" id="t_header">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TR class="Spacing">
    <TD class="Line1" colSpan=2></TD>
  </TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
    <TD class=field>
    <%if(!hasRequestname){%>
       <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
       <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
    <%}%>  
    <%if(!hasRequestlevel){%>
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
		<%}%>

    <%if(!hasMessage){%>
      <!--add by xhheng @ 2005/01/25 for 消息提醒 Request06，流转过程中察看短信设置 -->
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%
      String sqlWfMessage = "select messageType from workflow_base where id="+workflowid;
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
        }%>
        <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
        <%} else if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
        <%} else if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%> <%}%>
      <%}%>
      <%}%>
      <!-- 微信提醒(QC:98106) -->
      <%if(!hasChats){%>
      <!--add by xhheng @ 2005/01/25 for 消息提醒 Request06，流转过程中察看短信设置 -->
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%
      String sqlWfChats= "select chatsType from workflow_base where id="+workflowid;
      int wfChatsType=0;
      RecordSet.executeSql(sqlWfChats);
      if (RecordSet.next()) {
        wfChatsType=RecordSet.getInt("chatsType");
      }
      if(wfChatsType == 1){
        String sqlRqChats = "select chatsType from workflow_requestbase where requestid="+requestid;
        int rqChatsType=0;
        RecordSet.executeSql(sqlRqChats);
        if (RecordSet.next()) {
          rqChatsType=RecordSet.getInt("chatsType");
        }%>
        <%if(rqChatsType==0){%><%=SystemEnv.getHtmlLabelName(32638,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
        <%} else if(rqChatsType==1){%><%=SystemEnv.getHtmlLabelName(32638,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>
        <%}        %>
      <%}%>
      <%}%>
      <!-- 微信提醒(QC:98106) -->
      </TD>
  </TR>
  <TR>
    <TD class="Line1" colSpan=2></TD>
  </TR>
  </table> 
<%}%>     
    <%if(isbill.equals("1") && formid==7){%>
    <jsp:include page="/workflow/request/BillBudgetExpenseDetailMode.jsp" flush="true">
	<jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    </jsp:include>
    <%}%>
    <jsp:include page="WorkflowViewmode.jsp" flush="true">
    <jsp:param name="modeid" value="<%=modeid%>" />
    <jsp:param name="isform" value="<%=isform%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />    
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
    </jsp:include>
    <jsp:include page="ViewmodeValue.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="workflowid" value="<%=workflowid%>" />
	<jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="isurger" value="<%=isurger%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />  
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
	<jsp:param name="isprint" value="1" />
    </jsp:include>
    </form>
<%
}else{
//end by mackjoe

String viewpage= "";
if(isbill.equals("1")){
    RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
    if(RecordSet.next()) viewpage = RecordSet.getString("viewpage");
}

if (isbill.equals("1") && formid == 7 && "2".equals(ismode)) {
    viewpage = "";
}

if( !viewpage.equals("")) {
     request.setAttribute("requestname",requestname);
    request.setAttribute("workflowname",workflowname);
	session.setAttribute(userid+"_"+requestid+"requestname",requestname);
    session.setAttribute(userid+"_"+requestid+"workflowname",workflowname);
    String vp_isprint = Util.null2String(request.getParameter("isprint"));
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
    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="canactive" value="<%=canactive%>" />
    <jsp:param name="isprint" value="<%=vp_isprint%>" />
	<jsp:param name="desrequestid" value="<%=desrequestid%>" />
	<jsp:param name="isrequest" value="<%=isrequest%>" />
    <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="isurger" value="<%=isurger%>" />
    <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />

</jsp:include>
<%}else{%>

<form name="frmmain" method="post" action="RequestOperation.jsp">
    <%
    request.setAttribute("requestname",requestname);
    request.setAttribute("workflowname",workflowname);
	session.setAttribute(userid+"_"+requestid+"requestname",requestname);
    session.setAttribute(userid+"_"+requestid+"workflowname",workflowname);
    if("2".equals(ismode) && modeid>0){
    	if("true".equals((String)session.getAttribute("browser_isie"))){
    		usePrePrint = true;
	%>
		<object id="WebBrowser" classid="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2" height="0" width="0"></object>
	   <%} %>
            <jsp:include page="WorkflowViewRequestHtml.jsp" flush="true">
				<jsp:param name="modeid" value="<%=modeid%>" />
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="canactive" value="<%=canactive%>" />
                <jsp:param name="deleted" value="<%=deleted%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="requestlevel" value="<%=requestlevel%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="billid" value="<%=billid%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="isprint" value="1" />
                <jsp:param name="logintype" value="<%=logintype%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="nodetype" value="<%=nodetype%>" />
                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="isrequest" value="<%=isrequest%>" />
                <jsp:param name="isurger" value="<%=isurger%>" />
                <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />
				<jsp:param name="isremark" value="2" />
            </jsp:include>
	<%}else{%>
            <jsp:include page="WorkflowViewRequestBodyAction.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="canactive" value="<%=canactive%>" />
                <jsp:param name="deleted" value="<%=deleted%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="requestlevel" value="<%=requestlevel%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="billid" value="<%=billid%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="isprint" value="<%=isprint%>" />
                <jsp:param name="logintype" value="<%=logintype%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="nodetype" value="<%=nodetype%>" />
                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="isrequest" value="<%=isrequest%>" />
                <jsp:param name="isurger" value="<%=isurger%>" />
                <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />
                <jsp:param name="isOldWf" value="<%=isOldWf%>" />
            </jsp:include>
            <jsp:include page="WorkflowViewSignAction.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="usertype" value="<%=usertype%>" />
                <jsp:param name="isprint" value="<%=isprint%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="isOldWf" value="<%=isOldWf%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="isurger" value="<%=isurger%>" />
                <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />	
            </jsp:include>
            <%if(ishidearea == 1){ %>
	            <script type="text/javascript">
				jQuery(function(){
					judgeBrowserPrint();
				});
				</script>
            <%} %>
	<%}%>
</form>
<%}
}
int haslinkworkflow=Util.getIntValue(String.valueOf(session.getAttribute("haslinkworkflow")),0);
if(haslinkworkflow==1&&!isrequest.equals("1")){
    session.setAttribute("desrequestid",""+requestid);
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
	</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
</table>
<% 
rs_1.executeSql("select custompage from workflow_base where id="+workflowid);
if(rs_1.next()){
	String _custompage = Util.null2String(rs_1.getString("custompage")).trim();
	if(!"".equals(_custompage)){
%>
<jsp:include page="<%=_custompage %>" flush="true">
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="userid" value="<%=userid%>" />
    <jsp:param name="usertype" value="<%=usertype%>" />
    <jsp:param name="isprint" value="<%=isprint%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="isOldWf" value="<%=isOldWf%>" />
    <jsp:param name="desrequestid" value="<%=desrequestid%>" />
    <jsp:param name="isurger" value="<%=isurger%>" />
    <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />	
</jsp:include>
<% 
	}
}
%>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">

try{
	window.opener.btnWfCenterReload.onclick();
}catch(e){}

if (window.addEventListener){
    window.addEventListener("load", windowOnload, false);
}else if (window.attachEvent){
    window.attachEvent("onload", windowOnload);
}else{
    window.onload=windowOnload;
}

function doRetract(obj){
obj.disabled=true;
document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=rb&requestid=<%=requestid%>" //xwj for td3665 20060224
}

function showWFHelp(docid){
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    var operationPage = "/docs/docs/DocDsp.jsp?id="+docid;
    window.open(operationPage,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}
// modify by xhheng @20050304 for TD 1691
function openSignPrint1() {
    var redirectUrl = "PrintMode.jsp?isprintlog=true&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&isbill=<%=isbill%>&workflowid=<%=workflowid%>&formid=<%=formid%>&nodeid=<%=nodeid%>&billid=<%=billid%>&fromFlowDoc=1&urger=<%=urger%>&ismonitor=<%=ismonitor%>" ;
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

//TD4262 增加提示信息  开始


//提示窗口
<%
    if(modeid>0 && "1".equals(ismode)){
%>
var oPopup;
try{
    oPopup = window.createPopup()
}
catch(e){}
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
function displaydivSign()
{
	var oDivSign = $GetEle("oDivSign");
    if(oDivSign.style.display == ""){
        oDivSign.style.display = "none";
        $GetEle("workflowSignLabelSpan").innerHTML = "<font color=red><%=SystemEnv.getHtmlLabelName(21199,user.getLanguage())%></font>";
		if($GetEle("oDiv").style.display == "none" && $GetEle("oDivInner").style.display == "none" && oDivSign.style.display == "none"){
			$GetEle("oDivAll").style.display = "none";
		    $GetEle("spanimage").innerHTML = "<img src='/images/ArrowDownRed_wev8.gif' border=0>" ;
		}
    }
    else{
        oDivSign.style.display = "";
        $GetEle("workflowSignLabelSpan").innerHTML = "<font color=green><%=SystemEnv.getHtmlLabelName(21200,user.getLanguage())%></font>";
    }
}
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showallreceived(operator,operatedate,operatetime,returntdid,viewLogIds,logtype,destnodeid){
    <%
    if(modeid>0 && "1".equals(ismode)){
    %>
    showObjectPopup(document.getElementById("divFavContent19205"));
    <%}else{%>
    showPrompt("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    <%}%>
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowReceiviedPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid=<%=requestid%>&viewnodeIds="+viewLogIds+"&operator="+operator+"&operatedate="+operatedate+"&operatetime="+operatetime+"&returntdid="+returntdid+"&logtype="+logtype+"&destnodeid="+destnodeid);
    //获取执行状态


    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里


        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            document.all(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            hiddenPop();
        }
    }
}
function displaydiv_1()
{
	var WorkFlowDiv = $GetEle("WorkFlowDiv");
	var WorkFlowspan = $GetEle("WorkFlowspan");
    if(WorkFlowDiv.style.display == ""){
        WorkFlowDiv.style.display = "none";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
    } else {
        WorkFlowDiv.style.display = "";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";
    }
}
function openSignPrint() {
  var redirectUrl = "PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&urger=<%=urger%>&ismonitor=<%=ismonitor%>" ;
  <%//解决相关流程打印权限问题  
  if(wflinkno>=0){
  %>
  redirectUrl = "PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&isrequest=1&wflinkno=<%=wflinkno%>&urger=<%=urger%>&ismonitor=<%=ismonitor%>";
  <%}%>  
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
<%
    }else{
%>
var showTableDiv  = document.getElementById('_xTable');
var oIframe = document.createElement('iframe');
function showPrompt(content)
{
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = document.getElementById("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     message_table_Div.style.top=pTop;
     message_table_Div.style.left=pLeft;

     message_table_Div.style.zIndex=1002;
     //oIframe = document.createElement('iframe');
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

}
<%
    }
%>
//TD4262 增加提示信息  结束


function returnTrue(o){
	return;
}

function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}
function doReview(){
        var id = <%=requestid%>;
        //document.location.href="/workflow/request/Remark.jsp?requestid="+id; //xwj for td3247 20051201
		 <%if (!fromFlowDoc.equals("1")) {%>
        document.location.href="/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id; //xwj for td3247 20051201
		<%}else {%>
        parent.document.location.href="/workflow/request/Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+id; 
		<%}%>
   }
function onAddPhrase(phrase){            <!-- 添加常用短语 -->
    if(phrase!=null && phrase!=""){
      var remarkValue= document.all("remark").value;
      document.all("remark").value = remarkValue + "\n" + phrase ;
    }
  }
<%if (isurger){%>
function doSupervise(obj)
{
        <% if(ismode.equals("1")){ %>
        contentBox = document.getElementById("divFavContent18978");
        showObjectPopup(contentBox)
    <% }else{ %>
        var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
        showPrompt(content);
    <%  } %>
        $G("src").value='supervise';
        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
}
<%}%>
/** added by cyril on 2008-07-09 for TD:8835*/
function doViewModifyLog() {
	//var logURL = "/workflow/request/RequestModifyLogView.jsp?requestid=<%=requestid%>&nodeid=<%=nodeid%>&isAll=0&ismonitor=<%=ismonitor%>&urger=<%=urger%>";
	//window.open(logURL);
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/request/RequestModifyLogView.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&nodeid=<%=nodeid%>&isAll=0&ismonitor=<%=ismonitor%>&urger=<%=urger%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(21625,user.getLanguage())%>";
	dialog.Width = 1000;
	dialog.Height = 550;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
	/*
	if(parent!=null)
		parent.document.location.href = logURL;
	else
		document.location.href = logURL;
	*/
}
/** end by cyril on 008-07-09 for TD:8835*/
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
//微信提醒(QC:98106)
function onNewChats(wfid, nodeid, reqid){ 
	var redirectUrl =  "/systeminfo/BrowserMain.jsp?url=/wechat/sendWechat.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&workflowid="+wfid+"&nodeid="+nodeid+"&reqid="+reqid+"&actionid=dialog";
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
//浏览器打印相关方法

function judgeBrowserPrint(){
window.setTimeout(function(){		//延时执行，使得图片缩小功能打印自动弹框有效
	try{
		var usePrePrint = "<%=usePrePrint %>";
		if(usePrePrint == "true"){
			settingPrintPage();
			try {
				document.all.WebBrowser.ExecWB(7,1);
			} catch(e9) {
				alert("<%=SystemEnv.getHtmlLabelName(84341, user.getLanguage())%>");
				window.print();
			}
		}else{
			window.print();
		}
	}catch(e){}
},500);
}

//通过修改电脑注册表，控制IE下打印设置，默认勾选允许收缩到纸张大小
function settingPrintPage(){
	try{
		var hkey_root = "HKEY_CURRENT_USER" ;
		var hkey_path = "\\Software\\Microsoft\\Internet Explorer\\PageSetup\\";
		var hkey_key = "";
		var RegWsh = new ActiveXObject("WScript.Shell");
		hkey_key = "Print_Background";
   		RegWsh.RegWrite(hkey_root+hkey_path+hkey_key, "yes");
		hkey_key = "Shrink_To_Fit";
   		RegWsh.RegWrite(hkey_root+hkey_path+hkey_key, "yes");
	}catch(e){
		if(window.console)
			console.log("请设置IE下允许ActiveX插件运行,"+e);
	}
}

//自适应iframe的高度
//原本是调整iframe的高度的，现实现方式改变，此处改为取iframe的html，然后拼装到父页面中
function frameResize(){
	var callback = function(){
		var frameObj = parent.document.getElementById("requestiframe<%=requestid%>");
		if(!frameObj){
			return;
		}
		/*
		if(jQuery("table.excelMainTable").length > 0){   //新版e8的表单模式，将iframe的宽度调整跟表单一样宽
			var fwidth = jQuery("table.excelMainTable").width();
			frameObj.width = fwidth + 20;
		}else if(jQuery("table.excelOuterTable").length > 0){   //新版e8的表单模式，将iframe的宽度调整跟表单一样宽
			var fwidth = jQuery("table.excelOuterTable").width();
			frameObj.width = fwidth + 20;
		}

		//高度调整一定要放在宽度调整之后，因为宽度调整后，可能会因为有些文本折行导致高度再次变化
		var frameDoc = frameObj.document ? frameObj.document : frameObj.contentDocument;
		frameObj.height = jQuery("#w_table").height();
		*/

		jQuery("*").removeAttr("onclick").removeAttr("onmouseover").removeAttr("onmouseout");   //移除所有的鼠标点击、移入、移出的事件
		
		var _reqCount = parent.reqCount;
		var _orgCount = parent.orgCount;
		var _reqid = <%=requestid%>;
		var _firstReqid = parent.firstReqid;
		var divId = "req_<%=requestid%>";
		var htmlStr = "";
		if(_reqid == _firstReqid){  //两者相等，说明是第一条数据
			htmlStr = document.documentElement.innerHTML;
			var jsscript = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
			htmlStr = htmlStr.replace(jsscript,"");   //替换掉所有的js
		}else{
			jQuery("link").remove();
			jQuery("style").remove();
			htmlStr = document.getElementById("w_table").outerHTML;
			var jsscript = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
			htmlStr = htmlStr.replace(jsscript,"");   //替换掉所有的js
		}
		_reqCount = _reqCount - 1;
		if(_reqCount == 0){   //说明所有的iframe都加载完毕
			parent.loadOver();
		}else{
			parent.reqCount = _reqCount;
		}
		
		jQuery("#" + divId,parent.document).html(htmlStr); 
	}
	setTimeout(function(){callback();},20);
}

jQuery(document).ready(function(){
	jQuery("span a:contains('<%=SystemEnv.getHtmlLabelName(126555,user.getLanguage()) %>')").replaceWith('<%=SystemEnv.getHtmlLabelName(126555,user.getLanguage()) %>');
	jQuery("a:contains('<%=SystemEnv.getHtmlLabelName(126542,user.getLanguage())%>')").replaceWith('<%=SystemEnv.getHtmlLabelName(126542,user.getLanguage())%>');
});
</SCRIPT>
