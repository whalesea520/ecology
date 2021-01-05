<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(386,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(567,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("FnaBudgetModuleAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/fna/maintenance/FnaBudgetModuleAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaBudgetModule:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+38+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
<TABLE class=ListStyle cellspacing=1>
  <TBODY>
  <TR class=Header>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></TH>
  </TR>
 
    </TBODY>
    </TABLE>
<TABLE class=ListStyle CELLSPACING=1>
  <THEAD>
  <COLGROUP>
  <COL width="40%" align=left>
  <COL width="60%"  align=left>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH></TR>
    <TR class=Line><TD colspan="2" ></TD></TR> 
    </THEAD>
<%
int i= 0;
RecordSet.executeProc("FnaBudgetModule_Select","");
while(RecordSet.next()) {
	String id = RecordSet.getString("id") ;
	String budgetname = Util.toScreen(RecordSet.getString("budgetname"),user.getLanguage()) ;
	String budgetdesc = Util.toScreen(RecordSet.getString("budgetdesc"),user.getLanguage()) ;
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
    <TD><A 
      href="FnaBudgetModuleEdit.jsp?id=<%=id%>"><%=budgetname%></A></TD>
    <TD><%=budgetdesc%></TD></TR>
<%}%>
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
<script language=javascript>  
function submitData() {
 frmMain.submit();
}
</script>

</BODY>
</HTML>
