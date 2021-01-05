<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*,weaver.conn.*" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp"%>
<%@ page import="weaver.worktask.worktask.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet5" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td3665 on 20060227--%>
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
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="SysWFLMonitor" class="weaver.system.SysWFLMonitor" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />
<jsp:useBean id="WFCoadjutantManager" class="weaver.workflow.request.WFCoadjutantManager" scope="page" />
<%
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
boolean isUseOldWfMode = sysInfo.isUseOldWfMode();
int isonlyview = Util.getIntValue(request.getParameter("isonlyview"), 0);
%>
<%----xwj for td3665 20060301 begin---%>
<%
String info = (String)request.getParameter("infoKey");
int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
String isworkflowdoc = "0";//是否为公文
int seeflowdoc = Util.getIntValue(request.getParameter("seeflowdoc"),0);
boolean isnotprintmode =Util.null2String(request.getParameter("isnotprintmode")).equals("1")?true:false;
String reEdit=""+Util.getIntValue(request.getParameter("reEdit"),1);//是否为编辑
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String wfdoc = Util.null2String((String)session.getAttribute(requestid+"_wfdoc"));
String isrequest = Util.null2String(request.getParameter("isrequest")); //
String nodetypedoc=Util.null2String(request.getParameter("nodetypedoc"));
int desrequestid=0;
int wflinkno=Util.getIntValue(request.getParameter("wflinkno"));
//boolean isprint = Util.null2String(request.getParameter("isprint")).equals("1")?true:false;
boolean isprint=true;
String fromoperation=Util.null2String(request.getParameter("fromoperation"));

String fromPDA = Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录
String wfRemarkflag=Util.null2String(request.getParameter("wfRemarkflag"));
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

int lastOperator=0; //最后操作者id
String lastOperateDate="";//最后操作日期
String lastOperateTime="";//最后操作时间

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
boolean islog=true;            			//是否记录查看日志
//boolean haveOverright=false;            //强制归档权限
int wfcurrrid=0;

String sql = "" ;
char flag = Util.getSeparator() ;
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
String isSignMustInputOfThisJsp="0";
String isFormSignatureOfThisJsp="0";
rs.executeSql("select requestid from workflow_currentoperator where userid="+userid+" and usertype="+usertype+" and requestid="+requestid);
if(rs.next()){
	canview=true;
	isrequest = "0";
}
if(isrequest.equals("1")){      // 从相关工作流过来,有查看权限
    requestid=Util.getIntValue(String.valueOf(session.getAttribute("resrequestid"+wflinkno)),0);
    desrequestid=Util.getIntValue(String.valueOf(session.getAttribute("desrequestid")),0);//父级流程ID
    String realateRequest=Util.null2String(String.valueOf(session.getAttribute("relaterequest")));
	if (requestid==0&&realateRequest.equals("new"))  requestid=Util.getIntValue(request.getParameter("requestid"),0);
    rs.executeSql("select count(*) from workflow_currentoperator where userid="+userid+" and usertype="+usertype+" and requestid="+desrequestid);
    if(rs.next()){
        int counts=rs.getInt(1);
        if(counts>0){
           canview=true;
        }
    }
    session.setAttribute(requestid+"wflinkno",wflinkno+"");//解决相关流程，不是流程操作人无权限打印的问题    
}
int issecurity = 0;
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
	issecurity = Util.getIntValue(RecordSet.getString("issecurity"),0);
    if(nodeid<1) nodeid = currentnodeid;
	currentnodetype = Util.null2String(RecordSet.getString("currentnodetype"));
    if(nodetype.equals("")) nodetype = currentnodetype;
    docCategory=Util.null2String(RecordSet.getString("docCategory"));
    workflowname = WorkflowComInfo.getWorkflowname(workflowid+"");
    workflowname = Util.processBody(workflowname,user.getLanguage()+"");
    workflowtype = WorkflowComInfo.getWorkflowtype(workflowid+"");

    lastOperator = Util.getIntValue(RecordSet.getString("lastOperator"),0);
    lastOperateDate=Util.null2String(RecordSet.getString("lastOperateDate"));
    lastOperateTime=Util.null2String(RecordSet.getString("lastOperateTime"));
}else{
    response.sendRedirect("/notice/Deleted.jsp?showtype=wf");
    return ;
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
session.removeAttribute(userid+"_"+requestid+"isremark");
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
int preisremark=-1;//如果是流程参与人，该值会被赋予正确的值，在初始化时先设为错误值，以解决主流程参与人查看子流程时权限判断问题。TD10126
String isremarkForRM = "";
int groupdetailid=0;
RecordSet.executeSql("select isremark,isreminded,preisremark,id,groupdetailid,nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by isremark,id");
boolean istoManagePage=false;   //add by xhheng @20041217 for TD 1438
while(RecordSet.next())	{
    String isremark = Util.null2String(RecordSet.getString("isremark")) ;
	isremarkForRM = isremark;
    preisremark=Util.getIntValue(RecordSet.getString("preisremark"),0) ;
    wfcurrrid=Util.getIntValue(RecordSet.getString("id"));
    groupdetailid=Util.getIntValue(RecordSet.getString("groupdetailid"),0);
    int tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"));
    //modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直需要处理即使流程已归档
    if( isremark.equals("1")||isremark.equals("5") || isremark.equals("7")|| isremark.equals("9") ||(isremark.equals("0")  && !nodetype.equals("3")) ) {
      //modify by xhheng @20041217 for TD 1438
      istoManagePage=true;
      canview=true;
      nodeid=tmpnodeid;
      nodetype=WFLinkInfo.getNodeType(nodeid);  
      break;
    }
    if(isremark.equals("8")){
        canview=true;
        break;
    }
    canview=true;
}
//add by mackjoe at 2008-10-15 td9423
String isintervenor=Util.null2String(request.getParameter("isintervenor"));
int intervenorright=0;
if(isintervenor.equals("1")){
    intervenorright=SysWFLMonitor.getWFInterventorRightBymonitor(userid,requestid);
}  
if(intervenorright>0){
    istoManagePage=false;
    canview=true;
    nodeid=currentnodeid;
    nodetype=currentnodetype;
}
//add by mackjoe at 2006-04-24 td3994
int urger=Util.getIntValue(request.getParameter("urger"),0);
session.setAttribute(userid+"_"+requestid+"urger",""+urger);
if(urger==1){
    canview=false;
    intervenorright=0;
}
if(!canview) isurger=WFUrgerManager.UrgerHaveWorkflowViewRight(requestid,userid,Util.getIntValue(logintype,1));
int ismonitor=Util.getIntValue(request.getParameter("ismonitor"),0);
session.setAttribute(userid+"_"+requestid+"ismonitor",""+ismonitor);    
if(ismonitor==1){
    canview=false;
    intervenorright=0;
    isurger=false;
}
if(!canview&&!isurger) wfmonitor=WFUrgerManager.getMonitorViewRight(requestid,userid);
session.setAttribute(userid+"_"+requestid+"isintervenor",""+isintervenor);
session.setAttribute(userid+"_"+requestid+"intervenorright",""+intervenorright);
PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,10,(logintype).equals("1") ? "0" : "1",requestid);
//是否忽略权限校验, 0：不忽略，1：忽略
String ignore = Util.null2String(request.getParameter("ignore"));
ignore = !ignore.equals("1") && ignore.equals("0") ? "0" : ignore;
if(ignore.equals("0")){
	if(!canview && !isurger && !wfmonitor && !CoworkDAO.haveRightToViewWorkflow(Integer.toString(userid),Integer.toString(requestid))) {
		if(!WFUrgerManager.UrgerHaveWorkflowViewRight(desrequestid,userid,Util.getIntValue(logintype,1)) && !WFUrgerManager.getMonitorViewRight(desrequestid,userid)){//督办流程和监控流程的相关流程有查看权限
			response.sendRedirect("/notice/noright.jsp?isovertime="+isovertime);
			return ;
		}
	}
}

