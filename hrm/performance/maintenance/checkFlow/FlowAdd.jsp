<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("CheckFlowInfo:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18043,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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

<FORM name=resource id=resource action="FlowOperation.jsp" method=post>
<input type=hidden name=operationtype value=insert>
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="50%"> 
    <COL width="50%"> 
    <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=70%> <TBODY> 
          <TR class=title> 
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(15058,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
            <TD class=Field> 
              <select class=inputStyle id=type_1 
              name=type_1>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(18102,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(18103,user.getLanguage())%></option>
               
              </select>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18077,user.getLanguage())%></TD> <!--??-->
             <TD class=Field>
             <BUTTON type="button" class=Browser id=SelectFlowID onClick="onShowFlowID()"></BUTTON> 
              <span 
            id=flowidspan><img src="/images/BacoError.gif" 
            align=absMiddle></span> 
              <INPUT class=inputStyle id=relatingFlow 
            type=hidden name=relatingFlow>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
      
          </TBODY> 
        </TABLE>
      </TD>
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
    
	{	if(check_form(document.resource,"relatingFlow"))
	{
		document.resource.submit();
		}
	}
}</SCRIPT>
<SCRIPT language="vbs">

sub onShowFlowID() 
    para=document.resource.type_1.value
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/FlowBrowser.jsp?para="&para)
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	flowidspan.innerHtml = id(1)
	resource.relatingFlow.value=id(0)
	else
	flowidspan.innerHtml = ""
	resource.relatingFlow.value=""
	end if
	end if
end sub
</script>
</BODY>
</HTML>