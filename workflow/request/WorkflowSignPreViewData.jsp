<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
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

<%
int curPage = Util.getIntValue(request.getParameter("curPage"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int languageidfromrequest = Util.getIntValue(request.getParameter("languageid"));
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"), 0);
int userid = Util.getIntValue(request.getParameter("userid"), 0);
String isOldWf = Util.null2String(request.getParameter("isOldWf"));
String viewLogIds = Util.null2String(request.getParameter("viewLogIds"));
//String orderbytype = Util.null2String(request.getParameter("orderbytype"));
String orderbytype = "";
int creatorNodeId = Util.getIntValue(Util.null2String(request.getParameter("creatorNodeId")));
String txstatus = Util.null2String(request.getParameter("txstatus"));
String isHideInput = Util.null2String(request.getParameter("isHideInput"));
//是否流程督办
int urger = Util.getIntValue(request.getParameter("urger"),0);
//是否流程柑橘
int isintervenor = Util.getIntValue(request.getParameter("isintervenor"),0);


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


String maxrequestlogid = Util.null2String(request.getParameter("maxrequestlogid"));
StringBuffer sbfmaxrequestlogid = new StringBuffer(maxrequestlogid);
int loadNum = Util.getIntValue(request.getParameter("loadNum"), 0);
boolean isOldWf_ = false;
if(isOldWf.trim().equals("true")) isOldWf_=true;
User user2 = HrmUserVarify.getUser(request, response);
if (user2 == null)
	return;


String orderby = "desc";
String imgline="";//"<img src=\"/images/xp/L_wev8.png\">";
if("2".equals(orderbytype)){
	orderby = "asc";
    //imgline="<img src=\"/images/xp/L1_wev8.png\">";
}
WFLinkInfo.setRequest(request);
ArrayList log_loglist = null;
//节点签字意见权限控制
String sqlcondition = remarkRight.getRightCondition(requestid,workflowid,userid);
log_loglist = WFLinkInfo.getRequestLog(requestid, workflowid, viewLogIds, orderby, loadNum, sbfmaxrequestlogid, sqlcondition);

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
	while(pagestr.toLowerCase().indexOf("<script") != -1){
        int startindx = pagestr.toLowerCase().indexOf("<script");
		int endindx = pagestr.toLowerCase().indexOf("</script>");
		if (endindx != -1 && endindx > startindx){
			retrunstr += pagestr.substring(0, startindx);
			pagestr = pagestr.substring(endindx + 9);
		}
	}
	retrunstr+=pagestr;
	
	return retrunstr;
 }
%>

<%
int currPageCount = log_loglist.size();
out.print("<input type=\"hidden\" name=\"currPageCount"+curPage+"\" value=\""+currPageCount+"\">");
out.print("<input type=\"hidden\" name=\"maxrequestlogid"+curPage+"\" value=\""+sbfmaxrequestlogid.toString()+"\">");
if (log_loglist == null || log_loglist.isEmpty()) {
	out.print("<requestlognodata>");
	return;
}

for(int i=0;i<log_loglist.size();i++){
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
    String log_nodeimg="";
    if(log_tempvalue.equals(log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime)){
        log_branchenodeid=0;
    }else{
        log_tempvalue=log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime;
    }
    if(log_nodeattribute==1&&(log_logtype.equals("0")||log_logtype.equals("2"))&&log_branchenodeid==0){
        log_nodeimg=imgline;
        log_branchenodeid=log_nodeid;
    }
    if(log_isbranche==1){
        //log_nodeimg="<img src=\"/images/xp/T_wev8.png\">";
        log_branchenodeid=0;
    }

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
    <table name="signtable" class='liststyle liststyle1' cellspacing=0 style="margin:0;width:100%;">
    	<tbody>
		  <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark  <%}%> >
			<td>
			<table style="background:#fff"  width="100%" border="0" cellspacing="0" cellpadding="0" class="singleSignTbl">
			  <tr style="height:45px;">
			    <td width="12px" >&nbsp;</td>
			    <td width="40px" align="left" class="userheadimg"> 
			    	<!-- 人员头像 -->
					<span>
						<%if("".equals(signfieldids)||signfieldids.contains("0")){%>
							<!-- <img src="<%=img_path%>" style="width:35px;height:35px;border-radius:22px;margin-top:10px;"/> -->
							<%=weaver.hrm.User.getUserIcon(""+log_operator,"width:35px;height:35px;line-height:35px;border-radius:22px;margin-top:10px;") %>
						<%}%>
					</span>
			    </td>
			  
			    <td align="left">
			    	<div style="word-wrap:break-word; word-break:break-all; width:250px; font-size:12px;margin-top:10px;">
			    	<!-- 人员姓名 START -->
					<span>
					<%
						BaseBean wfsbean=FieldInfo.getWfsbean();
						int showimg = Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","showimg"),0);
						rssign.execute("select * from DocSignature  where hrmresid=" + log_operator + "order by markid");
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
							                        if (!"0".equals(Util.null2String(log_operatorDept)) && !"".equals(Util.null2String(log_operatorDept))) {
							                                displaydepid = Util.toScreen(log_operatorDept, languageidfromrequest);
							                                displaydepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept), languageidfromrequest);

							                            }
							                            displayid = log_operator;
							                            displayname = Util.toScreen(ResourceComInfo.getResourcename(log_operator), languageidfromrequest);

							                    } else if (log_operatortype.equals("1")) {
							                        isinneruser = false;
						                            displayid = log_operator;
						                            displayname = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator), languageidfromrequest);
							                    } else {
							                        displayname = SystemEnv.getHtmlLabelName(468, languageidfromrequest);
							                    }

							                } else {
							                    if (log_operatortype.equals("0")) {
							                            if (!log_agenttype.equals("2")) {
							                                if (!"0".equals(Util.null2String(log_operatorDept)) && !"".equals(Util.null2String(log_operatorDept))) {
							                                    displaydepid = Util.toScreen(log_operatorDept, languageidfromrequest);
							                                    displaydepname = Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept), languageidfromrequest);
							                                }
							                                displayid = log_operator;
							                                displayname = Util.toScreen(ResourceComInfo.getResourcename(log_operator), languageidfromrequest);
							                            } else if (log_agenttype.equals("2") || log_agenttype.equals("1")) {
	
							                                if (! ("" + log_nodeid).equals(String.valueOf(creatorNodeId))) {
							                                	
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

							                                    String agentCheckSql = " select * from workflow_Agent where workflowId=" + workflowid + " and beagenterId=" + log_agentorbyagentid + " and agenttype = '1' " + " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" + " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11, 19) + "' ) ) " + " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" + " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" + " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11, 19) + "' ) ) " + " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null) order by isCreateAgenter desc";
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
							                                            if (!log_agenttype.equals("2 ")) {
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
							                    } else if(log_operatortype.equals("1")){
						                            isinneruser = false;
							                        displayid = log_operator;
							                        displayname  = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),languageidfromrequest);
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
										        <a id="user_<%=log_iframeId%>" href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=displayid %>&requestid=<%=requestid%>" style='color:#099cff'>
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
								</span>
								<!-- 人员姓名 END -->
								&nbsp;&nbsp;
							 	<!--节点信息-->
								<%if("".equals(signfieldids)||signfieldids.contains("2")){ %>
									<span style="color:#c1c1c1;text-overflow:ellipsis;word-wrap:no-wrap;width: 160px;">
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
						</div>
						<div style="font-size:12px; color:#c1c1c1; margin-top:2px;">
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
						</div>
			    </td>
			    <td width="30px"></td>
			  </tr>
			  <tr>
			  	<td></td>
			  	<td></td>
			  	<td style="border-bottom:1px solid #e7e7e7; padding-top:2px; padding-bottom:4px;">
			  		<span>
			    	<!--签字意见-->
					<%
					    String _resvcss_Mrgtop = "3px";
						if(!log_logtype.equals("t")){
							if(tempRequestLogId>0&&tempImageFileId>0){
						%>
						   
							<jsp:include page="/workflow/request/WorkflowLoadSignatureRequestLogId.jsp">
								<jsp:param name="tempRequestLogId" value="<%=tempRequestLogId%>" />
							</jsp:include>
						<%
							}
							else
							{
								String tempremark = log_remark;
								tempremark = Util.StringReplace(tempremark,"&lt;br&gt;","<br>");
						%>
								<%=Util.StringReplace(tempremark,"&nbsp;"," ")%>
								<script type="text/javascript">
								try {
									 setIframeContent("<%=log_iframeId %>", "<%=script2Empty(log_remarkHtml).replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "").replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")%>", 
										 document.getElementById("<%=log_iframeId%>").contentWindow.document);
									 bodyresize(document.getElementById("<%=log_iframeId%>").contentWindow.document, "<%=log_iframeId%>", 1);
								} catch(e) {
								}
								</script>
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
											<img title="<%=SystemEnv.getHtmlLabelName(857,user2.getLanguage())%>" src="/images/sign/wd_wev8.png" style="line-height:26px;vertical-align:middle;">&nbsp;&nbsp;
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
										<a class="wffbtn" onmouseover="wfbtnOver(this)" onmouseout="wfbtnOut(this)" style="line-height:26px;cursor:pointer;color:#123885;" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')" title="<%=tempshowname%>"><%=tempshowname%></a>
				                        </span>
				                        <br>
							<%
									}
							%>
		
		
							<%
								}
								//System.err.println("log_signworkflowids--"+log_signworkflowids);
								ArrayList tempwflists=Util.TokenizerString(log_signworkflowids,",");
								int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
								for(int k=0;k<tempwflists.size();k++)
								{
								  if(k==0)
								  {
									%>
									<span style="line-height:26px;">
									<img title="<%=SystemEnv.getHtmlLabelName(22105,user2.getLanguage())%>" src="/images/sign/wf_wev8.png" style="line-height:26px;vertical-align: middle;">&nbsp;&nbsp;
									<%												 
								  }else{
									  %>
									<span style="line-height:26px;">
									<span style="line-height:26px;vertical-align: middle;opacity:0;padding-left:19px;"></span>&nbsp;&nbsp;		
									  <%
								  }
								  tempnum++;
								  session.setAttribute("resrequestid" + tempnum, "" + tempwflists.get(k));                
								  String temprequestname="<a class=\"wffbtn\" style=\"line-height:26px;cursor:pointer;color:#123885;\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+tempwflists.get(k)+"&wflinkno="+tempnum+"')\" title=" + wfrequestcominfo.getRequestName((String)tempwflists.get(k)) + ">"+wfrequestcominfo.getRequestName((String)tempwflists.get(k))+"</a>";
							%>
							  				
								<%=temprequestname%>
								</span>
								<br>
							  <%
							}
							 %>
								
	
							 <%
							session.setAttribute("slinkwfnum", "" + tempnum);
							session.setAttribute("desrequestid", "" + requestid);
							session.setAttribute("haslinkworkflow", "1");
							if(!log_annexdocids.equals("")){
							RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_annexdocids+") order by id asc");
							int linknum=-1;
							%>			
							 <span style="line-height:26px;">							
							 <img title="<%=SystemEnv.getHtmlLabelName(22194,user2.getLanguage())%>" src="/images/sign/fj_wev8.png"  style="line-height:26px;vertical-align: middle;">&nbsp;&nbsp;		
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
								<a class="wffbtn" style="cursor:pointer;color:#123885;" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')" title="<%=docImagefilename%>" ><%=docImagefilename%></a>
							  <%}else{%>
								<a class="wffbtn" style="cursor:pointer;color:#123885;" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')" title="<%=tempshowname%>"><%=tempshowname%>.<%=fileExtendName%></a>
							  <%}
							  
							  if(accessoryCount==1 &&((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){%>
						       
							      &nbsp;&nbsp;<BUTTON class="wffbtn" accessKey=1 style="color:#123885;border:0px;line-height:20px;font-size:12px;padding:3px;background: #fff"  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&fromrequest=1'" type="button">
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
								if (showimg == 1 && rssign.next() && true) {
									// 获取签章图片并显示

									String markpath = Util.null2String(rssign.getString("markpath"));
									
									//System.out.println("markpath:"+markpath);
									if (!markpath.equals("")) {
										userimg = "/weaver/weaver.file.ImgFileDownload?userid=" + log_operator;
										//System.out.println("userimg:"+userimg);
										//System.out.println("log_operatortype:"+log_operatortype);
									}
								}
								if(!userimg.equals("") && "0".equals(log_operatortype)){
									%>
										<div align="right" style="padding-right: 0px;"><img id=markImg src="<%=userimg%>" ></img></div>
									<%
								}
							    %>
					</span>
			  	</td>
			  	<td></td>
			  </tr>
			</table>
			</td>		
		  </tr>
	</tbody>
</table>
<%
	if(log_isbranche==0&&!"2".equals(orderbytype)) isLight = !isLight;
}
%>