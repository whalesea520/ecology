<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<LINK href="/css/Secondary_wev8.css" type=text/css rel=STYLESHEET>
		<style type="text/css">
.alink:link {
	color: #005BB7;
	text-decoration: underline;
}

.alink:visited {
	color: #005BB7;
	text-decoration: underline;
}

.alink:hover {
	color: #FF0000;
	text-decoration: none;
}

.alink:active {
	color: #002C57;
	text-decoration: none;
}
</style>
	</head>
	<BODY>
		<table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="">
			</colgroup>
			<tr></tr>
			<tr>
				<td></td>
				<td valign="top">
					<table class=ViewForm>
						<tr class=Header>
							<td align="left">
								<font color="#002C57"><%=SystemEnv.getHtmlLabelName(25407, user.getLanguage())%>：</font>
							</td>
						</tr>
						<TR class=Spacing>
							<TD class=Line1></TD>
						</TR>
						<tr height="20">
							<td style="">
								<li>
									<a class="alink" href="CustomerIntentList.jsp" target="pageRight"><%=SystemEnv.getHtmlLabelName(26795, user.getLanguage())%></a>
								</li>
							</td>
						</tr>
						<tr height="20">
							<td style="">
								<li>
									<a class="alink" href="CustomerDeputizeBrandList.jsp" target="pageRight"><%=SystemEnv.getHtmlLabelName(26796, user.getLanguage())%></a>
								</li>
							</td>
						</tr>
						<tr height="20">
							<td style="">
								<li>
									<a class="alink" href="CustomerProjectPhaseList.jsp" target="pageRight"><%=SystemEnv.getHtmlLabelName(26797, user.getLanguage())%></a>
								</li>
							</td>
						</tr>
						<tr height="20">
							<td style="">
								<li>
									<a class="alink" href="CustomerBizTypeList.jsp" target="pageRight"><%=SystemEnv.getHtmlLabelName(26800, user.getLanguage())%></a>
								</li>
							</td>
						</tr>
						<tr height="20">
							<td style="">
								<li>
									<a class="alink" href="CustomerChannelMark.jsp" target="pageRight"><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())+SystemEnv.getHtmlLabelName(2095, user.getLanguage())%></a>
								</li>
							</td>
						</tr>
						<TR class=Spacing>
							<TD class=Line1></TD>
						</TR>
					</table>

				</td>
				<td></td>
			</tr>
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
		</table>
	</BODY>
</HTML>