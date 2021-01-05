
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SignRecord" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.BaseBean" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<jsp:useBean id="RequestLogOperateName" class="weaver.workflow.request.RequestLogOperateName" scope="page"/>
<jsp:useBean id="remarkRight" class="weaver.workflow.request.RequestRemarkRight" scope="page" />
<jsp:useBean id="WorkflowVersion" class="weaver.workflow.workflow.WorkflowVersion" scope="page" />

<%@ page import="weaver.odoc.workflow.workflow.beans.FormSignatueConfigInfo" %>
<%@ page import="weaver.odoc.workflow.workflow.beans.ShortCutButtonConfigInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormSignatureConfigUtil" class="weaver.odoc.workflow.workflow.utils.FormSignatureConfigUtil" scope="page" />
<%

int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int languageidfromrequest = Util.getIntValue(request.getParameter("languageid"));
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"), 0);
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();
String ismultiprintmode = Util.null2String(session.getAttribute(userid + "" + requestid+ "ismultiprintmode"));
//System.out.println("----38-signmore---userid---"+userid);
//int userid = Util.getIntValue(request.getParameter("userid"), 0);
boolean isprint = Util.null2String(request.getParameter("isprint")).equalsIgnoreCase("true");
boolean isworkflowhtmldoc = Util.null2String(request.getParameter("isworkflowhtmldoc")).equalsIgnoreCase("1");
String isOldWf = Util.null2String(request.getParameter("isOldWf"));
String viewLogIds = Util.null2String(request.getParameter("viewLogIds"));
String orderbytype = Util.null2String(request.getParameter("orderbytype"));
int creatorNodeId = Util.getIntValue(Util.null2String(request.getParameter("creatorNodeId")));
String txstatus = Util.null2String(request.getParameter("txstatus"));
String isHideInput = Util.null2String(request.getParameter("isHideInput"));
//是否流程督办
int urger = Util.getIntValue(request.getParameter("urger"),0);
//是否流程柑橘
int isintervenor = Util.getIntValue(request.getParameter("isintervenor"),0);

boolean loadbyuser = Boolean.parseBoolean(request.getParameter("loadbyuser"));

if (loadbyuser) {
	RecordSetLog.executeSql("SELECT nodeid FROM workflow_currentoperator WHERE requestid="+requestid+" AND userid="+userid+" ORDER BY receivedate desc,receivetime DESC");
	if(RecordSetLog.next()){
		String viewNodeId = RecordSetLog.getString("nodeid");
	    RecordSetLog.executeSql("SELECT viewnodeids FROM workflow_flownode WHERE workflowid="+workflowid+" AND nodeid="+viewNodeId);
	    String viewnodeids = "-1";
	    if (RecordSetLog.next()) {
	    	viewnodeids = RecordSetLog.getString("viewnodeids");
	    }
	    if ("-1".equals(viewnodeids)) {//全部查看
	        RecordSetLog.executeSql("SELECT nodeid FROM workflow_flownode WHERE workflowid= "+workflowid+" AND EXISTS(SELECT 1 FROM workflow_nodebase WHERE id=workflow_flownode.nodeid AND (requestid IS NULL OR requestid="+ requestid + "))");
	        while (RecordSetLog.next()) {
	        	viewLogIds += "," + RecordSetLog.getString("nodeid");
	        }
	    } else if (viewnodeids == null || "".equals(viewnodeids)) {//全部不能查看
	    } else {//查看部分
	    	viewLogIds += "," + viewnodeids;
	    }
	}
}

String initUser="";

//页面是否有表单签章，有的话，取消引用按钮
String isFormSignature = Util.null2String(request.getParameter("isFormSignature"));

//获取签字意见字段控制信息
String signfieldids="";
SignRecord.executeSql("select signfieldids from workflow_flownode where workflowid="+workflowid+" and nodeid="+creatorNodeId);
if(SignRecord.next()){
 signfieldids=Util.null2String(SignRecord.getString("signfieldids"));
}


//转发引用权限
int forward=Util.getIntValue(Util.null2String(request.getParameter("forward")), 0);
int submit=Util.getIntValue(Util.null2String(request.getParameter("submit")), 0);
//int forward=1;
//int submit=1;

String pgflag = Util.null2String(request.getParameter("pgnumber"));
String maxrequestlogid = Util.null2String(request.getParameter("maxrequestlogid"));
int pgnumber = Util.getIntValue(pgflag);
int wfsignlddtcnt = Util.getIntValue(request.getParameter("wfsignlddtcnt"), 0);
boolean isOldWf_ = false;
if(isOldWf.trim().equals("true")) isOldWf_=true;
User user2 = HrmUserVarify.getUser(request, response);
if (user2 == null)
	return;


String orderby = "desc";
String imgline="<img src=\"/images/xp/L_wev8.png\">";
if("2".equals(orderbytype))
{
	orderby = "asc";
    imgline="<img src=\"/images/xp/L1_wev8.png\">";
}
WFLinkInfo.setRequest(request);
WFLinkInfo.setIsprint(isprint);
ArrayList log_loglist = null;
//获取高级查询的条件


String sqlwhere=WFLinkInfo.getRequestLogSearchConditionStr();
//节点签字意见权限控制
String sqlcondition = remarkRight.getRightCondition(requestid,workflowid,userid);
sqlwhere += sqlcondition;

StringBuffer sbfmaxrequestlogid = new StringBuffer(maxrequestlogid);
if ("-1".equals(maxrequestlogid)) {
    sbfmaxrequestlogid=WFLinkInfo.getMaxLogid(requestid,workflowid,viewLogIds,orderby, wfsignlddtcnt, pgnumber, sqlwhere);
}

