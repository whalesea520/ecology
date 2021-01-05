<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="weaver.general.* "%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.mobile.plugin.ecology.RequestOperation"%>
<%@ page import="weaver.mobile.webservices.workflow.*" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.mobile.webservices.common.HtmlUtil"%>
<%@page import="weaver.mobile.webservices.common.FIFOLinkedHashMap"%>
<%@page import="weaver.workflow.monitor.MonitorDTO"%>
<%@page import="org.json.JSONObject"%>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="weaver.workflow.request.WorkflowRequestMessage" %>
<%@ page import="weaver.workflow.html.FieldAttrManager" %>
<%@ page import="weaver.mobile.webservices.workflow.soa.RequestPreProcessing"%>
<%@ page import="java.io.*" %>
<%@page import="weaver.file.Prop,weaver.workflow.request.todo.RequestUtil" %>
<%@page import="weaver.formmode.ThreadLocalUser"%>  

<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page" /><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" /><!--xwj for td3665 20060224-->
<jsp:useBean id="SysWFLMonitor" class="weaver.system.SysWFLMonitor" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page" />


<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
String isDetailRowShow = Util.null2String(Prop.getPropValue("Mobile","isDetailRowShow"));
String detailcardshow = Util.null2String(Prop.getPropValue("Mobile","detailcardshow"));
//request message info start
String messageid = Util.null2String(request.getParameter("messageid"));
String resetoperator ="";
String systemwfInfo = "";
//request message info end

String detailid = Util.null2String(request.getParameter("detailid"));
String module = Util.null2String(request.getParameter("module"));
String scope = Util.null2String(request.getParameter("scope"));
String title = Util.null2String(request.getParameter("title"));
String clienttype = Util.null2String(request.getParameter("clienttype"));
String clientlevel = Util.null2String(request.getParameter("clientlevel"));
String clientVer = Util.null2String(request.getParameter("clientver"));
String serverVer = Util.null2String(request.getParameter("serverver"));
String type = Util.null2String(request.getParameter("type"));
String clientosver = Util.null2String(request.getParameter("clientosver"));
String ismonitor = Util.null2String(request.getParameter("ismonitor"));
String sessionkey = Util.null2String(request.getParameter("sessionkey"));
if("".equals(ismonitor) && module.equals("-1005")){
    ismonitor = "1";
}

int isurge1	= Util.getIntValue(request.getParameter("isurge"));
if(isurge1 <= 0 && module.equals("-1004")){
    isurge1 = 1;
}
String requestname="";      //请求名称
String requestlevel="";     //请求重要级别 0:正常 1:重要 2:紧急







String requestmark = "" ;   //请求编号
String isbill="0";          //是否单据 0:否 1:是







int creator=0;              //请求的创建人
int creatertype = 0;        //创建人类型 0: 内部用户 1: 外部用户
int deleted=0;              //请求是否删除  1:是 0或者其它 否







int billid=0 ;              //如果是单据,对应的单据表的id
String isModifyLog = "";		//是否记录表单日志 by cyril on 2008-07-09 for TD:8835





int formid=0;               //表单或者单据的id
int helpdocid = 0;          //帮助文档 id
String workflowname = "" ;         //工作流名称







String status = ""; //当前的操作类型







String docCategory="";//工作流目录








int lastOperator=0; //最后操作者id
String lastOperateDate="";//最后操作日期







String lastOperateTime="";//最后操作时间




boolean isurger=false;                  //督办人可查看
boolean wfmonitor=false;                //流程监控人


//ismonitor = "1";
boolean haveBackright=false;            //强制收回权限
boolean haveStopright = false;			//暂停权限
boolean haveCancelright = false;		//撤销权限
boolean haveRestartright = false;		//启用权限
boolean haveOverright=false;            //强制归档权限
int intervenorright = 0;   //流程干预




//2015/11/30 获取次账号信息 start
//User user = HrmUserVarify.getUser (request , response) ;

String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));//需要增加的代码


String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));//需要增加的代码
User user  = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码

String messagecontent = Util.null2String(session.getAttribute("msgcontent_"+user.getUID()+"_"+detailid));
String method = Util.null2String(request.getParameter("method"));
//2015/11/30 获取次账号信息 End
if(user == null)  return ;
ThreadLocalUser.setUser(user);
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;
char flag=Util.getSeparator() ;
int userid=user.getUID();

boolean isPreProcessing = (1 == Util.getIntValue(request.getParameter("isPreProc")));
String buttonswitch = Util.null2String(Prop.getPropValue("WebchatSwitch","buttonswitch"));

if(StringUtils.isNotBlank(detailid) && !isPreProcessing){
    File file = new File(RequestPreProcessing.getSystemFilePath()+"/cachefile/"+detailid+"/"+user.getUID()+"_view.html");
    if(file.exists()){
      try {
			String filecachestr = "";
			BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));
	        while (br.ready()) {
                filecachestr += br.readLine() + "\n";
            }
			filecachestr +="<script>var js_sessionkey='"+sessionkey+"';var js_module='"+module+"';var js_scope='"+scope+"';jQuery(function(){jQuery('#type').val("+type+");jQuery('#method2').val("+method+");jQuery('#clientver').val("+clientVer+");jQuery('#serverver').val("+serverVer+");jQuery('#ismonitor').val("+ismonitor+");if('"+clienttype+"'=='Webclient'){jQuery('#view_header').show();}else{jQuery('#view_header').hide();}jQuery('#workflowfrm').attr('action','/mobile/plugin/1/RequestOperation.jsp?module="+module+"&scope="+scope+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');});</script>";
		    br.close();
            PrintWriter writer = response.getWriter();
			writer.write(filecachestr);
			writer.flush();
			writer.close();
		} catch (Exception e) {}
        return;
    }
}

//仅仅在创建流程时候，才从request.getParameter取workflowid值


String workflowid = Util.null2String(request.getParameter("workflowid"));
//判断当前客户端程序版本是否高于4.5
boolean flagClientVersion4_5 = RequestOperation.compareVersion(clientVer, RequestOperation.VERSION_45);
//判断当前Mobile程序版本是否高于4.5
boolean flagServerVersion4_5 = RequestOperation.compareVersion(serverVer, RequestOperation.VERSION_45);
WorkflowServiceUtil.mobileVersion45 = flagServerVersion4_5;
WorkflowServiceUtil.clientMobileVersion45 = flagClientVersion4_5;
WorkflowServiceUtil.androidclienttype = "android".equals(clienttype) ;
WorkflowServiceUtil.androidclientosver = clientosver.compareTo("4.1.1")>=0;

int requestid = 0;

String userSignRemark = "";
String forwardresourceids = "";
String forwardresourceids2 = "";
String forwardresourceids3 = "";
String clientip = "";
WorkflowRequestInfo workflowRequestInfo = null;
String workflowHtmlShow = "";
String fromWF = "";
HttpServletRequest req = request;

requestid = Util.getIntValue(req.getParameter("requestid"), 0);
if (requestid == 0) {
	requestid = Util.getIntValue(detailid,0);
}


//如果method值为空，且requestId值为0或-1则为创建流程
if("".equals(method) && requestid <= 0){
	method = "create";
	type = "create";
}

int fromRequestid = Util.getIntValue(req.getParameter("fromRequestid"), 0);

//------------异构系统跳转 start
RequestUtil ru = new RequestUtil();
if(ru.isOpenOtherSystemToDo()&&requestid<0){
	String openurl = ru.getShowUrl(requestid+"",userid+"","1");
	System.out.println(openurl);
	response.sendRedirect(openurl);
	return;
}
//------------异构系统跳转 end

if(requestid<=0&&Util.getIntValue(workflowid)<=0) {
	response.sendRedirect("/mobile/plugin/1/createlist.jsp?sessionkey="+sessionkey+"&module="+module+"&scope="+scope+"&clienttype="+clienttype+"&clientlevel="+clientlevel);
	return;
}
boolean canview = false ;               // 是否可以查看
isurger=WFUrgerManager.UrgerHaveWorkflowViewRight(requestid,userid,Util.getIntValue(logintype,1));

int isurge = 0;
if(isurger){
   isurge = 1;
}
if(!canview&&!isurger){
	if("1".equals(ismonitor)){
		wfmonitor=WFUrgerManager.getMonitorViewRight(requestid,userid);
	}
} 

//监控、督办群组

Map<String, Object> otherinfo = new HashMap<String, Object>();
otherinfo.put("ismonitor", ismonitor);
otherinfo.put("isurger", isurge);
//应155683要求，添加module属性

otherinfo.put("module", module);


WorkflowService workflowWebService = new WorkflowServiceImpl();
WorkflowServiceUtil workflowServiceUtil = new WorkflowServiceUtil();
boolean iscanedit = workflowServiceUtil.iscanEdit(userid,requestid);

String wfReqInfoKey = "";
boolean isCanEditRemark = true;
int intModule = 0;
try{
    intModule = Integer.valueOf(module);
}catch(Exception e){
    
}
if ("create".equals(method)) {
	workflowRequestInfo = workflowWebService.getCreateWorkflowRequestInfo(Util.getIntValue(workflowid), userid);

	wfReqInfoKey = sessionkey + "_"+ workflowid + "_"+ userid;
} else {
    //判断是否监控、督办

    if(module!= null && intModule < 0){
        workflowRequestInfo = workflowWebService.getWorkflowRequest4split(requestid, userid, fromRequestid, 5, false, otherinfo);

        //监控和督办的时候，表单内容不可编辑
        if(workflowRequestInfo != null){
            workflowRequestInfo.setCanEdit(false);
            iscanedit = false;
        }
    }else{
        workflowRequestInfo = workflowWebService.getWorkflowRequest4split(requestid, userid, fromRequestid, 5, false);
    }
    
	
	workflowWebService.writeWorkflowReadFlag(String.valueOf(requestid), String.valueOf(userid), workflowRequestInfo.getIsremark());
	//wfReqInfoKey = "REQUESTID" + requestid + "_USERID"+ userid;
	wfReqInfoKey = sessionkey + "_" + workflowid + "_" + requestid + "_"+ userid;
}

if (workflowRequestInfo != null ) {
	StaticObj staticObj = StaticObj.getInstance();
	synchronized(staticObj){
	    Map mapWfReqInfos = (Map)staticObj.getObject("MOBILE_WORKFLOWREQUESTINFO_CACHE");
		if(mapWfReqInfos == null){
			mapWfReqInfos = new FIFOLinkedHashMap(10000);
			staticObj.putObject("MOBILE_WORKFLOWREQUESTINFO_CACHE", mapWfReqInfos);	
		}
		mapWfReqInfos.put(wfReqInfoKey, workflowRequestInfo);
	}
}


if(workflowRequestInfo==null){
    %><span><%=SystemEnv.getHtmlLabelName(126572,user.getLanguage()) %></span><%
    return;
    //没有权限
}
if (!"create".equals(method)) {
   isCanEditRemark =workflowRequestInfo.isCanEditRemark();
}

canview = workflowRequestInfo.isCanView();
if(!workflowRequestInfo.isCanView() && intModule != -1004 && intModule != -1005) {
    //没有权限
    %><span><%=SystemEnv.getHtmlLabelName(126572,user.getLanguage()) %></span><%
    return;
}

if(workflowRequestInfo.getWorkflowHtmlShow()!=null){
	workflowHtmlShow = StringUtils.defaultIfEmpty(workflowRequestInfo.getWorkflowHtmlShow()[0],"");
} else {
	workflowHtmlShow = "";
}
workflowid = workflowRequestInfo.getWorkflowBaseInfo().getWorkflowId();

boolean isvalid = workflowServiceUtil.isValid(""+workflowid);
if(!isvalid){
    %><span><%=SystemEnv.getHtmlLabelName(126572,user.getLanguage()) %></span><%
    return;
    //没有权限
}

String nodeId = workflowRequestInfo.getCurrentNodeId();

String isBill = workflowRequestInfo.getWorkflowBaseInfo().getIsBill();
String formId = workflowRequestInfo.getWorkflowBaseInfo().getFormId();
String nownodeid = workflowRequestInfo.getNodeId();
String nodeid2 = "";

String nodeflag	= "";
RecordSet rs_nodeid = new RecordSet();
String nodeattrSql = "select a.nodeid from workflow_flownode a,workflow_nodebase b where a.nodeid=b.id and b.nodeattribute in ('2')  and a.workflowid="+workflowid+ " and a.nodeid = "+  nownodeid;
rs_nodeid.executeSql(nodeattrSql);
//判断当前节点为分叉中间点时才进去做判断
if(rs_nodeid.next()){
    nodeflag = "1";
}
if("1".equals(nodeflag)){
String sqlnodeid = "select * from workflow_currentoperator where requestid = "+ requestid + " and userid = " + userid + " and isremark = 0 order by id desc" ;

rs_nodeid.executeSql(sqlnodeid);
if(rs_nodeid.next()){
    nodeid2 = Util.null2String(rs_nodeid.getString("nodeid"));
}
if(!nodeid2.equals(nodeId)){
    nodeId =  nodeid2;
}
}

RecordSet prs = new RecordSet();
if( isBill.equals("1") ) {
    prs.executeProc("workflow_form_SByRequestid",requestid+"");
    if(prs.next()){
        billid= Util.getIntValue(prs.getString("billid"));
    }
}
int userLanguage = user.getLanguage();
userLanguage = (userLanguage == 0) ? 7:userLanguage;

String request_fieldShowValue = "";
String request_fieldShowIndex = "";
//标记是从微搜模块进入start
String fromES=Util.null2String((String)request.getParameter("fromES"));
//标记是从微搜模块进入end
//标记是从任务管理模块进入start
String fromTask=Util.null2String((String)request.getParameter("fromTask"));
//标记是从任务管理模块进入end
//自由流程相关信息
 weaver.workflow.request.WorkflowIsFreeStartNode stnode=new weaver.workflow.request.WorkflowIsFreeStartNode();
 String nodeidss= stnode.getIsFreeStartNode(""+nodeId);
 String freedis=stnode.getNodeid(nodeidss);
 String isornotFree=stnode.isornotFree(""+nodeId);
 //判断是不是创建保存



String isreject="";
 boolean iscreate=stnode.IScreateNode(""+requestid); 
String nodetype="";
String 	isFree ="";
try{
	WFManager.setWfid(Util.getIntValue(""+workflowid));
	WFManager.getWfInfo();
	isFree = WFManager.getIsFree();
	prs.executeSql("select nodetype  from workflow_flownode where workflowid='"+workflowid+"' and nodeid='"+nodeId+"'");
	if(prs.next()){
			 nodetype = prs.getString("nodetype");
	}
}catch(Exception e){}        
 if(!isornotFree.equals("")&&!freedis.equals("")&&!iscreate&&(!"1".equals(isFree) || !"2".equals(nodetype))){
   isreject = "1";
 }
  String zjclNodeid=stnode.getIsFreeStart01Node(""+nodeId);
  int roomConflictChk=meetingSetInfo.getRoomConflictChk();
  int roomConflict= meetingSetInfo.getRoomConflict();
//是否是自由流程


boolean IsFreeWorkflow = false;
boolean isfreewfedit = false;
String freeNodeId = "";
String freeNodeName = "节点1";
String freeoperators = "";
String signtype = "";
//String currentNodeType = workflowRequestInfo.getCurrentNodeType();
String currentNodeType = Util.null2String(workflowRequestInfo.getCurrentNodeType());
if(workflowRequestInfo.getWorkflowBaseInfo().getIsFreeWorkflow().equals("1")){
	IsFreeWorkflow = true;
}
int testestesess = workflowRequestInfo.getIsremark();
boolean isfreeshow = false;
if(IsFreeWorkflow){
	if(requestid <= 0 || (currentNodeType.equals("0") && testestesess == 0)){
		isfreewfedit = true;
	}
	//只有手机端新建才能查看、编辑
    if(requestid <= 0){
    	isfreeshow = true;
    }
	freeNodeId = Util.null2String(workflowRequestInfo.getFreeNodeId());
	freeNodeName = Util.null2String(workflowRequestInfo.getFreeNodeName());
	freeoperators = Util.null2String(workflowRequestInfo.getOperators());
	signtype = Util.null2String(workflowRequestInfo.getSigntype());
}
if("".equals(signtype)){
	signtype = "2";
}
if(module.equals("-1005")){
	intervenorright=SysWFLMonitor.getWFInterventorRightBymonitor(userid,requestid);
}
if(intervenorright==2){
   // istoManagePage=false;
    canview=true;
    //nodeid=currentnodeid;
   // nodetype=currentnodetype;
}

//if(!canview) isurger=WFUrgerManager.UrgerHaveWorkflowViewRight(requestid,userid,Util.getIntValue(logintype,1));

//if("1".equals(ismonitor)){
 //   canview=false;
  //  intervenorright=0;	 //?
   //isurger=false;
