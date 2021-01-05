
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<%
String docid = Util.null2String(request.getParameter("docid"));
String isrequest = Util.null2String(request.getParameter("isrequest"));
String requestid = Util.null2String(request.getParameter("requestid"));
String docsubject=DocComInfo.getDocname(docid);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDoc_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1008,user.getLanguage())
	+":<a href='DocDsp.jsp?id="+docid+"&isrequest="+isrequest+"&requestid="+requestid+"'>"
	+Util.toScreen(docsubject,user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<TABLE class=ListStyle cellspacing="1" >
<colgroup> <col width="20%"> <col width="35%"> <col width="25%"> <col width="20%">
<tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(439,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(1008,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(1425,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
</tr>
 <TR class=Line><TD colspan="4" ></TD></TR>
<%
boolean islight=true;
RecordSet.executeProc("DocApproveRemark_SelectByDocid",docid);
while(RecordSet.next()){
    String approverid=RecordSet.getString("approverid");
    String approvedate=RecordSet.getString("approvedate");
    String approvetime=RecordSet.getString("approvetime");
    String approveremark=RecordSet.getString("approveremark");
    String isapprover=RecordSet.getString("isapprover");
    String status="";
    if(isapprover.equals("1"))  status=SystemEnv.getHtmlLabelName(1009,user.getLanguage());
    else if(isapprover.equals("0"))   status=SystemEnv.getHtmlLabelName(1010,user.getLanguage());
    else if(isapprover.equals("2"))   status=SystemEnv.getHtmlLabelName(1005,user.getLanguage());
    String approvername=ResourceComInfo.getResourcename(approverid);
%>
<tr <%if(islight){%> class=datalight <%} else {%>class=datadark<%}%>>
    <td><%=Util.toScreen(approvername,user.getLanguage())%></td>
    <td><%=Util.toScreenToEdit(approveremark,user.getLanguage())%></td>
    <td><%=Util.toScreen(approvedate,user.getLanguage())%>&nbsp;<%=Util.toScreen(approvetime,user.getLanguage())%></td>
    <td><%=Util.toScreen(status,user.getLanguage())%></td>
</tr>
<%
    islight=!islight;
}
%>
</table>

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

</body>
</html>