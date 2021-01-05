<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("LgcStockModeAdd:Add",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(712,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
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
		<td valign="top"><FORM style="MARGIN-TOP: 0px" name=right method=post action="LgcStockModeOperation.jsp" onSubmit='return check_form(this,"modename")'>
  <input type="hidden" name="operation" value="addmode">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:right.btnSave.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
  <BUTTON class=btn id=btnSave accessKey=S name=btnSave style="display:none"  type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON> 
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:right.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
  <BUTTON class=btn id=btnClear accessKey=R name=btnClear style="display:none"  type=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON> 
  <br>
        
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
    <TR class=Title> 
      <TH colSpan=2>进出库方式信息</TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <tr> 
      <td>名称</td>
      <td class=Field> 
        <input class=InputStyle  accesskey=Z name=modename size="30" onChange='checkinput("modename","modenameimage")' maxlength="30">
        <span id=modenameimage><img 
            src="/images/BacoError_wev8.gif" align=absMiddle></span> </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>类型</td>
      <td class=Field>
        <select class=InputStyle id=State name=modetype>
          <option value="1">入库</option>
          <option value="2">出库</option>
        </select>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>活跃</td>
      <td class=Field> 
        <input class=InputStyle  type="checkbox" name="modestatus" value="1">
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>描述</td>
      <td class=Field> 
        <textarea class=InputStyle accesskey="Z" class=InputString name="modedesc" cols="60"></textarea>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
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
      </BODY>
      </HTML>
