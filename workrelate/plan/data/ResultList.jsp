<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.common.xtable.TableSql" %>	
<%@ page import="weaver.common.xtable.TableConst" %>	
<%@ page import="weaver.secondary.xtable.TableColumn" %>	
<%@ page import="weaver.secondary.xtable.Table" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.pr.util.TransUtil" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
	String currentUserId = user.getUID()+"";
	String currentdate = TimeUtil.getCurrentDateString();

	String year = Util.null2String(request.getParameter("year"));
	String type1 = Util.null2String(request.getParameter("type1"));
	String type2 = Util.null2String(request.getParameter("type2"));
	
	if(year.equals("")){
		year = Util.null2String((String)request.getSession().getAttribute("PR_PLANREPORT_YEAR"));
		if(year.equals("")) year = currentdate.substring(0,4);
	}
	if(type1.equals("")){
		type1 = Util.null2String((String)request.getSession().getAttribute("PR_PLANREPORT_TYPE1"));
	}
	if(type2.equals("")){
		type2 = Util.null2String((String)request.getSession().getAttribute("PR_PLANREPORT_TYPE2_"+type1));
	}
	int isweek = 0;       
	int ismonth = 0;    
	rs.executeSql("select count(id) from PR_BaseSetting where resourcetype=2 and ismonth=1");
	if(rs.next() && rs.getInt(1)>0) ismonth = 1;  
	rs.executeSql("select count(id) from PR_BaseSetting where resourcetype=2 and isweek=1");
	if(rs.next() && rs.getInt(1)>0) isweek = 1;  
	if(isweek!=1 && ismonth!=1) {
		response.sendRedirect("../util/Message.jsp?type=2") ;
		return;//未启用任何周期
	}
	if(isweek!=1 && type1.equals("2")) type1 = "";
	if(ismonth!=1 && type1.equals("1")) type1 = "";
	if(type1.equals("")){
		if(isweek==1){ type1 = "2";}
		if(ismonth==1){ type1 = "1";}
	}
	if(type2.equals("")){
		if(type1.equals("2")) type2 = TimeUtil.getWeekOfYear(new Date())+"";
		if(type1.equals("1")) type2 = currentdate.substring(5,7);
		
		rs.executeSql("select count(id) from PR_PlanReport where isvalid=1 and year="+year+" and type1="+type1+" and type2="+type2+" and startdate<='"+currentdate+"'");
		if(rs.next() && rs.getInt(1)==0){
			if(type1.equals("1")){
				if(Integer.parseInt(type2)==1){
					year = (Integer.parseInt(year)-1)+"";
					type2 = "12";
				}else{
					type2 = (Integer.parseInt(type2)-1)+"";
				}
			}else if(type1.equals("2")){
				if(Integer.parseInt(type2)==1){
					year = (Integer.parseInt(year)-1)+"";
					type2 = TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))+"";
				}else{
					type2 = (Integer.parseInt(type2)-1)+"";
				}
			}
		}
	}
	boolean canview = true;
	//int currentyear = Integer.parseInt(TimeUtil.getCurrentDateString().substring(0,4)); 
	//int currentmonth = Integer.parseInt(TimeUtil.getCurrentDateString().substring(5,7)); 
	//int currentseason = Integer.parseInt(TimeUtil.getCurrentSeason()); 
	int intyear = Integer.parseInt(year);
	int inttype1 = Integer.parseInt(type1);
	int inttype2 = Integer.parseInt(type2);
	/**
	if(intyear>currentyear){
		canview = false;
	}else if(inttype1==1){
		if(intyear==currentyear && inttype2>currentmonth){
			canview = false;
		}
	}else if(inttype1==2){
		if(intyear==currentyear && inttype2>currentseason){
			canview = false;
		}
	}
	rs.executeSql("select count(id) from GP_AccessScore where isvalid=1 and year="+year+" and type1="+type1+" and type2="+type2);
	if(rs.next() && rs.getInt(1)==0){
		canview = false;
	}*/
	
	String hrmids = Util.fromScreen3(request.getParameter("hrmids"),user.getLanguage());
	
	String subcompanyids = Util.fromScreen3(request.getParameter("subcompanyids"), user.getLanguage());
	String subcompanynames = "";
	String departmentids = Util.fromScreen3(request.getParameter("departmentids"), user.getLanguage());
	String departmentnames = "";
	
	String status = Util.null2String(request.getParameter("status"));
	//String minresult = Util.null2String(request.getParameter("minresult"));
	//String maxresult = Util.null2String(request.getParameter("maxresult"));
	int isreset = Util.getIntValue(request.getParameter("isreset"),0);
				
	String backfields = " h.id,h.lastname,h.workcode,h.dsporder,t.id as planid,t.planname,t.year,t.type1,t.type2,t.status as s_status,t.isresubmit,t.startdate,t.enddate,h.departmentid,h.subcompanyid1,h.jobtitle ";
	String fromSql = " HrmResource h join PR_BaseSetting b on h.subcompanyid1=b.resourceid and b.resourcetype=2 left join PR_PlanReport t on h.id=t.userid and t.isvalid=1 and t.year="+year+" and t.type1="+type1+" and t.type2="+type2
				+" left join PR_PlanProgram p on h.id=p.userid and p.programtype="+type1;
	String orderby = " h.dsporder,h.id ";			
	
	String sqlWhere = " where h.status in (0,1,2,3) and h.loginid is not null and h.loginid<>''"
		+" and (h.id="+currentUserId+" or h.managerstr like '%,"+currentUserId+",%' or ','+convert(varchar(200),p.auditids)+',' like '%,"+currentUserId+",%' or p.shareids like '%,"+currentUserId+",%' or t.shareids like '%,"+currentUserId+",%'"
		+" or exists(select 1 from PR_BaseSetting bs where bs.resourceid=h.subcompanyid1 and bs.resourcetype=2 and (bs.reportaudit like '%,"+currentUserId+",%' or bs.reportview like '%,"+currentUserId+",%'))"
		+" or exists(select 1 from PR_BaseSetting bs where bs.resourceid=h.departmentid and bs.resourcetype=3 and (bs.reportaudit like '%,"+currentUserId+",%' or bs.reportview like '%,"+currentUserId+",%'))"
		+" or exists(select 1 from PR_PlanReportlog l where l.planid=t.id and l.operatetype in (4,5) and l.operator="+currentUserId+")"
		+")";
	if("oracle".equals(rs.getDBType())){
		sqlWhere = " where h.status in (0,1,2,3) and h.loginid is not null"
			+" and (h.id="+currentUserId+" or h.managerstr like '%,"+currentUserId+",%' or CONCAT(CONCAT(',',p.auditids),',') like '%,"+currentUserId+",%' or p.shareids like '%,"+currentUserId+",%' or t.shareids like '%,"+currentUserId+",%'"
			+" or exists(select 1 from PR_BaseSetting bs where bs.resourceid=h.subcompanyid1 and bs.resourcetype=2 and (bs.reportaudit like '%,"+currentUserId+",%' or bs.reportview like '%,"+currentUserId+",%'))"
			+" or exists(select 1 from PR_BaseSetting bs where bs.resourceid=h.departmentid and bs.resourcetype=3 and (bs.reportaudit like '%,"+currentUserId+",%' or bs.reportview like '%,"+currentUserId+",%'))"
			+" or exists(select 1 from PR_PlanReportlog l where l.planid=t.id and l.operatetype in (4,5) and l.operator="+currentUserId+")"
			+")";
	}
	if(inttype1==1){
		sqlWhere += " and b.ismonth=1";
	}else if(inttype1==2){
		sqlWhere += " and b.isweek=1";
	}else if(inttype1==3){
		//sqlWhere += " and b.ishyear=1";
	}else if(inttype1==4){
		//sqlWhere += " and b.isfyear=1";
	}
	if(!hrmids.equals("")){
		sqlWhere += " and h.id in ("+hrmids+")";
	}
	/**
	if (!subcompanyids.equals("") && !"0".equals(subcompanyids)) {
		sqlWhere += " and h.subcompanyid1 in ("+subcompanyids+")";
		List subcompanyIdList = Util.TokenizerString(subcompanyids, ",");
		for (int i = 0; i < subcompanyIdList.size(); i++) {
			subcompanynames += SubCompanyComInfo.getSubCompanyname((String)subcompanyIdList.get(i))+" ";
		}
	}
	if (!departmentids.equals("") && !"0".equals(departmentids)) {
		sqlWhere += " and h.departmentid in ("+departmentids+")";
		List departmentIdList = Util.TokenizerString(departmentids, ",");
		for (int i = 0; i < departmentIdList.size(); i++) {
			departmentnames += DepartmentComInfo.getDepartmentname((String)departmentIdList.get(i))+" ";
		}
	}*/
	int includesub = Util.getIntValue(request.getParameter("includesub"),3);
	if(!subcompanyids.equals("")&&!subcompanyids.equals("0")){//分部ID
		subcompanynames = SubCompanyComInfo.getSubCompanyname(subcompanyids);
		 if(includesub==2){
			String subCompanyIds = "";
			ArrayList list = new ArrayList();
			SubCompanyComInfo.getSubCompanyLists(subcompanyids,list);
			for(int i=0;i<list.size();i++){
				subCompanyIds += ","+(String)list.get(i);
				//subcompanynames += SubCompanyComInfo.getSubCompanyname((String)list.get(i))+" ";
			}
			if(list.size()>0)subCompanyIds = subCompanyIds.substring(1);
			
			sqlWhere += " and h.subcompanyid1 in ("+subCompanyIds+")";
			
		}else if(includesub==3){
			String subCompanyIds = subcompanyids;
			//subcompanynames += SubCompanyComInfo.getSubCompanyname(subcompanyids)+" ";
			ArrayList list = new ArrayList();
			SubCompanyComInfo.getSubCompanyLists(subcompanyids,list);
			for(int i=0;i<list.size();i++){
				subCompanyIds += ","+(String)list.get(i);
				//subcompanynames += SubCompanyComInfo.getSubCompanyname((String)list.get(i))+" ";
			}

			sqlWhere += " and h.subcompanyid1 in ("+subCompanyIds+")";
		}else{
			sqlWhere += " and h.subcompanyid1 in ("+subcompanyids+")";
		}
	}
	int includedept = Util.getIntValue(request.getParameter("includedept"),3);
	if(!departmentids.equals("") && !"0".equals(departmentids)){//部门ID
		departmentnames = DepartmentComInfo.getDepartmentname(departmentids);
		if(includedept==2){
			String departmentIds = "";
			ArrayList list = new ArrayList();
			SubCompanyComInfo.getSubDepartmentLists(departmentids,list);
			for(int i=0;i<list.size();i++){
				departmentIds += ","+(String)list.get(i);
				//departmentnames += DepartmentComInfo.getDepartmentname((String)list.get(i))+" ";
			}
			if(list.size()>0) departmentIds = departmentIds.substring(1);

			sqlWhere += " and h.departmentid in ("+departmentIds+")";
		}else if(includedept==3){
			String departmentIds = departmentids;
			//departmentnames += DepartmentComInfo.getDepartmentname(departmentids)+" ";
			ArrayList list = new ArrayList();
			SubCompanyComInfo.getSubDepartmentLists(departmentids,list);
			for(int i=0;i<list.size();i++){
				departmentIds += ","+(String)list.get(i);
				//departmentnames += DepartmentComInfo.getDepartmentname((String)list.get(i))+" ";
			}

			sqlWhere += " and h.departmentid in ("+departmentIds+")";
		}else{
			sqlWhere += " and h.departmentid in ("+departmentids+")";
		}
	}
	
	if(status.equals("0")){
		sqlWhere += " and t.startdate<='"+currentdate+"' and t.enddate>='"+currentdate+"' and (t.status=0 or t.status=2)";
	}
	if(status.equals("1")){
		sqlWhere += " and t.startdate<='"+currentdate+"' and t.enddate>='"+currentdate+"' and t.status=1";
	}
	if(status.equals("3")){
		sqlWhere += " and t.startdate<='"+currentdate+"' and t.status=3";
	}
	if(status.equals("-1")){
		sqlWhere += " and (t.id is null or t.startdate>'"+currentdate+"' or (t.enddate<'"+currentdate+"' and (t.status=0 or t.status=2 or t.status=1)))";
	}
	if(isreset==1){
		sqlWhere += " and t.isresubmit=1";
	}
	
	String titlename = cmutil.getYearType(year+"+"+type1+"+"+type2 )+ "工作计划报告";
	//System.out.println("select "+backfields+" from "+fromSql+" "+sqlWhere);
	request.getSession().setAttribute("PR_PLANREPORT_YEAR",year);
	request.getSession().setAttribute("PR_PLANREPORT_TYPE1",type1);
	request.getSession().setAttribute("PR_PLANREPORT_TYPE2_"+type1,type2);
	
	String weekdate1 = TimeUtil.getDateString(TimeUtil.getFirstDayOfWeek(Integer.parseInt(year),Integer.parseInt(type2)));
	String weekdate2 = TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(Integer.parseInt(year),Integer.parseInt(type2)));
	int currentweek = TimeUtil.getWeekOfYear(new Date());
