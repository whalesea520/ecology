<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@page import="org.json.JSONObject"%>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="weaver.general.* "%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.mobile.plugin.ecology.RequestOperation"%>
<%@ page import="weaver.mobile.webservices.workflow.*" %>
<%@ page import="weaver.workflow.request.WFPathUtil" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.formmode.ThreadLocalUser"%>  
<%@page import="weaver.mobile.webservices.common.HtmlUtil"%>
<%@page import="weaver.workflow.request.WorkflowSpeechAppend"%>
<%@page import="weaver.mobile.webservices.common.FIFOLinkedHashMap"%>
<%@page import="weaver.mobile.webservices.workflow.soa.RequestPreProcessing"%>
<%@page import="weaver.workflow.monitor.MonitorDTO"%>
<%@page import="weaver.workflow.request.WorkflowRequestMessage" %>
<%@page import="org.apache.ws.commons.util.Base64" %>
<%@page import="weaver.file.Prop" %>

<%@ page import="weaver.workflow.html.FieldAttrManager" %>


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
RecordSet rsFna = new RecordSet();

//request message info start
String messageid = Util.null2String(request.getParameter("messageid"));
String resetoperator = "";
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
String strIsPreLoad = Util.null2String(request.getParameter("isPreLoad"));
String clientosver = Util.null2String(request.getParameter("clientosver"));
String ismonitor = Util.null2String(request.getParameter("ismonitor"));
String changemode = Util.null2String(request.getParameter("changemode"));
String isdefaultmode="".equals(changemode)?"1":"0";

//根据版本控制显示手机端的签字意见还是服务端的签字意见
int hideWfSignuture = Util.getIntValue(Prop.getPropValue("Mobile","hideWfSignuture"),0);
boolean flagServerVersion6_0 = false;
if(hideWfSignuture==1){
	  flagServerVersion6_0 = true;
}



if("".equals(ismonitor) && module.equals("-1005")){
    ismonitor = "1";
}
int isurge1 = Util.getIntValue(request.getParameter("isurge"));
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
String isModifyLog = "";        //是否记录表单日志 by cyril on 2008-07-09 for TD:8835





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
boolean haveStopright = false;          //暂停权限
boolean haveCancelright = false;        //撤销权限
boolean haveRestartright = false;       //启用权限
boolean haveOverright=false;            //强制归档权限
int intervenorright = 0;   //流程干预





//2015/11/30 获取次账号信息 start
//User user = HrmUserVarify.getUser (request , response) ;

String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));//需要增加的代码


String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));//需要增加的代码
User user  = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码


String messagecontent = Util.null2String(session.getAttribute("msgcontent_"+user.getUID()+"_"+detailid));

//2015/11/30 获取次账号信息 End

if(user == null)  return ;
ThreadLocalUser.setUser(user);
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;
char flag=Util.getSeparator() ;
int userid=user.getUID();


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
boolean isPreLoad = false;


String wfsvid = Util.null2String(request.getParameter("wfsvid"));

//是否通过群组分享查看
//分享人




//分享群组
Map<String, Object> otherinfo = new HashMap<String, Object>();
otherinfo.put("isfromchatshare", request.getParameter("isfromchatshare"));
otherinfo.put("sharer", request.getParameter("sharer"));
otherinfo.put("sharertype", "0");
otherinfo.put("sharegroupid", request.getParameter("sharegroupid"));

int requestid = 0;
String userSignRemark = "";
String forwardresourceids = "";
String clientip = "";
WorkflowRequestInfo workflowRequestInfo = null;
String workflowHtmlShow = "";
String fromWF = "";
HttpServletRequest req = request;

requestid = Util.getIntValue(req.getParameter("requestid"), -1);
if (requestid == -1) {
    requestid = Util.getIntValue(detailid);
}

String method = Util.null2String(request.getParameter("method"));
//如果method值为空，且requestId值为0或-1则为创建流程
if("".equals(method) && requestid <= 0){
    method = "create";
    type = "create";
}

int fromRequestid = Util.getIntValue(req.getParameter("fromRequestid"), 0);
String sessionkey = Util.null2String(request.getParameter("sessionkey"));
boolean isPreProcessing = (1 == Util.getIntValue(request.getParameter("isPreProc")));

