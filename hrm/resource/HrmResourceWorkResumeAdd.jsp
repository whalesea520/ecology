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

if((!HrmUserVarify.checkUserRight("HrmResourceWorkResumeAdd:Add",user))&&applyid.equals("")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(812,user.getLanguage());
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
<FORM name=frmain action="HrmResourceWorkResumeOperation.jsp?"Action=2 method=post>
  <DIV><BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON> </DIV>

<input type="hidden" name="resourceid" value="<%=resourceid%>">
<input type="hidden" name="applyid" value="<%=applyid%>">
<input type="hidden" name="operation" value="add">

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
          <td class=Field><button class=Calendar type="button" id=selectstartdate onClick="getstartDate()"></button> 
              <span id=startdatespan ></span> 
              <input type="hidden" name="startdate">
          </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
            <td class=Field><button class=Calendar id=selectenddate onClick="getHendDate()"></button> 
              <span id=enddatespan ></span> 
              <input type="hidden" name="enddate">
            </td>
          </tr>
	<TR> 
      <TD><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
	  <TD class=Field> 
              <INPUT class=Field maxLength=30 size=30 name="jobtitle">
      </TD>
    </TR>
	 <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1975,user.getLanguage())%></td>
      <td class=Field> <BUTTON class=Browser id=SelectCompanyStyle onClick="onShowCompanyStyle()"></BUTTON> 
              <span id=companystylespan></span> 
              <INPUT class=saveHistory type=hidden name=companystyle>
      </TD>
    </tr>

    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></TD>
	  <TD class=Field> 
              <INPUT class=Field maxLength=100 size=30 name="company"
            onchange='checkinput("company","companyimage")'>
              <SPAN id=companyimage><IMG 
            src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
    </TR>
    
   
    <TR> 
      <TD valign="top"><%=SystemEnv.getHtmlLabelName(1977,user.getLanguage())%></TD>
      <TD class=Field> 
        <textarea class="saveHistory"  style="width:90%" name=workdesc rows="6"></textarea>
      </TD>
    </TR>
     <TR> 
      <TD valign="top"><%=SystemEnv.getHtmlLabelName(1978,user.getLanguage())%></TD>
      <TD class=Field> 
        <textarea class="saveHistory" style="width:90%" name=leavereason rows="6"></textarea>
      </TD>
    </TR>
    </TBODY> 
  </TABLE>
</FORM>
<SCRIPT language=VBS>
sub onShowCompanyStyle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
		companystylespan.innerHtml = id(1)
		frmain.companystyle.value=id(0)
		else
		companystylespan.innerHtml = ""
		frmain.companystyle.value= ""
		end if
	end if
end sub


</SCRIPT>

<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.frmain,"company"))
	{	
		document.frmain.submit();
	}
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
