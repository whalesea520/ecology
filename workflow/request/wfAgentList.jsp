
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*,weaver.workflow.request.WFWorkflows,weaver.workflow.request.WFWorkflowTypes"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="TimeUtil" class="weaver.general.TimeUtil" scope="page" />

<HTML><HEAD>
<!--以下是显示定制组件所需的js -->
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>

    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
    <SCRIPT type="text/javascript" src="../../js/weaver_wev8.js"></script>
</head>
<BODY>
<FORM id=frmmain name=frmmain method=post action="">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   	//菜单 标识是否 是流程代理或者是已办代理  1：



   	String agented = Util.null2String(request.getParameter("agented"));
	String agentFlag = Util.null2String(request.getParameter("agentFlag"));
	 
	if(agentFlag.equals(""))
        agentFlag="0";
	boolean haveAgentAllRight = false;
	if (HrmUserVarify.checkUserRight("WorkflowAgent:All", user)) {
		haveAgentAllRight = true;
	}
	if(agented.equals("0"))
	{
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(33242,user.getLanguage())+",javascript:popSetAgentWin(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    if ("0".equals(agentFlag) || haveAgentAllRight) {
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(33243,user.getLanguage())+",javascript:OnMultiSubmitNew(),_self}" ;
		    RCMenuHeight += RCMenuHeightStep ;
	    }
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(24183,user.getLanguage())+",javascript:trunAgented(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    if(HrmUserVarify.checkUserRight("AgentLog:View", user)){
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:trunLog(),_self} " ;
	        RCMenuHeight += RCMenuHeightStep ;
	    }
	}else
	{
		 RCMenu += "{"+SystemEnv.getHtmlLabelName(17723,user.getLanguage())+",javascript:trunSetAgent(),_self}" ;
		 RCMenuHeight += RCMenuHeightStep ;
	}
    


   int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统




    
	String nodetype = Util.null2String(request.getParameter("nodetype"));
	String creatertype = Util.null2String(request.getParameter("creatertype"));
	String requestlevel = Util.null2String(request.getParameter("requestlevel"));
    //创建日期标识
	String datecondition=Util.null2String(request.getParameter("createdateselect"));
	//接收日期标识
	String recievedateselect = Util.null2String(request
				.getParameter("recievedateselect"));
    //操作日期
	String operatedateselect = Util.null2String(request
				.getParameter("operatedateselect"));

    //1.基于流程类别调用(type) 2.基于流程调用(workflow)
    String menutype=Util.null2String(request
				.getParameter("menutype"));

    String menuid=Util.null2String(request
				.getParameter("menuid"));
	 String createrid = Util.null2String(request.getParameter("createrid"));
     String createrid2 = Util.null2String(request.getParameter("createrid2"));
     String creatername = "";
     String creatername2 = "";
     if ("1".equals(creatertype)) {
    	 createrid = "";
    	 creatername2 = CustomerInfoComInfo.getCustomerInfoname(createrid2);
     } else {
    	 createrid2 = "";
    	 creatername = ResourceComInfo.getResourcename(createrid);
     }

   String imagefilename = "/images/hdDOC_wev8.gif";
   String titlename = "";
   if(agented.equals("0"))
	   titlename = SystemEnv.getHtmlLabelName(17723,user.getLanguage());
	else if(agented.equals("1"))
		titlename = SystemEnv.getHtmlLabelName(24183,user.getLanguage());
   String needfav ="1";
   String needhelp ="";
   String userID = String.valueOf(user.getUID());
   String Belongtoids =user.getBelongtoids();
   String newsql="";
    

    // =====================添加页面上的查询条件            Start   =====================

    //高级搜索条件
    WfAdvanceSearchUtil  conditionutil=new  WfAdvanceSearchUtil(request,RecordSet);
   
    String conditions=conditionutil.getAdVanceSearch4OAgentCondition();

    if(!conditions.equals(""))
	{
	 newsql += conditions;
	}
    

	 // =====================添加页面上的查询条件            END   =====================
    
	 
int perpage=10;
boolean hascreatetime =true;
boolean hascreater =true;
boolean hasworkflowname =true;
boolean hasrequestlevel =true;
boolean hasrequestname =true;
boolean hasreceivetime =true;
boolean hasstatus =true;
boolean hasreceivedpersons =true;
boolean hascurrentnode =true;
// =====================获取查询数据显示列          Start    =====================
RecordSet.executeProc("workflow_RUserDefault_Select",""+userID);
if(RecordSet.next()){
    if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
    if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
    if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
    if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
    if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
    if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
    if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
    if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
    if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
    perpage= RecordSet.getInt("numperpage");
}else{
    RecordSet.executeProc("workflow_RUserDefault_Select","1");
    if(RecordSet.next()){
        if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
        if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
        if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
        if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
        if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
        if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
        if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
        if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
        if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
        perpage= RecordSet.getInt("numperpage");
    }
}

perpage = 10;
String belongtoshow = "";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
		if(RecordSet.next()){
			belongtoshow = RecordSet.getString("belongtoshow");
		}
   if(!"".equals(Belongtoids) && "1".equals(belongtoshow)){
	userID = userID +","+ Belongtoids;
   }



// =====================获取查询数据显示列            END   =====================
  
  

/*如果所有的列都不显示，那么就显示所有的，避免页面出错*/
if(!hascreatetime&&!hascreater&&!hasworkflowname&&!hasrequestlevel&&!hasrequestname&&!hasreceivetime&&!hasstatus&&!hasreceivedpersons&&!hascurrentnode){
	hascreatetime =true;
	hascreater =true;
	hasworkflowname =true;
	hasrequestlevel =true;
	hasrequestname =true;
	hasreceivetime =true;
	hasstatus =true;
	hasreceivedpersons =true;
	hascurrentnode =true;			
}



String pageIdStr = "5";

//======高级查询字段反馈============
//代理设置查询参数
String beagenterid = Util.null2String(request.getParameter("beagenterid"));
String agenterid = Util.null2String(request.getParameter("agenterid"));
String wftype = Util.null2String(request.getParameter("wftype"));
String wfidbytype = Util.null2String(request.getParameter("wfidbytype"));
String selectBeginDate = Util.null2String(request.getParameter("selectBeginDate"));
String begindatefrom = Util.null2String(request.getParameter("begindatefrom"));
String begindateto = Util.null2String(request.getParameter("begindateto"));
String selectEndDate = Util.null2String(request.getParameter("selectEndDate"));
String enddatefrom = Util.null2String(request.getParameter("enddatefrom"));
String enddateto = Util.null2String(request.getParameter("enddateto"));
String agentstatus = Util.null2String(request.getParameter("agentstatus"));
String beaiddepartmentid = Util.null2String(request.getParameter("beaiddepartmentid"));
String beaidsubcompanyid= Util.null2String(request.getParameter("beaidsubcompanyid"));
String aiddepartmentid= Util.null2String(request.getParameter("aiddepartmentid"));
String aidsubcompanyid= Util.null2String(request.getParameter("aidsubcompanyid"));
String beagentername = "";
String agentername = "";
String wfname = "";
String beaiddepartmentname = "";
String beaidsubcompanyname = "";
String aiddepartmentname = "";
String aidsubcompanyname = "";
if(!beagenterid.equals(""))
	beagentername = ResourceComInfo.getLastname(beagenterid);
