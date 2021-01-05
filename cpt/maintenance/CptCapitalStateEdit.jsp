<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
 rs.executeProc("CptCapitalState_SelectById",""+id);
 
	String name = "";
	String description = "";
    String issystem = "";
 if(rs.next()){
	name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	description = Util.toScreenToEdit(rs.getString("description"),user.getLanguage());
    issystem = rs.getString("issystem");
	}

if(issystem.equals("1")){
   response.sendRedirect("/notice/noright.jsp");
   return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(830,user.getLanguage()) + ":&nbsp;"
                            +SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("CptCapitalStateEdit:Edit", user)){
canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("CptCapitalStateAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",CptCapitalStateAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("CptCapitalStateEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("CptCapitalState:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=76 and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM id=weaver name=frmMain action="CapitalStateOperation.jsp" method=post>
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

		<TABLE class=ViewForm>
		  <COLGROUP>
		  <COL width="20%">
		  <COL width="80%">
		  <TBODY>
		  <TR class=Title>
			<TH colSpan=2><%=SystemEnv.getHtmlLabelName(830,user.getLanguage())%></TH></TR>
			<TR class=Spacing>
			<TD class=Line1 colSpan=2 ></TD></TR>
			<TR>
			<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
			<TD class=Field><%if(canEdit){%><INPUT type=text size=30 name="name"  value="<%=name%>" onchange='checkinput("name","nameimage")' class=InputStyle>
			<SPAN id=nameimage></SPAN><%}else{%><%=name%><%}%></TD>
			</TR>
			<TR><TD class=Line colSpan=2></TD></TR> 
			<TR>
			<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
			<TD class=Field><%if(canEdit){%><INPUT type=text size=60 name="description"   value="<%=description%>" onchange='checkinput("description","descriptionimage")' class=InputStyle>
			<SPAN id=descriptionimage></SPAN><%}else{%><%=description%><%}%></TD>
			</TR>
			<TR><TD class=Line colSpan=2></TD></TR> 
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

 <input type=hidden name=operation>
 <input type=hidden name=id value="<%=id%>">
 </form> 
 
 <script language=javascript>
 function onSave(){
	if(check_form(document.frmMain,'name,description')){
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 </script>
</BODY></HTML>
