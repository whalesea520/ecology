<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String tempcareername = Util.null2String(request.getParameter("careername"));
String tempcareerdesc = Util.null2String(request.getParameter("careerdesc"));

String  sqlwhere ="";
if (!tempcareername.equals("")){ 
	sqlwhere = " where careername like '%"+Util.fromScreen2(tempcareername,user.getLanguage())+"%' ";
	if (!tempcareerdesc.equals(""))
		sqlwhere +=" and careerdesc like '%"+Util.fromScreen2(tempcareerdesc,user.getLanguage())+"%' ";
}
else{
	if (!tempcareerdesc.equals(""))
		sqlwhere +=" where careerdesc like '%"+Util.fromScreen2(tempcareerdesc,user.getLanguage())+"%' ";
}
String sqlstr = "select * from HrmCareerInvite " + sqlwhere ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(366,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<FORM NAME=frmain action="HrmCareerApplyView.jsp" method=post>
<table class=ViewForm border=0>
    <colgroup> <col width="6%"> <col width="45%"> <col width="6%"> <col width="43%"> 
    <tbody> 
    <tr> 
      <th align=left colspan=4><%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%></th>
    </tr>
    <tr class=spacing> 
      <td class=line1 colspan=4></td>
    </tr>
    <tr> 
      <td width="10%"><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></td>
	<TD class=Field width="40%"><INPUT class=inputstyle name=careername value='<%=tempcareername%>'></TD>
      <td width="10%"><%=SystemEnv.getHtmlLabelName(1858,user.getLanguage())%></td>
      <TD class=Field width="40%"><input class=inputstyle name=careerdesc value=<%=tempcareerdesc%>></TD>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    </tbody> 
  </table>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(366,user.getLanguage())%></TH>
  </TR>
  </TBODY></TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <THEAD>
  <COLGROUP>
  <COL width="13%">
  <COL width="13%">
  <COL width="13%">
  <COL width="13%">
  <COL width="13%">
  <COL width="13%">
  <COL width="22%">
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1861,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1862,user.getLanguage())%></TH>
	</TR>
    <TR class=Line><TD colspan="7" ></TD></TR> 
    </THEAD>
<%
int i= 0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()) {
	String id = RecordSet.getString("id") ;
	String careername = Util.toScreen(RecordSet.getString("careername"),user.getLanguage()) ;
	String careerpeople = Util.null2String(RecordSet.getString("careerpeople")) ;
	String careersex = Util.null2String(RecordSet.getString("careersex")) ; 
	String careeredu = Util.null2String(RecordSet.getString("careeredu")) ;
	String createrid = Util.null2String(RecordSet.getString("createrid")) ;
	String createdate = Util.null2String(RecordSet.getString("createdate"));
	String careersexstr="";
	String careeredustr="";
	if (careersex.equals("0")) careersexstr = SystemEnv.getHtmlLabelName(763,user.getLanguage());
	else if	(careersex.equals("1")) careersexstr = SystemEnv.getHtmlLabelName(417,user.getLanguage());
	else if (careersex.equals("2")) careersexstr = SystemEnv.getHtmlLabelName(418,user.getLanguage());
	if (careeredu.equals("0")) careeredustr = SystemEnv.getHtmlLabelName(764,user.getLanguage());
	else if	(careeredu.equals("1")) careeredustr = SystemEnv.getHtmlLabelName(765,user.getLanguage());
	else if (careeredu.equals("2")) careeredustr = SystemEnv.getHtmlLabelName(766,user.getLanguage());
	else if (careeredu.equals("3")) careeredustr = SystemEnv.getHtmlLabelName(767,user.getLanguage());
	else if (careeredu.equals("4")) careeredustr = SystemEnv.getHtmlLabelName(768,user.getLanguage());
	else if (careeredu.equals("5")) careeredustr = SystemEnv.getHtmlLabelName(769,user.getLanguage());	
	else if (careeredu.equals("6")) careeredustr = SystemEnv.getHtmlLabelName(763,user.getLanguage());	

if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
    <TD><A HREF="HrmCareerApplyViewDetail.jsp?paraid=<%=id%>"><%=Util.add0(Util.getIntValue(id),12)%></A></TD>
	<TD><%=careername%></TD>
	<TD><%=careerpeople%></TD>
	<TD><%=careersexstr%></TD>
	<TD><%=careeredustr%></TD>
	<TD><%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%></TD>
	<TD><%=createdate%></TD>
    </TR>
<%}%>
 </TABLE>
</FORM>
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

</SCRIPT>
<SCRIPT language="javascript">
function OnSubmit(){
		document.frmain.submit();
}
</script>
</BODY>
</HTML>