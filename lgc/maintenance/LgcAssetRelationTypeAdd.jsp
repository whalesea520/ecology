<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("LgcAssetRelationTypeAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(706,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

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

<FORM id=frmMain action=LgcAssetRelationTypeOperation.jsp method=post onsubmit='return check_form(this,"typename")'>
  <DIV style="display:none">
  <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:frmMain.mysave.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

  <BUTTON class=btnSave accessKey=S id=mysave  type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON></div>
  <input type=hidden name=operation value="addtype">
  <TABLE class=ViewForm>
  <TBODY>
  <TR>
    <TH class=Title align=left>基本信息</TH></TR>
  <TR class=Spacing>
    <TD class=Line1 colSpan=4></TD></TR></TBODY></TABLE>
  <TABLE class=ViewForm id=tblScenarioCode>
    <THEAD> <COLGROUP> <COL width="15%"> <COL width="30%"> <COL width="15%"> <COL width="40%"></THEAD> 
    <TBODY> 
    <TR> 
      <TD>名称</TD>
      <TD class=FIELD> 
        <input class=InputStyle  id=typename name=typename maxlength="30" onchange='checkinput("typename","typenameimage")' size="30">
        <SPAN id=typenameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
      <TD>购物建议</TD>
      <TD class=field> 
        <input type="checkbox" name="shopadvice" value="1">
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <tr> 
      <td>类型</td>
      <td class=FIELD> 
        <select class=InputStyle id=State name=typekind>
          <option value="1">强制</option>
          <option value="2">必选其一</option>
          <option value="3">可选</option>
          <option value="4">可选其一</option>
          <option value="5">排除</option>
        </select>
      </td>
      <td>合同限制</td>
      <td class=field> 
        <input type="checkbox" name="contractlimit" value="1">
      </td>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD>说明</TD>
      <TD class=FIELD><nobr> 
        <textarea class=InputStyle id="typedesc" name="textarea" onChange="checkinput(&quot;typedesc&quot;,&quot;typedescimage&quot;)" cols="60" rows="6"></textarea>
      </TD>
      <TD>&nbsp;</TD>
      <TD>&nbsp;</TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    </TBODY> 
  </TABLE>
</FORM>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
