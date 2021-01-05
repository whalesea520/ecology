<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("HrmResourceFamilyInfoAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid = Util.null2String(request.getParameter("resourceid")) ;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(814,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM name=frmain action="HrmResourceFamilyInfoOperation.jsp?"Action=2 method=post>
  <DIV><BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON> </DIV>

<input type="hidden" name="resourceid" value="<%=resourceid%>">
<input type="hidden" name="operation" value="add">

  <TABLE class=Form>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
  <TR class=Section> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
  </TR>
    <TR class=Separator> 
      <TD class=Sep1 colSpan=2></TD>
    </TR>
  <TR> 
  <TD><%=SystemEnv.getHtmlLabelName(1943,user.getLanguage())%></TD>
	  <TD class=Field> 
              <INPUT class=Field maxLength=30 size=10 name="member"
            onchange='checkinput("member","memberimage")'>
              <SPAN id=memberimage><IMG 
            src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
    </TR>
   <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1944,user.getLanguage())%></TD>
	  <TD class=Field> 
              <INPUT class=Field maxLength=30 size=10 name="title"
            onchange='checkinput("title","titleimage")'>
              <SPAN id=titleimage><IMG 
            src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
    </TR>
	
	<TR> 
      <TD><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
	  <TD class=Field> 
              <INPUT class=Field maxLength=100 size=10 name="jobtitle">
              </TD>
    </TR>
	<TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1914,user.getLanguage())%></TD>
	  <TD class=Field> 
              <INPUT class=Field maxLength=100 size=60 name="company">
              </TD>
    </TR>
	<TR> 
      <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></TD>
	  <TD class=Field> 
              <INPUT class=Field maxLength=100 size=60 name="address">
      </TD>
    </TR>
    </TBODY> 
  </TABLE>
</FORM>


<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.frmain,"member,title"))
	{	
		document.frmain.submit();
	}
}
</script>

</BODY></HTML>
