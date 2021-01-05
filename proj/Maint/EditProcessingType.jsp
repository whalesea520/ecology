
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = request.getParameter("id");

	RecordSet.executeProc("Prj_ProcessingType_SelectByID",id);
	
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/proj/DBError.jsp?type=FindData");
		return;
	}
	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/proj/DBError.jsp?type=FindData");
		return;
	}
	RecordSet.first();
boolean canedit = HrmUserVarify.checkUserRight("EditProcessingType:Edit",user);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(665,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>



<FORM id=weaver action="/proj/Maint/ProcessingTypeOperation.jsp" method=post onsubmit='return check_form(this,"type,desc")'>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(HrmUserVarify.checkUserRight("EditProcessingType:Edit", user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
}
if(HrmUserVarify.checkUserRight("EditProcessingType:Delete", user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitDel(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%}%>
</DIV>
  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="id" value="<%=id%>">
  
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
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=viewform>
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=inputstyle maxLength=50 size=20 name="type" onchange='checkinput("type","typeimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>"><SPAN id=typeimage></SPAN><%}else {%> <%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%> <%}%></TD>
        </TR>        <TR class=spacing>
          <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=inputstyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"><SPAN id=descimage><%}else {%><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%><%}%></TD>
         </TR>         <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>       
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE></td>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'type,desc'))
		weaver.submit();
}


function submitDel()
{
	if(isdel()){
		document.all("method").value="delete" ;
		weaver.submit();
		}
}
</script>

</BODY>
</HTML>
