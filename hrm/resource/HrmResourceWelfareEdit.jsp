<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
char separator = Util.getSeparator() ;

String paraid = Util.null2String(request.getParameter("paraid")) ;
String welfareid = paraid ;

RecordSet.executeProc("HrmWelfare_SelectByID",welfareid);
RecordSet.next();

String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String datefrom = Util.toScreen(RecordSet.getString("datefrom"),user.getLanguage());
String dateto = Util.toScreen(RecordSet.getString("dateto"),user.getLanguage());
String basesalary = Util.toScreenToEdit(RecordSet.getString("basesalary"),user.getLanguage());
String homesub = Util.toScreenToEdit(RecordSet.getString("homesub"),user.getLanguage());
String vehiclesub = Util.toScreenToEdit(RecordSet.getString("vehiclesub"),user.getLanguage());
String mealsub = Util.toScreenToEdit(RecordSet.getString("mealsub"),user.getLanguage());
String othersub = Util.toScreenToEdit(RecordSet.getString("othersub"),user.getLanguage());
String adjustreason = Util.toScreenToEdit(RecordSet.getString("adjustreason"),user.getLanguage());

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1504,user.getLanguage());
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
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<FORM name=frmain action=HrmResourceWelfareOperation.jsp? method=post>
<input type="hidden" name="operation">
<input type="hidden" name="resourceid" value="<%=resourceid%>">
<input type="hidden" name="welfareid" value="<%=welfareid%>">

  <TABLE class=viewForm>
    <COLGROUP> 
    <COL width="15%"> 
    <COL width="85%"><TBODY> 
    <TR class=title> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=2></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
      <td class=Field><button class=Calendar type="button" id=selectdatefrom onClick="getDateFrom()"></button> 
        <span id=datefromspan ><%=datefrom%></span> 
        <input type="hidden" name="datefrom" value="<%=datefrom%>">
      </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
      <td class=Field><button class=Calendar type="button" id=selectdateto onClick="getDateTo()"></button> 
        <span id=datetospan ><%=dateto%></span> 
        <input type="hidden" name="dateto" value="<%=dateto%>">
      </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
            <td id=lblLimit><%=SystemEnv.getHtmlLabelName(1893,user.getLanguage())%></td>
            <td class=Field id=txtLimit> 
              <input class=inputstyle  
             maxlength=16 size=10  name="basesalary" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("basesalary")' value="<%=basesalary%>">
            </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
	<tr> 
            
      <td id=lblLimit><%=SystemEnv.getHtmlLabelName(1894,user.getLanguage())%></td>
            <td class=Field id=txtLimit> 
              <input class=inputstyle 
            maxlength=16 size=10 value="<%=homesub%>" name="homesub" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("homesub")'>
            </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
	<tr> 
            
      <td id=lblLimit><%=SystemEnv.getHtmlLabelName(1895,user.getLanguage())%></td>
            <td class=Field id=txtLimit> 
              <input class=inputstyle 
            maxlength=16 size=10 value="<%=vehiclesub%>" name="vehiclesub" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("vehiclesub")'>
            </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
	<tr> 
            
      <td id=lblLimit><%=SystemEnv.getHtmlLabelName(1896,user.getLanguage())%></td>
            <td class=Field id=txtLimit> 
              <input class=inputstyle 
            maxlength=16 size=10 value="<%=mealsub%>" name="mealsub" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("mealsub")'>
            </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
	<tr> 
            
      <td id=lblLimit><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></td>
            <td class=Field id=txtLimit> 
              <input class=inputstyle 
            maxlength=16 size=10 value="<%=othersub%>" name="othersub" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("othersub")'>
            </td>
    </tr>
		  <TR><TD class=Line colSpan=2></TD></TR> 
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1897,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT class=inputstyle maxLength=200 size=30 name="adjustreason" value="<%=adjustreason%>">
      </TD>
    </TR>
    <TR><TD class=line colSpan=2></TD></TR> 
    </TBODY> 
  </TABLE>
</FORM>
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
function submitData() {
"window.history.back(-1);
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>