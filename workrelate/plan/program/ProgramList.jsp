<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.common.xtable.TableSql" %>	
<%@ page import="weaver.common.xtable.TableConst" %>	
<%@ page import="weaver.secondary.xtable.TableColumn" %>	
<%@ page import="weaver.secondary.xtable.Table" %>	
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
	String currentUserId = user.getUID()+"";
	
	int isfyear = 0;       
	int ishyear = 0;     
	int isquarter = 0;       
	int ismonth = 0;    
	rs.executeSql("select count(id) from GP_BaseSetting where resourcetype=2 and isfyear=1");
	if(rs.next() && rs.getInt(1)>0) isfyear = 1;  
	rs.executeSql("select count(id) from GP_BaseSetting where resourcetype=2 and ishyear=1");
	if(rs.next() && rs.getInt(1)>0) ishyear = 1;  
	rs.executeSql("select count(id) from GP_BaseSetting where resourcetype=2 and isquarter=1");
	if(rs.next() && rs.getInt(1)>0) isquarter = 1;  
	rs.executeSql("select count(id) from GP_BaseSetting where resourcetype=2 and ismonth=1");
	if(rs.next() && rs.getInt(1)>0) ismonth = 1;  
	if(isfyear!=1 && ishyear!=1 && isquarter!=1 && ismonth!=1) {
		response.sendRedirect("../util/Message.jsp?type=2") ;
		return;//未启用任何考核
	}

	String hrmids = Util.fromScreen3(request.getParameter("hrmIds"),user.getLanguage());
	String subcompanyids = Util.fromScreen3(request.getParameter("subcompanyids"), user.getLanguage());
	String subcompanynames = "";
	String departmentids = Util.fromScreen3(request.getParameter("departmentids"), user.getLanguage());
	String departmentnames = "";
	
	String backfields = " h.id,h.departmentid,h.subcompanyid1,h.jobtitle,t.isfyear,t.ishyear,t.isquarter,t.ismonth,h.dsporder ";
	String fromSql = " HrmResource h,GP_BaseSetting t";
	String orderby = " h.dsporder,h.id ";
	String sqlWhere = " where h.subcompanyid1=t.resourceid and t.resourcetype=2"
				+" and h.status in (0,1,2,3) and h.loginid is not null and h.loginid<>''"
				+" and (t.ismonth=1 or t.isquarter=1 or t.ishyear=1 or t.isfyear=1)"
				+" and (h.id="+currentUserId+" or h.managerstr like '%,"+currentUserId+",%'"
				+" or exists(select 1 from GP_BaseSetting bs where bs.resourceid=h.subcompanyid1 and bs.resourcetype=2 and (bs.programcreate like '%,"+currentUserId+",%' or bs.programaudit like '%,"+currentUserId+",%'))"
				+")";
	if("oracle".equals(rs.getDBType())){
		sqlWhere = " where h.subcompanyid1=t.resourceid and t.resourcetype=2"
				+" and h.status in (0,1,2,3) and h.loginid is not null"
				+" and (t.ismonth=1 or t.isquarter=1 or t.ishyear=1 or t.isfyear=1)"
				+" and (h.id="+currentUserId+" or h.managerstr like '%,"+currentUserId+",%'"
				+" or exists(select 1 from GP_BaseSetting bs where bs.resourceid=h.subcompanyid1 and bs.resourcetype=2 and (bs.programcreate like '%,"+currentUserId+",%' or bs.programaudit like '%,"+currentUserId+",%'))"
				+")";
	}
	if(!hrmids.equals("")){
		sqlWhere += " and h.id in ("+hrmids+")";
	}
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
	}
	
	int nofyear = Util.getIntValue(request.getParameter("nofyear"),0);
	int nohyear = Util.getIntValue(request.getParameter("nohyear"),0);
	int noquarter = Util.getIntValue(request.getParameter("noquarter"),0);
	int nomonth = Util.getIntValue(request.getParameter("nomonth"),0);
	if(nofyear==1 || nohyear==1 || noquarter==1 || nomonth==1){
		String basedate = "";
		int year = Util.getIntValue(TimeUtil.getCurrentDateString().substring(0,4));//当前年份
		int month = Util.getIntValue(TimeUtil.getCurrentDateString().substring(5,7));//当前月份
    	int season = Util.getIntValue(TimeUtil.getCurrentSeason());//当前季度
    	sqlWhere += " and (";
    	String nowhere = "";
    	if(nofyear==1){
			basedate = TimeUtil.getYearMonthEndDay(year,12);
			if(!nowhere.equals("")) nowhere += " or ";
			nowhere += "(t.isfyear=1 and not exists(select 1 from GP_AccessProgram ap where ap.status=3 and ap.startdate<=Convert(VARCHAR(10),dateadd(d,t.fstartdays*t.fstarttype,'"+basedate+"'),126) and ap.programtype=4 and ap.userid=h.id))";
		}else if(nohyear==1){
			basedate = TimeUtil.getYearMonthEndDay(year,6);
			if(!nowhere.equals("")) nowhere += " or ";
			nowhere += "(t.ishyear=1 and not exists(select 1 from GP_AccessProgram ap where ap.status=3 and ap.startdate<=Convert(VARCHAR(10),dateadd(d,t.hstartdays*t.hstarttype,'"+basedate+"'),126) and ap.programtype=3 and ap.userid=h.id))";
		}else if(noquarter==1){
			if(season==1) basedate = TimeUtil.getYearMonthEndDay(year,3);
			if(season==2) basedate = TimeUtil.getYearMonthEndDay(year,6);
			if(season==3) basedate = TimeUtil.getYearMonthEndDay(year,9);
			if(season==4) basedate = TimeUtil.getYearMonthEndDay(year,12);
			if(!nowhere.equals("")) nowhere += " or ";
			nowhere += "(t.isquarter=1 and not exists(select 1 from GP_AccessProgram ap where ap.status=3 and ap.startdate<=Convert(VARCHAR(10),dateadd(d,t.qstartdays*t.qstarttype,'"+basedate+"'),126) and ap.programtype=2 and ap.userid=h.id))";
		}else if(nomonth==1){
			basedate = TimeUtil.getYearMonthEndDay(year,month);
			if(!nowhere.equals("")) nowhere += " or ";
			nowhere += "(t.ismonth=1 and not exists(select 1 from GP_AccessProgram ap where ap.status=3 and ap.startdate<=Convert(VARCHAR(10),dateadd(d,t.mstartdays*t.mstarttype,'"+basedate+"'),126) and ap.programtype=1 and ap.userid=h.id))";
		}
    	sqlWhere += nowhere;
    	sqlWhere += ")";
	}
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
		<style type="text/css">
			.status{width: 30px;height: 24px;margin-right: 10px;display:-moz-inline-box;display:inline-block;float: left;}
			.status0{background: url('../images/pstatus0.png') center no-repeat;}
			.status1{background: url('../images/pstatus1.png') center no-repeat;}
			.status2{background: url('../images/pstatus2.png') center no-repeat;}
			.status3{background: url('../images/pstatus3.png') center no-repeat;}
			.status4{background: url('../images/pstatus4.png') center no-repeat;}
			.status_txt{height: 24px;display:-moz-inline-box;display:inline-block;float: left;}
			.status_link{cursor: pointer;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body style="overflow: hidden;">
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:doSearch();,_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="searchForm" name="searchForm" action="ProgramList.jsp" method="post">
			<input type="hidden" id="nofyear" name="nofyear" value="<%=nofyear %>"/>
			<input type="hidden" id="nohyear" name="nohyear" value="<%=nohyear %>"/>
			<input type="hidden" id="noquarter" name="noquarter" value="<%=noquarter %>"/>
			<input type="hidden" id="nomonth" name="nomonth" value="<%=nomonth %>"/>
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="10"/>
					<col width=""/>
					<col width="10"/>
				</colgroup>
				<tr style="height: 10px;">
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
						<tr>
							<td valign="top">
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
											<TD class="title">人员</TD>
											<TD class="value">
												<INPUT class="wuiBrowser" type="hidden" id="hrmIds" name="hrmIds" value="<%=hrmids %>" _required="no"
													_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
					          	 					_displayText="<%=cmutil.getPerson(hrmids) %>" _param="resourceids" 
					          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
											</TD>
											<TD class="title">分部</TD>
											<TD class="value">
												<INPUT class="wuiBrowser" type="hidden" id="subcompanyids" name="subcompanyids" value="<%=subcompanyids %>"
								          	 		_displayText="<%=subcompanynames %>" _param="selectedids"
								          	 		_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp" />
								          	</TD>
								          	<TD class="title">部门</TD>
											<TD class="value">
												<INPUT class="wuiBrowser" type="hidden" id="departmentids" name="departmentids" value="<%=departmentids %>"
								          	 		_displayText="<%=departmentnames %>" _param="selectedids"
								          	 		_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" />
								          	</TD>
										</TR>
										<tr>
											<TD class="title">类型</TD>
											<TD class="value" colspan="5">
												<table class="innertable" cellpadding="0" cellspacing="0" border="0">
								          	 		<tr>
								          	 			<td>
														<%if(isfyear==1){ %><input type="checkbox" <%if(nofyear==1){ %> checked="checked" <%} %> onclick="changeType(this,'nofyear')"/>无年度&nbsp;&nbsp;<%} %>
														<%if(ishyear==1){ %><input type="checkbox" <%if(nohyear==1){ %> checked="checked" <%} %> onclick="changeType(this,'nohyear')"/>无半年&nbsp;&nbsp;<%} %>
														<%if(isquarter==1){ %><input type="checkbox" <%if(noquarter==1){ %> checked="checked" <%} %> onclick="changeType(this,'noquarter')"/>无季度&nbsp;&nbsp;<%} %>
														<%if(ismonth==1){ %><input type="checkbox" <%if(nomonth==1){ %> checked="checked" <%} %> onclick="changeType(this,'nomonth')"/>无月度<%} %>
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
									xTableColumn_user.setWidth(0.004); 
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
									
									/**
									TableColumn xTableColumn_jobtitle=new TableColumn();
									xTableColumn_jobtitle.setColumn("jobtitle");
									xTableColumn_jobtitle.setDataIndex("jobtitle");
									xTableColumn_jobtitle.setHeader("岗位");
									xTableColumn_jobtitle.setTransmethod("weaver.hrm.job.JobTitlesComInfo.getJobTitlesname");
									xTableColumn_jobtitle.setPara_1("column:jobtitle");
									xTableColumn_jobtitle.setSortable(true);
									xTableColumn_jobtitle.setHideable(true);
									xTableColumn_jobtitle.setWidth(0.006); 
									xTableColumnList.add(xTableColumn_jobtitle);
									*/
									
									TableColumn xTableColumn_status=new TableColumn();
									xTableColumn_status.setColumn("s_status");
									xTableColumn_status.setDataIndex("s_status");
									xTableColumn_status.setHeader("状态");
									xTableColumn_status.setTransmethod("weaver.gp.util.TransUtil.getProgramStatusDetail");
									xTableColumn_status.setPara_1("column:id");
									xTableColumn_status.setPara_2("column:isfyear+column:ishyear+column:isquarter+column:ismonth+column:fstarttype+column:fstartdays+column:hstarttype+column:hstartdays+column:qstarttype+column:qstartdays+column:mstarttype+column:mstartdays");
									xTableColumn_status.setSortable(true);
									xTableColumn_status.setHideable(true);
									xTableColumn_status.setWidth(0.012); 
									xTableColumnList.add(xTableColumn_status);
									
									/**
									TableColumn xTableColumn_operate=new TableColumn();
									xTableColumn_operate.setColumn("operate");
									xTableColumn_operate.setDataIndex("operate");
									xTableColumn_operate.setHeader("操作");
									xTableColumn_operate.setTransmethod("weaver.gp.util.TransUtil.getProgramAuditOperate");
									xTableColumn_operate.setPara_1("column:id");
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
								%>
								<%=xTable.myToString("30")%>			
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
		</table>
		</form>
		
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
			function changeType(obj,typeid){
				if($(obj).attr("checked")){
					$("#"+typeid).val(1);
				}else{
					$("#"+typeid).val(0);
				}
				doSearch();
			}

			function onRefresh(){
				_table.refresh();
				try{
					if(parent != null && parent.pageTop!=null){
						parent.pageTop.document.location = "ProgramMenu.jsp?type=3&<%=TimeUtil.getOnlyCurrentTimeString()%>";
					}
				}catch(e){alert(e);}
			}
		</script>
	</body>
</html>
