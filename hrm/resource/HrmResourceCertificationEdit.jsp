<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page"/>

<% if(!HrmUserVarify.checkUserRight("HrmResourceCertificationEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
char separator = Util.getSeparator() ;

String paraid = Util.null2String(request.getParameter("paraid")) ;
String certificationid = paraid ;

RecordSet.executeProc("HrmCertification_SelectByID",certificationid);
RecordSet.next();

String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String datefrom = Util.toScreen(RecordSet.getString("datefrom"),user.getLanguage());
String dateto = Util.toScreen(RecordSet.getString("dateto"),user.getLanguage());
String certname = Util.toScreenToEdit(RecordSet.getString("certname"),user.getLanguage());
String awardfrom = Util.toScreenToEdit(RecordSet.getString("awardfrom"),user.getLanguage());

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1502,user.getLanguage());
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
<FORM name=frmain action=HrmResourceCertificationOperation.jsp? method=post>
<DIV>
<BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<% if(HrmUserVarify.checkUserRight("HrmResourceCertificationEdit:Delete", user)){%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>
<BUTTON class=btn id=back accessKey=B onclick="window.history.back(-1)"><U>B</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>

 </DIV>
<input type="hidden" name="operation">
<input type="hidden" name="resourceid" value="<%=resourceid%>">
<input type="hidden" name="certificationid" value="<%=certificationid%>">

  <TABLE class=Form>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
    </TR>
    <TR class=Separator> 
      <TD class=Sep1 colSpan=2></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
      <td class=Field><button class=Calendar type="button" id=selectdatefrom onClick="getDateFrom()"></button> 
        <span id=datefromspan ><%=datefrom%></span> 
        <input type="hidden" name="datefrom" value="<%=datefrom%>">
      </td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
      <td class=Field><button class=Calendar type="button" id=selectdateto onClick="getDateTo()"></button> 
        <span id=datetospan ><%=dateto%></span> 
        <input type="hidden" name="dateto" value="<%=dateto%>">
      </td>
    </tr>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT class=Field maxLength=60 size=30 name="certname" value="<%=certname%>">
      </TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1905,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT class=Field maxLength=100 size=30 name="awardfrom" value="<%=awardfrom%>">
      </TD>
    </TR>
    </TBODY> 
  </TABLE>
</FORM>
<SCRIPT language="javascript">
function OnSubmit(){
   	document.frmain.operation.value="edit";
	document.frmain.submit();
}
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmain.operation.value="delete";
			document.frmain.submit();
		}
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