if(StringUtils.isNotBlank(detailid) && !isPreProcessing){
    File file = new File(RequestPreProcessing.getSystemFilePath()+"/cachefile/"+detailid+"/"+user.getUID()+".html");
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



otherinfo.put("ismonitor", ismonitor);
otherinfo.put("isurger", isurge);
//应155683要求，添加module属性

otherinfo.put("module", module);

WorkflowService workflowWebService = new WorkflowServiceImpl();
WorkflowServiceUtil workflowServiceUtil = new WorkflowServiceUtil();
boolean iscanedit = workflowServiceUtil.iscanEdit(userid,requestid);
String wfReqInfoKey = "";

int intModule = 0;
try{
    intModule = Integer.valueOf(module);
}catch(Exception e){
    
}
String mobilechangemode="";
String mobilemode="";
String mobileapplyworkflow="";
String mobileapplyworkflowids="";
if("".equals(changemode)&&(requestid>0||requestid==-1)){
	rsFna.executeSql("select mobilechangemode,mobilemode,mobileapplyworkflow,mobileapplyworkflowids from SystemSet ");
	if(rsFna.next()) {
		mobilechangemode = Util.null2String(rsFna.getString("mobilechangemode"));
		if("1".equals(mobilechangemode)){
			mobilemode = Util.null2String(rsFna.getString("mobilemode"));
			mobileapplyworkflow = Util.null2String(rsFna.getString("mobileapplyworkflow"));
			if("1".equals(mobileapplyworkflow)){//选择
				mobileapplyworkflowids= Util.null2String(rsFna.getString("mobileapplyworkflowids"));
			   if("".equals(workflowid)){
				    rsFna.executeSql(" select workflowid from workflow_requestbase where requestid='"+requestid+"'");
				    if(rsFna.next()){
				    	workflowid=Util.null2String(rsFna.getString("workflowid"));
				    }
			   }
				if((","+mobileapplyworkflowids+",").indexOf((","+workflowid+","))!=-1){
					changemode =mobilemode;
				}
			}else if("2".equals(mobileapplyworkflow)){ //排除选择
				mobileapplyworkflowids= Util.null2String(rsFna.getString("mobileapplyworkflowids"));
				if("".equals(workflowid)){
				    rsFna.executeSql(" select workflowid from workflow_requestbase where requestid='"+requestid+"'");
				    if(rsFna.next()){
				    	workflowid=Util.null2String(rsFna.getString("workflowid"));
				    }
			   }
				if((","+mobileapplyworkflowids+",").indexOf((","+workflowid+","))==-1){
					changemode =mobilemode;
				}
			}
			if("0".equals(mobileapplyworkflow)){
				changemode =mobilemode;
			}
		}
	} 
}


if ("create".equals(method)) {
    workflowRequestInfo = workflowWebService.getCreateWorkflowRequestInfo(Util.getIntValue(workflowid), userid,changemode);
    wfReqInfoKey = sessionkey + "_"+ workflowRequestInfo.getWorkflowBaseInfo().getWorkflowId() + "_"+ userid;
} else {
    //判断是否监控、督办
    otherinfo.put("changemode",changemode);
    if(module!= null && intModule < 0){
        workflowRequestInfo = workflowWebService.getWorkflowRequest4split(requestid, userid, fromRequestid, 5, false, otherinfo);
        //监控和督办的时候，表单内容不可编辑
        if(workflowRequestInfo != null){
            workflowRequestInfo.setCanEdit(false);
            iscanedit = false;
        }
    }
    //通过预处理加载



    if (isPreProcessing && !"".equals(wfsvid)) {
        workflowRequestInfo = RequestPreProcessing.getWorkflowService(request, user, requestid, wfsvid);
    }
    
    if (workflowRequestInfo == null) {
        workflowRequestInfo = workflowWebService.getWorkflowRequest4split(requestid, userid, fromRequestid, 5, isPreLoad, otherinfo);
        //监控和督办的时候，表单内容不可编辑
        if(module!= null && intModule < 0){
            workflowRequestInfo.setCanEdit(false);
        }
    }
    if(!isPreLoad && !isPreProcessing){
        //更新新到流程为已查看状态。





        workflowWebService.writeWorkflowReadFlag(String.valueOf(requestid), String.valueOf(userid), workflowRequestInfo.getIsremark());
        //key格式: 会话ID_流程ID_请求ID_用户ID
        wfReqInfoKey = sessionkey + "_" + workflowRequestInfo.getWorkflowBaseInfo().getWorkflowId() + "_" + requestid + "_"+ userid;
    }
}

//放入缓存
if (workflowRequestInfo != null && !"".equals(wfReqInfoKey)) {
    StaticObj staticObj = StaticObj.getInstance();
    synchronized(staticObj){
        Map mapWfReqInfos = (Map)staticObj.getObject("MOBILE_WORKFLOWREQUESTINFO_CACHE");
        if(mapWfReqInfos == null){
            mapWfReqInfos = new FIFOLinkedHashMap(1000);
            staticObj.putObject("MOBILE_WORKFLOWREQUESTINFO_CACHE", mapWfReqInfos); 
        }
        mapWfReqInfos.put(wfReqInfoKey, workflowRequestInfo);
    }
}

if(workflowRequestInfo==null){
    %>
    <script language="JavaScript">
        var tips = '<%=SystemEnv.getHtmlLabelName(126572,user.getLanguage())%>';
        if(tips!="")
        {
        	alert(tips);
            window.location.href="/mobile/plugin/1/clientSuccess.jsp";
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
    return;
    //没有权限
}
canview = workflowRequestInfo.isCanView();
if(!workflowRequestInfo.isCanView() && intModule != -1004 && intModule != -1005) {
    //没有权限
    %>
	<script language="JavaScript">
        var tips = '<%=SystemEnv.getHtmlLabelName(126572,user.getLanguage()) %>';
        if(tips!="")
        {
        	alert(tips);
            window.location.href="/mobile/plugin/1/clientSuccess.jsp";
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
    return;
}
//流程已流转到下一节点
if((WorkflowRequestMessage.WF_REQUEST_ERROR_CODE_02).equals(messageid)){
   %>
   	<script language="JavaScript">
        var tips = '<%=SystemEnv.getHtmlLabelNames(WorkflowRequestMessage.WF_REQUEST_ERROR_CODE_02,user.getLanguage()) %>';
        if(tips!="")
        {
        	alert(tips);
            window.location.href="/mobile/plugin/1/clientSuccess.jsp";
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
}
if(workflowRequestInfo.getWorkflowHtmlShow()!=null){
    workflowHtmlShow = StringUtils.defaultIfEmpty(workflowRequestInfo.getWorkflowHtmlShow()[0],"");
} else {
    workflowHtmlShow = "";
}
workflowid = workflowRequestInfo.getWorkflowBaseInfo().getWorkflowId();
boolean isvalid = workflowServiceUtil.isValid(""+workflowid);
if(!isvalid){
    %>
    <script language="JavaScript">
        var tips = '<%=SystemEnv.getHtmlLabelName(126572,user.getLanguage())%>';
        if(tips!="")
        {
        	alert(tips);
            window.location.href="/mobile/plugin/1/clientSuccess.jsp";
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
    return;
    //没有权限
}

int[] annexDocCategory = weaver.workflow.workflow.WorkflowComInfo.getAnnexDocCategory(workflowid);
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
if(!nodeid2.equals(nodeId)&&!"".equals(nodeid2)){
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
boolean flagForwardReceiveDef = "1".equals(workflowRequestInfo.getWorkflowBaseInfo().getIsForwardReceiveDef());

int userLanguage = user.getLanguage();
userLanguage = (userLanguage == 0) ? 7:userLanguage;

//workflowWebService.setLanguageid(userLanguage);

//new weaver.general.BaseBean().writeLog("-get-156->>>>"+workflowWebService.getLanguageid());
/*Map bean = new HashMap<String,String>();
bean.put(languageid,userLanguage);
private static ThreadLocal wsiConn = new ThreadLocal();
wsiConn.set(bean);  */                                                      

String request_fieldShowValue = "";
String request_fieldShowIndex = "";
boolean hasOperation = (workflowRequestInfo.getSubmitButtonName() != null && !workflowRequestInfo.getSubmitButtonName().equals(""))
    ||(workflowRequestInfo.getSubnobackButtonName()!=null&&!workflowRequestInfo.getSubnobackButtonName().equals(""))
    ||(workflowRequestInfo.getSubbackButtonName()!=null&&!workflowRequestInfo.getSubbackButtonName().equals(""))
    ||(workflowRequestInfo.getForwardButtonName()!=null&&!workflowRequestInfo.getForwardButtonName().equals("")
    ||(workflowRequestInfo.getGivingOpinionsbackName()!=null&&!workflowRequestInfo.getGivingOpinionsbackName().equals(""))
    ||(workflowRequestInfo.getGivingOpinionsnobackName()!=null&&!workflowRequestInfo.getGivingOpinionsnobackName().equals(""))
    ||(workflowRequestInfo.getGivingopinionsName()!=null&&!workflowRequestInfo.getGivingopinionsName().equals(""))
	||(workflowRequestInfo.getRetractbackButtonName()!=null&&!workflowRequestInfo.getRetractbackButtonName().equals(""))
	||(workflowRequestInfo.getSaveButtonName() != null && !workflowRequestInfo.getSaveButtonName().equals("")));
//自由流程相关信息
weaver.workflow.request.WorkflowIsFreeStartNode stnode=new weaver.workflow.request.WorkflowIsFreeStartNode();
String nodeidss= stnode.getIsFreeStartNode(""+nodeId);
String freedis=stnode.getNodeid(nodeidss);
String isornotFree=stnode.isornotFree(""+nodeId);
//判断是不是创建保存


//如果是系统表单，签字意见中不能添加位置

boolean isSystemBill = false;
if(isBill.equals("1") && !formId.equals("") && Integer.parseInt(formId)>0){
    isSystemBill = true;
}

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
boolean isfreeshow = false;
if(IsFreeWorkflow){
    if(requestid <= 0 || (currentNodeType.equals("0") && workflowRequestInfo.getIsremark() == 0)){
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
  //  intervenorright=0;     //?
   //isurger=false;
//}



int isremark = workflowRequestInfo.getIsremark();
int takisremark = Util.getIntValue(workflowRequestInfo.getTakisremark()+"",0);
int preisremark=-1;//如果是流程参与人，该值会被赋予正确的值，在初始化时先设为错误值，以解决主流程参与人查看子流程时权限判断问题。TD10126
prs = new RecordSet();
prs.executeSql("select isremark,isreminded,preisremark,id,groupdetailid,nodeid,takisremark,(CASE WHEN isremark=9 THEN '7.5' ELSE isremark END) orderisremark from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by orderisremark,id ");
boolean istoManagePage=false;   //add by xhheng @20041217 for TD 1438
while(prs.next())   {
    preisremark=Util.getIntValue(prs.getString("preisremark"),0) ;   
}


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

//签字意见添加位置  
int isRemarkLocation = 1;
/*if(!workflowid.equals("")){
    rsFna.executeSql("select isRemarkLocation from workflow_flownode where workflowid=" + workflowid +"and nodeId=" + nodeId);
    if(rsFna.next()){
        isRemarkLocation  = Util.getIntValue(rsFna.getString("isRemarkLocation"),0); 
    }
}*/
//是否包含位置字段
boolean includeLocation =  GPSLocationUtil.isInclude(isBill,formId);
if(currentstatus>-1)
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
            window.location.href="/mobile/plugin/1/clientSuccess.jsp";
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
    return ;
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
String borderWidth = "android".equals(clienttype)||"androidpad".equals(clienttype)||"Webclient".equals(clienttype)?"1px":"0.5px";
if(!"".equals(detailcardshow)&&(","+detailcardshow+",").indexOf(","+workflowid+",")!=-1){
	   detailcardshow = "1";
}else{
     detailcardshow = "";
}
%>
<html>
     <style type="text/css">
        .operatormessage {
		    border-top: #ccc solid <%=borderWidth%>;
		    border-left: #ccc solid <%=borderWidth%>;
		    border-right: #ccc solid <%=borderWidth%>;
        }
        .requestIfons {
            border-bottom: #cdd2d8 solid <%=borderWidth%>;
        }
        <%
        if("android".equals(clienttype)||"androidpad".equals(clienttype)||"Webclient".equals(clienttype)){
        %>
        .message_before {
            /*content: "\00a0";
            width: 0px;
            height: 0px;
            border-width: 8px 8px 8px 0;
            border-radius: 2px;
            border-style: solid;
            border-color: transparent #fff transparent transparent;
            top: 8px;
            */
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
        <%
        }else{
        %>
        
		.operatormessage:before {
		    position: absolute;
		    content: "\00a0";
		    width: 0px;
		    height: 0px;
		    border-width: 8px 8px 8px 0;
		    border-style: solid;
		    border-color: transparent #d9d9d9 transparent transparent;
		    border-radius: 2px;
		    top: 8px;
		    left: -8px;
		}
		
		.message_before {
		    position: absolute;
		    content: "\00a0";
		    width: 0px;
		    height: 0px;
		    border-width: 8px 8px 8px 0;
		    border-radius: 2px;
		    border-style: solid;
		    border-color: transparent #fff transparent transparent;
		    top: 8px;
		    left: -7px;
		}

        <%
        }
        %>
    </style>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="author" content="Weaver E-Mobile Dev Group" />
    <meta name="description" content="Weaver E-mobile" />
    <meta name="keywords" content="weaver,e-mobile" />
    <%
	 boolean ismobilehtml=weaver.mobile.webservices.workflow.WorkflowServiceUtil.isMobileParseExcelMode(workflowid+"",nodeId+"",changemode);
	  if(!"1".equals(detailcardshow)){%>
		<%
		if(ismobilehtml){
			flagServerVersion6_0 = true;
		 %>
		   <meta name="viewport" content="width=device-width, initial-scale=0.45,maximum-scale=5.0, minimum-scale=0.1" />
		<%}else{%>
		  <meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=5.0, minimum-scale=0.1" /> 
			<%}%>
	<%}else{%>
	     <meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0" /> 
	<%}%>
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
        <link rel="stylesheet" href="/mobile/plugin/1/css/r5_wev8.css" type="text/css">
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
    
    var f_weaver_belongto_userid = '<%=f_weaver_belongto_userid%>';
    var f_weaver_belongto_usertype = '<%=f_weaver_belongto_usertype%>';
    var chromeOnPropListener = null;
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
    //获取此请求是否可以操作




    function hasOperation() {
        return true;
    }
    /*
     * 是否可以分享
     */ 
    function getCanShare() {
        return "<%=workflowRequestInfo.getIsremark() >= 0 && intModule != -1004 && intModule != -1005%>";
    }
    function getCanChangePage(){
        return <%=canview? "" : "error"%>;
    }
    //获取所有操作按钮




    function getOperationList() {
        <%

        //获取操作权限
        //判断权限
        String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
        if("".equals(CurrentUser)){
            CurrentUser = String.valueOf(user.getUID());
        }
		Map<String,String> rightMap = new HashMap<String,String>();
		if("-1005".equals(module)){
			rightMap = Monitor.getWorkflowRight(request,user,CurrentUser,requestid);
		}
        int operatorType = -1;
        //
        StringBuffer operationJson = new StringBuffer();
        operationJson = new StringBuffer("{");
        if(!("-1005".equals(module) || "-1004".equals(module))){
        	int isBack = 0; // 标识默认的提交按钮

            operationJson.append("\\\"operations\\\" : [");
	        if (workflowRequestInfo.getSubmitButtonName() != null && !workflowRequestInfo.getSubmitButtonName().equals("")) {
				isBack = 1;
	            operatorType = 0;
	            //if (workflowRequestInfo.getRejectButtonName()!=null&&!workflowRequestInfo.getRejectButtonName().equals("")) {
	            //  operatorType = 0;
	            //}
	            
	            operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getSubmitButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doSubmit_4Mobile(this,1)\\\"},");
	        }
	        if (workflowRequestInfo.getSubnobackButtonName()!=null&&!workflowRequestInfo.getSubnobackButtonName().equals("")) {
				if(isBack != 1) {
					isBack = 2;
				}
	            operatorType = 2;
	            operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getSubnobackButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doSubmit_4Mobile(this,2)\\\"},");
	        }
	        if (workflowRequestInfo.getSubbackButtonName()!=null&&!workflowRequestInfo.getSubbackButtonName().equals("")) { 
				if(isBack != 1) {
					isBack = 3;
				}
	            operatorType = 3;
	            operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getSubbackButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doSubmit_4Mobile(this,3)\\\"},");
	        }
			 if (workflowRequestInfo.getSaveButtonName() != null && !workflowRequestInfo.getSaveButtonName().equals("")) {
				operatorType = 11;
				operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getSaveButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doSave_4Mobile(1)\\\"},");
            }
	        if(workflowRequestInfo.getSubmitDirectName() != null && !workflowRequestInfo.getSubmitDirectName().equals("")) {
				operatorType = 5;
				operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getSubmitDirectName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doSubmitDirect_4Mobile(" + isBack + ")\\\"},");
			}
	        if (workflowRequestInfo.getRejectButtonName()!=null&&!workflowRequestInfo.getRejectButtonName().equals("")) { 
	            if(!"".equals(isornotFree)){
	               if(isreject.equals("1")){
	                 operatorType = 1;
	                 operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getRejectButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"dorejectIsfree()\\\"},");
	               }
	            }else{
	                 operatorType = 1;
	                 operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getRejectButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doreject()\\\"},");
	            }
	        }else{
	            if(isreject.equals("1")){
	                if(iscanedit){
	                    operatorType = 1;
	                    operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getRejectButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"dorejectIsfree()\\\"},");
	                }
	            }
	        }
			if (workflowRequestInfo.getRetractbackButtonName()!=null&&!workflowRequestInfo.getRetractbackButtonName().equals("")) { 
			  operatorType = 5;
			  operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getRetractbackButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doRetract('','rb')\\\"},");
		   }
	        if (workflowRequestInfo.getForwardButtonName()!=null&&!workflowRequestInfo.getForwardButtonName().equals("")) { 
	            operatorType = 4;
	            operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getForwardButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doforward()\\\",\\\"forwardoperationkey\\\":\\\"forwardoperation\\\"},");
	            
	        }
	        if (workflowRequestInfo.getTakingOpsButtonName()!=null&&!workflowRequestInfo.getTakingOpsButtonName().equals("")) { 
	            operatorType = 0;
	            operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getTakingOpsButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doforward2()\\\",\\\"forwardoperationkey\\\":\\\"forwardoperation2\\\"},");
	            
	        }
	        if (workflowRequestInfo.getHandleForwardButtonName()!=null&&!workflowRequestInfo.getHandleForwardButtonName().equals("")) { 
	            operatorType = 0;
	            operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getHandleForwardButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doforward3()\\\",\\\"forwardoperationkey\\\":\\\"forwardoperation3\\\"},");
	            
	        }
	            if (workflowRequestInfo.getForhandbackButtonName()!=null&&!workflowRequestInfo.getForhandbackButtonName().equals("")) { 
	            operatorType = 2;
	            operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getForhandbackButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doforward3()\\\",\\\"forwardoperationkey\\\":\\\"forwardoperation4\\\"},");
	            
	        }
	            if (workflowRequestInfo.getForhandnobackButtonName()!=null&&!workflowRequestInfo.getForhandnobackButtonName().equals("")) { 
	            operatorType = 3;
	            operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getForhandnobackButtonName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doforward3()\\\",\\\"forwardoperationkey\\\":\\\"forwardoperation5\\\"},");
	            
	        }
	        if (workflowRequestInfo.getGivingopinionsName() != null && !workflowRequestInfo.getGivingopinionsName().equals("")) {
	            
	            operatorType = 0;
	            //if (workflowRequestInfo.getRejectButtonName()!=null&&!workflowRequestInfo.getRejectButtonName().equals("")) {
	            //  operatorType = 0;
	            //}
	            
	            operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getGivingopinionsName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doSubmit_4Mobile(this,1)\\\"},");
	        }
	        if (workflowRequestInfo.getGivingOpinionsnobackName()!=null&&!workflowRequestInfo.getGivingOpinionsnobackName().equals("")) {
	            operatorType = 2;
	            operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getGivingOpinionsnobackName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doSubmit_4Mobile(this,2)\\\"},");
	        }
	        if (workflowRequestInfo.getGivingOpinionsbackName()!=null&&!workflowRequestInfo.getGivingOpinionsbackName().equals("")) { 
	            operatorType = 3;
	            operationJson.append("{\\\"name\\\": \\\"").append(workflowRequestInfo.getGivingOpinionsbackName()).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doSubmit_4Mobile(this,3)\\\"},");
	        }
            if(operationJson.toString().endsWith(","))
                operationJson.delete(operationJson.length()-1, operationJson.length());
            operationJson.append("]");
	        if (workflowRequestInfo.getForwardButtonName()!=null&&!workflowRequestInfo.getForwardButtonName().equals("")) {   //转发提交
	            operationJson.append(",\\\"forwardoperation\\\" :"); 
	            operationJson.append("[{\\\"isFromFord\\\":\\\"true\\\",").append("\\\"name\\\": \\\"").append(workflowRequestInfo.getForwardButtonName()).append("\\\", \\\"type\\\":\\\"6\\\"").append(",\\\"callbackFunction1\\\":\\\"forwardresourceids\\\"").append(",\\\"callbackFunction2\\\":\\\"forwardresources\\\"").append(", \\\"callback\\\":\\\"doforward()\\\"}]");
	        }
	         if (workflowRequestInfo.getTakingOpsButtonName()!=null&&!workflowRequestInfo.getTakingOpsButtonName().equals("")) { 
	            operationJson.append(",\\\"forwardoperation2\\\" :"); 
	            operationJson.append("[{\\\"isFromFord\\\":\\\"true\\\",").append("\\\"name\\\": \\\"").append(workflowRequestInfo.getGivingopinionsName()).append("\\\", \\\"type\\\":\\\"6\\\"").append(",\\\"callbackFunction1\\\":\\\"forwardresourceids2\\\"").append(",\\\"callbackFunction2\\\":\\\"forwardresources2\\\"").append(", \\\"callback\\\":\\\"doforward2()\\\"}]");
	        }
	         if (workflowRequestInfo.getHandleForwardButtonName()!=null&&!workflowRequestInfo.getHandleForwardButtonName().equals("")) { 
	            operationJson.append(",\\\"forwardoperation3\\\" :"); 
	            operationJson.append("[{\\\"isFromFord\\\":\\\"true\\\",").append("\\\"name\\\": \\\"").append(workflowRequestInfo.getHandleForwardButtonName()).append("\\\", \\\"type\\\":\\\"6\\\"").append(",\\\"callbackFunction1\\\":\\\"forwardresourceids3\\\"").append(",\\\"callbackFunction2\\\":\\\"forwardresources3\\\"").append(", \\\"callback\\\":\\\"doforward3()\\\"}]");
	        }
	         if (workflowRequestInfo.getForhandbackButtonName()!=null&&!workflowRequestInfo.getForhandbackButtonName().equals("")) { 
	            operationJson.append(",\\\"forwardoperation4\\\" :"); 
	            operationJson.append("[{\\\"isFromFord\\\":\\\"true\\\",").append("\\\"name\\\": \\\"").append(workflowRequestInfo.getForhandbackButtonName()).append("\\\", \\\"type\\\":\\\"6\\\"").append(",\\\"callbackFunction1\\\":\\\"forwardresourceids3\\\"").append(",\\\"callbackFunction2\\\":\\\"forwardresources3\\\"").append(", \\\"callback\\\":\\\"doforward3()\\\"}]");
	        }
	         if (workflowRequestInfo.getForhandnobackButtonName()!=null&&!workflowRequestInfo.getForhandnobackButtonName().equals("")) { 
	            operationJson.append(",\\\"forwardoperation5\\\" :"); 
	            operationJson.append("[{\\\"isFromFord\\\":\\\"true\\\",").append("\\\"name\\\": \\\"").append(workflowRequestInfo.getForhandnobackButtonName()).append("\\\", \\\"type\\\":\\\"6\\\"").append(",\\\"callbackFunction1\\\":\\\"forwardresourceids3\\\"").append(",\\\"callbackFunction2\\\":\\\"forwardresources3\\\"").append(", \\\"callback\\\":\\\"doforward3()\\\"}]");
	        }
        }

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
      //流程干预按钮
      String showInterventionBtn = rightMap.get("showInterventionBtn");

        if(module.equals("-1005")){
	         operationJson.append(",\\\"Monitoroperation\\\" :["); 
	         if ("true".equals(showDeleteBtn)) {
	            operatorType = 10; //删除
	            operationJson.append("{\\\"name\\\": \\\"").append(SystemEnv.getHtmlLabelName(126371,user.getLanguage())).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"deleteWorkflowByRequestID()\\\"},");
	         }
	          if ("true".equals(showStopBtn)) {
	            operatorType = 11; //暂停
	            operationJson.append("{\\\"name\\\": \\\"").append(SystemEnv.getHtmlLabelName(20387,user.getLanguage())).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doStop()\\\"},");
	        }else if ("true".equals(showRestartBtn)) {
	            operatorType = 12; //启用
	            operationJson.append("{\\\"name\\\": \\\"").append(SystemEnv.getHtmlLabelName(26472,user.getLanguage())).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doRestart()\\\"},");
	        } 
	        if ("true".equals(showCancelBtn)) {
	            operatorType = 13; //撤销
	            operationJson.append("{\\\"name\\\": \\\"").append(SystemEnv.getHtmlLabelName(16210,user.getLanguage())).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doCancelw()\\\"},");
	        }
	        if ("true".equals(showOvmBtn) && currentstatus != 1) {
	            operatorType = 14; //强制归档
	            operationJson.append("{\\\"name\\\": \\\"").append(SystemEnv.getHtmlLabelName(18360,user.getLanguage())).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doDrawBack()\\\"},");
	        }
	        if ("true".equals(showRbmBtn)) {
	            operatorType = 15; //强制收回
	            operationJson.append("{\\\"name\\\": \\\"").append(SystemEnv.getHtmlLabelName(18359,user.getLanguage())).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doRetract('','rbm')\\\"},");
	        }
	        if(operationJson.toString().endsWith(","))
	            operationJson.delete(operationJson.length()-1, operationJson.length());
	        operationJson.append("]");
        }
        operationJson.append(",\\\"Urgeoperation\\\" :["); 
    
        if ("-1004".equals(module)) {
            operatorType = 16; //督办
            operationJson.append("{\\\"name\\\": \\\"").append(SystemEnv.getHtmlLabelName(126515,user.getLanguage())).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doSuperviseTemp()\\\"},");
        }else if ("true".equals(showInterventionBtn) && currentstatus != 1 && "-1005".equals(module)) {
            operatorType = 17; //干预
            operationJson.append("{\\\"name\\\": \\\"").append(SystemEnv.getHtmlLabelName(18913,user.getLanguage())).append("\\\", \\\"type\\\":\\\"" + operatorType).append("\\\", \\\"callback\\\":\\\"doConfirmIntervenor()\\\"},");
        } 
        if(operationJson.toString().endsWith(","))
            operationJson.delete(operationJson.length()-1, operationJson.length());

        if(operationJson.toString().startsWith("{,")) operationJson.delete(1, 2);
        operationJson.append("]");

        operationJson.append("}");
        %>
        return "<%=operationJson.toString() %>";
    }
    
    <%
	//没有开启可查看表单内容的权限时，流程图流程状态不允许查看

