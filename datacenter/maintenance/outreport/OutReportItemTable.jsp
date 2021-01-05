<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%

String itemid = Util.null2String(request.getParameter("itemid"));
String outrepid = Util.null2String(request.getParameter("outrepid"));
String itemrow = Util.null2String(request.getParameter("itemrow"));
String itemcolumn = Util.null2String(request.getParameter("itemcolumn"));


String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("报表项信息",user.getLanguage(),"0");
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
<!-- BUTTON class=btn accessKey=R onClick="history.back(-1)"><U>R</U>-返回</BUTTON -->

<FORM id=weaver name=frmMain action="OutReportItemOperation.jsp" method=post >
<input type="hidden" name=operation value="addtable">
<input type=hidden name=outrepid value="<%=outrepid%>">
<input type=hidden name=itemid value="<%=itemid%>">
<input type=hidden name=itemrow value="<%=itemrow%>">
<input type=hidden name=itemcolumn value="<%=itemcolumn%>">


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
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
      <TH colSpan=2>报表项信息</TH>
    </TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          
      <TD>表</TD>
          <TD class=Field>
        <select class="InputStyle" name="itemtable">
		<%
		  rs.executeProc("T_InputReport_SelectAll","");
		  while(rs.next()){
			String inpreptablename = Util.null2String(rs.getString("inpreptablename")) ;
			String inprepbugtablename = Util.null2String(rs.getString("inprepbugtablename")) ;
			String inprepbudget = Util.null2String(rs.getString("inprepbudget")) ;
		%>
          <option value="<%=inpreptablename%>"><%=inpreptablename%></option>
		  <% if(inprepbudget.equals("1")) {%>
		  <option value="<%=inprepbugtablename%>"><%=inprepbugtablename%></option>
		  <%}}%>
        </select>
      </TD>
        </TR>  <TR class=spacing>
    <TD class=line colSpan=2 ></TD></TR>
        <TR>
          
      <TD>别名</TD>
          <TD class=Field><INPUT type=text class="InputStyle"  size=50 name="itemtablealter" onchange='checkinput("itemtablealter","itemtablealterimage")'>
          <SPAN id=itemtablealterimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
 </TBODY></TABLE>
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
	if (check_form(frmMain,'itemtablealter'))
		frmMain.submit();
}
</script>
</BODY></HTML>