if(!agenterid.equals(""))
	agentername = ResourceComInfo.getLastname(agenterid);
if(!wfidbytype.equals(""))
	wfname = WorkflowComInfo.getWorkflowname(wfidbytype);
if(!beaiddepartmentid.equals(""))
	beaiddepartmentname = DepartmentComInfo.getDepartmentname(beaiddepartmentid);
if(!beaidsubcompanyid.equals(""))
	beaidsubcompanyname = SubCompanyComInfo.getSubcompanyname(beaidsubcompanyid);
if(!aiddepartmentid.equals(""))
	aiddepartmentname = DepartmentComInfo.getDepartmentname(aiddepartmentid);
if(!aidsubcompanyid.equals(""))
	aidsubcompanyname = SubCompanyComInfo.getSubcompanyname(aidsubcompanyid);
%>




		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/wfSearchResult_wev8.js"></script>
		<table id="topTitle" cellpadding="0" cellspacing="0" style="width:100%">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan">
					<%if(agented.equals("0")) {%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(33242, user.getLanguage())%>" class="e8_btn_top middle" onclick="popSetAgentWin()">
						<%if ("0".equals(agentFlag) || haveAgentAllRight) {%>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(33243, user.getLanguage())%>" class="e8_btn_top middle" onclick="OnMultiSubmitNew(this)">
						<%}%>
					<%} else {%>
					<input type="text" class="searchInput" name="flowTitle"/>
					<%}%>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>


<%
%>
			
<input type='hidden' name='agentFlag'  value="<%=agentFlag%>">
<input type='hidden' name='method' value="<%=menutype%>">
<input type='hidden' name='objid' value="<%=menuid%>">
 
 <!--高级设置表单   -------begin-->
