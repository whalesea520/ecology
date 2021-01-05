<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitDel(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="FormFieldBrowser.jsp" method=post>

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

  <table width=100% class="viewform">
  </table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1">
<TR class=DataHeader>
<TH width=25%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=75%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=0% style="display:none"></TH>
<TH width=0% style="display:none"></TH></tr>
<TR class=Line><Th colspan="4" ></Th></TR>
<%
String workflowid = Util.null2String(request.getParameter("workflowid")) ;
String sql = "select isbill from workflow_base where id = " + workflowid  ;
RecordSet.executeSql( sql ) ;
RecordSet.next() ;
String isbill = RecordSet.getString("isbill") ;
if(isbill.equals("0")) {
	sql = " select a.fieldid,a.fieldlable,b.fieldhtmltype,b.type from workflow_fieldlable a, workflow_formdict b , workflow_base c " +
		  " where a.fieldid = b.id and c.formid = a.formid and c.id = " + workflowid + " and a.langurageid ="+user.getLanguage()+
          " union "+
          " select a.fieldid,a.fieldlable,b.fieldhtmltype,b.type from workflow_fieldlable a, workflow_formdictdetail b , workflow_base c " +
		  " where a.fieldid = b.id and c.formid = a.formid and c.id = " + workflowid + " and a.langurageid ="+user.getLanguage();
}
else {
	sql = " select a.id ,d.labelname , a.fieldhtmltype, a.type from workflow_billfield a, workflow_base c , HtmlLabelInfo d " +
		  " where a.billid = c.formid and a.fieldlabel = d.indexid and c.id = " + workflowid + " and d.languageid ="+user.getLanguage() ;
}



int i=0;
RecordSet.executeSql( sql ) ;
while(RecordSet.next()){
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
	<TD><A HREF=#><%=RecordSet.getString(1)%></A></TD>
	<TD><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></TD>
	<TD style="display:none"><%=RecordSet.getString(3)%></TD>
	<TD style="display:none"><%=RecordSet.getString(4)%></TD>

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


</FORM></BODY></HTML>


<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","","","")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText,e.parentelement.cells(2).innerText,e.parentelement.cells(3).innerText)
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText,e.parentelement.parentelement.cells(2).innerText,e.parentelement.parentelement.cells(3).innerText)
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
<script>
function submitData()
{
	if (check_form(weaver,''))
		weaver.submit();
}

function submitDel()
{
btnclear_onclick();
}
</script>
