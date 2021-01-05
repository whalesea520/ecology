
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetP" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LanguageComInfo"
	class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="ContacterTitleComInfo"
	class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet"
	scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CheckUserRight"
	class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo"
	scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
	String ContacterID = Util.null2String(request.getParameter("ContacterID"));
	if(!user.getLogintype().equals("2")){
		response.sendRedirect("/CRM/manage/contacter/ContacterView.jsp?ContacterID="+ContacterID);
		return;
	}
	String log = Util.null2String(request.getParameter("log"));
	String frombase =  Util.null2String(request.getParameter("frombase"));
	RecordSet.executeProc("CRM_CustomerContacter_SByID", ContacterID);
	if (RecordSet.getCounts() <= 0) {
		response.sendRedirect("/base/error/DBError.jsp?type=FindData");
		return;
	}
	RecordSet.first();
	String CustomerID = RecordSet.getString(2);
	String contacterimageid = Util.null2String(RecordSet.getString("contacterimageid"));

	RecordSetC.executeProc("CRM_CustomerInfo_SelectByID", CustomerID);
	if (RecordSetC.getCounts() <= 0) {
		response.sendRedirect("/base/error/DBError.jsp");
		return;
	}
	RecordSetC.first();

	boolean hasFF = true;
	RecordSetFF.executeProc("Base_FreeField_Select", "c2");
	if (RecordSetFF.getCounts() <= 0)
		hasFF = false;
	else
		RecordSetFF.first();

	/*check right begin*/

	String useridcheck = "" + user.getUID();
	String customerDepartment = "" + RecordSetC.getString("department");

	boolean canview = false;
	boolean canedit = false;
	boolean canviewlog = false;
	boolean canmailmerge = false;
	boolean canapprove = false;
	boolean isCustomerSelf = false;

	//String ViewSql = "select * from CrmShareDetail where crmid="
	//		+ CustomerID + " and usertype=1 and userid="
	//		+ user.getUID();

	//RecordSetV.executeSql(ViewSql);

	//if (RecordSetV.next()) {
	//	canview = true;
	//	canviewlog = true;
	//	canmailmerge = true;
	//	if (RecordSetV.getString("sharelevel").equals("2")) {
	//		canedit = true;
	//	} else if (RecordSetV.getString("sharelevel").equals("3")
	//	|| RecordSetV.getString("sharelevel").equals("4")) {
	//		canedit = true;
	//		canapprove = true;
	//	}
	//}
	
