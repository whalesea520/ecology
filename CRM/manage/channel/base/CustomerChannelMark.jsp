<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</HEAD>
	<%
		String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
		String mark = Util.convertInput2DB(request.getParameter("mark"));

		boolean canEdit = false;
		String msg = "";
		
		//编辑
		if(operation.equals("edit") && HrmUserVarify.checkUserRight("CustomerChannelBaseMaint:Edit",user)){
			rs.executeSql("update CRM_CustomerChannelMark set mark='"+mark+"'");	
			msg = SystemEnv.getHtmlLabelName(18758, user.getLanguage())+"!";
		}
		
		rs.executeSql("select id,mark from CRM_CustomerChannelMark");
		if(rs.next()){
			mark = Util.convertDB2Input(rs.getString("mark"));
		}
		
		//System.out.println("mark:"+mark);
	%>
	<BODY>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
				if (HrmUserVarify.checkUserRight("CustomerChannelBaseMaint:Edit",user)) {
					canEdit = true;
					RCMenu += "{"+ SystemEnv.getHtmlLabelName(86, user.getLanguage())+ ",javascript:frmMain.submit(),_self} ";
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
										if (!msg.equals("")) {
									%>
									<DIV>
										<FONT color="red" size="2"><%=msg%></FONT>
									</DIV>
									<%
										}
									%>	
									<FORM id=weaver name=frmMain action="CustomerChannelMark.jsp" method=post>
										<input class=inputstyle type=hidden name=operation value="edit">
										<TABLE class=viewform>
											<COLGROUP>
												<COL width="20%">
												<COL width="80%">
											</COLGROUP>
												<TBODY>
													<TR class=title>
														<TH colSpan=2><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())+SystemEnv.getHtmlLabelName(2095, user.getLanguage())%></TH>
													</TR>
													<TR class=spacing>
														<TD class=line1 colSpan=2></TD>
													</TR>
													<TR>
														<TD><%=SystemEnv.getHtmlLabelName(2095, user.getLanguage())%></TD>
														<TD class=Field>
															<%
																if (canEdit) {
															%>
																<TEXTAREA class="InputStyle" name="mark" rows="8" cols="90"><%=mark %></TEXTAREA>
															<%
																} else {
															%>
																<%=Util.toHtml(mark)%>
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
	</BODY>
</HTML>