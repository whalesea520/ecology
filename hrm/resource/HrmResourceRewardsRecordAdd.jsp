<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("HrmResourceRewardsRecordAdd:Add",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(817,user.getLanguage());
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
<FORM name=frmain action="HrmResourceRewardsRecordOperation.jsp?"Action=2 method=post>
<input class=inputstyle type="hidden" name="resourceid" value="<%=resourceid%>">
<input class=inputstyle type="hidden" name="operation" value="add">
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
        <td><%=SystemEnv.getHtmlLabelName(1962,user.getLanguage())%></td>
          <td class=Field><button class=Calendar type="button" id=selectrewardsdate onClick="getRewardsDate()"></button> 
              <span id=rewardsdatespan ></span> 
              <input class=inputstyle type="hidden" name="rewardsdate">
          </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
   	<TR> 
      <TD><%=SystemEnv.getHtmlLabelName(808,user.getLanguage())%></TD>
       <TD class=Field>

              <INPUT class="wuiBrowser" id=rewardstype type=hidden name=rewardstype
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/tools/RewardsTypeBrowser.jsp"
			  _required="yes">
       </TD>
    </TR>
	<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <TR> 
      <TD valign="top"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
      <TD class=Field> 
        <textarea class="inputStyle"  style="width:90%" name=remark rows="6"></textarea>
      </TD>
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
sub onShowRewardsType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/tools/RewardsTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	rewardstypespan.innerHtml = id(1)
	frmain.rewardstype.value=id(0)
	else 
	rewardstypespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmain.rewardstype.value="" 
	end if
	end if
end sub

</SCRIPT>
<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.forms[0],"rewardstype"))
	{	
		document.forms[0].submit();
	}
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
