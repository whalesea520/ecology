<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.common.xtable.TableSql" %>	
<%@ page import="weaver.common.xtable.TableConst" %>	
<%@ page import="weaver.secondary.xtable.TableColumn" %>	
<%@ page import="weaver.secondary.xtable.Table" %>
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String currentUserId = user.getUID()+"";
	String currentdate = TimeUtil.getCurrentDateString();

	int showtype = Util.getIntValue(request.getParameter("showtype"),0);
	String type1 = Util.null2String(request.getParameter("type1"));
	
	String hrmids = Util.fromScreen3(request.getParameter("hrmids"),user.getLanguage());
	
	String subcompanyids = Util.fromScreen3(request.getParameter("subcompanyids"), user.getLanguage());
	String subcompanynames = "";
	String departmentids = Util.fromScreen3(request.getParameter("departmentids"), user.getLanguage());
	String departmentnames = "";
				
	String backfields = " t.id,t.scorename,t.userid,t.year,t.type1,t.type2,t.status,t.result,t.startdate,t.enddate,h.departmentid,h.subcompanyid1,h.jobtitle ";
	String fromSql = " GP_AccessScore t,HrmResource h ";
	String orderby = " t.userid ";			
	
	String sqlWhere = " where t.isvalid=1 and t.status<>3 and t.userid=h.id and t.startdate<='"+currentdate+"'"+" and t.enddate>='"+currentdate+"'"
	 	+" and h.status in (0,1,2,3) and h.loginid is not null "+((!"oracle".equals(rs.getDBType()))?" and h.loginid<>''":"")
		+" and (t.operator="+currentUserId+" or exists(select 1 from GP_AccessScoreAudit aa where aa.scoreid=t.id and aa.userid="+currentUserId+"))";
	if(!hrmids.equals("")){
		sqlWhere += " and t.userid in ("+hrmids+")";
	}
	if(!type1.equals("")){
		sqlWhere += " and t.type1 =" + type1;
	}
	if(showtype==1){
		sqlWhere += " and (t.status=0 or t.status=2)";
	}
	if(showtype==2){
		sqlWhere += " and t.status=1";
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
	//查询当前周期未设置方案数量
	int[] amounts = OperateUtil.getNoProgramCount(currentUserId);
	int amount1 = amounts[0];
	int amount2 = amounts[1];
	int amount3 = amounts[2];
	int amount4 = amounts[3];
	String titlename = "执行力-待考核评分及审批列表";
%>
<HTML>
	<head>
		<title>绩效考核评分</title>
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
		<link rel="stylesheet" type="text/css" href="../css/table.css?1" />
		<script type='text/javascript' src='/workrelate/js/jquery.showLoading.js'></script>
		<link rel="stylesheet" type="text/css" href="/workrelate/css/showLoading.css" />
		<style type="text/css">
			.btn1{width: 60px;line-height: 20px;text-align: center;border: 1px #B0B0B0 solid;cursor: pointer;margin-left: 5px;float: left;}
			.btn_hover{background: #5581DA;color: #fff;border-color: #5581DA;}	
			.tab{width: 50px;float: left;line-height: 28px;text-align: center;cursor: pointer;font-size: 13px;}
			.tab_click{background: #B1D4D9;color: #fff;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	<SCRIPT language="javascript" src="/workrelate/js/pointout.js"></script>
	</head>
	<body style="overflow: hidden;" id="body">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:doSearch();,_self} ";
			RCMenuHeight += RCMenuHeightStep;
			if(showtype==2){
				RCMenu += "{批准已选,javascript:approveBatch(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				
				RCMenu += "{退回已选,javascript:returnBatch(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				
				RCMenu += "{批准全部,javascript:doApproveAll(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				
				RCMenu += "{退回全部,javascript:doReturnAll(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="searchForm" name="searchForm" action="AccessList.jsp" method="post">
			<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
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
								<div style="width: 100%;height: 30px;border-bottom:1px #ECECEC solid;font-size: 14px;font-weight: bold;margin-bottom: 10px;margin-top: 0px;">
									<div style="line-height: 28px;color: #333333;float: left;">待考核评分及审批列表</div>
									<%if(amount1>0 || amount2>0 || amount3>0 || amount4>0){ %>
									<div style="line-height: 28px;float: right;font-size: 12px;color: #626262;" >
										<a href="javascript:openFullWindowHaveBar('/performance/program/ProgramMain.jsp?type=3')">考核方案未设置提示</a>(
										<%if(amount1>0){ %>年度：<a href="javascript:openFullWindowHaveBar('/performance/program/ProgramMain.jsp?type=3&nofyear=1')"><%=amount1%></a>&nbsp;<%} %>
										<%if(amount2>0){ %>半年：<a href="javascript:openFullWindowHaveBar('/performance/program/ProgramMain.jsp?type=3&nohyear=1')"><%=amount2%></a>&nbsp;<%} %>
										<%if(amount3>0){ %>季度：<a href="javascript:openFullWindowHaveBar('/performance/program/ProgramMain.jsp?type=3&noquarter=1')"><%=amount3%></a>&nbsp;<%} %>
										<%if(amount4>0){ %>月度：<a href="javascript:openFullWindowHaveBar('/performance/program/ProgramMain.jsp?type=3&nomonth=1')"><%=amount4%></a><%} %>
										)
									</div>	
									
									<%} %>
								</div>
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
											<TD class="title">类型</TD>
											<TD class="value">
												<select name="showtype">
													<option value=""></option>
													<option value="1" <%if(showtype==1){ %> selected="selected" <%} %>>考核</option>
													<option value="2" <%if(showtype==2){ %> selected="selected" <%} %>>审批</option>
												</select>
											</TD>
											<TD class="title">周期</TD>
											<TD class="value">
												<select name="type1">
													<option value=""></option>
													<option value="1" <%if(type1.equals("1")){ %> selected="selected" <%} %>>月度</option>
													<option value="2" <%if(type1.equals("2")){ %> selected="selected" <%} %>>季度</option>
													<option value="3" <%if(type1.equals("3")){ %> selected="selected" <%} %>>半年</option>
													<option value="4" <%if(type1.equals("4")){ %> selected="selected" <%} %>>年度</option>
												</select>
											</TD>
											<TD class="title">人员</TD>
											<TD class="value">
												<INPUT class="wuiBrowser" type="hidden" id="hrmids" name="hrmids" value="<%=hrmids %>" _required="no"
													_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
					          	 					_displayText="<%=cmutil.getPerson(hrmids) %>" _param="resourceids" 
					          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
											</TD>
											
										</TR>
										<tr>
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
										          	 		<select class=InputStyle name="includedept">
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
									
									TableColumn xTableColumn_name=new TableColumn();
									xTableColumn_name.setColumn("scorename");
									xTableColumn_name.setDataIndex("scorename");
									xTableColumn_name.setHeader("标题");
									xTableColumn_name.setTransmethod("weaver.gp.util.TransUtil.getScoreLink");
									xTableColumn_name.setPara_1("column:id");
									xTableColumn_name.setPara_2("column:scorename");
									xTableColumn_name.setSortable(true);
									xTableColumn_name.setHideable(true);
									xTableColumn_name.setWidth(0.01); 
									xTableColumnList.add(xTableColumn_name);
									
									TableColumn xTableColumn_yeartype=new TableColumn();
									xTableColumn_yeartype.setColumn("year");
									xTableColumn_yeartype.setDataIndex("year");
									xTableColumn_yeartype.setHeader("周期");
									xTableColumn_yeartype.setTransmethod("weaver.gp.util.TransUtil.getYearType");
									xTableColumn_yeartype.setPara_1("column:year+column:type1+column:type2");
									xTableColumn_yeartype.setSortable(true);
									xTableColumn_yeartype.setHideable(true);
									xTableColumn_yeartype.setWidth(0.005); 
									xTableColumnList.add(xTableColumn_yeartype);
									
									TableColumn xTableColumn_user=new TableColumn();
									xTableColumn_user.setColumn("userid");
									xTableColumn_user.setDataIndex("userid");
									xTableColumn_user.setHeader("人员");
									xTableColumn_user.setTransmethod("weaver.gp.util.TransUtil.getPerson");
									xTableColumn_user.setPara_1("column:userid");
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
									xTableColumn_status.setColumn("status");
									xTableColumn_status.setDataIndex("status");
									xTableColumn_status.setHeader("状态");
									xTableColumn_status.setTransmethod("weaver.gp.util.TransUtil.getScoreStatus");
									xTableColumn_status.setPara_1("column:status");
									xTableColumn_status.setSortable(true);
									xTableColumn_status.setHideable(true);
									xTableColumn_status.setWidth(0.004); 
									xTableColumnList.add(xTableColumn_status);
									
									TableColumn xTableColumn_result=new TableColumn();
									xTableColumn_result.setColumn("result");
									xTableColumn_result.setDataIndex("result");
									xTableColumn_result.setHeader("当前分值");
									xTableColumn_result.setSortable(true);
									xTableColumn_result.setHideable(true);
									xTableColumn_result.setWidth(0.003); 
									xTableColumnList.add(xTableColumn_result);
									
									TableColumn xTableColumn_enddate=new TableColumn();
									xTableColumn_enddate.setColumn("enddate");
									xTableColumn_enddate.setDataIndex("enddate");
									xTableColumn_enddate.setHeader("截止日期");
									xTableColumn_enddate.setSortable(true);
									xTableColumn_enddate.setHideable(true);
									xTableColumn_enddate.setWidth(0.005); 
									xTableColumnList.add(xTableColumn_enddate);
									
									TableColumn xTableColumn_operate=new TableColumn();
									xTableColumn_operate.setColumn("operate");
									xTableColumn_operate.setDataIndex("operate");
									xTableColumn_operate.setHeader("");
									xTableColumn_operate.setTransmethod("weaver.gp.util.TransUtil.getScoreOperate");
									xTableColumn_operate.setPara_1("column:id+column:status+column:enddate");
									xTableColumn_operate.setSortable(true);
									xTableColumn_operate.setHideable(true);
									xTableColumn_operate.setWidth(0.004); 
									xTableColumnList.add(xTableColumn_operate);
									
									TableSql xTableSql=new TableSql();
									xTableSql.setBackfields(backfields);
									xTableSql.setPageSize(20);
									xTableSql.setSqlform(fromSql);
									xTableSql.setSqlwhere(sqlWhere);
									xTableSql.setSqlprimarykey("t.id");
									xTableSql.setSqlisdistinct("true");
									xTableSql.setSort(orderby);
									xTableSql.setDir(TableConst.DESC);
					
									Table xTable=new Table(request); 
																	
									xTable.setTableNeedRowNumber(true);
									xTable.setTableSql(xTableSql);
									if(showtype==2){
										xTable.setTableGridType("checkbox");
									}
									xTable.setTableColumnList(xTableColumnList);
								%>
								<%=xTable.myToString("60")%>			
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
			function changeType(type){
				$("#programtype").val(type);
				doSearch();
			}

			function doDelete(id){
				if(confirm("确定删除此指令?")){
					$.ajax({
						type: "post",
						url: "Operation.jsp",
					    data:{"operation":"del_command","id":id}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					    	//var txt = jQuery.trim(data.responseText); 
					    	_table.refresh();
					    	parent.loadElement(-1);
					    }
				    });
				}
			}
			function setCommuse(commandid,commuse){
				$.ajax({
					type: "post",
					url: "Operation.jsp",
				    data:{"operation":"set_command","id":commandid,"commuse":commuse}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){
				    	//var txt = jQuery.trim(data.responseText); 
				    	_table.refresh();
				    	parent.loadElement(-1);
				    }
			    });
			}

			function onRefresh(){
				_table.refresh();
			}
			function doApprove(scoreids) {
			     confirmStyle("确定批准此考核结果?",function(){
			      jQuery.ajax({
						type: "post",
						url: "/performance/access/AccessOperation.jsp",
					    data:{"operation":"quick_approve","scoreids":scoreids}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					    	onRefresh();
					    }
				    });
			    });
			}
			function doReturn(scoreids) {
			    confirmStyle("确定退回此考核结果??",function(){
			      jQuery.ajax({
						type: "post",
						url: "/performance/access/AccessOperation.jsp",
					    data:{"operation":"quick_return","scoreids":scoreids}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					    	onRefresh();
					    }
				    });
			    });
			}
			function doApproveAll() {
			     confirmStyle("确定批准满足当前查询条件的全部考核结果?",function(){
			      $("#body").showLoading();
			      var showtype = $("select[name='showtype']").val();
			      var type1 = $("select[name='type1']").val();
			      var hrmids = $("#hrmids").val();
			      var includesub = $("select[name='includesub']").val();
			      var subcompanyids = $("#subcompanyids").val();
			      var includedept = $("select[name='includedept']").val();
			      var departmentids = $("#departmentids").val();
			      
			      jQuery.ajax({
						type: "post",
						url: "/performance/access/AccessOperation.jsp",
					    data:{"operation":"all_approve","showtype":showtype,"type1":type1,"hrmids":hrmids,"includesub":includesub,"subcompanyids":subcompanyids,"includedept":includedept,"departmentids":departmentids}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					    	var txt = $.trim(data.responseText);
					        $('#body').hideLoading();
					        if(txt==0){
					           alertStyle("当前查询条件不存在可以批准的考核结果!");
					        }
					        onRefresh();
					    }
				    });
			    });
			}
			function doReturnAll() {
			    confirmStyle("确定退回满足当前查询条件的全部考核结果??",function(){
			      $("#body").showLoading();
			      var showtype = $("select[name='showtype']").val();
			      var type1 = $("select[name='type1']").val();
			      var hrmids = $("#hrmids").val();
			      var includesub = $("select[name='includesub']").val();
			      var subcompanyids = $("#subcompanyids").val();
			      var includedept = $("select[name='includedept']").val();
			      var departmentids = $("#departmentids").val();
			      jQuery.ajax({
						type: "post",
						url: "/performance/access/AccessOperation.jsp",
					    data:{"operation":"all_return","showtype":showtype,"type1":type1,"hrmids":hrmids,"includesub":includesub,"subcompanyids":subcompanyids,"includedept":includedept,"departmentids":departmentids}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					        var txt = $.trim(data.responseText);
					        $('#body').hideLoading();
					        if(txt==0){
					           alertStyle("当前查询条件不存在可以退回的考核结果!");
					        }
					        onRefresh();
					    }
				    });
			    });
			}
			
			function approveBatch(){
				var selectedIds = _table._xtable_CheckedCheckboxId();
				if(selectedIds == ""){
					alertStyle("请选择要批准的数据!");
					return;
				}else{
					selectedIds = selectedIds.substring(0,selectedIds.length-1);
				}
				doApprove(selectedIds);
			}
			function returnBatch(){
				var selectedIds = _table._xtable_CheckedCheckboxId();
				if(selectedIds == ""){
					alertStyle("请选择要退回准的数据!");
					return;
				}else{
					selectedIds = selectedIds.substring(0,selectedIds.length-1);
				}
				doReturn(selectedIds);
			}
		</script>
	</body>
</html>
