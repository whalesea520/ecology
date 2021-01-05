
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo"
	class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo"
	scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo"
	scope="page" />
<jsp:useBean id="CustomerInfoComInfo"
	class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo"
	class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="RequestComInfo"
	class="weaver.workflow.request.RequestComInfo" scope="page" />
<%@include file="/systeminfo/init_wev8.jsp"%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17599, user.getLanguage());
String needfav = "1";
String needhelp = "";

char flag = 2;
boolean islight = true;
String userid = user.getUID() + "";
String votingid = Util.fromScreen(request.getParameter("votingid"),7);


RecordSet.executeProc("Voting_SelectByID", votingid);
RecordSet.next();
String subject = RecordSet.getString("subject");
String detail = RecordSet.getString("detail");
String createrid = RecordSet.getString("createrid");
String createdate = RecordSet.getString("createdate");
String createtime = RecordSet.getString("createtime");
String approverid = RecordSet.getString("approverid");
String approvedate = RecordSet.getString("approvedate");
String approvetime = RecordSet.getString("approvetime");
String begindate = RecordSet.getString("begindate");
String begintime = RecordSet.getString("begintime");
String enddate = RecordSet.getString("enddate");
String endtime = RecordSet.getString("endtime");
String isanony = RecordSet.getString("isanony");
String docid = RecordSet.getString("docid");
String crmid = RecordSet.getString("crmid");
String projectid = RecordSet.getString("projid");
String requestid = RecordSet.getString("requestid");
String votingcount = RecordSet.getString("votingcount");
String status = RecordSet.getString("status");
String isSeeResult = RecordSet.getString("isSeeResult");
int tempnum = -1;
if (Util.getIntValue(requestid) > 0) {
	RecordSet.executeSql("select min(requestid) requestid from workflow_currentoperator where userid="+ userid);
	RecordSet.next();
	tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
	tempnum++;
}

String objstr = "";
String questionid = "";
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table class=ViewForm>
	<col width=15%>
	<col width=35%>
	<col width=15%>
	<col width=35%>
	<TR class=Section>
		<TH colSpan=4>
			<div align="left"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></div>
	</TH>
</TR>
<TR class=separator style="height: 1px!important;">
	<TD class=line1 colSpan=4></TD>
</TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>
	<td class=field>
		<%=subject%>
	</td>
	<td><%=SystemEnv.getHtmlLabelName(18576, user.getLanguage())%></td>
	<td class=field>
		<input class="inputStyle" type=checkbox name="isanony"
			<%if(isanony.equals("1")){%> checked <%}%> value="1" disabled>
	</td>
</tr>
<TR style="height: 1px!important;">
	<TD class=Line colSpan=4></TD>
</TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(740, user.getLanguage())%></td>
	<td class=field>
		<%=begindate%>
	</td>
	<td><%=SystemEnv.getHtmlLabelName(742, user.getLanguage())%></td>
	<td class=field>
		<%=begintime%>
	</td>
</tr>
<TR style="height: 1px!important;">
	<TD class=Line colSpan=4></TD>
</TR>
<tr>
	<td>
		<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>
	</td>
	<td class=field>
		<%=enddate%>
	</td>
	<td>
		<%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%>
	</td>
	<td class=field>
		<%=endtime%>
</tr>
<TR style="height: 1px!important;">
	<TD class=Line colSpan=4></TD>
</TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%></td>
	<td class=field>
		<a href="/docs/docs/DocDsp.jsp?id=<%=docid%>" target="_blank"><%=Util.toScreen(DocComInfo.getDocname(docid), user
				.getLanguage())%></a>
	</td>
	<td><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></td>
	<td class=field>
		<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=crmid%>"
			target="_blank"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid), user.getLanguage())%></a>
</tr>
<TR style="height: 1px!important;">
	<TD class=Line colSpan=4></TD>
</TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></td>
	<td class=field>
		<a href="/proj/data/ViewProject.jsp?ProjID=<%=projectid%>"
			target="_blank"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid), user.getLanguage())%></a>
	</td>
	<td><%=SystemEnv.getHtmlLabelName(1044, user.getLanguage())%></td>
	<td class=field>
		<a
			href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>&isrequest=1&wflinkno=<%=tempnum%>"
			target="_blank"><%=Util.toScreen(RequestComInfo.getRequestname(requestid),user.getLanguage())%></a>
</tr>
<TR style="height: 1px!important;">
	<TD class=Line colSpan=4></TD>