String isaffirmance=WorkflowComInfo.getNeedaffirmance(""+workflowid);//是否需要提交确认
//TD8715 获取工作流信息，是否显示流程图
WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String isShowChart = Util.null2String(WFManager.getIsShowChart());
//System.out.println("isShowChart = " + isShowChart);
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");

//把session存储在SESSION中，供浏览框调用，达到不同的流程可以使用同一浏览框，不同的条件
session.setAttribute("workflowidbybrowser",workflowid+"");

if(RecordSet.next()){
	isModifyLog = Util.null2String(RecordSet.getString("isModifyLog"));//by cyril on 2008-07-09 for TD:8835
	formid = Util.getIntValue(RecordSet.getString("formid"),0);
	isbill = ""+Util.getIntValue(RecordSet.getString("isbill"),0);
	helpdocid = Util.getIntValue(RecordSet.getString("helpdocid"),0);
}
RecordSet.executeSql("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isSignMustInputOfThisJsp = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}

session.setAttribute(userid+"_"+requestid+"currentnodeid",""+currentnodeid);
session.setAttribute(userid+"_"+requestid+"currentnodetype",currentnodetype);
session.setAttribute(userid+"_"+requestid+"isaffirmance",isaffirmance);
session.setAttribute(userid+"_"+requestid+"reEdit",reEdit);
session.setAttribute(userid+"_"+requestid+"workflowname",workflowname);
request.setAttribute(userid+"_"+workflowid+"workflowname",workflowname);
session.setAttribute(userid+"_"+requestid+"issecurity",""+issecurity);
session.setAttribute(userid+"_"+requestid+"lastOperator",""+lastOperator);
session.setAttribute(userid+"_"+requestid+"lastOperateDate",lastOperateDate);
session.setAttribute(userid+"_"+requestid+"lastOperateTime",lastOperateTime);

//判断是否有流程创建文档，并且在该节点是有正文字段
boolean docFlag=flowDoc.haveDocFiled(""+workflowid,""+nodeid);
String  docFlagss=docFlag?"1":"0";
session.setAttribute("requestAdd"+requestid,docFlagss);

WFForwardManager.init();
WFForwardManager.setWorkflowid(workflowid);
WFForwardManager.setNodeid(nodeid);
WFForwardManager.setIsremark(Util.getIntValue(isremarkForRM,0)+"");
WFForwardManager.setRequestid(requestid);
WFForwardManager.setBeForwardid(wfcurrrid);
WFForwardManager.getWFNodeInfo();
String IsPendingForward=WFForwardManager.getIsPendingForward();
String IsBeForward=WFForwardManager.getIsBeForward();
String IsSubmitedOpinion=WFForwardManager.getIsSubmitedOpinion();
String IsSubmitForward=WFForwardManager.getIsSubmitForward();
String IsWaitForwardOpinion=WFForwardManager.getIsWaitForwardOpinion();
String IsBeForwardSubmit=WFForwardManager.getIsBeForwardSubmit();
String IsBeForwardModify=WFForwardManager.getIsBeForwardModify();
String IsBeForwardPending=WFForwardManager.getIsBeForwardPending();
boolean IsFreeWorkflow=WFForwardManager.getIsFreeWorkflow(requestid,nodeid,Util.getIntValue(isremarkForRM));
String IsFreeNode=WFForwardManager.getIsFreeNode(nodeid);
session.setAttribute(userid+"_"+requestid+"wfcurrrid",""+wfcurrrid);
boolean IsCanSubmit=WFForwardManager.getCanSubmit();
boolean IsBeForwardCanSubmitOpinion=WFForwardManager.getBeForwardCanSubmitOpinion();
boolean IsCanModify=WFForwardManager.getCanModify();
WFCoadjutantManager.getCoadjutantRights(groupdetailid);
String coadsigntype=WFCoadjutantManager.getSigntype();
String coadissubmitdesc=WFCoadjutantManager.getIssubmitdesc();
String coadisforward=WFCoadjutantManager.getIsforward();
String coadismodify=WFCoadjutantManager.getIsmodify();
String coadispending=WFCoadjutantManager.getIspending();
if(!IsCanModify&&coadismodify.equals("1")) IsCanModify=true;
boolean coadCanSubmit=WFCoadjutantManager.getCoadjutantCanSubmit(requestid,wfcurrrid,isremarkForRM,coadsigntype);
session.setAttribute(userid+"_"+requestid+"coadsigntype",coadsigntype);
session.setAttribute(userid+"_"+requestid+"coadissubmitdesc",coadissubmitdesc);
session.setAttribute(userid+"_"+requestid+"coadisforward",coadisforward);
session.setAttribute(userid+"_"+requestid+"coadismodify",coadismodify);
session.setAttribute(userid+"_"+requestid+"coadispending",coadispending);
session.setAttribute(userid+"_"+requestid+"coadCanSubmit",""+coadCanSubmit);
session.setAttribute(userid+"_"+requestid+"IsPendingForward",IsPendingForward);
session.setAttribute(userid+"_"+requestid+"IsBeForward",IsBeForward);
session.setAttribute(userid+"_"+requestid+"IsSubmitedOpinion",IsSubmitedOpinion);
session.setAttribute(userid+"_"+requestid+"IsSubmitForward",IsSubmitForward);
session.setAttribute(userid+"_"+requestid+"IsWaitForwardOpinion",IsWaitForwardOpinion);
session.setAttribute(userid+"_"+requestid+"IsBeForwardSubmit",IsBeForwardSubmit);
session.setAttribute(userid+"_"+requestid+"IsBeForwardModify",IsBeForwardModify);
session.setAttribute(userid+"_"+requestid+"IsBeForwardPending",IsBeForwardPending);
session.setAttribute(userid+"_"+requestid+"IsCanSubmit",""+IsCanSubmit);
session.setAttribute(userid+"_"+requestid+"IsBeForwardCanSubmitOpinion",""+IsBeForwardCanSubmitOpinion);
session.setAttribute(userid+"_"+requestid+"IsCanModify",""+IsCanModify);
session.setAttribute(userid+"_"+requestid+"IsFreeWorkflow",""+IsFreeWorkflow);
session.setAttribute(userid+"_"+requestid+"IsFreeNode",""+IsFreeNode);
session.setAttribute(userid+"_"+requestid+"issecurity",""+issecurity);

if(isremarkForRM.equals("8")||(isremarkForRM.equals("1")&&!IsCanSubmit)||("7".equals(isremarkForRM)&&!coadCanSubmit)){
    RecordSet.executeProc("workflow_CurrentOperator_Copy", requestid + "" + flag + userid + flag + usertype + "");
    if (currentnodetype.equals("3")) {
        RecordSet.executeSql("update workflow_currentoperator set iscomplete=1 where requestid=" + requestid + " and userid=" + userid + " and usertype=" + usertype);
    }
    isremarkForRM="2";
    istoManagePage=false;
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
    	response.sendRedirect("/worktask/request/ViewWorktask.jsp?requestid="+wt_requestid);
		return;
    }

}

