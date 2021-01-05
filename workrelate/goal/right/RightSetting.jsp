<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
	//判断是否有权限
	boolean canedit = false;
	if (HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)){
		canedit = true;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<style type="text/css">
			.mbtn3 {
				border-bottom: medium none;
				text-align: center;
				border-left: medium none;
				width: 61px;
				height: 22px;
				border-top: medium none;
				cursor: hand;
				margin-right: 5px;
				border-right: medium none;
				background-color: #D8EDEF;
				background-image: url("/recruitment/images/btn_search2.png");
			}
			.datatable{width: 100%;}
			.datatable td{line-height: 26px;padding-left: 2px;}
			.datatable th{background: #D1D1D1;line-height: 26px;padding-left: 2px;}
			.datatable td.title{font-weight: bold;}
			tr.Data td{text-align:center;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<%
		String type = Util.fromScreen3(request.getParameter("type"), user
				.getLanguage());
		String orgId = Util.fromScreen3(request.getParameter("orgId"), user
				.getLanguage());

		String titlename = "负责人设置：";

		if (type.equals("1")) {
			titlename += CompanyComInfo.getCompanyname(orgId);
			type = "1";
		} else if (type.equals("2")) {
			titlename += SubCompanyComInfo.getSubCompanyname(orgId);
			type = "2";
		} else if (type.equals("3")) {
			titlename += DepartmentComInfo.getDepartmentname(orgId);
			type = "3";
		} else if (type.equals("4")) {
			titlename += ResourceComInfo.getLastname(orgId);
			type = "4";
		}

		String sql = "select count(*) as amount from GM_RightSetting where orgId="
				+ orgId + " and type=" + type;
		rs.executeSql(sql);
		int amount = 0;
		if (rs.next()) {
			amount = rs.getInt("amount");
		}
		int pageNum = 0;
		if (amount % 2 == 0) {
			pageNum = amount / 2;
		} else {
			pageNum = amount / 2 + 1;
		}

		rs.executeSql("select hrmId from GM_RightSetting where orgId="
				+ orgId + " and type=" + type);
	%>
	<BODY style="overflow: auto">
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
					+ ",javascript:submitData(this),_self} ";
			RCMenuHeight += RCMenuHeightStep;

			RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage())
					+ ",javascript:onDelete(this),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="frmMain" name="frmMain" action="RightOperation.jsp" method="post">
			<input type="hidden" name="orgId" value="<%=orgId%>">
			<input type="hidden" name="type" value="<%=type%>">
			<input type="hidden" id="operation" name="operation" value="">
			<input type="hidden" id=num name=num value="" />
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" valign="top">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				</colgroup>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<div style="width: 100%;line-height: 28px;border-bottom:2px #D6D6D6 solid;font-size: 14px;font-weight: bold;margin-bottom: 10px;">
							<%=titlename %>
						</div>
					
						<%if(canedit){ %>
						<table class="datatable" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<TD class="title" width="20%">
									<%=SystemEnv.getHtmlLabelName(1867, user.getLanguage())%><!-- 人员 -->
								</TD>
								<TD>
									<INPUT class="wuiBrowser" type="hidden" id="hrmIds" name="hrmIds" value=""
										_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
					          	 		_param="resourceids" _required="yes"
					          	 		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
								</TD>
								<TD align="right">
									<BUTTON type="button" class=mbtn3 onClick="submitData(this)"><%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%></BUTTON>
									<BUTTON type="button" class=mbtn3 onClick="onDelete(this)" style="margin-left: 2px;"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></BUTTON>
								</TD>
							</tr>
						</table>
						<%} %>
						<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
							<colgroup>
								<COL width="49%">
								<COL width="1%">
								<COL width="49%">
							</colgroup>
							<tr>
								<td valign="top" width="50%">
									<table id="t1" class="datatable" cellspacing="0">
										<colgroup>
											<COL width="2%">
											<COL width="32%">
											<COL width="33%">
											<COL width="33%">
										</colgroup>
										<tbody>
											<TR class="Header">
												<TH align="left">
													<%if(canedit){ %><input type="checkbox" onclick="selectAll1()"><%} %>
												</TH>
												<TH><%=SystemEnv.getHtmlLabelName(1867, user.getLanguage())%><!-- 人员 -->
												</TH>
												<TH><%=SystemEnv.getHtmlLabelName(1915, user.getLanguage())%><!-- 职务 -->
												</TH>
												<TH>
													<%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%><!-- 部门 -->
												</TH>
											</TR>
											<%
												int num = 1;
												while (rs.next()) {
											%>
											<TR class="Data">
												<TD>
													<%if(canedit){ %><input type='checkbox' id='check_node_<%=num%>' name='check_node_<%=num%>' /><%} %>
												</TD>
												<TD>
													<input type="hidden" name="hrmId_<%=num%>" value="<%=rs.getString("hrmId")%>">
													<%=cmutil.getPerson(rs.getString("hrmId"))%>
												</TD>
												<TD>
													<%=Util.toScreen(JobTitlesComInfo
									.getJobTitlesname(ResourceComInfo.getJobTitle(rs
											.getString("hrmId"))), user.getLanguage())%>
												</TD>
												<TD>
													<a
														href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=ResourceComInfo
									.getDepartmentID(rs.getString("hrmId"))%>"
														target="_blank"> <%=Util.toScreen(DepartmentComInfo
									.getDepartmentname(ResourceComInfo.getDepartmentID(rs
											.getString("hrmId"))), user.getLanguage())%> </a>
												</TD>
											</TR>
											<%
												num++;
													if (num == pageNum + 1) {
														break;
													}
												}
											%>
										</tbody>
									</table>
								</td>
								<td></td>
								<td valign="top" width="50%">
									<table id="t2" class="datatable" cellspacing="0">
										<colgroup>
											<COL width="2%">
											<COL width="32%">
											<COL width="33%">
											<COL width="33%">
										</colgroup>
										<tbody>
											<TR class="Header">
												<TH align="left">
													<%if(canedit){ %><input type="checkbox" onclick="selectAll2()"><%} %>
												</TH>
												<TH><%=SystemEnv.getHtmlLabelName(1867, user.getLanguage())%><!-- 人员 -->
												</TH>
												<TH><%=SystemEnv.getHtmlLabelName(1915, user.getLanguage())%><!-- 职务 -->
												</TH>
												<TH>
													<%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%><!-- 部门 -->
												</TH>
											</TR>
											<%
												while (rs.next()) {
											%>
											<TR class="Data">
												<TD>
													<input type='checkbox' id='check_node_<%=num%>' name='check_node_<%=num%>' />
												</TD>
												<TD>
													<input type="hidden" name="hrmId_<%=num%>" value="<%=rs.getString("hrmId")%>">
													<%=cmutil.getPerson(rs.getString("hrmId"))%>
												</TD>
												<TD>
													<%=Util.toScreen(JobTitlesComInfo
									.getJobTitlesname(ResourceComInfo.getJobTitle(rs
											.getString("hrmId"))), user.getLanguage())%>
												</TD>
												<TD>
													<a
														href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=ResourceComInfo
									.getDepartmentID(rs.getString("hrmId"))%>"
														target="_blank"> <%=Util.toScreen(DepartmentComInfo
									.getDepartmentname(ResourceComInfo.getDepartmentID(rs
											.getString("hrmId"))), user.getLanguage())%> </a>
												</TD>
											</TR>
											<%
												num++;
												}
											%>
										</tbody>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td></td>
				</tr>
			</table>
		</form>
	
		<script type="text/javascript" defer="defer">
			jQuery("#num").val(<%=num%>);
			
			function submitData(obj) {
				if(check_form(frmMain,'hrmIds')){
					jQuery("#operation").val("save");
					obj.disabled = true;
					jQuery("#frmMain").submit();
				}
			}
			function onDelete(obj){
				var b = false;
				var n = <%=num%>;
				for(var i=1;i<n;i++){
					var v = document.getElementById("check_node_"+i).checked;
					if(v==true){
						b = true;
						break;
					}
				}
				if(b){
					if(isdel()){
						jQuery("#operation").val("delete");
						obj.disabled = true;
						jQuery("#frmMain").submit();
					}
				}else{
					alert("<%=SystemEnv.getHtmlLabelName(22686, user.getLanguage())%>"+"!");
				}
			}
			
			var ClickNum1=1;
			var ClickNum2=1;
			function selectAll1() {
				ClickNum1 = ClickNum1 + 1;
			    var table = document.getElementById("t1");  
				//找到控制范围下所有input    
				var objs = table.getElementsByTagName("input");  
				for(var i = 0; i < objs.length; i++){    
					if((objs[i].type.toLowerCase() == "checkbox") && (objs[i].disabled == false)){    
						if(ClickNum1 % 2!=1){    
								objs[i].checked = true; 
						}else{
							objs[i].checked = false; 
						}    
					}   
				}    
			}   
			function selectAll2() {
				ClickNum2 = ClickNum2 + 1;
			    var table = document.getElementById("t2");  
				//找到控制范围下所有input    
				var objs = table.getElementsByTagName("input");  
				for(var i = 0; i < objs.length; i++){    
					if((objs[i].type.toLowerCase() == "checkbox") && (objs[i].disabled == false)){    
						if(ClickNum2 % 2!=1){    
								objs[i].checked = true; 
						}else{
							objs[i].checked = false; 
						}    
					}   
				}    
			}
		</script>
	</BODY>
</HTML>