</TR>
<tr>
	<td valign=top><%=SystemEnv.getHtmlLabelName(16284, user.getLanguage())%></td>
	<td class=field>
		<%=detail%>
	</td>
	<td>
		<%=SystemEnv.getHtmlLabelName(21723,user.getLanguage())%>
	</td>
	<td class=field>
		<input class="inputStyle" type=checkbox name="isSeeResult"
			<%if("1".equals(isSeeResult)){%> checked <%}%> value="1" disabled>
		</td>
	</tr>
	<TR style="height: 1px!important;">
		<TD class=Line colSpan=4></TD>
	</TR>
</table>

<br>
<form name=frmmain action="VotingPollOperation.jsp" method=post>
	<input type=hidden name=method value="pollsubmit">
	<input type=hidden name=votingid value="<%=votingid%>">
<TABLE width=100% height=100% border="0" cellspacing="0">
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
						<table class=form>
							<col width=15%>
							<col width=35%>
							<col width=15%>
							<col width=35%>
							<TR class=separator>
								<TD class=Sep1 colSpan=4></TD>
							</TR>
							<tr>
								<td colspan=4 align=center>
									<font size=5 color=blue> <%=Util.toScreen(subject, 7)%></font>
								</td>
							</tr>
							<tr>
								<td colspan=4>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=Util.toScreen(detail, 7)%>
								</td>
							</tr>
							<tr>
								<td colspan=2></td>
							</tr>
						</table>

						<table class=ListShort>
							<col width=25%>
							<col width=55%>
							<col width=10%>
							<col width=10%>
							<TR class=separator>
								<TD class=Sep1 colSpan=4></TD>
							</TR>
						</table>
						<%
							RecordSet.executeProc("VotingQuestion_SelectByVoting", votingid);
							while (RecordSet.next()) {
								questionid = RecordSet.getString("id");
								String q_subject = RecordSet.getString("subject");
								String q_description = RecordSet.getString("description");
								String q_ismulti = RecordSet.getString("ismulti");
								String q_isother = RecordSet.getString("isother");
								String q_ismultino = RecordSet.getString("ismultino");
								int ismultinolength = 0;
							    if(!"".equals(q_ismultino)){
							       ismultinolength = Integer.parseInt(q_ismultino);
							    }
						%>
						<table class=ListShort>
							<tr class=datalight>
								<td>
									<b><%=q_subject%></b>
									<%
									if (!q_description.equals("")){
									%>(<%=q_description%>)<%
									}
									%>
								</td>
							</tr>
							<tr class=datadark>
								<td>
									<%
									rs.executeProc("VotingOption_SelectByQuestion", questionid);
									int count = 1;
									String titlechar = "";
									while (rs.next()) {
										titlechar = "" + count;

										String optionid = rs.getString("id");
										String o_desc = rs.getString("description");
										String selecttype = "";
										if (q_ismulti.equals("1"))
											selecttype = "checkbox";
										else
											selecttype = "radio";
									%>
									<%=titlechar%>.
									<input type=<%=selecttype%> class="inputStyle"
										name="questionid_<%=questionid%>" value="<%=optionid%>"
										<%if ("checkbox".equals(selecttype)&& ismultinolength >0){%>
											onclick="checkNumberFun(this,<%=q_ismultino%>)"
										<%}%>
									><%=o_desc%>&nbsp;&nbsp;&nbsp;
									<%
									if (selecttype.equals("checkbox")){
									%><br>
									<%}%>
									<%
									count++;
									}
									if (count > 1)
										objstr += ",questionid_" + questionid;
									if (q_isother.equals("1")) {
										titlechar = "" + count;
									%>
									<%=titlechar%>.<%=SystemEnv.getHtmlLabelName(375, user.getLanguage())%>:
									<input type=input class="inputStyle"
										name="otherinput_<%=questionid%>" size=30 value="">
									<%}%>
								</td>
							</tr>
							<tr>
								<td>
									&nbsp;
								</td>
							</tr>
						</table>
						<%}
						if (!objstr.equals(""))
							objstr = objstr.substring(1);
						%>
						<br>
						<table class=form width="100%">
							<tr>
								<td width=10% valign=top><%=SystemEnv.getHtmlLabelName(504, user.getLanguage())%></td>
									<td width=90% class=field>
										<textarea name="remark" class="inputStyle"
											style="width: 90%" rows=5></textarea>
									</td>
								</tr>
							</table>

						</td>
					</tr>
				</TABLE>
				</form>
			</td>
			<td></td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
	</table>
</form>
</body>
</html>