String message = Util.null2String(request.getParameter("message"));       // 返回的错误信息

session.setAttribute(userid+"_"+requestid+"requestname",requestname);
session.setAttribute(userid+"_"+requestid+"workflowid",""+workflowid);
session.setAttribute(userid+"_"+requestid+"nodeid",""+nodeid);
session.setAttribute(userid+"_"+requestid+"preisremark",""+preisremark);
if(((isremarkForRM.equals("0")||isremarkForRM.equals("1"))&&!IsCanSubmit)||(isremarkForRM.equals("7")&&!coadCanSubmit)) istoManagePage=false;
session.setAttribute(userid+"_"+requestid+"formid",""+formid);
session.setAttribute(userid+"_"+requestid+"billid",""+billid);
session.setAttribute(userid+"_"+requestid+"isbill",isbill);
session.setAttribute(userid+"_"+requestid+"nodetype",nodetype);
session.setAttribute(userid+"_"+requestid+"creater",""+creater);
session.setAttribute(userid+"_"+requestid+"creatertype",""+creatertype);

// 记录查看日志
String clientip = request.getRemoteAddr();
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;

boolean isOldWf = false;
if(isprint==false){
RecordSet4.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSet4.next()){
	if(RecordSet4.getString("nodeid") == null || "".equals(RecordSet4.getString("nodeid")) || "-1".equals(RecordSet4.getString("nodeid"))){
			isOldWf = true;
	}
}
}