if(!canview){
String viewRight = rightMap.get("viewRight");
canview = "true".equals(viewRight) || method.equals("create") || "-1005".equals(module);
}
    if (!"create".equals(method) && canview && flagServerVersion6_0) {
    %>
    //是否显示改造后的签字意见
    var showClientRemark = true;
    <%
    }
    %>
    $(document).ready(function () { 
        var nativeUrl = "emobile:PageFinishLoad:" + <%=(isPreProcessing && !"".equals(wfsvid)) ? "1" : "0" %>;
        location = nativeUrl; 
	//加上文档资源监控。
	var attacheUrl = "emobile:attachmentsReadyMessage:";
	 setTimeout(function(){
		location = attacheUrl; 	//避免冲掉emobile:PageFinishLoad
	 }, 1000);
	
        if($('.scroller_date'))
        $('.scroller_date').attr("readonly","readonly");
        if($('.scroller_time'))
        $('.scroller_time').attr("readonly","readonly");
        <%if(includeLocation){%>
            setTimeout("autoLocate()", 1000); //避免冲掉emobile:PageFinishLoad
        <%}%>
        
        <%
        if (!"create".equals(method) && canview && flagServerVersion6_0) {
            %>
                //加载签字意见
                var data ;
                var Resourcedata;
                //TODO
                try{
                    isfirst = true;
                   remarksignloadClinet();
                }catch(e){}
                try{
                //获取签字意见附带的文档和附件
                   getWorkflowResource();  
                }catch(e){}
            <%
        }
        %>
        try{
           setRedflag();
        }catch(e){}
        try{
           initFormPage();
        }catch(e){}
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
    
    function getTrack(fieldid){
        //弹出位置轨迹的窗口


        window.location.href="/mobile/plugin/1/showLocationTrack.jsp?title=<%=SystemEnv.getHtmlLabelName(22981,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(126093,user.getLanguage())%>"
                        +"&wfid="+<%=workflowid%>+"&requestId="+<%=requestid%>+"&fieldId="+fieldid;
    }
    

    function  getLoctionInfo(fieldid){
            //获取定位时间,经度,纬度
            //location="emobile:gps:doSaveBlog"; 
            var data = fieldid +","+<%=nodeId%>+"," +<%=userid%>;
            location="emobile:gpsbyfieldid:getGpsInfo:" + data;
            //jQuery('#clearLocationId' + fieldid).attr("disabled","disabled");
            //jQuery('#clearLocationId' + fieldid).attr("onclick","");
    }   

	   //获取当前 缩放状态 如果有该功能  1 PC解析模式   0瀑布模式  返回字符串类型  没有 返回空 无值
    function  checkZoomStatus(){
       var  changemode = "<%=changemode%>"; 
	   if('<%=weaver.mobile.webservices.workflow.WorkflowServiceUtil.isHTMLMode(workflowid+"",nodeId+"")%>'=='false'){
		      changemode = "";
	   }
	   return changemode;
	}
	
	function changeZoom(){
	    if('<%=changemode%>' == '1'){
	        if(location.href.indexOf("&changemode=")==-1){
		        location = location.href+"&changemode=0";
		      }else{
		         location = location.href.replace("changemode=1","changemode=0"); 
		      }
	      }else if('<%=changemode%>' == '0'){
		      if(location.href.indexOf("&changemode=")==-1){
		        location = location.href+"&changemode=1";
		      }else{
		         location = location.href.replace("changemode=0","changemode=1"); 
		      }
	      }
	}

    </script>
    
    <script type="text/javascript">
    var promptWrod = "<%=SystemEnv.getHtmlLabelName(558, userLanguage)%>";
    var ectSignWrod = "<%=SystemEnv.getHtmlLabelName(30490, userLanguage)%>";
    var sureToDeleteWord = "<%=SystemEnv.getHtmlLabelName(23271, userLanguage)%>";
    var cj_mes_timeWord = "<%=SystemEnv.getHtmlLabelName(24569, userLanguage)%>!";
    var cj_bohaiLeave2 = "<%=SystemEnv.getHtmlLabelName(21624, userLanguage)%>!";
    var cj_bohaiLeave11 = "<%=SystemEnv.getHtmlLabelName(24033, userLanguage)%>!";
    var cj_bohaiLeave2_1 = "<%=SystemEnv.getHtmlLabelName(21721, userLanguage)%>";
    var cj_bohaiLeave2_2 = "<%=SystemEnv.getHtmlLabelName(21720, userLanguage)%>";
    var cj_bohaiLeave11_1 = "<%=SystemEnv.getHtmlLabelName(131656, userLanguage)%>";
    var cj_bohaiLeave11_2 = "<%=SystemEnv.getHtmlLabelName(131655, userLanguage)%>";
    var cj_bohaiLeave12_1 = "<%=SystemEnv.getHtmlLabelName(84604, userLanguage)%>";
    var cj_bohaiLeave12_2 = "<%=SystemEnv.getHtmlLabelName(84604, userLanguage)%>";
    
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
    
    var isnewVersion = true;

    //文档,附件资源
    var formcontainattachs=[];
    var RoomConflictChk="<%=roomConflictChk%>";
    var RoomConflict="<%=roomConflict%>"
    
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
</head>

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
<body>
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
<%if("y".equals(Util.null2String(request.getParameter("needChooseOperator"))) || "y".equals(resetoperator)){ %>
    <jsp:include page="/mobile/plugin/1/RequestChooseOperator.jsp" flush="true">
    </jsp:include>
<%} %>


<div id="msgsendSystemInfo" style="display:none;">
	<%=systemwfInfo %>
</div>

<%if("1".equals(ismonitor) && module.equals("-1005")){%>
    <%--流程信息--%>
    
    <div class="requestIfons" onclick="doShowDt(this)" >
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

<%=WorkflowRequestMessage.getClientInfoHtml(messageid,messagecontent,user) %>
<div id="view_page">

<% 

%>
    <div data-role="page" class="page workFlowView">
            <div class="form_out_content" data-role="content" style="margin-left: 10px; margin-right: 10px; padding-top: 0px;">
        <iframe id="selectChangeDetail" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
        <iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
                <form id="workflowfrm" action="/mobile/plugin/1/RequestOperation.jsp?module=<%=module%>&scope=<%=scope%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>" method="post" enctype="multipart/form-data">
                    <input type="hidden" id="type" name="type" value="<%=type %>" />
                    <input type="hidden" id="method2" name="method2" value="<%=method %>" />
                    <input type="hidden" id="src" name="src" value="<%=method %>" />
                    <input type="hidden" id="markId" name="markId"/>
                    <input type="hidden" id="userid" name="userid" value="<%=userid%>"/>
                    <input type="hidden" id="clientver" name="clientver" value="<%=clientVer%>"/>
                    <input type="hidden" id="serverver" name="serverver" value="<%=serverVer%>"/>
                    <input type="hidden" id="fromPage" name="fromPage" value="client.jsp"/>
                    <input type="hidden" id="forwardflag" name="forwardflag" value="0"/>
                    <input type="hidden" id="ismonitor" name="ismonitor" value="<%=ismonitor%>"/>
                    <input type="hidden" id="isurge" name="isurge" value="<%=isurge%>"/>
                    <input type="hidden" id="intervenorright" name="intervenorright" value="<%=intervenorright%>"/>
                   	<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
					<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
					<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>
					<input type="hidden" name="requestURI" id="requestURI"  />
                    <%if(!isSystemBill){ %>
                    	<input type="hidden" id="remarkLocation" name="remarkLocation" value=""></input>
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
if("true".equals(showInterventionBtn) && module!= null && intModule == -1005){ %>

    <div style="height:10px;overflow:hidden;"></div>
    <div class="winContentTitleHead">
        <div class="winContentTitle"><%=SystemEnv.getHtmlLabelName(18913,user.getLanguage()) %></div>
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
                    <input type="hidden" name="module2" value="<%=module %>">
                    <input type="hidden" name="scope2" value="<%=scope %>">
                    <input type="hidden" name="page.pageNo" value="1">
                    <input type="hidden" name="requestid" value="<%=requestid %>">
                    <input type="hidden" name="workflowid" value="<%=workflowid %>">
                    <input type="hidden" name="workflowsignid" value='0'/>
        
                    <div style="display:none;">
                    <textarea style="border:1px solid #BBBBBB!important;width:100%;border-radius:5px;" id="userSignRemark" name="userSignRemark" cols="80" rows="8" ><%=Util.null2String(workflowRequestInfo.getRemark())%></textarea>
                    </div>
                    <%-- 如下两个隐藏域 分别表示  语音附件 和 手写签章 --%>
                    <input type="hidden" id="fieldHandWritten" name="fieldHandWritten" value=""/>
                    <input type="hidden" id="fieldSpeechAppend" name="fieldSpeechAppend" value=""/>
                    
                    <%-- 流程签字意见 相关附件字段值 --%>
                    <div id="fieldSignAppendfix" style="display:none"></div>
                    <input type="hidden" id="fieldSignAppendfix" name="fieldSignAppendfix" value="<%=Util.null2String(workflowRequestInfo.getSignatureAppendfix())%>" />

                
                    <input type="hidden" id="forwardresourceids" name="forwardresourceids"/>
                    <input type="hidden" id="forwardresourceids2" name="forwardresourceids2"/>
                    <input type="hidden" id="forwardresourceids3" name="forwardresourceids3"/>
					<input type="hidden" id="RejectToType" name="RejectToType" value="0" />
                    <%if(isreject.equals("1")){%>
                     <input type="hidden" id="rejectToNodeid" name="rejectToNodeid" value="<%=zjclNodeid %>">
                    <%}else{%>
                    <input type="hidden" id="rejectToNodeid" name="rejectToNodeid" value="">
                    <%}%>
                    <%
						if(!"".equals(Util.null2String(workflowRequestInfo.getSubmitButtonName()))
							|| !"".equals(Util.null2String(workflowRequestInfo.getSubnobackButtonName()))
							|| !"".equals(Util.null2String(workflowRequestInfo.getSubbackButtonName()))
						) {
					%>
						<input type="hidden" id="SubmitToNodeid" name="SubmitToNodeid" value="" />
                    <%	} %>
            </form>
        </div>
    </div>
</div>


        <%
        //如果非创建节点则显示
        //TODO
        if (!"create".equals(method) && canview && flagServerVersion6_0) {
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
        <div style='height: 20px; width: 100%; border-top: #d9d9d9 solid <%=borderWidth%>; clear: both;'></div>
        <div id="remarkTempDiv" style='display:none; clear: both;'></div>
        <div id="remarkShowMore" onclick="javascript:doexpandRemark();"><%=SystemEnv.getHtmlLabelName(82720,user.getLanguage())%></div>
        <%
        }
        %>
        <script type="text/javascript">

var flagHiddenSpeechBtn = false;

jQuery(function(){
	
	<% if("y".equals(resetoperator)){%>
		jQuery('.showWin').hide();;
		jQuery('.pageMasking').hide();;
	<%}%>
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
    
        
<%  if("1".equals(isBill) && "180".equals(formId)){ %>
    //请假申请单的特殊处理，隐藏剩余年假、带薪病假信息。





    jQuery("select[nameBak='leaveType']").trigger("onchange");
<%  } %>

<%if("y".equals(Util.null2String(request.getParameter("needChooseOperator")))){%>
    	jQuery('.showWin').show();
	jQuery('.pageMasking').show();
<%}%>
<%if("y".equals(resetoperator)){%>
	controlBottomOperArea('show');
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
	
	
	if(clienttype=="android"||clienttype=="androidpad"){
		setTimeout('hiddenSubmitWaitInfo()',10);
		//hiddenSubmitWaitInfo();
	}
	
	//去掉待办中 条件 点击这里连接 系统提醒工作流

	<%if("14".equals(formId)){%>
		removeAdminSystemWfRemarkInfo();
	<%}%>
});

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
		jQuery('.showWin').css('display','block');
		jQuery('.pageMasking').css('display','block');
		controlBottomOperArea('hidden');
	}
	
	function hiddenSubmitWaitInfo(){
		var url = "emobile:hiddenSubmitWaitInfo";	
		location = url;
	}
	
		//客户端隐藏下方按钮及签字意见栏

	function controlBottomOperArea(par){
		var url = "emobile:controlBottomOperArea:"+par;	
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
</script>

<!-- 抽出 -->
<script type="text/javascript" src="/mobile/plugin/1/js/view/1_wev8.js"></script>
<script type="text/javascript" src="/mobile/plugin/1/js/view/htmlAttr_wev8.js"></script>
<%if(isremark!=2&&isremark!=4&&takisremark!=-2){%>
<script type="text/javascript" src="/workflow/exceldesign/js/fieldAttrOperate_wev8.js"></script>
<%}%>
<!--js 国际化-->
<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
<script type="text/javascript">
    (function ($) {
        $.fn.scroller = function (opt) {
            $(this).bind("click", function () {
                //jQuery(this).attr("readonly","readonly");
                getCalendarForClient(this);
            });
        };
    })(jQuery);
   
    function  coverData(itemData)
    {
      if(!itemData)
          return itemData;
      itemData=itemData.replace(/&quotforjson;/g,"&quot;");
      itemData=itemData.replace(/&gtforjson;/g,"&gt;");
      itemData=itemData.replace(/&ltforjson;/g,"&lt;");
      return itemData;
    
    }
  
    //冒泡排序
    function  bubleSort(sortArray){

              var length=sortArray.length;
              var temp;
              for(var i=0;i<length;i++)
                for(var j=0;j<length-i-1;j++)
                {
                    if(JSON.parse(sortArray[j]).filecreatetime>JSON.parse(sortArray[j+1]).filecreatetime)
                    {
                        temp= sortArray[j];
                        sortArray[j]=sortArray[j+1];
                        sortArray[j+1]=temp;
                    }
                }
       }



    //获取所有的文档资源
    function getAllAttachmentsData() {
        var str="";
        var itemarray=[];
        var fileurl="";
        var filetitle="";
        var fileauthor="";
        var filecreatetime="";
        var fileid="";
        var excludearray=[];
        var isinflag=false;
        for(var i=0;i<formcontainattachs.length;i++)
        {
          isinflag=true;

          for(var j=0;j<excludearray.length;j++)
          {
             if(excludearray[j]===formcontainattachs[i].fileid)
             {
                isinflag=false;
                break;
             }
          }

          if(!isinflag)
              continue;
        
          filetitle=formcontainattachs[i].filetitle?formcontainattachs[i].filetitle:"";

          if(filetitle==="")
               continue;

          excludearray.push(formcontainattachs[i].fileid);
          
          fileauthor=formcontainattachs[i].fileauthor?formcontainattachs[i].fileauthor:"";
          filecreatetime=formcontainattachs[i].filecreatetime?formcontainattachs[i].filecreatetime:"";

          filetitle=coverData(filetitle);
          fileauthor=coverData(fileauthor);


          str="{\"filetitle\":\""+filetitle+"\",";
          str=str+"\"fileauthor\":\""+fileauthor+"\",";
          str=str+"\"filecreatetime\":\""+filecreatetime+"\",";
          str=str+"\"fileid\":\""+formcontainattachs[i].fileid+"\",";
          
         if(formcontainattachs[i].filetype==="0"  ||  formcontainattachs[i].filetype===0)
          { 

              fileurl="/mobile/plugin/2/view.jsp?detailid="+formcontainattachs[i].fileid+"&module=" + js_module + "&scope=" + js_scope + "&fromWF=true&requestid=" + js_requestid + "&fromRequestid=" + js_fromRequestid + "&showAll=true&clientver=" + js_clientVer
              +"&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
          }else if(formcontainattachs[i].filetype==="1"  ||  formcontainattachs[i].filetype===1)
          { 
              fileurl="/download.do?fileid="+formcontainattachs[i].fileid+"&filename="+filetitle+"&fromWF=true&requestid=" + js_requestid +"&module=" + js_module + "&scope=" + js_scope + ""
              +"&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
          }

          str=str+"\"fileurl\":\""+fileurl+"\",";
         
          str=str+"\"filetype\":\""+formcontainattachs[i].filetype+"\"}";
          
          itemarray.push(str);
        }
         
        bubleSort(itemarray);

        return "{\"fileattach\":["+itemarray.join(",")+"]}";
    }
    
    
    window.onscroll = function(){
        bodyScrollLeft = document.body.scrollLeft;
    }
    var ckInterval = null;
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
        //toURL("/mobile/plugin/1/clientInfo.jsp?location=" + remarkLocationStr,false);
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
        location = "emobile:openUserinfo:" + operatorUserid; 
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
    var attachflieList = new Object;
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
                                viewsignHtml += "<div class='operatorface' ontouchend='signRowUserTouchend(\"" + operatorId + "\")'><img src=\"" + operatorSignIcon + "\"></div>";
                            }else{
                                viewsignHtml += "<div class='operatorface_noicon' ontouchend='signRowUserTouchend(\"" + operatorId + "\")'>" + leftoperatorName + "</div>";
                            }
                            viewsignHtml += "<div class='operatormessage'>" + "<div class='message_before'></div>";
                            
                            viewsignHtml += "  <div class=\"signRow_yijian\">";
                            var handWrittenSignSrc = new Array();
                            var SpeechDisplayHtmls = new Array();
                            if (remarkSign != null && remarkSign != undefined) {
                            } else {
                                if(operateType != "抄送"){
	                                $('#remarkTempDiv').html('');
	                                $('#remarkTempDiv').html(remark);
	                                $('#remarkTempDiv').find('[name="handWrittenSign"]').each(function(){
	                                   handWrittenSignSrc.push($(this).attr("src"));
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
                                    for(var brCnt = 0; brCnt < $('#remarkTempDiv').find('br').length; brCnt++){
                                        if($($('#remarkTempDiv').find('br')[brCnt]).next().length > 0 && $($('#remarkTempDiv').find('br')[brCnt]).next()[0].tagName == "BR"){
                                            $($('#remarkTempDiv').find('br')[brCnt]).next().remove();
                                            brCnt--;
                                        }
                                    }
                                    remark = $('#remarkTempDiv').html();
                                    viewsignHtml += remark;
                                }
                            }
                            viewsignHtml += "</div>";
                            if (remarkSign != null && remarkSign != undefined) {
                                viewsignHtml += "  <div class=\"signRow_yijian 2\">";
                                viewsignHtml += "<div style=\"width:100%;clear:both\">" + "    <img src=\"/download.do?url=" + remarkSign + "\" onload='image_resize(this);' onresize='image_resize(this);' onclick='javascript:imgCarousel(this);'>" + "</div>";
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
                                        /*
                                        try{
                                            var fileid = this.outerHTML.substring(this.outerHTML.indexOf("/download.do?fileid=") + 20);
                                            fileid = fileid.substring(fileid.indexOf("&"));
                                            var filename = this.outerHTML.substring(this.outerHTML.indexOf("filename=") + 9);
                                            filename = filename.substring(filename.indexOf("'"));
                                            attachflieList["attach" + fileid] = filename;
                                            if(jQurey("#topattach" + fileid).length > 0){
                                                var clickEvent = jQurey("#topattach" + fileid).attr("onclick");
                                                clickEvent = clickEvent.replace("##tempattachfilename##",filename);
                                                jQurey("#topattach" + fileid).attr("onclick",clickEvent);
                                            }
                                        }catch(e){}
                                        */
                                        $(this).remove();
                                    }
                                });
                                /*
                                annexDocHtmls = annexDocHtmls.replace(regExpBr,"");
                                while(annexDocHtmls.indexOf("toURL('") >= 0){
                                    if(annexDocHtmls.indexOf("toURL('") >= 0){
                                        annexDocHtmls = annexDocHtmls.substring(annexDocHtmls.indexOf("toURL('") + 7);
                                        var docLink = annexDocHtmls.substring(0,annexDocHtmls.indexOf("'"));
                                        if(docLink.length > 3 && (docLink.substring(docLink.length - 3)=="jpg"
                                                                  || docLink.substring(docLink.length - 3)=="png"
                                                                  || docLink.substring(docLink.length - 3)=="gif")){
                                            imageSrcs.push(annexDocHtmls.substring(0,annexDocHtmls.indexOf("'")));
                                        }else{
                                            linkSrcs.push(annexDocHtmls.substring(0,annexDocHtmls.indexOf("'")));
                                        }
                                        annexDocHtmls = annexDocHtmls.substring(annexDocHtmls.indexOf("'") + 1);
                                    }else{
                                        break;
                                    }
                                }
                                */
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
                            /*
                            if(operateDate == (new Date()).format("yyyy-MM-dd")){
                                operateDate = "今天";
                            }else{
                                operateDateDat = new Date(operateDate);
                                if(getWeekOfYear(operateDateDat) == getWeekOfYear(new Date())){
                                    operateDate = weekday[operateDateDat.getDay()];
                                }
                            }
                            */
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
                            //$(e).bind("touchstart",function(){
                            //    touchmoveFlag = false;
                            //});
                            //$(e).bind("touchmove",function(){
                            //    touchmoveFlag = true;
                            //});
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
                            //$(this).remove();
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
                    $(".signRow_yijian").find("span").each(function() {
                        if($(this).html() == "来自iPhone客户端"){
                            //$(this).remove();
                        }
                    });
                    
                    //$(".signRowLocation").bind("touchstart",function(){
                    //    touchmoveFlag = false;
                    //});
                    //$(".signRowLocation").bind("touchmove",function(){
                    //    touchmoveFlag = true;
                    //});
                    //$(".signRow_operate").bind("touchstart",function(){
                    //    touchmoveFlag = false;
                    //});
                    //$(".signRow_operate").bind("touchmove",function(){
                    //    touchmoveFlag = true;
                    //});
                    $(".signRow_operate").unbind("touchend");
                    $(".signRow_operate").bind("touchend",function(){
                       //过滤滑动事件
                       if(touchmoveFlag){return;}
                       $(this).parent().find(".signRow_nodetotal").toggle();
                       $(this).toggleClass("signrow_endline");
                       $(this).find(".signRow_operateTime").toggleClass("signrow_endline");
                       $(this).find(".signRow_operatorname").toggleClass("signrow_endline");
                       $(this).find(".signRow_operateTime").toggleClass("signRow_operateTime_open");
                    });
                    var topHeight= $("#page_remarksign_Title_div").offset().top;
                    //var windowHeight = (window.screen.availHeight < document.body.clientHeight) ? window.screen.availHeight : document.body.clientHeight;
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
                    /*
                    var str = '';
                    str+="网页可见区域高 =" + document.body.clientHeight+"\n";//
                    str+="网页可见区域高(包括边线的宽)=" + document.body.offsetHeight+"\n";//
                    str+="网页正文全文高=" + document.body.scrollHeight+"\n";//
                    str+="网页被卷去的高=" + document.body.scrollTop+"\n";//
                    str+="网页被卷去的左=" + document.body.scrollLeft+"\n";//
                    str+="网页正文部分上=" + window.screenTop+"\n";//
                    str+="网页正文部分左=" + window.screenLeft+"\n";//
                    str+="屏幕分辨率的高=" + window.screen.height+"\n";//
                    str+="屏幕可用工作区高度=" + window.screen.availHeight+"\n";//
                    str+="topHeight=" + topHeight+"\n";//
                    str+="windowHeight=" + windowHeight+"\n";//
                    alert(str);
                    alert("window.screen.availHeight=" + window.screen.availHeight);
                    alert("$(document).height()=" + $(document).height());
                    alert("window.innerHeight=" + window.innerHeight);
                    alert("bodyHeight = " + $("body").height());
                    alert("$(window).height() = " + $(window).height());
                    alert("screen.height = " + screen.height);
                    alert("topHeight = " + topHeight);*/
                    if(isfirst && parseInt(topHeight) > parseInt(windowHeight) -26 ){
                        $("#page_remarksign_Title_div").addClass("fixedBottomDiv");
                    }
                    $("#page_remarksign_Title_div").bind("touchend",function(){
                        if(touchmoveFlag){
                            return;
                        }
                        $("#page_remarksign_Title_div").removeClass("fixedBottomDiv");
                        //防止此时触发加载更多
                        jQuery(window).unbind("scroll",autoScrollSign);
                        $(document).scrollTop(topHeight);
                        jQuery(window).bind("scroll",autoScrollSign);
                    });
                    $(".operatormessage").each(function(){
                        $(this).width($(window).width() - 65 -10);
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
                        if(parseInt(topHeight) > parseInt($(document).scrollTop()) + windowHeight- $("#page_remarksign_Title_div").height() + window.screen.height - window.screen.availHeight - 43){
                        <%}else{%>
                        if(parseInt(topHeight) > parseInt($(document).scrollTop()) + windowHeight  - $("#page_remarksign_Title_div").height() + window.screen.height - window.screen.availHeight - 43){
                        <%}%>
                            if($("#page_remarksign_Title_div").attr("class") == undefined || $("#page_remarksign_Title_div").attr("class").indexOf("fixedBottomDiv") == -1){
                                $("#page_remarksign_Title_div").addClass("fixedBottomDiv");
                            }
                        }else{
                            $("#page_remarksign_Title_div").removeClass("fixedBottomDiv");
                        }
                        prevTop = currTop;
					});
                    $(document).bind("touchmove",function(){
                        if(parseInt(topHeight) > parseInt($(document).scrollTop()) + windowHeight - $("#page_remarksign_Title_div").height() + window.screen.height - window.screen.availHeight - 43){
                            if($("#page_remarksign_Title_div").attr("class").indexOf("fixedBottomDiv") == -1){

                                $("#page_remarksign_Title_div").addClass("fixedBottomDiv");
                            }
                        }else{
                            $("#page_remarksign_Title_div").removeClass("fixedBottomDiv");
                        }
                    });
                    //$(".signRow_yijian").append($(attachfileHtml));
                    //$(".divSpeechDisplay").before($(attachfileHtml));
                    
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
        /*
        if(touchmoveFlag){return;}
        var thistimecount = 0;
        for(var showcnt = 0 ; showcnt < $(".message_content").length; showcnt++){
            var message_content = $(".message_content")[showcnt];
            if(thistimecount >= remarkPageLimit){
                break;
            }
            if($(message_content).css("display") == "none"){
                $(message_content).show();
                if(thistimecount == 0){
                    remarkPageCnt += 1;
                }
                thistimecount++;
            }
        }
        */
    }
    //标识当前转发操作是第一次





    var flagForwardFirst = true;
    //标识当前流程已操作人员





    var flagForwardReceiver = "";
    
    <% if(flagForwardReceiveDef){ %>
        flagForwardReceiver = "<%=WorkflowSpeechAppend.getAllOperateredResource(String.valueOf(requestid))%>";
    <% } %>
    
    //表单中所有文档与附件的json格式数据集合（在form.jsp中赋值）
    function getWorkflowResource() {
        //获取签字意见附带的文档和附件
        var signAttachUrl = "/mobile/plugin/1/workflowSignAttachFiles.jsp?workflowId=<%=workflowid%>&requestId=<%=requestid%>&pagesize=9999&pageindex=0&userid=<%=userid%>"
        +"&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
        
        jQuery.ajax({
            type : "get",
            url : signAttachUrl,
            success:function(str) {
                var signrs;
                if(!jQuery.isArray(str) && jQuery.trim(str) != "")
                signrs = JSON.parse(str);
                else
                signrs=str;
                if(!jQuery.isArray(formcontainattachs))
                {
                  formcontainattachs=[];
                }
                for(var i=0;i<signrs.length;i++)
                {
                   //添加签字意见附件
                    formcontainattachs.push(signrs[i]);
                }
                /*
                if($(".signRow_yijian").length > 0){
                    for(var i=0;i<formcontainattachs.length;i++){
                        var item = formcontainattachs[i];
                        var attachfileHtml="";
                        attachfileHtml +="<div class='attachfileDiv'>";
                        attachfileHtml +="<img src='/download.do?fileid=" + item.fileid + "&filename=" + item.filetitle + "'";
                        attachfileHtml +="  onload='image_resize(this);' onresize='image_resize(this);' onclick='javascript:imgCarousel(this);'>";
                        attachfileHtml +="</div>";
                    }
                    $(".signRow_yijian").append($(attachfileHtml));
                }
                */
                location = "emobile:attachmentsReadyMessage"; 
            }, fail:function(){

                alert('数据加载失败!!!');
                if(!jQuery.isArray(formcontainattachs))
                {
                  formcontainattachs=[];
                }
                location = "emobile:attachmentsReadyMessage";
            }
        });
    }
    
   

    
    //各种浏览按钮通用
    function showDialog(url, data) {
         data = data + "&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
         data =joinFieldParams(data);
        <%//if(!"".equals(workflowHtmlShow)){ %>
        //如果是手机Html模式，需要对浏览按钮中的弹出框地址作修改。





            url = "/mobile/plugin/browser.jsp";
        <% //} %>
        <%--
        if(data.indexOf("method=listDepartment") === -1 && data.indexOf("method=listSubCompany") === -1  ){
        --%>
            if (url == "/mobile/plugin/browser.jsp") {
	            url = "/mobile/plugin/1/browser.jsp";
	        }
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
	        try{
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
                       	 	
                       	 	_fnaUrlPara1 += "&orgid2="+orgid2+"&orgtype2="+orgtype2+"&billid=<%=billid%>";
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
	        var oldVal = $("#" + returnIdField).val();
	        var oldName = $("#" + returnShowField).text().replace(/( )+/g, ",");
	        url = (url + "?r=" + (new Date()).getTime() + data);
			if(oldVal !='' && (oldName==''||oldName==null)){ //保障浏览按钮不报错问题
				oldName=oldVal;
			}
	        
	        var splitChar = "@@TYLLKFGF@@";
	        //人力资源
	        if (browserMethod == "listUser") {
	            url = "HRMRESOURCE";
	            splitChar = ":";
	        }
	        
	        var browserName = "";
	        if (returnIdField == "forwardresourceids") {
	            //转发人       
	            browserName = "转发接收人";
	            
	            if(flagForwardFirst){
	                oldVal = flagForwardReceiver;
	                flagForwardFirst = false;
	            }else{
	                oldVal = $("#" + returnIdField).val();
	            }
	            
	            splitChar = ":";
	        }else if (returnIdField == "forwardresourceids2") {
	            //意见征询      
	            browserName = "意见征询接收人";
	            
	            if(flagForwardFirst){
	                oldVal = flagForwardReceiver;
	                flagForwardFirst = false;
	            }else{
	                oldVal = $("#" + returnIdField).val();
	            }
	            
	            splitChar = ":";
	        }else if (returnIdField == "forwardresourceids3") {
	            //转发人       
	            browserName = "转办接收人";
	            
	            if(flagForwardFirst){
	                oldVal = flagForwardReceiver;
	                flagForwardFirst = false;
	            }else{
	                oldVal = $("#" + returnIdField).val();
	            }
	            
	            splitChar = ":";
	        } else if(returnIdField == "rejectToNodeid"){
	            browserName = ""+SystemEnv.getHtmlNoteName(4642);
	        } else {
	            if(document.getElementById(returnIdField+"_d")){ //明细表的读取
	                 browserName = $("#" + returnIdField+"_d").parent().prev().text();
	            }else{
	                 browserName = $("#" + returnIdField).closest("div").parent().prev().prev().text();
	            }
	        }
	        var nativeUrl = "emobile" + splitChar + "Browser" + splitChar + url + splitChar + isMuti + splitChar + oldVal + splitChar + "setBrowserData" + splitChar + returnIdField + splitChar + returnShowField + splitChar + browserName + splitChar + oldName+splitChar+"UTF-8";
	        location = nativeUrl;
	        
	    <%-- 
        }else{
          departBrowser(data);
        }
        --%>

    }
    
    /**
     * 预算费用回调函数
     **/
    function fnaFyFunCallBack(fieldID, fieldSpan, keys, vals, clickType) {
        return;
    }

    
    
    /**
     * 浏览框回调方法





     **/
    function setBrowserData(fieldID, fieldSpan, keys, vals, clickType, call_fnaFyFunCallBack) {
        if(call_fnaFyFunCallBack==null){
            call_fnaFyFunCallBack = true;
        }
        //点击了清空或者取消



        if (clickType == 1 || clickType == 2) {         
            //点击了清空




            if (clickType == 1) {
                try {
                    $("#" + fieldID).val("");
                    $("td[id='"+fieldSpan+"']").html("");
                    $("#" + fieldID).change();
                    if(document.getElementById(fieldID+"_d")){
                       $("#" + fieldID+"_d").val("");
                    }
                    if(document.getElementById(fieldSpan+"_d")){
                       $("#" + fieldSpan+"_d").html("");
                         var groupidStr=$("#" + fieldSpan+"_d").attr("groupid");
                         var rowIdStr=$("#" + fieldSpan+"_d").attr("rowId");
                         var columnIdStr=$("#" + fieldSpan+"_d").attr("columnId");
                         if(groupidStr&&rowIdStr&&columnIdStr){
                            var showObj= document.getElementById("isshow"+groupidStr+"_"+rowIdStr+"_"+columnIdStr);
                            showObj.innerHTML = "<span id=\""+fieldSpan+"\" name=\""+fieldSpan+"\" keyid=\"mingxi\"></span>";
                         }
                         
                    }
                } catch (e) {
                    alert(e);
                }
                try{
                    if(call_fnaFyFunCallBack){
                        fnaFyFunCallBack(fieldID, fieldSpan, keys, vals, clickType);
                    }
                }catch(ex){}
                if(fieldID == "markId"){
                    //电子签章清空操作
                    return "markId:Empty";
                }
            }
            return false;
        }
        
        if (clickType == 0) {
            try {
                $("#" + fieldID).val(keys);
                $("td[id='"+fieldSpan+"']").html("<span id=\""+fieldSpan+"\" name=\""+fieldSpan+"\" keyid=\""+keys+"\">"+vals+"</span>");
                if(jQuery("#operators_0_span")){
                    jQuery("#operators_0_span").html(vals);
                }
                $("#" + fieldID).change();
                if(document.getElementById(fieldID+"_d")){
                    $("#" + fieldID+"_d").val(keys);
                }
                if(document.getElementById(fieldSpan+"_d")){
                    $("#" + fieldSpan+"_d").html(vals);
                    if(jQuery("#" + fieldID+"_d_ismandspan").length==0){//補充手段
                        $("#" + fieldSpan+"_d").after("<span id='" + fieldID+"_d_ismandspan' style='color: red;font-size: 16pt;float:right;display:none'>!</span>");    
                    }
                     var groupidStr=$("#" + fieldSpan+"_d").attr("groupid");
                     var rowIdStr=$("#" + fieldSpan+"_d").attr("rowId");
                     var columnIdStr=$("#" + fieldSpan+"_d").attr("columnId");
                     if(groupidStr&&rowIdStr&&columnIdStr){
                        var showObj= document.getElementById("isshow"+groupidStr+"_"+rowIdStr+"_"+columnIdStr);
                        showObj.innerHTML = "<span id=\""+fieldSpan+"\" name=\""+fieldSpan+"\" keyid=\"mingxi\">"+vals+"</span>";
                     }
                     //setTimeout(function(){
                       if(jQuery("#" + fieldID+"_ismandspan").length>0){
                        var spandobj = jQuery("#" + fieldID+"_d_ismandspan");    
                        var spandobj1 = jQuery("#" + fieldSpan+"_d_ismandspan");                   
                        var ismand = jQuery("#" + fieldID+"_ismandspan").attr("class") ;
                        if(ismand=='ismand'){
                            if(keys==''){
                                //spandobj.addClass("ismand");
                                spandobj.css("color","red").css("font-size","16pt").css("float","right");
                                spandobj.show();
                            }else{
                                spandobj.hide();
                            }
                        }else{
                            spandobj.hide();
                        }
                        //alert("ismand= "+ismand+"  display="+spandobj.css("display"));
                    }
                    //},1000); 
                }
                /*
                try {
                  clearInterval(ckInterval);
                } catch (e){}
                setInterval("setRedflag()",1000);
                */
            } catch (e) {
                alert(e);
            }
            try{
                if(call_fnaFyFunCallBack){
                    fnaFyFunCallBack(fieldID, fieldSpan, keys, vals, clickType);
                }
                if(window._FnaSubmitRequestJsRepayFlag){
                    fnaRepayCallBack1(fieldID, fieldSpan, keys, vals, clickType);
                }
            }catch(ex){}
            
            if (fieldID == "forwardresourceids") {

                if(keys == null || keys == ""){
                    var msg = "请选择转发接收人！";
                    return "emobile:Message:" + msg + ":" + promptWrod;
                }
                $('#src').val("forward");
                $('#forwardflag').val("1");
                $('#workflowfrm').submit();
                return true;
                
            }else if (fieldID == "forwardresourceids2") {

                if(keys == null || keys == ""){
                    var msg = "请选择意见征询接收人！";
                    return "emobile:Message:" + msg + ":" + promptWrod;
                }
                $('#src').val("forward");
                $('#forwardflag').val("2");
                $('#workflowfrm').submit();
                return true;
                
            }else if (fieldID == "forwardresourceids3") {

                if(keys == null || keys == ""){
                    var msg = "请选择转办接收人！";
                    return "emobile:Message:" + msg + ":" + promptWrod;
                }
                $('#src').val("forward");
                $('#forwardflag').val("3");
                $('#workflowfrm').submit();
                return true;
                
            } else if(fieldID == "rejectToNodeid"){
                if(keys == null || keys == ""){
                    var msg = ""+SystemEnv.getHtmlNoteName(4639);
                    return "emobile:Message:" + msg + ":" + promptWrod;
                }
                
                setTimeout(function () {
                    var flag = confirm(""+SystemEnv.getHtmlNoteName(4640));
                    if (flag) {
                        $('#src').val("reject");
                        $('#workflowfrm').submit();
                        return true;
                    }else{
                        return false;
                    }
                    
                }, 1000);
            } else {
                if(fieldID == "markId"){
                    if(keys == ""){
                        return "markId:Empty";
                    }else{
                        var markURL = "/weaver/weaver.file.SignatureDownLoad?markId=" + keys;
                        return markURL;
                    }
                }
            }
            
            return false;
        }else{
            return false;
        }
    }

    //转发处理
    function setForwardBrowserData(fieldID, fieldSpan, keys, vals, clickType) {
          if(docheckforward()){
             return  setBrowserData(fieldID,fieldSpan,keys,vals,clickType);
          }else{
             try {
               clearInterval(ckInterval);
             } catch (e){}
             setInterval("setRedflag()",1000);
             return "emobile:Message:请填写签字意见！:提示";
          }
    }
    
    //用于预加载页面之后，正式加载页面信息。去掉new标记、对抄送不需提交作提交操作。





    function reloadData () {
        var ajaxUrl = "/mobile/plugin/1/client.jsp?<%=request.getQueryString().replace("isPreLoad", "isPreLoadAAAA")%>";
        jQuery.ajax({
            type: "GET",
            url: ajaxUrl
        });
    }




    
    function isNeedAffirmance() {
        return <%=workflowRequestInfo.isNeedAffirmance() %>;
    }
    
    function getIsselectrejectnode() {
        return <%=workflowRequestInfo.getWorkflowBaseInfo().getIsselectrejectnode() %>;
    }
    
    <%
    //是否是从自定义模块从创建流程
    int createFromCustomMode = Util.getIntValue(Util.null2String(request.getParameter("crtfctm")), -1);
    %>
    function doLeftButton() {
        if (<%=createFromCustomMode == 1 %>) {
            return "BACK";
        }
        
        if(<%=fromRequestid%> > 0){
            goBack();
            return 1;
        }
    }
    
    function getRequestTitle(){
        return "<%=Util.null2String(workflowRequestInfo.getRequestName()).replace("\n","")%>";
    }
    
    function dataInput(parfield, strFieldName){
        var strData="id=<%=workflowid%>&node=<%=workflowRequestInfo.getCurrentNodeId() %>&trg="+parfield;
        dataInput2(parfield, strFieldName, strData);
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
        return doreject2(_this, <%=1 <= workflowRequestInfo.getWorkflowBaseInfo().getIsselectrejectnode() %>);
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
    
    //是否允许签字意见上传附件  
    function getIsAnnexUpload(){
        return "<%="1".equals(workflowRequestInfo.getIsAnnexUpload()) ? "" : SystemEnv.getHtmlLabelName(30492, userLanguage) %>";
    }
    
    //是否设置了 签字意见上传附件 的目录





    function getSignatureAppendfix(){
        return "<%=(annexDocCategory != null) ? "" : SystemEnv.getHtmlLabelName(31004, userLanguage)%>";
    }
    
    function isMustInputRemark(src) {
    	if("reject" == src) {
    		return <%=workflowRequestInfo.isRejectMustInputRemark() %>;
		}else {
        return <%=workflowRequestInfo.isMustInputRemark() %>;
		}
    }
    
    function getRemarkString(){
        //必须对换行符作二次转义





        return "<%=Util.null2String(workflowRequestInfo.getRemark()).replace("\n","\\n")%>";
    }
    
    function getWorkflowPhrases() {
        <%
        String phrasesstring = "{\\\"phrases\\\":[";
        String[][] workflowPhrases = workflowRequestInfo.getWorkflowPhrases();
        if(workflowPhrases != null){
            for (int i=0; i<workflowRequestInfo.getWorkflowPhrases().length; i++) {
                if (i != 0) phrasesstring += ",";
                 String phrName = workflowRequestInfo.getWorkflowPhrases()[i][0];
                phrName = phrName.replace("\r","※").replace("\n","▉").replace("\b","▓").replace("\f","▅").replace("\t","▒");
				phrName = phrName.replace("\\","\\\\");
				phrName = phrName.replace("※","\r").replace("▉","\n").replace("▓","\b").replace("▅","\f").replace("▒","\t");

				phrName = phrName.replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "").replaceAll("\\\\", "\\\\\\\\").replace("\"", "\\\\\\\"").replaceAll("\'", "\\\\\'");
                String phrValue = workflowRequestInfo.getWorkflowPhrases()[i][1];
                phrValue = phrValue.replace("\r","※").replace("\n","▉").replace("\b","▓").replace("\f","▅").replace("\t","▒");
				phrValue = phrValue.replace("\\","\\\\");
				phrValue = phrValue.replace("※","\r").replace("▉","\n").replace("▓","\b").replace("▅","\f").replace("▒","\t");
				phrValue=phrValue.replaceAll("\r\n", "").replaceAll("\n", "\\\\\\n").replaceAll("\r", "").replaceAll("\\\\", "\\\\\\\\").replace("\"", "\\\\\\\"").replaceAll("\'", "\\\\\'");
                phrasesstring += "{\\\"name\\\": \\\"" + phrName + "\\\", \\\"value\\\":\\\"" + phrValue + "\\\"}";
            }
        }
        phrasesstring += "]}";
        %>
        return "<%=phrasesstring %>";
    }
    //电子签章是否启用
    function isFormSignature() {
        return <%=workflowRequestInfo.getIsFormSignature().equals("1") %>;
    }
    
    function displayFormSignature(marksrc) {
        var url = "emobile:setFormSignatureSrc:" + "clearAppendix";
        location = url; 
    }
    
    function getFormSignatureCallback() {
        var url = "/mobile/plugin/browser.jsp";
        var datas = "&returnIdField=markId&returnShowField=markName&method=listBrowserData&browserTypeId=-10&isMuti=0"
        +"&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
        showDialog(url, datas);
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

    function doSubmitDirect_4Mobile(isBack) {
    	doSubmitDirect(null, isBack);
    }

	function doSave_4Mobile(_callBackFunType){
		if(_callBackFunType==1){
		  return dosave();
		}
	}
    
    //将签字意见相关放入表单





    function setSign2Form(signtext, fieldHandWrittenCtx, fieldSpeechAppendCtx, markIdCtx, fieldSignAppendCtx) {
        $("#userSignRemark").html(null2string(signtext));
		 $("#userSignRemark").val(null2string(signtext));
        var indexFlag;
        
        //非空判断
        fieldHandWrittenCtx = null2string(fieldHandWrittenCtx);
        //去掉后边的文件名称





        indexFlag = fieldHandWrittenCtx.indexOf(";");
        if(indexFlag > 0){
            fieldHandWrittenCtx = fieldHandWrittenCtx.substr(0, indexFlag);
        }
        $("#fieldHandWritten").val(fieldHandWrittenCtx);
        
        //非空判断
        fieldSpeechAppendCtx = null2string(fieldSpeechAppendCtx);
        //去掉后边的文件名称





        indexFlag = fieldSpeechAppendCtx.indexOf(";");
        if(indexFlag > 0){
            fieldSpeechAppendCtx = fieldSpeechAppendCtx.substr(0, indexFlag);
        }
        $("#fieldSpeechAppend").val(fieldSpeechAppendCtx);
        
        //设置签字意见中的附件上传
        addSignatureAppendfix(fieldSignAppendCtx);
    }
    var client_jsp_canview =<%=canview%>;
    var messageidisnull = <%=(StringUtils.isEmpty(messageid))%>;
    function getRemarkUrl(lastLogId) {
        if(client_jsp_canview && messageidisnull){
            return "/mobile/plugin/1/workflowSign4Separation.jsp?" + getUrlParamByLastLogId(lastLogId);
        }else{
            return "error";
        }
    }
    
    function inputRemarksign() {
        var url = "emobile:inputRemarksign";            
        location = url; 
    } 
    
    function addSignatureAppendfix(strDataKeyStr){
        try{
            var strFrag = "";
            //将多个图片附件分隔，并逐一将数据设置到隐藏表单域中。





            var arrDataKeys = strDataKeyStr.split(",");
            for(var i = 0; i<arrDataKeys.length; i++){
                var tempStr = arrDataKeys[i];
                var j = tempStr.indexOf(";");
                if(j > 0){
                    var dataKey = tempStr.substr(0, j);
                    var appendFileName = tempStr.substr((j+1));
                    strFrag += "<input type='hidden' id='fieldSignAppend_" + i + "' name='fieldSignAppend_" + i + "' value='" + dataKey + "' > &nbsp;&nbsp;";
                    strFrag += "<input type='hidden' id='fieldSignAppendName_" + i + "' name='fieldSignAppendName_" + i + "' value='" + appendFileName + "' > &nbsp;&nbsp;";
                }
            }
            
            strFrag += "<input type='hidden' id='cntFieldSignAppends' name='cntFieldSignAppends' value='" + i + "' > &nbsp;&nbsp;";
            
            $("#fieldSignAppendfix").html(strFrag);
        }catch(e){
            
        }
    }
    
    function delSignatrueAppendfix(docID){
        var fieldSignAppendfix = jQuery("#fieldSignAppendfix").val();
        fieldSignAppendfix = fieldSignAppendfix.replace(docID, "");
        jQuery("#fieldSignAppendfix").val(fieldSignAppendfix);
    }
</script>

<SCRIPT LANGUAGE="JavaScript">
function doConfirmIntervenor(){
    var Intervenorid = jQuery("#Intervenorid").val();
    if(Intervenorid == null || Intervenorid == ""){
        alert("<%=SystemEnv.getHtmlLabelName(125403,user.getLanguage()) %>");
        return;
    }
    //jQuery("input#eh_setoperator").val("y");
    //jQuery("#userSignRemark").val(jQuery("#Intervenorremark").val());
    return doIntervenor();
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
	            url="/mobile/plugin/1/clientSuccess.jsp"
	            window.location.href = url;
            }
        });
    }
    else
    {
    //  displayAllmenu();
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
                url="/mobile/plugin/1/clientSuccess.jsp"
                window.location.href = url;
            }
        });
        url="/mobile/plugin/1/clientSuccess.jsp"
        window.location.href = url;
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
                url="/mobile/plugin/1/clientSuccess.jsp"
                window.location.href = url;
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
function doRetract(obj,type){     //强制收回
var tips = '<%=tips%>';
if(tips != ""){
    alert(tips);
    return false;
}
//enableAllmenu();

//document.location.href="/mobile/plugin/1/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=rb&requestid=<%=requestid%>" //xwj for td3665 20060224
    
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
                url="/mobile/plugin/1/clientSuccess.jsp"
                window.location.href = url;
            }
        });
}


