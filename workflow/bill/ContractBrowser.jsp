<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String departmentmark = Util.null2String(request.getParameter("departmentmark"));
String name = Util.null2String(request.getParameter("name"));
String sqlwhere = "select t3.id,t2.requestname,t3.defcountprice,t3.countprice from workflow_form t1,workflow_requestbase t2,bill_contract t3 where t1.requestid = t2.requestid and t1.billid = t3.id and t1.billformid = 4";

if(!name.equals("")){
		sqlwhere += " and t2.requestname like '%";
		sqlwhere +=  Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
}
%>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ContractBrowser.jsp" method=post>
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
<TR class="Spacing"><TD class="Line1" colspan=4></TD></TR>
<TR>
<TD width=20%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD width=80% class=field><input name=name class=Inputstyle value="<%=name%>" style="width:80%"></TD>
</TR>
<TR class="Spacing"><TD class="Line1" colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1">
<TR class=DataHeader>
<TH width=10%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15439,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(1447,user.getLanguage())%></TH></tr> 
<TR class=Line ><Th colSpan=4></Th></TR> 
<%
int i=0;
RecordSet.execute(sqlwhere);
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
	<TD><%=RecordSet.getString(2)%></TD>
	<TD><%=RecordSet.getString(3)%></TD>
	<TD><%=RecordSet.getString(4)%></TD>
	
	
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
     window.parent.returnvalue = Array(0,"","")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText &"-"& e.parentelement.cells(2).innerText,e.parentelement.cells(2).innerText)
    //  window.parent.returnvalue = e.parentelement.cells(0).innerText
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText,e.parentelement.cells(2).innerText)
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
function submitData()
{btnok_onclick();
}

function submitClear()
{
	btnclear_onclick();
}

</script>
