
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerIntentComInfo" class="weaver.crm.channel.CustomerIntentComInfo" scope="page"/>
<jsp:useBean id="CustomerBizTypeComInfo" class="weaver.crm.channel.CustomerBizTypeComInfo" scope="page"/>
<jsp:useBean id="CustomerDeputizeBrandComInfo" class="weaver.crm.channel.CustomerDeputizeBrandComInfo" scope="page"/>
<jsp:useBean id="CustomerProjectPhaseComInfo" class="weaver.crm.channel.CustomerProjectPhaseComInfo" scope="page"/>
<jsp:useBean id="CommonTransUtil" class="weaver.crm.channel.CommonTransUtil" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String CustomerID = Util.null2String(request.getParameter("CustomerID"));

	RecordSet.executeSql("select t1.status,t2.intentId,t2.bizTypeId,t2.expectMoney,t2.deputizeBrandId,t2.deputizeBrandOther,t2.projectDemand,t2.projectBudget,t2.projectPhaseId,t2.exploiterId,t2.keyContact "
			+" from CRM_CustomerInfo t1 left join CRM_CustomerChannelInfo t2 on t1.id=t2.customerId where t1.id="+CustomerID);
	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/base/error/DBError.jsp?type=FindData");
		return;
	}
	RecordSet.first();
	
	String intentId = Util.null2String(RecordSet.getString("intentId"));
	String intentName = CustomerIntentComInfo.getName(intentId);
	String bizTypeId = Util.null2String(RecordSet.getString("bizTypeId"));
	String bizTypeName = CustomerBizTypeComInfo.getName(bizTypeId);
	String expectMoney = Util.null2String(RecordSet.getString("expectMoney"));
	String deputizeBrandId = Util.null2String(RecordSet.getString("deputizeBrandId"));
	String deputizeBrandName = CustomerDeputizeBrandComInfo.getName(deputizeBrandId);
	String deputizeBrandOther = Util.null2String(RecordSet.getString("deputizeBrandOther"));
	String projectDemand = Util.convertDB2Input(RecordSet.getString("projectDemand"));
	String projectBudget = Util.null2String(RecordSet.getString("projectBudget"));
	String projectPhaseId = Util.null2String(RecordSet.getString("projectPhaseId"));
	String projectPhaseName = CustomerProjectPhaseComInfo.getName(projectPhaseId);
	String exploiterId = Util.null2String(RecordSet.getString("exploiterId"));
	String exploiterName = CommonTransUtil.getPerson(exploiterId);
	String keyContact = CommonTransUtil.getYN(RecordSet.getString("keyContact"),user.getLanguage()+"");
	
	
	/*权限判断－－Begin*/
	
	String useridcheck=""+user.getUID();
	boolean canedit=false;
	
	int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
	if(sharelevel>1) canedit=true;
	
	//开拓人员本人可编辑【开拓人员】字段
	if(exploiterId.equals(useridcheck)){
		canedit=true;
	}
	
	if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
		canedit=false;
	}
	
	/*权限判断－－End*/
	
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdSystem_wev8.gif";
		String titlename = "";
		String needfav = "1";
		String needhelp = "";
		
	%>

	<BODY style="overflow:hidden;">
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(canedit) {
				RCMenu += "{" + SystemEnv.getHtmlLabelName(93, user.getLanguage())+ ",CustomerChannelInfoEdit.jsp?CustomerID="+CustomerID+",_self} ";
				RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
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
								<FORM id=frmMain name=frmMain action="CustomerChannelInfoOperation.jsp" method=post>
									<input class=inputstyle type="hidden" name=operation value=edit />
									<input class=inputstyle type="hidden" name=CustomerID value=<%=CustomerID %> />
									<TABLE class=viewform>
										<colgroup>
											<COL width="20%">
											<COL width="80%">
										</colgroup>
										<TBODY>
											<TR class=Title>
												<TH colspan="2"><%=SystemEnv.getHtmlLabelName(26820,user.getLanguage())%></TH>
											</TR>
											<TR class=spacing>
												<TD colspan="2" class=line1></TD>
											</TR>
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(25171, user.getLanguage())%></TD>
													<!-- 开拓人员 -->
												<TD class="Field">
													<%=exploiterName %>
													<INPUT class=inputstyle type=hidden name=exploiterId value="<%=exploiterId %>">
												</TD>
											</TR>
											<TR>
												<TD class=Line colSpan=2></TD>
											</TR>
															
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(26795, user.getLanguage())%></TD>
													<!-- 意向性 -->
												<TD class="Field">
													<%=intentName %>
												</TD>
											</TR>
											<TR style="height: 1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
															
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(26800, user.getLanguage())%></TD>
													<!-- 业务类型 -->
												<TD class="Field">
													<%=bizTypeName %>
												</TD>
											</TR>
											<TR>
												<TD class=Line colSpan=2></TD>
											</TR>
															
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(26796, user.getLanguage())%></TD>
													<!-- 代理品牌 -->
												<TD class="Field">
													<span style="width: 60px">
														<%=deputizeBrandName %>
													</span>
													&nbsp;&nbsp;
													<span><%=deputizeBrandOther %></span>
												</TD>
											</TR>
											<TR style="height: 1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
															
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(26815, user.getLanguage())%></TD>
													<!-- 预计签约金额 -->
												<TD class="Field">
													<%=expectMoney %>
												</TD>
											</TR>
											<TR style="height: 1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
															
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(26816, user.getLanguage())%></TD>
													<!-- 项目需求  -->
												<TD class="Field">
													<%=Util.toHtml(projectDemand) %>
												</TD>
											</TR>
											<TR style="height: 1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
															
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(15274, user.getLanguage())%></TD>
													<!-- 项目预算  -->
												<TD class="Field">
													<%=projectBudget %>
												</TD>
											</TR>
											<TR style="height: 1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
															
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(26797, user.getLanguage())%></TD>
													<!-- 项目阶段  -->
												<TD class="Field">
													<%=projectPhaseName %>
												</TD>
											</TR>
											<TR style="height: 1px;">
												<TD class=Line colSpan=2></TD>
											</TR>	
											
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(26863, user.getLanguage())%>(是否与客户方老板取得联系)</TD>
													<!-- 关键联系  -->
												<TD class="Field">
													<%=keyContact %>
												</TD>
											</TR>
											<TR style="height: 1px;">
												<TD class=Line colSpan=2></TD>
											</TR>			
															
										</TBODY>
									</TABLE>
								</form>
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
		</table>
	</BODY>
</HTML>