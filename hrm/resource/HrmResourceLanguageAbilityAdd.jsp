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
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
String applyid	  =	Util.null2String(request.getParameter("applyid")) ;

if(!HrmUserVarify.checkUserRight("HrmResourceLanguageAbilityAdd:Add",user)&&applyid.equals("")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(815,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
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
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM name=frmain action="HrmResourceLanguageAbilityOperation.jsp?"Action=2 method=post>
 
<input class=inputstyle type="hidden" name="resourceid" value="<%=resourceid%>">
<input class=inputstyle type="hidden" name="applyid" value="<%=applyid%>">
<input class=inputstyle type="hidden" name="operation" value="add">

  <TABLE class=ViewForm>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
  <TR class=Title> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
  </TR>
    <TR class=Title> 
      <TD class=line1 colSpan=2></TD>
    </TR>
	 <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1954,user.getLanguage())%></TD>
	  <TD class=Field> 
              <INPUT class=inputstyle maxLength=30 size=15 name="language"
            onchange='checkinput("language","languageimage")'>
              <SPAN id=languageimage><IMG 
            src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
	<tr> 
            <td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
            <td class=Field> 
              <select class=inputstyle id=level name=level>
                <option value="0" selected><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
                <option value="1" ><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option>
				<option value="2" ><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%></option>
                <option value="3" ><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%></option>
              </select>
            </td>
            </tr>
   <TR><TD class=Line colSpan=2></TD></TR> 
    <TR> 
      <TD valign="top"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
      <TD class=Field> 
        <textarea class=inputstyle style="width:90%" name=memo rows="6"></textarea>
      </TD>
    </TR>
     <TR><TD class=Line colSpan=2></TD></TR> 
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
    if(check_form(document.frmain,"language"))
	{	
		document.frmain.submit();
	}
}
</script>

</BODY></HTML>
