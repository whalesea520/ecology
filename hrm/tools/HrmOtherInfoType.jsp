<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="OtherInfoTypeComInfo" class="weaver.hrm.tools.OtherInfoTypeComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(560,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmOtherInfoTypeAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/tools/HrmOtherInfoTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmOtherInfoType:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+34+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
   <COL width="30%">
    <COL width="70%"> 
  <TBODY>
  <TR class=Header>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(560,user.getLanguage())%></TH></TR>
    <TR class=Header>
   <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan=2 ></TD></TR> 
  <%
  int i=0;
  String typeid="";
  String typename="";
  String typeremark="";
  while(OtherInfoTypeComInfo.next()){
  	typeid=OtherInfoTypeComInfo.getTypeid();
  	typename=OtherInfoTypeComInfo.getTypename();
  	typeremark=OtherInfoTypeComInfo.getTyperemark();
  	%>
  	<tr <%if(i==0){%> class=datalight <%} else {%> class=datadark <%}%>>
  	   <td><a href="HrmOtherInfoTypeEdit.jsp?id=<%=typeid%>"><%=Util.toScreen(typename,user.getLanguage())%></a></td>
  	   <td><%=Util.toScreen(typeremark,user.getLanguage())%></td>
  	</tr>
  	<%
  	if(i==0)   i=1;
  	else i=0;
  }
  %>
  </tbody>
</table>
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
</body>
</html>