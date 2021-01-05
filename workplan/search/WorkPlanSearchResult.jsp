
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

 <%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.WorkPlan.WorkPlanShareUtil" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="workPlanSearch" class="weaver.WorkPlan.WorkPlanSearch" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="WorkPlanSetInfo"	class="weaver.WorkPlan.WorkPlanSetInfo" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
		<SCRIPT language="JavaScript" src="/js/weaver_wev8.js"></SCRIPT>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
	</HEAD>
<%
//是否初次加载
	int isFirst = Util.getIntValue(request.getParameter("isFirst"), 1);
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	String advanced = Util.null2String(request.getParameter("advanced"));  //1：被反馈  2：需要审批完成
	String currUserId = String.valueOf(user.getUID());  //用户ID
	String currUserType = user.getLogintype();  //用户类型
	String planName = Util.null2String(request.getParameter("planname"));  //日程名
	String urgentLevel = Util.null2String(request.getParameter("urgentlevel"));  //紧急程度
	String planType = Util.null2String(request.getParameter("plantype"));  //日程类型
	String planStatus = Util.null2String(request.getParameter("planstatus"));  //状态  0：代办；1：完成；2、归档
	String createrId = Util.null2String(request.getParameter("createrid"));  //提交人
	String receiveType = Util.null2String(request.getParameter("receiveType"));  //接受类型  1：人力资源 5：分部 2：部门
	String receiveID = Util.null2String(request.getParameter("receiveID"));  //接收ID
	String beginDate = Util.null2String(request.getParameter("begindate"));  //开始日期
	String endDate = Util.null2String(request.getParameter("enddate"));  //结束日期
	String beginDate2 = Util.null2String(request.getParameter("begindate2"));  //开始日期
	String endDate2 = Util.null2String(request.getParameter("enddate2"));  //结束日期
	String crmIds = Util.null2String(request.getParameter("crmids"));  //相关客户
	String docIds = Util.null2String(request.getParameter("docids"));  //相关文档
	String projectIds = Util.null2String(request.getParameter("prjids"));  //相关项目
	String requestIds = Util.null2String(request.getParameter("requestids"));  //相关流程
	
	String createrDep = Util.null2String(request.getParameter("createrDep"));  //相关项目
	String createrSub = Util.null2String(request.getParameter("createrSub"));  //相关流程
	
	int timeSag = Util.getIntValue(request.getParameter("timeSag"),0);
	int timeSagEnd = Util.getIntValue(request.getParameter("timeSagEnd"),0);

	String from = Util.null2String(request.getParameter("from"));  //返回页面标记

	if (planStatus.equals("-1"))
	{
	    planStatus = "";
	}

	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(356,user.getLanguage()) + ":&nbsp;"
					 + SystemEnv.getHtmlLabelName(2211,user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	
	boolean simpleSearch="1".equals(Util.null2String(request.getParameter("simpleSearch")));//快速部署,隐藏高级查询
%>


<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if(isFirst == 1) {
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;	

    	RCMenu += "{"+SystemEnv.getHtmlLabelName(2022, user.getLanguage())+",javascript:resetCondtionAVS()',_top} " ;
    	RCMenuHeight += RCMenuHeightStep ;
	}else{
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(81272, user.getLanguage())+",javaScript:_xtable_getAllExcel()',_top} " ;
    	RCMenuHeight += RCMenuHeightStep ;
    }

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
		
			<%if(isFirst == 1) {%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top" onclick="doSearch();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_top" onclick="resetCondtionAVS();"/>
			<%} else { %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(126174,user.getLanguage())%>" class="e8_btn_top" onclick="batchFinish();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(81272,user.getLanguage())%>" style="margin-left: 5px" class="e8_btn_top_first" onclick="_xtable_getAllExcel();">
		
				<input type="text" class="searchInput" id="t_name" name="t_name" value=""/>
				<%if(!simpleSearch) {%>
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
				<%} %>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
		<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span ><%=SystemEnv.getHtmlLabelName(18482,user.getLanguage())%></span>
			
	 </span>
</div>
<%if(isFirst != 1) {%>
<div class="advancedSearchDiv" id="advancedSearchDiv">
<%} else { %>
<div class="advancedSearchDiv1" id="advancedSearchDiv1">
<%} %>
	<FORM id="frmmain" name="frmmain" method="post" action="WorkPlanSearchResult.jsp">
	<input type="hidden" name="isFirst" id="isFirst" value="0"/>
	<input type="hidden" name="simpleSearch" id="simpleSearch" value="<%=simpleSearch %>"/>
	<%String attrs = "{'expandAllGroup':'"+((isFirst == 1)?"true":"false")+"'}"; %>  
		<wea:layout type="4col" attributes='<%=attrs %>'>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(32905, user.getLanguage())%>' >
			<!--================== 标题 ==================-->			                	
				<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
				<wea:item>
			  		<INPUT type="text" class="InputStyle" maxlength="100" size="30" name="planname" value="<%=planName%>">
			  	</wea:item>
				<!--================== 紧急程度 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
				<wea:item>
		    		<SELECT name="urgentlevel" style="width:100px;">
						<OPTION value="" <%if(!"1".equals(urgentLevel) && !"2".equals(urgentLevel) && !"3".equals(urgentLevel)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
						<OPTION value="1" <%if("1".equals(urgentLevel) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></OPTION>
						<OPTION value="2" <%if("2".equals(urgentLevel) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></OPTION>
						<OPTION value="3" <%if("3".equals(urgentLevel) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></OPTION>
					</SELECT>
				</wea:item>
				<!--================== 日程类型 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></wea:item>
				<wea:item>
					<SELECT name="plantype" style="width:100px;">
						<OPTION value="" <%if("".equals(planType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>											
						<%
				  			rs.executeSql("SELECT * FROM WorkPlanType ORDER BY displayOrder ASC");
				  			while(rs.next())
				  			{
				  		%>
				  			<OPTION value="<%= rs.getInt("workPlanTypeID") %>" <%if(planType.equals(rs.getString("workPlanTypeID"))) {%>selected<%}%>><%= rs.getString("workPlanTypeName") %></OPTION>
				  		<%
				  			}
				  		%>
					</SELECT>
				</wea:item>
			<!--================== 状态 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
				<wea:item>
					<SELECT name="planstatus" style="width:100px;">
						<OPTION value="" <%if(!"1".equals(planStatus) && !"2".equals(planStatus) && !"0".equals(planStatus)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
						<OPTION value="0" <%if("0".equals(planStatus) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%></OPTION>
						<OPTION value="1" <%if("1".equals(planStatus) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></OPTION>
						<OPTION value="2" <%if("2".equals(planStatus) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>		
					</SELECT>
				</wea:item>
				<!--================== 提交人 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
			 	<wea:item>
					<brow:browser viewType="0" name="createrid" browserValue='<%=createrId%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
					browserSpanValue='<%= Util.toScreen(resourceComInfo.getResourcename(createrId),user.getLanguage()) %>'></brow:browser>
				</wea:item>
				<!--================== 接收人 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></wea:item>
				<wea:item>
					<INPUT type="hidden" name="receiveType" value="1" />
					<brow:browser viewType="0" name="receiveID" browserValue='<%=receiveID%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
					browserSpanValue='<%= Util.toScreen(resourceComInfo.getResourcename(receiveID),user.getLanguage()) %>'></brow:browser>
				</wea:item>

			<!--================== 开始日期  ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
			  	<wea:item>
					<span>
						<select name="timeSag" id="timeSag" onchange="changeDate(this,'wpbegindate');" style="width:100px;">
							<option value="0" <%=timeSag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
							<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
							<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
							<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
							<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
							<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
						</select>
					</span>
					<span id="wpbegindate"  style="<%=timeSag==6?"":"display:none;" %>">
						<button type="button" class="Calendar" id="SelectBeginDate" onclick="getDate(begindatespan,begindate)"></BUTTON> 
					  	<SPAN id="begindatespan"><%=beginDate%></SPAN> 
				  		<INPUT type="hidden" name="begindate" value="<%=beginDate%>">  
				  		&nbsp;-&nbsp;&nbsp;
				  		<button type="button" class="Calendar" id="SelectEndDate" onclick="getDate(enddatespan,enddate)"></BUTTON> 
				  		<SPAN id="enddatespan"><%=endDate%></SPAN> 
					    <INPUT type="hidden" name="enddate" value="<%=endDate%>">
					</span>
					
				</wea:item>
				<!--==================  结束日期 ==================-->
				<wea:item></wea:item>
			  	<wea:item>
			  		
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(32843, user.getLanguage())%>' >
				<!-- 提交人部门 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(19225,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="createrDep" browserValue='<%=createrDep %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
					completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
					browserSpanValue='<%=DepartmentComInfo.getDepartmentname(createrDep) %>'></brow:browser>

				</wea:item>
			  
				<!-- 提交人分部 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(22788,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="createrSub" browserValue='<%=createrSub %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
					completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
					browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(createrSub) %>'></brow:browser>
				</wea:item>
				<%if(WorkPlanSetInfo.getInfoDoc()==1){ %>
				<!--================== 相关文档 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></wea:item>
			  	<wea:item>
					<%
						String docidspan = "";
						if(!"".equals(docIds)){
							ArrayList ids = Util.TokenizerString(docIds,",");
							int docsnum = ids.size();
			
							for(int i=0;i<docsnum;i++){
								docidspan= docidspan+Util.toScreen(DocComInfo.getDocname(""+ids.get(i)),user.getLanguage())+"," ;               
							}
						}
					%>
					<brow:browser viewType="0" name="docids" browserValue='<%=docIds%>' 
					browserOnClick="" browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp?id=" 
					browserSpanValue='<%=docidspan%>'></brow:browser>
				</wea:item>
				<%} %>
				<%if(WorkPlanSetInfo.getInfoWf()==1){ %>
				<!--================== 相关流程 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></wea:item>
			 	<wea:item>
					<%
			      	String wfsname="";
			       	if(!requestIds.equals("")){
						ArrayList wfids_muti = Util.TokenizerString(requestIds,",");
						for(int i=0;i<wfids_muti.size();i++){
							wfsname += RequestComInfo.getRequestname(wfids_muti.get(i).toString()) + ",";
						}
					}%>
				  <brow:browser viewType="0" name="requestids" browserValue='<%=requestIds %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="
					hasInput="false"  isSingle="false" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" linkUrl="/workflow/request/ViewRequest.jsp?requestid==#id#&id=#id#" 
					browserSpanValue='<%=wfsname%>'></brow:browser>
					<!--
				  	<INPUT type="hidden" name="requestids" class="wuiBrowser"   _param="resourceids"
				  		_displayTemplate="<A href=/workflow/request/ViewRequest.jsp?requestid=#b{id} target='_blank'>#b{name}</A>&nbsp;"
				  		_url="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp">
						-->
				</wea:item>
				<%} %>
				<%if(WorkPlanSetInfo.getInfoCrm()==1){%>
				<!--================== 相关客户 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></wea:item>
			  	<wea:item>
					<% String crmidsSpan = "";
						if(!"".equals(crmIds)){
						ArrayList ids = Util.TokenizerString(crmIds,",");
						for(int i=0;i<ids.size();i++){

						crmidsSpan +=CustomerInfoComInfo.getCustomerInfoname(""+ids.get(i))+",";
				      }}%>
					 <brow:browser viewType="0" name="crmids" browserValue='<%=crmIds%>' 
							browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="%>'
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' 
							completeUrl="/data.jsp?type=18" linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#" 
							browserSpanValue='<%=crmidsSpan%>'></brow:browser>
					<!--
				  	<INPUT type="hidden" name="crmids" class="wuiBrowser" _param="resourceids"
				  		_displayTemplate="<A href=/CRM/data/ViewCustomer.jsp?CustomerID=#b{id} target='_blank'>#b{name}</A>&nbsp;"
				  		_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp">
						-->
				</wea:item>
				<%} %>
				<%if(WorkPlanSetInfo.getInfoPrj()==1){ %>
				<!--================== 相关项目 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></wea:item>
			  	<wea:item>
					<% String projectIdsSpan = "";
						if(!"".equals(projectIds)){
						ArrayList ids = Util.TokenizerString(projectIds,",");
						for(int i=0;i<ids.size();i++){

						projectIdsSpan +=ProjectInfoComInfo.getProjectInfoname(""+ids.get(i))+",";
				      }}%>
					 <brow:browser viewType="0" name="prjids" browserValue='<%=projectIds%>' 
							browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?resourceids="%>'
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' 
							completeUrl="/data.jsp?type=18" linkUrl="/proj/data/ViewProject.jsp?ProjID=#id#&id=#id#" 
							browserSpanValue='<%=projectIdsSpan%>'></brow:browser>
					<!--
				  	<INPUT type="hidden" name="prjids" class="wuiBrowser"  _trimLeftComma="yes" _param="projectids"
				  		_displayTemplate="<A href=/proj/data/ViewProject.jsp?ProjID=#b{id} target='_blank'>#b{name}</A>&nbsp;"
				  		_url="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp">
						-->
				</wea:item>
				<%}%>
			</wea:group>
			<%if(isFirst != 1) {%>
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="button" onclick="doSearch();" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
	    </wea:group>
	    <%} %>
	</wea:layout>
	</FORM>
</div>

<%if(isFirst != 1) {%>
	<%
	String backFields = "workPlan.ID, workPlan.name,workPlan.resourceID, workPlan.urgentLevel, workPlan.type_n, workPlan.createrID, workPlan.status, workPlan.beginDate, workPlan.beginTime, workPlan.endDate, workPlan.createDate, workPlan.createTime";
	String sqlForm = "";
	String sqlWhere = "";
	String sqlOrderBy = "workPlan.beginDate, workPlan.beginTime";
	//获取日程共享数据
	String shareSql=WorkPlanShareUtil.getShareSql(user);
	
	if ("1".equals(advanced))
	//被反馈（从主页转入）
	{
		sqlForm = "WorkPlan workPlan, WorkPlanExchange workPlanExchange";
		sqlWhere = "WHERE workPlan.id = workPlanExchange.workPlanId"
			+ " AND ("
			+ " workPlan.createrID = " + currUserId
			+ " OR workPlan.resourceID LIKE '" + currUserId + ",%'"
			+ " OR workPlan.resourceID LIKE '%," + currUserId + ",%'"
			+ " OR workPlan.resourceID LIKE '%," + currUserId + "'"
			+ ")"
			+ " AND workPlan.createrType = " + currUserType
			+ " AND workPlanExchange.memberID = " + currUserId
			+ " AND workPlanExchange.exchangeCount > 0"
			+ " AND workPlanExchange.memberType = " + currUserType;								
	}
	else if ("2".equals(advanced))
	//需要审批完成（从主页转入）
	{						    
		sqlForm = "WorkPlan workPlan, ("+shareSql+") workPlanShareDetail";
		sqlWhere = "WHERE workPlan.ID = workPlanShareDetail.workID"
			+ " AND workPlan.status = '0'"
			+ " AND workPlan.finishRemind > 0"
			+ " AND workPlan.createrID = " + currUserId
			+ " AND workPlan.createrType = '" + currUserType + "'";						    
	}
	else
	//从搜索页面进入
	{
		sqlForm = "WorkPlan workPlan, ("+shareSql+") workPlanShareDetail";
		sqlWhere = "WHERE workPlan.ID = workPlanShareDetail.workID";
			
		if(!"".equals(planName) && null != planName)
		{
			planName=planName.replaceAll("\"","＂");
			planName=planName.replaceAll("'","＇");
			sqlWhere += " AND workPlan.name LIKE '%" + planName + "%'";
		}
		if(!"".equals(urgentLevel) && null != urgentLevel)
		{	
			if("1".equals(urgentLevel)){
				sqlWhere += " AND (workPlan.urgentLevel = '1' or workPlan.urgentLevel='')";
			}else{
				sqlWhere += " AND workPlan.urgentLevel = '" + urgentLevel + "'";
			}
			
		}
		if(!"".equals(planType) && null != planType)
		{
			sqlWhere += " AND workPlan.type_n = '" + planType + "'";
		}
		if(!"".equals(planStatus) && null != planStatus)
		{
			sqlWhere += " AND workPlan.status = '" + planStatus + "'";
		}
		if(!"".equals(createrId) && null != createrId)
		{
			sqlWhere += " AND workPlan.createrid = " + createrId;
		}
		
		if(!createrDep.equals("")){
			sqlWhere += (" AND ( exists (select 1 from HrmResource where workPlan.createrid = HrmResource.id and HrmResource.departmentid in( "+ createrDep +")"
					+" UNION select 1 from HrmResourceVirtual where workPlan.createrid = HrmResourceVirtual.resourceid and HrmResourceVirtual.departmentid in( "+ createrDep +")"
					+") ) ");
		} 
		
		if(!createrSub.equals("")){
			sqlWhere +=(" AND ( exists (select 1 from HrmResource where workPlan.createrid = HrmResource.id and HrmResource.subcompanyid1 in("+ createrSub +")"
					+" UNION select 1 from HrmResourceVirtual where workPlan.createrid = HrmResourceVirtual.resourceid and HrmResourceVirtual.subcompanyid in( "+ createrSub +")"
					+") ) ");
		}
		
		//日程类型 1：人力资源 5：分部 2：部门
		if(!"".equals(receiveID) && null != receiveID)
		{
			if("1".equals(receiveType))
			//人力资源
			{										
				sqlWhere += " AND (";
				sqlWhere += " workPlan.resourceID = '" + receiveID + "'";
				sqlWhere += " OR workPlan.resourceID LIKE '" + receiveID + ",%'";
				sqlWhere += " OR workPlan.resourceID LIKE '%," + receiveID + ",%'";
				sqlWhere += " OR workPlan.resourceID LIKE '%," + receiveID + "'";
				sqlWhere += ")";							
			}
			else if("5".equals(receiveType))
			//分部
			{
				
			}
			else if("2".equals(receiveType))
			//部门
			{
				
			}
		}
		
		if(timeSag > 0&&timeSag<6){
			String doclastmoddatefrom = TimeUtil.getDateByOption(""+timeSag,"0");
			String doclastmoddateto = TimeUtil.getDateByOption(""+timeSag,"1");
			if(!doclastmoddatefrom.equals("")){
				sqlWhere += " and workPlan.endDate >= '" + doclastmoddatefrom + "'";
			}
			
			if(!doclastmoddateto.equals("")){
				sqlWhere += " and workPlan.beginDate <= '" + doclastmoddateto + "'";
			}
			
		}else{
			if(timeSag==6){//指定时间
				if((!"".equals(beginDate) && null != beginDate))
				{
					sqlWhere += " AND workPlan.endDate >= '" + beginDate+ "'";								    
				   // sqlWhere += "' OR workPlan.endDate IS NULL)";
				}
				if((!"".equals(endDate) && null != endDate))
				{
					sqlWhere += " AND workPlan.beginDate <= '" + endDate + "'";
				}
			}
			
		}
		//废弃开始
		if(timeSagEnd > 0&&timeSagEnd<6){
			String doclastmoddatefrom = TimeUtil.getDateByOption(""+timeSagEnd,"0");
			String doclastmoddateto = TimeUtil.getDateByOption(""+timeSagEnd,"1");
			if(!doclastmoddatefrom.equals("")){
				sqlWhere += " and workPlan.endDate >= '" + doclastmoddatefrom + "'";
			}
			
			if(!doclastmoddateto.equals("")){
				sqlWhere += " and workPlan.endDate <= '" + doclastmoddateto + "'";
			}
			
		}else{
			if(timeSagEnd==6){//指定时间
				if((!"".equals(beginDate2) && null != beginDate2))
				{
					sqlWhere += " AND workPlan.endDate >= '" + beginDate2+ "'";								    
				   // sqlWhere += "' OR workPlan.endDate IS NULL)";
				}
				if((!"".equals(endDate2) && null != endDate2))
				{
					sqlWhere += " AND workPlan.endDate <= '" + endDate2+ "'";								    
				   // sqlWhere += "' OR workPlan.endDate IS NULL)";
				}
			}
			
		}
		//废弃结束
		
		
		//相关客户
		if(!"".equals(crmIds) && null != crmIds)
		{
			sqlWhere += " AND (";
			sqlWhere += " workPlan.crmID = '" + crmIds + "'";
			sqlWhere += " OR workPlan.crmID LIKE '" + crmIds + ",%'";
			sqlWhere += " OR workPlan.crmID LIKE '%," + crmIds + ",%'";
			sqlWhere += " OR workPlan.crmID LIKE '%," + crmIds + "'";
			sqlWhere += ")";
		}
		
		//相关文档
		if(!"".equals(docIds) && null != docIds)
		{
			sqlWhere += " AND (";
			sqlWhere += " workPlan.docID = '" + docIds + "'";
			sqlWhere += " OR workPlan.docID LIKE '" + docIds + ",%'";
			sqlWhere += " OR workPlan.docID LIKE '%," + docIds + ",%'";
			sqlWhere += " OR workPlan.docID LIKE '%," + docIds + "'";
			sqlWhere += ")";
		}
		
		//相关项目
		if(!"".equals(projectIds) && null != projectIds)
		{
			sqlWhere += " AND (";
			sqlWhere += " workPlan.projectID = '" + projectIds + "'";
			sqlWhere += " OR workPlan.projectID LIKE '" + projectIds + ",%'";
			sqlWhere += " OR workPlan.projectID LIKE '%," + projectIds + ",%'";
			sqlWhere += " OR workPlan.projectID LIKE '%," + projectIds + "'";
			sqlWhere += ")";
		}
		
		//相关流程
		if(!"".equals(requestIds) && null != requestIds)
		{
			sqlWhere += " AND (";
			sqlWhere += " workPlan.requestID = '" + requestIds + "'";
			sqlWhere += " OR workPlan.requestID LIKE '" + requestIds + ",%'";
			sqlWhere += " OR workPlan.requestID LIKE '%," + requestIds + ",%'";
			sqlWhere += " OR workPlan.requestID LIKE '%," + requestIds + "'";
			sqlWhere += ")";
		}
	}
	String tableString=""+
		"<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.WP_WorkPlanSearch,user.getUID())+"\" tabletype=\"checkbox\">"+
		" <checkboxpopedom  id=\"checkbox\"  popedompara=\""+user.getUID()+"+column:createrID+column:status+column:userid\" showmethod=\"weaver.WorkPlan.WorkPlanSearch.getWorkPlanSearchResultCheckBox\" />"+
		"<sql backfields=\"" + backFields + "\" sqlform=\"" + Util.toHtmlForSplitPage(sqlForm) + "\" sqlprimarykey=\"workPlan.ID\" sqlorderby=\"" + sqlOrderBy + "\" sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlisdistinct=\"true\" />"+
		"<head>"+
		"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16094,user.getLanguage())+"\" column=\"type_n\" orderkey=\"type_n\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanType\"/>"+							    
		"<col width=\"20%%\"  text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\" column=\"ID\" otherpara=\"column:name+column:type_n\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanName\"/>"+
		"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"urgentLevel\" otherpara=\"" + user.getLanguage() + "\" orderkey=\"urgentLevel\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getUrgentName\" />"+
		"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"createrID\" orderkey=\"createrID\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getResourceName\" />"+
		"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(2211,user.getLanguage()) + SystemEnv.getHtmlLabelName(602,user.getLanguage())+ "\" column=\"status\" otherpara=\"" + user.getLanguage() + "\" orderkey=\"status\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getStatusName\"/>"+
		"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" column=\"beginDate\" orderkey=\"beginDate\"/>"+
		"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"\" column=\"endDate\" orderkey=\"endDate\"/>"+						    
		"</head>"+
"		<operates>"+
  "		<popedom column=\"id\" otherpara=\""+currUserId+"+column:status+column:resourceID+column:createrID\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanOperateList\"></popedom> "+
"		<operate href=\"javascript:doFinish();\" text=\""+SystemEnv.getHtmlLabelName(555,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
"		<operate href=\"javascript:doNoteFinish();\" text=\""+SystemEnv.getHtmlLabelName(555,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
"		<operate href=\"javascript:onShare();\" text=\""+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
"		</operates>"+
		"</table>";
	%>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WP_WorkPlanSearch%>"/>
	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 
<%} %>
</BODY>
</HTML>


<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<SCRIPT language="JavaScript">
function preDo(){
	//tabSelectChg();
	<%if(isFirst != 1){%>
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	<%}%>
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("input[name='planname']").val(name);
	doSearch();
}

function doSearch() {
	if (!checkDateValid("begindate", "enddate")) {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
		return;
	}
	document.frmmain.submit();
}

function checkDateValid(objStartName, objEndName) {
	var dateStart = document.all(objStartName).value;
	var dateEnd = document.all(objEndName).value;

	if ((dateStart == null || dateStart == "") || (dateEnd == null || dateEnd == ""))
		return true;

	var yearStart = dateStart.substring(0,4);
	var monthStart = dateStart.substring(5,7);
	var dayStart = dateStart.substring(8,10);
	var yearEnd = dateEnd.substring(0,4);
	var monthEnd = dateEnd.substring(5,7);
	var dayEnd = dateEnd.substring(8,10);
		
	if (yearStart > yearEnd)		
		return false;
	
	if (yearStart == yearEnd) {
		if (monthStart > monthEnd)
			return false;
		
		if (monthStart == monthEnd)
			if (dayStart > dayEnd)
				return false;
	}

	return true;
}

/**
*清空搜索条件
*/
function resetCondtionAVS(){
	var advancedSearchDiv = "#advancedSearchDiv";
	<%if(isFirst == 1){%>
	advancedSearchDiv = "#advancedSearchDiv1";
	<%}%>
	//清空文本框
	jQuery(advancedSearchDiv).find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery(advancedSearchDiv).find(".Browser").siblings("span").html("");
	jQuery(advancedSearchDiv).find(".Browser").siblings("input[type='hidden']").val("");
	jQuery(advancedSearchDiv).find(".e8_os").find("input[type='hidden']").val("");
	jQuery(advancedSearchDiv).find(".e8_outScroll .e8_innerShow span").html("");
	//清空下拉框
	jQuery(advancedSearchDiv).find("select").val("");
	jQuery(advancedSearchDiv).find("select").trigger("change");
	//清空日期
	jQuery(advancedSearchDiv).find(".Calendar").siblings("span").html("");
	jQuery(advancedSearchDiv).find(".Calendar").siblings("input[type='hidden']").val("");
	
	jQuery(advancedSearchDiv).find("select").selectbox('detach');
	jQuery(advancedSearchDiv).find("select").selectbox('attach');
}
var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function closeWinARfrsh(){
	diag_vote.close();
	doSearch();
}

function closeDlgAndRfsh(){
	closeWinARfrsh();
}

function view(id, workPlanTypeID){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange = false;
	diag_vote.isIframe=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>";
	if(workPlanTypeID == 6){
		diag_vote.URL = "/hrm/performance/targetPlan/PlanView.jsp?from=2&id=" + id ;
	} else {
		diag_vote.URL = "/workplan/data/WorkPlanDetail.jsp?from=1&workid=" + id ;
	}
	diag_vote.show();
	
}

function onShare(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange = false;
	diag_vote.isIframe=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>";
	diag_vote.URL = "/workplan/share/WorkPlanShare.jsp?planID=" + id ;
	diag_vote.show();
}


function doFinish(id){
	$.post("/workplan/data/WorkPlanOperation.jsp",{method:"finish",workid:id},function(datas){
		doSearch();
	});
}
function doNoteFinish(id){
	$.post("/workplan/data/WorkPlanOperation.jsp",{method:"notefinish",workid:id},function(datas){
		doSearch();
	});
}
function onDel(id){
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>", function (){
			$.post("/workplan/data/WorkPlanOperation.jsp",{method:"delete",workid:id},function(datas){
				doSearch();
			});
		}, function () {}, 320, 90,false);
	
}
function changeTitle(diag, name){
	 if(diag){
        diag.Title = name;
    }
}

function batchFinish(){
var ids = _xtable_CheckedCheckboxId();
if(ids==""){
	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125014,user.getLanguage())%>");
	return;
}
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126220, user.getLanguage())%>", function (){
		
		$.post("/workplan/data/WorkPlanOperation.jsp",{method:"batchfinish",workid:ids},function(datas){
			doSearch();
		});
	}, function () {}, 320, 90,false);
}
</SCRIPT>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
