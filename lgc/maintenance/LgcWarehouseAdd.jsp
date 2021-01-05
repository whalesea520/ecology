<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("LgcWarehouseAdd:Add",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(711,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
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
		<td valign="top"><FORM style="MARGIN-TOP: 0px" name=right method=post action="LgcWarehouseOperation.jsp" onSubmit='return check_form(this,"warehousename,roleid")'>
  <input type="hidden" name="operation" value="addwarehouse">
  <div style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:right.btnSave.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
  <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON> 
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:right.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
  <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON> 
  <br>
  </div>
        
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
    <TR class=Title> 
      <TH colSpan=2>仓库信息</TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <tr> 
      <td>名称</td>
      <td class=Field> 
        <input class=InputStyle  accesskey=Z name=warehousename size="30" onchange='checkinput("warehousename","warehousenameimage")' maxlength="30">
        <SPAN id=warehousenameimage><IMG 
            src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>说明</td>
      <td class=Field> 
        <textarea class=InputStyle accesskey="Z" name="warehousedesc" cols="60"></textarea>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>管理角色</td>
      <td class=Field>
	  <BUTTON CLASS=Browser ID=SelectRolesID onclick="onShowRolesID()"></BUTTON>
	  <SPAN ID=rolesidspan class=InputStyle><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
	  <input type=hidden id=roleid name=roleid>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    </TBODY> 
  </TABLE>
</FORM>

<script language=vbs>

sub onShowRolesID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if (Not IsEmpty(id))  then
		if id(0)<>"" then
		rolesidspan.innerHtml = id(1)
		right.roleid.value=id(0)
		else 
		rolesidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		right.roleid.value=""
		end if
	end if
end sub
</script>

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
