
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerIntentComInfo" class="weaver.crm.channel.CustomerIntentComInfo" scope="page"/>
<jsp:useBean id="CustomerBizTypeComInfo" class="weaver.crm.channel.CustomerBizTypeComInfo" scope="page"/>
<jsp:useBean id="CustomerDeputizeBrandComInfo" class="weaver.crm.channel.CustomerDeputizeBrandComInfo" scope="page"/>
<jsp:useBean id="CustomerProjectPhaseComInfo" class="weaver.crm.channel.CustomerProjectPhaseComInfo" scope="page"/>
<jsp:useBean id="CommonTransUtil" class="weaver.crm.channel.CommonTransUtil" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
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
	String keyContact = RecordSet.getString("keyContact");
	
	/*权限判断－－Begin*/
	
	String useridcheck=""+user.getUID();
	boolean canedit=false;
	boolean advanceEdit=false;//是否可编辑【开拓人员】字段
	
	int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
	if(sharelevel>1) canedit=true;
	
	//开拓人员为空时可编辑【开拓人员】字段
	if(exploiterId.equals("") || exploiterId.equals("0")){
		advanceEdit = true;
	}
	
	//开拓人员本人可编辑【开拓人员】字段
	if(exploiterId.equals(useridcheck)){
		canedit=true;
		advanceEdit = true;
	}
	//具有渠道客户维护权限可编辑【开拓人员】
	if (HrmUserVarify.checkUserRight("CustomerChannelBaseMaint:Edit", user)) {
		canedit=true;
		advanceEdit = true;
	}
	//如果属于总部级的CRM管理员角色，则能编辑全部。
	String leftjointable = "";
	RecordSet2.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = "+useridcheck);
	if(RecordSet2.next()){
		canedit=true;
		advanceEdit = true;
	}
	
	if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
		canedit=false;
	}
	
	/*权限判断－－End*/
	
	if(!canedit) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	if(exploiterId.equals("") && advanceEdit){
		exploiterId = useridcheck;
		exploiterName = CommonTransUtil.getPerson(exploiterId);
	}
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
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
					+ ",javascript:saveData(this),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())
					+",CustomerChannelInfoView.jsp?CustomerID="+CustomerID+",_self} " ;
			RCMenuHeight += RCMenuHeightStep;
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
											<TR class=spacing style="height: 1px;">
												<TD colspan="2" class=line1></TD>
											</TR>
															<TR>
																<TD><%=SystemEnv.getHtmlLabelName(25171, user.getLanguage())%></TD>
																<!-- 开拓人员 -->
																<TD class="Field">
																<%
																	if (advanceEdit) {
																%>
																	<INPUT class="wuiBrowser" type="hidden" id="exploiterId" name="exploiterId" value="<%=exploiterId %>"
																	_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
					          	 									_displayText="<%=exploiterName %>" _required="yes"
					          	 									_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" />	
																<%
																	}else{
																%>
																		<%=exploiterName %>
																		<INPUT class=inputstyle type=hidden name=exploiterId value="<%=exploiterId %>">
																<%
																	}
																%>
																</TD>
															</TR>
															<TR style="height: 1px;">
																<TD class=Line colSpan=2></TD>
															</TR>
															
															<TR>
																<TD><%=SystemEnv.getHtmlLabelName(26795, user.getLanguage())%></TD>
																<!-- 意向性 -->
																<TD class="Field">
																	<INPUT class="wuiBrowser" type="hidden" id="intentId" name="intentId" value="<%=intentId %>"
					          	 									_displayText="<%=intentName %>" _required="yes"
					          	 									_url="/systeminfo/BrowserMain.jsp?url=/crm/channel/base/CustomerIntentBrowser.jsp" />
																</TD>
															</TR>
															<TR style="height: 1px;">
																<TD class=Line colSpan=2></TD>
															</TR>
															
															<TR>
																<TD><%=SystemEnv.getHtmlLabelName(26800, user.getLanguage())%></TD>
																<!-- 业务类型 -->
																<TD class="Field">
																	<INPUT class="wuiBrowser" type="hidden" id="bizTypeId" name="bizTypeId" value="<%=bizTypeId %>"
					          	 									_displayText="<%=bizTypeName %>" _required="yes"
					          	 									_url="/systeminfo/BrowserMain.jsp?url=/crm/channel/base/CustomerBizTypeBrowser.jsp" />
																</TD>
															</TR>
															<TR style="height: 1px;">
																<TD class=Line colSpan=2></TD>
															</TR>
															
															<TR>
																<TD><%=SystemEnv.getHtmlLabelName(26796, user.getLanguage())%></TD>
																<!-- 代理品牌 -->
																<TD class="Field">
																	<INPUT class="wuiBrowser" type="hidden" id="deputizeBrandId" name="deputizeBrandId" value="<%=deputizeBrandId %>"
					          	 									_displayText="<%=deputizeBrandName %>" _required="yes" _callBack="setOther"
					          	 									_url="/systeminfo/BrowserMain.jsp?url=/crm/channel/base/CustomerDeputizeBrandBrowser.jsp" />
																	&nbsp;&nbsp;
																	<input class=inputstyle <%if(!deputizeBrandName.equals("其他")){%> style="display: none" <%}%> type=text size=20 id="deputizeBrandOther" name="deputizeBrandOther" maxlength="60" value="<%=deputizeBrandOther %>"
																		onchange='checkinput("deputizeBrandOther","deputizeBrandOtherSpan")'/>
																	<span id="deputizeBrandOtherSpan" <%if(!deputizeBrandName.equals("其他")){%> style="display: none" <%}%>>
																		<%if(deputizeBrandOther.equals("")){ %>
																			<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
																		<%}%>
																	</span>
																</TD>
															</TR>
															<TR style="height: 1px;">
																<TD class=Line colSpan=2></TD>
															</TR>
															
															<TR>
																<TD><%=SystemEnv.getHtmlLabelName(26815, user.getLanguage())%></TD>
																<!-- 预计签约金额 -->
																<TD class="Field">
																	<input class=inputstyle type=text size="50" maxlength=10 name='expectMoney' value="<%=expectMoney %>"
																		onKeyPress="ItemNum_KeyPress('expectMoney');" onBlur="checknumber('expectMoney');">
																</TD>
															</TR>
															<TR style="height: 1px;">
																<TD class=Line colSpan=2></TD>
															</TR>
															
															<TR>
																<TD><%=SystemEnv.getHtmlLabelName(26816, user.getLanguage())%></TD>
																<!-- 项目需求  -->
																<TD class="Field">
																	<TEXTAREA class="InputStyle" name="projectDemand" rows="5" cols="65"><%=projectDemand %></TEXTAREA>
																</TD>
															</TR>
															<TR style="height: 1px;">
																<TD class=Line colSpan=2></TD>
															</TR>
															
															<TR>
																<TD><%=SystemEnv.getHtmlLabelName(15274, user.getLanguage())%></TD>
																<!-- 项目预算  -->
																<TD class="Field">
																	<input class=inputstyle type=text size="50" maxlength=10 name='projectBudget' value="<%=projectBudget %>"
																		onKeyPress="ItemNum_KeyPress('projectBudget');" onBlur="checknumber('projectBudget');">
																</TD>
															</TR>
															<TR style="height: 1px;">
																<TD class=Line colSpan=2></TD>
															</TR>
															
															<TR>
																<TD><%=SystemEnv.getHtmlLabelName(26797, user.getLanguage())%></TD>
																<!-- 项目阶段  -->
																<TD class="Field">
																	<INPUT class="wuiBrowser" type="hidden" id="projectPhaseId" name="projectPhaseId" value="<%=projectPhaseId %>"
					          	 									_displayText="<%=projectPhaseName %>"
					          	 									_url="/systeminfo/BrowserMain.jsp?url=/crm/channel/base/CustomerProjectPhaseBrowser.jsp" />
																</TD>
															</TR>
															<TR style="height: 1px;">
																<TD class=Line colSpan=2></TD>
															</TR>
															
															<TR>
																<TD><%=SystemEnv.getHtmlLabelName(26863, user.getLanguage())%>(是否与客户方老板取得联系)</TD>
																	<!-- 关键联系  -->
																<TD class="Field">
																	<input type="checkbox" name="keyContact" <%if("1".equals(keyContact)){%> checked="checked" <%}%>>
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
		<script language=javascript>  
			function saveData(obj) {
				if(check_form(frmMain,'exploiterId,intentId,bizTypeId,deputizeBrandId')){
					if(jQuery("#deputizeBrandIdSpan").html().trim()=="其他"){
						alert(jQuery("#deputizeBrandOther").val());
						if(check_form(frmMain,'deputizeBrandOther')){
							obj.disabled = true;
							jQuery("#frmMain").submit();
						}
					}else{
						obj.disabled = true;
						jQuery("#frmMain").submit();
					}
				}	
			}
			function setOther(data,e){
				if(data.name=="其他"){
					jQuery("#deputizeBrandOther").show();
					jQuery("#deputizeBrandOtherSpan").show();
				}else{
					jQuery("#deputizeBrandOther").hide();
					jQuery("#deputizeBrandOther").val("");
					jQuery("#deputizeBrandOtherSpan").hide();
					jQuery("#deputizeBrandOtherSpan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				}
			}
		</script>
	</BODY>
</HTML>