<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaIndicatorAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if (true) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String indicatorname = Util.null2String(request.getParameter("indicatorname1")) ;
String indicatordesc = Util.null2String(request.getParameter("indicatordesc1")) ;
String indicatortype = Util.null2String(request.getParameter("indicatortype1")) ;
String indicatorbalance = Util.null2String(request.getParameter("indicatorbalance")) ;
String haspercent = Util.null2String(request.getParameter("haspercent")) ;
if(indicatortype.equals("")) indicatortype ="0" ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(564,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
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


<FORM id=frmMain action=FnaIndicatorOperation.jsp method=post>
 <input class=inputstyle type=hidden name=operation value="addindicator">
  <TABLE class=ViewForm>
  <TBODY>
  <TR>
    <TH class=Title align=left><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
  <TR class=Spacing style="height: 1px;">
    <TD class=Line1 colSpan=4></TD></TR></TBODY></TABLE>
  <TABLE class=ViewForm id=tblScenarioCode>
    <THEAD> <COLGROUP> <COL width="15%"> <COL width="33%"> <COL width="6%"> <COL width="15%"> <COL width="32%"></THEAD> 
    <TBODY> 
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class=FIELD> 
        <INPUT class=inputstyle id=indicatorname name=indicatorname maxlength="20" onchange='checkinput("indicatorname","indicatornameimage")' size="15" value="<%=indicatorname%>">
        <SPAN id=indicatornameimage> 
        <% if(indicatorname.equals("")) {%>
        <IMG src="/images/BacoError_wev8.gif" align=absMiddle> 
        <%}%>
        </SPAN></TD>
		<TD></TD>
      <TD> 
        <% if(indicatortype.equals("0")) {%>
        <%=SystemEnv.getHtmlLabelName(1463,user.getLanguage())%> 
        <%} else if(indicatortype.equals("2")){%>
        <%=SystemEnv.getHtmlLabelName(1464,user.getLanguage())%> 
        <%}%>
      </TD>
      <TD <% if(indicatortype.equals("0") || indicatortype.equals("2")) {%> class=field <%}%>> 
        <% if(indicatortype.equals("0")) {%>
        <select class=inputstyle id=indicatorbalance name=indicatorbalance>
          <option value=1 <%if(indicatorbalance.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(566,user.getLanguage())%></option>
          <option value=2 <%if(indicatorbalance.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(629,user.getLanguage())%></option>
        </select>
        <%} else if(indicatortype.equals("2")){%>
        <input type="checkbox" name="haspercent" value="1" <%if(haspercent.equals("1")) {%> checked <%}%>>
        <%}%>
      </TD>
    </TR>
	<!--added by lupeng 2004.05.13 for TD451.-->  
    <TR style="height: 1px;"><TD class=Line colSpan=2></TD><TD></TD><TD class=Line colSpan=2></TD></TR>
	<!--end-->
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
      <td class=FIELD><nobr> 
        <input class=inputstyle id=indicatordesc name=indicatordesc maxlength="100" onChange='checkinput("indicatordesc","indicatordescimage")' size="30" value="<%=indicatordesc%>">
        <span id=indicatordescimage> 
        <% if(indicatordesc.equals("")) {%>
        <img src="/images/BacoError_wev8.gif" align=absMiddle> 
        <%}%>
        </span></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
	<!--added by lupeng 2004.05.13 for TD451.-->  
    <TR style="height: 1px;"><TD class=Line colSpan=2></TD><TD colSpan=3></TD></TR>
	<!--end-->
    <!--tr> 
      <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
      <td class=FIELD> 
        <select class=inputstyle id=indicatortype name=indicatortype onchange="onChange()">
          <option value=0 <%if(indicatortype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></option>
          <option value=1 <%if(indicatortype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
          <option value=2 <%if(indicatortype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(449,user.getLanguage())%></option>
        </select>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr -->
    <input class=inputstyle type="hidden" id=indicatortype name=indicatortype value="0">

    <% if(indicatortype.equals("2")) {%>
    <tr class=Title> 
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(449,user.getLanguage())%></TH>
    </tr>
	<TR CLASS=Seperator><TD COLSPAN=4 CLASS="sep2"></TD></TR>
    <TR> 
      <TD>&nbsp;</TD>
      <TD>
        <table width="100%">
          <colgroup> <col width="48%"> <col align=middle width="4%"> <col width="48%"> 
          <tbody> 
          <tr> 
            <td class=FIELD><button class=Browser id=SelectIndicator onClick="onShowIndicator(indicatoridfirstspan,indicatoridfirst)"></button> 
	 		<span class=inputstyle id=indicatoridfirstspan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span> 
             <input id=indicatoridfirst type=hidden name=indicatoridfirst>
            </td>
            <td>/ </td>
            <td class=FIELD><button class=Browser id=SelectIndicator onClick="onShowIndicator(indicatoridlastspan,indicatoridlast)"></button> 
	 		<span class=inputstyle id=indicatoridlastspan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span> 
             <input id=indicatoridlast type=hidden name=indicatoridlast>
            </td>
          </tr>
          </tbody>
        </table>
      </TD>
      <TD>&nbsp;</TD>
      <TD>&nbsp;</TD>
    </TR>
<%}%>
    </TBODY> 
  </TABLE>
</FORM>
<FORM id=changsubmit name=changsubmit action=FnaIndicatorAdd.jsp method=post>
  <input class=inputstyle type=hidden name=indicatorname1>
  <input class=inputstyle type=hidden name=indicatordesc1>
  <input class=inputstyle type=hidden name=indicatortype1>
</form>
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



<Script language=javascript>
function onSave() {
	parastr = "indicatorname,indicatordesc" ;
	if(frmMain.indicatortype.selectedIndex == 2) parastr = parastr + ",indicatoridfirst,indicatoridlast" ;
	if(check_form(frmMain,parastr)) {
		frmMain.submit() ;
	}
	
}

function onChange() {
	changsubmit.indicatorname1.value=frmMain.indicatorname.value;
	changsubmit.indicatordesc1.value=frmMain.indicatordesc.value;
	changsubmit.indicatortype1.value=frmMain.indicatortype.selectedIndex;
	
	changsubmit.submit() ;
}
</script>

<script language=vbs>
sub onShowIndicator(spanname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/FnaIndicatorBrowser.jsp?sqlwhere=where indicatortype !='2'")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputename.value=id(0)
	else
	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	inputename.value=""
	end if
	end if
end sub
</script>

</BODY></HTML>
