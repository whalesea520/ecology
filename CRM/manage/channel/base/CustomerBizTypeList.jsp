
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	</HEAD>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(136, user.getLanguage())+SystemEnv.getHtmlLabelName(26800, user.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if (HrmUserVarify.checkUserRight("CustomerChannelBaseMaint:Add", user)) {
				RCMenu += "{" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + ",CustomerBizTypeAdd.jsp,_top} ";
				RCMenuHeight += RCMenuHeightStep;
			}
			if (HrmUserVarify.checkUserRight("CustomerChannelBaseMaint:Log", user)) {
				if (RecordSet.getDBType().equals("db2")) {
					RCMenu += "{" + SystemEnv.getHtmlLabelName(83, user.getLanguage()) + ",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=" + 152 + ",_self} ";
				} else {
					RCMenu += "{" + SystemEnv.getHtmlLabelName(83, user.getLanguage()) + ",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=" + 152 + ",_self} ";
				}
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
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">
								<TABLE class=ListStyle cellspacing=1>
									<COLGROUP>
										<COL width="30%">
										<COL width="70%">
									</COLGROUP>
									<TBODY>
										<TR class=Title>
											<TH colSpan=2><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())+SystemEnv.getHtmlLabelName(26800, user.getLanguage())%></TH>
										</TR>
										
										<TR class=Header>
											<th><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></th>
											<th><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></th>
										</tr>
										<TR class=Line>
											<TD colSpan=2></TD>
										</TR>
										<%
											RecordSet.executeSql("select id,name,description from CRM_CustomerBizType");
											boolean isLight = false;
											while (RecordSet.next()) {
												if (isLight = !isLight) {
										%>
										<TR CLASS=DataDark>
										<%
												} else {
										%>
										<TR CLASS=DataLight>
										<%
												}
										%>
											<TD>
												<a href="CustomerBizTypeEdit.jsp?id=<%=RecordSet.getString(1)%>"><%=Util.toScreen(RecordSet.getString(2), user.getLanguage())%></a>
											</TD>
											<TD><%=Util.toScreen(RecordSet.getString(3), user.getLanguage())%></TD>
										</TR>
										<%
											}
										%>
										
								</TABLE>
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
