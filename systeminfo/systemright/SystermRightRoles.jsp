<%@ page import="weaver.general.Util,weaver.conn.*" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head><%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage());
String needfav ="1";
String needhelp ="1";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>



<DIV class="HdrTitle">
<TABLE width=100% border=0 cellpadding=0 cellspacing=0>
<TR><TD width=55px align=left><IMG src="images/hdSystem_wev8.gif" height=24px></TD><TD align=left><SPAN ID=BacoTitle style="font-size:medium; font-weight:bold"><%=SystemEnv.getHtmlLabelName(33381, user.getLanguage())%></SPAN></TD><TD align=right>&nbsp;</TD><TD width=5px></TD><TD align=center width="24px"><BUTTON class="btnFavorite" TITLE="Add to favorites" ID=BacoAddFavorite language=VBS ></BUTTON>
<SCRIPT LANGUAGE=VBS>
	Sub BacoAddFavorite_OnClick
		window.external.AddFavorite BacoGetGoPageURL, BacoTitle.InnerText
	End Sub

	Function BacoGetGoPageURL
		Dim i, i2
		Dim s, gopage
		Dim sp: sp = "SystemFunction%2Easp%3FAction%3D1%26ID%3D1"
		If IsEmpty(window.parent) Then 
			s = location.href & ""
		Else	
			s = window.parent.location.href
			If InStr(1,s,"bp.asp",1) > 0 Then
				s = window.parent.location.href
				gopage = "?gopage="
				If InStr(1,s,"?gopage=",1) > 0 Then
					gopage = "&gopage="
				Else
					If InStr(1,s,"?",1) > 0 Then gopage = "&gopage="
				End If
				i = Instr(1, s, "gopage=",1)
				If i > 0 Then
					i2 = Instr(i, s, "&",1) 
					If i2 > 0 Then
						s = Left(s,i-2) & Mid(s, i2, Len(s) - i2) & gopage & sp 
					Else
						s = Left(s,i-2) & gopage & sp 
					End If
				Else
					s = s & gopage & sp 
				End If
			Else
				s = location.href & ""
			End If
		End If
		s = Replace(s,"bp.asp&","bp.asp?",1,1,1)
		BacoGetGoPageURL = s
	End Function
</SCRIPT>
</TD><TD align=center width="24px"><BUTTON class="btnHelp" language=VBS onclick='window.open "BacoHelp.asp?Title=%B9%A6%C4%DC&Topic=SystemFunction.asp&TopicFilter=BACO", null, "width=800,height=500,resizable=yes,scrollbars=yes,status=yes,toolbar=yes,menubar=no,location=no"'></BUTTON></TD></TR>
</TABLE>
</DIV>
<FORM ID=Baco ACTION=SystemFunction.asp?Action=2&ID=1 METHOD=POST>
<DIV>
<BUTTON TYPE=SUBMIT CLASS=btnSave ACCESSKEY="S"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%></BUTTON> 
<BUTTON CLASS=btnNew ID=AddNew ACCESSKEY="N"><U>N</U>-<%=SystemEnv.getHtmlLabelName(21673, user.getLanguage())%></BUTTON> 
<BUTTON CLASS=btnDelete ID=Delete ACCESSKEY="D"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></BUTTON> </DIV>
<SCRIPT LANGUAGE=VBS>
   Sub AddNew_onclick
      location = "SystemFunction.asp?action=0&Product=6"
   End Sub
   Sub Delete_onclick
      If MsgBox("确认: 删除", 4) = 6 Then
         location = "SystemFunction.asp?action=3&ID=1"
      End If
   End Sub
</SCRIPT>
<INPUT type="Hidden" name="PrevAction" value="1">
<TABLE class="Form">
	<COL width="15%">
	<COL width="34%">
	<COL width="24px">
	<COL width="15%">
	<COL width="34%">
	<TR class="Separator">
		<TD class="sep1" colspan="2"></TD>
		<TD></TD>
		<TD class="sep1" colspan="2"></TD>
	</TR>
	<TR>
		<TD>ID</TD>
		<TD class="Field">1</TD>
		<TD></TD>
		<TD><%=SystemEnv.getHtmlLabelName(330, user.getLanguage())%></TD>
		<TD class="Field"><INPUT TYPE=TEXT CLASS=saveHistory NAME=Target SIZE=50 MAXLENGTH=60 VALUE="EPRequest.asp"></TD>
	</TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></TD>
		<TD class="Field"><INPUT TYPE=TEXT CLASS=saveHistory NAME=Description SIZE=60 MAXLENGTH=255 VALUE="Create all request types, irrespective of request-type definition"></TD>
		<TD></TD>
		<TD><%=SystemEnv.getHtmlLabelName(517, user.getLanguage())%></TD>
		<TD class="Field"><INPUT TYPE=CHECKBOX CLASS=saveHistory ID=UseDivisionCheckbox><INPUT TYPE=HIDDEN CLASS=saveHistory NAME=UseDivision VALUE=0>
<SCRIPT LANGUAGE=VBS>
   Sub UseDivisionCheckbox_onclick
      If Baco.UseDivisionCheckbox.Checked Then
         Baco.UseDivision.value = 1
      Else
         Baco.UseDivision.value = 0
      End If
   End Sub
</SCRIPT></TD>
	</TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(101, user.getLanguage())%></TD>
		<TD class="Field"><SELECT ID=Product CLASS=saveHistory NAME=Product><OPTION VALUE="5">CRM</OPTION><OPTION VALUE="1">Documents</OPTION><OPTION VALUE="3">Financial</OPTION><OPTION VALUE="2">HRM</OPTION><OPTION VALUE="4">Logistics</OPTION><OPTION VALUE="6" SELECTED>Procurement</OPTION><OPTION VALUE="7">Project</OPTION><OPTION VALUE="0">System</OPTION></SELECT></TD>
		<TD colspan="3"></TD>
	</TR>
	<TR>
		<TD VALIGN=TOP><%=SystemEnv.getHtmlLabelName(504, user.getLanguage())%></TD>
		<TD><TEXTAREA CLASS=saveHistory NAME=Notes ROWS=8 COLS=60></TEXTAREA></TD>
		<TD colspan="3"></TD>
	</TR>
</TABLE>
</FORM>

<TABLE class="ListShort">
	<TR>
		<TD COLSPAN=2><B><%=SystemEnv.getHtmlLabelName(122, user.getLanguage())%></B></TD>
		<TD ALIGN=right>
			<BUTTON CLASS=Btn ACCESSKEY="1" LANGUAGE=VBS onclick='window.location="SystemRoleFunction.asp?FunctionID=1"' id=button1 name=button1>
				<U>1</U>-<%=SystemEnv.getHtmlLabelName(193, user.getLanguage())%>
			</BUTTON>		
		</TD>
	</TR>
	<TR class="Separator"><TD class="sep1" colspan="3"></TD></TR>
	<TR class="Header">
		<TD><%=SystemEnv.getHtmlLabelName(122, user.getLanguage())%></TD>
		<TD><%=SystemEnv.getHtmlLabelName(460, user.getLanguage())%></TD>
		<TD><%=SystemEnv.getHtmlLabelName(139, user.getLanguage())%></TD>
	</TR>
<TR class=DataLight><TD>11</A></TD><TD><A HREF=SystemRoleFunction.asp?Action=1&ID={2F8B6741-53B0-4303-A8C8-3281E00216CE}>HR Manager</A></TD><TD><%=SystemEnv.getHtmlLabelName(1851, user.getLanguage())%></TD></TR>
</BODY>
</HTML>