//}



int isremark = workflowRequestInfo.getIsremark();
int takisremark = Util.getIntValue(workflowRequestInfo.getTakisremark()+"",0);
int preisremark=-1;//如果是流程参与人，该值会被赋予正确的值，在初始化时先设为错误值，以解决主流程参与人查看子流程时权限判断问题。TD10126
prs = new RecordSet();
prs.executeSql("select isremark,isreminded,preisremark,id,groupdetailid,nodeid,takisremark,(CASE WHEN isremark=9 THEN '7.5' ELSE isremark END) orderisremark from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by orderisremark,id ");
boolean istoManagePage=false;   //add by xhheng @20041217 for TD 1438
while(prs.next())	{
    preisremark=Util.getIntValue(prs.getString("preisremark"),0) ;   
}

//签字意见添加位置，

int isRemarkLocation = 0;
//存在位置字段
boolean includeLocation =  GPSLocationUtil.isInclude(isBill,formId);


int currentnodeid = 0;
int currentstatus = -1;//当前流程状态(对应流程暂停、撤销而言)
RecordSet crs = new RecordSet();
crs.executeProc("workflow_Requestbase_SByID",requestid+"");
if(requestid > 0){
    if(crs.next()){
        status  = Util.null2String(crs.getString("status")) ;
        requestname= Util.null2String(crs.getString("requestname")) ;
        requestlevel = Util.null2String(crs.getString("requestlevel"));
        requestmark = Util.null2String(crs.getString("requestmark")) ;
        creator = Util.getIntValue(crs.getString("creater"),0);
        
        creatertype = Util.getIntValue(crs.getString("creatertype"),0);
        deleted = Util.getIntValue(crs.getString("deleted"),0);
        //workflowid = Util.getIntValue(RecordSet.getString("workflowid"),0);
        currentnodeid = Util.getIntValue(crs.getString("currentnodeid"),0);
       // if(nodeId<1) nodeId = currentnodeid;
        //currentnodetype = Util.null2String(RecordSet.getString("currentnodetype"));
       //if(nodetype.equals("")) nodetype = currentnodetype;
        docCategory=Util.null2String(crs.getString("docCategory"));
        //workflowname = WorkflowComInfo.getWorkflowname(workflowid+"");
        //workflowtype = WorkflowComInfo.getWorkflowtype(workflowid+"");

        lastOperator = Util.getIntValue(crs.getString("lastOperator"),0);
        lastOperateDate=Util.null2String(crs.getString("lastOperateDate"));
        lastOperateTime=Util.null2String(crs.getString("lastOperateTime"));
        currentstatus = Util.getIntValue(crs.getString("currentstatus"),-1);
    }else{
        response.sendRedirect("/notice/Deleted.jsp?showtype=wf");
        return ;
    }
}


HashMap map = WfFunctionManageUtil.wfFunctionManageByNodeid(Util.getIntValue(workflowid,0),currentnodeid);
String rb = (String)map.get("rb");
String ov = (String)map.get("ov");//能否强制归档依据查看人所在节点是否有权限

if("1".equals(ismonitor)){
haveStopright = WfFunctionManageUtil.haveStopright(currentstatus,creator,user,currentNodeType,requestid,false);//流程不为暂停或者撤销状态，当前用户为流程发起人或者系统管理员，并且流程状态不为创建和归档
haveCancelright = WfFunctionManageUtil.haveCancelright(currentstatus,creator,user,currentNodeType,requestid,false);//流程不为撤销状态，当前用户为流程发起人，并且流程状态不为创建和归档
haveRestartright = WfFunctionManageUtil.haveRestartright(currentstatus,creator,user,currentNodeType,requestid,false);//流程为暂停或者撤销状态，当前用户为系统管理员，并且流程状态不为创建和归档
haveBackright=(preisremark!=1 && preisremark!=5 && preisremark!=8 && preisremark!=9 ) && !"0".equals(rb) && WfForceDrawBack.isHavePurview(requestid,userid,Integer.parseInt(logintype),-1,-1);
}
//haveOverright=(isremark != 1&&isremark != 9&&isremark != 5) && (("1".equals(ov) && "1".equals(ismonitor)) || WfForceOver.isNodeOperator(requestid,userid)) && !currentNodeType.equals("3");
if((isremark != 1&&isremark != 9&&isremark != 5) 
        && ("1".equals(ov) && "1".equals(ismonitor)) 
        && !currentNodeType.equals("3") ){
			if((WfFunctionManageUtil.haveOtherOperationRight(requestid)
            &&!WfForceOver.isOver(requestid) 
            && (WfForceOver.isNodeOperator(requestid, userid) 
                || WFUrgerManager.getMonitorViewRight(requestid, userid)))){
			       haveOverright = true;
			}

}
boolean haveDelright = false;
//增加对流程当前所处节点类型的判断TD9023

if("1".equals(ismonitor)){
	MonitorDTO monitorInfo = Monitor.getMonitorInfo(userid+"", creator+"", workflowid);

//是否有删除权限


        if(monitorInfo.getIsdelete() || monitorInfo.getIsforceover()) {
        	haveDelright = true;
		}

		}

String lastnodeid = ""; // 上一次退回操作的节点id
String isSubmitDirectNode = ""; // 上一次退回操作的节点是否启用退回后再提交直达本节点
int nodeid = -1; // 当前操作者所在节点id
crs.execute("select * from workflow_currentoperator where isremark = '0' and requestid=" + requestid + " and userid=" + userid + " and usertype=" + usertype + " order by id desc");
if(crs.next()) {
	nodeid = Util.getIntValue(Util.null2String(crs.getString("nodeid")), -1);
}
String sql_isreject = " select a.nodeid lastnodeid, a.logtype from workflow_requestlog a, workflow_nownode b where a.requestid = b.requestid and a.destnodeid = b.nownodeid "
	+ " and b.requestid=" + requestid + " and a.destnodeid=" + nodeid + " and a.nodeid != " + nodeid + " order by a.logid desc";
crs.executeSql(sql_isreject);
while(crs.next()) {
	String logtype = Util.null2String(crs.getString("logtype"));
	if("3".equals(logtype)) {
		lastnodeid = Util.null2String(crs.getString("lastnodeid"));
		break;
	}
	if("0".equals(logtype) || "2".equals(logtype) || "e".equals(logtype) || "i".equals(logtype) || "j".equals(logtype)){
		break;
	}
}
if(!"".equals(lastnodeid)&&!new weaver.workflow.request.WFLinkInfo().isCanSubmitToRejectNode(requestid,currentnodeid,Util.getIntValue(lastnodeid,0))){
	lastnodeid = "";
}
if(!"".equals(lastnodeid)) {
	crs.executeSql("select * from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + lastnodeid);
	if(crs.next()) {
		isSubmitDirectNode = Util.null2String(crs.getString("isSubmitDirectNode"));
	}
}
if(!"".equals(detailcardshow)&&(","+detailcardshow+",").indexOf(","+workflowid+",")!=-1){
	   detailcardshow = "1";
}else{
     detailcardshow = "";
}
%>
<html>
<head>
 <style type="text/css">
     .operatormessage {
		    border-top: #ccc solid 1px;
		    border-left: #ccc solid 1px;
		    border-right: #ccc solid 1px;
      }
      .requestIfons {
          border-bottom: #cdd2d8 solid 1px;
      }
      .message_before {
            content: "\00a0";
            width: 9px;
            height: 16px;
            left: -8px;
            position: absolute;
            background-image: url('/mobile/plugin/1/images/zuocezhijiao.png');
            background-size: 9px 16px;
            background-repeat: no-repeat;
            background-position: center left ;
            background-color:#fff;
       }
a{color:blue !important;}
.message-box{font-family:微软雅黑!important};


</style>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<%
	boolean ismobilehtml=weaver.mobile.webservices.workflow.WorkflowServiceUtil.isMobileParseExcelMode(workflowid+"",nodeId+"");
    %>
	<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/1/js/jquery-1.6.2.min_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
	<!-- workflow 专用  -->
	<script type="text/javascript" src="/mobile/plugin/1/js/workflow_wev8.js"></script>
	<script type="text/javascript" src="/mobile/plugin/1/js/view_wev8.js"></script>
	<!--弹出框-->
	<script type="text/javascript" src="/js/mylibs/asyncbox/AsyncBox.v1.4_wev8.js"></script>
	<link rel="stylesheet" href="/js/mylibs/asyncbox/skins/ZCMS/asyncbox_wev8.css">
	<!--日期时间控件-->
	<link rel="stylesheet" href="/mobile/plugin/widget/mobiscroll/mobiscroll.min_wev8.css">
	<script type="text/javascript" src="/mobile/plugin/widget/mobiscroll/mobiscroll.min_wev8.js"></script>
	<!-- 富文本 -->
	<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>
	<script type="text/javascript" src="/mobile/plugin/1/js/wfUtil_wev8.js"></script>

	<!--客户自定义js-->
    <script type="text/javascript" src="/mobile/plugin/custom/custion_wev8.js"></script>

	<link rel="stylesheet" href="/mobile/plugin/1/css/r4_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/1/css/r6_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/1/css/client.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/1/css/signstyle.css" type="text/css">
    <link rel="stylesheet" href="/css/crmcss/lanlv_wev8.css" type="text/css">
	<%if(IsFreeWorkflow){  %>
	<link rel="stylesheet" href="/mobile/plugin/1/css/freestyle_wev8.css" media="screen" type="text/css" />
	<%} %>
	<!-- onpropertychange事件支持 -->
	<script type="text/javascript">
	$.client = "mobile";
	$.browser = "mobile";
	</script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/Listener_wev8.js"></script>
	<script type="text/javascript" src="/js/workflow/VCEventHandle_wev8.js"></script>
	<script type="text/javascript" src="/mobile/plugin/1/js/formatUtil_wev8.js"></script>
		
	<%if(includeLocation){%>
	<!-- 地图相关 -->
	<link rel="stylesheet" href="https://cache.amap.com/lbs/static/main.css?v=1.0" />
	<script src="https://cache.amap.com/lbs/static/es5.min.js"></script>
	<script src="https://webapi.amap.com/maps?v=1.3&key=ab13604106709a9ba50a95f8a59e6a4c&plugin=AMap.Geocoder"></script>
	<%} %>

	<script language="javascript">
function HideInter()
{
    $(".pageIntervaling").hide();
    //$("#tt2").hide();
}
</script>

	<SCRIPT LANGUAGE="JavaScript">

jQuery("#menu li").mouseover(function(){
jQuery(this).find("ul").css("display", "block");
});

jQuery("#menu li").mouseout(function(){
jQuery(this).find("ul").css("display", "none");
});

jQuery("#menu").bind("click", function(){
if(jQuery(this).attr("href") == "#"){
return false;
}
var txt_href = jQuery(this).attr("href");
jQuery.get(txt_href, function(result){
jQuery("#display").html(result);
});
return false;
});

</SCRIPT>

	<script type="text/javascript">
	
	var chromeOnPropListener = null;
	
    var f_weaver_belongto_userid = '<%=f_weaver_belongto_userid%>';
    var f_weaver_belongto_usertype = '<%=f_weaver_belongto_usertype%>';
    
	//加载监听器，页面打开调用一次；明细表添加调用一次，重置定时器监听的对象
	function loadListener(){
		if(chromeOnPropListener==null){
			chromeOnPropListener = new Listener();
		}else{
			chromeOnPropListener.stop();
		}
		chromeOnPropListener.load("[_listener][_listener!='']");
		chromeOnPropListener.start(500, "_listener");
	}
	</script>
	
	<script type="text/javascript">
	var promptWrod = "<%=SystemEnv.getHtmlLabelName(558, userLanguage)%>";
	var ectSignWrod = "<%=SystemEnv.getHtmlLabelName(30490, userLanguage)%>";
	var sureToDeleteWord = "<%=SystemEnv.getHtmlLabelName(23271, userLanguage)%>";
	var cj_mes_timeWord = "<%=SystemEnv.getHtmlLabelName(24569, userLanguage)%>!";
	var cj_bohaiLeave2_1 = "<%=SystemEnv.getHtmlLabelName(21721, userLanguage)%>";
	var cj_bohaiLeave2_2 = "<%=SystemEnv.getHtmlLabelName(21720, userLanguage)%>";
	var cj_bohaiLeave11_1 = "<%=SystemEnv.getHtmlLabelName(131656, userLanguage)%>";
	var cj_bohaiLeave11_2 = "<%=SystemEnv.getHtmlLabelName(131655, userLanguage)%>";
	var cj_bohaiLeave12_1 = "<%=SystemEnv.getHtmlLabelName(84604, userLanguage)%>";
	var cj_bohaiLeave12_2 = "<%=SystemEnv.getHtmlLabelName(82767, userLanguage)%>";
	
	var bodyScrollLeft = 0;
	var fieldIdRemindType;
	var fieldIdRemindBeforeStart;
	var fieldIdRemindBeforeEnd;
	var fieldIdRemindTimesBeforeStart;
	var fieldIdRemindTimesBeforeEnd;
	var clientVersion=0;
	var clienttype="<%=clienttype%>";
	
	var js_userid = "<%=userid%>";
	var js_sessionkey = "<%=sessionkey %>";
	var js_module = "<%=module %>";
	var js_scope = "<%=scope %>";
	var js_fromRequestid = "<%=fromRequestid %>";

	var js_requestid = "<%=requestid %>";
	var js_nodeid = "<%=nodeId %>";
	var js_clientlevel = "<%=clientlevel%>";
	var js_clientVer = "<%=clientVer %>";
	var js_workflowid = "<%=workflowid%>";
	var js_clienttype="<%=clienttype%>";
	var js_isBill = "<%=isBill %>";
	var js_formid = "<%=formId%>";
	var lastnodeid = "<%=lastnodeid %>";
	var isSubmitDirectNode = "<%=isSubmitDirectNode %>";
	
	var js_fromES="<%=fromES%>";
	var isnewVersion = false;
	var js_fromTask = "<%=fromTask%>";
	var RoomConflictChk="<%=roomConflictChk%>";
	var RoomConflict="<%=roomConflict%>"
	var buttonswitch = "<%=buttonswitch%>";
	
	//字段属性联动依赖的全局对象
	var wf__info = {
		"requestid": js_requestid,
		"workflowid": js_workflowid,
		"nodeid": js_nodeid,
		"formid": js_formid,
		"isbill": js_isBill,
		"f_bel_userid": "<%=userid %>",
		"f_bel_usertype": "<%=usertype %>",
		"belmobile": true,
		"datassplit": "<%=FieldAttrManager.DATAS_SEPARATOR %>",
		"paramsplit": "<%=FieldAttrManager.PARAM_SEPARATOR %>",
		"valuesplit": "<%=FieldAttrManager.VALUE_SEPARATOR %>"
	};
</SCRIPT>
<!-- 抽出 -->
<script type="text/javascript" src="/mobile/plugin/1/js/view/1_wev8.js"></script>

<%


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
        if(tips!="")
        {
            alert(tips);
            goBack();
        }
        try
        {
            setTimeout('top.window.close()',1);
        }
        catch(e)
        {
            window.location.href="/notice/noright.jsp?isovertime=1";
        }
    </script>
<%
} %>

<script type="text/javascript" src="/mobile/plugin/1/js/view/htmlAttr_wev8.js"></script>
<%if(isremark!=2&&isremark!=4&&takisremark!=-2){%>
<script type="text/javascript" src="/workflow/exceldesign/js/fieldAttrOperate_wev8.js"></script>
<%}%>

