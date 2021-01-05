<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>

<BODY>
<FORM NAME=SearchForm STYLE="margin-bottom:0">
<TABLE ID=BrowseTable class=Data STYLE="margin-top:0">
<TR class=DataHeader>
<TH><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<%
int i=0;
while(DocTypeComInfo.next()){
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
	<TD><A HREF=#><%=DocTypeComInfo.getDocTypeid()%></A></TD>
	<TD><%=DocTypeComInfo.getDocTypename()%></TD>
</TR>
<%}%>

</TABLE></FORM></BODY></HTML>


<SCRIPT LANGUAGE=VBS>
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     // window.Parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
      window.Parent.returnvalue = e.parentelement.cells(0).innerText
      window.Parent.Close
   ElseIf e.TagName = "A" Then
      //window.Parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
      window.Parent.returnvalue = e.parentelement.parentelement.cells(0).innerText
      window.Parent.Close
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
