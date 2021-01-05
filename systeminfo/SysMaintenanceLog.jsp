<!DOCTYPE HTML>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-08-08 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="companyInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    String wflog=Util.null2String(request.getParameter("wflog"));
    String from=Util.null2String(request.getParameter("from"));
    String isDialog = Util.null2String(request.getParameter("isdialog"));
	String condition = Util.null2String(request.getParameter("condition"), "show");
    String operateitem = Util.null2String(request.getParameter("operateitem"));
	
    String relatedid = Util.null2String(request.getParameter("relatedid"));
    if(operateitem.equals("418")||operateitem.equals("419")||operateitem.equals("420")){
    	if(!relatedid.equals("")){
	    	response.sendRedirect("/systeminfo/LabelManageLog.jsp?"+request.getQueryString());
	    	return;
    	}
    }
    if(!isDialog.equals("no"))isDialog="1";
	int secid = Util.getIntValue(request.getParameter("secid"),0);
	String subname="";
	if(secid != 0) subname = ":" + SystemEnv.getHtmlLabelName(secid,user.getLanguage());
	String sql="";
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	if(sqlwhere.equals("")){
		sqlwhere = "where operateitem="+operateitem;
	}else if(sqlwhere.indexOf("operateitem")==-1){
		sqlwhere = " and operateitem="+operateitem;
	}
	if(sqlwhere.endsWith("relatedid=")){
		sqlwhere += relatedid;
	}else if(sqlwhere.indexOf("relatedid=")==-1){
		if(!relatedid.equals("")){
			sqlwhere+= " and relatedid="+relatedid;
		}
	}
	/*add by lvyi 这个页面有点特殊*/
	if(from.equals("hrmcontract")){
		sqlwhere += Util.null2String(request.getParameter("id"))+")";
	}
	boolean isLogView = HrmUserVarify.checkUserRight("LogView:View", user);

	boolean isResourcesInfoSys = HrmUserVarify.checkUserRight("ResourcesInformationSystem:All", user);

	// 如果是登录日志查看，需要检查是否有登录日志查看的权限 （刘煜修改）
	if( ((sqlwhere.equals("")||(sqlwhere.indexOf("operateitem=60")>=0)) && !isLogView)||((sqlwhere.equals("")||(sqlwhere.indexOf("operateitem=89")>=0))&&!isResourcesInfoSys))  {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String subcomid = Util.null2String(request.getParameter("subcomid"));
	String checkDeptId = Util.null2String(request.getParameter("checkDeptId"));
	String cmd = Util.null2String(request.getParameter("cmd"));
	String chartType = Util.null2String(request.getParameter("chartType"));
	String qname = Util.null2String(request.getParameter("qname"));
	String srid = Util.null2String(request.getParameter("srid"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String fromdate = Util.null2String(request.getParameter("fromdate"));
	String todate = Util.null2String(request.getParameter("todate"));
	String dateselect =Util.fromScreen(request.getParameter("dateselect"),user.getLanguage());
	if(cmd.equals("sr") && !srid.equals("1")){
		if(chartType.equals("all")){
			dateselect = "";
		}else if(chartType.equals("day")){
			dateselect = "1";
		}else if(chartType.equals("week")){
			dateselect = "2";
		}else if(chartType.equals("month")){
			dateselect = "3";
		}else if(chartType.equals("quarter")){
			dateselect = "4";
		}else if(chartType.equals("year")){
			dateselect = "5";
		}
	}
	if(!dateselect.equals("") && !dateselect.equals("0")&& !dateselect.equals("6")){
		fromdate = TimeUtil.getDateByOption(dateselect,"0");
		todate = TimeUtil.getDateByOption(dateselect,"1");
	}
	
	int start = Util.getIntValue(request.getParameter("start") ,1) ;
	String linkstr;
		if(!ajax.equals("1"))
	linkstr="SysMaintenanceLog.jsp?sqlwhere="+sqlwhere+"&resourceid="+resourceid+"&fromdate="+fromdate+"&todate="+todate ;
		else
	linkstr="/systeminfo/SysMaintenanceLog.jsp?ajax=1&sqlwhere="+sqlwhere+"&resourceid="+resourceid+"&fromdate="+fromdate+"&todate="+todate ;

	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(83,user.getLanguage())+subname;
	String needfav ="";
	String needhelp ="";
	String subcompanyid=request.getParameter("subcompanyid");
	boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
	//String isNew = Util.null2String(request.getParameter("isNew"));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if(!dialog){
				dialog = parent.getDialog(this);
			}
			if("<%=cmd%>" != "NOTCHANGE"){
				try{
					parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(32940,user.getLanguage())%>");
				}catch(e){}
			}
			
			function onBtnSearchClick(){
				jQuery("#SysMaintenanceLog").submit();
			}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)&& !cmd.equals("sr")){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%if(!isfromtab ) {%>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%} %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(!condition.equals("hidden")){
			if(!ajax.equals("1"))
			{
				if(!cmd.equals("sr")){
					RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSubmit(),_self}";
					RCMenuHeight += RCMenuHeightStep;
				}
			}
			else
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:logsearch(),_self}";
				RCMenuHeight += RCMenuHeightStep;
			}
			}
			if(!isfromtab && !isDialog.equals("1") && !cmd.equals("sr")){
			if(sqlwhere.indexOf("operateitem=90") >= 0)
			//协作区退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goCoworkBack(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=85") >= 0&&!wflog.equals("1"))
			//路径设置、路径模版查看日志返回
			{
				//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goWorkFlowMonitorBack(),_self} " ;
				String isTemplate=sqlwhere.indexOf("isTemplate=1")>0?"1":"0";
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goWorkFlowLogBack("+isTemplate+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=91") >= 0)
			//我的日程监控退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goWorkPlanMonitorBack(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=23") >= 0)
			//办公地点退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goOfficePlaceBack(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=24") >= 0)
			//职务类别按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goDutyCategoryBack() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			
			else if(sqlwhere.indexOf("operateitem=25") >= 0)
			//职务设置退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goDutySetBack() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
		   else if(sqlwhere.indexOf("operateitem=26") >= 0)
			//岗位设置退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goPostSetBack() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=93") >= 0)
			//奖惩管理退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goPunishManagerBack() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=95") >= 0)
			//项目监控退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goItemManagerBack() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=94") >= 0)
			//奖惩种类退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goPunishTypeBack() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=96") >= 0)
			//考核项目退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goCheckItem() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=97") >= 0)
			//考核种类退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goCheckKind() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem =17")>=0)
			{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goHrmScheduleDiffBack() ,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			}
		   else if(sqlwhere.indexOf("operateitem =79")>=0)
			{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goHrmScheduleMaintanceBack() ,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem =13")>=0)
			{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goHrmDefaultScheduleListBack() ,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem =21")>=0)
			{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goHrmPubHolidayBack() ,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem =75")>=0)
			{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goDocMouldBack() ,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem =7")>=0)
			{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goDocSysDefaultsBack() ,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			}else if(sqlwhere.indexOf("operateitem=16 and relatedid=")>=0){//返回单个角色页面Tab1
				int roleid_tmp = Util.getIntValue(sqlwhere.trim().substring(sqlwhere.trim().indexOf("operateitem=16 and relatedid=")+"operateitem=16 and relatedid=".length()), 0);
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goRoleBack1("+roleid_tmp+") ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}else if(sqlwhere.indexOf("operateitem=102 and relatedid=")>=0){//返回单个角色页面Tab2
				int roleid_tmp = Util.getIntValue(sqlwhere.trim().substring(sqlwhere.trim().indexOf("operateitem=102 and relatedid=")+"operateitem=102 and relatedid=".length()), 0);
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goRoleBack2("+roleid_tmp+") ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}else if(sqlwhere.indexOf("operateitem=32 and relatedid=")>=0){//返回单个角色页面Tab3
		//		int roleid_tmp = Util.getIntValue(sqlwhere.trim().substring(sqlwhere.trim().indexOf("operateitem=32 and relatedid=")+"operateitem=32 and relatedid=".length()), 0);
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1) ,_self} " ;
		//		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goRoleBack3("+roleid_tmp+") ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}else if(sqlwhere.indexOf("operateitem=103 and relatedid=")>=0){//返回单个角色页面Tab4
				int roleid_tmp = Util.getIntValue(sqlwhere.trim().substring(sqlwhere.trim().indexOf("operateitem=103 and relatedid=")+"operateitem=103 and relatedid=".length()), 0);
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goRoleBack4("+roleid_tmp+") ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}else if(sqlwhere.indexOf("operateitem=16")>=0){//返回角色页面
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goRoleListBack() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=100") >= 0)
			//新闻设置类型退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goNewsTypeBack() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=101") >= 0)
			//网段策略退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goIpStrategyBack() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=45") >= 0)
			//单位设置-日志查询页面退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goLgcAssetUnitBack() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}else if(sqlwhere.indexOf("operateitem=44") >= 0)
			//类型设置-日志查询页面退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goCptCapitalTypeBack() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(sqlwhere.indexOf("operateitem=51") >= 0)
			//资产资料维护-日志查询页面退回按钮
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goCptCapitalMaintenanceBack() ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			else if(!wflog.equals("1")){	
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1) ,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			}
			RCMenu += "{EXCEL,javascript:exportExcel(),_self}";
			RCMenuHeight += RCMenuHeightStep;
			String sqlWhere = "";
			String fromUrl = Util.null2String(request.getParameter("_fromURL"));
		%>

		<iframe name="excels" id="excels" src="" style="display:none" ></iframe>
		<%if(!fromUrl.equals("3")&&!cmd.equals("sr")){ %>
			<jsp:include page="/systeminfo/commonTabHead.jsp">
	 		  	<jsp:param name="mouldID" value="default"/>
	   			<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(31709,user.getLanguage()) %>"/>
			</jsp:include>
		<%} %>
		<FORM id=SysMaintenanceLog name=SysMaintenanceLog action="/systeminfo/SysMaintenanceLog.jsp" method=post>
		<input type="hidden" id=_fromURL name="_fromURL" value="<%=fromUrl %>">
		<input type="hidden" id=cmd name="cmd" value="<%=cmd %>">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(!ajax.equals("1")&&!cmd.equals("sr")&&!condition.equals("hidden")){%>
					<input type=button class="e8_btn_top" onclick="OnSubmit();" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>"></input>
					<%}%>
					<%if(cmd.equals("sr")){%>
						<input type="text" class="searchInput" name="qname" value="<%=qname%>"/>
						<input type="hidden" id=srid name="srid" value="1">
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%if(cmd.equals("sr")){%>
		<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelNames("674,1867",user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="resourceid" browserValue='<%=resourceid %>' width="120px"
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp" tempTitle='<%= SystemEnv.getHtmlLabelNames("674,1867",user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
							browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage()) %>'>
					   </brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1276,user.getLanguage())%></wea:item>
					<wea:item>
						<span class="wuiDateSpan">
						    <input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
						    <input class=wuiDateSel  type="hidden" name="todate" value="<%=todate%>">
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelNames("674,127,124",user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="checkDeptId" width="120px"
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
							browserValue='<%=checkDeptId %>' 
							browserSpanValue = '<%=DepartmentComInfo.getDepartmentNames(checkDeptId)%>'  tempTitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
							isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='1'
							completeUrl="/data.jsp?type=4" >
						</brow:browser> 
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelNames("674,127,141",user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="subcomid" browserValue='<%=subcomid %>' width="120px"
							browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
							hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp?type=164"  tempTitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
							browserSpanValue='<%=SubCompanyComInfo.getSubcompanynames(subcomid) %>'>
						</brow:browser>
					</wea:item>
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
		<%}%>
		<%
		if(ajax.equals("1")){
		%>
		<input type="hidden" id=ajax name="ajax" value="1">
		<%}%>
		<input type="hidden" id=sqlwhere name="sqlwhere" value="<%=xssUtil.put(sqlwhere)%>">
		<input type="hidden" name="start" value=''>
		<input type="hidden" id=cmd name="cmd" value="<%=cmd%>">
		<input type="hidden" id=chartType name="chartType" value="<%=chartType%>">
		<%
			if(cmd.equals("sr")){
				String backFields = "id, relatedName, operateType, lableId, operateUserId, operateDate, operateTime, clientAddress";
				
				String sqlForm = "";
				
				if(sqlwhere.indexOf("operateitem=60")>=0){
					sqlForm = "HrmSysMaintenanceLog  SysMaintenanceLog, SystemLogItem";
				}else{
					sqlForm = "SysMaintenanceLog, SystemLogItem";
				}
				
				if(sqlwhere.indexOf("operateitem=85")>=0 && !isLogView)
				//流程监控需要根据监控列表判断查看范围
				{
				}
				else if(sqlwhere.indexOf("operateitem=91") >= 0)
				{
					sqlForm += ", WorkPlanMonitor";
				}
								
				sqlWhere = sqlwhere;
				sqlWhere += " AND SysMaintenanceLog.operateItem = SystemLogItem.itemId";
				if(sqlwhere.indexOf("operateitem=85")>=0 && !isLogView)
				//流程监控需要根据监控列表判断查看范围
				{
					//sqlWhere += " AND WorkFlow_Monitor_Bound.monitorHrmId = " + user.getUID() + " AND WorkFlow_Monitor_Bound.workFlowId = SysMaintenanceLog.relatedId";
					String wfidsql = Monitor.getwfidRightSql(user.getUID()+"",rs.getDBType());
					sqlWhere += " and SysMaintenanceLog.relatedId in ("+wfidsql+")";
				}
				else if(sqlwhere.indexOf("operateitem=91") >= 0)
				{
					sqlWhere += " AND WorkPlanMonitor.hrmId = " + user.getUID() + " AND WorkPlanMonitor.workPlanTypeId = SysMaintenanceLog.relatedId";
				}
				
				String sqlOrderBy = "";
								
				if(!"".equals(resourceid))
				{
					sqlWhere += " AND operateUserId = " + resourceid;
				}
				
				if(qname.length() > 0){
					sqlWhere += " AND operateUserId in (select id from hrmresource where lastname like '%"+qname+"%')";
				}
				
				if(!"".equals(fromdate))
				{
					sqlWhere += " and operateDate >= '" + fromdate + "'";				    
				}
				if(!"".equals(todate))
				{
					sqlWhere += " and operateDate <= '" + todate + "'";
				}
				if(!"".equals(subcomid))
				{
				sqlWhere += " AND operateUserId in  (select id from hrmresource where subcompanyid1 in ("+subcomid+") ) ";
				}
				if(!"".equals(checkDeptId))
				{
				sqlWhere += " AND operateUserId in  (select id from hrmresource where departmentid in ("+checkDeptId+") ) ";
				}

				String tableString = ""+
					"<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.SYS_LOGLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"none\">"+
					"<sql backfields=\"" + backFields + "\" sqlform=\"" + sqlForm + "\" sqlprimarykey=\"id\" sqlorderby=\"" + "id" + "\" sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlisdistinct=\"true\" />"+
					"<head>"+
						"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelNames("674,1867", user.getLanguage())+"\" labelid=\"674,1867\" column=\"operateUserId\" orderkey=\"operateUserId\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getResourceNameLink\"/>"+
						"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(1276, user.getLanguage())+"\" labelid=\"1276\" column=\"operateDate\" orderkey=\"operateDate\" otherpara=\"column:operateTime\" transmethod=\"weaver.splitepage.transform.SptmForCowork.combineDateTime\" />"+
						"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(63, user.getLanguage())+"\" labelid=\"63\" column=\"operateType\" orderkey=\"operateType\"  otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getTypeName\" />"+
						"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(101, user.getLanguage())+"\" labelid=\"101\" column=\"lableId\"  orderkey=\"lableId\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getItemLableName\"/>"+
						"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(106, user.getLanguage())+"\" labelid=\"106\" column=\"relatedName\" orderkey=\"relatedName\"/>"+
						"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelNames("108,110", user.getLanguage())+"\" labelid=\"108,110\" column=\"clientAddress\" orderkey=\"clientAddress\" />"+
					"</head>"+
					"</table>";
			
			%>
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.SYS_LOGLIST %>"/>
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 
		<%}else {
			String backFields = "id, relatedName, operateType, lableId, operateUserId, operateDate, operateTime, clientAddress";
			
			String sqlForm = "SysMaintenanceLog, SystemLogItem";
			if(sqlwhere.indexOf("operateitem=85")>=0 && !isLogView)
			//流程监控需要根据监控列表判断查看范围
			{
			}
			else if(sqlwhere.indexOf("operateitem=91") >= 0)
			{
				sqlForm += ", WorkPlanMonitor";
			}
							
			sqlWhere = sqlwhere;
			sqlWhere += " AND SysMaintenanceLog.operateItem = SystemLogItem.itemId";
			if(sqlwhere.indexOf("operateitem=85")>=0 && !isLogView)
			//流程监控需要根据监控列表判断查看范围
			{
				//sqlWhere += " AND WorkFlow_Monitor_Bound.monitorHrmId = " + user.getUID() + " AND WorkFlow_Monitor_Bound.workFlowId = SysMaintenanceLog.relatedId";
				String wfidsql = Monitor.getwfidRightSql(user.getUID()+"",rs.getDBType());
				sqlWhere += " and SysMaintenanceLog.relatedId in ("+wfidsql+")";
			}
			else if(sqlwhere.indexOf("operateitem=91") >= 0)
			{
				sqlWhere += " AND WorkPlanMonitor.hrmId = " + user.getUID() + " AND WorkPlanMonitor.workPlanTypeId = SysMaintenanceLog.relatedId";
			}
			
			String sqlOrderBy = "";
							
			if(!"".equals(resourceid))
			{
				sqlWhere += " AND operateUserId = " + resourceid;
			}
			
			if(qname.length() > 0){
				sqlWhere += " AND operateUserId in (select id from hrmresource where lastname like '%"+qname+"%')";
			}
			
			if(!"".equals(fromdate))
			{
				sqlWhere += " and operateDate >= '" + fromdate + "'";				    
			}
			if(!"".equals(todate))
			{
				sqlWhere += " and operateDate <= '" + todate + "'";
			}

			if(!"".equals(subcomid))
			{
			sqlWhere += " AND operateUserId in  (select id from hrmresource where subcompanyid1 in ("+subcomid+") ) ";
			}
			if(!"".equals(checkDeptId))
			{
			sqlWhere += " AND operateUserId in  (select id from hrmresource where departmentid in ("+checkDeptId+") ) ";
			}

			String tableString = ""+
				"<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.SYS_LOGLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"none\">"+
				"<sql backfields=\"" + backFields + "\" sqlform=\"" + sqlForm + "\" sqlprimarykey=\"id\" sqlorderby=\"" + "" + "\" sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlisdistinct=\"true\" />"+
				"<head>"+
					"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(97, user.getLanguage())+"\" labelid=\"97\" column=\"operateDate\" orderkey=\"operateDate\" otherpara=\"column:operateTime\" transmethod=\"weaver.splitepage.transform.SptmForCowork.combineDateTime\" />"+
					//"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(16017, user.getLanguage())+"\" column=\"operateUserId\" transmethod=\"weaver.splitepage.transform.SptmForLog.getLoginName\"/>"+
					//"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(141, user.getLanguage())+"\" column=\"operateUserId\" transmethod=\"weaver.splitepage.transform.SptmForLog.getSubName\"/>"+
					//  "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(124, user.getLanguage())+"\" column=\"operateUserId\" transmethod=\"weaver.splitepage.transform.SptmForLog.getDepName\"/>"+
					"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(99, user.getLanguage())+"\" labelid=\"99\" column=\"operateUserId\" orderkey=\"operateUserId\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getResourceNameLink\"/>"+

					
					"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(63, user.getLanguage())+"\" labelid=\"63\" column=\"operateType\" orderkey=\"operateType\"  otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getTypeName\" />"+
					"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(101, user.getLanguage())+"\" labelid=\"101\" column=\"lableId\"  orderkey=\"lableId\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getItemLableName\"/>"+
					"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(106, user.getLanguage())+"\" labelid=\"106\" column=\"relatedName\" orderkey=\"relatedName\"/>"+
					"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(108, user.getLanguage())+SystemEnv.getHtmlLabelName(110, user.getLanguage())+"\" labelid=\"108,110\" column=\"clientAddress\" orderkey=\"clientAddress\"/>"+
				"</head>"+
				"</table>";
			
		%>
		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.SYS_LOGLIST %>"/>
		<%if(!condition.equals("hidden")){%>
		<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="resourceid" browserValue='<%=resourceid %>' width="120px"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp" tempTitle='<%= SystemEnv.getHtmlLabelName(17482,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
						browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage()) %>'>
				   </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(2061,user.getLanguage())%></wea:item>
				<wea:item>
					<span class="wuiDateSpan">
					    <input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
					    <input class=wuiDateSel  type="hidden" name="todate" value="<%=todate%>">
					</span>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="checkDeptId" width="120px"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
						browserValue='<%=checkDeptId %>' 
						browserSpanValue = '<%=DepartmentComInfo.getDepartmentNames(checkDeptId)%>'  tempTitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
						isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='1'
						completeUrl="/data.jsp?type=4" >
					</brow:browser> 
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="subcomid" browserValue='<%=subcomid %>' width="120px"
						browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp?type=164"  tempTitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
						browserSpanValue='<%=SubCompanyComInfo.getSubcompanynames(subcomid) %>'>
					</brow:browser>
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(32940,user.getLanguage()) %>' attributes="{'groupOperDisplay':'none'}">
				<wea:item attributes="{'isTableList':'true','colspan':'full'}">
					<!--================== 显示列表 ==================-->					
					<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 
				</wea:item>
			</wea:group>
		</wea:layout>
		<%} else {%>
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 
		<%}}%>
		</form>
		<%if(!ajax.equals("1")){%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<%}else {%>
		<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
		<%}%>
		<%if(!ajax.equals("1")){%>
		<script language="javascript">
		function toDate(str)
		{    
			var sd=str.split("-");    
			return new Date(sd[0],sd[1],sd[2]);
		}

		function onShowBranch(datas,e){
		  if(datas){
			 if(datas.id!=""){
			   jQuery("#subcomid").val(datas.id.substr(1));
			 }else{
			   jQuery("#subcomid").val(""); 
			 }    
		  }
		}

		function onShowResourceID(inputname,spanname){
			var opts={
					_dwidth:'550px',
					_dheight:'550px',
					_url:'about:blank',
					_scroll:"no",
					_dialogArguments:"",
					_displayTemplate:"#b{name}",
					_displaySelector:"",
					_required:"no",
					_displayText:"",
					value:""
				};
			var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
			var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
			opts.top=iTop;
			opts.left=iLeft;
				
			datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
						"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
			if (datas) {
				if (datas.id!= "") {
					
					$("#"+spanname).html("<A href='javascript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</A>");

					$("input[name="+inputname+"]").val(datas.id);
				}else{
					$("#"+spanname).html("");
					$("input[name="+inputname+"]").val("");
				}
			}
		}

		function onShowSubcompany(inputname,spanname)  {
			var opts={
					_dwidth:'550px',
					_dheight:'550px',
					_url:'about:blank',
					_scroll:"no",
					_dialogArguments:"",
					_displayTemplate:"#b{name}",
					_displaySelector:"",
					_required:"no",
					_displayText:"",
					value:""
				};
			var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
			var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
			opts.top=iTop;
			opts.left=iLeft;
				
			linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
			datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
					"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
		   if (datas) {
				if (datas.id!= "") {
					ids = datas.id.split(",");
					names =datas.name.split(",");
					sHtml = "";
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
							sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
						}
					}
					$("#"+spanname).html(sHtml);
					$("input[name="+inputname+"]").val(datas.id);
				}
				else	{
					 $("#"+spanname).html("");
					$("input[name="+inputname+"]").val("");
				}
			}
		}
		function onShowDepartment(datas,e){
			if(datas){
			 if(datas.id!=""){
			   jQuery("#checkDeptId").val(datas.id.substr(1));
			 }else{
			   jQuery("#checkDeptId").val(""); 
			 }    
		  }
		}

		function exportExcel()
		{
			document.getElementById("excels").src = "LogExcel.jsp?sqlwhere=<%=xssUtil.put(sqlWhere)%>&cmd=<%=cmd%>";
		}

		function OnSubmit()
		{   
		<%if(wflog.equals("1")){%>
			SysMaintenanceLog.action="/systeminfo/SysMaintenanceLog.jsp?wflog=1";
		<%}%>
			if(toDate(SysMaintenanceLog.fromdate.value)>toDate(SysMaintenanceLog.todate.value))
			{
				alert("<%=SystemEnv.getHtmlLabelName(129305, user.getLanguage())%>");
				return;
			}
			SysMaintenanceLog.submit();
		}

		function goCoworkBack()
		{
			window.location = "/system/systemmonitor/cowork/CoworkMonitor.jsp";
		}

		function goWorkFlowMonitorBack()
		{
			window.location = "/system/systemmonitor/workflow/WorkflowMonitorList.jsp";
		}

		function goWorkFlowLogBack(isTemplate){
			window.location = "/workflow/workflow/managewf.jsp?isWorkflowDoc=&isTemplate="+isTemplate;
		}

		function goWorkPlanMonitorBack()
		{
			window.location = "/system/systemmonitor/workplan/WorkPlanMonitor.jsp";
		}

		function goOfficePlaceBack()
		{
			window.location = "/hrm/location/HrmLocation.jsp";
		}
		function goDutyCategoryBack() 
		{
			 window.location="/hrm/jobgroups/HrmJobGroups.jsp";
		 }
		 function goDutySetBack()
		{
			window.location='/hrm/jobactivities/HrmJobActivities.jsp';
		 }
		 function goPostSetBack()
		{
			window.location='/hrm/jobtitles/HrmJobTitles.jsp';
		 }
		 function goPunishManagerBack()
		{
		 window.location='/hrm/award/HrmAward.jsp';
		 }
		 function goPunishTypeBack()
		{
		 window.location='/hrm/award/HrmAwardType.jsp';
		 }
		 function goHrmScheduleDiffBack()
		{
		 window.location="/hrm/schedule/HrmScheduleDiff.jsp?subcompanyid=<%=subcompanyid%>";
		 }
		 function goHrmScheduleMaintanceBack()
		{
		 window.location="/hrm/schedule/HrmScheduleMaintance.jsp";
		 }
		function goHrmDefaultScheduleListBack()
		{
		window.location="/hrm/schedule/HrmDefaultScheduleList.jsp";
		}
		function goHrmPubHolidayBack()
		{
		window.location="/hrm/schedule/HrmPubHoliday.jsp";
		}
		function goDocSysDefaultsBack()
		{
		window.location="/docs/tools/DocSysDefaults.jsp";
		}
		function goItemManagerBack()
		{
		window.location="/system/systemmonitor/proj/ProjMonitor.jsp";
		}
		function goCheckItem()
		{
		window.location="/hrm/check/HrmCheckItem.jsp";
		}
		function goCheckKind()
		{
		window.location="/hrm/check/HrmCheckKind.jsp";
		}
		function goDocMouldBack()
		{
		window.location="/docs/mouldfile/DocMould.jsp";
		}
		function goNewsTypeBack()
		{
		window.location="/docs/news/type/newstypeList.jsp";
		}
		function goIpStrategyBack()
		{
		window.location="/hrm/tools/NetworkSegmentStrategy.jsp";
		}
		function goRoleListBack(){
			window.location="/hrm/roles/HrmRoles.jsp";
		}
		function goRoleBack1(roleid){
			window.location="/hrm/roles/HrmRolesEdit.jsp?id="+roleid;
		}
		function goRoleBack2(roleid){
			window.location="/hrm/roles/HrmRolesFucRightSet.jsp?id="+roleid;
		}
		//function goRoleBack3(roleid){
		//	window.location="/hrm/roles/HrmRolesMembers.jsp?id="+roleid+"&type=0";
			//window.location="/hrm/roles/HrmRolesMembersEdit.jsp?id="+roleid;
		//}
		function goRoleBack4(roleid){
			window.location="/hrm/roles/HrmRolesStrRightSet.jsp?id="+roleid;
		}
		function goLgcAssetUnitBack()
		{
		window.location="/lgc/maintenance/LgcAssetUnit.jsp";
		}
		function goCptCapitalTypeBack()
		{
			location.href = "/cpt/maintenance/CptCapitalType.jsp";
		}
		function goCptCapitalMaintenanceBack()
		{
			history.back();
			//location.href = "/cpt/capital/CptCapitalMaintenance.jsp";
			//location.href = "/cpt/capital/CptCapMain_frm.jsp";
		}
		</script>
		<%}%>
		<%if(!fromUrl.equals("3")&&!cmd.equals("sr")){ %>
			<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
		<%} %>
		<%if("1".equals(isDialog)&& !cmd.equals("sr")){ %>
			</div>
			<div id="zDialog_div_bottom" class="zDialog_div_bottom">
				<wea:layout type="2col">
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="top.Dialog.close();">
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
			<script type="text/javascript">
				jQuery(document).ready(function(){
					window.notExecute = true;
					resizeDialog(document);
				});
			</script>
		<%} %>
	</BODY>
	<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>

