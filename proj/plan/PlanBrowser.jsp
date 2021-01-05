<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PlanTypeComInfo" class="weaver.proj.Maint.PlanTypeComInfo" scope="page" />
<jsp:useBean id="PlanSortComInfo" class="weaver.proj.Maint.PlanSortComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
String plantype = Util.null2String(request.getParameter("plantype"));
String plansort = Util.null2String(request.getParameter("plansort"));
String validate = Util.null2String(request.getParameter("validate"));

if(plantype.equals("")) plantype = "0";
if(plansort.equals("")) plansort = "0";
if(validate.equals("")) validate = "0";

String sqlwhere = " ";         
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



<FORM NAME=SearchForm STYLE="margin-bottom:0" action="PlanBrowser.jsp" method=post>
<input type=hidden name=ProjID value="<%=ProjID%>">
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



 <TABLE class=viewform>
      <COLGROUP>
  	<COL width="15%">
  	<COL width="35%">
  	<COL width="15%">
  	<COL width="35%">
        <TBODY>
        
        <TR class=spacing>
          <TD class=line1 colSpan=4></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(842,user.getLanguage())%></TD>
          <TD class=Field>
          <select class=inputstyle  name="plantype">
          <option value="0"></option>
          <%
          while(PlanTypeComInfo.next()){
          %>
          <option value="<%=PlanTypeComInfo.getPlanTypeid()%>" <%if(PlanTypeComInfo.getPlanTypeid().equals(plantype)){%> selected <%}%>><%=PlanTypeComInfo.getPlanTypename()%></option>
          <%}%>
          </select>
          </TD>
          <TD><%=SystemEnv.getHtmlLabelName(843,user.getLanguage())%></TD>
          <TD class=Field><select class=inputstyle  name="plansort">
          <option value="0"></option>
          <%
          while(PlanSortComInfo.next()){
          %>
          <option value="<%=PlanSortComInfo.getPlanSortid()%>" <%if(PlanSortComInfo.getPlanSortid().equals(plansort)){%> selected <%}%>><%=PlanSortComInfo.getPlanSortname()%></option>
          <%}%>
          </select>
         </TD>
          
        </TR> <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
          <TD class=Field colspan=3>
          <select class="inputstyle"  name="validate">
          <option value="0" <%if(validate.equals("0")){%> selected <%}%>></option>
          <option value="1" <%if(validate.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
          <option value="2" <%if(validate.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
          </select> </TD>         
         </TR>   <TR class=spacing>
          <TD class=line1 colSpan=4></TD></TR>     
        </TBODY></TABLE>
        
<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1">
<TR class=DataHeader>
<TH width=25%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=25%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
<TH width=25%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TH>
<TH width=25%><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TH>
</tr>
<tr class="line"><th colspan="4"></th></tr>
<%
int ishead = 0;
	sqlwhere = " where prjid = " + ProjID;
	if(!plantype.equals("0")){
          	sqlwhere += " and plantype = " + plantype;
          }
          if(!plansort.equals("0")){
          	
          		sqlwhere += " and plansort = "+ plansort;
          	
          }
          if(!validate.equals("0")){
          	if(validate.equals("2")) validate = "0";
          		sqlwhere += " and validate_n = " + validate;

          }
          
int i=0;
sqlwhere = "select * from Prj_PlanInfo "+sqlwhere + " order by id";
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
	<TD><%=RecordSet.getString("subject")%></TD>
	<td> <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("resourceid")),user.getLanguage())%></td>
	<td><%if(RecordSet.getString("validate_n").equals("1")){%>
          	<img border=0 src="/images/BacoCheck_wev8.gif"> </img>
          	<%}else{%>
          	<img border=0 src="/images/BacoCross_wev8.gif"> </img>
          	<%}%>
          </td>
	
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
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
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
{btnclear_onclick();
}
</script>