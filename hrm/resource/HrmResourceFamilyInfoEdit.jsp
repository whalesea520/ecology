<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
char separator = Util.getSeparator() ;
boolean canedit = HrmUserVarify.checkUserRight("HrmResourceFamilyInfoEdit:Edit", user) ;
String paraid = Util.null2String(request.getParameter("paraid")) ;
String familyinfoid = paraid ;

RecordSet.executeProc("HrmFamilyInfo_SelectByID",familyinfoid);
RecordSet.next();

String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String member = Util.toScreenToEdit(RecordSet.getString("member"),user.getLanguage());
String title = Util.toScreenToEdit(RecordSet.getString("title"),user.getLanguage());
String company = Util.toScreenToEdit(RecordSet.getString("company"),user.getLanguage());
String jobtitle = Util.toScreenToEdit(RecordSet.getString("jobtitle"),user.getLanguage());
String address = Util.toScreenToEdit(RecordSet.getString("address"),user.getLanguage());

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(814,user.getLanguage());
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
<FORM name=frmain action=HrmResourceFamilyInfoOperation.jsp? method=post>
<%if(canedit){%>
<DIV>
<BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<% }
if(HrmUserVarify.checkUserRight("HrmResourceFamilyInfoEdit:Delete", user)){
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>
 </DIV>
<input type="hidden" name="operation">
<input type="hidden" name="resourceid" value="<%=resourceid%>">
<input type="hidden" name="familyinfoid" value="<%=familyinfoid%>">

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
	   <%if(canedit){%>
        <INPUT class=saveHistory maxLength=30 size=10 name=member value="<%=member%>">
		 <%} else {%>
		<%=member%>
		<%}%>
      </TD>
    </TR>
    
   <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1944,user.getLanguage())%></TD>
      <TD class=Field>
	   <%if(canedit){%>
        <INPUT class=saveHistory maxLength=30 size=10 name=title value="<%=title%>">
		 <%} else {%>
		<%=title%>
		<%}%>
      </TD>
    </TR>

	<TR> 
      <TD><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
      <TD class=Field>
	   <%if(canedit){%>
        <INPUT class=saveHistory maxLength=30 size=10 name=jobtitle value="<%=jobtitle%>">
		 <%} else {%>
		<%=jobtitle%>
		<%}%>
      </TD>
    </TR>

	<TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1914,user.getLanguage())%></TD>
      <TD class=Field>
	   <%if(canedit){%>
        <INPUT class=saveHistory maxLength=100 size=30 name=company value="<%=company%>">
		 <%} else {%>
		<%=company%>
		<%}%>
      </TD>
    </TR>

	<TR> 
      <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></TD>
      <TD class=Field>
	   <%if(canedit){%>
        <INPUT class=saveHistory maxLength=100 size=30 name=address value="<%=address%>">
		 <%} else {%>
		<%=address%>
		<%}%>
      </TD>
    </TR>
 
    </TBODY> 
  </TABLE>
</FORM>

<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.frmain,"member,title"))
	{	
		document.frmain.operation.value="edit";
		document.frmain.submit();
	}
}
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmain.operation.value="delete";
			document.frmain.submit();
		}
}
</script>

</BODY></HTML>