//System.out.println("sbfmaxrequestlogid1:"+sbfmaxrequestlogid);
if (pgflag == null || pgflag.equals("")) {
	log_loglist = WFLinkInfo.getRequestLog(requestid,workflowid,viewLogIds,orderby,sqlcondition);
} else {
//	wfsignlddtcnt=2;
	log_loglist = WFLinkInfo.getRequestLog(requestid,workflowid,viewLogIds,orderby, wfsignlddtcnt, sbfmaxrequestlogid, sqlwhere);
}
//System.out.println("log_loglist=" + log_loglist);
boolean isLight = false;
int nLogCount=0;
String lineNTdOne="";
String lineNTdTwo="";
int log_branchenodeid=0;
String log_tempvalue="";
int tempRequestLogId=0;
int tempImageFileId=0;
%>

<%!
 private String script2Empty(String pagestr) {
    String retrunstr = "";
    int startindx = pagestr.toLowerCase().indexOf("<script");
    int endindx = pagestr.toLowerCase().indexOf("</script>");
    while(startindx != -1 && endindx != -1 && endindx > startindx){
        retrunstr += pagestr.substring(0, startindx);
        pagestr = pagestr.substring(endindx + 9);
        
        startindx = pagestr.toLowerCase().indexOf("<script");
        endindx = pagestr.toLowerCase().indexOf("</script>");
    }
	retrunstr+=pagestr;
	retrunstr = retrunstr.replaceAll(" ", "");
	return retrunstr;
 }
%>

<%if (pgflag == null || pgflag.equals("")) {  %>
<table class=liststyle cellspacing=1>
    <colgroup>
    <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    <tbody>
<%} else {
	int currentPageCnt = log_loglist.size();
	int allItems=WFLinkInfo.getRequestLogTotalCount(requestid,workflowid,viewLogIds,sqlwhere);
	
	int allPages=(allItems+wfsignlddtcnt-1)/wfsignlddtcnt;
	if(allPages==0){
		allPages=1;
	}
	out.print("<input type=\"hidden\" name=\"currentPageCnt" + pgnumber + "\" value=\"" + currentPageCnt + "\">");
	out.print("<input type=\"hidden\" name=\"allItems" + pgnumber + "\" value=\"" + allItems + "\">");
	out.print("<input type=\"hidden\" name=\"allPages" + pgnumber + "\" value=\"" + allPages + "\">");
	out.print("<input type=\"hidden\" name=\"maxrequestlogid" + pgnumber + "\" value=\"" + sbfmaxrequestlogid.toString() + "\">");
	if (log_loglist == null || log_loglist.isEmpty()) {
		out.print("<requestlognodata>");
		return;
	}
}
%>

<%
		/*是否有转发权限的判断*/
		/**
		int usertype = 0;   //用户在工作流表中的类型 0: 内部 1: 外部
		String logintype = user2.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
		if(logintype.equals("1")) usertype = 0;
		if(logintype.equals("2")) usertype = 1;
		int isremark = -1 ;  //当前操作状态


		// 当前用户表中该请求对应的信息 isremark为0为当前操作者, isremark为1为当前被转发者,isremark为2为可跟踪查看者


		RecordSetlog3.executeSql("select isremark from workflow_currentoperator where (isremark<8 or isremark>8) and requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by isremark");
		while(RecordSetlog3.next())	{
			 int tempisremark = Util.getIntValue(RecordSetlog3.getString("isremark"),0) ;
			 if( tempisremark == 0 || tempisremark == 1 || tempisremark == 5 || tempisremark == 9|| tempisremark == 7) {  
				 // 当前操作者或被转发者


				isremark = tempisremark ;
				break ;
			 }
		}
		boolean wfmonitor="true".equals(session.getAttribute(userid+"_"+requestid+"wfmonitor"))?true:false;  //流程监控人


		String fromPDA= Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录

		String IsPendingForward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsPendingForward"));
		String IsBeForwardTodo=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForwardTodo"));
		String IsBeForwardSubmitAlready=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForwardSubmitAlready"));
		String IsBeForwardSubmitNotaries=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForwardSubmitNotaries"));
		String IsFromWFRemark_T=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsFromWFRemark_T"));
		boolean canForwd = false;
		if(("0".equals(IsFromWFRemark_T) && "1".equals(IsBeForwardTodo)) || "1".equals(IsFromWFRemark_T) && "1".equals(IsBeForwardSubmitAlready) || ("2".equals(IsFromWFRemark_T) && "1".equals(IsBeForwardSubmitNotaries))){
			canForwd = true;
		}
		//System.out.println("canForwd:"+canForwd);
		//System.out.println("isremark:"+isremark);
		//System.out.println("IsPendingForward:"+IsPendingForward);
		//System.out.println("fromPDA:"+fromPDA);
		//System.out.println("wfmonitor:"+wfmonitor);
		//String forwardName="";
		if(!fromPDA.equals("1") && !wfmonitor) {  //pda登录,流程监控不要菜单
			
		}
		forwardName = SystemEnv.getHtmlLabelName(6011,user2.getLanguage());
		**/
%>