<!--js 国际化-->
<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
<script type="text/javascript" src="/mobile/plugin/1/js/workflowsign_wev8.js"></script>
<script type="text/javascript">
	window.onscroll = function(){
		bodyScrollLeft = document.body.scrollLeft;
	}
	window.onresize = winResize;
	var ckInterval = null;
	var fieldId =-1;
	var geolocation;
	$(document).ready(function () {
	//	HideInter();
		<%
		if (!"create".equals(method)) {
		%>
		 var data ;
         var Resourcedata;

		//加载签字意见
		try{
		    isfirst = true;
		    remarksignloadClinet();
		}catch(e){}
		<%
		}
		%>
		setRedflag();
		initFormPage();
		ckInterval = setInterval("setRedflag()",1000);
		
		$("a[href='#'][data-rel='dialog']").attr("href","javascript:void(0);");
		if(clienttype=="android"||clienttype=="androidpad"){
			clientVersion=mobileInterface.getClientVersion();
		}
		
		var $viewMainTable = jQuery("table[class='ViewForm outertable']");
		if($viewMainTable != null){
			if($viewMainTable.width() > document.body.clientWidth){
				document.getElementById("view_header").style.width = $viewMainTable.width() + 10;
				document.getElementById("header").style.width = $viewMainTable.width() + 10;
			}
		} 

		            //调整表单中签字意见的样式
        jQuery(".td_edesign").find("a").each(function(){
            var clickEvent = jQuery(this).attr("onclick");
            //调整地图事件
            //从openMap(121.493072,31.243081,"上海市虹口区提篮桥街道武昌路58号") 调整为 signRowLocationTouchend("1461115406108,121.493072,31.243081,上海市虹口区提篮桥街道武昌路58号")
            if(clickEvent != undefined && clickEvent.indexOf("parent.openMap(") >= 0){
                try{
                    var tempclickEvent = clickEvent.substring(clickEvent.indexOf("parent.openMap("));
                    tempclickEvent = tempclickEvent.substring(0,tempclickEvent.indexOf(");") + 2);
	                var clickEventOpenmap = clickEvent.substring(clickEvent.indexOf("parent.openMap(") + 15);
	                clickEventOpenmap = clickEventOpenmap.substring(0,clickEventOpenmap.indexOf(");"));
                    clickEventOpenmap = clickEventOpenmap.replace("\"" , "");
                    clickEventOpenmap = clickEventOpenmap.replace("\"" , "");
	                clickEventOpenmap = "signRowLocationTouchend('1461115406108," + clickEventOpenmap + "');";
	                clickEvent = clickEvent.replace(tempclickEvent,clickEventOpenmap);
                    jQuery(this).removeAttr("href");
                    this.style.height = "auto";
	                jQuery(this).attr("onclick",clickEvent);
                }catch(e){}
            }
            //附件
            if(clickEvent != undefined && clickEvent.indexOf("openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=") >= 0){
                try{
                    var tempAttachid = clickEvent.substring(clickEvent.indexOf("openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=") + 48);
                    tempAttachid = tempAttachid.substring(0,tempAttachid.indexOf("&"));
                    var clickEvent = "toDocument(" + tempAttachid + ");";
                    jQuery(this).removeAttr("href");
                    jQuery(this).attr("onclick",clickEvent);
                }catch(e){}
            }
            var aHref = jQuery(this).attr("href");
            //文档
            if(aHref != undefined && aHref.indexOf("/docs/docs/DocDsp.jsp") >= 0){
                try{
                    var tempDocid = aHref.substring(aHref.indexOf("/docs/docs/DocDsp.jsp?id=") + 25);
                    tempDocid = tempDocid.substring(0,tempDocid.indexOf("&"));
                    var clickEvent = "toDocument(" + tempDocid + ");";
                    jQuery(this).removeAttr("href");
                    jQuery(this).attr("onclick",clickEvent);
                }catch(e){}
            }
            //流程
            if(aHref != undefined && aHref.indexOf("/workflow/request/ViewRequest.jsp") >= 0){
                try{
                    var tempReqid = aHref.substring(aHref.indexOf("requestid=") + 10);
                    tempReqid = tempReqid.substring(0,tempReqid.indexOf("&"));
                    var clickEvent = "toRequest(" + tempReqid + ");";
                    jQuery(this).removeAttr("href");
                    jQuery(this).attr("onclick",clickEvent);
                }catch(e){}
            }
        
        });
		<%if(includeLocation){
			if(module.equals("-1004") || module.equals("-1005")){
			    %>
			    try{
			        for (var i=0; i<window._autoLocateFields.length; i++) {
			           var autofield = window._autoLocateFields[i]; 
			           jQuery('#showInfo' + autofield ).val(jQuery("#module" + autofield).val());
			        }
			    }catch(e){
			    }
			    <%
			}else{
		%>
			createMap();
        	autoLocate();
		<%}}%>

		try{
			<%if((!"android".equals(clienttype)&&!"androidpad".equals(clienttype)&&!"iPhone".equals(clienttype)&&!"iPad".equals(clienttype))||"".equals(clienttype)||!"1".equals(module)){%>
				  jQuery("a[name='appendixeEditField']").each(function(){
				          jQuery(this).remove();
			      });
			<%}%>
		}catch(e){}
		
		
	});

	<%if (workflowHtmlShow != null && !"".equals(workflowHtmlShow)) {%>
		jQuery(document).ready(function(){
		 <%if(isremark!=2&&isremark!=4&&takisremark!=-2){%>
		  try{
			$("tr[name^='trView_']").each(function(){
				  var trname=$(this).attr("name");
				  if(trname.indexOf("_")!=-1){
					   var trrowindex=trname.split("_")[2];
					   detailattrshow(trrowindex);
				  }
			});
			$("button[name^='addbutton']").click(function(){
				var tableindex=$(this).attr("name").replace("addbutton","");
				var trrowindex = (new Number($("#nodenum"+tableindex).val())-1);
				detailattrshow(trrowindex);
			});
		  }catch(e){}
		<%}%>
			try{
			  formuaAttrShow(0);
			  $("tr[name^='trView_']").each(function(){
				  var trname=$(this).attr("name");
				  if(trname.indexOf("_")!=-1){
					   var trrowindex=trname.split("_")[2];
					   formuaAttrShowDetail(trrowindex);
					  try{
							$("td[_cellattr]").each(function(){
								var _cellattr =  $(this).attr("_cellattr");
							    if(_cellattr.indexOf("$[")!=-1){
									 $(this).attr("_cellattr",_cellattr.replace("$[","").replace("]$","")+"_"+trrowindex);
								}
								
							});

							$("td[_fieldid]").each(function(){
								var _fieldid =  $(this).attr("_fieldid");
								 if(_fieldid.indexOf("$[")!=-1){
									$(this).attr("_fieldid",_fieldid.replace("$[","").replace("]$","")+"_"+trrowindex);
								}
							});

							  $("td[_formula]").each(function(){
								var _formula =  $(this).attr("_formula");
								 if(_formula.indexOf("$[")!=-1){
								   $(this).attr("_formula",_formula.replace("$[","").replace("]$",""));
								 }
							});
						}catch(e){
						}
				  }
			 });
			 $("button[name^='addbutton']").click(function(){
				 var tableindex=$(this).attr("name").replace("addbutton","");
				 var trrowindex = (new Number($("#nodenum"+tableindex).val())-1);
				 formuaAttrShowDetail(trrowindex);
			 });
		  }catch(e){}

			<%if(ismobilehtml){%>
			$(".excelDetailTable").css("width","100%");
		<%}%>
			 try{
				if($("strong").parent("span").length>0){
					   $("strong").each(function(){
							if($(this).attr("style")==undefined){
								  if($(this).parent("span").attr("style")!=undefined||$(this).parent("span").attr("style")!=''){
									   $(this).attr("style",$(this).parent("span").attr("style"));
								  }
							}
					   });
				}
		   }catch(e){}
	   });

	<%}%>

	    /**
     * 图片调整大小
     */
    function image_resize(_this) {
        var innerWidth = window.innerWidth;
        var imgWidth = $(_this).width();
        if (imgWidth >= innerWidth) {
            $(_this).width("100%");
            $(_this).removeAttr("height");
            $(_this).css("height", "");
        }
    }
    var touchmoveFlag = false;
    $(document).bind("touchmove",function(){
        touchmoveFlag = true;
    });
    $(document).bind("touchstart",function(){
        touchmoveFlag = false;
    });
    function signRowLocationTouchend(remarkLocationStr){
        if(touchmoveFlag){
            return;
        }
        if(remarkLocationStr!=""){
		    var infos = remarkLocationStr.split(",");
		    if(infos.length == 4){
		        var returnSre ="emobile:openaddress";
		        returnSre +=":" + infos[1];
		        returnSre +=":" + infos[2];
		        returnSre +=":" + infos[3];
		        location = returnSre;
		    }
	   }
    }
	function signRowUserTouchend(operatorUserid){
        if(touchmoveFlag){
            return;
        }
        //toURL("/mobile/plugin/1/clientInfo.jsp?userInfo=emoble:openUserinfo:" + operatorUserid,false);
    }
    //获取本周是一年中的第几周  
    function getWeekOfYear(date) {   
        var d1 = date;  
        var d2 = new Date(date.getFullYear(), 0, 1);  
        var d = Math.round((d1 - d2) / 86400000);   
        return Math.ceil((d + ((d2.getDay() + 1) - 1)) / 7);   
    }
    var weekday=new Array(7)
    weekday[0]="<%=SystemEnv.getHtmlLabelName(398, userLanguage)%>";
    weekday[1]="<%=SystemEnv.getHtmlLabelName(392, userLanguage)%>";
    weekday[2]="<%=SystemEnv.getHtmlLabelName(393, userLanguage)%>";
    weekday[3]="<%=SystemEnv.getHtmlLabelName(394, userLanguage)%>";
    weekday[4]="<%=SystemEnv.getHtmlLabelName(395, userLanguage)%>";
    weekday[5]="<%=SystemEnv.getHtmlLabelName(396, userLanguage)%>";
    weekday[6]="<%=SystemEnv.getHtmlLabelName(397, userLanguage)%>";
    var $autoFun;
    var remarkLoadingFlag = false;
    /**
     * 加载签字意见
    */
    var isfirst;
        function remarksignloadClinet(){
        //避免重复加载
        if(remarkLoadingFlag) return;
        remarkLoadingFlag = true;
        var paras = getUrlParam();
        //显示正在加载的旋转图片。

        if(paras.loadingTarget!=null) jQuery(paras.loadingTarget).showLoading();
        util.getData({
            "loadingTarget": document.body,
            "paras": paras,
            "callback": function(data) {
                if (data.error) {
                    //第一次加载删除加载图标

                    if (isfirst != undefined && isfirst != null && isfirst == true) {
                        $("#workflowrequestsignblock").hide();
                        
                        //第一次加载，如果没有数据，则隐藏  流转意见 标签
                        jQuery("#page_remarksign_Title_div").css("display","none");
                        jQuery("#workflowrequestsignblock").css("display","none");
                    } else {
                        $("#workflowsignmore").remove();
                    }
                } else {
                    var pageindex = data.pageindex;
                    var pagesize = data.pagesize;
                    var count = data.count;
                    var ishavepre = data.ishavepre;
                    var ishavenext = data.ishavenext
                    var pagecount = data.pagecount;
                    $("input[name='workflowsignid']").val(pageindex);
                    var viewsignHtml = "";
                    var currentPageDataCnt = new Date().getTime();
                    if (data.logs != undefined && data.logs != null && count != "0") {
                        $.each(data.logs, 
                        function(i, item) {
                            currentPageDataCnt++;
                            var annexDocHtmls = item.annexDocHtmls;
                            var id = item.id;
                            var nodeId = item.nodeId;
                            var nodeName = item.nodeName;
                            var operateDate = item.operateDate;
                            var operateTime = item.operateTime;
                            var operateType = item.operateType;
                            var operatorDept = item.operatorDept;
                            var operatorId = item.operatorId;
                            var operatorName = item.operatorName;
                            var operatorAgentorFrom = item.operatorAgentorFrom;
                            var operatorAgentorTo = item.operatorAgentorTo;
                            var operatorAgentLog = item.operatorAgentLog;
                            var operatorSign = item.operatorSign;
                            var customSign = item.customSign;
                            
                            var receivedPersons = item.receivedPersons;
                            var remark = item.remarkClient;
                            var remarkSign = item.remarkSign;
                            var signDocHtmls = item.signDocHtmls;
                            var signWorkFlowHtmls = item.signWorkFlowHtmls;
                            var operatorSignIcon = item.operatorSignIcon;
                            var nodeRowName = '节点';
                            var operationRowName = '操作';
                            var receivedRowName = '接收人';
                            var accessoryRowName = '相关附件';
                            var signDocHtmlsRowName = '相关文档';
                            var signWorkFlowHtmlsRowName = '相关流程';
                            viewsignHtml += "<div class='message_content'>";
                            
                            var operatorUser = <%=user.getUID()%>;
                            var leftoperatorName = operatorName;
                            if(!util.isNullOrEmpty(operatorAgentorTo)){
                                leftoperatorName = operatorAgentorTo;
                            }
                            if(!util.isNullOrEmpty(operatorAgentLog)){
                                operatorName = operatorAgentLog;
                            }
                            if(operatorSignIcon == "/messager/images/icon_w_wev8.jpg" || operatorSignIcon == "/messager/images/icon_m_wev8.jpg"){
                                operatorSignIcon = "";
                            }
                            if(!util.isNullOrEmpty(operatorSignIcon)){
                                viewsignHtml += "<div class='operatorface' onclick='signRowUserTouchend(\"" + operatorId + "\")'><img src=\"" + operatorSignIcon + "\"></div>";
                            }else{
                                viewsignHtml += "<div class='operatorface_noicon' onclick='signRowUserTouchend(\"" + operatorId + "\")'>" + leftoperatorName + "</div>";
                            }
                            viewsignHtml += "<div class='operatormessage'>" + "<div class='message_before'></div>";
                            
                            viewsignHtml += "  <div class=\"signRow_yijian\" key=\""+i+"\">";
                            var handWrittenSignSrc = new Array();
                            var SpeechDisplayHtmls = new Array();
                            if (remarkSign != null && remarkSign != undefined) {
                            } else {
                                if(operateType != "抄送"){
	                                $('#remarkTempDiv').html('');
	                                $('#remarkTempDiv').html(remark);
									var handWrittenSignStr="";
	                                $('#remarkTempDiv').find('[name="handWrittenSign"]').each(function(){
										if($(this).attr("src") != handWrittenSignStr){
											  handWrittenSignSrc.push($(this).attr("src"));
										}
									    handWrittenSignStr=$(this).attr("src");
                                        $(this).remove();
	                                });
                                    $('#remarkTempDiv').find('.divSpeechDisplay').each(function(){
                                        if($(this).find("audio").length > 0){
	                                       SpeechDisplayHtmls.push($(this).html());
	                                       $(this).remove();
                                        }
                                    });
	                                $('#remarkTempDiv').find("embed").remove();
	                                remark = $('#remarkTempDiv').html();
	                                //remark = remark.replace('<span style="font-size:11px;color:#666;">来自android客户端</span>','');
	                                
                                    $('#remarkTempDiv').html(remark);
                                    /*for(var brCnt = 0; brCnt < $('#remarkTempDiv').find('br').length; brCnt++){
                                        if($($('#remarkTempDiv').find('br')[brCnt]).next().length > 0 && $($('#remarkTempDiv').find('br')[brCnt]).next()[0].tagName == "BR"){
                                            $($('#remarkTempDiv').find('br')[brCnt]).next().remove();
                                            brCnt--;
                                        }
                                    }*/
                                    remark = $('#remarkTempDiv').html();
                                    viewsignHtml += remark;
                                }
                            }
                            viewsignHtml += "</div>";
                            if (remarkSign != null && remarkSign != undefined) {
                                viewsignHtml += "  <div class=\"signRow_yijian 2\">";
                                viewsignHtml += "<div style=\"width:100%;clear:both\">" + "    <img src=\"/weaver/weaver.file.FileDownload?fileid=" + remarkSign + "\" onload='image_resize(this);' onresize='image_resize(this);' onclick='javascript:imgCarousel(this);'>" + "</div>";
                                viewsignHtml += "</div>";
                            }
                            
                            var regExpCss = new RegExp(/text-decoration\:underline\;color\:blue\;cursor\:hand\;/g);
                            var regExpBr = new RegExp(/<br\/>/g);
                            if (!util.isNullOrEmpty(signDocHtmls)) {
                                signDocHtmls = signDocHtmls.replace(regExpCss,"display:block;");
                                signDocHtmls = signDocHtmls.replace(regExpBr,"");
                                viewsignHtml += "<div class=\"signRow 1\">" + signDocHtmls + "</div>";
                            }
                            if (!util.isNullOrEmpty(signWorkFlowHtmls)) {
                                signWorkFlowHtmls = signWorkFlowHtmls.replace(regExpCss,"display:block;");
                                signWorkFlowHtmls = signWorkFlowHtmls.replace(regExpBr,"");
                                viewsignHtml += "<div class=\"signRow 3\">" + signWorkFlowHtmls + "</div>";
                            }
                            
                            if(handWrittenSignSrc.length >0 ){
                                viewsignHtml += "  <div class=\"signRow_yijian\">";
                                var handWrittenSignHtml = "<div style='clear:both'>";
                                for(var imgCnt = 0 ; imgCnt < handWrittenSignSrc.length ; imgCnt++){
                                    var imageSrc = handWrittenSignSrc[imgCnt];
                                    if(imageSrc.indexOf("/download.do?fileid=/download.do") >= 0){
                                       imageSrc = imageSrc.replace("/download.do?fileid=/download.do","/download.do");
                                    }
									if(imageSrc.indexOf("/download.do") >= 0){
	                                       imageSrc = imageSrc.replace("/download.do","/weaver/weaver.file.FileDownload");
	                                }
                                    handWrittenSignHtml +="<div class='speechAttachment'>";
                                    handWrittenSignHtml +="<img src='" + imageSrc + "'";
                                    handWrittenSignHtml +="  onload='image_resize(this);' onresize='image_resize(this);' onclick='javascript:imgCarousel(this);'>";
                                    handWrittenSignHtml +="</div>";
                                }
                                handWrittenSignHtml +="</div>";
                                viewsignHtml += handWrittenSignHtml;
                                viewsignHtml += " </div>";
                            
                            }
                            var signRow_yijian1Html = "";
                            var imageSrcs = new Array();
                            if (!util.isNullOrEmpty(annexDocHtmls)) {
                                annexDocHtmls = annexDocHtmls.replace(regExpCss,"display:block;");
                                annexDocHtmls = annexDocHtmls.replace(regExpBr,"");
                                $('#remarkTempDiv').html('');
                                $('#remarkTempDiv').append($(annexDocHtmls));
                                var linkSrcs = new Array();
                                $('#remarkTempDiv').find("span").each(function(){
                                    var linksrc = $(this).attr("onclick");
                                    if(linksrc != "" && linksrc.indexOf("toURL('") >= 0){
                                        linksrc = linksrc.substring(linksrc.indexOf("toURL('") + 7);
                                        linksrc = linksrc.substring(0,linksrc.indexOf("'"));
                                        if(linksrc.length > 3 && (linksrc.substring(linksrc.length - 3)=="jpg"
                                                                  || linksrc.substring(linksrc.length - 3)=="png"
                                                                  || linksrc.substring(linksrc.length - 3)=="gif")){
                                            imageSrcs.push(linksrc);
                                        }else{
                                            linkSrcs.push(this.outerHTML);
                                        }
                                        $(this).remove();
                                    }
                                });
                                var tempannexDocHtmls = "";
                                if($('#remarkTempDiv').find("span").length > 0){
                                    tempannexDocHtmls = $('#remarkTempDiv').html();
                                }
                                if(linkSrcs.length > 0){
                                    for(var imgCnt = 0 ; imgCnt < linkSrcs.length ; imgCnt++){
                                        var linkSrc = linkSrcs[imgCnt];
                                        linkSrc = linkSrc.replace("/download.do?fileid=/download.do","/download.do");
                                        tempannexDocHtmls += linkSrc;
                                    }
                                }
	                            if(imageSrcs.length > 0){
	                                var attachfileHtml = "<div style='clear:both'>";
	                                for(var imgCnt = 0 ; imgCnt < imageSrcs.length ; imgCnt++){
	                                    var imageSrc = imageSrcs[imgCnt];
	                                    if(imageSrc.indexOf("/download.do?fileid=/download.do") >= 0){
	                                       imageSrc = imageSrc.replace("/download.do?fileid=/download.do","/download.do");
	                                    }
										if(imageSrc.indexOf("/download.do") >= 0){
	                                       imageSrc = imageSrc.replace("/download.do","/weaver/weaver.file.FileDownload");
	                                    }

	                                    attachfileHtml +="<div class='attachfileDiv'>";
	                                    attachfileHtml +="<img src='" + imageSrc + "'";
	                                    attachfileHtml +="  onload='image_resize(this);' onresize='image_resize(this);' onclick='javascript:imgCarousel(this);'>";
	                                    attachfileHtml +="</div>";
	                                }
	                                signRow_yijian1Html += attachfileHtml;
	                                signRow_yijian1Html += " </div>";
	                            }
                                if(tempannexDocHtmls != ""){
                                    var regExpCss = new RegExp(/text-decoration\:underline\;color\:blue\;cursor\:hand\;/g);
                                    var regExpBr = new RegExp(/<br\/>/g);
                                    tempannexDocHtmls = tempannexDocHtmls.replace(regExpBr,"");
                                    tempannexDocHtmls = tempannexDocHtmls.replace(regExpCss,"display:block;");
                                    signRow_yijian1Html += "<div class=\"signRow 2\" style=\"padding-left:0px;\">" + tempannexDocHtmls + "</div>";
                                }
                                
                            }
                            if(signRow_yijian1Html != ""){
	                            viewsignHtml += "  <div class=\"signRow_yijian 1\">";
                                viewsignHtml += signRow_yijian1Html;
	                            viewsignHtml += "</div>";
                            }
                            if(SpeechDisplayHtmls.length >0 ){
                                viewsignHtml += "  <div class=\"signRow_yijian\">";
                                var SpeechDisplayHtml = "<div class='divSpeechDisplay'>";
                                for(var audCnt = 0 ; audCnt < SpeechDisplayHtmls.length ; audCnt++){
                                    var audHtml = SpeechDisplayHtmls[audCnt];
                                    if(audHtml != ""){
	                                    SpeechDisplayHtml += audHtml;
                                    }
                                }
                                handWrittenSignHtml +="</div>";
                                viewsignHtml += SpeechDisplayHtml;
                                viewsignHtml += " </div>";
                            
                            }
							viewsignHtml += "  <div class=\"signRow_yijian 4\" key=\"4"+i+"\">";
                            viewsignHtml += "</div>";
                            if(!util.isNullOrEmpty(customSign)) {
                                viewsignHtml += "  <div class=\"signRow_yijian 3\">";
                                viewsignHtml += "<div class=\"operatorSign\"><img src=\"" + customSign +"\" onload='image_resize(this);' onresize='image_resize(this);' onclick='javascript:imgCarousel(this);' ></div>";
                                viewsignHtml += "</div>";
                            }
							
                            var remarkLocationStr = item.remarkLocation;
                            if(!util.isNullOrEmpty(remarkLocationStr)){
                                if(remarkLocationStr.lastIndexOf(",") >= 0){
                                    var locationStr = remarkLocationStr.substring(remarkLocationStr.lastIndexOf(",")+1);
                                    viewsignHtml += "<div class=\"signRowLocation\" ontouchend=\"signRowLocationTouchend('" + remarkLocationStr + "')\">" + locationStr + "</div>";
                                }
                            }
                            viewsignHtml += "<div class='signRow_operate'><div class=\"signRow_operatorname\">" + operatorName + "</div> <div class=\"signRow_operateTime\">" + operateType + " 于 " + operateDate + "&nbsp;" + operateTime + "" + "</div></div>";
                            viewsignHtml += "<div class=\"signRow_nodetotal\">";
                            viewsignHtml += "<div class=\"signRow_nodename\"><span>" + nodeRowName + ":</span>" + nodeName + "</div>"; 
                            viewsignHtml += "<div class=\"signRow_nodeTypename\"><span>" + operationRowName + ":</span>" + operateType + "</div>";
                            viewsignHtml += "<div class=\"signRow_receivedName\"><span>" + receivedRowName + ":</span>" + receivedPersons + "</div>";
                            viewsignHtml += "</div>";
                            
                            viewsignHtml += "</div>";
                            viewsignHtml += "</div>";
                        });
                    }
                    //第一次加载删除加载图标

                    if (isfirst != undefined && isfirst != null && isfirst == true) {
                        $("#workflowrequestsignblock").html("");
                        
                        //第一次加载，如果没有数据，则隐藏  流转意见 标签
                        if(data.logs == undefined || data.logs == null || count == "0"){
                            jQuery("#page_remarksign_Title_div").css("display","none");
                            jQuery("#workflowrequestsignblock").css("display","none");
                        }
                    }
                    $("#cleaboth").remove();
                    $("#workflowsignmore").remove();
                    $("#remarkShowMore").hide();
                    if (ishavenext == "1") {
                        var moreRowName = '展开全部';
                        $("#remarkShowMore").html("<%=SystemEnv.getHtmlLabelName(82720,user.getLanguage())%>");
                        $("#remarkShowMore").show();
                        jQuery(window).bind("scroll",autoScrollSign);
                    }else{
                        $("#remarkShowMore").hide();
                        jQuery(window).unbind("scroll",autoScrollSign);
                    }
                    $("#workflowrequestsignblock").append(viewsignHtml);
                    $("#workflowrequestsignblock").append("<div style='display:none' id='msgTool'></div>");
                    //在新加载的页面上，可能包含语音附件的播放按钮，则需要对其进行隐藏。

                    hiddenSpeechBtn();
                    $(".signRow_yijian").find("img").each(function(i,e) {
                       var imgsrc = $(e).attr("src");
                       if(imgsrc.indexOf("data:image/png;base64") == 0){
                            $(e).bind("touchend",function(){
                                //过滤滑动事件
                                if(touchmoveFlag){return;}
                                toURL(imgsrc,false);
                            });
                       }
                       if(imgsrc =="data:image/png;base64,null"){
                           $(e).attr("src","/mobile/plugin/1/images/blog_photo_failure.png");
                           $(e).css("height","77px");
                       }
                    });
                    //去掉地图链接
                    $(".signRow_yijian").find("a").each(function() {
                    
                        if($(this).attr("atsome") != undefined && $(this).parent().attr("contenteditable") != undefined){
                            $(this).parent().html($(this).html());
                        }else if($(this).attr("__noshow") !="undefined"){
                            $(this).remove();
                        }
                        
                    });
                    //去除空行
                    $(".signRow_yijian").children().each(function() {
                        if(this.tagName == "SPAN" && $(this).html() == "来自iPhone客户端"){
                           // $(this).remove();
                        }
                        if(this.tagName == "P" || this.tagName == "p"){
                            var innerHtml = $(this).html();
                            innerHtml = innerHtml.replace(/&nbsp;/ig, "");
                            if(innerHtml.trim() == "") {
                                $(this).remove();
                            }
                        }
                    });
                    //去除"来自iPhone客户端"
					var  signrowyijianHtml="";
                    $(".signRow_yijian").find("span").each(function() {
                        var htmlyijian=$(this).html();
                        if($(this).attr("style")=='font-size:11px;color:#666;'&&htmlyijian.indexOf("客户端")!=-1){
							$(this).hide();
							var key=$(this).parent().attr("key");
							 $("div[key='4"+key+"']").html("<span class=\"mobilesignMifxx\" style=\"font-size:11px;color:#666;\">"+$(this).html()+"</span>");
                             
                        }
                    });
					$(".mobilesignMifxx").each(function(){$(this).show();});
					
                    
                    $(".signRow_operate").unbind("click");
                    $(".signRow_operate").bind("click",function(){
                       //过滤滑动事件
                       if(touchmoveFlag){return;}
                       $(this).parent().find(".signRow_nodetotal").toggle();
                       $(this).toggleClass("signrow_endline");
                       $(this).find(".signRow_operateTime").toggleClass("signrow_endline");
                       $(this).find(".signRow_operatorname").toggleClass("signrow_endline");
                       $(this).find(".signRow_operateTime").toggleClass("signRow_operateTime_open");
                    });
                    var topHeight= $("#page_remarksign_Title_div").offset().top;
                    var windowHeight = document.body.clientHeight  + window.screen.height - window.screen.availHeight;
                    
                    $(".signRow").find("span").each(function(){
                        $(this).attr("style","display:block;");
                        var clickevent = $(this).attr("onclick");
                        if(clickevent.length > 10 && clickevent.substring(0,10) == "toDocument"){
                            $(this).addClass("signRow_Docspan");
                        }else if(clickevent.length > 9 && clickevent.substring(0,9) == "toRequest"){
                            $(this).addClass("signRow_WFspan");
                        }
                    });
                    if(isfirst && parseInt(topHeight) > parseInt(windowHeight) -36 ){
                        $("#page_remarksign_Title_div").addClass('<%="1".equals(buttonswitch)?"fixedBottomDivWeb":"fixedBottomDiv"%>');
                    }
                    $("#page_remarksign_Title_div").bind("touchend",function(){
                        if(touchmoveFlag){
                            return;
                        }
                        $("#page_remarksign_Title_div").removeClass('<%="1".equals(buttonswitch)?"fixedBottomDivWeb":"fixedBottomDiv"%>');
                        //防止此时触发加载更多
                        jQuery(window).unbind("scroll",autoScrollSign);
                        $(document).scrollTop(topHeight);
                        jQuery(window).bind("scroll",autoScrollSign);
                    });
                    $(".operatormessage").each(function(){
                        //$(this).width($(document).width() - ($(document).width()*0.22));
                    });
                    
                    //$(window).scroll(function() {
                    $(window).scroll(function() {
                        var currTop = $(window).scrollTop();
                        var scrollTopFlag = false;
                        if(currTop < prevTop){
                            scrollTopFlag = true;
                        }
                        <%
                        if("android".equals(clienttype)||"androidpad".equals(clienttype)||"Webclient".equals(clienttype)){%>
                        if(parseInt(topHeight) > parseInt($(document).scrollTop()) + windowHeight- $("#page_remarksign_Title_div").height() + window.screen.height - window.screen.availHeight - <%="1".equals(buttonswitch)?88:50%>){
                        <%}else{%>
                        if(parseInt(topHeight) > parseInt($(document).scrollTop()) + windowHeight  - $("#page_remarksign_Title_div").height() + window.screen.height - window.screen.availHeight - <%="1".equals(buttonswitch)?88:50%>){
                        <%}%>
                            if($("#page_remarksign_Title_div").attr("class") == undefined || $("#page_remarksign_Title_div").attr("class").indexOf('<%="1".equals(buttonswitch)?"fixedBottomDivWeb":"fixedBottomDiv"%>') == -1){
                                $("#page_remarksign_Title_div").addClass('<%="1".equals(buttonswitch)?"fixedBottomDivWeb":"fixedBottomDiv"%>');
                            }
                        }else{
                            $("#page_remarksign_Title_div").removeClass('<%="1".equals(buttonswitch)?"fixedBottomDivWeb":"fixedBottomDiv"%>');
                        }
                        prevTop = currTop;
					});
                    $(document).bind("touchmove",function(){
                        if(parseInt(topHeight) > parseInt($(document).scrollTop()) + windowHeight - $("#page_remarksign_Title_div").height() + window.screen.height - window.screen.availHeight - <%="1".equals(buttonswitch)?88:50%>){
                            if($("#page_remarksign_Title_div").attr("class").indexOf('<%="1".equals(buttonswitch)?"fixedBottomDivWeb":"fixedBottomDiv"%>') == -1){

                                $("#page_remarksign_Title_div").addClass('<%="1".equals(buttonswitch)?"fixedBottomDivWeb":"fixedBottomDiv"%>');
                            }
                        }else{
                            $("#page_remarksign_Title_div").removeClass('<%="1".equals(buttonswitch)?"fixedBottomDivWeb":"fixedBottomDiv"%>');
                        }
                    });
                    
                    //修改播放器样式
                    $(".divSpeechDisplay").find("audio").each(function(){
                       if($(this).parent().find(".audioPlaybutton").length> 0) {
                            return;
                       }
                       var audio = this;
                       var audioParent = $(this).parent();
                       var playHtml = "";
                       playHtml +="<div class='audioPlaybutton'>&nbsp;</div>";
                       playHtml +="<div class='audioDurationDiv'>&nbsp;</div>";
                       //playHtml +="<video src='" + audio.src + "' controls='true'></video>";
                       audio.style.display = "none";
                       audioParent.append($(playHtml));
                       audioParent.find(".audioPlaybutton").add(audioParent.find(".audioDurationDiv")).bind("touchend",function(){
					        if(touchmoveFlag){
					            return;
					        }
                            $audioDurationDiv = audioParent.find(".audioDurationDiv");
                            if(audioParent.find(".audioPlaybutton").attr("class").indexOf("audioPausebutton") >= 0){
                                audio.pause();
                            }else{
                                audioParent.find(".audioPlaybutton").addClass("audioPausebutton");
                                audio.play();
                            }
                       });
                       $(audio).bind("pause",function() {
                            $audioDurationDiv = audioParent.find(".audioDurationDiv");
                            clearAuto();
                        });
                       $(audio).bind("ended",function() {
                            $audioDurationDiv = audioParent.find(".audioDurationDiv");
                            clearAuto();
                        });
                       $(audio).bind("playing",function() {
                            $audioDurationDiv = audioParent.find(".audioDurationDiv");
                            autoSlide();
                        });
                       
                       
                    });
                    remarkLoadingFlag = false;
                }
            }
        })
    
    }

    function imgCarousel(touchobj) {
         toURL(jQuery(touchobj).attr("src"),false);
	}

    var prevTop = 0;
    var $audioDurationDiv;
    var Durationcount=0;
    function autoSlide(){
        Durationcount += 50;
        if(Durationcount == 10000){
            Durationcount = 0;
        }
        $audioDurationDiv.css("background-position","center left " + Durationcount + "px")
        $autoFun = setTimeout(autoSlide, 150);//
    }
    function clearAuto(){ 
       $audioDurationDiv.parent().find(".audioPlaybutton").removeClass("audioPausebutton");
       clearTimeout($autoFun); 
    } 
    //加载更多
    function doexpandRemark(){
	    $("#remarkShowMore").html("处理中...");
	    jQuery("#workflowsignmore").attr("onclick", "");
	    $("#workflowsignmore").css("background", "#A4A4A4");
	    $("#workflowsignmore").css("border", "1px solid #A4A4A4");
	    isfirst = false;
	    remarksignloadClinet();
	}
    function autoScrollSign(){
        if(document.body.scrollHeight < $(document).scrollTop() + window.screen.availHeight){
            doexpandRemark();
        }
        //过滤滑动事件
    }


	
	//各种浏览按钮通用
	function showDialog(url, data) {
	    data += "&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
		data =joinFieldParams(data);
		<% //if(!"".equals(workflowHtmlShow)){ %>
		//如果是手机Html模式，需要对浏览按钮中的弹出框地址作修改。
			url = "/mobile/plugin/browser.jsp";
		<%// } %>

		try{
			
			var returnIdField = "";
			var returnShowField = "";
			var browserMethod = "";
			var browserTypeId = "";
			var customBrowType = "";
			var joinFieldParamsStr = "";
			var isMuti = "";
			var linkhref = "";
			
			var paramsArray = data.split("&");
			for (var i=0; i<paramsArray.length; i++) {
				var paramstr = paramsArray[i];
				
				var paramkv = paramstr.split("=");
				if (paramkv.length > 1) {
					if ("returnIdField" == paramkv[0]) {
						returnIdField = paramkv[1];
					}
					if ("returnShowField" == paramkv[0]) {
						returnShowField = paramkv[1];
					}
					
					if ("method" == paramkv[0]) {
						browserMethod = paramkv[1];
					}
					if ("isMuti" == paramkv[0]) {
						isMuti = paramkv[1];
					}
					if("joinFieldParams" == paramkv[0]){
					     joinFieldParamsStr = paramkv[1];
					}
					if("linkhref" == paramkv[0]){
						linkhref = paramkv[1];  
					}
				}
			}
			if(window._isFnaSubmitRequestJs4MobileWf&&
    	            ((window.dt1_organizationtype&&window.dt1_organizationid)||(window.dt1_organizationtype2&&window.dt1_organizationid2))
			){
				var _browserMethod_old = browserMethod;
		    	var _fieldID = "";
		    	var _indexno = "";
		    	var fieldIDArray = returnIdField.split("_");
		    	if(fieldIDArray!=null){
	                if(fieldIDArray.length>=2){
	                    _fieldID = fieldIDArray[0].replace("field","");
	                    _indexno = fieldIDArray[1];
	                }else{
	                    _fieldID = fieldIDArray[0].replace("field","");
					}
		    	}
				if(_fieldID!=""&&(_fieldID==window.dt1_organizationid || _fieldID==window.dt1_organizationid2)){
					var _dt1_organizationtype_isDtl = "1";
					var orgtype = "";
					if(_fieldID==window.dt1_organizationid){
						if(window.dt1_organizationtype_isDtl){
							_dt1_organizationtype_isDtl = window.dt1_organizationtype_isDtl;
						}
						orgtype = getWfMainAndDetailFieldValueForMobile(window.dt1_organizationtype, _dt1_organizationtype_isDtl, _indexno);
						
					}else if(_fieldID==window.dt1_organizationid2){
						if(window.dt1_organizationtype2_isDtl){
							_dt1_organizationtype_isDtl = window.dt1_organizationtype2_isDtl;
						}
						orgtype = getWfMainAndDetailFieldValueForMobile(window.dt1_organizationtype2, _dt1_organizationtype_isDtl, _indexno);
						
					}
					
					if(orgtype=="0"){
						browserMethod="listUser";
					}else if(orgtype=="1"){
						browserMethod="listDepartment";
					}else if(orgtype=="2"){
						browserMethod="listSubCompany";
					}else if(orgtype=="3"){
						browserMethod="listFnaCostCenter";
					}
					try{
						data=data.replace("&method="+_browserMethod_old+"&","&method="+browserMethod+"&");
					}catch(ex2){}
					
				}else if(_fieldID!=""&&(_fieldID==window.dt1_subject || _fieldID==window.dt1_subject2)){
					var _dt1_organizationtype_isDtl = "1";
					var orgtype = "";
					var _dt1_organizationid_isDtl = "1";
					var orgid = "";
					if(_fieldID==window.dt1_subject){
						if(window.dt1_organizationtype_isDtl){
							_dt1_organizationtype_isDtl = window.dt1_organizationtype_isDtl;
						}
						orgtype = getWfMainAndDetailFieldValueForMobile(window.dt1_organizationtype, _dt1_organizationtype_isDtl, _indexno);
						if(window.dt1_organizationid_isDtl){
							_dt1_organizationid_isDtl = window.dt1_organizationid_isDtl;
						}
						orgid = getWfMainAndDetailFieldValueForMobile(window.dt1_organizationid, _dt1_organizationid_isDtl, _indexno);
						
					}else if(_fieldID==window.dt1_subject2){
						if(window.dt1_organizationtype2_isDtl){
							_dt1_organizationtype_isDtl = window.dt1_organizationtype2_isDtl;
						}
						orgtype = getWfMainAndDetailFieldValueForMobile(window.dt1_organizationtype2, _dt1_organizationtype_isDtl, _indexno);
						if(window.dt1_organizationid2_isDtl){
							_dt1_organizationid_isDtl = window.dt1_organizationid2_isDtl;
						}
						orgid = getWfMainAndDetailFieldValueForMobile(window.dt1_organizationid2, _dt1_organizationid_isDtl, _indexno);
						
					}

					if(orgtype=="0"){
						orgtype="3";
					}else if(orgtype=="1"){
						orgtype="2";
					}else if(orgtype=="2"){
						orgtype="1";
					}else if(orgtype=="3"){
						orgtype="<%=FnaCostCenter.ORGANIZATION_TYPE%>";
					}
					
					try{
						var _fnaUrlPara1 = "orgid="+orgid+"&orgtype="+orgtype+"&isFnaSubmitRequest4Mobile=1";
						
						if(window.dt1_subject == window.dt1_subject2){
                    		var _dt1_organizationtype2_isDtl = "1";
                    		var _dt1_organizationid2_isDtl = "1";
                       		var orgtype2 = "";
                       	 	var orgid = "";
                        	if(_fieldID==window.dt1_subject){
                        		if(window.dt1_organizationtype2_isDtl){
                        			_dt1_organizationtype2_isDtl = window.dt1_organizationtype2_isDtl;
        		                }
                            	orgtype2 = getWfMainAndDetailFieldValueForMobile(window.dt1_organizationtype2, _dt1_organizationtype2_isDtl, _indexno);
        	                    if(window.dt1_organizationid2_isDtl){
        	                    	_dt1_organizationid2_isDtl = window.dt1_organizationid2_isDtl;
        		                }
        	                    orgid2 = getWfMainAndDetailFieldValueForMobile(window.dt1_organizationid2, _dt1_organizationid2_isDtl, _indexno);
                        		
                        	}else if(_fieldID==window.dt1_subject2){
                        		if(window.dt1_organizationtype_isDtl){
                        			 _dt1_organizationtype2_isDtl = window.dt1_organizationtype_isDtl;
         		                }
                             	orgtype2 = getWfMainAndDetailFieldValueForMobile(window.dt1_organizationtype, _dt1_organizationtype2_isDtl, _indexno);
         	                    if(window.dt1_organizationid_isDtl){
         	                    	_dt1_organizationid2_isDtl = window.dt1_organizationid_isDtl;
         		                }
         	                    orgid2 = getWfMainAndDetailFieldValueForMobile(window.dt1_organizationid, _dt1_organizationid2_isDtl, _indexno);
                        	}

                       	 	if(orgtype2=="0"){
                                orgtype2="3";
                            }else if(orgtype2=="1"){
                           	 	orgtype2="2";
                            }else if(orgtype2=="2"){
                           	 	orgtype2="1";
                            }else if(orgtype=="3"){
                           	 	orgtype2="<%=FnaCostCenter.ORGANIZATION_TYPE%>";
                            }
                       	 	
                       	 	_fnaUrlPara1 += "&orgid2="+orgid2+"&orgtype2="+orgtype2;
                        }
						
						data = data+"&"+_fnaUrlPara1;
					}catch(ex2){}
					
				}
			}
			if(window._FnaSubmitRequestJsRepayFlag || window._FnaSubmitRequestJsReimFlag){
				var _fieldID = "";
		    	var _indexno = "";
		    	var fieldIDArray = returnIdField.split("_");
		    	if(fieldIDArray!=null && fieldIDArray.length>=2){
		    		_fieldID = fieldIDArray[0].replace("field","");
		    		_indexno = fieldIDArray[1];
		    	}else{
		    		_fieldID = returnIdField.replace("field","");
		    	}
				if(_fieldID!=""&&_fieldID==window.dt2_fieldIdJklc){
					data = data+"&isFnaRepayRequest4Mobile=1&fnaWfRequestid="+js_requestid;
					if(window.main_fieldIdSqr_controlBorrowingWf && window.main_fieldIdSqr){
						data += "&main_fieldIdSqr_controlBorrowingWf="+window.main_fieldIdSqr_controlBorrowingWf+"&main_fieldIdSqr_val="+jQuery("#field"+window.main_fieldIdSqr).val();
					}
				}else if(_fieldID!=""&&_fieldID==window.main_fieldIdFysqlc && window._FnaSubmitRequestJsReimFlag){
					data = data+"&isFnaRequestApplication4Mobile=1&fnaWfRequestid="+js_requestid;
				}
			}
            if(browserMethod=='listFnaBudgetFeeType' || browserMethod=='listFnaCostCenter'){
                try{
                    var _UrlPara1 = "fnaworkflowid=<%=workflowid%>&fnafieldid="+returnIdField;
                    data = data+"&"+_UrlPara1;
                }catch(ex2){}
            }

		}catch(ex2){}
		<%--
	    	if(data.indexOf("method=listDepartment") === -1 && data.indexOf("method=listSubCompany") === -1  ){
		  showDialog2(url, data);
		}else{
		  departBrowser(data);
		}
		--%>
		showDialog2(url, data);
	}
	
	function getTrack(fieldid){
		//弹出位置轨迹的窗口

		window.location.href="/mobile/plugin/1/showLocationTrack.jsp?title=<%=SystemEnv.getHtmlLabelName(22981,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(126093,user.getLanguage())%>"
				+"&wfid=<%=workflowid%>&requestId=<%=requestid%>&fieldId="+fieldid +"&clienttype=" + clienttype +"&module=<%=module%>&scope=<%=scope%>&clientlevel=<%=clientlevel%>" ;
	}	
	
	function isNeedAffirmance() {
		return <%=workflowRequestInfo.isNeedAffirmance() %>;
	}
	
	function getIsselectrejectnode() {
		return <%=workflowRequestInfo.getWorkflowBaseInfo().getIsselectrejectnode() %>;
	}
	
	function doLeftButton() {
		if(<%=fromRequestid%> > 0 || "<%=fromES%>"=="true"||"<%=fromTask%>"=="true"){
			goBack();
			return 1;
		}
	}
	
	function dataInput(parfield, strFieldName){
		if(<%=workflowRequestInfo.isCanEdit()%>){
		  var strData="id=<%=workflowid%>&node=<%=nodeId%>&trg="+parfield;
		  dataInput2(parfield, strFieldName, strData);
		}
	}
	
	function isNeedAffirmance() {
		return <%=workflowRequestInfo.isNeedAffirmance() %>;
	}
	
	function docheckreject(){
		return docheckreject2(<%="2".equals(workflowRequestInfo.getTempletStatus()) %>);
	}
		
	function doreject(_this){
		if(jQuery("#SubmitToNodeid").length > 0) {
			jQuery("#SubmitToNodeid").val("");
		}
		doreject2(_this, <%=1 <= workflowRequestInfo.getWorkflowBaseInfo().getIsselectrejectnode() %>);
	}
	function dorejectIsfree(_this){
		if(jQuery("#SubmitToNodeid").length > 0) {
			jQuery("#SubmitToNodeid").val("");
		}
		 if(remarksignCheck("reject")){
	<%
	if(freedis.equals("1")){%>
	 $('#src').val("reject");
	 $('#workflowfrm').submit();
	<%}else{
	%>
	 var url = "/mobile/plugin/browser.jsp";
	 var datas = encodeURI("&returnIdField=rejectToNodeid&returnShowField=rejectToNodeName&method=listBrowserData&browserTypeId=-100&customBrowType=<%=workflowid%>|<%=requestid%>|<%=nodeId%>&isMuti=0");
	 showDialog(url, datas);
	 <%}%>
		 }
	}
	
	//主表信息
	function getSignatureStatus() {
		return <%="1".equals(workflowRequestInfo.getSignatureStatus()) %>;
	}
	function getTempletStatus() {
		return <%="1".equals(workflowRequestInfo.getTempletStatus()) %>;
	}
	
	function isMustInputRemark(src) {
		if("reject" == src) {
			return <%=workflowRequestInfo.isRejectMustInputRemark() %>;
		}else {
		return <%=workflowRequestInfo.isMustInputRemark() %>;
		}
	}
	
	//为了能在custompage4Emoble中定义的jsp中重写提交事件此处，添加了一个流程生成的提交按钮的事件的入口函数
	function doSubmit_4Mobile(_object, _callBackFunType){
		if(_callBackFunType==1){
			return dosubmit(_object);
		}else if(_callBackFunType==2){
			return dosubnoback(_object);
		}else if(_callBackFunType==3){
			return dosubback(_object);
		}
	}
	
	function createMap(){
		map = new AMap.Map("map", {
			keyboardEnable:false,
			level:11,
			resizeEnable:false,
		});	
   	
    	map.plugin('AMap.Geolocation', function() {
	        geolocation = new AMap.Geolocation({
	            enableHighAccuracy: true,//是否使用高精度定位，默认:true
	            timeout: 5000,          //超过10秒后停止定位，默认：无穷大

	            showButton: false, 
	            //buttonOffset: new AMap.Pixel(10, 20),//定位按钮与设置的停靠位置的偏移量，默认：Pixel(10, 20)
	            zoomToAccuracy: false,     // 定位成功后调整地图视野范围使定位位置及精度范围视野内可见，默认：false
				showMarker:false
	        });   
	        map.addControl(geolocation);	        
	        AMap.event.addListener(geolocation, 'complete', onComplete);//返回定位信息
	        AMap.event.addListener(geolocation, 'error', onError);      //返回定位出错信息
	    });	    	
  	} 
	
	function  getLoctionInfo(fieldid){
			//获取定位时间,经度,纬度
			fieldId = fieldid;
			geolocation.getCurrentPosition();
			jQuery('#clearLocationId' + fieldid).attr("disabled","disabled");
			jQuery('#clearLocationId' + fieldid).attr("onclick","");
	} 
  	
  	//解析定位结果
    function onComplete(data) {
		regeocoder(data.position.getLng(),data.position.getLat());
    } 
    
    //解析定位错误信息
    function onError(data) {
    	alert("请检查网络是否连接！");
    }
    
    //逆地理编码

  	function regeocoder(lng,lat) {  
  		var geocoder = new AMap.Geocoder({
            radius: 1000,
            extensions: "all"
        });  
        
        var lngLat = [lng,lat]      
        geocoder.getAddress(lngLat, function(status, result) {
            if (status === 'complete' && result.info === 'OK') {
                geocoder_CallBack(lng,lat,result);
            }
        });        
    }
    
    function geocoder_CallBack(lng,lat,result) {
        var address = result.regeocode.formattedAddress; //返回地址描述
        
  		curiPosi = {
  						lng:lng,
  						lat:lat,
  						addr:address
  					};
  		var timestamp = (new Date()).getTime();
  		var resultStr = timestamp +","+lng+","+lat+","+address;
  		var data = fieldId +","+"<%=nodeId%>"+"," +"<%=userid%>";
  		getGpsInfo(data, resultStr);
    }
    
    /* 获取签字意见是否添加位置信息,web端暂未处理, */	
	function getLocateStatus(wfid){
		return 0;
	}
	
</script>

<script type="text/javascript" src="/mobile/plugin/browsernew/js/zepto.min_wev8.js?2"></script>
<style>
#departChooseDiv{
    position:fixed;
    left: 0px;
    top: 0px;
    width: 100%;
    height: 100%;
    z-index: 99999;
    transition:All 0.3s;
    -webkit-transition:All 0.3s;
    -webkit-transform: translate3d(100%, 0, 0);
    transform: translate3d(100%, 0, 0);
    visibility: hidden;
}
body.hrmshow #departChooseDiv{
    -webkit-transform: translate3d(0, 0, 0);
    transform: translate3d(0, 0, 0);
    visibility: visible;
}
#departChooseFrame{
    width: 100%;
    height: 100%;
}
</style>