%>
<HTML>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/ext-all_wev8.css' />
		<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/xtheme-gray_wev8.css'/>
		<link rel='stylesheet' type='text/css' href='/css/weaver-ext_wev8.css' />
		<script type='text/javascript' src='/js/extjs/adapter/ext/ext-base_wev8.js'></script>
		<script type='text/javascript' src='/js/extjs/ext-all_wev8.js'></script>   
		<%if(user.getLanguage()==7) {%>
			<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_CN_wev8.js'></script>
			<script type='text/javascript' src='/js/weaver-lang-cn-gbk_wev8.js'></script>
		<%} else if(user.getLanguage()==8) {%>
			<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-en_wev8.js'></script>
			<script type='text/javascript' src='/js/weaver-lang-en-gbk_wev8.js'></script>
		<%}%>
		<script type="text/javascript" src="/secondwev/js/WeaverTableExt.js"></script>  
		<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />
		<link rel="stylesheet" type="text/css" href="../css/table.css" />
		<link rel="stylesheet" type="text/css" href="../css/tab.css" />
		<style type="text/css">
			.status{width: 30px;height: 24px;margin-right: 4px;display:-moz-inline-box;display:inline-block;float: left;cursor:pointer;}
			.status1{background: url('../images/status1.png') center no-repeat;}
			.status2{background: url('../images/status2.png') center no-repeat;}
			.status3{background: url('../images/status3.png') center no-repeat;}
			.status4{background: url('../images/pstatus0.png') center no-repeat;}
			.status5{background: url('../images/status5.png') center no-repeat;}
			.status6{background: url('../images/status6.png') center no-repeat;}
			.status7{background: url('../images/status7.png') center no-repeat;}
			.status8{background: url('../images/status8.png') center no-repeat;}
			.status_txt{height: 24px;display:-moz-inline-box;display:inline-block;float: left;}
			.rescore{width: 14px;height: 22px;background: url('../images/rescore.png') center no-repeat;display:-moz-inline-box;display:inline-block;}
			
			.operatespan{float: right;margin-right: 10px;display: none;}
			.x-grid3-row-over .operatespan{display: inline;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body style="overflow: hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:doSearch();,_self} ";
			RCMenuHeight += RCMenuHeightStep;
			
			//RCMenu += "{"+"Excel,javascript:exportExcel(),_top} " ;
			//RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="searchForm" name="searchForm" action="ResultList.jsp" method="post">
			<input type="hidden" id="year" name="year" value="<%=year %>">
			<input type="hidden" id="type1" name="type1" value="<%=type1 %>">
			<input type="hidden" id="type2" name="type2" value="<%=type2 %>">
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="10"/>
					<col width=""/>
					<col width="10"/>
				</colgroup>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
						<tr>
							<td valign="top">
								<div class="tabpanel">
									<div id="yearpanel" class="yearpanel" >&nbsp;&nbsp;&nbsp;<%=year %></div>
									<%if(isweek==1){%><div class="tab <%if(type1.equals("2")){ %>tab_click<%} %>" onclick="changeType(2)">周报</div><%} %>
									<%if(ismonth==1){ %><div class="tab <%if(type1.equals("1")){ %>tab_click<%} %>" onclick="changeType(1)">月报</div><%} %>
									<%if(type1.equals("1")){ %>
									<div class="tab2_panel" style="width: 422px;">
									<%for(int i=1;i<13;i++){ %>
										<div class="tab2 <%if(Integer.parseInt(type2)==i){ %>tab2_click<%} %>" onclick="changeType2(<%=i %>)"><%=i %>月</div>
									<%} %>
									</div>
									<%}else if(type1.equals("2")){ 
									%>
									<div class="tab2_panel" style="width: 261px;">
										<div class="week_btn1 <%if(inttype2!=1){ %>week_prev<%} %>" <%if(inttype2!=1){ %> onclick="changeType2(<%=inttype2-1 %>)" title="上一周" <%} %>></div>
										<div id="weekpanel" class="week_txt">第&nbsp;<%=type2 %>&nbsp;周</div>
										<div class="week_btn2 <%if(inttype2!=TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))){ %>week_next<%} %>" <%if(inttype2!=TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))){ %> onclick="changeType2(<%=inttype2+1 %>)" title="下一周" <%} %>></div>
										<div class="week_show"><%=weekdate1+" 至 "+weekdate2 %></div>
									</div>
									<%}else{ %>
									<div class="tab2_panel" style="width: 1px;border-right: 0px;"></div>
									<%} %>
									<div class="maintitle"><%=titlename%></div>
								</div>
								<%if(canview){ %>
								<TABLE id="searchTable" class="searchtable" cellpadding="0" cellspacing="0" border="0">
									<COLGROUP>
										<COL width="11%"/>
										<COL width="22%"/>
										<COL width="11%"/>
										<COL width="22%"/>
										<COL width="12%"/>
										<COL width="22%"/>
									</COLGROUP>
									<TBODY>
										<TR>
											<TD class="title">状态</TD>
											<TD class="value">
												<select name="status">
													<option value=""></option>
													<option value="0" <%if(status.equals("0")){ %> selected="selected" <%} %>>草稿</option>
													<option value="1" <%if(status.equals("1")){ %> selected="selected" <%} %>>审批中</option>
													<option value="3" <%if(status.equals("3")){ %> selected="selected" <%} %>>已完成</option>
													<option value="-1" <%if(status.equals("-1")){ %> selected="selected" <%} %>>其他</option>
												</select>
											</TD>
											<TD class="title">人员</TD>
											<TD class="value">
												<INPUT class="wuiBrowser" type="hidden" id="hrmids" name="hrmids" value="<%=hrmids %>" _required="no"
													_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
					          	 					_displayText="<%=cmutil.getPerson(hrmids) %>" _param="resourceids" 
					          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
											</TD>
											<TD class="title">分部</TD>
											<TD class="value">
								          	 	<table class="innertable" cellpadding="0" cellspacing="0" border="0">
								          	 		<tr>
								          	 			<td>
									          	 			<select class=InputStyle name="includesub">
										          	 			<option value="3" <%if(includesub==3){%>SELECTED<%}%>>含子分部</option>
															  	<option value="1" <%if(includesub==1){%>SELECTED<%}%>>仅本分部</option>
															  	<option value="2" <%if(includesub==2){%>SELECTED<%}%>>仅子分部</option>
															</select>
								          	 			</td>
								          	 			<td>
								          	 				<INPUT class="wuiBrowser" type="hidden" id="subcompanyids" name="subcompanyids" value="<%=subcompanyids %>"
								          	 					_displayText="<%=subcompanynames %>" 
								          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" />
								          	 			</td>
								          	 		</tr>
								          	 	</table>
								          	</TD>
										</TR>
										<tr>
											
								          	<TD class="title">部门</TD>
											<TD class="value" colspan="5">
												<table class="innertable" cellpadding="0" cellspacing="0" border="0">
								          	 		<tr>
								          	 			<td>
										          	 		<select class=InputStyle name="includesub">
										          	 			<option value="3" <%if(includedept==3){%>SELECTED<%}%>>含子部门</option>
										          	 			<option value="1" <%if(includedept==1){%>SELECTED<%}%>>仅本部门</option>
															  	<option value="2" <%if(includedept==2){%>SELECTED<%}%>>仅子部门</option>
															</select>
  														</td>
								          	 			<td>
															<INPUT class="wuiBrowser" type="hidden" id="departmentids" name="departmentids" value="<%=departmentids %>"
								          	 					_displayText="<%=departmentnames %>"
								          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" />
								          	 			</td>
								          	 		</tr>
								          	 	</table>
								          	 	<div style="width: auto;height: 26px;float: right;margin-top: 3px;">
								          	 		<div class="btn1 btn" onclick="doSearch();" title="搜索">搜索</div>
								          	 	</div>
								          	</TD>
										</tr>
									</TBODY>
								</TABLE>
								<%
								
									//out.println("select "+backfields+" from "+fromSql+ sqlWhere);
																
									ArrayList xTableColumnList=new ArrayList();
									
									TableColumn xTableColumn_user=new TableColumn();
									xTableColumn_user.setColumn("id");
									xTableColumn_user.setDataIndex("id");
									xTableColumn_user.setHeader("人员");
									xTableColumn_user.setTransmethod("weaver.gp.util.TransUtil.getPerson");
									xTableColumn_user.setPara_1("column:id");
									xTableColumn_user.setSortable(true);
									xTableColumn_user.setHideable(true);
									xTableColumn_user.setWidth(0.003); 
									xTableColumnList.add(xTableColumn_user);
																	
									TableColumn xTableColumn_subcompany=new TableColumn();
									xTableColumn_subcompany.setColumn("subcompanyid1");
									xTableColumn_subcompany.setDataIndex("subcompanyid1");
									xTableColumn_subcompany.setHeader("分部");
									xTableColumn_subcompany.setTransmethod("weaver.hrm.company.SubCompanyComInfo.getSubCompanyname");
									xTableColumn_subcompany.setPara_1("column:subcompanyid1");
									xTableColumn_subcompany.setSortable(true);
									xTableColumn_subcompany.setHideable(true);
									xTableColumn_subcompany.setWidth(0.006); 
									xTableColumnList.add(xTableColumn_subcompany);
									
									TableColumn xTableColumn_department=new TableColumn();
									xTableColumn_department.setColumn("departmentid");
									xTableColumn_department.setDataIndex("departmentid");
									xTableColumn_department.setHeader("部门");
									xTableColumn_department.setTransmethod("weaver.hrm.company.DepartmentComInfo.getDepartmentname");
									xTableColumn_department.setPara_1("column:departmentid");
									xTableColumn_department.setSortable(true);
									xTableColumn_department.setHideable(true);
									xTableColumn_department.setWidth(0.006); 
									xTableColumnList.add(xTableColumn_department);
									
									
									TableColumn xTableColumn_status=new TableColumn();
									xTableColumn_status.setColumn("s_status");
									xTableColumn_status.setDataIndex("s_status");
									xTableColumn_status.setHeader("状态");
									xTableColumn_status.setTransmethod("weaver.pr.util.TransUtil.getPlanStatusDetail");
									xTableColumn_status.setPara_1("column:planid");
									xTableColumn_status.setPara_2("column:s_status+column:startdate+column:enddate+column:id+"+intyear+"+"+inttype1+"+"+inttype2);
									xTableColumn_status.setSortable(true);
									xTableColumn_status.setHideable(true);
									xTableColumn_status.setWidth(0.012); 
									xTableColumnList.add(xTableColumn_status);
									
									
									/**
									TableColumn xTableColumn_enddate=new TableColumn();
									xTableColumn_enddate.setColumn("enddate");
									xTableColumn_enddate.setDataIndex("enddate");
									xTableColumn_enddate.setHeader("截止日期");
									xTableColumn_enddate.setSortable(true);
									xTableColumn_enddate.setHideable(true);
									xTableColumn_enddate.setWidth(0.005); 
									xTableColumnList.add(xTableColumn_enddate);
									*/
									/**
									TableColumn xTableColumn_operate=new TableColumn();
									xTableColumn_operate.setColumn("scoreid");
									xTableColumn_operate.setDataIndex("scoreid");
									xTableColumn_operate.setHeader("操作");
									xTableColumn_operate.setTransmethod("weaver.gp.util.TransUtil.getScoreResultView");
									xTableColumn_operate.setPara_1("column:scoreid");
									xTableColumn_operate.setSortable(true);
									xTableColumn_operate.setHideable(true);
									xTableColumn_operate.setWidth(0.004); 
									xTableColumnList.add(xTableColumn_operate);
									*/
									TableSql xTableSql=new TableSql();
									xTableSql.setBackfields(backfields);
									xTableSql.setPageSize(20);
									xTableSql.setSqlform(fromSql);
									xTableSql.setSqlwhere(sqlWhere);
									xTableSql.setSqlprimarykey("h.id");
									xTableSql.setSqlisdistinct("true");
									xTableSql.setSort(orderby);
									xTableSql.setDir(TableConst.ASC);
					
									Table xTable=new Table(request); 
																	
									xTable.setTableNeedRowNumber(true);
									xTable.setTableSql(xTableSql);
									xTable.setTableColumnList(xTableColumnList);
									
									//String sql = "select distinct " + backfields + " from " + fromSql + sqlWhere
									//+ " order by h.dsporder,h.id";
									
									//request.getSession().setAttribute("PR_PLANRESULT_SQL",sql);
									//request.getSession().setAttribute("PR_PLANRESULT_TITLE",titlename);
								%>
								<%=xTable.myToString("64")%>	
								<%}else{ %>
								<font style="color: red;font-size: 13px;margin-left: 5px;">此周期暂无数据！</font>
								<%} %>		
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
		</table>
		</form>
		<iframe id="searchexport" style="display:none"></iframe>
		<div id="yearselect" class="yearselect">
		<% 
			int currentyear = Integer.parseInt(currentdate.substring(0,4));
			for(int i=2013;i<(currentyear+4);i++){ %>
			<div class="yearoption" _val="<%=i %>">&nbsp;&nbsp;&nbsp;<%=i %></div>
		<%	} %>
		</div>
		<div id="weekselect" class="weekselect">
			<%
				for(int i=1;i<TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))+1;i++){
			%>
				<div class="weekoption<%if(currentweek==i){ %> weekoption_current<%} %><%if(inttype2==i){ %> weekoption_select<%} %>" <%if(inttype2!=i){ %> onclick="changeType2(<%=i%>)" style="cursor:pointer;" <%} %>>第<%=i %>周</div>
			<%	} %> 
		</div>
		<script type="text/javascript" src="../js/tab.js"></script>  
		<script type="text/javascript">
			$(document).ready(function(){
				jQuery("div.btn").live("mouseover",function(){
					jQuery(this).addClass("btn_hover");
				}).live("mouseout",function(){
					jQuery(this).removeClass("btn_hover");
				});
			});
	
		   	document.onkeydown=keyListener;
			function keyListener(e){
			    e = e ? e : event;   
			    if(e.keyCode == 13){
			    	doSearch();
			    }    
			}
			function doSearch(){
				$("#searchForm").submit();
			}
			function doSearch2(type,orgid){
				if(type==1){
					jQuery("#subcompanyids").val("");
					jQuery("#departmentids").val("");
					jQuery("#hrmids").val("");
				}else if(type==2){
					jQuery("#subcompanyids").val(orgid);
					jQuery("#departmentids").val("");
					jQuery("#hrmids").val("");
				}else if(type==3){
					jQuery("#subcompanyids").val("");
					jQuery("#departmentids").val(orgid);
					jQuery("#hrmids").val("");
				}else if(type==4){
					jQuery("#subcompanyids").val("");
					jQuery("#departmentids").val("");
					jQuery("#hrmids").val(orgid);
				}
				doSearch();
			}
			function exportExcel(){
				jQuery("#searchexport").attr("src","AccessExport.jsp");
			}
			function changeType(type){
				$("#programtype").val(type);
				doSearch();
			}

			function onRefresh(){
				_table.refresh();
			}
			function changeYear(year){
				jQuery("#year").val(year);
				doSearch();
			}
			function changeType(type){
				jQuery("#type1").val(type);
				jQuery("#type2").val("");
				doSearch();
			}
			function changeType2(type){
				jQuery("#type2").val(type);
				doSearch();
			}
		</script>
	</body>
</html>
