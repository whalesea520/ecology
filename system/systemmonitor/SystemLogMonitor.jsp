
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.general.IsGovProj"%>
<jsp:useBean id="SystemLogMonitorUtil" class="weaver.system.SystemLogMonitorUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
	</head>

	<%
		int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统
		String imagefilename = "/images/hdDOC_wev8.gif";
		String titlename = "系统监控";
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:OnChangePage(1),_self}";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<div id='divshowreceivied'
			style='background: #FFFFFF; padding: 3px; width: 100%' valign='top'>
		</div>
		<FORM id=weaver name=weaver method=post action="SystemLogMonitor.jsp">
			<%
				String monitortype =  Util.null2String(request.getParameter("monitortype"));
				String fromdate = Util.null2String(request.getParameter("fromdate"));
				String todate = Util.null2String(request.getParameter("todate"));
				String monitorbody =  Util.null2String(request.getParameter("monitorbody"));
				String monitorbodyid =  Util.null2String(request.getParameter("monitorbodyid"));
				int perpage = Util.getIntValue(Util.null2String(request.getParameter("perpage")), 10);
				SystemLogMonitorUtil.setMonitortype(monitortype);
				SystemLogMonitorUtil.setFromdate(fromdate);
				SystemLogMonitorUtil.setTodate(todate);
				SystemLogMonitorUtil.setMonitorbody(monitorbody);
				SystemLogMonitorUtil.setMonitorbodyid(monitorbodyid);
				SystemLogMonitorUtil.setPerpage(perpage);
				SystemLogMonitorUtil.setUser(user);
			%>

			<table width=100% height=100% border="0" cellspacing="0"
				cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
									<table class=ViewForm>
										<colgroup>
											<col width="10%">
											<col width="20%">
											<col width="5">
											<col width="10%">
											<col width="20%">
											<col width="3%">
											<col width="6%">
											<col width="15">
										<tbody>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(2239, user.getLanguage())//监控类型 %></td>
												<td class=field>
													<select size=1 class=InputStyle name=monitortype style="width: 150" onchange="changeMonitorType(this);">
														<option value="">
															&nbsp;
														</option>
														<option value="1" <% if(monitortype.equals("1")) {%> selected
															<%}%>>非授权访问文档</option>
														<option value="2" <% if(monitortype.equals("2")) {%> selected
															<%}%>>非授权访问客户</option>
														<option value="3" <% if(monitortype.equals("3")) {%> selected
															<%}%>>异常登陆系统</option>
														<option value="4" <% if(monitortype.equals("4")) {%> selected
															<%}%>>未使用动态密码</option>
													</select>
												</td>

												<td>
													&nbsp;
												</td>
												<td><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%></td>
												<td class=field>
													<BUTTON class=calendar id=SelectDate
														onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>
													<SPAN id=fromdatespan><%=fromdate%></SPAN> -&nbsp;&nbsp;
													<BUTTON class=calendar id=SelectDate2
														onclick="gettheDate(todate,todatespan)"></BUTTON>
													<SPAN id=todatespan><%=todate%></SPAN>
													<input type="hidden" name="fromdate" value="<%=fromdate%>">
													<input type="hidden" name="todate" value="<%=todate%>">
												</td>

												<td>
													&nbsp;
												</td>
												<td><%=SystemEnv.getHtmlLabelName(665, user.getLanguage())+SystemEnv.getHtmlLabelName(106, user.getLanguage())//监控对象 %></td>
												<td class=field colspan=4>
													<select name=monitorbody class=InputStyle onchange="changeMonitorBody();">
														<option value="1" <% if(monitorbody.equals("1")) {%>
															selected <%}%>><%=SystemEnv.getHtmlLabelName(1867, user.getLanguage())//人员 %></option>
														<option value="2" <% if(monitorbody.equals("2")) {%>
															selected <%}%>><%=SystemEnv.getHtmlLabelName(22243, user.getLanguage())//文档 %></option>
														<option value="3" <% if(monitorbody.equals("3")) {%>
															selected <%}%>><%=SystemEnv.getHtmlLabelName(92, user.getLanguage())//目录 %></option>
														<option value="4" <% if(monitorbody.equals("4")) {%>
															selected <%}%>><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())//客户%></option>
													</select>
													&nbsp
													<button class=browser onClick="onShowMonitorBody()"></button>
													<span id=monitorbodyidspan>
													<%
													String monitorbodynames = "";
													ArrayList bodyidList = Util.TokenizerString(monitorbodyid,",");
													for(int i=0;i<bodyidList.size();i++)
													{
														String bodyid = (String)bodyidList.get(i);
														if(monitorbody.equals("1"))
														{
															monitorbodynames += ResourceComInfo.getLastname(bodyid)+",";
														}
														else if(monitorbody.equals("2"))
														{
															monitorbodynames += DocComInfo.getDocname(bodyid)+",";
														}
														else if(monitorbody.equals("3"))
														{
															monitorbodynames += SecCategoryComInfo.getSecCategoryname(bodyid)+",";
														}
														else if(monitorbody.equals("4"))
														{
															monitorbodynames += CustomerInfoComInfo.getCustomerInfoname(bodyid)+",";
														}
													}
													out.print(monitorbodynames);
													%>
													</span>
													<input name=monitorbodyid type=hidden value="<%=monitorbodyid%>">
												</td>
											</tr>
											<TR>
												<TD class=Line colSpan=7></TD>
											</TR>
										</tbody>
									</table>
									<%
										if(!"".equals(monitortype)&&!"4".equals(monitortype))
										{
										String tableString = SystemLogMonitorUtil.getTableString();
									%>

									<TABLE width="100%">
										<tr>
											<td valign="top">
												<wea:SplitPageTag tableString="<%=tableString%>" mode="run" />
											</td>
										</tr>
									</TABLE>
									<br>
									<table align=right>
										<tr>
											<td>
												&nbsp;
											</td>
											<td>
												<%
													RCMenu += "{" + SystemEnv.getHtmlLabelName(18363, user.getLanguage()) + ",javascript:_table.firstPage(),_self}";
													RCMenuHeight += RCMenuHeightStep;
													RCMenu += "{" + SystemEnv.getHtmlLabelName(1258, user.getLanguage()) + ",javascript:_table.prePage(),_self}";
													RCMenuHeight += RCMenuHeightStep;
													RCMenu += "{" + SystemEnv.getHtmlLabelName(1259, user.getLanguage()) + ",javascript:_table.nextPage(),_self}";
													RCMenuHeight += RCMenuHeightStep;
													RCMenu += "{" + SystemEnv.getHtmlLabelName(18362, user.getLanguage()) + ",javascript:_table.lastPage(),_self}";
													RCMenuHeight += RCMenuHeightStep;
												%>
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
									</TABLE>
									<%
									}
									else if("4".equals(monitortype))
									{
										List userlist = SystemLogMonitorUtil.getNoUseDynaPassUsers();
									%>
									<TABLE width="100%">
										<tr>
											<td valign="top">
												<DIV class=table>
													<TABLE class=ListStyle cellSpacing=1>
														<THEAD>
															<TR class=HeaderForXtalbe>
																<TH id=operatedate width="40%">
																	<%=SystemEnv.getHtmlLabelName(21965, user.getLanguage())//员工姓名 %>&nbsp;
																</TH>
																<TH id=operatetime width="60%">
																	<%=SystemEnv.getHtmlLabelName(18939, user.getLanguage())//部门 %>&nbsp;
																</TH>
															</TR>
														</THEAD>
														<TBODY>
															<TR class=Line>
																<TH colSpan=50></TH>
															</TR>
															<%
															for(int i=0;i<userlist.size();i++)
															{
																String uid = (String)userlist.get(i);
																String username = ResourceComInfo.getLastname(uid);
																String departmentname = DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(uid));
																String classname = (i%2==0)?"DataDark":"DataLight";
																
																if(!"".equals(username))
																{
															%>
															<TR style="VERTICAL-ALIGN: middle" class=<%=classname %>>
																<TD align=left>
																	<a href="javascript:this.openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=<%=uid %>')"><%=username %></a>
																</TD>
																<TD align=left>
																	<a href="javascript:this.openFullWindowForXtable('/hrm/company/HrmDepartmentDsp.jsp?id=<%=ResourceComInfo.getDepartmentID(uid) %>')"><%=departmentname %></a>
																</TD>
															</TR>
															<%
																}
															} 
															%>
															<TR class=xTable_line>
																<TH colSpan=50></TH>
															</TR>
														</TBODY>
													</TABLE>
												</DIV>
											</td>
										</tr>
									</TABLE>
									<%
									}
									%>
								</td>
							</tr>
						</TABLE>
					</td>
					<td></td>
				</tr>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
			</table>
		</form>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language=vbs>