String imagefilename = "/images/hdReport.gif";
String titlename =  SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage()) + " - " +  status + " "+requestmark ;//Modify by 杨国生 2004-10-26 For TD1231
//if(helpdocid !=0 ) {titlename=titlename + "<img src=/images/help.gif style=\"CURSOR:hand\" width=12 onclick=\"location.href='/docs/docs/DocDsp.jsp?id="+helpdocid+"'\">";}
String needfav ="1";
String needhelp ="";
//add by mackjoe at 2005-12-20 增加模板应用
String ismode="";
int modeid=0;
int isform=0;
int showdes=0;
int printdes=0;
int toexcel=0;
RecordSet.executeSql("select ismode,showdes,printdes,toexcel from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
    showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
    printdes=Util.getIntValue(Util.null2String(RecordSet.getString("printdes")),0);
    toexcel=Util.getIntValue(Util.null2String(RecordSet.getString("toexcel")),0);
}
if(ismode.equals("1")){
	ismode="0";
}
if("2".equals(ismode)){
	weaver.workflow.exceldesign.HtmlLayoutOperate htmlLayoutOperate = new weaver.workflow.exceldesign.HtmlLayoutOperate();
	modeid = htmlLayoutOperate.getActiveHtmlLayout(workflowid, nodeid, 0);
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script> 
<style>
/*****weaver.css *****/
BODY {
	FONT-SIZE: 9pt; MARGIN: 0px; FONT-FAMILY: Verdana; LIST-STYLE-TYPE: circle; scrollbar-base-color:#FFFFCC; scrollbar-face-color:#d6d3ce; SCROLLBAR-HIGHLIGHT-COLOR: #f5f9ff; SCROLLBAR-SHADOW-COLOR: #D6D3D6; SCROLLBAR-3DLIGHT-COLOR: #D6D3D6; SCROLLBAR-ARROW-COLOR: #797979; SCROLLBAR-TRACK-COLOR: #EFF3F7; SCROLLBAR-DARKSHADOW-COLOR: #ffffff 
}
TABLE {
	FONT-SIZE: 9pt; FONT-FAMILY: Verdana
}
TABLE.Form {
	BORDER-RIGHT: medium none; PADDING-RIGHT: 0px; BORDER-TOP: medium none; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; BORDER-LEFT: medium none; WIDTH: 100%; BORDER-BOTTOM: medium none
}
TABLE.Form TR {
	
}
TABLE.Form TR.Section {
	
}
TABLE.Form TR.Section TH {
	TEXT-INDENT: -1pt; TEXT-ALIGN: left
}
TABLE.Form TR.Separator {
	HEIGHT: 4px
}
TABLE.Form TD {
	PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; PADDING-TOP: 0px
}
TABLE.Form TD.Field {
	PADDING-RIGHT: 3px; PADDING-LEFT: 2px; BACKGROUND-COLOR: #efefef
}
TABLE.Form TD.Sep1 {
	BACKGROUND-IMAGE: url(../images/Sep1.gif); BACKGROUND-REPEAT: repeat-x; HEIGHT: 3px
}
TABLE.Form TD.Sep2 {
	BACKGROUND-IMAGE: url(../images/Sep2.gif); BACKGROUND-REPEAT: repeat-x; HEIGHT: 3px
}
TABLE.Form TD.Sep3 {
	BACKGROUND-IMAGE: url(../images/Sep3.gif); BACKGROUND-REPEAT: repeat-x; HEIGHT: 3px
}
TABLE.ListShort {
	BORDER-RIGHT: 0px; PADDING-RIGHT: 0px; BORDER-TOP: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; BORDER-LEFT: 0px; WIDTH: 100%; PADDING-TOP: 0px; BORDER-BOTTOM: 0px
}
TABLE.ListShort TR {
	
}
TABLE.ListShort TR.Section {
	
}
TABLE.ListShort TR.Section TH {
	TEXT-ALIGN: left
}
TABLE.ListShort TR.Separator {
	HEIGHT: 3px
}
TABLE.ListShort TR.Header {
	COLOR: #000000; BACKGROUND-COLOR: #d6d3ce
}
TABLE.ListShort TR.Header TD {
	BORDER-RIGHT: #c5c5c5 1pt solid; PADDING-RIGHT: 3pt; BORDER-TOP: #c5c5c5 1pt solid; FONT-WEIGHT: normal; VERTICAL-ALIGN: text-top; BORDER-LEFT: #c5c5c5 1pt solid; PADDING-TOP: 2pt; BORDER-BOTTOM: #c5c5c5 1pt solid; TEXT-ALIGN: left ; 
}
TABLE.ListShort TR.Header TH {
	BORDER-RIGHT: #c5c5c5 1pt solid; PADDING-RIGHT: 3pt; BORDER-TOP: #c5c5c5 1pt solid; FONT-WEIGHT: normal; VERTICAL-ALIGN: text-top; BORDER-LEFT: #c5c5c5 1pt solid; PADDING-TOP: 2pt; BORDER-BOTTOM: #c5c5c5 1pt solid; TEXT-ALIGN: left
}
TABLE.ListShort TR.DataDark {
	BACKGROUND-COLOR: #e7e7e7
}
TABLE.ListShort TR.DataDark TD {
	PADDING-RIGHT: 4pt; PADDING-LEFT: 1pt; LINE: 100%
}
TABLE.ListShort TR.DataLight {
	BACKGROUND-COLOR: #f5f5f5
}
TABLE.ListShort TR.DataLight TD {
	PADDING-RIGHT: 4pt; PADDING-LEFT: 1pt; LINE: 100%
}
TABLE.ListShort TR.DataField {
	BACKGROUND-COLOR: #efefef
}
TABLE.ListShort TR.DataField TD {
	PADDING-RIGHT: 4pt; PADDING-LEFT: 1pt; LINE: 100%
}
TABLE.ListShort TR.Selected {
	CURSOR: hand; COLOR: #ffffff; BACKGROUND-COLOR: #959595
}
TABLE.ListShort TR.Selected TD {
	PADDING-RIGHT: 4pt; PADDING-LEFT: 1pt
}
TABLE.ListShort TR.DataOutline1 {
	FONT-WEIGHT: bold; COLOR: #ce0031; BACKGROUND-COLOR: #ffffff
}
TABLE.ListShort TR.DataOutline1 TD {
	PADDING-RIGHT: 4pt; BORDER-TOP: #daacb7 1pt solid; PADDING-LEFT: 1pt
}
TABLE.ListShort TR.DataOutline2 {
	FONT-WEIGHT: bold; COLOR: #1d9dff; BACKGROUND-COLOR: #ffffff
}
TABLE.ListShort TR.DataOutline2 TD {
	PADDING-RIGHT: 4pt; PADDING-LEFT: 1pt
}
TABLE.ListShort TR.DataOutline3 {
	FONT-WEIGHT: bold; COLOR: #939393; BACKGROUND-COLOR: #ffffff
}
TABLE.ListShort TR.DataOutline3 TD {
	PADDING-RIGHT: 4pt; PADDING-LEFT: 1pt
}
TABLE.ListShort TR.DataOutline4 {
	FONT-WEIGHT: bold; COLOR: #fbaa2b; BACKGROUND-COLOR: #ffffff
}
TABLE.ListShort TR.DataOutline4 TD {
	PADDING-RIGHT: 4pt; PADDING-LEFT: 1pt
}
TABLE.ListShort TR.Total TD {
	BORDER-RIGHT: #b4b4b4 1pt solid; PADDING-RIGHT: 4pt; BORDER-TOP: #b4b4b4 1pt solid; PADDING-LEFT: 1pt; FONT-WEIGHT: bold; VERTICAL-ALIGN: text-top; BORDER-LEFT: #b4b4b4 1pt solid; BORDER-BOTTOM: #b4b4b4 1pt solid
}
TABLE.ListShort TD.Sep1 {
	BACKGROUND-IMAGE: url(/images/Sep1.gif); BACKGROUND-REPEAT: repeat-x; HEIGHT: 3px
}
TABLE.ListShort TD.Sep2 {
	BACKGROUND-IMAGE: url(/images/Sep2.gif); BACKGROUND-REPEAT: repeat-x; HEIGHT: 3px
}
TABLE.ListShort TD.Sep3 {
	BACKGROUND-IMAGE: url(/images/Sep3.gif); BACKGROUND-REPEAT: repeat-x; HEIGHT: 3px
}
TABLE.Monitor {
	PADDING-RIGHT: 0px; PADDING-LEFT: 0px; FONT-SIZE: 9pt; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 22px
}
TABLE.Monitor TD.Entity {
	BORDER-RIGHT: #7a90b2 1pt solid; BORDER-TOP: #7a90b2 1pt solid; PADDING-LEFT: 2pt; BORDER-LEFT: #7a90b2 1pt solid; BORDER-BOTTOM: #7a90b2 1pt solid; BACKGROUND-COLOR: #d6d3ce
}

DIV.Btnbar {
	
}
DIV.HdrTitle {
	BACKGROUND-COLOR: #f4f4f4
}
DIV.HdrProps {
	PADDING-LEFT: 2pt; FONT-SIZE: 9pt; COLOR: #676767; HEIGHT: 14px; BACKGROUND-COLOR: #e5e5e5
}
DIV.HdrProps TD {
	COLOR: #676767
}
DIV.Chart {
	LEFT: 10px; POSITION: relative; TOP: 10px
}
TABLE.ChartTop {
	BORDER-RIGHT: 2px outset; BORDER-TOP: 2px outset; BORDER-LEFT: 2px outset; CURSOR: hand; COLOR: white; BORDER-BOTTOM: 2px outset; BACKGROUND-COLOR: #0070BF
}
TABLE.ChartGroup {
	BORDER-RIGHT: 2px outset; BORDER-TOP: 2px outset; BORDER-LEFT: 2px outset; CURSOR: hand; BORDER-BOTTOM: 2px outset; BACKGROUND-COLOR: #659BF5; TEXT-ALIGN: center
}
TABLE.ChartCompany {
	BORDER-RIGHT: 2px outset; BORDER-TOP: 2px outset; BORDER-LEFT: 2px outset; CURSOR: hand; BORDER-BOTTOM: 2px outset; BACKGROUND-COLOR: #51B5EE; TEXT-ALIGN: center
}
TABLE.ChartInactive {
	BORDER-RIGHT: 2px outset; BORDER-TOP: 2px outset; BORDER-LEFT: 2px outset; CURSOR: hand; COLOR: gray; BORDER-BOTTOM: 2px outset; BACKGROUND-COLOR: #ffcccc; TEXT-ALIGN: center
}
TABLE.ChartDisabled {
	BORDER-RIGHT: 2px outset; BORDER-TOP: 2px outset; BORDER-LEFT: 2px outset; COLOR: gray; BORDER-BOTTOM: 2px outset; BACKGROUND-COLOR: #ffcc00; TEXT-ALIGN: center
}
TD.ChartTop {
	COLOR: white; HEIGHT: 100%; BACKGROUND-COLOR: #1397D4; TEXT-ALIGN: center
}
TD.ChartGroup {
	COLOR: black; HEIGHT: 100%; BACKGROUND-COLOR: #c6c3bd; TEXT-ALIGN: center
}
TD.ChartCompany {
	COLOR: black; HEIGHT: 100%; BACKGROUND-COLOR: #d6d3ce; TEXT-ALIGN: center
}
TD.ChartInactive {
	COLOR: gray; HEIGHT: 100%; BACKGROUND-COLOR: #ffcc99; TEXT-ALIGN: center
}
TD.ChartDisabled {
	COLOR: gray; HEIGHT: 100%; BACKGROUND-COLOR: #ffcc66; TEXT-ALIGN: center
}
TD.ChartDescription {
	COLOR: black; BACKGROUND-COLOR: gainsboro; TEXT-ALIGN: left
}
TD.ChartValue {
	COLOR: black; BACKGROUND-COLOR: gainsboro; TEXT-ALIGN: right
}
TD.ChartCell {
	WIDTH: 100px; COLOR: black; BACKGROUND-COLOR: gainsboro; TEXT-ALIGN: right
}
TD.ChartValueLow {
	COLOR: black; BACKGROUND-COLOR: #ff9900; TEXT-ALIGN: right
}
TD.ChartValueHigh {
	COLOR: black; BACKGROUND-COLOR: #99ff33; TEXT-ALIGN: right
}
TD.Selected
{
    CURSOR: hand;
    COLOR: #FFFFFF;
    BACKGROUND-COLOR: #959595
}
.FieldLong {
	WIDTH: 267px
}
.FieldLongB {
	WIDTH: 242px
}
.FieldxLong {
	WIDTH: 696px
}
.FieldShort {
	WIDTH: 126px
}
.FieldxShort {
	WIDTH: 50px
}
.saveHistory {
	BEHAVIOR: url(#default#savehistory)
}
INPUT.text {
	FONT-SIZE: 100% 
}
SELECT {
	FONT-SIZE: 100%; FONT-FAMILY: 宋体, MS Sans Serif, Arial
}
TEXTAREA {
	FONT-SIZE: 100%; FONT-FAMILY: 宋体, MS Sans Serif, Arial
}
FORM {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px
}
PRE {
	FONT-SIZE: 14pt
}

.titlename {
 	FONT-WEIGHT: bold; FONT-SIZE: 16pt
 }

BUTTON.DELROW {
	BORDER-RIGHT: medium none;
	BORDER-TOP: medium none;
	BACKGROUND-IMAGE: url(/images/BacoDelete.GIF);
	OVERFLOW: hidden;
	BORDER-LEFT: medium none;
	CURSOR: hand;
	WIDTH: 16px;
	HEIGHT: 16px;
	BORDER-BOTTOM: medium none;
	BACKGROUND-REPEAT: no-repeat;
	BACKGROUND-COLOR: transparent;
}

.smallfont {
	FONT-SIZE: 10pt
}
.fontred {
    COLOR: #FF0000;
}

A {
	COLOR: blue; TEXT-DECORATION: underline
}
A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
A:visited {
	TEXT-DECORATION: underline}

TABLE.Shadow {
	border: #000000 ;
	width:100% ;
	height:100% ;
	BORDER-color:#ffffff;
	BORDER-TOP: 3px outset #ffffff;
	BORDER-RIGHT: 3px outset #000000;
	BORDER-BOTTOM: 3px outset #000000;
	BORDER-LEFT: 3px outset #ffffff;
	BACKGROUND-COLOR:#FFFFFF
}

TABLE.Shadow A {
	COLOR: blue; TEXT-DECORATION: underline
}
TABLE.Shadow A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

TABLE.Shadow A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
TABLE.Shadow A:visited {
	TEXT-DECORATION: underline
}

DIV.TopTitle {
	BORDER-RIGHT: #979797 1px solid;
	BORDER-TOP: #979797 1px solid;
	BORDER-LEFT: #979797 1px solid; 
	BORDER-BOTTOM: #979797 1px solid;
	BACKGROUND-COLOR: #ECECEC
}
DIV.TopTitle {
	PADDING-LEFT: 2pt; FONT-SIZE: 9pt; COLOR: #B7C6CF; HEIGHT: 14px; BACKGROUND-COLOR: #ECECEC
}
DIV.TopTitle TD {
	COLOR: #000000
}

DIV.TopTitle A {
	COLOR: blue; TEXT-DECORATION: underline
}
DIV.TopTitle A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

DIV.TopTitle A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
DIV.TopTitle A:visited {
	TEXT-DECORATION: underline
}

TABLE.ViewForm {
	BORDER-RIGHT: medium none; PADDING-RIGHT: 0px; BORDER-TOP: medium none; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; BORDER-LEFT: medium none; WIDTH: 100%; BORDER-BOTTOM: medium none;
	cellspacing:0;cellpadding:0
}

TABLE.ViewForm A {
	COLOR: blue; TEXT-DECORATION: underline
}
TABLE.ViewForm A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

TABLE.ViewForm A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
TABLE.ViewForm A:visited {
	TEXT-DECORATION: underline}


TABLE.ViewForm TR {
	
}

TABLE.ViewForm TR.Title TH {
	TEXT-INDENT: -1pt; TEXT-ALIGN: left
}
TABLE.ViewForm TR.Spacing {
	HEIGHT: 4px
}
TABLE.ViewForm TD {
	PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; PADDING-TOP: 0px
}
TABLE.ViewForm TD.Field {
	PADDING-RIGHT: 3px; PADDING-LEFT: 2px; BACKGROUND-COLOR: #EAEAEA
}

TD.Field A {
	COLOR: blue; TEXT-DECORATION: underline
}
TD.Field A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

TD.Field A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
TD.Field A:visited {
	TEXT-DECORATION: underline}

TABLE.ViewForm TD.Line {
	BACKGROUND-COLOR: #ECECEC; BACKGROUND-REPEAT: repeat-x; HEIGHT: 1px
}
TABLE.ViewForm TD.Line1 {
	BACKGROUND-COLOR: #A1A1A1; BACKGROUND-REPEAT: repeat-x; HEIGHT: 2px
}
TABLE.ViewForm TD.Line2 {
	BACKGROUND-COLOR: #ECECEC; BACKGROUND-REPEAT: repeat-x; HEIGHT: 1px
}

.InputStyle{
BORDER-LEFT-STYLE: none; 
BORDER-RIGHT-STYLE: none;
BORDER-TOP-STYLE: none ;
BORDER-BOTTOM: #000000 1px solid;
BACKGROUND-COLOR: #FFFFFF
}
.Label{
BORDER-LEFT-STYLE: none; 
BORDER-RIGHT-STYLE: none;
BORDER-TOP-STYLE: none ;
BORDER-BOTTOM: none;
background-color:transparent;
text-align: center
}
.InputStyle_1{
BORDER-BOTTOM: #626262 1px solid; 
BORDER-LEFT: #626262 1px solid; 
BORDER-RIGHT: #626262 1px solid; 
BORDER-TOP: #626262 1px solid; 
BACKGROUND-COLOR: #FFFFFF;
padding-top:2px
}



TABLE.ListStyle {
	width:"100%" ;
	BACKGROUND-COLOR: #FFFFFF ;
	BORDER-Spacing:1pt ; 
}
TABLE.ListStyle A {
	COLOR: blue; TEXT-DECORATION: underline
}
TABLE.ListStyle A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

TABLE.ListStyle A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
TABLE.ListStyle A:visited {
	TEXT-DECORATION: underline}

TABLE.ListStyle TR {
	
}
TABLE.ListStyle TR.Title {
	
}
TABLE.ListStyle TR.Title TH {
	TEXT-ALIGN: left
}
TABLE.ListStyle TR.Spacing {
	HEIGHT: 1px
}
TABLE.ListStyle TR.Header {
	COLOR: #003366; BACKGROUND-COLOR: #C8C8C8 ; HEIGHT: 30px ;BORDER-Spacing:1pt
}
TR.Header A {
	COLOR: black; TEXT-DECORATION: underline
}
TR.Header A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

TR.Header A:link {
	COLOR: black; TEXT-DECORATION: underline
}
TR.Header A:visited {
	TEXT-DECORATION: underline}
TABLE.ListStyle TR.Header TD {
	COLOR: #003366 
}
TABLE.ListStyle TR.Header TH {
	COLOR: #003366 ;
	TEXT-ALIGN: left
}


TABLE.ListStyle TR.HeaderForWf {
	COLOR: #003366; BACKGROUND-COLOR: #E4E4E4 ; HEIGHT: 30px ;BORDER-Spacing:1pt
}
TR.HeaderForWf A {
	COLOR: black; TEXT-DECORATION: underline
}
TR.HeaderForWf A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

TR.HeaderForWf A:link {
	COLOR: black; TEXT-DECORATION: underline
}
TR.HeaderForWf A:visited {
	TEXT-DECORATION: underline}
TABLE.ListStyle TR.HeaderForWf TD {
	COLOR: #003366 
}
TABLE.ListStyle TR.HeaderForWf TH {
	COLOR: #003366 ;
	TEXT-ALIGN: left
}


TABLE.ListStyle TR.HeaderForXtalbe {
	cursor:hand; COLOR: #003366; BACKGROUND-COLOR: #C8C8C8 ; HEIGHT: 30px ;BORDER-Spacing:1pt
}
TR.HeaderForXtalbe A {
	COLOR: black; TEXT-DECORATION: underline
}
TR.HeaderForXtalbe A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

TR.HeaderForXtalbe A:link {
	COLOR: black; TEXT-DECORATION: underline
}
TR.HeaderForXtalbe A:visited {
	TEXT-DECORATION: underline}
TABLE.ListStyle TR.HeaderForXtalbe TD {
	COLOR: #003366 
}
TABLE.ListStyle TR.HeaderForXtalbe TH {
	COLOR: #003366 ;
	TEXT-ALIGN: left
}


TABLE.ListStyle TR.DataDark {
	BACKGROUND-COLOR: #F7F7F7 ; HEIGHT: 22px ; BORDER-Spacing:1pt
}
TABLE.ListStyle TR.DataDark TD {
	PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}

TABLE.ListStyle TR.DataLight {
	BACKGROUND-COLOR: #FFFFFF ; HEIGHT: 22px ; BORDER-Spacing:1pt 
}
TABLE.ListStyle TR.DataLight TD {
	PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}

TABLE.ListStyle TR.DataField {
	BACKGROUND-COLOR: #efefef
}
TABLE.ListStyle TR.DataField TD {
	PADDING-RIGHT: 4pt; PADDING-LEFT: 1pt; LINE: 100%
}
TABLE.ListStyle TR.Selected {
	BACKGROUND-COLOR: #EAEAEA ; HEIGHT: 22px ; BORDER-Spacing:1pt 
}
TABLE.ListStyle TR.Selected TD {
	PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}
TABLE.ListStyle TR.DataOutline1 {
	FONT-WEIGHT: bold; COLOR: #ce0031; BACKGROUND-COLOR: #ffffff
}
TABLE.ListStyle TR.DataOutline1 TD {
	PADDING-RIGHT: 4pt; BORDER-TOP: #daacb7 1pt solid; PADDING-LEFT: 1pt
}
TABLE.ListStyle TR.DataOutline2 {
	FONT-WEIGHT: bold; COLOR: #1d9dff; BACKGROUND-COLOR: #ffffff
}
TABLE.ListStyle TR.DataOutline2 TD {
	PADDING-RIGHT: 4pt; PADDING-LEFT: 1pt
}
TABLE.ListStyle TR.DataOutline3 {
	FONT-WEIGHT: bold; COLOR: #939393; BACKGROUND-COLOR: #ffffff
}
TABLE.ListStyle TR.DataOutline3 TD {
	PADDING-RIGHT: 4pt; PADDING-LEFT: 1pt
}
TABLE.ListStyle TR.DataOutline4 {
	FONT-WEIGHT: bold; COLOR: #fbaa2b; BACKGROUND-COLOR: #ffffff
}
TABLE.ListStyle TR.DataOutline4 TD {
	PADDING-RIGHT: 4pt; PADDING-LEFT: 1pt
}
TABLE.ListStyle TR.Total TD {
	BORDER-RIGHT: #b4b4b4 1pt solid; PADDING-RIGHT: 4pt; BORDER-TOP: #b4b4b4 1pt solid; PADDING-LEFT: 1pt; FONT-WEIGHT: bold; VERTICAL-ALIGN: text-top; BORDER-LEFT: #b4b4b4 1pt solid; BORDER-BOTTOM: #b4b4b4 1pt solid
}
TABLE.ListStyle TR.Line {
	 BACKGROUND-COLOR: #EFEFEF ; BACKGROUND-REPEAT: repeat-x; HEIGHT: 3px
}
TABLE.ListStyle TR.Line2 {
	 BACKGROUND-COLOR: #EFEFEF ; BACKGROUND-REPEAT: repeat-x; HEIGHT: 3px
}
TABLE.ListStyle TD.Line1 {
	 BACKGROUND-COLOR: #A1A1A1 ; BACKGROUND-REPEAT: repeat-x; HEIGHT: 2px
}
TABLE.BroswerStyle {
	width:"100%" ;
	BACKGROUND-COLOR: #FFFFFF ;
	BORDER-Spacing:1pt ; 
}

TABLE.BroswerStyle A {
	COLOR: blue; TEXT-DECORATION: underline
}
TABLE.BroswerStyle A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

TABLE.BroswerStyle A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
TABLE.BroswerStyle A:visited {
	TEXT-DECORATION: underline}

TABLE.BroswerStyle TR {
	
}
TABLE.BroswerStyle TR.Title {
	
}
TABLE.BroswerStyle TR.Title TH {
	TEXT-ALIGN: left
}
TABLE.BroswerStyle TR.Spacing {
	HEIGHT: 1px
}
TABLE.BroswerStyle TR.DataHeader {
	COLOR: #000000; BACKGROUND-COLOR: #BFBFBF ; HEIGHT: 22px ;BORDER-Spacing:1pt
}
TABLE.BroswerStyle TR.DataHeader TD {
	COLOR: #000000 
}
TABLE.BroswerStyle TR.DataHeader TH {
	COLOR: #000000 ;
	TEXT-ALIGN: left
}
TABLE.BroswerStyle TR.DataDark {
	BACKGROUND-COLOR: #e7e7e7 ; HEIGHT: 22px ; BORDER-Spacing:1pt
}
TABLE.BroswerStyle TR.DataDark TD {
	PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}
TABLE.BroswerStyle TR.DataLight {
	BACKGROUND-COLOR: #f5f5f5 ; HEIGHT: 22px ; BORDER-Spacing:1pt 
}
TABLE.BroswerStyle TR.DataLight TD {
	PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}
TABLE.BroswerStyle TR.Line {
	 BACKGROUND-COLOR: #D3D6D8 ; BACKGROUND-REPEAT: repeat-x; HEIGHT: 3px
}

TABLE.BroswerStyle TR.Selected
{
    CURSOR: hand;
    COLOR: #000000;
    BACKGROUND-COLOR: #C8C8C8 ;
	HEIGHT: 22px 
}
TABLE.BroswerStyle TR.Selected TD
{
PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}
TD
{
}
TD A:link
{
    COLOR: black;
    TEXT-DECORATION: none
}
TD A:visited
{
    COLOR: black;
    TEXT-DECORATION: none
}
TABLE.BroswerStyle TR.Selected A:link
{
    COLOR: black;
    TEXT-DECORATION: none;

}
TABLE.BroswerStyle TR.Selected A:visited
{
    COLOR: black;
    TEXT-DECORATION: none;
}




TABLE.ReportStyle {
	width:"100%" ;
	BACKGROUND-COLOR: #000000 	
}
TABLE.ReportStyle A {
	COLOR: blue; TEXT-DECORATION: underline
}
TABLE.ReportStyle A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

TABLE.ReportStyle A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
TABLE.ReportStyle A:visited {
	TEXT-DECORATION: underline}

TABLE.ReportStyle TR.Header {
	COLOR: #FFFFFF; BACKGROUND-COLOR: #BFBFBF ; HEIGHT: 22px 
}
TR.Header A {
	COLOR: black; TEXT-DECORATION: underline
}
TR.Header A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

TR.Header A:link {
	COLOR: black; TEXT-DECORATION: underline
}
TR.Header A:visited {
	TEXT-DECORATION: underline}
TABLE.ReportStyle TR.Header TD {
	COLOR: #000000 
}
TABLE.ReportStyle TR.Header TH {
	COLOR: #000000 ;
	TEXT-ALIGN: left
}

TABLE.ReportStyle TR {
	BACKGROUND-COLOR: #FFFFFF 
}

hr{margin:0;padding:0;height:2px;color:#CCCCCC}
h2.title{margin:5;text-align:center;font-size:20px;font-weight:bold;}


span.href{cursor:hand;text-decoration:underline;color:blue}
div.help{border:0px solid #000;margin-top:10px;padding:5px;font-weight:bold}
.tabHeadDiv{
	width:100%;
	position:absolute;
	left:0px;
	top:2px;
	CELLSPACING:0;
}
.formSplitSpanIn{
	posiotion:relative;
	height:26px;
	font-size:12px;
	TEXT-DECORATION:none;
	color:#000000;
	cursor:hand;
	vertical-align : middle;
	text-align:center;
	padding-top: 8px;
	border-top:1px #D0D0D0 solid;
	border-right:1px #D0D0D0 solid;
	word-break:keep-all;
	word-wrap:normal;
	_filter : progid:DXImageTransform.Microsoft.Gradient ( enabled=bEnabled , startColorStr=#FFE7E7E7 , endColorStr=#FFFFFFFF );
}
.formSplitSpanOut{
	height:25px;
	font-size:12px;
	TEXT-DECORATION:none;
	color:#000000;
	cursor:hand;
	vertical-align : middle;
	text-align:center;
	padding-top: 8px;
	border-top:1px #D0D0D0 solid;
	border-bottom:1px #D0D0D0 solid;
	border-right:1px #D0D0D0 solid;
	word-break:keep-all;
	word-wrap:normal;
	_filter : progid:DXImageTransform.Microsoft.Gradient ( enabled=bEnabled , startColorStr=#FFFFFFFF , endColorStr=#FFE7E7E7 );
}
.borderFormSplitSpan{
	height:26px;
	width:1px;
	cursor:hand;
	vertical-align : middle;
	background-color: #D0D0D0;
}
.lastFormSplitSpan{
	height:26px;
	font-size:12px;
	TEXT-DECORATION:none;
	color:#000000;
	vertical-align : middle;
	text-align:center;
	padding-top: 8px;
	border-bottom:1px #D0D0D0 solid;
}
.formSplitDiv{
	width:100%

}
.detailAddTd{
	height : 24px;
	borderBottom : 1px #ffffff solid;
	BACKGROUND-COLOR : #E7E7E7;
	word-wrap : break-word;
	word-break : break-all;
}
.wordSpan{font-family:MS Shell Dlg,Arial;CURSOR: hand;font-weight:bold;FONT-SIZE: 10pt}

.outertable{
	border-collapse:collapse !important;
	border-style:solid !important;
	border-color: #005782 !important;
	border-width:2px !important;
}
.reqname{
	color:#000000 !important;
	font-size:16pt !important;
	font-weight:bold !important;
}
.maintable{
	border-collapse:collapse !important
	border-style:solid !important;
	border-color: #005782 !important;
	border-width:0px !important;
}
.fname{
	height: 20px !important;
	background-color: #C4E1FF !important;
	font-size:10pt !important;
	border-style:solid !important;
	border-color: #005782 !important;
	border-width:1px !important;
}
.fvalue{
	height: 20px !important;
	background-color: #FFFFFF !important;
	border-style:solid !important;
	border-color: #005782 !important;
	border-width:1px !important;
}
.detailtable{
	border-collapse:collapse !important;
	border-style:solid !important;
	border-color: #005782 !important;
	border-width:1px !important;
}
.detailtitle{
	height: 20px !important;
	font-size:10pt !important;
	background-color: #C4E1FF !important;
	border-style:solid !important;
	border-color: #005782 !important;
	border-width:1px !important;
}
.detailfield{
	background-color: #FFFFFF !important;
	border-bottom-style:solid !important;
	border-bottom-color: #005782 !important;
	border-bottom-width:1px !important;
}
</style>
<title><%=requestname%></title>
</head>
<body>



        <input type=hidden name=seeflowdoc value="<%=seeflowdoc%>">
		<input type=hidden name=isworkflowdoc value="<%=isworkflowdoc%>">
        <input type=hidden name=wfdoc value="<%=wfdoc%>">
        <input type=hidden name=picInnerFrameurl value="/workflow/request/WorkflowRequestPictureInner.jsp?isview=1&fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>">

		<TABLE width=100%>
		<tr>
		<td valign="top">
        <%if( message.equals("4") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(21266,user.getLanguage())%></font>
		<%} else if( message.equals("5") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(21270,user.getLanguage())%></font>
		<%} else if( message.equals("6") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(21766,user.getLanguage())%></font>
        <%} else if( message.equals("7") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(22751,user.getLanguage())%></font>
        <%} else if( message.equals("8") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(24676,user.getLanguage())%></font>
		<%}%>

<%
String viewpage= "";
if(isbill.equals("1")){
    RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
    if(RecordSet.next()) viewpage = RecordSet.getString("viewpage");
}
if( !viewpage.equals("")) {
	//TD10126 部分服务器下直接使用Util.null2String(request.getParameter("isprint"))传参数会出错
	String isprint_viewpage = Util.null2String(request.getParameter("isprint"));
	if(formid == 6){
		session.setAttribute("viewresourceplan", ""+requestid);
	}
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
    <jsp:param name="isprint" value="<%=isprint_viewpage%>" />
	<jsp:param name="desrequestid" value="<%=desrequestid%>" />
	<jsp:param name="isrequest" value="<%=isrequest%>" />
    <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="isurger" value="<%=isurger%>" />
    <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />

</jsp:include>
<%}else{%>

<form name="frmmain" method="post" action="RequestOperation.jsp" <%if (!fromPDA.equals("1")) {%> enctype="multipart/form-data" <%}%>>
<input type="hidden" name="needwfback"  id="needwfback" value="1"/>

<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>


	<%if("2".equals(ismode) && modeid>0){//这里故意写isremark=2%>
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
                <jsp:param name="isprint" value="0" />
                <jsp:param name="logintype" value="<%=logintype%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="nodetype" value="<%=nodetype%>" />
                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="isrequest" value="<%=isrequest%>" />
                <jsp:param name="isurger" value="<%=isurger%>" />
                <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="intervenorright" value="<%=intervenorright%>" />
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
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="intervenorright" value="<%=intervenorright%>" />
            </jsp:include>
	<%}
	if("1".equals(wfRemarkflag)){%>
            
			<jsp:include page="ExportRequestSign.jsp" flush="true">
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
      <%}%>
</form>
<%}
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
            <jsp:param name="desrequestid" value="<%=desrequestid%>" />
            <jsp:param name="intervenorright" value="<%=intervenorright%>" />
        </jsp:include>
<%		
	}
%>

	</td>
		</tr>
		</TABLE>

		
</body>
</html>