</head>


<body >
<%--
<div id="departChooseDiv">
    <iframe id="departChooseFrame" src="/mobile/plugin/browsernew/departBrowser.jsp" frameborder="0" scrolling="auto">
    </iframe>
</div>
--%>

<%
String[] info = WorkflowRequestMessage.resolveSystemwfInfo(messagecontent);
systemwfInfo = info[0];
resetoperator = info[1];
%>
<!-- 异常选择人员提交 -->
<%if("y".equals(Util.null2String(request.getParameter("needChooseOperator")))|| "y".equals(resetoperator)){ %>
	<jsp:include page="/mobile/plugin/1/RequestChooseOperator.jsp" flush="true">
	</jsp:include>
<%} %>
<%if(includeLocation){%>
<div id='map' style='height:1px;width:1px;display:block;'></div>
<%} %>
<div id="view_page">
	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<table class="webtoolbarTbl">
			<tr>
				<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div class="webtoolbarItem">
						返回
						</div>
					</a>
				</td>
				<td align="center" valign="middle">
					<div id="view_title"><%=workflowRequestInfo.getWorkflowBaseInfo().getWorkflowName() %></div>
				</td>
				<td width="10%" align="right" valign="middle" style="padding-right:5px;">
					<a href="javascript:logout();">
						<div class="webtoolbarItem">
						退出
						</div>
					</a>
				</td>
			</tr>
		</table>
	</div>


	<div data-role="page" class="page workFlowView">

