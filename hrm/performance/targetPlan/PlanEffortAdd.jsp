<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ include file="/systeminfo/init.jsp" %>


<jsp:useBean id="resource" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<% 
   //if (!Rights.getRights("","","","")){//х╗очеп╤о
	//response.sendRedirect("/notice/noright.jsp") ;
	//return ;
   //}
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<STYLE>
	.vis1	{ visibility:"visible" }
	.vis2	{ visibility:"hidden" }
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
//GeneratePro.createAll("workPlan");
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18202,user.getLanguage());
String id=Util.null2String(request.getParameter("id"));   
String needfav ="1";
String needhelp ="";
String planDate=Util.null2String(request.getParameter("planDate"));
String type=Util.null2String(request.getParameter("type"));
String from=Util.null2String(request.getParameter("from"));
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

<FORM name=resource id=resource action="PlanOperation.jsp" method=post>
<input type=hidden name=operationType value="EffortAdd" >
<input type=hidden name=id value=<%=id%> >
<input type=hidden name=from value=<%=from%>>
<input type=hidden name=type value=<%=type%> >
<input type=hidden name=planDate value=<%=planDate%> >
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="50%"> 
    <COL width="50%"> 
    <TBODY> 
  
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=70%> <TBODY> 
       
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18201,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=50 size=50 
            name=effortName  onchange='checkinput("effortName","nameimage")'>
			<SPAN id=nameimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=3 size=3 
            name=viewSort  onchange='checknumber("viewSort");checkinput("viewSort","vnameimage")'>
			<SPAN id=vnameimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN>
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
    
    if(check_form(document.resource,"keffortName,viewSort"))
	{	
		document.resource.submit();
		for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++)
		{
		window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
		}
		//window.frames["rightMenuIframe"].window.event.srcElement.disabled=true;
	}
}

</script>
</BODY>
</HTML>