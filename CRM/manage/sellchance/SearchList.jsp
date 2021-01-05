
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.docs.docs.DocComInfo" %>
<%@ page import="weaver.workflow.request.RequestComInfo" %>
<%@ page import="weaver.crm.Maint.CustomerInfoComInfo" %>
<%@ page import="weaver.proj.Maint.ProjectTaskApprovalDetail" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.cs.util.CommonTransUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_c" class="weaver.conn.RecordSet" scope="page" />
	<%
		String sqlWhere = " where 1=1 ";

		String init = Util.fromScreen3(request.getParameter("init"), user.getLanguage());
		int frozencols = Util.getIntValue(request.getParameter("frozencols"), 3);
		
		String subject = Util.fromScreen3(request.getParameter("subject"), user.getLanguage());
		String subcompanyId = Util.fromScreen3(request.getParameter("subcompanyId"), user.getLanguage());
		String includeSubCompany = Util.fromScreen3(request.getParameter("includeSubCompany"), user.getLanguage());
		if(!subcompanyId.equals("")&&!subcompanyId.equals("0")){//客户经理分部ID
			 if(includeSubCompany.equals("2")){
				String subCompanyIds = "";
				ArrayList list = new ArrayList();
				SubCompanyComInfo.getSubCompanyLists(subcompanyId,list);
				for(int i=0;i<list.size();i++){
					subCompanyIds += ","+(String)list.get(i);
				}
				if(list.size()>0)subCompanyIds = subCompanyIds.substring(1);
				subCompanyIds = "("+subCompanyIds+")";
				
				sqlWhere+=" and t.subCompanyId in "+subCompanyIds;
			}else if(includeSubCompany.equals("1")){
				sqlWhere+=" and t.subCompanyId="+subcompanyId;
			}else{
				String subCompanyIds = subcompanyId;
				ArrayList list = new ArrayList();
				SubCompanyComInfo.getSubCompanyLists(subcompanyId,list);
				for(int i=0;i<list.size();i++){
					subCompanyIds += ","+(String)list.get(i);
				}
				subCompanyIds = "("+subCompanyIds+")";

				sqlWhere+=" and t.subCompanyId in "+subCompanyIds;
			}
		}
		String departmentId = Util.fromScreen3(request.getParameter("deptId"), user.getLanguage());
		String includeSubDepartment = Util.fromScreen3(request.getParameter("includeSubDepartment"), user.getLanguage());
		if(!departmentId.equals("")){//客户经理部门ID
			if(includeSubDepartment.equals("2")){
				String departmentIds = "";
				ArrayList list = new ArrayList();
				SubCompanyComInfo.getSubDepartmentLists(departmentId,list);
				for(int i=0;i<list.size();i++){
					departmentIds += ","+(String)list.get(i);
				}
				if(list.size()>0)departmentIds = departmentIds.substring(1);
				departmentIds = "("+departmentIds+")";

				sqlWhere+=" and t.departmentId in "+departmentIds;
			}else if(includeSubDepartment.equals("1")){
				sqlWhere+=" and t.departmentId="+departmentId;
			}else{
				String departmentIds = departmentId;
				ArrayList list = new ArrayList();
				SubCompanyComInfo.getSubDepartmentLists(departmentId,list);
				for(int i=0;i<list.size();i++){
					departmentIds += ","+(String)list.get(i);
				}
				departmentIds = "("+departmentIds+")";

				sqlWhere+=" and t.departmentId in "+departmentIds;	
			}
		}
		String creater = Util.fromScreen3(request.getParameter("creater"), user.getLanguage());
		String customerid = Util.fromScreen3(request.getParameter("customerid"), user.getLanguage());
		String createDateFrom = Util.fromScreen3(request.getParameter("createDateFrom"), user.getLanguage());
		String createDateTo = Util.fromScreen3(request.getParameter("createDateTo"), user.getLanguage());
		String selltype = Util.fromScreen3(request.getParameter("selltype"), user.getLanguage());
		String sellstatusid = Util.fromScreen3(request.getParameter("sellstatusid"), user.getLanguage());
		String endtatusid = Util.fromScreen3(request.getParameter("endtatusid"), user.getLanguage());
		String sellDateFrom = Util.fromScreen3(request.getParameter("sellDateFrom"), user.getLanguage());
		String sellDateTo = Util.fromScreen3(request.getParameter("sellDateTo"), user.getLanguage());
		String preyield=Util.null2String(request.getParameter("preyield"));
		String preyield_1=Util.null2String(request.getParameter("preyield_1"));
		String attention=Util.null2String(request.getParameter("attention"));
		if (init.equals("")) {
			if(endtatusid.equals("")) endtatusid = "0";
		}

		//找到用户能看到的所有客户
		String condition = cmutil.getCustomerStr(user);
		
		if(!"".equals(subject)){
			sqlWhere += " and t.subject like '%"+subject+"%'";
		}
		if(!"".equals(creater)){
			sqlWhere += " and t.creater in ("+creater+")";
		}
		if(!"".equals(customerid)){
			sqlWhere += " and t.customerid ="+customerid;
		}
		if(!"".equals(createDateFrom)){
			sqlWhere += " and t.createdate >='"+createDateFrom+"'";
		}
		if(!"".equals(createDateTo)){
			sqlWhere += " and t.createdate <='"+createDateTo+"'";
		}
		if(!"".equals(selltype)){
			sqlWhere += " and t.selltype ="+selltype;
		}
		if(!"".equals(sellstatusid)){
			sqlWhere += " and t.sellstatusid ="+sellstatusid;
		}
		if(!"".equals(endtatusid)){
			sqlWhere += " and t.endtatusid ="+endtatusid;
		}
		if(!"".equals(sellDateFrom)){
			sqlWhere += " and t.predate >='"+sellDateFrom+"'";
		}
		if(!"".equals(sellDateTo)){
			sqlWhere += " and t.predate <='"+sellDateTo+"'";
		}
		if(!"".equals(preyield)){
			sqlWhere += " and t.preyield >="+preyield;
		}
		if(!"".equals(preyield_1)){
			sqlWhere += " and t.preyield <="+preyield_1;
		}
		if("1".equals(attention)){
			sqlWhere += " and exists (select 1 from CRM_SellChance_Attention t2 where t.id=t2.sellchanceId and t2.userId="+user.getUID()+")";
		}
		if("0".equals(attention)){
			sqlWhere += " and not exists (select 1 from CRM_SellChance_Attention t2 where t.id=t2.sellchanceId and t2.userId="+user.getUID()+")";
		}
	%>