<% 
//没有开启可查看表单内容的权限时，流程图流程状态不允许查看

//判断权限
String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
if("".equals(CurrentUser)){
    CurrentUser = String.valueOf(user.getUID());
}
//获取操作权限
Map<String,String> rightMap = new HashMap<String, String>();
if ("-1005".equals(module)) {
    rightMap = Monitor.getWorkflowRight(request,user,CurrentUser,requestid);
}
if (!canview) {
	String viewRight = rightMap.get("viewRight");
    canview = "true".equals(viewRight) || intModule >= 0 || "-1005".equals(module);
}
if(canview){%>
<div id="header" class="headToolbarDiv">        
	<div class="toolbarDivClass">
		<div class="toolbarCurItem">
            <%-- 表单 --%>
            <%=SystemEnv.getHtmlLabelName(31923,user.getLanguage()) %>
		</div>
		<a href="javascript:goWfPic();">
		<div class="toolbarCenItem">
		<%-- 流程图 --%>
            <%=SystemEnv.getHtmlLabelName(18912,user.getLanguage()) %>
		</div>
		</a>
		<a href="javascript:goWfStatus();">
		<div class="toolbarRhtItem">
            <%-- 状态 --%>
            <%=SystemEnv.getHtmlLabelName(126034,user.getLanguage()) %>
		</div>
		</a>		
	</div>
</div>
<div id="msgsendSystemInfo" style="display:none;">
	<%=systemwfInfo %>
</div>
<%if("1".equals(ismonitor) && module.equals("-1005")){%>
    <%--流程信息--%>
    <div class="requestIfons" ontouchend="doShowDt(this)" >
        <div class="left">
            <%=SystemEnv.getHtmlLabelName(32210, userLanguage)%>
        </div>
        <div class="right">
            &nbsp;
        </div>
    </div>
<%}%>
</div>
    <!-- 流程 信息 --> 
    <%if("1".equals(ismonitor)){ %>
        <jsp:include page="/mobile/plugin/1/monitor/monitordtform.jsp" flush="true">
            <jsp:param name="requestid" value="<%=requestid%>"/>
            <jsp:param name="userLanguage" value="<%=userLanguage%>"/>
        </jsp:include>
    <%} %>
<%=WorkflowRequestMessage.getClientInfoHtml(messageid,messagecontent,user)%>	
<%}%>
<iframe id="selectChangeDetail" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<form id="workflowfrm" action="/mobile/plugin/1/RequestOperation.jsp?module=<%=module%>&scope=<%=scope%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>" method="post" enctype="multipart/form-data" autocomplete="off">
			<div class="form_out_content" data-role="content" style="margin-left: 10px; margin-right: 10px; padding-top: 0px;<%=ismobilehtml?"width:100%;overflow-y:hidden;":""%>">
					<input type="hidden" id="type" name="type" value="<%=type %>" />
					<input type="hidden" id="method2" name="method2" value="<%=method %>" />
					<input type="hidden" id="src" name="src" value="<%=method %>" />
					<input type="hidden" id="markId" name="markId"/>
					<input type="hidden" id="userid" name="userid" value="<%=userid%>"/>
					<input type="hidden" id="clientver" name="clientver" value="<%=clientVer%>"/>
					<input type="hidden" id="serverver" name="serverver" value="<%=serverVer%>"/>
					<input type="hidden" id="forwardflag" name="forwardflag" value="0"/>
					<input type="hidden" id="ismonitor" name="ismonitor" value="<%=ismonitor%>"/>
					<input type="hidden" id="isurge" name="isurge" value="<%=isurge%>"/>
					<input type="hidden" id="intervenorright" name="intervenorright" value="<%=intervenorright%>"/>
                   	<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
					<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
					<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>
					<input type="hidden" name="requestURI" id="requestURI" >
					<%if(isRemarkLocation>0) {%>
                    			<input type="hidden" id="remarkLocation" name="remarkLocation" value="">
                    			<%} %>
