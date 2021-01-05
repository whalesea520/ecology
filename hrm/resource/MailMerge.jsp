<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
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
int id= Util.getIntValue(request.getParameter("id"));
int applyid=Util.getIntValue(request.getParameter("applyid"),0);
String issearch = Util.null2String(request.getParameter("issearch"));
int pagenum=Util.getIntValue(request.getParameter("pagenum"),0);

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class="HdrProps">&nbsp;</DIV>

<FORM NAME=weaver action="SendMail.jsp">
<BUTTON accesskey=M CLASS=Btn TYPE=SUBMIT ID=btnMerge NAME=btnMerge><U>M</U>-<%=SystemEnv.getHtmlLabelName(1226,user.getLanguage())%></BUTTON>
<BUTTON accesskey=T CLASS=BtnReset ID=ResetForm><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>

<INPUT TYPE="hidden" NAME="Action" VALUE="1">

<INPUT TYPE=Hidden ID=Type NAME=Type VALUE=1></INPUT>
<TABLE CLASS="Form">
<COL WIDTH="25%"><COL WIDTH="75%">
  <TR CLASS="Section"><TH COLSPAN="2"><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH></TR>  
  <TR><TD COLSPAN="2" CLASS="Sep1"></TD></TR>

<TR>
	<TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
	<TD Class=Field><INPUT TYPE=TEXT ID=subject NAME=subject SIZE=100 MAXLENGTH=255></INPUT></TD>
  </TR>  
 <TR>

 <tr>
	<TD><%=SystemEnv.getHtmlLabelName(1260,user.getLanguage())%></TD>
	<TD Class=Field><INPUT TYPE=TEXT ID=from NAME=from SIZE=80 MAXLENGTH=255 value=<%=user.getEmail()%>></INPUT></TD>
  </TR>  

 <TR> 
   	<TD><%=SystemEnv.getHtmlLabelName(1264,user.getLanguage())%></TD>
	<TD Class=Field>
		<BUTTON class=Browser ID=SelectLayout name=SelectLayout onclick="showMailMould()"> </BUTTON>
		<SPAN ID=DisplayLayout></SPAN>
		<INPUT TYPE=HIDDEN ID=mailid NAME="mailid" ></INPUT>	
	</TD>	
</TR>
<tr id="needhidd" style="display:''"><td><%=SystemEnv.getHtmlLabelName(1265,user.getLanguage())%></td></tr>
<tr id="needhidden" style="display:''"><td>&nbsp</td>
	<td  class=Field > 
    <textarea class=saveHistory style="WIDTH: 100%" id=selfComment name=selfComment size=80 rows=15></textarea>
    </td>
</tr>

<input type=hidden name=id value="<%=id%>">
<input type=hidden name=issearch value="<%=issearch%>">
<input type=hidden name=applyid value="<%=applyid%>">
<input type=hidden name=pagenum value="<%=pagenum%>">
         
</TABLE>
       
</FORM>
<script language=vbs>
sub showMailMould()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/mail/DocMouldBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "0" then
			DisplayLayout.innerHtml = "<A href='/docs/mail/DocMouldDsp.jsp?id="&id(0)&"'>"&id(1)&"</A>"
			weaver.mailid.value=id(0)
			needhidd.style.display="none"
			needhidden.style.display="none"
		else 
			DisplayLayout.innerHtml =""
			weaver.mailid.value=""
			needhidd.style.display=""
			needhidden.style.display=""	
		end if
	end if
end sub
</script>