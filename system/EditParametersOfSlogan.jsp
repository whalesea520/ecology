<% if(!HrmUserVarify.checkUserRight("ParametersOfSlogan:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
RecordSet.executeProc("Sys_Slogan_Select","");
RecordSet.next();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String message = Util.null2String(request.getParameter("message")) ;
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(229,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<FORM id=weaver name=weaver action="/system/ParametersOfSloganOperation.jsp" method=post onsubmit='return check_form(this,"type,desc")'>
<DIV>
	<BUTTON class=btnSave accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
</DIV>
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
          <TD><%=SystemEnv.getHtmlLabelName(2074,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=saveHistory maxLength=150 size=50 name="content" onchange='checkinput("content","contentimage")' value="<%=RecordSet.getString(1)%>"><SPAN id=contentimage></SPAN></TD>
         </TR>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2075,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=saveHistory maxLength=1 size=5 name="speed" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("speed");checkinput("speed","speedimage")' value="<%=RecordSet.getInt(2)%>"><SPAN id=speedimage></SPAN></TD>
        </TR>
	<TR>
	<TD><%=SystemEnv.getHtmlLabelName(2076,user.getLanguage())%></TD>
	<TD class=field>
		<TABLE border=0 cellspacing=0 cellpadding=0>
		<TR>
			<TD><INPUT TYPE=hidden Name="colorid1" value="<%=RecordSet.getString(3)%>"></INPUT></TD>
			<TD><BUTTON CLASS=Browser ID=SelectColor1>&nbsp;</BUTTON></TD>
			<TD>
			<TABLE border=1 cellspacing=0 cellpadding=0 bordercolor=black>
			<TR><TD STYLE="border:1px" ID=SelectedColor1 BGCOLOR="<%=RecordSet.getString(3)%>">&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>
			</TABLE>
			<SCRIPT LANGUAGE=VBS>
		Sub SelectColor1_onclick
		   id = window.showModalDialog("/systeminfo/ColorBrowser.jsp")
		   
		   If IsNull(id) Then
		      document.weaver.colorid1.value = ""
		   ElseIf Not IsEmpty(id) Then
		      document.weaver.colorid1.value = id
		      'document.weaver.colorid1.innerText = id
		      SelectedColor1.bgColor = id
		   End If
		End Sub
		</SCRIPT>
			</TD>
		</TR>
		</TABLE>
	</TD>
      </TR>
	<TR>
	<TD><%=SystemEnv.getHtmlLabelName(2077,user.getLanguage())%></TD>
	<TD class=field>
		<TABLE border=0 cellspacing=0 cellpadding=0>
		<TR>
			<TD><INPUT TYPE=hidden Name="colorid2" value="<%=RecordSet.getString(4)%>"></INPUT></TD>
			<TD><BUTTON CLASS=Browser ID=SelectColor2>&nbsp;</BUTTON></TD>
			<TD>
			<TABLE border=1 cellspacing=0 cellpadding=0 bordercolor=black>
			<TR><TD STYLE="border:1px" ID=SelectedColor2 BGCOLOR="<%=RecordSet.getString(4)%>">&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>
			</TABLE>
			<SCRIPT LANGUAGE=VBS>
		Sub SelectColor2_onclick
		   id = window.showModalDialog("/systeminfo/ColorBrowser.jsp")
		   
		   If IsNull(id) Then
		      document.weaver.colorid2.value = ""
		   ElseIf Not IsEmpty(id) Then
		      document.weaver.colorid2.value = id
		      'document.weaver.colorid2.innerText = id
		      SelectedColor2.bgColor = id
		   End If
		End Sub
		</SCRIPT>
			</TD>
		</TR>
		</TABLE>
	</TD>
      </TR>
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
</FORM>

</BODY>
</HTML>