<div class="advancedSearchDiv" id="advancedSearchDiv">
   <wea:layout type="4col">
   	<%if(agented.equals("0")){%>
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
    		<wea:item><%=SystemEnv.getHtmlLabelName(17565, user.getLanguage())%></wea:item>
    		<wea:item>
	    		<%if(agentFlag.equals("1"))
		    	{%>
    			<span id="beagenterspan">
		   			<brow:browser viewType="0" name="beagenterid" browserValue='<%=beagenterid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="80%" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=beagentername %>'> 
				   	</brow:browser> 
				</span>
				<%}else{ %>
					<%=ResourceComInfo.getLastname(user.getUID()+"") %>
				<%} %>
    		</wea:item>
    		<wea:item><%=SystemEnv.getHtmlLabelName(17566, user.getLanguage())%></wea:item>
    		<wea:item>
    			<span id="agenterspan">
		   			<brow:browser viewType="0" name="agenterid" browserValue='<%=agenterid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="80%" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=agentername %>'> 
				   	</brow:browser> 
				</span>
    		</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
	    	<% String wfbytypeBrowserURL = "";%>
	    	<wea:item>
		    	 <span>
		    	 	<brow:browser viewType="0" name="wftype"
								browserValue='<%=wftype%>' width="80%"
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
								_callback="setWFbyType"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
								browserDialogWidth="600px"
								browserSpanValue='<%=WorkTypeComInfo.getWorkTypename(wftype)%>'></brow:browser>
		    	</span> 
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(259, user.getLanguage())%></wea:item>
	    	<wea:item>
		    	 <brow:browser viewType="0" name="wfidbytype"
								browserValue='<%=wfidbytype%>' width="80%"
								getBrowserUrlFn="getFlowWindowUrl" hasInput="true"
								isSingle="true" hasBrowser="true" isMustInput="1"
								completeUrl="/data.jsp?type=workflowBrowser"
								browserSpanValue='<%=WorkflowComInfo.getWorkflowname(wfidbytype)%>'></brow:browser>
	    	</wea:item>
	    	<!--开始时间-->      
  			<wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
    		<wea:item>
				<span style='float:left;display:inline-block;'>
					<select style='width:100%;' name="selectBeginDate" id="selectBeginDate" style="width: 150px" onchange="changeDate(this,'beginDate');" class="styled" >
						<option value="0" <%=selectBeginDate.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
						<option value="1" <%=selectBeginDate.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage())%></option>
						<option value="2" <%=selectBeginDate.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage())%></option>
						<option value="3" <%=selectBeginDate.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage())%></option>
						<option value="4" <%=selectBeginDate.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage())%></option>
						<option value="5" <%=selectBeginDate.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage())%></option>
						<option value="6" <%=selectBeginDate.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530, user.getLanguage())%></option>
					</select>
			   </span>
			   <span  style='float:left;margin-left:5px;padding-top: 5px;'>
				   	<span id="beginDate" <%if(!"6".equals(selectBeginDate)){%>style="display:none;"<%}%>>
				   	<button type="button" class="calendar" id="beginDateBtn" onclick="getDate(begindatefromspan,begindatefrom)"></button>&nbsp;
				   	<span id="begindatefromspan"><%=begindatefrom%></span>
				  	-&nbsp;&nbsp;<button type="button" class="calendar" id="beginDateBtn2" onclick="getDate(begindatetospan,begindateto)"></button>&nbsp;
				  	<span id="begindatetospan"><%=begindateto%></span>
				  	</span>
				  	<input type="hidden" name="begindatefrom" value="<%=begindatefrom%>">
					<input type="hidden" name="begindateto" value="<%=begindateto%>">
				</span>
    		</wea:item>
    		<!--结束时间-->
    		<wea:item><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
			<wea:item>
				<span style='float:left;display:inline-block;'>
					<select style='width:100%;' name="selectEndDate" id="selectEndDate" style="width: 150px" onchange="changeDate(this,'endDate');" class="styled" >
						<option value="0" <%=selectEndDate.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
						<option value="1" <%=selectEndDate.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage())%></option>
						<option value="2" <%=selectEndDate.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage())%></option>
						<option value="3" <%=selectEndDate.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage())%></option>
						<option value="4" <%=selectEndDate.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage())%></option>
						<option value="5" <%=selectEndDate.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage())%></option>
						<option value="6" <%=selectEndDate.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530, user.getLanguage())%></option>
					</select>
			   </span>
			   <span  style='float:left;margin-left: 5px;padding-top: 5px;'>
				   	<span id="endDate" <%if(!"6".equals(selectEndDate)){%>style="display:none;"<%}%>>
				   	<button type="button" class="calendar" id="endDateBtn" onclick="getDate(enddatefromspan,enddatefrom)"></button>&nbsp;
				   	<span id="enddatefromspan"><%=enddatefrom%></span>
				  	-&nbsp;&nbsp;<button type="button" class="calendar" id="SelectDate2" onclick="getDate(enddatetospan,enddateto)"></button>&nbsp;
				  	<span id="enddatetospan"><%=enddateto%></span>
				  	</span>
				  	<input type="hidden" name="enddatefrom" value="<%=enddatefrom%>">
					<input type="hidden" name="enddateto" value="<%=enddateto%>">
				</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(33362, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<select class=inputstyle name=agentstatus style='width:80%' size=1 >
					<option value="0" <%=agentstatus.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
					<option value="1" <%=(agentstatus.equals("1") || agentstatus.equals("")) ?"selected":"" %>><%=SystemEnv.getHtmlLabelName(24324, user.getLanguage())%></option>
					<option value="2" <%=agentstatus.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1979, user.getLanguage())%></option>
					<option value="3" <%=agentstatus.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(33348, user.getLanguage())%></option>
					<option value="5" <%=agentstatus.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(82860, user.getLanguage())%></option>
					<option value="4" <%=agentstatus.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(22348, user.getLanguage())%></option>
				</select>
	    	</wea:item>
	    </wea:group>
	    
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'  attributes="{'itemAreaDisplay':'none'}">
			<%if(agentFlag.equals("1")){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(17565, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27511, user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<brow:browser viewType="0" name="beaiddepartmentid" browserValue='<%=beaiddepartmentid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue='<%=beaiddepartmentname %>'> </brow:browser> 
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(17565, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></wea:item>
		    	<wea:item>
		    		 <brow:browser viewType="0" name="beaidsubcompanyid" browserValue='<%=beaidsubcompanyid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=beaidsubcompanyname %>'> </brow:browser> 
		    	</wea:item>
			<%} %>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(17566, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27511, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<brow:browser viewType="0" name="aiddepartmentid" browserValue='<%=aiddepartmentid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue='<%=aiddepartmentname %>'> </brow:browser> 
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(17566, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		 <brow:browser viewType="0" name="aidsubcompanyid" browserValue='<%=aidsubcompanyid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=aidsubcompanyname %>'> </brow:browser> 
	    	</wea:item>
	    </wea:group>
	    <%}else{%>
	    	<%
	    		String requestName = Util.null2String(request.getParameter("requestname"));
	    		String workcode = Util.null2String(request.getParameter("workcode"));
	    		String recievedatefrom = Util.null2String(request.getParameter("recievedatefrom"));
	    		String recievedateto = Util.null2String(request.getParameter("recievedateto"));
	    		String archivestatus = Util.null2String(request.getParameter("archivestatus"));
	    	%>
	    	<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
    			<wea:item><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></wea:item>
    			<wea:item><input class="InputStyle" type="text" name="requestname" id="requestname" value='<%=requestName%>'/></wea:item>
    			<wea:item><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%></wea:item>
    			<wea:item><input id="workcode" name="workcode" class="InputStyle" type="text" value='<%=workcode%>' /></wea:item>
    			<wea:item><%=SystemEnv.getHtmlLabelName(15534, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<select class=inputstyle name=requestlevel style='width:80%;' size=1>
					<option value="" ></option>
					<option value="0" <%if("0".equals(requestlevel)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%></option>
					<option value="1" <%if("1".equals(requestlevel)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%></option>
					<option value="2" <%if("2".equals(requestlevel)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%></option>
				 </select>
	    	</wea:item>
	    	<wea:item ><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
	    	<wea:item >
	    		         <span  style='float:left'>
								<select class=inputstyle name=creatertype  style='height:25px;width:100px;' onchange="changeType(this.value,'createridse1span','createridse2span');">
								<%if (!user.getLogintype().equals("2")) {%>
									<option <%if("0".equals(creatertype)) {%>selected<%}%> value="0"><%=SystemEnv.getHtmlLabelName(362, user.getLanguage())%></option>
								<%}%>
									<option <%if("1".equals(creatertype)) {%>selected<%}%> value="1"><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%></option>
								</select>								
							</span>
							<span id="createridse1span" <%if("1".equals(creatertype)) {%>style="display:none;"<%}%>>
								  <brow:browser viewType="0" name="createrid" browserValue='<%=createrid%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="135px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=creatername%>'> 
						   </brow:browser> 
							</span>
							<span id="createridse2span" <%if(!"1".equals(creatertype)) {%>style="display:none;"<%}%>>
								  <brow:browser viewType="0" name="createrid2" browserValue='<%=createrid2%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" width="135px;" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=7"  browserSpanValue='<%=creatername2%>'> 
								 </brow:browser> 
							</span>
	    	</wea:item>
    		</wea:group>
    		<wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'  attributes="{'itemAreaDisplay':'none'}">
				<wea:item><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<%
							String ownerdepartmentid = Util.null2String(request.getParameter("ownerdepartmentid"));
							String ownerdepartmentname = "";
							if(!"".equals(ownerdepartmentid)) {
								ownerdepartmentname = DepartmentComInfo.getDepartmentname(ownerdepartmentid);
							}
						%>
		    		 <brow:browser viewType="0" name="ownerdepartmentid" browserValue='<%=ownerdepartmentid%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue='<%=ownerdepartmentname%>'> </brow:browser>
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<%
							String creatersubcompanyid = Util.null2String(request.getParameter("creatersubcompanyid"));
							String creatersubcompanyname = "";
							if(!"".equals(creatersubcompanyid)) {
								creatersubcompanyname = SubCompanyComInfo.getSubCompanydesc(creatersubcompanyid);
							}
						%>
		    		<brow:browser viewType="0" name="creatersubcompanyid" browserValue='<%=creatersubcompanyid%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=creatersubcompanyname%>'> </brow:browser> 
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(17994, user.getLanguage())%></wea:item>
		    	<wea:item  attributes="{colspan:3}">
		    		<span style='float:left;display:inline-block;'>
						<select name="recievedateselect" id="doccreatedateselect" onchange="changeDate(this,'recievedate');" class=inputstyle size=1    style=width:150>
									<option value="0" <%="0".equals(recievedateselect)?"selected":""%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
									<option value="1" <%="1".equals(recievedateselect)?"selected":""%>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage())%></option>
									<option value="2" <%="2".equals(recievedateselect)?"selected":""%>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage())%></option>
									<option value="3" <%="3".equals(recievedateselect)?"selected":""%>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage())%></option>
									<option value="4" <%="4".equals(recievedateselect)?"selected":""%>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage())%></option>
									<option value="5" <%="5".equals(recievedateselect)?"selected":""%>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage())%></option>
									<option value="6" <%="6".equals(recievedateselect)?"selected":""%>><%=SystemEnv.getHtmlLabelName(17908, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19467, user.getLanguage())%></option>
								</select>
							  </span>
							   <span  style='float:left;margin-left: 10px;padding-top: 5px;'>
									   <span id="recievedate" <%if(!"6".equals(recievedateselect)){%>style="display:none;"<%}%>>
									   <button type="button" class="calendar" id="SelectDate" onclick="getDate(recievedatefromspan,recievedatefrom)"></button>&nbsp;
										<span id="recievedatefromspan"><%=recievedatefrom%></span>
										  -&nbsp;&nbsp;<button type="button" class="calendar" id="SelectDate1" onclick="getDate(recievedatetospan,recievedateto)"></button>&nbsp;
										<span id="recievedatetospan"><%=recievedateto%></span>
										</span>
										<input type="hidden" name="recievedatefrom" value="<%=recievedatefrom%>">
										<input type="hidden" name="recievedateto" value="<%=recievedateto%>">
								</span>
		    	</wea:item>
		    	<%-- 
		    	<wea:item><%=SystemEnv.getHtmlLabelName(553, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602, user.getLanguage())%></wea:item>
		    	<wea:item>
		    		            <select class=inputstyle size=1 style='width:80%' name="archivestatus1">
									<option value="0" ><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
									<option value="1" ><%=SystemEnv.getHtmlLabelName(16658, user.getLanguage())%></option>
									<option value="2" ><%=SystemEnv.getHtmlLabelName(24627, user.getLanguage())%></option>
								</select>
		    	</wea:item>
		    	--%>
				<wea:item><%=SystemEnv.getHtmlLabelName(15112, user.getLanguage())%></wea:item>
				<wea:item>
				        <select class=inputstyle size=1 style='width:80%' name="archivestatus">
							<option value="0" <%="0".equals(archivestatus)?"selected":""%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
							<option value="2" <%="2".equals(archivestatus)?"selected":""%>><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%></option>
							<option value="1" <%="1".equals(archivestatus)?"selected":""%>><%=SystemEnv.getHtmlLabelName(18800, user.getLanguage())%></option>
						</select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
				<wea:item>
				        <select class=inputstyle  size=1 name=wfstatu style='width:80%'>
								<option value="1" ><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
								<option value="0" ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
								<option value="2" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					   </select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(15536, user.getLanguage())%></wea:item>
				<wea:item>
				         <select class=inputstyle size=1 name=nodetype style='width:80%'>
								<option value="">&nbsp;</option>
								<option value="0" <%="0".equals(nodetype)?"selected":""%>><%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%></option>
								<option value="1" <%="1".equals(nodetype)?"selected":""%>><%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%></option>
								<option value="2" <%="2".equals(nodetype)?"selected":""%>><%=SystemEnv.getHtmlLabelName(725, user.getLanguage())%></option>
								<option value="3" <%="3".equals(nodetype)?"selected":""%>><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%></option>
							</select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(16354, user.getLanguage())%></wea:item>
				<wea:item>
						<%
							String unophrmid = Util.null2String(request.getParameter("unophrmid"));
							String unophrmname = "";
							if(!"".equals(unophrmid)){
								String st[]=unophrmid.split(",");
								for(int i=0;i<st.length;i++){
									String str01=""+st[i];
									if(!str01.equals("")){
										unophrmname+="  "+ResourceComInfo.getResourcename(str01);
							  		}
							 	}
							}
						%>
				         <brow:browser viewType="0" name="unophrmid" browserValue='<%=unophrmid%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=unophrmname%>'> </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%></wea:item>
				<wea:item>
						<%
							String docids = Util.null2String(request.getParameter("docids"));
							String docname = "";
							if(!"".equals(docids)){
								String st[]=docids.split(",");
								for(int i=0;i<st.length;i++){
									String str01=""+st[i];
									if(!str01.equals("")){
										docname+="  "+DocComInfo.getDocname(str01);
							  		}
							 	}
							}
						%>
				          <brow:browser viewType="0" name="docids" browserValue='<%=docids%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=9" width="80%" browserSpanValue='<%=docname%>'> </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></wea:item>
				<wea:item>
						<%
							String hrmcreaterid = Util.null2String(request.getParameter("hrmcreaterid"));
							String hrmname = "";
							if(!"".equals(hrmcreaterid)){
								String st[]=hrmcreaterid.split(",");
								for(int i=0;i<st.length;i++){
									String str01=""+st[i];
									if(!str01.equals("")){
										hrmname+="  "+ResourceComInfo.getResourcename(str01);
							  		}
							 	}
							}
						%>
				         <brow:browser viewType="0" name="hrmcreaterid" browserValue='<%=hrmcreaterid%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=hrmname%>'> </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></wea:item>
				<wea:item>
						<%
								String crmids = Util.null2String(request.getParameter("crmids"));
								String crmname="";
								if(!"".equals(crmids)){
									String st[]=crmids.split(",");
									for(int i=0;i<st.length;i++){
										String str01=""+st[i];
										if(!str01.equals("")){
									  		crmname+="  "+CustomerInfoComInfo.getCustomerInfoname(str01);
								  		}
								 	}
								}
	     				 	%>
				         <brow:browser viewType="0" name="crmids" browserValue='<%=crmids%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=18" width="80%" browserSpanValue='<%=crmname%>'> </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
				<wea:item>
						<%
								String proids = Util.null2String(request.getParameter("proids"));
								String projname="";
								if(!"".equals(proids)){
									String st[]=proids.split(",");
									for(int i=0;i<st.length;i++){
								  		String str01=""+st[i];
								  		if(!str01.equals("")){
									  		projname+="  "+ProjectInfoComInfo.getProjectInfoname(str01);
								  		}
								 	}
								}
	     				 	%>
				        	<brow:browser viewType="0" name="proids" browserValue='<%=proids%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=135" width="80%" browserSpanValue='<%=projname%>'> </brow:browser>
				</wea:item>
			
	    	</wea:group>
	    <%} %>
	    <wea:group context="">
	    	<wea:item type="toolbar">
				<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>" class="e8_btn_submit"/>
				<span class="e8_sep_line">|</span>
				<input type="button"  class='resetitem e8_btn_cancel' value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%>"  >
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>

</div>
<!--- 高级设置结束 -->









<TABLE width="100%"  cellspacing="0" cellpadding="0">
    <tr>
        <td valign="top">
            <%
				String tableString = "";
            	String backfields = "";
            	String fromSql="";
            	String sqlWhere = "";
            	String sqlCondition = "";
            	String orderby = "t1.agenterId,t1.beagenterid";
            	//added by xwj fortd2483 20050812
            	String currentDate=TimeUtil.getCurrentDateString();
            	String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
				int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
if(!"".equals(userID)){
arr2 = userID.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}
//for(int k=0;k<userlist.size();k++){
	   //beagenterid = Util.null2String((String)userlist.get(k));
	   //userID = Util.null2String((String)userlist.get(k));
	   //System.out.println("--675555555555-beagenterid----"+beagenterid);
            	//System.out.println(agentFlag+"++++"+agented);
            	//代理设置：===>我的代理 &　其他人的代理
            	if(agented.equals("0"))
            	{
            		backfields = "   t1.agentid,t1.beagenterid,t1.agenterId,t2.id,t2.workflowtype,t2.workflowname,t1.beginDate,t1.beginTime,t1.endDate,t1.endTime,t1.isCreateAgenter,t1.agenttype,t1.operatorid ";
            		fromSql = " workflow_agent t1,workflow_base t2,workflow_agentConditionSet t3 ";
            		String swt =  " and t1.agenttype!='0' " ;//默认显示未结束的 0表示结束、1或者空 表示有效 
            		sqlWhere = " t1.workflowid = t2.id and t1.agentid = t3.agentid  and t1.workflowid= t3.workflowid and t1.beagenterid=t3.bagentuid and ( t2.isvalid='1' or t2.isvalid='3') ";
            		if(selectBeginDate.equals("") && selectEndDate.equals("") && agentstatus.equals(""))
            			sqlWhere += swt;
            		if(!beagenterid.equals("")){
            			sqlCondition += " and t1.beagenterid='"+beagenterid+"' ";
            		}
            		if(!agenterid.equals("")){
            			sqlCondition += " and  t3.agentuid='"+agenterid+"'   ";
            		}
            		if(wftype.equals("0") || wftype.equals(""));
            		else sqlCondition += " and t2.workflowtype='"+wftype+"' ";
            		if(!wfidbytype.equals(""))
            			sqlCondition += " and t2.id="+wfidbytype+" ";
            		if(selectBeginDate.equals("1"))
            			sqlCondition += " and t1.beginDate>='"+TimeUtil.getToday()+"' ";
           			else if(selectBeginDate.equals("2"))
           				sqlCondition += " and t1.beginDate>='"+TimeUtil.getFirstDayOfWeek()+"' ";
       				else if(selectBeginDate.equals("3"))
               			sqlCondition += " and t1.beginDate>='"+TimeUtil.getFirstDayOfMonth()+"' ";
               		else if(selectBeginDate.equals("4"))
                   		sqlCondition += " and t1.beginDate>='"+TimeUtil.getFirstDayOfSeason()+"' ";
                   	else if(selectBeginDate.equals("5"))
                       	sqlCondition += " and t1.beginDate>='"+TimeUtil.getFirstDayOfTheYear()+"' ";
      				else if(selectBeginDate.equals("6"))
          				sqlCondition += " and (t1.beginDate>='"+begindatefrom+"' and t1.beginDate <='"+begindateto+"')";
          			if(selectEndDate.equals("1"))
          				sqlCondition += " and t1.endDate >='"+ TimeUtil.getToday()+"' ";
      				else if(selectEndDate.equals("2"))
           				sqlCondition += " and t1.endDate>='"+TimeUtil.getFirstDayOfWeek()+"' ";
       				else if(selectEndDate.equals("3"))
               			sqlCondition += " and t1.endDate>='"+TimeUtil.getFirstDayOfMonth()+"' ";
               		else if(selectEndDate.equals("4"))
                   		sqlCondition += " and t1.endDate>='"+TimeUtil.getFirstDayOfSeason()+"' ";
                   	else if(selectEndDate.equals("5"))
                       	sqlCondition += " and t1.endDate>='"+TimeUtil.getFirstDayOfTheYear()+"' ";
      				else if(selectEndDate.equals("6"))
          				sqlCondition += " and (t1.endDate>='"+enddatefrom+"' and t1.endDate <='"+enddateto+"')";
          			
          			if(agentstatus.equals("1")){//未结束

          				sqlCondition +=  " and t1.agenttype='1' " ;
          			}else if(agentstatus.equals("2")){//未开始

          				sqlCondition += " and t1.agenttype='1' and ((t1.beginDate ='"+currentDate+"' and t1.beginTime>'"+currentTime+"') or t1.beginDate>'"+currentDate+"') ";
            		}else if(agentstatus.equals("3")){//代理中
            		  if(RecordSet.getDBType().equals("oracle")){//标准开发时，未针对oracle数据库做特使控制导致oracle查询不到
            			  sqlCondition += swt + "  and ((TO_DATE(nvl(beginDate,'1900-01-01') || ' ' || nvl(beginTime,'00:00'),'yyyy-mm-dd hh24:mi')<= TO_DATE('"+currentDate+" "+currentTime+"','yyyy-mm-dd hh24:mi:ss')))";
            			}else{
            				sqlCondition += swt + " and (t1.beginDate='' or (t1.beginDate!='' and (t1.beginDate<'"+currentDate+"' or (t1.beginDate='"+currentDate+"' and (t1.beginTime='' or t1.beginTime is null or t1.beginTime>'"+currentTime+"')))))";            				  
            			}
            	   }else if(agentstatus.equals("4")){//已结束

       					sqlCondition += " and t1.agenttype='0'";
					}else if(agentstatus.equals("5")){//收回中

       				    sqlCondition +=  " and t1.agenttype='1' and ( ( (t1.endDate < '" + currentDate + "' and (t1.endTime='' or t1.endTime is null))" + 
                	    " or (t1.endDate <='" + currentDate + "' and t1.endTime <'" + currentTime + "' ) ) " + 
                	    " or t1.endDate < '" + currentDate + "' or t1.endDate = '' or t1.endDate is null)" ;
					}
          			
          			if (!"".equals(aiddepartmentid)) {
          				sqlCondition += " and  t3.agentuid IN (SELECT id FROM hrmresource WHERE departmentid='"+aiddepartmentid+"')   ";
          			}
          			if (!"".equals(aidsubcompanyid)) {
          				sqlCondition += " and   t3.agenttype='1' and t3.agentuid IN (SELECT id FROM hrmresource WHERE subcompanyid1='"+aidsubcompanyid+"')   ";
          			}
          			if ("1".equals(agentFlag)) {
          				if (!"".equals(beaiddepartmentid)) {
          					sqlCondition += " AND t1.beagenterid IN (SELECT id FROM hrmresource WHERE departmentid='"+beaiddepartmentid+"')";
          				}
          				if (!"".equals(beaidsubcompanyid)) {
          					sqlCondition += " AND t1.beagenterid IN (SELECT id FROM hrmresource WHERE subcompanyid1='"+beaidsubcompanyid+"')";
          				}
          			}
          				
            		//代理设置：===>我的代理
            		if(agentFlag.equals("0"))
            		{
            			//backfields += " ,t3.agcount ";
            			//fromSql += " and t1.beagenterid ="+user.getUID();
            			sqlWhere += " and t1.beagenterid in ("+userID+")";
            		}
            		//代理设置：===>其他人的代理
            		else if(agentFlag.equals("1"))
            		{
						if(!userID.equals(String.valueOf(user.getUID()))){
						sqlWhere += " and t1.beagenterid not in ("+userID+")";
						}else{
            			//fromSql += " and t1.beagenterid !="+user.getUID();
            			sqlWhere += " and t1.beagenterid !="+user.getUID();
						}
            		}
            		if(sqlCondition.length()>0)
            			sqlWhere += sqlCondition;
            		//fromSql += swt;
            		//fromSql += " group by t1.agenterid ) t3 ";
            		
             //out.println("select "+backfields+" from "+fromSql+" where "+sqlWhere);
					for(int k=0;k<userlist.size();k++){
	   				int beagenteridall = Util.getIntValue((String)userlist.get(k));
	  				 userID = Util.null2String((String)userlist.get(k));
            	//System.out.println(agentFlag+"++++"+agented);
            		String operateString = "";
            		if ("0".equals(agentFlag) || haveAgentAllRight) {//
            			operateString = " <operates>";
            			operateString +="    <popedom transmethod=\"weaver.workflow.workflow.WFAgentTransMethod.getAgentOperation\" ></popedom> ";
            			operateString +="     <operate  	href=\"javascript:onagentedit();\" text=\"" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + "\" otherpara=\"ct+column:agenterId+column:beagenterid+column:id\" index=\"0\"/>";
            			operateString +="     <operate  	href=\"javascript:onagentcondition();\" text=\"" + SystemEnv.getHtmlLabelName(82586, user.getLanguage()) + "\" otherpara=\"ct+column:agenterId+column:beagenterid+column:id\" index=\"1\"/>";
    					operateString +="     <operate  	href=\"javascript:countermand();\" text=\"" + SystemEnv.getHtmlLabelName(33354, user.getLanguage()) + "\" otherpara=\"it\" index=\"2\"/>";
    					operateString +="     <operate  	href=\"javascript:countermand();\" text=\"" + SystemEnv.getHtmlLabelName(33355, user.getLanguage()) + "\" otherpara=\"pt+column:agenterId+column:beagenterid\" index=\"3\"/>";
    					operateString +=" </operates>";
    				 
            		}
            		tableString ="<table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REQUEST_WFAGENTLIST,user.getUID())+"\" >"+
                    "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.agentid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />";
                    tableString +=  operateString;
                    tableString += " <head>";
                    if(agentFlag.equals("1")){
                    	tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17565,user.getLanguage())+"\" column=\"beagenterid\" orderkey=\"t1.beagenterid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\" />";
					}
                    tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17566,user.getLanguage())+"\" column=\"agenterId\" otherpara=\"column:agentid\" transmethod=\"weaver.workflow.request.wfAgentCondition.getMulResourcename1\" />";
                    
                    tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"operatorid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\" />";
                    
                    tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(33234,user.getLanguage())+"\" column=\"workflowtype\"  transmethod=\"weaver.workflow.workflow.WFAgentTransMethod.getWFtype\" />";
			       	tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(18499,user.getLanguage())+"\" column=\"workflowname\"  />";
			       	tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"beginDate\"  otherpara=\"column:agentid\" transmethod=\"weaver.workflow.workflow.WFAgentTransMethod.getBeginDatetime\" />";
			       	tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"endDate\"  otherpara=\"column:agentid\" transmethod=\"weaver.workflow.workflow.WFAgentTransMethod.getEndDatetime\" />";
			       	//tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(33341,user.getLanguage())+"\" column=\"isCreateAgenter\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.WFAgentTransMethod.getCreateAgentName\"/>";
			       	tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1929,user.getLanguage())+"\" column=\"agenttype\" otherpara=\"column:beginDate+column:beginTime+column:endDate+column:endTime+"+user.getLanguage()+"+column:agentid\" transmethod=\"weaver.workflow.workflow.WFAgentTransMethod.getAgentType\" />";
			       	tableString+="</head></table>";
            		}
				}
				
            	//已办代理：===>代我处理的 & 我代为处理的
            	else if(agented.equals("1"))	
            	{
            		//System.out.println("已办");
            		backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid,t2.viewtype,t2.receivedate,t2.receivetime,t2.operatedate,t2.operatetime,t2.isremark,t2.nodeid,t2.agentorbyagentid,t2.agenttype ";
            		fromSql  = " from workflow_requestbase t1,workflow_currentoperator t2,workflow_base t3,hrmresource t4 ";
            		sqlWhere = " where t2.requestid=t1.requestid and t3.id = t1.workflowid and t4.id=t2.userid and t2.agenttype='2' and t2.isremark='2' and t2.islasttimes='1' ";
            		//已办代理：===>代我处理的	
            		if(agentFlag.equals("0"))
            		{
            			sqlWhere += " and t2.agentorbyagentid in("+userID+" )";
            		}
            		//已办代理：===>我代为处理的
            		else if(agentFlag.equals("1"))
            		{
            			sqlWhere += " and t2.userid in("+userID+" )";
            		}
            		//基于类别调用
         		   	if(menutype.equals("type"))
         		   	{
         			   sqlWhere =sqlWhere+ "  and  t3.workflowtype='"+menuid+"'  ";
					}else  if(menutype.equals("workflow")){
         			
         		    	sqlWhere =sqlWhere+ "  and  t3.id='"+menuid+"'  ";    
         			}
         		    String requestName = Util.null2String(request.getParameter("requestname"));
            		if (!"".equals(requestName)) {
            			sqlWhere += " AND t1.requestname LIKE '%" + requestName + "%'";
            		}
            		String workcode = Util.null2String(request.getParameter("workcode"));
            		if (!"".equals(workcode)) {
            			sqlWhere += " AND t1.creatertype='0' AND t1.creater IN (SELECT id FROM hrmresource WHERE workcode LIKE '%" + workcode + "%')";
            		}
            		if (!"".equals(requestlevel)) {
            			sqlWhere += " AND t1.requestlevel=" + requestlevel;
            		}
            		if (!"".equals(creatertype)) {
            			if ("0".equals(creatertype)) {
            				if (!"".equals(createrid)) {
            					sqlWhere += " AND t1.creatertype<>1 AND t1.creater=" + createrid;
            				}
            			} else if ("1".equals(creatertype)) {
            				if (!"".equals(createrid2)) {
            					sqlWhere += " AND t1.creatertype=1 AND t1.creater=" + createrid2;
            				}
            			}
            		}
            		sqlWhere += newsql;
            		//System.out.println("sqlWhere:==>"+sqlWhere);
            		//System.out.println("newsql:==>"+newsql);
            		int isovertime = 0;
            		orderby = " t1.requestid, t2.operatedate,t2.operatetime ";
					for(int k=0;k<userlist.size();k++){
	  int beagenterid2 = Util.getIntValue((String)userlist.get(k));
	   userID = Util.null2String((String)userlist.get(k));
					String para2="column:requestid+column:workflowid+column:viewtype+"+isovertime+"+"+user.getLanguage()+"+column:nodeid+column:isremark+"+userID+"+column:agentorbyagentid+column:agenttype";
                    String para4=user.getLanguage()+"+"+user.getUID();
                                                                         
                    tableString ="<table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REQUEST_WFAGENTLIST,user.getUID())+"\" >"+
                                 "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                                 "<head>";
                    tableString+="<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  otherpara=\""+para2+"\"/>";
                    tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
                    tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(15586,user.getLanguage())+"\" column=\"currentnodeid\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
                    tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(32532,user.getLanguage())+"\" column=\"operatedate\" orderkey=\"t1.operatedate,t1.operatetime\" otherpara=\"column:operatetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                    tableString+="</head></table>"; 
            	}
}
            %>
            <wea:SplitPageTag tableString='<%=tableString%>' mode="run"/>
            <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_REQUEST_WFAGENTLIST%>"/>
        </td>
    </tr>
