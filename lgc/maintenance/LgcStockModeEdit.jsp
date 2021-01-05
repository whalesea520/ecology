<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
RecordSet.executeProc("LgcStockMode_SelectByID",id);
RecordSet.next();
String modename = RecordSet.getString("modename");
String modetype = Util.null2String(RecordSet.getString("modetype"));
String modestatus = Util.null2String(RecordSet.getString("modestatus"));
String modedesc = RecordSet.getString("modedesc");
boolean canedit = HrmUserVarify.checkUserRight("LgcStockModeEdit:Edit", user) ;
boolean canedit2 = canedit & !modestatus.equals("2") ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(712,user.getLanguage())+" : "+ Util.toScreen(modename,user.getLanguage());
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
  <FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="LgcStockModeOperation.jsp">
  <input type="hidden" name="id" value="<%=id%>">
  <input type="hidden" name="operation">
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
<BUTTON class=btn id=btnClear accessKey=R name=btnClear mode=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON> 
<% } 
if(HrmUserVarify.checkUserRight("LgcStockModeEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%
}
 if(HrmUserVarify.checkUserRight("LgcStockMode:Log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =50 and relatedid="+id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnLog accessKey=L name=button2 onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =50 and relatedid=<%=id%>'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
<%}
%>
</div>    <br>
   
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Title> 
      <TH colSpan=2>进出库方式信息</TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <TR> 
      <TD>名称</TD>
      <TD Class=Field> 
        <% if(canedit) { %>
        <input class=InputStyle  accesskey=Z name=modename size="30" onChange='checkinput("modename","modenameimage")' value="<%=Util.toScreenToEdit(modename,user.getLanguage())%>" maxlength="30">
        <span id=modenameimage></span> 
        <% } else {%>
        <%=Util.toScreen(modename,user.getLanguage())%> 
        <%}%>
      </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>类型</td>
      <td class=Field> 
        <% if(canedit2) { %>
        <select class=InputStyle id=State name=modetype>
          <option value="1" <% if(modetype.equals("1")) {%> selected <%}%>>入库</option>
          <option value="2" <% if(modetype.equals("2")) {%> selected <%}%>>出库</option>
        </select>
        <% } else {
		if(modetype.equals("1")) {%>入库
		<%}else if(modetype.equals("2")) {%>出库<%}%>
        <input type="hidden" name="modetype" value="<%=modetype%>">
        <%}%>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>活跃</td>
      <td class=Field> 
        <input type="checkbox" name="modestatus" value="1" <% if(modestatus.equals("1") || modestatus.equals("2")) {%> checked <%} if(!canedit2) {%> disabled <%}%> >
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>详细</td>
      <td class=Field> 
        <% if(canedit) { %>
        <textarea class=InputStyle accesskey="Z" name="modedesc" cols="60"><%=Util.toScreenToEdit(modedesc,user.getLanguage())%></textarea>
        <% } else {%>
        <%=Util.toScreen(modedesc,user.getLanguage())%> 
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
<script language=javascript>
 function onEdit(){
 	if(check_form(document.frmMain,'modename')){
 		document.frmMain.operation.value="editmode";
		<% if(modestatus.equals("2")) { %>
		document.frmMain.modestatus.disabled = false ;
		document.frmMain.modestatus.value="2";
		<%}%>
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="deletemode";
			<% if(modestatus.equals("2")) { %>
			document.frmMain.modestatus.disabled = false ;
			document.frmMain.modestatus.value="2";
			<%}%>
			document.frmMain.submit();
		}
}
 </script>
</BODY>
</HTML>
