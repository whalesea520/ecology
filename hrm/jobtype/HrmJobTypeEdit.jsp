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
 rs.executeProc("HrmJobType_SelectById",""+id);
 
	String name = "";
	String description = "";
 if(rs.next()){
	name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	description = Util.toScreenToEdit(rs.getString("description"),user.getLanguage());
	}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(805,user.getLanguage())+":"+name;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmJobTypeEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobTypeAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/jobtype/HrmJobTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobTypeEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobType:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+62+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<FORM id=weaver name=frmMain action="JobTypeOperation.jsp" method=post>
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle type=text size=30 name="name"  value="<%=name%>" onchange='checkinput("name","nameimage")'>
          <SPAN id=nameimage></SPAN><%}else{%><%=name%><%}%></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle type=text size=60 name="description"   value="<%=description%>" onchange='checkinput("description","descriptionimage")'>
          <SPAN id=descriptionimage></SPAN><%}else{%><%=description%><%}%></TD>
        </TR>
  </TR>
<TR><TD class=Line colSpan=2></TD></TR> 
 </TBODY>
 </TABLE>
 
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=id value="<%=id%>">
 </form> 
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
