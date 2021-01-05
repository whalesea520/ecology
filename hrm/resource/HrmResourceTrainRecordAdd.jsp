<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("HrmResourceTrainRecordAdd:Add",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(816,user.getLanguage());
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
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM name=frmain action="HrmResourceTrainRecordOperation.jsp?" method=post>
<input type="hidden" name="resourceid" value="<%=resourceid%>">
<input type="hidden" name="operation" value="add">
<TABLE class=viewForm>
  <COLGROUP> 
  <COL width="15%"> 
  <COL width="85%">
  <TBODY> 
  <TR class=title> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
  </TR>
  <TR class=spacing style="height:2px"> 
    <TD class=line1 colSpan=2></TD>
  </TR>
  <tr> 
    <td><%=SystemEnv.getHtmlLabelName(1971,user.getLanguage())%></td>
    <td class=Field><button class=Calendar type="button" id=selecttrainstartdate onClick="getTrainstartDate()"></button> 
      <span id=trainstartdatespan ></span> 
      <input type="hidden" name="trainstartdate">
    </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr> 
    <td><%=SystemEnv.getHtmlLabelName(1972,user.getLanguage())%></td>
    <td class=Field><button class=Calendar type="button" id=selecttrainenddate onClick="getTrainendDate()"></button> 
      <span id=trainenddatespan ></span> 
      <input type="hidden" name="trainenddate">
    </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(807,user.getLanguage())%></TD>
    <TD class=Field>

      <INPUT class="wuiBrowser" id=traintype type=hidden name=traintype
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/tools/TrainTypeBrowser.jsp"
	  _required="yes">
    </TD>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <TR> 
    <td id=lblLimit><%=SystemEnv.getHtmlLabelName(1973,user.getLanguage())%></td>
    <td class=Field id=txtLimit> 
      <input class=inputstyle 
            maxlength=16 size=10 value=0 name="trainhour" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("trainhour")'>
    </td>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <td><%=SystemEnv.getHtmlLabelName(1974,user.getLanguage())%></td>
    <td class=Field> 
      <input class=inputstyle maxlength=100 size=30 
            name=trainunit>
    </td>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <TR> 
    <td valign="top"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
    <td class=Field> 
      <textarea class="inputstyle"  style="width:90%" name=trainrecord rows="6"></textarea>
    </td>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
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
<td height="0" colspan="3"></td>
</tr>
</table>
<SCRIPT language=VBS>
sub onShowTrainType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/tools/TrainTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	traintypespan.innerHtml = id(1)
	frmain.traintype.value=id(0)
	else 
	traintypespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmain.traintype.value="" 
	end if
	end if
end sub

</SCRIPT>

<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.forms[0],"traintype"))
	{	
		document.forms[0].submit();
	}
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