sub onShowMonitorBody()
	tmpval = document.all("monitorbody").value
	tmpbodyval = document.all("monitorbodyid").value
	if tmpval = "1" then
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpbodyval)
	elseif tmpval = "2" then
		id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+tmpbodyval)
	elseif tmpval = "3" then
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategoryMBrowser.jsp?selectids="+tmpbodyval)
	elseif tmpval = "4" then
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+tmpbodyval)
	end if
	if NOT isempty(id) then
	        if id(0)<> "" then
				resourceids = id(0)
				resourceids = Mid(resourceids,2,len(resourceids))
				monitorbodyidspan.innerHtml = id(1)
				weaver.monitorbodyid.value=resourceids
			else
				monitorbodyidspan.innerHtml = ""
				weaver.monitorbodyid.value=""
			end if
	end if

end sub
</script>
<SCRIPT language="javascript">
function changeMonitorType(o)
{
	var monitortype = document.weaver.monitortype.value;;
	var monitorbody = document.weaver.monitorbody.value;
	if(monitortype=="1")
	{
		if(monitorbody=="4")
		{
			document.getElementById("monitorbodyidspan").innerHTML = "";
			document.weaver.monitorbodyid.value="";
		}
	}
	else if(monitortype=="2")
	{
		if(monitorbody=="2"||monitorbody=="3")
		{
			document.getElementById("monitorbodyidspan").innerHTML = "";
			document.weaver.monitorbodyid.value="";
		}
	}
	else if(monitortype=="3")
	{
		if(monitorbody!="1")
		{
			document.getElementById("monitorbodyidspan").innerHTML = "";
			document.weaver.monitorbodyid.value="";
		}
	}
	else if(monitortype=="4")
	{
		document.getElementById("monitorbodyidspan").innerHTML = "";
		document.weaver.monitorbodyid.value="";
	}
}
function changeMonitorBody()
{
	document.getElementById("monitorbodyidspan").innerHTML = "";
	document.weaver.monitorbodyid.value="";
}
function OnChangePage()
{
	document.weaver.submit();
}
</script>
	</body>
</html>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>