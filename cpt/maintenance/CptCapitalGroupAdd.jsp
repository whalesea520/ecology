
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CapitalGroupComInfo" class="weaver.cpt.maintenance.CapitalGroupComInfo" scope="page" />
<% if(!HrmUserVarify.checkUserRight("CptCapitalGroupAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String parentid = Util.null2String(request.getParameter("parentid"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(831,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>
<FORM id=weaver action="/cpt/maintenance/CapitalGroupOperation.jsp" method=post onsubmit='return check_form(this,"name,description")'>
<DIV>
	<BUTTON class=btnSave accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
</DIV>
  <input type="hidden" name="operation" value="add">
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
          <TD class=Field><INPUT class=saveHistory maxLength=50 size=20 name="name" onchange='checkinput("name","nameimage")'><SPAN id=nameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=saveHistory maxLength=150 size=50 name="description" onchange='checkinput("description","descriptionimage")'><SPAN id=descriptionimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
         </TR>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser onclick="onShowCapitalGroupID()"></BUTTON> 
              <SPAN id=parentidspan><%=CapitalGroupComInfo.getCapitalGroupname(parentid)%></SPAN> 
              <INPUT type=hidden name=parentid value=<%=parentid%>>
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
	parentidspan.innerHtml = id(1)
	weaver.parentid.value=id(0)
	else 
	parentidspan.innerHtml = ""
	weaver.parentid.value=""
	end if
	end if
end sub
</script>

</BODY>
</HTML>
