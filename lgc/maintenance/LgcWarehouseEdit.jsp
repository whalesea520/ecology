<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
RecordSet.executeProc("LgcWarehouse_SelectByID",id);
RecordSet.next();
String warehousename = RecordSet.getString("warehousename");
String warehousedesc = RecordSet.getString("warehousedesc");
String roleid = Util.null2String(RecordSet.getString("roleid"));

boolean canedit = HrmUserVarify.checkUserRight("LgcWarehouseEdit:Edit", user) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(711,user.getLanguage())+" : "+ Util.toScreen(warehousename,user.getLanguage());
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
		<td valign="top"><%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
  <FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="LgcWarehouseOperation.jsp">
    <input type="hidden" name="operation">
    <input type="hidden" name="id" value="<%=id%>">
<div style="display:none">
<% if(canedit) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn id=btnSave accessKey=S name=btnSave onclick="onEdit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON> 
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:frmMain.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn id=btnClear accessKey=R name=btnClear warehouse=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON> 
<% } 
if(HrmUserVarify.checkUserRight("LgcWarehouseEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%
}
 if(HrmUserVarify.checkUserRight("LgcWarehouse:Log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =49 and relatedid=<"+id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnLog accessKey=L name=button2 onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =49 and relatedid=<%=id%>'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
<%}
%>
</div>    <br>
   
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Title> 
      <TH colSpan=2>仓库信息</TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <TR> 
      <TD>名称</TD>
      <TD Class=Field> 
        <% if(canedit) { %>
        <input class=InputStyle  accesskey=Z name=warehousename size="30" onChange='checkinput("warehousename","warehousenameimage")' value="<%=Util.toScreenToEdit(warehousename,user.getLanguage())%>" maxlength="30">
        <span id=warehousenameimage></span> 
        <% } else {%>
        <%=Util.toScreen(warehousename,user.getLanguage())%> 
        <%}%>
      </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>说明</td>
      <td class=Field> 
        <% if(canedit) { %>
        <textarea class=InputStyle accesskey="Z" name="warehousedesc" cols="60"><%=Util.toScreenToEdit(warehousedesc,user.getLanguage())%></textarea>
        <% } else {%>
        <%=Util.toScreen(warehousedesc,user.getLanguage())%> 
        <%}%>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>管理角色</td>
      <td class=Field> 
        <% if(canedit) { %>
        <BUTTON CLASS=Browser ID=SelectRolesID onclick="onShowRolesID()"></BUTTON>
	  <SPAN ID=rolesidspan class=InputStyle>
        <%=Util.toScreen(RolesComInfo.getRolesname(roleid),user.getLanguage())%>
        </span> 
        <input class=InputStyle  id=roleid type=hidden name=roleid value="<%=roleid%>">
        <% } else {%>
        <%=Util.toScreen(RolesComInfo.getRolesname(roleid),user.getLanguage())%> 
        <%}%>
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
<script language="VBS">
sub onShowRolesID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if (Not IsEmpty(id))  then
		if id(0)<>"" then
		rolesidspan.innerHtml = id(1)
		frmMain.roleid.value=id(0)
		else 
		rolesidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		frmMain.roleid.value=""
		end if
	end if
end sub
</script>

<script language=javascript>
 function onEdit(){
 	if(check_form(document.frmMain,'warehousename,roleid')){
 		document.frmMain.operation.value="editwarehouse";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="deletewarehouse";
			document.frmMain.submit();
		}
}
 </script>
</BODY>
</HTML>
