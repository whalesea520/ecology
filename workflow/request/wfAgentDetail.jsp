
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*,weaver.workflow.request.WFWorkflows,weaver.workflow.request.WFWorkflowTypes"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="TimeUtil" class="weaver.general.TimeUtil" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT type="text/javascript" src="../../js/weaver_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
　  <script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</head>

<BODY>
<FORM id=frmmain name=frmmain method=post action="">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   //菜单
    RCMenu += "{" + SystemEnv.getHtmlLabelName(365, user.getLanguage()) + ",javascript:agentadd(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{" + SystemEnv.getHtmlLabelName(2081, user.getLanguage()) + ",javascript:openFavouriteBrowser(),_self}";
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{" + SystemEnv.getHtmlLabelName(275, user.getLanguage()) + ",javascript:showHelp(),_self}";
    RCMenuHeight += RCMenuHeightStep;


    String agentInfo = Util.null2String(request.getParameter("agentInfo"));
	String nodetype = Util.null2String(request.getParameter("nodetype"));
	String creatertype = Util.null2String(request.getParameter("creatertype"));
	String createrid = Util.null2String(request.getParameter("createrid"));
	String agentlevel = Util.null2String(request.getParameter("agentlevel"));
    //创建日期标识
	String datecondition=Util.null2String(request.getParameter("createdateselect"));
	//接收日期标识
	String agentenddateselect = Util.null2String(request
				.getParameter("agentdateendselect"));
    //代理开始日期

	String agentdateselect = Util.null2String(request
				.getParameter("agentdateselect"));
    //代理创建日期日期
	String agentcreatedateselect = Util.null2String(request
				.getParameter("agentcreatedateselect"));

	//1.基于流程类别调用(type) 2.基于流程调用(workflow)
    String method=Util.null2String(request
				.getParameter("method"));

    String objid=Util.null2String(request
				.getParameter("objid"));

     int  agentid=Util.getIntValue(request.getParameter("agentid"),0);
	 int beagentid=Util.getIntValue(request.getParameter("beagentid"),0);
     int agentdepartmentid = Util.getIntValue(request.getParameter("agentdepartmentid"),0);
	 int beagentdepartmentid=Util.getIntValue(request.getParameter("beagentdepartmentid"),0);
     int agentsubcompanyid = Util.getIntValue(request.getParameter("agentsubcompanyid"),0);
	 int beagentsubcompanyid= Util.getIntValue(request.getParameter("beagentsubcompanyid"),0);

     String wfid= Util.null2String(request.getParameter("wfid"));
	 String wftypeid= Util.null2String(request.getParameter("wftypeid"));

    boolean haveAgentAllRight=false;

    if(agentInfo.equals("")  ||  agentInfo.equals("0"))
	{
     	agentInfo="0";
        haveAgentAllRight=true;
	}
    else    
    if(HrmUserVarify.checkUserRight("WorkflowAgent:All", user)){
       haveAgentAllRight=true;
    }


   String imagefilename = "/images/hdDOC_wev8.gif";
   String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
   String needfav ="1";
   String needhelp ="";
   String userID = String.valueOf(user.getUID());
   String newsql=" where 1=1 ";
    

    // =====================添加页面上的查询条件            Start   =====================



    //高级搜索条件
    WfAdvanceSearchUtil  conditionutil=new  WfAdvanceSearchUtil(request,RecordSet);
   
    String conditions=conditionutil.getAdVanceSearch4OAgentDetailCondition();

    if(!conditions.equals(""))
	{
	 newsql += conditions;
	}
    
 
 

   //基于类别调用
   if(method.equals("type"))
   {
      newsql =newsql+ "  and  workflowtype='"+objid+"'  ";

    }else  if(method.equals("workflow")){
	
      newsql =newsql+ "  and  workflowid='"+objid+"'  ";    
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
perpage=10;







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




%>




		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/wfSearchResult_wev8.js"></script>
		<table id="topTitle" cellpadding="0" cellspacing="0" style="width:100%">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan">
				    <input type="button" value="<%=SystemEnv.getHtmlLabelName(33242,user.getLanguage())%>" class="e8_btn_top middle" onclick="agentadd()">
                      
                    <% if(haveAgentAllRight){ %>
                    <input type="button" value="<%=SystemEnv.getHtmlLabelName(33243,user.getLanguage())%>" class="e8_btn_top middle" onclick="agentBackByBatch()">
                    <% } %>
					&nbsp;&nbsp;&nbsp;
                    <span class="placefolder" style="display:inline-block;width:40px;"></span>
					<input type="text" class="searchInput" name="wfname"/>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>


<%
%>
			
<input type='hidden' name='agentInfo'  value="<%=agentInfo%>">
<input type='hidden' name='method' value="<%=method%>">
<input type='hidden' name='objid' value="<%=objid%>">
 
 <!--高级设置表单   -------begin-->
<div class="advancedSearchDiv" id="advancedSearchDiv">

   <wea:layout type="4col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(22256, user.getLanguage())%></wea:item>
		    	<wea:item>
			    	<brow:browser viewType="0" name="wftypeid" browserValue='<%= wftypeid %>' browserOnClick="" browserUrl="/workflow/workflow/WorkTypeBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=WorkTypeComInfo.getWorkTypename(wftypeid)%>'> 
				   </brow:browser> 
		    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(259, user.getLanguage())%></wea:item>
	    	<wea:item>
			     <brow:browser viewType="0" name="wfid" browserValue='<%= wfid %>' browserOnClick="" browserUrl="/workflow/workflow/WorkflowBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=WorkflowComInfo.getWorkflowname(wfid)%>'> 
				   </brow:browser> 
			</wea:item>
	    	<wea:item>
                 <%=SystemEnv.getHtmlLabelName(33362, user.getLanguage())%>

            </wea:item>
	    	<wea:item>
	    		<select class=inputstyle name=agentlevel width="80%" size=1>
					<option value=""></option>
					<option value="0"
							<% if(agentlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24324, user.getLanguage())%>
								</option>
					<option value="1"
							<% if(agentlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1979, user.getLanguage())%>
								</option>
					<option value="2"
							<% if(agentlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(33348, user.getLanguage())%>

								</option>
					<option value="3"
							<% if(agentlevel.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22348, user.getLanguage())%>
								</option>
				</select>
	    	</wea:item>
            
			   <%  if(!agentInfo.equals("0")) { %> 
		
		 
            <wea:item><%=SystemEnv.getHtmlLabelName(17565, user.getLanguage())%></wea:item>
            <wea:item>
	
                <brow:browser viewType="0" name="beagentid" browserValue='<%= ""+beagentid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=beagentid!=0?Util.toScreen(ResourceComInfo.getResourcename(beagentid+""),user.getLanguage()):""%>'> </brow:browser> 
             </wea:item>
            <wea:item> <%=SystemEnv.getHtmlLabelName(17565, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27511, user.getLanguage())%></wea:item>
            <wea:item>
	        	 
                 <brow:browser viewType="0" name="beagentdepartmentid" browserValue='<%= ""+beagentdepartmentid %>' browserOnClick="" browserUrl="/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue='<%=beagentdepartmentid!=0?Util.toScreen(DepartmentComInfo.getDepartmentname(beagentdepartmentid+""),user.getLanguage()):""%>'> </brow:browser> 

             </wea:item>
             <wea:item><%=SystemEnv.getHtmlLabelName(17565, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></wea:item>
             <wea:item>

				  <brow:browser viewType="0" name="beagentsubcompanyid" browserValue='<%= ""+beagentsubcompanyid %>' browserOnClick="" browserUrl="/hrm/company/SubcompanyBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=beagentsubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(beagentsubcompanyid+""),user.getLanguage()):""%>'> </brow:browser> 
            </wea:item>

			<wea:item ><%=SystemEnv.getHtmlLabelName(17566, user.getLanguage())%></wea:item>
	    	<wea:item >
	    		<brow:browser viewType="0" name="agentid" browserValue='<%= ""+agentid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="33%" browserSpanValue='<%=agentid!=0?Util.toScreen(ResourceComInfo.getResourcename(agentid+""),user.getLanguage()):""%>'> </brow:browser> 
	    	</wea:item>
  
	<% } else {%>


	    	<wea:item ><%=SystemEnv.getHtmlLabelName(17566, user.getLanguage())%></wea:item>
	    	<wea:item >
	    		<brow:browser viewType="0" name="agentid" browserValue='<%= ""+agentid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=agentid!=0?Util.toScreen(ResourceComInfo.getResourcename(agentid+""),user.getLanguage()):""%>'> </brow:browser> 
	    	</wea:item>

			<%
	           } 	
			%>
	    	
	    </wea:group>
	     <wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'  attributes="{'itemAreaDisplay':'none'}">
	    	<wea:item><%=SystemEnv.getHtmlLabelName(17566, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27511, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		 <brow:browser viewType="0" name="agentdepartmentid" browserValue='<%= ""+agentdepartmentid %>' browserOnClick="" browserUrl="/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue='<%=agentdepartmentid!=0?Util.toScreen(DepartmentComInfo.getDepartmentname(agentdepartmentid+""),user.getLanguage()):""%>'> </brow:browser> 
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(17566, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<brow:browser viewType="0" name="agentsubcompanyid" browserValue='<%= ""+agentsubcompanyid %>' browserOnClick="" browserUrl="/hrm/company/SubcompanyBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=agentsubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(agentsubcompanyid+""),user.getLanguage()):""%>'> </brow:browser> 
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(26241, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(740, user.getLanguage())%></wea:item>
	        <wea:item  attributes="{\"colspan\":\"3\"}">
	    		<span style='float:left;display:inline-block;width:33%;'>
					<select style='width:100%;'  name="agentdateselect" id="agentdateselect" style="width: 150px" onchange="changeDate(this,'agentdate');" class="styled"  value="<%=agentdateselect%>" >
						<option value="0"  <% if(agentdateselect.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
						<option value="1" <% if(agentdateselect.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage())%></option>
						<option value="2" <% if(agentdateselect.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage())%></option>
						<option value="3" <% if(agentdateselect.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage())%></option>
						<option value="4" <% if(agentdateselect.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage())%></option>
						<option value="5" <% if(agentdateselect.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage())%></option>
						<option value="6" <% if(agentdateselect.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32530, user.getLanguage())%></option>
					</select>
				  </span>
					  <span  style='float:left;margin-left: 10px;padding-top: 5px;'>
					  <span id="agentdate" style="display:<% if(!agentdateselect.equals("6")) {%>none<%}%>;">
					  <button type="button" class="calendar" id="SelectDate" onclick="getDate(agentdateselectfromspan,agentdateselectfrom)"></button>&nbsp;
					  <span id="agentdateselectfromspan"><%=Util.null2String(request.getParameter("agentdateselectfrom"))%></span>
					  -&nbsp;&nbsp;<button type="button" class="calendar" id="SelectDate2" onclick="getDate(agentdateselecttospan,agentdateselectto)"></button>&nbsp;
					  <span id="agentdateselecttospan"><%=Util.null2String(request.getParameter("agentdateselectto"))%></span>
					  </span>
					  <input type="hidden" name="agentdateselectfrom" value="<%=Util.null2String(request.getParameter("agentdateselectfrom"))%>">
					  <input type="hidden" name="agentdateselectto" value="<%=Util.null2String(request.getParameter("agentdateselectto"))%>">
				  </span>
	    	</wea:item>
	    	<wea:item>代理<%=SystemEnv.getHtmlLabelName(24980, user.getLanguage())%></wea:item>
	    	 <wea:item  attributes="{\"colspan\":\"3\"}">
	    		<span style='float:left;display:inline-block;width:33%;'>
					<select style='width:100%;' name="agentdateendselect" id="agentdateendselect" style="width: 150px" onchange="changeDate(this,'agentdateend');" class="styled">
						<option value="0"  <% if(agentenddateselect.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
						<option value="1" <% if(agentenddateselect.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage())%></option>
						<option value="2" <% if(agentenddateselect.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage())%></option>
						<option value="3" <% if(agentenddateselect.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage())%></option>
						<option value="4" <% if(agentenddateselect.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage())%></option>
						<option value="5" <% if(agentenddateselect.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage())%></option>
						<option value="6" <% if(agentenddateselect.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32530, user.getLanguage())%></option>
					</select>
				  </span>
				  <span  style='float:left;margin-left: 10px;padding-top: 5px;'>
					   <span id="agentdateend" style="display: <% if(!agentenddateselect.equals("6")) {%>none<%}%>;">
					   <button type="button" class="calendar" id="SelectDate" onclick="getDate(agentenddatefromspan,agentenddatefrom)"></button>&nbsp;
					  <span id="agentenddatefromspan"><%=Util.null2String(request.getParameter("agentenddatefrom"))%></span>
					  -&nbsp;&nbsp;<button type="button" class="calendar" id="SelectDate1" onclick="getDate(agentenddatetospan,agentenddateto)"></button>&nbsp;
					  <span id="agentenddatetospan"><%=Util.null2String(request.getParameter("agentenddateto"))%></span>
					  </span>
					  <input type="hidden" name="agentenddatefrom" value="<%=Util.null2String(request.getParameter("agentenddatefrom"))%>">
					  <input type="hidden" name="agentenddateto" value="<%=Util.null2String(request.getParameter("agentenddateto"))%>">
				  </span>
	    	</wea:item>

            <wea:item><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></wea:item>
			<wea:item  attributes="{\"colspan\":\"3\"}">
	    		<span style='float:left;display:inline-block;width:33%;'>
					<select style='width:100%;'  name="agentcreatedateselect" id="agentcreatedateselect" style="width: 150px" onchange="changeDate(this,'agentcreatedate');" class="styled">
					<option value="0"  <% if(agentcreatedateselect.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
					<option value="1" <% if(agentcreatedateselect.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage())%></option>
					<option value="2" <% if(agentcreatedateselect.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage())%></option>
					<option value="3" <% if(agentcreatedateselect.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage())%></option>
					<option value="4" <% if(agentcreatedateselect.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage())%></option>
					<option value="5" <% if(agentcreatedateselect.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage())%></option>
					<option value="6" <% if(agentcreatedateselect.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32530, user.getLanguage())%></option>
				</select>
			  </span>
			   <span  style='float:left;margin-left: 10px;padding-top: 5px;'>
					  <span id="agentcreatedate" style="display: <% if(!agentcreatedateselect.equals("6")) {%>none<%}%>;">
					  <button type="button" class="calendar" id="SelectDate" onclick="getDate(agentcreatedatefromspan,agentcreatedatefrom)"></button>&nbsp;
					  <span id="agentcreatedatefromspan"><%=Util.null2String(request.getParameter("agentcreatedatefrom"))%></span>
					  -&nbsp;&nbsp;<button type="button" class="calendar" id="SelectDate1" onclick="getDate(agentcreatedatetospan,agentcreatedateto)"></button>&nbsp;
					  <span id="agentcreatedatetospan"><%=Util.null2String(request.getParameter("agentcreatedateto"))%></span>
					  </span>
					  <input type="hidden" name="agentcreatedatefrom" value="<%=Util.null2String(request.getParameter("agentcreatedatefrom"))%>">
					  <input type="hidden" name="agentcreatedateto" value="<%=Util.null2String(request.getParameter("agentcreatedateto"))%>">
			  </span>
			</wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
		    <wea:item>
			     <select class=inputstyle size=1 name=wfstatu style=width:33%>
				<option value="2"
						<% if(Util.null2String(request.getParameter("wfstatu")).equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>
							</option>
				<option value="1"
						<% if(Util.null2String(request.getParameter("wfstatu")).equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2246, user.getLanguage())%>
							</option>
				<option value="0"
						<% if(Util.null2String(request.getParameter("wfstatu")).equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245, user.getLanguage())%>
							</option>
				
			</select>
			</wea:item>

	    </wea:group>
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
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.getPageSize(PageIdConst.WF_REQUEST_WFAGENTDETAIL %>"/>
</div>
<!--- 高级设置结束 -->





<TABLE width="100%"  cellspacing="0" cellpadding="0">
    <tr>
        <td valign="top">
            <%
                            String tableString = "";
                            String backfields = " agentId,workflowId,isCreateAgenterBy,currenstatu,agentname,begentname,typename,workflowname,isCreateAgenter,agenterId,beagenterId,workflowtype,begintime,endtime";
							String fromSql="";
							//System.out.println("this is agentInfo==>"+agentInfo);

                            String orderby="";

                            //我的代理
						    if(agentInfo.equals("0"))
							{
							fromSql  = "  from (select  case when isCreateAgenter='1' then '是' else '否' end as isCreateAgenterBy,case  when GETDATE()&lt;begintime then '未开始' when GETDATE()&gt;endtime then '已结束'   else '代理中' end  as currenstatu,*   from(select  a.agentId,b.isvalid,a.workflowId,d.departmentid,d.subcompanyid1,d.lastname as agentname,e.lastname as begentname,c.typename,b.workflowname,isCreateAgenter,a.agenterId,a.beagenterId,b.workflowtype,a.begintime,a.endtime,a.createtime  from (select a.agentId,a.agenterId,a.beagenterId,a.workflowId,a.isCreateAgenter,a.beginDate+' '+a.beginTime as begintime,a.endDate+' '+a.endTime as endtime,a.operatordate+' '+a.operatortime as createtime from Workflow_Agent a  where a.beagenterId='"+user.getUID()+"'  and  a.agenttype='1')a  inner join workflow_base b  on a.workflowId=b.id inner join workflow_type c on b.workflowtype=c.id inner join HrmResource d on a.agenterId=d.id inner join HrmResource e on a.beagenterId=e.id)a)a  ";

                            orderby=" agenterId,workflowtype ";

                            }
							//其他人的代理
							else  if(agentInfo.equals("1"))
							{
							fromSql  = "  from (select  case when isCreateAgenter='1' then '是' else '否' end as isCreateAgenterBy,case  when GETDATE()&lt;begintime then '未开始' when GETDATE()&gt;endtime then '已结束'   else '代理中' end  as currenstatu,*   from(select  a.agentId,b.isvalid,a.workflowId,d.departmentid,d.subcompanyid1,e.departmentid as beagentdepartmentid,e.subcompanyid1 as beagentsubcompanyid1,d.lastname as agentname,e.lastname as begentname,c.typename,b.workflowname,isCreateAgenter,a.agenterId,a.beagenterId,b.workflowtype,a.begintime,a.endtime,a.createtime  from (select a.agentId,a.agenterId,a.beagenterId,a.workflowId,a.isCreateAgenter,a.beginDate+' '+a.beginTime as begintime,a.endDate+' '+a.endTime as endtime,a.operatordate+' '+a.operatortime as createtime from Workflow_Agent a  where a.beagenterId!='"+user.getUID()+"' and a.agenttype='1')a  inner join workflow_base b  on a.workflowId=b.id inner join workflow_type c on b.workflowtype=c.id inner join HrmResource d on a.agenterId=d.id inner join HrmResource e on a.beagenterId=e.id)a)a  ";

                            orderby="  beagenterId,agenterId,workflowtype  ";

							}
							String sqlWhere = newsql;
                            int isovertime = 0;
                            String para2="column:requestid+column:workflowid+column:viewtype+"+isovertime+"+"+user.getLanguage()+"+column:nodeid+column:isremark+"+userID+"+column:agentorbyagentid+column:agenttype";
                            String para4=user.getLanguage()+"+"+user.getUID();

                            String operateString= "";
					        //流程操作菜单 add by Dracula @2014-1-6 
					        
					        	String popedomAgentpara = "column:agentId";

					        	String popeAgentpara = user.getUID()+"_"+agentInfo;
					        	
								operateString = "<operates>";

				        		operateString +=" <popedom transmethod=\"weaver.general.WorkFlowTransMethod.getWFAgentBackOperation\"  otherpara=\""+popeAgentpara+"\"   ></popedom> ";


			        			operateString +="     <operate href=\"javascript:doReadIt();\" text=\""+SystemEnv.getHtmlLabelName(18458,user.getLanguage())+"\" otherpara=\""+popedomAgentpara+"\" index=\"0\"/>";
			        			
				 	       		operateString +="</operates>";
				 	       		
                            tableString ="<table class='wfagentinfo' instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REQUEST_WFAGENTDETAIL,user.getUID())+"\" >"+
							" <checkboxpopedom  id=\"checkbox\"  popedompara=\""+popeAgentpara+"\" showmethod=\"weaver.general.WorkFlowTransMethod.getWFAgentBackOperationCheckBox\" />"+
                                         "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"agentid\" sqlsortway=\"Desc\"  />"+
                                         operateString +
                                         " <head>";

                            if(agentInfo.equals("1"))
                            tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17565,user.getLanguage())+"\" column=\"beagenterId\" orderkey=\"beagenterId\" otherpara=\"column:creatertype\"   transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";

                            tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17566,user.getLanguage())+"\" column=\"agenterId\" orderkey=\"agenterId\"  otherpara=\"column:creatertype\"  transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";


                            tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22256,user.getLanguage())+"\" column=\"typename\" orderkey=\"workflowtype\" />";


							tableString+="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowId\" orderkey=\"workflowId\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";


                            tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"begintime\"  orderkey=\"begintime\"  />";


                            tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"endTime\"  orderkey=\"endTime\"  />";

                            

                            tableString+="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(33341,user.getLanguage())+"\" column=\"isCreateAgenterBy\" orderkey=\"isCreateAgenterBy\" />";


							tableString+="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1929,user.getLanguage())+"\" column=\"currenstatu\" orderkey=\"currenstatu\" />";

                            tableString+="</head></table>";
            %>

<% //System.out.println(tableString);  
%>

            <wea:SplitPageTag tableString='<%=tableString%>' mode="run"/>
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


<script type="text/javascript">

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

    function  commitdata(){
   
       	    var value=$("input[name='wfname']",parent.document).val();
		    $("input[name='wfname']").val(value);
		    document.frmmain.submit();
   
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
<SCRIPT language="javascript" src="/js/ecology8/request/wfAgentManagerDetail_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script>

  
    $(".resetitem").click(function(){
	
	      resetForm();
	      
	
	});

    //添加代理
	function  agentadd()
	{
	
	  var mainframe=$("#mainFrame",parent.parent.parent.document);
	  mainframe.attr("src","/workflow/request/wfAgentAdd.jsp"); 
	
	}


    function  agentrowspan()
	{
       var agentinfo="<%=agentInfo%>";
	   if(agentinfo==="0")
	   {
       weaver_table_rowspan(".ListStyle",[2,3]);
       }else
	   {
	    weaver_table_rowspan(".ListStyle",[2,3,4]);
	   }
	}

    //初始化，保证代理数据列合并

    function  agentinitrowmerge()
	{
    	var agentinfo="<%=agentInfo%>";
	    if($(".ListStyle").length>0)
		{
		 if(agentinfo==="0")
	      {
              weaver_table_rowspan(".ListStyle",[2,3]);
          }else
	      {
	          weaver_table_rowspan(".ListStyle",[2,3,4]);
	      }
		}else
		setTimeout(agentinitrowmerge,200); 
	}

    agentinitrowmerge();


 </script>
 </body>
</html>
