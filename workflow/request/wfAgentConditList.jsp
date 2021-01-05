
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(33243,user.getLanguage())+",javascript:OnMultiSubmitNew(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;


String menuid=Util.null2String(request.getParameter("menuid"));
String menutype=Util.null2String(request.getParameter("menutype"));
String nodetype = Util.null2String(request.getParameter("nodetype"));
String creatertype = Util.null2String(request.getParameter("creatertype"));
String requestlevel = Util.null2String(request.getParameter("requestlevel"));
String createrid = Util.null2String(request.getParameter("createrid"));
String createrid2 = Util.null2String(request.getParameter("createrid2"));

String userID = String.valueOf(user.getUID());
String agented="0";
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = "";
String agentFlag="0";
String beagenterid = Util.null2String(request.getParameter("beagenterid"));
if(!beagenterid.equals(""+user.getUID())){
	agentFlag="1";
}
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


boolean haveAgentAllRight = false;
if (HrmUserVarify.checkUserRight("WorkflowAgent:All", user)) {
	haveAgentAllRight = true;
}

int perpage=20;

int beagenterId2 = Util.getIntValue(request.getParameter("beagenterId2"),0);
int agenterId2 = Util.getIntValue(request.getParameter("agenterId2"),0);
String overlapagentstrid = Util.null2String((String)session.getAttribute(user.getUID()+"_"+beagenterId2+"_"+agenterId2));
 
%>


<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/wfSearchResult_wev8.js"></script>
<table id="topTitle" cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
	    <input type="button" value="<%=SystemEnv.getHtmlLabelName(33243, user.getLanguage())%>" class="e8_btn_top middle" onclick="OnMultiSubmitNew(this)">
			<input type="text" class="searchInput" name="flowTitle"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>


<%
%>
			
 
 <!--高级设置表单   -------begin-->
