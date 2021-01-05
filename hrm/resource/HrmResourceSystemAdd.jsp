<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String id = request.getParameter("id");
boolean hasFF = true;
RecordSet.executeProc("Base_FreeField_Select","hr");
if(RecordSet.getCounts()<=0)
	hasFF = false;
else
	RecordSet.first();

RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String openPasswordLock = settings.getOpenPasswordLock();
String passwordComplexity = settings.getPasswordComplexity();
int minpasslen=settings.getMinPasslen();
    
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
/*登录名冲突*/
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
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
<FORM name=resource id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
	<input type=hidden name=operation value="addresourcesysteminfo">
	<input type=hidden name=id value="<%=id%>">
  <TABLE class=viewForm>
    <COLGROUP> 
    <COL width="49%"> 
    <COL width=10> 
    <COL width="49%"> 
    <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> 
          <COL width=30%> 
          <COL width=70%>
          <TBODY> 
          <TR class=title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:2px"> 
            <TD class=line1 colSpan=2></TD>
          </TR>          
            <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(16126,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputStyle maxLength=20  onchange='checkinput("loginid","loginidimage")' size=15 name=loginid>
              <SPAN id=loginidimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    	  <%
          if("1".equals(openPasswordLock))
          {
          %>
          <TR> 
           <TD><%=SystemEnv.getHtmlLabelName(24706, user.getLanguage())%></TD>
           <TD class=Field>
              <input type="checkbox" name="passwordlock" onclick="setPasswordLock(this);">        
           </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <%
          } 
          %>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=20 
            onchange='checkinput("password","passwordimage")' size=15 name=password type="password">
              <span id=passwordimage><img 
            src="/images/BacoError_wev8.gif" align=absMiddle></span></td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(16127,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=20 onChange='checkinput("confirmpassword","confirmpasswordimage")' 
              size=15 name=confirmpassword type="password">
              <span id=confirmpasswordimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span></td>
          </tr>   
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<%if(isMultilanguageOK){%>		  
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></TD>
            <TD class=Field>

              <INPUT class="wuiBrowser" id=systemlanguage type=hidden name=systemlanguage
			  _url="/systeminfo/language/LanguageBrowser.jsp"
			  _required="yes">
            </TD>
          </TR>  
<%}%>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputStyle  size=2 name=seclevel>
            </TD>
          </TR>
           <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>        
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
 
    </TBODY> 
  </table>
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
<script language=vbs>
sub onShowSystemLanguage()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	systemlanguagespan.innerHtml = id(1)
	resource.systemlanguage.value=id(0)
	else
	systemlanguagespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.systemlanguage.value=""
	end if
	end if
end sub

</script> 

<script language=javascript>
function setPasswordLock(o)
{
	if(o.checked)
	{
		o.value = 1;
	}
	else
	{
		o.value = -1;
	}
}
function CheckPasswordComplexity()
{
	var cs = document.resource.confirmpassword.value;
	//alert(cs);
	var checkpass = true;
	<%
	if("1".equals(passwordComplexity))
	{		
	%>
	var complexity11 = /[a-z]+/;
	var complexity12 = /[A-Z]+/;
	var complexity13 = /\d+/;
	if(cs!="")
	{
		if(complexity11.test(cs)&&complexity12.test(cs)&&complexity13.test(cs))
		{
			checkpass = true;
		}
		else
		{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31863,user.getLanguage())%>");
			checkpass = false;
		}
	}
	<%
	}
	else if("2".equals(passwordComplexity))
	{
	%>
	var complexity21 = /[a-zA-Z_]+/;
	var complexity22 = /\W+/;
	var complexity23 = /\d+/;
	if(cs!="")
	{
		if(complexity21.test(cs)&&complexity22.test(cs)&&complexity23.test(cs))
		{
			checkpass = true;
		}
		else
		{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83716,user.getLanguage())%>");
			checkpass = false;
		}
	}
	<%
	}
	%>
	return checkpass;
}
function doSave() {
  if(document.resource.password.value.length<<%=minpasslen%>){
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20172,user.getLanguage())+minpasslen%>");
  }else if(document.resource.password.value == document.resource.confirmpassword.value ){
    var checkpass = CheckPasswordComplexity();
	if(checkpass)
	{
       document.resource.submit() ;
    }
  }else{
    window.top.Dialog.alert("password error!");
  }
}
</script>
</BODY>
</HTML>