<HTML>
	<HEAD>
		<title>商机跟进管理</title>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/secondary/FrozenTable_wev8.js"></script>
		<STYLE type=text/css>
			#DataTable{border: 1px #DAEFEF solid;}
			.frozencol{border-right: 1px #B00058 solid;}
			.thead{border-bottom:1px #ddd solid;background-color: #CAE8EA;cursor: pointer;border-right: 1px #EEEEEE solid;}
			.tdata{border-bottom:1px #F8FCFC solid;border-right: 1px #F7FBFF solid;background-color: #FFFFFF;}
			.tdata1{border-bottom:1px #F8FCFC solid;border-right: 1px #ffffff solid;background-color: #F7FBFF;}
			.thead div,.tdata div,.tdata1 div{padding-left: 3px;}
			.scroll1{  
				overflow-y: auto;
				overflow-x: hidden;
				SCROLLBAR-DARKSHADOW-COLOR: #ffffff;
			  	SCROLLBAR-ARROW-COLOR: #CAE8EA;
			  	SCROLLBAR-3DLIGHT-COLOR: #CAE8EA;
			  	SCROLLBAR-SHADOW-COLOR: #CAE8EA ;
			  	SCROLLBAR-HIGHLIGHT-COLOR: #F4FAFF;
			  	SCROLLBAR-FACE-COLOR: #F0F9FF;}
			 .cdata{height:100%;}
		</STYLE>
		<script type="text/javascript">
			// 栏位标题 ( 栏位名称 # 栏位宽度 # 资料对齐 )
			var DataTitles=new Array(
				"关注#40 #left"  ,
				"客户/主题#250 #left"  ,
				"客户经理  #75#left"  ,
				"销售类型  #75#left"  ,
				"销售状态  #75#left"  ,
				"归档状态  #75#left"  ,
				"创建时间  #75#left"  ,
				"销售预期  #75 #left",
				"预期收益  #75 #left",
				"可能性  #75 #left");
			<%
				String datestr = "";
				int week = 0;
				for(int i=0;i<11;i++){
					if(i==0)
						datestr = "今天 "+TimeUtil.getCurrentDateString();
					else if(i==1)
						datestr = "昨天 "+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-1);
					else
						datestr = TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),i*(-1));
					
					week =  TimeUtil.dateWeekday(TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),i*(-1)));
					switch(week){
						case 0: datestr += " 星期日";
						break;
						case 1: datestr += " 星期一";
						break;
						case 2: datestr += " 星期二";
						break;
						case 3: datestr += " 星期三";
						break;
						case 4: datestr += " 星期四";
						break;
						case 5: datestr += " 星期五";
						break;
						case 6: datestr += " 星期六";
						break;
					}
					datestr += " #300 #center";
			%>
				DataTitles[<%=i+10%>] = "<%=datestr%>";
			<%
				}
			%>
			var DataFields=new Array()
			<%
				double summoney = 0;
				int pagenum = Util.getIntValue(request.getParameter("pagenum"), 1);
				int pagesize = 10;
				rs.executeSql("Select count(*) RecordSetCounts from CRM_SellChance t join "+condition+" on t.customerid = customerIds.id and (customerIds.deleted=0 or customerIds.deleted is null) "+sqlWhere);
				boolean hasNextPage = false;
				int totalsize = 0;
				if (rs.next()) {
					totalsize = rs.getInt(1);
				}
				if (totalsize > pagenum * pagesize) {
					hasNextPage = true;
				}
				int totalpage = totalsize / pagesize;
				if(totalsize - totalpage * pagesize > 0) totalpage = totalpage + 1;
			
				int temp=0;
				String sellType = "";
				String endtatus = "";
				String createdate = "";
				String attstr = "";
				String sql = "select top "+(totalsize-(pagenum-1)*pagesize)+" t.id,t.customerid,t.creater,t.subject,t.comefromid,t.sellstatusid,t.endtatusid,t.predate,t.preyield,t.currencyid,t.probability,t.createdate,t.createtime,t.content,t.approver,"
					+ "t.approvedate,t.approvetime,t.approvestatus,t.sufactor,t.defactor,t.departmentId,t.subCompanyId,t.selltype,sa.id as att "
					+ "from CRM_SellChance t join "+condition+" on t.customerid = customerIds.id and (customerIds.deleted=0 or customerIds.deleted is null) left join CRM_SellChance_Attention sa on t.id=sa.sellchanceId and sa.userId="+user.getUID()
					+ sqlWhere + " order by t.createdate asc,t.createtime asc";
				//System.out.println(sql);
				rs.executeSql(sql);
				int totalline = 1;
				if (rs.last()) {
					do{
						summoney += Util.getDoubleValue(rs.getString("preyield"));
						sellType = Util.null2String(rs.getString("sellType"));
						if(sellType.equals("1")){
							sellType = "新签";
						}else if(sellType.equals("2")){
							sellType = "二次";
						}else{
							sellType = "";
						}
						endtatus = Util.null2String(rs.getString("endtatusid"));
						if(endtatus.equals("0")){
							endtatus = "进行中";
						}else if(endtatus.equals("1")){
							endtatus = "成功";
						}else{
							endtatus = "失败";
						}
						createdate = rs.getString("createdate")+" "+rs.getString("createtime");
						attstr = Util.null2String(rs.getString("att"));
						if(attstr.equals("")){
							attstr = "<img src='/image_secondary/common/unselect_wev8.png' style='cursor:pointer' onclick=doAttention('"+rs.getString("id")+"',this,"+temp+") _settype='1' title='添加关注'/>";
						}else{
							attstr = "<img src='/image_secondary/common/select_wev8.png' style='cursor:pointer' onclick=doAttention('"+rs.getString("id")+"',this,"+temp+") _settype='0' title='取消关注'/>";
						}
			%>
				var recordArray	= new Array(
						"<%=attstr%>",
						"<%=getCrmName(rs.getString("customerid"))%><br><a href='###' onclick=openFullWindowHaveBar('/CRM/sellchance/ViewSellChance.jsp?id=<%=rs.getString("id")%>&CustomerID=<%=rs.getString("customerid")%>') target='_self'><%=Util.null2String(rs.getString("subject"))%></a>",
						"<%=getHrmname(rs.getString("creater"))%>",
						"<%=sellType%>","<%=SellstatusComInfo.getSellStatusname(Util.null2String(rs.getString("sellstatusid")))%>","<%=endtatus%>","<%=createdate%>",
						"<%=Util.null2String(rs.getString("predate"))%>",
						"<%=Util.null2String(rs.getString("preyield"))%>",
						"<%=Util.null2String(rs.getString("probability"))%>");
			<%
				List contactList = new ArrayList();
				String contactsql = " SELECT DISTINCT a.id,a.begindate,a.begintime,a.resourceid,convert(varchar(2000),a.description) as description,a.name,a.status,a.createrid,a.createrType,a.taskid,a.crmid,a.requestid,a.docid FROM WorkPlan a,  WorkPlanShareDetail b WHERE a.id = b.workid" 
					+ " AND (',' + a.crmid + ',') LIKE '%," + rs.getString("customerid") + ",%'" 
					+ " AND b.usertype = 1 AND a.createrType=1 AND b.userid = " + user.getUID()
					+ " AND a.type_n = '3' AND a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-10)+"' AND a.begindate<='TimeUtil.getCurrentDateString()'"
					+ " ORDER BY a.begindate DESC, a.begintime ASC";
				rs_c.executeSql(contactsql);
				while(rs_c.next()){
					String[] cdata = {Util.null2String(rs_c.getString("begindate")),Util.null2String(rs_c.getString("begintime"))
							,Util.null2String(rs_c.getString("createrid")),Util.null2String(rs_c.getString("description"))
							,Util.null2String(rs_c.getString("taskid")),Util.null2String(rs_c.getString("crmid"))
							,Util.null2String(rs_c.getString("requestid")),Util.null2String(rs_c.getString("docid"))};
					contactList.add(cdata);
				}
				String contactstr = "";
				for(int i=0;i<11;i++){
					contactstr = "";
					for(int j=0;j<contactList.size();j++){
						String[] _data = (String[])contactList.get(j);
						if(TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),i*(-1)).equals(_data[0])){
							contactstr += "<div style='width:100%;border-bottom:1px #EAEAEA dashed;padding:0px;margin-bottom:4px;'><div style='width:100%;text-align:left;background-color:#FAFAFA;padding:0px;'>"+getHrmname(_data[2])+" "+_data[0]+" "+_data[1]+"</div>"
									+"<div style='width:100%;text-align:left;padding:0px;'>"+Util.toScreen(_data[3],user.getLanguage())+"</div>";
							if(!_data[4].equals("") && !_data[4].equals("0")) contactstr += "<div style='width:100%;text-align:left;padding:0px;'>相关项目："+getProjectName(_data[4])+"</div>";
							if(!_data[5].equals("") && !_data[5].equals("0")) contactstr += "<div style='width:100%;text-align:left;padding:0px;'>相关客户："+getCrmName(_data[5])+"</div>";
							if(!_data[6].equals("") && !_data[6].equals("0")) contactstr += "<div style='width:100%;text-align:left;padding:0px;'>相关流程："+getRequestName(_data[6])+"</div>";
							if(!_data[7].equals("") && !_data[7].equals("0")) contactstr += "<div style='width:100%;text-align:left;padding:0px;'>相关文档："+getDocName(_data[7])+"</div>";
							contactstr += "</div>";
						}
						if(TimeUtil.dateInterval(TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),i*(-1)),_data[0])>0){
							break;
						}
					}
					if(contactstr.equals("")) contactstr = "<div style='width:100%;text-align:left;color:#C6C6C6;padding:0px;'>无相关联系记录!</div>";
					contactstr += "<div style='width:100%;text-align:right;padding:0px;'><a href=javascript:openFullWindowForXtable('AddContactLog.jsp?customerId="+rs.getString("customerid")+"')>添加</a>&nbsp;&nbsp;</div>";
			%>
					recordArray[<%=i+10%>] = "<%=contactstr%>";
			<%
				}
			%>

				DataFields[<%=temp%>] = recordArray;
			<%			
						temp++;
						if (hasNextPage) {
							totalline += 1;
							if (totalline > pagesize)
								break;
						}
					} while (rs.previous());
				}
				if(totalsize==0){
			%>
				DataFields[0] = new Array("","暂无数据！","","","","","","","","","","","","","","","","","","","");
			<%
					
				}
			%>
		</script>
	</head>
	
	<BODY  style="overflow: hidden">
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:onSearch();,_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form id="frmMain" name="frmMain" action="SearchList.jsp" method="post">
		<input type="hidden" name="init" value="0" />
		<input type="hidden" id="pagenum" name="pagenum" value="<%=pagenum%>" />
		<input type="hidden" id="frozencols" name="frozencols" value="<%=frozencols%>" />
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" valign="top">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
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
								<table id="searchTable" style="width: 100%" cellpadding="0" cellspacing="0" border="0">
									<tr id="searchTr">
										<td valign="top">
											<TABLE class=ViewForm>
												<COLGROUP>
													<COL width="11%">
													<COL width="22%">
													<COL width="11%">
													<COL width="22%">
													<COL width="12%">
													<COL width="22%">
												</COLGROUP>
												<TBODY>
													<TR>
														<TD><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%><!-- 主题 -->
														</TD>
														<TD class="Field">
															<INPUT class=inputstyle type=text name="subject" value="<%=subject%>" style="width:95%" maxlength="50"/>
														</TD>
														
														<TD><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%><!-- 分部 -->
														</TD>
														<TD class="Field">
															<div style="float: left;">
																<input class="wuiBrowser" type="hidden" id="subcompanyId" name="subcompanyId" value="<%=subcompanyId%>"
																	_displayText="<%=SubCompanyComInfo.getSubCompanyname(subcompanyId) %>"
																	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" />
															</div>
															<div style="float: right;">
																<select class=InputStyle name="includeSubCompany">
																	<option value="3" <%if(includeSubCompany.equals("3")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18921,user.getLanguage())%></option>
																	<option value="1" <%if(includeSubCompany.equals("1")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
																  	<option value="2" <%if(includeSubCompany.equals("2")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18920,user.getLanguage())%></option>
																</select>
															</div>
														</TD>
														
														<TD><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%><!-- 部门 -->
														</TD>
														<TD class="Field">
															<div style="float: left;">
																<INPUT class="wuiBrowser" type="hidden" id="deptId" name="deptId" value="<%=departmentId %>"
									          	 					_displayText="<%=DepartmentComInfo.getDepartmentname(departmentId) %>"
									          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" />
								          	 				</div>
								          	 				<div style="float: right;">
								          	 					<select class=InputStyle name="includeSubDepartment">
								          	 						<option value="3" <%if(includeSubDepartment.equals("3")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18918,user.getLanguage())%></option>
															  		<option value="1" <%if(includeSubDepartment.equals("1")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
															  		<option value="2" <%if(includeSubDepartment.equals("2")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18917,user.getLanguage())%></option>
															  	</select>
															 </div>
														</TD>
													</TR>
													<tr style="height: 1px;">
														<td class=Line colspan=6></td>
													</tr>
													<TR>
														<TD><%=SystemEnv.getHtmlLabelName(1278, user.getLanguage())%></TD><!-- 客户经理 -->
														<TD class=Field>
															<INPUT class="wuiBrowser" type="hidden" id="creater" name="creater" value="<%=creater %>"
																_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
								          	 					_displayText="<%=getHrmname(creater) %>" _param="resourceids" 
								          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
														</TD>
														<TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD><!-- 客户 -->
			    										<TD class=Field>
			    											<INPUT class=wuiBrowser type=hidden name="customerid" value="<%=customerid%>"
			    												_displayText="<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=customerid%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customerid),user.getLanguage())%></a>" 
			    												_displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" 
			    												_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" />
			    										</TD>
			    										<TD><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></TD><!-- 创建日期 -->
			    										<TD class=Field>
			    											<BUTTON type="button" class=Calendar onclick="gettheDate(createDateFrom,createDateFromSpan)"></BUTTON>
															<SPAN id="createDateFromSpan"><%=createDateFrom%></SPAN>
															<input class=inputstyle type="hidden" name="createDateFrom" value="<%=createDateFrom%>" />
															－&nbsp;
															<BUTTON type="button" class=Calendar onclick="gettheDate(createDateTo,createDateToSpan)"></BUTTON>
															<SPAN id="createDateToSpan"><%=createDateTo%></SPAN>
															<input class=inputstyle type="hidden" name="createDateTo" value="<%=createDateTo%>" />
			    										</TD>
													</TR>
													<tr style="height: 1px;">
														<td class=Line colspan=6></td>
													</tr>
													<TR>
														<TD>销售类型</TD>
														<TD class=Field>
															<select class=InputStyle id="selltype" name="selltype">
																<option value=""></option>
																<option value="1" <%if("1".equals(selltype)){%> selected="selected" <%}%>>新签</option>
																<option value="2" <%if("2".equals(selltype)){%> selected="selected" <%}%>>二次</option>
															</select>
														</TD>
														<TD><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%> </TD>
													    <TD class=Field>
													    	<select class="InputStyle" id="sellstatusid" name="sellstatusid">
													    		<option value=""></option>
													    <%  
													    	SellstatusComInfo.setTofirstRow();
															while(SellstatusComInfo.next()){
													    %>
													    	<option value="<%=SellstatusComInfo.getSellStatusid()%>" <%if(SellstatusComInfo.getSellStatusid().equals(sellstatusid)){%>selected<%}%> ><%=SellstatusComInfo.getSellStatusname()%></option>
													    <%  } %>
													    	</select>
													    </TD>
														<TD><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></TD>
													    <TD class=Field>
													    	<select class="InputStyle" id="endtatusid" name="endtatusid">
															    <option value=""></option>
															    <option value="0" <%if(endtatusid.equals("0")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%></option>
															    <option value="1" <%if(endtatusid.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%></option>
															    <option value="2" <%if(endtatusid.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%></option>
													    	</select>
													    </TD>
													</TR>
													<tr style="height: 1px;">
														<td class=Line colspan=6></td>
													</tr>
													<TR>
														<TD><%=SystemEnv.getHtmlLabelName(2247,user.getLanguage())%></TD><!-- 销售预期 -->
			    										<TD class=Field>
			    											<BUTTON type="button" class=Calendar onclick="gettheDate(sellDateFrom,sellDateFromSpan)"></BUTTON>
															<SPAN id="sellDateFromSpan"><%=sellDateFrom%></SPAN>
															<input class=inputstyle type="hidden" name="sellDateFrom" value="<%=sellDateFrom%>" />
															－&nbsp;
															<BUTTON type="button" class=Calendar onclick="gettheDate(sellDateTo,sellDateToSpan)"></BUTTON>
															<SPAN id="sellDateToSpan"><%=sellDateTo%></SPAN>
															<input class=inputstyle type="hidden" name="sellDateTo" value="<%=sellDateTo%>" />
			    										</TD>
														<TD><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%>  </TD>
													    <TD class=Field>
													    	<INPUT type="text" class=InputStyle maxLength=20 size=6 id="preyield" name="preyield" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' value="<%=preyield%>">
													     -- <INPUT type="text" class=InputStyle maxLength=20 size=6 id="preyield_1" name="preyield_1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()' value="<%=preyield_1%>">
													    </TD>
														<TD>是否关注</TD>
												        <TD class=field>
												        	<select class="InputStyle" id="attention" name="attention">
															    <option value=""></option>
															    <option value="1" <%if(attention.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
															    <option value="0" <%if(attention.equals("0")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
													    	</select>
												        </TD>
													</TR>
													<tr style="height: 1px;">
														<td class=Line colspan=6></td>
													</tr>
													
												</TBODY>
											</TABLE>
										</td>
									</tr>
									<tr>
										<td align="right" valign="middle" style="height: 25px;">
											<a href="###" onclick="controlSearch(this)" _status="1" title="收缩">收缩>></a>
										</td>
									</tr>								
								</table>
								
								<TABLE cellSpacing=0 cellPadding=0 border=0>
  									<TBODY>
  										<TR>
    										<TD style="">
      											<DIV id="DataTable"></DIV> 
      										</TD>
      									</TR>
      								</TBODY>
      							</TABLE>
      										<table style="width: 100%" cellSpacing=0 cellPadding=0 border=0>
												<TR>
													<td width="200px" align="left">
														预期收益合计：<%=summoney %>
													</td>
													<TD align=right>
														<TABLE>
															<TR>
																<TD>
																&raquo; 共<%=totalsize%>条记录&nbsp;&nbsp;&nbsp;每页<%=pagesize%>条&nbsp;&nbsp;&nbsp;共<%=totalpage%>页&nbsp;&nbsp;
																<%if(pagenum > 1){%>
																	<A style="cursor:hand;TEXT-DECORATION:none;" onClick="toFirstPage()" ><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%></A>
																	<A style="cursor:hand;TEXT-DECORATION:none;" onClick="toPrePage('<%=pagenum%>')"><%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></A>
																<%} else {%>
																	<%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%>
																<%}%>
																<%if(pagenum < totalpage){%>
																	<A style="cursor:hand;TEXT-DECORATION:none;" onClick="toNextPage('<%=pagenum%>')"><%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></A>
																	<A style="cursor:hand;TEXT-DECORATION:none;" onClick="toLastPage('<%=totalpage%>')"><%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%></A>
																<%} else {%>
																	<%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%>
																<%}%>
																&nbsp;第<input id='topagenum' name='topagenum' type="text" value="<%=pagenum%>" size="2" class="text" style="text-align:right"/>页
																&nbsp;<span onClick="toGoPage()" style="width:38px;line-height:21px;background:url('/wui/theme/ecologyBasic/skins/default/table/jump_wev8.png') no-repeat;text-align: center;cursor: pointer;">跳转</span>
																</TD>
															</TR>
														</TABLE>
													</TD>
												</TR>
												<TR><TD class=Line ></TD></TR>
											</table>
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
		</table>
		</form>
		<iframe id="searchexport" style="display:none"></iframe>
		<script type="text/javascript">
			$(document).ready(function(){
				setHeight();
			});
			var resizeTimer = null;  
			//$(window).resize(function(){
				//setHeight();
				//if(resizeTimer) clearTimeout(resizeTimer);  
				//resizeTimer = setTimeout("setHeight()",100);  
				//FrozenResize($(window).width()-40,$(window).height()-$("#searchTable").height()-100,22,<%=frozencols%>);
				
			//});
			function setHeight(){
				FrozenInit($(window).width()-40,$(window).height()-$("#searchTable").height()-100,22,<%=frozencols%>);
			}
			//搜索
			function onSearch(){
				jQuery("#frmMain").submit();   
			}
			document.onkeydown=keyListener;
			function keyListener(e){
			    e = e ? e : event;   
			    if(e.keyCode == 13){    
			    	onSearch();
			    }    
			}
			//设置关注
			function doAttention(sellchanceId,obj,index){
				var settype = jQuery(obj).attr("_settype");
				var att = jQuery("#attention").val();
				var url = "SearchAttention.jsp?sellchanceId="+sellchanceId+"&settype="+settype;
				jQuery.post(url,function(data){
					//alert("设置完成");
					if(att==""){
						if(settype==1){
							//jQuery(obj).attr("src","/image_secondary/common/select_wev8.png");
							//jQuery(obj).attr("_settype",0);
							jQuery(jQuery(obj).parent()[0]).html("<img src='/image_secondary/common/select_wev8.png' style='cursor:pointer' onclick=doAttention('"+sellchanceId+"',this,"+index+") _settype='0' title='取消关注'/>");
							DataFields[index][0] = "<img src='/image_secondary/common/select_wev8.png' style='cursor:pointer' onclick=doAttention('"+sellchanceId+"',this,"+index+") _settype='0' title='取消关注'/>";
						}else{
							//jQuery(obj).attr("src","/image_secondary/common/unselect_wev8.png");
							//jQuery(obj).attr("_settype",1);
							jQuery(jQuery(obj).parent()[0]).html("<img src='/image_secondary/common/unselect_wev8.png' style='cursor:pointer' onclick=doAttention('"+sellchanceId+"',this,"+index+") _settype='1' title='添加关注'/>");
							DataFields[index][0] = "<img src='/image_secondary/common/unselect_wev8.png' style='cursor:pointer' onclick=doAttention('"+sellchanceId+"',this,"+index+") _settype='1' title='添加关注'/>";
						}
					}else{
						onSearch();	
					}
				});
			}
			function onRefresh(){
				
			}
			function comparenumber() {
			    if ((document.frmmain.preyield.value != "") && (document.frmmain.preyield_1.value != "")) {
					lownumber = eval(toFloat(document.all("preyield").value,0));
					highnumber = eval(toFloat(document.all("preyield_1").value,0));		

					if (lownumber > highnumber) {
						alert("<%=SystemEnv.getHtmlLabelName(15243,user.getLanguage())%>！");			
					}		
				}	
			}
			function toFloat(str , def) {
				if(isNaN(parseFloat(str))) return def ;
				else return str ;
			}
			
			function toFirstPage(){
				jQuery("#pagenum").val(1);   
				jQuery("#frmMain").submit();   
			}

			function toPrePage(currentpage){
				if(currentpage == 1) {
					return;
				}
				jQuery("#pagenum").val(Number(currentpage) - 1);   
				jQuery("#frmMain").submit();   
			}
			function toNextPage(currentpage){
				if(currentpage == <%=totalpage%>) {
					return;
				}
				jQuery("#pagenum").val(Number(currentpage) + 1);   
				jQuery("#frmMain").submit();
			}
			function toLastPage(lastpage){
				jQuery("#pagenum").val(lastpage);   
				jQuery("#frmMain").submit();
			}
			function toGoPage(){
				var topage = jQuery("#topagenum").val();
				if(topage == <%=pagenum%>) return;
				if(topage > <%=totalpage%>) 
				{
					jQuery("#topagenum").val(<%=pagenum%>);
					return;
				}
				jQuery("#pagenum").val(topage);   
				jQuery("#frmMain").submit();
			}
			function controlSearch(obj){
				var _status = jQuery(obj).attr("_status");
				if(_status==1){
					jQuery("#searchTr").hide();
					jQuery(obj).attr("_status",0);
					jQuery(obj).attr("title","展开");
					jQuery(obj).html("展开>>");
				}else{
					jQuery("#searchTr").show();
					jQuery(obj).attr("_status",1);
					jQuery(obj).attr("title","收缩");
					jQuery(obj).html("收缩>>");
				}
				setHeight();
			}
		</script>
	</BODY>
</HTML>
<%!
	public String getHrmname(String ids) {
		String names = "";
		try{
			ResourceComInfo rc = new ResourceComInfo();
			if(ids != null && !"".equals(ids)){
				List idList = Util.TokenizerString(ids, ",");
				for (int i = 0; i < idList.size(); i++) {
					names += "<a href='javaScript:openhrm("+ idList.get(i)+ ");' onclick='pointerXY(event);'>"+ rc.getResourcename((String)idList.get(i)) + "</a> ";
				}
			}	
		}catch(Exception e){
				
		}
		return names;
	}
	public String getDocName(String ids) {
		String docNames = "";
		try{
			DocComInfo doc = new DocComInfo();
			if(ids != null && !"".equals(ids)){
				List idList = Util.TokenizerString(ids, ",");
				for (int i = 0; i < idList.size(); i++) {
					docNames += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=" + idList.get(i)+"') >"+ doc.getDocname((String)idList.get(i))+"</a> ";
				}
			}
		}catch(Exception e){
				
		}
		return docNames;
	}	
	public String getRequestName(String ids) {
		String requestNames = "";
		try{
			RequestComInfo request = new RequestComInfo();
			if(ids != null && !"".equals(ids.trim())){
				List idList = Util.TokenizerString(ids, ",");
				for (int i = 0; i < idList.size(); i++) {
					requestNames += "<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid=" + idList.get(i)+"') >"+ request.getRequestname((String)idList.get(i))+"</a> ";
				}
			}
		}catch(Exception e){
				
		}
		return requestNames;
	}
	public String getCrmName(String ids) {
		String crmNames = "";
		try{
			CustomerInfoComInfo ci = new CustomerInfoComInfo();
			if(ids != null && !"".equals(ids)){
				List idList = Util.TokenizerString(ids, ",");
				for (int i = 0; i < idList.size(); i++) {
					crmNames += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID=" + (String)idList.get(i)+"')>"+ ci.getCustomerInfoname((String)idList.get(i))+"</a> ";
				}
			}
		}catch(Exception e){
				
		}
		return crmNames;
	}
	public String getProjectName(String ids) {
		String projectNames = "";
		try{
			ProjectTaskApprovalDetail ptad = new ProjectTaskApprovalDetail();
			if(ids != null && !"".equals(ids)){
				List idList = Util.TokenizerString(ids, ",");
				for (int i = 0; i < idList.size(); i++) {
					projectNames += "<a href=javaScript:openFullWindowHaveBar('/proj/process/ViewTask.jsp?taskrecordid=" + (String)idList.get(i)+"')>"+ ptad.getTaskSuject((String)idList.get(i))+"</a> ";
				}
			}
		}catch(Exception e){
				
		}
		return projectNames;
	}
%>