<div class="advancedSearchDiv" id="advancedSearchDiv">
   <wea:layout type="4col">
   	<%if(agented.equals("0")){%>
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
    		<wea:item><%=SystemEnv.getHtmlLabelName(17565, user.getLanguage())%></wea:item>
    		<wea:item>
			 <%=ResourceComInfo.getLastname(user.getUID()+"") %>
			 
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
					<option value="4" <%=agentstatus.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(22348, user.getLanguage())%></option>
				</select>
	    	</wea:item>
	    </wea:group>
	    
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'  attributes="{'itemAreaDisplay':'none'}">
		 
	    	<wea:item><%=SystemEnv.getHtmlLabelName(17566, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27511, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<brow:browser viewType="0" name="aiddepartmentid" browserValue='<%=aiddepartmentid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue='<%=aiddepartmentname %>'> </brow:browser> 
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(17566, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		 <brow:browser viewType="0" name="aidsubcompanyid" browserValue='<%=aidsubcompanyid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=aidsubcompanyname %>'> </brow:browser> 
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
<%

String urlType = "17";
String pageId = PageIdConst.getWFPageId(urlType) ;
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.getWFPageId(urlType) %>"/>


<TABLE width="100%"  cellspacing="0" cellpadding="0">
    <tr>
        <td valign="top">
            <%
          
            	String newsql="";
            	String pageIdStr = "17";
				String tableString = "";
            	String backfields = "";
            	String fromSql="";
            	String sqlWhere = "";
            	String sqlCondition = "";
            	String orderby = "t1.beagenterid,t1.agenterid";
            	//added by xwj fortd2483 20050812
            	String currentDate=TimeUtil.getCurrentDateString();
            	String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
            	//System.out.println(agentFlag+"++++"+agented);\
            	//代理设置：===>我的代理 &　其他人的代理
            	if(agented.equals("0"))
            	{
            		backfields = " t1.operatorid, t1.agentid,t1.beagenterid,t1.agenterid,t1.workflowid,t2.id,t2.workflowtype,t2.workflowname,t1.beginDate,t1.beginTime,t1.endDate,t1.endTime,t1.isCreateAgenter,t1.agenttype ";
            		fromSql = " workflow_agent t1,workflow_base t2 ";
            		
            		
					String swt="  and (" + Util.getSubINClause(overlapagentstrid, "t1.agentid", "IN") + ") " ;
					
            		sqlWhere = " t1.workflowid = t2.id  and t2.isvalid='1' and agenttype=1 ";
            		if(selectBeginDate.equals("") && selectEndDate.equals("") && agentstatus.equals(""))
            			sqlWhere += swt;
            		if(!beagenterid.equals(""))
            			sqlCondition += " and t1.bagentuid='"+beagenterid+"' ";
            		if(!agenterid.equals(""))
            			sqlCondition += " and t1.agentuid='"+agenterid+"' ";
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
          			
          			if(agentstatus.equals("1")){
          				sqlCondition += swt;
          			}else if(agentstatus.equals("2")){
          				sqlCondition += " and t1.agenttype='1' and ((t1.beginDate ='"+currentDate+"' and t1.beginTime>'"+currentTime+"') or t1.beginDate>'"+currentDate+"') ";
          			}else if(agentstatus.equals("3")){
          			  if(RecordSet.getDBType().equals("oracle")){//标准开发时，未针对oracle数据库做特使控制导致oracle查询不到
            			  sqlCondition += swt + "  and ((TO_DATE(nvl(beginDate,'1900-01-01') || ' ' || nvl(beginTime,'00:00'),'yyyy-mm-dd hh24:mi')<= TO_DATE('"+currentDate+" "+currentTime+"','yyyy-mm-dd hh24:mi:ss')))";
            			}else{
            				sqlCondition += swt + " and (t1.beginDate='' or (t1.beginDate!='' and (t1.beginDate<'"+currentDate+"' or (t1.beginDate='"+currentDate+"' and (t1.beginTime='' or t1.beginTime is null or t1.beginTime>'"+currentTime+"')))))";            				  
            			}
       					//sqlCondition += swt + " and (t1.beginDate='' or (t1.beginDate!='' and (t1.beginDate<'"+currentDate+"' or (t1.beginDate='"+currentDate+"' and (t1.beginTime='' or t1.beginTime is null or t1.beginTime>'"+currentTime+"')))))";
       				}else if(agentstatus.equals("4")){
       					sqlCondition += " and t1.agenttype='0'";
          			
       				}if (!"".equals(aiddepartmentid)) {
          				sqlCondition += " AND t1.agenterid IN (SELECT id FROM hrmresource WHERE departmentid='"+aiddepartmentid+"')";
          			}
          			if (!"".equals(aidsubcompanyid)) {
          				sqlCondition += " AND t1.agenterid IN (SELECT id FROM hrmresource WHERE subcompanyid1='"+aidsubcompanyid+"')";
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
            			sqlWhere += " and t1.beagenterid ="+user.getUID();
            		}
            		if(sqlCondition.length()>0)
            			sqlWhere += sqlCondition;
            		//fromSql += swt;
            		//fromSql += " group by t1.agenterid ) t3 ";
            		
            	  	//out.println("sql:select "+backfields+" from "+fromSql+" where "+sqlWhere);
            		String operateString = "";
            		if ("0".equals(agentFlag) || haveAgentAllRight) {//
            			operateString = " <operates>";
            			operateString +="     <operate href=\"javascript:onagentedit();\" text=\"" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + "\" otherpara=\"ct+column:agenterId+column:beagenterid+column:workflowid\" index=\"0\"/>";
            			operateString +=" 	  <popedom transmethod=\"weaver.workflow.workflow.WFAgentTransMethod.getAgentOperation\" ></popedom> ";
    					operateString +="     <operate href=\"javascript:onagentcondition();\" text=\"" + SystemEnv.getHtmlLabelName(82586, user.getLanguage()) + "\" otherpara=\"ct+column:agenterId+column:beagenterid+column:workflowid\" index=\"0\"/>";
    					operateString +="     <operate href=\"javascript:countermand();\" text=\"" + SystemEnv.getHtmlLabelName(33354, user.getLanguage()) + "\" otherpara=\"it\" index=\"0\"/>";
    					operateString +=" </operates>";
            		}
            		tableString ="<table instanceid=\"workflowRequestListTable\"  pageId=\""+pageId+"\"  tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.getWFPageId(pageIdStr),user.getUID())+"\" >"+
                    "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.agentid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />";
                    tableString +=  operateString;
                    tableString += " <head>";
                    if(agentFlag.equals("1"))
                    tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17565,user.getLanguage())+"\" column=\"beagenterid\" orderkey=\"t1.beagenterid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\" />";
			       	tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17566,user.getLanguage())+"\" column=\"agenterId\" otherpara=\"column:agentid\" transmethod=\"weaver.workflow.request.wfAgentCondition.getMulResourcename1\" />";
			         tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"operatorid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\" />";
			       	tableString+="<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(33234,user.getLanguage())+"\" column=\"workflowtype\"  transmethod=\"weaver.workflow.workflow.WFAgentTransMethod.getWFtype\" />";
			       	tableString+="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18499,user.getLanguage())+"\" column=\"workflowname\"  />";
			       	tableString+="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"beginDate\"  otherpara=\"column:agentid\" transmethod=\"weaver.workflow.workflow.WFAgentTransMethod.getBeginDatetime\" />";
			       	tableString+="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"endDate\"  otherpara=\"column:agentid\" transmethod=\"weaver.workflow.workflow.WFAgentTransMethod.getEndDatetime\" />";
			       	//tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(33341,user.getLanguage())+"\" column=\"isCreateAgenter\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.WFAgentTransMethod.getCreateAgentName\"/>";
			       		tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1929,user.getLanguage())+"\" column=\"agenttype\" otherpara=\"column:beginDate+column:beginTime+column:endDate+column:endTime+"+user.getLanguage()+"+column:agentid\" transmethod=\"weaver.workflow.workflow.WFAgentTransMethod.getAgentType\" />";
			       	tableString+="</head></table>";
            	}
            %>
            <wea:SplitPageTag tableString='<%=tableString%>' mode="run"/>
            <input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.getWFPageId(urlType) %>"/>
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
		jQuery("#outwfidbytypediv").next().find("span").append("<button class='Browser e8_browflow' type='button' onclick=showModalDialogForBrowser(event,'/workflow/workflow/WFTypeBrowserContenter.jsp?wftypeid="+selvar+"','#','wfidbytype',true,1,'',{name:'wfidbytype',hasInput:true,zDialog:true,dialogTitle:'<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())%>',arguments:''});></button>")
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
		var url = "/workflow/request/wfAgentAddContent.jsp";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17723,user.getLanguage()) %>";
		if(!!id){//编辑
			url = "/workflow/request/wfAgentEdit.jsp?id="+id;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(17723,user.getLanguage()) %>";
		}
		dialog.Width = 650;
		dialog.Height = 450;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.maxiumnable = true;
		dialog.show();		
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
		dialog.Height =570;
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
	
   function cz()
	{
	  _xtable_CleanCheckedCheckbox();
	}
 </script>
</html>
