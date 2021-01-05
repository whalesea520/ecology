
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(71,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    int customerid= Util.getIntValue(request.getParameter("customerid"));
    String[] choice = request.getParameterValues("choice");
    String issearch = Util.null2String(request.getParameter("issearch"));
    int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);

    String defmailserver = SystemComInfo.getDefmailserver() ;
    String defmailfrom = SystemComInfo.getDefmailfrom() ;
    String defneedauth = SystemComInfo.getDefneedauth() ;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1226,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">

<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			<% if( defmailserver.equals("") ) {%>
			<font color=red><%=SystemEnv.getHtmlLabelName(18902,user.getLanguage())%></font><br>
			<%}%>
			<% if( defneedauth.equals("1") && defmailfrom.equals("") ) {%>
			<font color=red><%=SystemEnv.getHtmlLabelName(18904,user.getLanguage())%></font>
			<%}%>

			<FORM ID=weaver NAME=weaver action="/sendmail/CrmSendMail.jsp">

			<INPUT TYPE="hidden" NAME="Action" VALUE="1">

			<INPUT TYPE=Hidden ID=Type NAME=Type VALUE=1></INPUT>
			<TABLE class=ViewForm>
			<COL WIDTH="35%"><COL WIDTH="65%">
			  <TR class=Title><TH COLSPAN="2"><%=SystemEnv.getHtmlLabelName(18905,user.getLanguage())%></TH></TR>
			  <TR style="height:2px"><TD COLSPAN="2" class=Line1></TD></TR>

			 <TR>
				<TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
				<TD Class=Field><INPUT TYPE=TEXT ID=subject NAME=subject class="InputStyle" SIZE=80 MAXLENGTH=255  onchange='checkinput("subject","subjectimage")'><SPAN id=subjectimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
			  </TR>
			  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
			  <% if( defneedauth.equals("1")) { %>
				<INPUT TYPE=hidden ID=from NAME=from value="<%=defmailfrom%>">
			  <% } else { %>
			  <tr>
				<TD><%=SystemEnv.getHtmlLabelName(1260,user.getLanguage())%></TD>
				<TD Class=Field>
				<INPUT TYPE=TEXT ID=from NAME=from class="InputStyle" SIZE=80 MAXLENGTH=255 value=<%=user.getEmail()%>>
				</TD>
			  </TR>
			  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
			  <%}%>
				<TR><TD><%=SystemEnv.getHtmlLabelName(1261,user.getLanguage())%></TD>
					<TD CLASS=Field >
					<INPUT TYPE=RADIO ID=sendto NAME=sendto VALUE=1 CHECKED ><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></INPUT>
					<INPUT TYPE=RADIO ID=sendto NAME=sendto VALUE=2><%=SystemEnv.getHtmlLabelName(1262,user.getLanguage())%></INPUT>
					<INPUT TYPE=RADIO ID=sendto NAME=sendto VALUE=3><%=SystemEnv.getHtmlLabelName(1263,user.getLanguage())%></INPUT>
					</td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <TR>
				<TD><%=SystemEnv.getHtmlLabelName(18530,user.getLanguage())%></TD>
                <TD Class=Field>
                    <BUTTON class=calendar type="button" id=SelectDate onclick="getDate(fromdatespan,fromdate)"></BUTTON>&nbsp;
                    <SPAN id=fromdatespan ></SPAN>
                    <input type="hidden" name="fromdate" value="">&nbsp&nbsp&nbsp&nbsp
                    <BUTTON class=calendar type="button" id=SelectTime onclick="getDate(fromtimespan,fromtime)"></BUTTON>&nbsp;
                    <SPAN id=fromtimespan ></SPAN>
                    <input type="hidden" name="fromtime" value="">
                </TD>
              </tr>
              <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<TR id="mailidtr">
					<TD><%=SystemEnv.getHtmlLabelName(18906,user.getLanguage())%></TD>
					<TD Class=Field>
						
						<INPUT class="wuiBrowser" TYPE=HIDDEN ID=mailid NAME="mailid" 
						_url="/systeminfo/BrowserMain.jsp?url=/docs/mail/DocMouldBrowser.jsp"
						_displayTemplate="<A target='_blank' href='/docs/mail/DocMouldDsp.jsp?id=#b{id}'>#b{name}</A>"></INPUT>
					</TD>
				</TR>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<TR id="inprepidtr">
					<TD><%=SystemEnv.getHtmlLabelName(18907,user.getLanguage())%></TD>
					<TD Class=Field>
						
						<INPUT class="wuiBrowser" TYPE=HIDDEN ID=inprepid NAME="inprepid" value=""
						_url="/systeminfo/BrowserMain.jsp?url=/sendmail/SendMailBrowser.jsp"></INPUT>
					</TD>
				</TR>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr id="selfcommenttr"><td><%=SystemEnv.getHtmlLabelName(18908,user.getLanguage())%></td>
					<td  class=Field >
					<textarea style="WIDTH: 100%" id=selfComment name=selfComment class="InputStyle" size=80 rows=15></textarea>
					</td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>


			<input type=hidden name=customerid value="<%=customerid%>">
			<input type=hidden name=pagenum value="<%=pagenum%>">
			<input type=hidden name=issearch value="<%=issearch%>">

			</TABLE>
			<%
			if( choice != null ) {
				String crmid = "";
				for(int i=0; i<choice.length;i++){
					crmid = choice[i];
			%>
			<input type="hidden" name="choice" value="<%=crmid%>" >
			<%
				}
			}
			%>
			</FORM>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>

</table>

</BODY>
</HTML>
<script language=vbs>
sub showMailMould()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/mail/DocMouldBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "0" then
			DisplayLayout.innerHtml = "<A href='/docs/mail/DocMouldDsp.jsp?id="&id(0)&"'>"&id(1)&"</A>"
			weaver.mailid.value=id(0)
            inprepidspan.innerHtml=""
            weaver.inprepid.value = ""
			selfcommenttr.style.display="none"
            inprepidtr.style.display="none"
		else
			DisplayLayout.innerHtml =""
			weaver.mailid.value=""
			selfcommenttr.style.display=""
            inprepidtr.style.display=""
		end if
	end if
end sub

sub showInprepId(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/sendmail/SendMailBrowser.jsp")
	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            spanname.innerHtml = id(1)
            inputname.value=id(0)
            DisplayLayout.innerHtml=""
            weaver.mailid.value = ""
            selfcommenttr.style.display="none"
            mailidtr.style.display="none"
        else
            spanname.innerHtml = ""
            inputname.value=""
            selfcommenttr.style.display=""
            mailidtr.style.display=""
        end if
	end if
end sub
</script>
<script language="javascript">
 function onSubmit(){
    if(check_form(weaver,'subject')){
	    document.weaver.submit();
    }
 }
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>