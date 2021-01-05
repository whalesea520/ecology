
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocSearchMouldManager" class="weaver.docs.search.DocSearchMouldManager" scope="page" />
<HTML>


<HEAD>
<LINK REL=stylesheet type="text/css" HREF="/css/Weaver_wev8.css">

</HEAD>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<BODY>


<FORM NAME="SearchForm" action="DocSearchTempletBrowser.jsp" method=post>
<input type="hidden" name="pagenum" value=''>

<table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0">
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
		<TABLE class=Shadow  height="100%" width="100%"> 
		<tr>
		<td valign="top">
					<TABLE ID=BrowseTable class=BroswerStyle cellspacing="0"  cellpadding="0">
					<TR class=DataHeader>
					<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
					<TH> <%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>   
					</TR>
					<TR class=Line><TH colSpan=2></TH></TR>
					<%
					int i=0;
					int userid =user.getUID();
			        DocSearchMouldManager.setUserid(userid);
					DocSearchMouldManager.selectSearchMouldIDByUser();
					while(DocSearchMouldManager.next()){

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
								<TD style="display:none"><A HREF=#><%=DocSearchMouldManager.getMouldID()%></A></TD>
								<TD> <%=DocSearchMouldManager.getMouldnameInTurn()%> </TD>
							
							</TR>
							<%
					}
					DocSearchMouldManager.closeStatement();
					%>
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

</FORM>


</BODY>
</HTML>





<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
     
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
     
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
