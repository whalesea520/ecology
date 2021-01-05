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
	String currentdate = TimeUtil.getCurrentDateString();

	String year = Util.null2String(request.getParameter("year"));
	String type1 = "1";
	String type2 = Util.null2String(request.getParameter("type2"));
	
	if(year.equals("")){
		year = currentdate.substring(0,4);
	}
	int ismonth = 0; 
	rs.executeSql("select count(id) from GP_BaseSetting where resourcetype=2 and ismonth=1");
	if(rs.next() && rs.getInt(1)>0) ismonth = 1;  
	if(ismonth!=1) {
		response.sendRedirect("../util/Message.jsp?type=2") ;
		return;//未启用月度考核
	}
	boolean canview = true;
	//int currentyear = Integer.parseInt(TimeUtil.getCurrentDateString().substring(0,4)); 
	//int currentmonth = Integer.parseInt(TimeUtil.getCurrentDateString().substring(5,7)); 
	//int currentseason = Integer.parseInt(TimeUtil.getCurrentSeason()); 
	int intyear = Integer.parseInt(year);
	int inttype1 = Integer.parseInt(type1);
	int maxm = 13;
	int cyear = Integer.parseInt(currentdate.substring(0,4));
	int cmonth = Integer.parseInt(currentdate.substring(5,7));
	if(intyear>cyear) maxm = 0;
	if(intyear==cyear) maxm = cmonth;
	
	String hrmids = Util.fromScreen3(request.getParameter("hrmids"),user.getLanguage());
	
	String subcompanyids = Util.fromScreen3(request.getParameter("subcompanyids"), user.getLanguage());
	String subcompanynames = "";
	String departmentids = Util.fromScreen3(request.getParameter("departmentids"), user.getLanguage());
	String departmentnames = "";
	
	StringBuffer backfields = new StringBuffer();
	StringBuffer fromsql = new StringBuffer();
	StringBuffer sqlWhere = new StringBuffer();
	
	backfields.append(" h.id,h.lastname,h.workcode,h.dsporder,h.departmentid,h.subcompanyid1,h.jobtitle");
	fromsql.append(" HrmResource h join GP_BaseSetting b on h.subcompanyid1=b.resourceid and b.resourcetype=2");
	for(int i=1;i<maxm;i++){
		backfields.append(",t"+i+".id as scoreid"+i+",t"+i+".result as result"+i);
		fromsql.append(" left join GP_AccessScore t"+i+" on h.id=t"+i+".userid and t"+i+".isvalid=1 and t"+i+".year="+year+" and t"+i+".type1=1 and t"+i+".type2="+i);
	}
	String orderby = " h.dsporder,h.id ";			
	
	sqlWhere.append(" where h.status in (0,1,2,3) and h.loginid is not null "+((!"oracle".equals(rs.getDBType()))?" and h.loginid<>''":""));
	sqlWhere.append(" and (h.id="+currentUserId+" or h.managerstr like '%,"+currentUserId+",%' ");
	//sqlWhere.append(" or exists(select 1 from GP_AccessScoreCheck ac where ac.scoreid=t.id and ac.userid="+currentUserId+")");
	sqlWhere.append(" or exists(select 1 from GP_BaseSetting bs where bs.resourceid=h.subcompanyid1 and bs.resourcetype=2 and (bs.accessconfirm like '%,"+currentUserId+",%' or bs.accessview like '%,"+currentUserId+",%'))");
	sqlWhere.append(" or exists(select 1 from GP_BaseSetting bs where bs.resourceid=h.departmentid and bs.resourcetype=3 and (bs.accessconfirm like '%,"+currentUserId+",%' or bs.accessview like '%,"+currentUserId+",%'))");
	sqlWhere.append(")");
	if(inttype1==1){
		sqlWhere.append(" and b.ismonth=1");
	}else if(inttype1==2){
		sqlWhere.append(" and b.isquarter=1");
	}else if(inttype1==3){
		sqlWhere.append(" and b.ishyear=1");
	}else if(inttype1==4){
		sqlWhere.append(" and b.isfyear=1");
	}
	if(!hrmids.equals("")){
		sqlWhere.append(" and h.id in ("+hrmids+")");
	}
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
			
			sqlWhere.append(" and h.subcompanyid1 in ("+subCompanyIds+")");
			
		}else if(includesub==3){
			String subCompanyIds = subcompanyids;
			//subcompanynames += SubCompanyComInfo.getSubCompanyname(subcompanyids)+" ";
			ArrayList list = new ArrayList();
			SubCompanyComInfo.getSubCompanyLists(subcompanyids,list);
			for(int i=0;i<list.size();i++){
				subCompanyIds += ","+(String)list.get(i);
				//subcompanynames += SubCompanyComInfo.getSubCompanyname((String)list.get(i))+" ";
			}

			sqlWhere.append(" and h.subcompanyid1 in ("+subCompanyIds+")");
		}else{
			sqlWhere.append(" and h.subcompanyid1 in ("+subcompanyids+")");
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

			sqlWhere.append(" and h.departmentid in ("+departmentIds+")");
		}else if(includedept==3){
			String departmentIds = departmentids;
			//departmentnames += DepartmentComInfo.getDepartmentname(departmentids)+" ";
			ArrayList list = new ArrayList();
			SubCompanyComInfo.getSubDepartmentLists(departmentids,list);
			for(int i=0;i<list.size();i++){
				departmentIds += ","+(String)list.get(i);
				//departmentnames += DepartmentComInfo.getDepartmentname((String)list.get(i))+" ";
			}

			sqlWhere.append(" and h.departmentid in ("+departmentIds+")");
		}else{
			sqlWhere.append(" and h.departmentid in ("+departmentids+")");
		}
	}
	
	String titlename = year+ "年月度考核结果统计";
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
			.status{width: 30px;height: 24px;margin-right: 4px;display:-moz-inline-box;display:inline-block;float: left;}
			.status1{background: url('../images/status1.png') center no-repeat;}
			.status2{background: url('../images/status2.png') center no-repeat;}
			.status3{background: url('../images/status3.png') center no-repeat;}
			.status4{background: url('../images/status4.png') center no-repeat;}
			.status5{background: url('../images/status5.png') center no-repeat;}
			.status6{background: url('../images/status6.png') center no-repeat;}
			.status7{background: url('../images/status7.png') center no-repeat;}
			.status8{background: url('../images/status8.png') center no-repeat;}
			.status_txt{height: 24px;display:-moz-inline-box;display:inline-block;float: left;}
			.rescore{width: 14px;height: 22px;background: url('../images/rescore.png') center no-repeat;display:-moz-inline-box;display:inline-block;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body style="overflow: hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:doSearch();,_self} ";
			RCMenuHeight += RCMenuHeightStep;
			
			RCMenu += "{"+"Excel,javascript:exportExcel(),_top} " ;
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="searchForm" name="searchForm" action="ReportList.jsp" method="post">
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
									<div class="maintitle" style="float:left;"><%=titlename%></div>
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
								          	<TD class="title">部门</TD>
											<TD class="value" colspan="3">
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
									
									for(int i=1;i<13;i++){
										TableColumn xTableColumn_result=new TableColumn();
										xTableColumn_result.setColumn("result"+i);
										xTableColumn_result.setDataIndex("result"+i);
										xTableColumn_result.setHeader(i+"月");
										xTableColumn_result.setTransmethod("weaver.gp.util.TransUtil.getScoreReporttView");
										xTableColumn_result.setPara_1("column:result"+i);
										xTableColumn_result.setPara_2("column:scoreid"+i+"+0+column:id+"+intyear+"+1+"+i);
										xTableColumn_result.setSortable(true);
										xTableColumn_result.setHideable(true);
										xTableColumn_result.setWidth(0.003); 
										xTableColumnList.add(xTableColumn_result);
									}
									
									
									TableSql xTableSql=new TableSql();
									xTableSql.setBackfields(backfields.toString());
									xTableSql.setPageSize(20);
									xTableSql.setSqlform(fromsql.toString());
									xTableSql.setSqlwhere(sqlWhere.toString());
									xTableSql.setSqlprimarykey("h.id");
									xTableSql.setSqlisdistinct("true");
									xTableSql.setSort(orderby);
									xTableSql.setDir(TableConst.ASC);
					
									Table xTable=new Table(request); 
																	
									xTable.setTableNeedRowNumber(true);
									xTable.setTableSql(xTableSql);
									xTable.setTableColumnList(xTableColumnList);
									
									String sql = "select distinct " + backfields.toString() + " from " + fromsql.toString() + sqlWhere.toString()
									+ " order by h.dsporder,h.id";
									
									request.getSession().setAttribute("GP_ACCESSREPORT_SQL",sql);
									request.getSession().setAttribute("GP_ACCESSREPORT_TITLE",titlename);
								%>
								<%=xTable.myToString("64")%>	
								<%}else{ %>
								<font style="color: red;font-size: 13px;margin-left: 5px;">暂无数据！</font>
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
		<script type="text/javascript" src="../js/tab.js"></script>  
		<script type="text/javascript">
			$(document).ready(function(){
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
				jQuery("#searchexport").attr("src","ReportExport.jsp");
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
				doSearch();
			}
			function changeType2(type){
				jQuery("#type2").val(type);
				doSearch();
			}
		</script>
	</body>
</html>