function doDrawBack(obj){   //强制归档
//document.location.href="/mobile/plugin/1/wfFunctionManageLink.jsp?flag=ov&requestid=<%=requestid%>" //xwj for td3665 20060224
    jQuery.ajax({
                url:"/mobile/plugin/1/wfFunctionManageLink.jsp",
                type:"get",
                data:{
                    flag:"ovm",
                    requestid:"<%=requestid%>"
                },
                success:function(data){
	                url="/mobile/plugin/1/clientSuccess.jsp"
	                window.location.href = url;
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


<%if (intervenorright>0){%>    // 干预
function showIntervenor(obj)
{
     jQuery("#intervenor").bind("click", function(event) { jQuery(".pageIntervaling").show(); });

}
<%}%>
<%if ("-1004".equals(module)){%>

function doSuperviseTemp(){        //督办
  return dosupervise();
}
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
                //  e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84024,user.getLanguage())%>",true);
                }catch(e){}
            },
            complete:function(xhr){
                //e8showAjaxTips("",false);
                url="/mobile/plugin/1/clientSuccess.jsp"
                window.location.href = url;
            },
            success:function(data){
                //window.location="WorkflowMonitorList.jsp?"+data;
                //_xtable_CleanCheckedCheckbox();
                //_table.reLoad();
                url="/mobile/plugin/1/clientSuccess.jsp"
                window.location.href = url;
            }
        });
    }
    
     //requestid = requestid+",";
     //document.weaver.multiRequestIds.value = requestid;
     //document.weaver.operation.value='deleteworkflow';
     //document.weaver.action='/system/systemmonitor/MonitorOperation.jsp';
     //document.weaver.submit();
}