</TABLE>

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
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</form>
</body>

<script type="text/javascript">
	//流程类型过滤
	function setWFbyType()
	{
		var selvar = jQuery('#wftype').val();
		jQuery("#wfidbytype").val("");
		jQuery("span[name='wfidbytypespan']").html("");
		jQuery("#outwfidbytypediv").next().find("button").remove();
		jQuery("#outwfidbytypediv").next().find("span").append("<button class='Browser e8_browflow' type='button' onclick=showModalDialogForBrowser(event,'/workflow/workflow/WFTypeBrowserContenter.jsp?wftypeid="+selvar+"','#','wfidbytype',true,1,'',{name:'wfidbytype',hasInput:true,zDialog:true,dialogTitle:'<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>',arguments:''});></button>")
	}
//分页控件 菜单 标志为已读



		function doReadIt(requestid,otherpara,obj)
		{
			$.ajax({ 
		        type: "GET",
		        url: "WFSearchResultReadIt.jsp?requestid="+requestid+"&userid=<%=userID%>&usertype=<%=user.getLogintype()+""%>",
		        success:function(){
		        	_table.reLoad();
		        }
	        });
		}
		
		//分页控件 菜单 转发功能
		function doReview(requestid)
		{
			//看原逻辑应该有保存表单签章，暂时不知其逻辑,并还有一个参数



			//目前只要有转发按钮的都打开转发页面
			//参考ManageRequestNoFormIframe.jsp
			var forwardurl = "/workflow/request/Remark.jsp?requestid="+requestid;
			openFullWindowHaveBar(forwardurl);
		}
		
		//分页控件 菜单 打印功能
		function doPrint(requestid)
		{	
			//打印貌似没这么简单，看原始逻辑还需要设置一些信息



			//目前只是把打印页面打开
			//参考ManageRequestNoFormIframe.jsp
			openFullWindowHaveBar("/workflow/request/PrintRequest.jsp?requestid="+requestid+"&isprint=1&fromFlowDoc=1");
		}
		
		// 分页控件 菜单 新建流程
		function doNewwf(requestid,newwfpara)
		{
			var pms = newwfpara.split("+");
			var wfid = pms[0];
			var agent = pms[1];
			openFullWindowHaveBar("/workflow/request/AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&reqid="+requestid);
		}
		
		//分页控件 菜单 新建短信
		function doNewMsg(requestid,newmsgpara)
		{
			var pms = newmsgpara.split("+");
			var wfid = pms[0];
			var nodeid = pms[1];
			openFullWindowHaveBar("/sms/SendRequestSms.jsp?workflowid="+wfid+"&nodeid="+nodeid+"&reqid="+reqid);
		}
		
		//分页控件 菜单 查看表单日志
		function seeFormLog(requestid,nodeid)
		{
			var wfmonitor = false;
			var _wfmonitor = 0;
			//流程监控人



			if(wfmonitor) 
				_wfmonitor = 1;
			openFullWindowHaveBar("/workflow/request/RequestModifyLogView.jsp?requestid="+requestid+"&nodeid="+nodeid+"&isAll=0&ismonitor="+_wfmonitor+"&urger=0");
		}