<%
for(int i=0;i<log_loglist.size();i++)
{
    Hashtable htlog=(Hashtable)log_loglist.get(i);
    int log_isbranche=Util.getIntValue((String)htlog.get("isbranche"),0);
    int log_nodeid=Util.getIntValue((String)htlog.get("nodeid"),0);
    int log_nodeattribute=Util.getIntValue((String)htlog.get("nodeattribute"),0);
    String log_nodename=Util.null2String((String)htlog.get("nodename"));
    int log_destnodeid=Util.getIntValue((String)htlog.get("destnodeid"));
    String log_remark=Util.null2String((String)htlog.get("remark"));
    String log_operatortype=Util.null2String((String)htlog.get("operatortype"));
    String log_operator=Util.null2String((String)htlog.get("operator"));
    String log_agenttype=Util.null2String((String)htlog.get("agenttype"));
    String log_agentorbyagentid=Util.null2String((String)htlog.get("agentorbyagentid"));
    String log_operatedate=Util.null2String((String)htlog.get("operatedate"));
    String log_operatetime=Util.null2String((String)htlog.get("operatetime"));
    String log_logtype=Util.null2String((String)htlog.get("logtype"));
    String log_receivedPersons=Util.null2String((String)htlog.get("receivedPersons"));
    String log_receivedPersonids=Util.null2String((String)htlog.get("receivedPersonids"));
    tempRequestLogId=Util.getIntValue((String)htlog.get("logid"),0);
    String log_annexdocids=Util.null2String((String)htlog.get("annexdocids"));
    String log_operatorDept=Util.null2String((String)htlog.get("operatorDept"));
    String log_signdocids=Util.null2String((String)htlog.get("signdocids"));
    String log_signworkflowids=Util.null2String((String)htlog.get("signworkflowids"));
    
    String log_remarkHtml = Util.null2String((String)htlog.get("remarkHtml"));

    String log_iframeId = Util.null2String((String)htlog.get("iframeId"));	
    
    rs.writeLog("WorkflowViewSignMore.jsp  workflowId="+workflowid+",log_nodeid="+log_nodeid);
    FormSignatueConfigInfo formSignatueConfig = FormSignatureConfigUtil.getFormSignatureConfig(workflowid,log_nodeid,user);
    rs.executeQuery("select isFormSignature from workflow_flownode where workflowId=? and nodeId=?", workflowid, log_nodeid);
    boolean autoSizeFlag = rs.next() && "1".equals(rs.getString("isFormSignature")) && formSignatueConfig.isAutoResizeSignImage();
    
    if (pgflag == null || pgflag.equals("")) {
	    if(log_loglist.size()>10)
	    {
	    	if(i<10)
	    	{
	    		continue;
	    	}
	    }
    } 
    String log_nodeimg="";
    if(log_tempvalue.equals(log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime)){
        log_branchenodeid=0;
    }else{
        log_tempvalue=log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime;
    }
    /*
    if(log_nodeattribute==1&&(log_logtype.equals("0")||log_logtype.equals("2"))&&log_branchenodeid==0){
        log_nodeimg=imgline;
        log_branchenodeid=log_nodeid;
    }
    if(log_isbranche==1){
        log_nodeimg="<img src=\"/images/xp/T_wev8.png\">";
        log_branchenodeid=0;
    }
    */
    log_nodeimg = "";
    log_branchenodeid=log_nodeid;
    
	tempImageFileId=0;
	if(tempRequestLogId>0)
	{
		RecordSetlog3.executeSql("select imageFileId from Workflow_FormSignRemark where requestLogId="+tempRequestLogId);
		if(RecordSetlog3.next())
		{
			tempImageFileId=Util.getIntValue(RecordSetlog3.getString("imageFileId"),0);
		}
	}

	lineNTdOne="line"+String.valueOf(nLogCount)+"TdOne";
    if(log_isbranche==0&&"2".equals(orderbytype)) isLight = !isLight;
	String img_path=ResourceComInfo.getMessagerUrls(log_operator);
	
	
	String operatorDepartInfo = "";
	
	String bodydivid = "babysays" +tempRequestLogId+ new Date().getTime();
%>
    <table class='liststyle liststyle1' cellspacing=0 style="margin:0;width:100%;">
    	<colgroup>
    		<col width='10%'>
    		<col width='50%'>
    		<col width='10%'>  
    		<col width='30%'>
    	</colgroup>
    	<tbody>
		  <tr height="20px" onclick="jQuery('.singleSignTbl').trigger('click');"  onmouseover="thisSignForB('<%="quote"+i%>',true,this)" onmouseout="thisSignForB('<%="quote"+i%>',false,this)">
		  	<td colspan="2" style="background:#ffffff;">
		  	</td>
		  </tr>
		  <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark  <%}%> onmouseover="showQuote('<%="quote"+i%>',true,this)" onmouseout="showQuote('<%="quote"+i%>',false,this)">
			<td colspan="4" style="">
			<table style="background:#fff"  width="100%" border="0" cellspacing="0" cellpadding="0" class="singleSignTbl" onmouseover="showquoteandtransto(this)" onmouseout="hidequoteandtransto(this)">
			  <tr style=" vertical-align: top;">
			    <td width="27px" >&nbsp;</td>
			    
			    <td width="40px" align="left" class="userheadimg" style="background-color: transparent !important; border-bottom:1px solid #e7e7e7;<%if(txstatus.equals("0")){%>display:none<%}%>"> 
			    	<!-- 人员头像 -->
					<div style="margin-top: 5px;">
						<%if("".equals(signfieldids)||signfieldids.contains("0")){%>
							<!-- <img src="<%=img_path%>" style="width:30px;height:30px;border-radius:20px;"/> -->
							<%=weaver.hrm.User.getUserIcon(log_operator) %>
						<%}%>
					</div>
			    </td>
			  
			    <td width="160px" align="left" style="color:#099cff;border-bottom:1px solid #e7e7e7;">
			    	<div style="width:100px;">
			    	<!-- 人员姓名 START -->
					<span>
					<%
						BaseBean wfsbean=FieldInfo.getWfsbean();
						int showimg = Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","showimg"),0);
                        rssign.execute("select * from DocSignature  where sealType=1 and hrmresid=" + log_operator + "order by markid");
						String userimg = "";
						boolean isexsAgent = false;
						boolean isinneruser = true;
						String displayid = "";
						String displayname = "";
						String displaydepid = "";
						String displaydepname = "";
						String displaybyagentid = "";
						String displaybyagentname = "";
						String displaybyagentdepid = "";
						String displaybyagentdepname = "";
						if(!userimg.equals("") && "0".equals(log_operatortype)){
					%>
						<img id=markImg src="<%=userimg%>" ></img>
					<%
						} else {
							  if (isOldWf_) {
							       if (log_operatortype.equals("0")) {
							                if (isprint == false) {
							                        if (!"0".equals(Util.null2String(log_operatorDept)) && !"".equals(Util.null2String(log_operatorDept))) {
							                                displaydepid = Util.toScreen(log_operatorDept, languageidfromrequest);
							                                displaydepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept), languageidfromrequest);

							                            }
							                            displayid = log_operator;
							                            displayname = Util.toScreen(ResourceComInfo.getResourcename(log_operator), languageidfromrequest);

							                        } else {
							                            if (!"0".equals(Util.null2String(log_operatorDept)) && !"".equals(Util.null2String(log_operatorDept))) {
							                                displaydepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept), languageidfromrequest);
							                            }
							                            displayname = Util.toScreen(ResourceComInfo.getResourcename(log_operator), languageidfromrequest);
							                        }

							                    } else if (log_operatortype.equals("1")) {
							                        isinneruser = false;
							                        if (isprint == false) {
							                            displayid = log_operator;
							                            displayname = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator), languageidfromrequest);
							                        } else {

							                            if (!"0".equals(Util.null2String(log_operatorDept)) && !"".equals(Util.null2String(log_operatorDept))) {

							                                displaydepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept), languageidfromrequest);
							                            }

							                            displayname = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator), languageidfromrequest);
							                        }
							                    } else {
							                        displayname = SystemEnv.getHtmlLabelName(468, languageidfromrequest);
							                    }

							                } else {
							                    if (log_operatortype.equals("0")) {
							                        if (isprint == false) {
							                            if (!log_agenttype.equals("2")) {
							                                if (!"0".equals(Util.null2String(log_operatorDept)) && !"".equals(Util.null2String(log_operatorDept))) {
							                                    displaydepid = Util.toScreen(log_operatorDept, languageidfromrequest);
							                                    displaydepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept), languageidfromrequest);
							                                }
							                                displayid = log_operator;
							                                displayname = Util.toScreen(ResourceComInfo.getResourcename(log_operator), languageidfromrequest);
							                            } else if (log_agenttype.equals("2") || log_agenttype.equals("1")) {

							                                //if (! ("" + log_nodeid).equals(String.valueOf(creatorNodeId))) {
							                                if(true){
							                                    isexsAgent = true;
							                                    if (!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid))) && !"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))) {
							                                        displaybyagentdepid = Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid), languageidfromrequest);
							                                        displaybyagentdepname = Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)), languageidfromrequest);
							                                    }
							                                    displaybyagentid = log_agentorbyagentid;
							                                    displaybyagentname = Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid), languageidfromrequest);

							                                    if (!"0".equals(Util.null2String(log_operatorDept)) && !"".equals(Util.null2String(log_operatorDept))) {

							                                        displaydepid = Util.toScreen(log_operatorDept, languageidfromrequest);
							                                        displaydepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept), languageidfromrequest);

							                                    }
							                                    displayid = log_operator;
							                                    displayname = Util.toScreen(ResourceComInfo.getResourcename(log_operator), languageidfromrequest);

							                                } else { // 创造节点log,
							                                    // 如果设置代理时选中了代理流程创建,同时代理人本身对该流程就具有创建权限,那么该代理人创建节点的log不体现代理关系
																String tempAllwfids = WorkflowVersion.getAllVersionStringByWFIDs(workflowid+"");

							                                    String agentCheckSql = " select * from workflow_agentConditionSet where workflowId in(" + tempAllwfids + ") and isCreateAgenter='1' and bagentuid=" + log_agentorbyagentid + " and agenttype = '1' " + " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" + " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11, 19) + "' ) ) " + " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" + " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" + " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11, 19) + "' ) ) " + " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null) order by agentbatch asc  ,id asc ";
							                                    RecordSetlog3.executeSql(agentCheckSql);
							                                    if (!RecordSetlog3.next()) {
							                                        if (!"0".equals(Util.null2String(log_operatorDept)) && !"".equals(Util.null2String(log_operatorDept))) {
							                                            displaydepid = Util.toScreen(log_operatorDept, languageidfromrequest);
							                                            displaydepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept), languageidfromrequest);

							                                        }
							                                        displayid = log_operator;
							                                        displayname = Util.toScreen(ResourceComInfo.getResourcename(log_operator), languageidfromrequest);
							                                    } else {
							                                        String isCreator = RecordSetlog3.getString("isCreateAgenter");

							                                        if (!isCreator.equals("1")) {
							                                            if (!"0".equals(Util.null2String(log_operatorDept)) && !"".equals(Util.null2String(log_operatorDept))) {
							                                                displaydepid = Util.toScreen(log_operatorDept, languageidfromrequest);
							                                                displaydepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept), languageidfromrequest);

							                                            }
							                                            displayid = log_operator;
							                                            displayname = Util.toScreen(ResourceComInfo.getResourcename(log_operator), languageidfromrequest);
							                                        } else {

							                                            int userLevelUp = -1;
							                                            int uesrLevelTo = -1;
							                                            int secLevel = -1;
							                                            rsCheckUserCreater.executeSql("select seclevel from HrmResource where id = " + log_operator);
							                                            if (rsCheckUserCreater.next()) {
							                                                secLevel = rsCheckUserCreater.getInt("seclevel ");
							                                            } else {
							                                                rsCheckUserCreater.executeSql("select seclevel from HrmResourceManager where id = " + log_operator);
							                                                if (rsCheckUserCreater.next()) {
							                                                    secLevel = rsCheckUserCreater.getInt("seclevel ");
							                                                }
							                                            }

							                                            // 是否有此流程的创建权限(代理)
							                                            boolean haswfcreate = new weaver.share.ShareManager().hasWfCreatePermission(HrmUserVarify.getUser(request, response), workflowid);;
							                                            if (!log_agenttype.equals("2")) {
							                                                if (!"0 ".equals(Util.null2String(log_operatorDept)) && !"".equals(Util.null2String(log_operatorDept))) {

							                                                    displaydepid = Util.toScreen(log_operatorDept, languageidfromrequest);
							                                                    displaydepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept), languageidfromrequest);
							                                                }
							                                                displayid = log_operator;
							                                                displayname = Util.toScreen(ResourceComInfo.getResourcename(log_operator), languageidfromrequest);
							                                            } else {
							                                                isexsAgent = true;
							                                                if (!"0 ".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid))) && !"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))) {

							                                                    displaybyagentdepid = Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid), languageidfromrequest);
							                                                    displaybyagentdepname = Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)), languageidfromrequest);
							                                                }
							                                                displaybyagentid = log_agentorbyagentid;
							                                                displaybyagentname = Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid), languageidfromrequest) + SystemEnv.getHtmlLabelName(24214, languageidfromrequest);

							                                                if (!"0 ".equals(Util.null2String(log_operatorDept)) && !"".equals(Util.null2String(log_operatorDept))) {

							                                                    displaydepid = Util.toScreen(log_operatorDept, languageidfromrequest);
							                                                    displaydepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept), languageidfromrequest);

							                                                }
							                                                displayid = log_operator;
							                                                displayname = Util.toScreen(ResourceComInfo.getResourcename(log_operator), languageidfromrequest);
							                                            }
							                                        }

							                                    }
							                                }
							                            } else {}
							                        } else {
							                            if (!log_agenttype.equals("2")) {
							                                if (!"0 ".equals(Util.null2String(log_operatorDept)) && !"".equals(Util.null2String(log_operatorDept))) {
							                                    displaydepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept), languageidfromrequest);
							                                }
							                                displayname = Util.toScreen(ResourceComInfo.getResourcename(log_operator), languageidfromrequest);

							                            } else if (log_agenttype.equals("2")) {
							                                isexsAgent = true;
							                                if (!"0 ".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid))) && !"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))) {
							                                    displaybyagentdepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_agentorbyagentid), languageidfromrequest);
							                                }
							                                displaybyagentname = Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest);
							                               
							                                if(!"0 ".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){
							                                    displaydepname  = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest);
							                                }

							                                displayname  = Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest);
							                            } else{}
							                            
							                        }
							                    } else if(log_operatortype.equals("1")){
						                            isinneruser = false;
								                    if(isprint==false){
								                        displayid = log_operator;
								                        displayname  = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),languageidfromrequest);
								                    }else{
								                        displayname  = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),languageidfromrequest);
								                    }
								                }else{
								                    displayname = SystemEnv.getHtmlLabelName(468,languageidfromrequest);
								                }
							                }
										} 
										%>
										
										<%
										if (isexsAgent) {
										%>
										    <FONT color="#099cff">
										    <A id="useragent_<%=log_iframeId%>" href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);' style="color:#099cff" ><%=displaybyagentname%></A>
										    -></FONT>
										<%
										}
										%>
										<div style="height:1px;"></div>
										
										
										<%
										if (!"".equals(displayid)){
										   //判断姓名是否显示
										   if("".equals(signfieldids)||signfieldids.contains("1")){
										     if (isinneruser) { %>
												<a id="user_<%=log_iframeId%>" href="javaScript:openhrm(<%=displayid %>);" onclick='pointerXY(event);' style='color:#099cff'>
													<%=displayname %>
												</a>
										    	<input type="hidden" name="displayid" value="<%=displayid %>">
										     <%} else { %>
										        <a id="user_<%=log_iframeId%>" href="/CRM/data/ViewCustomer.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&CustomerID=<%=displayid %>&requestid=<%=requestid%>" style='color:#099cff'>
										        	<%=displayname %>
										        </a>
										        <input type="hidden" name="displayid" value="<%=displayid %>">
										      <%
										       }
										   }
										} else { 
										%>
										    <%=displayname %>
										<%
										}
										%>
								
								
						
								</div>
							<!-- 人员姓名 END -->
							<!-- 操作人部门信息 -->
									<%if("".equals(signfieldids)||signfieldids.contains("3")){%>
										<%
										if (!"".equals(displaydepid)) {
										%>
											<p><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=displaydepid %>" target="_Blank" class="department_href"><%=displaydepname %></a></p>
										<%
										} else {%>
											<%=displaydepname %>
										<%
										} %>
										<%=
										    operatorDepartInfo
										%>
									<%}%>
			    </td>
			    <td name="signContentTd"  style="background-color: transparent !important; color:#323232;border-bottom:1px solid #e7e7e7;word-wrap:break-all;word-break:break-all;">
			    <span>
			    	            <!--签字意见-->
										<%

										    String _resvcss_Mrgtop = "3px";
											if(!log_logtype.equals("t")) {
												if(tempRequestLogId>0&&tempImageFileId>0) {
												if(isprint || autoSizeFlag) {
											%>
													
												<jsp:include page="/workflow/request/WorkflowLoadSingnatureImg.jsp">
													<jsp:param name="tempImageFileId" value="<%=tempImageFileId%>" />
												</jsp:include>
											<%
                                                    } else {	
											%>
												<jsp:include page="/workflow/request/WorkflowLoadSignatureRequestLogId.jsp">
													<jsp:param name="tempRequestLogId" value="<%=tempRequestLogId%>" />
												</jsp:include>
											<%
                                                    }
												} else {													  
	  				
	 if(log_remarkHtml.indexOf("f_weaver_belongto_userid")>-1 && log_remarkHtml.indexOf("f_weaver_belongto_usertype")>-1){
		 String b = log_remarkHtml.substring(log_remarkHtml.indexOf("f_weaver_belongto_userid"),log_remarkHtml.indexOf("f_weaver_belongto_usertype"));
		 log_remarkHtml = log_remarkHtml.replace(b,"f_weaver_belongto_userid="+f_weaver_belongto_userid+"&");
	  }
	  if(log_remarkHtml.indexOf("docs/docs/DocDsp.jsp?")>-1){
		 String c = log_remarkHtml.substring(log_remarkHtml.indexOf("docs/docs/DocDsp.jsp?"),log_remarkHtml.indexOf("DocDsp.jsp?")+11);
		 log_remarkHtml = log_remarkHtml.replace(c,"docs/docs/DocDsp.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&");
	  }
	  //流程签字意见内容中附件  
	  log_remarkHtml = log_remarkHtml.replace("desrequestid=0","desrequestid="+desrequestid);
	  log_remarkHtml = log_remarkHtml.replace("requestid=-1","requestid="+requestid);
	  
	  if(log_remarkHtml.indexOf("<img")>-1){
			///////////
		  	String begin_logRemark = "";
		  	String new_logRemark = "";
		  	String end_logRemark = "";
		  	String cycleString = log_remarkHtml;
		  	int f = 0;
			while(cycleString.indexOf("<img") > -1 ){
				f++;
			  	int b = cycleString.indexOf("<img");
			  	begin_logRemark = cycleString.substring(0,b);
			  	new_logRemark += begin_logRemark;
				cycleString = cycleString.substring(b);
				String imgString = "";
				int e = cycleString.indexOf("/>");
				imgString = cycleString.substring(0, e);
			    if(isworkflowhtmldoc){
			    	new_logRemark += "<a>" + imgString + " onload=\"parent.image_resize(this,'"+log_iframeId+"');\" onresize=\"parent.image_resize(this,'"+log_iframeId+"');\" /> </a>" ;
			    }else{
					new_logRemark += "<div class=\"small_pic\"><a pichref=\"pic_one"+f+"\" style=\"cursor:url('/images/preview/amplification_wev8.png'),auto;color:white!important;\" title=\""+SystemEnv.getHtmlLabelName(129381, user.getLanguage())+"\" >" + imgString + " onload=\"parent.image_resize(this,'"+log_iframeId+"');\" onresize=\"parent.image_resize(this,'"+log_iframeId+"');\" /> </a></div><div id=\"pic_one"+f+"\" style=\"display:none;\">" + imgString +" class=\"maxImg\" /></div>" ;
			    }
				cycleString = cycleString.substring(e+2);
				end_logRemark = cycleString;
			}
			new_logRemark += end_logRemark;
			log_remarkHtml = new_logRemark;
		  	///////////
	  	}
	  if(isprint && log_remark.indexOf("<img")>-1){		//打印使用的是log_remark，也需要处理img
			///////////
		  	String begin_logRemark = "";
		  	String new_logRemark = "";
		  	String end_logRemark = "";
		  	String cycleString = log_remark;
		  	int f = 0;
			while(cycleString.indexOf("<img") > -1 ){
				f++;
			  	int b = cycleString.indexOf("<img");
			  	begin_logRemark = cycleString.substring(0,b);
			  	new_logRemark += begin_logRemark;
				cycleString = cycleString.substring(b);
				String imgString = "";
				int e = cycleString.indexOf("/>");
				imgString = cycleString.substring(0, e);
				new_logRemark += "<div class=\"small_pic\">" + imgString + " onload=\"image_resize(this,'"+log_iframeId+"');\" onresize=\"image_resize(this,'"+log_iframeId+"');\" /></div><div id=\"pic_one"+f+"\" style=\"display:none;\">" + imgString +" class=\"maxImg\" /></div>" ;
				cycleString = cycleString.substring(e+2);
				end_logRemark = cycleString;
			}
			new_logRemark += end_logRemark;
			log_remark = new_logRemark;
	  	}
  
													String tempremark = log_remark;
													tempremark = Util.StringReplace(tempremark,"&lt;br&gt;","<br>");
													if (!"".equals(tempremark) && isprint) {
													    tempremark += "<br>";
													}
													//System.out.println("tempremark = "+tempremark);
											%>
											
													<%=Util.StringReplace(tempremark,"&nbsp;"," ")%>
												
												
												<%
												if (pgflag != null && !pgflag.equals("")) {
													//System.out.println("进入签章:");

												%>
												   
												    
													<script type="text/javascript">
													try {
														 setIframeContent("<%=log_iframeId %>", "<%=script2Empty(log_remarkHtml).replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "").replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")%>",document.getElementById("<%=log_iframeId%>").contentWindow.document);
														 bodyresize(document.getElementById("<%=log_iframeId%>").contentWindow.document, "<%=log_iframeId%>", 1);
														 //alert(bodyresize(document.getElementById("<%=log_iframeId%>").contentWindow.document, "<%=log_iframeId%>", 1));
														 //alert(document.getElementById("<%=log_iframeId%>").contentWindow.document);
													} catch(e) {
													}
													</script>
												<%
												}
												%>
											<%
												}
											%>
										 <%
										 } else {
										     
										     _resvcss_Mrgtop = "-2px";
										     String _divhgt = "16px";
										     
										     String _isIE = (String)session.getAttribute("browser_isie");
										     if ("true".equals(_isIE)) {
										         _divhgt = "15px";
										     }
										     %>
										     <div style="height:<%=_divhgt %>!important;width:1px;"></div>
										     <%
										 }
										%>

											<!--相关文件-->
											
											<%
											 if(!log_annexdocids.equals("")||!log_signdocids.equals("")||!log_signworkflowids.equals(""))
												 {
													if(!log_signdocids.equals(""))
													{
														RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_signdocids+") order by id asc");
														int linknum=-1;
														while(RecordSetlog3.next())
														{
														  linknum++;
														  if(linknum==0)
														  {													
															%>
															    <span style="line-height:26px;">
																<img title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>" src="/images/sign/wd_wev8.png" style="line-height:26px;vertical-align:middle;">&nbsp;&nbsp;
															<%
														  }else{
															%>
																<span style="line-height:26px;">
																<span style="line-height:26px;vertical-align:middle;padding-left:19px;"></span>&nbsp;&nbsp;
															<% 
														  }
														  String showid = Util.null2String(RecordSetlog3.getString(1)) ;
														  String tempshowname= Util.toScreen(RecordSetlog3.getString(2),languageidfromrequest) ;
												  			%>					
															<a class="wffbtn" onmouseover="wfbtnOver(this)" onmouseout="wfbtnOut(this)" style="line-height:26px;cursor:pointer;color:#123885;" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')" title="<%=tempshowname%>"><%=tempshowname%></a>
									                        </span>
									                        <br>
												<%
														}
												%>
							
							
												<%
													}
													ArrayList tempwflists=Util.TokenizerString(log_signworkflowids,",");
													int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
													for(int k=0;k<tempwflists.size();k++)
													{
													  if(k==0)
													  {
														%>
														<span style="line-height:26px;">
														<img title="<%=SystemEnv.getHtmlLabelName(22105,user.getLanguage())%>" src="/images/sign/wf_wev8.png" style="line-height:26px;vertical-align: middle;">&nbsp;&nbsp;
														<%												 
													  }else{
														  %>
														<span style="line-height:26px;">
														<span style="line-height:26px;vertical-align: middle;opacity:0;padding-left:19px;"></span>&nbsp;&nbsp;		
														  <%
													  }
													  tempnum++;
													  session.setAttribute("resrequestid" + tempnum, "" + tempwflists.get(k));                
													  String temprequestname="<a class=\"wffbtn\" style=\"line-height:26px;cursor:pointer;color:#123885;\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&isrequest=1&requestid="+tempwflists.get(k)+"&wflinkno="+tempnum+"')\" title=" + wfrequestcominfo.getRequestName((String)tempwflists.get(k)) + ">"+wfrequestcominfo.getRequestName((String)tempwflists.get(k))+"</a>";
												%>
												  				
													<%=temprequestname%>
													</span>
													<br>
												  <%
												}
												 %>
													

												 <%
												session.setAttribute("slinkwfnum", "" + tempnum);
												session.setAttribute("haslinkworkflow", "1");
												if(!log_annexdocids.equals("")){
												RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_annexdocids+") order by id asc");
												int linknum=-1;
												%>			
												 <span style="line-height:26px;">							
												 <img title="<%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>" src="/images/sign/fj_wev8.png"  style="line-height:26px;vertical-align: middle;">&nbsp;&nbsp;		
												<%
												while(RecordSetlog3.next()){
												  %>
												  <%if(linknum!=-1){%>
												  	<span style="line-height:26px;">
												  	<span style="line-height:26px;vertical-align: middle;opacity:0;padding-left:19px;"></span>&nbsp;&nbsp;
												  <%}%>
											        
												  <%
												  linknum++;
												  if(linknum==0){
													  %>
													  <!-- 
													  <%=SystemEnv.getHtmlLabelName(22194,languageidfromrequest)%>：


													   -->
													  <%
												  }
												  String showid = Util.null2String(RecordSetlog3.getString(1)) ;
												  String tempshowname= Util.toScreen(RecordSetlog3.getString(2),languageidfromrequest) ;
												  int accessoryCount=RecordSetlog3.getInt(3);
												  String SecCategory=Util.null2String(RecordSetlog3.getString(4));
												  DocImageManager.resetParameter();
												  DocImageManager.setDocid(Util.getIntValue(showid));
												  DocImageManager.selectDocImageInfo();
		
												  String docImagefilename = "";
												  String fileExtendName = "";
												  String docImagefileid = "";
												  int versionId = 0;
												  long docImagefileSize = 0;
												  if(DocImageManager.next()){
													//DocImageManager会得到doc第一个附件的最新版本


													docImagefilename = DocImageManager.getImagefilename();
													fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
													docImagefileid = DocImageManager.getImagefileid();
													docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
													versionId = DocImageManager.getVersionId();
												  }
												 if(accessoryCount>1){
												   fileExtendName ="htm";
												 }
												  String imgSrc= AttachFileUtil.getImgStrbyExtendName(fileExtendName,16);
												  boolean nodownload=SecCategoryComInfo1.getNoDownload(SecCategory).equals("1")?true:false;
												  %>
											
											      <span>
												  <%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx")||fileExtendName.equalsIgnoreCase("pdf"))){%>
													<a class="wffbtn" style="cursor:pointer;color:#123885;" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')" title="<%=docImagefilename%>" ><%=docImagefilename%></a>
												  <%}else{%>
													<a class="wffbtn" style="cursor:pointer;color:#123885;" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id=<%=showid%>&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')" title="<%=tempshowname%>"><%=tempshowname%>.<%=fileExtendName%></a>
												  <%}
												  
												  if(accessoryCount==1 &&!isprint&&((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){%>
											          &nbsp;&nbsp;<BUTTON class="wffbtn" accessKey=1 style="color:#123885;border:0px;line-height:20px;font-size:12px;padding:3px;background: #fff"  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>'); return false;" type="button">
														[<%=SystemEnv.getHtmlLabelName(258,languageidfromrequest)%>(<%=docImagefileSize/1024%>K)]
													  </BUTTON>
													 
												  <%}
												  %>
									              </span>
									              </span>
									              <br>									              
												  <%
												}%>

												  <%}}%>
												  
												  
								          <%
												    /*暂时启用 签章功能*/
                                                    if (showimg == 1 && rssign.next()) {
                                                        userimg = "/weaver/weaver.file.ImgFileDownload?userid=" + log_operator+"&sealType=1";
                                                    }
													if(!userimg.equals("") && "0".equals(log_operatortype)){
														%>
															<div align="right" style="padding-right: 0px;"><img id=markImg src="<%=userimg%>" ></img></div>
														<%
													}
												    %>
						
								<span class="showUsers" style="color:#7e7e7e;<%=isprint ? "display:inline-block;" : "overflow:hidden;float:left;" %>height:17px;margin-bottom: 20px;<%=(log_remarkHtml == null || "".equals(log_remarkHtml.trim())) ? "" : "margin-top:5px;" %>" id="<%=bodydivid%>">
									
									<%
										int showCount = 6;
										String[] initUsers=null;
										lineNTdTwo="line"+String.valueOf(nLogCount)+"TdTwo"+Util.getRandom();
										String tempStr ="";
										//log_logtype.equals("s") 不合并督办
										
										int destnodeidattr = 0 ;
										rssign.executeSql("select nodeattribute from workflow_nodebase where id="+log_destnodeid);
										if(rssign.next()){
											destnodeidattr = rssign.getInt(1); 
										}
										
										if(((log_nodeattribute!=2&&destnodeidattr==2) || log_nodeattribute==1)&&(log_logtype.equals("0")||log_logtype.equals("2")||log_logtype.equals("3")||log_logtype.equals("t"))){//分叉起始或者主干退回到分叉
											String[] _log_receivedPersons = WFLinkInfo.getForkStartReceivers(requestid,tempRequestLogId,log_nodeid,log_operatedate,log_operatetime,log_logtype);
											log_receivedPersons = _log_receivedPersons[0];
										}
										if(log_receivedPersons.length()>0) tempStr =Util.toScreen(log_receivedPersons.substring(0,log_receivedPersons.length()-1),languageidfromrequest);
										//if(log_receivedPersons.length()>0){
										//	String linkString = WFLinkInfo.getLinkString(requestid,log_receivedPersonids,log_operatortype,languageidfromrequest);
										//	tempStr =  Util.toScreen(linkString,languageidfromrequest);
										//}
										
										String showoperators="";
										try
										{
										showoperators=RequestDefaultComInfo.getShowoperator(""+userid);
										
										}
										catch (Exception eshows)
										{
										}
										if (!showoperators.equals("1") && false) {
											if(!"".equals(tempStr) && tempStr != null){
												 tempStr = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick=showallreceivedforsign('"+requestid+"','"+viewLogIds+"','"+log_operator+"','"+log_operatedate+"','"+log_operatetime+"','"+lineNTdTwo+"','"+log_logtype+"',"+log_destnodeid+")>"+SystemEnv.getHtmlLabelName(89,languageidfromrequest)+"</span>";
											}
										}
									   String initUser2 = tempStr;
									   initUsers = tempStr.split(",");
									   initUser = "";
								       if(initUsers.length>showCount){
								          for(int j=0;j<showCount;j++){
								        	  initUser+="," + initUsers[j];
								          }
								          if (initUser.length() > 1) {
								        	  initUser = initUser.substring(1);
								          }
								       }else{
								    	   initUser=tempStr;
								       }
								       
								       //如果是打印页面，则不隐藏接收人


								       if (isprint) {
								           initUser = initUser2;
								           showCount = Integer.MAX_VALUE;
								       }
									%>
									<span style="display:inline;color:#7e7e7e;word-break:break-all;word-wrap: break-word;">
										<%=SystemEnv.getHtmlLabelName(896,languageidfromrequest)%>：&nbsp;<%=initUser%>
									</span>
									<span style="display:inline;color:#7e7e7e;word-break:break-all;word-wrap: break-word;display:none">
										<%=SystemEnv.getHtmlLabelName(896,languageidfromrequest)%>：&nbsp;<%=initUser2%>
									</span>
								</span>
								<%if(initUsers.length>showCount){ %>
								<span><img title="<%=SystemEnv.getHtmlLabelName(84538,user.getLanguage())%>" class="toggleUserList" onclick="toggleUserList(this)" src="/images/sign/sign_zk_hot_wev8.png" style="cursor:pointer;padding-right: 0px;margin-top:<%=_resvcss_Mrgtop%>;vertical-align:middle;"></span>
								<%}%>
					</span>
			    </td>
			    <td width="50px" style="color:#9b9b9b;border-bottom:1px solid #e7e7e7;"></td>
			    <td width="210px" style="color:#9b9b9b;border-bottom:1px solid #e7e7e7;text-overflow:ellipsis;" align="left" title="<%=SystemEnv.getHtmlLabelName(84539,user.getLanguage())%>">
			    		<!--时间-->
						<span>
						<%if("".equals(signfieldids)||signfieldids.contains("4")){%>
							<%=Util.toScreen(log_operatedate,languageidfromrequest)%>
						<%}%>
						&nbsp;
						<%if("".equals(signfieldids)||signfieldids.contains("5")){%>
							<%=Util.toScreen(log_operatetime,languageidfromrequest)%>
						<%}%>			  
						</span>
						<!--节点信息-->
							  <p>
								<%if("".equals(signfieldids)||signfieldids.contains("2")){%>
								<span style="color:#089bfd;text-overflow:ellipsis;word-wrap:no-wrap;width: 160px;">
									[<%=log_nodeimg%><%=Util.toScreen(log_nodename,languageidfromrequest)%>
								<!--操作-->
								<%
									String logtype = log_logtype;
									String operationname = RequestLogOperateName.getOperateName(""+workflowid,""+requestid,""+log_nodeid,logtype,log_operator,languageidfromrequest);
								%>
								<%if("".equals(signfieldids)||signfieldids.contains("6")){%>
								/&nbsp;<%=operationname%>]
								<%}%>
								</span>
								<%}%>						
							  </p>
			    </td>
			    <td width="<%=isprint ? "5px" : "138px" %>" align="center" style="border-bottom:1px solid #e7e7e7;">
			        <table width="100%">
			          <tr>
			            <%
						if(!isHideInput.equals("1")&&((isintervenor==1||urger==1||submit==1)&&!isFormSignature.equals("1") ) && !log_logtype.equals("t") && (log_remarkHtml != null && !"".equals(log_remarkHtml.trim()))){						
						%>
						
						<!-- 引用START -->	
						<td class="<%="quote"+i%>" align="center" style="border-bottom:0px !important">
						<div style="" title="<%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%>">
							<img class='quote' onclick="quoteClick(this)" onmouseover="showquote(this)" onmouseout="hidequote(this)" src="/images/sign/sign_yy_normal_wev8.png" style="vertical-align:text-top;opacity:0;cursor: pointer;"/>
						</div>
						</td>
						<%
							}
						%>
			            <!-- 转发START -->
			    		<%
							if(forward==1){
						%>
						<td align="center" style="border-bottom:0px !important">
						<div  style="" title="<%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%>">
							<span  style='display:none'><%=log_operator%></span>
							<span  style='display:none'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></span>
							<span  style='display:none'><%=log_operator%></span>
							<span  style='display:none'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></span>
							<img class="transto" onclick="transtoClick(this)" onmouseover="showtransto(this)" onmouseout="hidetransto(this)" src="/images/sign/sign_zf_normal_wev8.png" style="vertical-align:text-top;opacity:0;cursor: pointer;"/> 
						</div>
						</td>						
						<%}%>						
					  </tr>
					</table>
			    </td>
			  </tr>
			</table>
			</td>		
		  </tr>
<%
	if(log_isbranche==0&&!"2".equals(orderbytype)) isLight = !isLight;
}
%>
</tbody>
</table>