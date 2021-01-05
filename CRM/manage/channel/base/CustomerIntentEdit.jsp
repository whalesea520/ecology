<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CustomerIntentComInfo" class="weaver.crm.channel.CustomerIntentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</HEAD>
	<%
		int id = Util.getIntValue(request.getParameter("id"), 0);
		String name = CustomerIntentComInfo.getName("" + id);
		String desc = CustomerIntentComInfo.getDesc("" + id);;

		int msgid = Util.getIntValue(request.getParameter("msgid"), -1);

		String imagefilename = "/images/hdSystem_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(136, user.getLanguage())+SystemEnv.getHtmlLabelName(26795, user.getLanguage())+ ":" + name;
		String needfav = "1";
		String needhelp = "";
		boolean canEdit = false;
	%>
	<BODY>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
				if (HrmUserVarify.checkUserRight("CustomerChannelBaseMaint:Edit",user)) {
					canEdit = true;
					RCMenu += "{"+ SystemEnv.getHtmlLabelName(86, user.getLanguage())+ ",javascript:onSave(),_self} ";
					RCMenuHeight += RCMenuHeightStep;
				}
				if (HrmUserVarify.checkUserRight("CustomerChannelBaseMaint:Add",user)) {
					RCMenu += "{"+ SystemEnv.getHtmlLabelName(82, user.getLanguage())+ ",CustomerIntentAdd.jsp,_self} ";
					RCMenuHeight += RCMenuHeightStep;
				}
				if (HrmUserVarify.checkUserRight("CustomerChannelBaseMaint:Delete",user)) {
					RCMenu += "{"+ SystemEnv.getHtmlLabelName(91, user.getLanguage())+ ",javascript:onDelete(),_self} ";
					RCMenuHeight += RCMenuHeightStep;
				}
				if (HrmUserVarify.checkUserRight("CustomerChannelBaseMaint:Log",user)) {
					if (rs.getDBType().equals("db2")) {
						RCMenu += "{"+ SystemEnv.getHtmlLabelName(83, user.getLanguage())
								+ ",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="
								+ 149 + " and relatedid=" + id + ",_self} ";
					} else {
						RCMenu += "{"+ SystemEnv.getHtmlLabelName(83, user.getLanguage())
								+ ",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="
								+ 149 + " and relatedid=" + id + ",_self} ";
					}
					RCMenuHeight += RCMenuHeightStep;
				}
				RCMenu += "{"+ SystemEnv.getHtmlLabelName(1290, user.getLanguage())+ ",CustomerIntentList.jsp,_self} ";
				RCMenuHeight += RCMenuHeightStep;
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
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
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
									<%
										if (msgid != -1) {
									%>
									<DIV>
										<FONT color="red" size="2"> <%=SystemEnv.getErrorMsgName(msgid, user.getLanguage())%></FONT>
									</DIV>
									<%
										}
									%>	
									<FORM id=weaver name=frmMain action="CustomerIntentOperation.jsp" method=post>
										<input class=inputstyle type=hidden name=operation>
										<input class=inputstyle type=hidden name=id value="<%=id%>">
										<TABLE class=viewform>
											<COLGROUP>
												<COL width="20%">
												<COL width="80%">
											</COLGROUP>
												<TBODY>
													<TR class=title>
														<TH colSpan=2><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())+SystemEnv.getHtmlLabelName(26795, user.getLanguage())%></TH>
													</TR>
													<TR class=spacing>
														<TD class=line1 colSpan=2></TD>
													</TR>
													<TR>
														<TD><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></TD>
														<TD class=Field>
															<%
																if (canEdit) {
															%>
															<input class=inputstyle size=30 maxlength="30" name="name" value="<%=name%>"
																onchange='checkinput("name","nameimage")'>
															<SPAN id=nameimage></SPAN>
															<%
																} else {
															%><%=name%>
															<%
																}
															%>
														</TD>
													</TR>
													<TR>
														<TD class=Line colSpan=2></TD>
													</TR>
													<TR>
														<TD><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></TD>
														<TD class=Field>
															<%
																if (canEdit) {
															%><input class=inputstyle size=60 maxlength="60" name="description"
																value="<%=desc%>" onchange='checkinput("description","descriptionimage")'>
															  <SPAN id=descriptionimage></SPAN>
															<%
																} else {
															%><%=desc%>
															<%
																}
															%>
														</TD>
													</TR>
													<TR>
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
					<tr>
						<td height="10" colspan="3"></td>
					</tr>	
			</table>
<script>
 function onSave(){
	if(check_form(document.frmMain,'name,description')){
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7, user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 </script>
	</BODY>
</HTML>