
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetR" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ContractViewer" class="weaver.crm.ContractViewer" scope="page"/>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
int success = Util.getIntValue(request.getParameter("success"),0);
%>
<BODY>
<DIV id=wait style="filter:alpha(opacity=30); height:100%; width:100%">
<TABLE width="100%" height="100%">
	<%if (success==0){%>
	<TR><TD align=center style="font-size: 36pt;"><%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...</TD></TR>
	<%}else{%>
	<TR><TD align=center style="font-size: 36pt;"><%=SystemEnv.getHtmlLabelNames("553,555",user.getLanguage())%></TD></TR>
	<%}%>
</TABLE>
</DIV>
</BODY>
</HTML>
<%
if (success==0){
	String contractId = "";
	String sqlstr = "select id from CRM_Contract";
	RecordSet.executeSql(sqlstr);
	while(RecordSet.next())
	{
		contractId = RecordSet.getString("id");
		ContractViewer.setContractShareById(contractId);
	}
	response.sendRedirect("CRMContractShareIni.jsp?success=1");
}
%>