//function deleteWorkflow(obj){  //批量删除
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
}    */
    function getRemarkLocation(resultStr){
        jQuery("#remarkLocation").val(resultStr);
    }
    
	/* 获取签字意见是否添加位置信息 */	
	function getLocateStatus(wfid){
	    <%if(isSystemBill){ %>
	    	return 0;
	    <%}else{%>
			return 1;
		<%}%>
	}
	
	var crtimgjson = null;
    function imgCarousel(touchobj) {
	    if (crtimgjson === null) {
	        crtimgjson = new Array();
	        var imgs = jQuery("img");
	        for (var i=0; i<imgs.length; i++) {
	            if($(imgs[i]).attr("onresize") != undefined && $(imgs[i]).attr("align") != "absmiddle"){
                    crtimgjson.push(imgs[i].src);
	            }
	        }
	    }
	    
	    if (crtimgjson.length > 0 ) {
	        var curindex = crtimgjson.indexOf(touchobj.src);
                var url = "emobile:imgCarousel:" + JSON.stringify(crtimgjson).replace(/ /g, "") + ":" + curindex;
	        location.href = url;
	    }
	}



</SCRIPT>

<%
RecordSet rs_cus = new RecordSet();
String custompage4Emoble = "";
rs_cus.executeSql("select custompage4Emoble from workflow_base where id = "+Util.getIntValue(workflowid));
if(rs_cus.next()){
    custompage4Emoble = Util.null2String(rs_cus.getString("custompage4Emoble")).trim();
}
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
</body></html>
