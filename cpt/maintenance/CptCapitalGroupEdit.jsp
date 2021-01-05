
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%
boolean canedit = HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Edit",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTemp" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalGroupComInfo" class="weaver.cpt.maintenance.CapitalGroupComInfo" scope="page" />
<%
	String id = request.getParameter("id");

	RecordSet.executeProc("CptCapitalGroup_SelectByID",id);

	RecordSet.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(831,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>

<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>

<FORM id=weaver action="/cpt/maintenance/CapitalGroupOperation.jsp" method=post onsubmit='return check_form(this,"name,description")'>
<DIV>
<%
if(HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Edit", user)){
%>
	<BUTTON class=btnSave accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%
}
if(HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Delete", user)){
%>
	<BUTTON class=btnDelete id=Delete accessKey=D onclick='if(isdel()){location.href="/cpt/maintenance/CapitalGroupOperation.jsp?operation=delete&id=<%=id%>"}'><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}
%>
</DIV>
<input type="hidden" name="operation" value="edit">
<input type="hidden" name="id" value="<%=id%>">
<TABLE class=form>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=Form>
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
        <TR class=Section>
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class=separator>
          <TD class=Sep1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=saveHistory maxLength=50 size=20 name="name" onchange='checkinput("name","nameimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>"><SPAN id=nameimage></SPAN><%}else {%><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%><%}%></TD>
        </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=saveHistory maxLength=150 size=50 name="description" onchange='checkinput("description","descriptionimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"><SPAN id=descriptionimage></SPAN><%}else {%><%=Util.toScreen(RecordSet.getString("description"),user.getLanguage())%><%}%></TD>
         </TR>  
		<TR>
<%
boolean flag = true;
String sql = "select * from CptCapitalGroup where parentid = "+id;
RecordSetTemp.executeSql(sql);
flag=RecordSetTemp.next();
%>
          <TD><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit&&!flag) {%>
          <BUTTON class=Browser onclick="onShowCapitalGroupID()"></BUTTON> 
              <SPAN id=Sectorspan><%=CapitalGroupComInfo.getCapitalGroupname(RecordSet.getString("parentid"))%></SPAN> 
              <INPUT type=hidden name=parentid value=<%=RecordSet.getString("parentid")%>>
		<%}else {%>
		<%=Util.toScreen(CapitalGroupComInfo.getCapitalGroupname(RecordSet.getString("parentid")),user.getLanguage())%>
		<%}%>
			  </TD>
         </TR>       
	   </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
</FORM>

<script language=vbs>
sub onShowCapitalGroupID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalGroupBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Sectorspan.innerHtml = id(1)
	weaver.parentid.value=id(0)
	else 
	Sectorspan.innerHtml = ""
	weaver.parentid.value=""
	end if
	end if
end sub
</script>

</BODY>
</HTML>