int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
     canview=true;
     canviewlog=true;
     canmailmerge=true;
     if(sharelevel==2) canedit=true;
     if(sharelevel==3||sharelevel==4){
         canedit=true;
         canapprove=true;
     }
}	

	if (user.getLogintype().equals("2")
			&& CustomerID.equals(useridcheck)) {
		isCustomerSelf = true;
	}

	if (useridcheck.equals(RecordSetC.getString("agent"))) {
		canview = true;
		canedit = true;
		canviewlog = true;
		canmailmerge = true;
	}

	if (RecordSetC.getInt("status") == 7
			|| RecordSetC.getInt("status") == 8) {
		canedit = false;
	}

	/*check right end*/

	if (!canview && !isCustomerSelf) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<HTML>
	<HEAD>
		<base target="_blank" />
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";

		String titlename = SystemEnv.getHtmlLabelName(82, user
				.getLanguage())
				+ SystemEnv.getHtmlLabelName(572, user.getLanguage())
				+ " - "
				+ SystemEnv.getHtmlLabelName(136, user.getLanguage())
				+ ":<a href='/CRM/data/ViewCustomer.jsp?log="
				+ log
				+ "&CustomerID="
				+ RecordSetC.getString("id")
				+ "'>"
				+ Util.toScreen(RecordSetC.getString("name"), user
				.getLanguage()) + "</a>";

		String needfav = "1";
		String needhelp = "";
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<div id="divBase">
			<TABLE class=ViewForm>
				<COLGROUP>
					<COL width="59%">
					<COL width="1%">
					<COL width="40%">
				</COLGROUP>
				<TR>
					<TD vAlign=top align=left>
						<DIV style="display:none">
							<%
							if (canedit || isCustomerSelf) {
							%>
							<%
									RCMenu += "{"
									+ SystemEnv.getHtmlLabelName(93, user.getLanguage())
									+ ",javascript:doEdit(),_top} ";
									RCMenuHeight += RCMenuHeightStep;
							%>
							<BUTTON class=BtnEdit id=myfun1 accessKey=E name=button1
								onclick='doEdit()'>
								<U>E</U>
								<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>
							</BUTTON>
							<%
							}
							%>
						</DIV>
						<TABLE class=ViewForm>
							<COLGROUP>
								<COL width="30%">
								<COL width="70%">
							</COLGROUP>
							<TBODY>
								<TR class=Title>
									<TH colSpan=2>
										<%=SystemEnv.getHtmlLabelName(61, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87, user.getLanguage())%>
									</TH>
								</TR>
								<TR class=Spacing  style="height: 1px">
									<TD class=Line1 colSpan=2></TD>
								</TR>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(462, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=Util.toScreen(
							ContacterTitleComInfo
									.getContacterTitlename(RecordSet
											.getString("title")), user
									.getLanguage())%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(413, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=Util.toScreen(RecordSet.getString("firstname"), user
							.getLanguage())%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(475, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=Util.toScreen(RecordSet.getString("lastname"), user
							.getLanguage())%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(640, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=Util.toScreen(RecordSet.getString("jobtitle"), user
							.getLanguage())%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<!-- 增加联系人项目角色、意向判断、关注点字段开始 QC16057-->
						        <TR>
						          <TD>项目角色</TD>
						          <TD class=Field>
						          	<%=Util.toScreen(RecordSet.getString("projectrole"), user.getLanguage())%>
						          </TD>
						        </TR>
						        <tr style="height: 1px"><td class=Line colspan=2></td></tr>
						        <TR>
						          <TD>意向判断</TD>
						          <TD class=Field>
						          	<%=Util.toScreen(RecordSet.getString("attitude"), user.getLanguage())%>
						          </TD>
						        </TR>
						        <tr style="height: 1px"><td class=Line colspan=2></td></tr>
						        <TR>
						          <TD>关注点</TD>
						          <TD class=Field>
						          	<%=Util.toScreen(RecordSet.getString("attention"), user.getLanguage())%>
						          </TD>
						        </TR>
						        <tr style="height: 1px"><td class=Line colspan=2></td></tr>
						        <!-- 增加联系人项目角色、意向判断、关注点字段结束 -->
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(477, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<a href="mailto:<%=RecordSet.getString("email")%>"><%=Util.toScreen(RecordSet.getString("email"), user
							.getLanguage())%> </a>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(420, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("phoneoffice")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(619, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("phonehome")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(620, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("mobilephone")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(494, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("fax")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>

								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(6066, user
									.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("interest")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(6067, user
									.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("hobby")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(596, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("managerstr")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(442, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(460, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("subordinate")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(6068, user
									.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("strongsuit")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<%--<TR>--%>
								<%--  <TD><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></TD>--%>
								<%--  <TD class=Field><%=RecordSet.getString("age")%></TD>--%>
								<%--</TR><tr><td class=Line colspan=2></td></tr>--%>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(1884, user
									.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("birthday")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(17534, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=SystemEnv.getHtmlLabelName(17548, user.getLanguage())%>
										&nbsp;
										<%=RecordSet.getString("birthdaynotifydays")%>
										&nbsp;
										<%=SystemEnv.getHtmlLabelName(1925, user
									.getLanguage())%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(1967, user
									.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("home")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(1518, user
									.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("school")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(803, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("speciality")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(1840, user
									.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("nativeplace")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(1887, user
									.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("IDCard")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(812, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=RecordSet.getString("experience")%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>


								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(231, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<%=Util.toScreen(LanguageComInfo.getLanguagename(RecordSet
							.getString("language")), user.getLanguage())%>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<%
								if (!user.getLogintype().equals("2")) {
								%>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144, user.getLanguage())%>
									</TD>
									<TD class=Field>
										<a
											href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>"><%=Util.toScreen(
								ResourceComInfo.getResourcename(RecordSet
										.getString("manager")), user
										.getLanguage())%> </a>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<%
								} else {
								%>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144, user.getLanguage())%>
									</TD>
									<TD class=Field></TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								<%
								}
								%>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(1262, user
									.getLanguage())%>
									</TD>
									<TD class=Field>
										<INPUT type=checkbox name="Main" value="1"
											<%if(RecordSet.getString("main").equals("1")){%> checked
											<%}%> disabled>
									</TD>
								</TR>
								<tr  style="height: 1px">
									<td class=Line colspan=2></td>
								</tr>
								
								<!-- dky -->
								<TR>
								 <TD><%=SystemEnv.getHtmlLabelName(25101,user.getLanguage())%><!-- IM号码--></TD>
						          <TD class=Field><%=RecordSet.getString("imcode")%></TD>
						        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
						        
						        <TR>
								 <TD><%=SystemEnv.getHtmlLabelName(25102,user.getLanguage())%><!-- 状态 --></TD>
						          <TD class=Field>
						          		<%if(RecordSet.getInt("status")==1){%><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%><!-- 有效 --><%} %>
						          		<%if(RecordSet.getInt("status")==0){%><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%><!-- 离职 --><%} %>
						          		<%if(RecordSet.getInt("status")==2){%><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%><!-- 未知 --><%} %>
						          </TD>
						        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
						        
						        <TR>
								 <TD><%=SystemEnv.getHtmlLabelName(25103,user.getLanguage())%><!-- 是否需要联系 --></TD>
						          <TD class=Field>
						          		<%if(RecordSet.getInt("isneedcontact")==1){%><%=SystemEnv.getHtmlLabelName(25104,user.getLanguage())%><!-- 是 --><%} %>
						          		<%if(RecordSet.getInt("isneedcontact")==0){%><%=SystemEnv.getHtmlLabelName(25105,user.getLanguage())%><!-- 否 --><%} %>
						          </TD>
						        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
						        
						        <% 
									//取得负责人
									String principalIds = "";
									String principalNames = "";
									RecordSetP.executeSql("select principalId from CS_ContacterPrincipal where contacterId = "+ ContacterID);
									while(RecordSetP.next()){
										principalIds += ","+RecordSetP.getInt("principalId");
										principalNames += ",<a href='/hrm/resource/HrmResource.jsp?id="+RecordSetP.getInt("principalId")+"' target='_blank'>"+ResourceComInfo.getLastname(""+RecordSetP.getInt("principalId"))+"</a>";
									}
									if(!principalIds.equals("")){
										principalIds = principalIds.substring(1);
									}
									if(!principalNames.equals("")){
										principalNames = principalNames.substring(1);
									}
								%>
						        <TR>
						          <TD><%=SystemEnv.getHtmlLabelName(24976,user.getLanguage())%><!-- 客服负责人 --></TD>
						          <TD class=Field> 
						             <%=principalNames %>
						          </TD>
						        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
						        
							</TBODY>
						</TABLE>
					</TD>
					<TD>
						&nbsp;
					</TD>
					<TD vAlign=top align=left>
						<TABLE class="viewform">
							<TBODY>
								<TR align='left' class=Title>
									<TH>
										<%=SystemEnv.getHtmlLabelName(15707, user.getLanguage())%>
									</TH>
								</TR>
								<TR class=Spacing  style="height: 1px">
									<TD class=Line1></TD>
								</TR>
								<TR border=0>
									<TD width="100%" id=imagetd>
									    <%
											if (!"".equals(contacterimageid) && !"0".equals(contacterimageid)) {
										%>
										<img border=0 id=resourceimage width="450"  src="/weaver/weaver.file.FileDownload?fileid=<%=contacterimageid%>">
									    <%
										    }
										%>
									</TD>
								</TR>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TABLE>

			<TABLE class=ViewForm>
				<COLGROUP>
					<COL width="20%">
					<COL width="80%">
				</COLGROUP>
				<TBODY>
					<TR class=Title>
						<TH colSpan=2>
							<%=SystemEnv.getHtmlLabelName(570, user.getLanguage())%>
						</TH>
					</TR>
					<TR class=Spacing  style="height: 1px">
						<TD class=Line1 colSpan=2></TD>
					</TR>
					<%
							if (hasFF) {
							for (int i = 1; i <= 5; i++) {
								if (RecordSetFF.getString(i * 2 + 1).equals("1")) {
					%>
					<TR>
						<TD>
							<%=RecordSetFF.getString(i * 2)%>
						</TD>
						<TD class=Field>
							<%=RecordSet.getString("datefield" + i)%>
						</TD>
					</TR>
					<TR class=Spacing  style="height: 1px">
						<td class=Line colspan=2></td>
					</tr>
					<%
							}
							}
							for (int i = 1; i <= 5; i++) {
								if (RecordSetFF.getString(i * 2 + 11).equals("1")) {
					%>
					<TR>
						<TD>
							<%=RecordSetFF.getString(i * 2 + 10)%>
						</TD>
						<TD class=Field>
							<%=RecordSet.getString("numberfield" + i)%>
						</TD>
					</TR>
					<TR class=Spacing  style="height: 1px">
						<td class=Line colspan=2></td>
					</tr>
					<%
							}
							}
							for (int i = 1; i <= 5; i++) {
								if (RecordSetFF.getString(i * 2 + 21).equals("1")) {
					%>
					<TR>
						<TD>
							<%=RecordSetFF.getString(i * 2 + 20)%>
						</TD>
						<TD class=Field>
							<%=Util.toScreen(RecordSet.getString("textfield"
										+ i), user.getLanguage())%>
						</TD>
					</TR>
					<TR class=Spacing  style="height: 1px">
						<td class=Line colspan=2></td>
					</tr>
					<%
							}
							}
							for (int i = 1; i <= 5; i++) {
								if (RecordSetFF.getString(i * 2 + 31).equals("1")) {
					%>
					<TR>
						<TD>
							<%=RecordSetFF.getString(i * 2 + 30)%>
						</TD>
						<TD class=Field>
							<INPUT type=checkbox value=1
								<%if(RecordSet.getString("tinyintfield"+i).equals("1")){%>
								checked <%}%> disabled>
						</TD>
					</TR>
					<TR class=Spacing  style="height: 1px">
						<td class=Line colspan=2></td>
					</tr>
					<%
							}
							}
						}
					%>
				</TBODY>
			</TABLE>

			<TABLE class=ViewForm>
				<COLGROUP>
					<COL width="20%">
					<COL width="80%">
				</COLGROUP>
				<TBODY>
					<TR class=Title>
						<TH colSpan=4>
							<%=SystemEnv.getHtmlLabelName(454, user.getLanguage())%>
						</TH>
					</TR>
					<TR class=Spacing  style="height: 1px">
						<TD class=Line1 colSpan=2></TD>
					</TR>
					<TR>
						<TD>
							<%=SystemEnv.getHtmlLabelName(454, user.getLanguage())%>
						</TD>
						<TD class=Field>
							<%
								String remarktmp = Util.null2String(RecordSet.getString("remark"));
								remarktmp = remarktmp.replaceAll("[\r\n]","<br/>");
							%>
							<%=remarktmp%>
						</TD>
					</TR>
					<TR class=Spacing  style="height: 1px">
						<td class=Line colspan=2></td>
					</tr>
					<TR>
						<TD>
							<%=SystemEnv.getHtmlLabelName(454, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58, user.getLanguage())%>
						</TD>
						<TD class=Field>
							<a
								href='/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("remarkDoc")%>'><%=DocComInfo.getDocname(RecordSet.getString("remarkDoc"))%>
							</a>
						</TD>
					</TR>
					<TR class=Spacing  style="height: 1px">
						<td class=Line colspan=2></td>
					</tr>
				</TBODY>
			</TABLE>
		</div>
		</td>
		<td></td>
		</tr>
		</table>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<script type="text/javascript">
		function doEdit(){
			document.location.href="/CRM/data/EditContacter.jsp?log=<%=log%>&ContacterID=<%=ContacterID%>&frombase=<%=frombase%>";
		}
		</script>
	</BODY>
</HTML>