function onShowWorkFlow(inputname, spanname) {
	onShowWorkFlowBase(inputname, spanname, false);
}

function onShowWorkFlowBase(inputname, spanname, needed) {
	var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	if (retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
			$GetEle(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
			$GetEle("objid").value = wuiUtil.getJsonValueByIndex(retValue, 0);
		} else { 
			$GetEle(inputname).value = "";
			if (needed) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
			$GetEle("objid").value = "";
		}
	}
}
</script>


<SCRIPT language="javascript">
	
	function OnMultiSubmitNew(obj)
	{
		var agentids = _xtable_CheckedCheckboxId();
		 
		if(agentids === "")
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>")
		else
			countermand(agentids,"mt");
		//mt: 列表页面的批量收回;
		//it：列表上的按钮“收回此条代理”;
		//pt：列表上的按钮”收回全部代理“;
	}
	
	function  commitdata(){
		var value=$("input[name='flowTitle']",parent.document).val();
		$("input[name='requestname']").val(value);
		document.frmmain.submit();
   	}
   
   	//跳转到已办代理 页面
	function trunAgented(){
		var leftframe = $("#leftframe",parent.parent.document);
		leftframe.attr("src","/workflow/request/wfAgentAllTreeList.jsp?agentFlag=0");
		var contentframe=$("#contentframe",parent.parent.document);
        contentframe.attr("src","/workflow/request/wfAgentAll.jsp?agented=1&agentFlag=0");
   	}
   //跳转到设置代理页面



   	function trunSetAgent()
   	{
   		var leftframe = $("#leftframe",parent.parent.document);
		leftframe.attr("src","");
		$("#oTd1",parent.parent.document).css("display","none");
   		var contentframe=$("#contentframe",parent.parent.document);
        contentframe.attr("src","/workflow/request/wfAgentAll.jsp?agented=0&agentFlag=0");
   	}
   	//跳转到日志



   	function trunLog() {
   		var contentframe=$("#contentframe",parent.parent.document);
        contentframe.attr("src","/workflow/request/agentLogList.jsp");
   	}
   	
   	
   	var dialog = null;
   	//弹出新建代理页面
   	function popSetAgentWin(id)
   	{
   		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/request/wfAgentAdd.jsp?isdialog=1&f_weaver_belongto_userid=<%=user.getUID()%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17723,user.getLanguage()) %>";
		 
		dialog.Width = 650;
		dialog.Height = 520;
		//dialog.Drag = true;
		dialog.URL = url;
		dialog.maxiumnable = true;
		dialog.show();		
   	}
   	
    function cz()
	{
	  _xtable_CleanCheckedCheckbox();
	}
   	
   	
   	//弹出收回代理确认页面
   	function countermand(agentid,type)
	{
	 
		var url = "";
		
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
	 
		if(type === "it" || type=== "mt"){
			url = "/workflow/request/wfAgentGetBackConfirm.jsp?agentid="+agentid+"&type="+type;
		}else
		{
			
			var agenterid = type.split("+")[1];
			var beagenterid = type.split("+")[2];
			//var agentcount = type.split("+")[3];
			url = "/workflow/request/wfAgentGetBackConfirm.jsp?agentid="+agentid+"&type=pt&agenterid="+agenterid+"&beagenterid="+beagenterid;
		}
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(33350,user.getLanguage())%>";
		dialog.Width = 400;
		dialog.Height = 170;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
//N代理条件
function onagentcondition(agentid,type){
 
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var agenterid = type.split("+")[1];
		var beagenterid = type.split("+")[2];
	 	var agentworkflowid = type.split("+")[3];
		var url = "/workflow/request/wfAgentCondition.jsp?agentid="+agentid+"&type=pt&agenterid="+agenterid+"&beagenterid="+beagenterid+"&workflowid="+agentworkflowid;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(82586,user.getLanguage())%>";
		dialog.Width = 900;
		dialog.Height = 570;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
}
//编辑
function onagentedit(agentid,type){
	  	dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var agenterid = type.split("+")[1];
		var beagenterid = type.split("+")[2];
	 	var agentworkflowid = type.split("+")[3];
		var url = "/workflow/request/wfAgentEditCondition.jsp?agentid="+agentid+"&type=pt&agenterid="+agenterid+"&beagenterid="+beagenterid+"&workflowid="+agentworkflowid;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(82595,user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height =550;
		dialog.Drag = true;
		 
		dialog.URL = url;
		dialog.show();
}

   jQuery("#topTitle").topMenuTitle({searchFn:commitdata});

    var showTableDiv = document.getElementById('divshowreceivied');
    var oIframe = document.createElement('iframe');
    function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("div");
        message_Div.id="message_Div";
        message_Div.className="xTable_message";
        showTableDiv.appendChild(message_Div);
        var message_Div1 = document.getElementById("message_Div");
        message_Div1.style.display="inline";
        message_Div1.innerHTML=content;
        var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
        var pLeft= document.body.offsetWidth/2-50;
        message_Div1.style.position="absolute"
        message_Div1.style.top=pTop;
        message_Div1.style.left=pLeft;

        message_Div1.style.zIndex=1002;

        oIframe.id = 'HelpFrame';
        showTableDiv.appendChild(oIframe);
        oIframe.frameborder = 0;
        oIframe.style.position = 'absolute';
        oIframe.style.top = pTop;
        oIframe.style.left = pLeft;
        oIframe.style.zIndex = message_Div1.style.zIndex - 1;
        oIframe.style.width = parseInt(message_Div1.offsetWidth);
        oIframe.style.height = parseInt(message_Div1.offsetHeight);
        oIframe.style.display = 'block';
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
        function showallreceived(requestid,returntdid){
        showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
        var ajax=ajaxinit();

        ajax.open("POST", "/workflow/search/WorkflowUnoperatorPersons.jsp", true);
        ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
        ajax.send("requestid="+requestid+"&returntdid="+returntdid);
        //获取执行状态



        //alert(ajax.readyState);
        //alert(ajax.status);
        ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里



        if (ajax.readyState==4&&ajax.status == 200) {
        try{
        document.getElementById(returntdid).innerHTML = ajax.responseText;
        }catch(e){}
        showTableDiv.style.display='none';
        oIframe.style.display='none';
        }
        }
        }

</script>

<SCRIPT language="javascript" src="/js/ecology8/request/wFCommonAdvancedSearch_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script>
	function setSelectBoxValue(selector, value) {
		if (value == null) {
			value = jQuery(selector).find('option').first().val();
		}
		jQuery(selector).selectbox('change',value,jQuery(selector).find('option[value="'+value+'"]').text());
	}

	function cleanBrowserValue(name) {
		_writeBackData(name, 1, {id:'',name:''});
	}

	function onReset() {
		//browser
		jQuery('#frmmain .e8_os input[type="hidden"]').each(function() {
			cleanBrowserValue(jQuery(this).attr('name'));
		});
		//input
		jQuery('#frmmain input:text').val('');
		//select
		jQuery('#frmmain select').each(function() {
			setSelectBoxValue(this);
		});
		//流程状态特殊处理



		setSelectBoxValue('#frmmain select[name="agentstatus"]', '1');
	}

	$(".resetitem").click(function(){
		onReset();
	});

	function agentdetail()
	{

     var mainframe=$("#mainFrame",parent.parent.parent.document);
	 mainframe.attr("src","/workflow/request/wfAgentManager.jsp");   
	 
	}

	function changeType(v, s1, s2) {
		if (1 == v) {
			jQuery('#' + s1).hide();
			jQuery('#' + s2).show();
		} else {
			jQuery('#' + s2).hide();
			jQuery('#' + s1).show();
		}
	}

	function getFlowWindowUrl() {
		return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=" + $G("wftype").value;
	}
 </script>
</html>
