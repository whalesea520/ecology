<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

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
<FORM id=weaver name=frmMain action="OutReportOperation.jsp" method=post >

<!-- BUTTON class=btn accessKey=R onClick="location.herf='OutReportItemDetail"><U>R</U>-返回</BUTTON -->

<FORM id=weaver name=frmMain action="OutReportItemOperation.jsp" method=post >
<input type="hidden" name=operation value="addcondition">
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
          
      <TD>条件</TD>
          
      <TD class=Field><button class=Browser id=SelectItem onClick="onShowCondition(conditionidspan,conditionid)"></button>
	  <span class=InputStyle id=conditionidspan><IMG src='/images/BacoError.gif' align=absMiddle></span> 
	  <input id=conditionid type=hidden name=conditionid>
	  
	   </TD>
        </TR>  <TR class=spacing>
    <TD class=line colSpan=2 ></TD></TR>
        <TR>
          
      <TD>值</TD>
          <TD class=Field><INPUT type=text class="InputStyle" size=50 name="conditionvalue" onchange='checkinput("conditionvalue","conditionvalueimage")'>
          <SPAN id=conditionvalueimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>说明:用 $条件数据库字段名 标识从用户查询中获取</TD>
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
 <script language=vbs>
 sub onShowCondition(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/datacenter/maintenance/condition/OutReportConditionBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		spanname.innerHtml= id(1)
		inputname.value = id(0)
	else
		spanname.innerHtml= "<IMG src='/images/BacoError.gif' align=absMiddle>"
		inputname.value = ""
	end if
	end if
end sub
</script>
  <script language="javascript">
function submitData()
{
	if (check_form(frmMain,'conditionid,conditionvalue'))
		frmMain.submit();
}
</script>

</BODY></HTML>