<div>

<% if(!canview){%>
    <div  style="font-size:12pt;height:60px;line-height:60px;text-align:center;">
    <%-- 抱歉,您没有流程内容查看权限... --%>
    <%=SystemEnv.getHtmlLabelName(126351,user.getLanguage()) %>
    </div>
<%}else{ %>
<div class="form_content" style="height:24px;width:100%">&nbsp;</div>
					<%
					
					if (workflowHtmlShow != null && !"".equals(workflowHtmlShow)) {
						if(!"create".equals(method)){
							if(iscanedit){
								workflowHtmlShow=workflowHtmlShow;
							}else{
								workflowHtmlShow=workflowHtmlShow.replaceAll("&lt;","<").replaceAll("&gt;",">");
							}
						}
					%>

						<div class="ui-body ui-body-d ui-view-corner ui-view-opacity">
                    
						<%
						if(workflowRequestInfo.getVersion()==2){ 
						%>
							<%@ include file="/mobile/plugin/1/html/operDetail.jsp" %>
							<%@ include file="/mobile/plugin/1/html/htmlcalculate.jsp" %>
						<%} %>
							<%=workflowHtmlShow %>
						</div>

					<%} else {
					    if(canview){
					%>
						<!-- 主表和明细表 -->
						<%@ include file="/mobile/plugin/1/form.jsp" %>
					<%
					    }
					} 
					%>
					
					<%if(IsFreeWorkflow){  %>
						<%@ include file="/mobile/plugin/1/mobileformfree.jsp" %>
					<%}
					
	}%>

	

					<!-- 干预 提交 -->

<%

//流程干预按钮
String showInterventionBtn = rightMap.get("showInterventionBtn");
if("true".equals(showInterventionBtn) && module!= null && intModule == -1005 ){ %>

	<div style="height:10px;overflow:hidden;"></div>
	<div class="blockHead" style="margin-top:15px;">
	        <span class="m-l-14"><%=SystemEnv.getHtmlLabelName(18194,user.getLanguage()) %></span>
	</div>
	<jsp:include page="/mobile/plugin/1/monitor/RequestIntervenor.jsp" flush="true">
	<jsp:param name="workflowid" value="<%=workflowid%>"/>
	<jsp:param name="intervenorright" value="<%=intervenorright%>"/>
	<jsp:param name="userid" value="<%=userid%>"/>
	<jsp:param name="usertype" value="<%=usertype%>"/>
	<jsp:param name="isbill" value="<%=isBill%>"/>
    <jsp:param name="billid" value="<%=billid%>"/>
	<jsp:param name="nodeid" value="<%=nodeId%>"/>	
	<jsp:param name="requestid" value="<%=requestid%>"/>	
	<jsp:param name="formid" value="<%=formId%>"/>	
	<jsp:param name="nodetype" value="<%=currentNodeType%>"/>
	<jsp:param name="creater" value="<%=creator%>"/>
	<jsp:param name="creatertype" value="<%=creatertype%>"/>
	
	
	</jsp:include>
<%} %>
	
		<div style="height:10px;overflow:hidden;"></div>
			
			<input type="hidden" name="module2" value="<%=module %>">
			<input type="hidden" name="scope2" value="<%=scope %>">
			<input type="hidden" name="page.pageNo" value="1">
			<input type="hidden" name="requestid" value="<%=requestid %>">
			<input type="hidden" name="workflowid" value="<%=workflowid %>">
			<input type="hidden" name="workflowsignid" value='0'/>
			<table id="head" cellspacing="0" cellpadding="0" width="100%" style="table-layout:fixed;word-break:break-all;display:none;">
			<%
			int cntDisplayBtn = 0;
			if ((workflowRequestInfo.getSubmitButtonName() != null && !workflowRequestInfo.getSubmitButtonName().equals(""))
					||(workflowRequestInfo.getSubnobackButtonName()!=null&&!workflowRequestInfo.getSubnobackButtonName().equals(""))
					||(workflowRequestInfo.getSubbackButtonName()!=null&&!workflowRequestInfo.getSubbackButtonName().equals(""))
					||(workflowRequestInfo.getForwardButtonName()!=null&&!workflowRequestInfo.getForwardButtonName().equals(""))
					||(workflowRequestInfo.getGivingOpinionsbackName()!=null&&!workflowRequestInfo.getGivingOpinionsbackName().equals(""))
					||(workflowRequestInfo.getGivingOpinionsnobackName()!=null&&!workflowRequestInfo.getGivingOpinionsnobackName().equals(""))
					||(workflowRequestInfo.getGivingopinionsName()!=null&&!workflowRequestInfo.getGivingopinionsName().equals("")) 
				    ||(workflowRequestInfo.getRetractbackButtonName()!=null&&!workflowRequestInfo.getRetractbackButtonName().equals(""))
				    ||(workflowRequestInfo.getSaveButtonName() != null && !workflowRequestInfo.getSaveButtonName().equals(""))
					|| isurger || (intervenorright>0)) {
				cntDisplayBtn++;
				if((workflowRequestInfo.getForwardButtonName()!=null&&!workflowRequestInfo.getForwardButtonName().equals("")) 
					|| isurger || (intervenorright>0)){ //加上督办权限
					isCanEditRemark = true;
				}
			%>
			<tr><td>

				<div class="remarkArea" style="<%=isCanEditRemark?"display:block":"display:none"%>">
				<table style="width:100%;">
					
					<%-- Mobile4.5功能 --%>
					<tr style="<%=flagServerVersion4_5?"display:block":"display:none"%>">
						<td>
							<!-- 手写签批显示  和 语音附件播放使用 -->
							<div id="divHandWrittenSign" ></div>
							<br>
							<div id="divSpeechAttachment"></div>
							<br>
							<div style="display:none">
								<%-- 如下两个隐藏域 分别表示  语音附件 和 手写签章 --%>
								<input type="hidden" id="fieldSpeechAppend" name="fieldSpeechAppend" value=""/>
							</div>
							<div>
								<img id="markImg" src=""  style="display:none;" class="signatureStyle" />
							</div>
						</td>
					</tr>
					
				</table>
				</div>
			</td></tr>
			<%} %>
			</table>
		</div>
		<div style="height:10px;overflow:hidden;"></div>
	</div>
