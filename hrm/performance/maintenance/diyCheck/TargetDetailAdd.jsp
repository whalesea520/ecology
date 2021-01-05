<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<% if(!HrmUserVarify.checkUserRight("DiyCheck:Maintenance",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18122,user.getLanguage());
String mainid=Util.null2String(request.getParameter("id"));
String parentId=Util.null2String(request.getParameter("parentId"));
String needfav ="1";
String needhelp ="";
String tName="";

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

<FORM name=resource id=resource action="CheckOperation.jsp" method=post>
<input type=hidden name=inserttype value=detail >
<input type=hidden name=mainid  value=<%=mainid%> >
<input type=hidden name=parentId  value=<%=parentId%> >
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
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=2 style="padding:0;"></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=30 size=30 
            name=targetName  onchange='checkinput("targetName","nameimage")'>
			<SPAN id=nameimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN>
			 <button type="button" class=Browser id=SelectFlowID onClick="onShowTargetID()"></BUTTON> 
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
    <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle name=percent_n id=percent_n onchange='checkinput("percent_n","pimage");checknumber("percent_n")' size=4 maxLength=4>
			<SPAN id=pimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN>
			<input type=hidden name=targetIdf>
            </TD>
          </TR>
          
        <TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
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
   
    if(check_form(document.resource,"targetName,percent_n"))
	{	if (parseFloat(document.resource.percent_n.value)>100) 
	     {
	     alert("<%=SystemEnv.getHtmlLabelName(18118,user.getLanguage())%>");
	     return;
	     }
	  document.resource.submit();
	  enablemenu();
	}
}
function onShowTargetID(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/maintenance/diyCheck/TargetBrowser.jsp")
	if(datas){
		if(datas.id){
			$("input[name=targetName]").val(datas.name);
			$("input[name=targetIdf]").val(datas.id);
			$("#nameimage").html("");
		}else{
			$("input[name=targetName]").val("");
			$("input[name=targetIdf]").val("");
			$("#nameimage").html("<IMG src='/images/BacoError.gif' align=absMiddle>");			
		}
	}
}
</script>
</BODY>
</HTML>