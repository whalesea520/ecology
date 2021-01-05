
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ include file="/systeminfo/init_wev8.jsp"%>

<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(18121,
			user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>

<html>
<head>
	<link rel=stylesheet type=text/css href=/css/Weaver_wev8.css />
</head>
<body>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>

	<table width=100% height=100% border="0" cellspacing="0"
		cellpadding="0">
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
				<table class=Shadow>
					<tr>
						<td valign="top">
							<table class=ViewForm>
								<colgroup>
									<col width="30px"><col>
								</colgroup>
								<tbody>
									<tr class=Title>
										<th colspan=2 style="padding-left: 10px;"><%=SystemEnv.getHtmlLabelName(19010, user.getLanguage())%></th>
									</tr>
									<tr class=Spacing>
										<td class=Line1 colSpan=2></td>
									</tr>
									<tr>
										<td>1、<%=SystemEnv.getHtmlLabelName(19091, user.getLanguage())%></td>
									</tr>
									<tr>
										<td>2、<%=SystemEnv.getHtmlLabelName(19092, user.getLanguage())%></td>
									</tr>
									<tr>
										<td>3、<%=SystemEnv.getHtmlLabelName(19093, user.getLanguage())%></td>
									</tr>
								</tbody>
							</table>
						</td>
					</tr>
				</table>
			</td>
			<td></td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
	</table>
</body>
</html>
