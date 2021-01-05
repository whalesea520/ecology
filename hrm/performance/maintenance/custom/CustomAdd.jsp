<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("CheckGradeInfo:Maintenance",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(705,user.getLanguage());

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

<FORM name=resource id=resource action="CustomOperation.jsp" method=post>
<input type=hidden name=inserttype value=basic>
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
          <TR class=spacing" style="height:1px;"> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=20 size=20 
            name=unitName  onchange='checkinput("unitName","nameimage")'>
			<SPAN id=nameimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD> <!--描述-->
              <TD class=Field>
              <input class=inputstyle name=memo maxLength=20 size=20 >
            </TD>
          </TR>
          <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD><!--状态 起用/禁止-->
             <TD class=Field> 
             <input class=inputstyle type="checkbox"  value="0" name="status" >
             <!-- 是否起用-->
            </TD>
            
          </TR>
         
          <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
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
    if(check_form(document.resource,"unitName"))
	{	
		document.resource.submit();
		enablemenu();
	}
}
</script>
</BODY>
</HTML>