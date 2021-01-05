<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MailMouldComInfo" class="weaver.docs.mail.MailMouldComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);
rs.executeProc("T_SurveyItem_SelectByInprepid",""+inprepid);
rs.next() ;

String inprepname = Util.toScreenToEdit(rs.getString("inprepname"),user.getLanguage()) ;
String inpreptablename = Util.null2String(rs.getString("inpreptablename")) ;
String mailid = Util.null2String(rs.getString("mailid")) ;
String urlname = Util.null2String(rs.getString("urlname")) ;
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16246,user.getLanguage())+ inprepname;
String needfav ="1";
String needhelp ="";
String sql = "" ;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='InputReportAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15196,user.getLanguage())+",javascript:location='BuildHtml.jsp?inprepid="+inprepid+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

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
<FORM id=weaver name=frmMain action="InputReportOperation.jsp" method=post>

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15197,user.getLanguage())%></TH>
    </TR>
  <TR class=Spacing>
    <TD class=Line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15189,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=text class=InputStyle size=50 name="inprepname" onchange='checkinput("inprepname","inprepnameimage")' value="<%=inprepname%>"> 
          <SPAN id=inprepnameimage></SPAN></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15186,user.getLanguage())%></TD>
          <TD class=Field><%=inpreptablename%></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15193,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=text  class=InputStyle  size=40 name="urlname" onchange='checkinput("urlname","urlnameimage")' value="<%=urlname%>"> 
          <SPAN id=urlnameimage></SPAN><%=SystemEnv.getHtmlLabelName(15194,user.getLanguage())%>：www.e-cology.com.cn</TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15198,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser ID=SelectLayout name=SelectLayout onclick="showMailMould()"> </BUTTON>
		  <SPAN ID=DisplayLayout><%=Util.toScreen(MailMouldComInfo.getMailMouldname(mailid),user.getLanguage())%></SPAN>
		  <INPUT TYPE=HIDDEN ID=mailid NAME="mailid" value="<%=mailid%>" ></INPUT></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        
        <input type="hidden" name=operation>
        <input type="hidden" name=inpreptablename value="<%=inpreptablename%>">
		<input type=hidden name=inprepid value="<%=inprepid%>">
 </TBODY></TABLE>
  <br>
  <table class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="40%">
  <COL width="30%">
  <COL width="30%">
    <tbody> 
    <tr class=header>
      <td colspan=2><b><%=SystemEnv.getHtmlLabelName(15199,user.getLanguage())%></b></td>
      <td align=right colspan=3>
	  <button class=btn accessKey=I onClick="location.href='InputReportItemAdd.jsp?inprepid=<%=inprepid%>'"><U>I</U>-<%=SystemEnv.getHtmlLabelName(15200,user.getLanguage())%></button>
      </td>
    </tr>

    <tr class=Header> 
      <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
	  <td><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>
    </tr>
<TR class=Line><TD colSpan=3></TD></TR>
    <%
	int i = 0 ;
	sql = "select * from T_fieldItem where inprepid ="+inprepid +" order by itemid" ;
    rs1.executeSql(sql);
	while(rs1.next()) {
        String itemid = Util.null2String(rs1.getString("itemid")) ;
		String itemdspname = Util.toScreen(rs1.getString("itemdspname"),user.getLanguage()) ;
		String itemfieldname = Util.null2String(rs1.getString("itemfieldname")) ;
		String itemfieldtype = Util.null2String(rs1.getString("itemfieldtype")) ;
		

  	if(i==0){
  		i=1;
  	%>
    <tr class=datalight> 
      <%}else{
  		i=0;
  	%>
    <tr class=datadark> 
    <% }%>
      <td><a href="InputReportItemEdit.jsp?itemid=<%=itemid%>"><%=itemdspname%></a></td>
      <td><%=itemfieldname%></td>
	  <td>
	    <% if(itemfieldtype.equals("1")) { %><%=SystemEnv.getHtmlLabelName(15201,user.getLanguage())%>
		<%} else if(itemfieldtype.equals("2")) { %><%=SystemEnv.getHtmlLabelName(15202,user.getLanguage())%>
		<%} else if(itemfieldtype.equals("3")) { %><%=SystemEnv.getHtmlLabelName(15203,user.getLanguage())%>
		<%} else if(itemfieldtype.equals("4")) { %><%=SystemEnv.getHtmlLabelName(15204,user.getLanguage())%>
        <%} else if(itemfieldtype.equals("5")) { %><%=SystemEnv.getHtmlLabelName(15205,user.getLanguage())%>
        <%} else if(itemfieldtype.equals("6")) { %><%=SystemEnv.getHtmlLabelName(15206,user.getLanguage())%><%}%>
	  </td>
    </tr>
	<%}%>
    </tbody>
  </table>
  
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language=vbs>
sub showMailMould()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/mail/DocMouldBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "0" then
			DisplayLayout.innerHtml = "<A href='/docs/mail/DocMouldDsp.jsp?id="&id(0)&"'>"&id(1)&"</A>"
			weaver.mailid.value=id(0)
		else 
			DisplayLayout.innerHtml =""
			weaver.mailid.value=""
		end if
	end if
end sub
</script>

<script language=javascript>
 function onSave(){
	if(check_form(document.frmMain,'inprepname')){
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
