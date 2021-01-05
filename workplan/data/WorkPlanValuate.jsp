<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="workPlanValuate" class="weaver.WorkPlan.WorkPlanValuate" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="JavaScript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>
<%
    String workPlanId = Util.null2String(request.getParameter("workid"));

    String userId = String.valueOf(user.getUID());
    ArrayList valResults = workPlanValuate.getValuateScores(userId, workPlanId);
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:doCancel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
<TR>
	<TD></TD>
	<TD valign="top">
		<TABLE class="Shadow">
		<TR>
		<TD valign="top">
			  <TABLE class="ListStyle" cellspacing="1" id="score">
				<COLGROUP>
                <COL width="30%">
                <COL width="70%">
                <TBODY>
                <TR class="Header">
                  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(17505,user.getLanguage())%></TD>
                  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%></TD>
                </TR>
                <TR class="Line"><TD colspan="2"></TD></TR>
			<%
                boolean isLight = false;
                String valMemberStr = "";
                String[] data;
				String m_memberId = "";
                String m_score = "";
                String m_canValuate = "";
				for (int i = 0; i < valResults.size(); i++) {
                    data = (String[]) valResults.get(i);
					m_memberId = data[0];
                    m_score = data[1];
                    m_canValuate = data[2];

                    isLight = !isLight;
			%>
                <TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
				  <TD><%=resourceComInfo.getResourcename(m_memberId)%></TD>
				  <TD class="Field">
                <%
                    if (m_canValuate.equals("1")) {
                        valMemberStr += m_memberId + ",";
                %>
                    <INPUT type="hidden" name="memberid" value="<%=m_memberId%>">
					<SELECT name="score<%=m_memberId%>">
					<OPTION value=""><%=SystemEnv.getHtmlLabelName(17533,user.getLanguage())%></OPTION>
					<OPTION value="1">1</OPTION>
					<OPTION value="2">2</OPTION>
					<OPTION value="3">3</OPTION>
					<OPTION value="4">4</OPTION>
					<OPTION value="5" selected>5</OPTION>
					</SELECT>
                    <%} else {%>
                    <%=(m_score.equals("") ? "-" : m_score)%>
                    <%}%>
                  </TD>
				</TR>
				<TR><TD class="Line" colSpan="2"></TD></TR>
			<%
                }

                if (!valMemberStr.equals(""))
                    valMemberStr = valMemberStr.substring(0, valMemberStr.lastIndexOf(","));
            %>
				</TBODY>
			  </TABLE>
		</TD>
		</TR>
		</TABLE>
	</TD>
	<TD></TD>
</TR>
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
</TABLE>
<SCRIPT language="VBS">
Sub doSubmit()
    allMembers = "<%=valMemberStr%>"&","
	valMembers = ""
	valScores = ""
	While InStr(allMembers, ",") <> 0
		valMember = Mid(allMembers, 1, InStr(allMembers, ",") - 1)
		htmlObjName = "score"&valMember
        valScore = document.all(htmlObjName).value
        If valScore <> "" Then
            valMembers = valMembers&valMember&","
            valScores = valScores&valScore&","
        End If
		allMembers = Mid(allMembers, InStr(allMembers,",") + 1, Len(allMembers))
	Wend

	If valMembers <> "" Then
        valMembers = Mid(valMembers, 1, InStrRev(valMembers, ",") - 1)
		valScores = Mid(valScores, 1, InStrRev(valScores, ",") - 1)
	End If

	window.parent.returnvalue = Array(valMembers, valScores)
    window.parent.close
End Sub

Sub doCancel()
     window.parent.returnvalue = Array("-1", "-1")
     window.parent.close
End Sub
</SCRIPT>
</BODY>
</HTML>