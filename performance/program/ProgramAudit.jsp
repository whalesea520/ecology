<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.common.xtable.TableSql" %>	
<%@ page import="weaver.common.xtable.TableConst" %>	
<%@ page import="weaver.secondary.xtable.TableColumn" %>	
<%@ page import="weaver.secondary.xtable.Table" %>
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String userid = user.getUID()+"";
	String programtype = Util.getIntValue(request.getParameter("programtype"),0)+"";
	//查询是否是审核人
	/**
	rs.executeSql("select count(id) from GP_BaseSetting where ','+convert(varchar(2000),programaudit)+',' like '%,"+userid+",%'");
	if(rs.next() && rs.getInt(1)==0){
		if(programtype.equals("0")) programtype = "1";
		response.sendRedirect("ProgramView.jsp?resourceid="+userid+"&programtype="+programtype) ;
	    return ;
	}*/

	String programname = Util.fromScreen3(request.getParameter("programname"),user.getLanguage());
	String hrmids = Util.fromScreen3(request.getParameter("hrmids"),user.getLanguage());
	String subcompanyids = Util.fromScreen3(request.getParameter("subcompanyids"), user.getLanguage());
	String subcompanynames = "";
	String departmentids = Util.fromScreen3(request.getParameter("departmentids"), user.getLanguage());
	String departmentnames = "";
	
	String backfields = " t1.id,t1.programname,t1.userid,t1.startdate,t1.programtype,h.departmentid,h.subcompanyid1,h.jobtitle ";
	String fromSql = " GP_AccessProgram t1,GP_AccessProgramAudit t2,HrmResource h ";
	String orderby = " t1.id ";
	String sqlWhere = " where t1.id=t2.programid and t1.userid=h.id and h.status in (0,1,2,3) and h.loginid is not null "+((!"oracle".equals(rs.getDBType()))?" and h.loginid<>''":"")+" and t2.userid="+userid;
	if(!programtype.equals("0")){
		sqlWhere += " and t1.programtype ="+programtype;
	}
	if(!programname.equals("")){
		sqlWhere += " and t1.programname like '%"+programname+"%'";
	}
	if(!hrmids.equals("")){
		sqlWhere += " and t1.userid in ("+hrmids+")";
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
	String titlename = "执行力-待审核方案";
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
		<link rel="stylesheet" type="text/css" href="../css/table.css?1" />
		<script type='text/javascript' src='/workrelate/js/jquery.showLoading.js'></script>
		<link rel="stylesheet" type="text/css" href="/workrelate/css/showLoading.css" />
		<style type="text/css">
	
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
		
			RCMenu += "{批准已选,javascript:approveBatch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			
			RCMenu += "{退回已选,javascript:returnBatch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			
			RCMenu += "{批准全部,javascript:doApproveAll(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			
			RCMenu += "{退回全部,javascript:doReturnAll(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="searchForm" name="searchForm" action="ProgramAudit.jsp" method="post">
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
											<TD class="title">名称</TD>
											<TD class="value">
												<INPUT class=inputstyle type=text name="programname" value="<%=programname%>" style="width:95%" maxlength="50"/>
											</TD>
											<TD class="title">类型</TD>
											<TD class="value">
												<select name="programtype">
													<option value=""></option>
													<option value="1" <%if(programtype.equals("1")){ %> selected="selected" <%} %>>月度</option>
													<option value="2" <%if(programtype.equals("2")){ %> selected="selected" <%} %>>季度</option>
													<option value="3" <%if(programtype.equals("3")){ %> selected="selected" <%} %>>半年</option>
													<option value="4" <%if(programtype.equals("4")){ %> selected="selected" <%} %>>年度</option>
												</select>
											</TD>
											<TD class="title">人员</TD>
											<TD class="value">
												<INPUT class="wuiBrowser" type="hidden" id="hrmIds" name="hrmIds" value="<%=hrmids %>" _required="no"
													_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
					          	 					_displayText="<%=cmutil.getPerson(hrmids) %>" _param="resourceids" 
					          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
											</TD>
										</TR>
										<tr>
											<TD class="title">分部</TD>
											<TD class="value">
												<INPUT class="wuiBrowser" type="hidden" id="subcompanyids" name="subcompanyids" value="<%=subcompanyids %>"
								          	 		_displayText="<%=subcompanynames %>" _param="selectedids"
								          	 		_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp" />
								          	</TD>
								          	<TD class="title">部门</TD>
											<TD class="value" colspan="3">
												<table class="innertable" cellpadding="0" cellspacing="0" border="0">
													<tr>
														<td>
															<INPUT class="wuiBrowser" type="hidden" id="departmentids" name="departmentids" value="<%=departmentids %>"
								          	 					_displayText="<%=departmentnames %>" _param="selectedids"
								          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" />
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
									xTableColumn_name.setColumn("programname");
									xTableColumn_name.setDataIndex("programname");
									xTableColumn_name.setHeader("考核方案");
									xTableColumn_name.setTransmethod("weaver.gp.util.TransUtil.getProgramLink");
									xTableColumn_name.setPara_1("column:id");
									xTableColumn_name.setPara_2("column:programname");
									xTableColumn_name.setSortable(true);
									xTableColumn_name.setHideable(false);
									xTableColumn_name.setWidth(0.01); 
									xTableColumnList.add(xTableColumn_name);
									
									TableColumn xTableColumn_programtype=new TableColumn();
									xTableColumn_programtype.setColumn("programtype");
									xTableColumn_programtype.setDataIndex("programtype");
									xTableColumn_programtype.setHeader("方案类型");
									xTableColumn_programtype.setTransmethod("weaver.gp.util.TransUtil.getType1");
									xTableColumn_programtype.setPara_1("column:programtype");
									xTableColumn_programtype.setSortable(true);
									xTableColumn_programtype.setHideable(true);
									xTableColumn_programtype.setWidth(0.004); 
									xTableColumnList.add(xTableColumn_programtype);
									
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
									
									TableColumn xTableColumn_user=new TableColumn();
									xTableColumn_user.setColumn("userid");
									xTableColumn_user.setDataIndex("userid");
									xTableColumn_user.setHeader("人员");
									xTableColumn_user.setTransmethod("weaver.gp.util.TransUtil.getPerson");
									xTableColumn_user.setPara_1("column:userid");
									xTableColumn_user.setSortable(true);
									xTableColumn_user.setHideable(true);
									xTableColumn_user.setWidth(0.004); 
									xTableColumnList.add(xTableColumn_user);
									
									TableColumn xTableColumn_startdate=new TableColumn();
									xTableColumn_startdate.setColumn("startdate");
									xTableColumn_startdate.setDataIndex("startdate");
									xTableColumn_startdate.setHeader("生效日期");
									xTableColumn_startdate.setSortable(true);
									xTableColumn_startdate.setHideable(true);
									xTableColumn_startdate.setWidth(0.006); 
									xTableColumnList.add(xTableColumn_startdate);
									
									TableColumn xTableColumn_operate=new TableColumn();
									xTableColumn_operate.setColumn("operate");
									xTableColumn_operate.setDataIndex("operate");
									xTableColumn_operate.setHeader("");
									xTableColumn_operate.setTransmethod("weaver.gp.util.TransUtil.getProgramAuditOperate");
									xTableColumn_operate.setPara_1("column:id");
									xTableColumn_operate.setSortable(true);
									xTableColumn_operate.setHideable(true);
									xTableColumn_operate.setWidth(0.004); 
									xTableColumnList.add(xTableColumn_operate);
									
									TableSql xTableSql=new TableSql();
									xTableSql.setBackfields(backfields);
									xTableSql.setPageSize(20);
									xTableSql.setSqlform(fromSql);
									xTableSql.setSqlwhere(sqlWhere);
									xTableSql.setSqlprimarykey("t1.id");
									xTableSql.setSqlisdistinct("true");
									xTableSql.setSort(orderby);
									xTableSql.setDir(TableConst.DESC);
					
									Table xTable=new Table(request); 
																	
									xTable.setTableNeedRowNumber(true);
									xTable.setTableSql(xTableSql);
									xTable.setTableGridType("checkbox");
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
				try{
					if(parent != null && parent.pageTop!=null){
						parent.document.location = "ProgramMain.jsp?type=2&<%=TimeUtil.getOnlyCurrentTimeString()%>";
					}
				}catch(e){alertStyle(e);}
				
			}
			function doApprove(programids) {
			    confirmStyle("确定批准此考核方案?",function(){
			      $.ajax({
						type: "post",
						url: "/performance/program/ProgramOperation.jsp",
					    data:{"operation":"quick_approve","programids":programids}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					    	onRefresh();
					    }
				    });
			    });
			}
			function doReturn(programids) {
			    confirmStyle("确定退回此考核方案?",function(){
			      $.ajax({
						type: "post",
						url: "/performance/program/ProgramOperation.jsp",
					    data:{"operation":"quick_return","programids":programids}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					    	onRefresh();
					    }
				    });
			    });
			}
			function doApproveAll() {
			    confirmStyle("确定批准满足当前查询条件的全部考核方案?",function(){
			      $("#body").showLoading();
			      var programname = $("input[name='programname']").val();
			      var programtype = $("select[name='programtype']").val();
			      var hrmIds = $("#hrmIds").val();
			      var subcompanyids = $("#subcompanyids").val();
			      var departmentids = $("#departmentids").val();
			      $.ajax({
						type: "post",
						url: "/performance/program/ProgramOperation.jsp",
					    data:{"operation":"all_approve","programname":programname,"programtype":programtype,"hrmIds":hrmIds,"subcompanyids":subcompanyids,"departmentids":departmentids}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					        var txt = $.trim(data.responseText);
					        $('#body').hideLoading();
					        if(txt==0){
					           alertStyle("当前查询条件不存在可以批准的考核方案!");
					        }
					        onRefresh();
					    }
				    });
			    });
			}
			function doReturnAll() {
			    confirmStyle("确定退回满足当前查询条件的全部考核方案?",function(){
			      $("#body").showLoading();
			      var programname = $("input[name='programname']").val();
			      var programtype = $("select[name='programtype']").val();
			      var hrmIds = $("#hrmIds").val();
			      var subcompanyids = $("#subcompanyids").val();
			      var departmentids = $("#departmentids").val();
			      $.ajax({
						type: "post",
						url: "/performance/program/ProgramOperation.jsp",
					    data:{"operation":"all_return","programname":programname,"programtype":programtype,"hrmIds":hrmIds,"subcompanyids":subcompanyids,"departmentids":departmentids}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					    	var txt = $.trim(data.responseText);
					        $('#body').hideLoading();
					        if(txt==0){
					           alertStyle("当前查询条件不存在可以退回的考核方案!");
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
