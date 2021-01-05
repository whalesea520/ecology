
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String message = request.getParameter("message") ;
String imagefilename = "/images/hdSystem_wev8.gif";
// String titlename = SystemEnv.getHtmlLabelName(776,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<DIV class=HdrProps></DIV>
<%
if(message != null){
%>
<DIV>
<font color=red size=2>
<%=message%>
</font>
</DIV>
<%}%>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="CreateDBOperation.jsp">
<div>
<BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></BUTTON> 
<BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(2073,user.getLanguage())%></BUTTON> 
</div>    <br>
   
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(774,user.getLanguage())%></TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(2071,user.getLanguage())%></td>
      <td class=Field> 
        <input accesskey=Z name=dbserver  maxlength="20" >
      </td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></td>
      <td class=Field> 
        <input accesskey=Z name=username  maxlength="20" >
      </td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
      <td class=Field> 
        <input accesskey=Z name=password  maxlength="20" >
      </td>
    </tr>
    </TBODY> 
  </TABLE>
  </FORM>
</BODY>
</HTML>
