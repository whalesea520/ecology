<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(16890,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="ReportStatItemOperation.jsp" method=post >
<input type="hidden" name=operation value=add>

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
        <INPUT type=text class=inputstyle size=50 name="statitemname" onchange='checkinput("statitemname","statitemnameimage")'>
        <SPAN id=statitemnameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
    </TR>  <TR class=spacing style="height:1px;"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT type=text class=inputstyle size=50 name="statitemenname">
      </TD>
    </TR>  
    <TR class=spacing style="height:1px;"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%></TD>
      <TD class=Field > 
        <INPUT type=text class=inputstyle size=80 name="statitemexpress" onchange='checkinput("statitemexpress","statitemexpressimage")'>
        <SPAN id=statitemexpressimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
    </TR><TR class=spacing style="height:1px;"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=80 name="statitemdesc" >
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


<script language="javascript">
function submitData()
{
	if (check_form(frmMain,'statitemname,statitemexpress'))
		frmMain.submit();
}
</script>
</BODY></HTML>
