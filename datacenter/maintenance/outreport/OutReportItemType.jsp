<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int outrepid = Util.getIntValue(request.getParameter("outrepid"),0);
int itemrow = Util.getIntValue(request.getParameter("itemrow"),0);
int itemcolumn = Util.getIntValue(request.getParameter("itemcolumn"),0);
String itemtype = "" ;
String itemid = "" ;

char separator = Util.getSeparator() ;
String para = ""+outrepid + separator + ""+itemrow  + separator + ""+itemcolumn ;


rs.executeProc("T_OutReportItem_SelectByRowCol",para);
if(rs.next()) {
    itemid = Util.null2String(rs.getString("itemid")) ;
    itemtype = Util.null2String(rs.getString("itemtype")) ;
}


String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("报表项类型",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:frmMain.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:docopy(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="OutReportItemDetail.jsp" method=post >
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
      <TH colSpan=2>报表项类型</TH>
    </TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD>文本项</TD>
          <TD class=Field><input type="radio" name="itemtype" value="1" <% if(itemtype.equals("") || itemtype.equals("1")) {%> checked <%}%>></TD>
        </TR>  <TR class=spacing>
    <TD class=line colSpan=2 ></TD></TR>
        <TR>
          <TD>数据库取值</TD>
          <TD class=Field><input type="radio" name="itemtype" value="2" <% if( itemtype.equals("2")) {%> checked <%}%>></TD>
        </TR>  <TR class=spacing>
    <TD class=line colSpan=2 ></TD></TR>
        <TR>
          <TD>其它表格取值</TD>
          <TD class=Field><input type="radio" name="itemtype" value="3" <% if( itemtype.equals("3")) {%> checked <%}%>></TD>
        </TR>  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
        <input type="hidden" name=outrepid value=<%=outrepid%>>
        <input type="hidden" name=itemrow value=<%=itemrow%>>
        <input type="hidden" name=itemcolumn value=<%=itemcolumn%>>
        <input type="hidden" name=itemid value=<%=itemid%>>
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

 <script language=javascript>

 function docopy() {
     document.frmMain.action = "OutReportItemCopy.jsp" ;
     document.frmMain.submit() ;
 }
 </script>
</BODY></HTML>
