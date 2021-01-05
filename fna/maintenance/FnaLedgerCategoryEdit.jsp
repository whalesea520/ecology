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
RecordSet.executeProc("FnaLedgerCategory_SelectByID",id);
RecordSet.next();
String categoryname = RecordSet.getString("categoryname");
String categorydesc = RecordSet.getString("categorydesc");
boolean canedit = HrmUserVarify.checkUserRight("FnaLedgerCategoryEdit:Edit", user) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(92,user.getLanguage())+" : "+ Util.toScreen(categoryname,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaLedgerCategoryEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
 if(HrmUserVarify.checkUserRight("FnaLedgerCategory:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+35+" and relatedid="+id+",_self} " ;
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
  <FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="FnaLedgerCategoryOperation.jsp">
    <input type="hidden" name="operation">
    <input type="hidden" name="id" value="<%=id%>">
  <TABLE class=viewForm>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=title> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1479,user.getLanguage())%></TH>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=2></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD Class=Field>
        <% if(canedit) { %>
        <input class=inputstyle accesskey=Z name=categoryname size="30" onChange='checkinput("categoryname","categorynameimage")' value="<%=Util.toScreenToEdit(categoryname,user.getLanguage())%>">
        <span id=categorynameimage></span> 
        <% } else {%>
        <%=Util.toScreen(categoryname,user.getLanguage())%>
        <%}%>
      </TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></td>
      <td class=Field> 
        <% if(canedit) { %>
        <textarea class=inputstyle accesskey="Z" name="categorydesc" cols="60"><%=Util.toScreenToEdit(categorydesc,user.getLanguage())%></textarea>
        <% } else {%>
        <%=Util.toScreen(categorydesc,user.getLanguage())%>
        <%}%>
      </td>
    </tr>
   <TR><TD class=Line colSpan=2></TD></TR> 
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
<script language=javascript>
 function onEdit(){
 	if(check_form(document.frmMain,'categoryname')){
 		document.frmMain.operation.value="editcategory";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="deletecategory";
			document.frmMain.submit();
		}
}
 </script>
</BODY>
</HTML>
