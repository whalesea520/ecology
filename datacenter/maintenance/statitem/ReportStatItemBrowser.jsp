<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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

  <table width=100% class=viewform>
    <TR class=spacing>
      <TD class=line1 colspan=4></TD>
    </TR>
  </table>
<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1">
<TR class=DataHeader>
<TH width=0%  style="display:none"></TH>
<TH width=20%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=50%><%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH></tr>
<TR class=Line><Th colspan="4" ></Th></TR> 
<%
boolean isLight = false;
sqlwhere = "select * from T_Statitem "+sqlwhere;
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
	String statitemid = Util.null2String(RecordSet.getString("statitemid")) ;
    String statitemname = Util.toScreen(RecordSet.getString("statitemname"),user.getLanguage()) ;
    String statitemexpress = Util.null2String(RecordSet.getString("statitemexpress")) ;
    String statitemdesc = Util.toScreen(RecordSet.getString("statitemdesc"),user.getLanguage()) ;
		
	isLight = ! isLight ;
%>
<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
	<TD  style="display:none"><A HREF=#><%=statitemid%></A></TD>
	<TD><%=statitemname%></TD>
	<TD><%=statitemexpress%></TD>
	<TD><%=statitemdesc%></TD>
	
</TR>
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


</BODY></HTML>


<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array(0,"")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
    //  window.parent.returnvalue = e.parentelement.cells(0).innerText
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
     // window.parent.returnvalue = e.parentelement.parentelement.cells(0).innerText
      window.parent.Close
   End If
End Sub
Sub BrowseTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub
</SCRIPT>
 <script language="javascript">
function submitClear()
{
	btnclear_onclick();
}
</script>