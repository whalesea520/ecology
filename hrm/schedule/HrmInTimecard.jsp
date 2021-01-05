<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit", user)){
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
}
%>

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16259 , user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
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
<FORM id=frmMain name=frmMain action="HrmInTimecardOperation.jsp" method=post enctype="multipart/form-data">
<DIV>
<BUTTON class=btnSave type="button" accessKey=S onClick="dosubmit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></BUTTON>
</DIV>
<br>
  <table class=Viewform>
    <COLGROUP> <COL width="15%"> <COL width="85%"> <tbody> 
    <tr class=Title> 
      <td><nobr><b><%=SystemEnv.getHtmlLabelName(16698,user.getLanguage())%></b></td>
      <td align=right></td>
    </tr>
    <tr class=spacing style="height:2px"> 
      <td class=Line1 colspan=2></td>
    </tr>
    <tr class=spacing> 
      <td colspan=2 height=8></td>
    </tr>
    <tr class=spacing> 
      <td><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></td>
      <td class=Field>
        <input class=inputstyle type="file" name="excelfile">
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    </tbody> 
  </table>  
</form>

  <br>
  <table class=viewform>
    <COLGROUP> <COL width="20%"> <COL width="80%"><tbody> 
    <tr > 
      <td colspan=2><nobr><b><%=SystemEnv.getHtmlLabelName(22271,user.getLanguage())%></b></td>
    </tr>
   <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR> 
   <tr> 
      <td><%=SystemEnv.getHtmlLabelName(83852 ,user.getLanguage())%></td>
      <td><a href='/hrm/schedule/inputexcellfile/input.xls'><%=SystemEnv.getHtmlLabelName(22273 ,user.getLanguage())%></a>&nbsp;</td>
    </tr> 
    <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(83857 ,user.getLanguage())%></td>
      <td>
       <%=SystemEnv.getHtmlLabelName(83859  ,user.getLanguage())%><br><br>
       <%=SystemEnv.getHtmlLabelName(83861  ,user.getLanguage())%><br><br>
       <%=SystemEnv.getHtmlLabelName(83862  ,user.getLanguage())%><br><br>
       <%=SystemEnv.getHtmlLabelName(83863  ,user.getLanguage())%><br><br>
       <%=SystemEnv.getHtmlLabelName(83864  ,user.getLanguage())%><br><br>
       <%=SystemEnv.getHtmlLabelName(83866  ,user.getLanguage())%> 
      </td>
    </tr> 
    <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR> 
    </tbody> 
  </table>
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

<script language=javascript>
function dosubmit() {
    if(check_form(document.frmMain,'excelfile')) {
        document.frmMain.submit() ;
    }
}
</script>
</BODY>
</HTML>