</div>
<%
		//如果非创建节点则显示
		if (!"create".equals(method) && canview) {
		%>
		<div sytle="height:26px;width:100%;">
	        <div id="page_remarksign_Title_div">
	            <div>
	                <%-- 流转意见 --%>
	                <%=SystemEnv.getHtmlLabelName(125734,user.getLanguage()) %>
	            </div>
	        </div>
	        <div style="width:1px;float:left;">&nbsp;</div>
        </div>
        <div id="workflowrequestsignblock">
            <div id="firstload" style="text-align: center; height: 18px;">
                <img src="/images/loading2_wev8.gif" style="vertical-align: middle;">
                <%-- 正在加载，请稍后... --%>
                <span
                    style="display: inline-block; height: 18px !important; line-height: 18px; vertical-align: middle;"><%=SystemEnv.getHtmlLabelName(81558,user.getLanguage())%></span>
            </div>
        </div>
        <div style='height: 20px; width: 100%; border-top: #d9d9d9 solid 1px; clear: both;'></div>
		<div id="remarkTempDiv" style='display:none; clear: both;'></div>
        <div id="remarkShowMore" onclick="javascript:doexpandRemark();"><%=SystemEnv.getHtmlLabelName(82720,user.getLanguage())%></div>
		<%}%>
		<div style="height:<%="1".equals(buttonswitch)?"60":"20"%>px;overflow:hidden;"></div>
	<%
			 cntDisplayBtn = 0;
				boolean onlyforwardButton=true;
			if ((workflowRequestInfo.getSubmitButtonName() != null && !workflowRequestInfo.getSubmitButtonName().equals(""))
					||(workflowRequestInfo.getSubnobackButtonName()!=null&&!workflowRequestInfo.getSubnobackButtonName().equals(""))
					||(workflowRequestInfo.getSubbackButtonName()!=null&&!workflowRequestInfo.getSubbackButtonName().equals(""))
					||(workflowRequestInfo.getForwardButtonName()!=null&&!workflowRequestInfo.getForwardButtonName().equals(""))
					||(workflowRequestInfo.getGivingOpinionsbackName()!=null&&!workflowRequestInfo.getGivingOpinionsbackName().equals(""))
					||(workflowRequestInfo.getGivingOpinionsnobackName()!=null&&!workflowRequestInfo.getGivingOpinionsnobackName().equals(""))
					||(workflowRequestInfo.getGivingopinionsName()!=null&&!workflowRequestInfo.getGivingopinionsName().equals("")) 
				    ||(workflowRequestInfo.getRetractbackButtonName()!=null&&!workflowRequestInfo.getRetractbackButtonName().equals(""))
				    ||(workflowRequestInfo.getSaveButtonName() != null && !workflowRequestInfo.getSaveButtonName().equals(""))
					|| isurger || (intervenorright>0)) {
				cntDisplayBtn++;
				if((workflowRequestInfo.getForwardButtonName()!=null&&!workflowRequestInfo.getForwardButtonName().equals("")) 
					|| isurger || (intervenorright>0)){ //加上督办权限
					isCanEditRemark = true;
				  }
				  if(isCanEditRemark){
					   if((workflowRequestInfo.getSubmitButtonName() != null &&!workflowRequestInfo.getSubmitButtonName().equals(""))){
					        onlyforwardButton =false;
				       }
					   if(workflowRequestInfo.getSubnobackButtonName()!=null&&!workflowRequestInfo.getSubnobackButtonName().equals("")){
                            onlyforwardButton =false;
					   }
					   if(workflowRequestInfo.getSubbackButtonName()!=null&&!workflowRequestInfo.getSubbackButtonName().equals("")){
					          onlyforwardButton =false;
					   }
					   if(workflowRequestInfo.getGivingOpinionsbackName()!=null&&!workflowRequestInfo.getGivingOpinionsbackName().equals("")){
                           onlyforwardButton =false;
					   }
					   if(workflowRequestInfo.getGivingOpinionsnobackName()!=null&&!workflowRequestInfo.getGivingOpinionsnobackName().equals("")){
                               onlyforwardButton =false;
					   }
					   if(workflowRequestInfo.getGivingopinionsName()!=null&&!workflowRequestInfo.getGivingopinionsName().equals("")){
                               onlyforwardButton =false;
					   }
					   if(workflowRequestInfo.getSaveButtonName()!=null&&!workflowRequestInfo.getSaveButtonName().equals("")){
                               onlyforwardButton =false;
					   }
					    if(workflowRequestInfo.getRetractbackButtonName()!=null&&!workflowRequestInfo.getRetractbackButtonName().equals("")){
                               onlyforwardButton =false;
					   }
				  }
				  
%>
               <div id="signbuttonbg"></div>
		 <div class="signbuttonbox" style="display:none">
				   <ul class="ulbutton ulbtnlist">
				   </ul>
				    <ul class="ulbutton ulcancal" style="margin-top:6px;margin-bottom:6px;">
					  <li class="ullibutton"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage()) %></li>
				   </ul>
			
		 </div>

        <div id="signbg"></div>
		<div class="signbox" style="display:none">
		<%if(isCanEditRemark){%>
			<div class="signtitle">
				<table cellpadding="0" width="100%" height="100%" cellspacing="0px" border="0">
					<colgroup>
						<col width="35%" />
						<col width="*" />
						<col width="35%" />
					</colgroup>
					<tr style="height:100%">
				
						<td>
							<div class="signforwardimg">&nbsp;</div>
						</td>
						
						<td align="center">
							<div class="signnotationtitle">
								<%
									if (workflowRequestInfo.getWorkflowPhrases() != null) {
									%>
									<select id="phrase" onclick="(jQuery('#userSignRemark'))[0].style.display = ''"
										onchange="addToRemark2(this);resetselect();" >
										<option value="0" selected="selected" >
										<%=SystemEnv.getHtmlLabelName(22409,user.getLanguage())%>
										</option>
										<%
										for (int i=0; i<workflowRequestInfo.getWorkflowPhrases().length; i++) {
											String selectkey = workflowRequestInfo.getWorkflowPhrases()[i][1].replace("\"", "&quot;");
											String selectValue = workflowRequestInfo.getWorkflowPhrases()[i][0].replace("\"", "&quot;");
										%>
											<option value="<%=selectkey%>"><%=selectValue %></option>
										<%} %>
									</select>
								<%}%>
							</div>
						</td>
						<td style="text-align:right;padding-right:10px;">
						<%
						   String isFormSignature = workflowRequestInfo.getIsFormSignature();
						   //if(isCanEditRemark && flagServerVersion4_5||"1".equals(isFormSignature)){
						  // if(isCanEditRemark && flagServerVersion4_5&&!clienttype.equals("Webclient")){
						%>
							<div class="signaddmore" style="<%=isCanEditRemark ||"1".equals(isFormSignature)?"display:block":"display:none"%>">
							   <img src="/mobile/plugin/1/images/addmore.png"></img>
							    <div id="signaddmorebg" style="display:none">
									 <ul>
									    <li id="handWrittenSignLi">手写签批</li>
										<!--<li onclick="getSpeechAttachment();">语音附件</li>-->
									  <%if("1".equals(isFormSignature)){%>
										<li onclick="showDialogEletricSignature('/mobile/plugin/1/browserSignature.jsp','&userid=<%=userid%>');">电子签章</li>
									  <%}%>
									 </ul>
								</div>
							</div>
						 <% //}%>
						</td>
					</tr>
				</table>
			</div>
			<div class="signlist" style="margin:0; padding:0;">
				<div style="margin:0 10px;height:100%;">
			     <textarea  id="userSignRemark" name="userSignRemark" placeholder="请输入签字意见" ><%=workflowRequestInfo.getRemark() == null ? "" : workflowRequestInfo.getRemark()%></textarea>

			   <%if (workflowRequestInfo.isMustInputRemark()) {%>
					<div id="userSignRemark_ismandspan" class="ismand">!</div>
				<%} %>
				</div>
			</div>
			<%}%>
			<div class="signlistbtn">
			   	<div class="signbtnopration">
			   </div>
			   <div class="signbtnforwardopration" style="display:none;">
			   </div>
				<% if (workflowRequestInfo.getRejectButtonName()!=null&&!workflowRequestInfo.getRejectButtonName().equals("")) { cntDisplayBtn++; }
				if(cntDisplayBtn > 0 || "1".equals(ismonitor)){ %>
				    <%
					if(!("-1005".equals(module) || "-1004".equals(module))){
						int isBack = 0; // 标识默认的提交按钮
					if (workflowRequestInfo.getSubmitButtonName()!=null&&!workflowRequestInfo.getSubmitButtonName().equals("")) {
						isBack = 1;
					%>
					<div class="listbtnhandler" onclick="doSubmit_4Mobile(this,1);">
					   <div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/approval.png);background-size: contain;"></div>
				       <div class="listbtntext">
					      <%=workflowRequestInfo.getSubmitButtonName() %>
					   </div>
					 </div>
					<%} %>
					<%
					if (workflowRequestInfo.getSubnobackButtonName()!=null&&!workflowRequestInfo.getSubnobackButtonName().equals("")) {
						if(isBack != 1) {
							isBack = 2;
						}
					%>
					 <div class="listbtnhandler" onclick="doSubmit_4Mobile(this,2);">
					   <div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/approval.png);background-size: contain;"></div>
				       <div class="listbtntext">
					        <%=workflowRequestInfo.getSubnobackButtonName()%>
					   </div>
					  </div>
					<%} %>
					<%
					if (workflowRequestInfo.getSubbackButtonName()!=null&&!workflowRequestInfo.getSubbackButtonName().equals("")) { 
						if(isBack != 1) {
							isBack = 3;
						}
					%>
					<div class="listbtnhandler" onclick="doSubmit_4Mobile(this,3);">
					   <div class="listbtnimg" style="background-image:url(/mobile/plugin/1/images/approval.png);background-size: contain;"></div>
				       <div class="listbtntext">
					        <%=workflowRequestInfo.getSubbackButtonName()%>
					  </div>
					 </div>
					<%
					}
					%>
					<%
					if (workflowRequestInfo.getSaveButtonName()!=null&&!workflowRequestInfo.getSaveButtonName().equals("")) { 
					%>
					<div class="listbtnhandler" onclick="dosave(this);">
					   <div class="listbtnimg" style="background-image:url(/mobile/plugin/1/images/approval.png);background-size: contain;"></div>
				       <div class="listbtntext">
					        <%=workflowRequestInfo.getSaveButtonName()%>
					  </div>
					 </div>
					<%
					}
					%>
					<%
						if(!"".equals(Util.null2String(workflowRequestInfo.getSubmitButtonName()))
							|| !"".equals(Util.null2String(workflowRequestInfo.getSubnobackButtonName()))
							|| !"".equals(Util.null2String(workflowRequestInfo.getSubbackButtonName()))
						) {
					%>
					<input type="hidden" id="SubmitToNodeid" name="SubmitToNodeid" value="" />
					<%	} %>
					<%	if(workflowRequestInfo.getSubmitDirectName() != null && !workflowRequestInfo.getSubmitDirectName().equals("")) { %>
					 <div class="listbtnhandler" onclick="doSubmitDirect(this, <%=isBack %>);">
					   <div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/approval.png);background-size: contain;"></div>
				       <div class="listbtntext">
					        <%=workflowRequestInfo.getSubmitDirectName()%>
					   </div>
					  </div>
				     <%	} %>

				     <%if (workflowRequestInfo.getRejectButtonName()!=null&&!workflowRequestInfo.getRejectButtonName().equals("")) {
					  if(!"".equals(isornotFree)){
					    if(isreject.equals("1")){
					%>
						<div class="listbtnhandler" onclick="dorejectIsfree(this);">
							<div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/refused.png);background-size: contain;"></div>
							<div class="listbtntext"><%=SystemEnv.getHtmlLabelName(236,user.getLanguage()) %></div>
						</div>
						<input type="hidden" id="rejectToNodeid" name="rejectToNodeid" value="<%=zjclNodeid %>">
					  <%}
					   }else{%>
						<div class="listbtnhandler" onclick="doreject(this);">
							<div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/refused.png);background-size: contain;"></div>
							<div class="listbtntext">
								<%=workflowRequestInfo.getRejectButtonName() %>
							</div>
						</div>
						<input type="hidden" id="rejectToNodeid" name="rejectToNodeid" value="">
					   <%}%>
					   <input type="hidden" id="RejectToType" name="RejectToType" value="0" />
					<%
					}else {%>
					    <% if(isreject.equals("1")){%>
					    	<%if(iscanedit){ %>
					    	 <div class="listbtnhandler" onclick="dorejectIsfree(this);">
							    <div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/refused.png);background-size: contain;"></div>
				                <div class="listbtntext"><%=SystemEnv.getHtmlLabelName(236,user.getLanguage()) %></div>
							  </div>
							   <input type="hidden" id="rejectToNodeid" name="rejectToNodeid" value="<%=zjclNodeid %>">
						   <%} %>
					    <%}%>
					<% }%>
					 <%
					if (workflowRequestInfo.getRetractbackButtonName()!=null&&!workflowRequestInfo.getRetractbackButtonName().equals("")) {
					%>
					 <div id="doretract" class="listbtnhandler" onclick="doRetract(this,'rb');">
					  <div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/forwarding.png);background-size: contain;"></div>
					  <div class="listbtntext"><%=workflowRequestInfo.getRetractbackButtonName() %></div>
					 </div>
					<%}%>
					<%
					 if (workflowRequestInfo.getForwardButtonName()!=null&&!workflowRequestInfo.getForwardButtonName().equals("")) { 
					%>
						<div class="forwardbtn listbtnhandler" onclick="doforwardBtn()">
						  <img src="/mobile/plugin/1/images/forwarding_new.png"></img>
						  <div class="listbtntext" style="display:none;">
								<%=workflowRequestInfo.getForwardButtonName() %>
							</div>
						</div>
						<input type="hidden" id="forwardresourceids" name="forwardresourceids"/>
						<table style="display:none">
						   <tr>
						    <td id="forwardresources"  jsfn="1">
							</td>
						   </tr>
						</table>
                   <%}%>
					<%
					 if (workflowRequestInfo.getForwardButtonName()!=null&&!workflowRequestInfo.getForwardButtonName().equals("")) { 
					%>
					 <div id="doforward" class="listbtnhandler" onclick="doforwardhandler();">
					  <div class="listfordwardbtnimg"  style="background-image:url(/mobile/plugin/1/images/forwarding.png);background-size: contain;"></div>
					  <div class="listfordwardbtntext"><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></div>
					 </div>
					<%}%>
				  <%if (workflowRequestInfo.getTakingOpsButtonName()!=null&&!workflowRequestInfo.getTakingOpsButtonName().equals("")) { %>
				       <div class="listbtnhandler" onclick="doforward2(this);">
						<div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/forwarding.png);background-size: contain;"></div>
				        <div class="listbtntext">
					        <%=workflowRequestInfo.getTakingOpsButtonName() %>
						</div>
					  </div>
						<input type="hidden" id="forwardresourceids2" name="forwardresourceids2"/>
						<div id="forwardresources2" style="display:none" jsfn="1"></div>
                  <%}%>
                   <%if (workflowRequestInfo.getHandleForwardButtonName()!=null&&!workflowRequestInfo.getHandleForwardButtonName().equals("")) { %>
                       <div class="listbtnhandler" onclick="doforward3(this);">
						<div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/forwarding.png);background-size: contain;"></div>
				        <div class="listbtntext">
					        <%=workflowRequestInfo.getHandleForwardButtonName() %>
						</div>
					   </div>
						<div id="forwardresources3" style="display:none" jsfn="1"></div>
                  <%}%>
                  <%if (workflowRequestInfo.getForhandbackButtonName()!=null&&!workflowRequestInfo.getForhandbackButtonName().equals("")) { %>
                     <div class="listbtnhandler" onclick="doforward3();">
						 <div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/forwarding.png);background-size: contain;"></div>
							<div class="listbtntext"> 
								<%=workflowRequestInfo.getForhandbackButtonName() %>
							</div>
					  </div>
					 <div id="forwardresources3" style="display:none" jsfn="1"></div>
                  <%}%>
                   <%
					if (workflowRequestInfo.getForhandnobackButtonName()!=null&&!workflowRequestInfo.getForhandnobackButtonName().equals("")) { 
					%>
					<div class="listbtnhandler" onclick="doforward3();">
					  <div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/forwarding.png);background-size: contain;"></div>
				      <div class="listbtntext">
					        <%=workflowRequestInfo.getForhandnobackButtonName() %>
					  </div>
					 </div>
					  <div id="forwardresources3" style="display:none" jsfn="1"></div>
                  <%}%>
                  <input type="hidden" id="forwardresourceids3" name="forwardresourceids3"/>
				   <%if (workflowRequestInfo.getGivingopinionsName()!=null&&!workflowRequestInfo.getGivingopinionsName().equals("")) { %>
					<div class="listbtnhandler" onclick="doSubmit_4Mobile(this,1);">
						  <div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/forwarding.png);background-size: contain;"></div>
						  <div class="listbtntext">
								<%=workflowRequestInfo.getGivingopinionsName() %>
						  </div>
					</div>
                  <%}%>	
                   <%if (workflowRequestInfo.getGivingOpinionsbackName()!=null&&!workflowRequestInfo.getGivingOpinionsbackName().equals("")) { %>
				     <div class="listbtnhandler" onclick="doSubmit_4Mobile(this,2);">
					   <div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/forwarding.png);background-size: contain;"></div>
				       <div class="listbtntext">
					        <%=workflowRequestInfo.getGivingOpinionsbackName() %>
					   </div>
					  </div>
                  <%}%>
                   <%
					if (workflowRequestInfo.getGivingOpinionsnobackName()!=null&&!workflowRequestInfo.getGivingOpinionsnobackName().equals("")) { 
					%>
					  <div class="listbtnhandler" onclick="doSubmit_4Mobile(this,3);"> 
					   <div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/forwarding.png);background-size: contain;"></div>
				       <div class="listbtntext">
					        <%=workflowRequestInfo.getGivingOpinionsnobackName() %>
					   </div>
					  </div>
                  <%}%>
				<%}%>
				 <%
					if ("-1004".equals(module)) { 
					%>
					<div class="listbtnhandler" onclick="dosupervise(this);">  
					  <div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/duban.png);background-size: contain;"></div>
				      <div class="listbtntext">
					     <%=SystemEnv.getHtmlLabelName(126515,user.getLanguage())%>
					  </div>
					 </div>
                  <%}%>
                 <%
				//删除按钮
				String showDeleteBtn = rightMap.get("showDeleteBtn");
				//暂停按钮
				String showStopBtn = rightMap.get("showStopBtn");
				//撤销按钮
				String showCancelBtn = rightMap.get("showCancelBtn");
				//启用按钮
				String showRestartBtn = rightMap.get("showRestartBtn");
				//强制归档按钮
				String showOvmBtn = rightMap.get("showOvmBtn");
				//强制收回按钮
				String showRbmBtn = rightMap.get("showRbmBtn");
				%>
				 <%if(module.equals("-1005")){%>
					<%if("true".equals(showDeleteBtn) ){%>
						<%--删除 --%>
						<div class="listbtnhandler" onclick="deleteWorkflowByRequestID(this);"> 
							<div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/approval.png);background-size: contain;"></div>
							<div class="listbtntext"><%=SystemEnv.getHtmlLabelName(125426,user.getLanguage())%></div>
						</div>
					<%}if("true".equals(showStopBtn)){%>
						<%--暂停 --%>
						<div class="listbtnhandler" onclick="doStop(this);">
							<div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/approval.png);background-size: contain;"></div>
							<div class="listbtntext"><%=SystemEnv.getHtmlLabelName(20387,user.getLanguage()) %></div>
						</div>
					<%}else if("true".equals(showRestartBtn)){%>
						<%--启用 --%>
						
						<div class="listbtnimg" onclick="doRestart(this);" style="background-image:url(/mobile/plugin/1/images/approval.png);background-size: contain;"></div>
				        <div class="listbtntext"><%=SystemEnv.getHtmlLabelName(31676,user.getLanguage()) %></div>
					<%}%>
					<%if("true".equals(showCancelBtn)){%>
					  <div class="listbtnhandler" onclick="doCancelw(this);"> 
						<div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/approval.png);background-size: contain;"></div>
				        <div class="listbtntext"><%=SystemEnv.getHtmlLabelName(16210,user.getLanguage()) %></div>
					  </div>
					<%}%> 
					<%if("true".equals(showOvmBtn) && currentstatus != 1){%>
						<%--强制归档 --%>
					   <div class="listbtnhandler" onclick="doDrawBack(this);">	
						<div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/approval.png);background-size: contain;"></div>
				        <div class="listbtntext"><%=SystemEnv.getHtmlLabelName(18360,user.getLanguage()) %></div>
					  </div>
					<%}%>
					<%if("true".equals(showRbmBtn)){%>
						<%--强制收回 --%>
						<div class="listbtnhandler" onclick="doRetract(this,'rbm');">	
							<div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/approval.png);background-size: contain;"></div>
							<div class="listbtntext"><%=SystemEnv.getHtmlLabelName(18359,user.getLanguage()) %></div>
						</div>
					<%}%>
					<%if("true".equals(showInterventionBtn) && currentstatus != 1){%>
						<%--流程干预 --%>
						<div class="listbtnhandler" onclick="doConfirmIntervenor(this);">	
						  <div class="listbtnimg"  style="background-image:url(/mobile/plugin/1/images/ganyu.png);background-size: contain;"></div>
				          <div class="listbtntext"><%=SystemEnv.getHtmlLabelName(18913,user.getLanguage()) %></div>
						</div>
					<%}%>
				<%}%>
             <%}%>
			</div>
		</div>
		<input type="hidden" id="onlyforwardButton" value="<%=onlyforwardButton%>" />
		<div class="morebutton" style="display:none"></div>
		<div style="height:8px;"></div>
		<div class="signbtn3 signclearfix">
			<div class="signmenu">
				<div>
				   <div class="signcontent">
					 <div class="signimg"><img src="/mobile/plugin/1/images/feedback_pen_icon.png"></div>
					 <div class="signflag"><%=SystemEnv.getHtmlLabelName(129987,user.getLanguage()) %></div>
					</div>
				  <div class="signbtn">
				  	  <div class="firstButton"></div>
				     <div class="firstImg"><img  src="/mobile/plugin/1/images/firstimg.png"></div> 
				  </div>
				</div>
			</div>
			<div class="signmenubtn">
			</div>
		</div>
	<%}%>
 </form>
