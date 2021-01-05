
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-06-26 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="workTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("HrmRrightTransfer:Tran", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelNames("385,80",user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	String oldJson = jsonSql;
	jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
	String customerName = Util.null2String(request.getParameter("customerName"));
	String customerType = Util.null2String(request.getParameter("customerType"));
	String customerStatus = Util.null2String(request.getParameter("customerStatus"));
	
	String projectName = Util.null2String(request.getParameter("projectName"));
	String projectType = Util.null2String(request.getParameter("projectType"));
	String workType = Util.null2String(request.getParameter("workType"));
	String projectStatus = Util.null2String(request.getParameter("projectStatus"));
	
	String hrmName = Util.null2String(request.getParameter("hrmName"));
	String hrmJobtitle = Util.null2String(request.getParameter("hrmJobtitle"));
	String hrmDepartment = Util.null2String(request.getParameter("hrmDepartment"));
	String hrmSubcompany = Util.null2String(request.getParameter("hrmSubcompany"));
	
	String docName = Util.null2String(request.getParameter("docName"));
	String docMaincategory = Util.null2String(request.getParameter("docMaincategory"));
	String docStatus = Util.null2String(request.getParameter("docStatus"));
	String docDspreply = Util.null2String(request.getParameter("docDspreply"));
	
	String eventName = Util.null2String(request.getParameter("eventName"));
	String eventCode = Util.null2String(request.getParameter("eventCode"));
	String eventType = Util.null2String(request.getParameter("eventType"));
	String eventWorkFlowName = Util.null2String(request.getParameter("eventWorkFlowName"));
	
	String coworkName = Util.null2String(request.getParameter("coworkName"));
	String coworkType = Util.null2String(request.getParameter("coworkType"));
	String coworkStatus = Util.null2String(request.getParameter("coworkStatus"));

	String fromid=Util.null2String(request.getParameter("fromid"));
	String toid=Util.null2String(request.getParameter("toid"));
	int type = Util.getIntValue(request.getParameter("type"),0);
	int crmallnum=Util.getIntValue(request.getParameter("crmallnum"),0);
	int projectallnum=Util.getIntValue(request.getParameter("projectallnum"),0);
	int resourceallnum=Util.getIntValue(request.getParameter("resourceallnum"),0);
	int docallnum=Util.getIntValue(request.getParameter("docallnum"),0);
	int eventAllNum=Util.getIntValue(request.getParameter("eventAllNum"),0);  //apollo
	int coworkAllNum=Util.getIntValue(request.getParameter("coworkAllNum"),0);
	/* 2014-7-31 start */
	int pendingEventAllNum=Util.getIntValue(request.getParameter("pendingEventAllNum"),0);
	/* 2014-7-31 end */

	String crmidstr=Util.null2String(request.getParameter("crmidstr"));
	//{modified by chengfeng.han 2011-7-4 start  22692 
	String crmtype=Util.null2String(request.getParameter("crmtype"));
	String crmstatus=Util.null2String(request.getParameter("crmstatus"));
	//end}
	//{modified by chengfeng.han 2011-7-5 start  22692 
	String projecttype=Util.null2String(request.getParameter("projecttype"));
	String projectstatus=Util.null2String(request.getParameter("projectstatus"));
	String worktype=Util.null2String(request.getParameter("worktype"));
	//end}
	String projectidstr=Util.null2String(request.getParameter("projectidstr"));
	String resourceidstr=Util.null2String(request.getParameter("resourceidstr"));
	String docidstr=Util.null2String(request.getParameter("docidstr"));
	String eventIDStr=Util.null2String(request.getParameter("eventIDStr"));//apollo
	String coworkIDStr=Util.null2String(request.getParameter("coworkIDStr"));
	/* 2014-7-31 start */
	String pendingEventIDStr=Util.null2String(request.getParameter("pendingEventIDStr"));
	/* 2014-7-31 end */

	ArrayList crmids=new ArrayList();
	ArrayList projectids=new ArrayList();
	ArrayList resourceids=new ArrayList();
	ArrayList docids=new ArrayList();
	ArrayList eventIDs=new ArrayList();//apollo
	ArrayList coworkIDs=new ArrayList();
	/* 2014-7-31 start */
	ArrayList pendingEventIDs=new ArrayList();
	/* 2014-7-31 end */

	String crmall=Util.null2String(request.getParameter("crmall"));
	String projectall=Util.null2String(request.getParameter("projectall"));
	String resourceall=Util.null2String(request.getParameter("resourceall"));
	String docall=Util.null2String(request.getParameter("docall"));
	String eventAll=Util.null2String(request.getParameter("eventAll"));//apollo
	String coworkAll=Util.null2String(request.getParameter("coworkAll"));
	/* 2014-7-31 start */
	String pendingEventAll=Util.null2String(request.getParameter("pendingEventAll"));
	/* 2014-7-31 end */

	String crmallFlag=Util.null2String(request.getParameter("crmallFlag"));
	String projectallFlag=Util.null2String(request.getParameter("projectallFlag"));
	String resourceallFlag=Util.null2String(request.getParameter("resourceallFlag"));
	String docallFlag=Util.null2String(request.getParameter("docallFlag"));
	String eventAllFlag=Util.null2String(request.getParameter("eventAllFlag"));//apollo
	String coworkAllFlag=Util.null2String(request.getParameter("coworkAllFlag"));
	/* 2014-7-31 start */
	String pendingEventAllFlag=Util.null2String(request.getParameter("pendingEventAllFlag"));
	/* 2014-7-31 end */

	if(crmallFlag.equals("0")){
		crmall = "0";
	}
	if(projectallFlag.equals("0")){
		projectall = "0";
	}
	if(resourceallFlag.equals("0")){
		resourceall = "0";
	}
	if(docallFlag.equals("0")){
		docall = "0";
	}
	if(eventAllFlag.equals("0")){
		eventAll = "0";
	}
	if(coworkAllFlag.equals("0")){
		coworkAll = "0";
	}
	/* 2014-7-31 start */
	if("0".equals(pendingEventAllFlag)) {
		pendingEventAll = "0";
	}
	/* 2014-7-31 end */

	int i=0;
	int j=0;
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:selectDone(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())+",javascript:selectAll(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<input type=hidden name="isdialog" value="<%=isDialog%>">
			<input type=hidden name="cmd" value="closeDialog">
			<input type=hidden name="fromid" value="<%=fromid%>">
			<input type=hidden name="toid" value="<%=toid%>">
			<input type=hidden name="crmidstr" value="<%=crmidstr%>">
			<input type=hidden name="h_crmtype" value="<%=crmtype%>">
			<input type=hidden name="h_crmstatus" value="<%=crmstatus%>">
			<input type=hidden name="h_projecttype" value="<%=projecttype%>">
			<input type=hidden name="h_projectstatus" value="<%=projectstatus%>">
			<input type=hidden name="h_worktype" value="<%=worktype%>">
			<input type=hidden name="projectidstr" value="<%=projectidstr%>">
			<input type=hidden name="resourceidstr" value="<%=resourceidstr%>">
			<input type=hidden name="docidstr" value="<%=docidstr%>">
			<input type=hidden name="eventIDStr" value="<%=eventIDStr%>">
			<input type=hidden name="coworkIDStr" value="<%=coworkIDStr%>">
			<%-- 2014-7-31 start --%>
			<input type=hidden name="pendingEventIDStr" value="<%=pendingEventIDStr%>">
			<%-- 2014-7-31 end --%>

			<input type=hidden name="crmall" value="<%=crmall%>">
			<input type=hidden name="projectall" value="<%=projectall%>">
			<input type=hidden name="resourceall" value="<%=resourceall%>">
			<input type=hidden name="docall" value="<%=docall%>">
			<input type=hidden name="eventAll" value="<%=eventAll%>">
			<input type=hidden name="coworkAll" value="<%=coworkAll%>">
			<%-- 2014-7-31 start --%>
			<input type=hidden name="pendingEventAll" value="<%=pendingEventAll%>">
			<%-- 2014-7-31 end --%>

			<input type=hidden name="crmallnum" value="<%=crmallnum%>">
			<input type=hidden name="projectallnum" value="<%=projectallnum%>">
			<input type=hidden name="resourceallnum" value="<%=resourceallnum%>">
			<input type=hidden name="docallnum" value="<%=docallnum%>">
			<input type=hidden name="eventAllNum" value="<%=eventAllNum%>">
			<input type=hidden name="coworkAllNum" value="<%=coworkAllNum%>">
			<%-- 2014-7-31 start --%>
			<input type=hidden name="pendingEventAllNum" value="<%=pendingEventAllNum%>">
			<%-- 2014-7-31 end --%>
			<input type=hidden name="type" value="<%=type%>">
			<input type=hidden name="jsonSql" value="<%=Tools.getURLEncode(oldJson)%>">
			<input type=hidden name="isDelType" value="0">
			<input type=hidden name="selectAllSql" value="">
			<input type=hidden name="needExecuteSql" value="0">
			
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<input type=button class="e8_btn_top" onclick="selectDone();" value="<%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%>"></input>
						<input type=button class="e8_btn_top" onclick="selectAll();" value="<%=SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())%>"></input>
						<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<%if(type == 1){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
						<wea:item><input type="text" class=InputStyle maxLength=50 size=30 name="customerName" value='<%=customerName%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
						<wea:item>
							<select name="customerType" class=InputStyle>
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<%
									rs.executeProc("CRM_CustomerType_SelectAll","");
									while(rs.next()){
										String tmpid=rs.getString("id");
										if(CRMSearchComInfo.isCustomerTypeSel(Util.getIntValue(tmpid)) ||customerType.equals(tmpid)){
											out.println("<option value='"+tmpid+"' selected='selected' >"+rs.getString("fullname")+"</optin>");
										}else{
											out.println("<option value='"+tmpid+"'>"+rs.getString("fullname")+"</optin>");
										}
									}
								%>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
						<wea:item>
							<select name="customerStatus" class=InputStyle>
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<%
									rs.execute("select id , fullname from CRM_CustomerStatus");
									while(rs.next()){
										String tmpid = rs.getString("id");
										if(CRMSearchComInfo.getCustomerStatus().equals(tmpid) ||customerStatus.equals(tmpid)){
											out.println("<option value='"+tmpid+"' selected='selected' >"+rs.getString("fullname")+"</optin>");
										}else{
											out.println("<option value='"+tmpid+"'>"+rs.getString("fullname")+"</optin>");
										}
									}
								%>
							</select>
						</wea:item>
						<%}else if(type == 2){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(1353,user.getLanguage())%></wea:item>
						<wea:item><input type="text" class=InputStyle maxLength=50 size=30 name="projectName" value='<%=projectName%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></wea:item>
						<wea:item>
							<select name="projectType" class=InputStyle>
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<%while(ProjectTypeComInfo.next()){%>
									<option value="<%=ProjectTypeComInfo.getProjectTypeid()%>" <%=projectType.equals(ProjectTypeComInfo.getProjectTypeid())?"selected":""%>><%=ProjectTypeComInfo.getProjectTypename()%></option>
								<%}%>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
						<wea:item>
							<select class="InputStyle" name="workType">
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<%while(WorkTypeComInfo.next()){%>
									<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=workType.equals(WorkTypeComInfo.getWorkTypeid())?"selected":""%>><%=WorkTypeComInfo.getWorkTypename()%></option>
								<%}%>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></wea:item>
						<wea:item>
							<select name="projectStatus" class=InputStyle>
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<%while(ProjectStatusComInfo.next()){%>
									<option value="<%=ProjectStatusComInfo.getProjectStatusid()%>" <%=projectStatus.equals(ProjectStatusComInfo.getProjectStatusid())?"selected":""%>><%=ProjectStatusComInfo.getProjectStatusdesc()%></option>
								<%}%>
							</select>
						</wea:item>
						<%}else if(type == 3){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
						<wea:item><input type="text" class=InputStyle maxLength=50 size=30 name="hrmName" value='<%=hrmName%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="hrmJobtitle" browserValue='<%=hrmJobtitle%>'
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobtitles/JobTitlesBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=hrmjobtitles" width="60%" browserSpanValue='<%=JobTitlesComInfo.getJobTitlesname(hrmJobtitle)%>'>
							</brow:browser>		 
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="hrmDepartment" browserValue='<%=hrmDepartment%>' browserOnClick=""
								browserurl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?excludeid=&selectedids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=4" width="60%" browserSpanValue='<%=DepartmentComInfo.getDepartmentname(hrmDepartment)%>'>
							</brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="hrmSubcompany" browserValue='<%=hrmSubcompany%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?excludeid="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=164" width="60%" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(hrmSubcompany)%>'>
							</brow:browser>
						</wea:item>
						<%}else if(type == 4){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(19541,user.getLanguage())%></wea:item>
						<wea:item> <input type="text" class=InputStyle maxLength=50 size=30 name="docName" value='<%=docName%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></wea:item>
						<wea:item> <input type="text" class=InputStyle maxLength=50 size=30 name="docMaincategory" value='<%=docMaincategory%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
						<wea:item>
							<select name="docStatus" class=InputStyle>
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<option value="0" <%=docStatus.equals("0")?"selected":""%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
								<option value="1" <%=docStatus.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(18431,user.getLanguage())%></option>
								<option value="2" <%=docStatus.equals("2")?"selected":""%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
								<option value="3" <%=docStatus.equals("3")?"selected":""%>><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
								<option value="4" <%=docStatus.equals("4")?"selected":""%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
								<option value="5" <%=docStatus.equals("5")?"selected":""%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
								<option value="6" <%=docStatus.equals("6")?"selected":""%>><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></option>
								<option value="7" <%=docStatus.equals("7")?"selected":""%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
								<option value="8" <%=docStatus.equals("8")?"selected":""%>><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></option>
								<option value="9" <%=docStatus.equals("9")?"selected":""%>><%=SystemEnv.getHtmlLabelName(21556,user.getLanguage())%></option>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></wea:item>
						<wea:item>
							<SELECT  class=InputStyle id="docDspreply" name=docDspreply>
							   <option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							   <option value="1" <%if (docDspreply.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18467,user.getLanguage())%></option>
							   <option value="2" <%if (docDspreply.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18468,user.getLanguage())%></option>
							</SELECT>    
						</wea:item>
						<%}else if(type == 5 || type == 7){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></wea:item>
						<wea:item> <input type="text" class=InputStyle maxLength=50 size=30 name="eventName" value='<%=eventName%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
						<wea:item> <input type="text" class=InputStyle maxLength=50 size=30 name="eventCode" value='<%=eventCode%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<select id="eventType" name="eventType">
									<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									<%
										workTypeComInfo.setTofirstRow();
										while(workTypeComInfo.next()){
									%>
									<option value="<%=workTypeComInfo.getWorkTypeid()%>" <%=eventType.equals(workTypeComInfo.getWorkTypeid())?"selected":""%>><%=workTypeComInfo.getWorkTypename()%></option>
									<%}%>
								</select>
							</span> 
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(26361,user.getLanguage())%></wea:item>
						<wea:item> <input type="text" class=InputStyle maxLength=50 size=30 name="eventWorkFlowName" value='<%=eventWorkFlowName%>'></wea:item>
						<%}else if(type == 6){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
						<wea:item> <input type="text" class=InputStyle maxLength=50 size=30 name="coworkName" value='<%=coworkName%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(17694,user.getLanguage())%></wea:item>
						<wea:item>
							<select name="coworkType" size=1 class=InputStyle>
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<%
									String typesql="select * from cowork_types" ;
									rs.executeSql(typesql);
									while(rs.next()){
										String tmptypeid=rs.getString("id");
										String typename=rs.getString("typename");
								%>
									<option value="<%=tmptypeid%>" <%=coworkType.equals(tmptypeid)?"selected":""%>><%=typename%></option>
								<%
									}
								%>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
						<wea:item>
							<select name="coworkStatus" class=InputStyle>
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<option value="1" <%=coworkStatus.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
								<option value="2" <%=coworkStatus.equals("2")?"selected":""%>><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
							</select>
						</wea:item>
						<%}%>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%
			String backfields = ""; 
			String fromSql  = "";
			String sqlWhere = "";
			String orderby = "";
			String tableString = "";
			String selectedstrs = "";
			if(type == 1){
				selectedstrs = crmidstr;

				backfields = " a.id,a.name,a.language,a.manager,a.type,a.status,a.seclevel "; 
				fromSql  = " from CRM_CustomerInfo a ";
				sqlWhere = " where a.manager = "+fromid+" and (a.deleted is null or a.deleted!=1) ";
				orderby = " a.id " ;
				
				if(qname.length() > 0 ){
					sqlWhere += " and a.name like '%"+qname+"%' ";
				}else if(customerName.length() > 0){
					sqlWhere += " and a.name like '%"+customerName+"%' ";
				}
				if(customerType.length() > 0){
					sqlWhere += " and a.type  = "+customerType;
				}
				if(customerStatus.length() > 0){
					sqlWhere += " and a.status  = "+customerStatus;
				}
				String operateString= "";
				tableString =" <table pageId=\""+Constants.HRM_Z_011+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_011,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
				operateString+
				"	<head>"+
				"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(1268,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" linkvaluecolumn=\"id\" linkkey=\"CustomerID\" href=\"/CRM/data/ViewCustomer.jsp\"/>"+
				"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(1282,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" transmethod=\"weaver.crm.Maint.CustomerTypeComInfo.getCustomerTypename\" />"+
				"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(15078,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" transmethod=\"weaver.crm.Maint.CustomerStatusComInfo.getCustomerStatusname\" />"+
				"	</head>"+
				" </table>";
			}else if(type == 2){
				selectedstrs = projectidstr;

				backfields = " a.id,a.name,a.description,a.prjtype,a.worktype,a.status,dbo.getPrjBeginDate(a.id) as begindate,dbo.getPrjEndDate(a.id) as enddate "; 
				fromSql  = " from Prj_ProjectInfo a ";
				sqlWhere = " where a.manager = "+fromid;
				orderby = " a.id " ;
				
				if(qname.length() > 0 ){
					sqlWhere += " and a.name like '%"+qname+"%' ";
				}else if(projectName.length() > 0){
					sqlWhere += " and a.name like '%"+projectName+"%' ";
				}				
				if(projectType.length() > 0){
					sqlWhere += " and a.prjtype  = "+projectType;
				}				
				if(workType.length() > 0){
					sqlWhere += " and a.worktype  = "+workType;
				}
				if(projectStatus.length() > 0){
					sqlWhere += " and a.status  = "+projectStatus;
				}
				String operateString= "";
				tableString =" <table pageId=\""+Constants.HRM_Z_011+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_011,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
				operateString+
				"	<head>"+
				"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(1353,user.getLanguage())+"\" column=\"id\" orderkey=\"name\" otherpara=\"column:name+column:status+"+user.getLanguage()+"+column:begindate+column:enddate\" transmethod='weaver.proj.util.ProjectTransUtil.getPrjName'/>"+
				"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(586,user.getLanguage())+"\" column=\"prjtype\" orderkey=\"prjtype\" transmethod=\"weaver.proj.Maint.ProjectTypeComInfo.getProjectTypename\" />"+
				"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(587,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" transmethod=\"weaver.proj.Maint.ProjectStatusComInfo.getProjectStatusdesc\" />"+
				"	</head>"+
				" </table>";
			}else if(type == 3){
				selectedstrs = resourceidstr;

				backfields = " a.id,a.lastname,a.jobtitle,a.departmentid,a.subcompanyid1,a.managerid,a.dsporder "; 
				fromSql  = " from HrmResource a ";
				sqlWhere = " where a.managerid = "+fromid+" and (a.status between 0  and 3) ";
				orderby = " a.dsporder,a.lastname " ;
				
				if(qname.length() > 0 ){
					sqlWhere += " and a.lastname like '%"+qname+"%' ";
				}else if(hrmName.length() > 0){
					sqlWhere += " and a.lastname like '%"+hrmName+"%' ";
				}
				if(hrmJobtitle.length() > 0){
					sqlWhere += " and a.jobtitle  = "+hrmJobtitle;
				}				
				if(hrmDepartment.length() > 0){
					sqlWhere += " and a.departmentid  = "+hrmDepartment;
				}
				if(hrmSubcompany.length() > 0){
					sqlWhere += " and a.subcompanyid1  = "+hrmSubcompany;
				}
				String operateString= "";
				tableString =" <table pageId=\""+Constants.HRM_Z_011+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_011,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
				operateString+
				"	<head>"+
				"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmResource\" />"+
				"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitle\" orderkey=\"jobtitle\" transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\" />"+
				"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" />"+
				"	</head>"+
				" </table>";
			}else if(type == 4){
				selectedstrs = docidstr;

				backfields = " a.id,a.docsubject,a.doccreaterid,a.ownerid,a.usertype,a.replydocid,a.maincategory,b.categoryname as bcategoryname,a.subcategory,c.categoryname as ccategoryname,a.seccategory,d.categoryname as dcategoryname,a.docstatus "; 
				fromSql  = " from DocDetail a left join DocMainCategory b on a.maincategory = b.id left join DocSubCategory c on a.subcategory = c.id left join DocSecCategory d on a.subcategory = d.id ";
				sqlWhere = " where a.maincategory!=0 and a.subcategory!=0 and a.seccategory!=0 and a.id IN (select max(id) from DocDetail where ownerid = "+fromid+" and (ishistory is null or ishistory = 0) group by parentids)";
				orderby = " a.id " ;
				
				if(qname.length() > 0 ){
					sqlWhere += " and a.docsubject like '%"+qname+"%' ";
				}else if(docName.length() > 0){
					sqlWhere += " and a.docsubject like '%"+docName+"%' ";
				}				
				if(docMaincategory.length() > 0){
					sqlWhere += " and (b.categoryname like '%"+docMaincategory+"%' or c.categoryname like '%"+docMaincategory+"%' or c.categoryname like '%"+docMaincategory+"%') ";
				}
				if(docStatus.length() > 0){
					sqlWhere += " and a.docstatus  = "+docStatus;
				}
				if(docDspreply.length() > 0){
					if(docDspreply.equals("1")){
						sqlWhere += " and (a.isreply!=1 or a.isreply is null) ";
					}else if(docDspreply.equals("2")){
						sqlWhere += " and a.isreply='1' ";
					}
				}
				
				String operateString= "";
				tableString =" <table pageId=\""+Constants.HRM_Z_011+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_011,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
				operateString+
				"	<head>"+
				"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(19541,user.getLanguage())+"\" column=\"docsubject\" orderkey=\"docsubject\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/docs/docs/DocDsp.jsp\" />"+
				"		<col width=\"45%\" text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"id\" orderkey=\"maincategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\" />"+
				//weaver.splitepage.transform.SptmForDoc.getDocStatus3&"+user.getLanguage()+"+column:docstatus+column:seccategory
				"		<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=220,1=18431,2=225,3=359,4=236,5=251,6=19564,7=15750,8=15358,9=21556]}\"/>"+
				"	</head>"+
				" </table>";
			}else if(type == 5){
				selectedstrs = eventIDStr;

				String para2 = "column:requestid+column:workflowid+column:viewtype+0+" + user.getLanguage() + "+column:nodeid+column:isremark+" + fromid
						+ "+column:agentorbyagentid+column:agenttype+column:isprocessed";
				backfields = " a.requestId, a.workflowId, a.requestName, a.creater, d.lastname, a.createDate, a.createTime, c.workflowname,b.viewtype,b.nodeid,b.isremark,b.agentorbyagentid,b.agenttype,b.isprocessed "; 
				fromSql  = " FROM Workflow_RequestBase a left join Workflow_CurrentOperator b on a.requestId = b.requestId left join workflow_base c on a.workflowid = c.id left join HrmResource d on a.creater = d.id ";
				sqlWhere = " WHERE b.userId = "+fromid+" AND b.isRemark in ('2', '4') AND b.userType = "+(String.valueOf(user.getLogintype()).equals("2") ? 1 : 0)+" and c.isvalid in ('1', '3') AND b.isLastTimes = 1 ";
				orderby = "" ;

				/* 2014-7-31 start */
				int eventSearchType = Util.getIntValue(request.getParameter("eventSearchType"), 1);
				switch(eventSearchType) {
					case 2:
						sqlWhere += " and (b.isComplete <> 1 AND (b.agenttype<>1 OR (b.agenttype=1 AND NOT EXISTS(SELECT 1 FROM workflow_currentoperator b2 WHERE b2.userid=b.agentorbyagentid AND b2.agenttype=2 AND b2.agentorbyagentid=b.userid AND b2.isremark='0'))))";
						break;
					case 3:
						sqlWhere += " and b.isComplete = 1";
						break;
					default:
						sqlWhere += "AND (b.isComplete = 1 OR (b.agenttype<>1 OR (b.agenttype=1 AND NOT EXISTS(SELECT 1 FROM workflow_currentoperator b2 WHERE b2.userid=b.agentorbyagentid AND b2.agenttype=2 AND b2.agentorbyagentid=b.userid AND b2.isremark='0'))))";
						break;
				}
				/* 2014-7-31 end */

				if(qname.length() > 0 ){
					sqlWhere += " and a.requestName like '%"+qname+"%' ";
				}else if(eventName.length() > 0){
					sqlWhere += " and a.requestName like '%"+eventName+"%' ";
				}
				if(eventWorkFlowName.length() > 0){
					sqlWhere += " and c.workflowname like '%"+eventWorkFlowName+"%' ";
				}
				if(eventCode.length() > 0){
					sqlWhere += " and a.creatertype = '0' and d.workcode like '%"+eventCode+"%' ";
				}
				if(eventType.length() > 0){
					sqlWhere += " and c.workflowtype = "+eventType;
				}
				String operateString= "";
				tableString =" <table pageId=\""+Constants.HRM_Z_011+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_011,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.requestId\" sqlsortway=\"DESC\" sqlisdistinct=\"\"/>"+
				operateString+
				"	<head>"+
				"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestName\" orderkey=\"requestName\" linkkey=\"requestid\" linkvaluecolumn=\"requestId\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\" otherpara=\""+para2+"\" />"+
				"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" />"+
				"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(26361,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\"/>"+
				"	</head>"+
				" </table>";
			}else if(type == 6){
				selectedstrs = coworkIDStr;

				backfields = " a.id,a.name,a.typeid,b.typename,a.status,a.isnew,a.isTop,a.approvalAtatus  "; 
				fromSql  = " from cowork_items a left join cowork_types b on a.typeid = b.id ";
				sqlWhere = " where a.coworkmanager = "+fromid;
				orderby = " a.id " ;
				
				if(qname.length() > 0 ){
					sqlWhere += " and a.name like '%"+qname+"%' ";
				}else if(coworkName.length() > 0){
					sqlWhere += " and a.name like '%"+coworkName+"%' ";
				}
				if(coworkType.length() > 0){
					sqlWhere += " and a.typeid  = "+coworkType;
				}
				if(coworkStatus.length() > 0){
					sqlWhere += " and a.status  = "+coworkStatus;
				}
				String operateString= "";
				tableString =" <table pageId=\""+Constants.HRM_Z_011+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_011,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
				operateString+
				"	<head>"+
				"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" otherpara='column:id+column:isnew+"+fromid+"+column:approvalAtatus+column:isTop' transmethod=\"weaver.general.CoworkTransMethod.getCoworkName\" />"+
				"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(17694,user.getLanguage())+"\" column=\"typename\" orderkey=\"typename\"/>"+
				"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" transmethod=\"weaver.general.CoworkTransMethod.getCoworkStatus\" />"+
				"	</head>"+
				" </table>";
			/* 2014-7-31 start */
			}else if(type == 7) {
				selectedstrs = pendingEventIDStr;

				String para2 = "column:requestid+column:workflowid+column:viewtype+0+" + user.getLanguage() + "+column:nodeid+column:isremark+" + fromid
						+ "+column:agentorbyagentid+column:agenttype+column:isprocessed";

				backfields = " a.requestId, a.workflowId, a.requestName, a.creater, d.lastname, a.createDate, a.createTime, c.workflowname,b.viewtype,b.nodeid,b.isremark,b.agentorbyagentid,b.agenttype,b.isprocessed "; 
				fromSql  = " FROM Workflow_RequestBase a left join Workflow_CurrentOperator b on a.requestId = b.requestId left join workflow_base c on a.workflowid = c.id left join HrmResource d on a.creater = d.id ";
				sqlWhere = " WHERE b.userId = "+fromid+" AND b.isRemark in ('0','1','5','8','9','7') AND b.userType = "+(String.valueOf(user.getLogintype()).equals("2") ? 1 : 0)+" and c.isvalid in ('1', '3') AND b.isLastTimes = 1 ";
				orderby = "" ;
				
				if(qname.length() > 0 ){
					sqlWhere += " and a.requestName like '%"+qname+"%' ";
				}else if(eventName.length() > 0){
					sqlWhere += " and a.requestName like '%"+eventName+"%' ";
				}
				if(eventWorkFlowName.length() > 0){
					sqlWhere += " and c.workflowname like '%"+eventWorkFlowName+"%' ";
				}
				if(eventCode.length() > 0){
					sqlWhere += " and a.creatertype = '0' and d.workcode like '%"+eventCode+"%' ";
				}
				if(eventType.length() > 0){
					sqlWhere += " and c.workflowtype = "+eventType;
				}

				String operateString= "";
				tableString =" <table pageId=\""+Constants.HRM_Z_011+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_011,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.requestId\" sqlsortway=\"DESC\" sqlisdistinct=\"\"/>"+
				operateString+
				"	<head>"+
				"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestName\" orderkey=\"requestName\" linkkey=\"requestid\" linkvaluecolumn=\"requestId\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\" otherpara=\""+para2+"\" />"+
				"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" />"+
				"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(26361,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\"/>"+
				"	</head>"+
				" </table>";
			}
			/* 2014-7-31 end */

			StringBuilder _sql = new StringBuilder();
			_sql.append("select ").append(backfields).append(fromSql).append(sqlWhere);

			rs.executeSql("select count(1) as count from (" + _sql.toString() + ") temp");
			long count = 0;
			if (rs.next()){
				count = Long.parseLong(Util.null2String(rs.getString("count"), "0"));
			}

			MJson mjson = new MJson(oldJson, true);
			String _type = "" + type;
			if(mjson.exsit(_type)) {
				mjson.updateArrayValue(_type, _sql.toString());
			} else {
				mjson.putArrayValue(_type, _sql.toString());
			}
			String oJson = Tools.getURLEncode(mjson.toString());
			mjson.removeArrayValue(_type);
			String nJson = Tools.getURLEncode(mjson.toString());
		%>
		<script>
			$GetEle("selectAllSql").value = encodeURI("<%=_sql.toString()%>");
		</script>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' selectedstrs="<%=selectedstrs%>" mode="run" /> 
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.closeByHand();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
	<script type="text/javascript">
		var parentWin;
		var dialog;

		try {
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		} catch(ex){}			
		function viewCowork(obj){
			var coworkid=$(obj).attr("_coworkid");
			var url="/cowork/ViewCoWork.jsp?id="+coworkid;
			openFullWindowForXtable(url);
			$(obj).css("font-weight","normal");
		}
		function onBtnSearchClick(){
			jQuery("#searchfrm").submit();
		}

		function doCloseDialog() {
			dialog.close();
		}

		function selectDone(id){
			if(!id){
				id = _xtable_CheckedCheckboxId();
			}
			if(!id){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
				return;
			}
			if(id.match(/,$/)){
				id = id.substring(0,id.length-1);
			}
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>",function(){
				if (dialog) {
					var data = {
						type: <%=type%>,
						isAll: false,
						id: id,
						json: '<%=nJson%>'
					};
					dialog.callback(data);
					doCloseDialog()
				} else {
					var idArr = id.split(",");
					<%if(type == 1){%>
					$GetEle("crmidstr").value = id;
					$GetEle("crmall").value = $GetEle("crmallnum").value == idArr.length ? "1" : "0";
					<%}else if(type == 2){%>
					$GetEle("projectidstr").value = id;
					$GetEle("projectall").value = $GetEle("projectallnum").value == idArr.length ? "1" : "0";
					<%}else if(type == 3){%>
					$GetEle("resourceidstr").value = id;
					$GetEle("resourceall").value = $GetEle("resourceallnum").value == idArr.length ? "1" : "0";
					<%}else if(type == 4){%>
					$GetEle("docidstr").value = id;
					$GetEle("docall").value = $GetEle("docallnum").value == idArr.length ? "1" : "0";
					<%}else if(type == 5){%>
					$GetEle("eventIDStr").value = id;
					$GetEle("eventAll").value = $GetEle("eventAllNum").value == idArr.length ? "1" : "0";
					<%}else if(type == 6){%>
					$GetEle("coworkIDStr").value = id;
					$GetEle("coworkAll").value = $GetEle("coworkAllNum").value == idArr.length ? "1" : "0";
					<%}else if(type == 7){%>
					$GetEle("pendingEventIDStr").value = id;
					$GetEle("pendingEventAll").value = $GetEle("pendingEventAllNum").value == idArr.length ? "1" : "0";
					<%}%>
					$GetEle("isDelType").value = "1";
					$GetEle("jsonSql").value = encodeURI("<%=jsonSql%>");
					$GetEle("searchfrm").action = "HrmRightTransfer.jsp";
					$GetEle("searchfrm").submit();
				}
			});
		}

		function selectAll(){
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>",function(){
				if (dialog) {
					var data = {
						type: <%=type%>,
						isAll: true,
						count: <%=count%>,
						json: '<%=oJson%>'
					};
					dialog.callback(data);
					doCloseDialog()
				} else {
					$GetEle("needExecuteSql").value = "1";
					$GetEle("jsonSql").value = encodeURI("<%=jsonSql%>");
					$GetEle("searchfrm").action = "HrmRightTransfer.jsp";
					$GetEle("searchfrm").submit();
				}
			});
		}
	</script>
	</body>
</html>
