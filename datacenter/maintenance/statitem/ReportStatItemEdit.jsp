<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>



<%

String statitemid = Util.null2String(request.getParameter("statitemid"));
rs.executeProc("T_Statitem_Select", statitemid);
rs.next() ;

String statitemname = Util.toScreenToEdit(rs.getString("statitemname"),user.getLanguage()) ;
String statitemenname = Util.toScreenToEdit(rs.getString("statitemenname"),user.getLanguage()) ;
String statitemdesc = Util.toScreenToEdit(rs.getString("statitemdesc"),user.getLanguage()) ;
String statitemexpress = Util.null2String(rs.getString("statitemexpress")) ;

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(16890,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",ReportStatItemAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="ReportStatItemOperation.jsp" method=post >
<input type="hidden" name=operation>
<input type="hidden" name=statitemid value=<%=statitemid%>>

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
    <COLGROUP> <COL width="20%"> <COL width="80%"> <TBODY> 
    <TR class=title> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16890,user.getLanguage())%></TH>
    </TR>
    <TR class=spacing style="height:1px;"> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT type=text class=inputstyle size=50 name="statitemname" onchange='checkinput("statitemname","statitemnameimage")' value="<%=statitemname%>">
        <SPAN id=statitemnameimage></SPAN></TD>
    </TR>  <TR class=spacing style="height:1px;"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT type=text class=inputstyle size=50 name="statitemenname" value="<%=statitemenname%>">
      </TD>
    </TR>  <TR class=spacing style="height:1px;"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%></TD>
      <TD class=Field > 
        <INPUT type=text class=inputstyle size=80 name="statitemexpress" onchange='checkinput("statitemexpress","statitemexpressimage")' value="<%=statitemexpress%>">
        <SPAN id=statitemexpressimage></SPAN></TD>
    </TR><TR class=spacing style="height:1px;"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=80 name="statitemdesc" value="<%=statitemdesc%>">
      </td>
    </tr><TR class=spacing style="height:1px;"> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    </TBODY> 
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


 </form>


<script language=javascript>
 
function onSave(){
    if(check_form(document.frmMain,'statitemname,statitemexpress')){
        document.frmMain.operation.value="edit";
        document.frmMain.submit();
    }
 }
 function onDelete(){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.frmMain.operation.value="delete";
        document.frmMain.submit();
    }
}

</script>
 
</BODY></HTML>
