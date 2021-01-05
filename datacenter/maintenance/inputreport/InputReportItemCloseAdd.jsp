<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);
String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("新 ：输入项锁定",user.getLanguage(),"0");
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
<FORM id=weaver name=frmMain action="InputReportItemOperation.jsp" method=post>

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
      <TH colSpan=2>输入项锁定</TH>
    </TR>
    <TR class=Spacing style="height: 1px"> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD>基层单位</TD>
      <TD class=Field> 
        
        <input class="wuiBrowser" _required="yes" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" type="hidden" id="crmid" name="crmid">
      </TD></TR><TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    
    <TR> 
      <TD>输入项</TD>
      <TD class=Field> 
        <select class="InputStyle" name='itemid' style='width:50%'>
            <% 
                rs.executeSql("select * from T_InputReportItem where inprepid =" + inprepid );
                while(rs.next()) {
            %>
            <option value='<%=Util.null2String(rs.getString("itemid"))%>'><%=Util.toScreen(rs.getString("itemdspname"),user.getLanguage())%></option>
            <%}%>
        </select>
      </TD>
    </TR><TR class=Spacing style="height: 1px"> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    
    <input type="hidden" name=operation value=addclose>
	<input type="hidden" name=inprepid value=<%=inprepid%>>
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

<script language=vbs>
sub onShowCustomer(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if NOT isempty(id) then
        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value = id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value =""
		end if
	end if
end sub
</script>
<script language="javascript">
function submitData()
{
	if (check_form(frmMain,'crmid'))
		frmMain.submit();
}
</script> 
</BODY></HTML>