</div>
<script type="text/javascript">
var flagHiddenSpeechBtn = false;

jQuery(function(){
<% if(flagServerVersion4_5){ %>
	//仅当 当前访问程序是WebClient而且不是创建流程时候，才对语音附件作隐藏处理。



 	flagHiddenSpeechBtn = <%=(clienttype.equalsIgnoreCase("Webclient") && !"create".equals(method))%>;

 	hiddenSpeechBtn();
<%} %>

	//如果当前表单不可编辑 或者 是非客户端登录方式，需对附件上传类型字段中各附件之后的删除按钮作删除。



	var flagDelAppendix = <%=(!workflowRequestInfo.isCanEdit() || clienttype.equalsIgnoreCase("Webclient"))%>;
	if(flagDelAppendix){
	    var $delAppend = jQuery("a[name='appendixDelField']");
	    $delAppend.each(
		    function(i){
				jQuery(this).remove();
		    })
	}
	
    jQuery("a[name='appendixDelField'][showdelbtn='1']").each(
	    function(i){
			jQuery(this).remove();
	    });
	
	//仅当非客户端登录方式，支持对附件上传字段的编辑操作



	var flagEditAppendix = <%=(clienttype.equalsIgnoreCase("Webclient"))%>;
	if(flagEditAppendix){
		var $editAppend = jQuery("td[name='appendixEditField']");
		$editAppend.each(
		    function(i){
		    	jQuery(this).remove();
		    })
	}
	
<%
if ("create".equals(method)) {
%>
<%  if("1".equals(isBill) && "180".equals(formId)){ %>
	//请假申请单的特殊处理，隐藏剩余年假、带薪病假信息。



	jQuery("select[nameBak='leaveType']").trigger("onchange");
<%  } %>

<%
}
%>

	jQuery('body,html').animate({scrollTop:0},1000);  
	if(clienttype=="android"||clienttype=="androidpad"){
		hiddenSubmitWaitInfo();
	}
	
	//去掉待办中 条件 点击这里连接
	<%if("14".equals(formId)){%>
		removeAdminSystemWfRemarkInfo();
	<%}%>
});

function doConfirmIntervenor(){
	var Intervenorid = jQuery("#Intervenorid").val();
	if(Intervenorid == null || Intervenorid == ""){
		alert("<%=SystemEnv.getHtmlLabelName(125403,user.getLanguage()) %>");
		return;
	}
	//jQuery("input#eh_setoperator").val("y");
	//jQuery("#userSignRemark").val(jQuery("#Intervenorremark").val());
    doIntervenor();
}

function hiddenSpeechBtn(){
	if(flagHiddenSpeechBtn){
		var divSpeechs = document.getElementsByName("divSpeechDisplay");
		if(divSpeechs != null && divSpeechs != undefined){
			for(var i = 0; i< divSpeechs.length; i++){
				divSpeechs[i].style.display = "none";
			}
		}
	}
}

function doStop(obj){
	//您确定要暂停当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26156,user.getLanguage())%>?")){
		//enableAllmenu();
		//document.location.href="/mobile/plugin/1/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=stop&requestid=<%=requestid%>" //xwj for td3665 20060224
		jQuery.ajax({
            url:"/mobile/plugin/1/wfFunctionManageLink.jsp",
            type:"get",
            data:{
                f_weaver_belongto_userid:"<%=userid%>",
                f_weaver_belongto_usertype:"<%=usertype%>",
                flag:"stop",
                requestid:"<%=requestid%>"
            },
            success:function(data){
                goBack();
            }
        });
	}
	else
	{
	//	displayAllmenu();
		return false;
	}
}
function doCancelw(obj){
	//您确定要撤销当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26157,user.getLanguage())%>?")){
		//enableAllmenu();
		//document.location.href="/mobile/plugin/1/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=cancel&requestid=<%=requestid%>" //xwj for td3665 20060224
		jQuery.ajax({
            url:"/mobile/plugin/1/wfFunctionManageLink.jsp",
            type:"get",
            data:{
                f_weaver_belongto_userid:"<%=userid%>",
                f_weaver_belongto_usertype:"<%=usertype%>",
                flag:"cancel",
                requestid:"<%=requestid%>"
            },
            success:function(data){
                goBack();
            }
        });
		goBack();
	}
	else
	{
		//displayAllmenu();
		return false;
	}
}
function doRestart(obj)
{
	//您确定要启用当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26158,user.getLanguage())%>?")){
		//enableAllmenu();
		//document.location.href="/mobile/plugin/1/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=restart&requestid=<%=requestid%>" //xwj for td3665 20060224
		jQuery.ajax({
            url:"/mobile/plugin/1/wfFunctionManageLink.jsp",
            type:"get",
            data:{
                f_weaver_belongto_userid:"<%=userid%>",
                f_weaver_belongto_usertype:"<%=usertype%>",
                flag:"restart",
                requestid:"<%=requestid%>"
            },
            success:function(data){
                goBack();
            }
        });
	}
	else
	{
		//displayAllmenu();
		return false;
	}
}

<%
    String tips = "";
    if(currentstatus==0)
    {
        tips = SystemEnv.getHtmlLabelName(18567,user.getLanguage());//您对该流程已经失去强制收回权限!
    }
%>
function doRetract(obj,type){	 //强制收回
obj.disabled=true;
var tips = '<%=tips%>';
if(tips != ""){
    alert(tips);
    return false;
}
try{
setPageAllButtonDisabled();
var $btnRejectObj = jQuery("#doretract");
$btnRejectObj.attr("loadding", 1);
$btnRejectObj.html(""+SystemEnv.getHtmlNoteName(4641));
}catch(e){}
//enableAllmenu();

//document.location.href="/mobile/plugin/1/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=rb&requestid=<%=requestid%>" //xwj for td3665 20060224
    //您确定要强制回收当前流程吗

    //if(confirm("<%=SystemEnv.getHtmlLabelName(126273,user.getLanguage())%>")){
        jQuery.ajax({
            url:"/mobile/plugin/1/wfFunctionManageLink.jsp",
            type:"get",
            data:{
                f_weaver_belongto_userid:"<%=userid%>",
                f_weaver_belongto_usertype:"<%=usertype%>",
                flag:type,
                requestid:"<%=requestid%>"
            },
            success:function(data){
			  if(type=='rb'){
				if(data.indexOf("infoKey=rbfail")!=-1){
					alert("<%=SystemEnv.getHtmlLabelName(18567,user.getLanguage())%>");
				}
			  }
                goBack();
            }
        });
    //}
}


function doDrawBack(obj){	//强制归档
obj.disabled=true;
//document.location.href="/mobile/plugin/1/wfFunctionManageLink.jsp?flag=ov&requestid=<%=requestid%>" //xwj for td3665 20060224
	jQuery.ajax({
	            url:"/mobile/plugin/1/wfFunctionManageLink.jsp",
	            type:"get",
	            data:{
	                flag:"ovm",
	                requestid:"<%=requestid%>"
	            },
	            success:function(data){
	                goBack();
	            }
	        });
}

function doShowDt(obj){
jQuery(".requestinfo_making").toggle();
jQuery(obj).find(".right").toggleClass("requestIfons_open");
}

function doHideDt(obj){
jQuery(".requestinfo_making").hide();
}


<%if (intervenorright>0){%>	   // 干预
function showIntervenor(obj)
{
	 jQuery("#intervenor").bind("click", function(event) { jQuery(".pageIntervaling").show(); });

}
<%}%>
<%if (isurger){%>

//function doSupervise(obj){		//督办
//	alert("-doSupervise---");
//}
<%}%>



function deleteWorkflowByRequestID(){   //单个删除
	
	if(confirm("<%=SystemEnv.getHtmlLabelName(124824,user.getLanguage())%>")){	 
	var requestid = "<%=requestid%>"+",";
    	jQuery.ajax({
			url:"/mobile/plugin/1/monitor/MonitorOperation.jsp",
			type:"get",
			data:{
				operation:"deleteworkflow",
				multiRequestIds:requestid,
			},
			beforeSend:function(xhr){
				try{
				//	e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84024,user.getLanguage())%>",true);
				}catch(e){}
			},
			complete:function(xhr){
				//e8showAjaxTips("",false);
			},
			success:function(data){
				//window.location="WorkflowMonitorList.jsp?"+data;
				//_xtable_CleanCheckedCheckbox();
				//_table.reLoad();
                goBack();
			}
		});
    }
	
	 //requestid = requestid+",";
     //document.weaver.multiRequestIds.value = requestid;
     //document.weaver.operation.value='deleteworkflow';
     //document.weaver.action='/system/systemmonitor/MonitorOperation.jsp';
     //document.weaver.submit();
}

		//生成系统提醒流程
		function triggerSystemWorkflow(prefix,url,title,loginuserid,type){
			prefix = prefix.replace(/~0~/g,"<span class='importantInfo'>");
			prefix = prefix.replace(/~1~/g,"</span>");
			prefix = prefix.replace(/~2~/g,"<span class='importantDetailInfo'>");
			
			var botfix = "<%=SystemEnv.getHtmlLabelName(126558,user.getLanguage())%>";
			if("<%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%>" == title){
				botfix="<%=SystemEnv.getHtmlLabelName(126556,user.getLanguage())%>";
			}
			var messagedetail =jQuery('#msgsendSystemInfo').html()+'<span>'+prefix + '，<%=SystemEnv.getHtmlLabelName(126554,user.getLanguage())%><a id="wfSErrorResetBtn" style="color:#2b8ae2!important;" href="'+url+'" title="'+title+'" type="'+type+'"> <%=SystemEnv.getHtmlLabelName(126555,user.getLanguage())%> </a>'+botfix+'</span>';
			var ontouchendevent = jQuery('.message-button').attr('ontouchend');
			jQuery('.message-button').css('background-color','#aebdc9');
			jQuery('.message-button').removeAttr('ontouchend');
			jQuery.ajax({
				type:'get',
				url:'TriggerRemindWorkflow.jsp?_'+new Date().getTime()+"=1",
				data:{
					remark:messagedetail,
					loginuserid:loginuserid,
					requestid:'<%=requestid%>'
				},
				error:function (XMLHttpRequest, textStatus, errorThrown) {
			    	jQuery('.message-button').attr('ontouchend',ontouchendevent);
			    	jQuery('.message-button').css('background-color','#017bfd');
				} , 
			    success:function (data, textStatus) {
			    	alert("<%=SystemEnv.getHtmlLabelName(126317,user.getLanguage())%>");
			    }
			});
		}
		
		function opencondition(conditid){
			jQuery('#'+conditid).toggle();
		}
		
		
		function rechoseoperator(){
	    	jQuery('.showWin').show();
			jQuery('.pageMasking').show();
		}

		<% if("y".equals(resetoperator)){%>
			jQuery('.showWin').hide();;
			jQuery('.pageMasking').hide();;
		<%}%>

		
		<%if("y".equals(Util.null2String(request.getParameter("needChooseOperator")))){%>
		    	jQuery('.showWin').show();
				jQuery('.pageMasking').show();
		<%}%>
		
		jQuery(".message-box").live('touchend', function (e) {
			if(jQuery(e.target).is("a:contains('<%=SystemEnv.getHtmlLabelName(126542,user.getLanguage())%>')")){
				e.stopPropagation();
			}else if(jQuery(e.target).is("div[index='conditiondetail']")){
				jQuery(e.target).parent('div').hide();
				e.stopPropagation();
			}else{
				jQuery(".message-detail-condition").hide();
			}
		});
			
		function hiddenSubmitWaitInfo(){
			var url = "emobile:hiddenSubmitWaitInfo";	
			location = url;
		}
		
		function removeAdminSystemWfRemarkInfo(){
	        var msghtml = jQuery(".mainFormRowValueTDDIV span a:contains('<%=SystemEnv.getHtmlLabelName(126555,7)%>')").parent().html();
	        if(msghtml){
		        msghtml = msghtml.replace(/，<%=SystemEnv.getHtmlLabelName(126554,7)%>.*[<%=SystemEnv.getHtmlLabelName(126558,7)%>|<%=SystemEnv.getHtmlLabelName(126556,7)%>]$/g,'');
		        jQuery(".mainFormRowValueTDDIV span a:contains('<%=SystemEnv.getHtmlLabelName(126555,7)%>')").parent().html(msghtml);
	        }
	        jQuery(".mainFormRowValueTDDIV a:contains('<%=SystemEnv.getHtmlLabelName(126542,7)%>')").replaceWith('<%=SystemEnv.getHtmlLabelName(126542,7)%>');
	    
	    
	        msghtml = jQuery(".mainFormRowValueTDDIV span a:contains('<%=SystemEnv.getHtmlLabelName(126555,8)%>')").parent().html();
	        if(msghtml){
		        msghtml = msghtml.replace(/，<%=SystemEnv.getHtmlLabelName(126554,8)%>.*[<%=SystemEnv.getHtmlLabelName(126558,8)%>|<%=SystemEnv.getHtmlLabelName(126556,8)%>]$/g,'');
		        jQuery(".mainFormRowValueTDDIV span a:contains('<%=SystemEnv.getHtmlLabelName(126555,8)%>')").parent().html(msghtml);
	        }
	        jQuery(".mainFormRowValueTDDIV a:contains('<%=SystemEnv.getHtmlLabelName(126542,8)%>')").replaceWith('<%=SystemEnv.getHtmlLabelName(126542,8)%>');
	    
	    
	        msghtml = jQuery(".mainFormRowValueTDDIV span a:contains('<%=SystemEnv.getHtmlLabelName(126555,9)%>')").parent().html();
	        if(msghtml){
	        	msghtml = msghtml.replace(/，<%=SystemEnv.getHtmlLabelName(126554,9)%>.*[<%=SystemEnv.getHtmlLabelName(126558,9)%>|<%=SystemEnv.getHtmlLabelName(126556,9)%>]$/g,'');
		        jQuery(".mainFormRowValueTDDIV span a:contains('<%=SystemEnv.getHtmlLabelName(126555,9)%>')").parent().html(msghtml);
	        }
	        jQuery(".mainFormRowValueTDDIV a:contains('<%=SystemEnv.getHtmlLabelName(126542,9)%>')").replaceWith('<%=SystemEnv.getHtmlLabelName(126542,9)%>');
		}
			
//function deleteWorkflow(obj){	 //批量删除
   // if(_xtable_CheckedCheckboxId()!=""){
        //if(isdel()) {
        //    obj.disabled=true;
        //    document.weaver.multiRequestIds.value = _xtable_CheckedCheckboxId();
        //    document.weaver.operation.value='deleteworkflow';
       //     document.weaver.action='/system/systemmonitor/MonitorOperation.jsp';
       //     document.weaver.submit();
       // }
        
   /*     top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
        	jQuery.ajax({
				url:"/system/systemmonitor/MonitorOperation.jsp",
				type:"post",
				data:{
					operation:"deleteworkflow",
					multiRequestIds:_xtable_CheckedCheckboxId(),
				},
				beforeSend:function(xhr){
					try{
						e8showAjaxTips("正在删除数据，请稍候...",true);
					}catch(e){}
				},
				complete:function(xhr){
					e8showAjaxTips("",false);
				},
				success:function(data){
					//window.location="WorkflowMonitorList.jsp?"+data;
					_xtable_CleanCheckedCheckbox();
					_table.reLoad();
				}
			});
        }, function () {}, 320, 90,true);
        
	}else{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    }
}	 */



</script>

<%
RecordSet rs_cus = new RecordSet();
String custompage4Emoble = "";
rs_cus.executeSql("select custompage4Emoble from workflow_base where id = "+Util.getIntValue(workflowid));
if(rs_cus.next()){
	custompage4Emoble = Util.null2String(rs_cus.getString("custompage4Emoble")).trim();
}
%>
<%
if(!"".equals(custompage4Emoble)){
%> 
<jsp:include page="<%=custompage4Emoble%>" flush="true">
	<jsp:param name="workflowid" value="<%=workflowid%>" />
	<jsp:param name="nodeid" value="<%=nodeId%>" />
	<jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="userid" value="<%=userid%>" />
	<jsp:param name="languageid" value="<%=user.getLanguage()%>" />
	<jsp:param name="module" value="<%=module%>" />
</jsp:include>
<%
}

%>
<div id="szsyjfsbg"></div>
<div id="szsyjfsshow"></div>
<input type="hidden" id="showcardhidden"   value=""/>
</body>
</html>